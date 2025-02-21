function [minpeak1, maxpeak2] = peaksfind(DATA)

minpeak1 = NaN; 
maxpeak2 = NaN; 

% Поиск максимальных пиков
[~, locsMax] = findpeaks(DATA(70:end), 'MinPeakHeight', 15, 'MinPeakDistance', 3);
if length(locsMax) >= 1  
    second_peak_location = locsMax(1) + 69; % Корректируем индекс
    maxpeak2 = DATA(second_peak_location); % Установка maxpeak2
end

% Поиск минимальных пиков
[~, locsMin] = findpeaks(-DATA(70:end), 'MinPeakHeight', -180, 'MinPeakDistance', 3);
if length(locsMin) >= 1  
    first_peak_location = locsMin(1) + 69; % Корректируем индекс
    minpeak1 = DATA(first_peak_location); % Установка minpeak1
end

end