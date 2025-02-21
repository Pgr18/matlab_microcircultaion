function cycle_plot(DATA,PARAM,path)

cyclenamefull = string(DATA.NAME,"dd-MM-yyyy HH:mm:ss.SSS");
cyclename = string(DATA.NAME,"HH-mm-ss.SSS");

fig = figure('Name',cyclename,'NumberTitle','off', ...
    'Color','white');

tiledlayout(3,1)

% First plot
ax1 = nexttile;
plot(DATA.TIME,DATA.ECG)
title(cyclenamefull)
ylabel('ECG, mV') 
grid on
grid minor

% Second plot
ax2 = nexttile;
plot(DATA.TIME,DATA.RHEO1,'-', ...
    DATA.TIME,DATA.RHEO2,'-', ...
    DATA.TIME(DATA.dRHEO1_MAX_I),DATA.RHEO1(DATA.dRHEO1_MAX_I),'or',...
    DATA.TIME(DATA.dRHEO2_MAX_I),DATA.RHEO2(DATA.dRHEO2_MAX_I),'or',...
    DATA.TIME(DATA.RHEO1_MAX_I),DATA.RHEO1(DATA.RHEO1_MAX_I),'db',...
    DATA.TIME(DATA.RHEO2_MAX_I),DATA.RHEO2(DATA.RHEO2_MAX_I),'db',...
    DATA.TIME(DATA.RHEO1_MIN_I),DATA.RHEO1(DATA.RHEO1_MIN_I),'xg',...
    DATA.TIME(DATA.RHEO2_MIN_I),DATA.RHEO2(DATA.RHEO2_MIN_I),'xg')

title(strcat('BASE1=', num2str(round(mean(DATA.BASE1))),[' Ohm, ' ...
    'QS1='], num2str(round(DATA.QS1,0)),[' Ohm, ' ...
    'BASE2='], num2str(round(mean(DATA.BASE2))),[' Ohm, ' ...
    'QS2='], num2str(round(DATA.QS2)),' Ohm'))
ylabel('-RHEO, mOhm') 
grid on
grid minor

% Third plot
% ax3 = nexttile;
% plot(DATA.TIME,DATA.dRHEO1,'-', ...
%     DATA.TIME,DATA.dRHEO2,'-', ...
%     DATA.TIME(DATA.dRHEO1_MAX_I),DATA.dRHEO1(DATA.dRHEO1_MAX_I),'or',...
%     DATA.TIME(DATA.dRHEO2_MAX_I),DATA.dRHEO2(DATA.dRHEO2_MAX_I),'or')
% title(strcat('Ad1=', num2str(round(PARAM.ad1,3)),[' mOhm, ' ...
%     'f1='], num2str(round(1000*PARAM.f1,3)),[' ms, ' ...
%     'Ad2='], num2str(round(PARAM.ad2,3)),[' mOhm, ' ...
%     'f2='], num2str(round(1000*PARAM.f2,3)),' ms'))
% ylabel('dRHEO, mOhm') 
% xlabel('Time, s')
% grid on
% grid minor

ax3 = nexttile;
plot(DATA.TIME,DATA.BASE1,'-')
title("Базовое сопротивление")
ylabel('Base, Ohm') 
xlabel('Time, s')
grid on
grid minor

linkaxes([ax1 ax2 ax3],'x')

[status] = mkdir(path);
if status == 1
    saveas(fig,strcat(path,cyclename,'.png'))
    saveas(fig,strcat(path,cyclename,'.fig'))
    close(fig)
end

end
