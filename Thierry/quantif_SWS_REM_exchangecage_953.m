%% Script pour analyse des changements de cages en CNO / Saline
%% Homecage1 day 2

cd /media/nas5/Thierry_DATA/Exchange Cages/953_953_953_953_Baseline2_02072019_190702_085527/M953_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage1
SWS953Homecage1DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS953Homecage1Start=Start(SWSEpoch)./(1e4);
SWS953Homecage1End=End(SWSEpoch)./(1e4);
SWS953Homecage1DurationEpisods=SWS953Homecage1End-SWS953Homecage1Start;%durée de chaque épisode
Nb_SWSEpoch953Homecage1 = length(SWS953Homecage1Start);%Nombre d'épisodes de SWS

%WAKE Homecage1
Wake953Homecage1DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake953Homecage1Start = Start(Wake)./(1e4);
Wake953Homecage1End = End(Wake)./(1e4); 
Wake953Homecage1DurationEpisods=Wake953Homecage1End-Wake953Homecage1Start;
Nb_WakeEpoch953Homecage1 = length(Wake953Homecage1Start); 

%REM Homecage1
REM953Homecage1DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM953Homecage1Start=Start(REMEpoch)./(1e4);
REM953Homecage1End=End(REMEpoch)./(1e4);
REM953Homecage1DurationEpisods=REM953Homecage1End-REM953Homecage1Start;
Nb_REMEpoch953Homecage1 = length(REM953Homecage1Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_953_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_953_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_953_Homecage1=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_953_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_953_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_953_Homecage1 PercWake_Total_953_Homecage1 PercREM_Total_953_Homecage1]
PlotErrorBarN_KJ({PercWake_Total_953_Homecage1 PercSWS_Total_953_Homecage1 PercREM_Total_953_Homecage1})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 953 Homecage1)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch953Homecage1 Nb_SWSEpoch953Homecage1 Nb_REMEpoch953Homecage1] 
PlotErrorBarN_KJ({Nb_WakeEpoch953Homecage1 Nb_SWSEpoch953Homecage1 Nb_REMEpoch953Homecage1})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 953 Homecage1)')
xticklabels({'Wake Homecage1','SWS Homecage1','REM Homecage1'})

%Total sleep duration Homecage1
TotalSleep953Homecage1=SWS953Homecage1DurationTot+REM953Homecage1DurationTot;
TotalSession953Homecage1=Wake953Homecage1DurationTot+SWS953Homecage1DurationTot+REM953Homecage1DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_953 = length(Start(Wake)); 
% sb2_953 = length(Start(SWSEpoch)); 
% rb2_953 = length(Start(REMEpoch)); 
% allb2_953 = wb2_953+sb2_953+rb2_953; 
% wpb2_953 = wb2_953/allb2_953*100; 
% spb2_953 = sb2_953/allb2_953*100; 
% rpb2_953 = rb2_953/allb2_953*100;


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

PercFirstHalfHomecage1_953=nanmean(perHomecage1(1:length(perHomecage1)/2));
PercSecHalfHomecage1_953=nanmean(perHomecage1(length(perHomecage1)/2:end));

PercFirstThirdHomecage1_953=nanmean(perHomecage1(1:length(perHomecage1)/3))
PercSecThirdHomecage1_953=nanmean(perHomecage1(length(perHomecage1)/3:2*length(perHomecage1)/3))
PercLastThirdHomecage1_953=nanmean(perHomecage1(2*length(perHomecage1)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage1_953 PercSecHalfHomecage1_953 PercFirstThirdHomecage1_953 PercSecThirdHomecage1_953 PercLastThirdHomecage1_953})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/953_953_953_953_CNO_Saline_03072019_190703_091346/Mouse953_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS CNO
SWS953CNODurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS953CNOStart=Start(SWSEpoch)./(1e4);
SWS953CNOEnd=End(SWSEpoch)./(1e4);
SWS953CNODurationEpisods=SWS953CNOEnd-SWS953CNOStart;%durée de chaque épisode
Nb_SWSEpoch953CNO = length(SWS953CNOStart);%Nombre d'épisodes de SWS

%WAKE CNO 
Wake953CNODurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake953CNOStart = Start(Wake)./(1e4);
Wake953CNOEnd = End(Wake)./(1e4); 
Wake953CNODurationEpisods=Wake953CNOEnd-Wake953CNOStart;
Nb_WakeEpoch953CNO = length(Wake953CNOStart); 

%REM CNO 
REM953CNODurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM953CNOStart=Start(REMEpoch)./(1e4);
REM953CNOEnd=End(REMEpoch)./(1e4);
REM953CNODurationEpisods=REM953CNOEnd-REM953CNOStart;
Nb_REMEpoch953CNO = length(REM953CNOStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_953_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_953_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_953_CNO=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_953_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_953_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_953_CNO PercWake_Total_953_CNO PercREM_Total_953_CNO]
PlotErrorBarN_KJ({PercWake_Total_953_CNO PercSWS_Total_953_CNO PercREM_Total_953_CNO})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 953 CNO)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch953CNO Nb_SWSEpoch953CNO Nb_REMEpoch953CNO] 
PlotErrorBarN_KJ({Nb_WakeEpoch953CNO Nb_SWSEpoch953CNO Nb_REMEpoch953CNO})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 953 CNO)')
xticklabels({'Wake CNO','SWS CNO','REM CNO'})

%Total sleep duration CNO
TotalSleep953CNO=SWS953CNODurationTot+REM953CNODurationTot;
TotalSession953CNO=Wake953CNODurationTot+SWS953CNODurationTot+REM953CNODurationTot;

% % stages %
% wcno1_953 = length(Start(Wake)); 
% scno1_953 = length(Start(SWSEpoch));
% rcno1_953 = length(Start(REMEpoch));
% allcno1_953 = wcno1_953+scno1_953+rcno1_953;
% wpcno1_953 = wcno1_953/allcno1_953*100;
% spcno1_953 = scno1_953/allcno1_953*100;
% rpcno1_953 = rcno1_953/allcno1_953*100;

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

PercFirstHalfCNO_953=nanmean(perCNO(1:length(perCNO)/2));
PercSecHalfCNO_953=nanmean(perCNO(length(perCNO)/2:end));

PercFirstThirdCNO_953=nanmean(perCNO(1:length(perCNO)/3))
PercSecThirdCNO_953=nanmean(perCNO(length(perCNO)/3:2*length(perCNO)/3))
PercLastThirdCNO_953=nanmean(perCNO(2*length(perCNO)/3:end))

PlotErrorBarN_KJ({PercFirstHalfCNO_953 PercSecHalfCNO_953 PercFirstThirdCNO_953 PercSecThirdCNO_953 PercLastThirdCNO_953})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/953_953_953_953_Baseline3_04072019_190704_090313/M953_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage2
SWS953Homecage2DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS953Homecage2Start=Start(SWSEpoch)./(1e4);
SWS953Homecage2End=End(SWSEpoch)./(1e4);
SWS953Homecage2DurationEpisods=SWS953Homecage2End-SWS953Homecage2Start;%durée de chaque épisode
Nb_SWSEpoch953Homecage2 = length(SWS953Homecage2Start);%Nombre d'épisodes de SWS

%WAKE Homecage2
Wake953Homecage2DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake953Homecage2Start = Start(Wake)./(1e4);
Wake953Homecage2End = End(Wake)./(1e4); 
Wake953Homecage2DurationEpisods=Wake953Homecage2End-Wake953Homecage2Start;
Nb_WakeEpoch953Homecage2 = length(Wake953Homecage2Start); 

%REM Homecage2
REM953Homecage2DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM953Homecage2Start=Start(REMEpoch)./(1e4);
REM953Homecage2End=End(REMEpoch)./(1e4);
REM953Homecage2DurationEpisods=REM953Homecage2End-REM953Homecage2Start;
Nb_REMEpoch953Homecage2 = length(REM953Homecage2Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_953_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_953_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_953_Homecage2=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_953_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_953_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_953_Homecage2 PercWake_Total_953_Homecage2 PercREM_Total_953_Homecage2]
PlotErrorBarN_KJ({PercWake_Total_953_Homecage2 PercSWS_Total_953_Homecage2 PercREM_Total_953_Homecage2})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 953 Homecage2)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch953Homecage2 Nb_SWSEpoch953Homecage2 Nb_REMEpoch953Homecage2] 
PlotErrorBarN_KJ({Nb_WakeEpoch953Homecage2 Nb_SWSEpoch953Homecage2 Nb_REMEpoch953Homecage2})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 953 Homecage2)')
xticklabels({'Wake Homecage2','SWS Homecage2','REM Homecage2'})

%Total sleep duration Homecage2 Mouse 1
TotalSleep953Homecage2=SWS953Homecage2DurationTot+REM953Homecage2DurationTot;
TotalSession953Homecage2=Wake953Homecage2DurationTot+SWS953Homecage2DurationTot+REM953Homecage2DurationTot;

% % stages %
% wb3_953 = length(Start(Wake)); 
% sb3_953 = length(Start(SWSEpoch));
% rb3_953 = length(Start(REMEpoch));
% allb3_953 = wb3_953+sb3_953+rb3_953;
% wpb3_953 = wb3_953/allb3_953*100
% spb3_953 = sb3_953/allb3_953*100;
% rpb3_953 = rb3_953/allb3_953*100;

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

PercFirstHalfHomecage2_953=nanmean(perHomecage2(1:length(perHomecage2)/2));
PercSecHalfHomecage2_953=nanmean(perHomecage2(length(perHomecage2)/2:end));

PercFirstThirdHomecage2_953=nanmean(perHomecage2(1:length(perHomecage2)/3))
PercSecThirdHomecage2_953=nanmean(perHomecage2(length(perHomecage2)/3:2*length(perHomecage2)/3))
PercLastThirdHomecage2_953=nanmean(perHomecage2(2*length(perHomecage2)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage2_953 PercSecHalfHomecage2_953 PercFirstThirdHomecage2_953 PercSecThirdHomecage2_953 PercLastThirdHomecage2_953})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/953_953_953_953_CNO_saline_2_05072019_190705_093630/M953_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Saline
SWS953SalineDurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS953SalineStart=Start(SWSEpoch)./(1e4);
SWS953SalineEnd=End(SWSEpoch)./(1e4);
SWS953SalineDurationEpisods=SWS953SalineEnd-SWS953SalineStart;%durée de chaque épisode
Nb_SWSEpoch953Saline = length(SWS953SalineStart);%Nombre d'épisodes de SWS

%WAKE Saline 
Wake953SalineDurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake953SalineStart = Start(Wake)./(1e4);
Wake953SalineEnd = End(Wake)./(1e4); 
Wake953SalineDurationEpisods=Wake953SalineEnd-Wake953SalineStart;
Nb_WakeEpoch953Saline = length(Wake953SalineStart); 

%REM Saline 
REM953SalineDurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM953SalineStart=Start(REMEpoch)./(1e4);
REM953SalineEnd=End(REMEpoch)./(1e4);
REM953SalineDurationEpisods=REM953SalineEnd-REM953SalineStart;
Nb_REMEpoch953Saline = length(REM953SalineStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_953_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_953_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_953_Saline=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_953_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_953_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_953_Saline PercWake_Total_953_Saline PercREM_Total_953_Saline]
PlotErrorBarN_KJ({PercWake_Total_953_Saline PercSWS_Total_953_Saline PercREM_Total_953_Saline})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 953 Saline)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch953Saline Nb_SWSEpoch953Saline Nb_REMEpoch953Saline] 
PlotErrorBarN_KJ({Nb_WakeEpoch953Saline Nb_SWSEpoch953Saline Nb_REMEpoch953Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 953 Saline)')
xticklabels({'Wake Saline','SWS Saline','REM Saline'})

%Total sleep duration Saline
TotalSleep953Saline=SWS953SalineDurationTot+REM953SalineDurationTot;
TotalSession953Saline=Wake953SalineDurationTot+SWS953SalineDurationTot+REM953SalineDurationTot;

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

PercFirstHalfSaline_953=nanmean(perSaline(1:length(perSaline)/2));
PercSecHalfSaline_953=nanmean(perSaline(length(perSaline)/2:end));

PercFirstThirdSaline_953=nanmean(perSaline(1:length(perSaline)/3))
PercSecThirdSaline_953=nanmean(perSaline(length(perSaline)/3:2*length(perSaline)/3))
PercLastThirdSaline_953=nanmean(perSaline(2*length(perSaline)/3:end))

PlotErrorBarN_KJ({PercFirstHalfSaline_953 PercSecHalfSaline_953 PercFirstThirdSaline_953 PercSecThirdSaline_953 PercLastThirdSaline_953})
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
% wsal_953 = length(Start(Wake)); 
% ssal_953 = length(Start(SWSEpoch));
% rsal_953 = length(Start(REMEpoch));
% allsal_953 = wsal_953+ssal_953+rsal_953;
% wpsal_953 = wsal_953/allsal_953*100
% spsal_953 = ssal_953/allsal_953*100;
% rpsal_953 = rsal_953/allsal_953*100;
%
% f = figure('Position', [0 0 1000 400]);
%     subplot(2,2,1)
%     bar([spb2_953 wpb2_953 rpb2_953],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('953 Sleep stages proportion Homecage 1')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,2)
%     bar([spcno1_953 wpcno1_953 rpcno1_953],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('953 Sleep stages proportion CNO')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,3)
%     bar([spb3_953 wpb3_953 rpb3_953],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('953 Sleep stages proportion Homacage 2')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,4)
%     bar([spsal_953 wpsal_953 rpsal_953],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('953 Sleep stages proportion Saline')
%     xticklabels({'SWS','Wake','REM'})

%% CNO vs Homecage1
%Ratio (REM/SWS)
ra_RemSwsCNO953=(REM953CNODurationTot)/(SWS953CNODurationTot);
ra_RemSwsHomecage1_953=(REM953Homecage1DurationTot)/(SWS953Homecage1DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep953Homecage1=(Wake953Homecage1DurationTot)./(TotalSleep953Homecage1);
ra_WakeSleep953CNO=(Wake953CNODurationTot)./(TotalSleep953CNO);

%Calcul ratio SWS vs Total Sleep
ra953_CNO_SWSTotal=SWS953CNODurationTot./TotalSleep953CNO;
ra953_Homecage1_SWSTotal=SWS953Homecage1DurationTot./TotalSleep953Homecage1;
%Calcul ratio REM vs Total Sleep
ra953_Homecage1_REMTotal=REM953Homecage1DurationTot./TotalSleep953Homecage1;
ra953_CNO_REMTotal=REM953CNODurationTot./TotalSleep953CNO;
[ra953_Homecage1_SWSTotal ra953_CNO_SWSTotal ra953_Homecage1_REMTotal ra953_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra953_Homecage1_SWSTotal ra953_CNO_SWSTotal ra953_Homecage1_REMTotal ra953_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in homecage1 vs Exchange Cage CNO (Mouse 953)')
xticklabels({'SWS/Sleep Homecage1','SWS/Sleep Exchange CNO','REM/Sleep Homecage1','REM/Sleep Exchange CNO'})

%% CNO vs Homecage2
%Ratio (REM/SWS)
ra_RemSwsCNO953=(REM953CNODurationTot)/(SWS953CNODurationTot);
ra_RemSwsHomecage2_953=(REM953Homecage2DurationTot)/(SWS953Homecage2DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep953Homecage2=(Wake953Homecage2DurationTot)./(TotalSleep953Homecage2);
ra_WakeSleep953CNO=(Wake953CNODurationTot)./(TotalSleep953CNO);

%Calcul ratio SWS vs Total Sleep
ra953_CNO_SWSTotal=SWS953CNODurationTot./TotalSleep953CNO;
ra953_Homecage2_SWSTotal=SWS953Homecage2DurationTot./TotalSleep953Homecage2;
%Calcul ratio REM vs Total Sleep
ra953_Homecage2_REMTotal=REM953Homecage2DurationTot./TotalSleep953Homecage2;
ra953_CNO_REMTotal=REM953CNODurationTot./TotalSleep953CNO;
[ra953_Homecage2_SWSTotal ra953_CNO_SWSTotal ra953_Homecage2_REMTotal ra953_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra953_Homecage2_SWSTotal ra953_CNO_SWSTotal ra953_Homecage2_REMTotal ra953_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Homecage2 vs Exchange Cage CNO (Mouse 953)')
xticklabels({'SWS/Sleep Homecage2','SWS/Sleep Exchange CNO','REM/Sleep Homecage2','REM/Sleep Exchange CNO'})

%create histogram distributions 
% histogram((REM953Homecage1DurationEpisods),20)
% hold on
% histogram((REM953CNODurationEpisods),20)
% 
% histogram((REM953Homecage2DurationEpisods),20)
% hold on
% histogram((REM953CNODurationEpisods),20)

%% CNO vs Saline
%Ratio (REM/SWS)
ra_RemSwsCNO953=(REM953CNODurationTot)/(SWS953CNODurationTot);
ra_RemSwsSaline953=(REM953SalineDurationTot)/(SWS953SalineDurationTot);

%Ratio (Wake/Sleep)
ra_WakeTsleep953Saline=(Wake953SalineDurationTot)./(TotalSleep953Saline);
ra_WakeTsleep953CNO=(Wake953CNODurationTot)./(TotalSleep953CNO);

%Calcul ratio SWS vs Total Sleep 
ra953_CNO_SWSTotal=SWS953CNODurationTot./TotalSleep953CNO;
ra953_Saline_SWSTotal=SWS953SalineDurationTot./TotalSleep953Saline;

%Calcul ratio REM vs Total Sleep
ra953_Saline_REMTotal=REM953SalineDurationTot./TotalSleep953Saline;
ra953_CNO_REMTotal=REM953CNODurationTot./TotalSleep953CNO;
[ra953_Saline_SWSTotal ra953_CNO_SWSTotal ra953_Saline_REMTotal ra953_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra953_Saline_SWSTotal ra953_CNO_SWSTotal ra953_Saline_REMTotal ra953_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Saline vs Exchange Cage CNO (Mouse 953)')
xticklabels({'','SWS/Sleep Exchange Saline','SWS/Sleep Exchange CNO','REM/Sleep Exchange Saline','REM/Sleep Exchange CNO'})


%% tracer les spectres de l'hippocampe pour chaque état

clear all

%REM
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M953_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M953_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M953_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M953_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power REM (M953)')
set(gca,'FontSize',14)

clear all

%Wake
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M953_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M953_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M953_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,Wake))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M953_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,Wake))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power Wake (M953)')
set(gca,'FontSize',14)

clear all

%SWS
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M953_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M953_CNO
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M953_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M953_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power SWS (M953)')
set(gca,'FontSize',14)


% %%%%%%%
% cd /media/nas5/Thierry_DATA/Exchange Cages/953_953_953_953_Baseline2_02072019_190702_085527/Mouse953
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS Homecage Mouse2
% SWS953Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS953HomecageStart=Start(SWSEpoch)./(1e4)
% SWS953HomecageEnd=End(SWSEpoch)./(1e4)
% SWS953HomecageDuration=SWS953HomecageEnd-SWS953HomecageStart
% Nb_SWSEpoch953Homecage = length(SWS953HomecageStart); 
% 
% %WAKE Homecage Mouse2
% Wake953Homecage=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake953HomecageStart = Start(Wake)./(1e4);
% Wake953HomecageEnd = End(Wake)./(1e4); 
% Wake953HomecageDuration=Wake953HomecageEnd-Wake953HomecageStart
% Nb_WakeEpoch953Homecage = length(Wake953HomecageStart); 
% 
% %REM Homecage Mouse2
% REM953Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM953HomecageStart=Start(REMEpoch)./(1e4)
% REM953HomecageEnd=End(REMEpoch)./(1e4)
% REM953HomecageDuration=REM953HomecageEnd-REM953HomecageStart
% Nb_REMEpoch953Homecage = length(REM953HomecageStart); 
% 
% %Total sleep duration Homecage Mouse2
% TotalSleep953Homecage=SWS953Homecage+REM953Homecage
% 
% cd /media/mobs/MOBs96/M953_Sleep_cage_changed_day_07112018
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS CNO Mouse2
% SWS953CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS953CNOStart=Start(SWSEpoch)./(1e4)
% SWS953CNOEnd=End(SWSEpoch)./(1e4)
% SWS953CNODuration=SWS953CNOEnd-SWS953CNOStart
% Nb_SWSEpoch953CNO = length(SWS953CNOStart); 
% 
% %WAKE CNO Mouse2
% Wake953CNO=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake953CNOStart = Start(Wake)./(1e4);
% Wake953CNOEnd = End(Wake)./(1e4); 
% Wake953CNODuration=Wake953CNOEnd-Wake953CNOStart
% Nb_WakeEpoch953CNO = length(Wake953CNOStart); 
% 
% %REM CNO Mouse2
% REM953CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM953CNOStart=Start(REMEpoch)./(1e4)
% REM953CNOEnd=End(REMEpoch)./(1e4)
% REM953CNODuration=REM953CNOEnd-REM953CNOStart
% Nb_REMEpoch953CNO = length(REM953CNOStart); 
% 
% %Total sleep duration CNO Mouse2
% TotalSleep953CNO=SWS953CNO+REM953CNO

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Ratio (REM/SWS) Mouse2
% ra_RemSwsCNO953=(REM953CNO)/(SWS953CNO)
% ra_RemSwsHomecage953=(REM953Homecage)/(SWS953Homecage)
% 
% %Ratio (Wake/Sleep) Mouse2
% ra_WakeTsleep953Homecage=(Wake953Homecage)./(TotalSleep953Homecage)
% ra_WakeTsleep953CNO=(Wake953CNO)./(TotalSleep953CNO)
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
% ra953_CNO_SWSTotal=SWS953CNO./TotalSleep953CNO;
% ra953_Homecage_SWSTotal=SWS953Homecage./TotalSleep953Homecage;
% ra953_Homecage_REMTotal=REM953Homecage./TotalSleep953Homecage;
% ra953_CNO_REMTotal=REM953CNO./TotalSleep953CNO;
% [ra953_Homecage_SWSTotal ra953_CNO_SWSTotal ra953_Homecage_REMTotal ra953_CNO_REMTotal]
%  
% PlotErrorBarN_KJ({ra953_Homecage_SWSTotal ra953_CNO_SWSTotal ra953_Homecage_REMTotal ra953_CNO_REMTotal})
% 
% %Create histogram distributions Mouse 2
% histogram((REM953HomecageDuration),20)
% hold on
% histogram((REM953CNODuration),20)
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 953-953-953-953
% ra_Homecage_SWSTotal=[ra953_Homecage_SWSTotal ra953_Homecage_SWSTotal ra953_Homecage_SWSTotal ra953_Homecage_SWSTotal]
% ra_CNO_SWSTotal=[ra953_CNO_SWSTotal ra953_CNO_SWSTotal ra953_CNO_SWSTotal ra953_CNO_SWSTotal]
% 
% ra_Homecage_REMTotal=[ra953_Homecage_REMTotal ra953_Homecage_REMTotal ra953_Homecage_REMTotal ra953_Homecage_REMTotal]
% ra_CNO_REMTotal=[ra953_CNO_REMTotal ra953_CNO_REMTotal ra953_CNO_REMTotal ra953_CNO_REMTotal]
% 
% PlotErrorBarN_KJ({ra_Homecage_SWSTotal,ra_CNO_SWSTotal})
% PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal})
% 
% 
% %Calcul durée total recordings Mouse 953-953-953-953
% 
% timeRecord953Homecage=(Wake953Homecage+SWS953Homecage+REM953Homecage)
% timeRecord953CNO=(Wake953CNO+SWS953CNO+REM953CNO)
% timeRecord953Homecage=(Wake953Homecage+SWS953Homecage+REM953Homecage)
% timeRecord953CNO=(Wake953CNO+SWS953CNO+REM953CNO)
% 
% PlotErrorBarN_KJ({timeRecord953Homecage, timeRecord953CNO,timeRecord953Homecage, timeRecord953CNO})
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
