%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /home/mobschapeau/Dropbox/Kteam/PrgMatlab/Thierry/Alice/box_rat_72h/ParcoursComputeDeltaRipples.m

% Ce script permet de tracer 4 figures pour l'expérience Box Rat 72h
% L'expérience Box Rat 72h comprend 3 conditions : Baseline 1, Eposure et
% Baseline 2
% Et elle a été réalisée pour 2 souris : M923 et M926

%Remarque : pour mettre une ligne verticale sur le graphe
%line([8280 8280],ylim,'color','k','linewidth',2)

% Le sctrip est composé de 3 sections :
%   * Section 1 : calcul et chargement des données préalablement calculées
%     par le script SleepStageFigure
%   * Section 2 : tracé de l'histogramme de la répartition des ondes delta au
%     cours de l'enregistrement superposé à l'hypnogramme (2 figures, une par souris)
%   * Section 3 : tracé de l'histogramme de la répartition des ondes ripples au
%     cours de l'enregistrement supperposé à l'hypnogramme (2 figures, une par souris)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1 : Chargement des données

Dir{1}=PathForExperiments_TG('box_rat_72h_Baseline1');      % 1=Baseline 1
Dir{2}=PathForExperiments_TG('box_rat_72h_Exposure');       % 2=Exposure
Dir{3}=PathForExperiments_TG('box_rat_72h_Baseline2');      % 3=Baseline 2
DirFigure='/media/nas5/Thierry_DATA/Figures/Rat_box_72h/Figures/';  % dossier où seront enregistrées les figures .fig

for i=1:length(Dir) % baseline 1 ou baseline 2 ou exp
    for j=1:length(Dir{i}.path)
        cd(Dir{i}.path{j}{1});
        load('DeltaWaves.mat');
        Deltas(i,j)=alldeltas_PFCx;
        load('Ripples.mat');
        Ripples(i,j)=tRipples;
        load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
        REM{i,j}=REMEpoch;
        wake{i,j}=Wake; 
        SWS{i,j}=SWSEpoch;
        Delta_min=Deltaperminute(Deltas(i,j));
        Deltam{i,j}=Delta_min;
        Ripples_min=RipplesPerMinute(Ripples(i,j));
        Ripplem{i,j}=Ripples_min;
    end
end


%% Histogramme Deltas par minute

ax1=linspace(0,length(Deltam{1,1})*60,length(Deltam{1,1}));
ax2=linspace(0,length(Deltam{2,1})*60,length(Deltam{2,1}));
ax3=linspace(0,length(Deltam{3,1})*60,length(Deltam{3,1}));
for i=1:length(Dir{1}.path);    % pour chacune des souris 1=923 et 2=926
    
    figure
    % Baseline 1
    subplot(3,1,1),
    bar(ax1,Deltam{1,i}), hold on
    ylabel('Number of Delta')
    yyaxis right
    SleepStages=PlotSleepStage(wake{1,i},SWS{1,i},REM{1,i},0);
    set(gca,'ytick',[-1:4])
    set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
    ylim([-1.5 4.5])
    xlabel('Time (min)')
    title(strcat('Number of Deltas wave per minute Baseline 1 M',num2str(Dir{1}.nMice{i})))

    % Exposure
    subplot(3,1,2),
    bar(ax2,Deltam{2,i}), hold on
    ylabel('Number of Delta')
    yyaxis right
    SleepStages=PlotSleepStage(wake{2,i},SWS{2,i},REM{2,i},0);
    xlabel('Time (min)')
    set(gca,'ytick',[-1:4])
    set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
    ylim([-1.5 4.5])
    title(strcat('Number of Deltas wave per minute Exposure M',num2str(Dir{1}.nMice{i})))
    
    % Baseline 2
    subplot(3,1,3),
    bar(ax3,Deltam{3,i}), hold on
    ylabel('Number of Delta')
    yyaxis right
    SleepStages=PlotSleepStage(wake{1,i},SWS{1,i},REM{1,i},0);
    set(gca,'ytick',[-1:4])
    set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
    ylim([-1.5 4.5])
    xlabel('Time (min)')
    title(strcat('Number of Deltas wave per minute Baseline 2 M',num2str(Dir{1}.nMice{i})))
    
        cd(DirFigure);
    figname=strcat('Delta distribution with hypnogram M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig
end

%% Histogramme Ripples

ax1=linspace(0,length(Deltam{1,1})*60,length(Deltam{1,1}));
ax2=linspace(0,length(Deltam{2,1})*60,length(Deltam{2,1}));
ax3=linspace(0,length(Deltam{3,1})*60,length(Deltam{3,1}));

for i=1:length(Dir{1}.path);    % pour chacune des souris 1=923 et 2=926

    figure
    % Baseline 1
    subplot(3,1,1),
    bar(ax1,Ripplem{1,i}), hold on
    ylabel('Number of Ripples')
    yyaxis right
    SleepStages=PlotSleepStage(wake{1,i},SWS{1,i},REM{1,i},0);
    set(gca,'ytick',[-1:4])
    set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
    ylim([-1.5 4.5])
    xlabel('Time (min)')
    title(strcat('Number of Ripples per minute Baseline 1 M',num2str(Dir{1}.nMice{i})))

    % Exposure
    subplot(3,1,2), hold on, 
    bar(ax2,Ripplem{2,i}), hold on
    ylabel('Number of Ripples')
    yyaxis right
    SleepStages=PlotSleepStage(wake{2,i},SWS{2,i},REM{2,i},0);
    set(gca,'ytick',[-1:4])
    set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
    ylim([-1.5 4.5])
    xlabel('Time (min)')
    title(strcat('Number of Ripples per minute Exposure M',num2str(Dir{1}.nMice{i})))
    
    % Baseline 2
    subplot(3,1,3), hold on, 
    bar(ax3,Ripplem{3,i}), hold on
    ylabel('Number of Ripples')
    yyaxis right
    SleepStages=PlotSleepStage(wake{3,i},SWS{3,i},REM{3,i},0);
    set(gca,'ytick',[-1:4])
    set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
    ylim([-1.5 4.5])
    xlabel('Time (min)')
    title(strcat('Number of Ripples per minute Baseline 2 M',num2str(Dir{1}.nMice{i})))
    
    cd(DirFigure);
    figname=strcat('Ripples distribution with hypnogram M',num2str(Dir{1}.nMice{i}),'.fig');
    savefig(fullfile(figname)) % enregistrement de la figure .fig
    
end

