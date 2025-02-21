function monoplot = monoplot(CYCDATA,path,name)
N1 = length(CYCDATA);
num_f = 1;
for i = 1:N1
fig = figure('NumberTitle','off', ...
    'Color','white');

tiledlayout(2,1)


% First plot
ax1 = nexttile;

    for i1 = 1:length(CYCDATA{i})
        %if (~isempty(CYCDATA{i}{i1}))
        %yyaxis left
        plot(CYCDATA{i}{i1}.TIME,-CYCDATA{i}{i1}.RHEO2);
        %yyaxis right
        %plot(CYCDATA{i}{i1}.TIME,CYCDATA{i}{i1}.RHEO1);
    hold on
        %end
    end

title("Все циклы");
ylabel('RHEO, mOhm')
%legend(["Со лба","С рук"]);
grid on
grid minor
hold off

ax2 = nexttile;

    for i1 = 1:length(CYCDATA{i})
        %if (~isempty(CYCDATA{i}{i1}))
    plot(CYCDATA{i}{i1}.TIME,CYCDATA{i}{i1}.BASE1);
    hold on
       %end
    end

title("Базовое сопротивление")
ylabel('Base, Ohm') 
xlabel('Time, s')
grid on
grid minor
hold off
linkaxes([ax1 ax2],'x')

[status] = mkdir(path);
if status == 1
    saveas(fig,strcat(path,strcat(name,int2str(num_f)),'.png'))
    saveas(fig,strcat(path,strcat(name,int2str(num_f)),'.fig'))
    close(fig)
end
num_f = num_f +1;
end
end