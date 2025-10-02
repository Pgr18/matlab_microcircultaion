%cycleall(CYCLE_BR,strcat('PLOTS/',NAME,'/'),'DATA_CYCLES_BR',TT_CL);

clear all
close all

NAME = '2025-04-18'; %Название папки с данными
NEW = 0; %Обновить данные из текстовых: 0-нет, 1-МГТУ, 2-РНЦХ
CYCLE_KEY = 1; %Обновить данные циклов
CYCLE_FIND = 'REO1'; %Алгоритм определения циклов по ECGP, ECGN, REO1, REO2
LDF_fl = 1;% Флаг наличия ЛДФ-сигналов
ecg_filt_thr = 0.3;
filt_fl = 1; %0 - без двойной фильтрации, 1 - с ней
%Чтение файла расписания процедуры
TT = importtt(strcat('DATA/',NAME,'/TIMETABLE.xlsx'),NAME);

%Чтение файла параметров процедуры
%OD = importtt(strcat('DATA/',NAME,'/OPERDATA.xlsx'),NAME);

%Чтение файлов из папки и сохранение объединенного файла
if NEW ~= 0
    readall(strcat('DATA/',NAME,'/'),strcat('OUT/',NAME,'/'),NEW);
    if LDF_fl == 1
        read_LDF(strcat('DATA/',NAME,'/Лазма/'),strcat('OUT/',NAME,'/'),NEW);
    end
end

%Чтение объединенных данных из папки
load(strcat('OUT/',NAME,'/DATA.mat'));
if LDF_fl == 1
load(strcat('OUT/',NAME,'/DATA_LDF.mat'));
end

%Визуализация объединенных данных
if LDF_fl == 0
    DATA_LDF = 0;
end
%TT = 0;
plotall(DATA,DATA_LDF,strcat('PLOTS/',NAME,'/'),'DATA_RAW',TT,LDF_fl);
%Визуализация вейвлет-анализа данных
%plotwv(DATA,strcat('PLOTS/',NAME,'/'),'DATA_RAW_WV',TT);

%Чтение файла битых данных
BT = importbt(strcat('DATA/',NAME,'/BROKENDATA.xlsx'),NAME);
%BT = 0;
if istable(BT)
    %Удаление битых данных, если они есть
    [DATA_CL, TT_CL] = databt(DATA,TT,BT);
    DATA_CL = DATA_CL(abs(DATA_CL.ECG)<ecg_filt_thr,:);
    DATA_CL = DATA_CL(abs(DATA_CL.RHEO2)<200,:);
    DATA_CL = DATA_CL(abs(DATA_CL.RHEO1)<200,:);
    %эксперимент - ФНЧ
    %DATA_CL.RHEO1 = lowpass(DATA_CL.RHEO1,50,200);
    if (NAME == '2025-08-28')
        DATA_CL.BASE2(DATA_CL.BASE2<20) = 3*DATA_CL.BASE2(DATA_CL.BASE2<20);
    end
    %DATA_CL.RHEO2 = lowpass(DATA_CL.RHEO2,50,200);
    %Визуализация данных без битых, если они есть
    plotall(DATA_CL,DATA_LDF,strcat('PLOTS/',NAME,'/'),'DATA_CL',TT_CL,LDF_fl);

    %Визуализация вейвлет-анализа данных
    %plotwv(DATA_CL,strcat('PLOTS/',NAME,'/'),'DATA_CL_WV',TT_CL);
else
    DATA_CL = DATA;
    DATA_CL = DATA_CL(abs(DATA_CL.ECG)<ecg_filt_thr,:);
    DATA_CL = DATA_CL(abs(DATA_CL.RHEO2)<200,:);
    DATA_CL = DATA_CL(abs(DATA_CL.RHEO1)<200,:);
    TT_CL = TT;
    plotall(DATA_CL,DATA_LDF,strcat('PLOTS/',NAME,'/'),'DATA_CL',TT_CL,LDF_fl);
end

%Разбиение данных на циклы и их сохранение
if CYCLE_KEY ~= 0
    dataproccycle(DATA_CL,strcat('OUT/',NAME,'/'),CYCLE_FIND,filt_fl);
    CYCLE_FIND = 'ECGN';
    filt_fl = 0;
    dataproccycle(DATA_CL,strcat('OUT/',NAME,'/'),CYCLE_FIND,filt_fl);
end

%Чтение данных циклов из папки
load(strcat('OUT/',NAME,'/CYCLE_DATA.mat'));

%Визуализация данных всех циклов
%cycleall(CYCLE_DATA,strcat('PLOTS/',NAME,'/'),'DATA_CYCLES',TT_CL);

%Разбиение циклов на вдох и выдох

%ClusterBR(CYCLE_BR,strcat('OUT/',NAME,'/'));
%Построение всех циклов для вдоха на одном графике
%load(strcat('OUT/',NAME,'/FORM_INH.mat'));
%monoplot(FORM_INH,strcat('PLOTS/',NAME,'/CYCLES_FORM/'),'Inhale');

%Построение по одному графику на каждую форму сигнала

%monoplot1(FORM_INH,strcat('PLOTS/',NAME,'/CYCLES_FORM/Pres/'),'Inhale_pres');


%Построение всех циклов для выдоха на одном графике
%load(strcat('OUT/',NAME,'/FORM_EXH.mat'));
%monoplot(FORM_EXH,strcat('PLOTS/',NAME,'/CYCLES_FORM/'),'Exhale');
%monoplot1(FORM_INH,FORM_EXH,strcat('PLOTS/',NAME,'/CYCLES_FORM/Pres/'),'pres');
%Удаление кривой дыхания в сигнале импеданса и сохранение данных
CYCLE_BR = breathproc(CYCLE_DATA,strcat('PLOTS/',NAME,'/'),'BREATHE');

%Обработка данных, разбиение на циклы и их визуализация
dataproc(CYCLE_BR,strcat('OUT/',NAME,'/'));

%Чтение данных циклов и параметров из папки
load(strcat('OUT/',NAME,'/CYCLE.mat'));
load(strcat('OUT/',NAME,'/PARAM.mat'));

%Визуализация данных всех циклов
cycleall(CYCLE_BR,DATA_LDF,strcat('PLOTS/',NAME,'/'),'DATA_CYCLES_BR',TT_CL,LDF_fl);

%Визуализация параметров всех циклов
%param_plot_REO_Time(PARAM,strcat('PLOTS/',NAME,'/'),'PARAM_Time',TT_CL);
param_plot_REO_Amp(PARAM,strcat('PLOTS/',NAME,'/'),'PARAM_Amp',TT_CL);
%param_plot_REO(PARAM,strcat('PLOTS/',NAME,'/'),'PARAM_Reo',TT_CL);

OD = 0;
if istable(OD)
    %Визуализация параметров всех циклов
    PD = param_plot_od(PARAM,strcat('PLOTS/',NAME,'/'),'PARAM_OD',TT,OD);
    param_plot(PARAM,strcat('PLOTS/',NAME,'/'),'PARAM',TT_CL,PD);
end
 
%Разбиение данных на циклы и их сохранение
if CYCLE_KEY ~= 0
    try
        rmdir(strcat('PLOTS/',NAME,'/CYCLES/'),'s');
    catch
    end
    %Визуализация данных циклов
    for i=1:height(PARAM)        
        cycle_plot(CYCLE{PARAM.I(i)},PARAM(i,:),strcat('PLOTS/',NAME,'/CYCLES/'));
    end
end