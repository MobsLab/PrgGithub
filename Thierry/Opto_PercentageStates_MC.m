Dir{1}=PathForExperiments_MC('Baseline_OptoSleep');
Dir{2}=PathForExperiments_MC('Stim_OptoSleep');
Dir{3}=PathForExperiments_MC('Baseline2_OptoSleep');
Dir{4}=PathForExperiments_MC('Stim2_OptoSleep');
% DirFigure='/media/nas5/Thierry_DATA/Figures/PFC-VLPO_dreadd-cre/';  % dossier où seront enregistrées les figures .fig

ResREM=[];
ResWake=[];
ResSWS=[];

for i=1:length(Dir) % baseline 1 ou Saline ou Baseline 2 ou CNO
    for j=1:length(Dir{i}.path)        
        cd(Dir{i}.path{j}{1});
        load SleepScoring_OBGamma Wake REMEpoch SWSEpoch        % choix du sleep scoring
%       load SleepScoring_Accelero Wake REMEpoch SWSEpoch     % choix du sleep scoring
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
xticklabels({'Baseline','OptoStim'})
% PlotErrorBarN_KJ({[ResWake(1,1),ResWake(2,1),ResWake(3,1)] [ResWake(4,1),ResWake(5,1),ResWake(6,1)] [ResWake(7,1),ResWake(8,1),ResWake(9,1)] [ResWake(10,1),ResWake(11,1),ResWake(12,1)]},'newfig',0);
PlotErrorBarN_KJ({[ResWake(1,1),ResWake(2,1),ResWake(3,1),ResWake(4,1),ResWake(5,1)] [ResWake(6,1),ResWake(7,1),ResWake(8,1),ResWake(9,1),ResWake(10,1)]},'newfig',0);
% ResWake(1,1)=Eveil Total Baseline1 M1035 // ResWake(2,1)=Eveil Total Baseline1 M1036 // ResWake(3,1) = Eveil Total Baseline1 M1037
% ResWake(4,1)=Eveil Total Saline M1035 // ResWake(5,1)=Eveil Total Saline M1036 // ResWake(6,1) = Eveil Total Saline M1037
% ResWake(7,1)=Eveil Total Baseline2 M1035 // ResWake(8,1)=Eveil Total Baseline2 M1035 // ResWake(9,1) = Eveil Total Baseline2 M1037
% ResWake(10,1)=Eveil Total CNO M1035 // ResWake(11,1)=Eveil Total CNO M1036 // ResWake(12,1) = Eveil Total CNO M1037
hold on, plot([1.1,2.1],[ResWake(1,1),ResWake(6,1)],'b-o') %M645
hold on, plot([1.1,2.1],[ResWake(2,1),ResWake(7,1)],'r-o') %M648
hold on, plot([1.1,2.1],[ResWake(3,1),ResWake(8,1)],'g-o') %M675
hold on, plot([1.1,2.1],[ResWake(4,1),ResWake(9,1)],'o-o') %M711
hold on, plot([1.1,2.1],[ResWake(5,1),ResWake(10,1)],'p-o') %M733


% SWS
subplot(1,3,2); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total')
xticks([1 2])
xticklabels({'Saline','CNO'})
PlotErrorBarN_KJ({[ResSWS(1,1),ResSWS(2,1),ResSWS(3,1),ResSWS(4,1),ResSWS(5,1)] [ResSWS(6,1),ResSWS(7,1),ResSWS(8,1),ResSWS(9,1),ResSWS(10,1)]},'newfig',0);
% ResSWS(1,1)=SWS Total Baseline1 M1035 // ResSWS(2,1)=SWS Total Baseline1 M1036 // ResSWS(3,1) = SWS Total Baseline1 M1037
% ResSWS(4,1)=SWS Total Saline M1035 // ResSWS(5,1)=SWS Total Saline M1036 // ResSWS(6,1) = SWS Total Saline M1037
% ResSWS(7,1)=SWS Total Baseline2 M1035 // ResSWS(8,1)=SWS Total Baseline2 M1035 // ResSWS(9,1) = SWS Total Baseline2 M1037
% ResSWS(10,1)=SWS Total CNO M1035 // ResSWS(11,1)=SWS Total CNO M1036 // ResSWS(12,1) = SWS Total CNO M1037
hold on, plot([1.1,2.1],[ResSWS(1,1),ResSWS(6,1)],'b-o') %M645
hold on, plot([1.1,2.1],[ResSWS(2,1),ResSWS(7,1)],'r-o') %M648
hold on, plot([1.1,2.1],[ResSWS(3,1),ResSWS(8,1)],'g-o') %M675
hold on, plot([1.1,2.1],[ResSWS(4,1),ResSWS(9,1)],'o-o') %M711
hold on, plot([1.1,2.1],[ResSWS(5,1),ResSWS(10,1)],'p-o') %M733

%REM
subplot(1,3,3); %create and get handle to the subplot axes
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total')
xticks([1 2])
xticklabels({'Saline','CNO'})
PlotErrorBarN_KJ({[ResREM(1,1),ResREM(2,1),ResREM(3,1),ResREM(4,1),ResREM(5,1)] [ResREM(6,1),ResREM(7,1),ResREM(8,1),ResREM(9,1),ResREM(10,1)]},'newfig',0);
% ResREM(1,1)=REM Total Baseline1 M1035 // ResREM(2,1)=REM Total Baseline1 M1036 // ResREM(3,1) = REM Total Baseline1 M1037
% ResREM(4,1)=REM Total Saline M1035 // ResREM(5,1)=REM Total Saline M1036 // ResREM(6,1) = REM Total Saline M1037
% ResREM(7,1)=REM Total Baseline2 M1035 // ResREM(8,1)=REM Total Baseline2 M1035 // ResREM(9,1) = REM Total Baseline2 M1037
% ResREM(10,1)=REM Total CNO M1035 // ResREM(11,1)=REM Total CNO M1036 // ResREM(12,1) = REM Total CNO M1037
hold on, plot([1.1,2.1],[ResREM(1,1),ResREM(6,1)],'b-o') %M645
hold on, plot([1.1,2.1],[ResREM(2,1),ResREM(7,1)],'r-o') %M648
hold on, plot([1.1,2.1],[ResREM(3,1),ResREM(8,1)],'g-o') %M675
hold on, plot([1.1,2.1],[ResREM(4,1),ResREM(9,1)],'o-o') %M711
hold on, plot([1.1,2.1],[ResREM(5,1),ResREM(10,1)],'p-o') %M733


% cd(DirFigure);
% savefig(fullfile('Percentage of states during the wole experiments.fig'));