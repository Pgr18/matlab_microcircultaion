function PARAM = dataproc(DATA1,path)

PARAM = table;
n = 0;
for k=1:length(DATA1)

    CYCLE{k}.NAME = DATA1{k}.NAME;
    CYCLE{k}.TIME = DATA1{k}.TIME;
    CYCLE{k}.RHEO1 = -DATA1{k}.RHEO1;
    %CYCLE{k}.BASE1 = mean(DATA{k}.BASE1);
    CYCLE{k}.BASE1 = DATA1{k}.BASE1;
    CYCLE{k}.QS1 = mean(DATA1{k}.QS1);
    CYCLE{k}.ECG = DATA1{k}.ECG;
    CYCLE{k}.RHEO2 = -DATA1{k}.RHEO2;
    %CYCLE{k}.BASE2 = mean(DATA{k}.BASE2);
    CYCLE{k}.BASE2 = DATA1{k}.BASE2;
    CYCLE{k}.QS2 = mean(DATA1{k}.QS2);
    
    CYCLE{k}.dRHEO1(1) = 0;
    CYCLE{k}.dRHEO2(1) = 0;
    for i=2:length(DATA1{k}.TIME)
       CYCLE{k}.dRHEO1(i) = CYCLE{k}.RHEO1(i) - CYCLE{k}.RHEO1(i-1);
       CYCLE{k}.dRHEO2(i) = CYCLE{k}.RHEO2(i) - CYCLE{k}.RHEO2(i-1);
    end
    CYCLE{k}.dRHEO1 = medfilt1(CYCLE{k}.dRHEO1,10);
    CYCLE{k}.dRHEO2 = medfilt1(CYCLE{k}.dRHEO2,10);

    %Расчет параметров
    [~,CYCLE{k}.RHEO1_MAX_I] = max(CYCLE{k}.RHEO1);
    [~,CYCLE{k}.RHEO2_MAX_I] = max(CYCLE{k}.RHEO2);
    [~,CYCLE{k}.RHEO1_MIN_I] = min(CYCLE{k}.RHEO1);
    [~,CYCLE{k}.RHEO2_MIN_I] = min(CYCLE{k}.RHEO2);    
    [~,CYCLE{k}.dRHEO1_MAX_I] = max(CYCLE{k}.dRHEO1);
    [~,CYCLE{k}.dRHEO2_MAX_I] = max(CYCLE{k}.dRHEO2);
    

    %Блок условий адекватности анализа
    key = 1;

    %Минимум расположен левее максимума
    if or((CYCLE{k}.RHEO1_MAX_I <= CYCLE{k}.RHEO1_MIN_I),(CYCLE{k}.RHEO2_MAX_I <= CYCLE{k}.RHEO2_MIN_I))
       key = 0;
    end
    %Максимум R2 расположен правее максимума R1
    if (CYCLE{k}.RHEO1_MAX_I > CYCLE{k}.RHEO2_MAX_I)
       key = 0;
    end
    
    key = 1; %Отменяет предыдущий код условий
    if (key > 0)
       n = n+1;

       %номер цикла
       PARAM.I(n) = k;

       %время цикла
       PARAM.NAME(n) = CYCLE{k}.NAME;

       %длительность цикла
       PARAM.RR(n) = CYCLE{k}.TIME(length(DATA1{k}.TIME));

       %время подъема восходящей части
       PARAM.alpha1(n) = CYCLE{k}.TIME(CYCLE{k}.RHEO1_MAX_I);
       PARAM.alpha2(n) = CYCLE{k}.TIME(CYCLE{k}.RHEO2_MAX_I);

       %время спуска нисходящей части
       PARAM.beta1(n) = CYCLE{k}.TIME(length(DATA1{k}.TIME)) - CYCLE{k}.TIME(CYCLE{k}.RHEO1_MAX_I);
       PARAM.beta2(n) = CYCLE{k}.TIME(length(DATA1{k}.TIME)) - CYCLE{k}.TIME(CYCLE{k}.RHEO2_MAX_I);

       %время быстрого кровенаполнения
       PARAM.f1(n) = CYCLE{k}.TIME(CYCLE{k}.dRHEO1_MAX_I);
       PARAM.f2(n) = CYCLE{k}.TIME(CYCLE{k}.dRHEO2_MAX_I);

       %основная амплитуда реограммы
       PARAM.dR1(n) = CYCLE{k}.RHEO1(CYCLE{k}.RHEO1_MAX_I)- CYCLE{k}.RHEO1(CYCLE{k}.RHEO1_MIN_I); % - CYCLE{k}.RHEO1(CYCLE{k}.RHEO1_MIN_I);
       PARAM.dR2(n) = CYCLE{k}.RHEO2(CYCLE{k}.RHEO2_MAX_I)- CYCLE{k}.RHEO2(CYCLE{k}.RHEO2_MIN_I); % - CYCLE{k}.RHEO2(CYCLE{k}.RHEO2_MIN_I);

       %амплитуда быстрого кровенаполнения
       PARAM.a1(n) = CYCLE{k}.RHEO1(CYCLE{k}.dRHEO1_MAX_I);
       PARAM.a2(n) = CYCLE{k}.RHEO2(CYCLE{k}.dRHEO2_MAX_I);

       %амплитуда дикротической волны и инцизура
       [PARAM.e1(n), PARAM.d1(n)] = peaksfind(CYCLE{k}.RHEO1);
       [PARAM.e2(n), PARAM.d2(n)] = peaksfind(CYCLE{k}.RHEO2);

       %амплитуда дифференциальной реограммы
       PARAM.ad1(n) = CYCLE{k}.dRHEO1(CYCLE{k}.dRHEO1_MAX_I) - CYCLE{k}.dRHEO1(1);
       PARAM.ad2(n) = CYCLE{k}.dRHEO2(CYCLE{k}.dRHEO2_MAX_I) - CYCLE{k}.dRHEO2(1);

       %амплитуда базового импеданса
       PARAM.BASE1(n) = mean(CYCLE{k}.BASE1);
       PARAM.BASE2(n) = mean(CYCLE{k}.BASE2);     
  
       %отношение основной амплитуды реограммы к базовому импедансу
       PARAM.dR1r(n) = PARAM.dR1(n)/mean(CYCLE{k}.BASE1);
       PARAM.dR2r(n) = PARAM.dR2(n)/mean(CYCLE{k}.BASE2);
        
       % Кровенаполнение кожно-жирового слоя
       %PARAM.dV(n) = dvolume(PARAM.dR1(n));

       %Индекс флаксомоций
       %PARAM.flux(n) = filtering(CYCLE{k}.RHEO1);
       
 
    end

end

[status] = mkdir(path);

if status == 1
    save(strcat(path,'CYCLE.mat'), "CYCLE");
    save(strcat(path,'PARAM.mat'), "PARAM");
end

end