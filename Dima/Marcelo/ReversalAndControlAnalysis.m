%% Get Data

clear all
SingleMiceFolderExperiment = '/home/vador/Documents/Marcelo/Results/Reversal/Averages/SingleMiceData';
SingleMiceFolderControl = '/home/vador/Documents/Marcelo/Results/ReversalControl/Averages/SingleMiceData';

Mice2UseExperiment = logical([0 1 1]); % Reversal: [863 913 934], put ones in the positions of mice to be used in analysis
Mice2UseControl = logical([0 0 1 1 0]); % ReversalControl: [913 932 934 935 938], put ones in the positions of mice to be used in analysis

% Experiment
cd(SingleMiceFolderExperiment)
Expe = dir;
Expe = Expe(~ismember({Expe.name}, {'.', '..'}));
Expe = Expe(Mice2UseExperiment);

for k = 1:numel(Expe)
    load(Expe(k).name);
    MouseName{k} = MouseData.MouseName;
    if k == 1
        TrajPreCat = MouseData.TrajPre;
        TrajPreTrials = MouseData.TrajPreTrials;
        TrajPosPAGCat = MouseData.TrajPosPAG;
        TrajPosPAGTrials = MouseData.TrajPosPAGTrials;
        TrajPosMFBCat = MouseData.TrajPosMFB;
        TrajPosMFBTrials = MouseData.TrajPosMFBTrials;
        SpeedSafePreTrials = MouseData.SpeedSafePreTrials;
        SpeedSafePosPAGTrials = MouseData.SpeedSafePosPAGTrials;
        SpeedSafePosMFBTrials = MouseData.SpeedSafePosMFBTrials;
        SpeedPreTraj = MouseData.SpeedPreTraj;
        SpeedPosPAGTraj = MouseData.SpeedPosPAGTraj;
        SpeedPosMFBTraj = MouseData.SpeedPosMFBTraj;
    
    else
        TrajPreCat = cat(1,TrajPreCat,MouseData.TrajPre);
        TrajPreTrials(k,:) = MouseData.TrajPreTrials;
        TrajPosPAGCat = cat(1,TrajPosPAGCat,MouseData.TrajPosPAG);
        TrajPosPAGTrials(k,:) = MouseData.TrajPosPAGTrials;
        TrajPosMFBCat = cat(1,TrajPosMFBCat,MouseData.TrajPosMFB);
        TrajPosMFBTrials(k,:) = MouseData.TrajPosMFBTrials;
        SpeedSafePreTrials(k,:) = MouseData.SpeedSafePreTrials;
        SpeedSafePosPAGTrials(k,:) = MouseData.SpeedSafePosPAGTrials;
        SpeedSafePosMFBTrials(k,:) = MouseData.SpeedSafePosMFBTrials;
        SpeedPreTraj(k,:) = MouseData.SpeedPreTraj;
        SpeedPosPAGTraj(k,:) = MouseData.SpeedPosPAGTraj;
        SpeedPosMFBTraj(k,:) = MouseData.SpeedPosMFBTraj;
    end
    
    OccupPreTrials(:,:,k) = MouseData.OccupPre;
    OccupPosPAGTrials(:,:,k) = MouseData.OccupPosPAG;
    OccupPosMFBTrials(:,:,k) = MouseData.OccupPosMFB;
    OccupPre(:,k) = MouseData.OccupPreMean;
    OccupPreStd(:,k) = MouseData.OccupPreStd;
    OccupPosPAG(:,k) = MouseData.OccupPosPAGMean;
    OccupPosPAGStd(:,k) = MouseData.OccupPosPAGStd;
    OccupPosMFB(:,k) = MouseData.OccupPosMFBMean;
    OccupPosMFBStd(:,k) = MouseData.OccupPosMFBStd;
    OccupPAG(:,k) = MouseData.OccupPAGMean;
    OccupPAGStd(:,k) = MouseData.OccupPAGStd;
    OccupMFB(:,k) = MouseData.OccupMFBMean;
    OccupMFBStd(:,k) = MouseData.OccupMFBStd;
    NumEntPreTrials(:,k) = MouseData.NumEntPre;
    NumEntPosPAGTrials(:,k) = MouseData.NumEntPosPAG;
    NumEntPosMFBTrials(:,k) = MouseData.NumEntPosMFB;
    NumEntPre(k) = MouseData.NumEntPreMean;
    NumEntPreStd(k) = MouseData.NumEntPreStd;
    NumEntPosPAG(k) = MouseData.NumEntPosPAGMean;
    NumEntPosPAGStd(k) = MouseData.NumEntPosPAGStd;
    NumEntPosMFB(k) = MouseData.NumEntPosMFBMean;
    NumEntPosMFB(k) = MouseData.NumEntPosMFBStd;
    NumCondMFB(k) = MouseData.NumCondMFB;
    NumCondPAG(k) = MouseData.NumCondPAG;
    FirstTimeShockPreTrials(:,k) = MouseData.FirstTimeShockPre;
    FirstTimeShockPosPAGTrials(:,k) = MouseData.FirstTimeShockPosPAG;
    FirstTimeShockPosMFBTrials(:,k) = MouseData.FirstTimeShockPosMFB;
    FirstTimeShockPre(k) = MouseData.FirstTimeShockPreMean;
    FirstTimeShockPreStd(k) = MouseData.FirstTimeShockPreStd;
    FirstTimeShockPosPAG(k) = MouseData.FirstTimeShockPosPAGMean;
    FirstTimeShockPosPAGStd(k) = MouseData.FirstTimeShockPosPAGStd;
    FirstTimeShockPosMFB(k) = MouseData.FirstTimeShockPosMFBMean;
    FirstTimeShockPosMFBStd(k) = MouseData.FirstTimeShockPosMFBStd;
    SpeedPreTrials(:,k) = MouseData.SpeedPre;
    SpeedPosPAGTrials(:,k) = MouseData.SpeedPosPAG;
    SpeedPosMFBTrials(:,k) = MouseData.SpeedPosMFB;
    SpeedShockPre(k) = MouseData.SpeedShockPreMean;
    SpeedShockPre(k) = MouseData.SpeedShockPreStd;
    SpeedSafePre(k) = MouseData.SpeedSafePreMean;
    SpeedSafePreStd(k) = MouseData.SpeedSafePreStd;
    SpeedShockPosPAG(k) = MouseData.SpeedShockPosPAGMean;
    SpeedShockPosPAGStd(k) = MouseData.SpeedShockPosPAGStd;
    SpeedSafePosPAG(k) = MouseData.SpeedSafePosPAGMean;
    SpeedSafePosPAGStd(k) = MouseData.SpeedSafePosPAGStd;
    SpeedShockPosMFB(k) = MouseData.SpeedShockPosMFBMean;
    SpeedShockPosMFBStd(k) = MouseData.SpeedShockPosMFBStd;
    SpeedSafePosMFB(k) = MouseData.SpeedSafePosMFBMean;
    SpeedSafePosMFBStd(k) = MouseData.SpeedSafePosMFBStd;
    EscapeWallShockPAG(k) = MouseData.EscapeWallShockPAGMean;
    EscapeWallShockPAGStd(k) = MouseData.EscapeWallShockPAGStd;
    EscapeWallShockMFB(k) = MouseData.EscapeWallShockMFBMean;
    EscapeWallShockMFBStd(k) = MouseData.EscapeWallShockMFBStd;
    EscapeWallSafeMFB(k) = MouseData.EscapeWallSafeMFBMean;
    EscapeWallSafeMFBStd(k) = MouseData.EscapeWallSafeMFBStd;
    EscapeWallSafePAG(k) = MouseData.EscapeWallSafePAGMean;
    EscapeWallSafePAGStd(k) = MouseData.EscapeWallSafePAGStd;
end

% Control
cd(SingleMiceFolderControl)
Control = dir;
Control = Control(~ismember({Control.name}, {'.', '..'}));
Control = Control(Mice2UseControl);

for k = 1:numel(Control)
    load(Control(k).name);
    MouseNameControl{k} = MouseData.MouseName;
    
    if k == 1
        TrajPreCatControl = MouseData.TrajPre;
        TrajPreTrialsControl = MouseData.TrajPreTrials;
        TrajPosPAGCatControl = MouseData.TrajPosPAG;
        TrajPosPAGTrialsControl = MouseData.TrajPosPAGTrials;
        TrajPosMFBCatControl = MouseData.TrajPosMFB;
        TrajPosMFBTrialsControl = MouseData.TrajPosMFBTrials;
        SpeedSafePreTrialsControl = MouseData.SpeedSafePreTrials;
        SpeedSafePosPAGTrialsControl = MouseData.SpeedSafePosPAGTrials;
        SpeedSafePosMFBTrialsControl = MouseData.SpeedSafePosMFBTrials;
        SpeedPreTrajControl = MouseData.SpeedPreTraj;
        SpeedPosPAGTrajControl = MouseData.SpeedPosPAGTraj;
        SpeedPosMFBTrajControl = MouseData.SpeedPosMFBTraj;
    else
        TrajPreCatControl = cat(1,TrajPreCatControl,MouseData.TrajPre);
        TrajPreTrialsControl(k,:) = MouseData.TrajPreTrials;
        TrajPosPAGCatControl = cat(1,TrajPosPAGCatControl,MouseData.TrajPosPAG);
        TrajPosPAGTrialsControl(k,:) = MouseData.TrajPosPAGTrials;
        TrajPosMFBCatControl = cat(1,TrajPosMFBCatControl,MouseData.TrajPosMFB);
        TrajPosMFBTrialsControl(k,:) = MouseData.TrajPosMFBTrials;
        SpeedSafePreTrialsControl(k,:) = MouseData.SpeedSafePreTrials;
        SpeedSafePosPAGTrialsControl(k,:) = MouseData.SpeedSafePosPAGTrials;
        SpeedSafePosMFBTrialsControl(k,:) = MouseData.SpeedSafePosMFBTrials;
        SpeedPreTrajControl(k,:) = MouseData.SpeedPreTraj;
        SpeedPosPAGTrajControl(k,:) = MouseData.SpeedPosPAGTraj;
        SpeedPosMFBTrajControl(k,:) = MouseData.SpeedPosMFBTraj;
    end
    
    OccupPreTrialsControl(:,:,k) = MouseData.OccupPre;
    OccupPosPAGTrialsControl(:,:,k) = MouseData.OccupPosPAG;
    OccupPosMFBTrialsControl(:,:,k) = MouseData.OccupPosMFB;
    OccupPreControl(:,k) = MouseData.OccupPreMean;
    OccupPreStdControl(:,k) = MouseData.OccupPreStd;
    OccupPosPAGControl(:,k) = MouseData.OccupPosPAGMean;
    OccupPosPAGStdControl(:,k) = MouseData.OccupPosPAGStd;
    OccupPosMFBControl(:,k) = MouseData.OccupPosMFBMean;
    OccupPosMFBStdControl(:,k) = MouseData.OccupPosMFBStd;
    OccupPAGControl(:,k) = MouseData.OccupPAGMean;
    OccupPAGStdControl(:,k) = MouseData.OccupPAGStd;
    OccupMFBControl(:,k) = MouseData.OccupMFBMean;
    OccupMFBStdControl(:,k) = MouseData.OccupMFBStd;
    NumEntPreTrialsControl(:,k) = MouseData.NumEntPre;
    NumEntPosPAGTrialsControl(:,k) = MouseData.NumEntPosPAG;
    NumEntPosMFBTrialsControl(:,k) = MouseData.NumEntPosMFB;
    NumEntPreControl(k) = MouseData.NumEntPreMean;
    NumEntPreStdControl(k) = MouseData.NumEntPreStd;
    NumEntPosPAGControl(k) = MouseData.NumEntPosPAGMean;
    NumEntPosPAGStdControl(k) = MouseData.NumEntPosPAGStd;
    NumEntPosMFBControl(k) = MouseData.NumEntPosMFBMean;
    NumEntPosMFBControl(k) = MouseData.NumEntPosMFBStd;
    NumCondMFBControl(k) = MouseData.NumCondMFB;
    NumCondPAGControl(k) = MouseData.NumCondPAG;
    FirstTimeShockPreTrialsControl(:,k) = MouseData.FirstTimeShockPre;
    FirstTimeShockPosPAGTrialsControl(:,k) = MouseData.FirstTimeShockPosPAG;
    FirstTimeShockPosMFBTrialsControl(:,k) = MouseData.FirstTimeShockPosMFB;
    FirstTimeShockPreControl(k) = MouseData.FirstTimeShockPreMean;
    FirstTimeShockPreStdControl(k) = MouseData.FirstTimeShockPreStd;
    FirstTimeShockPosPAGControl(k) = MouseData.FirstTimeShockPosPAGMean;
    FirstTimeShockPosPAGStdControl(k) = MouseData.FirstTimeShockPosPAGStd;
    FirstTimeShockPosMFBControl(k) = MouseData.FirstTimeShockPosMFBMean;
    FirstTimeShockPosMFBStdControl(k) = MouseData.FirstTimeShockPosMFBStd;
    SpeedPreTrialsControl(:,k) = MouseData.SpeedPre;
    SpeedPosPAGTrialsControl(:,k) = MouseData.SpeedPosPAG;
    SpeedPosMFBTrialsControl(:,k) = MouseData.SpeedPosMFB;
    SpeedShockPreControl(k) = MouseData.SpeedShockPreMean;
    SpeedShockPreControl(k) = MouseData.SpeedShockPreStd;
    SpeedSafePreControl(k) = MouseData.SpeedSafePreMean;
    SpeedSafePreStdControl(k) = MouseData.SpeedSafePreStd;
    SpeedShockPosPAGControl(k) = MouseData.SpeedShockPosPAGMean;
    SpeedShockPosPAGStdControl(k) = MouseData.SpeedShockPosPAGStd;
    SpeedSafePosPAGControl(k) = MouseData.SpeedSafePosPAGMean;
    SpeedSafePosPAGStdControl(k) = MouseData.SpeedSafePosPAGStd;
    SpeedShockPosMFBControl(k) = MouseData.SpeedShockPosMFBMean;
    SpeedShockPosMFBStdControl(k) = MouseData.SpeedShockPosMFBStd;
    SpeedSafePosMFBControl(k) = MouseData.SpeedSafePosMFBMean;
    SpeedSafePosMFBStdControl(k) = MouseData.SpeedSafePosMFBStd;
    EscapeWallShockPAGControl(k) = MouseData.EscapeWallShockPAGMean;
    EscapeWallShockPAGStdControl(k) = MouseData.EscapeWallShockPAGStd;
    EscapeWallShockMFBControl(k) = MouseData.EscapeWallShockMFBMean;
    EscapeWallShockMFBStdControl(k) = MouseData.EscapeWallShockMFBStd;
    EscapeWallSafeMFBControl(k) = MouseData.EscapeWallSafeMFBMean;
    EscapeWallSafeMFBStdControl(k) = MouseData.EscapeWallSafeMFBStd;
    EscapeWallSafePAGControl(k) = MouseData.EscapeWallSafePAGMean;
    EscapeWallSafePAGStdControl(k) = MouseData.EscapeWallSafePAGStd;
end

%% Plots Shock zone occupancy during reversal experiments

OccupPreMean=mean(OccupPre,2);
OccupPreMeanStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGMeanStd=std(OccupPosPAG,0,2);

OccupPosMFBMean=mean(OccupPosMFB,2);
OccupPosMFBMeanStd=std(OccupPosMFB,0,2);

OccupPreMeanControl=mean(OccupPreControl,2);
OccupPreMeanStdControl=std(OccupPreControl,0,2);

OccupPosPAGMeanControl=mean(OccupPosPAGControl,2);
OccupPosPAGMeanStdControl=std(OccupPosPAGControl,0,2);

OccupPosMFBMeanControl=mean(OccupPosMFBControl,2);
OccupPosMFBMeanStdControl=std(OccupPosMFBControl,0,2);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

ColorMice = 1;

ymax = 45;

figure
subplot(1,2,1)
bar([1:3],100*[OccupPreMean(1) OccupPosPAGMean(1) OccupPosMFBMean(1)],'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],100*[OccupPreMean(1) OccupPosPAGMean(1) OccupPosMFBMean(1)],100*[OccupPreMeanStd(1) OccupPosPAGMeanStd(1) OccupPosMFBMeanStd(1)],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5,'DisplayName','Random Occupancy');

if ColorMice == 0
    for i=1:numel(Expe)
        plot([1:3]+0.1,100*[OccupPre(1,i) OccupPosPAG(1,i) OccupPosMFB(1,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
    end
elseif ColorMice == 1
    for i=1:numel(Expe)
        plot([1:3]+0.1,100*[OccupPre(1,i) OccupPosPAG(1,i) OccupPosMFB(1,i)],'linestyle','-','linewidth',1.2,...
        'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
        'DisplayName',MouseName{i});
    end
end
legend show
ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Shock zone occupancy during Reversal Experiment');

subplot(1,2,2)
bar([1:3],100*[OccupPreMeanControl(1) OccupPosPAGMeanControl(1) OccupPosMFBMeanControl(1)],'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],100*[OccupPreMeanControl(1) OccupPosPAGMeanControl(1)...
    OccupPosMFBMeanControl(1)],100*[OccupPreMeanStdControl(1) OccupPosPAGMeanStdControl(1)...
    OccupPosMFBMeanStdControl(1)],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5,'DisplayName','Random Occupancy');

if ColorMice == 0
    for i=1:numel(Control)
        plot([1:3]+0.1,100*[OccupPreControl(1,i) OccupPosPAGControl(1,i)...
            OccupPosMFBControl(1,i)],'color',[0.6 0.6 0.6],...
            'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]'...
            ,'MarkerFaceColor','w','MarkerSize',6);
    end
elseif ColorMice == 1
    for i=1:numel(Control)
        plot([1:3]+0.1,100*[OccupPreControl(1,i) OccupPosPAGControl(1,i)...
            OccupPosMFBControl(1,i)],'linestyle','-','linewidth',1.2,...
            'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
            'DisplayName',MouseNameControl{i});
    end
end
legend show
ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Shock zone occupancy during Reversal Control Experiment');

%% First time to enter shock zone plot 

FirstTimeShockPreMean=mean(FirstTimeShockPre);
FirstTimeShockPreMeanStd=std(FirstTimeShockPre);
FirstTimeShockPosPAGMean=mean(FirstTimeShockPosPAG);
FirstTimeShockPosPAGMeanStd=std(FirstTimeShockPosPAG);
FirstTimeShockPosMFBMean=mean(FirstTimeShockPosMFB);
FirstTimeShockPosMFBMeanStd=std(FirstTimeShockPosMFB);

FirstTimeShockPreMeanControl=mean(FirstTimeShockPreControl);
FirstTimeShockPreMeanStdControl=std(FirstTimeShockPreControl);
FirstTimeShockPosPAGMeanControl=mean(FirstTimeShockPosPAGControl);
FirstTimeShockPosPAGMeanStdControl=std(FirstTimeShockPosPAGControl);
FirstTimeShockPosMFBMeanControl=mean(FirstTimeShockPosMFBControl);
FirstTimeShockPosMFBMeanStdControl=std(FirstTimeShockPosMFBControl);


OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

ColorMice = 1;


figure
subplot(1,2,1)
bar([1:3],[FirstTimeShockPreMean FirstTimeShockPosPAGMean FirstTimeShockPosMFBMean],'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[FirstTimeShockPreMean FirstTimeShockPosPAGMean FirstTimeShockPosMFBMean],...
    [FirstTimeShockPreMeanStd FirstTimeShockPosPAGMeanStd FirstTimeShockPosMFBMeanStd],...
    'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

if ColorMice == 1
    for i=1:numel(Expe)
    plot([1:3]+0.1,[FirstTimeShockPre(i) FirstTimeShockPosPAG(i) FirstTimeShockPosMFB(i)],'linestyle','-','linewidth',1.2,...
                'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
                'DisplayName',MouseName{i});
    end
    legend show
else
    for i=1:numel(Expe)
    plot([1:3]+0.1,[FirstTimeShockPre(i) FirstTimeShockPosPAG(i) FirstTimeShockPosMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-','linewidth',1.2,...
                'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
                'DisplayName',MouseName{i});
    end
end
xrange = xlim;
line(xrange,[121,121],'Color','red','LineWidth',2,'HandleVisibility','off')
text(xrange(1),116,' No entries during test','Color','red','FontSize',10, 'FontWeight','bold','HandleVisibility','off')

ylabel('Time (s)','fontweight','bold','fontsize',10);
% ylim([0 1300]);
title('First time to enter shock zone in Reversal Experiment');

subplot(1,2,2)
bar([1:3],[FirstTimeShockPreMeanControl FirstTimeShockPosPAGMeanControl...
    FirstTimeShockPosMFBMeanControl],'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[FirstTimeShockPreMeanControl FirstTimeShockPosPAGMeanControl...
    FirstTimeShockPosMFBMeanControl],[FirstTimeShockPreMeanStdControl FirstTimeShockPosPAGMeanStdControl...
    FirstTimeShockPosMFBMeanStdControl],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

if ColorMice == 1
    for i=1:numel(Control)
        plot([1:3]+0.1,[FirstTimeShockPreControl(i) FirstTimeShockPosPAGControl(i)...
            FirstTimeShockPosMFBControl(i)],'linestyle','-','linewidth',1.2,...
            'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
            'DisplayName',MouseNameControl{i});
    end
    legend show
else
    for i=1:numel(Expe)
        plot([1:3]+0.1,[FirstTimeShockPreControl(i) FirstTimeShockPosPAGControl(i)...
            FirstTimeShockPosMFBControl(i)],'color',[0.6 0.6 0.6],'linestyle','-','linewidth',1.2,...
            'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
            'DisplayName',MouseNameControl{i});
    end
end
xrange = xlim;
line(xrange,[121,121],'Color','red','LineWidth',2,'HandleVisibility','off')
text(xrange(1),116,' No entries during test','Color','red','FontSize',10, 'FontWeight','bold','HandleVisibility','off')

ylabel('Time (s)','fontweight','bold','fontsize',10);
% ylim([0 1300]);
title('First time to enter shock zone in Reversal Control Experiment');

%% Compare Occupancies

OccupPreMean=mean(OccupPre,2);
OccupPreMeanStd=std(OccupPre,0,2);

OccupPAGMean=mean(OccupPAG,2);
OccupPAGMeanStd=std(OccupPAG,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGMeanStd=std(OccupPosPAG,0,2);

OccupMFBMean=mean(OccupMFB,2);
OccupMFBMeanStd=std(OccupMFB,0,2);

OccupPosMFBMean=mean(OccupPosMFB,2);
OccupPosMFBMeanStd=std(OccupPosMFB,0,2);

OccupLabels_2 = {'Shock' 'Safe'};
y_range_bar = [0 75];
textPos = [0.5,24];
figure

subplot(2,3,1)

bar([1:3],100*[OccupPreMean(1) OccupPosPAGMean(1) OccupPosMFBMean(1)],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],100*[OccupPreMean(1) OccupPosPAGMean(1) OccupPosMFBMean(1)],100*[OccupPreMeanStd(1) OccupPosPAGMeanStd(1) OccupPosMFBMeanStd(1)]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

xlimits = xlim;

line(xlimits,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(Expe)
plot([1:3]+0.1,100*[OccupPre(1,i) OccupPosPAG(1,i) OccupPosMFB(1,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
ylim(y_range_bar);
title('Shock zone occupancy during reversal experiment');


subplot(2,3,4)
bar([1 2],100*[OccupPreMean(1) OccupPreMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPreMean(1) OccupPreMean(2)],100*[OccupPreMeanStd(1) OccupPreMeanStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Pre Tests');
ylim(y_range_bar);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(Expe)
plot([1 2]+0.1,100*[OccupPre(1,i) OccupPre(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

subplot(2,3,2)

bar([1 2],100*[OccupPAGMean(1) OccupPAGMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPAGMean(1) OccupPAGMean(2)],100*[OccupPAGMeanStd(1) OccupPAGMeanStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy PAG conditioning');
ylim(y_range_bar);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(Expe)
plot([1 2]+0.1,100*[OccupPAG(1,i) OccupPAG(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

subplot(2,3,5)

bar([1 2],100*[OccupPosPAGMean(1) OccupPosPAGMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPosPAGMean(1) OccupPosPAGMean(2)],100*[OccupPosPAGMeanStd(1) OccupPosPAGMeanStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Post PAG');
ylim(y_range_bar);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(Expe)
plot([1 2]+0.1,100*[OccupPosPAG(1,i) OccupPosPAG(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

subplot(2,3,3)

bar([1 2],100*[OccupMFBMean(1) OccupMFBMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupMFBMean(1) OccupMFBMean(2)],100*[OccupMFBMeanStd(1) OccupMFBMeanStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy MFB conditioning');
ylim(y_range_bar);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(Expe)
plot([1 2]+0.1,100*[OccupMFB(1,i) OccupMFB(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

subplot(2,3,6)

bar([1 2],100*[OccupPosMFBMean(1) OccupPosMFBMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPosMFBMean(1) OccupPosMFBMean(2)],100*[OccupPosMFBMeanStd(1) OccupPosMFBMeanStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Post MFB');
ylim(y_range_bar);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(Expe)
plot([1 2]+0.1,100*[OccupPosMFB(1,i) OccupPosMFB(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

%% Density map

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.8 0.8 0 0]';
ShockZone = [0 0.35 0.35 0 0;0 0 0.4 0.4 0]';

TrajPreCat = TrajPreCat(all(~isnan(TrajPreCat),2),:);
TrajPosPAGCat = TrajPosPAGCat(all(~isnan(TrajPosPAGCat),2),:);
TrajPosMFBCat = TrajPosMFBCat(all(~isnan(TrajPosMFBCat),2),:);

TrajPreCatControl = TrajPreCatControl(all(~isnan(TrajPreCatControl),2),:);
TrajPosPAGCatControl = TrajPosPAGCatControl(all(~isnan(TrajPosPAGCatControl),2),:);
TrajPosMFBCatControl = TrajPosMFBCatControl(all(~isnan(TrajPosMFBCatControl),2),:);

zmax = 0.2;
linecolorint = 0.05;

figure
subplot(2,3,1)
[occH, x1, x2] = hist2(TrajPreCat(:,1), TrajPreCat(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=[0 1];
        y=[0 1];
        imagesc(x,y,occHS)
        caxis([0 zmax]) % control color intensity here
        colormap(hot)
        hold on
        plot(Maze(:,1),Maze(:,2),'w','linewidth',2)
        plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
        for i = 1:numel(Expe)
            for j = 1:4
                pl=plot(TrajPreTrials{i,j}(:,1),TrajPreTrials{i,j}(:,2), 'w', 'linewidth',.05);
                pl.Color(4) = linecolorint;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'YDir', 'normal');
        title(['Pre-tests - Reversal N = ',num2str(numel(Expe))]);

subplot(2,3,2)
[occH, x1, x2] = hist2(TrajPosPAGCat(:,1), TrajPosPAGCat(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=[0 1];
        y=[0 1];
        imagesc(x,y,occHS)
        caxis([0 zmax]) % control color intensity here
        colormap(hot)
        hold on
        plot(Maze(:,1),Maze(:,2),'w','linewidth',2)
        plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
        for i = 1:numel(Expe)
            for j = 1:4
                pl=plot(TrajPosPAGTrials{i,j}(:,1),TrajPosPAGTrials{i,j}(:,2), 'w', 'linewidth',.05);
                pl.Color(4) = linecolorint;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'YDir', 'normal');
        title(['Post-PAG Tests - Reversal N = ',num2str(numel(Expe))]);
        
subplot(2,3,3)
[occH, x1, x2] = hist2(TrajPosMFBCat(:,1), TrajPosMFBCat(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=[0 1];
        y=[0 1];
        imagesc(x,y,occHS)
        caxis([0 zmax]) % control color intensity here
        colormap(hot)
        hold on
        plot(Maze(:,1),Maze(:,2),'w','linewidth',2)
        plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
        for i = 1:numel(Expe)
            for j = 1:4
                pl=plot(TrajPosMFBTrials{i,j}(:,1),TrajPosMFBTrials{i,j}(:,2), 'w', 'linewidth',.05);
                pl.Color(4) = linecolorint;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'YDir', 'normal');
        title(['Post-MFB Tests - Reversal N = ',num2str(numel(Expe))]);
        
subplot(2,3,4)
[occH, x1, x2] = hist2(TrajPreCatControl(:,1), TrajPreCatControl(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=[0 1];
        y=[0 1];
        imagesc(x,y,occHS)
        caxis([0 zmax]) % control color intensity here
        colormap(hot)
        hold on
        plot(Maze(:,1),Maze(:,2),'w','linewidth',2)
        plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
        for i = 1:numel(Control)
            for j = 1:4
                pl=plot(TrajPreTrialsControl{i,j}(:,1),TrajPreTrialsControl{i,j}(:,2), 'w', 'linewidth',.05);
                pl.Color(4) = linecolorint;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'YDir', 'normal');
        title(['Pre-tests - Reversal Control N = ',num2str(numel(Control))]);
   
        
subplot(2,3,5)
[occH, x1, x2] = hist2(TrajPosPAGCatControl(:,1), TrajPosPAGCatControl(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=[0 1];
        y=[0 1];
        imagesc(x,y,occHS)
        caxis([0 zmax]) % control color intensity here
        colormap(hot)
        hold on
        plot(Maze(:,1),Maze(:,2),'w','linewidth',2)
        plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
        for i = 1:numel(Control)
            for j = 1:4
                pl=plot(TrajPosPAGTrialsControl{i,j}(:,1),TrajPosPAGTrialsControl{i,j}(:,2), 'w', 'linewidth',.05);
                pl.Color(4) = linecolorint;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'YDir', 'normal');
        title(['Post-PAG Tests - Reversal Control N = ',num2str(numel(Control))]);
        
subplot(2,3,6)
[occH, x1, x2] = hist2(TrajPosMFBCatControl(:,1), TrajPosMFBCatControl(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=[0 1];
        y=[0 1];
        imagesc(x,y,occHS)
        caxis([0 zmax]) % control color intensity here
        colormap(hot)
        hold on
        plot(Maze(:,1),Maze(:,2),'w','linewidth',2)
        plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
        for i = 1:numel(Control)
            for j = 1:4
                pl=plot(TrajPosMFBTrialsControl{i,j}(:,1),TrajPosMFBTrialsControl{i,j}(:,2), 'w', 'linewidth',.05);
                pl.Color(4) = linecolorint;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca, 'YDir', 'normal');
        title(['Post-MFB Tests - Reversal Control N = ',num2str(numel(Control))]);

%% Speed

ColorMice = 1;

SpeedShockPreMean=nanmean(SpeedShockPre);
SpeedShockPreMeanStd=nanstd(SpeedShockPre);

SpeedSafePreMean=nanmean(SpeedSafePre);
SpeedSafePreMeanStd=nanstd(SpeedSafePre);

SpeedShockPosPAGMean=nanmean(SpeedShockPosPAG);
SpeedShockPosPAGMeanStd=nanstd(SpeedShockPosPAG);

SpeedSafePosPAGMean=nanmean(SpeedSafePosPAG);
SpeedSafePosPAGMeanStd=nanstd(SpeedSafePosPAG);

SpeedShockPosMFBMean=nanmean(SpeedShockPosMFB);
SpeedShockPosMFBMeanStd=nanstd(SpeedShockPosMFB);

SpeedSafePosMFBMean=nanmean(SpeedSafePosMFB);
SpeedSafePosMFBMeanStd=nanstd(SpeedSafePosMFB);

SpeedShockPreMeanControl=nanmean(SpeedShockPreControl);
SpeedShockPreMeanStdControl=nanstd(SpeedShockPreControl);

SpeedSafePreMeanControl=nanmean(SpeedSafePreControl);
SpeedSafePreMeanStdControl=nanstd(SpeedSafePreControl);

SpeedShockPosPAGMeanControl=nanmean(SpeedShockPosPAGControl);
SpeedShockPosPAGMeanStdControl=nanstd(SpeedShockPosPAGControl);

SpeedSafePosPAGMeanControl=nanmean(SpeedSafePosPAGControl);
SpeedSafePosPAGMeanStdControl=nanstd(SpeedSafePosPAGControl);

SpeedShockPosMFBMeanControl=nanmean(SpeedShockPosMFBControl);
SpeedShockPosMFBMeanStdControl=nanstd(SpeedShockPosMFBControl);

SpeedSafePosMFBMeanControl=nanmean(SpeedSafePosMFBControl);
SpeedSafePosMFBMeanStdControl=nanstd(SpeedSafePosMFBControl);


figure

subplot(2,2,1)
bar([1 2 3],[SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean]...
    ,'k','HandleVisibility','off')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2,3],[SpeedShockPreMean SpeedShockPosPAGMean...
    SpeedShockPosMFBMean],[SpeedShockPreMeanStd SpeedShockPosPAGMeanStd...
    SpeedShockPosMFBMeanStd],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed in shock zone during Reversal Experiment');
ylim([0 7.5]);

SpeedShockPosPAGZeroes=SpeedShockPosPAG;
SpeedShockPosPAGZeroes(isnan(SpeedShockPosPAGZeroes))= 0;

if ColorMice == 1
    for i=1:numel(Expe)
        plot([1:3]+0.1,[SpeedShockPre(i) SpeedShockPosPAGZeroes(i)...
            SpeedShockPosMFB(i)],'linestyle','-','linewidth',1.2,...
            'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
            'DisplayName',MouseName{i});
    end
    legend show
    
else
   for i=1:numel(Expe)
    plot([1:3]+0.1,[SpeedShockPre(i) SpeedShockPosPAGZeroes(i)...
        SpeedShockPosMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-',...
        'marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
   end 
end

text(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean...
    SpeedShockPosMFBMean])),ones(length(find(isnan([SpeedShockPreMean ...
    SpeedShockPosPAGMean SpeedShockPosMFBMean])))),...
    {'No entries', 'in this zone'},'Color','red','vert','bottom',...
    'horiz','center','FontSize',8, 'FontWeight','bold')

subplot(2,2,3)
bar([1 2 3],[SpeedSafePreMean SpeedSafePosPAGMean SpeedSafePosMFBMean]...
    ,'k','HandleVisibility','off')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2,3],[SpeedSafePreMean SpeedSafePosPAGMean...
    SpeedSafePosMFBMean],[SpeedSafePreMeanStd SpeedSafePosPAGMeanStd...
    SpeedSafePosMFBMeanStd],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed in safe zone during Reversal Experiment');
ylim([0 7.5]);

SpeedSafePosPAGZeroes=SpeedSafePosPAG;
SpeedSafePosPAGZeroes(isnan(SpeedSafePosPAGZeroes))= 0;

if ColorMice == 1
    for i=1:numel(Expe)
        plot([1:3]+0.1,[SpeedSafePre(i) SpeedSafePosPAGZeroes(i)...
            SpeedSafePosMFB(i)],'linestyle','-','linewidth',1.2,...
            'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
            'DisplayName',MouseName{i});
    end
    legend show
    
else
   for i=1:numel(Expe)
    plot([1:3]+0.1,[SpeedSafePre(i) SpeedSafePosPAGZeroes(i)...
        SpeedSafePosMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-',...
        'marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
   end 
end


text(find(isnan([SpeedSafePreMean SpeedSafePosPAGMean...
    SpeedSafePosMFBMean])),ones(length(find(isnan([SpeedSafePreMean...
    SpeedSafePosPAGMean SpeedSafePosMFBMean])))),...
    {'No entries', 'in this zone'},'Color','red','vert',...
    'bottom','horiz','center','FontSize',8, 'FontWeight','bold')

subplot(2,2,2)
bar([1 2 3],[SpeedShockPreMeanControl SpeedShockPosPAGMeanControl SpeedShockPosMFBMeanControl]...
    ,'k','HandleVisibility','off')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2,3],[SpeedShockPreMeanControl SpeedShockPosPAGMeanControl...
    SpeedShockPosMFBMeanControl],[SpeedShockPreMeanStdControl SpeedShockPosPAGMeanStdControl...
    SpeedShockPosMFBMeanStdControl],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed in shock zone during Reversal Control Experiment');
ylim([0 7.5]);

SpeedShockPosPAGZeroesControl=SpeedShockPosPAGControl;
SpeedShockPosPAGZeroesControl(isnan(SpeedShockPosPAGZeroesControl))= 0;

if ColorMice == 1
    for i=1:numel(Control)
        plot([1:3]+0.1,[SpeedShockPreControl(i) SpeedShockPosPAGZeroesControl(i)...
            SpeedShockPosMFBControl(i)],'linestyle','-','linewidth',1.2,...
            'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
            'DisplayName',MouseNameControl{i});
    end
    legend show
    
else
   for i=1:numel(Control)
    plot([1:3]+0.1,[SpeedShockPreControl(i) SpeedShockPosPAGZeroesControl(i)...
        SpeedShockPosMFBControl(i)],'color',[0.6 0.6 0.6],'linestyle','-',...
        'marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
   end 
end

text(find(isnan([SpeedShockPreMeanControl SpeedShockPosPAGMeanControl...
    SpeedShockPosMFBMeanControl])),ones(length(find(isnan([SpeedShockPreMeanControl ...
    SpeedShockPosPAGMeanControl SpeedShockPosMFBMeanControl])))),...
    {'No entries', 'in this zone'},'Color','red','vert','bottom',...
    'horiz','center','FontSize',8, 'FontWeight','bold')

subplot(2,2,4)
bar([1 2 3],[SpeedSafePreMeanControl SpeedSafePosPAGMeanControl SpeedSafePosMFBMeanControl]...
    ,'k','HandleVisibility','off')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2,3],[SpeedSafePreMeanControl SpeedSafePosPAGMeanControl...
    SpeedSafePosMFBMeanControl],[SpeedSafePreMeanStdControl SpeedSafePosPAGMeanStdControl...
    SpeedSafePosMFBMeanStdControl],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed in safe zone during Reversal Control Experiment');
ylim([0 7.5]);

SpeedSafePosPAGZeroesControl=SpeedSafePosPAGControl;
SpeedSafePosPAGZeroesControl(isnan(SpeedSafePosPAGZeroesControl))= 0;

if ColorMice == 1
    for i=1:numel(Control)
        plot([1:3]+0.1,[SpeedSafePreControl(i) SpeedSafePosPAGZeroesControl(i)...
            SpeedSafePosMFBControl(i)],'linestyle','-','linewidth',1.2,...
            'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
            'DisplayName',MouseNameControl{i});
    end
    legend show
    
else
   for i=1:numel(Control)
    plot([1:3]+0.1,[SpeedSafePreControl(i) SpeedSafePosPAGZeroesControl(i)...
        SpeedSafePosMFBControl(i)],'color',[0.6 0.6 0.6],'linestyle','-',...
        'marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
   end 
end


text(find(isnan([SpeedSafePreMeanControl SpeedSafePosPAGMeanControl...
    SpeedSafePosMFBMeanControl])),ones(length(find(isnan([SpeedSafePreMeanControl...
    SpeedSafePosPAGMeanControl SpeedSafePosMFBMeanControl])))),...
    {'No entries', 'in this zone'},'Color','red','vert',...
    'bottom','horiz','center','FontSize',8, 'FontWeight','bold')



%% Speed trajectories

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.85 0.85 0 0]';
ShockZone = [0 0.35 0.35 0 0;0 0 0.3 0.3 0]';
LineTraj = 1.8;

y_range=[0 1];
x_range=[0 1];

figure
subplot(2,3,1)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPreTrials{i,j}(:,1);  % X data
                y = TrajPreTrials{i,j}(:,2);  % Y data
                z = SpeedPreTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title(['Speed during Pre-tests - Reversal N = ',num2str(numel(Expe))])

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,2)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPosPAGTrials{i,j}(:,1);  % X data
                y = TrajPosPAGTrials{i,j}(:,2);  % Y data
                z = SpeedPosPAGTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title(['Speed during Post PAG - Reversal N = ',num2str(numel(Expe))])

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,3)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPosMFBTrials{i,j}(:,1);  % X data
                y = TrajPosMFBTrials{i,j}(:,2);  % Y data
                z = SpeedPosMFBTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title(['Speed during Post MFB - Reversal N = ',num2str(numel(Expe))])

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,4)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPreTrialsControl{i,j}(:,1);  % X data
                y = TrajPreTrialsControl{i,j}(:,2);  % Y data
                z = SpeedPreTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title(['Speed during Pre-tests - Reversal Control N = ',num2str(numel(Control))])

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,5)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPosPAGTrialsControl{i,j}(:,1);  % X data
                y = TrajPosPAGTrialsControl{i,j}(:,2);  % Y data
                z = SpeedPosPAGTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title(['Speed during Post PAG - Reversal Control N = ',num2str(numel(Control))])

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,6)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPosMFBTrialsControl{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsControl{i,j}(:,2);  % Y data
                z = SpeedPosMFBTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title(['Speed during Post MFB - Reversal Control N = ',num2str(numel(Control))])

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);


%% Speed trajectories Towards Shock Zone

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.85 0.85 0 0]';
ShockZone = [0 0.35 0.35 0 0;0 0 0.3 0.3 0]';
LineTraj = 1.8;

y_range=[0 1];
x_range=[0 1];

for i = 1:numel(Expe)
    for j = 1:4
       [TrajPreTrialsTowards{i,j},TrajPreTrialsAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPreTrials{i,j});

       [TrajPosPAGTrialsTowards{i,j},TrajPosPAGTrialsAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPosPAGTrials{i,j});

       [TrajPosMFBTrialsTowards{i,j},TrajPosMFBTrialsAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPosMFBTrials{i,j});
    end
end

for i = 1:numel(Control)
    for j = 1:4
       [TrajPreTrialsControlTowards{i,j},TrajPreTrialsControlAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPreTrialsControl{i,j});

       [TrajPosPAGTrialsControlTowards{i,j},TrajPosPAGTrialsControlAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPosPAGTrialsControl{i,j});

       [TrajPosMFBTrialsControlTowards{i,j},TrajPosMFBTrialsControlAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPosMFBTrialsControl{i,j});
    end
end

% Experiment
figure
subplot(2,3,1)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPreTrialsTowards{i,j}(:,1);  % X data
                y = TrajPreTrialsTowards{i,j}(:,2);  % Y data
                z = SpeedPreTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Pre-Tests Towards Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,2)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPosPAGTrialsTowards{i,j}(:,1);  % X data
                y = TrajPosPAGTrialsTowards{i,j}(:,2);  % Y data
                z = SpeedPosPAGTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Post PAG Towards Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,3)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPosMFBTrialsTowards{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsTowards{i,j}(:,2);  % Y data
                z = SpeedPosMFBTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Post MFB Towards Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,4)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPreTrialsAway{i,j}(:,1);  % X data
                y = TrajPreTrialsAway{i,j}(:,2);  % Y data
                z = SpeedPreTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Pre-tests Away From Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,5)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPosPAGTrialsAway{i,j}(:,1);  % X data
                y = TrajPosPAGTrialsAway{i,j}(:,2);  % Y data
                z = SpeedPosPAGTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Post PAG Away From Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,6)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPosMFBTrialsAway{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsAway{i,j}(:,2);  % Y data
                z = SpeedPosMFBTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Post MFB Away From Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

annotation('textbox', [0 0.9 1 0.1],'String'...
    ,['Reversal Experiment N = ',num2str(numel(Expe))],'EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')

% Control
figure
subplot(2,3,1)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPreTrialsControlTowards{i,j}(:,1);  % X data
                y = TrajPreTrialsControlTowards{i,j}(:,2);  % Y data
                z = SpeedPreTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Pre-tests Towards Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,2)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPosPAGTrialsControlTowards{i,j}(:,1);  % X data
                y = TrajPosPAGTrialsControlTowards{i,j}(:,2);  % Y data
                z = SpeedPosPAGTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Post-PAG Tests Towards Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,3)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPosMFBTrialsControlTowards{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsControlTowards{i,j}(:,2);  % Y data
                z = SpeedPosMFBTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Post-MFB Tests Towards Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,4)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPreTrialsControlAway{i,j}(:,1);  % X data
                y = TrajPreTrialsControlAway{i,j}(:,2);  % Y data
                z = SpeedPreTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Pre-tests Away From Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,5)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPosPAGTrialsControlAway{i,j}(:,1);  % X data
                y = TrajPosPAGTrialsControlAway{i,j}(:,2);  % Y data
                z = SpeedPosPAGTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Post-PAG Tests Away From Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,6)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPosMFBTrialsControlAway{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsControlAway{i,j}(:,2);  % Y data
                z = SpeedPosMFBTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Post-MFB Tests Away From Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

annotation('textbox', [0 0.9 1 0.1],'String'...
    ,['Reversal Control Experiment N = ',num2str(numel(Control))],'EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')


%% Speed trajectories Post MFB

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.85 0.85 0 0]';
ShockZone = [0 0.35 0.35 0 0;0 0 0.4 0.4 0]';
LineTraj = 1.8;

y_range=[0 1];
x_range=[0 1];

for i = 1:numel(Expe)
    for j = 1:4
       [TrajPreTrialsTowards{i,j},TrajPreTrialsAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPreTrials{i,j});

       [TrajPosPAGTrialsTowards{i,j},TrajPosPAGTrialsAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPosPAGTrials{i,j});

       [TrajPosMFBTrialsTowards{i,j},TrajPosMFBTrialsAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPosMFBTrials{i,j});
    end
end

for i = 1:numel(Control)
    for j = 1:4
       [TrajPreTrialsControlTowards{i,j},TrajPreTrialsControlAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPreTrialsControl{i,j});

       [TrajPosPAGTrialsControlTowards{i,j},TrajPosPAGTrialsControlAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPosPAGTrialsControl{i,j});

       [TrajPosMFBTrialsControlTowards{i,j},TrajPosMFBTrialsControlAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPosMFBTrialsControl{i,j});
    end
end

figure
subplot(2,3,1)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPosMFBTrials{i,j}(:,1);  % X data
                y = TrajPosMFBTrials{i,j}(:,2);  % Y data
                z = SpeedPosMFBTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title(['All Trajectories - Reversal N = ',num2str(numel(Expe))])

% hcb = colorbar; 
% set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);


subplot(2,3,2)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPosMFBTrialsTowards{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsTowards{i,j}(:,2);  % Y data
                z = SpeedPosMFBTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Reversal - Trajectories Towards Shock')

% hcb = colorbar; 
% set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,3)
hold on
for i = 1:numel(Expe)
            for j = 1:4
                x = TrajPosMFBTrialsAway{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsAway{i,j}(:,2);  % Y data
                z = SpeedPosMFBTraj{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Reversal - Trajectories Away From Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);


subplot(2,3,4)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPosMFBTrialsControl{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsControl{i,j}(:,2);  % Y data
                z = SpeedPosMFBTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title(['All Trajectories - Reversal Control N = ',num2str(numel(Control))])

% hcb = colorbar; 
% set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,5)
hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPosMFBTrialsControlTowards{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsControlTowards{i,j}(:,2);  % Y data
                z = SpeedPosMFBTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Control - Trajectories Towards Shock')

% hcb = colorbar; 
% set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);


subplot(2,3,6)

hold on
for i = 1:numel(Control)
            for j = 1:4
                x = TrajPosMFBTrialsControlAway{i,j}(:,1);  % X data
                y = TrajPosMFBTrialsControlAway{i,j}(:,2);  % Y data
                z = SpeedPosMFBTrajControl{i,j};                
                surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', LineTraj);            % Make a thicker line
 
            end
        end

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Control - Trajectories Away From Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

annotation('textbox', [0 0.9 1 0.1],'String'...
    ,'Post-MFB tests','EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')
%% Number of entries in shock zone

ymax = 6;

ColorMice = 1;

NumEntPreMean=mean(NumEntPre);
NumEntPreMeanStd=std(NumEntPre);

NumEntPosPAGMean=mean(NumEntPosPAG);
NumEntPosPAGMeanStd=std(NumEntPosPAG);

NumEntPosMFBMean=mean(NumEntPosMFB);
NumEntPosMFBMeanStd=std(NumEntPosMFB);

NumEntPreMeanControl=mean(NumEntPreControl);
NumEntPreMeanStdControl=std(NumEntPreControl);

NumEntPosPAGMeanControl=mean(NumEntPosPAGControl);
NumEntPosPAGMeanStdControl=std(NumEntPosPAGControl);

NumEntPosMFBMeanControl=mean(NumEntPosMFBControl);
NumEntPosMFBMeanStdControl=std(NumEntPosMFBControl);


OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

figure
subplot(1,2,1)
bar([1:3],[NumEntPreMean NumEntPosPAGMean NumEntPosMFBMean]...
    ,'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[NumEntPreMean NumEntPosPAGMean...
    NumEntPosMFBMean],[NumEntPreMeanStd NumEntPosPAGMeanStd...
    NumEntPosMFBMeanStd],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

if ColorMice == 1
    for i=1:numel(Expe)
    plot([1:3]+0.1,[NumEntPre(i) NumEntPosPAG(i)...
        NumEntPosMFB(i)],'linestyle','-','linewidth',1.2,...
        'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
        'DisplayName',MouseName{i});
    end  
    legend show
else
    for i=1:numel(Expe)
    plot([1:3]+0.1,[NumEntPre(i) NumEntPosPAG(i)...
        NumEntPosMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-',...
        'marker','o','MarkerEdgeColor', [0.5 0.5 0.5]',...
        'MarkerFaceColor','w','MarkerSize',6);
    end
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('# of entries in shock zone - Reversal Experiment');

subplot(1,2,2)
bar([1:3],[NumEntPreMeanControl NumEntPosPAGMeanControl NumEntPosMFBMeanControl]...
    ,'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[NumEntPreMeanControl NumEntPosPAGMeanControl...
    NumEntPosMFBMeanControl],[NumEntPreMeanStdControl NumEntPosPAGMeanStdControl...
    NumEntPosMFBMeanStdControl],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

if ColorMice == 1
    for i=1:numel(Control)
    plot([1:3]+0.1,[NumEntPreControl(i) NumEntPosPAGControl(i)...
        NumEntPosMFBControl(i)],'linestyle','-','linewidth',1.2,...
        'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
        'DisplayName',MouseNameControl{i});
    end
    legend show

else
    for i=1:numel(Control)
    plot([1:3]+0.1,[NumEntPreControl(i) NumEntPosPAGControl(i)...
        NumEntPosMFBControl(i)],'color',[0.6 0.6 0.6],'linestyle','-',...
        'marker','o','MarkerEdgeColor', [0.5 0.5 0.5]',...
        'MarkerFaceColor','w','MarkerSize',6);
    end
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('# of entries in shock zone - Reversal Control Experiment');
%% Number of Stimulations

ymax = 300;
ColorMice = 1;

NumCondPAGMean = mean(NumCondPAG);
NumCondPAGStd = std(NumCondPAG);

NumCondMFBMean = mean(NumCondMFB);
NumCondMFBStd = std(NumCondMFB);

NumCondPAGMeanControl = mean(NumCondPAGControl);
NumCondPAGStdControl = std(NumCondPAGControl);

NumCondMFBMeanControl = mean(NumCondMFBControl);
NumCondMFBStdControl = std(NumCondMFBControl);

figure
subplot(1,2,1)
bar([1 2],[NumCondPAGMean NumCondMFBMean],'k','HandleVisibility','off')
set(gca,'xticklabel',{'PAG';'MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
ylabel('Stimulations count','fontweight','bold','fontsize',10);
title('# os stimulations during Reversal Experiment');
ylim([0 ymax]);
hold on
er = errorbar([1 2],[NumCondPAGMean NumCondMFBMean],...
    [NumCondPAGStd NumCondMFBStd],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

if ColorMice ==1
    for i=1:numel(Expe)
    plot([1 2]+0.1,[NumCondPAG(i) NumCondMFB(i)],'linestyle','-','linewidth',1.2,...
        'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
        'DisplayName',MouseName{i});
    end
    legend show
else
    for i=1:numel(Expe)
    plot([1 2]+0.1,[NumCondPAG(i) NumCondMFB(i)],'color',[0.6 0.6 0.6],...
        'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]',...
        'MarkerFaceColor','w','MarkerSize',6);
    end
end

subplot(1,2,2)
bar([1 2],[NumCondPAGMeanControl NumCondMFBMeanControl],'k','HandleVisibility','off')
set(gca,'xticklabel',{'PAG';'MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
ylabel('Stimulations count','fontweight','bold','fontsize',10);
title('# os stimulations during Reversal Control Experiment');
ylim([0 ymax]);
hold on
er = errorbar([1 2],[NumCondPAGMeanControl NumCondMFBMeanControl],...
    [NumCondPAGStdControl NumCondMFBStdControl],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

if ColorMice ==1
    for i=1:numel(Control)
    plot([1 2]+0.1,[NumCondPAGControl(i) NumCondMFBControl(i)],'linestyle','-','linewidth',1.2,...
        'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
        'DisplayName',MouseNameControl{i});
    end
    legend show
else
    for i=1:numel(Expe)
    plot([1 2]+0.1,[NumCondPAGControl(i) NumCondMFBControl(i)],'color',[0.6 0.6 0.6],...
        'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]',...
        'MarkerFaceColor','w','MarkerSize',6);
    end
end


%% Escape Latency

EscapeWallShockPAGMean=nanmean(EscapeWallShockPAG);
EscapeWallShockPAGMeanStd=nanstd(EscapeWallShockPAG);

EscapeWallShockMFBMean=nanmean(EscapeWallShockMFB);
EscapeWallShockMFBMeanStd=nanstd(EscapeWallShockMFB);

EscapeWallShockPAGMeanControl=nanmean(EscapeWallShockPAGControl);
EscapeWallShockPAGMeanStdControl=nanstd(EscapeWallShockPAGControl);

EscapeWallShockMFBMeanControl=nanmean(EscapeWallShockMFBControl);
EscapeWallShockMFBMeanStdControl=nanstd(EscapeWallShockMFBControl);

ymax = 70;

ColorMice = 1;

figure
subplot(1,2,1)
bar([1,2],[EscapeWallShockPAGMean EscapeWallShockMFBMean],'k','HandleVisibility','off')
set(gca,'xticklabel',{'PAG Cond','MFB Cond'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallShockPAGMean EscapeWallShockMFBMean]...
    ,[EscapeWallShockPAGMeanStd EscapeWallShockMFBMeanStd],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

if ColorMice == 1
    for i=1:numel(Expe)
    plot([1 2]+0.1,[EscapeWallShockPAG(i) EscapeWallShockMFB(i)],'linestyle','-','linewidth',1.2,...
        'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
        'DisplayName',MouseName{i});
    end
    legend show
else
    for i=1:numel(Expe)
    plot([1 2]+0.1,[EscapeWallShockPAG(i) EscapeWallShockMFB(i)],...
        'color',[0.6 0.6 0.6],'linestyle','-','marker',...
        'o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
    end
end

ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim([0,ymax]);
title('Shock Zone Escape Latency - Reversal Experiment');

subplot(1,2,2)
bar([1,2],[EscapeWallShockPAGMeanControl EscapeWallShockMFBMeanControl],'k','HandleVisibility','off')
set(gca,'xticklabel',{'PAG Cond','MFB Cond'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallShockPAGMeanControl EscapeWallShockMFBMeanControl]...
    ,[EscapeWallShockPAGMeanStdControl EscapeWallShockMFBMeanStdControl],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

if ColorMice == 1
    for i=1:numel(Control)
    plot([1 2]+0.1,[EscapeWallShockPAGControl(i) EscapeWallShockMFBControl(i)],'linestyle','-','linewidth',1.2,...
        'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
        'DisplayName',MouseNameControl{i});
    end
    legend show
else
    for i=1:numel(Cotrol)
    plot([1 2]+0.1,[EscapeWallShockPAGControl(i) EscapeWallShockMFBControl(i)],...
        'color',[0.6 0.6 0.6],'linestyle','-','marker',...
        'o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
    end
end

ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim([0,ymax]);
title('Shock Zone Escape Latency - Reversal Control Experiment');


%% Dinamics of occupancy

OccupPreTrialsMean=mean(OccupPreTrials,3);
OccupPreTrialsStd=std(OccupPreTrials,0,3);

OccupPosPAGTrialsMean=mean(OccupPosPAGTrials,3);
OccupPosPAGTrialsStd=std(OccupPosPAGTrials,0,3);

OccupPosMFBTrialsMean=mean(OccupPosMFBTrials,3);
OccupPosMFBTrialsStd=std(OccupPosMFBTrials,0,3);

OccupPreTrialsMeanControl=mean(OccupPreTrialsControl,3);
OccupPreTrialsStdControl=std(OccupPreTrialsControl,0,3);

OccupPosPAGTrialsMeanControl=mean(OccupPosPAGTrialsControl,3);
OccupPosPAGTrialsStdControl=std(OccupPosPAGTrialsControl,0,3);

OccupPosMFBTrialsMeanControl=mean(OccupPosMFBTrialsControl,3);
OccupPosMFBTrialsStdControl=std(OccupPosMFBTrialsControl,0,3);


OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax = 70;
figure
subplot(3,1,1)
hb = bar([1:4],100*[OccupPreTrialsMean(1,:);OccupPreTrialsMeanControl(1,:)]','k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,100*[OccupPreTrialsMean(1,:);OccupPreTrialsMeanControl(1,:)]',...
    100*[OccupPreTrialsStd(1,:);OccupPreTrialsStdControl(1,:)]','HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,100*OccupPreTrials(1,:,i),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,100*OccupPreTrialsControl(1,:,i),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

aux = xlim;
line(xlim,[21.5 21.5],'Color',[0.6 0.6 0.6],'LineStyle','--','LineWidth',1.5,'HandleVisibility','off');
text(aux(1)+0.02,23.2,'random level', 'FontWeight','bold','FontSize',8,'FontAngle', 'italic','Color',[0.6 0.6 0.6]);
ylabel('Time spent (s)','fontweight','bold','fontsize',10);
ylim([0 50]);
title('Pre-tests');

subplot(3,1,2)
hb = bar([1:4],100*[OccupPosPAGTrialsMean(1,:);OccupPosPAGTrialsMeanControl(1,:)]','k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,100*[OccupPosPAGTrialsMean(1,:);OccupPosPAGTrialsMeanControl(1,:)]',...
    100*[OccupPosPAGTrialsStd(1,:);OccupPosPAGTrialsStdControl(1,:)]','HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,100*OccupPosPAGTrials(1,:,i),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,100*OccupPosPAGTrialsControl(1,:,i),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

aux = xlim;
line(xlim,[21.5 21.5],'Color',[0.6 0.6 0.6],'LineStyle','--','LineWidth',1.5,'HandleVisibility','off');
text(aux(1)+0.02,23.2,'random level', 'FontWeight','bold','FontSize',8,'FontAngle', 'italic','Color',[0.6 0.6 0.6]);
ylabel('Time spent (s)','fontweight','bold','fontsize',10);
ylim([0 50]);
title('Post-PAG tests');

subplot(3,1,3)
hb = bar([1:4],100*[OccupPosMFBTrialsMean(1,:);OccupPosMFBTrialsMeanControl(1,:)]','k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,100*[OccupPosMFBTrialsMean(1,:);OccupPosMFBTrialsMeanControl(1,:)]',...
    100*[OccupPosMFBTrialsStd(1,:);OccupPosMFBTrialsStdControl(1,:)]','HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,100*OccupPosMFBTrials(1,:,i),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,100*OccupPosMFBTrialsControl(1,:,i),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

aux = xlim;
line(xlim,[21.5 21.5],'Color',[0.6 0.6 0.6],'LineStyle','--','LineWidth',1.5,'HandleVisibility','off');
text(aux(1)+0.02,23.2,'random level', 'FontWeight','bold','FontSize',8,'FontAngle', 'italic','Color',[0.6 0.6 0.6]);
ylabel('Time spent (s)','fontweight','bold','fontsize',10);
ylim([0 65]);
title('Post-MFB tests');

annotation('textbox', [0 0.9 1 0.1],'String'...
    ,'Dynamics of shock zone Occupancy','EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')
%% Dinamics of entry number

NumEntPreTrialsMean=mean(NumEntPreTrials,2);
NumEntPreTrialsStd=std(NumEntPreTrials,0,2);

NumEntPosPAGTrialsMean=mean(NumEntPosPAGTrials,2);
NumEntPosPAGTrialsStd=std(NumEntPosPAGTrials,0,2);

NumEntPosMFBTrialsMean=mean(NumEntPosMFBTrials,2);
NumEntPosMFBTrialsStd=std(NumEntPosMFBTrials,0,2);

NumEntPreTrialsMeanControl=mean(NumEntPreTrialsControl,2);
NumEntPreTrialsStdControl=std(NumEntPreTrialsControl,0,2);

NumEntPosPAGTrialsMeanControl=mean(NumEntPosPAGTrialsControl,2);
NumEntPosPAGTrialsStdControl=std(NumEntPosPAGTrialsControl,0,2);

NumEntPosMFBTrialsMeanControl=mean(NumEntPosMFBTrialsControl,2);
NumEntPosMFBTrialsStdControl=std(NumEntPosMFBTrialsControl,0,2);


OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax = 5;
figure
subplot(3,1,1)
hb = bar([1:4],[NumEntPreTrialsMean,NumEntPreTrialsMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[NumEntPreTrialsMean,NumEntPreTrialsMeanControl],...
    [NumEntPreTrialsStd,NumEntPreTrialsStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,NumEntPreTrials,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,NumEntPreTrialsControl,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Pre-tests');

subplot(3,1,2)
hb = bar([1:4],[NumEntPosPAGTrialsMean,NumEntPosPAGTrialsMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[NumEntPosPAGTrialsMean,NumEntPosPAGTrialsMeanControl],...
    [NumEntPosPAGTrialsStd,NumEntPosPAGTrialsStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,NumEntPosPAGTrials,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,NumEntPosPAGTrialsControl,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Post-PAG tests');

subplot(3,1,3)
hb = bar([1:4],[NumEntPosMFBTrialsMean,NumEntPosMFBTrialsMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[NumEntPosMFBTrialsMean,NumEntPosMFBTrialsMeanControl],...
    [NumEntPosMFBTrialsStd,NumEntPosMFBTrialsStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,NumEntPosMFBTrials,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,NumEntPosMFBTrialsControl,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Post-MFB tests');

annotation('textbox', [0 0.9 1 0.1],'String'...
    ,'Dynamics of the number of entries in shock zone','EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')

%% Dynamics of first time to enter

FirstTimeShockPreTrialsMean=mean(FirstTimeShockPreTrials,2);
FirstTimeShockPreTrialsStd=std(FirstTimeShockPreTrials,0,2);

FirstTimeShockPosPAGTrialsMean=mean(FirstTimeShockPosPAGTrials,2);
FirstTimeShockPosPAGTrialsStd=std(FirstTimeShockPosPAGTrials,0,2);

FirstTimeShockPosMFBTrialsMean=mean(FirstTimeShockPosMFBTrials,2);
FirstTimeShockPosMFBTrialsStd=std(FirstTimeShockPosMFBTrials,0,2);

FirstTimeShockPreTrialsMeanControl=mean(FirstTimeShockPreTrialsControl,2);
FirstTimeShockPreTrialsStdControl=std(FirstTimeShockPreTrialsControl,0,2);

FirstTimeShockPosPAGTrialsMeanControl=mean(FirstTimeShockPosPAGTrialsControl,2);
FirstTimeShockPosPAGTrialsStdControl=std(FirstTimeShockPosPAGTrialsControl,0,2);

FirstTimeShockPosMFBTrialsMeanControl=mean(FirstTimeShockPosMFBTrialsControl,2);
FirstTimeShockPosMFBTrialsStdControl=std(FirstTimeShockPosMFBTrialsControl,0,2);


OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax = 140;
figure
subplot(3,1,1)
hb = bar([1:4],[FirstTimeShockPreTrialsMean,FirstTimeShockPreTrialsMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[FirstTimeShockPreTrialsMean,FirstTimeShockPreTrialsMeanControl],...
    [FirstTimeShockPreTrialsStd,FirstTimeShockPreTrialsStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,FirstTimeShockPreTrials,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,FirstTimeShockPreTrialsControl,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

xrange = xlim;
line(xrange,[120,120],'Color','red','LineWidth',2,'HandleVisibility','off')
text(xrange(1),114,' no entries during test','Color','red','FontSize',8, 'FontWeight','bold','FontAngle', 'italic')

ylabel('Time of entry (s)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Pre-tests');

subplot(3,1,2)
hb = bar([1:4],[FirstTimeShockPosPAGTrialsMean,FirstTimeShockPosPAGTrialsMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[FirstTimeShockPosPAGTrialsMean,FirstTimeShockPosPAGTrialsMeanControl],...
    [FirstTimeShockPosPAGTrialsStd,FirstTimeShockPosPAGTrialsStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,FirstTimeShockPosPAGTrials,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,FirstTimeShockPosPAGTrialsControl,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

xrange = xlim;
line(xrange,[120,120],'Color','red','LineWidth',2,'HandleVisibility','off')
text(xrange(1),114,' no entries during test','Color','red','FontSize',8, 'FontWeight','bold','FontAngle', 'italic')

ylabel('Time of entry (s)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Post-PAG tests');

subplot(3,1,3)
hb = bar([1:4],[FirstTimeShockPosMFBTrialsMean,FirstTimeShockPosMFBTrialsMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[FirstTimeShockPosMFBTrialsMean,FirstTimeShockPosMFBTrialsMeanControl],...
    [FirstTimeShockPosMFBTrialsStd,FirstTimeShockPosMFBTrialsStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,FirstTimeShockPosMFBTrials,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,FirstTimeShockPosMFBTrialsControl,'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

xrange = xlim;
line(xrange,[120,120],'Color','red','LineWidth',2,'HandleVisibility','off')
text(xrange(1),114,' no entries during test','Color','red','FontSize',8, 'FontWeight','bold','FontAngle', 'italic')

ylabel('Time of entry (s)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Post-MFB tests');

annotation('textbox', [0 0.9 1 0.1],'String'...
    ,'Dynamics of first time to enter shock zone','EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')

%% Dinamics of safe zone speed

SpeedSafePreTrialsAvg = cellfun(@nanmean,SpeedSafePreTrials); 
SpeedSafePosPAGTrialsAvg = cellfun(@nanmean,SpeedSafePosPAGTrials);
SpeedSafePosMFBTrialsAvg = cellfun(@nanmean,SpeedSafePosMFBTrials);
SpeedSafePreTrialsControlAvg = cellfun(@nanmean,SpeedSafePreTrialsControl);
SpeedSafePosPAGTrialsControlAvg = cellfun(@nanmean,SpeedSafePosPAGTrialsControl);
SpeedSafePosMFBTrialsControlAvg = cellfun(@nanmean,SpeedSafePosMFBTrialsControl);


SpeedSafePreTrialsMean=nanmean(SpeedSafePreTrialsAvg,1);
SpeedSafePreTrialsStd=std(SpeedSafePreTrialsAvg,0,1);

SpeedSafePosPAGTrialsMean=nanmean(SpeedSafePosPAGTrialsAvg,1);
SpeedSafePosPAGTrialsStd=std(SpeedSafePosPAGTrialsAvg,0,1);

SpeedSafePosMFBTrialsMean=nanmean(SpeedSafePosMFBTrialsAvg,1);
SpeedSafePosMFBTrialsStd=std(SpeedSafePosMFBTrialsAvg,0,1);

SpeedSafePreTrialsMeanControl=nanmean(SpeedSafePreTrialsControlAvg,1);
SpeedSafePreTrialsStdControl=std(SpeedSafePreTrialsControlAvg,0,1);

SpeedSafePosPAGTrialsMeanControl=nanmean(SpeedSafePosPAGTrialsControlAvg,1);
SpeedSafePosPAGTrialsStdControl=std(SpeedSafePosPAGTrialsControlAvg,0,1);

SpeedSafePosMFBTrialsMeanControl=nanmean(SpeedSafePosMFBTrialsControlAvg,1);
SpeedSafePosMFBTrialsStdControl=std(SpeedSafePosMFBTrialsControlAvg,0,1);


OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax = 10;
figure
subplot(3,1,1)
hb = bar([1:4],[SpeedSafePreTrialsMean;SpeedSafePreTrialsMeanControl]','k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[SpeedSafePreTrialsMean;SpeedSafePreTrialsMeanControl]',...
    [SpeedSafePreTrialsStd;SpeedSafePreTrialsStdControl]','HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,SpeedSafePreTrialsAvg(i,:),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,SpeedSafePreTrialsControlAvg(i,:),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Pre-tests');

subplot(3,1,2)
hb = bar([1:4],[SpeedSafePosPAGTrialsMean;SpeedSafePosPAGTrialsMeanControl]','k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[SpeedSafePosPAGTrialsMean;SpeedSafePosPAGTrialsMeanControl]',...
    [SpeedSafePosPAGTrialsStd;SpeedSafePosPAGTrialsStdControl]','HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,SpeedSafePosPAGTrialsAvg(i,:),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,SpeedSafePosPAGTrialsControlAvg(i,:),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Post-PAG tests');

subplot(3,1,3)
hb = bar([1:4],[SpeedSafePosMFBTrialsMean;SpeedSafePosMFBTrialsMeanControl]','k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[SpeedSafePosMFBTrialsMean;SpeedSafePosMFBTrialsMeanControl]',...
    [SpeedSafePosMFBTrialsStd;SpeedSafePosMFBTrialsStdControl]','HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+0.01,SpeedSafePosMFBTrialsAvg(i,:),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.01,SpeedSafePosMFBTrialsControlAvg(i,:),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Post-MFB tests');

annotation('textbox', [0 0.9 1 0.1],'String'...
    ,'Dynamics of the speed in the safe zone','EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')

