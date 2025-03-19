%%Baseline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /media/nas5/Thierry_DATA/Exchange Cages/923_926_927_928_Baseline2_02072019_190702_085527/Mouse923
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS Homecage Mouse 1
SWS923Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
SWS923HomecageStart=Start(SWSEpoch)./(1e4);
SWS923HomecageEnd=End(SWSEpoch)./(1e4);
SWS923HomecageDuration=SWS923HomecageEnd-SWS923HomecageStart;
Nb_SWSEpoch923Homecage = length(SWS923HomecageStart); 

%WAKE Homecage Mouse 1
Wake923Homecage=sum(End(Wake,'s')-Start(Wake,'s'));
Wake923HomecageStart = Start(Wake)./(1e4);
Wake923HomecageEnd = End(Wake)./(1e4); 
Wake923HomecageDuration=Wake923HomecageEnd-Wake923HomecageStart;
Nb_WakeEpoch923Homecage = length(Wake923HomecageStart); 

%REM Homecage Mouse 1
REM923Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM923HomecageStart=Start(REMEpoch)./(1e4);
REM923HomecageEnd=End(REMEpoch)./(1e4);
REM923HomecageDuration=REM923HomecageEnd-REM923HomecageStart;
Nb_REMEpoch923Homecage = length(REM923HomecageStart); 

%Nombre d'épisodes
[Nb_SWSEpoch923Homecage Nb_WakeEpoch923Homecage Nb_REMEpoch923Homecage] 
PlotErrorBarN_KJ({Nb_SWSEpoch923Homecage Nb_WakeEpoch923Homecage Nb_REMEpoch923Homecage})

%Total sleep duration Homecage Mouse 1
TotalSleep923Homecage=SWS923Homecage+REM923Homecage;

% stages %
wb2 = length(Start(Wake)); 
sb2 = length(Start(SWSEpoch));
rb2 = length(Start(REMEpoch));
allb2 = wb2+sb2+rb2;
wpb2 = wb2/allb2*100;
spb2 = sb2/allb2*100;
rpb2 = rb2/allb2*100;


%%%%CNO%%%%%
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse923_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS CNO Mouse 1
SWS923CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
SWS923CNOStart=Start(SWSEpoch)./(1e4);
SWS923CNOEnd=End(SWSEpoch)./(1e4);
SWS923CNODuration=SWS923CNOEnd-SWS923CNOStart;
Nb_SWSEpoch923CNO = length(SWS923CNOStart); 

%WAKE CNO Mouse 1
Wake923CNO=sum(End(Wake,'s')-Start(Wake,'s'));
Wake923CNOStart = Start(Wake)./(1e4);
Wake923CNOEnd = End(Wake)./(1e4); 
Wake923CNODuration=Wake923CNOEnd-Wake923CNOStart;
Nb_WakeEpoch923CNO = length(Wake923CNOStart); 

%REM CNO Mouse 1
REM923CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM923CNOStart=Start(REMEpoch)./(1e4);
REM923CNOEnd=End(REMEpoch)./(1e4);
REM923CNODuration=REM923CNOEnd-REM923CNOStart;
Nb_REMEpoch923CNO = length(REM923CNOStart); 

%Nombre d'épisodes
[Nb_SWSEpoch923CNO Nb_WakeEpoch923CNO Nb_REMEpoch923CNO] 
PlotErrorBarN_KJ({Nb_SWSEpoch923CNO Nb_WakeEpoch923CNO Nb_REMEpoch923CNO})

%Total sleep duration CNO Mouse 1
TotalSleep923CNO=SWS923CNO+REM923CNO;

% stages %
wcno1 = length(Start(Wake)); 
scno1 = length(Start(SWSEpoch));
rcno1 = length(Start(REMEpoch));
allcno1 = wcno1+scno1+rcno1;
wpcno1 = wcno1/allcno1*100;
spcno1 = scno1/allcno1*100;
rpcno1 = rcno1/allcno1*100;

%%%%Baseline 3%%%%%
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
%SWS Baseline 3 Mouse 1
SWS923Baseline3=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
SWS923Baseline3Start=Start(SWSEpoch)./(1e4);
SWS923Baseline3End=End(SWSEpoch)./(1e4);
SWS923Baseline3Duration=SWS923Baseline3End-SWS923Baseline3Start;
Nb_SWSEpoch923Baseline3 = length(SWS923Baseline3Start); 

%WAKE Baseline 3 Mouse 1
Wake923Baseline3=sum(End(Wake,'s')-Start(Wake,'s'));
Wake923Baseline3Start = Start(Wake)./(1e4);
Wake923Baseline3End = End(Wake)./(1e4); 
Wake923Baseline3Duration=Wake923Baseline3End-Wake923Baseline3Start;
Nb_WakeEpoch923Baseline3 = length(Wake923Baseline3Start); 

%REM Baseline 3 Mouse 1
REM923Baseline3=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM923Baseline3Start=Start(REMEpoch)./(1e4);
REM923Baseline3End=End(REMEpoch)./(1e4);
REM923Baseline3Duration=REM923Baseline3End-REM923Baseline3Start;
Nb_REMEpoch923Baseline3 = length(REM923Baseline3Start); 

%Nombre d'épisodes
[Nb_SWSEpoch923Baseline3 Nb_WakeEpoch923Baseline3 Nb_REMEpoch923Baseline3] 
PlotErrorBarN_KJ({Nb_SWSEpoch923Baseline3 Nb_WakeEpoch923Baseline3 Nb_REMEpoch923Baseline3})

%Total sleep duration Baseline 3 Mouse 1
TotalSleep923Baseline3=SWS923Baseline3+REM923Baseline3;

% stages %
wb3 = length(Start(Wake)); 
sb3 = length(Start(SWSEpoch));
rb3 = length(Start(REMEpoch));
allb3 = wb3+sb3+rb3;
wpb3 = wb3/allb3*100
spb3 = sb3/allb3*100;
rpb3 = rb3/allb3*100;

%%%%Saline%%%%%
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
%SWS Saline Mouse 1
SWS923Saline=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
SWS923SalineStart=Start(SWSEpoch)./(1e4);
SWS923SalineEnd=End(SWSEpoch)./(1e4);
SWS923SalineDuration=SWS923SalineEnd-SWS923SalineStart;
Nb_SWSEpoch923Saline = length(SWS923SalineStart); 

%WAKE Saline Mouse 1
Wake923Saline=sum(End(Wake,'s')-Start(Wake,'s'));
Wake923SalineStart = Start(Wake)./(1e4);
Wake923SalineEnd = End(Wake)./(1e4); 
Wake923SalineDuration=Wake923SalineEnd-Wake923SalineStart;
Nb_WakeEpoch923Saline = length(Wake923SalineStart); 

%REM Saline Mouse 1
REM923Saline=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM923SalineStart=Start(REMEpoch)./(1e4);
REM923SalineEnd=End(REMEpoch)./(1e4);
REM923SalineDuration=REM923SalineEnd-REM923SalineStart;
Nb_REMEpoch923Saline = length(REM923SalineStart); 

%Nombre d'épisodes
[Nb_SWSEpoch923Saline Nb_WakeEpoch923Saline Nb_REMEpoch923Saline] 
PlotErrorBarN_KJ({Nb_SWSEpoch923Saline Nb_WakeEpoch923Saline Nb_REMEpoch923Saline})

%Total sleep duration Saline Mouse 1
TotalSleep923Saline=SWS923Saline+REM923Saline;

% stages %
wsal = length(Start(Wake)); 
ssal = length(Start(SWSEpoch));
rsal = length(Start(REMEpoch));
allsal = wsal+ssal+rsal;
wpsal = wsal/allsal*100
spsal = ssal/allsal*100;
rpsal = rsal/allsal*100;


f = figure('Position', [0 0 1000 400]);
    subplot(2,2,1)
    bar([spb2 rpb2 wpb2],'k')
    ylabel('Proportion (%)')
    xlabel('Sleep stages')
    title('Sleep stages proportion baseline 2')
    xticklabels(ss_real)
    
    subplot(2,2,2)
    bar([spcno1 rpcno1 wpcno1],'k')
    ylabel('Proportion (%)')
    xlabel('Sleep stages')
    title('Sleep stages proportion CNO')
    xticklabels(ss_real)
    
    subplot(2,2,3)
    bar([spb3 rpb3 wpb3],'k')
    ylabel('Proportion (%)')
    xlabel('Sleep stages')
    title('Sleep stages proportion baseline 3')
    xticklabels(ss_real)
    
    subplot(2,2,4)
    bar([spsal rpsal wpsal],'k')
    ylabel('Proportion (%)')
    xlabel('Sleep stages')
    title('Sleep stages proportion saline')
    xticklabels(ss_real)


                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%CNO vs Baseline
%Ratio (REM/SWS) Mouse 1
ra_RemSwsCNO923=(REM923CNO)/(SWS923CNO);
ra_RemSwsHomecage923=(REM923Homecage)/(SWS923Homecage);

%Ratio (Wake/Sleep) Mouse 1
ra_WakeTsleep923Homecage=(Wake923Homecage)./(TotalSleep923Homecage);
ra_WakeTsleep923CNO=(Wake923CNO)./(TotalSleep923CNO);

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 1
ra923_CNO_SWSTotal=SWS923CNO./TotalSleep923CNO;
ra923_Homecage_SWSTotal=SWS923Homecage./TotalSleep923Homecage;
ra923_Homecage_REMTotal=REM923Homecage./TotalSleep923Homecage;
ra923_CNO_REMTotal=REM923CNO./TotalSleep923CNO;
[ra923_Homecage_SWSTotal ra923_CNO_SWSTotal ra923_Homecage_REMTotal ra923_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra923_Homecage_SWSTotal ra923_CNO_SWSTotal ra923_Homecage_REMTotal ra923_CNO_REMTotal})

%create histogram distributions Mouse 1
histogram((REM923HomecageDuration),20)
hold on
histogram((REM923CNODuration),20)


%%%CNO vs Saline
%Ratio (REM/SWS) Mouse 1
ra_RemSwsCNO923=(REM923CNO)/(SWS923CNO);
ra_RemSwsSaline923=(REM923Saline)/(SWS923Saline);

%Ratio (Wake/Sleep) Mouse 1
ra_WakeTsleep923Saline=(Wake923Saline)./(TotalSleep923Saline);
ra_WakeTsleep923CNO=(Wake923CNO)./(TotalSleep923CNO);

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 1
ra923_CNO_SWSTotal=SWS923CNO./TotalSleep923CNO;
ra923_Saline_SWSTotal=SWS923Saline./TotalSleep923Saline;
ra923_Saline_REMTotal=REM923Saline./TotalSleep923Saline;
ra923_CNO_REMTotal=REM923CNO./TotalSleep923CNO;
[ra923_Saline_SWSTotal ra923_CNO_SWSTotal ra923_Saline_REMTotal ra923_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra923_Saline_SWSTotal ra923_CNO_SWSTotal ra923_Saline_REMTotal ra923_CNO_REMTotal})

%%%%%%%
cd /media/nas5/Thierry_DATA/Exchange Cages/923_926_927_928_Baseline2_02072019_190702_085527/Mouse923
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS Homecage Mouse2
SWS926Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS926HomecageStart=Start(SWSEpoch)./(1e4)
SWS926HomecageEnd=End(SWSEpoch)./(1e4)
SWS926HomecageDuration=SWS926HomecageEnd-SWS926HomecageStart
Nb_SWSEpoch926Homecage = length(SWS926HomecageStart); 

%WAKE Homecage Mouse2
Wake926Homecage=sum(End(Wake,'s')-Start(Wake,'s'))
Wake926HomecageStart = Start(Wake)./(1e4);
Wake926HomecageEnd = End(Wake)./(1e4); 
Wake926HomecageDuration=Wake926HomecageEnd-Wake926HomecageStart
Nb_WakeEpoch926Homecage = length(Wake926HomecageStart); 

%REM Homecage Mouse2
REM926Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM926HomecageStart=Start(REMEpoch)./(1e4)
REM926HomecageEnd=End(REMEpoch)./(1e4)
REM926HomecageDuration=REM926HomecageEnd-REM926HomecageStart
Nb_REMEpoch926Homecage = length(REM926HomecageStart); 

%Total sleep duration Homecage Mouse2
TotalSleep926Homecage=SWS926Homecage+REM926Homecage

cd /media/mobs/MOBs96/M926_Sleep_cage_changed_day_07112018
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')

%SWS CNO Mouse2
SWS926CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
SWS926CNOStart=Start(SWSEpoch)./(1e4)
SWS926CNOEnd=End(SWSEpoch)./(1e4)
SWS926CNODuration=SWS926CNOEnd-SWS926CNOStart
Nb_SWSEpoch926CNO = length(SWS926CNOStart); 

%WAKE CNO Mouse2
Wake926CNO=sum(End(Wake,'s')-Start(Wake,'s'))
Wake926CNOStart = Start(Wake)./(1e4);
Wake926CNOEnd = End(Wake)./(1e4); 
Wake926CNODuration=Wake926CNOEnd-Wake926CNOStart
Nb_WakeEpoch926CNO = length(Wake926CNOStart); 

%REM CNO Mouse2
REM926CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
REM926CNOStart=Start(REMEpoch)./(1e4)
REM926CNOEnd=End(REMEpoch)./(1e4)
REM926CNODuration=REM926CNOEnd-REM926CNOStart
Nb_REMEpoch926CNO = length(REM926CNOStart); 

%Total sleep duration CNO Mouse2
TotalSleep926CNO=SWS926CNO+REM926CNO

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ratio (REM/SWS) Mouse2
ra_RemSwsCNO926=(REM926CNO)/(SWS926CNO)
ra_RemSwsHomecage926=(REM926Homecage)/(SWS926Homecage)

%Ratio (Wake/Sleep) Mouse2
ra_WakeTsleep926Homecage=(Wake926Homecage)./(TotalSleep926Homecage)
ra_WakeTsleep926CNO=(Wake926CNO)./(TotalSleep926CNO)

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
ra926_CNO_SWSTotal=SWS926CNO./TotalSleep926CNO;
ra926_Homecage_SWSTotal=SWS926Homecage./TotalSleep926Homecage;
ra926_Homecage_REMTotal=REM926Homecage./TotalSleep926Homecage;
ra926_CNO_REMTotal=REM926CNO./TotalSleep926CNO;
[ra926_Homecage_SWSTotal ra926_CNO_SWSTotal ra926_Homecage_REMTotal ra926_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra926_Homecage_SWSTotal ra926_CNO_SWSTotal ra926_Homecage_REMTotal ra926_CNO_REMTotal})

%Create histogram distributions Mouse 2
histogram((REM926HomecageDuration),20)
hold on
histogram((REM926CNODuration),20)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 923-926-927-928
ra_Homecage_SWSTotal=[ra923_Homecage_SWSTotal ra926_Homecage_SWSTotal ra927_Homecage_SWSTotal ra928_Homecage_SWSTotal]
ra_CNO_SWSTotal=[ra923_CNO_SWSTotal ra926_CNO_SWSTotal ra927_CNO_SWSTotal ra928_CNO_SWSTotal]

ra_Homecage_REMTotal=[ra923_Homecage_REMTotal ra926_Homecage_REMTotal ra927_Homecage_REMTotal ra928_Homecage_REMTotal]
ra_CNO_REMTotal=[ra923_CNO_REMTotal ra926_CNO_REMTotal ra927_CNO_REMTotal ra928_CNO_REMTotal]

PlotErrorBarN_KJ({ra_Homecage_SWSTotal,ra_CNO_SWSTotal})
PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal})


%Calcul durée total recordings Mouse 923-926-927-928

timeRecord923Homecage=(Wake923Homecage+SWS923Homecage+REM923Homecage)
timeRecord923CNO=(Wake923CNO+SWS923CNO+REM923CNO)
timeRecord926Homecage=(Wake926Homecage+SWS926Homecage+REM926Homecage)
timeRecord926CNO=(Wake926CNO+SWS926CNO+REM926CNO)

PlotErrorBarN_KJ({timeRecord923Homecage, timeRecord923CNO,timeRecord926Homecage, timeRecord926CNO})




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
