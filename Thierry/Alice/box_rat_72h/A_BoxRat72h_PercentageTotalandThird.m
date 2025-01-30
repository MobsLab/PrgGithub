%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/box_rat_72h/ParcoursComputeSleepStagesPercentageTotalandThird.m

% Ce script permet de tracer 5 figures pour l'expérience Box Rat 72h en
% appelant la fonction ComputeSleepStagesPercentageTotalandThird
% L'expérience Box Rat 72h comprend 3 conditions : Baseline 1, Eposure et
% Baseline 2
% Et elle a été réalisée pour 2 souris : M923 et M926

% Le sctrip est composé de 6 sections :
%   * Section 1 : chargement des données et calcul des variables d'interêt
%   (% REM, Wake, NREM...) à l'aide de la fonction ComputeSleepStagesPercentageTotalandThird

%   * Section 2 : tracé des histogrammes du pourcentage des 3 états de
%   vigilence selon les conditions

%   * Section 3 : tracé des histogrammes du nombre d'épisode les 3 états de
%   vigilence

%   * Section 4 : tracé des histogrammes des pourcentage d'éveil au cours
%   des trois tiers de l'expérience

%   * Section 5 : tracé des histogrammes des pourcentage de NREM au cours
%   des trois tiers de l'expérience

%   * Section 6 : tracé des histogrammes des pourcentage de REM au cours
%   des trois tiers de l'expérience

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Chargement des données

Dir{1}=PathForExperiments_TG('box_rat_72h_Baseline1');
Dir{2}=PathForExperiments_TG('box_rat_72h_Exposure');
Dir{3}=PathForExperiments_TG('box_rat_72h_Baseline2');
DirFigure='/media/nas5/Thierry_DATA/Figures/Rat_box_72h/Figures/';  % dossier où seront enregistrées les figures .fig

ResREM=[];
ResWake=[];
ResSWS=[];

for i=1:length(Dir) % baseline 1 ou baseline 2 ou exp
    for j=1:length(Dir{i}.path)        
        cd(Dir{i}.path{j}{1});
        load SleepScoring_OBGamma Wake REMEpoch SWSEpoch        % choix du sleep scoring
%         load SleepScoring_Accelero Wake REMEpoch SWSEpoch     % choix du sleep scoring
        Restemp=ComputeSleepStagesPercentageTotalandThird(Wake,SWSEpoch,REMEpoch);        
        ResWake=[ResWake;Restemp(1,:)];
        ResSWS=[ResSWS;Restemp(2,:)];
        ResREM=[ResREM;Restemp(3,:)];
        NbNREM(i,j)=length(length(SWSEpoch));
        NbREM(i,j)=length(length(REMEpoch));
        NbWake(i,j)=length(length((Wake)));
        clear Wake REMEpoch SWSEpoch
    end       
end

%% Section 2 : tracé de la figure du pourcentage des 3 états de vigilence selon les conditions

figure
% Wake
subplot(1,3,1);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of Wake/Total')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResWake(1,1),ResWake(2,1)] [ResWake(3,1),ResWake(4,1)] [ResWake(5,1),ResWake(6,1)]},'newfig',0);
% ResWake(1,1)=Eveil Total Baseline1 M923 // ResWake(2,1)=Eveil Total Baseline1 M926 //
% ResWake(3,1)=Eveil Total Exposure M923 // ResWake(4,1)=Eveil Total Exposure M926 //
% ResWake(5,1)=Eveil Total Baseline2 M923 // ResWake(6,1)=Eveil Total Baseline2 M926 //
hold on, plot([1.1,2.1,3.1],[ResWake(1,1),ResWake(3,1),ResWake(5,1)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResWake(2,1),ResWake(4,1),ResWake(6,1)],'r-o') %M926

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResSWS(1,1),ResSWS(2,1)] [ResSWS(3,1),ResSWS(4,1)] [ResSWS(5,1),ResSWS(6,1)]},'newfig',0);
% ResSWS(1,1)=SWS Total Baseline1 M923 // ResSWS(2,1)=SWS Total Baseline1 M926 //
% ResSWS(3,1)=SWS Total Exposure M923 // ResSWS(4,1)=SWS Total Exposure M926 //
% ResSWS(5,1)=SWS Total Baseline2 M923 // ResSWS(6,1)=SWS Total Baseline2 M926 //
hold on, plot([1.1,2.1,3.1],[ResSWS(1,1),ResSWS(3,1),ResSWS(5,1)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResSWS(2,1),ResSWS(4,1),ResSWS(6,1)],'r-o') %M926

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResREM(1,1),ResREM(2,1)] [ResREM(3,1),ResREM(4,1)] [ResREM(5,1),ResREM(6,1)]},'newfig',0);
% ResREM(1,1)=REM Total Baseline1 M923 // ResREM(2,1)=REM Total Baseline1 M926 //
% ResREM(3,1)=REM Total Exposure M923 // ResREM(4,1)=REM Total Exposure M926 //
% ResREM(5,1)=REM Total Baseline2 M923 // ResREM(6,1)=REM Total Baseline2 M926 //
hold on, plot([1.1,2.1,3.1],[ResREM(1,1),ResREM(3,1),ResREM(5,1)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResREM(2,1),ResREM(4,1),ResREM(6,1)],'r-o') %M926

cd(DirFigure);
savefig(fullfile('Percentage of states during the wole experiments.fig'));


%% Section 3 : Tracé des figures number of different states

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
PlotErrorBarN_KJ({NbWake(1,:) NbWake(2,:) NbWake(3,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1],[NbWake(1,1) NbWake(2,1) NbWake(3,1)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[NbWake(1,2) NbWake(2,2) NbWake(3,2)],'r-o') %M926

%* REM
subplot(1,3,2);
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of NREM bouts')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({NbNREM(1,:) NbNREM(2,:) NbNREM(3,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1],[NbNREM(1,1) NbNREM(2,1) NbNREM(3,1)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[NbNREM(1,2) NbNREM(2,2) NbNREM(3,2)],'r-o') %M926

%* NREM
subplot(1,3,3);
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of REM bouts')
xticks([1 2 3])
xticklabels({'Baseline1','Exposure','Baseline2'})
PlotErrorBarN_KJ({NbREM(1,:) NbREM(2,:) NbREM(3,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1],[NbREM(1,1) NbREM(2,1) NbREM(3,1)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[NbREM(1,2) NbREM(2,2) NbREM(3,2)],'r-o') %M926

cd(DirFigure);
savefig(fullfile('Number of bouts of states during the wole experiments.fig'));

%% Section 4 : tracé des histogrammes des pourcentage d'éveil au cours des trois tiers de l'expérience

figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,50]);
title('Percentage of Wake for the first third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResWake(1,2),ResWake(2,2)] [ResWake(3,2),ResWake(4,2)] [ResWake(5,2),ResWake(6,2)]},'newfig',0);
% ResWake(1,2)=Eveil 1er tiers Baseline1 M923 // ResWake(2,2)=Eveil 1er tiers Baseline1 M926 //
% ResWake(3,2)=Eveil 1er tiers Exposure M923 // ResWake(4,2)=Eveil 1er tiers Exposure M926 //
% ResWake(5,2)=Eveil 1er tiers Baseline2 M923 // ResWake(6,2)=Eveil 1er tiers Baseline2 M926 //
hold on, plot([1.1,2.1,3.1],[ResWake(1,2),ResWake(3,2),ResWake(5,2)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResWake(2,2),ResWake(4,2),ResWake(6,2)],'r-o') %M926

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,50]);
title('Percentage of Wake for the second third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResWake(1,3),ResWake(2,3)] [ResWake(3,3),ResWake(4,3)] [ResWake(5,3),ResWake(6,3)]},'newfig',0);
% ResWake(1,3)=Eveil 2eme tiers Baseline1 M923 // ResWake(2,3)=Eveil 2eme tiers Baseline1 M926 //
% ResWake(3,3)=Eveil 2eme tiers Exposure M923 // ResWake(4,3)=Eveil 2eme tiers Exposure M926 //
% ResWake(5,3)=Eveil 2eme tiers Baseline2 M923 // ResWake(6,3)=Eveil 2eme tiers Baseline2 M926 //
hold on, plot([1.1,2.1,3.1],[ResWake(1,3),ResWake(3,3),ResWake(5,3)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResWake(2,3),ResWake(4,3),ResWake(6,3)],'r-o') %M926

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,50]);
title('Percentage of Wake for the last third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResWake(1,4),ResWake(2,4)] [ResWake(3,4),ResWake(4,4)] [ResWake(5,4),ResWake(6,4)]},'newfig',0);
% ResWake(1,3)=Eveil 3eme tiers Baseline1 M923 // ResWake(2,3)=Eveil 3eme tiers Baseline1 M926 //
% ResWake(3,3)=Eveil 3eme tiers Exposure M923 // ResWake(4,3)=Eveil 3eme tiers Exposure M926 //
% ResWake(5,3)=Eveil 3eme tiers Baseline2 M923 // ResWake(6,3)=Eveil 3eme tiers Baseline2 M926 //
hold on, plot([1.1,2.1,3.1],[ResWake(1,4),ResWake(3,4),ResWake(5,4)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResWake(2,4),ResWake(4,4),ResWake(6,4)],'r-o') %M926

cd (DirFigure)
savefig(fullfile('% of Wake over Total for the 3 thirds.fig'))

%% Section 5 : tracé des histogrammes des pourcentage de NREM au cours des trois tiers de l'expérience

figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,80]);
title('Percentage of NREM for the first third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResSWS(1,2),ResSWS(2,2)] [ResSWS(3,2),ResSWS(4,2)] [ResSWS(5,2),ResSWS(6,2)]},'newfig',0);
hold on, plot([1.1,2.1,3.1],[ResSWS(1,2),ResSWS(3,2),ResSWS(5,2)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResSWS(2,2),ResSWS(4,2),ResSWS(6,2)],'r-o') %M926

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,80]);
title('Percentage of NREM for the second third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResSWS(1,3),ResSWS(2,3)] [ResSWS(3,3),ResSWS(4,3)] [ResSWS(5,3),ResSWS(6,3)]},'newfig',0);
hold on, plot([1.1,2.1,3.1],[ResSWS(1,3),ResSWS(3,3),ResSWS(5,3)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResSWS(2,3),ResSWS(4,3),ResSWS(6,3)],'r-o') %M926

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,80]);
title('Percentage of NREM for the last third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResSWS(1,4),ResSWS(2,4)] [ResSWS(3,4),ResSWS(4,4)] [ResSWS(5,4),ResSWS(6,4)]},'newfig',0);
hold on, plot([1.1,2.1,3.1],[ResSWS(1,4),ResSWS(3,4),ResSWS(5,4)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResSWS(2,4),ResSWS(4,4),ResSWS(6,4)],'r-o') %M926

cd (DirFigure)
savefig(fullfile('% of NREM over Total for the 3 thirds.fig'))

%% Section 6 : tracé des histogrammes des pourcentage de REM au cours des trois tiers de l'expérience

figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,12]);
title('Percentage of REM for the first third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResREM(1,2),ResREM(2,2)] [ResREM(3,2),ResREM(4,2)] [ResREM(5,2),ResREM(6,2)]},'newfig',0);
hold on, plot([1.1,2.1,3.1],[ResREM(1,2),ResREM(3,2),ResREM(5,2)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResREM(2,2),ResREM(4,2),ResREM(6,2)],'r-o') %M926

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,12]);
title('Percentage of REM for the second third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResREM(1,3),ResREM(2,3)] [ResREM(3,3),ResREM(4,3)] [ResREM(5,3),ResREM(6,3)]},'newfig',0);
hold on, plot([1.1,2.1,3.1],[ResREM(1,3),ResREM(3,3),ResREM(5,3)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResREM(2,3),ResREM(4,3),ResREM(6,3)],'r-o') %M926

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,12]);
title('Percentage of REM for the last third')
xticks([1 2 3])
xticklabels({'Baseline 1','Exposure','Baseline 2'})
PlotErrorBarN_KJ({[ResREM(1,4),ResREM(2,4)] [ResREM(3,4),ResREM(4,4)] [ResREM(5,4),ResREM(6,4)]},'newfig',0);
hold on, plot([1.1,2.1,3.1],[ResREM(1,4),ResREM(3,4),ResREM(5,4)],'b-o') %M923
hold on, plot([1.1,2.1,3.1],[ResREM(2,4),ResREM(4,4),ResREM(6,4)],'r-o') %M926

cd (DirFigure)
savefig(fullfile('% of REM over Total for the 3 thirds.fig'))
