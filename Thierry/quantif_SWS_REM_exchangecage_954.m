%% Script pour analyse des changements de cages en CNO / Saline
%% Homecage1 day 2

cd /media/nas5/Thierry_DATA/Exchange Cages/954_954_954_954_Baseline2_02072019_190702_085527/M954_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage1
SWS954Homecage1DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS954Homecage1Start=Start(SWSEpoch)./(1e4);
SWS954Homecage1End=End(SWSEpoch)./(1e4);
SWS954Homecage1DurationEpisods=SWS954Homecage1End-SWS954Homecage1Start;%durée de chaque épisode
Nb_SWSEpoch954Homecage1 = length(SWS954Homecage1Start);%Nombre d'épisodes de SWS

%WAKE Homecage1
Wake954Homecage1DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake954Homecage1Start = Start(Wake)./(1e4);
Wake954Homecage1End = End(Wake)./(1e4); 
Wake954Homecage1DurationEpisods=Wake954Homecage1End-Wake954Homecage1Start;
Nb_WakeEpoch954Homecage1 = length(Wake954Homecage1Start); 

%REM Homecage1
REM954Homecage1DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM954Homecage1Start=Start(REMEpoch)./(1e4);
REM954Homecage1End=End(REMEpoch)./(1e4);
REM954Homecage1DurationEpisods=REM954Homecage1End-REM954Homecage1Start;
Nb_REMEpoch954Homecage1 = length(REM954Homecage1Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_954_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_954_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_954_Homecage1=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_954_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_954_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_954_Homecage1 PercWake_Total_954_Homecage1 PercREM_Total_954_Homecage1]
PlotErrorBarN_KJ({PercWake_Total_954_Homecage1 PercSWS_Total_954_Homecage1 PercREM_Total_954_Homecage1})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 954 Homecage1)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch954Homecage1 Nb_SWSEpoch954Homecage1 Nb_REMEpoch954Homecage1] 
PlotErrorBarN_KJ({Nb_WakeEpoch954Homecage1 Nb_SWSEpoch954Homecage1 Nb_REMEpoch954Homecage1})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 954 Homecage1)')
xticklabels({'Wake Homecage1','SWS Homecage1','REM Homecage1'})

%Total sleep duration Homecage1
TotalSleep954Homecage1=SWS954Homecage1DurationTot+REM954Homecage1DurationTot;
TotalSession954Homecage1=Wake954Homecage1DurationTot+SWS954Homecage1DurationTot+REM954Homecage1DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_954 = length(Start(Wake)); 
% sb2_954 = length(Start(SWSEpoch)); 
% rb2_954 = length(Start(REMEpoch)); 
% allb2_954 = wb2_954+sb2_954+rb2_954; 
% wpb2_954 = wb2_954/allb2_954*100; 
% spb2_954 = sb2_954/allb2_954*100; 
% rpb2_954 = rb2_954/allb2_954*100;


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

PercFirstHalfHomecage1_954=nanmean(perHomecage1(1:length(perHomecage1)/2));
PercSecHalfHomecage1_954=nanmean(perHomecage1(length(perHomecage1)/2:end));

PercFirstThirdHomecage1_954=nanmean(perHomecage1(1:length(perHomecage1)/3))
PercSecThirdHomecage1_954=nanmean(perHomecage1(length(perHomecage1)/3:2*length(perHomecage1)/3))
PercLastThirdHomecage1_954=nanmean(perHomecage1(2*length(perHomecage1)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage1_954 PercSecHalfHomecage1_954 PercFirstThirdHomecage1_954 PercSecThirdHomecage1_954 PercLastThirdHomecage1_954})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/954_954_954_954_CNO_Saline_03072019_190703_091346/Mouse954_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS CNO
SWS954CNODurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS954CNOStart=Start(SWSEpoch)./(1e4);
SWS954CNOEnd=End(SWSEpoch)./(1e4);
SWS954CNODurationEpisods=SWS954CNOEnd-SWS954CNOStart;%durée de chaque épisode
Nb_SWSEpoch954CNO = length(SWS954CNOStart);%Nombre d'épisodes de SWS

%WAKE CNO 
Wake954CNODurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake954CNOStart = Start(Wake)./(1e4);
Wake954CNOEnd = End(Wake)./(1e4); 
Wake954CNODurationEpisods=Wake954CNOEnd-Wake954CNOStart;
Nb_WakeEpoch954CNO = length(Wake954CNOStart); 

%REM CNO 
REM954CNODurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM954CNOStart=Start(REMEpoch)./(1e4);
REM954CNOEnd=End(REMEpoch)./(1e4);
REM954CNODurationEpisods=REM954CNOEnd-REM954CNOStart;
Nb_REMEpoch954CNO = length(REM954CNOStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_954_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_954_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_954_CNO=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_954_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_954_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_954_CNO PercWake_Total_954_CNO PercREM_Total_954_CNO]
PlotErrorBarN_KJ({PercWake_Total_954_CNO PercSWS_Total_954_CNO PercREM_Total_954_CNO})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 954 CNO)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch954CNO Nb_SWSEpoch954CNO Nb_REMEpoch954CNO] 
PlotErrorBarN_KJ({Nb_WakeEpoch954CNO Nb_SWSEpoch954CNO Nb_REMEpoch954CNO})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 954 CNO)')
xticklabels({'Wake CNO','SWS CNO','REM CNO'})

%Total sleep duration CNO
TotalSleep954CNO=SWS954CNODurationTot+REM954CNODurationTot;
TotalSession954CNO=Wake954CNODurationTot+SWS954CNODurationTot+REM954CNODurationTot;

% % stages %
% wcno1_954 = length(Start(Wake)); 
% scno1_954 = length(Start(SWSEpoch));
% rcno1_954 = length(Start(REMEpoch));
% allcno1_954 = wcno1_954+scno1_954+rcno1_954;
% wpcno1_954 = wcno1_954/allcno1_954*100;
% spcno1_954 = scno1_954/allcno1_954*100;
% rpcno1_954 = rcno1_954/allcno1_954*100;

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

PercFirstHalfCNO_954=nanmean(perCNO(1:length(perCNO)/2));
PercSecHalfCNO_954=nanmean(perCNO(length(perCNO)/2:end));

PercFirstThirdCNO_954=nanmean(perCNO(1:length(perCNO)/3))
PercSecThirdCNO_954=nanmean(perCNO(length(perCNO)/3:2*length(perCNO)/3))
PercLastThirdCNO_954=nanmean(perCNO(2*length(perCNO)/3:end))

PlotErrorBarN_KJ({PercFirstHalfCNO_954 PercSecHalfCNO_954 PercFirstThirdCNO_954 PercSecThirdCNO_954 PercLastThirdCNO_954})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/954_954_954_954_Baseline3_04072019_190704_090313/M954_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage2
SWS954Homecage2DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS954Homecage2Start=Start(SWSEpoch)./(1e4);
SWS954Homecage2End=End(SWSEpoch)./(1e4);
SWS954Homecage2DurationEpisods=SWS954Homecage2End-SWS954Homecage2Start;%durée de chaque épisode
Nb_SWSEpoch954Homecage2 = length(SWS954Homecage2Start);%Nombre d'épisodes de SWS

%WAKE Homecage2
Wake954Homecage2DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake954Homecage2Start = Start(Wake)./(1e4);
Wake954Homecage2End = End(Wake)./(1e4); 
Wake954Homecage2DurationEpisods=Wake954Homecage2End-Wake954Homecage2Start;
Nb_WakeEpoch954Homecage2 = length(Wake954Homecage2Start); 

%REM Homecage2
REM954Homecage2DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM954Homecage2Start=Start(REMEpoch)./(1e4);
REM954Homecage2End=End(REMEpoch)./(1e4);
REM954Homecage2DurationEpisods=REM954Homecage2End-REM954Homecage2Start;
Nb_REMEpoch954Homecage2 = length(REM954Homecage2Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_954_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_954_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_954_Homecage2=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_954_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_954_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_954_Homecage2 PercWake_Total_954_Homecage2 PercREM_Total_954_Homecage2]
PlotErrorBarN_KJ({PercWake_Total_954_Homecage2 PercSWS_Total_954_Homecage2 PercREM_Total_954_Homecage2})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 954 Homecage2)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch954Homecage2 Nb_SWSEpoch954Homecage2 Nb_REMEpoch954Homecage2] 
PlotErrorBarN_KJ({Nb_WakeEpoch954Homecage2 Nb_SWSEpoch954Homecage2 Nb_REMEpoch954Homecage2})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 954 Homecage2)')
xticklabels({'Wake Homecage2','SWS Homecage2','REM Homecage2'})

%Total sleep duration Homecage2 Mouse 1
TotalSleep954Homecage2=SWS954Homecage2DurationTot+REM954Homecage2DurationTot;
TotalSession954Homecage2=Wake954Homecage2DurationTot+SWS954Homecage2DurationTot+REM954Homecage2DurationTot;

% % stages %
% wb3_954 = length(Start(Wake)); 
% sb3_954 = length(Start(SWSEpoch));
% rb3_954 = length(Start(REMEpoch));
% allb3_954 = wb3_954+sb3_954+rb3_954;
% wpb3_954 = wb3_954/allb3_954*100
% spb3_954 = sb3_954/allb3_954*100;
% rpb3_954 = rb3_954/allb3_954*100;

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

PercFirstHalfHomecage2_954=nanmean(perHomecage2(1:length(perHomecage2)/2));
PercSecHalfHomecage2_954=nanmean(perHomecage2(length(perHomecage2)/2:end));

PercFirstThirdHomecage2_954=nanmean(perHomecage2(1:length(perHomecage2)/3))
PercSecThirdHomecage2_954=nanmean(perHomecage2(length(perHomecage2)/3:2*length(perHomecage2)/3))
PercLastThirdHomecage2_954=nanmean(perHomecage2(2*length(perHomecage2)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage2_954 PercSecHalfHomecage2_954 PercFirstThirdHomecage2_954 PercSecThirdHomecage2_954 PercLastThirdHomecage2_954})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/954_954_954_954_CNO_saline_2_05072019_190705_093630/M954_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Saline
SWS954SalineDurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS954SalineStart=Start(SWSEpoch)./(1e4);
SWS954SalineEnd=End(SWSEpoch)./(1e4);
SWS954SalineDurationEpisods=SWS954SalineEnd-SWS954SalineStart;%durée de chaque épisode
Nb_SWSEpoch954Saline = length(SWS954SalineStart);%Nombre d'épisodes de SWS

%WAKE Saline 
Wake954SalineDurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake954SalineStart = Start(Wake)./(1e4);
Wake954SalineEnd = End(Wake)./(1e4); 
Wake954SalineDurationEpisods=Wake954SalineEnd-Wake954SalineStart;
Nb_WakeEpoch954Saline = length(Wake954SalineStart); 

%REM Saline 
REM954SalineDurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM954SalineStart=Start(REMEpoch)./(1e4);
REM954SalineEnd=End(REMEpoch)./(1e4);
REM954SalineDurationEpisods=REM954SalineEnd-REM954SalineStart;
Nb_REMEpoch954Saline = length(REM954SalineStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_954_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_954_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_954_Saline=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_954_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_954_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_954_Saline PercWake_Total_954_Saline PercREM_Total_954_Saline]
PlotErrorBarN_KJ({PercWake_Total_954_Saline PercSWS_Total_954_Saline PercREM_Total_954_Saline})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 954 Saline)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch954Saline Nb_SWSEpoch954Saline Nb_REMEpoch954Saline] 
PlotErrorBarN_KJ({Nb_WakeEpoch954Saline Nb_SWSEpoch954Saline Nb_REMEpoch954Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 954 Saline)')
xticklabels({'Wake Saline','SWS Saline','REM Saline'})

%Total sleep duration Saline
TotalSleep954Saline=SWS954SalineDurationTot+REM954SalineDurationTot;
TotalSession954Saline=Wake954SalineDurationTot+SWS954SalineDurationTot+REM954SalineDurationTot;

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

PercFirstHalfSaline_954=nanmean(perSaline(1:length(perSaline)/2));
PercSecHalfSaline_954=nanmean(perSaline(length(perSaline)/2:end));

PercFirstThirdSaline_954=nanmean(perSaline(1:length(perSaline)/3))
PercSecThirdSaline_954=nanmean(perSaline(length(perSaline)/3:2*length(perSaline)/3))
PercLastThirdSaline_954=nanmean(perSaline(2*length(perSaline)/3:end))

PlotErrorBarN_KJ({PercFirstHalfSaline_954 PercSecHalfSaline_954 PercFirstThirdSaline_954 PercSecThirdSaline_954 PercLastThirdSaline_954})
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
% wsal_954 = length(Start(Wake)); 
% ssal_954 = length(Start(SWSEpoch));
% rsal_954 = length(Start(REMEpoch));
% allsal_954 = wsal_954+ssal_954+rsal_954;
% wpsal_954 = wsal_954/allsal_954*100
% spsal_954 = ssal_954/allsal_954*100;
% rpsal_954 = rsal_954/allsal_954*100;
%
% f = figure('Position', [0 0 1000 400]);
%     subplot(2,2,1)
%     bar([spb2_954 wpb2_954 rpb2_954],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('954 Sleep stages proportion Homecage 1')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,2)
%     bar([spcno1_954 wpcno1_954 rpcno1_954],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('954 Sleep stages proportion CNO')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,3)
%     bar([spb3_954 wpb3_954 rpb3_954],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('954 Sleep stages proportion Homacage 2')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,4)
%     bar([spsal_954 wpsal_954 rpsal_954],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('954 Sleep stages proportion Saline')
%     xticklabels({'SWS','Wake','REM'})

%% CNO vs Homecage1
%Ratio (REM/SWS)
ra_RemSwsCNO954=(REM954CNODurationTot)/(SWS954CNODurationTot);
ra_RemSwsHomecage1_954=(REM954Homecage1DurationTot)/(SWS954Homecage1DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep954Homecage1=(Wake954Homecage1DurationTot)./(TotalSleep954Homecage1);
ra_WakeSleep954CNO=(Wake954CNODurationTot)./(TotalSleep954CNO);

%Calcul ratio SWS vs Total Sleep
ra954_CNO_SWSTotal=SWS954CNODurationTot./TotalSleep954CNO;
ra954_Homecage1_SWSTotal=SWS954Homecage1DurationTot./TotalSleep954Homecage1;
%Calcul ratio REM vs Total Sleep
ra954_Homecage1_REMTotal=REM954Homecage1DurationTot./TotalSleep954Homecage1;
ra954_CNO_REMTotal=REM954CNODurationTot./TotalSleep954CNO;
[ra954_Homecage1_SWSTotal ra954_CNO_SWSTotal ra954_Homecage1_REMTotal ra954_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra954_Homecage1_SWSTotal ra954_CNO_SWSTotal ra954_Homecage1_REMTotal ra954_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in homecage1 vs Exchange Cage CNO (Mouse 954)')
xticklabels({'SWS/Sleep Homecage1','SWS/Sleep Exchange CNO','REM/Sleep Homecage1','REM/Sleep Exchange CNO'})

%% CNO vs Homecage2
%Ratio (REM/SWS)
ra_RemSwsCNO954=(REM954CNODurationTot)/(SWS954CNODurationTot);
ra_RemSwsHomecage2_954=(REM954Homecage2DurationTot)/(SWS954Homecage2DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep954Homecage2=(Wake954Homecage2DurationTot)./(TotalSleep954Homecage2);
ra_WakeSleep954CNO=(Wake954CNODurationTot)./(TotalSleep954CNO);

%Calcul ratio SWS vs Total Sleep
ra954_CNO_SWSTotal=SWS954CNODurationTot./TotalSleep954CNO;
ra954_Homecage2_SWSTotal=SWS954Homecage2DurationTot./TotalSleep954Homecage2;
%Calcul ratio REM vs Total Sleep
ra954_Homecage2_REMTotal=REM954Homecage2DurationTot./TotalSleep954Homecage2;
ra954_CNO_REMTotal=REM954CNODurationTot./TotalSleep954CNO;
[ra954_Homecage2_SWSTotal ra954_CNO_SWSTotal ra954_Homecage2_REMTotal ra954_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra954_Homecage2_SWSTotal ra954_CNO_SWSTotal ra954_Homecage2_REMTotal ra954_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Homecage2 vs Exchange Cage CNO (Mouse 954)')
xticklabels({'SWS/Sleep Homecage2','SWS/Sleep Exchange CNO','REM/Sleep Homecage2','REM/Sleep Exchange CNO'})

% %create histogram distributions 
% histogram((REM954Homecage1DurationEpisods),20)
% hold on
% histogram((REM954CNODurationEpisods),20)
% 
% histogram((REM954Homecage2DurationEpisods),20)
% hold on
% histogram((REM954CNODurationEpisods),20)

%% CNO vs Saline
%Ratio (REM/SWS)
ra_RemSwsCNO954=(REM954CNODurationTot)/(SWS954CNODurationTot);
ra_RemSwsSaline954=(REM954SalineDurationTot)/(SWS954SalineDurationTot);

%Ratio (Wake/Sleep)
ra_WakeTsleep954Saline=(Wake954SalineDurationTot)./(TotalSleep954Saline);
ra_WakeTsleep954CNO=(Wake954CNODurationTot)./(TotalSleep954CNO);

%Calcul ratio SWS vs Total Sleep 
ra954_CNO_SWSTotal=SWS954CNODurationTot./TotalSleep954CNO;
ra954_Saline_SWSTotal=SWS954SalineDurationTot./TotalSleep954Saline;

%Calcul ratio REM vs Total Sleep
ra954_Saline_REMTotal=REM954SalineDurationTot./TotalSleep954Saline;
ra954_CNO_REMTotal=REM954CNODurationTot./TotalSleep954CNO;
[ra954_Saline_SWSTotal ra954_CNO_SWSTotal ra954_Saline_REMTotal ra954_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra954_Saline_SWSTotal ra954_CNO_SWSTotal ra954_Saline_REMTotal ra954_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Saline vs Exchange Cage CNO (Mouse 954)')
xticklabels({'','SWS/Sleep Exchange Saline','SWS/Sleep Exchange CNO','REM/Sleep Exchange Saline','REM/Sleep Exchange CNO'})


%% tracer les spectres de l'hippocampe pour chaque état

clear all

%REM
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M954_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M954_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M954_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M954_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power REM (M954)')
set(gca,'FontSize',14)

clear all

%Wake
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M954_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M954_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M954_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,Wake))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M954_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,Wake))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power Wake (M954)')
set(gca,'FontSize',14)

clear all

%SWS
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M954_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M954_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M954_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M954_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power SWS (M954)')
set(gca,'FontSize',14)



% %%%%%%%
% cd /media/nas5/Thierry_DATA/Exchange Cages/954_954_954_954_Baseline2_02072019_190702_085527/Mouse954
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS Homecage Mouse2
% SWS954Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS954HomecageStart=Start(SWSEpoch)./(1e4)
% SWS954HomecageEnd=End(SWSEpoch)./(1e4)
% SWS954HomecageDuration=SWS954HomecageEnd-SWS954HomecageStart
% Nb_SWSEpoch954Homecage = length(SWS954HomecageStart); 
% 
% %WAKE Homecage Mouse2
% Wake954Homecage=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake954HomecageStart = Start(Wake)./(1e4);
% Wake954HomecageEnd = End(Wake)./(1e4); 
% Wake954HomecageDuration=Wake954HomecageEnd-Wake954HomecageStart
% Nb_WakeEpoch954Homecage = length(Wake954HomecageStart); 
% 
% %REM Homecage Mouse2
% REM954Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM954HomecageStart=Start(REMEpoch)./(1e4)
% REM954HomecageEnd=End(REMEpoch)./(1e4)
% REM954HomecageDuration=REM954HomecageEnd-REM954HomecageStart
% Nb_REMEpoch954Homecage = length(REM954HomecageStart); 
% 
% %Total sleep duration Homecage Mouse2
% TotalSleep954Homecage=SWS954Homecage+REM954Homecage
% 
% cd /media/mobs/MOBs96/M954_Sleep_cage_changed_day_07112018
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS CNO Mouse2
% SWS954CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS954CNOStart=Start(SWSEpoch)./(1e4)
% SWS954CNOEnd=End(SWSEpoch)./(1e4)
% SWS954CNODuration=SWS954CNOEnd-SWS954CNOStart
% Nb_SWSEpoch954CNO = length(SWS954CNOStart); 
% 
% %WAKE CNO Mouse2
% Wake954CNO=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake954CNOStart = Start(Wake)./(1e4);
% Wake954CNOEnd = End(Wake)./(1e4); 
% Wake954CNODuration=Wake954CNOEnd-Wake954CNOStart
% Nb_WakeEpoch954CNO = length(Wake954CNOStart); 
% 
% %REM CNO Mouse2
% REM954CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM954CNOStart=Start(REMEpoch)./(1e4)
% REM954CNOEnd=End(REMEpoch)./(1e4)
% REM954CNODuration=REM954CNOEnd-REM954CNOStart
% Nb_REMEpoch954CNO = length(REM954CNOStart); 
% 
% %Total sleep duration CNO Mouse2
% TotalSleep954CNO=SWS954CNO+REM954CNO

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Ratio (REM/SWS) Mouse2
% ra_RemSwsCNO954=(REM954CNO)/(SWS954CNO)
% ra_RemSwsHomecage954=(REM954Homecage)/(SWS954Homecage)
% 
% %Ratio (Wake/Sleep) Mouse2
% ra_WakeTsleep954Homecage=(Wake954Homecage)./(TotalSleep954Homecage)
% ra_WakeTsleep954CNO=(Wake954CNO)./(TotalSleep954CNO)
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
% ra954_CNO_SWSTotal=SWS954CNO./TotalSleep954CNO;
% ra954_Homecage_SWSTotal=SWS954Homecage./TotalSleep954Homecage;
% ra954_Homecage_REMTotal=REM954Homecage./TotalSleep954Homecage;
% ra954_CNO_REMTotal=REM954CNO./TotalSleep954CNO;
% [ra954_Homecage_SWSTotal ra954_CNO_SWSTotal ra954_Homecage_REMTotal ra954_CNO_REMTotal]
%  
% PlotErrorBarN_KJ({ra954_Homecage_SWSTotal ra954_CNO_SWSTotal ra954_Homecage_REMTotal ra954_CNO_REMTotal})
% 
% %Create histogram distributions Mouse 2
% histogram((REM954HomecageDuration),20)
% hold on
% histogram((REM954CNODuration),20)
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 954-954-954-954
% ra_Homecage_SWSTotal=[ra954_Homecage_SWSTotal ra954_Homecage_SWSTotal ra954_Homecage_SWSTotal ra954_Homecage_SWSTotal]
% ra_CNO_SWSTotal=[ra954_CNO_SWSTotal ra954_CNO_SWSTotal ra954_CNO_SWSTotal ra954_CNO_SWSTotal]
% 
% ra_Homecage_REMTotal=[ra954_Homecage_REMTotal ra954_Homecage_REMTotal ra954_Homecage_REMTotal ra954_Homecage_REMTotal]
% ra_CNO_REMTotal=[ra954_CNO_REMTotal ra954_CNO_REMTotal ra954_CNO_REMTotal ra954_CNO_REMTotal]
% 
% PlotErrorBarN_KJ({ra_Homecage_SWSTotal,ra_CNO_SWSTotal})
% PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal})
% 
% 
% %Calcul durée total recordings Mouse 954-954-954-954
% 
% timeRecord954Homecage=(Wake954Homecage+SWS954Homecage+REM954Homecage)
% timeRecord954CNO=(Wake954CNO+SWS954CNO+REM954CNO)
% timeRecord954Homecage=(Wake954Homecage+SWS954Homecage+REM954Homecage)
% timeRecord954CNO=(Wake954CNO+SWS954CNO+REM954CNO)
% 
% PlotErrorBarN_KJ({timeRecord954Homecage, timeRecord954CNO,timeRecord954Homecage, timeRecord954CNO})
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
