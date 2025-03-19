%% Script pour analyse des changements de cages en CNO / Saline
%% Homecage1 day 2

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Baseline2_02072019_190702_085527/M923_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage1
SWS923Homecage1DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS923Homecage1Start=Start(SWSEpoch)./(1e4);
SWS923Homecage1End=End(SWSEpoch)./(1e4);
SWS923Homecage1DurationEpisods=SWS923Homecage1End-SWS923Homecage1Start;%durée de chaque épisode
Nb_SWSEpoch923Homecage1 = length(SWS923Homecage1Start);%Nombre d'épisodes de SWS

%WAKE Homecage1
Wake923Homecage1DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake923Homecage1Start = Start(Wake)./(1e4);
Wake923Homecage1End = End(Wake)./(1e4); 
Wake923Homecage1DurationEpisods=Wake923Homecage1End-Wake923Homecage1Start;
Nb_WakeEpoch923Homecage1 = length(Wake923Homecage1Start); 

%REM Homecage1
REM923Homecage1DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM923Homecage1Start=Start(REMEpoch)./(1e4);
REM923Homecage1End=End(REMEpoch)./(1e4);
REM923Homecage1DurationEpisods=REM923Homecage1End-REM923Homecage1Start;
Nb_REMEpoch923Homecage1 = length(REM923Homecage1Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_923_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_923_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_923_Homecage1=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_923_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_923_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_923_Homecage1 PercWake_Total_923_Homecage1 PercREM_Total_923_Homecage1]
PlotErrorBarN_KJ({PercWake_Total_923_Homecage1 PercSWS_Total_923_Homecage1 PercREM_Total_923_Homecage1})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 923 Homecage1)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch923Homecage1 Nb_SWSEpoch923Homecage1 Nb_REMEpoch923Homecage1] 
PlotErrorBarN_KJ({Nb_WakeEpoch923Homecage1 Nb_SWSEpoch923Homecage1 Nb_REMEpoch923Homecage1})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 923 Homecage1)')
xticklabels({'Wake Homecage1','SWS Homecage1','REM Homecage1'})

%Total sleep duration Homecage1
TotalSleep923Homecage1=SWS923Homecage1DurationTot+REM923Homecage1DurationTot;
TotalSession923Homecage1=Wake923Homecage1DurationTot+SWS923Homecage1DurationTot+REM923Homecage1DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_923 = length(Start(Wake)); 
% sb2_923 = length(Start(SWSEpoch)); 
% rb2_923 = length(Start(REMEpoch)); 
% allb2_923 = wb2_923+sb2_923+rb2_923; 
% wpb2_923 = wb2_923/allb2_923*100; 
% spb2_923 = sb2_923/allb2_923*100; 
% rpb2_923 = rb2_923/allb2_923*100;


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

PercFirstHalfHomecage1_923=nanmean(perHomecage1(1:length(perHomecage1)/2));
PercSecHalfHomecage1_923=nanmean(perHomecage1(length(perHomecage1)/2:end));

PercFirstThirdHomecage1_923=nanmean(perHomecage1(1:length(perHomecage1)/3))
PercSecThirdHomecage1_923=nanmean(perHomecage1(length(perHomecage1)/3:2*length(perHomecage1)/3))
PercLastThirdHomecage1_923=nanmean(perHomecage1(2*length(perHomecage1)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage1_923 PercSecHalfHomecage1_923 PercFirstThirdHomecage1_923 PercSecThirdHomecage1_923 PercLastThirdHomecage1_923})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage1')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

if plo
SleepStagesHomecage1=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsHomecage1/1E4,rescale(perHomecage1,-1,2),'ro-')
end



%% CNO day 3

cd /media/nas5/Thierry_DATA/Exchange Cages/923_926_927_928_CNO_Saline_03072019_190703_091346/Mouse923_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS CNO
SWS923CNODurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS923CNOStart=Start(SWSEpoch)./(1e4);
SWS923CNOEnd=End(SWSEpoch)./(1e4);
SWS923CNODurationEpisods=SWS923CNOEnd-SWS923CNOStart;%durée de chaque épisode
Nb_SWSEpoch923CNO = length(SWS923CNOStart);%Nombre d'épisodes de SWS

%WAKE CNO 
Wake923CNODurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake923CNOStart = Start(Wake)./(1e4);
Wake923CNOEnd = End(Wake)./(1e4); 
Wake923CNODurationEpisods=Wake923CNOEnd-Wake923CNOStart;
Nb_WakeEpoch923CNO = length(Wake923CNOStart); 

%REM CNO 
REM923CNODurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM923CNOStart=Start(REMEpoch)./(1e4);
REM923CNOEnd=End(REMEpoch)./(1e4);
REM923CNODurationEpisods=REM923CNOEnd-REM923CNOStart;
Nb_REMEpoch923CNO = length(REM923CNOStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_923_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_923_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_923_CNO=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_923_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_923_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_923_CNO PercWake_Total_923_CNO PercREM_Total_923_CNO]
PlotErrorBarN_KJ({PercWake_Total_923_CNO PercSWS_Total_923_CNO PercREM_Total_923_CNO})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 923 CNO)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch923CNO Nb_SWSEpoch923CNO Nb_REMEpoch923CNO] 
PlotErrorBarN_KJ({Nb_WakeEpoch923CNO Nb_SWSEpoch923CNO Nb_REMEpoch923CNO})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 923 CNO)')
xticklabels({'Wake CNO','SWS CNO','REM CNO'})

%Total sleep duration CNO
TotalSleep923CNO=SWS923CNODurationTot+REM923CNODurationTot;
TotalSession923CNO=Wake923CNODurationTot+SWS923CNODurationTot+REM923CNODurationTot;

% % stages %
% wcno1_923 = length(Start(Wake)); 
% scno1_923 = length(Start(SWSEpoch));
% rcno1_923 = length(Start(REMEpoch));
% allcno1_923 = wcno1_923+scno1_923+rcno1_923;
% wpcno1_923 = wcno1_923/allcno1_923*100;
% spcno1_923 = scno1_923/allcno1_923*100;
% rpcno1_923 = rcno1_923/allcno1_923*100;

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

PercFirstHalfCNO_923=nanmean(perCNO(1:length(perCNO)/2));
PercSecHalfCNO_923=nanmean(perCNO(length(perCNO)/2:end));

PercFirstThirdCNO_923=nanmean(perCNO(1:length(perCNO)/3))
PercSecThirdCNO_923=nanmean(perCNO(length(perCNO)/3:2*length(perCNO)/3))
PercLastThirdCNO_923=nanmean(perCNO(2*length(perCNO)/3:end))

PlotErrorBarN_KJ({PercFirstHalfCNO_923 PercSecHalfCNO_923 PercFirstThirdCNO_923 PercSecThirdCNO_923 PercLastThirdCNO_923})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods CNO')
xticklabels({'FirstHalf','SeconHalf','FirstThird','SecondThird', 'LastThird'})
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

if plo
SleepStagesCNO=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsCNO/1E4,rescale(perCNO,-1,2),'ko-')
end


%% Homecage2 day 4

cd /media/nas5/Thierry_DATA/Exchange Cages/923_926_927_928_Baseline3_04072019_190704_090313/M923_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage2
SWS923Homecage2DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS923Homecage2Start=Start(SWSEpoch)./(1e4);
SWS923Homecage2End=End(SWSEpoch)./(1e4);
SWS923Homecage2DurationEpisods=SWS923Homecage2End-SWS923Homecage2Start;%durée de chaque épisode
Nb_SWSEpoch923Homecage2 = length(SWS923Homecage2Start);%Nombre d'épisodes de SWS

%WAKE Homecage2
Wake923Homecage2DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake923Homecage2Start = Start(Wake)./(1e4);
Wake923Homecage2End = End(Wake)./(1e4); 
Wake923Homecage2DurationEpisods=Wake923Homecage2End-Wake923Homecage2Start;
Nb_WakeEpoch923Homecage2 = length(Wake923Homecage2Start); 

%REM Homecage2
REM923Homecage2DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM923Homecage2Start=Start(REMEpoch)./(1e4);
REM923Homecage2End=End(REMEpoch)./(1e4);
REM923Homecage2DurationEpisods=REM923Homecage2End-REM923Homecage2Start;
Nb_REMEpoch923Homecage2 = length(REM923Homecage2Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_923_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_923_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_923_Homecage2=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_923_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_923_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_923_Homecage2 PercWake_Total_923_Homecage2 PercREM_Total_923_Homecage2]
PlotErrorBarN_KJ({PercWake_Total_923_Homecage2 PercSWS_Total_923_Homecage2 PercREM_Total_923_Homecage2})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 923 Homecage2)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch923Homecage2 Nb_SWSEpoch923Homecage2 Nb_REMEpoch923Homecage2] 
PlotErrorBarN_KJ({Nb_WakeEpoch923Homecage2 Nb_SWSEpoch923Homecage2 Nb_REMEpoch923Homecage2})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 923 Homecage2)')
xticklabels({'Wake Homecage2','SWS Homecage2','REM Homecage2'})

%Total sleep duration Homecage2 Mouse 1
TotalSleep923Homecage2=SWS923Homecage2DurationTot+REM923Homecage2DurationTot;
TotalSession923Homecage2=Wake923Homecage2DurationTot+SWS923Homecage2DurationTot+REM923Homecage2DurationTot;

% % stages %
% wb3_923 = length(Start(Wake)); 
% sb3_923 = length(Start(SWSEpoch));
% rb3_923 = length(Start(REMEpoch));
% allb3_923 = wb3_923+sb3_923+rb3_923;
% wpb3_923 = wb3_923/allb3_923*100
% spb3_923 = sb3_923/allb3_923*100;
% rpb3_923 = rb3_923/allb3_923*100;

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

PercFirstHalfHomecage2_923=nanmean(perHomecage2(1:length(perHomecage2)/2));
PercSecHalfHomecage2_923=nanmean(perHomecage2(length(perHomecage2)/2:end));

PercFirstThirdHomecage2_923=nanmean(perHomecage2(1:length(perHomecage2)/3))
PercSecThirdHomecage2_923=nanmean(perHomecage2(length(perHomecage2)/3:2*length(perHomecage2)/3))
PercLastThirdHomecage2_923=nanmean(perHomecage2(2*length(perHomecage2)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage2_923 PercSecHalfHomecage2_923 PercFirstThirdHomecage2_923 PercSecThirdHomecage2_923 PercLastThirdHomecage2_923})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage2')
xticklabels({'FirstHalf','SeconHalf','FirstThird','SecondThird', 'LastThird'})
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

if plo
SleepStagesHomecage2=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsHomecage2/1E4,rescale(perHomecage2,-1,2),'ro-')
end

%% Saline day 5

cd /media/nas5/Thierry_DATA/Exchange Cages/923_926_927_928_CNO_saline_2_05072019_190705_093630/M923_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Saline
SWS923SalineDurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS923SalineStart=Start(SWSEpoch)./(1e4);
SWS923SalineEnd=End(SWSEpoch)./(1e4);
SWS923SalineDurationEpisods=SWS923SalineEnd-SWS923SalineStart;%durée de chaque épisode
Nb_SWSEpoch923Saline = length(SWS923SalineStart);%Nombre d'épisodes de SWS

%WAKE Saline 
Wake923SalineDurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake923SalineStart = Start(Wake)./(1e4);
Wake923SalineEnd = End(Wake)./(1e4); 
Wake923SalineDurationEpisods=Wake923SalineEnd-Wake923SalineStart;
Nb_WakeEpoch923Saline = length(Wake923SalineStart); 

%REM Saline 
REM923SalineDurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM923SalineStart=Start(REMEpoch)./(1e4);
REM923SalineEnd=End(REMEpoch)./(1e4);
REM923SalineDurationEpisods=REM923SalineEnd-REM923SalineStart;
Nb_REMEpoch923Saline = length(REM923SalineStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_923_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_923_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_923_Saline=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_923_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_923_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_923_Saline PercWake_Total_923_Saline PercREM_Total_923_Saline]
PlotErrorBarN_KJ({PercWake_Total_923_Saline PercSWS_Total_923_Saline PercREM_Total_923_Saline})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 923 Saline)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch923Saline Nb_SWSEpoch923Saline Nb_REMEpoch923Saline] 
PlotErrorBarN_KJ({Nb_WakeEpoch923Saline Nb_SWSEpoch923Saline Nb_REMEpoch923Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 923 Saline)')
xticklabels({'Wake Saline','SWS Saline','REM Saline'})

%Total sleep duration Saline
TotalSleep923Saline=SWS923SalineDurationTot+REM923SalineDurationTot;
TotalSession923Saline=Wake923SalineDurationTot+SWS923SalineDurationTot+REM923SalineDurationTot;

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

PercFirstHalfSaline_923=nanmean(perSaline(1:length(perSaline)/2));
PercSecHalfSaline_923=nanmean(perSaline(length(perSaline)/2:end));

PercFirstThirdSaline_923=nanmean(perSaline(1:length(perSaline)/3))
PercSecThirdSaline_923=nanmean(perSaline(length(perSaline)/3:2*length(perSaline)/3))
PercLastThirdSaline_923=nanmean(perSaline(2*length(perSaline)/3:end))

PlotErrorBarN_KJ({PercFirstHalfSaline_923 PercSecHalfSaline_923 PercFirstThirdSaline_923 PercSecThirdSaline_923 PercLastThirdSaline_923})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Saline')
xticklabels({'FirstHalf','SeconHalf','FirstThird','SecondThird', 'LastThird'})
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

if plo
SleepStagesSaline=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsSaline/1E4,rescale(perSaline,-1,2),'ro-')
end

%% % stages %
% wsal_923 = length(Start(Wake)); 
% ssal_923 = length(Start(SWSEpoch));
% rsal_923 = length(Start(REMEpoch));
% allsal_923 = wsal_923+ssal_923+rsal_923;
% wpsal_923 = wsal_923/allsal_923*100
% spsal_923 = ssal_923/allsal_923*100;
% rpsal_923 = rsal_923/allsal_923*100;
%
% f = figure('Position', [0 0 1000 400]);
%     subplot(2,2,1)
%     bar([spb2_923 wpb2_923 rpb2_923],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('923 Sleep stages proportion Homecage 1')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,2)
%     bar([spcno1_923 wpcno1_923 rpcno1_923],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('923 Sleep stages proportion CNO')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,3)
%     bar([spb3_923 wpb3_923 rpb3_923],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('923 Sleep stages proportion Homacage 2')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,4)
%     bar([spsal_923 wpsal_923 rpsal_923],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('923 Sleep stages proportion Saline')
%     xticklabels({'SWS','Wake','REM'})

%% CNO vs Homecage1
%Ratio (REM/SWS)
ra_RemSwsCNO923=(REM923CNODurationTot)/(SWS923CNODurationTot);
ra_RemSwsHomecage1_923=(REM923Homecage1DurationTot)/(SWS923Homecage1DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep923Homecage1=(Wake923Homecage1DurationTot)./(TotalSleep923Homecage1);
ra_WakeSleep923CNO=(Wake923CNODurationTot)./(TotalSleep923CNO);

%Calcul ratio SWS vs Total Sleep
ra923_CNO_SWSTotal=SWS923CNODurationTot./TotalSleep923CNO;
ra923_Homecage1_SWSTotal=SWS923Homecage1DurationTot./TotalSleep923Homecage1;
%Calcul ratio REM vs Total Sleep
ra923_Homecage1_REMTotal=REM923Homecage1DurationTot./TotalSleep923Homecage1;
ra923_CNO_REMTotal=REM923CNODurationTot./TotalSleep923CNO;
[ra923_Homecage1_SWSTotal ra923_CNO_SWSTotal ra923_Homecage1_REMTotal ra923_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra923_Homecage1_SWSTotal ra923_CNO_SWSTotal ra923_Homecage1_REMTotal ra923_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in homecage1 vs Exchange Cage CNO (Mouse 923)')
xticklabels({'SWS/Sleep Homecage1','SWS/Sleep Exchange CNO','REM/Sleep Homecage1','REM/Sleep Exchange CNO'})

%% CNO vs Homecage2
%Ratio (REM/SWS)
ra_RemSwsCNO923=(REM923CNODurationTot)/(SWS923CNODurationTot);
ra_RemSwsHomecage2_923=(REM923Homecage2DurationTot)/(SWS923Homecage2DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep923Homecage2=(Wake923Homecage2DurationTot)./(TotalSleep923Homecage2);
ra_WakeSleep923CNO=(Wake923CNODurationTot)./(TotalSleep923CNO);

%Calcul ratio SWS vs Total Sleep
ra923_CNO_SWSTotal=SWS923CNODurationTot./TotalSleep923CNO;
ra923_Homecage2_SWSTotal=SWS923Homecage2DurationTot./TotalSleep923Homecage2;
%Calcul ratio REM vs Total Sleep
ra923_Homecage2_REMTotal=REM923Homecage2DurationTot./TotalSleep923Homecage2;
ra923_CNO_REMTotal=REM923CNODurationTot./TotalSleep923CNO;
[ra923_Homecage2_SWSTotal ra923_CNO_SWSTotal ra923_Homecage2_REMTotal ra923_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra923_Homecage2_SWSTotal ra923_CNO_SWSTotal ra923_Homecage2_REMTotal ra923_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Homecage2 vs Exchange Cage CNO (Mouse 923)')
xticklabels({'SWS/Sleep Homecage2','SWS/Sleep Exchange CNO','REM/Sleep Homecage2','REM/Sleep Exchange CNO'})

%create histogram distributions 
histogram((REM923Homecage1DurationEpisods),20)
hold on
histogram((REM923CNODurationEpisods),20)

histogram((REM923Homecage2DurationEpisods),20)
hold on
histogram((REM923CNODurationEpisods),20)

%% CNO vs Saline
%Ratio (REM/SWS)
ra_RemSwsCNO923=(REM923CNODurationTot)/(SWS923CNODurationTot);
ra_RemSwsSaline923=(REM923SalineDurationTot)/(SWS923SalineDurationTot);

%Ratio (Wake/Sleep)
ra_WakeTsleep923Saline=(Wake923SalineDurationTot)./(TotalSleep923Saline);
ra_WakeTsleep923CNO=(Wake923CNODurationTot)./(TotalSleep923CNO);

%Calcul ratio SWS vs Total Sleep 
ra923_CNO_SWSTotal=SWS923CNODurationTot./TotalSleep923CNO;
ra923_Saline_SWSTotal=SWS923SalineDurationTot./TotalSleep923Saline;

%Calcul ratio REM vs Total Sleep
ra923_Saline_REMTotal=REM923SalineDurationTot./TotalSleep923Saline;
ra923_CNO_REMTotal=REM923CNODurationTot./TotalSleep923CNO;
[ra923_Saline_SWSTotal ra923_CNO_SWSTotal ra923_Saline_REMTotal ra923_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra923_Saline_SWSTotal ra923_CNO_SWSTotal ra923_Saline_REMTotal ra923_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Saline vs Exchange Cage CNO (Mouse 923)')
xticklabels({'','SWS/Sleep Exchange Saline','SWS/Sleep Exchange CNO','REM/Sleep Exchange Saline','REM/Sleep Exchange CNO'})


%% tracer les spectres de l'hippocampe pour chaque condition

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M923_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
size(Spectro{1})% taille 
figure, imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1})'), axis xy
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
%Spectre global sur toute la nuit
figure, plot(f,mean(Data(Spectrotsd_Homecage1)))
%spectre des différents états
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'g')
hold on, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'r')
hold on, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b')
legend('REM','SWS','Wake')
xlabel('Frequency (Hz)')
ylabel('Intensity')

load('/media/nas5/Thierry_DATA/M781_processed/M781_Stimopto_REM_or_wake_5s_01102018/LFPData/LFP7.mat')
figure, plot(Range(LFP,'s'),Data(LFP))
hold on, plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'r')
figure, plot(Data(Restrict(LFP,REMEpoch)))

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse923_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
size(Spectro{1})% taille 
figure, imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1})'), axis xy
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Spectrotsd_CNO)))
figure, plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r')
hold on, plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'b')
hold on, plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'k')

load('/media/nas5/Thierry_DATA/M781_processed/M781_Stimopto_REM_or_wake_5s_01102018/LFPData/LFP7.mat')
figure, plot(Range(LFP,'s'),Data(LFP))
hold on, plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'r')
figure, plot(Data(Restrict(LFP,REMEpoch)))

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M923_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
size(Spectro{1})% taille 
figure, imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1})'), axis xy
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Spectrotsd_Homecage2)))
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'r')
hold on, plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'b')
hold on, plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,Wake))),'k')

load('/media/nas5/Thierry_DATA/M781_processed/M781_Stimopto_REM_or_wake_5s_01102018/LFPData/LFP7.mat')
figure, plot(Range(LFP,'s'),Data(LFP))
hold on, plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'r')
figure, plot(Data(Restrict(LFP,REMEpoch)))

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M923_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
size(Spectro{1})% taille 
figure, imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1})'), axis xy
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Spectrotsd_Saline)))
figure, plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'r')
hold on, plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'b')
hold on, plot(f,mean(Data(Restrict(Spectrotsd_Saline,Wake))),'k')

load('/media/nas5/Thierry_DATA/M781_processed/M781_Stimopto_REM_or_wake_5s_01102018/LFPData/LFP7.mat')
figure, plot(Range(LFP,'s'),Data(LFP))
hold on, plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'r')
figure, plot(Data(Restrict(LFP,REMEpoch)))

%% tracer les spectres de l'hippocampe pour chaque état
clear all

%REM
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M923_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse923_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M923_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M923_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power REM (M923)')
set(gca,'FontSize',14)

clear all

%Wake
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M923_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse923_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M923_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,Wake))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M923_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,Wake))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power Wake (M923)')
set(gca,'FontSize',14)

clear all

%SWS
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M923_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse923_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M923_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M923_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power SWS (M923)')
set(gca,'FontSize',14)

% %%%%%%%
% cd /media/nas5/Thierry_DATA/Exchange Cages/923_923_923_923_Baseline2_02072019_190702_085527/Mouse923
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS Homecage Mouse2
% SWS923Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS923HomecageStart=Start(SWSEpoch)./(1e4)
% SWS923HomecageEnd=End(SWSEpoch)./(1e4)
% SWS923HomecageDuration=SWS923HomecageEnd-SWS923HomecageStart
% Nb_SWSEpoch923Homecage = length(SWS923HomecageStart); 
% 
% %WAKE Homecage Mouse2
% Wake923Homecage=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake923HomecageStart = Start(Wake)./(1e4);
% Wake923HomecageEnd = End(Wake)./(1e4); 
% Wake923HomecageDuration=Wake923HomecageEnd-Wake923HomecageStart
% Nb_WakeEpoch923Homecage = length(Wake923HomecageStart); 
% 
% %REM Homecage Mouse2
% REM923Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM923HomecageStart=Start(REMEpoch)./(1e4)
% REM923HomecageEnd=End(REMEpoch)./(1e4)
% REM923HomecageDuration=REM923HomecageEnd-REM923HomecageStart
% Nb_REMEpoch923Homecage = length(REM923HomecageStart); 
% 
% %Total sleep duration Homecage Mouse2
% TotalSleep923Homecage=SWS923Homecage+REM923Homecage
% 
% cd /media/mobs/MOBs96/M923_Sleep_cage_changed_day_07112018
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS CNO Mouse2
% SWS923CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS923CNOStart=Start(SWSEpoch)./(1e4)
% SWS923CNOEnd=End(SWSEpoch)./(1e4)
% SWS923CNODuration=SWS923CNOEnd-SWS923CNOStart
% Nb_SWSEpoch923CNO = length(SWS923CNOStart); 
% 
% %WAKE CNO Mouse2
% Wake923CNO=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake923CNOStart = Start(Wake)./(1e4);
% Wake923CNOEnd = End(Wake)./(1e4); 
% Wake923CNODuration=Wake923CNOEnd-Wake923CNOStart
% Nb_WakeEpoch923CNO = length(Wake923CNOStart); 
% 
% %REM CNO Mouse2
% REM923CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM923CNOStart=Start(REMEpoch)./(1e4)
% REM923CNOEnd=End(REMEpoch)./(1e4)
% REM923CNODuration=REM923CNOEnd-REM923CNOStart
% Nb_REMEpoch923CNO = length(REM923CNOStart); 
% 
% %Total sleep duration CNO Mouse2
% TotalSleep923CNO=SWS923CNO+REM923CNO

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Ratio (REM/SWS) Mouse2
% ra_RemSwsCNO923=(REM923CNO)/(SWS923CNO)
% ra_RemSwsHomecage923=(REM923Homecage)/(SWS923Homecage)
% 
% %Ratio (Wake/Sleep) Mouse2
% ra_WakeTsleep923Homecage=(Wake923Homecage)./(TotalSleep923Homecage)
% ra_WakeTsleep923CNO=(Wake923CNO)./(TotalSleep923CNO)
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
% ra923_CNO_SWSTotal=SWS923CNO./TotalSleep923CNO;
% ra923_Homecage_SWSTotal=SWS923Homecage./TotalSleep923Homecage;
% ra923_Homecage_REMTotal=REM923Homecage./TotalSleep923Homecage;
% ra923_CNO_REMTotal=REM923CNO./TotalSleep923CNO;
% [ra923_Homecage_SWSTotal ra923_CNO_SWSTotal ra923_Homecage_REMTotal ra923_CNO_REMTotal]
%  
% PlotErrorBarN_KJ({ra923_Homecage_SWSTotal ra923_CNO_SWSTotal ra923_Homecage_REMTotal ra923_CNO_REMTotal})
% 
% %Create histogram distributions Mouse 2
% histogram((REM923HomecageDuration),20)
% hold on
% histogram((REM923CNODuration),20)
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 923-923-923-923
% ra_Homecage_SWSTotal=[ra923_Homecage_SWSTotal ra923_Homecage_SWSTotal ra923_Homecage_SWSTotal ra923_Homecage_SWSTotal]
% ra_CNO_SWSTotal=[ra923_CNO_SWSTotal ra923_CNO_SWSTotal ra923_CNO_SWSTotal ra923_CNO_SWSTotal]
% 
% ra_Homecage_REMTotal=[ra923_Homecage_REMTotal ra923_Homecage_REMTotal ra923_Homecage_REMTotal ra923_Homecage_REMTotal]
% ra_CNO_REMTotal=[ra923_CNO_REMTotal ra923_CNO_REMTotal ra923_CNO_REMTotal ra923_CNO_REMTotal]
% 
% PlotErrorBarN_KJ({ra_Homecage_SWSTotal,ra_CNO_SWSTotal})
% PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal})
% 
% Restrict
% %Calcul durée total recordings Mouse 923-923-923-923
% 
% timeRecord923Homecage=(Wake923Homecage+SWS923Homecage+REM923Homecage)
% timeRecord923CNO=(Wake923CNO+SWS923CNO+REM923CNO)
% timeRecord923Homecage=(Wake923Homecage+SWS923Homecage+REM923Homecage)
% timeRecord923CNO=(Wake923CNO+SWS923CNO+REM923CNO)
% 
% PlotErrorBarN_KJ({timeRecord923Homecage, timeRecord923CNO,timeRecord923Homecage, timeRecord923CNO})
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
