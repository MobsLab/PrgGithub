function AnalyseActimeterML

% AnalyseActimeterML.m
%
% use results from 3 types of sleep scoring :
%   - sleepscoringML.m (StateEpoch.mat)
%   - BulbSleepScriptGL.m (StateEpochSB.mat and B_High_Spectrum.mat)
%   - ActiToData.m (Actimeter.mat)
%
% other related scripts and functions :
%   - ActimetrySleepScorCompar.m 
%   - ActimetryQuantifSleep.m
%   - PoolDataActi.m
%   - GetAllDataActi.m
%   - an_actiML.m


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% loading data
disp('...Loading Actimeter.mat for ScoringAD')
load Actimeter ActiData ActiScoring

ActiTSD=tsd(1E4*(ActiData(:,1)-ActiData(1,1)),ActiData(:,2));
FilActi=FilterLFP(ActiTSD,[1 40],1024);
tsd_ActiData=tsd(Range(ActiTSD),abs(hilbert(Data(FilActi))));
% tsd_ActiData=tsd((ActiData(:,1)-ActiData(1,1))*1E4,ActiData(:,2));
tsd_ActiScor=tsd((ActiScoring(:,1)-ActiData(1,1))*1E4,ActiScoring(:,2));
tsd_ActiBreathFreq=tsd((ActiScoring(:,1)-ActiData(1,1))*1E4,ActiScoring(:,3));
tps=ActiScoring(:,1)-ActiScoring(1,1);

disp('...Loading StateEpoch.mat for sleepscoringML')
load StateEpoch REMEpoch SWSEpoch Spectro Mmov
f=Spectro{3};
Sptsd=tsd(Spectro{2}*1E4,Spectro{1});

% 
% disp('...Loading StateEpochSB.mat for sleepscoringSB')
% load B_High_Spectrum Spectro
% load StateEpochSB REMEpoch SWSEpoch
% 


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% Quantification of wake periods

qq = quantile(Data(tsd_ActiData),0.9);
WakeEpoch=thresholdIntervals(tsd_ActiData,qq,'Direction','Above');
WakeEpoch=mergeCloseIntervals(WakeEpoch,5*1E4);
%WakeEpoch=dropShortIntervals(WakeEpoch,1*1E4);
WakeScorEpoch=thresholdIntervals(tsd_ActiScor,0,'Direction','Above');

figure, plot(Range(tsd_ActiData,'s'),Data(tsd_ActiData))
hold on, plot(Range(Restrict(tsd_ActiData,WakeEpoch),'s'),Data(Restrict(tsd_ActiData,WakeEpoch)),'g')
hold on, plot(Range(tsd_ActiScor,'s'),Data(tsd_ActiScor),'r')
hold on, line([0 max(Range(tsd_ActiData,'s'))],[qq qq],'Color',[0.5 0.5 0.5])


Dur=Stop(WakeEpoch,'s')-Start(WakeEpoch,'s');
DurSc=Stop(WakeScorEpoch,'s')-Start(WakeScorEpoch,'s');

figure('Color',[1 1 1]), subplot(2,3,1:2), hist(Dur,100)
subplot(2,3,3),boxplot(Dur);xlabel('thresh on hilbert'), 
title(['mean dur = ',num2str(mean(Dur)),'+/-',num2str(std(Dur))])

subplot(2,3,4:5), hist(DurSc,100)
subplot(2,3,6), boxplot(DurSc); xlabel('AD scoring')
title(['mean dur = ',num2str(mean(DurSc)),' +/-',num2str(std(DurSc))])


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% Quantification of SLEEP periods

SleepEpoch=thresholdIntervals(tsd_ActiData,qq,'Direction','Below');
SleepEpoch=dropShortIntervals(SleepEpoch,5*1E4);
SleepScorEpoch=thresholdIntervals(tsd_ActiScor,0,'Direction','Below');

figure, plot(Range(tsd_ActiData,'s'),Data(tsd_ActiData))
hold on, plot(Range(Restrict(tsd_ActiData,SleepEpoch),'s'),Data(Restrict(tsd_ActiData,SleepEpoch)),'r')
hold on, plot(Range(tsd_ActiScor,'s'),Data(tsd_ActiScor),'r')
hold on, line([0 max(Range(tsd_ActiData,'s'))],[qq qq],'Color',[0.5 0.5 0.5])


SleepDur=Stop(SleepEpoch,'s')-Start(SleepEpoch,'s');
SleepDurSc=Stop(SleepScorEpoch,'s')-Start(SleepScorEpoch,'s');

figure('Color',[1 1 1]), subplot(2,3,1:2), hist(SleepDur,100)
subplot(2,3,3),boxplot(SleepDur);xlabel('thresh on hilbert'), 
title(['mean dur = ',num2str(mean(SleepDur)),'+/-',num2str(std(SleepDur))])

subplot(2,3,4:5), hist(SleepDurSc,100)
subplot(2,3,6), boxplot(SleepDurSc); xlabel('AD scoring')
title(['mean dur = ',num2str(mean(SleepDurSc)),' +/-',num2str(std(SleepDurSc))])


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% transition sleep-> wake and wake-> sleep
% sampling 

% sleep-> wake transition
dd=[0 ;diff(Data(tsd_ActiScor))];
indexSW=find(dd==2);

% wake-> sleep transition
indexWS=find(dd==-2);


figure('Color',[1 1 1]), plot(Range(tsd_ActiData,'s'),rescale(Data(tsd_ActiData),-1,2),'k')
hold on, plot(Range(tsd_ActiScor,'s'),rescale(Data(tsd_ActiScor),0,1),'-r','Linewidth',1.2)
title('Actimetry scoringAD (movements frequency)')
hold on, plot(tps(indexSW),ones(length(indexSW)),'.g')
hold on, plot(tps(indexWS),zeros(length(indexWS)),'.b')

% -------------------------------------------------------------------------
%% transition PETH ActiScortsd

% sleep-> wake transition
figure('Color',[1 1 1])
[fh,r,h,m] = ImagePETH(tsd_ActiScor, ts(tps(indexSW)*1E4), -2E5, 2E5);
title('Acti Scoring, Transition Sleep -> Wake')

% wake-> sleep transition
figure('Color',[1 1 1])
[fh,r,h,m] = ImagePETH(tsd_ActiScor, ts(tps(indexWS)*1E4), -2E5, 2E5);
title('Acti Scoring, Transition Wake -> Sleep')

% -------------------------------------------------------------------------
%% transition PETH Actitsd

% sleep-> wake transition
figure('Color',[1 1 1])
[fh,r,h,m] = ImagePETH(tsd_ActiData, ts(tps(indexSW)*1E4), -2E5, 2E5);
title('Act iData, Transition Sleep -> Wake')

% wake-> sleep transition
figure('Color',[1 1 1])
[fh,r,h,m] = ImagePETH(tsd_ActiData, ts(tps(indexWS)*1E4), -2E5, 2E5);
title('Acti Data, Transition Wake -> Sleep')

% -------------------------------------------------------------------------
%% transition PETH Mmov

Mmov=tsd(double(Range(Mmov)),rescale(double(Data(Mmov)),0,20));
HMmov=tsd(Range(Mmov),abs(hilbert(Data(Mmov))));

% sleep-> wake transition
figure('Color',[1 1 1])
[fh,r,h,m] = ImagePETH(HMmov, ts(tps(indexSW)*1E4), -2E5, 2E5);
title('Mmov, Transition Sleep -> Wake')
caxis([0 max(dt)])

% wake-> sleep transition
figure('Color',[1 1 1])
[fh,r,h,m] = ImagePETH(HMmov, ts(tps(indexWS)*1E4), -2E5, 2E5);
title('Mmov, Transition Wake -> Sleep')
%subplot(4,1,2:3);caxis([0 max(dt)])

% -------------------------------------------------------------------------
%% transition PETH ActiBreathFreq

% sleep-> wake transition
figure('Color',[1 1 1])
[fh,r,h,m] = ImagePETH(tsd_ActiBreathFreq, ts(tps(indexSW)*1E4), -2E5, 2E5);
title('Acti Breathing Freq, Transition Sleep -> Wake')

% wake-> sleep transition
figure('Color',[1 1 1])
[fh,r,h,m] = ImagePETH(tsd_ActiBreathFreq, ts(tps(indexWS)*1E4), -2E5, 2E5);
title('Acti Breathing Freq, Transition Wake -> Sleep')



% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% AverageSpectrogram

% sleep-> wake transition
AverageSpectrogram(Sptsd,f,ts(tps(indexSW)*1E4),1000,50,1);
title('Spectrum dHPC, Transition Sleep -> Wake')


% wake-> sleep transition
AverageSpectrogram(Sptsd,f,ts(tps(indexWS)*1E4),1000,50,1);
title('Spectrum dHPC, Transition Wake -> Sleep')









% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% micro-waking


