%% Get Data
clear all
SingleMiceFolder = '/home/vador/Documents/Marcelo/Results/SleepImportance/SingleMiceData';
cd(SingleMiceFolder)
D = dir;
D = D(~ismember({D.name}, {'.', '..'}));
Mice2Use = logical([0 1 1 1 1 0]); % [863 913 923 934 935 938], put ones in the positions of mice to be used in analysis
D = D(Mice2Use);

for k = 1:numel(D)
    load(D(k).name);
    MouseName{k} = MouseData.MouseName;
    
    if k == 1
        TrajPreCat = MouseData.TrajPre;
        TrajPreTrials = MouseData.TrajPreTrials;
        TrajPosPAGCat = MouseData.TrajPosPAG;
        TrajPosPAGTrials = MouseData.TrajPosPAGTrials;
        SpeedPreTraj = MouseData.SpeedPreTraj;
        SpeedPosPAGTraj = MouseData.SpeedPosPAGTraj;

    
    else
        TrajPreCat = cat(1,TrajPreCat,MouseData.TrajPre);
        TrajPreTrials(k,:) = MouseData.TrajPreTrials;
        TrajPosPAGCat = cat(1,TrajPosPAGCat,MouseData.TrajPosPAG);
        TrajPosPAGTrials(k,:) = MouseData.TrajPosPAGTrials;
        SpeedPreTraj(k,:) = MouseData.SpeedPreTraj;
        SpeedPosPAGTraj(k,:) = MouseData.SpeedPosPAGTraj;
    end
    
    OccupPreTrials(:,:,k) = MouseData.OccupPre;
    OccupPosPAGTrials(:,:,k) = MouseData.OccupPosPAG;
    OccupPre(:,k) = MouseData.OccupPreMean;
    OccupPreStd(:,k) = MouseData.OccupPreStd;
    OccupPosPAG(:,k) = MouseData.OccupPosPAGMean;
    OccupPosPAGStd(:,k) = MouseData.OccupPosPAGStd;
    OccupPAG(:,k) = MouseData.OccupPAGMean;
    OccupPAGStd(:,k) = MouseData.OccupPAGStd;
    NumEntPreTrials(:,k) = MouseData.NumEntPre;
    NumEntPosPAGTrials(:,k) = MouseData.NumEntPosPAG;
    NumEntPre(k) = MouseData.NumEntPreMean;
    NumEntPreStd(k) = MouseData.NumEntPreStd;
    NumEntPosPAG(k) = MouseData.NumEntPosPAGMean;
    NumEntPosPAGStd(k) = MouseData.NumEntPosPAGStd;
    NumCondPAG(k) = MouseData.NumCondPAG;
    FirstTimeShockPreTrials(:,k) = MouseData.FirstTimeShockPre;
    FirstTimeShockPosPAGTrials(:,k) = MouseData.FirstTimeShockPosPAG;
    FirstTimeShockProbe(k) = MouseData.FirstTimeShockProbe;
    FirstTimeShockPre(k) = MouseData.FirstTimeShockPreMean;
    FirstTimeShockPreStd(k) = MouseData.FirstTimeShockPreStd;
    FirstTimeShockPosPAG(k) = MouseData.FirstTimeShockPosPAGMean;
    FirstTimeShockPosPAGStd(k) = MouseData.FirstTimeShockPosPAGStd;
    SpeedPreTrials(:,k) = MouseData.SpeedPre;
    SpeedPosPAGTrials(:,k) = MouseData.SpeedPosPAG;
    SpeedSafePreTrials(:,k) = MouseData.SpeedSafePreTrials;
    SpeedSafePosPAGTrials(:,k) = MouseData.SpeedSafePosPAGTrials;
    SpeedShockPre(k) = MouseData.SpeedShockPreMean;
    SpeedShockPre(k) = MouseData.SpeedShockPreStd;
    SpeedSafePre(k) = MouseData.SpeedSafePreMean;
    SpeedSafePreStd(k) = MouseData.SpeedSafePreStd;
    SpeedShockPosPAG(k) = MouseData.SpeedShockPosPAGMean;
    SpeedShockPosPAGStd(k) = MouseData.SpeedShockPosPAGStd;
    SpeedSafePosPAG(k) = MouseData.SpeedSafePosPAGMean;
    SpeedSafePosPAGStd(k) = MouseData.SpeedSafePosPAGStd;
end

%% Density Maps

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.8 0.8 0 0]';
ShockZone = [0 0.35 0.35 0 0;0 0 0.3 0.3 0]';

TrajPreCat = TrajPreCat(all(~isnan(TrajPreCat),2),:);
TrajPosPAGCat = TrajPosPAGCat(all(~isnan(TrajPosPAGCat),2),:);

zmax = 0.3;
linecolor = 0.08;


figure
subplot(1,2,1)
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
        for i = 1:numel(D)
            for j = 1:4
                pl=plot(TrajPreTrials{i,j}(:,1),TrajPreTrials{i,j}(:,2), 'w', 'linewidth',.005);
                pl.Color(4) = linecolor    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca,'YDir','normal')
        title('Pre-tests');

subplot(1,2,2)
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
        for i = 1:numel(D)
            for j = 1:4
                pl=plot(TrajPosPAGTrials{i,j}(:,1),TrajPosPAGTrials{i,j}(:,2), 'w', 'linewidth',.005);
                pl.Color(4) = linecolor;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        set(gca,'YDir','normal')
        title('Post-PAG Tests');
        
annotation('textbox', [0 0.9 1 0.1],'String'...
    ,['Occupancy Maps (N = ',num2str(numel(D)) ')'],'EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')



        
%% Speed

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.8 0.8 0 0]';
ShockZone = [0 0.35 0.35 0 0;0 0 0.3 0.3 0]';

TrajPreCat = TrajPreCat(all(~isnan(TrajPreCat),2),:);
TrajPosPAGCat = TrajPosPAGCat(all(~isnan(TrajPosPAGCat),2),:);

for i = 1:numel(D)
    for j = 1:4
       [TrajPreTrialsTowards{i,j},TrajPreTrialsAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPreTrials{i,j});

       [TrajPosPAGTrialsTowards{i,j},TrajPosPAGTrialsAway{i,j}] =...
           SeparateTrajectoriesTowardsShock(TrajPosPAGTrials{i,j});
    end
end

LineTraj = 1;

y_range=[0 1];
x_range=[0 1];


figure       
subplot(2,3,1)
hold on
for i = 1:numel(D)
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
colormap parula

plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Pre-tests')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,2)
hold on
for i = 1:numel(D)
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

subplot(2,3,3)
hold on
for i = 1:numel(D)
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
title('Speed during Pre-tests Towards Shock')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);


subplot(2,3,4)
hold on
for i = 1:numel(D)
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
colormap parula
plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
title('Speed during Post-PAG')

hcb = colorbar; 
set(get(hcb,'label'),'string','Speed (cm/s)'); 

caxis([0 25])

xlim(x_range);
ylim(y_range);

subplot(2,3,5)
hold on
for i = 1:numel(D)
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
for i = 1:numel(D)
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

annotation('textbox', [0 0.9 1 0.1],'String'...
    ,['Speed Maps (N = ',num2str(numel(D)) ')'],'EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')
        

%% Plots Shock zone occupancy during Sleep importance experiments

OccupPreMean=mean(OccupPre,2);
OccupPreMeanStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGMeanStd=std(OccupPosPAG,0,2);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

figure
bar([1 2],100*[OccupPreMean(1) OccupPosPAGMean(1)],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1 2],100*[OccupPreMean(1) OccupPosPAGMean(1)],100*[OccupPreMeanStd(1) OccupPosPAGMeanStd(1)]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color',[0.6 0.6 0.6],'LineStyle','--','LineWidth',1.5);
text(0,23.2,'random level', 'FontWeight','bold','FontSize',8,'FontAngle', 'italic');

for i=1:numel(D)
plot([1 2]+0.1,100*[OccupPre(1,i) OccupPosPAG(1,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Percentage of time spent','fontweight','bold','fontsize',10);
ylim([0 52]);
title('Shock Zone Occupancy');

%% First time to enter shock zone plot 

FirstTimeShockPreMean=mean(FirstTimeShockPre);
FirstTimeShockPreMeanStd=std(FirstTimeShockPre);

FirstTimeShockPosPAGMean=mean(FirstTimeShockPosPAG);
FirstTimeShockPosPAGMeanStd=std(FirstTimeShockPosPAG);

FirstTimeShockProbeMean=mean(FirstTimeShockProbe);
FirstTimeShockProbeStd=std(FirstTimeShockProbe);

OccupLabels={'Pre-test';'Probe test';'Post PAG'};


figure
bar([1:3],[FirstTimeShockPreMean FirstTimeShockProbeMean FirstTimeShockPosPAGMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[FirstTimeShockPreMean FirstTimeShockProbeMean FirstTimeShockPosPAGMean],[FirstTimeShockPreMeanStd FirstTimeShockProbeStd FirstTimeShockPosPAGMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1:3]+0.1,[FirstTimeShockPre(i) FirstTimeShockProbe(i) FirstTimeShockPosPAG(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

xrange = xlim;
line(xrange,[240,240],'Color','red','LineWidth',2)
text(xrange(1),234,' No entries during test','Color','red','FontSize',10, 'FontWeight','bold')

ylabel('Time (s)','fontweight','bold','fontsize',10);
% ylim([0 1300]);
title('First time to enter shock zone in sleep importance experiment');

%% Compare Occupancies

OccupPreMean=mean(OccupPre,2);
OccupPreMeanStd=std(OccupPre,0,2);

OccupPAGMean=mean(OccupPAG,2);
OccupPAGMeanStd=std(OccupPAG,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGMeanStd=std(OccupPosPAG,0,2);


OccupLabels_2 = {'Shock' 'Safe'};
y_range_bar = [0 75];
textPos = [0.5,24];
figure

subplot(2,2,1)

bar([1 2],100*[OccupPreMean(1) OccupPosPAGMean(1)],'k')
set(gca,'xticklabel',{'Pre-tests';'Post-tests'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1 2],100*[OccupPreMean(1) OccupPosPAGMean(1)],100*[OccupPreMeanStd(1) OccupPosPAGMeanStd(1)]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

xlimits = xlim;

line(xlimits,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(D)
plot([1 2]+0.1,100*[OccupPre(1,i) OccupPosPAG(1,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time spent in zone (%)','fontweight','bold','fontsize',10);
ylim(y_range_bar);
title('Shock zone occupancy - Sleep Importance Experiment');


subplot(2,2,3)
bar([1 2],100*[OccupPreMean(1) OccupPreMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPreMean(1) OccupPreMean(2)],100*[OccupPreMeanStd(1) OccupPreMeanStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Time spent in zone (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Pre Tests');
ylim(y_range_bar);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(D)
plot([1 2]+0.1,100*[OccupPre(1,i) OccupPre(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

subplot(2,2,2)

bar([1 2],100*[OccupPAGMean(1) OccupPAGMean(2)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPAGMean(1) OccupPAGMean(2)],100*[OccupPAGMeanStd(1) OccupPAGMeanStd(2) ]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Time spent in zone (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy PAG conditioning');
ylim(y_range_bar);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(D)
plot([1 2]+0.1,100*[OccupPAG(1,i) OccupPAG(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

subplot(2,2,4)

bar([1 2],100*[OccupPosPAGMean(1) OccupPosPAGMean(2)],'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],100*[OccupPosPAGMean(1) OccupPosPAGMean(2)],100*[OccupPosPAGMeanStd(1) OccupPosPAGMeanStd(2) ],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Time spent in zone (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Post PAG');
ylim(y_range_bar);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5,'HandleVisibility','off');
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(D)
plot([1 2]+0.1,100*[OccupPosPAG(1,i) OccupPosPAG(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end



%% Speed

SpeedShockPreMean=nanmean(SpeedShockPre);
SpeedShockPreMeanStd=nanstd(SpeedShockPre);

SpeedSafePreMean=nanmean(SpeedSafePre);
SpeedSafePreMeanStd=nanstd(SpeedSafePre);

SpeedShockPosPAGMean=nanmean(SpeedShockPosPAG);
SpeedShockPosPAGMeanStd=nanstd(SpeedShockPosPAG);

SpeedSafePosPAGMean=nanmean(SpeedSafePosPAG);
SpeedSafePosPAGMeanStd=nanstd(SpeedSafePosPAG);

figure

subplot(1,3,1)
bar([1 2],[SpeedShockPreMean SpeedShockPosPAGMean],'k')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPreMean SpeedShockPosPAGMean],[SpeedShockPreMeanStd SpeedShockPosPAGMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed in shock zone during sleep importance experiment');
ylim([0 7.5]);

SpeedShockPosPAGZeroes=SpeedShockPosPAG;
SpeedShockPosPAGZeroes(isnan(SpeedShockPosPAGZeroes))= 0;

for i=1:numel(D)
plot([1 2]+0.1,[SpeedShockPre(i) SpeedShockPosPAGZeroes(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

text(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean])),ones(length(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

subplot(1,3,2)
bar([1 2],[SpeedShockPreMean SpeedSafePreMean],'k')
set(gca,'xticklabel',{'Shock zone';'Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPreMean SpeedSafePreMean],[SpeedShockPreMeanStd SpeedSafePreMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed during pre-tests in sleep importance experiment');
ylim([0 7.5]);

for i=1:numel(D)
plot([1 2]+0.1,[SpeedShockPre(i) SpeedSafePre(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

text(find(isnan([SpeedShockPreMean SpeedSafePreMean])),ones(length(find(isnan([SpeedShockPreMean SpeedSafePreMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')


subplot(1,3,3)
bar([1 2],[SpeedShockPosPAGMean SpeedSafePosPAGMean],'k')
set(gca,'xticklabel',{'Shock zone';'Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPosPAGMean SpeedSafePosPAGMean],[SpeedShockPosPAGMeanStd SpeedSafePosPAGMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed during post-PAG in sleep importance experiment');
ylim([0 7.5]);

for i=1:numel(D)
plot([1 2]+0.1,[SpeedShockPosPAGZeroes(i) SpeedSafePosPAG(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

text(find(isnan([SpeedShockPosPAGMean SpeedSafePosPAGMean])),ones(length(find(isnan([SpeedShockPosPAGMean SpeedSafePosPAGMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

%% Number of entries in shock zone

NumEntPreMean=mean(NumEntPre);
NumEntPreMeanStd=std(NumEntPre);

NumEntPosPAGMean=mean(NumEntPosPAG);
NumEntPosPAGMeanStd=std(NumEntPosPAG);


OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

figure
bar([1 2],[NumEntPreMean NumEntPosPAGMean],'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1 2],[NumEntPreMean NumEntPosPAGMean],[NumEntPreMeanStd NumEntPosPAGMeanStd],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1 2]+0.1,[NumEntPre(i) NumEntPosPAG(i)],'linestyle','-','linewidth',1.2,...
    'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
    'DisplayName',MouseName{i});
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 8]);
title('Number of entries in shock zone during sleep importance experiment');

legend show

%% Dinamics of occupancy

OccupPreTrialsMean=mean(OccupPreTrials,3);
OccupPreTrialsStd=std(OccupPreTrials,0,3);

OccupPosPAGTrialsMean=mean(OccupPosPAGTrials,3);
OccupPosPAGTrialsStd=std(OccupPosPAGTrials,0,3);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax = 100;

figure
subplot(2,2,1)
bar([1:4],100*OccupPreTrialsMean(1,:),'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],100*OccupPreTrialsMean(1,:),100*OccupPreTrialsStd(1,:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);
% text(0.1,24,'Random Occupancy', 'FontWeight','bold','FontSize',10);

for i=1:numel(D)
plot([1:4]+0.1,100*OccupPreTrials(1,:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time spent (%)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Shock zone occupancy in Pre-tests');

subplot(2,2,3)
bar([1:4],100*OccupPosPAGTrialsMean(1,:),'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],100*OccupPosPAGTrialsMean(1,:),100*OccupPosPAGTrialsStd(1,:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);
% text(0.1,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',10);

for i=1:numel(D)
plot([1:4]+0.1,100*OccupPosPAGTrials(1,:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time spent (%)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Shock zone occupancy in Post-PAG tests');

subplot(2,2,2)
bar([1:4],100*OccupPreTrialsMean(2,:),'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],100*OccupPreTrialsMean(2,:),100*OccupPreTrialsStd(2,:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);
% text(0.1,24,'Random Occupancy', 'FontWeight','bold','FontSize',10);

for i=1:numel(D)
plot([1:4]+0.1,100*OccupPreTrials(2,:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time spent (%)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Safe zone occupancy in Pre-tests');

subplot(2,2,4)
bar([1:4],100*OccupPosPAGTrialsMean(2,:),'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],100*OccupPosPAGTrialsMean(2,:),100*OccupPosPAGTrialsStd(2,:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);
% text(0.1,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',10);

for i=1:numel(D)
plot([1:4]+0.1,100*OccupPosPAGTrials(2,:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time spent (%)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Safe zone occupancy in Post-PAG tests');


%% Dinamics of entry number

NumEntPreTrialsMean=mean(NumEntPreTrials,2);
NumEntPreTrialsStd=std(NumEntPreTrials,0,2);

NumEntPosPAGTrialsMean=mean(NumEntPosPAGTrials,2);
NumEntPosPAGTrialsStd=std(NumEntPosPAGTrials,0,2);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax=15;

figure

subplot(2,1,1)
bar([1:4],NumEntPreTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],NumEntPreTrialsMean,NumEntPreTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1:4]+0.1,NumEntPreTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Number of entries in shock zone during Pre-tests');

subplot(2,1,2)
bar([1:4],NumEntPosPAGTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],NumEntPosPAGTrialsMean,NumEntPosPAGTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1:4]+0.1,NumEntPosPAGTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Number of entries in shock zone during Post-PAG tests');

%% Dinamics of first time to enter

FirstTimeShockPreTrialsMean=mean(FirstTimeShockPreTrials,2);
FirstTimeShockPreTrialsStd=std(FirstTimeShockPreTrials,0,2);

FirstTimeShockPosPAGTrialsMean=mean(FirstTimeShockPosPAGTrials,2);
FirstTimeShockPosPAGTrialsStd=std(FirstTimeShockPosPAGTrials,0,2);

FirstTimeShockProbeMean=mean(FirstTimeShockProbe);
FirstTimeShockProbeStd=std(FirstTimeShockProbe);
Colors = lines(numel(D)); 

manualjitter = linspace (-0.1,0.1,numel(D));

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4';'Single trial';'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

figure
subplot(1,12,[1:7])
hold on
bar(1,nan,'k','DisplayName','Pre-tests') %legend entry 1
bar(1,nan,'facecolor',[.5 .5 .5],'DisplayName','Probe Test before sleep') %legend entry 2
bar(1,nan,'w','DisplayName','Post-PAG test after sleep') %legend entry 3

hb = bar([1:9],[FirstTimeShockPreTrialsMean;FirstTimeShockProbeMean;FirstTimeShockPosPAGTrialsMean],'k','LineWidth',2,'HandleVisibility','off');
xlim([0.5 9.5])
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
er = errorbar([1:9],[FirstTimeShockPreTrialsMean;FirstTimeShockProbeMean;...
    FirstTimeShockPosPAGTrialsMean],[FirstTimeShockPreTrialsStd;FirstTimeShockProbeStd;...
    FirstTimeShockPosPAGTrialsStd],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

hb.FaceColor = 'flat';
hb.CData(5,:) = [.5 .5 .5];
for i=6:9
hb.CData(i,:) = [1 1 1];
end

set(gca,'ColorOrderIndex',1)
for i=1:numel(D)
plot([1:9]+manualjitter(i),[FirstTimeShockPreTrials(:,i);FirstTimeShockProbe(i);...
    FirstTimeShockPosPAGTrials(:,i)],'color',[0.6 0.6 0.6],'linestyle','-','linewidth',1.2,...
    'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',Colors(i,:),'MarkerSize',6,...
    'DisplayName',MouseName{i},'HandleVisibility','off');
end
% 'color',[0.6 0.6 0.6]

xrange = xlim;
line(xrange,[240,240],'Color','red','LineWidth',2,'HandleVisibility','off')
text(xrange(1),230,' no entries during test','Color','red','FontSize',10, 'FontWeight','bold','FontAngle', 'italic')

ylabel('Time of entry (s)','fontweight','bold','fontsize',10);
ylim([0 260]);
title('Dynamics of first time to enter shock zone');

legend('show')

subplot(1,12,[9:12])
hold on
hb_2 = bar([1:3],[FirstTimeShockPreTrialsMean(1) FirstTimeShockProbeMean FirstTimeShockPosPAGTrialsMean(1)],'k','LineWidth',2,'HandleVisibility','off');
Xlim = ([0.5 3.5]);
xticks([1:3])
set(gca,'xticklabel',{'Trial 1';'Single Trial';'Trial 1'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
er = errorbar([1:3],[FirstTimeShockPreTrialsMean(1);FirstTimeShockProbeMean;FirstTimeShockPosPAGTrialsMean(1)],[FirstTimeShockPreTrialsStd(1);FirstTimeShockProbeStd;FirstTimeShockPosPAGTrialsStd(1)],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

hb_2.FaceColor = 'flat';
hb_2.CData(2,:) = [.5 .5 .5];
hb_2.CData(3,:) = [1 1 1];

set(gca,'ColorOrderIndex',1)
for i=1:numel(D)
plot([1:3]+manualjitter(i),[FirstTimeShockPreTrials(1,i);FirstTimeShockProbe(i);...
    FirstTimeShockPosPAGTrials(1,i)],'color',[0.6 0.6 0.6],'linestyle',...
    '-','linewidth',1.2,'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',Colors(i,:),'MarkerSize',6);
end
% 'color',[0.6 0.6 0.6]

xrange = xlim;
line(xrange,[240,240],'Color','red','LineWidth',2)

lgd=legend(MouseName);
aux=lgd.Location;
lgd.Location='eastoutside';

ylabel('Time of entry (s)','fontweight','bold','fontsize',10);
ylim([0 260]);
title('Extract');

%% Dinamics of speed

SpeedPreTrialsMean = mean(SpeedPreTrials,2);
SpeedPreTrialsStd = std(SpeedPreTrials,0,2);

SpeedPosPAGTrialsMean = mean(SpeedPosPAGTrials,2);
SpeedPosPAGTrialsStd = std(SpeedPosPAGTrials,0,2);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};
ymax = 10;

figure
subplot(2,1,1)
bar([1:4],SpeedPreTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1:4],SpeedPreTrialsMean,SpeedPreTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Average speed during Pre-tests');
ylim([0 ymax]);
for i=1:numel(D)
plot([1:4]+0.1,SpeedPreTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

subplot(2,1,2)
bar([1:4],SpeedPosPAGTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1:4],SpeedPosPAGTrialsMean,SpeedPosPAGTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Average speed during Post-PAG tests');
ylim([0 ymax]);
for i=1:numel(D)
plot([1:4]+0.1,SpeedPosPAGTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end
