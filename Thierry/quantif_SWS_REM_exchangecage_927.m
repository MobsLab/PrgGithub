%% Script pour analyse des changements de cages en CNO / Saline
%% Homecage1 day 2

cd /media/nas5/Thierry_DATA/Exchange Cages/927_927_927_928_Baseline2_02072019_190702_085527/M927_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage1
SWS927Homecage1DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS927Homecage1Start=Start(SWSEpoch)./(1e4);
SWS927Homecage1End=End(SWSEpoch)./(1e4);
SWS927Homecage1DurationEpisods=SWS927Homecage1End-SWS927Homecage1Start;%durée de chaque épisode
Nb_SWSEpoch927Homecage1 = length(SWS927Homecage1Start);%Nombre d'épisodes de SWS

%WAKE Homecage1
Wake927Homecage1DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake927Homecage1Start = Start(Wake)./(1e4);
Wake927Homecage1End = End(Wake)./(1e4); 
Wake927Homecage1DurationEpisods=Wake927Homecage1End-Wake927Homecage1Start;
Nb_WakeEpoch927Homecage1 = length(Wake927Homecage1Start); 

%REM Homecage1
REM927Homecage1DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM927Homecage1Start=Start(REMEpoch)./(1e4);
REM927Homecage1End=End(REMEpoch)./(1e4);
REM927Homecage1DurationEpisods=REM927Homecage1End-REM927Homecage1Start;
Nb_REMEpoch927Homecage1 = length(REM927Homecage1Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_927_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_927_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_927_Homecage1=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_927_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_927_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_927_Homecage1 PercWake_Total_927_Homecage1 PercREM_Total_927_Homecage1]
PlotErrorBarN_KJ({PercWake_Total_927_Homecage1 PercSWS_Total_927_Homecage1 PercREM_Total_927_Homecage1})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 927 Homecage1)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch927Homecage1 Nb_SWSEpoch927Homecage1 Nb_REMEpoch927Homecage1] 
PlotErrorBarN_KJ({Nb_WakeEpoch927Homecage1 Nb_SWSEpoch927Homecage1 Nb_REMEpoch927Homecage1})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 927 Homecage1)')
xticklabels({'Wake Homecage1','SWS Homecage1','REM Homecage1'})

%Total sleep duration Homecage1
TotalSleep927Homecage1=SWS927Homecage1DurationTot+REM927Homecage1DurationTot;
TotalSession927Homecage1=Wake927Homecage1DurationTot+SWS927Homecage1DurationTot+REM927Homecage1DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_927 = length(Start(Wake)); 
% sb2_927 = length(Start(SWSEpoch)); 
% rb2_927 = length(Start(REMEpoch)); 
% allb2_927 = wb2_927+sb2_927+rb2_927; 
% wpb2_927 = wb2_927/allb2_927*100; 
% spb2_927 = sb2_927/allb2_927*100; 
% rpb2_927 = rb2_927/allb2_927*100;


%% Calcul REM 1/3 - 2/3 - 3/3 Homecage1


try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimHomecage1=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);

numpointsHomecage1=floor(maxlimHomecage1/pas/1E4)+1;

for i=1:numpointsHomecage1
    perHomecage1(i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsHomecage1(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

% function [PercFirstHalf, PercSecHalf, PercFirstThird,PercSecThird,PercLastThird]=PercREMFirstSecHalf(REMEpoch,SWSEpoch,Wake,pas,plo)

PercFirstHalfHomecage1_927=nanmean(perHomecage1(1:length(perHomecage1)/2));
PercSecHalfHomecage1_927=nanmean(perHomecage1(length(perHomecage1)/2:end));

PercFirstThirdHomecage1_927=nanmean(perHomecage1(1:length(perHomecage1)/3))
PercSecThirdHomecage1_927=nanmean(perHomecage1(length(perHomecage1)/3:2*length(perHomecage1)/3))
PercLastThirdHomecage1_927=nanmean(perHomecage1(2*length(perHomecage1)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage1_927 PercSecHalfHomecage1_927 PercFirstThirdHomecage1_927 PercSecThirdHomecage1_927 PercLastThirdHomecage1_927})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage1')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

% if plo
SleepStagesHomecage1=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsHomecage1/1E4,rescale(perHomecage1,-1,2),'ro-')
% end



%% CNO day 3

cd /media/nas5/Thierry_DATA/Exchange Cages/927_927_927_928_CNO_Saline_03072019_190703_091346/Mouse927_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS CNO
SWS927CNODurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS927CNOStart=Start(SWSEpoch)./(1e4);
SWS927CNOEnd=End(SWSEpoch)./(1e4);
SWS927CNODurationEpisods=SWS927CNOEnd-SWS927CNOStart;%durée de chaque épisode
Nb_SWSEpoch927CNO = length(SWS927CNOStart);%Nombre d'épisodes de SWS

%WAKE CNO 
Wake927CNODurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake927CNOStart = Start(Wake)./(1e4);
Wake927CNOEnd = End(Wake)./(1e4); 
Wake927CNODurationEpisods=Wake927CNOEnd-Wake927CNOStart;
Nb_WakeEpoch927CNO = length(Wake927CNOStart); 

%REM CNO 
REM927CNODurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM927CNOStart=Start(REMEpoch)./(1e4);
REM927CNOEnd=End(REMEpoch)./(1e4);
REM927CNODurationEpisods=REM927CNOEnd-REM927CNOStart;
Nb_REMEpoch927CNO = length(REM927CNOStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_927_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_927_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_927_CNO=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_927_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_927_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_927_CNO PercWake_Total_927_CNO PercREM_Total_927_CNO]
PlotErrorBarN_KJ({PercWake_Total_927_CNO PercSWS_Total_927_CNO PercREM_Total_927_CNO})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 927 CNO)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch927CNO Nb_SWSEpoch927CNO Nb_REMEpoch927CNO] 
PlotErrorBarN_KJ({Nb_WakeEpoch927CNO Nb_SWSEpoch927CNO Nb_REMEpoch927CNO})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 927 CNO)')
xticklabels({'Wake CNO','SWS CNO','REM CNO'})

%Total sleep duration CNO
TotalSleep927CNO=SWS927CNODurationTot+REM927CNODurationTot;
TotalSession927CNO=Wake927CNODurationTot+SWS927CNODurationTot+REM927CNODurationTot;

% % stages %
% wcno1_927 = length(Start(Wake)); 
% scno1_927 = length(Start(SWSEpoch));
% rcno1_927 = length(Start(REMEpoch));
% allcno1_927 = wcno1_927+scno1_927+rcno1_927;
% wpcno1_927 = wcno1_927/allcno1_927*100;
% spcno1_927 = scno1_927/allcno1_927*100;
% rpcno1_927 = rcno1_927/allcno1_927*100;

%% Calcul REM 1/3 - 2/3 - 3/3 CNO

try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimCNO=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);

numpointsCNO=floor(maxlimCNO/pas/1E4)+1;

for i=1:numpointsCNO
    perCNO(i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsCNO(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

% function [PercFirstHalf, PercSecHalf, PercFirstThird,PercSecThird,PercLastThird]=PercREMFirstSecHalf(REMEpoch,SWSEpoch,Wake,pas,plo)

PercFirstHalfCNO_927=nanmean(perCNO(1:length(perCNO)/2));
PercSecHalfCNO_927=nanmean(perCNO(length(perCNO)/2:end));

PercFirstThirdCNO_927=nanmean(perCNO(1:length(perCNO)/3))
PercSecThirdCNO_927=nanmean(perCNO(length(perCNO)/3:2*length(perCNO)/3))
PercLastThirdCNO_927=nanmean(perCNO(2*length(perCNO)/3:end))

PlotErrorBarN_KJ({PercFirstHalfCNO_927 PercSecHalfCNO_927 PercFirstThirdCNO_927 PercSecThirdCNO_927 PercLastThirdCNO_927})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods CNO')
xticklabels({'FirstHalf','SeconHalf','FirstThird','SecondThird', 'LastThird'})
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

% if plo
SleepStagesCNO=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsCNO/1E4,rescale(perCNO,-1,2),'ro-')
% end


%% Homecage2 day 4

cd /media/nas5/Thierry_DATA/Exchange Cages/927_927_927_928_Baseline3_04072019_190704_090313/M927_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage2
SWS927Homecage2DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS927Homecage2Start=Start(SWSEpoch)./(1e4);
SWS927Homecage2End=End(SWSEpoch)./(1e4);
SWS927Homecage2DurationEpisods=SWS927Homecage2End-SWS927Homecage2Start;%durée de chaque épisode
Nb_SWSEpoch927Homecage2 = length(SWS927Homecage2Start);%Nombre d'épisodes de SWS

%WAKE Homecage2
Wake927Homecage2DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake927Homecage2Start = Start(Wake)./(1e4);
Wake927Homecage2End = End(Wake)./(1e4); 
Wake927Homecage2DurationEpisods=Wake927Homecage2End-Wake927Homecage2Start;
Nb_WakeEpoch927Homecage2 = length(Wake927Homecage2Start); 

%REM Homecage2
REM927Homecage2DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM927Homecage2Start=Start(REMEpoch)./(1e4);
REM927Homecage2End=End(REMEpoch)./(1e4);
REM927Homecage2DurationEpisods=REM927Homecage2End-REM927Homecage2Start;
Nb_REMEpoch927Homecage2 = length(REM927Homecage2Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_927_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_927_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_927_Homecage2=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_927_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_927_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_927_Homecage2 PercWake_Total_927_Homecage2 PercREM_Total_927_Homecage2]
PlotErrorBarN_KJ({PercWake_Total_927_Homecage2 PercSWS_Total_927_Homecage2 PercREM_Total_927_Homecage2})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 927 Homecage2)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch927Homecage2 Nb_SWSEpoch927Homecage2 Nb_REMEpoch927Homecage2] 
PlotErrorBarN_KJ({Nb_WakeEpoch927Homecage2 Nb_SWSEpoch927Homecage2 Nb_REMEpoch927Homecage2})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 927 Homecage2)')
xticklabels({'Wake Homecage2','SWS Homecage2','REM Homecage2'})

%Total sleep duration Homecage2 Mouse 1
TotalSleep927Homecage2=SWS927Homecage2DurationTot+REM927Homecage2DurationTot;
TotalSession927Homecage2=Wake927Homecage2DurationTot+SWS927Homecage2DurationTot+REM927Homecage2DurationTot;

% % stages %
% wb3_927 = length(Start(Wake)); 
% sb3_927 = length(Start(SWSEpoch));
% rb3_927 = length(Start(REMEpoch));
% allb3_927 = wb3_927+sb3_927+rb3_927;
% wpb3_927 = wb3_927/allb3_927*100
% spb3_927 = sb3_927/allb3_927*100;
% rpb3_927 = rb3_927/allb3_927*100;

%% Calcul REM 1/3 - 2/3 - 3/3 Homecage2


try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimHomecage2=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);

numpointsHomecage2=floor(maxlimHomecage2/pas/1E4)+1;

for i=1:numpointsHomecage2
    perHomecage2(i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsHomecage2(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

% function [PercFirstHalf, PercSecHalf, PercFirstThird,PercSecThird,PercLastThird]=PercREMFirstSecHalf(REMEpoch,SWSEpoch,Wake,pas,plo)

PercFirstHalfHomecage2_927=nanmean(perHomecage2(1:length(perHomecage2)/2));
PercSecHalfHomecage2_927=nanmean(perHomecage2(length(perHomecage2)/2:end));

PercFirstThirdHomecage2_927=nanmean(perHomecage2(1:length(perHomecage2)/3))
PercSecThirdHomecage2_927=nanmean(perHomecage2(length(perHomecage2)/3:2*length(perHomecage2)/3))
PercLastThirdHomecage2_927=nanmean(perHomecage2(2*length(perHomecage2)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage2_927 PercSecHalfHomecage2_927 PercFirstThirdHomecage2_927 PercSecThirdHomecage2_927 PercLastThirdHomecage2_927})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage2')
xticklabels({'FirstHalf','SeconHalf','FirstThird','SecondThird', 'LastThird'})
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

%if plo
SleepStagesHomecage2=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsHomecage2/1E4,rescale(perHomecage2,-1,2),'ro-')
%end

%% Saline day 5

cd /media/nas5/Thierry_DATA/Exchange Cages/927_927_927_928_CNO_saline_2_05072019_190705_093630/M927_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Saline
SWS927SalineDurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS927SalineStart=Start(SWSEpoch)./(1e4);
SWS927SalineEnd=End(SWSEpoch)./(1e4);
SWS927SalineDurationEpisods=SWS927SalineEnd-SWS927SalineStart;%durée de chaque épisode
Nb_SWSEpoch927Saline = length(SWS927SalineStart);%Nombre d'épisodes de SWS

%WAKE Saline 
Wake927SalineDurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake927SalineStart = Start(Wake)./(1e4);
Wake927SalineEnd = End(Wake)./(1e4); 
Wake927SalineDurationEpisods=Wake927SalineEnd-Wake927SalineStart;
Nb_WakeEpoch927Saline = length(Wake927SalineStart); 

%REM Saline 
REM927SalineDurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM927SalineStart=Start(REMEpoch)./(1e4);
REM927SalineEnd=End(REMEpoch)./(1e4);
REM927SalineDurationEpisods=REM927SalineEnd-REM927SalineStart;
Nb_REMEpoch927Saline = length(REM927SalineStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_927_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_927_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_927_Saline=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_927_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_927_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_927_Saline PercWake_Total_927_Saline PercREM_Total_927_Saline]
PlotErrorBarN_KJ({PercWake_Total_927_Saline PercSWS_Total_927_Saline PercREM_Total_927_Saline})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 927 Saline)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch927Saline Nb_SWSEpoch927Saline Nb_REMEpoch927Saline] 
PlotErrorBarN_KJ({Nb_WakeEpoch927Saline Nb_SWSEpoch927Saline Nb_REMEpoch927Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 927 Saline)')
xticklabels({'Wake Saline','SWS Saline','REM Saline'})

%Total sleep duration Saline
TotalSleep927Saline=SWS927SalineDurationTot+REM927SalineDurationTot;
TotalSession927Saline=Wake927SalineDurationTot+SWS927SalineDurationTot+REM927SalineDurationTot;

%% Calcul REM 1/3 - 2/3 - 3/3 Saline


try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlimSaline=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);

numpointsSaline=floor(maxlimSaline/pas/1E4)+1;

for i=1:numpointsSaline
    perSaline(i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSaline(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

% function [PercFirstHalf, PercSecHalf, PercFirstThird,PercSecThird,PercLastThird]=PercREMFirstSecHalf(REMEpoch,SWSEpoch,Wake,pas,plo)

PercFirstHalfSaline_927=nanmean(perSaline(1:length(perSaline)/2));
PercSecHalfSaline_927=nanmean(perSaline(length(perSaline)/2:end));

PercFirstThirdSaline_927=nanmean(perSaline(1:length(perSaline)/3))
PercSecThirdSaline_927=nanmean(perSaline(length(perSaline)/3:2*length(perSaline)/3))
PercLastThirdSaline_927=nanmean(perSaline(2*length(perSaline)/3:end))

PlotErrorBarN_KJ({PercFirstHalfSaline_927 PercSecHalfSaline_927 PercFirstThirdSaline_927 PercSecThirdSaline_927 PercLastThirdSaline_927})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Saline')
xticklabels({'FirstHalf','SeconHalf','FirstThird','SecondThird', 'LastThird'})
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

%if plo
SleepStagesSaline=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsSaline/1E4,rescale(perSaline,-1,2),'ro-')
%end

%% % stages %
% wsal_927 = length(Start(Wake)); 
% ssal_927 = length(Start(SWSEpoch));
% rsal_927 = length(Start(REMEpoch));
% allsal_927 = wsal_927+ssal_927+rsal_927;
% wpsal_927 = wsal_927/allsal_927*100
% spsal_927 = ssal_927/allsal_927*100;
% rpsal_927 = rsal_927/allsal_927*100;
%
% f = figure('Position', [0 0 1000 400]);
%     subplot(2,2,1)
%     bar([spb2_927 wpb2_927 rpb2_927],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('927 Sleep stages proportion Homecage 1')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,2)
%     bar([spcno1_927 wpcno1_927 rpcno1_927],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('927 Sleep stages proportion CNO')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,3)
%     bar([spb3_927 wpb3_927 rpb3_927],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('927 Sleep stages proportion Homacage 2')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,4)
%     bar([spsal_927 wpsal_927 rpsal_927],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('927 Sleep stages proportion Saline')
%     xticklabels({'SWS','Wake','REM'})

%% CNO vs Homecage1
%Ratio (REM/SWS)
ra_RemSwsCNO927=(REM927CNODurationTot)/(SWS927CNODurationTot);
ra_RemSwsHomecage1_927=(REM927Homecage1DurationTot)/(SWS927Homecage1DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep927Homecage1=(Wake927Homecage1DurationTot)./(TotalSleep927Homecage1);
ra_WakeSleep927CNO=(Wake927CNODurationTot)./(TotalSleep927CNO);

%Calcul ratio SWS vs Total Sleep
ra927_CNO_SWSTotal=SWS927CNODurationTot./TotalSleep927CNO;
ra927_Homecage1_SWSTotal=SWS927Homecage1DurationTot./TotalSleep927Homecage1;
%Calcul ratio REM vs Total Sleep
ra927_Homecage1_REMTotal=REM927Homecage1DurationTot./TotalSleep927Homecage1;
ra927_CNO_REMTotal=REM927CNODurationTot./TotalSleep927CNO;
[ra927_Homecage1_SWSTotal ra927_CNO_SWSTotal ra927_Homecage1_REMTotal ra927_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra927_Homecage1_SWSTotal ra927_CNO_SWSTotal ra927_Homecage1_REMTotal ra927_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in homecage1 vs Exchange Cage CNO (Mouse 927)')
xticklabels({'SWS/Sleep Homecage1','SWS/Sleep Exchange CNO','REM/Sleep Homecage1','REM/Sleep Exchange CNO'})

%% CNO vs Homecage2
%Ratio (REM/SWS)
ra_RemSwsCNO927=(REM927CNODurationTot)/(SWS927CNODurationTot);
ra_RemSwsHomecage2_927=(REM927Homecage2DurationTot)/(SWS927Homecage2DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep927Homecage2=(Wake927Homecage2DurationTot)./(TotalSleep927Homecage2);
ra_WakeSleep927CNO=(Wake927CNODurationTot)./(TotalSleep927CNO);

%Calcul ratio SWS vs Total Sleep
ra927_CNO_SWSTotal=SWS927CNODurationTot./TotalSleep927CNO;
ra927_Homecage2_SWSTotal=SWS927Homecage2DurationTot./TotalSleep927Homecage2;
%Calcul ratio REM vs Total Sleep
ra927_Homecage2_REMTotal=REM927Homecage2DurationTot./TotalSleep927Homecage2;
ra927_CNO_REMTotal=REM927CNODurationTot./TotalSleep927CNO;
[ra927_Homecage2_SWSTotal ra927_CNO_SWSTotal ra927_Homecage2_REMTotal ra927_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra927_Homecage2_SWSTotal ra927_CNO_SWSTotal ra927_Homecage2_REMTotal ra927_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Homecage2 vs Exchange Cage CNO (Mouse 927)')
xticklabels({'SWS/Sleep Homecage2','SWS/Sleep Exchange CNO','REM/Sleep Homecage2','REM/Sleep Exchange CNO'})

%create histogram distributions 
histogram((REM927Homecage1DurationEpisods),20)
hold on
histogram((REM927CNODurationEpisods),20)

histogram((REM927Homecage2DurationEpisods),20)
hold on
histogram((REM927CNODurationEpisods),20)

%% CNO vs Saline
%Ratio (REM/SWS)
ra_RemSwsCNO927=(REM927CNODurationTot)/(SWS927CNODurationTot);
ra_RemSwsSaline927=(REM927SalineDurationTot)/(SWS927SalineDurationTot);

%Ratio (Wake/Sleep)
ra_WakeTsleep927Saline=(Wake927SalineDurationTot)./(TotalSleep927Saline);
ra_WakeTsleep927CNO=(Wake927CNODurationTot)./(TotalSleep927CNO);

%Calcul ratio SWS vs Total Sleep 
ra927_CNO_SWSTotal=SWS927CNODurationTot./TotalSleep927CNO;
ra927_Saline_SWSTotal=SWS927SalineDurationTot./TotalSleep927Saline;

%Calcul ratio REM vs Total Sleep
ra927_Saline_REMTotal=REM927SalineDurationTot./TotalSleep927Saline;
ra927_CNO_REMTotal=REM927CNODurationTot./TotalSleep927CNO;
[ra927_Saline_SWSTotal ra927_CNO_SWSTotal ra927_Saline_REMTotal ra927_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra927_Saline_SWSTotal ra927_CNO_SWSTotal ra927_Saline_REMTotal ra927_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Saline vs Exchange Cage CNO (Mouse 927)')
xticklabels({'','SWS/Sleep Exchange Saline','SWS/Sleep Exchange CNO','REM/Sleep Exchange Saline','REM/Sleep Exchange CNO'})



%% tracer les spectres de l'hippocampe pour chaque état
clear all
 

%REM
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M927_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse927_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M927_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M927_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power REM (M927)')
set(gca,'FontSize',14)

clear all

%Wake
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M927_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse927_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M927_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,Wake))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M927_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,Wake))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power Wake (M927)')
set(gca,'FontSize',14)

clear all

%SWS
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M927_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse927_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M927_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M927_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power SWS (M927)')
set(gca,'FontSize',14)


%% tracer les spectres de l'hippocampe pour chaque état
clear all

%REM
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M927_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M927_CNO_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M927_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/M927_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power REM (M927)')
set(gca,'FontSize',14)

clear all

%Wake
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M927_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M927_CNO_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M927_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,Wake))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/M927_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,Wake))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power Wake (M927)')
set(gca,'FontSize',14)

clear all

%SWS
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M927_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M927_CNO_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M927_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/M927_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power SWS (M927)')
set(gca,'FontSize',14)



% %%%%%%%
% cd /media/nas5/Thierry_DATA/Exchange Cages/927_927_927_927_Baseline2_02072019_190702_085527/Mouse927
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS Homecage Mouse2
% SWS927Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS927HomecageStart=Start(SWSEpoch)./(1e4)
% SWS927HomecageEnd=End(SWSEpoch)./(1e4)
% SWS927HomecageDuration=SWS927HomecageEnd-SWS927HomecageStart
% Nb_SWSEpoch927Homecage = length(SWS927HomecageStart); 
% 
% %WAKE Homecage Mouse2
% Wake927Homecage=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake927HomecageStart = Start(Wake)./(1e4);
% Wake927HomecageEnd = End(Wake)./(1e4); 
% Wake927HomecageDuration=Wake927HomecageEnd-Wake927HomecageStart
% Nb_WakeEpoch927Homecage = length(Wake927HomecageStart); 
% 
% %REM Homecage Mouse2
% REM927Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM927HomecageStart=Start(REMEpoch)./(1e4)
% REM927HomecageEnd=End(REMEpoch)./(1e4)
% REM927HomecageDuration=REM927HomecageEnd-REM927HomecageStart
% Nb_REMEpoch927Homecage = length(REM927HomecageStart); 
% 
% %Total sleep duration Homecage Mouse2
% TotalSleep927Homecage=SWS927Homecage+REM927Homecage
% 
% cd /media/mobs/MOBs96/M927_Sleep_cage_changed_day_07112018
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS CNO Mouse2
% SWS927CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS927CNOStart=Start(SWSEpoch)./(1e4)
% SWS927CNOEnd=End(SWSEpoch)./(1e4)
% SWS927CNODuration=SWS927CNOEnd-SWS927CNOStart
% Nb_SWSEpoch927CNO = length(SWS927CNOStart); 
% 
% %WAKE CNO Mouse2
% Wake927CNO=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake927CNOStart = Start(Wake)./(1e4);
% Wake927CNOEnd = End(Wake)./(1e4); 
% Wake927CNODuration=Wake927CNOEnd-Wake927CNOStart
% Nb_WakeEpoch927CNO = length(Wake927CNOStart); 
% 
% %REM CNO Mouse2
% REM927CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM927CNOStart=Start(REMEpoch)./(1e4)
% REM927CNOEnd=End(REMEpoch)./(1e4)
% REM927CNODuration=REM927CNOEnd-REM927CNOStart
% Nb_REMEpoch927CNO = length(REM927CNOStart); 
% 
% %Total sleep duration CNO Mouse2
% TotalSleep927CNO=SWS927CNO+REM927CNO

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Ratio (REM/SWS) Mouse2
% ra_RemSwsCNO927=(REM927CNO)/(SWS927CNO)
% ra_RemSwsHomecage927=(REM927Homecage)/(SWS927Homecage)
% 
% %Ratio (Wake/Sleep) Mouse2
% ra_WakeTsleep927Homecage=(Wake927Homecage)./(TotalSleep927Homecage)
% ra_WakeTsleep927CNO=(Wake927CNO)./(TotalSleep927CNO)
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
% ra927_CNO_SWSTotal=SWS927CNO./TotalSleep927CNO;
% ra927_Homecage_SWSTotal=SWS927Homecage./TotalSleep927Homecage;
% ra927_Homecage_REMTotal=REM927Homecage./TotalSleep927Homecage;
% ra927_CNO_REMTotal=REM927CNO./TotalSleep927CNO;
% [ra927_Homecage_SWSTotal ra927_CNO_SWSTotal ra927_Homecage_REMTotal ra927_CNO_REMTotal]
%  
% PlotErrorBarN_KJ({ra927_Homecage_SWSTotal ra927_CNO_SWSTotal ra927_Homecage_REMTotal ra927_CNO_REMTotal})
% 
% %Create histogram distributions Mouse 2
% histogram((REM927HomecageDuration),20)
% hold on
% histogram((REM927CNODuration),20)
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 927-927-927-927
% ra_Homecage_SWSTotal=[ra927_Homecage_SWSTotal ra927_Homecage_SWSTotal ra927_Homecage_SWSTotal ra927_Homecage_SWSTotal]
% ra_CNO_SWSTotal=[ra927_CNO_SWSTotal ra927_CNO_SWSTotal ra927_CNO_SWSTotal ra927_CNO_SWSTotal]
% 
% ra_Homecage_REMTotal=[ra927_Homecage_REMTotal ra927_Homecage_REMTotal ra927_Homecage_REMTotal ra927_Homecage_REMTotal]
% ra_CNO_REMTotal=[ra927_CNO_REMTotal ra927_CNO_REMTotal ra927_CNO_REMTotal ra927_CNO_REMTotal]
% 
% PlotErrorBarN_KJ({ra_Homecage_SWSTotal,ra_CNO_SWSTotal})
% PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal})
% 
% 
% %Calcul durée total recordings Mouse 927-927-927-927
% 
% timeRecord927Homecage=(Wake927Homecage+SWS927Homecage+REM927Homecage)
% timeRecord927CNO=(Wake927CNO+SWS927CNO+REM927CNO)
% timeRecord927Homecage=(Wake927Homecage+SWS927Homecage+REM927Homecage)
% timeRecord927CNO=(Wake927CNO+SWS927CNO+REM927CNO)
% 
% PlotErrorBarN_KJ({timeRecord927Homecage, timeRecord927CNO,timeRecord927Homecage, timeRecord927CNO})
% 
% 
% 
% 
% % %Hypnogram
% % 
% % CreateSleepSignals('recompute',0,'scoring','accelero');
% % 
% % %% Substages disp('getting sleep stages') [featuresNREM, Namesfeatures,
% % EpochSleep, NoiseEpoch, scoring] =
% % FindNREMfeatures('scoring','accelero'); save('FeaturesScoring',
% % 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
% % [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
% % save('SleepSubstages', 'Epoch', 'NameEpoch')
% % 
% % %% Id figure 1 disp('making ID fig1') MakeIDSleepData PlotIDSleepData
% % saveas(1,'IDFig1.png') close all
% % 
% % %% Id figure 2 disp('making ID fig2') MakeIDSleepData2 PlotIDSleepData2
% % saveas(1,'IDFig2.png') close all
