%тестирование корреляционного анализа чисто по RHEO1
clear all
NAME = '2025-04-18';
TT = importtt(strcat('DATA/',NAME,'/TIMETABLE.xlsx'),NAME);
load(strcat('OUT/',NAME,'/CYCLE_DATA.mat'));
load(strcat('OUT/',NAME,'/DATA_LDF.mat'));
%Чтение файла битых данных
BT = importbt(strcat('DATA/',NAME,'/BROKENDATA.xlsx'),NAME);
%BT = 0;
targetTime = datetime('2025-04-11 08:26:25');
timestamps = cellfun(@(x) x.NAME, CYCLE_DATA);
timeDiffs = abs(timestamps - targetTime);

% Find index of minimum difference
[~, closestIdx] = min(timeDiffs);



base_signal = CYCLE_DATA{closestIdx}.RHEO1;%2240 for 2025-08-14,60 for 2025-05-29
base_time = CYCLE_DATA{closestIdx}.TIME;
for i=1:length(CYCLE_DATA)

compare_signal = resample(CYCLE_DATA{i}.RHEO1,length(base_signal),length(CYCLE_DATA{i}.RHEO1));
answ(i) = corr(base_signal,compare_signal);
end
plot(answ)
indices_to_delete = find(answ<mean(answ));
indicesToDelete = sort(indices_to_delete, 'descend');
CYCLE_DATA(transpose(indicesToDelete))=[];

TT_CL = TT;
CYCLE_BR = breathproc(CYCLE_DATA,strcat('PLOTS/',NAME,'/'),'BREATHE');
LDF_fl = 1;
%Обработка данных, разбиение на циклы и их визуализация
dataproc(CYCLE_BR,strcat('OUT/',NAME,'/'));

%Чтение данных циклов и параметров из папки
load(strcat('OUT/',NAME,'/CYCLE.mat'));
load(strcat('OUT/',NAME,'/PARAM.mat'));

%Визуализация данных всех циклов
cycleall(CYCLE_BR,DATA_LDF,strcat('PLOTS/',NAME,'/'),'DATA_CYCLES_BR',TT_CL,LDF_fl);
[status] = mkdir(strcat('OUT/',NAME,'/'));

if status == 1
    save(strcat(strcat('OUT/',NAME,'/'),'CYCLE_DATA.mat'), "CYCLE_DATA");
end
