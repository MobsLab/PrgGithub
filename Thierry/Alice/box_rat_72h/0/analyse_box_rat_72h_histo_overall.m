%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ce programme permet de tracer 3 figures différentes pour l'éxpérience
% box_rat_72h.
% Il est composé de 4 sections

% Section 1. Chargement des données avec PathForExperiments_TG
% Section 2. Tracé de l'histogramme des pourcentage des états sur tout l'enregistrement
% Section 3. Tracé de l'histogramme des pourcentage de REM et SWS sur le sommeil
% Section 4. Tracé de l'histogramme du nombre d'épisodes des 3 états sur tout l'enregistrement


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 1 : Chargement des données

close all
clear all
Dir_figures='/media/nas5/Thierry_DATA/Rat_box_72h/Figures/'

%Load Baseline
Dir_Baseline1=PathForExperiments_TG('box_rat_72h_Baseline1');

for i=1:length(Dir_Baseline1.path);
    cd(Dir_Baseline1.path{i}{1});
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep');
    Wake_Baseline1(i)=Wake;
    REMEpoch_Baseline1(i)=REMEpoch;
    NREMEpoch_Baseline1(i)=SWSEpoch;
    PercNREM_Total_Baseline1(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercREM_Total_Baseline1(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercWake_Total_Baseline1(i)=sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercNREM_Sleep_Baseline1(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;
    PercREM_Sleep_Baseline1(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;  
    NbNREM_Baseline1(i)=length(length(SWSEpoch));
    NbREM_Baseline1(i)=length(length(REMEpoch));
    NbWake_Baseline1(i)=length(length(Wake));
end

%Load Exposure
Dir_Exposure=PathForExperiments_TG('box_rat_72h_Exposure');

for i=1:length(Dir_Exposure.path);
    cd(Dir_Exposure.path{i}{1});
    load('SleepScoring_OBGamma.mat', 'Wake','SWSEpoch','SWSEpoch','Sleep');
    Wake_Exposure(i)=Wake;
    REMEpoch_Exposure(i)=REMEpoch;
    NREMEpoch_Exposure(i)=SWSEpoch;
    
    
    PercNREM_Total_Exposure(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercREM_Total_Exposure(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercWake_Total_Exposure(i)=sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercNREM_Sleep_Exposure(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;
    PercREM_Sleep_Exposure(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;  
    NbNREM_Exposure(i)=length(length(SWSEpoch));
    NbREM_Exposure(i)=length(length(REMEpoch));
    NbWake_Exposure(i)=length(length((Wake)));   
end

%Load Baseline2
Dir_Baseline2=PathForExperiments_TG('box_rat_72h_Baseline2');

for i=1:length(Dir_Baseline2.path);
    cd(Dir_Baseline2.path{i}{1});
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep');
    Wake_Baseline2(i)=Wake;
    REMEpoch_Baseline2(i)=REMEpoch;
    NREMEpoch_Baseline2(i)=SWSEpoch;
    PercNREM_Total_Baseline2(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercREM_Total_Baseline2(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercWake_Total_Baseline2(i)=sum(Stop(Wake,'s')-Start(Wake,'s'))./(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s'))).*100;
    PercNREM_Sleep_Baseline2(i)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;
    PercREM_Sleep_Baseline2(i)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))./sum(Stop(Sleep,'s')-Start(Sleep,'s')).*100;  
    NbNREM_Baseline2(i)=length(length(SWSEpoch));
    NbREM_Baseline2(i)=length(length(REMEpoch));
    NbWake_Baseline2(i)=length(length((Wake)));
end


%% Section 2 : Tracé des figures Mean percentage of different states Wake NREM & REM /Total

%Pourcentages de Wake, NREM & REM au cours de l'enregistrement pour les 3
%conditions pour les 2 souris
%* Wake
figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of Wake/Total')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({PercWake_Total_Baseline1 PercWake_Total_Exposure PercWake_Total_Baseline2},'newfig',0);

%* REM
subplot(1,3,2);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({PercREM_Total_Baseline1 PercREM_Total_Exposure PercREM_Total_Baseline2},'newfig',0);

%* NREM
subplot(1,3,3);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({PercNREM_Total_Baseline1 PercNREM_Total_Exposure PercNREM_Total_Baseline2},'newfig',0);

cd (Dir_figures)
savefig(fullfile('Percentage of states during the wole experiments.fig'))

%% Section 3 : Tracé des figures Mean percentage of different states NREM & REM /Sleep

%Pourcentages de Wake, NREM & REM au cours du sommeil pour les 3
%conditions pour les 2 souris

%* REM
figure
subplot(1,2,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Sleep')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({PercREM_Sleep_Baseline1 PercREM_Sleep_Exposure PercREM_Sleep_Baseline2},'newfig',0);

%* NREM
subplot(1,2,2);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Sleep')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({PercNREM_Sleep_Baseline1 PercNREM_Sleep_Exposure PercNREM_Sleep_Baseline2},'newfig',0);

cd (Dir_figures)
savefig(fullfile('Percentage of states during the sleep.fig'))

%% Section 4 : Tracé des figures number of different states

%Nombre d'épisodes de Wake, NREM & REM au cours de l'enregistrement pour les 3
%conditions pour les 2 souris
%* Wake
figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of Wake bouts')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({NbWake_Baseline1 NbWake_Exposure NbWake_Baseline2},'newfig',0);

%* REM
subplot(1,3,2);
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of NREM bouts')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({NbREM_Baseline1 NbREM_Exposure NbREM_Baseline2},'newfig',0);

%* NREM
subplot(1,3,3);
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of REM bouts')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({NbNREM_Baseline1 NbNREM_Exposure NbNREM_Baseline2},'newfig',0);
cd (Dir_figures)
savefig(fullfile('Mean number of bouts for different states for the 3 conditions.fig'))