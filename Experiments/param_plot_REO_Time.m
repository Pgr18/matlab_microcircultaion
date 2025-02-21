function param_plot_REO_Time(PARAM,path,name,TT)

fig = figure('Name',name,'NumberTitle','off', ...
    'Color','white', 'units','normalized','outerposition',[0 0 1 1]);
tiledlayout(5,1)

% First plot
ax1 = nexttile;
plot(PARAM.NAME,1000.*PARAM.RR,'d')
title(strcat(path,name))
ylabel('T, ms')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Second plot
ax2 = nexttile;
plot(PARAM.NAME,1000.*PARAM.alpha1,'o',...
    PARAM.NAME,1000.*PARAM.alpha2,'*')
title('Время подъема восходящей части')
ylabel('alpha, ms')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Third plot
ax3 = nexttile;
plot(PARAM.NAME,1000.*PARAM.beta1,'o',...
    PARAM.NAME,1000.*PARAM.beta2,'*')
title('Время спуска нисходящей части')
ylabel('beta, ms')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Fourth plot
ax4 = nexttile;
plot(PARAM.NAME,1000.*PARAM.f1,'o',...
    PARAM.NAME,1000.*PARAM.f2,'*')
title('Время быстрого кровенаполнения')
ylabel('f, ms') 
grid on
grid minor
xline(TT.DATE,'--')

% Fifth plot
ax5 = nexttile;
plot(PARAM.NAME,PARAM.beta1./PARAM.alpha1,'o',...
    PARAM.NAME,PARAM.beta2./PARAM.alpha2,'*')
ylabel('beta/alpha') 
xlabel('Time') 
grid on
grid minor
xline(TT.DATE,'--')
legend('Channel 1','Channel 2','')

linkaxes([ax1 ax2 ax3 ax4 ax5],'x')

status = mkdir(path);
if status == 1
    saveas(fig,strcat(path,name,'.png'))
    saveas(fig,strcat(path,name,'.fig'))
    close(fig)
end

end