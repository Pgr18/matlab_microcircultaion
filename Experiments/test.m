i1 = 1;
i2 = 3;
if (length(CYCLE_DATA_INH{i1}.RHEO2) > length(CYCLE_DATA_INH{i2}.RHEO2))
    data_temp1 = CYCLE_DATA_INH{i2}.RHEO2;
    data_temp2 = CYCLE_DATA_INH{i1}.RHEO2(1:length(CYCLE_DATA_INH{i2}.RHEO2));
else
    data_temp1 = CYCLE_DATA_INH{i1}.RHEO2;
    data_temp2 = CYCLE_DATA_INH{i2}.RHEO2(1:length(CYCLE_DATA_INH{i1}.RHEO2));
end
max(xcorr(data_temp1,data_temp2,'normalized'));
plot(-CYCLE_DATA_INH{i1}.RHEO1);