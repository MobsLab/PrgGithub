
Cols = {[0 0 1],[1, 0, 0],[0 1 0]};
X = [1,2,3];
Legends = {'Wake','NREM','REM'};


for mouse=1:length(Mouse)
    OutPutData.BaselineSleep.accelero.var(mouse,2) = nanmean(movstd(log10(Data(OutPutData.BaselineSleep.accelero.tsd{mouse,2})),5));
    OutPutData.BaselineSleep.accelero.var(mouse,4) = nanmean(movstd(log10(Data(OutPutData.BaselineSleep.accelero.tsd{mouse,4})),5));
    OutPutData.BaselineSleep.accelero.var(mouse,5) = nanmean(movstd(log10(Data(OutPutData.BaselineSleep.accelero.tsd{mouse,5})),5));
    try
        OutPutData.BaselineSleep.emg.var(mouse,2) = nanmean(movstd(Data(OutPutData.BaselineSleep.emg.tsd{mouse,2}),5));
        OutPutData.BaselineSleep.emg.var(mouse,4) = nanmean(movstd(Data(OutPutData.BaselineSleep.emg.tsd{mouse,4}),5));
        OutPutData.BaselineSleep.emg.var(mouse,5) = nanmean(movstd(Data(OutPutData.BaselineSleep.emg.tsd{mouse,5}),5));
    end
end

% OutPutData.Cond.masktemperature.var(4,5)=NaN; OutPutData.Cond.masktemperature.mean(4,5)=NaN;
% OutPutData.Ext.masktemperature.mean(3,5:6)=NaN; OutPutData.Ext.masktemperature.var(3,5:6)=NaN;

for mouse=1:length(Mouse)
    OutPutData.BaselineSleep.heartrate.mean(OutPutData.BaselineSleep.heartrate.mean==0)=NaN;
    OutPutData.BaselineSleep.heartratevar.mean(OutPutData.BaselineSleep.heartratevar.mean==0)=NaN;
    OutPutData.BaselineSleep.emg.mean(OutPutData.BaselineSleep.emg.mean==0)=NaN;
    OutPutData.BaselineSleep.emg.var(OutPutData.BaselineSleep.emg.var==0)=NaN;
end


%% 1) Plot mean values
figure
subplot(261)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.heartrate.mean(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Heart rate')

subplot(262)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.respi_freq_bm.mean(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Respiratory rate')

subplot(263)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.tailtemperature.mean(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Temperature (°C)'); title('Tail temperature')

subplot(264)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.masktemperature.mean(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Temperature (°C)'); title('Mask temperature')

subplot(265)
MakeSpreadAndBoxPlot2_SB(abs(OutPutData.BaselineSleep.emg.mean(:,[2 4 5])),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('(a.u.)'); title('EMG Power')

subplot(266)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.accelero.mean(:,[2 4 5])),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('(a.u.)'); title('Accelerometer')

%% 2) Plot variability

subplot(267)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.heartratevar.mean(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Variability'); ylim([0 0.4])

subplot(268)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.respivar.mean(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);

subplot(269)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.tailtemperature.var(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);

OutPutData.BaselineSleep.masktemperature.var(6,5:6)=NaN;
subplot(2,6,10)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.masktemperature.var(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);

subplot(2,6,11)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.emg.var(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);

subplot(2,6,12)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.accelero.var(:,[2 4 5]),Cols,X,Legends,'showpoints',0,'paired',1);


a=suptitle('Somatic characterization, Baseline sleep, n=9'); a.FontSize=20;


%%
Cols = {[1, 0.8, 0.8],[1, 0.4, 0.4],[0.8, 0, 0]};
X = [1,2,3];
Legends = {'N1','N2','N3'};

for mouse=1:length(Mouse)
    OutPutData.BaselineSleep.accelero.var(mouse,6) = nanmean(movstd(log10(Data(OutPutData.BaselineSleep.accelero.tsd{mouse,6})),5));
    OutPutData.BaselineSleep.accelero.var(mouse,7) = nanmean(movstd(log10(Data(OutPutData.BaselineSleep.accelero.tsd{mouse,7})),5));
    OutPutData.BaselineSleep.accelero.var(mouse,8) = nanmean(movstd(log10(Data(OutPutData.BaselineSleep.accelero.tsd{mouse,8})),5));
    try
        OutPutData.BaselineSleep.emg.var(mouse,6) = nanmean(movstd(Data(OutPutData.BaselineSleep.emg.tsd{mouse,6}),5));
        OutPutData.BaselineSleep.emg.var(mouse,7) = nanmean(movstd(Data(OutPutData.BaselineSleep.emg.tsd{mouse,7}),5));
        OutPutData.BaselineSleep.emg.var(mouse,8) = nanmean(movstd(Data(OutPutData.BaselineSleep.emg.tsd{mouse,8}),5));
    end
end

% OutPutData.Cond.masktemperature.var(4,5)=NaN; OutPutData.Cond.masktemperature.mean(4,5)=NaN;
% OutPutData.Ext.masktemperature.mean(3,5:6)=NaN; OutPutData.Ext.masktemperature.var(3,5:6)=NaN;

for mouse=1:length(Mouse)
    OutPutData.BaselineSleep.heartrate.mean(OutPutData.BaselineSleep.heartrate.mean==0)=NaN;
    OutPutData.BaselineSleep.heartratevar.mean(OutPutData.BaselineSleep.heartratevar.mean==0)=NaN;
    OutPutData.BaselineSleep.emg.mean(OutPutData.BaselineSleep.emg.mean==0)=NaN;
    OutPutData.BaselineSleep.emg.var(OutPutData.BaselineSleep.emg.var==0)=NaN;
end


%% 1) Plot mean values
figure
subplot(261)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.heartrate.mean(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Heart rate')

subplot(262)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.respi_freq_bm.mean(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Respiratory rate')

subplot(263)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.tailtemperature.mean(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Temperature (°C)'); title('Tail temperature')

subplot(264)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.masktemperature.mean(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Temperature (°C)'); title('Mask temperature')

subplot(265)
MakeSpreadAndBoxPlot2_SB(abs(OutPutData.BaselineSleep.emg.mean(:,6:8)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('(a.u.)'); title('EMG Power')

subplot(266)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.accelero.mean(:,6:8)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('(a.u.)'); title('Accelerometer')

%% 2) Plot variability

subplot(267)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.heartratevar.mean(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Variability'); ylim([0 0.4])

subplot(268)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.respivar.mean(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);

subplot(269)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.tailtemperature.var(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);

OutPutData.BaselineSleep.masktemperature.var(6,5:6)=NaN;
subplot(2,6,10)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.masktemperature.var(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);

subplot(2,6,11)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.emg.var(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);

subplot(2,6,12)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.accelero.var(:,6:8),Cols,X,Legends,'showpoints',0,'paired',1);


a=suptitle('Somatic characterization, Baseline sleep, NREM, n=9'); a.FontSize=20;



