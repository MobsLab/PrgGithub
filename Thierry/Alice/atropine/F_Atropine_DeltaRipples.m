%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/PFC-VLPO_dread-ex/ParcoursComputeDeltaRipples.m

% Ce script permet de tracer 6 figures pour l'expérience PFC-VLPO_dread-ex
% en utilisant les fonctions Deltaperminute et RipplesPerMinute
% L'expérience PFC-VLPO_dread-ex comprend 4 conditions : Baseline 1, Saline,
% Baseline 2 et CNO
% Et elle a été réalisée pour 3 souris : M923, M1036 et M1037

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

a=0;
Dir{1}=PathForExperiments_TG('atropine_Baseline');
Dir{2}=PathForExperiments_TG('atropine_Atropine');
Dir{3}=PathForExperiments_TG('atropine_Saline');
DirFigure='/media/nas5/Thierry_DATA/Figures/Atropine/';

for i=1:length(Dir) % baseline 1 ou baseline 2 ou Saline ou CNO
    for j=1:length(Dir{i}.path)
        cd(Dir{i}.path{j}{1});
        a=a+1;
        fprintf('Calculting data %d/%d\n',[a,length(Dir)*length(Dir{i}.path)])
        load('DeltaWaves.mat');
        Deltas(i,j)=alldeltas_PFCx;
        Delta_min=Deltaperminute(Deltas(i,j));
        Deltam{i,j}=Delta_min;
        if exist('Ripples.mat','file')==2
            load('Ripples.mat');
            Ripples(i,j)=tRipples;
            Ripples_min=RipplesPerMinute(Ripples(i,j));
            Ripplem{i,j}=Ripples_min;
        else
            Ripplem{i,j}=0;
        end
        load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
        REM{i,j}=REMEpoch;
        wake{i,j}=Wake; 
        SWS{i,j}=SWSEpoch;
    end
end


%% Section 2 : Histogramme Deltas par minute
ax1_Baseline=linspace(0,length(Deltam{1,1})*60,length(Deltam{1,1}));
ax2_Baseline=linspace(0,length(Deltam{1,2})*60,length(Deltam{1,2}));
ax3_Baseline=linspace(0,length(Deltam{1,3})*60,length(Deltam{1,3}));
ax4_Baseline=linspace(0,length(Deltam{1,4})*60,length(Deltam{1,4}));
ax1_Atropine=linspace(0,length(Deltam{2,1})*60,length(Deltam{2,1}));
ax2_Atropine=linspace(0,length(Deltam{2,2})*60,length(Deltam{2,2}));
ax3_Atropine=linspace(0,length(Deltam{2,3})*60,length(Deltam{2,3}));
ax4_Atropine=linspace(0,length(Deltam{2,4})*60,length(Deltam{2,4}));
ax1_Saline=linspace(0,length(Deltam{3,1})*60,length(Deltam{3,1}));
ax2_Saline=linspace(0,length(Deltam{3,2})*60,length(Deltam{3,2}));
ax3_Saline=linspace(0,length(Deltam{3,3})*60,length(Deltam{3,3}));
ax4_Saline=linspace(0,length(Deltam{3,4})*60,length(Deltam{3,4}));


% M923
figure
% Baseline
subplot(3,1,1),
bar(ax1_Baseline,Deltam{1,1}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{1,1},SWS{1,1},REM{1,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline M923')
% Atropine
subplot(3,1,2),
bar(ax1_Atropine,Deltam{2,1}), hold on
% pour mettre une ligne verticale sur le graphe
line([8216 8216],ylim,'color','r','linewidth',2)
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{2,1},SWS{2,1},REM{2,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Atropine M923')
% Saline
subplot(3,1,3),
bar(ax1_Saline,Deltam{3,1}), hold on
% pour mettre une ligne verticale sur le graphe
line([9833 9833],ylim,'color','r','linewidth',2)
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{3,1},SWS{3,1},REM{3,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Saline M923')    
cd(DirFigure);
savefig(fullfile('Delta distribution with hypnogram M923.fig')) % enregistrement de la figure .fig


% M926
figure
% Baseline
subplot(3,1,1),
bar(ax2_Baseline,Deltam{1,2}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{1,2},SWS{1,2},REM{1,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline M926')
% Atropine
subplot(3,1,2),
bar(ax2_Atropine,Deltam{2,2}), hold on
% pour mettre une ligne verticale sur le graphe
line([8295 8295],ylim,'color','r','linewidth',2)
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{2,2},SWS{2,2},REM{2,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Atropine M926')
% Saline
subplot(3,1,3),
bar(ax2_Saline,Deltam{3,2}), hold on
% pour mettre une ligne verticale sur le graphe
line([9888 9888],ylim,'color','r','linewidth',2)
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{3,2},SWS{3,2},REM{3,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Saline M926')    
cd(DirFigure);
savefig(fullfile('Delta distribution with hypnogram M926.fig')) % enregistrement de la figure .fig

% M927
figure
% Baseline
subplot(3,1,1),
bar(ax3_Baseline,Deltam{1,3}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{1,3},SWS{1,3},REM{1,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline M927')
% Atropine
subplot(3,1,2),
bar(ax3_Atropine,Deltam{2,3}), hold on
% pour mettre une ligne verticale sur le graphe
line([8341 8341],ylim,'color','r','linewidth',2)
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{2,3},SWS{2,3},REM{2,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Atropine M927')
% Saline
subplot(3,1,3),
bar(ax3_Saline,Deltam{3,3}), hold on
% pour mettre une ligne verticale sur le graphe
line([9916 9916],ylim,'color','r','linewidth',2)
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{3,3},SWS{3,3},REM{3,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Saline M927')    
cd(DirFigure);
savefig(fullfile('Delta distribution with hypnogram M927.fig')) % enregistrement de la figure .fig
    
% M928
figure
% Baseline
subplot(3,1,1),
bar(ax4_Baseline,Deltam{1,4}), hold on
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{1,4},SWS{1,4},REM{1,4},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Baseline M928')
% Atropine
subplot(3,1,2),
bar(ax4_Atropine,Deltam{2,4}), hold on
% pour mettre une ligne verticale sur le graphe
line([8378 8378],ylim,'color','r','linewidth',2)
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{2,4},SWS{2,4},REM{2,4},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Atropine M928')
% Saline
subplot(3,1,3),
bar(ax4_Saline,Deltam{3,4}), hold on
% pour mettre une ligne verticale sur le graphe
line([9969 9969],ylim,'color','r','linewidth',2)
ylabel('Number of Delta')
yyaxis right
SleepStages=PlotSleepStage(wake{3,4},SWS{3,4},REM{3,4},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Deltas wave per minute Saline M928')    
cd(DirFigure);
savefig(fullfile('Delta distribution with hypnogram M928.fig')) % enregistrement de la figure .fig

%% Histogramme Ripples
ax1_Baseline=linspace(0,length(Ripplem{1,1})*60,length(Ripplem{1,1}));
ax2_Baseline=linspace(0,length(Ripplem{1,2})*60,length(Ripplem{1,2}));
ax3_Baseline=linspace(0,length(Ripplem{1,3})*60,length(Ripplem{1,3}));
ax4_Baseline=linspace(0,length(Ripplem{1,4})*60,length(Ripplem{1,4}));
ax1_Atropine=linspace(0,length(Ripplem{2,1})*60,length(Ripplem{2,1}));
ax2_Atropine=linspace(0,length(Ripplem{2,2})*60,length(Ripplem{2,2}));
ax3_Atropine=linspace(0,length(Ripplem{2,3})*60,length(Ripplem{2,3}));
ax4_Atropine=linspace(0,length(Ripplem{2,4})*60,length(Ripplem{2,4}));
ax1_Saline=linspace(0,length(Ripplem{3,1})*60,length(Ripplem{3,1}));
ax2_Saline=linspace(0,length(Ripplem{3,2})*60,length(Ripplem{3,2}));
ax3_Saline=linspace(0,length(Ripplem{3,3})*60,length(Ripplem{3,3}));
ax4_Saline=linspace(0,length(Ripplem{3,4})*60,length(Ripplem{3,4}));



% M923
figure
% Baseline
subplot(3,1,1),
bar(ax1_Baseline,Ripplem{1,1}), hold on
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{1,1},SWS{1,1},REM{1,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Baseline M923')
% Atropine
subplot(3,1,2),
bar(ax1_Atropine,Ripplem{2,1}), hold on
% pour mettre une ligne verticale sur le graphe
line([8216 8216],ylim,'color','r','linewidth',2)
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{2,1},SWS{2,1},REM{2,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Atropine M923')
% Saline
subplot(3,1,3),
bar(ax1_Saline,Ripplem{3,1}), hold on
% pour mettre une ligne verticale sur le graphe
line([9833 9833],ylim,'color','r','linewidth',2)
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{3,1},SWS{3,1},REM{3,1},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Saline M923')    
cd(DirFigure);
savefig(fullfile('Ripple distribution with hypnogram M923.fig')) % enregistrement de la figure .fig


% M926      % Pas de ripples pour cette souris
figure
% Baseline
subplot(3,1,1),
bar(ax2_Baseline,Ripplem{1,2}), hold on
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{1,2},SWS{1,2},REM{1,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Baseline M926')
% Atropine
subplot(3,1,2),
bar(ax2_Atropine,Ripplem{2,2}), hold on
% pour mettre une ligne verticale sur le graphe
line([8295 8295],ylim,'color','r','linewidth',2)
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{2,2},SWS{2,2},REM{2,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Atropine M926')
% Saline
subplot(3,1,3),
bar(ax2_Saline,Ripplem{3,2}), hold on
% pour mettre une ligne verticale sur le graphe
line([9888 9888],ylim,'color','r','linewidth',2)
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{3,2},SWS{3,2},REM{3,2},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Saline M926')    
cd(DirFigure);
savefig(fullfile('Ripple distribution with hypnogram M926.fig')) % enregistrement de la figure .fig

% M927
figure
% Baseline
subplot(3,1,1),
bar(ax3_Baseline,Ripplem{1,3}), hold on
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{1,3},SWS{1,3},REM{1,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Baseline M927')
% Atropine
subplot(3,1,2),
bar(ax3_Atropine,Ripplem{2,3}), hold on
% pour mettre une ligne verticale sur le graphe
line([8341 8341],ylim,'color','r','linewidth',2)
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{2,3},SWS{2,3},REM{2,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Atropine M927')
% Saline
subplot(3,1,3),
bar(ax3_Saline,Ripplem{3,3}), hold on
% pour mettre une ligne verticale sur le graphe
line([9916 9916],ylim,'color','r','linewidth',2)
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{3,3},SWS{3,3},REM{3,3},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Saline M927')    
cd(DirFigure);
savefig(fullfile('Ripple distribution with hypnogram M927.fig')) % enregistrement de la figure .fig
    
% M928
figure
% Baseline
subplot(3,1,1),
bar(ax4_Baseline,Ripplem{1,4}), hold on
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{1,4},SWS{1,4},REM{1,4},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Baseline M928')
% Atropine
subplot(3,1,2),
bar(ax4_Atropine,Ripplem{2,4}), hold on
% pour mettre une ligne verticale sur le graphe
line([8378 8378],ylim,'color','r','linewidth',2)
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{2,4},SWS{2,4},REM{2,4},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Atropine M928')
% Saline
subplot(3,1,3),
bar(ax4_Saline,Ripplem{3,4}), hold on
% pour mettre une ligne verticale sur le graphe
line([9969 9969],ylim,'color','r','linewidth',2)
ylabel('Number of Ripple')
yyaxis right
SleepStages=PlotSleepStage(wake{3,4},SWS{3,4},REM{3,4},0);
set(gca,'ytick',[-1:4])
set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
ylim([-1.5 4.5])
xlabel('Time (s)')
title('Number of Ripples wave per minute Saline M928')    
cd(DirFigure);
savefig(fullfile('Ripple distribution with hypnogram M928.fig')) % enregistrement de la figure .fig
