function T = importtt(path,NAME)

try
    T = readtable(path);
    
    if isdatetime(T.TIME)
        T.DATE = T.TIME;
    else
        for i=1:height(T)
        H = floor(T.TIME(i)*24);
        M = floor(T.TIME(i)*24*60 - H*60);
        S = floor(T.TIME(i)*24*60*60 - H*60*60 - M*60);
        t(i) = datetime(str2num(NAME(1:4)),str2num(NAME(6:7)),str2num(NAME(9:10)),H,M,S);
        end
        T.DATE = t.';
    end

catch 
    T = 0;
end

end