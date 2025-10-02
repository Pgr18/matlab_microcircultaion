function res = corr_filt(NAME,i_ref)
load(strcat('OUT/',NAME,'/CYCLE_DATA.mat'));
base_signal = CYCLE_DATA{i_ref}.RHEO1;
base_time = CYCLE_DATA{i_ref}.TIME;
for i=1:length(CYCLE_DATA)
compare_signal = resample(CYCLE_DATA{i}.RHEO1,length(base_signal),length(CYCLE_DATA{i}.RHEO1));
answ(i) = corr(base_signal,compare_signal);
end
res = mean(answ);
indices_to_delete = find(answ<mean(answ));
indicesToDelete = sort(indices_to_delete, 'descend');
CYCLE_DATA(transpose(indicesToDelete))=[];
end