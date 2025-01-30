%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/PFC-VLPO_dread-ex/ParcoursComputeDeltaRipples.m

% Ce script permet de tracer 6 figures pour l'expérience PFC-VLPO_dread-ex
% en utilisant les fonctions Deltaperminute et RipplesPerMinute
% L'expérience PFC-VLPO_dread-ex comprend 4 conditions : Baseline 1, Saline,
% Baseline 2 et CNO
% Et elle a été réalisée pour 3 souris : M1035, M1036 et M1037

%Remarque : pour mettre une ligne verticale sur le graphe
%line([8280 8280],ylim,'color','k','linewidth',2)

% Le sctrip est composé de 3 sections :
%   * Section 1 : calcul et chargement des données préalablement calculées
%     par le script SleepStageFigure grâce aux fonctions Deltaperminute et RipplesPerMinute
%   * Section 2 : tracé de l'histogramme de la répartition des ondes delta au
%     cours de l'enregistrement superposé à l'hypnogramme (3 figures, une par souris)
%   * Section 3 : tracé de l'histogramme de la répartition des ondes ripples au
%     cours de l'enregistrement supperposé à l'hypnogramme (3 figures, une par souris)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Chargement des données

Dir{1}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Baseline1');
Dir{2}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Saline');
Dir{3}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_Baseline2');
Dir{4}=PathForExperiments_TG('PFC-VLPO_dreadd-ex_CNO');
DirFigure='/media/nas5/Thierry_DATA/Figures/PFC-VLPO_dreadd-cre/';
a=0;

for i=1:length(Dir) % baseline 1 ou baseline 2 ou Saline ou CNO
    for j=1:length(Dir{i}.path)
        cd(Dir{i}.path{j}{1});
        a=a+1;
        fprintf('Calculting data %d/%d\n',[a,length(Dir)*length(Dir{i}.path)])
        load('DeltaWaves.mat');
        Deltas(i,j)=alldeltas_PFCx;
        Delta_min=Deltaperminute(Deltas(i,j));
        Deltam{i,j}=Delta_min;
        load('Ripples.mat');
        Ripples(i,j)=tRipples;
        Ripples_min=RipplesPerMinute(Ripples(i,j));
        Ripplem{i,j}=Ripples_min;
        load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
        REM{i,j}=REMEpoch;
        wake{i,j}=Wake; 
        SWS{i,j}=SWSEpoch;
    end
end


%% Section 2 : Histogramme Deltas par minute
ax1_Baseline1=linspace(0,length(Deltam{1,1})*60,length(Deltam{1,1}));
ax2_Baseline1=linspace(0,length(Deltam{1,2})*60,length(Deltam{1,2}));
ax3_Baseline1=linspace(0,length(Deltam{1,3})*60,length(Deltam{1,3}));
ax1_Saline=linspace(0,length(Deltam{2,1})*60,length(Deltam{2,1}));
ax2_Saline=linspace(0,length(Deltam{2,2})*60,length(Deltam{2,2}));
ax3_Saline=linspace(0,length(Deltam{2,3})*60,length(Deltam{2,3}));
ax1_Baseline2=linspace(0,length(Deltam{3,1})*60,length(Deltam{3,1}));
ax2_Baseline2=linspace(0,length(Deltam{3,2})*60,length(Deltam{3,2}));
ax3_Baseline2=linspace(0,length(Deltam{3,3})*60,length(Deltam{3,3}));
ax1_CNO=linspace(0,length(Deltam{4,1})*60,length(Deltam{4,1}));
ax2_CNO=linspace(0,length(Deltam{4,2})*60,length(Deltam{4,2}));
ax3_CNO=linspace(0,length(Deltam{4,3})*60,length(Deltam{4,3}));

% M1035
figure
% Baseline 1
subplot(4,1,1),
bar(ax1_Baseline1,Deltam{1,1}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{1,1},SWS{1,1},REM{1,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline 1 M1035')
% Saline
subplot(4,1,2),
bar(ax1_Saline,Deltam{2,1}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{2,1},SWS{2,1},REM{2,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Saline M1035')
% Baseline 2
subplot(4,1,3),
bar(ax1_Baseline2,Deltam{3,1}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{3,1},SWS{3,1},REM{3,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline 2 M1035')
% CNO
subplot(4,1,4),
bar(ax1_CNO,Deltam{4,1}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{4,1},SWS{4,1},REM{4,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute CNO M1035')
    
cd(DirFigure);
savefig(fullfile('Delta distribution with hypnogram M1035.fig')) % enregistrement de la figure .fig


% M1036
figure
% Baseline 1
subplot(4,1,1),
bar(ax2_Baseline1,Deltam{1,2}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{1,2},SWS{1,2},REM{1,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline 1 M1036')
% Saline
subplot(4,1,2),
bar(ax2_Saline,Deltam{2,2}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{2,2},SWS{2,2},REM{2,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Saline M1036')
% Baseline 2
subplot(4,1,3),
bar(ax2_Baseline2,Deltam{3,2}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{3,2},SWS{3,2},REM{3,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline 2 M1036')
% CNO
subplot(4,1,4),
bar(ax2_CNO,Deltam{4,2}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{4,2},SWS{4,2},REM{4,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute CNO M1036')
    
cd(DirFigure);
savefig(fullfile('Delta distribution with hypnogram M1036.fig')) % enregistrement de la figure .fig


% M1037
figure
% Baseline 1
subplot(4,1,1),
bar(ax3_Baseline1,Deltam{1,3}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{1,3},SWS{1,3},REM{1,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline 1 M1037')
% Saline
subplot(4,1,2),
bar(ax3_Saline,Deltam{2,3}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{2,3},SWS{2,3},REM{2,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Saline M1037')
% Baseline 2
subplot(4,1,3),
bar(ax3_Baseline2,Deltam{3,3}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{3,3},SWS{3,3},REM{3,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline 2 M1037')
% CNO
subplot(4,1,4),
bar(ax3_CNO,Deltam{4,3}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{4,3},SWS{4,3},REM{4,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute CNO M1037')
    
cd(DirFigure);
savefig(fullfile('Delta distribution with hypnogram M1037.fig')) % enregistrement de la figure .fig


%% Histogramme Ripples
ax1_Baseline1=linspace(0,length(Ripplem{1,1})*60,length(Ripplem{1,1}));
ax2_Baseline1=linspace(0,length(Ripplem{1,2})*60,length(Ripplem{1,2}));
ax3_Baseline1=linspace(0,length(Ripplem{1,3})*60,length(Ripplem{1,3}));
ax1_Saline=linspace(0,length(Ripplem{2,1})*60,length(Ripplem{2,1}));
ax2_Saline=linspace(0,length(Ripplem{2,2})*60,length(Ripplem{2,2}));
ax3_Saline=linspace(0,length(Ripplem{2,3})*60,length(Ripplem{2,3}));
ax1_Baseline2=linspace(0,length(Ripplem{3,1})*60,length(Ripplem{3,1}));
ax2_Baseline2=linspace(0,length(Ripplem{3,2})*60,length(Ripplem{3,2}));
ax3_Baseline2=linspace(0,length(Ripplem{3,3})*60,length(Ripplem{3,3}));
ax1_CNO=linspace(0,length(Ripplem{4,1})*60,length(Ripplem{4,1}));
ax2_CNO=linspace(0,length(Ripplem{4,2})*60,length(Ripplem{4,2}));
ax3_CNO=linspace(0,length(Ripplem{4,3})*60,length(Ripplem{4,3}));

% M1035
figure
% Baseline 1
subplot(4,1,1),
bar(ax1_Baseline1,Ripplem{1,1}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{1,1},SWS{1,1},REM{1,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute Baseline 1 M1035')
% Saline
subplot(4,1,2),
bar(ax1_Saline,Ripplem{2,1}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{2,1},SWS{2,1},REM{2,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute Saline M1035')
% Baseline 2
subplot(4,1,3),
bar(ax1_Baseline2,Ripplem{3,1}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{3,1},SWS{3,1},REM{3,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute Baseline 2 M1035')
% CNO
subplot(4,1,4),
bar(ax1_CNO,Ripplem{4,1}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{4,1},SWS{4,1},REM{4,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute CNO M1035')
    
cd(DirFigure);
savefig(fullfile('ripple distribution with hypnogram M1035.fig')) % enregistrement de la figure .fig


% M1036
figure
% Baseline 1
subplot(4,1,1),
bar(ax2_Baseline1,Ripplem{1,2}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{1,2},SWS{1,2},REM{1,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute Baseline 1 M1036')
% Saline
subplot(4,1,2),
bar(ax2_Saline,Ripplem{2,2}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{2,2},SWS{2,2},REM{2,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute Saline M1036')
% Baseline 2
subplot(4,1,3),
bar(ax2_Baseline2,Ripplem{3,2}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{3,2},SWS{3,2},REM{3,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute Baseline 2 M1036')
% CNO
subplot(4,1,4),
bar(ax2_CNO,Ripplem{4,2}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{4,2},SWS{4,2},REM{4,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute CNO M1036')
    
cd(DirFigure);
savefig(fullfile('ripple distribution with hypnogram M1036.fig')) % enregistrement de la figure .fig


% M1037
figure
% Baseline 1
subplot(4,1,1),
bar(ax3_Baseline1,Ripplem{1,3}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{1,3},SWS{1,3},REM{1,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute Baseline 1 M1037')
% Saline
subplot(4,1,2),
bar(ax3_Saline,Ripplem{2,3}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{2,3},SWS{2,3},REM{2,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute Saline M1037')
% Baseline 2
subplot(4,1,3),
bar(ax3_Baseline2,Ripplem{3,3}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{3,3},SWS{3,3},REM{3,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute Baseline 2 M1037')
% CNO
subplot(4,1,4),
bar(ax3_CNO,Ripplem{4,3}), hold on
ylabel('Number of ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{4,3},SWS{4,3},REM{4,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of ripples wave per minute CNO M1037')
    
cd(DirFigure);
savefig(fullfile('ripple distribution with hypnogram M1037.fig')) % enregistrement de la figure .fig

