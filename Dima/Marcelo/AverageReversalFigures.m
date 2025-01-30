%% Get Data
clear all

Control = 0;

if Control == 1
SingleMiceFolder = '/home/vador/Documents/Marcelo/Results/ReversalControl/Averages/SingleMiceData';
cd(SingleMiceFolder)
D = dir;
D = D(~ismember({D.name}, {'.', '..'}));

Mice2Use = logical([0 0 1 1 0]); % ReversalControl: [913 932 934 935 938], put ones in the positions of mice to be used in analysis
D = D(Mice2Use);
end

if Control == 0
SingleMiceFolder = '/home/vador/Documents/Marcelo/Results/Reversal/Averages/SingleMiceData';
cd(SingleMiceFolder)
D = dir;
D = D(~ismember({D.name}, {'.', '..'}));

Mice2Use = logical([0 1 1]); % Reversal: [863 913 934], put ones in the positions of mice to be used in analysis
D = D(Mice2Use);
end


for k = 1:numel(D)
    load(D(k).name);
    MouseName{k} = MouseData.MouseName;
    if k == 1
        TrajPreCat = MouseData.TrajPre;
        TrajPreTrials = MouseData.TrajPreTrials;
        TrajPosPAGCat = MouseData.TrajPosPAG;
        TrajPosPAGTrials = MouseData.TrajPosPAGTrials;
        TrajPosMFBCat = MouseData.TrajPosMFB;
        TrajPosMFBTrials = MouseData.TrajPosMFBTrials;
    else
        TrajPreCat = cat(1,TrajPreCat,MouseData.TrajPre);
        TrajPreTrials(k,:) = MouseData.TrajPreTrials;
        TrajPosPAGCat = cat(1,TrajPosPAGCat,MouseData.TrajPosPAG);
        TrajPosPAGTrials(k,:) = MouseData.TrajPosPAGTrials;
        TrajPosMFBCat = cat(1,TrajPosMFBCat,MouseData.TrajPosMFB);
        TrajPosMFBTrials(k,:) = MouseData.TrajPosMFBTrials;
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

%% Plots Shock zone occupancy during reversal experiments

OccupPreMean=mean(OccupPre,2);
OccupPreMeanStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGMeanStd=std(OccupPosPAG,0,2);

OccupPosMFBMean=mean(OccupPosMFB,2);
OccupPosMFBMeanStd=std(OccupPosMFB,0,2);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

ColorMice = 1;

figure
bar([1:3],100*[OccupPreMean(1) OccupPosPAGMean(1) OccupPosMFBMean(1)],'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],100*[OccupPreMean(1) OccupPosPAGMean(1) OccupPosMFBMean(1)],100*[OccupPreMeanStd(1) OccupPosPAGMeanStd(1) OccupPosMFBMeanStd(1)],'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5,'HandleVisibility','off');
text(0.1,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',10);

if ColorMice == 0
    for i=1:numel(D)
        plot([1:3]+0.1,100*[OccupPre(1,i) OccupPosPAG(1,i) OccupPosMFB(1,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
    end
elseif ColorMice == 1
    for i=1:numel(D)
        plot([1:3]+0.1,100*[OccupPre(1,i) OccupPosPAG(1,i) OccupPosMFB(1,i)],'linestyle','-','linewidth',1.2,...
        'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
        'DisplayName',MouseName{i});
    end
end
legend show
ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
ylim([0 32]);
title('Shock zone occupancy during reversal experiment');

%% First time to enter shock zone plot 

FirstTimeShockPreMean=mean(FirstTimeShockPre);
FirstTimeShockPreMeanStd=std(FirstTimeShockPre);
FirstTimeShockPosPAGMean=mean(FirstTimeShockPosPAG);
FirstTimeShockPosPAGMeanStd=std(FirstTimeShockPosPAG);
FirstTimeShockPosMFBMean=mean(FirstTimeShockPosMFB);
FirstTimeShockPosMFBMeanStd=std(FirstTimeShockPosMFB);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};


figure
bar([1:3],[FirstTimeShockPreMean FirstTimeShockPosPAGMean FirstTimeShockPosMFBMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[FirstTimeShockPreMean FirstTimeShockPosPAGMean FirstTimeShockPosMFBMean],[FirstTimeShockPreMeanStd FirstTimeShockPosPAGMeanStd FirstTimeShockPosMFBMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1:3]+0.1,[FirstTimeShockPre(i) FirstTimeShockPosPAG(i) FirstTimeShockPosMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

xrange = xlim;
line(xrange,[121,121],'Color','red','LineWidth',2)
text(xrange(1),116,' No entries during test','Color','red','FontSize',10, 'FontWeight','bold')

ylabel('Time (s)','fontweight','bold','fontsize',10);
% ylim([0 1300]);
title('First time to enter shock zone in reversal experiment');

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

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};
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

for i=1:numel(D)
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

for i=1:numel(D)
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

for i=1:numel(D)
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

for i=1:numel(D)
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

for i=1:numel(D)
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

for i=1:numel(D)
plot([1 2]+0.1,100*[OccupPosMFB(1,i) OccupPosMFB(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

%% Density map

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.8 0.8 0 0]';
ShockZone = [0 0.35 0.35 0 0;0 0 0.3 0.3 0]';

TrajPreCat = TrajPreCat(all(~isnan(TrajPreCat),2),:);
TrajPosPAGCat = TrajPosPAGCat(all(~isnan(TrajPosPAGCat),2),:);
TrajPosMFBCat = TrajPosMFBCat(all(~isnan(TrajPosMFBCat),2),:);


figure
subplot(1,3,1)
[occH, x1, x2] = hist2(TrajPreCat(:,1), TrajPreCat(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=[0 1];
        y=[0 1];
        imagesc(x,y,occHS)
        caxis([0 .1]) % control color intensity here
        colormap(hot)
        hold on
        plot(Maze(:,1),Maze(:,2),'w','linewidth',2)
        plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
        for i = 1:numel(D)
            for j = 1:4
                pl=plot(TrajPreTrials{i,j}(:,1),TrajPreTrials{i,j}(:,2), 'w', 'linewidth',.05);
                pl.Color(4) = .2;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        title('Occupancy map during pre-tests');
   
        
        subplot(1,3,2)
[occH, x1, x2] = hist2(TrajPosPAGCat(:,1), TrajPosPAGCat(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=[0 1];
        y=[0 1];
        imagesc(x,y,occHS)
        caxis([0 .1]) % control color intensity here
        colormap(hot)
        hold on
        plot(Maze(:,1),Maze(:,2),'w','linewidth',2)
        plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
        for i = 1:numel(D)
            for j = 1:4
                pl=plot(TrajPosPAGTrials{i,j}(:,1),TrajPosPAGTrials{i,j}(:,2), 'w', 'linewidth',.05);
                pl.Color(4) = .2;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        title('Occupancy map during post-PAG tests');
        
        subplot(1,3,3)
[occH, x1, x2] = hist2(TrajPosMFBCat(:,1), TrajPosMFBCat(:,2), 240, 320);
        occHS(1:320,1:240) = SmoothDec(occH/15,[3,3]);
        x=[0 1];
        y=[0 1];
        imagesc(x,y,occHS)
        caxis([0 .1]) % control color intensity here
        colormap(hot)
        hold on
        plot(Maze(:,1),Maze(:,2),'w','linewidth',2)
        plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
        for i = 1:numel(D)
            for j = 1:4
                pl=plot(TrajPosMFBTrials{i,j}(:,1),TrajPosMFBTrials{i,j}(:,2), 'w', 'linewidth',.05);
                pl.Color(4) = .2;    %control line color intensity here
            end
        end
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        title('Occupancy map during post-MFB tests');
        
annotation('textbox', [0.1 0 1 0.1],'String'...
    , ['*Reversal Control Experiment N = ',num2str(numel(D))],'EdgeColor',...
    'none','HorizontalAlignment', 'left','FontSize',10, 'FontWeight','bold')


%% Speed

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

figure

subplot(2,2,1)
bar([1 2 3],[SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean],'k')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2,3],[SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean],[SpeedShockPreMeanStd SpeedShockPosPAGMeanStd SpeedShockPosMFBMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed in shock zone during reversal experiment');
ylim([0 7.5]);

SpeedShockPosPAGZeroes=SpeedShockPosPAG;
SpeedShockPosPAGZeroes(isnan(SpeedShockPosPAGZeroes))= 0;

for i=1:numel(D)
plot([1:3]+0.1,[SpeedShockPre(i) SpeedShockPosPAGZeroes(i) SpeedShockPosMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

text(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean])),ones(length(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean SpeedShockPosMFBMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

subplot(2,2,2)
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
title('Speed during pre-tests in reversal experiment');
ylim([0 7.5]);

for i=1:numel(D)
plot([1 2]+0.1,[SpeedShockPre(i) SpeedSafePre(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

text(find(isnan([SpeedShockPreMean SpeedSafePreMean])),ones(length(find(isnan([SpeedShockPreMean SpeedSafePreMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')


subplot(2,2,3)
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
title('Speed during post-PAG in reversal experiment');
ylim([0 7.5]);

for i=1:numel(D)
plot([1 2]+0.1,[SpeedShockPosPAGZeroes(i) SpeedSafePosPAG(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

text(find(isnan([SpeedShockPosPAGMean SpeedSafePosPAGMean])),ones(length(find(isnan([SpeedShockPosPAGMean SpeedSafePosPAGMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')


subplot(2,2,4)
bar([1 2],[SpeedShockPosMFBMean SpeedSafePosMFBMean],'k')
set(gca,'xticklabel',{'Shock zone';'Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedShockPosMFBMean SpeedSafePosMFBMean],[SpeedShockPosMFBMeanStd SpeedSafePosMFBMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed during post-MFB tests in reversal experiment');
ylim([0 7.5]);

for i=1:numel(D)
plot([1 2]+0.1,[SpeedShockPosMFB(i) SpeedSafePosMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

text(find(isnan([SpeedShockPosMFBMean SpeedSafePosMFBMean])),ones(length(find(isnan([SpeedShockPosMFBMean SpeedSafePosMFBMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')

%% Number of entries in shock zone

NumEntPreMean=mean(NumEntPre);
NumEntPreMeanStd=std(NumEntPre);

NumEntPosPAGMean=mean(NumEntPosPAG);
NumEntPosPAGMeanStd=std(NumEntPosPAG);

NumEntPosMFBMean=mean(NumEntPosMFB);
NumEntPosMFBMeanStd=std(NumEntPosMFB);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

figure
bar([1:3],[NumEntPreMean NumEntPosPAGMean NumEntPosMFBMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[NumEntPreMean NumEntPosPAGMean NumEntPosMFBMean],[NumEntPreMeanStd NumEntPosPAGMeanStd NumEntPosMFBMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1:3]+0.1,[NumEntPre(i) NumEntPosPAG(i) NumEntPosMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 7]);
title('Number of entries in shock zone during reversal experiment');

%% Number of Stimulations

NumCondPAGMean = mean(NumCondPAG);
NumCondPAGStd = std(NumCondPAG);

NumCondMFBMean = mean(NumCondMFB);
NumCondMFBStd = std(NumCondMFB);

figure
bar([1 2],[NumCondPAGMean NumCondMFBMean],'k')
set(gca,'xticklabel',{'PAG';'MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
ylabel('Stimulations count','fontweight','bold','fontsize',10);
title('Number of PAG and MFB stimulations during reversal experiment');
ylim([0 100]);
hold on
er = errorbar([1 2],[NumCondPAGMean NumCondMFBMean],[NumCondPAGStd NumCondMFBStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1 2]+0.1,[NumCondPAG(i) NumCondMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

%% Escape Latency

EscapeWallShockPAGMean=nanmean(EscapeWallShockPAG);
EscapeWallShockPAGMeanStd=nanstd(EscapeWallShockPAG);

EscapeWallShockMFBMean=nanmean(EscapeWallShockMFB);
EscapeWallShockMFBMeanStd=nanstd(EscapeWallShockMFB);

EscapeWallSafeMFBMean=nanmean(EscapeWallSafeMFB);
EscapeWallSafeMFBMeanStd=nanstd(EscapeWallSafeMFB);

EscapeWallSafePAGMean=nanmean(EscapeWallSafePAG);
EscapeWallSafePAGMeanStd=nanstd(EscapeWallSafePAG);

y_range=[0 150];

figure
subplot(2,2,1)
bar([1,2],[EscapeWallShockPAGMean EscapeWallShockMFBMean],'k')
set(gca,'xticklabel',{'PAG Cond','MFB Cond'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallShockPAGMean EscapeWallShockMFBMean],[EscapeWallShockPAGMeanStd EscapeWallShockMFBMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1 2]+0.1,[EscapeWallShockPAG(i) EscapeWallShockMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim(y_range);
title('Escape Latency from Shock Zone');

subplot(2,2,2)
bar([1,2],[EscapeWallSafePAGMean EscapeWallSafeMFBMean],'k')
set(gca,'xticklabel',{'PAG Cond','MFB Cond'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallSafePAGMean EscapeWallSafeMFBMean],[EscapeWallSafePAGMeanStd EscapeWallSafeMFBMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1 2]+0.1,[EscapeWallSafePAG(i) EscapeWallSafeMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim(y_range);
title('Escape Latency from Safe Zone');

subplot(2,2,3)
bar([1,2],[EscapeWallShockPAGMean EscapeWallSafePAGMean],'k')
set(gca,'xticklabel',{'Shock Zone','Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallShockPAGMean EscapeWallSafePAGMean],[EscapeWallShockPAGMeanStd EscapeWallSafePAGMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1 2]+0.1,[EscapeWallShockPAG(i) EscapeWallSafePAG(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim(y_range);
title('Escape Latency During PAG Conditioning');

subplot(2,2,4)
bar([1,2],[EscapeWallShockMFBMean EscapeWallSafeMFBMean],'k')
set(gca,'xticklabel',{'Shock Zone','Safe Zone'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1,2],[EscapeWallShockMFBMean EscapeWallSafeMFBMean],[EscapeWallShockMFBMeanStd EscapeWallSafeMFBMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1 2]+0.1,[EscapeWallShockMFB(i) EscapeWallSafeMFB(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim(y_range);
title('Escape Latency During MFB Conditioning');

%% Dinamics of occupancy

OccupPreTrialsMean=mean(OccupPreTrials,3);
OccupPreTrialsStd=std(OccupPreTrials,0,3);

OccupPosPAGTrialsMean=mean(OccupPosPAGTrials,3);
OccupPosPAGTrialsStd=std(OccupPosPAGTrials,0,3);

OccupPosMFBTrialsMean=mean(OccupPosMFBTrials,3);
OccupPosMFBTrialsStd=std(OccupPosMFBTrials,0,3);


OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax = 70;

figure
subplot(3,2,1)
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

subplot(3,2,3)
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

subplot(3,2,5)
bar([1:4],100*OccupPosMFBTrialsMean(1,:),'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],100*OccupPosMFBTrialsMean(1,:),100*OccupPosMFBTrialsStd(1,:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);
% text(0.1,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',10);

for i=1:numel(D)
plot([1:4]+0.1,100*OccupPosMFBTrials(1,:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time spent (%)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Shock zone occupancy in Post-MFB tests');

subplot(3,2,2)
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

subplot(3,2,4)
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

subplot(3,2,6)
bar([1:4],100*OccupPosMFBTrialsMean(2,:),'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],100*OccupPosMFBTrialsMean(2,:),100*OccupPosMFBTrialsStd(2,:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);
% text(0.1,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',10);

for i=1:numel(D)
plot([1:4]+0.1,100*OccupPosMFBTrials(2,:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Time spent (%)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Safe zone occupancy in Post-MFB tests');


%% Dinamics of entry number

NumEntPreTrialsMean=mean(NumEntPreTrials,2);
NumEntPreTrialsStd=std(NumEntPreTrials,0,2);

NumEntPosPAGTrialsMean=mean(NumEntPosPAGTrials,2);
NumEntPosPAGTrialsStd=std(NumEntPosPAGTrials,0,2);

NumEntPosMFBTrialsMean=mean(NumEntPosMFBTrials,2);
NumEntPosMFBTrialsStd=std(NumEntPosMFBTrials,0,2);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax=20;

figure

subplot(3,1,1)
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

subplot(3,1,2)
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

subplot(3,1,3)
bar([1:4],NumEntPosMFBTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],NumEntPosMFBTrialsMean,NumEntPosMFBTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1:4]+0.1,NumEntPosMFBTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Number of entries in shock zone during Post-MFB tests');


%% Dinamics of first time to enter

FirstTimeShockPreTrialsMean=mean(FirstTimeShockPreTrials,2);
FirstTimeShockPreTrialsStd=std(FirstTimeShockPreTrials,0,2);

FirstTimeShockPosPAGTrialsMean=mean(FirstTimeShockPosPAGTrials,2);
FirstTimeShockPosPAGTrialsStd=std(FirstTimeShockPosPAGTrials,0,2);

FirstTimeShockPosMFBTrialsMean=mean(FirstTimeShockPosMFBTrials,2);
FirstTimeShockPosMFBTrialsStd=std(FirstTimeShockPosMFBTrials,0,2);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};


figure
subplot(3,1,1)
bar([1:4],FirstTimeShockPreTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],FirstTimeShockPreTrialsMean,FirstTimeShockPreTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1:4]+0.1,FirstTimeShockPreTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

xrange = xlim;
line(xrange,[121,121],'Color','red','LineWidth',2)
text(xrange(1),116,' No entries during test','Color','red','FontSize',10, 'FontWeight','bold')

ylabel('Time (s)','fontweight','bold','fontsize',10);
ylim([0 130]);
title('First time to enter shock zone in Pre-tests');

subplot(3,1,2)
bar([1:4],FirstTimeShockPosPAGTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],FirstTimeShockPosPAGTrialsMean,FirstTimeShockPosPAGTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1:4]+0.1,FirstTimeShockPosPAGTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

xrange = xlim;
line(xrange,[121,121],'Color','red','LineWidth',2)
text(xrange(1),116,' No entries during test','Color','red','FontSize',10, 'FontWeight','bold')

ylabel('Time (s)','fontweight','bold','fontsize',10);
ylim([0 130]);
title('First time to enter shock zone in Post-PAG tests');

subplot(3,1,3)
bar([1:4],FirstTimeShockPosMFBTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:4],FirstTimeShockPosMFBTrialsMean,FirstTimeShockPosMFBTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1:4]+0.1,FirstTimeShockPosMFBTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

xrange = xlim;
line(xrange,[121,121],'Color','red','LineWidth',2)
text(xrange(1),116,' No entries during test','Color','red','FontSize',10, 'FontWeight','bold')

ylabel('Time (s)','fontweight','bold','fontsize',10);
ylim([0 130]);
title('First time to enter shock zone in Post-MFB tests');

%% Dinamics of speed

SpeedPreTrialsMean = mean(SpeedPreTrials,2);
SpeedPreTrialsStd = std(SpeedPreTrials,0,2);

SpeedPosPAGTrialsMean = mean(SpeedPosPAGTrials,2);
SpeedPosPAGTrialsStd = std(SpeedPosPAGTrials,0,2);

SpeedPosMFBTrialsMean = mean(SpeedPosMFBTrials,2);
SpeedPosMFBTrialsStd = std(SpeedPosMFBTrials,0,2);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};
ymax = 10;

figure
subplot(3,1,1)
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

subplot(3,1,2)
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

subplot(3,1,3)
bar([1:4],SpeedPosMFBTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1:4],SpeedPosMFBTrialsMean,SpeedPosMFBTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Average speed during Post-MFB tests');
ylim([0 ymax]);
for i=1:numel(D)
plot([1:4]+0.1,SpeedPosMFBTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end
