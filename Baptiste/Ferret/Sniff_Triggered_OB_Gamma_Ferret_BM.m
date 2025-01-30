


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



subplot(245)
plot(nanmean(M) , 'k' , 'LineWidth' , 2)








