function [dataout, TTout] = plotall(data,data_ldf,path,name,TT,ldf_flag)

fig = figure('Name',name,'NumberTitle','off', ...
    'Color','white', 'units','normalized','outerposition',[0 0 1 1]);

if ldf_flag == 1
tiledlayout(4,1)
else
    tiledlayout(3,1)
end

% First plot
ax1 = nexttile;
plot(data.DATE,data.ECG,'.')
title(strcat(path,name))
ylabel('ECG, mV')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)
% 
% % Second plot
% ax2 = nexttile;
% %plot(data.DATE,data.RHEO1*0.0708/1000,'.',data.DATE,data.RHEO2*0.1203/1000,'.')
% %plot(data.DATE,data.RHEO2*0.1203/1000,'.')
% %ylabel('\Delta\rho кажущееся, Ом*м') 
% plot(data.DATE,data.RHEO1,'.',data.DATE,data.RHEO2,'.')
% ylabel('\DeltaR, пульсовое сопротивление, Ом') 
% grid on
% grid minor
xline(TT.DATE,'--')
% Second plot
ax2 = nexttile;
%plot(data.DATE,data.RHEO1*0.0708/1000,'.',data.DATE,data.RHEO2*0.1203/1000,'.')
%plot(data.DATE,data.RHEO2*0.1203/1000,'.')
%ylabel('\Delta\rho кажущееся, Ом*м') 
plot(data.DATE,data.RHEO1,'.',data.DATE,data.RHEO2,'.')
ylabel('\DeltaR, пульсовое сопротивление, Ом') 
grid on
grid minor
xline(TT.DATE,'--')

% Third plot
ax3 = nexttile;
%plot(data.DATE,data.BASE1*0.0708,'.',data.DATE,data.BASE2*0.1203,'.')
%plot(data.DATE,data.BASE2*0.1203,'.')
%ylabel('\rho кажущееся, Ом*м') 
plot(data.DATE,data.BASE1,'.',data.DATE,data.BASE2,'x')
ylabel('R, базовое сопротивление, Ом') 
xlabel('Время') 
grid on
grid minor
xline(TT.DATE,'--')
legend('С рук','Со лба')

if ldf_flag == 1
    % Fourth plot
ax4 = nexttile;
%plot(data.DATE,data.BASE1*0.0708,'.',data.DATE,data.BASE2*0.1203,'.')
%plot(data.DATE,data.BASE2*0.1203,'.')
%ylabel('\rho кажущееся, Ом*м') 
yyaxis left
plot(data.DATE,data.RHEO2,LineWidth=3)
ylabel('Импеданс, мОм')
ylim([-50 50])
yyaxis right
plot(data_ldf.DATE_LDF,data_ldf.MC,LineWidth=3)
ylim([10 30])
ylabel('ПМ, параметр микроциркуляции, ед.') 
xlabel('Время') 

grid on
grid minor
xline(TT.DATE,'--')
legend('Импеданс','ЛДФ')

linkaxes([ax1 ax2 ax3 ax4],'x')% ax3
else
    linkaxes([ax1 ax2 ax3],'x')% ax3
end



[status, msg, msgID] = mkdir(path);
if status == 1
    saveas(fig,strcat(path,name,'.png'))
    saveas(fig,strcat(path,name,'.fig'))
    close(fig)
end

end
