function CYCLE_DATA = dataproccycle(DATA,path,type)

HR_min = 50; %Минимальное значение ЧСС
HR_max = 100; %Максимальное значение ЧСС
QRS_min = 0.1; %Минимальное значение QRS, мВ
min_pos = 0.25; %Максимальное временное отклонение начала QRS от максимума производной

Fd = 1/(DATA.TIME(2) - DATA.TIME(1));

switch type
    case 'ECGP'
        SIGNAL = DATA.ECG;
    case 'ECGN'
        SIGNAL = -DATA.ECG;
    case 'REO1'
        dRHEO(1) = 0;
        for i=2:length(DATA.RHEO1)
           dRHEO(i) = DATA.RHEO1(i-1) - DATA.RHEO1(i);
        end
        SIGNAL = medfilt1(dRHEO,10);
        SIGNAL = highpass(SIGNAL,HR_min/60,Fd);
        SIGNAL_REO = highpass(-DATA.RHEO1,HR_min/60,Fd);
    case 'REO2'
        dRHEO(1) = 0;
        for i=2:length(DATA.RHEO2)
           dRHEO(i) = DATA.RHEO2(i-1) - DATA.RHEO2(i);
        end
        SIGNAL = medfilt1(dRHEO,10);
        SIGNAL = highpass(SIGNAL,HR_min/60,Fd);
        SIGNAL_REO = highpass(-DATA.RHEO2,HR_min/60,Fd);
    otherwise
        SIGNAL = DATA.ECG;
end

gr = 0;

[qrs_amp_raw,qrs_i_raw] = pan_tompkin(SIGNAL,Fd,gr);

if (type == "REO1") || (type == "REO2")
    n = 0;
    for k=1:length(qrs_i_raw)-1
        start_i = round(qrs_i_raw(k+1) - (qrs_i_raw(k+1) - qrs_i_raw(k)) * min_pos);
        [~,min_locs] = findpeaks(-SIGNAL(start_i:qrs_i_raw(k+1)));
        if length(min_locs) > 0
            [~,I] = min(SIGNAL(min_locs+start_i));

            if (qrs_i_raw(k+1) - (min_locs(I)+start_i)) > 2
                [~,min_locs_REO] = findpeaks(-SIGNAL_REO(min_locs(I)+start_i:qrs_i_raw(k+1)));
                if length(min_locs_REO) > 0
                    n = n+1;
                    cycle_i(n) = min_locs_REO(length(min_locs_REO))+min_locs(I)+start_i;
                end
            end
        end
    end

    n = 0;
    for k=1:length(cycle_i)-1
       key = 1;
       if (cycle_i(k+1)-(cycle_i(k))) > Fd*60/HR_min
           key = 0;
       end
       if (cycle_i(k+1)-(cycle_i(k))) < Fd*60/HR_max
           key = 0;
       end
       if (key > 0)
           n = n+1;

           time = zeros(length(cycle_i(k):cycle_i(k+1)),1);
           for i=1:length(cycle_i(k):cycle_i(k+1))
               time(i) = (i-1)/Fd;
           end

           CYCLE_DATA{n}.NAME = DATA.DATE(cycle_i(k));
           CYCLE_DATA{n}.TIME = time;   
           CYCLE_DATA{n}.RHEO1 = DATA.RHEO1(cycle_i(k):cycle_i(k+1));
           CYCLE_DATA{n}.BASE1 = DATA.BASE1(cycle_i(k):cycle_i(k+1));
           CYCLE_DATA{n}.QS1 = DATA.BASE1(cycle_i(k):cycle_i(k+1));
           CYCLE_DATA{n}.ECG = DATA.ECG(cycle_i(k):cycle_i(k+1));
           CYCLE_DATA{n}.RHEO2 = DATA.RHEO2(cycle_i(k):cycle_i(k+1));
           CYCLE_DATA{n}.BASE2 = DATA.BASE2(cycle_i(k):cycle_i(k+1));
           CYCLE_DATA{n}.QS2 = DATA.BASE2(cycle_i(k):cycle_i(k+1));
       end
    end
else
    n = 0;
    if (qrs_i_raw > 1)
       for k=1:length(qrs_i_raw)-1
           key = 1;
    
           if (qrs_i_raw(k+1)-(qrs_i_raw(k))) > Fd*60/HR_min
               key = 0;
           end
           if (qrs_i_raw(k+1)-(qrs_i_raw(k))) < Fd*60/HR_max
               key = 0;
           end
           if abs(qrs_amp_raw(k)) < QRS_min
               key = 0;
           end

           if abs(max(SIGNAL(qrs_i_raw(k):qrs_i_raw(k+1))) -...
               min(SIGNAL(qrs_i_raw(k):qrs_i_raw(k+1)))) < QRS_min
               key = 0;
           end
    
           if (key > 0)
               n = n+1;
    
               time = zeros(length(qrs_i_raw(k):qrs_i_raw(k+1)),1);
               for i=1:length(qrs_i_raw(k):qrs_i_raw(k+1))
                   time(i) = (i-1)/Fd;
               end
    
               CYCLE_DATA{n}.NAME = DATA.DATE(qrs_i_raw(k));
               CYCLE_DATA{n}.TIME = time;
               CYCLE_DATA{n}.QRS = abs(qrs_amp_raw(k));      
               CYCLE_DATA{n}.RHEO1 = DATA.RHEO1(qrs_i_raw(k):qrs_i_raw(k+1));
               CYCLE_DATA{n}.BASE1 = DATA.BASE1(qrs_i_raw(k):qrs_i_raw(k+1));
               CYCLE_DATA{n}.QS1 = DATA.BASE1(qrs_i_raw(k):qrs_i_raw(k+1));
               CYCLE_DATA{n}.ECG = DATA.ECG(qrs_i_raw(k):qrs_i_raw(k+1));
               CYCLE_DATA{n}.RHEO2 = DATA.RHEO2(qrs_i_raw(k):qrs_i_raw(k+1));
               CYCLE_DATA{n}.BASE2 = DATA.BASE2(qrs_i_raw(k):qrs_i_raw(k+1));
               CYCLE_DATA{n}.QS2 = DATA.BASE2(qrs_i_raw(k):qrs_i_raw(k+1));
           end
       end
    end
end

[status] = mkdir(path);

if status == 1
    save(strcat(path,'CYCLE_DATA.mat'), "CYCLE_DATA");
end

end