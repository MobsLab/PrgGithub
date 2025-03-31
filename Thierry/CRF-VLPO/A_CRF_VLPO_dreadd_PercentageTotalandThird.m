%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/PFC-VLPO_dread-ex/A_ParcoursComputeSleepStagesPercentageTotalandThird.m

% Ce script permet de tracer 5 figures pour l'expérience PFC-VLPO_dread-ex en
% appelant la fonction ComputeSleepStagesPercentageTotalandThird
% L'expériencePFC-VLPO_dread-ex comprend 4 conditions : Baseline 1, Saline,
% Baseline 2 et CNO
% Et elle a été réalisée pour 3 souris : M1035, M1036 et M1037

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

Dir{1}=PathForExperiments_TG('CNO-CRFcre_Session1_Baseline2');
Dir{2}=PathForExperiments_TG('CNO-CRFcre_Session1_Saline');
Dir{3}=PathForExperiments_TG('CNO-CRFcre_Session1_Baseline3');
Dir{4}=PathForExperiments_TG('CNO-CRFcre_Session1_CNO');
DirFigure='/media/nas5/Thierry_DATA/Figures/CRF_Cre_VLPO_dreadd/';  % dossier où seront enregistrées les figures .fig

ResREM=[];
ResWake=[];
ResSWS=[];

for i=1:length(Dir) % baseline 2 ou Saline ou Baseline 3 ou CNO
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
xticks([1 2])
xticklabels({'Saline','CNO'})
%PlotErrorBarN_KJ({[ResWake(1,1),ResWake(2,1),ResWake(3,1)] [ResWake(4,1),ResWake(5,1),ResWake(6,1)] [ResWake(7,1),ResWake(8,1),ResWake(9,1)] [ResWake(10,1),ResWake(11,1),ResWake(12,1)]},'newfig',0);
PlotErrorBarN_KJ({[ResWake(4,1),ResWake(5,1),ResWake(6,1)] [ResWake(10,1),ResWake(11,1),ResWake(12,1)]},'newfig',0);
% ResWake(1,1)=Eveil Total Baseline1 M1035 // ResWake(2,1)=Eveil Total Baseline1 M1036 // ResWake(3,1) = Eveil Total Baseline1 M1037
% ResWake(3,1)=Eveil Total Saline M1035 // ResWake(5,1)=Eveil Total Saline M1036 // ResWake(6,1) = Eveil Total Saline M1037
% ResWake(7,1)=Eveil Total Baseline2 M1035 // ResWake(8,1)=Eveil Total Baseline2 M1035 // ResWake(9,1) = Eveil Total Baseline2 M1037
% ResWake(10,1)=Eveil Total CNO M1035 // ResWake(11,1)=Eveil Total CNO M1036 // ResWake(12,1) = Eveil Total CNO M1037
hold on, plot([1.1,2.1],[ResWake(4,1),ResWake(10,1)],'b-o') %M1035
hold on, plot([1.1,2.1],[ResWake(5,1),ResWake(11,1)],'r-o') %M1036
hold on, plot([1.1,2.1],[ResWake(6,1),ResWake(12,1)],'g-o') %M1037

% SWS
subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total')
xticks([1 2])
xticklabels({'Saline','CNO'})
PlotErrorBarN_KJ({[ResSWS(4,1),ResSWS(5,1),ResSWS(6,1)] [ResSWS(10,1),ResSWS(11,1),ResSWS(12,1)]},'newfig',0);
% ResSWS(1,1)=SWS Total Baseline1 M1035 // ResSWS(2,1)=SWS Total Baseline1 M1036 // ResSWS(3,1) = SWS Total Baseline1 M1037
% ResSWS(3,1)=SWS Total Saline M1035 // ResSWS(5,1)=SWS Total Saline M1036 // ResSWS(6,1) = SWS Total Saline M1037
% ResSWS(7,1)=SWS Total Baseline2 M1035 // ResSWS(8,1)=SWS Total Baseline2 M1035 // ResSWS(9,1) = SWS Total Baseline2 M1037
% ResSWS(10,1)=SWS Total CNO M1035 // ResSWS(11,1)=SWS Total CNO M1036 // ResSWS(12,1) = SWS Total CNO M1037
hold on, plot([1.1,2.1],[ResSWS(4,1),ResSWS(10,1)],'b-o') %M1035
hold on, plot([1.1,2.1],[ResSWS(5,1),ResSWS(11,1)],'r-o') %M1036
hold on, plot([1.1,2.1],[ResSWS(6,1),ResSWS(12,1)],'g-o') %M1037

%REM
subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total')
xticks([1 2])
xticklabels({'Saline','CNO'})
PlotErrorBarN_KJ({[ResREM(4,1),ResREM(5,1),ResREM(6,1)] [ResREM(10,1),ResREM(11,1),ResREM(12,1)]},'newfig',0);
% ResREM(1,1)=REM Total Baseline1 M1035 // ResREM(2,1)=REM Total Baseline1 M1036 // ResREM(3,1) = REM Total Baseline1 M1037
% ResREM(3,1)=REM Total Saline M1035 // ResREM(5,1)=REM Total Saline M1036 // ResREM(6,1) = REM Total Saline M1037
% ResREM(7,1)=REM Total Baseline2 M1035 // ResREM(8,1)=REM Total Baseline2 M1035 // ResREM(9,1) = REM Total Baseline2 M1037
% ResREM(10,1)=REM Total CNO M1035 // ResREM(11,1)=REM Total CNO M1036 // ResREM(12,1) = REM Total CNO M1037
hold on, plot([1.1,2.1],[ResREM(4,1),ResREM(10,1)],'b-o') %M1035
hold on, plot([1.1,2.1],[ResREM(5,1),ResREM(11,1)],'r-o') %M1036
hold on, plot([1.1,2.1],[ResREM(6,1),ResREM(12,1)],'g-o') %M1037


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
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({NbWake(1,:) NbWake(2,:) NbWake(3,:) NbWake(4,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1,4.1],[NbWake(1,1) NbWake(2,1) NbWake(3,1) NbWake(4,1)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[NbWake(1,2) NbWake(2,2) NbWake(3,2) NbWake(4,2)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[NbWake(1,3) NbWake(2,3) NbWake(3,3) NbWake(4,3)],'g-o') %M1037

%* REM
subplot(1,3,2);
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of NREM bouts')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({NbNREM(1,:) NbNREM(2,:) NbNREM(3,:) NbNREM(4,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1,4.1],[NbNREM(1,1) NbNREM(2,1) NbNREM(3,1) NbNREM(4,1)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[NbNREM(1,2) NbNREM(2,2) NbNREM(3,2) NbNREM(4,2)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[NbNREM(1,3) NbNREM(2,3) NbNREM(3,3) NbNREM(4,3)],'g-o') %M1037

%* NREM
subplot(1,3,3);
ylabel('Number of bouts')
xlabel('Conditions')
title('Mean number of REM bouts')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({NbREM(1,:) NbREM(2,:) NbREM(3,:) NbREM(4,:)},'newfig',0);
hold on, plot([1.1,2.1,3.1,4.1],[NbREM(1,1) NbREM(2,1) NbREM(3,1) NbREM(4,1)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[NbREM(1,2) NbREM(2,2) NbREM(3,2) NbREM(4,2)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[NbREM(1,3) NbREM(2,3) NbREM(3,3) NbREM(4,3)],'g-o') %M1037

cd(DirFigure);
savefig(fullfile('Number of bouts of states during the wole experiments.fig'));

%% Section 4 : tracé des histogrammes des pourcentage d'éveil au cours des trois tiers de l'expérience

figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,70]);
title('Percentage of Wake for the first third')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResWake(1,2),ResWake(2,2),ResWake(3,2)] [ResWake(4,2),ResWake(5,2),ResWake(6,2)] [ResWake(7,2),ResWake(8,2),ResWake(9,2)] [ResWake(10,2),ResWake(11,2),ResWake(12,2)]},'newfig',0);
% ResWake(1,2)=Eveil 1st Third Baseline1 M1035 // ResWake(2,2)=Eveil 1st Third Baseline1 M1036 // ResWake(3,2) = Eveil 1st Third Baseline1 M1037
% ResWake(3,2)=Eveil 1st Third Saline M1035 // ResWake(5,2)=Eveil 1st Third Saline M1036 // ResWake(6,2) = Eveil 1st Third Saline M1037
% ResWake(7,2)=Eveil 1st Third Baseline2 M1035 // ResWake(8,2)=Eveil 1st Third Baseline2 M1035 // ResWake(9,2) = Eveil 1st Third Baseline2 M1037
% ResWake(10,2)=Eveil 1st Third CNO M1035 // ResWake(11,2)=Eveil 1st Third CNO M1036 // ResWake(12,2) = Eveil 1st Third CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(1,2),ResWake(4,2),ResWake(7,2),ResWake(10,2)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(2,2),ResWake(5,2),ResWake(8,2),ResWake(11,2)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(3,2),ResWake(6,2),ResWake(9,2),ResWake(12,2)],'g-o') %M1037

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,70]);
title('Percentage of Wake for the second third')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResWake(1,3),ResWake(2,3),ResWake(3,3)] [ResWake(4,3),ResWake(5,3),ResWake(6,3)] [ResWake(7,3),ResWake(8,3),ResWake(9,3)] [ResWake(10,3),ResWake(11,3),ResWake(12,3)]},'newfig',0);
% ResWake(1,3)=Eveil 2nd third Baseline1 M1035 // ResWake(2,3)=Eveil 2nd Third Baseline1 M1036 // ResWake(3,3) = Eveil 2nd Third Baseline1 M1037
% ResWake(3,3)=Eveil 2nd Third Saline M1035 // ResWake(5,3)=Eveil 2nd Third Saline M1036 // ResWake(6,3) = Eveil 2nd Third Saline M1037
% ResWake(7,3)=Eveil 2nd Third Baseline2 M1035 // ResWake(8,3)=Eveil 2nd Third Baseline2 M1035 // ResWake(9,3) = Eveil 2nd Third Baseline2 M1037
% ResWake(10,3)=Eveil 2nd Third CNO M1035 // ResWake(11,3)=Eveil 2nd Third CNO M1036 // ResWake(12,3) = Eveil 2nd Third CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(1,3),ResWake(4,3),ResWake(7,3),ResWake(10,3)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(2,3),ResWake(5,3),ResWake(8,3),ResWake(11,3)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(3,3),ResWake(6,3),ResWake(9,3),ResWake(12,3)],'g-o') %M1037

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,70]);
title('Percentage of Wake for the last third')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResWake(1,4),ResWake(2,4),ResWake(3,4)] [ResWake(4,4),ResWake(5,4),ResWake(6,4)] [ResWake(7,4),ResWake(8,4),ResWake(9,4)] [ResWake(10,4),ResWake(11,4),ResWake(12,4)]},'newfig',0);
% ResWake(1,4)=Eveil 3rd third Baseline1 M1035 // ResWake(2,4)=Eveil 3rd Third Baseline1 M1036 // ResWake(3,4) = Eveil 3rd Third Baseline1 M1037
% ResWake(3,4)=Eveil 3rd Third Saline M1035 // ResWake(5,4)=Eveil 3rd Third Saline M1036 // ResWake(6,4) = Eveil 3rd Third Saline M1037
% ResWake(7,4)=Eveil 3rd Third Baseline2 M1035 // ResWake(8,4)=Eveil 3rd Third Baseline2 M1035 // ResWake(9,4) = Eveil 3rd Third Baseline2 M1037
% ResWake(10,4)=Eveil 3rd Third CNO M1035 // ResWake(11,4)=Eveil 3rd Third CNO M1036 // ResWake(12,4) = Eveil 3rd Third CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(1,4),ResWake(4,4),ResWake(7,4),ResWake(10,4)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(2,4),ResWake(5,4),ResWake(8,4),ResWake(11,4)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(3,4),ResWake(6,4),ResWake(9,4),ResWake(12,4)],'g-o') %M1037

cd (DirFigure)
savefig(fullfile('% of Wake over Total for the 3 thirds.fig'))

%% Section 5 : tracé des histogrammes des pourcentage de NREM au cours des trois tiers de l'expérience

figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,80]);
title('Percentage of NREM for the first third')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResSWS(1,2),ResSWS(2,2),ResSWS(3,2)] [ResSWS(4,2),ResSWS(5,2),ResSWS(6,2)] [ResSWS(7,2),ResSWS(8,2),ResSWS(9,2)] [ResSWS(10,2),ResSWS(11,2),ResSWS(12,2)]},'newfig',0);
% ResSWS(1,2)=SWS 1st Third Baseline1 M1035 // ResSWS(2,2)=SWS 1st Third Baseline1 M1036 // ResSWS(3,2) = SWS 1st Third Baseline1 M1037
% ResSWS(3,2)=SWS 1st Third Saline M1035 // ResSWS(5,2)=SWS 1st Third Saline M1036 // ResSWS(6,2) = SWS 1st Third Saline M1037
% ResSWS(7,2)=SWS 1st Third Baseline2 M1035 // ResSWS(8,2)=SWS 1st Third Baseline2 M1035 // ResSWS(9,2) = SWS 1st Third Baseline2 M1037
% ResSWS(10,2)=SWS 1st Third CNO M1035 // ResSWS(11,2)=SWS 1st Third CNO M1036 // ResSWS(12,2) = SWS 1st Third CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(1,2),ResSWS(4,2),ResSWS(7,2),ResSWS(10,2)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(2,2),ResSWS(5,2),ResSWS(8,2),ResSWS(11,2)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(3,2),ResSWS(6,2),ResSWS(9,2),ResSWS(12,2)],'g-o') %M1037

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,80]);
title('Percentage of NREM for the second third')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResSWS(1,3),ResSWS(2,3),ResSWS(3,3)] [ResSWS(4,3),ResSWS(5,3),ResSWS(6,3)] [ResSWS(7,3),ResSWS(8,3),ResSWS(9,3)] [ResSWS(10,3),ResSWS(11,3),ResSWS(12,3)]},'newfig',0);
% ResSWS(1,3)=SWS 2nd Third Baseline1 M1035 // ResSWS(2,3)=SWS 2nd Third Baseline1 M1036 // ResSWS(3,3) = SWS 2nd Third Baseline1 M1037
% ResSWS(3,3)=SWS 2nd Third Saline M1035 // ResSWS(5,3)=SWS 2nd Third Saline M1036 // ResSWS(6,3) = SWS 2nd Third Saline M1037
% ResSWS(7,3)=SWS 2nd Third Baseline2 M1035 // ResSWS(8,3)=SWS 2nd Third Baseline2 M1035 // ResSWS(9,3) = SWS 2nd Third Baseline2 M1037
% ResSWS(10,3)=SWS 2nd Third CNO M1035 // ResSWS(11,3)=SWS 2nd Third CNO M1036 // ResSWS(12,3) = SWS 2nd Third CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(1,3),ResSWS(4,3),ResSWS(7,3),ResSWS(10,3)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(2,3),ResSWS(5,3),ResSWS(8,3),ResSWS(11,3)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(3,3),ResSWS(6,3),ResSWS(9,3),ResSWS(12,3)],'g-o') %M1037

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,80]);
title('Percentage of NREM for the last third')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResSWS(1,4),ResSWS(2,4),ResSWS(3,4)] [ResSWS(4,4),ResSWS(5,4),ResSWS(6,4)] [ResSWS(7,4),ResSWS(8,4),ResSWS(9,4)] [ResSWS(10,4),ResSWS(11,4),ResSWS(12,4)]},'newfig',0);
% ResSWS(1,4)=SWS 3rd Third Baseline1 M1035 // ResSWS(2,4)=SWS 3rd Third Baseline1 M1036 // ResSWS(3,4) = SWS 3rd Third Baseline1 M1037
% ResSWS(3,4)=SWS 3rd Third Saline M1035 // ResSWS(5,4)=SWS 3rd Third Saline M1036 // ResSWS(6,4) = SWS 3rd Third Saline M1037
% ResSWS(7,4)=SWS 3rd Third Baseline2 M1035 // ResSWS(8,4)=SWS 3rd Third Baseline2 M1035 // ResSWS(9,4) = SWS 3rd Third Baseline2 M1037
% ResSWS(10,4)=SWS 3rd Third CNO M1035 // ResSWS(11,4)=SWS 3rd Third CNO M1036 // ResSWS(12,4) = SWS 3rd Third CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(1,4),ResSWS(4,4),ResSWS(7,4),ResSWS(10,4)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(2,4),ResSWS(5,4),ResSWS(8,4),ResSWS(11,4)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(3,4),ResSWS(6,4),ResSWS(9,4),ResSWS(12,4)],'g-o') %M1037

cd (DirFigure)
savefig(fullfile('% of NREM over Total for the 3 thirds.fig'))

%% Section 6 : tracé des histogrammes des pourcentage de REM au cours des trois tiers de l'expérience

figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,13]);
title('Percentage of REM for the first third')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResREM(1,2),ResREM(2,2),ResREM(3,2)] [ResREM(4,2),ResREM(5,2),ResREM(6,2)] [ResREM(7,2),ResREM(8,2),ResREM(9,2)] [ResREM(10,2),ResREM(11,2),ResREM(12,2)]},'newfig',0);
% ResREM(1,2)=REM 1st Thist Baseline1 M1035 // ResREM(2,2)=REM 1st Thist Baseline1 M1036 // ResREM(3,2) = REM 1st Thist Baseline1 M1037
% ResREM(3,2)=REM 1st Thist Saline M1035 // ResREM(5,2)=REM 1st Thist Saline M1036 // ResREM(6,2) = REM 1st Thist Saline M1037
% ResREM(7,2)=REM 1st Thist Baseline2 M1035 // ResREM(8,2)=REM 1st Thist Baseline2 M1035 // ResREM(9,2) = REM 1st Thist Baseline2 M1037
% ResREM(10,2)=REM 1st Thist CNO M1035 // ResREM(11,2)=REM 1st Thist CNO M1036 // ResREM(12,2) = REM 1st Thist CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(1,2),ResREM(4,2),ResREM(7,2),ResREM(10,2)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(2,2),ResREM(5,2),ResREM(8,2),ResREM(11,2)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(3,2),ResREM(6,2),ResREM(9,2),ResREM(12,2)],'g-o') %M1037

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,13]);
title('Percentage of REM for the second third')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResREM(1,3),ResREM(2,3),ResREM(3,3)] [ResREM(4,3),ResREM(5,3),ResREM(6,3)] [ResREM(7,3),ResREM(8,3),ResREM(9,3)] [ResREM(10,3),ResREM(11,3),ResREM(12,3)]},'newfig',0);
% ResREM(1,3)=REM 2nd Third Baseline1 M1035 // ResREM(2,3)=REM 2nd Third Baseline1 M1036 // ResREM(3,3) = REM 2nd Third Baseline1 M1037
% ResREM(3,3)=REM 2nd Third Saline M1035 // ResREM(5,3)=REM 2nd Third Saline M1036 // ResREM(6,3) = REM 2nd Third Saline M1037
% ResREM(7,3)=REM 2nd Third Baseline2 M1035 // ResREM(8,3)=REM 2nd Third Baseline2 M1035 // ResREM(9,3) = REM 2nd Third Baseline2 M1037
% ResREM(10,3)=REM 2nd Third CNO M1035 // ResREM(11,3)=REM 2nd Third CNO M1036 // ResREM(12,3) = REM 2nd Third CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(1,3),ResREM(4,3),ResREM(7,3),ResREM(10,3)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(2,3),ResREM(5,3),ResREM(8,3),ResREM(11,3)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(3,3),ResREM(6,3),ResREM(9,3),ResREM(12,3)],'g-o') %M1037

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,13]);
title('Percentage of REM for the last third')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResREM(1,4),ResREM(2,4),ResREM(3,4)] [ResREM(4,4),ResREM(5,4),ResREM(6,4)] [ResREM(7,4),ResREM(8,4),ResREM(9,4)] [ResREM(10,4),ResREM(11,4),ResREM(12,4)]},'newfig',0);
% ResREM(1,4)=REM last Third Baseline1 M1035 // ResREM(2,4)=REM last Third Baseline1 M1036 // ResREM(3,4) = REM last Third Baseline1 M1037
% ResREM(3,4)=REM last Third Saline M1035 // ResREM(5,4)=REM last Third Saline M1036 // ResREM(6,4) = REM last Third Saline M1037
% ResREM(7,4)=REM last Third Baseline2 M1035 // ResREM(8,4)=REM last Third Baseline2 M1035 // ResREM(9,4) = REM last Third Baseline2 M1037
% ResREM(10,4)=REM last Third CNO M1035 // ResREM(11,4)=REM last Third CNO M1036 // ResREM(12,4) = REM last Third CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(1,4),ResREM(4,4),ResREM(7,4),ResREM(10,4)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(2,4),ResREM(5,4),ResREM(8,4),ResREM(11,4)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(3,4),ResREM(6,4),ResREM(9,4),ResREM(12,4)],'g-o') %M1037

cd (DirFigure)
savefig(fullfile('% of REM over Total for the 3 thirds.fig'))

%% Section 7 : tracé des histogrammes des pourcentage de Wake au cours des trois premières heures de l'expérience

figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,100]);
title('Percentage of Wake for the first hour')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResWake(1,5),ResWake(2,5),ResWake(3,5)] [ResWake(4,5),ResWake(5,5),ResWake(6,5)] [ResWake(7,5),ResWake(8,5),ResWake(9,5)] [ResWake(10,5),ResWake(11,5),ResWake(12,5)]},'newfig',0);
% ResWake(1,5)=Wake 1st hour Baseline1 M1035 // ResWake(2,5)=Wake 1st hour Baseline1 M1036 // ResWake(3,5) = Wake 1st hour Baseline1 M1037
% ResWake(3,5)=Wake 1st hour Saline M1035 // ResWake(5,5)=Wake 1st hour Saline M1036 // ResWake(6,5) = Wake 1st hour Saline M1037
% ResWake(7,5)=Wake 1st hour Baseline2 M1035 // ResWake(8,5)=Wake 1st hour Baseline2 M1035 // ResWake(9,5) = Wake 1st hour Baseline2 M1037
% ResWake(10,5)=Wake 1st hour CNO M1035 // ResWake(11,5)=Wake 1st hour CNO M1036 // ResWake(12,5) = Wake 1st hour CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(1,5),ResWake(4,5),ResWake(7,5),ResWake(10,5)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(2,5),ResWake(5,5),ResWake(8,5),ResWake(11,5)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(3,5),ResWake(6,5),ResWake(9,5),ResWake(12,5)],'g-o') %M1037

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,100]);
title('Percentage of Wake for the second hour')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResWake(1,6),ResWake(2,6),ResWake(3,6)] [ResWake(4,6),ResWake(5,6),ResWake(6,6)] [ResWake(7,6),ResWake(8,6),ResWake(9,6)] [ResWake(10,6),ResWake(11,6),ResWake(12,6)]},'newfig',0);
% ResWake(1,6)=Wake 2nd hour Baseline1 M1035 // ResWake(2,6)=Wake 2nd hour Baseline1 M1036 // ResWake(3,6) = Wake 2nd hour Baseline1 M1037
% ResWake(3,6)=Wake 2nd hour Saline M1035 // ResWake(5,6)=Wake 2nd hour Saline M1036 // ResWake(6,6) = Wake 2nd hour Saline M1037
% ResWake(7,6)=Wake 2nd hour Baseline2 M1035 // ResWake(8,6)=Wake 2nd hour Baseline2 M1035 // ResWake(9,6) = Wake 2nd hour Baseline2 M1037
% ResWake(10,6)=Wake 2nd hour CNO M1035 // ResWake(11,6)=Wake 2nd hour CNO M1036 // ResWake(12,6) = Wake 2nd hour CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(1,6),ResWake(4,6),ResWake(7,6),ResWake(10,6)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(2,6),ResWake(5,6),ResWake(8,6),ResWake(11,6)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(3,6),ResWake(6,6),ResWake(9,6),ResWake(12,6)],'g-o') %M1037

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,100]);
title('Percentage of Wake for the third hour')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResWake(1,7),ResWake(2,7),ResWake(3,7)] [ResWake(4,7),ResWake(5,7),ResWake(6,7)] [ResWake(7,7),ResWake(8,7),ResWake(9,7)] [ResWake(10,7),ResWake(11,7),ResWake(12,7)]},'newfig',0);
% ResWake(1,7)=Wake last hour Baseline1 M1035 // ResWake(2,7)=Wake last hour Baseline1 M1036 // ResWake(3,7) = Wake last hour Baseline1 M1037
% ResWake(3,7)=Wake last hour Saline M1035 // ResWake(5,7)=Wake last hour Saline M1036 // ResWake(6,7) = Wake last hour Saline M1037
% ResWake(7,7)=Wake last hour Baseline2 M1035 // ResWake(8,7)=Wake last hour Baseline2 M1035 // ResWake(9,7) = Wake last hour Baseline2 M1037
% ResWake(10,7)=Wake last hour CNO M1035 // ResWake(11,7)=Wake last hour CNO M1036 // ResWake(12,7) = Wake last hour CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(1,7),ResWake(4,7),ResWake(7,7),ResWake(10,7)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(2,7),ResWake(5,7),ResWake(8,7),ResWake(11,7)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResWake(3,7),ResWake(6,7),ResWake(9,7),ResWake(12,7)],'g-o') %M1037

cd (DirFigure)
savefig(fullfile('% of Wake over Total for the 3 hours.fig'))

%% Section 8 : tracé des histogrammes des pourcentage de SWS au cours des trois premières heures de l'expérience

figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,90]);
title('Percentage of NREM for the first hour')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResSWS(1,5),ResSWS(2,5),ResSWS(3,5)] [ResSWS(4,5),ResSWS(5,5),ResSWS(6,5)] [ResSWS(7,5),ResSWS(8,5),ResSWS(9,5)] [ResSWS(10,5),ResSWS(11,5),ResSWS(12,5)]},'newfig',0);
% ResSWS(1,5)=SWS 1st hour Baseline1 M1035 // ResSWS(2,5)=SWS 1st hour Baseline1 M1036 // ResSWS(3,5) = SWS 1st hour Baseline1 M1037
% ResSWS(3,5)=SWS 1st hour Saline M1035 // ResSWS(5,5)=SWS 1st hour Saline M1036 // ResSWS(6,5) = SWS 1st hour Saline M1037
% ResSWS(7,5)=SWS 1st hour Baseline2 M1035 // ResSWS(8,5)=SWS 1st hour Baseline2 M1035 // ResSWS(9,5) = SWS 1st hour Baseline2 M1037
% ResSWS(10,5)=SWS 1st hour CNO M1035 // ResSWS(11,5)=SWS 1st hour CNO M1036 // ResSWS(12,5) = SWS 1st hour CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(1,5),ResSWS(4,5),ResSWS(7,5),ResSWS(10,5)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(2,5),ResSWS(5,5),ResSWS(8,5),ResSWS(11,5)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(3,5),ResSWS(6,5),ResSWS(9,5),ResSWS(12,5)],'g-o') %M1037

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,90]);
title('Percentage of NREM for the second hour')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResSWS(1,6),ResSWS(2,6),ResSWS(3,6)] [ResSWS(4,6),ResSWS(5,6),ResSWS(6,6)] [ResSWS(7,6),ResSWS(8,6),ResSWS(9,6)] [ResSWS(10,6),ResSWS(11,6),ResSWS(12,6)]},'newfig',0);
% ResSWS(1,6)=SWS 2nd hour Baseline1 M1035 // ResSWS(2,6)=SWS 2nd hour Baseline1 M1036 // ResSWS(3,6) = SWS 2nd hour Baseline1 M1037
% ResSWS(3,6)=SWS 2nd hour Saline M1035 // ResSWS(5,6)=SWS 2nd hour Saline M1036 // ResSWS(6,6) = SWS 2nd hour Saline M1037
% ResSWS(7,6)=SWS 2nd hour Baseline2 M1035 // ResSWS(8,6)=SWS 2nd hour Baseline2 M1035 // ResSWS(9,6) = SWS 2nd hour Baseline2 M1037
% ResSWS(10,6)=SWS 2nd hour CNO M1035 // ResSWS(11,6)=SWS 2nd hour CNO M1036 // ResSWS(12,6) = SWS 2nd hour CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(1,6),ResSWS(4,6),ResSWS(7,6),ResSWS(10,6)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(2,6),ResSWS(5,6),ResSWS(8,6),ResSWS(11,6)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(3,6),ResSWS(6,6),ResSWS(9,6),ResSWS(12,6)],'g-o') %M1037

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,90]);
title('Percentage of NREM for the third hour')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResSWS(1,7),ResSWS(2,7),ResSWS(3,7)] [ResSWS(4,7),ResSWS(5,7),ResSWS(6,7)] [ResSWS(7,7),ResSWS(8,7),ResSWS(9,7)] [ResSWS(10,7),ResSWS(11,7),ResSWS(12,7)]},'newfig',0);
% ResSWS(1,7)=SWS last hour Baseline1 M1035 // ResSWS(2,7)=SWS last hour Baseline1 M1036 // ResSWS(3,7) = SWS last hour Baseline1 M1037
% ResSWS(3,7)=SWS last hour Saline M1035 // ResSWS(5,7)=SWS last hour Saline M1036 // ResSWS(6,7) = SWS last hour Saline M1037
% ResSWS(7,7)=SWS last hour Baseline2 M1035 // ResSWS(8,7)=SWS last hour Baseline2 M1035 // ResSWS(9,7) = SWS last hour Baseline2 M1037
% ResSWS(10,7)=SWS last hour CNO M1035 // ResSWS(11,7)=SWS last hour CNO M1036 // ResSWS(12,7) = SWS last hour CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(1,7),ResSWS(4,7),ResSWS(7,7),ResSWS(10,7)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(2,7),ResSWS(5,7),ResSWS(8,7),ResSWS(11,7)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResSWS(3,7),ResSWS(6,7),ResSWS(9,7),ResSWS(12,7)],'g-o') %M1037

cd (DirFigure)
savefig(fullfile('% of SWS over Total for the 3 hours.fig'))

%% Section 9 : tracé des histogrammes des pourcentage de REM au cours des trois premières heures de l'expérience

figure
subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,14]);
title('Percentage of REM for the first hour')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResREM(1,5),ResREM(2,5),ResREM(3,5)] [ResREM(4,5),ResREM(5,5),ResREM(6,5)] [ResREM(7,5),ResREM(8,5),ResREM(9,5)] [ResREM(10,5),ResREM(11,5),ResREM(12,5)]},'newfig',0);
% ResREM(1,5)=REM 1st hour Baseline1 M1035 // ResREM(2,5)=REM 1st hour Baseline1 M1036 // ResREM(3,5) = REM 1st hour Baseline1 M1037
% ResREM(3,5)=REM 1st hour Saline M1035 // ResREM(5,5)=REM 1st hour Saline M1036 // ResREM(6,5) = REM 1st hour Saline M1037
% ResREM(7,5)=REM 1st hour Baseline2 M1035 // ResREM(8,5)=REM 1st hour Baseline2 M1035 // ResREM(9,5) = REM 1st hour Baseline2 M1037
% ResREM(10,5)=REM 1st hour CNO M1035 // ResREM(11,5)=REM 1st hour CNO M1036 // ResREM(12,5) = REM 1st hour CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(1,5),ResREM(4,5),ResREM(7,5),ResREM(10,5)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(2,5),ResREM(5,5),ResREM(8,5),ResREM(11,5)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(3,5),ResREM(6,5),ResREM(9,5),ResREM(12,5)],'g-o') %M1037

subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,14]);
title('Percentage of REM for the second hour')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResREM(1,6),ResREM(2,6),ResREM(3,6)] [ResREM(4,6),ResREM(5,6),ResREM(6,6)] [ResREM(7,6),ResREM(8,6),ResREM(9,6)] [ResREM(10,6),ResREM(11,6),ResREM(12,6)]},'newfig',0);
% ResREM(1,6)=REM 2nd hour Baseline1 M1035 // ResREM(2,6)=REM 2nd hour Baseline1 M1036 // ResREM(3,6) = REM 2nd hour Baseline1 M1037
% ResREM(3,6)=REM 2nd hour Saline M1035 // ResREM(5,6)=REM 2nd hour Saline M1036 // ResREM(6,6) = REM 2nd hour Saline M1037
% ResREM(7,6)=REM 2nd hour Baseline2 M1035 // ResREM(8,6)=REM 2nd hour Baseline2 M1035 // ResREM(9,6) = REM 2nd hour Baseline2 M1037
% ResREM(10,6)=REM 2nd hour CNO M1035 // ResREM(11,6)=REM 2nd hour CNO M1036 // ResREM(12,6) = REM 2nd hour CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(1,6),ResREM(4,6),ResREM(7,6),ResREM(10,6)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(2,6),ResREM(5,6),ResREM(8,6),ResREM(11,6)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(3,6),ResREM(6,6),ResREM(9,6),ResREM(12,6)],'g-o') %M1037

subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
ylim([0,14]);
title('Percentage of REM for the third hour')
xticks([1 2 3 4])
xticklabels({'Baseline 1','Saline','Baseline 2','CNO'})
PlotErrorBarN_KJ({[ResREM(1,7),ResREM(2,7),ResREM(3,7)] [ResREM(4,7),ResREM(5,7),ResREM(6,7)] [ResREM(7,7),ResREM(8,7),ResREM(9,7)] [ResREM(10,7),ResREM(11,7),ResREM(12,7)]},'newfig',0);
% ResREM(1,7)=REM last hour Baseline1 M1035 // ResREM(2,7)=REM last hour Baseline1 M1036 // ResREM(3,7) = REM last hour Baseline1 M1037
% ResREM(3,7)=REM last hour Saline M1035 // ResREM(5,7)=REM last hour Saline M1036 // ResREM(6,7) = REM last hour Saline M1037
% ResREM(7,7)=REM last hour Baseline2 M1035 // ResREM(8,7)=REM last hour Baseline2 M1035 // ResREM(9,7) = REM last hour Baseline2 M1037
% ResREM(10,7)=REM last hour CNO M1035 // ResREM(11,7)=REM last hour CNO M1036 // ResREM(12,7) = REM last hour CNO M1037
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(1,7),ResREM(4,7),ResREM(7,7),ResREM(10,7)],'b-o') %M1035
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(2,7),ResREM(5,7),ResREM(8,7),ResREM(11,7)],'r-o') %M1036
hold on, plot([1.1,2.1,3.1,4.1],[ResREM(3,7),ResREM(6,7),ResREM(9,7),ResREM(12,7)],'g-o') %M1037

cd (DirFigure)
savefig(fullfile('% of REM over Total for the 3 hours.fig'))
