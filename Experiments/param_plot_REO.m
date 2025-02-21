function param_plot_REO(PARAM,path,name,TT)

fig = figure('Name',name,'NumberTitle','off', ...
    'Color','white', 'units','normalized','outerposition',[0 0 1 1]);
tiledlayout(5,1)

% First plot
ax1 = nexttile;
plot(PARAM.NAME,60./PARAM.RR,'d')
title(strcat(path,name))
ylabel('Heart rate')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Second plot
ax2 = nexttile;
plot(PARAM.NAME,PARAM.BASE1,'o',...
    PARAM.NAME,PARAM.BASE2,'*')
title('Базовый импеданс')
ylabel('BASE, ohm') 
grid on
grid minor
xline(TT.DATE,'--')

% Third plot
ax3 = nexttile;
plot(PARAM.NAME,PARAM.dR1./PARAM.BASE1,'o',...
    PARAM.NAME,PARAM.dR2./PARAM.BASE2,'*')
ylabel('b/BASE') 
grid on
grid minor
xline(TT.DATE,'--')

% Fourth plot
ax4 = nexttile;
plot(PARAM.NAME,PARAM.a1./PARAM.f1,'o',...
    PARAM.NAME,PARAM.a2./PARAM.f2,'*')
ylabel('a/f, ohm/s') 
grid on
grid minor
xline(TT.DATE,'--')

% Fifth plot
%ax5 = nexttile;
%plot(PARAM.NAME,PARAM.dR1./PARAM.alpha1,'o',...
%    PARAM.NAME,PARAM.dR2./PARAM.alpha2,'*')
% ylabel('a/alpha, ohm/s') 
% xlabel('Time') 
% grid on
% grid minor
% xline(TT.DATE,'--')
% legend('Channel 1','Channel 2','')

% Sixth plot

ax5 = nexttile;
plot(PARAM.NAME,PARAM.dV,'o')
title('Кровенаполнение')
ylabel('Кровенаполнение, мл/мин на 100г ткани') 
xlabel('Time') 
grid on
grid minor
xline(TT.DATE,'--')

linkaxes([ax1 ax2 ax3 ax4 ax5],'x')

status = mkdir(path);
if status == 1
    saveas(fig,strcat(path,name,'.png'))
    saveas(fig,strcat(path,name,'.fig'))
    close(fig)
end

end