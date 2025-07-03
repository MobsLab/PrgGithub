

%%
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