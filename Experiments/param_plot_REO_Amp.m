function param_plot_REO_Amp(PARAM,path,name,TT)

fig = figure('Name',name,'NumberTitle','off', ...
    'Color','white', 'units','normalized','outerposition',[0 0 1 1]);
tiledlayout(5,1)

% First plot
ax1 = nexttile;
plot(PARAM.NAME,PARAM.a1,'o',...
    PARAM.NAME,PARAM.a2,'*')
title(strcat(path,name,' Амплитуда быстрого кровенаполнения'))
ylabel('a, Ohm')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Second plot
ax2 = nexttile;
plot(PARAM.NAME,PARAM.dR1,'o',...
    PARAM.NAME,PARAM.dR2,'*')
disp(mean(PARAM.dR1));
disp(mean(PARAM.dR2));
title('Основная амплитуда реограммы')
ylabel('b, Ohm')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Third plot
ax3 = nexttile;
plot(PARAM.NAME,PARAM.e1,'o',...
    PARAM.NAME,PARAM.e2,'*')
title(strcat(path,name))
title('Амплитуда дикротической волны')
ylabel('e, Ohm')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Fourth plot
ax4 = nexttile;
plot(PARAM.NAME,PARAM.d1,'o',...
    PARAM.NAME,PARAM.d2,'*')
title('Амплитуда инцизуры')
ylabel('d, Ohm') 
grid on
grid minor
xline(TT.DATE,'--')

% Fifth plot
ax5 = nexttile;
plot(PARAM.NAME,PARAM.ad1,'o',...
    PARAM.NAME,PARAM.ad2,'*')
title('Амплитуда дифференциальной реограммы')
ylabel('ad') 
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