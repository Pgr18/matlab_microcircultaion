function DATA = cycleall(CYCLE,data_ldf,path,name,TT,ldf_flag)

DATE = [];
ECG = [];
RHEO1 = [];
BASE1 = [];
RHEO2 = [];
BASE2 = [];

N = length(CYCLE);
for i=1:N
    DATE = [DATE; CYCLE{i}.NAME+seconds(CYCLE{i}.TIME)];
    ECG = [ECG; CYCLE{i}.ECG];
    RHEO1 = [RHEO1; CYCLE{i}.RHEO1];
    BASE1 = [BASE1; CYCLE{i}.BASE1];
    RHEO2 = [RHEO2; CYCLE{i}.RHEO2];
    BASE2 = [BASE2; CYCLE{i}.BASE2];

    CYCLE_LINE(i) = CYCLE{i}.NAME;
    ECG_LINE(i) = CYCLE{i}.ECG(1);
    RHEO1_LINE(i) = CYCLE{i}.RHEO1(1);
    RHEO2_LINE(i) = CYCLE{i}.RHEO2(1);
end
    %CYCLE_LINE(N+1) = CYCLE{N}.NAME+seconds(CYCLE{N}.TIME(length(CYCLE{N}.TIME)));

varNames = {'DATE','ECG','RHEO1','BASE1','RHEO2','BASE2'};
data = table(DATE,ECG,RHEO1,BASE1,RHEO2,BASE2, ...
    'VariableNames',varNames);

fig = figure('Name',name,'NumberTitle','off', ...
    'Color','white', 'units','normalized','outerposition',[0 0 1 1]);

if ldf_flag == 1
tiledlayout(4,1)
else
    tiledlayout(3,1)
end

% First plot
ax1 = nexttile;
plot(data.DATE,data.ECG,"LineWidth",3)
title(strcat(path,name))
ylabel('ECG, mV')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)
%xline(CYCLE_LINE,':r')

% Second plot
ax2 = nexttile;
plot(data.DATE,-data.RHEO1,data.DATE,-data.RHEO2,"LineWidth",3)%CYCLE_LINE,-RHEO1_LINE,'o',CYCLE_LINE,-RHEO2_LINE,'o'
ylabel('-RHEO, mOhm') 
grid on
grid minor
xline(TT.DATE,'--')
legend(["С рук" "Со лба"]);
%xline(CYCLE_LINE,':r')

% Third plot
ax3 = nexttile;
plot(data.DATE,data.BASE1,'.',data.DATE,data.BASE2,'.')
ylabel('BASE, Ohm') 
xlabel('Time') 
grid on
grid minor
xline(TT.DATE,'--')
%xline(CYCLE_LINE,':r')
legend('Channel 1','Channel 2','')

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


status = mkdir(path);
if status == 1
    saveas(fig,strcat(path,name,'.png'))
    saveas(fig,strcat(path,name,'.fig'))
    close(fig)
end

end