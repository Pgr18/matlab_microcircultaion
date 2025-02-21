function T = importbt(path,NAME)

try
    T = readtable(path);
    for i=1:height(T)
        Hs = floor(T.START(i)*24);
        Ms = floor(T.START(i)*24*60 - Hs*60);
        Ss = floor(T.START(i)*24*60*60 - Hs*60*60 - Ms*60);
        ts(i) = datetime(str2num(NAME(1:4)),str2num(NAME(6:7)),str2num(NAME(9:10)),Hs,Ms,Ss);
    
        He = floor(T.END(i)*24);
        Me = floor(T.END(i)*24*60 - He*60);
        Se = floor(T.END(i)*24*60*60 - He*60*60 - Me*60);
        te(i) = datetime(str2num(NAME(1:4)),str2num(NAME(6:7)),str2num(NAME(9:10)),He,Me,Se);
    
    end
    T.DATEs = ts.';
    T.DATEe = te.';

catch 
    T = 0;
end

end