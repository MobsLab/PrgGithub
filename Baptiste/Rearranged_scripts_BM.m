

%% correlation matrices
edit 



 


%% Cortical analyses
% load('Ref_Low_Spectrum.mat')
load('H_Low_Spectrum.mat')
figure
imagesc(Spectro{2} , Spectro{3} , log10(Spectro{1})'), axis xy, caxis([.5 5])
makepretty
xlabel('time (s)'), ylabel('Frequency (Hz)')
Hypnogram_LineColor_BM(19)
title('Cortical spectrogram, OB sleep scoring')

figure
subplot(211)
imagesc(Spectro{2} , Spectro{3} , log10(Spectro{1})'), axis xy, caxis([.5 5])
Hypnogram_LineColor_BM(19)
load('LFPData/LFP0.mat')
load('StateEpochSB.mat', 'ThetaEpoch','Sleep','Epoch','Wake')
val=1;
t=Range(LFP);
begin=t(1)/(val*1e4);
endin=t(end)/(val*1e4);
thr=18;

line([begin endin],[thr thr],'linewidth',10,'color','w')
sleepstart=Start(and(ThetaEpoch,Sleep));
sleepstop=Stop(and(ThetaEpoch,Sleep));
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4)/1e4 sleepstop(k)/(val*1e4)],[thr thr],'color','g','linewidth',5);
end
sleepstart=Start(and(Epoch-ThetaEpoch,Sleep));
sleepstop=Stop(and(Epoch-ThetaEpoch,Sleep));
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','r','linewidth',5);
end
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','b','linewidth',5);
end
ylabel('Frequency (Hz)')
title('Cortical spectrogram')



load('B_UltraLow_Spectrum.mat')
subplot(212)
imagesc(Spectro{2} , Spectro{3} , log10(Spectro{1})'), axis xy, caxis([2.5 5])
Hypnogram_LineColor_BM(.95)
val=1;
t=Range(LFP);
begin=t(1)/(val*1e4);
endin=t(end)/(val*1e4);
thr=.9;

line([begin endin],[thr thr],'linewidth',10,'color','w')
sleepstart=Start(and(ThetaEpoch,Sleep));
sleepstop=Stop(and(ThetaEpoch,Sleep));
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4)/1e4 sleepstop(k)/(val*1e4)],[thr thr],'color','g','linewidth',5);
end
sleepstart=Start(and(Epoch-ThetaEpoch,Sleep));
sleepstop=Stop(and(Epoch-ThetaEpoch,Sleep));
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','r','linewidth',5);
end
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','b','linewidth',5);
end
xlabel('time (s)'), ylabel('Frequency (Hz)')
title('OB ultra low spectrogram')


a=suptitle('Compared scoring for S1/S2 based on cortical or OB activity'); a.FontSize=20;


%% mean spectrum OB S1/S2
load('B_Low_Spectrum.mat')
Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});

OB_Wake = Restrict(Sp_tsd , Wake);
OB_REM = Restrict(Sp_tsd , and(Sleep,Epoch_01_05));
OB_NREM = Restrict(Sp_tsd , and(Sleep,(Sleep-Epoch_01_05)));


figure
plot(Spectro{3} , nanmean(Data(OB_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(OB_NREM)),'g')
plot(Spectro{3} , nanmean(Data(OB_REM)),'r')
ylabel('Power (a.u.)'), xlabel('Frequency (Hz)')
makepretty
legend('Wake','S1','S2')
title('OB mean spectrum, sleep session')



%% Accelerometer spectrogram
load('behavResources.mat', 'MovAcctsd')
MovAcctsd_Wake = Restrict(MovAcctsd , Wake);
MovAcctsd_Sleep = Restrict(MovAcctsd , Sleep);
smootime = 1;

clear A
A = log(Data(MovAcctsd));
A(A==-Inf) = 0;
A = runmean(A , ceil(smootime/median(diff(Range(MovAcctsd,'s')))));
A = A-nanmean(A);
% plot(Range(MovAcctsd,'s') , A)
MovAcctsd_corr = A;

[params,movingwin,suffix]=SpectrumParametersBM('ultralow_bm'); % low or high
params.Fs = 50;
[Sp,t,f]=mtspecgramc(MovAcctsd_corr,movingwin,params);
Spectro={Sp,t,f};
save('Accelero_All_Spectrum.mat','Spectro','-v7.3')


clear B
B = log(Data(MovAcctsd_Wake));
B(B==-Inf) = 0;
B = runmean(B , ceil(smootime/median(diff(Range(MovAcctsd,'s')))));
B = B-nanmean(B);
MovAcctsd_Wake_corr = B;

[params,movingwin,suffix]=SpectrumParametersBM('ultralow_bm'); % low or high
params.Fs = 50;
[Sp,t,f]=mtspecgramc(MovAcctsd_Wake_corr,movingwin,params);
Spectro={Sp,t,f};
save('Accelero_Wake_Spectrum.mat','Spectro','-v7.3')


clear C
C = log(Data(MovAcctsd_Sleep));
C(C==-Inf) = 0;
C = runmean(C , ceil(smootime/median(diff(Range(MovAcctsd,'s')))));
C = C-nanmean(C);
MovAcctsd_Sleep_corr = C;

[params,movingwin,suffix]=SpectrumParametersBM('ultralow_bm'); % low or high
params.Fs = 50;
[Sp,t,f]=mtspecgramc(MovAcctsd_Sleep_corr,movingwin,params);
Spectro={Sp,t,f};
save('Accelero_Sleep_Spectrum.mat','Spectro','-v7.3')


load('Accelero_All_Spectrum.mat')
Sp_Acc_All = Spectro{1};
load('Accelero_Wake_Spectrum.mat')
Sp_Acc_Wake = Spectro{1};
load('Accelero_Sleep_Spectrum.mat')
Sp_Acc_Sleep = Spectro{1};


figure
subplot(311)
imagesc(Spectro{2}/60 , Spectro{3} , log10(Sp_Acc_All)'), axis xy,% caxis([0 .01])
subplot(312)
imagesc(Spectro{2}/60 , Spectro{3} , log10(Sp_Acc_Wake)'), axis xy, %caxis([0 .01])
subplot(313)
imagesc(Spectro{2}/60 , Spectro{3} , log10(Sp_Acc_Sleep)'), axis xy, %caxis([0 .01])

figure
subplot(131)
plot(Spectro{3} , Spectro{3}.*nanmean(Sp_Acc_All))
makepretty
xlabel('Frequency (Hz)')
ylabel('Power (a.u.)')
vline(0.685,'--r')

subplot(132)
plot(Spectro{3} , Spectro{3}.*nanmean(Sp_Acc_Wake))
makepretty
xlabel('Frequency (Hz)')
vline(0.695,'--r')

subplot(133)
plot(Spectro{3} , Spectro{3}.*nanmean(Sp_Acc_Sleep))
makepretty
xlabel('Frequency (Hz)')
vline(0.6683,'--r')
vline(0.769,'--r')


%% Breathing spectrogram from piezzo
Breathing_tsd_corr = tsd(Range(Breathing_tsd) , zscore(Data(Breathing_tsd)));
Breathing_Sleep_corr = Restrict(Breathing_tsd_corr , Sleep);
Breathing_Wake_corr = Restrict(Breathing_tsd_corr , Wake);

[params,movingwin,suffix]=SpectrumParametersBM('ultralow_bm'); 
[Sp,t,f]=mtspecgramc(Data(Breathing_tsd_corr),movingwin,params);
Spectro={Sp,t,f};
save('Respi_Low_Spectrum.mat','Spectro','ch','-v7.3')

figure
imagesc(t,f,10*log10(Sp)'), axis xy
caxis([-12 3])
xlabel('time (h)'), ylabel('Frequency (Hz)')
a=colorbar; a.Ticks=[-12 3]; a.TickLabels={'0','1'}; a.Label.String='Power (a.u.)'; a.Label.FontSize=15;
makepretty
Hypnogram_LineColor_BM(.95)

title('Breathing spectrogram from piezzo, head restraint session')



% temporal evolution
load('InstFreqAndPhase_B.mat')
Respi_smooth = tsd(Range(LocalFreq.PT) , runmean(Data(LocalFreq.PT),10));
Respi_smooth_Wake = Restrict(Respi_smooth , Wake);
Respi_smooth_Sleep = Restrict(Respi_smooth , Sleep);

figure
subplot(1,7,1:6)
plot(Range(Respi_smooth_Wake,'s') , Data(Respi_smooth_Wake) , 'b')
hold on
plot(Range(Respi_smooth_Sleep,'s') , Data(Respi_smooth_Sleep) , 'r')
ylabel('Frequency (Hz)'), xlabel('time (s)')
legend('Wake','Sleep')
title('Breathing evolution')

subplot(177)
u=bar([nanmean(Data(Respi_smooth_Wake)) nanmean(Data(Respi_smooth_Sleep))]); u.FaceColor = 'flat'; u.CData = [0 0 1 ; 1 0 0];
xticklabels({'Wake','Sleep'})
ylabel('Frequency (Hz)')
title('Breathing mean value')


a=suptitle('Breathing activity, head restraint session'); a.FontSize=20;



%% Phase locking of alpha
channel=5; clear P_Mobile P_Immobile
figure
[P_Mobile,f,VBinnedPhase] = PrefPhaseSpectrum(LFP_Mobile , Data(OB_Low_Mobile.(Channel{channel})) , Range(OB_Low_Mobile.(Channel{channel}),'s') , range_Low , [1 8] , 30); close

figure
[P_Immobile,f,VBinnedPhase] = PrefPhaseSpectrum(LFP_Immobile , Data(OB_Low_Immobile.(Channel{channel})) , Range(OB_Low_Immobile.(Channel{channel}),'s') , range_Low , [1 8] , 30); close
close

figure
subplot(121)
imagesc([VBinnedPhase VBinnedPhase+354] , f , f'.*[P_Mobile ; P_Mobile]'); axis xy; 
caxis([7e4 12e4]); ylim([10 20])
colormap jet
ylabel('Frequency (Hz)'); xlabel('Phase (degrees)')
title('Mobile')
colorbar

subplot(122)
imagesc([VBinnedPhase VBinnedPhase+354] , f , f'.*[P_Immobile ; P_Immobile]'); axis xy; 
caxis([5e4 11e4]); ylim([10 20])
colormap jet
ylabel('Frequency (Hz)'); xlabel('Phase (degrees)')
title('Immobile')
colorbar

title_f = sgtitle('Phase-locking of alpha range');
title_f.FontSize = 20;



%% Phase Preference
channel=1;
figure
[P_Mobile,f,VBinnedPhase] = PrefPhaseSpectrum(LFP_Mobile , Data(OB_Middle_Mobile.(Channel{channel})) , Range(OB_Middle_Mobile.(Channel{channel}),'s') , range_Middle , [1 8] , 30); close

figure
[P_Immobile,f,VBinnedPhase] = PrefPhaseSpectrum(LFP_Immobile , Data(OB_Middle_Immobile.(Channel{channel})) , Range(OB_Middle_Immobile.(Channel{channel}),'s') , range_Middle , [1 8] , 30); close
close

figure
subplot(121)
imagesc([VBinnedPhase VBinnedPhase+354] , f , [P_Mobile ; P_Mobile]'); axis xy; 
caxis([0 11e3]); ylim([20 100])
colormap jet
ylabel('Frequency (Hz)'); xlabel('Phase (degrees)')
title('Mobile')
colorbar

subplot(122)
imagesc([VBinnedPhase VBinnedPhase+354] , f , [P_Immobile ; P_Immobile]'); axis xy; 
caxis([0 11e3]); ylim([20 100])
colormap jet
ylabel('Frequency (Hz)'); xlabel('Phase (degrees)')
title('Immobile')
colorbar

f_title = sgtitle('Phase preference, 1-8 Hz');
f_title.FontSize = 20;



%% Breathing mean waveform
Breathing_tsd = LFP;
Breathing_Sleep = Restrict(Breathing_tsd , Sleep);
Breathing_Wake = Restrict(Breathing_tsd , Wake);
Breathing_S1 = Restrict(Breathing_tsd , S1_epoch);
Breathing_S2 = Restrict(Breathing_tsd , S2_epoch);

AllPeaks_corr = AllPeaks(1:2:end,1);
AllPeaks_ts = ts(AllPeaks_corr*1e4);
AllPeaks_Sleep = Restrict(AllPeaks_ts , Sleep);
AllPeaks_Wake = Restrict(AllPeaks_ts , Wake);
AllPeaks_S1 = Restrict(AllPeaks_ts , S1_epoch);
AllPeaks_S2 = Restrict(AllPeaks_ts , S2_epoch);


[M_all,T_all] = PlotRipRaw(Breathing_tsd , AllPeaks_corr, 2e3, 0 , 0);
[M_sleep,T_sleep] = PlotRipRaw(Breathing_Sleep , Range(AllPeaks_Sleep)/1e4, 2e3, 0 , 0);
[M_wake,T_wake] = PlotRipRaw(Breathing_Wake , Range(AllPeaks_Wake)/1e4, 2e3, 0 , 0);
[M_S1,T_S1] = PlotRipRaw(Breathing_S1 , Range(AllPeaks_S1)/1e4, 2e3, 0 , 0);
[M_S2,T_S2] = PlotRipRaw(Breathing_S2 , Range(AllPeaks_S2)/1e4, 2e3, 0 , 0);


figure
Conf_Inter=nanstd(T_sleep)/sqrt(size(T_sleep,1));
h=shadedErrorBar(M_sleep(:,1)' , nanmean(T_sleep) , Conf_Inter ,'-r',1); hold on;
Conf_Inter=nanstd(T_wake)/sqrt(size(T_wake,1));
h=shadedErrorBar(M_wake(:,1)' , nanmean(T_wake) , Conf_Inter ,'-b',1); hold on;
makepretty
xlabel('time (s)')
ylabel('amplitude (a.u.)')
f=get(gca,'Children'); legend([f(5),f(1)],'Sleep','Wake');
ylim([7e3 9e3])
title('Mean breathing waveform, head restraint session')


%% Phase pref
% OB Ultra Low
load('B_UltraLow_Spectrum.mat')
OB_UL_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
OB_UL_Sptsd_Sleep = Restrict(OB_UL_Sptsd , Sleep);
OB_UL_Sptsd_Wake = Restrict(OB_UL_Sptsd , Wake);

[P_sleep,f,VBinnedPhase] = PrefPhaseSpectrum(Breathing_Sleep_corr , Data(OB_UL_Sptsd_Sleep) , Range(OB_UL_Sptsd_Sleep,'s') , Spectro{3} , [.1 1] , 30); close
[P_wake,f,VBinnedPhase] = PrefPhaseSpectrum(Breathing_Wake_corr , Data(OB_UL_Sptsd_Wake) , Range(OB_UL_Sptsd_Wake,'s') , Spectro{3} , [.1 1] , 30); close


figure
subplot(121)
imagesc([VBinnedPhase VBinnedPhase+360] , f , log(runmean([P_wake' P_wake']',3)')); axis xy
xlabel('Phase (degrees)'), ylabel('Frequency(Hz)')
makepretty
caxis([9 11])
title('Wake')

subplot(122)
imagesc([VBinnedPhase VBinnedPhase+360] , f , log(runmean([P_sleep' P_sleep']',3)')); axis xy
xlabel('Phase (degrees)')
caxis([9 11])
title('Sleep')
makepretty
a=colorbar; a.Ticks=[1e4 1.8e4]; a.TickLabels={'0','1'}; a.Label.String='Power (a.u.)'; a.Label.FontSize=15;

colormap jet
a=suptitle('OB very low frequency phase preference on breathing phase'); a.FontSize=20;


% OB Low
load('B_Low_Spectrum.mat')
OB_Low_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
OB_Low_Sptsd_Sleep = Restrict(OB_Low_Sptsd , Sleep);
OB_Low_Sptsd_Wake = Restrict(OB_Low_Sptsd , Wake);


[P_sleep,f,VBinnedPhase] = PrefPhaseSpectrum(Breathing_Sleep_corr , Data(OB_Low_Sptsd_Sleep) , Range(OB_Low_Sptsd_Sleep,'s') , Spectro{3} , [.1 1] , 30); close
[P_wake,f,VBinnedPhase] = PrefPhaseSpectrum(Breathing_Wake_corr , Data(OB_Low_Sptsd_Wake) , Range(OB_Low_Sptsd_Wake,'s') , Spectro{3} , [.1 1] , 30); close


figure
subplot(223)
imagesc([VBinnedPhase VBinnedPhase+360] , f , runmean([P_wake' P_wake']',3)'); axis xy
ylabel('Frequency(Hz)'), xlabel('Phase (degrees)'), 
makepretty
caxis([1e4 4e4]), ylim([0 5])

subplot(224)
imagesc([VBinnedPhase VBinnedPhase+360] , f , runmean([P_sleep' P_sleep']',3)'); axis xy
caxis([1e4 4e4]), ylim([0 5]), xlabel('Phase (degrees)'), 
makepretty

subplot(221)
imagesc([VBinnedPhase VBinnedPhase+360] , f , runmean([P_wake' P_wake']',3)'); axis xy
ylabel('Frequency(Hz)')
makepretty
caxis([3e3 8e3]), ylim([5 20])
title('Wake')

subplot(222)
imagesc([VBinnedPhase VBinnedPhase+360] , f , runmean([P_sleep' P_sleep']',3)'); axis xy
caxis([3e3 8e3]), ylim([5 20])
title('Sleep')
makepretty
a=colorbar; a.Ticks=[1e4 4e4]; a.TickLabels={'0','1'}; a.Label.String='Power (a.u.)'; a.Label.FontSize=15;

colormap jet
a=suptitle('OB low frequency phase preference on breathing phase'); a.FontSize=20;



% OB Middle
load('B_Middle_Spectrum.mat')
OB_Middle_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1}());
OB_Middle_Sptsd_Sleep = Restrict(OB_Middle_Sptsd , Sleep);

[P_sleep,f,VBinnedPhase] = PrefPhaseSpectrum(Breathing_Sleep_corr , Data(OB_Middle_Sptsd_Sleep) , Range(OB_Middle_Sptsd_Sleep,'s') , Spectro{3} , [.1 1] , 30); close
[P_wake,f,VBinnedPhase] = PrefPhaseSpectrum(Breathing_Wake_corr , Data(OB_Middle_Sptsd_Wake) , Range(OB_Middle_Sptsd_Wake,'s') , Spectro{3} , [.1 1] , 30); close


figure
subplot(121)
imagesc([VBinnedPhase VBinnedPhase+360] , f , runmean([P_wake' P_wake']',3)'); axis xy
xlabel('Phase (degrees)'), ylabel('Frequency(Hz)')
makepretty
caxis([0 7e3]), ylim([20 100])
title('Wake')

subplot(122)
imagesc([VBinnedPhase VBinnedPhase+360] , f , runmean([P_sleep' P_sleep']',3)'); axis xy
xlabel('Phase (degrees)')
caxis([0 7e3]), ylim([20 100])
title('Sleep')
makepretty
a=colorbar; a.Ticks=[1e4 4e4]; a.TickLabels={'0','1'}; a.Label.String='Power (a.u.)'; a.Label.FontSize=15;

colormap jet
a=suptitle('OB High frequency phase preference on breathing phase'); a.FontSize=20;



% Gamma during states
OB_Middle = load('B_Middle_Spectrum.mat'); OB_Middle_tsd = tsd(OB_Middle.Spectro{2}*1e4 , OB_Middle.Spectro{1});

OB_Middle_Wake = Restrict(OB_Middle_tsd,Wake);
OB_Middle_SWS = Restrict(OB_Middle_tsd,SWSEpoch);
OB_Middle_REM = Restrict(OB_Middle_tsd,REMEpoch);



figure
plot(OB_Middle.Spectro{3} , log10(nanmean(Data(OB_Middle_Wake))) , 'b')
hold on
plot(OB_Middle.Spectro{3} , log10(nanmean(Data(OB_Middle_SWS))) , 'r')
plot(OB_Middle.Spectro{3} , log10(nanmean(Data(OB_Middle_REM))) , 'g')






