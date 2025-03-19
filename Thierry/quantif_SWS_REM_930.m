%% Script pour analyse de cages en CNO / Saline
%% Homecage1 day 2

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M930_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage1
SWS930Homecage1DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS930Homecage1Start=Start(SWSEpoch)./(1e4);
SWS930Homecage1End=End(SWSEpoch)./(1e4);
SWS930Homecage1DurationEpisods=SWS930Homecage1End-SWS930Homecage1Start;%durée de chaque épisode
Nb_SWSEpoch930Homecage1 = length(SWS930Homecage1Start);%Nombre d'épisodes de SWS

%WAKE Homecage1
Wake930Homecage1DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake930Homecage1Start = Start(Wake)./(1e4);
Wake930Homecage1End = End(Wake)./(1e4); 
Wake930Homecage1DurationEpisods=Wake930Homecage1End-Wake930Homecage1Start;
Nb_WakeEpoch930Homecage1 = length(Wake930Homecage1Start); 

%REM Homecage1
REM930Homecage1DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM930Homecage1Start=Start(REMEpoch)./(1e4);
REM930Homecage1End=End(REMEpoch)./(1e4);
REM930Homecage1DurationEpisods=REM930Homecage1End-REM930Homecage1Start;
Nb_REMEpoch930Homecage1 = length(REM930Homecage1Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_930_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_930_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_930_Homecage1=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_930_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_930_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_930_Homecage1 PercWake_Total_930_Homecage1 PercREM_Total_930_Homecage1]
PlotErrorBarN_KJ({PercWake_Total_930_Homecage1 PercSWS_Total_930_Homecage1 PercREM_Total_930_Homecage1})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 930 Homecage1)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)


%Nombre d'épisodes
[Nb_WakeEpoch930Homecage1 Nb_SWSEpoch930Homecage1 Nb_REMEpoch930Homecage1] 
PlotErrorBarN_KJ({Nb_WakeEpoch930Homecage1 Nb_SWSEpoch930Homecage1 Nb_REMEpoch930Homecage1})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 930 Homecage1)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)

%Total sleep duration Homecage1
TotalSleep930Homecage1=SWS930Homecage1DurationTot+REM930Homecage1DurationTot;
TotalSession930Homecage1=Wake930Homecage1DurationTot+SWS930Homecage1DurationTot+REM930Homecage1DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_930 = length(Start(Wake)); 
% sb2_930 = length(Start(SWSEpoch)); 
% rb2_930 = length(Start(REMEpoch)); 
% allb2_930 = wb2_930+sb2_930+rb2_930; 
% wpb2_930 = wb2_930/allb2_930*100; 
% spb2_930 = sb2_930/allb2_930*100; 
% rpb2_930 = rb2_930/allb2_930*100;


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

PercFirstHalfHomecage1_930=nanmean(perHomecage1(1:length(perHomecage1)/2));
PercSecHalfHomecage1_930=nanmean(perHomecage1(length(perHomecage1)/2:end));

PercFirstThirdHomecage1_930=nanmean(perHomecage1(1:length(perHomecage1)/3))
PercSecThirdHomecage1_930=nanmean(perHomecage1(length(perHomecage1)/3:2*length(perHomecage1)/3))
PercLastThirdHomecage1_930=nanmean(perHomecage1(2*length(perHomecage1)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage1_930 PercSecHalfHomecage1_930 PercFirstThirdHomecage1_930 PercSecThirdHomecage1_930 PercLastThirdHomecage1_930})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage1')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
set(gca,'FontSize',14)
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

% if plo
SleepStagesHomecage1=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsHomecage1/1E4,rescale(perHomecage1,-1,2),'ro-','LineWidth',2)
set(gca,'FontSize',14)
ylabel('%REM and stages')
xlabel('Time (s)')
title('Percentage REM over time')
% end



%% CNO day 3

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M930_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS CNO
SWS930CNODurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS930CNOStart=Start(SWSEpoch)./(1e4);
SWS930CNOEnd=End(SWSEpoch)./(1e4);
SWS930CNODurationEpisods=SWS930CNOEnd-SWS930CNOStart;%durée de chaque épisode
Nb_SWSEpoch930CNO = length(SWS930CNOStart);%Nombre d'épisodes de SWS

%WAKE CNO
Wake930CNODurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake930CNOStart = Start(Wake)./(1e4);
Wake930CNOEnd = End(Wake)./(1e4); 
Wake930CNODurationEpisods=Wake930CNOEnd-Wake930CNOStart;
Nb_WakeEpoch930CNO = length(Wake930CNOStart); 

%REM CNO
REM930CNODurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM930CNOStart=Start(REMEpoch)./(1e4);
REM930CNOEnd=End(REMEpoch)./(1e4);
REM930CNODurationEpisods=REM930CNOEnd-REM930CNOStart;
Nb_REMEpoch930CNO = length(REM930CNOStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_930_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_930_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_930_CNO=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_930_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_930_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_930_CNO PercWake_Total_930_CNO PercREM_Total_930_CNO]
PlotErrorBarN_KJ({PercWake_Total_930_CNO PercSWS_Total_930_CNO PercREM_Total_930_CNO})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 930 CNO)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)


%Nombre d'épisodes
[Nb_WakeEpoch930CNO Nb_SWSEpoch930CNO Nb_REMEpoch930CNO] 
PlotErrorBarN_KJ({Nb_WakeEpoch930CNO Nb_SWSEpoch930CNO Nb_REMEpoch930CNO})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 930 CNO)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)

%Total sleep duration CNO
TotalSleep930CNO=SWS930CNODurationTot+REM930CNODurationTot;
TotalSession930CNO=Wake930CNODurationTot+SWS930CNODurationTot+REM930CNODurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_930 = length(Start(Wake)); 
% sb2_930 = length(Start(SWSEpoch)); 
% rb2_930 = length(Start(REMEpoch)); 
% allb2_930 = wb2_930+sb2_930+rb2_930; 
% wpb2_930 = wb2_930/allb2_930*100; 
% spb2_930 = sb2_930/allb2_930*100; 
% rpb2_930 = rb2_930/allb2_930*100;


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

PercFirstHalfCNO_930=nanmean(perCNO(1:length(perCNO)/2));
PercSecHalfCNO_930=nanmean(perCNO(length(perCNO)/2:end));

PercFirstThirdCNO_930=nanmean(perCNO(1:length(perCNO)/3))
PercSecThirdCNO_930=nanmean(perCNO(length(perCNO)/3:2*length(perCNO)/3))
PercLastThirdCNO_930=nanmean(perCNO(2*length(perCNO)/3:end))

PlotErrorBarN_KJ({PercFirstHalfCNO_930 PercSecHalfCNO_930 PercFirstThirdCNO_930 PercSecThirdCNO_930 PercLastThirdCNO_930})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods CNO')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
set(gca,'FontSize',14)
    
%% Plot de l'hypnogramme + Pourcentage de REM CNO

% if plo
SleepStagesCNO=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsCNO/1E4,rescale(perCNO,-1,2),'ro-','LineWidth',2)
set(gca,'FontSize',14)
ylabel('%REM and stages')
xlabel('Time (s)')
title('Percentage REM over time')
% end

%% Homecage2 day 4

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M930_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage2
SWS930Homecage2DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS930Homecage2Start=Start(SWSEpoch)./(1e4);
SWS930Homecage2End=End(SWSEpoch)./(1e4);
SWS930Homecage2DurationEpisods=SWS930Homecage2End-SWS930Homecage2Start;%durée de chaque épisode
Nb_SWSEpoch930Homecage2 = length(SWS930Homecage2Start);%Nombre d'épisodes de SWS

%WAKE Homecage2
Wake930Homecage2DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake930Homecage2Start = Start(Wake)./(1e4);
Wake930Homecage2End = End(Wake)./(1e4); 
Wake930Homecage2DurationEpisods=Wake930Homecage2End-Wake930Homecage2Start;
Nb_WakeEpoch930Homecage2 = length(Wake930Homecage2Start); 

%REM Homecage2
REM930Homecage2DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM930Homecage2Start=Start(REMEpoch)./(1e4);
REM930Homecage2End=End(REMEpoch)./(1e4);
REM930Homecage2DurationEpisods=REM930Homecage2End-REM930Homecage2Start;
Nb_REMEpoch930Homecage2 = length(REM930Homecage2Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_930_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_930_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_930_Homecage2=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_930_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_930_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_930_Homecage2 PercWake_Total_930_Homecage2 PercREM_Total_930_Homecage2]
PlotErrorBarN_KJ({PercWake_Total_930_Homecage2 PercSWS_Total_930_Homecage2 PercREM_Total_930_Homecage2})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 930 Homecage2)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)


%Nombre d'épisodes
[Nb_WakeEpoch930Homecage2 Nb_SWSEpoch930Homecage2 Nb_REMEpoch930Homecage2] 
PlotErrorBarN_KJ({Nb_WakeEpoch930Homecage2 Nb_SWSEpoch930Homecage2 Nb_REMEpoch930Homecage2})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 930 Homecage2)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)

%Total sleep duration Homecage2
TotalSleep930Homecage2=SWS930Homecage2DurationTot+REM930Homecage2DurationTot;
TotalSession930Homecage2=Wake930Homecage2DurationTot+SWS930Homecage2DurationTot+REM930Homecage2DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_930 = length(Start(Wake)); 
% sb2_930 = length(Start(SWSEpoch)); 
% rb2_930 = length(Start(REMEpoch)); 
% allb2_930 = wb2_930+sb2_930+rb2_930; 
% wpb2_930 = wb2_930/allb2_930*100; 
% spb2_930 = sb2_930/allb2_930*100; 
% rpb2_930 = rb2_930/allb2_930*100;


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

PercFirstHalfHomecage2_930=nanmean(perHomecage2(1:length(perHomecage2)/2));
PercSecHalfHomecage2_930=nanmean(perHomecage2(length(perHomecage2)/2:end));

PercFirstThirdHomecage2_930=nanmean(perHomecage2(1:length(perHomecage2)/3))
PercSecThirdHomecage2_930=nanmean(perHomecage2(length(perHomecage2)/3:2*length(perHomecage2)/3))
PercLastThirdHomecage2_930=nanmean(perHomecage2(2*length(perHomecage2)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage2_930 PercSecHalfHomecage2_930 PercFirstThirdHomecage2_930 PercSecThirdHomecage2_930 PercLastThirdHomecage2_930})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Homecage2')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
set(gca,'FontSize',14)
    
%% Plot de l'hypnogramme + Pourcentage de REM Homecage2

% if plo
SleepStagesHomecage2=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsHomecage2/1E4,rescale(perHomecage2,-1,2),'ro-','LineWidth',2)
set(gca,'FontSize',14)
ylabel('%REM and stages')
xlabel('Time (s)')
title('Percentage REM over time')
% end

%% Saline day 5

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Saline
SWS930SalineDurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS930SalineStart=Start(SWSEpoch)./(1e4);
SWS930SalineEnd=End(SWSEpoch)./(1e4);
SWS930SalineDurationEpisods=SWS930SalineEnd-SWS930SalineStart;%durée de chaque épisode
Nb_SWSEpoch930Saline = length(SWS930SalineStart);%Nombre d'épisodes de SWS

%WAKE Saline
Wake930SalineDurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake930SalineStart = Start(Wake)./(1e4);
Wake930SalineEnd = End(Wake)./(1e4); 
Wake930SalineDurationEpisods=Wake930SalineEnd-Wake930SalineStart;
Nb_WakeEpoch930Saline = length(Wake930SalineStart); 

%REM Saline
REM930SalineDurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM930SalineStart=Start(REMEpoch)./(1e4);
REM930SalineEnd=End(REMEpoch)./(1e4);
REM930SalineDurationEpisods=REM930SalineEnd-REM930SalineStart;
Nb_REMEpoch930Saline = length(REM930SalineStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_930_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_930_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_930_Saline=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_930_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_930_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_930_Saline PercWake_Total_930_Saline PercREM_Total_930_Saline]
PlotErrorBarN_KJ({PercWake_Total_930_Saline PercSWS_Total_930_Saline PercREM_Total_930_Saline})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 930 Saline)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)


%Nombre d'épisodes
[Nb_WakeEpoch930Saline Nb_SWSEpoch930Saline Nb_REMEpoch930Saline] 
PlotErrorBarN_KJ({Nb_WakeEpoch930Saline Nb_SWSEpoch930Saline Nb_REMEpoch930Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 930 Saline)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)

%Total sleep duration Saline
TotalSleep930Saline=SWS930SalineDurationTot+REM930SalineDurationTot;
TotalSession930Saline=Wake930SalineDurationTot+SWS930SalineDurationTot+REM930SalineDurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_930 = length(Start(Wake)); 
% sb2_930 = length(Start(SWSEpoch)); 
% rb2_930 = length(Start(REMEpoch)); 
% allb2_930 = wb2_930+sb2_930+rb2_930; 
% wpb2_930 = wb2_930/allb2_930*100; 
% spb2_930 = sb2_930/allb2_930*100; 
% rpb2_930 = rb2_930/allb2_930*100;


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

PercFirstHalfSaline_930=nanmean(perSaline(1:length(perSaline)/2));
PercSecHalfSaline_930=nanmean(perSaline(length(perSaline)/2:end));

PercFirstThirdSaline_930=nanmean(perSaline(1:length(perSaline)/3))
PercSecThirdSaline_930=nanmean(perSaline(length(perSaline)/3:2*length(perSaline)/3))
PercLastThirdSaline_930=nanmean(perSaline(2*length(perSaline)/3:end))

PlotErrorBarN_KJ({PercFirstHalfSaline_930 PercSecHalfSaline_930 PercFirstThirdSaline_930 PercSecThirdSaline_930 PercLastThirdSaline_930})
ylabel('%REM')
xlabel('Periods')
title('Percentage REM in different periods Saline')
xticklabels({'FirstHalf','SecondHalf','FirstThird','SecondThird', 'LastThird'})
xticks([1 2 3 4 5])
set(gca,'FontSize',14)
    
%% Plot de l'hypnogramme + Pourcentage de REM Saline

% if plo
SleepStagesSaline=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1);
hold on, plot(tpsSaline/1E4,rescale(perSaline,-1,2),'ro-','LineWidth',2)
set(gca,'FontSize',14)
ylabel('%REM and stages')
xlabel('Time (s)')
title('Percentage REM over time')
% end

%% % stages %
% wsal_930 = length(Start(Wake)); 
% ssal_930 = length(Start(SWSEpoch));
% rsal_930 = length(Start(REMEpoch));
% allsal_930 = wsal_930+ssal_930+rsal_930;
% wpsal_930 = wsal_930/allsal_930*100
% spsal_930 = ssal_930/allsal_930*100;
% rpsal_930 = rsal_930/allsal_930*100;
%
% f = figure('Position', [0 0 1000 400]);
%     subplot(2,2,1)
%     bar([spb2_930 wpb2_930 rpb2_930],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('930 Sleep stages proportion Homecage 1')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,2)
%     bar([spcno1_930 wpcno1_930 rpcno1_930],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('930 Sleep stages proportion CNO')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,3)
%     bar([spb3_930 wpb3_930 rpb3_930],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('930 Sleep stages proportion Homacage 2')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,4)
%     bar([spsal_930 wpsal_930 rpsal_930],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('930 Sleep stages proportion Saline')
%     xticklabels({'SWS','Wake','REM'})

%% CNO vs Homecage1
%Ratio (REM/SWS)
ra_RemSwsCNO930=(REM930CNODurationTot)/(SWS930CNODurationTot);
ra_RemSwsHomecage1_930=(REM930Homecage1DurationTot)/(SWS930Homecage1DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep930Homecage1=(Wake930Homecage1DurationTot)./(TotalSleep930Homecage1);
ra_WakeSleep930CNO=(Wake930CNODurationTot)./(TotalSleep930CNO);

%Calcul ratio SWS vs Total Sleep
ra930_CNO_SWSTotal=SWS930CNODurationTot./TotalSleep930CNO;
ra930_Homecage1_SWSTotal=SWS930Homecage1DurationTot./TotalSleep930Homecage1;
%Calcul ratio REM vs Total Sleep
ra930_Homecage1_REMTotal=REM930Homecage1DurationTot./TotalSleep930Homecage1;
ra930_CNO_REMTotal=REM930CNODurationTot./TotalSleep930CNO;
[ra930_Homecage1_SWSTotal ra930_CNO_SWSTotal ra930_Homecage1_REMTotal ra930_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra930_Homecage1_SWSTotal ra930_CNO_SWSTotal ra930_Homecage1_REMTotal ra930_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in homecage1 vs  Cage CNO (Mouse 930)')
xticklabels({'SWS/Sleep Homecage1','SWS/Sleep  CNO','REM/Sleep Homecage1','REM/Sleep  CNO'})
set(gca,'FontSize',14)
xticks([1 2 3 4])


%% CNO vs Homecage2
%Ratio (REM/SWS)
ra_RemSwsCNO930=(REM930CNODurationTot)/(SWS930CNODurationTot);
ra_RemSwsHomecage2_930=(REM930Homecage2DurationTot)/(SWS930Homecage2DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep930Homecage2=(Wake930Homecage2DurationTot)./(TotalSleep930Homecage2);
ra_WakeSleep930CNO=(Wake930CNODurationTot)./(TotalSleep930CNO);

%Calcul ratio SWS vs Total Sleep
ra930_CNO_SWSTotal=SWS930CNODurationTot./TotalSleep930CNO;
ra930_Homecage2_SWSTotal=SWS930Homecage2DurationTot./TotalSleep930Homecage2;
%Calcul ratio REM vs Total Sleep
ra930_Homecage2_REMTotal=REM930Homecage2DurationTot./TotalSleep930Homecage2;
ra930_CNO_REMTotal=REM930CNODurationTot./TotalSleep930CNO;
[ra930_Homecage2_SWSTotal ra930_CNO_SWSTotal ra930_Homecage2_REMTotal ra930_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra930_Homecage2_SWSTotal ra930_CNO_SWSTotal ra930_Homecage2_REMTotal ra930_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Homecage2 vs  Cage CNO (Mouse 930)')
xticklabels({'SWS/Sleep Homecage2','SWS/Sleep  CNO','REM/Sleep Homecage2','REM/Sleep  CNO'})
set(gca,'FontSize',14)
xticks([1 2 3 4])

% %create histogram distributions 
% histogram((REM930Homecage1DurationEpisods),20)
% hold on
% histogram((REM930CNODurationEpisods),20)
% 
% histogram((REM930Homecage2DurationEpisods),20)
% hold on
% histogram((REM930CNODurationEpisods),20)

%% CNO vs Saline
%Ratio (REM/SWS)
ra_RemSwsCNO930=(REM930CNODurationTot)/(SWS930CNODurationTot);
ra_RemSwsSaline930=(REM930SalineDurationTot)/(SWS930SalineDurationTot);

%Ratio (Wake/Sleep)
ra_WakeTsleep930Saline=(Wake930SalineDurationTot)./(TotalSleep930Saline);
ra_WakeTsleep930CNO=(Wake930CNODurationTot)./(TotalSleep930CNO);

%Calcul ratio SWS vs Total Sleep 
ra930_CNO_SWSTotal=SWS930CNODurationTot./TotalSleep930CNO;
ra930_Saline_SWSTotal=SWS930SalineDurationTot./TotalSleep930Saline;

%Calcul ratio REM vs Total Sleep
ra930_Saline_REMTotal=REM930SalineDurationTot./TotalSleep930Saline;
ra930_CNO_REMTotal=REM930CNODurationTot./TotalSleep930CNO;
[ra930_Saline_SWSTotal ra930_CNO_SWSTotal ra930_Saline_REMTotal ra930_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra930_Saline_SWSTotal ra930_CNO_SWSTotal ra930_Saline_REMTotal ra930_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Saline vs  Cage CNO (Mouse 930)')
xticklabels({'SWS/Sleep  Saline','SWS/Sleep  CNO','REM/Sleep  Saline','REM/Sleep  CNO'})
set(gca,'FontSize',14)
xticks([1 2 3 4])


%% Tracer les spectres globaux de l'hippocampe
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M930_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Spectrotsd_Homecage1)),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M930_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Spectrotsd_CNO)),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M930_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Spectrotsd_Homecage2)),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Spectrotsd_Saline)),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power all stages (M930)')
set(gca,'FontSize',14)


%% tracer les spectres de l'hippocampe restreint pour chaque état
clear all

%REM
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M930_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M930_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M930_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power REM (M930)')
set(gca,'FontSize',14)

clear all

%Wake
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M930_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M930_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,Wake))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/M928_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,Wake))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power Wake (M930)')
set(gca,'FontSize',14)

clear all

%SWS
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M930_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M930_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M930_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power SWS (M930)')
set(gca,'FontSize',14)



% %%%%%%%
% cd /media/nas5/Thierry_DATA/Exchange Cages/929_930_929_930_Baseline2_02072019_190702_085527/Mouse930
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS Homecage Mouse2
% SWS930Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS930HomecageStart=Start(SWSEpoch)./(1e4)
% SWS930HomecageEnd=End(SWSEpoch)./(1e4)
% SWS930HomecageDuration=SWS930HomecageEnd-SWS930HomecageStart
% Nb_SWSEpoch930Homecage = length(SWS930HomecageStart); 
% 
% %WAKE Homecage Mouse2
% Wake930Homecage=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake930HomecageStart = Start(Wake)./(1e4);
% Wake930HomecageEnd = End(Wake)./(1e4); 
% Wake930HomecageDuration=Wake930HomecageEnd-Wake930HomecageStart
% Nb_WakeEpoch930Homecage = length(Wake930HomecageStart); 
% 
% %REM Homecage Mouse2
% REM930Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM930HomecageStart=Start(REMEpoch)./(1e4)
% REM930HomecageEnd=End(REMEpoch)./(1e4)
% REM930HomecageDuration=REM930HomecageEnd-REM930HomecageStart
% Nb_REMEpoch930Homecage = length(REM930HomecageStart); 
% 
% %Total sleep duration Homecage Mouse2
% TotalSleep930Homecage=SWS930Homecage+REM930Homecage
% 
% cd /media/mobs/MOBs96/M930_Sleep_cage_changed_day_07112018
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS CNO Mouse2
% SWS930CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS930CNOStart=Start(SWSEpoch)./(1e4)
% SWS930CNOEnd=End(SWSEpoch)./(1e4)
% SWS930CNODuration=SWS930CNOEnd-SWS930CNOStart
% Nb_SWSEpoch930CNO = length(SWS930CNOStart); 
% 
% %WAKE CNO Mouse2
% Wake930CNO=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake930CNOStart = Start(Wake)./(1e4);
% Wake930CNOEnd = End(Wake)./(1e4); 
% Wake930CNODuration=Wake930CNOEnd-Wake930CNOStart
% Nb_WakeEpoch930CNO = length(Wake930CNOStart); 
% 
% %REM CNO Mouse2
% REM930CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM930CNOStart=Start(REMEpoch)./(1e4)
% REM930CNOEnd=End(REMEpoch)./(1e4)
% REM930CNODuration=REM930CNOEnd-REM930CNOStart
% Nb_REMEpoch930CNO = length(REM930CNOStart); 
% 
% %Total sleep duration CNO Mouse2
% TotalSleep930CNO=SWS930CNO+REM930CNO

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Ratio (REM/SWS) Mouse2
% ra_RemSwsCNO930=(REM930CNO)/(SWS930CNO)
% ra_RemSwsHomecage930=(REM930Homecage)/(SWS930Homecage)
% 
% %Ratio (Wake/Sleep) Mouse2
% ra_WakeTsleep930Homecage=(Wake930Homecage)./(TotalSleep930Homecage)
% ra_WakeTsleep930CNO=(Wake930CNO)./(TotalSleep930CNO)
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
% ra930_CNO_SWSTotal=SWS930CNO./TotalSleep930CNO;
% ra930_Homecage_SWSTotal=SWS930Homecage./TotalSleep930Homecage;
% ra930_Homecage_REMTotal=REM930Homecage./TotalSleep930Homecage;
% ra930_CNO_REMTotal=REM930CNO./TotalSleep930CNO;
% [ra930_Homecage_SWSTotal ra930_CNO_SWSTotal ra930_Homecage_REMTotal ra930_CNO_REMTotal]
%  
% PlotErrorBarN_KJ({ra930_Homecage_SWSTotal ra930_CNO_SWSTotal ra930_Homecage_REMTotal ra930_CNO_REMTotal})
% 
% %Create histogram distributions Mouse 2
% histogram((REM930HomecageDuration),20)
% hold on
% histogram((REM930CNODuration),20)
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 930-930-930-930
% ra_Homecage_SWSTotal=[ra930_Homecage_SWSTotal ra930_Homecage_SWSTotal ra930_Homecage_SWSTotal ra930_Homecage_SWSTotal]
% ra_CNO_SWSTotal=[ra930_CNO_SWSTotal ra930_CNO_SWSTotal ra930_CNO_SWSTotal ra930_CNO_SWSTotal]
% 
% ra_Homecage_REMTotal=[ra930_Homecage_REMTotal ra930_Homecage_REMTotal ra930_Homecage_REMTotal ra930_Homecage_REMTotal]
% ra_CNO_REMTotal=[ra930_CNO_REMTotal ra930_CNO_REMTotal ra930_CNO_REMTotal ra930_CNO_REMTotal]
% 
% PlotErrorBarN_KJ({ra_Homecage_SWSTotal,ra_CNO_SWSTotal})
% PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal})
% 
% 
% %Calcul durée total recordings Mouse 930-930-930-930
% 
% timeRecord930Homecage=(Wake930Homecage+SWS930Homecage+REM930Homecage)
% timeRecord930CNO=(Wake930CNO+SWS930CNO+REM930CNO)
% timeRecord930Homecage=(Wake930Homecage+SWS930Homecage+REM930Homecage)
% timeRecord930CNO=(Wake930CNO+SWS930CNO+REM930CNO)
% 
% PlotErrorBarN_KJ({timeRecord930Homecage, timeRecord930CNO,timeRecord930Homecage, timeRecord930CNO})
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
