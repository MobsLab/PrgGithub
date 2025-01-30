

for mouse=1:length(Mouse)
    %         OutPutData..tailtemperature.var(mouse,2) = nanmean(movstd(Data(OutPutData..tailtemperature.tsd{mouse,2}),5));
    %         OutPutData..masktemperature.var(mouse,2) = nanmean(movstd(Data(OutPutData.masktemperature.tsd{mouse,2}),5));
    OutPutData.accelero.var(mouse,2) = nanmean(movstd(log10(Data(OutPutData.accelero.tsd{mouse,2})),5));
    %     OutPutData.tailtemperature.var(mouse,3) = nanmean(movstd(Data(OutPutData.tailtemperature.tsd{mouse,3}),5));
    %     OutPutData.masktemperature.var(mouse,3) = nanmean(movstd(Data(OutPutData.masktemperature.tsd{mouse,3}),5));
    OutPutData.accelero.var(mouse,3) = nanmean(movstd(log10(Data(OutPutData.accelero.tsd{mouse,3})),5));
    try
        OutPutData.emg.var(mouse,2) = nanmean(movstd(Data(OutPutData.emg.tsd{mouse,2}),5));
        OutPutData.emg.var(mouse,3) = nanmean(movstd(Data(OutPutData.emg.tsd{mouse,3}),5));
    end
end
OutPutData.Cond.masktemperature.var(4,5)=NaN; OutPutData.Cond.masktemperature.mean(4,5)=NaN;
OutPutData.Ext.masktemperature.mean(3,5:6)=NaN; OutPutData.Ext.masktemperature.var(3,5:6)=NaN;

for mouse=1:length(Mouse)
    OutPutData.heartrate.mean(OutPutData.heartrate.mean==0)=NaN;
    OutPutData.heartratevar.mean(OutPutData.heartratevar.mean==0)=NaN;
    OutPutData.emg.mean(OutPutData.emg.mean==0)=NaN;
    OutPutData.emg.var(OutPutData.emg.var==0)=NaN;
end



%group=;

%% 1) Plot mean values
figure
subplot(261)
MakeSpreadAndBoxPlot2_SB(OutPutData.heartrate.mean(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Heart rate')

subplot(262)
MakeSpreadAndBoxPlot2_SB(OutPutData.respi_freq_bm.mean(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Respiratory rate')

subplot(263)
MakeSpreadAndBoxPlot2_SB(OutPutData.tailtemperature.mean(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Temperature (°C)'); title('Tail temperature')

subplot(264)
MakeSpreadAndBoxPlot2_SB(OutPutData.masktemperature.mean(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Temperature (°C)'); title('Mask temperature')

subplot(265)
MakeSpreadAndBoxPlot2_SB(abs(OutPutData.emg.mean(:,2:3)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('(a.u.)'); title('EMG Power')

subplot(266)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.accelero.mean(:,2:3)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('(a.u.)'); title('Accelerometer')

%% 2) Plot variability

subplot(267)
MakeSpreadAndBoxPlot2_SB(OutPutData.heartratevar.mean(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Variability');

subplot(268)
MakeSpreadAndBoxPlot2_SB(OutPutData.respivar.mean(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);

subplot(269)
MakeSpreadAndBoxPlot2_SB(OutPutData.tailtemperature.var(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);

OutPutData.masktemperature.var(6,5:6)=NaN;
subplot(2,6,10)
MakeSpreadAndBoxPlot2_SB(OutPutData.masktemperature.var(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);

subplot(2,6,11)
MakeSpreadAndBoxPlot2_SB(OutPutData.emg.var(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);

subplot(2,6,12)
MakeSpreadAndBoxPlot2_SB(OutPutData.accelero.var(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);


if sess==1
    a=suptitle('Somatic characterization, head restrained, n=2'); a.FontSize=20;
else
    a=suptitle('Somatic characterization, saline SB, Ext sessions, n=8'); a.FontSize=20;
end


