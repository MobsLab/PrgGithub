%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/PFC-VLPO_dread-ex/B_ParcoursComputeSleepStages_Overtime.m

% Ce script permet de tracer 4 figures pour l'expérience PFC-VLPO_dread-ex en
% appelant la fonction DensitySleepStage
% L'expérience PFC-VLPO_dread-ex comprend 4 conditions : Baseline 1, Saline,
% Baseline 2 et CNO
% Et elle a été réalisée pour 3 souris : M1035, M1036 et M1037

% Le sctrip est composé de 4 sections :
%   * Section 1 : chargement des données et calcul des variables d'interêt
%   (% REM, Wake, NREM...) à l'aide de la fonction DensitySleepStage

%   * Section 2 : tracé du pourcentage de REM au cours du temps pour les 4
%   conditions pour chacune des 3 souris

%   * Section 3 : tracé des pourcentages des différents états de vigilence
%   au cours d'un enregistrement

%   * Section 4 : tracé des histogrammes de la durée avant le premier NREM sleep
%   et de celle avant le premier REM sleep


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Chargement et calcul des données

Dir{1}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Baseline1');
Dir{2}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Saline');
Dir{3}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Baseline2');
Dir{4}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_CNO');
DirFigure='/media/nas5/Thierry_DATA/Figures/PFC-VLPO_dreadd-cre/';

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

for i=1:length(Dir{1}.path)
    % Pourcentage REM overtime pour les 3 conditions
    figure, %plot(Range(D_REM_200{1,i},'s'),Data(D_REM_200{1,i}),'b')    % Baseline 1
    hold on, plot(Range(D_REM_200{2,i},'s'),Data(D_REM_200{2,i}),'k')   % Saline
    %hold on, plot(Range(D_REM_200{3,i},'s'),Data(D_REM_200{3,i}),'k')   % Baseline 2
    hold on, plot(Range(D_REM_200{4,i},'s'),Data(D_REM_200{4,i}),'r')   % CNO
    ylabel('%REM')
    xlabel('Time (s)')
    title(strcat('REM Percentage overtime M',num2str(Dir{1}.nMice{i})))
%    legend('Baseline 1','Saline','Baseline 2','CNO')
    legend('Saline','CNO')
    cd(DirFigure);
    figname=strcat('REM percentage overtime M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname))
end



%% Section 3 : tracé des pourcentages des différents états de vigilence au cours d'un enregistrement

c=1;     % condition : 1=Baseline1   2=Saline  3=Baseline2  4=CNO
m=1;     % souris : 1=M1035   2=M1036  3=1037
figure, plot(Range(D_Wake_90{c,m},'s'),Data(D_Wake_90{c,m}),'b','linewidth',2)
hold on, plot(Range(D_SWS_90{c,m},'s'),Data(D_SWS_90{c,m}),'r','linewidth',2)
hold on, plot(Range(D_REM_90{c,m},'s'),Data(D_REM_90{c,m}),'g','linewidth',2)
ylabel('Percentage (%)')
xlabel('Time (s)')
title('Percentage of states over time M1035 Baseline 1')
legend('Wake','NREM','REM')

cd(DirFigure);
savefig(fullfile('Percentage of the 3 state for 1 recording Baseline 1 M923.fig'))

%% Section 4 : tracé des histogrammes de la durée avant le premier NREM sleep et de celle avant le premier REM sleep

figure
subplot(1,2,1); %create and get handle to the subplot axes
ylabel('Time(s)')
xlabel('Conditions')
title('Duration before the first NREM')     %Lasting at least 300 seconds
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({tpsFirstSleep(1,:) tpsFirstSleep(2,:) tpsFirstSleep(3,:) tpsFirstSleep(4,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1,4.1],[tpsFirstSleep(1,1),tpsFirstSleep(2,1),tpsFirstSleep(3,1) tpsFirstSleep(4,1)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[tpsFirstSleep(1,2),tpsFirstSleep(2,2),tpsFirstSleep(3,2) tpsFirstSleep(4,2)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[tpsFirstSleep(1,3),tpsFirstSleep(2,3),tpsFirstSleep(3,3) tpsFirstSleep(4,3)],'g-o') %M1036

subplot(1,2,2); %create and get handle to the subplot axes
ylabel('Time (s)')
xlabel('Conditions')
title('Duration before the first REM')     %Lasting at least 15 seconds
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({tpsFirstREM(1,:) tpsFirstREM(2,:) tpsFirstREM(3,:) tpsFirstREM(4,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1,4.1],[tpsFirstREM(1,1),tpsFirstREM(2,1),tpsFirstREM(3,1) tpsFirstREM(4,1)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[tpsFirstREM(1,2),tpsFirstREM(2,2),tpsFirstREM(3,2) tpsFirstREM(4,2)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[tpsFirstREM(1,3),tpsFirstREM(2,3),tpsFirstREM(3,3) tpsFirstREM(4,3)],'g-o') %M1037

cd(DirFigure);
savefig(fullfile('Duration before first REM and NREM sleep.fig'))
