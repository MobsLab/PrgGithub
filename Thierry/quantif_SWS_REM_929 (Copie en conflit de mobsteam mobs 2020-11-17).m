%% Script pour analyse de cages en CNO / Saline
%% Homecage1 day 2

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M929_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage1
SWS929Homecage1DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS929Homecage1Start=Start(SWSEpoch)./(1e4);
SWS929Homecage1End=End(SWSEpoch)./(1e4);
SWS929Homecage1DurationEpisods=SWS929Homecage1End-SWS929Homecage1Start;%durée de chaque épisode
Nb_SWSEpoch929Homecage1 = length(SWS929Homecage1Start);%Nombre d'épisodes de SWS

%WAKE Homecage1
Wake929Homecage1DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake929Homecage1Start = Start(Wake)./(1e4);
Wake929Homecage1End = End(Wake)./(1e4); 
Wake929Homecage1DurationEpisods=Wake929Homecage1End-Wake929Homecage1Start;
Nb_WakeEpoch929Homecage1 = length(Wake929Homecage1Start); 

%REM Homecage1
REM929Homecage1DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM929Homecage1Start=Start(REMEpoch)./(1e4);
REM929Homecage1End=End(REMEpoch)./(1e4);
REM929Homecage1DurationEpisods=REM929Homecage1End-REM929Homecage1Start;
Nb_REMEpoch929Homecage1 = length(REM929Homecage1Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_929_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_929_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_929_Homecage1=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_929_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_929_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_929_Homecage1 PercWake_Total_929_Homecage1 PercREM_Total_929_Homecage1]
PlotErrorBarN_KJ({PercWake_Total_929_Homecage1 PercSWS_Total_929_Homecage1 PercREM_Total_929_Homecage1})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 929 Homecage1)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)


%Nombre d'épisodes
[Nb_WakeEpoch929Homecage1 Nb_SWSEpoch929Homecage1 Nb_REMEpoch929Homecage1] 
PlotErrorBarN_KJ({Nb_WakeEpoch929Homecage1 Nb_SWSEpoch929Homecage1 Nb_REMEpoch929Homecage1})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 929 Homecage1)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)

%Total sleep duration Homecage1
TotalSleep929Homecage1=SWS929Homecage1DurationTot+REM929Homecage1DurationTot;
TotalSession929Homecage1=Wake929Homecage1DurationTot+SWS929Homecage1DurationTot+REM929Homecage1DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_929 = length(Start(Wake)); 
% sb2_929 = length(Start(SWSEpoch)); 
% rb2_929 = length(Start(REMEpoch)); 
% allb2_929 = wb2_929+sb2_929+rb2_929; 
% wpb2_929 = wb2_929/allb2_929*100; 
% spb2_929 = sb2_929/allb2_929*100; 
% rpb2_929 = rb2_929/allb2_929*100;


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

PercFirstHalfHomecage1_929=nanmean(perHomecage1(1:length(perHomecage1)/2));
PercSecHalfHomecage1_929=nanmean(perHomecage1(length(perHomecage1)/2:end));

PercFirstThirdHomecage1_929=nanmean(perHomecage1(1:length(perHomecage1)/3))
PercSecThirdHomecage1_929=nanmean(perHomecage1(length(perHomecage1)/3:2*length(perHomecage1)/3))
PercLastThirdHomecage1_929=nanmean(perHomecage1(2*length(perHomecage1)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage1_929 PercSecHalfHomecage1_929 PercFirstThirdHomecage1_929 PercSecThirdHomecage1_929 PercLastThirdHomecage1_929})
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

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M929_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS CNO
SWS929CNODurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS929CNOStart=Start(SWSEpoch)./(1e4);
SWS929CNOEnd=End(SWSEpoch)./(1e4);
SWS929CNODurationEpisods=SWS929CNOEnd-SWS929CNOStart;%durée de chaque épisode
Nb_SWSEpoch929CNO = length(SWS929CNOStart);%Nombre d'épisodes de SWS

%WAKE CNO
Wake929CNODurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake929CNOStart = Start(Wake)./(1e4);
Wake929CNOEnd = End(Wake)./(1e4); 
Wake929CNODurationEpisods=Wake929CNOEnd-Wake929CNOStart;
Nb_WakeEpoch929CNO = length(Wake929CNOStart); 

%REM CNO
REM929CNODurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM929CNOStart=Start(REMEpoch)./(1e4);
REM929CNOEnd=End(REMEpoch)./(1e4);
REM929CNODurationEpisods=REM929CNOEnd-REM929CNOStart;
Nb_REMEpoch929CNO = length(REM929CNOStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_929_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_929_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_929_CNO=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_929_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_929_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_929_CNO PercWake_Total_929_CNO PercREM_Total_929_CNO]
PlotErrorBarN_KJ({PercWake_Total_929_CNO PercSWS_Total_929_CNO PercREM_Total_929_CNO})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 929 CNO)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)


%Nombre d'épisodes
[Nb_WakeEpoch929CNO Nb_SWSEpoch929CNO Nb_REMEpoch929CNO] 
PlotErrorBarN_KJ({Nb_WakeEpoch929CNO Nb_SWSEpoch929CNO Nb_REMEpoch929CNO})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 929 CNO)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)

%Total sleep duration CNO
TotalSleep929CNO=SWS929CNODurationTot+REM929CNODurationTot;
TotalSession929CNO=Wake929CNODurationTot+SWS929CNODurationTot+REM929CNODurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_929 = length(Start(Wake)); 
% sb2_929 = length(Start(SWSEpoch)); 
% rb2_929 = length(Start(REMEpoch)); 
% allb2_929 = wb2_929+sb2_929+rb2_929; 
% wpb2_929 = wb2_929/allb2_929*100; 
% spb2_929 = sb2_929/allb2_929*100; 
% rpb2_929 = rb2_929/allb2_929*100;


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

PercFirstHalfCNO_929=nanmean(perCNO(1:length(perCNO)/2));
PercSecHalfCNO_929=nanmean(perCNO(length(perCNO)/2:end));

PercFirstThirdCNO_929=nanmean(perCNO(1:length(perCNO)/3))
PercSecThirdCNO_929=nanmean(perCNO(length(perCNO)/3:2*length(perCNO)/3))
PercLastThirdCNO_929=nanmean(perCNO(2*length(perCNO)/3:end))

PlotErrorBarN_KJ({PercFirstHalfCNO_929 PercSecHalfCNO_929 PercFirstThirdCNO_929 PercSecThirdCNO_929 PercLastThirdCNO_929})
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

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M929_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage2
SWS929Homecage2DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS929Homecage2Start=Start(SWSEpoch)./(1e4);
SWS929Homecage2End=End(SWSEpoch)./(1e4);
SWS929Homecage2DurationEpisods=SWS929Homecage2End-SWS929Homecage2Start;%durée de chaque épisode
Nb_SWSEpoch929Homecage2 = length(SWS929Homecage2Start);%Nombre d'épisodes de SWS

%WAKE Homecage2
Wake929Homecage2DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake929Homecage2Start = Start(Wake)./(1e4);
Wake929Homecage2End = End(Wake)./(1e4); 
Wake929Homecage2DurationEpisods=Wake929Homecage2End-Wake929Homecage2Start;
Nb_WakeEpoch929Homecage2 = length(Wake929Homecage2Start); 

%REM Homecage2
REM929Homecage2DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM929Homecage2Start=Start(REMEpoch)./(1e4);
REM929Homecage2End=End(REMEpoch)./(1e4);
REM929Homecage2DurationEpisods=REM929Homecage2End-REM929Homecage2Start;
Nb_REMEpoch929Homecage2 = length(REM929Homecage2Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_929_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_929_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_929_Homecage2=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_929_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_929_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_929_Homecage2 PercWake_Total_929_Homecage2 PercREM_Total_929_Homecage2]
PlotErrorBarN_KJ({PercWake_Total_929_Homecage2 PercSWS_Total_929_Homecage2 PercREM_Total_929_Homecage2})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 929 Homecage2)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)


%Nombre d'épisodes
[Nb_WakeEpoch929Homecage2 Nb_SWSEpoch929Homecage2 Nb_REMEpoch929Homecage2] 
PlotErrorBarN_KJ({Nb_WakeEpoch929Homecage2 Nb_SWSEpoch929Homecage2 Nb_REMEpoch929Homecage2})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 929 Homecage2)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)

%Total sleep duration Homecage2
TotalSleep929Homecage2=SWS929Homecage2DurationTot+REM929Homecage2DurationTot;
TotalSession929Homecage2=Wake929Homecage2DurationTot+SWS929Homecage2DurationTot+REM929Homecage2DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_929 = length(Start(Wake)); 
% sb2_929 = length(Start(SWSEpoch)); 
% rb2_929 = length(Start(REMEpoch)); 
% allb2_929 = wb2_929+sb2_929+rb2_929; 
% wpb2_929 = wb2_929/allb2_929*100; 
% spb2_929 = sb2_929/allb2_929*100; 
% rpb2_929 = rb2_929/allb2_929*100;


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

PercFirstHalfHomecage2_929=nanmean(perHomecage2(1:length(perHomecage2)/2));
PercSecHalfHomecage2_929=nanmean(perHomecage2(length(perHomecage2)/2:end));

PercFirstThirdHomecage2_929=nanmean(perHomecage2(1:length(perHomecage2)/3))
PercSecThirdHomecage2_929=nanmean(perHomecage2(length(perHomecage2)/3:2*length(perHomecage2)/3))
PercLastThirdHomecage2_929=nanmean(perHomecage2(2*length(perHomecage2)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage2_929 PercSecHalfHomecage2_929 PercFirstThirdHomecage2_929 PercSecThirdHomecage2_929 PercLastThirdHomecage2_929})
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

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Saline
SWS929SalineDurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS929SalineStart=Start(SWSEpoch)./(1e4);
SWS929SalineEnd=End(SWSEpoch)./(1e4);
SWS929SalineDurationEpisods=SWS929SalineEnd-SWS929SalineStart;%durée de chaque épisode
Nb_SWSEpoch929Saline = length(SWS929SalineStart);%Nombre d'épisodes de SWS

%WAKE Saline
Wake929SalineDurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake929SalineStart = Start(Wake)./(1e4);
Wake929SalineEnd = End(Wake)./(1e4); 
Wake929SalineDurationEpisods=Wake929SalineEnd-Wake929SalineStart;
Nb_WakeEpoch929Saline = length(Wake929SalineStart); 

%REM Saline
REM929SalineDurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM929SalineStart=Start(REMEpoch)./(1e4);
REM929SalineEnd=End(REMEpoch)./(1e4);
REM929SalineDurationEpisods=REM929SalineEnd-REM929SalineStart;
Nb_REMEpoch929Saline = length(REM929SalineStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_929_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_929_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_929_Saline=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_929_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_929_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_929_Saline PercWake_Total_929_Saline PercREM_Total_929_Saline]
PlotErrorBarN_KJ({PercWake_Total_929_Saline PercSWS_Total_929_Saline PercREM_Total_929_Saline})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 929 Saline)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)


%Nombre d'épisodes
[Nb_WakeEpoch929Saline Nb_SWSEpoch929Saline Nb_REMEpoch929Saline] 
PlotErrorBarN_KJ({Nb_WakeEpoch929Saline Nb_SWSEpoch929Saline Nb_REMEpoch929Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 929 Saline)')
xticklabels({'Wake','SWS','REM'})
xticks([1 2 3])
set(gca,'FontSize',14)

%Total sleep duration Saline
TotalSleep929Saline=SWS929SalineDurationTot+REM929SalineDurationTot;
TotalSession929Saline=Wake929SalineDurationTot+SWS929SalineDurationTot+REM929SalineDurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_929 = length(Start(Wake)); 
% sb2_929 = length(Start(SWSEpoch)); 
% rb2_929 = length(Start(REMEpoch)); 
% allb2_929 = wb2_929+sb2_929+rb2_929; 
% wpb2_929 = wb2_929/allb2_929*100; 
% spb2_929 = sb2_929/allb2_929*100; 
% rpb2_929 = rb2_929/allb2_929*100;


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

PercFirstHalfSaline_929=nanmean(perSaline(1:length(perSaline)/2));
PercSecHalfSaline_929=nanmean(perSaline(length(perSaline)/2:end));

PercFirstThirdSaline_929=nanmean(perSaline(1:length(perSaline)/3))
PercSecThirdSaline_929=nanmean(perSaline(length(perSaline)/3:2*length(perSaline)/3))
PercLastThirdSaline_929=nanmean(perSaline(2*length(perSaline)/3:end))

PlotErrorBarN_KJ({PercFirstHalfSaline_929 PercSecHalfSaline_929 PercFirstThirdSaline_929 PercSecThirdSaline_929 PercLastThirdSaline_929})
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
% wsal_929 = length(Start(Wake)); 
% ssal_929 = length(Start(SWSEpoch));
% rsal_929 = length(Start(REMEpoch));
% allsal_929 = wsal_929+ssal_929+rsal_929;
% wpsal_929 = wsal_929/allsal_929*100
% spsal_929 = ssal_929/allsal_929*100;
% rpsal_929 = rsal_929/allsal_929*100;
%
% f = figure('Position', [0 0 1000 400]);
%     subplot(2,2,1)
%     bar([spb2_929 wpb2_929 rpb2_929],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('929 Sleep stages proportion Homecage 1')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,2)
%     bar([spcno1_929 wpcno1_929 rpcno1_929],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('929 Sleep stages proportion CNO')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,3)
%     bar([spb3_929 wpb3_929 rpb3_929],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('929 Sleep stages proportion Homacage 2')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,4)
%     bar([spsal_929 wpsal_929 rpsal_929],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('929 Sleep stages proportion Saline')
%     xticklabels({'SWS','Wake','REM'})

%% CNO vs Homecage1
%Ratio (REM/SWS)
ra_RemSwsCNO929=(REM929CNODurationTot)/(SWS929CNODurationTot);
ra_RemSwsHomecage1_929=(REM929Homecage1DurationTot)/(SWS929Homecage1DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep929Homecage1=(Wake929Homecage1DurationTot)./(TotalSleep929Homecage1);
ra_WakeSleep929CNO=(Wake929CNODurationTot)./(TotalSleep929CNO);

%Calcul ratio SWS vs Total Sleep
ra929_CNO_SWSTotal=SWS929CNODurationTot./TotalSleep929CNO;
ra929_Homecage1_SWSTotal=SWS929Homecage1DurationTot./TotalSleep929Homecage1;
%Calcul ratio REM vs Total Sleep
ra929_Homecage1_REMTotal=REM929Homecage1DurationTot./TotalSleep929Homecage1;
ra929_CNO_REMTotal=REM929CNODurationTot./TotalSleep929CNO;
[ra929_Homecage1_SWSTotal ra929_CNO_SWSTotal ra929_Homecage1_REMTotal ra929_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra929_Homecage1_SWSTotal ra929_CNO_SWSTotal ra929_Homecage1_REMTotal ra929_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in homecage1 vs  Cage CNO (Mouse 929)')
xticklabels({'SWS/Sleep Homecage1','SWS/Sleep  CNO','REM/Sleep Homecage1','REM/Sleep  CNO'})
set(gca,'FontSize',14)
xticks([1 2 3 4])


%% CNO vs Homecage2
%Ratio (REM/SWS)
ra_RemSwsCNO929=(REM929CNODurationTot)/(SWS929CNODurationTot);
ra_RemSwsHomecage2_929=(REM929Homecage2DurationTot)/(SWS929Homecage2DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep929Homecage2=(Wake929Homecage2DurationTot)./(TotalSleep929Homecage2);
ra_WakeSleep929CNO=(Wake929CNODurationTot)./(TotalSleep929CNO);

%Calcul ratio SWS vs Total Sleep
ra929_CNO_SWSTotal=SWS929CNODurationTot./TotalSleep929CNO;
ra929_Homecage2_SWSTotal=SWS929Homecage2DurationTot./TotalSleep929Homecage2;
%Calcul ratio REM vs Total Sleep
ra929_Homecage2_REMTotal=REM929Homecage2DurationTot./TotalSleep929Homecage2;
ra929_CNO_REMTotal=REM929CNODurationTot./TotalSleep929CNO;
[ra929_Homecage2_SWSTotal ra929_CNO_SWSTotal ra929_Homecage2_REMTotal ra929_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra929_Homecage2_SWSTotal ra929_CNO_SWSTotal ra929_Homecage2_REMTotal ra929_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Homecage2 vs  Cage CNO (Mouse 929)')
xticklabels({'SWS/Sleep Homecage2','SWS/Sleep  CNO','REM/Sleep Homecage2','REM/Sleep  CNO'})
set(gca,'FontSize',14)
xticks([1 2 3 4])

% %create histogram distributions 
% histogram((REM929Homecage1DurationEpisods),20)
% hold on
% histogram((REM929CNODurationEpisods),20)
% 
% histogram((REM929Homecage2DurationEpisods),20)
% hold on
% histogram((REM929CNODurationEpisods),20)

%% CNO vs Saline
%Ratio (REM/SWS)
ra_RemSwsCNO929=(REM929CNODurationTot)/(SWS929CNODurationTot);
ra_RemSwsSaline929=(REM929SalineDurationTot)/(SWS929SalineDurationTot);

%Ratio (Wake/Sleep)
ra_WakeTsleep929Saline=(Wake929SalineDurationTot)./(TotalSleep929Saline);
ra_WakeTsleep929CNO=(Wake929CNODurationTot)./(TotalSleep929CNO);

%Calcul ratio SWS vs Total Sleep 
ra929_CNO_SWSTotal=SWS929CNODurationTot./TotalSleep929CNO;
ra929_Saline_SWSTotal=SWS929SalineDurationTot./TotalSleep929Saline;

%Calcul ratio REM vs Total Sleep
ra929_Saline_REMTotal=REM929SalineDurationTot./TotalSleep929Saline;
ra929_CNO_REMTotal=REM929CNODurationTot./TotalSleep929CNO;
[ra929_Saline_SWSTotal ra929_CNO_SWSTotal ra929_Saline_REMTotal ra929_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra929_Saline_SWSTotal ra929_CNO_SWSTotal ra929_Saline_REMTotal ra929_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Saline vs  Cage CNO (Mouse 929)')
xticklabels({'SWS/Sleep  Saline','SWS/Sleep  CNO','REM/Sleep  Saline','REM/Sleep  CNO'})
set(gca,'FontSize',14)
xticks([1 2 3 4])


%% Tracer les spectres globaux de l'hippocampe
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M929_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Spectrotsd_Homecage1)),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M929_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Spectrotsd_CNO)),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M929_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Spectrotsd_Homecage2)),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Spectrotsd_Saline)),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power all stages (M929)')
set(gca,'FontSize',14)

clear all


%% tracer les spectres de l'hippocampe restreint pour chaque état
clear all

%REM
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M929_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'k','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M929_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M929_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power REM (M929)')
set(gca,'FontSize',14)

clear all

%Wake
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M929_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M929_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline
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
title('HPC spectral power Wake (M929)')
set(gca,'FontSize',14)

clear all

%SWS
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M929_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M929_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M929_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power SWS (M929)')
set(gca,'FontSize',14)



% %%%%%%%
% cd /media/nas5/Thierry_DATA/Exchange Cages/929_929_929_929_Baseline2_02072019_190702_085527/Mouse929
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS Homecage Mouse2
% SWS929Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS929HomecageStart=Start(SWSEpoch)./(1e4)
% SWS929HomecageEnd=End(SWSEpoch)./(1e4)
% SWS929HomecageDuration=SWS929HomecageEnd-SWS929HomecageStart
% Nb_SWSEpoch929Homecage = length(SWS929HomecageStart); 
% 
% %WAKE Homecage Mouse2
% Wake929Homecage=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake929HomecageStart = Start(Wake)./(1e4);
% Wake929HomecageEnd = End(Wake)./(1e4); 
% Wake929HomecageDuration=Wake929HomecageEnd-Wake929HomecageStart
% Nb_WakeEpoch929Homecage = length(Wake929HomecageStart); 
% 
% %REM Homecage Mouse2
% REM929Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM929HomecageStart=Start(REMEpoch)./(1e4)
% REM929HomecageEnd=End(REMEpoch)./(1e4)
% REM929HomecageDuration=REM929HomecageEnd-REM929HomecageStart
% Nb_REMEpoch929Homecage = length(REM929HomecageStart); 
% 
% %Total sleep duration Homecage Mouse2
% TotalSleep929Homecage=SWS929Homecage+REM929Homecage
% 
% cd /media/mobs/MOBs96/M929_Sleep_cage_changed_day_07112018
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS CNO Mouse2
% SWS929CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS929CNOStart=Start(SWSEpoch)./(1e4)
% SWS929CNOEnd=End(SWSEpoch)./(1e4)
% SWS929CNODuration=SWS929CNOEnd-SWS929CNOStart
% Nb_SWSEpoch929CNO = length(SWS929CNOStart); 
% 
% %WAKE CNO Mouse2
% Wake929CNO=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake929CNOStart = Start(Wake)./(1e4);
% Wake929CNOEnd = End(Wake)./(1e4); 
% Wake929CNODuration=Wake929CNOEnd-Wake929CNOStart
% Nb_WakeEpoch929CNO = length(Wake929CNOStart); 
% 
% %REM CNO Mouse2
% REM929CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM929CNOStart=Start(REMEpoch)./(1e4)
% REM929CNOEnd=End(REMEpoch)./(1e4)
% REM929CNODuration=REM929CNOEnd-REM929CNOStart
% Nb_REMEpoch929CNO = length(REM929CNOStart); 
% 
% %Total sleep duration CNO Mouse2
% TotalSleep929CNO=SWS929CNO+REM929CNO

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Ratio (REM/SWS) Mouse2
% ra_RemSwsCNO929=(REM929CNO)/(SWS929CNO)
% ra_RemSwsHomecage929=(REM929Homecage)/(SWS929Homecage)
% 
% %Ratio (Wake/Sleep) Mouse2
% ra_WakeTsleep929Homecage=(Wake929Homecage)./(TotalSleep929Homecage)
% ra_WakeTsleep929CNO=(Wake929CNO)./(TotalSleep929CNO)
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
% ra929_CNO_SWSTotal=SWS929CNO./TotalSleep929CNO;
% ra929_Homecage_SWSTotal=SWS929Homecage./TotalSleep929Homecage;
% ra929_Homecage_REMTotal=REM929Homecage./TotalSleep929Homecage;
% ra929_CNO_REMTotal=REM929CNO./TotalSleep929CNO;
% [ra929_Homecage_SWSTotal ra929_CNO_SWSTotal ra929_Homecage_REMTotal ra929_CNO_REMTotal]
%  
% PlotErrorBarN_KJ({ra929_Homecage_SWSTotal ra929_CNO_SWSTotal ra929_Homecage_REMTotal ra929_CNO_REMTotal})
% 
% %Create histogram distributions Mouse 2
% histogram((REM929HomecageDuration),20)
% hold on
% histogram((REM929CNODuration),20)
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 929-929-929-929
% ra_Homecage_SWSTotal=[ra929_Homecage_SWSTotal ra929_Homecage_SWSTotal ra929_Homecage_SWSTotal ra929_Homecage_SWSTotal]
% ra_CNO_SWSTotal=[ra929_CNO_SWSTotal ra929_CNO_SWSTotal ra929_CNO_SWSTotal ra929_CNO_SWSTotal]
% 
% ra_Homecage_REMTotal=[ra929_Homecage_REMTotal ra929_Homecage_REMTotal ra929_Homecage_REMTotal ra929_Homecage_REMTotal]
% ra_CNO_REMTotal=[ra929_CNO_REMTotal ra929_CNO_REMTotal ra929_CNO_REMTotal ra929_CNO_REMTotal]
% 
% PlotErrorBarN_KJ({ra_Homecage_SWSTotal,ra_CNO_SWSTotal})
% PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal})
% 
% 
% %Calcul durée total recordings Mouse 929-929-929-929
% 
% timeRecord929Homecage=(Wake929Homecage+SWS929Homecage+REM929Homecage)
% timeRecord929CNO=(Wake929CNO+SWS929CNO+REM929CNO)
% timeRecord929Homecage=(Wake929Homecage+SWS929Homecage+REM929Homecage)
% timeRecord929CNO=(Wake929CNO+SWS929CNO+REM929CNO)
% 
% PlotErrorBarN_KJ({timeRecord929Homecage, timeRecord929CNO,timeRecord929Homecage, timeRecord929CNO})
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
