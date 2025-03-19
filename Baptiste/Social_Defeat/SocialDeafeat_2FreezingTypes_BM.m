

GetData_SD_2Fz_BM

%% figures

Cols={[1 .5 .5],[.5 .5 1]};
Legends={'exposure CD1 cage','exposure homecage'};
X=1:2;


figure
subplot(161)
bar(Fz_prop)
xticklabels(Legends), xtickangle(45)
ylabel('mice proportion')
title('mice freezing after exposure')
ylim([0 .55])
box off

subplot(162)
MakeSpreadAndBoxPlot3_SB(FreezeTime(2:3),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time (s)')
set(gca , 'Yscale','log')
title('time spent freezing')

subplot(1,6,3:5)
Plot_MeanSpectrumForMice_BM(OB_Low_Mean_Fz{2} , 'color','r','smoothing',5)
Plot_MeanSpectrumForMice_BM(OB_Low_Mean_Fz{3} , 'color','b','smoothing',5)
xlim([0 10])
f=get(gca,'Children'); l=legend([f(8),f(4)],'exposure CD1 cage','exposure homecage');
box off
title('Mean OB spectrum during freezing')

subplot(166)
MakeSpreadAndBoxPlot3_SB(Rip_density(2:3),Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.3]), ylabel('ripples occurency (#/s)')
title('Ripples density during freezing')

a=suptitle('Freezing features after social defeat, MC data, n=32'); a.FontSize=20;





figure
[h , MaxPowerValues , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_Low_Mean_Fz{2} , 'color','r')
[h , MaxPowerValues , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_Low_Mean_Fz{3} , 'color','b')
xlim([0 10])
f=get(gca,'Children'); l=legend([f(8),f(4)],'exposure CD1 cage','exposure homecage');
makepretty



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1 6])
ylabel('Frequency (Hz)')

ind = or(isnan(Freq_Max1) , isnan(Freq_Max2));
subplot(122)
MakeSpreadAndBoxPlot3_SB({Freq_Max1(~ind) Freq_Max2(~ind)},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([1 6])




%%
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Acc_Values_Fz,Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('movement quantity (log scale)')
title('Accelerometer')

subplot(122)
MakeSpreadAndBoxPlot3_SB(EMGVals,Cols,X,Legends,'showpoints',0,'paired',0);
ylabel('EMG power (log scale)')
title('EMG')




figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Acc_Values_Fz,Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('movement quantity (log scale)')
title('Accelerometer')

subplot(122)
MakeSpreadAndBoxPlot3_SB(EMGVals,Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('EMG power (log scale)')
title('EMG')





