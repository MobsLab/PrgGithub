


cd('/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230227/')
load('LFPData/LFP35.mat')
load('SleepScoring_OBGamma.mat', 'REMEpoch', 'SWSEpoch', 'Wake', 'Epoch_S1', 'Epoch_S2')
load('B_Middle_Spectrum.mat')
NREM1 = and(SWSEpoch,Epoch_S2);
NREM2 = and(SWSEpoch,Epoch_S1);

Fil_LFP = FilterLFP(LFP,[.1 1],1024);
Phase=tsd(Range(Fil_LFP) , angle(hilbert(zscore(Data(Fil_LFP))))*180/pi+180);
Phase_Above_350=thresholdIntervals(Phase,350,'Direction','Above');
Sniff=ts((Stop(Phase_Above_350)+Start(Phase_Above_350))/2);
Sniff_Wake = Restrict(Sniff,Wake);
Sniff_NREM = Restrict(Sniff,SWSEpoch);
Sniff_NREM1 = Restrict(Sniff,NREM1);
Sniff_NREM2 = Restrict(Sniff,NREM2);
Sniff_REM = Restrict(Sniff,REMEpoch);

Stsd = tsd(Spectro{2}*1e4 , log10(Spectro{1}));
f = Spectro{3};

figure
subplot(3,4,[1 5])
[M,~,t]=AverageSpectrogram(Stsd,f,Sniff_Wake,50,250,0,.7,1);
imagesc(t/1E3,f,SmoothDec(M,2)), axis xy
xlim([0 5]), ylim([20 100]), caxis([3.5 6.2]), ylabel('Frequency (Hz)')
title('Wake')
makepretty

subplot(349)
plot(t/1E3, nanmean(M) , 'k' , 'LineWidth' , 2), xlim([0 5])
xlabel('time (s)'), ylabel('OB gamma power (a.u.)')
makepretty, ylim([4.1 4.8])

subplot(3,4,[2 6])
[M,~,t]=AverageSpectrogram(Stsd,f,Sniff_NREM1,50,250,0,5,1);
imagesc(t/1E3,f,SmoothDec(M,.7)), axis xy
xlim([0 5]), ylim([20 100]), caxis([3.5 6.2])
makepretty
title('NREM1')

subplot(3,4,10)
plot(t/1E3, nanmean(M) , 'k' , 'LineWidth' , 2), xlim([0 5])
xlabel('time (s)')
makepretty, ylim([4.1 4.8])

subplot(3,4,[3 7])
[M,~,t]=AverageSpectrogram(Stsd,f,Sniff_NREM2,50,250,0,5,1);
imagesc(t/1E3,f,SmoothDec(M,.7)), axis xy
xlim([0 5]), ylim([20 100]), caxis([3.5 6.2])
makepretty
title('NREM2')

subplot(3,4,11)
plot(t/1E3, nanmean(M) , 'k' , 'LineWidth' , 2), xlim([0 5])
xlabel('time (s)'), ylim([4.1 4.8])
makepretty

subplot(3,4,[4 8])
[M,~,t]=AverageSpectrogram(Stsd,f,Sniff_REM,50,250,0,5,1);
imagesc(t/1E3,f,SmoothDec(M,.7)), axis xy
xlim([0 5]), ylim([20 100]), caxis([3.5 6.2])
makepretty
title('REM')

subplot(3,4,12)
plot(t/1E3, nanmean(M) , 'k' , 'LineWidth' , 2), xlim([0 5])
xlabel('time (s)'), ylim([4.1 4.8])
makepretty

colormap jet





%%

cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20250103_LSP_saline')


cd('/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230227/')
load('LFPData/LFP105.mat')
load('SleepScoring_OBGamma.mat', 'REMEpoch', 'SWSEpoch', 'Wake', 'Epoch_S1', 'Epoch_S2')
load('B_Low_Spectrum.mat')
NREM1 = and(SWSEpoch,Epoch_S2);
NREM2 = and(SWSEpoch,Epoch_S1);

Fil_LFP = FilterLFP(LFP,[.1 1],1024);
Phase=tsd(Range(Fil_LFP) , angle(hilbert(zscore(Data(Fil_LFP))))*180/pi+180);
Phase_Above_350=thresholdIntervals(Phase,350,'Direction','Above');
Sniff=ts((Stop(Phase_Above_350)+Start(Phase_Above_350))/2);
Sniff_Wake = Restrict(Sniff,Wake);
Sniff_NREM = Restrict(Sniff,SWSEpoch);
Sniff_NREM1 = Restrict(Sniff,NREM1);
Sniff_NREM2 = Restrict(Sniff,NREM2);
Sniff_REM = Restrict(Sniff,REMEpoch);

Stsd = tsd(Spectro{2}*1e4 , log10(Spectro{1}));
f = Spectro{3};

figure
subplot(3,4,[1 5])
[M,~,t]=AverageSpectrogram(Stsd,f,Sniff_Wake,50,250,0,.7,1);
imagesc(t/1E3,f,SmoothDec(M,2)), axis xy
xlim([0 5]), ylim([0 10]), caxis([5 6.9]), ylabel('Frequency (Hz)')
title('Wake')
makepretty

subplot(349)
plot(t/1E3, movmean(nanmean(M([1:65],:)),5) , 'k' , 'LineWidth' , 2), xlim([0 5])
xlabel('time (s)'), ylabel('OB delta power (a.u.)')
makepretty, ylim([6.1 6.55])

subplot(3,4,[2 6])
[M,~,t]=AverageSpectrogram(Stsd,f,Sniff_NREM1,50,250,0,5,1);
imagesc(t/1E3,f,SmoothDec(M,.7)), axis xy
xlim([0 5]), ylim([0 10]), caxis([5 6.9])
makepretty
title('IS')

subplot(3,4,10)
plot(t/1E3, movmean(nanmean(M([1:65],:)),5) , 'k' , 'LineWidth' , 2), xlim([0 5])
xlabel('time (s)')
makepretty, ylim([6.1 6.55])

subplot(3,4,[3 7])
[M,~,t]=AverageSpectrogram(Stsd,f,Sniff_NREM2,50,250,0,5,1);
imagesc(t/1E3,f,SmoothDec(M,.7)), axis xy
xlim([0 5]), ylim([0 10]), caxis([5 6.9])
makepretty
title('NREM')

subplot(3,4,11)
plot(t/1E3, movmean(nanmean(M([1:65],:)),5) , 'k' , 'LineWidth' , 2), xlim([0 5])
xlabel('time (s)'), ylim([6.1 6.55])
makepretty

subplot(3,4,[4 8])
[M,~,t]=AverageSpectrogram(Stsd,f,Sniff_REM,50,250,0,5,1);
imagesc(t/1E3,f,SmoothDec(M,.7)), axis xy
xlim([0 5]), ylim([0 10]), caxis([5 6.9])
makepretty
title('REM')

subplot(3,4,12)
plot(t/1E3, movmean(nanmean(M([1:65],:)),5) , 'k' , 'LineWidth' , 2), xlim([0 5])
xlabel('time (s)'), ylim([6.1 6.55])
makepretty

colormap jet








%%
load('LFPData/LFP105.mat')
load('SleepScoring_OBGamma.mat', 'REMEpoch', 'SWSEpoch', 'Wake', 'Epoch_S1', 'Epoch_S2')
load('B_Low_Spectrum.mat')
NREM1 = and(SWSEpoch,Epoch_S2);
NREM2 = and(SWSEpoch,Epoch_S1);

Fil_LFP = FilterLFP(LFP,[.1 1],1024);
Phase=tsd(Range(Fil_LFP) , angle(hilbert(zscore(Data(Fil_LFP))))*180/pi+180);
Phase_Above_350=thresholdIntervals(Phase,350,'Direction','Above');
Sniff=ts((Stop(Phase_Above_350)+Start(Phase_Above_350))/2);
Sniff_Wake = Restrict(Sniff,Wake);
Sniff_NREM = Restrict(Sniff,SWSEpoch);
Sniff_NREM1 = Restrict(Sniff,NREM1);
Sniff_NREM2 = Restrict(Sniff,NREM2);
Sniff_REM = Restrict(Sniff,REMEpoch);

load('/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241211_TORCs/LFPData/LFP21.mat')
[M_sup_wake,T] = PlotRipRaw(LFP, Range(Sniff_Wake)/1e4, 1e3, 0, 1,1);
[M_sup_is,T] = PlotRipRaw(LFP, Range(Sniff_NREM1)/1e4, 1e3, 0, 1,1);
[M_sup_nrem,T] = PlotRipRaw(LFP, Range(Sniff_NREM2)/1e4, 1e3, 0, 1,1);
[M_sup_rem,T] = PlotRipRaw(LFP, Range(Sniff_REM)/1e4, 1e3, 0, 1,1);
load('/media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241211_TORCs/LFPData/LFP23.mat')
[M_deep_wake,T] = PlotRipRaw(LFP, Range(Sniff_Wake)/1e4, 1e3, 0, 1,1);
[M_deep_is,T] = PlotRipRaw(LFP, Range(Sniff_NREM1)/1e4, 1e3, 0, 1,1);
[M_deep_nrem,T] = PlotRipRaw(LFP, Range(Sniff_NREM2)/1e4, 1e3, 0, 1,1);
[M_deep_rem,T] = PlotRipRaw(LFP, Range(Sniff_REM)/1e4, 1e3, 0, 1,1);


figure
subplot(141)
plot(M_sup_wake(:,1) , M_sup_wake(:,2))
hold on
plot(M_sup_wake(:,1) , M_deep_wake(:,2))
ylim([-600 600])

subplot(142)
plot(M_sup_is(:,1) , M_sup_is(:,2))
hold on
plot(M_sup_is(:,1) , M_deep_is(:,2))
ylim([-600 600])

subplot(143)
plot(M_sup_nrem(:,1) , M_sup_nrem(:,2))
hold on
plot(M_sup_nrem(:,1) , M_deep_nrem(:,2))
ylim([-600 600])

subplot(144)
plot(M_sup_rem(:,1) , M_sup_rem(:,2))
hold on
plot(M_sup_rem(:,1) , M_deep_rem(:,2))
ylim([-600 600])







