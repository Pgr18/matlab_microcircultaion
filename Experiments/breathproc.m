function CYCLE_BR = breathproc(CYCLE,path,name)

DATE = [];
RHEO1 = [];
RHEO2 = [];

N = length(CYCLE);
for i=1:N
    DATE = [DATE; CYCLE{i}.NAME+seconds(CYCLE{i}.TIME)];
    RHEO1 = [RHEO1; CYCLE{i}.RHEO1];
    RHEO2 = [RHEO2; CYCLE{i}.RHEO2];

    if i > 1
        BR_COUNT(i) = BR_COUNT(i-1)+length(CYCLE{i-1}.TIME);
    else
        BR_COUNT(i) = 1;
    end

    BREATH1(i) = CYCLE{i}.RHEO1(1);
    BREATH2(i) = CYCLE{i}.RHEO2(1);
end

BR1_LINE = spline(BR_COUNT,BREATH1,1:length(DATE));
BR2_LINE = spline(BR_COUNT,BREATH2,1:length(DATE));

BR1 = RHEO1 - BR1_LINE.';
BR2 = RHEO2 - BR2_LINE.';

CYCLE_BR = CYCLE;
k = 0;
for i=1:N
    for j=1:length(CYCLE_BR{i}.TIME)
        k = k+1;
        CYCLE_BR{i}.RHEO1(j) = BR1(k);
        CYCLE_BR{i}.RHEO2(j) = BR2(k);
    end
end

fig = figure('Name',name,'NumberTitle','off', ...
    'Color','white', 'units','normalized','outerposition',[0 0 1 1]);
tiledlayout(3,1)
% First plot
ax1 = nexttile;
plot(DATE,-BR1,'.',DATE,-BR2,'.',DATE(BR_COUNT),-BR1(BR_COUNT),'o',DATE(BR_COUNT),-BR2(BR_COUNT),'o')
ylabel('-RHEO, mOhm') 
grid on
grid minor
% Second plot
ax2 = nexttile;
plot(DATE,BR1_LINE,'-',DATE(BR_COUNT),BREATH1,'o')
ylabel('RHEO1, mOhm') 
grid on
grid minor
% Third plot
ax3 = nexttile;
plot(DATE,BR2_LINE,'-',DATE(BR_COUNT),BREATH2,'o')
ylabel('RHEO2, mOhm') 
grid on
grid minor
linkaxes([ax1 ax2 ax3],'x')

[status] = mkdir(path);
if status == 1
    saveas(fig,strcat(path,name,'.png'))
    saveas(fig,strcat(path,name,'.fig'))
    close(fig)
end

end