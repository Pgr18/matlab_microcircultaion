function plotwv(data,path,name,TT)

%Parameters
sampleRate = 1/(data.TIME(2)-data.TIME(1));
wavelet = 'amor';
frequencyLimits = [0.01,10];

%Compute CWT
[waveletTransform,frequency] = cwt(data.ECG, sampleRate, wavelet,...
    FrequencyLimits = frequencyLimits);
ECGs = abs(waveletTransform);

[waveletTransform] = cwt(data.RHEO1, sampleRate, wavelet,...
    FrequencyLimits = frequencyLimits);
R1s = abs(waveletTransform);

[waveletTransform] = cwt(data.RHEO2, sampleRate, wavelet,...
    FrequencyLimits = frequencyLimits);
R2s = abs(waveletTransform);

fig = figure('Name',name,'NumberTitle','off', ...
    'Color','white', 'units','normalized','outerposition',[0 0 1 1]);

tiledlayout(5,1)

% First plot
ax1 = nexttile;
plot(data.DATE,data.ECG,'.')
title(strcat(path,name))
ylabel('ECG, mV')
grid on
grid minor
xline(TT.DATE,'--',TT.DESC)

% Second plot
ax2 = nexttile;
plot(data.DATE,data.RHEO1,'.')
ylabel('RHEO1, mOhm') 
grid on
grid minor
xline(TT.DATE,'--')

ax2w = nexttile;
pcolor(data.DATE,frequency,R1s)
shading flat
set(gca,"yscale","log")
ylim(frequencyLimits)
ylabel("RHEO1, Hz")
xlabel("Time (s)")


% Third plot
ax3 = nexttile;
plot(data.DATE,data.RHEO2,'.')
ylabel('RHEO2, Ohm') 
xlabel('Time') 
grid on
grid minor
xline(TT.DATE,'--')

ax3w = nexttile;
pcolor(data.DATE,frequency,R2s)
shading flat
set(gca,"yscale","log")
ylim(frequencyLimits)
ylabel("RHEO2, Hz")
xlabel("Time (s)")

linkaxes([ax1 ax2 ax2w ax3 ax3w],'x')

[status, msg, msgID] = mkdir(path);
if status == 1
    saveas(fig,strcat(path,name,'.png'))
    saveas(fig,strcat(path,name,'.fig'))
    close(fig)
end

end
