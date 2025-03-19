%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ParcoursComputeSleepStages_Overtime

% Ce script permet de tracer 3 figures pour l'expérience Box Rat 72h en
% appelant la fonction DensitySleepStage
% L'expérience Box Rat 72h comprend 3 conditions : Baseline 1, Eposure et
% Baseline 2
% Et elle a été réalisée pour 2 souris : M923 et M926

% Le sctrip est composé de 4 sections :
%   * Section 1 : chargement des données et calcul des variables d'interêt
%   (% REM, Wake, NREM...) à l'aide de la fonction DensitySleepStage

%   * Section 2 : tracé du pourcentage de REM au cours du temps pour les 3
%   conditions

%   * Section 3 : tracé des pourcentages des différents états de vigilence
%   au cours d'un enregistrement

%   * Section 4 : tracé des histogrammes de la durée avant le premier NREM sleep
%   et de celle avant le premier REM sleep


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Chargement et calcul des données

Dir{1}=PathForExperiments_TG('box_rat_72h_Baseline1');
Dir{2}=PathForExperiments_TG('box_rat_72h_Exposure');
Dir{3}=PathForExperiments_TG('box_rat_72h_Baseline2');
DirFigure='/media/nas5/Thierry_DATA/Rat_box_72h/Figures/'

for i=1:length(Dir) % baseline 1 ou baseline 2 ou exp
    for j=1:length(Dir{i}.path)        
        cd(Dir{i}.path{j}{1});
        load SleepScoring_OBGamma Wake REMEpoch SWSEpoch
%         load SleepScoring_Accelero Wake REMEpoch SWSEpoch
        [D_REM_200{i,j},tpsFirstSleep(i,j),tpsFirstREM(i,j)]=DensitySleepStage(Wake,SWSEpoch,REMEpoch,'rem',200);
        D_SWS_90{i,j}=DensitySleepStage(Wake,SWSEpoch,REMEpoch,'sws',90);
        D_REM_90{i,j}=DensitySleepStage(Wake,SWSEpoch,REMEpoch,'rem',90);
        D_Wake_90{i,j}=DensitySleepStage(Wake,SWSEpoch,REMEpoch,'Wake',90);
        clear Wake REMEpoch SWSEpoch
    end       
end

%% Section 2 : tracé du pourcentage de REM au cours du temps pour les 3 conditions

% Pourcentage REM overtime pour les 3 conditions M923
figure, plot(Range(D_REM_200{1,1},'s'),Data(D_REM_200{1,1}),'b')
hold on, plot(Range(D_REM_200{2,1},'s'),Data(D_REM_200{2,1}),'r')
hold on, plot(Range(D_REM_200{3,1},'s'),Data(D_REM_200{3,1}),'k')
ylabel('%REM')
xlabel('Time (s)')
title('Percentage REM over time M923')
legend('Baseline 1','Exposure','Baseline 2')

% Pourcentage REM overtime pour les 3 conditions M926
figure, plot(Range(D_REM_200{1,2},'s'),Data(D_REM_200{1,2}),'b')
hold on, plot(Range(D_REM_200{2,2},'s'),Data(D_REM_200{2,2}),'r')
hold on, plot(Range(D_REM_200{3,2},'s'),Data(D_REM_200{3,2}),'k')
ylabel('%REM')
xlabel('Time (s)')
title('Percentage REM over time M926')
legend('Baseline 1','Exposure','Baseline 2')

cd(DirFigure);
savefig(fullfile('Percentage of REM over time.fig'))

%% Section 3 : tracé des pourcentages des différents états de vigilence au cours d'un enregistrement

c=1;     % condition : 1=Baseline1   2=Exposure  3=Baseline2
m=1;     % souris : 1=M923   2=M926
figure, plot(Range(D_Wake_90{c,m},'s'),Data(D_Wake_90{c,m}),'b')
hold on, plot(Range(D_SWS_90{c,m},'s'),Data(D_SWS_90{c,m}),'r')
hold on, plot(Range(D_REM_90{c,m},'s'),Data(D_REM_90{c,m}),'g')
ylabel('Percentage (%)')
xlabel('Time (s)')
title('Percentage of states over time M923 Baseline 1')
legend('Wake','NREM','REM')

cd(DirFigure);
savefig(fullfile('Percentage of the 3 state for 1 recording Baseline 1 M923.fig'))

%% Section 4 : tracé des histogrammes de la durée avant le premier NREM sleep et de celle avant le premier REM sleep

figure
subplot(1,2,1); %create and get handle to the subplot axes
ylabel('Time(s)')
xlabel('Conditions')
title('Duration before the first NREM')     %Lasting at least 300 seconds
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({tpsFirstSleep(1,:) tpsFirstSleep(2,:) tpsFirstSleep(3,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1],[tpsFirstSleep(1,1),tpsFirstSleep(2,1),tpsFirstSleep(3,1)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[tpsFirstSleep(1,2),tpsFirstSleep(2,2),tpsFirstSleep(3,2)],'r-o') %M926

subplot(1,2,2); %create and get handle to the subplot axes
ylabel('Time (s)')
xlabel('Conditions')
title('Duration before the first REM')     %Lasting at least 15 seconds
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({tpsFirstREM(1,:) tpsFirstREM(2,:) tpsFirstREM(3,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1],[tpsFirstREM(1,1),tpsFirstREM(2,1),tpsFirstREM(3,1)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[tpsFirstREM(1,2),tpsFirstREM(2,2),tpsFirstREM(3,2)],'r-o') %M926

cd(DirFigure);
savefig(fullfile('Duration before first REM and NREM sleep.fig'))
