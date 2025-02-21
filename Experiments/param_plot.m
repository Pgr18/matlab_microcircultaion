function param_plot(PARAM,path,name,TT,PD)

fig = figure('Name',name,'NumberTitle','off', ...
    'Color','white', 'units','normalized','outerposition',[0 0 1 1]);
tiledlayout(4,1)

%{
mednum = 50;
RRmed = medfilt1(PARAM.RR,mednum);
dR1med = medfilt1(PARAM.dR1,mednum);
dR2med = medfilt1(PARAM.dR2,mednum);
dR1rmed = medfilt1(PARAM.dR1r,mednum);
dR2rmed = medfilt1(PARAM.dR2r,mednum);
%}

% First plot
ax1 = nexttile;
plot(PARAM.NAME,PARAM.RR,'o',...
    PD.DATE,60./PD.RR,'-b')
title(strcat(path,name))
ylabel('R-R interval, s')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Second plot
ax2 = nexttile;
plot(PARAM.NAME,PARAM.dR1,'o',...
    PARAM.NAME,PARAM.dR2,'o',...
    PD.DATE,PD.dR1,'-b',...
    PD.DATE,PD.dR2,'-r')
ylabel('-dRHEO, mOhm') 
grid on
grid minor
xline(TT.DATE,'--')

% Third plot
ax3 = nexttile;
plot(PARAM.NAME,1000.*PARAM.dR1r,'o',...
    PARAM.NAME,1000.*PARAM.dR2r,'o',...
    PD.DATE,PD.dR1r,'-b',...
    PD.DATE,PD.dR2r,'-r')
ylabel('-dRHEO/BASE, kOne') 
xlabel('Time') 
grid on
grid minor
xline(TT.DATE,'--')

% Fourth plot
ax4 = nexttile;
plot(PARAM.NAME,PARAM.BASE1,'o',...
    PARAM.NAME,PARAM.BASE2,'o',...
    PD.DATE,PD.BASE1,'-b',...
    PD.DATE,PD.BASE2,'-r')
ylabel('BASE') 
xlabel('Time') 
grid on
grid minor
xline(TT.DATE,'--')
legend('Channel 1','Channel 2','')

linkaxes([ax1 ax2 ax3 ax4],'x')

status = mkdir(path);
if status == 1
    saveas(fig,strcat(path,name,'.png'))
    saveas(fig,strcat(path,name,'.fig'))
    close(fig)
end

end