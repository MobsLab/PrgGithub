%%DAY

cd /media/nas5/Thierry_DATA/Exchange Cages/M779_processed/Baseline_homecage
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS before Mouse1
SWS779Before=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS779BeforeStart=Start(SWSEpoch)./(1e4)
SWS779BeforeEnd=End(SWSEpoch)./(1e4)
SWS779BeforeDuration=SWS779BeforeEnd-SWS779BeforeStart
Nb_SWS779BeforeBefore = length(SWS779BeforeStart); 

%WAKE before Mouse1
Wake779Before=sum(End(Wake,'s')-Start(Wake,'s'))
Wake779BeforeStart = Start(Wake)./(1e4);
Wake779BeforeEnd = End(Wake)./(1e4); 
Wake779BeforeDuration=Wake779BeforeEnd-Wake779BeforeStart
Nb_WakeEpoch779Before = length(Wake779BeforeStart); 

%REM before Mouse1
REM779Before=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM779BeforeStart=Start(REMEpoch)./(1e4)
REM779BeforeEnd=End(REMEpoch)./(1e4)
REM779BeforeDuration=REM779BeforeEnd-REM779BeforeStart
Nb_REMEpoch779Before = length(REM779BeforeStart); 

%Total sleep duration before Mouse1
TotalSleep779Before=SWS779Before+REM779Before

cd /media/nas5/Thierry_DATA/Exchange Cages/M779_processed/Exchange_cage
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS after Mouse1
SWS779After=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS779AfterStart=Start(SWSEpoch)./(1e4)
SWS779AfterEnd=End(SWSEpoch)./(1e4)
SWS779AfterDuration=SWS779AfterEnd-SWS779AfterStart
Nb_SWSEpoch779After = length(SWS779AfterStart); 

%WAKE After Mouse1
Wake779After=sum(End(Wake,'s')-Start(Wake,'s'))
Wake779AfterStart = Start(Wake)./(1e4);
Wake779AfterEnd = End(Wake)./(1e4); 
Wake779AfterDuration=Wake779AfterEnd-Wake779AfterStart
Nb_WakeEpoch779After = length(Wake779AfterStart); 

%REM After Mouse1
REM779After=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM779AfterStart=Start(REMEpoch)./(1e4)
REM779AfterEnd=End(REMEpoch)./(1e4)
REM779AfterDuration=REM779AfterEnd-REM779AfterStart
Nb_REMEpoch779After = length(REM779AfterStart); 

%Total sleep duration After Mouse1
TotalSleep779After=SWS779After+REM779After

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ratio (REM/SWS) Mouse1
ra_RemSwsAfter779=(REM779After)/(SWS779After)
ra_RemSwsBefore779=(REM779Before)/(SWS779Before)

%Ratio (Wake/Sleep) Mouse1
ra_WakeTsleep779Before=(Wake779Before)./(TotalSleep779Before)
ra_WakeTsleep779After=(Wake779After)./(TotalSleep779After)

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 1
ra779_After_SWSTotal=SWS779After./TotalSleep779After;
ra779_Before_SWSTotal=SWS779Before./TotalSleep779Before;
ra779_Before_REMTotal=REM779Before./TotalSleep779Before;
ra779_After_REMTotal=REM779After./TotalSleep779After;
[ra779_Before_SWSTotal ra779_After_SWSTotal ra779_Before_REMTotal ra779_After_REMTotal]
 
PlotErrorBarN_KJ({ra779_Before_SWSTotal ra779_After_SWSTotal ra779_Before_REMTotal ra779_After_REMTotal})
% PlotErrorBarN_KJ({ra_RemSwsBefore779 ra_RemSwsAfter779 ra_RemSwsBefore796 ra_RemSwsAfter796})


%Create histogram distributions Mouse 1
histogram((REM779BeforeDuration),200)
hold on
histogram((REM779AfterDuration),200)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /media/nas5/Thierry_DATA/Exchange Cages/M796_processed/Baseline_homecage
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS before Mouse 2
SWS796Before=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS796BeforeStart=Start(SWSEpoch)./(1e4)
SWS796BeforeEnd=End(SWSEpoch)./(1e4)
SWS796BeforeDuration=SWS796BeforeEnd-SWS796BeforeStart
Nb_SWSEpoch796Before = length(SWS796BeforeStart); 

%WAKE before Mouse 2
Wake796Before=sum(End(Wake,'s')-Start(Wake,'s'))
Wake796BeforeStart = Start(Wake)./(1e4);
Wake796BeforeEnd = End(Wake)./(1e4); 
Wake796BeforeDuration=Wake796BeforeEnd-Wake796BeforeStart
Nb_WakeEpoch796Before = length(Wake796BeforeStart); 

%REM before Mouse 2
REM796Before=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM796BeforeStart=Start(REMEpoch)./(1e4)
REM796BeforeEnd=End(REMEpoch)./(1e4)
REM796BeforeDuration=REM796BeforeEnd-REM796BeforeStart
Nb_REMEpoch796Before = length(REM796BeforeStart); 

%Total sleep duration before Mouse 2
TotalSleep796Before=SWS796Before+REM796Before

cd /media/nas5/Thierry_DATA/Exchange Cages/M796_processed/Exchange_cage
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS after Mouse 2
SWS796After=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS796AfterStart=Start(SWSEpoch)./(1e4)
SWS796AfterEnd=End(SWSEpoch)./(1e4)
SWS796AfterDuration=SWS796AfterEnd-SWS796AfterStart
Nb_SWSEpoch796After = length(SWS796AfterStart); 

%WAKE After Mouse 2
Wake796After=sum(End(Wake,'s')-Start(Wake,'s'))
Wake796AfterStart = Start(Wake)./(1e4);
Wake796AfterEnd = End(Wake)./(1e4); 
Wake796AfterDuration=Wake796AfterEnd-Wake796AfterStart
Nb_WakeEpoch796After = length(Wake796AfterStart); 

%REM After Mouse 2
REM796After=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM796AfterStart=Start(REMEpoch)./(1e4)
REM796AfterEnd=End(REMEpoch)./(1e4)
REM796AfterDuration=REM796AfterEnd-REM796AfterStart
Nb_REMEpoch796After = length(REM796AfterStart); 

%Total sleep duration After Mouse 2
TotalSleep796After=SWS796After+REM796After

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ratio (REM/SWS) Mouse 2
ra_RemSwsAfter796=(REM796After)/(SWS796After)
ra_RemSwsBefore796=(REM796Before)/(SWS796Before)

%Ratio (Wake/Sleep) Mouse 2
ra_WakeTsleep796Before=(Wake796Before)./(TotalSleep796Before)
ra_WakeTsleep796After=(Wake796After)./(TotalSleep796After)

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
ra796_After_SWSTotal=SWS796After./TotalSleep796After;
ra796_Before_SWSTotal=SWS796Before./TotalSleep796Before;
ra796_Before_REMTotal=REM796Before./TotalSleep796Before;
ra796_After_REMTotal=REM796After./TotalSleep796After;
[ra796_Before_SWSTotal ra796_After_SWSTotal ra796_Before_REMTotal ra796_After_REMTotal]
 
PlotErrorBarN_KJ({ra796_Before_SWSTotal ra796_After_SWSTotal ra796_Before_REMTotal ra796_After_REMTotal})

%create histogram distributions Mouse 2
histogram((REM796BeforeDuration),20)
hold on
histogram((REM796AfterDuration),20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 1 et 2
ra_Before_SWSTotal=[ra796_Before_SWSTotal ra779_Before_SWSTotal]
ra_After_SWSTotal=[ra796_After_SWSTotal ra779_After_SWSTotal]

ra_Before_REMTotal=[ra796_Before_REMTotal ra779_Before_REMTotal]
ra_After_REMTotal=[ra796_After_REMTotal ra779_After_REMTotal]

PlotErrorBarN_KJ({ra_Before_SWSTotal,ra_After_SWSTotal})
PlotErrorBarN_KJ({ra_Before_REMTotal,ra_After_REMTotal})


%Calcul durée total recordings Mouse 1 et 2

timeRecord796Before=(Wake796Before+SWS796Before+REM796Before)
timeRecord796After=(Wake796After+SWS796After+REM796After)
timeRecord779Before=(Wake779Before+SWS779Before+REM779Before)
timeRecord779After=(Wake779After+SWS779After+REM779After)

PlotErrorBarN_KJ({timeRecord796Before, timeRecord796After,timeRecord779Before, timeRecord779After})







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
