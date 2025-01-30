%% Script pour analyse des changements de cages en CNO / Saline
%% Homecage1 day 2

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Baseline2_02072019_190702_085527/M928_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage1
SWS928Homecage1DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS928Homecage1Start=Start(SWSEpoch)./(1e4);
SWS928Homecage1End=End(SWSEpoch)./(1e4);
SWS928Homecage1DurationEpisods=SWS928Homecage1End-SWS928Homecage1Start;%durée de chaque épisode
Nb_SWSEpoch928Homecage1 = length(SWS928Homecage1Start);%Nombre d'épisodes de SWS

%WAKE Homecage1
Wake928Homecage1DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake928Homecage1Start = Start(Wake)./(1e4);
Wake928Homecage1End = End(Wake)./(1e4); 
Wake928Homecage1DurationEpisods=Wake928Homecage1End-Wake928Homecage1Start;
Nb_WakeEpoch928Homecage1 = length(Wake928Homecage1Start); 

%REM Homecage1
REM928Homecage1DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM928Homecage1Start=Start(REMEpoch)./(1e4);
REM928Homecage1End=End(REMEpoch)./(1e4);
REM928Homecage1DurationEpisods=REM928Homecage1End-REM928Homecage1Start;
Nb_REMEpoch928Homecage1 = length(REM928Homecage1Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_928_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_928_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_928_Homecage1=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_928_Homecage1=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_928_Homecage1=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_928_Homecage1 PercWake_Total_928_Homecage1 PercREM_Total_928_Homecage1]
PlotErrorBarN_KJ({PercWake_Total_928_Homecage1 PercSWS_Total_928_Homecage1 PercREM_Total_928_Homecage1})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 928 Homecage1)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch928Homecage1 Nb_SWSEpoch928Homecage1 Nb_REMEpoch928Homecage1] 
PlotErrorBarN_KJ({Nb_WakeEpoch928Homecage1 Nb_SWSEpoch928Homecage1 Nb_REMEpoch928Homecage1})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 928 Homecage1)')
xticklabels({'Wake Homecage1','SWS Homecage1','REM Homecage1'})

%Total sleep duration Homecage1
TotalSleep928Homecage1=SWS928Homecage1DurationTot+REM928Homecage1DurationTot;
TotalSession928Homecage1=Wake928Homecage1DurationTot+SWS928Homecage1DurationTot+REM928Homecage1DurationTot;

% Pourcentage du nombre d'épisodes REM/SWS/Wake
%
% wb2_928 = length(Start(Wake)); 
% sb2_928 = length(Start(SWSEpoch)); 
% rb2_928 = length(Start(REMEpoch)); 
% allb2_928 = wb2_928+sb2_928+rb2_928; 
% wpb2_928 = wb2_928/allb2_928*100; 
% spb2_928 = sb2_928/allb2_928*100; 
% rpb2_928 = rb2_928/allb2_928*100;


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

PercFirstHalfHomecage1_928=nanmean(perHomecage1(1:length(perHomecage1)/2));
PercSecHalfHomecage1_928=nanmean(perHomecage1(length(perHomecage1)/2:end));

PercFirstThirdHomecage1_928=nanmean(perHomecage1(1:length(perHomecage1)/3))
PercSecThirdHomecage1_928=nanmean(perHomecage1(length(perHomecage1)/3:2*length(perHomecage1)/3))
PercLastThirdHomecage1_928=nanmean(perHomecage1(2*length(perHomecage1)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage1_928 PercSecHalfHomecage1_928 PercFirstThirdHomecage1_928 PercSecThirdHomecage1_928 PercLastThirdHomecage1_928})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/928_928_928_928_CNO_Saline_03072019_190703_091346/Mouse928_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS CNO
SWS928CNODurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS928CNOStart=Start(SWSEpoch)./(1e4);
SWS928CNOEnd=End(SWSEpoch)./(1e4);
SWS928CNODurationEpisods=SWS928CNOEnd-SWS928CNOStart;%durée de chaque épisode
Nb_SWSEpoch928CNO = length(SWS928CNOStart);%Nombre d'épisodes de SWS

%WAKE CNO 
Wake928CNODurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake928CNOStart = Start(Wake)./(1e4);
Wake928CNOEnd = End(Wake)./(1e4); 
Wake928CNODurationEpisods=Wake928CNOEnd-Wake928CNOStart;
Nb_WakeEpoch928CNO = length(Wake928CNOStart); 

%REM CNO 
REM928CNODurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM928CNOStart=Start(REMEpoch)./(1e4);
REM928CNOEnd=End(REMEpoch)./(1e4);
REM928CNODurationEpisods=REM928CNOEnd-REM928CNOStart;
Nb_REMEpoch928CNO = length(REM928CNOStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_928_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_928_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_928_CNO=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_928_CNO=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_928_CNO=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_928_CNO PercWake_Total_928_CNO PercREM_Total_928_CNO]
PlotErrorBarN_KJ({PercWake_Total_928_CNO PercSWS_Total_928_CNO PercREM_Total_928_CNO})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 928 CNO)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch928CNO Nb_SWSEpoch928CNO Nb_REMEpoch928CNO] 
PlotErrorBarN_KJ({Nb_WakeEpoch928CNO Nb_SWSEpoch928CNO Nb_REMEpoch928CNO})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 928 CNO)')
xticklabels({'Wake CNO','SWS CNO','REM CNO'})

%Total sleep duration CNO
TotalSleep928CNO=SWS928CNODurationTot+REM928CNODurationTot;
TotalSession928CNO=Wake928CNODurationTot+SWS928CNODurationTot+REM928CNODurationTot;

% % stages %
% wcno1_928 = length(Start(Wake)); 
% scno1_928 = length(Start(SWSEpoch));
% rcno1_928 = length(Start(REMEpoch));
% allcno1_928 = wcno1_928+scno1_928+rcno1_928;
% wpcno1_928 = wcno1_928/allcno1_928*100;
% spcno1_928 = scno1_928/allcno1_928*100;
% rpcno1_928 = rcno1_928/allcno1_928*100;

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

PercFirstHalfCNO_928=nanmean(perCNO(1:length(perCNO)/2));
PercSecHalfCNO_928=nanmean(perCNO(length(perCNO)/2:end));

PercFirstThirdCNO_928=nanmean(perCNO(1:length(perCNO)/3))
PercSecThirdCNO_928=nanmean(perCNO(length(perCNO)/3:2*length(perCNO)/3))
PercLastThirdCNO_928=nanmean(perCNO(2*length(perCNO)/3:end))

PlotErrorBarN_KJ({PercFirstHalfCNO_928 PercSecHalfCNO_928 PercFirstThirdCNO_928 PercSecThirdCNO_928 PercLastThirdCNO_928})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/928_928_928_928_Baseline3_04072019_190704_090313/M928_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Homecage2
SWS928Homecage2DurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS928Homecage2Start=Start(SWSEpoch)./(1e4);
SWS928Homecage2End=End(SWSEpoch)./(1e4);
SWS928Homecage2DurationEpisods=SWS928Homecage2End-SWS928Homecage2Start;%durée de chaque épisode
Nb_SWSEpoch928Homecage2 = length(SWS928Homecage2Start);%Nombre d'épisodes de SWS

%WAKE Homecage2
Wake928Homecage2DurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake928Homecage2Start = Start(Wake)./(1e4);
Wake928Homecage2End = End(Wake)./(1e4); 
Wake928Homecage2DurationEpisods=Wake928Homecage2End-Wake928Homecage2Start;
Nb_WakeEpoch928Homecage2 = length(Wake928Homecage2Start); 

%REM Homecage2
REM928Homecage2DurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM928Homecage2Start=Start(REMEpoch)./(1e4);
REM928Homecage2End=End(REMEpoch)./(1e4);
REM928Homecage2DurationEpisods=REM928Homecage2End-REM928Homecage2Start;
Nb_REMEpoch928Homecage2 = length(REM928Homecage2Start);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_928_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_928_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_928_Homecage2=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_928_Homecage2=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_928_Homecage2=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_928_Homecage2 PercWake_Total_928_Homecage2 PercREM_Total_928_Homecage2]
PlotErrorBarN_KJ({PercWake_Total_928_Homecage2 PercSWS_Total_928_Homecage2 PercREM_Total_928_Homecage2})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 928 Homecage2)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch928Homecage2 Nb_SWSEpoch928Homecage2 Nb_REMEpoch928Homecage2] 
PlotErrorBarN_KJ({Nb_WakeEpoch928Homecage2 Nb_SWSEpoch928Homecage2 Nb_REMEpoch928Homecage2})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 928 Homecage2)')
xticklabels({'Wake Homecage2','SWS Homecage2','REM Homecage2'})

%Total sleep duration Homecage2 Mouse 1
TotalSleep928Homecage2=SWS928Homecage2DurationTot+REM928Homecage2DurationTot;
TotalSession928Homecage2=Wake928Homecage2DurationTot+SWS928Homecage2DurationTot+REM928Homecage2DurationTot;

% % stages %
% wb3_928 = length(Start(Wake)); 
% sb3_928 = length(Start(SWSEpoch));
% rb3_928 = length(Start(REMEpoch));
% allb3_928 = wb3_928+sb3_928+rb3_928;
% wpb3_928 = wb3_928/allb3_928*100
% spb3_928 = sb3_928/allb3_928*100;
% rpb3_928 = rb3_928/allb3_928*100;

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

PercFirstHalfHomecage2_928=nanmean(perHomecage2(1:length(perHomecage2)/2));
PercSecHalfHomecage2_928=nanmean(perHomecage2(length(perHomecage2)/2:end));

PercFirstThirdHomecage2_928=nanmean(perHomecage2(1:length(perHomecage2)/3))
PercSecThirdHomecage2_928=nanmean(perHomecage2(length(perHomecage2)/3:2*length(perHomecage2)/3))
PercLastThirdHomecage2_928=nanmean(perHomecage2(2*length(perHomecage2)/3:end))

PlotErrorBarN_KJ({PercFirstHalfHomecage2_928 PercSecHalfHomecage2_928 PercFirstThirdHomecage2_928 PercSecThirdHomecage2_928 PercLastThirdHomecage2_928})
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

cd /media/nas5/Thierry_DATA/Exchange Cages/928_928_928_928_CNO_saline_2_05072019_190705_093630/M928_Saline_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

%SWS Saline
SWS928SalineDurationTot=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));%durée total de SWS
SWS928SalineStart=Start(SWSEpoch)./(1e4);
SWS928SalineEnd=End(SWSEpoch)./(1e4);
SWS928SalineDurationEpisods=SWS928SalineEnd-SWS928SalineStart;%durée de chaque épisode
Nb_SWSEpoch928Saline = length(SWS928SalineStart);%Nombre d'épisodes de SWS

%WAKE Saline 
Wake928SalineDurationTot=sum(End(Wake,'s')-Start(Wake,'s'));
Wake928SalineStart = Start(Wake)./(1e4);
Wake928SalineEnd = End(Wake)./(1e4); 
Wake928SalineDurationEpisods=Wake928SalineEnd-Wake928SalineStart;
Nb_WakeEpoch928Saline = length(Wake928SalineStart); 

%REM Saline 
REM928SalineDurationTot=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
REM928SalineStart=Start(REMEpoch)./(1e4);
REM928SalineEnd=End(REMEpoch)./(1e4);
REM928SalineDurationEpisods=REM928SalineEnd-REM928SalineStart;
Nb_REMEpoch928Saline = length(REM928SalineStart);

%Pourcentage de REM/SWS/Wake sur tout le sommeil

%REM/Sleep
PercREM_Sleep_928_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%SWS/Sleep
PercSWS_Sleep_928_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100
%Wake/Total
PercWake_Total_928_Saline=(sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%SWS/Total
PercSWS_Total_928_Saline=(sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')))).*100
%REM/Total
PercREM_Total_928_Saline=(sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s')))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100

[PercSWS_Total_928_Saline PercWake_Total_928_Saline PercREM_Total_928_Saline]
PlotErrorBarN_KJ({PercWake_Total_928_Saline PercSWS_Total_928_Saline PercREM_Total_928_Saline})
ylabel('Percentage (%)')
xlabel('Conditions')
title('Sleep/Wake proportions (Mouse 928 Saline)')
xticklabels({'Wake','SWS','REM'})

%Nombre d'épisodes
[Nb_WakeEpoch928Saline Nb_SWSEpoch928Saline Nb_REMEpoch928Saline] 
PlotErrorBarN_KJ({Nb_WakeEpoch928Saline Nb_SWSEpoch928Saline Nb_REMEpoch928Saline})
ylabel('Number of events')
xlabel('Conditions')
title('Number of sate events (Mouse 928 Saline)')
xticklabels({'Wake Saline','SWS Saline','REM Saline'})

%Total sleep duration Saline
TotalSleep928Saline=SWS928SalineDurationTot+REM928SalineDurationTot;
TotalSession928Saline=Wake928SalineDurationTot+SWS928SalineDurationTot+REM928SalineDurationTot;

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

PercFirstHalfSaline_928=nanmean(perSaline(1:length(perSaline)/2));
PercSecHalfSaline_928=nanmean(perSaline(length(perSaline)/2:end));

PercFirstThirdSaline_928=nanmean(perSaline(1:length(perSaline)/3))
PercSecThirdSaline_928=nanmean(perSaline(length(perSaline)/3:2*length(perSaline)/3))
PercLastThirdSaline_928=nanmean(perSaline(2*length(perSaline)/3:end))

PlotErrorBarN_KJ({PercFirstHalfSaline_928 PercSecHalfSaline_928 PercFirstThirdSaline_928 PercSecThirdSaline_928 PercLastThirdSaline_928})
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
% wsal_928 = length(Start(Wake)); 
% ssal_928 = length(Start(SWSEpoch));
% rsal_928 = length(Start(REMEpoch));
% allsal_928 = wsal_928+ssal_928+rsal_928;
% wpsal_928 = wsal_928/allsal_928*100
% spsal_928 = ssal_928/allsal_928*100;
% rpsal_928 = rsal_928/allsal_928*100;
%
% f = figure('Position', [0 0 1000 400]);
%     subplot(2,2,1)
%     bar([spb2_928 wpb2_928 rpb2_928],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('928 Sleep stages proportion Homecage 1')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,2)
%     bar([spcno1_928 wpcno1_928 rpcno1_928],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('928 Sleep stages proportion CNO')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,3)
%     bar([spb3_928 wpb3_928 rpb3_928],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('928 Sleep stages proportion Homacage 2')
%     xticklabels({'SWS','Wake','REM'})
%     
%     subplot(2,2,4)
%     bar([spsal_928 wpsal_928 rpsal_928],'k')
%     ylabel('Proportion (%)')
%     xlabel('Sleep stages')
%     title('928 Sleep stages proportion Saline')
%     xticklabels({'SWS','Wake','REM'})

%% CNO vs Homecage1
%Ratio (REM/SWS)
ra_RemSwsCNO928=(REM928CNODurationTot)/(SWS928CNODurationTot);
ra_RemSwsHomecage1_928=(REM928Homecage1DurationTot)/(SWS928Homecage1DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep928Homecage1=(Wake928Homecage1DurationTot)./(TotalSleep928Homecage1);
ra_WakeSleep928CNO=(Wake928CNODurationTot)./(TotalSleep928CNO);

%Calcul ratio SWS vs Total Sleep
ra928_CNO_SWSTotal=SWS928CNODurationTot./TotalSleep928CNO;
ra928_Homecage1_SWSTotal=SWS928Homecage1DurationTot./TotalSleep928Homecage1;
%Calcul ratio REM vs Total Sleep
ra928_Homecage1_REMTotal=REM928Homecage1DurationTot./TotalSleep928Homecage1;
ra928_CNO_REMTotal=REM928CNODurationTot./TotalSleep928CNO;
[ra928_Homecage1_SWSTotal ra928_CNO_SWSTotal ra928_Homecage1_REMTotal ra928_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra928_Homecage1_SWSTotal ra928_CNO_SWSTotal ra928_Homecage1_REMTotal ra928_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in homecage1 vs Exchange Cage CNO (Mouse 928)')
xticklabels({'SWS/Sleep Homecage1','SWS/Sleep Exchange CNO','REM/Sleep Homecage1','REM/Sleep Exchange CNO'})

%% CNO vs Homecage2
%Ratio (REM/SWS)
ra_RemSwsCNO928=(REM928CNODurationTot)/(SWS928CNODurationTot);
ra_RemSwsHomecage2_928=(REM928Homecage2DurationTot)/(SWS928Homecage2DurationTot);

%Ratio (Wake/Sleep)
ra_WakeSleep928Homecage2=(Wake928Homecage2DurationTot)./(TotalSleep928Homecage2);
ra_WakeSleep928CNO=(Wake928CNODurationTot)./(TotalSleep928CNO);

%Calcul ratio SWS vs Total Sleep
ra928_CNO_SWSTotal=SWS928CNODurationTot./TotalSleep928CNO;
ra928_Homecage2_SWSTotal=SWS928Homecage2DurationTot./TotalSleep928Homecage2;
%Calcul ratio REM vs Total Sleep
ra928_Homecage2_REMTotal=REM928Homecage2DurationTot./TotalSleep928Homecage2;
ra928_CNO_REMTotal=REM928CNODurationTot./TotalSleep928CNO;
[ra928_Homecage2_SWSTotal ra928_CNO_SWSTotal ra928_Homecage2_REMTotal ra928_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra928_Homecage2_SWSTotal ra928_CNO_SWSTotal ra928_Homecage2_REMTotal ra928_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Homecage2 vs Exchange Cage CNO (Mouse 928)')
xticklabels({'SWS/Sleep Homecage2','SWS/Sleep Exchange CNO','REM/Sleep Homecage2','REM/Sleep Exchange CNO'})

%create histogram distributions 
histogram((REM928Homecage1DurationEpisods),20)
hold on
histogram((REM928CNODurationEpisods),20)

histogram((REM928Homecage2DurationEpisods),20)
hold on
histogram((REM928CNODurationEpisods),20)

%% CNO vs Saline
%Ratio (REM/SWS)
ra_RemSwsCNO928=(REM928CNODurationTot)/(SWS928CNODurationTot);
ra_RemSwsSaline928=(REM928SalineDurationTot)/(SWS928SalineDurationTot);

%Ratio (Wake/Sleep)
ra_WakeTsleep928Saline=(Wake928SalineDurationTot)./(TotalSleep928Saline);
ra_WakeTsleep928CNO=(Wake928CNODurationTot)./(TotalSleep928CNO);

%Calcul ratio SWS vs Total Sleep 
ra928_CNO_SWSTotal=SWS928CNODurationTot./TotalSleep928CNO;
ra928_Saline_SWSTotal=SWS928SalineDurationTot./TotalSleep928Saline;

%Calcul ratio REM vs Total Sleep
ra928_Saline_REMTotal=REM928SalineDurationTot./TotalSleep928Saline;
ra928_CNO_REMTotal=REM928CNODurationTot./TotalSleep928CNO;
[ra928_Saline_SWSTotal ra928_CNO_SWSTotal ra928_Saline_REMTotal ra928_CNO_REMTotal]
 
PlotErrorBarN_KJ({ra928_Saline_SWSTotal ra928_CNO_SWSTotal ra928_Saline_REMTotal ra928_CNO_REMTotal})
ylabel('ratio')
xlabel('Conditions')
title('Ratio SWS/Sleep and REM/Sleep in Saline vs Exchange Cage CNO (Mouse 928)')
xticklabels({'','SWS/Sleep Exchange Saline','SWS/Sleep Exchange CNO','REM/Sleep Exchange Saline','REM/Sleep Exchange CNO'})


%% tracer les spectres de l'hippocampe pour chaque état
clear all

%REM
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M928_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,REMEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M928_CNO_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,REMEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M928_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,REMEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/M928_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,REMEpoch))),'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power REM (M928)')
set(gca,'FontSize',14)

clear all

%Wake
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M928_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,Wake))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M928_CNO_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,Wake))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M928_Baseline3
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
title('HPC spectral power Wake (M928)')
set(gca,'FontSize',14)

clear all

%SWS
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M928_Baseline2
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage1=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(Spectrotsd_Homecage1,SWSEpoch))),'b','LineWidth',2)
hold on, 

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M928_CNO_1_day5
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_CNO=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_CNO,SWSEpoch))),'r','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M928_Baseline3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Homecage2=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Homecage2,SWSEpoch))),'k','LineWidth',2)
hold on,

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/M928_Saline
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
load('H_Low_Spectrum.mat')
Spectrotsd_Saline=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};
plot(f,mean(Data(Restrict(Spectrotsd_Saline,SWSEpoch))),'LineWidth',2,'Color',[0 0.498039215803146 0],'LineWidth',2)
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC spectral power SWS (M928)')
set(gca,'FontSize',14)



% %%%%%%%
% cd /media/nas5/Thierry_DATA/Exchange Cages/928_928_928_928_Baseline2_02072019_190702_085527/Mouse928
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS Homecage Mouse2
% SWS928Homecage=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS928HomecageStart=Start(SWSEpoch)./(1e4)
% SWS928HomecageEnd=End(SWSEpoch)./(1e4)
% SWS928HomecageDuration=SWS928HomecageEnd-SWS928HomecageStart
% Nb_SWSEpoch928Homecage = length(SWS928HomecageStart); 
% 
% %WAKE Homecage Mouse2
% Wake928Homecage=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake928HomecageStart = Start(Wake)./(1e4);
% Wake928HomecageEnd = End(Wake)./(1e4); 
% Wake928HomecageDuration=Wake928HomecageEnd-Wake928HomecageStart
% Nb_WakeEpoch928Homecage = length(Wake928HomecageStart); 
% 
% %REM Homecage Mouse2
% REM928Homecage=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM928HomecageStart=Start(REMEpoch)./(1e4)
% REM928HomecageEnd=End(REMEpoch)./(1e4)
% REM928HomecageDuration=REM928HomecageEnd-REM928HomecageStart
% Nb_REMEpoch928Homecage = length(REM928HomecageStart); 
% 
% %Total sleep duration Homecage Mouse2
% TotalSleep928Homecage=SWS928Homecage+REM928Homecage
% 
% cd /media/mobs/MOBs96/M928_Sleep_cage_changed_day_07112018
% load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch')
% 
% %SWS CNO Mouse2
% SWS928CNO=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% SWS928CNOStart=Start(SWSEpoch)./(1e4)
% SWS928CNOEnd=End(SWSEpoch)./(1e4)
% SWS928CNODuration=SWS928CNOEnd-SWS928CNOStart
% Nb_SWSEpoch928CNO = length(SWS928CNOStart); 
% 
% %WAKE CNO Mouse2
% Wake928CNO=sum(End(Wake,'s')-Start(Wake,'s'))
% Wake928CNOStart = Start(Wake)./(1e4);
% Wake928CNOEnd = End(Wake)./(1e4); 
% Wake928CNODuration=Wake928CNOEnd-Wake928CNOStart
% Nb_WakeEpoch928CNO = length(Wake928CNOStart); 
% 
% %REM CNO Mouse2
% REM928CNO=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))
% REM928CNOStart=Start(REMEpoch)./(1e4)
% REM928CNOEnd=End(REMEpoch)./(1e4)
% REM928CNODuration=REM928CNOEnd-REM928CNOStart
% Nb_REMEpoch928CNO = length(REM928CNOStart); 
% 
% %Total sleep duration CNO Mouse2
% TotalSleep928CNO=SWS928CNO+REM928CNO

                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Ratio (REM/SWS) Mouse2
% ra_RemSwsCNO928=(REM928CNO)/(SWS928CNO)
% ra_RemSwsHomecage928=(REM928Homecage)/(SWS928Homecage)
% 
% %Ratio (Wake/Sleep) Mouse2
% ra_WakeTsleep928Homecage=(Wake928Homecage)./(TotalSleep928Homecage)
% ra_WakeTsleep928CNO=(Wake928CNO)./(TotalSleep928CNO)
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 2
% ra928_CNO_SWSTotal=SWS928CNO./TotalSleep928CNO;
% ra928_Homecage_SWSTotal=SWS928Homecage./TotalSleep928Homecage;
% ra928_Homecage_REMTotal=REM928Homecage./TotalSleep928Homecage;
% ra928_CNO_REMTotal=REM928CNO./TotalSleep928CNO;
% [ra928_Homecage_SWSTotal ra928_CNO_SWSTotal ra928_Homecage_REMTotal ra928_CNO_REMTotal]
%  
% PlotErrorBarN_KJ({ra928_Homecage_SWSTotal ra928_CNO_SWSTotal ra928_Homecage_REMTotal ra928_CNO_REMTotal})
% 
% %Create histogram distributions Mouse 2
% histogram((REM928HomecageDuration),20)
% hold on
% histogram((REM928CNODuration),20)
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Calcul ratio SWS vs Total Sleep et REM vs Total Sleep Mouse 928-928-928-928
% ra_Homecage_SWSTotal=[ra928_Homecage_SWSTotal ra928_Homecage_SWSTotal ra928_Homecage_SWSTotal ra928_Homecage_SWSTotal]
% ra_CNO_SWSTotal=[ra928_CNO_SWSTotal ra928_CNO_SWSTotal ra928_CNO_SWSTotal ra928_CNO_SWSTotal]
% 
% ra_Homecage_REMTotal=[ra928_Homecage_REMTotal ra928_Homecage_REMTotal ra928_Homecage_REMTotal ra928_Homecage_REMTotal]
% ra_CNO_REMTotal=[ra928_CNO_REMTotal ra928_CNO_REMTotal ra928_CNO_REMTotal ra928_CNO_REMTotal]
% 
% PlotErrorBarN_KJ({ra_Homecage_SWSTotal,ra_CNO_SWSTotal})
% PlotErrorBarN_KJ({ra_Homecage_REMTotal,ra_CNO_REMTotal})
% 
% 
% %Calcul durée total recordings Mouse 928-928-928-928
% 
% timeRecord928Homecage=(Wake928Homecage+SWS928Homecage+REM928Homecage)
% timeRecord928CNO=(Wake928CNO+SWS928CNO+REM928CNO)
% timeRecord928Homecage=(Wake928Homecage+SWS928Homecage+REM928Homecage)
% timeRecord928CNO=(Wake928CNO+SWS928CNO+REM928CNO)
% 
% PlotErrorBarN_KJ({timeRecord928Homecage, timeRecord928CNO,timeRecord928Homecage, timeRecord928CNO})
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
