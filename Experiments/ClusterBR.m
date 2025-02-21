function ClusterBR= ClusterBR(CYCLE,path)
%UNTITLED Summary of this function goes here
n1 = 1;
n2 = 1;
N = length(CYCLE);
%&& (mean(-CYCLE{i}.RHEO2) < 500) && (min(-CYCLE{i}.RHEO2)) > -100
for i=1:N

    len = length(CYCLE{i}.BASE1);
    if (CYCLE{i}.BASE1(1) > CYCLE{i}.BASE1(len)) && (CYCLE{i}.BASE1(1) == max(CYCLE{i}.BASE1)) && (CYCLE{i}.BASE1(len) == min(CYCLE{i}.BASE1)) && (min(CYCLE{i}.RHEO2) > -50) && (max(CYCLE{i}.RHEO1) < 300)
        CYCLE_DATA_EXH{n1} = CYCLE{i};
        n1 = n1+1;
    elseif (CYCLE{i}.BASE1(1) < CYCLE{i}.BASE1(len)) && (CYCLE{i}.BASE1(len) == max(CYCLE{i}.BASE1)) && (CYCLE{i}.BASE1(1) == min(CYCLE{i}.BASE1)) && (min(CYCLE{i}.RHEO2) > -50) && (max(CYCLE{i}.RHEO1) < 300)
        CYCLE_DATA_INH{n2} = CYCLE{i};
        n2 = n2+1;
    end

    

end




%Разбиение по видам форм сигналов на вдохе и на выдохе

%На вдохе



%i1 = 1;
thr = 0.99;
inh_ind = 1;
f_inh_ind = 1;
inh_ind_oth = 1;
FORM_INH{f_inh_ind}{inh_ind} = CYCLE_DATA_INH{1};
inh_ind = inh_ind + 1;
for i=1:length(CYCLE_DATA_INH)
    clear data_temp1;
    clear data_temp2;
    if (~isempty(CYCLE_DATA_INH{i}))
    for i1= (i+1):length(CYCLE_DATA_INH)
        if (~isempty(CYCLE_DATA_INH{i1}))
if (length(CYCLE_DATA_INH{i}.RHEO2) > length(CYCLE_DATA_INH{i1}.RHEO2))
    data_temp1 = CYCLE_DATA_INH{i}.RHEO2(1:length(CYCLE_DATA_INH{i1}.RHEO2));
    data_temp2 = CYCLE_DATA_INH{i1}.RHEO2;
else
    data_temp1 = CYCLE_DATA_INH{i}.RHEO2;
    data_temp2 = CYCLE_DATA_INH{i1}.RHEO2(1:length(CYCLE_DATA_INH{i}.RHEO2));
end
    corr_val = max(xcorr (data_temp1, data_temp2,'normalized'));
    if corr_val > thr % Если второй сигнал похож на первый
        
        FORM_INH{f_inh_ind}{inh_ind} = CYCLE_DATA_INH{i1};
        CYCLE_DATA_INH{i1} = {};
        inh_ind = inh_ind + 1;
        
    else %Если не похож
        
        inh_ind_oth = 1;
       % f_inh_ind = f_inh_ind+1;
        FORM_INH{f_inh_ind+1}{inh_ind_oth} = CYCLE_DATA_INH{i1};
        inh_ind_oth = inh_ind_oth + 1;
        %inh_ind = inh_ind + 1;
        %CYCLE_DATA_INH{i1} = [];
        
    end

        end
    end

    f_inh_ind = f_inh_ind+1;
    inh_ind = inh_ind_oth;
    end



end


% На выдохе


exh_ind = 1;
f_exh_ind = 1;
exh_ind_oth = 1;
FORM_EXH{f_exh_ind}{exh_ind} = CYCLE_DATA_EXH{1};
exh_ind = exh_ind + 1;
for i=1:length(CYCLE_DATA_EXH)
    clear data_temp1;
    clear data_temp2;
    if (~isempty(CYCLE_DATA_EXH{i}))
    for i1= (i+1):length(CYCLE_DATA_EXH)
        if (~isempty(CYCLE_DATA_EXH{i1}))
if (length(CYCLE_DATA_EXH{i}.RHEO2) > length(CYCLE_DATA_EXH{i1}.RHEO2))
    data_temp1 = CYCLE_DATA_EXH{i}.RHEO2(1:length(CYCLE_DATA_EXH{i1}.RHEO2));
    data_temp2 = CYCLE_DATA_EXH{i1}.RHEO2;
else
    data_temp1 = CYCLE_DATA_EXH{i}.RHEO2;
    data_temp2 = CYCLE_DATA_EXH{i1}.RHEO2(1:length(CYCLE_DATA_EXH{i}.RHEO2));
end
    corr_val = max(xcorr (data_temp1, data_temp2,'normalized'));
    if corr_val > thr % Если второй сигнал похож на первый
        
        FORM_EXH{f_exh_ind}{exh_ind} = CYCLE_DATA_EXH{i1};
        CYCLE_DATA_EXH{i1} = {};
        exh_ind = exh_ind + 1;
        
    else %Если не похож
        
        exh_ind_oth = 1;
       % f_inh_ind = f_inh_ind+1;
        FORM_EXH{f_exh_ind+1}{exh_ind_oth} = CYCLE_DATA_EXH{i1};
        exh_ind_oth = exh_ind_oth + 1;
        %inh_ind = inh_ind + 1;
        %CYCLE_DATA_INH{i1} = [];
        
    end

        end
    end

    f_exh_ind = f_exh_ind+1;
    exh_ind = exh_ind_oth;
    end



end



[status] = mkdir(path);

if status == 1
    save(strcat(path,'CYCLE_DATA_INH.mat'), "CYCLE_DATA_INH");
    save(strcat(path,'CYCLE_DATA_EXH.mat'), "CYCLE_DATA_EXH");
    save(strcat(path,'FORM_INH.mat'), "FORM_INH");
    save(strcat(path,'FORM_EXH.mat'), "FORM_EXH");
    %save(strcat(path,'CYCLE_DATA_OTH.mat'), "CYCLE_DATA_OTH");
end

end