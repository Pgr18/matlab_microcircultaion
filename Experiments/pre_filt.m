function Data_return = pre_filt(Data)
nonNanCount = sum(~cellfun(@(x) any(isempty(x)), Data));
corrs = zeros(1,nonNanCount);
for i=1:nonNanCount-1
    compare_signal = resample(Data{i+1}.RHEO2,length(Data{i}.RHEO2),length(Data{i+1}.RHEO2));
    corrs(i) = corr(Data{i}.RHEO2,compare_signal);
end
indices_to_delete = find(corrs<median(corrs));
indicesToDelete = sort(indices_to_delete, 'descend');
Data(transpose(indicesToDelete))=[];
Data_return = Data;
end