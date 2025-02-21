function [dataout, TTout] = databt(data,TT,BT)

toDelete = data.DATE < data.DATE(1);
for i=1:height(BT)
    toDelete = toDelete | (data.DATE >= BT.DATEs(i) & data.DATE <= BT.DATEe(i));
end
data(toDelete,:) = [];

toDeleteTT = false(height(TT),1);
for i=1:height(TT)
    if TT.DATE(i) <= min(data.DATE) 
        toDeleteTT(i) = 1;
    elseif TT.DATE(i) >= max(data.DATE) 
        toDeleteTT(i) = 1;
    end
end
TT(toDeleteTT,:) = [];

dataout = data;
TTout = TT;

end
