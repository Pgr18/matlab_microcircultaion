function [Flux_Index] = filtering(DATA)

fs = 200; %Частота дискретизации РКМ в Гц
f_endo = [0.005 0.01999]; % Частоты эндотелиальных колебаний
f_neuro = [0.02 0.049999]; % Частоты нейрогенных колебаний
f_mio = [0.05 0.1499999]; % Частоты миогенных колебаний
f_breath = [0.15 0.39999999]; % Частоты дыхания
f_cardio = [0.4 2.0]; % Частоты сердечной активности

A_Endo = bandpass(DATA, f_endo, fs);
A_neuro = bandpass(DATA, f_neuro, fs);
A_mio = bandpass(DATA, f_mio, fs);
A_breath = bandpass(DATA, f_breath, fs);
A_cardio = bandpass(DATA, f_cardio, fs);

Flux_Index = mean(((abs(A_Endo)+abs(A_neuro)+abs(A_mio))/(abs(A_breath)+abs(A_cardio)))*100,"all");

end