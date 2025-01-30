%%DAY

cd /media/mobs/DataMOBS92/Processed_DATA/M782_processed/M782_SleepBaseline_day_06112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS before Mouse1
SWS782Before=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS782BeforeStart=Start(SWSEpoch)./(1e4)
SWS782BeforeEnd=End(SWSEpoch)./(1e4)
SWS782BeforeDuration=SWS782BeforeEnd-SWS782BeforeStart
Nb_SWSEpoch782Before = length(SWS782BeforeStart); 

%WAKE before Mouse1
Wake782Before=sum(End(Wake,'s')-Start(Wake,'s'))
Wake782BeforeStart = Start(Wake)./(1e4);
Wake782BeforeEnd = End(Wake)./(1e4); 
Wake782BeforeDuration=Wake782BeforeEnd-Wake782BeforeStart
Nb_WakeEpoch782Before = length(Wake782BeforeStart); 

%REM before Mouse1
REM782Before=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM782BeforeStart=Start(REMEpoch)./(1e4)
REM782BeforeEnd=End(REMEpoch)./(1e4)
REM782BeforeDuration=REM782BeforeEnd-REM782BeforeStart
Nb_REMEpoch782Before = length(REM782BeforeStart); 

%Total sleep duration before Mouse1
TotalSleep782Before=SWS782Before+REM782Before

cd /media/mobs/MOBs96/M782_Sleep_cage_changed_day_07112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS after Mouse1
SWS782After=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS782AfterStart=Start(SWSEpoch)./(1e4)
SWS782AfterEnd=End(SWSEpoch)./(1e4)
SWS782AfterDuration=SWS782AfterEnd-SWS782AfterStart
Nb_SWSEpoch782After = length(SWS782AfterStart); 

%WAKE After Mouse1
Wake782After=sum(End(Wake,'s')-Start(Wake,'s'))
Wake782AfterStart = Start(Wake)./(1e4);
Wake782AfterEnd = End(Wake)./(1e4); 
Wake782AfterDuration=Wake782AfterEnd-Wake782AfterStart
Nb_WakeEpoch782After = length(Wake782AfterStart); 

%REM After Mouse1
REM782After=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM782AfterStart=Start(REMEpoch)./(1e4)
REM782AfterEnd=End(REMEpoch)./(1e4)
REM782AfterDuration=REM782AfterEnd-REM782AfterStart
Nb_REMEpoch782After = length(REM782AfterStart); 

%Total sleep duration After Mouse1
TotalSleep782After=SWS782After+REM782After

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ratio (REM/SWS) Mouse1
ra_RemSwsAfter782=(REM782After)/(SWS782After)
ra_RemSwsBefore782=(REM782Before)/(SWS782Before)

%Ratio (Wake/Sleep) Mouse1
ra_WakeTsleep782Before=(Wake782Before)./(TotalSleep782Before)
ra_WakeTsleep782After=(Wake782After)./(TotalSleep782After)

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 1
ra782_After_SWSTotal=SWS782After./TotalSleep782After;
ra782_Before_SWSTotal=SWS782Before./TotalSleep782Before;
ra782_Before_REMTotal=REM782Before./TotalSleep782Before;
ra782_After_REMTotal=REM782After./TotalSleep782After;
[ra782_Before_SWSTotal ra782_After_SWSTotal ra782_Before_REMTotal ra782_After_REMTotal]
 
PlotErrorBarN_KJ({ra782_Before_SWSTotal ra782_After_SWSTotal ra782_Before_REMTotal ra782_After_REMTotal})

%Create histogram distributions Mouse 1
histogram((REM782BeforeDuration),20)
hold on
histogram((REM782AfterDuration),20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /media/mobs/DataMOBS92/Processed_DATA/M781_processed/M781_SleepBaseline_day_06112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS before Mouse 2
SWS781Before=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS781BeforeStart=Start(SWSEpoch)./(1e4)
SWS781BeforeEnd=End(SWSEpoch)./(1e4)
SWS781BeforeDuration=SWS781BeforeEnd-SWS781BeforeStart
Nb_SWSEpoch781Before = length(SWS781BeforeStart); 

%WAKE before Mouse 2
Wake781Before=sum(End(Wake,'s')-Start(Wake,'s'))
Wake781BeforeStart = Start(Wake)./(1e4);
Wake781BeforeEnd = End(Wake)./(1e4); 
Wake781BeforeDuration=Wake781BeforeEnd-Wake781BeforeStart
Nb_WakeEpoch781Before = length(Wake781BeforeStart); 

%REM before Mouse 2
REM781Before=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM781BeforeStart=Start(REMEpoch)./(1e4)
REM781BeforeEnd=End(REMEpoch)./(1e4)
REM781BeforeDuration=REM781BeforeEnd-REM781BeforeStart
Nb_REMEpoch781Before = length(REM781BeforeStart); 

%Total sleep duration before Mouse 2
TotalSleep781Before=SWS781Before+REM781Before

cd /media/mobs/MOBs96/M781_Sleep_cage_changed_day_07112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS after Mouse 2
SWS781After=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS781AfterStart=Start(SWSEpoch)./(1e4)
SWS781AfterEnd=End(SWSEpoch)./(1e4)
SWS781AfterDuration=SWS781AfterEnd-SWS781AfterStart
Nb_SWSEpoch781After = length(SWS781AfterStart); 

%WAKE After Mouse 2
Wake781After=sum(End(Wake,'s')-Start(Wake,'s'))
Wake781AfterStart = Start(Wake)./(1e4);
Wake781AfterEnd = End(Wake)./(1e4); 
Wake781AfterDuration=Wake781AfterEnd-Wake781AfterStart
Nb_WakeEpoch781After = length(Wake781AfterStart); 

%REM After Mouse 2
REM781After=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM781AfterStart=Start(REMEpoch)./(1e4)
REM781AfterEnd=End(REMEpoch)./(1e4)
REM781AfterDuration=REM781AfterEnd-REM781AfterStart
Nb_REMEpoch781After = length(REM781AfterStart); 

%Total sleep duration After Mouse 2
TotalSleep781After=SWS781After+REM781After

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ratio (REM/SWS) Mouse 2
ra_RemSwsAfter781=(REM781After)/(SWS781After)
ra_RemSwsBefore781=(REM781Before)/(SWS781Before)

%Ratio (Wake/Sleep) Mouse 2
ra_WakeTsleep781Before=(Wake781Before)./(TotalSleep781Before)
ra_WakeTsleep781After=(Wake781After)./(TotalSleep781After)

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
ra781_After_SWSTotal=SWS781After./TotalSleep781After;
ra781_Before_SWSTotal=SWS781Before./TotalSleep781Before;
ra781_Before_REMTotal=REM781Before./TotalSleep781Before;
ra781_After_REMTotal=REM781After./TotalSleep781After;
[ra781_Before_SWSTotal ra781_After_SWSTotal ra781_Before_REMTotal ra781_After_REMTotal]
 
PlotErrorBarN_KJ({ra781_Before_SWSTotal ra781_After_SWSTotal ra781_Before_REMTotal ra781_After_REMTotal})

%create histogram distributions Mouse 2
histogram((REM781BeforeDuration),20)
hold on
histogram((REM781AfterDuration),20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 1 et 2
ra_Before_SWSTotal=[ra781_Before_SWSTotal ra782_Before_SWSTotal]
ra_After_SWSTotal=[ra781_After_SWSTotal ra782_After_SWSTotal]

ra_Before_REMTotal=[ra781_Before_REMTotal ra782_Before_REMTotal]
ra_After_REMTotal=[ra781_After_REMTotal ra782_After_REMTotal]

PlotErrorBarN_KJ({ra_Before_SWSTotal,ra_After_SWSTotal})
PlotErrorBarN_KJ({ra_Before_REMTotal,ra_After_REMTotal})


%Calcul durée total recordings Mouse 1 et 2

timeRecord781Before=(Wake781Before+SWS781Before+REM781Before)
timeRecord781After=(Wake781After+SWS781After+REM781After)
timeRecord782Before=(Wake782Before+SWS782Before+REM782Before)
timeRecord782After=(Wake782After+SWS782After+REM782After)

PlotErrorBarN_KJ({timeRecord781Before, timeRecord781After,timeRecord782Before, timeRecord782After})


%%NIGHT

cd /media/mobs/DataMOBS92/Processed_DATA/M782_processed/M782_SleepBaseline_night_06112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS before Mouse1
nSWS782Before=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
nSWS782BeforeStart=Start(SWSEpoch)./(1e4)
nSWS782BeforeEnd=End(SWSEpoch)./(1e4)
nSWS782BeforeDuration=nSWS782BeforeEnd-nSWS782BeforeStart
nNb_SWSEpoch782Before = length(nSWS782BeforeStart); 

%WAKE before Mouse1
nWake782Before=sum(End(Wake,'s')-Start(Wake,'s'))
nWake782BeforeStart = Start(Wake)./(1e4);
nWake782BeforeEnd = End(Wake)./(1e4); 
nWake782BeforeDuration=nWake782BeforeEnd-nWake782BeforeStart
nNb_WakeEpoch782Before = length(nWake782BeforeStart); 

%REM before Mouse1
nREM782Before=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
nREM782BeforeStart=Start(REMEpoch)./(1e4)
nREM782BeforeEnd=End(REMEpoch)./(1e4)
nREM782BeforeDuration=nREM782BeforeEnd-nREM782BeforeStart
nNb_REMEpoch782Before = length(nREM782BeforeStart); 

%Total sleep duration before Mouse1
nTotalSleep782Before=nSWS782Before+nREM782Before

cd /media/mobs/MOBs96/M782_Sleep_cage_changed_night_07112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS after Mouse1
nSWS782After=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
nSWS782AfterStart=Start(SWSEpoch)./(1e4)
nSWS782AfterEnd=End(SWSEpoch)./(1e4)
nSWS782AfterDuration=nSWS782AfterEnd-nSWS782AfterStart
nNb_SWSEpoch782After = length(nSWS782AfterStart); 

%WAKE After Mouse1
nWake782After=sum(End(Wake,'s')-Start(Wake,'s'))
nWake782AfterStart = Start(Wake)./(1e4);
nWake782AfterEnd = End(Wake)./(1e4); 
nWake782AfterDuration=nWake782AfterEnd-nWake782AfterStart
nNb_WakeEpoch782After = length(nWake782AfterStart); 

%REM After Mouse1
nREM782After=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
nREM782AfterStart=Start(REMEpoch)./(1e4)
nREM782AfterEnd=End(REMEpoch)./(1e4)
nREM782AfterDuration=nREM782AfterEnd-nREM782AfterStart
nNb_REMEpoch782After = length(nREM782AfterStart); 

%Total sleep duration After Mouse1
nTotalSleep782After=nSWS782After+nREM782After

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ratio (REM/SWS) Mouse1
nra_RemSwsAfter782=(nREM782After)/(nSWS782After)
nra_RemSwsBefore782=(nREM782Before)/(nSWS782Before)

%Ratio (Wake/Sleep) Mouse1
nra_WakeTsleep782Before=(nWake782Before)./(nTotalSleep782Before)
nra_WakeTsleep782After=(nWake782After)./(nTotalSleep782After)

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 1
nra782_After_SWSTotal=nSWS782After./nTotalSleep782After;
nra782_Before_SWSTotal=nSWS782Before./nTotalSleep782Before;
nra782_Before_REMTotal=nREM782Before./nTotalSleep782Before;
nra782_After_REMTotal=nREM782After./nTotalSleep782After;
[nra782_Before_SWSTotal nra782_After_SWSTotal nra782_Before_REMTotal nra782_After_REMTotal]
 
PlotErrorBarN_KJ({nra782_Before_SWSTotal nra782_After_SWSTotal nra782_Before_REMTotal nra782_After_REMTotal})

%Create histogram distributions Mouse 1
histogram((nREM782BeforeDuration),20)
hold on
histogram((nREM782AfterDuration),20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /media/mobs/DataMOBS92/Processed_DATA/M781_processed/M781_SleepBaseline_night_06112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS before Mouse 2
nSWS781Before=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
nSWS781BeforeStart=Start(SWSEpoch)./(1e4)
nSWS781BeforeEnd=End(SWSEpoch)./(1e4)
nSWS781BeforeDuration=nSWS781BeforeEnd-nSWS781BeforeStart
nNb_SWSEpoch781Before = length(nSWS781BeforeStart); 

%WAKE before Mouse 2
nWake781Before=sum(End(Wake,'s')-Start(Wake,'s'))
nWake781BeforeStart = Start(Wake)./(1e4);
nWake781BeforeEnd = End(Wake)./(1e4); 
nWake781BeforeDuration=nWake781BeforeEnd-nWake781BeforeStart
nNb_WakeEpoch781Before = length(Wake781BeforeStart); 

%REM before Mouse 2
nREM781Before=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
nREM781BeforeStart=Start(REMEpoch)./(1e4)
nREM781BeforeEnd=End(REMEpoch)./(1e4)
nREM781BeforeDuration=nREM781BeforeEnd-nREM781BeforeStart
nNb_REMEpoch781Before = length(nREM781BeforeStart); 

%Total sleep duration before Mouse 2
nTotalSleep781Before=nSWS781Before+nREM781Before

cd /media/mobs/MOBs96/M781_Sleep_cage_changed_night_07112018
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS after Mouse 2
nSWS781After=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
nSWS781AfterStart=Start(SWSEpoch)./(1e4)
nSWS781AfterEnd=End(SWSEpoch)./(1e4)
nSWS781AfterDuration=nSWS781AfterEnd-nSWS781AfterStart
nNb_SWSEpoch781After = length(nSWS781AfterStart); 

%WAKE After Mouse 2
nWake781After=sum(End(Wake,'s')-Start(Wake,'s'))
nWake781AfterStart = Start(Wake)./(1e4);
nWake781AfterEnd = End(Wake)./(1e4); 
nWake781AfterDuration=nWake781AfterEnd-nWake781AfterStart
nNb_WakeEpoch781After = length(nWake781AfterStart); 

%REM After Mouse 2
nREM781After=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
nREM781AfterStart=Start(REMEpoch)./(1e4)
nREM781AfterEnd=End(REMEpoch)./(1e4)
nREM781AfterDuration=nREM781AfterEnd-nREM781AfterStart
nNb_REMEpoch781After = length(nREM781AfterStart); 

%Total sleep duration After Mouse 2
nTotalSleep781After=nSWS781After+nREM781After

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ratio (REM/SWS) Mouse 2
nra_RemSwsAfter781=(nREM781After)/(nSWS781After)
nra_RemSwsBefore781=(nREM781Before)/(nSWS781Before)

%Ratio (Wake/Sleep) Mouse 2
nra_WakeTsleep781Before=(nWake781Before)./(nTotalSleep781Before)
nra_WakeTsleep781After=(nWake781After)./(nTotalSleep781After)

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
nra781_After_SWSTotal=nSWS781After./nTotalSleep781After;
nra781_Before_SWSTotal=nSWS781Before./nTotalSleep781Before;
nra781_Before_REMTotal=nREM781Before./nTotalSleep781Before;
nra781_After_REMTotal=nREM781After./nTotalSleep781After;
[nra781_Before_SWSTotal nra781_After_SWSTotal nra781_Before_REMTotal nra781_After_REMTotal]
 
PlotErrorBarN_KJ({nra781_Before_SWSTotal nra781_After_SWSTotal nra781_Before_REMTotal nra781_After_REMTotal})

%create histogram distributions Mouse 2
histogram((nREM781BeforeDuration),20)
hold on
histogram((nREM781AfterDuration),20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 1 et 2
nra_Before_SWSTotal=[nra781_Before_SWSTotal nra782_Before_SWSTotal]
nra_After_SWSTotal=[nra781_After_SWSTotal nra782_After_SWSTotal]

nra_Before_REMTotal=[nra781_Before_REMTotal nra782_Before_REMTotal]
nra_After_REMTotal=[nra781_After_REMTotal nra782_After_REMTotal]

PlotErrorBarN_KJ({nra_Before_SWSTotal,nra_After_SWSTotal})
PlotErrorBarN_KJ({nra_Before_REMTotal,nra_After_REMTotal})


%Calcul durée total recordings Mouse 1 et 2

ntimeRecord781Before=(nWake781Before+nSWS781Before+nREM781Before)
ntimeRecord781After=(nWake781After+nSWS781After+nREM781After)
ntimeRecord782Before=(nWake782Before+nSWS782Before+nREM782Before)
ntimeRecord782After=(nWake782After+nSWS782After+nREM782After)

PlotErrorBarN_KJ({ntimeRecord781Before, ntimeRecord781After,ntimeRecord782Before, ntimeRecord782After})




% %Hypnogram
% 
% CreateSleepSignals('recompute',0,'scoring','accelero');
% 
% %% Substages disp('getting sleep stages') [featuresNREM, Namesfeatures,
% EpochSleep, NoiseEpoch, scoring] =
% FindNREMfeatures('scoring','accelero'); save('FeaturesScoring',
% 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
% [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
% save('SleepSubstages', 'Epoch', 'NameEpoch')
% 
% %% Id figure 1 disp('making ID fig1') MakeIDSleepData PlotIDSleepData
% saveas(1,'IDFig1.png') close all
% 
% %% Id figure 2 disp('making ID fig2') MakeIDSleepData2 PlotIDSleepData2
% saveas(1,'IDFig2.png') close all
