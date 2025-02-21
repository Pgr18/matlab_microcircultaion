function monoplot1 = monoplot1(CYCDATA1,CYCDATA2,path,name)
N1 = min(length(CYCDATA1),length(CYCDATA2));
num_f = 1;
for i = 1:N1
fig = figure('NumberTitle','off', ...
    'Color','white');

tiledlayout(2,1)


% First plot
ax1 = nexttile;

    
        %if (~isempty(CYCDATA{i}{i1}))
        yyaxis left
        plot(CYCDATA1{i}{1}.TIME,-CYCDATA1{i}{1}.RHEO2,'LineWidth',3);
        yyaxis right
        plot(CYCDATA2{i}{1}.TIME,-CYCDATA2{i}{1}.RHEO2,'LineWidth',3);
    
        %end
    

title("1 цикл");
ylabel('-RHEO, mOhm')
legend(["Со лба, вдох","Со лба, выдох"]);
grid on
grid minor


ax2 = nexttile;

    
        %if (~isempty(CYCDATA{i}{i1}))
        yyaxis left
    plot(CYCDATA1{i}{1}.TIME,CYCDATA1{i}{1}.BASE1,'LineWidth',3);
    yyaxis right
    plot(CYCDATA2{i}{1}.TIME,CYCDATA2{i}{1}.BASE1,'LineWidth',3);
    
       %end
    

title("Базовое сопротивление")
legend(["Со лба, вдох","Со лба, выдох"]);
ylabel('Base, Ohm') 
xlabel('Time, s')
grid on
grid minor

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