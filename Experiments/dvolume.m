function [deltaV] = dvolume(delta_Z)
%DVOLUME Summary of this function goes here
%   Detailed explanation goes here

%Геометрические характеристики "кубика" ткани в мм
l_mm = 10;
% Перевод в нужные единицы измерения
l = l_mm/1000;
% Удельное сопротивление крови в Ом*м
rho_blood = 1.35;
% исходное удельное сопротивление ткани в Ом*м
%rho_tissue0 = 1/0.13366;%серое вещество

rho_tissue0 = 1/(60*10^(-3));%кожа
%rho_tissue0 = 1/(0.020791);%лобная кость
% Плотность ткани в кг/м3
rho_mech_tissue = 1000;
% Кровенаполнение ткани, мл/(мин*100г)
%V_blood_tissue = 10;
% ЧСС, уд/мин
HR = 60;
% Объём ткани
V_tissue = 0.1/rho_mech_tissue;
a = sqrt(V_tissue/l);
% Объём крови
%V_blood = (V_blood_tissue/HR)/1000000;
S_tissue = a*a;
%S_blood = V_blood/l;
%R_tissue = rho_tissue0*l/S_tissue;

% Закомментить когда обратный пересчёт
% R_blood = rho_blood*l/S_blood;
% R_blood_tissue = R_tissue*R_blood/(R_tissue+R_blood);
% deltaR = R_blood_tissue - R_tissue;
% b = sqrt(V_blood/l);
% %b = 0;
% % Изменение удельного сопротивления вследствие кровенаполнения
% delta__rho = (S_tissue)*deltaR/l;
% disp(delta__rho);
% Закомментить когда обратный пересчёт. Конец

%Обратный пересчёт в кровенаполнение на 100 г ткани
%Исходное значение изменения удельного сопротивления в Ом*м
delta__rho = -delta_Z/10.63/1000; % in Ohm*m

deltaR = delta__rho*l/S_tissue;
R_tissue = rho_tissue0*l/S_tissue;
R_blood_tissue = R_tissue+deltaR;
R_blood = R_blood_tissue*R_tissue/(R_tissue - R_blood_tissue);

S_blood = rho_blood*l/R_blood;
V_blood = S_blood*l*1000000;
deltaV = HR*V_blood;


end

