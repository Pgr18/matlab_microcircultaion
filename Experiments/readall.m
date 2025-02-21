function DATA = readall(pathin,pathout,type)

listing = dir(pathin);
N=0;
for i=1:length(listing)
    if contains(listing(i).name,'.csv')
        N=N+1;
        t(N) = datetime(str2num(listing(i).name(1:4)), ...
            str2num(listing(i).name(6:7)), ...
            str2num(listing(i).name(9:10)), ...
            str2num(listing(i).name(12:13)), ...
            str2num(listing(i).name(15:16)), ...
            str2num(listing(i).name(18:19)), ...
            str2num(listing(i).name(21:23)));
       
        switch type
            case 1
                INPUT{N} = importfile_new(strcat(pathin,listing(i).name)); %Сингапурский РКМ
            case 2
                INPUT{N} = importfile(strcat(pathin,listing(i).name)); %Старый РКМ
            otherwise
                INPUT{N} = importfile(strcat(pathin,listing(i).name)); %Старый РКМ
        end
    end
end

N = 0;
M=0;
for i=1:length(INPUT)
   % M = M+1;

    for j=1:height(INPUT{i})
        N = N+1;
        DATE(N) = t(i)+seconds(INPUT{i}.TIME(j));  
        TIME(N) = INPUT{i}.TIME(j);
        RHEO1(N) = INPUT{i}.RHEO1(j);
        BASE1(N) = INPUT{i}.BASE1(j);
        QS1(N) = INPUT{i}.QS1(j);
        ECG(N) = INPUT{i}.ECG(j);
        RHEO2(N) = INPUT{i}.RHEO2(j);
        BASE2(N) = INPUT{i}.BASE2(j);
        QS2(N) = INPUT{i}.QS2(j);
        MEAN_b1(N) = mean(INPUT{i}.BASE1);
        MEAN_b2(N) = mean(INPUT{i}.BASE2);

    end

end






varNames = {'DATE','TIME','ECG','RHEO1','BASE1','QS1','RHEO2','BASE2','QS2','MEAN_b1','MEAN_b2'};
DATA = table(DATE.',TIME.',ECG.',RHEO1.',BASE1.',QS1.',RHEO2.',BASE2.',QS2.',MEAN_b1.',MEAN_b2.', ...
    'VariableNames',varNames);



[status, msg, msgID] = mkdir(pathout);

if status == 1
    save(strcat(pathout,'DATA.mat'), "DATA");
end

end