function PD = param_plot_od(PARAM,path,name,TT,OD)

PD = table;
PD.DATE = OD.DATE;
PD.RR = NaN(height(OD),1);
PD.dR1 = NaN(height(OD),1);
PD.dR2 = NaN(height(OD),1);
PD.dR1r = NaN(height(OD),1);
PD.dR2r = NaN(height(OD),1);
PD.BASE1 = NaN(height(OD),1);
PD.BASE2 = NaN(height(OD),1);

for i=1:height(OD)
   KH = ismember(hour(PARAM.NAME),hour(OD.DATE(i)));
   KM = ismember(minute(PARAM.NAME),minute(OD.DATE(i)));
   K = bitand(KH,KM);

   if ~isempty(find(K,1))
       PD.RR(i) = 60/mean(PARAM.RR(K));
       PD.dR1(i) = mean(PARAM.dR1(K));
       PD.dR2(i) = mean(PARAM.dR2(K));
       PD.dR1r(i) = 1000*mean(PARAM.dR1r(K));
       PD.dR2r(i) = 1000*mean(PARAM.dR2r(K));
       PD.BASE1(i) = mean(PARAM.BASE1(K));
       PD.BASE2(i) = mean(PARAM.BASE2(K));
   end
end

fig = figure('Name',name,'NumberTitle','off', ...
    'Color','white', 'units','normalized','outerposition',[0 0 1 1]);
tiledlayout(4,1)

% First plot
ax1 = nexttile;
plot(PD.DATE,PD.RR,'o-',...
    OD.DATE,OD.HR,'*-b')
title(strcat(path,name))
ylabel('Heart rate, 1/min')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Second plot
ax2 = nexttile;
plot(PD.DATE,PD.dR1r,'o-', ...
    PD.DATE,PD.dR2r,'o-')
ylabel('-dRHEO/BASE, kOne') 
grid on
grid minor
xline(TT.DATE,'--')
legend('Channel 1','Channel 2','')

% Third plot
ax3 = nexttile;
plot(PD.DATE,PD.BASE1,'o-', ...
    PD.DATE,PD.BASE2,'o-')
ylabel('BASE, Ohm') 
grid on
grid minor
xline(TT.DATE,'--')

% Fourth plot
ax4 = nexttile;
plot(OD.DATE,OD.TEMP,'*-')
ylabel('Temperature, C') 
xlabel('Time') 
grid on
grid minor
xline(TT.DATE,'--b')

linkaxes([ax1 ax2 ax3 ax4],'x')

status = mkdir(path);
if status == 1
    saveas(fig,strcat(path,name,'.png'))
    saveas(fig,strcat(path,name,'.fig'))
    close(fig)
end

end