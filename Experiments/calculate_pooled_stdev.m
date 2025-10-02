function overall_stdev = calculate_pooled_stdev(means, stdevs, sizes)
    % CALCULATE_POOLED_STDEV Вычисляет объединенное стандартное отклонение
    % 
    % Входные параметры:
    %   means  - вектор средних значений для каждой группы
    %   stdevs - вектор стандартных отклонений для каждой группы
    %   sizes  - вектор размеров выборок для каждой группы
    %
    % Выходные параметры:
    %   overall_stdev - общее стандартное отклонение
    
    % 1. Общее количество наблюдений
    N_total = sum(sizes);
    
    % 2. Общее среднее (взвешенное по размерам выборок)
    overall_mean = sum(means .* sizes) / N_total;
    
    % 3. Дисперсия внутри групп (SS_within)
    variances = stdevs .^ 2;
    SS_within = sum((sizes - 1) .* variances);
    
    % 4. Дисперсия между группами (SS_between)
    SS_between = sum(sizes .* (means - overall_mean) .^ 2);
    
    % 5. Общая дисперсия (для выборочного стандартного отклонения)
    SS_total = SS_within + SS_between;
    overall_variance = SS_total / (N_total - 1);
    
    % 6. Общее стандартное отклонение
    overall_stdev = sqrt(overall_variance);
end