%% Physio by states
cd('/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230227/')
load('SleepScoring_OBGamma.mat', 'Wake', 'SWSEpoch', 'REMEpoch', 'TotalNoiseEpoch', 'Epoch')
Wake = or(Wake , TotalNoiseEpoch);
REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);
Wake = mergeCloseIntervals(Wake,3e4);
Wake = dropShortIntervals(Wake,3e4);
TotDur = sum(DurationEpoch(or(Epoch,TotalNoiseEpoch)))./3.6e7;

% Breathing Piezzo, frequency and variability
P = load('Piezzo_ULow_Spectrum.mat');
Sptsd = tsd(P.Spectro{2}*1e4 , P.Spectro{1});
[Sptsd_clean,~,EpochClean] = CleanSpectro(Sptsd , P.Spectro{3} , 8);

Piezzo_Wake  = Restrict(Sptsd_clean , Wake);
Piezzo_NREM  = Restrict(Sptsd_clean , SWSEpoch);
Piezzo_REM  = Restrict(Sptsd_clean , REMEpoch);

Spectrum_Frequency = ConvertSpectrum_in_Frequencies_BM(P.Spectro{3} , Range(Sptsd_clean) , Data(Sptsd_clean) , 'frequency_band' , [.25 1]);
Breathing_var = tsd(Range(Spectrum_Frequency) , movstd(Data(Spectrum_Frequency) , ceil(30/median(diff(Range(Spectrum_Frequency,'s')))),'omitnan'));

Breathing_Wake  = Restrict(Spectrum_Frequency , Wake);
Breathing_NREM  = Restrict(Spectrum_Frequency , SWSEpoch);
Breathing_REM  = Restrict(Spectrum_Frequency , REMEpoch);

Breathing_var_Wake = Restrict(Breathing_var , Wake);
Breathing_var_NREM = Restrict(Breathing_var , SWSEpoch);
Breathing_var_REM = Restrict(Breathing_var , REMEpoch);


figure
imagesc(Range(Sptsd_clean)/3.6e7 , P.Spectro{3} , runmean(runmean(log10(Data(Sptsd_clean)'),5)',50)'), axis xy
ylabel('Frequency (Hz)')
colormap viridis, caxis([-1.8 -.5])


figure
plot(P.Spectro{3} , nanmean(Data(Piezzo_Wake)) , 'b')
hold on
plot(P.Spectro{3} , nanmean(Data(Piezzo_NREM)) , 'r')
plot(P.Spectro{3} , nanmean(Data(Piezzo_REM)) , 'g')


figure
[Y,X]=hist(Data(Breathing_var_Wake),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'b','LineWidth',1)
hold on
[Y,X]=hist(Data(Breathing_var_NREM),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'r','LineWidth',1)
[Y,X]=hist(Data(Breathing_var_REM),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'g','LineWidth',1)
xlabel('Breathing variability (a.u.)'), ylabel('PDF')
box off,% xlim([1.5 6])
legend('Wake','NREM','REM')


% Breathing power var
load('LFPData/LFP35.mat')
FilLFP = FilterLFP(LFP,[.1 1],1024);
BreathingPower = tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
BreathingPower_var = tsd(Range(BreathingPower) , movstd(Data(BreathingPower) , ceil(30/median(diff(Range(FilLFP,'s'))))));

BreathingPower_var_Wake = Restrict(BreathingPower_var , Wake);
BreathingPower_var_NREM = Restrict(BreathingPower_var , SWSEpoch);
BreathingPower_var_REM = Restrict(BreathingPower_var , REMEpoch);

figure
plot(Range(BreathingPower_var_Wake,'s')/3600 , log10(Data(BreathingPower_var_Wake)) , '.b')
hold on
plot(Range(BreathingPower_var_NREM,'s')/3600 , log10(Data(BreathingPower_var_NREM)) , '.r')
plot(Range(BreathingPower_var_REM,'s')/3600 , log10(Data(BreathingPower_var_REM)) , '.g')


figure
[Y,X]=hist(log10(Data(BreathingPower_var_Wake)),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'b','LineWidth',1)
hold on
[Y,X]=hist(log10(Data(BreathingPower_var_NREM)),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'r','LineWidth',1)
[Y,X]=hist(log10(Data(BreathingPower_var_REM)),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'g','LineWidth',1)
xlabel('Breathing variability (a.u.)'), ylabel('PDF')
box off,% xlim([1.5 6])
legend('Wake','NREM','REM')


% EKG
load('HeartBeatInfo.mat', 'EKG')
HRVar = tsd(Range(EKG.HBRate) , movstd(Data(EKG.HBRate),5));

HR_Wake  = Restrict(EKG.HBRate , Wake);
HR_NREM  = Restrict(EKG.HBRate , SWSEpoch);
HR_REM  = Restrict(EKG.HBRate , REMEpoch);

HRVar_Wake  = Restrict(HRVar , Wake);
HRVar_NREM  = Restrict(HRVar , SWSEpoch);
HRVar_REM  = Restrict(HRVar , REMEpoch);


figure
subplot(211)
plot(Range(HR_Wake,'s')/3600 , Data(HR_Wake) , '.b')
hold on
plot(Range(HR_NREM,'s')/3600 , Data(HR_NREM) , '.r')
plot(Range(HR_REM,'s')/3600 , Data(HR_REM) , '.g')

subplot(212)
plot(Range(HRVar_Wake,'s')/3600 , log10(Data(HRVar_Wake)) , '.b')
hold on
plot(Range(HRVar_NREM,'s')/3600 , log10(Data(HRVar_NREM)) , '.r')
plot(Range(HRVar_REM,'s')/3600 , log10(Data(HRVar_REM)) , '.g')
ylim([-2.5 1])

figure
subplot(121)
[Y,X]=hist(Data(HR_Wake),100);
Y=Y/sum(Y);
plot(X,Y,'b','LineWidth',1)
hold on
[Y,X]=hist(Data(HR_NREM),100);
Y=Y/sum(Y);
plot(X,Y,'r','LineWidth',1)
[Y,X]=hist(Data(HR_REM),100);
Y=Y/sum(Y);
plot(X,Y,'g','LineWidth',1)
xlabel('Heart rate (Hz)'), ylabel('PDF')
box off, xlim([2 7])
legend('Wake','NREM','REM')

subplot(122)
[Y,X]=hist(log10(Data(HRVar_Wake)),200);
Y=Y/sum(Y);
plot(X,Y,'b','LineWidth',1)
hold on
[Y,X]=hist(log10(Data(HRVar_NREM)),200);
Y=Y/sum(Y);
plot(X,Y,'r','LineWidth',1)
[Y,X]=hist(log10(Data(HRVar_REM)),200);
Y=Y/sum(Y);
plot(X,Y,'g','LineWidth',1)
xlabel('Heart rate variability (a.u.)')
box off, xlim([-3 1])



% no more sinus arythmia
D = diff(Data(EKG.HBTimes)/1e4); D(or(D>.5 , D<.1458))=NaN;
R = Range(EKG.HBTimes); R(or(D>.5 , D<.1458))=NaN;
TSD = tsd(R(2:end) , D);

TSD_Wake = Restrict(TSD , Wake);
TSD_NREM = Restrict(TSD , SWSEpoch);
TSD_REM = Restrict(TSD , REMEpoch);

figure
plot(Range(TSD_Wake,'s')/3600 , Data(TSD_Wake) , '.b')
hold on
plot(Range(TSD_NREM,'s')/3600 , Data(TSD_NREM) , '.r')
plot(Range(TSD_REM,'s')/3600 , Data(TSD_REM) , '.g')




figure
[Y,X]=hist(Data(TSD_Wake),300);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'b','LineWidth',1)
hold on
[Y,X]=hist(Data(TSD_NREM),300);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'r','LineWidth',1)
[Y,X]=hist(Data(TSD_REM),300);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'g','LineWidth',1)
xlabel('EMG power (log scale)'), ylabel('PDF')
box off, xlim([1.5 6])
legend('Wake','NREM','REM')



y = skewness(Data(TSD_Wake))
y = skewness(Data(TSD_NREM))
y = skewness(Data(TSD_REM))



%% Gamma OB/PFC lag
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline')
load('SleepScoring_OBGamma.mat', 'Wake')

load('LFPData/LFP11.mat')
FilGamma = FilterLFP(LFP,[40 60],1024);
tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) ); 
smootime=.06;
SmoothGamma_OB = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
    ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));

load('LFPData/LFP13.mat')
FilGamma = FilterLFP(LFP,[40 60],1024);
tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) ); 
SmoothGamma_PFC = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
    ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));

SmoothGamma_OB_Wake = Restrict(SmoothGamma_OB , Wake);
[c,lags] = xcorr(zscore(Data(SmoothGamma_OB_Wake)) , zscore(Data(Restrict(SmoothGamma_PFC,SmoothGamma_OB_Wake))) , 1250 , 'biased');

figure
plot(linspace(-1,1,2501) , c , 'b' , 'LineWidth' , 2)
xlabel('lag (s)'), ylabel('Corr values (a.u.)'), xlim([-1 1])
box off
vline(0,'--r')


%% corr OB gamma / Breathing
cd('/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230227/')
load('SleepScoring_OBGamma.mat', 'SWSEpoch', 'REMEpoch' , 'Wake')
REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);

load('LFPData/LFP26.mat')
FilGamma = FilterLFP(LFP,[40 60],1024);
tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) ); 
smootime=.06;
SmoothGamma = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
    ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));


FilULow = FilterLFP(LFP,[.1 1],1024); 
tEnveloppeULow = tsd(Range(LFP), abs(hilbert(Data(FilULow))) ); 
smootime=.006;
SmoothULow = tsd(Range(tEnveloppeULow), runmean(Data(tEnveloppeULow), ...
    ceil(smootime/median(diff(Range(tEnveloppeULow,'s'))))));


figure
plot(Range(SmoothULow,'s') , Data(SmoothULow))
hold on
plot(Range(SmoothGamma,'s') , Data(SmoothGamma))
xlim([8249 8259])


[c_all,lags] = xcorr(Data(SmoothULow) , Data(Restrict(SmoothGamma,SmoothULow)) , 3750);
SmoothULow_Wake = Restrict(SmoothULow , Wake);
[c_wake,lags] = xcorr(Data(SmoothULow_Wake) , Data(Restrict(SmoothGamma,SmoothULow_Wake)) , 3750 , 'biased');
SmoothULow_NREM = Restrict(SmoothULow , SWSEpoch);
[c_nrem,lags] = xcorr(Data(SmoothULow_NREM) , Data(Restrict(SmoothGamma,SmoothULow_NREM)) , 3750 , 'biased');
SmoothULow_REM = Restrict(SmoothULow , REMEpoch);
[c_rem,lags] = xcorr(Data(SmoothULow_REM) , Data(Restrict(SmoothGamma,SmoothULow_REM)) , 3750 , 'biased');


figure
subplot(121)
plot(linspace(-3,3,7501) , c_wake , 'b' , 'LineWidth' , 2)
hold on
plot(linspace(-3,3,7501) , c_nrem , 'r' , 'LineWidth' , 2)
plot(linspace(-3,3,7501) , c_rem , 'g' , 'LineWidth' , 2)
vline(0,'--r')
xlabel('lag (s)'), ylabel('Corr values (a.u.)'), xlim([-3 3])
box off

SmoothULow_Wake = Restrict(SmoothULow , Wake);
[c_wake,lags] = xcorr(zscore(Data(SmoothULow_Wake)) , zscore(Data(Restrict(SmoothGamma,SmoothULow_Wake))) , 3750 , 'biased');
SmoothULow_NREM = Restrict(SmoothULow , SWSEpoch);
[c_nrem,lags] = xcorr(zscore(Data(SmoothULow_NREM)) , zscore(Data(Restrict(SmoothGamma,SmoothULow_NREM))) , 3750 , 'biased');
SmoothULow_REM = Restrict(SmoothULow , REMEpoch);
[c_rem,lags] = xcorr(zscore(Data(SmoothULow_REM)) , zscore(Data(Restrict(SmoothGamma,SmoothULow_REM))) , 3750 , 'biased');

subplot(122)
plot(linspace(-3,3,7501) , c_wake , 'b' , 'LineWidth' , 2)
hold on
plot(linspace(-3,3,7501) , c_nrem , 'r' , 'LineWidth' , 2)
plot(linspace(-3,3,7501) , c_rem , 'g' , 'LineWidth' , 2)
vline(0,'--r')
xlabel('lag (s)'), ylabel('Corr values (a.u.)'), xlim([-3 3])
box off




%% ongoing



cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline/')
load('SleepScoring_OBGamma.mat','Wake', 'Sleep', 'SWSEpoch', 'REMEpoch')

H_Low = load('H_Low_Spectrum.mat');
H_Low_Sptsd = tsd(H_Low.Spectro{2}*1e4 , H_Low.Spectro{1});
H_Low_Sptsd_Sleep = Restrict(H_Low_Sptsd , Sleep);
H_Low_Sptsd_NREM = Restrict(H_Low_Sptsd , SWSEpoch);

B_Low = load('B_Low_Spectrum.mat');
B_Low_Sptsd = tsd(B_Low.Spectro{2}*1e4 , B_Low.Spectro{1});
B_Low_Sptsd_Sleep = Restrict(B_Low_Sptsd , Sleep);
B_Low_Sptsd_NREM = Restrict(B_Low_Sptsd , SWSEpoch);

B_UltraLow = load('B_UltraLow_Spectrum.mat');
B_UltraLow_Sptsd = tsd(B_UltraLow.Spectro{2}*1e4 , B_UltraLow.Spectro{1});
B_UltraLow_Sptsd_Sleep = Restrict(B_UltraLow_Sptsd , Sleep);
B_UltraLow_Sptsd_NREM = Restrict(B_UltraLow_Sptsd , SWSEpoch);

B_High = load('B_Middle_Spectrum.mat');
B_High_Sptsd = tsd(B_High.Spectro{2}*1e4 , B_High.Spectro{1});
B_High_Sptsd_Sleep = Restrict(B_High_Sptsd , Sleep);
B_High_Sptsd_NREM = Restrict(B_High_Sptsd , SWSEpoch);

P_Low = load('PFCx_Low_Spectrum.mat');
P_Low_Sptsd = tsd(P_Low.Spectro{2}*1e4 , P_Low.Spectro{1});
P_Low_Sptsd_Sleep = Restrict(P_Low_Sptsd , Sleep);
P_Low_Sptsd_NREM = Restrict(P_Low_Sptsd , SWSEpoch);


load('B_Low_Spectrum.mat')



figure
subplot(511)
imagesc(B_High.Spectro{2}/60 , B_High.Spectro{3} , runmean(runmean(log10(B_High.Spectro{1}'),1)',1e2)'), axis xy
ylim([20 100]), caxis([1.8 4])
colormap jet
PlotPerAsLine(Wake,95,'b','timescaling',60e4);
PlotPerAsLine(SWSEpoch,95,'r','timescaling',60e4);
PlotPerAsLine(REMEpoch,95,'g','timescaling',60e4);

subplot(512)
imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10(H_Low.Spectro{1}'),1)',1e2)'), axis xy
ylim([0 10]), caxis([1.5 4])

subplot(513)
imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10(P_Low.Spectro{1}'),1)',1e2)'), axis xy
ylim([0 10]), caxis([1.5 4])

subplot(514)
imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10(B_Low.Spectro{1}'),1)',1e2)'), axis xy
ylim([0 10]), caxis([2.5 4])

subplot(515)
imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10(B_UltraLow.Spectro{1}'),1)',15)'), axis xy
caxis([1.8 4])



figure
subplot(511)
imagesc(Range(B_High_Sptsd_Sleep,'s')/60 , B_High.Spectro{3} , runmean(runmean(log10(Data(B_High_Sptsd_Sleep)'),1)',1e2)'), axis xy
ylim([20 100]), caxis([1.8 4])
colormap jet

subplot(512)
imagesc(Range(H_Low_Sptsd_Sleep,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(H_Low_Sptsd_Sleep)'),1)',1e2)'), axis xy
ylim([0 10]), caxis([1.5 4.5])

subplot(513)
imagesc(Range(P_Low_Sptsd_Sleep,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(P_Low_Sptsd_Sleep)'),1)',1e2)'), axis xy
ylim([0 10]), caxis([1.5 4])

subplot(514)
imagesc(Range(B_Low_Sptsd_Sleep,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(B_Low_Sptsd_Sleep)'),1)',1e2)'), axis xy
ylim([0 10]), caxis([2.5 4])

subplot(515)
imagesc(Range(B_UltraLow_Sptsd_Sleep,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(B_UltraLow_Sptsd_Sleep)'),1)',15)'), axis xy
caxis([1.8 4])




figure
subplot(511)
imagesc(Range(B_High_Sptsd_NREM,'s')/60 , B_High.Spectro{3} , runmean(runmean(log10(Data(B_High_Sptsd_NREM)'),1)',1e2)'), axis xy
ylim([20 100]), caxis([1.8 4])
colormap jet

subplot(512)
imagesc(Range(H_Low_Sptsd_NREM,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(H_Low_Sptsd_NREM)'),1)',1e2)'), axis xy
ylim([0 10]), caxis([1.5 4.5])

subplot(513)
imagesc(Range(P_Low_Sptsd_NREM,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(P_Low_Sptsd_NREM)'),1)',1e2)'), axis xy
ylim([0 10]), caxis([1.5 4])

subplot(514)
imagesc(Range(B_Low_Sptsd_NREM,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(B_Low_Sptsd_NREM)'),1)',1e2)'), axis xy
ylim([0 10]), caxis([2.5 4])

subplot(515)
imagesc(Range(B_UltraLow_Sptsd_NREM,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(B_UltraLow_Sptsd_NREM)'),1)',15)'), axis xy
caxis([1.8 4])


