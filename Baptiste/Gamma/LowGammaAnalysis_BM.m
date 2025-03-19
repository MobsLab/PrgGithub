
%% Low gamma study

load('ChannelsToAnalyse/Bulb_deep.mat','channel')
MiddleSpectrum_BM([cd filesep],channel,'B')

load('B_Middle_Spectrum.mat')
load('behavResources_SB.mat', 'Behav')

Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});

Sptsd_Fz = Restrict(Sptsd , Behav.FreezeAccEpoch);
Sptsd_FzShock = Restrict(Sptsd , and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1}));
Sptsd_FzSafe = Restrict(Sptsd , and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5})));

figure
subplot(311)
imagesc(Range(Sptsd) , Spectro{3} , Data(Sptsd)'); axis xy
caxis([0 4e4])
title('All')
subplot(312)
imagesc(Range(Sptsd_Fz) , Spectro{3} , Data(Sptsd_Fz)'); axis xy
colormap jet
caxis([0 4e4])
title('Fz')
subplot(325)
imagesc(Range(Sptsd_FzShock) , Spectro{3} , Data(Sptsd_FzShock)'); axis xy
colormap jet
caxis([0 4e4])
title('Shock Fz')
subplot(326)
imagesc(Range(Sptsd_FzSafe) , Spectro{3} , Data(Sptsd_FzSafe)'); axis xy
colormap jet
caxis([0 4e4])
title('Safe Fz')

figure
subplot(311)
imagesc(Range(Sptsd) , Spectro{3} , Data(Sptsd)'); axis xy
caxis([0 4e4]); ylim([20 55])
title('All')
subplot(312)
imagesc(Range(Sptsd_Fz) , Spectro{3} , Data(Sptsd_Fz)'); axis xy
colormap jet
caxis([0 4e4]); ylim([20 55])
title('Fz')
subplot(325)
imagesc(Range(Sptsd_FzShock) , Spectro{3} , Data(Sptsd_FzShock)'); axis xy
colormap jet
caxis([0 4e4]); ylim([20 55])
title('Shock Fz')
subplot(326)
imagesc(Range(Sptsd_FzSafe) , Spectro{3} , Data(Sptsd_FzSafe)'); axis xy
colormap jet
caxis([0 4e4]); ylim([20 55])
title('Safe Fz')

figure
subplot(121)
plot(Spectro{3} ,nanmean(Data(Sptsd)) , 'g')
hold on
plot(Spectro{3} ,nanmean(Data(Sptsd_Fz)) , 'k')
plot(Spectro{3} ,nanmean(Data(Sptsd_FzShock)) , 'r')
plot(Spectro{3} ,nanmean(Data(Sptsd_FzSafe)) , 'b')
set(gca,'Yscale','log')
makepretty
legend('All','Fz','Fz shock','Fz safe')
ylabel('Power (a.u.)')
xlabel('Frequency (Hz)')

subplot(122)
plot(Spectro{3} ,Spectro{3}.*nanmean(Data(Sptsd)) , 'g')
hold on
plot(Spectro{3} ,Spectro{3}.*nanmean(Data(Sptsd_Fz)) , 'k')
plot(Spectro{3} ,Spectro{3}.*nanmean(Data(Sptsd_FzShock)) , 'r')
plot(Spectro{3} ,Spectro{3}.*nanmean(Data(Sptsd_FzSafe)) , 'b')
makepretty
xlim([18 100]); ylim([0 1e6])
xlabel('Frequency (Hz)')

ylim([20 55])
hline(40,'-r')
vline(40,'-r')

Data_Sptsd_Fz=Data(Sptsd_Fz);
Data_Sptsd_FzShock=Data(Sptsd_FzShock);
Data_Sptsd_FzSafe=Data(Sptsd_FzSafe);

figure
plot(nanmean(runmean(Data_Sptsd_Fz(:,12:42),10)'))
vline(6780,'-r')
xlim([0 max(length(Data_Sptsd_Fz))])
text(3500,2e4,['Shock : ' num2str(nanmean(nanmean(runmean(Data_Sptsd_FzShock(:,12:42),5)')))])
text(8000,2e4,['Safe : ' num2str(nanmean(nanmean(runmean(Data_Sptsd_FzSafe(:,12:42),5)')))])
title('OB 20-55 power')
makepretty
xlabel('time (a.u.)'); ylabel('Power (a.u.)')

load('H_VHigh_Spectrum.mat')
Sptsd2 = tsd(Spectro{2}*1e4 , Spectro{1});

Sptsd2_Fz = Restrict(Sptsd2 , Behav.FreezeAccEpoch);
Sptsd2_FzShock = Restrict(Sptsd2 , and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1}));
Sptsd2_FzSafe = Restrict(Sptsd2 , and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5})));

figure
subplot(211)
imagesc(Range(Sptsd2_FzSafe) , Spectro{3} , Data(Sptsd2_FzSafe)'); axis xy
colormap jet
caxis([0 8e2]); ylim([100 250])
title('VHigh HPC')
subplot(212)
imagesc(Range(Sptsd_FzSafe) , Spectro{3} , Data(Sptsd_FzSafe)'); axis xy
colormap jet
caxis([0 4e4]); ylim([20 55])
title('OB gamma')
ylabel('Frequency (Hz)')

load('B_Low_Spectrum.mat')
Sptsd3 = tsd(Spectro{2}*1e4 , Spectro{1});

Sptsd3_Fz = Restrict(Sptsd3 , Behav.FreezeAccEpoch);
Sptsd3_FzShock = Restrict(Sptsd3 , and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1}));
Sptsd3_FzSafe = Restrict(Sptsd3 , and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5})));

figure
imagesc(Range(Sptsd3_Fz) , Spectro{3} , Data(Sptsd3_Fz)'); axis xy
colormap jet
caxis([0 5e5])
title('All Fz')


%% check other mice

