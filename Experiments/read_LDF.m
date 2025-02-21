function DATA = read_LDF(pathin_ldf,pathout,type)

%Для ЛДФ
listing = dir(pathin_ldf);
N=0;
for i=1:length(listing)
    if contains(listing(i).name,'.txt')
        N=N+1; 
        INPUT{N} = importfile_ldf(strcat(pathin_ldf,listing(i).name));
    end
end

N = 0;
M=0;
for i=1:length(INPUT)
   % M = M+1;

    for j=1:height(INPUT{i})
        N = N+1;
        DATE_LDF(N) = datetime(INPUT{i}.Date(1)+" "+INPUT{i}.Start_time(1))+seconds(INPUT{i}.Time(j));  
        TIME_LDF(N) = INPUT{i}.Time(j);
        MC(N) = INPUT{i}.MC(j)/10;


    end

end

%Конец для ЛДФ

varNames_LDF = {'MC','DATE_LDF','TIME_LDF'};
DATA_LDF = table(MC.',DATE_LDF.',TIME_LDF.', ...
    'VariableNames',varNames_LDF);


[status, msg, msgID] = mkdir(pathout);

if status == 1
    save(strcat(pathout,'DATA_LDF.mat'),"DATA_LDF");
end

end