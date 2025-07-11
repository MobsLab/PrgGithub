%% Script pour analyse des changements de cages en CNO / Saline
%% Homecage1 day 2

cd /media/nas5/Thierry_DATA/Exchange Cages/926_926_927_928_Baseline2_02072019_190702_085527/M926_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage1
SWS926Homecage1DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS926Homecage1Start=Start(SWSEpoch)./(1e4);
SWS926Homecage1End=End(SWSEpoch)./(1e4);
SWS926Homecage1DurationEpisods=SWS926Homecage1End-SWS926Homecage1Start;%durée de chaque épisode
Nb_SWSEpoch926Homecage1 = length(SWS926Homecage1Start);%Nombre d'épisodes de SWS

%WAKE Homecage1
Wake926Homecage1DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake926Homecage1Start = Start(Wake)./(1e4);
Wake926Homecage1End = End(Wake)./(1e4); 
Wake926Homecage1DurationEpisods=Wake926Homecage1End-Wake926Homecage1Start;
Nb_WakeEpoch926Homecage1 = length(Wake926Homecage1Start); 

%REM Homecage1
REM926Homecage1DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM926Homecage1Start=Start(REMEpoch)./(1e4);
REM926Homecage1End=End(REMEpoch)./(1e4);
REM926Homecage1DurationEpisods=REM926Homecage1End-REM926Homecage1Start;
Nb_REMEpoch926Homecage1 = length(REM926Homecage1Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_926_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_926_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_926_Homecage1=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_926_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_926_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_926_Homecage1 PercWake_Total_926_Homecage1 PercREM_Total_926_Homecage1]
PlotErrorBarN_KJ({PercWake_Total_926_Homecage1 PercSWS_Total_926_Homecage1 PercREM_Total_926_Homecage1})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 926 Homecage1)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch926Homecage1 Nb_SWSEpoch926Homecage1 Nb_REMEpoch926Homecage1] 
PlotErrorBarN_KJ({Nb_WakeEpoch926Homecage1 Nb_SWSEpoch926Homecage1 Nb_REMEpoch926Homecage1})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 926 Homecage1)')
xticklabels({'Wake Homecage1','SWS Homecage1','REM Homecage1'})

%Total sleep duration Homecage1
TotalSleep926Homecage1=SWS926Homecage1DurationTot+REM926Homecage1DurationTot;
TotalSession926Homecage1=Wake926Homecage1DurationTot+SWS926Homecage1DurationTot+REM926Homecage1DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_926 = length(Start(Wake)); 
% sb2_926 = length(Start(SWSEpoch)); 
% rb2_926 = length(Start(REMEpoch)); 
% allb2_926 = wb2_926+sb2_926+rb2_926; 
% wpb2_926 = wb2_926/allb2_926*100; 
% spb2_926 = sb2_926/allb2_926*100; 
% rpb2_926 = rb2_926/allb2_926*100;


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

PercFirstHalfHomecage1_926=nanmean(perHomecage1(1:length(perHomecage1)/2));
PercSecHalfHomecage1_926=nanmean(perHomecage1(length(perHomecage1)/2:end));

PercFirstThirdHomecage1_926=nanmean(perHomecage1(1:length(perHomecage1)/3))
PercSecThirdHomecage1_926=nanmean(perHomecage1(length(perHomecage1)/3:2*length(perHomecage1)/3))
PercLastThirdHomecage1_926=nanmean(perHomecage1(2*length(perHomecage1)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage1_926 PercSecHalfHomecage1_926 PercFirstThirdHomecage1_926 PercSecThirdHomecage1_926 PercLastThirdHomecage1_926})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/926_926_927_928_CNO_Saline_03072019_190703_091346/Mouse926_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS CNO
SWS926CNODurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS926CNOStart=Start(SWSEpoch)./(1e4);
SWS926CNOEnd=End(SWSEpoch)./(1e4);
SWS926CNODurationEpisods=SWS926CNOEnd-SWS926CNOStart;%durée de chaque épisode
Nb_SWSEpoch926CNO = length(SWS926CNOStart);%Nombre d'épisodes de SWS

%WAKE CNO 
Wake926CNODurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake926CNOStart = Start(Wake)./(1e4);
Wake926CNOEnd = End(Wake)./(1e4); 
Wake926CNODurationEpisods=Wake926CNOEnd-Wake926CNOStart;
Nb_WakeEpoch926CNO = length(Wake926CNOStart); 

%REM CNO 
REM926CNODurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM926CNOStart=Start(REMEpoch)./(1e4);
REM926CNOEnd=End(REMEpoch)./(1e4);
REM926CNODurationEpisods=REM926CNOEnd-REM926CNOStart;
Nb_REMEpoch926CNO = length(REM926CNOStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_926_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_926_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_926_CNO=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_926_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_926_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_926_CNO PercWake_Total_926_CNO PercREM_Total_926_CNO]
PlotErrorBarN_KJ({PercWake_Total_926_CNO PercSWS_Total_926_CNO PercREM_Total_926_CNO})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 926 CNO)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch926CNO Nb_SWSEpoch926CNO Nb_REMEpoch926CNO] 
PlotErrorBarN_KJ({Nb_WakeEpoch926CNO Nb_SWSEpoch926CNO Nb_REMEpoch926CNO})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 926 CNO)')
xticklabels({'Wake CNO','SWS CNO','REM CNO'})

%Total sleep duration CNO
TotalSleep926CNO=SWS926CNODurationTot+REM926CNODurationTot;
TotalSession926CNO=Wake926CNODurationTot+SWS926CNODurationTot+REM926CNODurationTot;

% % stages %
% wcno1_926 = length(Start(Wake)); 
% scno1_926 = length(Start(SWSEpoch));
% rcno1_926 = length(Start(REMEpoch));
% allcno1_926 = wcno1_926+scno1_926+rcno1_926;
% wpcno1_926 = wcno1_926/allcno1_926*100;
% spcno1_926 = scno1_926/allcno1_926*100;
% rpcno1_926 = rcno1_926/allcno1_926*100;

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

PercFirstHalfCNO_926=nanmean(perCNO(1:length(perCNO)/2));
PercSecHalfCNO_926=nanmean(perCNO(length(perCNO)/2:end));

PercFirstThirdCNO_926=nanmean(perCNO(1:length(perCNO)/3))
PercSecThirdCNO_926=nanmean(perCNO(length(perCNO)/3:2*length(perCNO)/3))
PercLastThirdCNO_926=nanmean(perCNO(2*length(perCNO)/3:end))

PlotErrorBarN_KJ({PercFirstHalfCNO_926 PercSecHalfCNO_926 PercFirstThirdCNO_926 PercSecThirdCNO_926 PercLastThirdCNO_926})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/926_926_927_928_Baseline3_04072019_190704_090313/M926_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage2
SWS926Homecage2DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS926Homecage2Start=Start(SWSEpoch)./(1e4);
SWS926Homecage2End=End(SWSEpoch)./(1e4);
SWS926Homecage2DurationEpisods=SWS926Homecage2End-SWS926Homecage2Start;%durée de chaque épisode
Nb_SWSEpoch926Homecage2 = length(SWS926Homecage2Start);%Nombre d'épisodes de SWS

%WAKE Homecage2
Wake926Homecage2DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake926Homecage2Start = Start(Wake)./(1e4);
Wake926Homecage2End = End(Wake)./(1e4); 
Wake926Homecage2DurationEpisods=Wake926Homecage2End-Wake926Homecage2Start;
Nb_WakeEpoch926Homecage2 = length(Wake926Homecage2Start); 

%REM Homecage2
REM926Homecage2DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM926Homecage2Start=Start(REMEpoch)./(1e4);
REM926Homecage2End=End(REMEpoch)./(1e4);
REM926Homecage2DurationEpisods=REM926Homecage2End-REM926Homecage2Start;
Nb_REMEpoch926Homecage2 = length(REM926Homecage2Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_926_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_926_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_926_Homecage2=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_926_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_926_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_926_Homecage2 PercWake_Total_926_Homecage2 PercREM_Total_926_Homecage2]
PlotErrorBarN_KJ({PercWake_Total_926_Homecage2 PercSWS_Total_926_Homecage2 PercREM_Total_926_Homecage2})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 926 Homecage2)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch926Homecage2 Nb_SWSEpoch926Homecage2 Nb_REMEpoch926Homecage2] 
PlotErrorBarN_KJ({Nb_WakeEpoch926Homecage2 Nb_SWSEpoch926Homecage2 Nb_REMEpoch926Homecage2})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 926 Homecage2)')
xticklabels({'Wake Homecage2','SWS Homecage2','REM Homecage2'})

%Total sleep duration Homecage2 Mouse 1
TotalSleep926Homecage2=SWS926Homecage2DurationTot+REM926Homecage2DurationTot;
TotalSession926Homecage2=Wake926Homecage2DurationTot+SWS926Homecage2DurationTot+REM926Homecage2DurationTot;

% % stages %
% wb3_926 = length(Start(Wake)); 
% sb3_926 = length(Start(SWSEpoch));
% rb3_926 = length(Start(REMEpoch));
% allb3_926 = wb3_926+sb3_926+rb3_926;
% wpb3_926 = wb3_926/allb3_926*100
% spb3_926 = sb3_926/allb3_926*100;
% rpb3_926 = rb3_926/allb3_926*100;

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

PercFirstHalfHomecage2_926=nanmean(perHomecage2(1:length(perHomecage2)/2));
PercSecHalfHomecage2_926=nanmean(perHomecage2(length(perHomecage2)/2:end));

PercFirstThirdHomecage2_926=nanmean(perHomecage2(1:length(perHomecage2)/3))
PercSecThirdHomecage2_926=nanmean(perHomecage2(length(perHomecage2)/3:2*length(perHomecage2)/3))
PercLastThirdHomecage2_926=nanmean(perHomecage2(2*length(perHomecage2)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage2_926 PercSecHalfHomecage2_926 PercFirstThirdHomecage2_926 PercSecThirdHomecage2_926 PercLastThirdHomecage2_926})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/926_926_927_928_CNO_saline_2_05072019_190705_093630/M926_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Saline
SWS926SalineDurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS926SalineStart=Start(SWSEpoch)./(1e4);
SWS926SalineEnd=End(SWSEpoch)./(1e4);
SWS926SalineDurationEpisods=SWS926SalineEnd-SWS926SalineStart;%durée de chaque épisode
Nb_SWSEpoch926Saline = length(SWS926SalineStart);%Nombre d'épisodes de SWS

%WAKE Saline 
Wake926SalineDurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake926SalineStart = Start(Wake)./(1e4);
Wake926SalineEnd = End(Wake)./(1e4); 
Wake926SalineDurationEpisods=Wake926SalineEnd-Wake926SalineStart;
Nb_WakeEpoch926Saline = length(Wake926SalineStart); 

%REM Saline 
REM926SalineDurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM926SalineStart=Start(REMEpoch)./(1e4);
REM926SalineEnd=End(REMEpoch)./(1e4);
REM926SalineDurationEpisods=REM926SalineEnd-REM926SalineStart;
Nb_REMEpoch926Saline = length(REM926SalineStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_926_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_926_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_926_Saline=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_926_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_926_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_926_Saline PercWake_Total_926_Saline PercREM_Total_926_Saline]
PlotErrorBarN_KJ({PercWake_Total_926_Saline PercSWS_Total_926_Saline PercREM_Total_926_Saline})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 926 Saline)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch926Saline Nb_SWSEpoch926Saline Nb_REMEpoch926Saline] 
PlotErrorBarN_KJ({Nb_WakeEpoch926Saline Nb_SWSEpoch926Saline Nb_REMEpoch926Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 926 Saline)')
xticklabels({'Wake Saline','SWS Saline','REM Saline'})

%Total sleep duration Saline
TotalSleep926Saline=SWS926SalineDurationTot+REM926SalineDurationTot;
TotalSession926Saline=Wake926SalineDurationTot+SWS926SalineDurationTot+REM926SalineDurationTot;

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

PercFirstHalfSaline_926=nanmean(perSaline(1:length(perSaline)/2));
PercSecHalfSaline_926=nanmean(perSaline(length(perSaline)/2:end));

PercFirstThirdSaline_926=nanmean(perSaline(1:length(perSaline)/3))
PercSecThirdSaline_926=nanmean(perSaline(length(perSaline)/3:2*length(perSaline)/3))
PercLastThirdSaline_926=nanmean(perSaline(2*length(perSaline)/3:end))

PlotErrorBarN_KJ({PercFirstHalfSaline_926 PercSecHalfSaline_926 PercFirstThirdSaline_926 PercSecThirdSaline_926 PercLastThirdSaline_926})
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
% wsal_926 = length(Start(Wake)); 
% ssal_926 = length(Start(SWSEpoch));
% rsal_926 = length(Start(REMEpoch));
% allsal_926 = wsal_926+ssal_926+rsal_926;
% wpsal_926 = wsal_926/allsal_926*100
% spsal_926 = ssal_926/allsal_926*100;
% rpsal_926 = rsal_926/allsal_926*100;
%
% f = figure('Position', [0 0 1000 400]);
%     subplot(2,2,1)
%     bar([spb2_926 wpb2_926 rpb2_926],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('926 Sleep stages proportion Homecage 1')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,2)
%     bar([spcno1_926 wpcno1_926 rpcno1_926],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('926 Sleep stages proportion CNO')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,3)
%     bar([spb3_926 wpb3_926 rpb3_926],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('926 Sleep stages proportion Homacage 2')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,4)
%     bar([spsal_926 wpsal_926 rpsal_926],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('926 Sleep stages proportion Saline')
%     xticklabels({'SWS','Wake','REM'})

%% CNO vs Homecage1
%Ratio (REM/SWS)
ra_RemSwsCNO926=(REM926CNODurationTot)/(SWS926CNODurationTot);
ra_RemSwsHomecage1_926=(REM926Homecage1DurationTot)/(SWS926Homecage1DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep926Homecage1=(Wake926Homecage1DurationTot)./(TotalSleep926Homecage1);
ra_WakeSleep926CNO=(Wake926CNODurationTot)./(TotalSleep926CNO);

%Calcul ratio SWS vs Total Sleep
ra926_CNO_SWSTotal=SWS926CNODurationTot./TotalSleep926CNO;
ra926_Homecage1_SWSTotal=SWS926Homecage1DurationTot./TotalSleep926Homecage1;
%Calcul ratio REM vs Total Sleep
ra926_Homecage1_REMTotal=REM926Homecage1DurationTot./TotalSleep926Homecage1;
ra926_CNO_REMTotal=REM926CNODurationTot./TotalSleep926CNO;
[ra926_Homecage1_SWSTotal ra926_CNO_SWSTotal ra926_Homecage1_REMTotal ra926_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra926_Homecage1_SWSTotal ra926_CNO_SWSTotal ra926_Homecage1_REMTotal ra926_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in homecage1 vs Exchange Cage CNO (Mouse 926)')
xticklabels({'SWS/Sleep Homecage1','SWS/Sleep Exchange CNO','REM/Sleep Homecage1','REM/Sleep Exchange CNO'})

%% CNO vs Homecage2
%Ratio (REM/SWS)
ra_RemSwsCNO926=(REM926CNODurationTot)/(SWS926CNODurationTot);
ra_RemSwsHomecage2_926=(REM926Homecage2DurationTot)/(SWS926Homecage2DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep926Homecage2=(Wake926Homecage2DurationTot)./(TotalSleep926Homecage2);
ra_WakeSleep926CNO=(Wake926CNODurationTot)./(TotalSleep926CNO);

%Calcul ratio SWS vs Total Sleep
ra926_CNO_SWSTotal=SWS926CNODurationTot./TotalSleep926CNO;
ra926_Homecage2_SWSTotal=SWS926Homecage2DurationTot./TotalSleep926Homecage2;
%Calcul ratio REM vs Total Sleep
ra926_Homecage2_REMTotal=REM926Homecage2DurationTot./TotalSleep926Homecage2;
ra926_CNO_REMTotal=REM926CNODurationTot./TotalSleep926CNO;
[ra926_Homecage2_SWSTotal ra926_CNO_SWSTotal ra926_Homecage2_REMTotal ra926_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra926_Homecage2_SWSTotal ra926_CNO_SWSTotal ra926_Homecage2_REMTotal ra926_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Homecage2 vs Exchange Cage CNO (Mouse 926)')
xticklabels({'SWS/Sleep Homecage2','SWS/Sleep Exchange CNO','REM/Sleep Homecage2','REM/Sleep Exchange CNO'})

%create histogram distributions 
histogram((REM926Homecage1DurationEpisods),20)
hold on
histogram((REM926CNODurationEpisods),20)

histogram((REM926Homecage2DurationEpisods),20)
hold on
histogram((REM926CNODurationEpisods),20)

%% CNO vs Saline
%Ratio (REM/SWS)
ra_RemSwsCNO926=(REM926CNODurationTot)/(SWS926CNODurationTot);
ra_RemSwsSaline926=(REM926SalineDurationTot)/(SWS926SalineDurationTot);

%Ratio (Wake/Sleep)
ra_WakeTsleep926Saline=(Wake926SalineDurationTot)./(TotalSleep926Saline);
ra_WakeTsleep926CNO=(Wake926CNODurationTot)./(TotalSleep926CNO);

%Calcul ratio SWS vs Total Sleep 
ra926_CNO_SWSTotal=SWS926CNODurationTot./TotalSleep926CNO;
ra926_Saline_SWSTotal=SWS926SalineDurationTot./TotalSleep926Saline;

%Calcul ratio REM vs Total Sleep
ra926_Saline_REMTotal=REM926SalineDurationTot./TotalSleep926Saline;
ra926_CNO_REMTotal=REM926CNODurationTot./TotalSleep926CNO;
[ra926_Saline_SWSTotal ra926_CNO_SWSTotal ra926_Saline_REMTotal ra926_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra926_Saline_SWSTotal ra926_CNO_SWSTotal ra926_Saline_REMTotal ra926_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Saline vs Exchange Cage CNO (Mouse 926)')
xticklabels({'','SWS/Sleep Exchange Saline','SWS/Sleep Exchange CNO','REM/Sleep Exchange Saline','REM/Sleep Exchange CNO'})


%% tracer les spectres de l'hippocampe pour chaque état
clear all

%REM
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M926_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse926_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M926_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M926_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power REM (M926)')
set(gca,'FontSize',14)

clear all

%Wake
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M926_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse926_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M926_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,Wake))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M926_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,Wake))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power Wake (M926)')
set(gca,'FontSize',14)

clear all

%SWS
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M926_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse926_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M926_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M926_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power SWS (M926)')
set(gca,'FontSize',14)



% %%%%%%%
% cd /media/nas5/Thierry_DATA/Exchange Cages/926_926_926_926_Baseline2_02072019_190702_085527/Mouse926
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS Homecage Mouse2
% SWS926Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS926HomecageStart=Start(SWSEpoch)./(1e4)
% SWS926HomecageEnd=End(SWSEpoch)./(1e4)
% SWS926HomecageDuration=SWS926HomecageEnd-SWS926HomecageStart
% Nb_SWSEpoch926Homecage = length(SWS926HomecageStart); 
% 
% %WAKE Homecage Mouse2
% Wake926Homecage=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake926HomecageStart = Start(Wake)./(1e4);
% Wake926HomecageEnd = End(Wake)./(1e4); 
% Wake926HomecageDuration=Wake926HomecageEnd-Wake926HomecageStart
% Nb_WakeEpoch926Homecage = length(Wake926HomecageStart); 
% 
% %REM Homecage Mouse2
% REM926Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM926HomecageStart=Start(REMEpoch)./(1e4)
% REM926HomecageEnd=End(REMEpoch)./(1e4)
% REM926HomecageDuration=REM926HomecageEnd-REM926HomecageStart
% Nb_REMEpoch926Homecage = length(REM926HomecageStart); 
% 
% %Total sleep duration Homecage Mouse2
% TotalSleep926Homecage=SWS926Homecage+REM926Homecage
% 
% cd /media/mobs/MOBs96/M926_Sleep_cage_changed_day_07112018
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS CNO Mouse2
% SWS926CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS926CNOStart=Start(SWSEpoch)./(1e4)
% SWS926CNOEnd=End(SWSEpoch)./(1e4)
% SWS926CNODuration=SWS926CNOEnd-SWS926CNOStart
% Nb_SWSEpoch926CNO = length(SWS926CNOStart); 
% 
% %WAKE CNO Mouse2
% Wake926CNO=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake926CNOStart = Start(Wake)./(1e4);
% Wake926CNOEnd = End(Wake)./(1e4); 
% Wake926CNODuration=Wake926CNOEnd-Wake926CNOStart
% Nb_WakeEpoch926CNO = length(Wake926CNOStart); 
% 
% %REM CNO Mouse2
% REM926CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM926CNOStart=Start(REMEpoch)./(1e4)
% REM926CNOEnd=End(REMEpoch)./(1e4)
% REM926CNODuration=REM926CNOEnd-REM926CNOStart
% Nb_REMEpoch926CNO = length(REM926CNOStart); 
% 
% %Total sleep duration CNO Mouse2
% TotalSleep926CNO=SWS926CNO+REM926CNO

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Ratio (REM/SWS) Mouse2
% ra_RemSwsCNO926=(REM926CNO)/(SWS926CNO)
% ra_RemSwsHomecage926=(REM926Homecage)/(SWS926Homecage)
% 
% %Ratio (Wake/Sleep) Mouse2
% ra_WakeTsleep926Homecage=(Wake926Homecage)./(TotalSleep926Homecage)
% ra_WakeTsleep926CNO=(Wake926CNO)./(TotalSleep926CNO)
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
% ra926_CNO_SWSTotal=SWS926CNO./TotalSleep926CNO;
% ra926_Homecage_SWSTotal=SWS926Homecage./TotalSleep926Homecage;
% ra926_Homecage_REMTotal=REM926Homecage./TotalSleep926Homecage;
% ra926_CNO_REMTotal=REM926CNO./TotalSleep926CNO;
% [ra926_Homecage_SWSTotal ra926_CNO_SWSTotal ra926_Homecage_REMTotal ra926_CNO_REMTotal]
%  
% PlotErrorBarN_KJ({ra926_Homecage_SWSTotal ra926_CNO_SWSTotal ra926_Homecage_REMTotal ra926_CNO_REMTotal})
% 
% %Create histogram distributions Mouse 2
% histogram((REM926HomecageDuration),20)
% hold on
% histogram((REM926CNODuration),20)
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 926-926-926-926
% ra_Homecage_SWSTotal=[ra926_Homecage_SWSTotal ra926_Homecage_SWSTotal ra926_Homecage_SWSTotal ra926_Homecage_SWSTotal]
% ra_CNO_SWSTotal=[ra926_CNO_SWSTotal ra926_CNO_SWSTotal ra926_CNO_SWSTotal ra926_CNO_SWSTotal]
% 
% ra_Homecage_REMTotal=[ra926_Homecage_REMTotal ra926_Homecage_REMTotal ra926_Homecage_REMTotal ra926_Homecage_REMTotal]
% ra_CNO_REMTotal=[ra926_CNO_REMTotal ra926_CNO_REMTotal ra926_CNO_REMTotal ra926_CNO_REMTotal]
% 
% PlotErrorBarN_KJ({ra_Homecage_SWSTotal,ra_CNO_SWSTotal})
% PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal})
% 
% 
% %Calcul durée total recordings Mouse 926-926-926-926
% 
% timeRecord926Homecage=(Wake926Homecage+SWS926Homecage+REM926Homecage)
% timeRecord926CNO=(Wake926CNO+SWS926CNO+REM926CNO)
% timeRecord926Homecage=(Wake926Homecage+SWS926Homecage+REM926Homecage)
% timeRecord926CNO=(Wake926CNO+SWS926CNO+REM926CNO)
% 
% PlotErrorBarN_KJ({timeRecord926Homecage, timeRecord926CNO,timeRecord926Homecage, timeRecord926CNO})
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
