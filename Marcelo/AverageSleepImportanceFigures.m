%% Get Data
clear all
SingleMiceFolder = '/home/vador/Documents/Marcelo/Results/SleepImportance/SingleMiceData';
cd(SingleMiceFolder)
D = dir;
D = D(~ismember({D.name}, {'.', '..'}));

for k = 1:numel(D)
    load(D(k).name);
%     MouseName(k) = MouseData.MouseName;
    OccupPre(:,k) = MouseData.OccupPreMean;
    OccupPreStd(:,k) = MouseData.OccupPreStd;
    OccupPosPAG(:,k) = MouseData.OccupPosPAGMean;
    OccupPosPAGStd(:,k) = MouseData.OccupPosPAGStd;
    OccupPAG(:,k) = MouseData.OccupPAGMean;
    OccupPAGStd(:,k) = MouseData.OccupPAGStd;
    NumEntPre(k) = MouseData.NumEntPreMean;
    NumEntPreStd(k) = MouseData.NumEntPreStd;
    NumEntPosPAG(k) = MouseData.NumEntPosPAGMean;
    NumEntPosPAGStd(k) = MouseData.NumEntPosPAGStd;
    NumCondPAG(k) = MouseData.NumCondPAG;
    FirstTimeShockPre(k) = MouseData.FirstTimeShockPreMean;
    FirstTimeShockPreStd(k) = MouseData.FirstTimeShockPreStd;
    FirstTimeShockPosPAG(k) = MouseData.FirstTimeShockPosPAGMean;
    FirstTimeShockPosPAGStd(k) = MouseData.FirstTimeShockPosPAGStd;
    SpeedShockPre(k) = MouseData.SpeedShockPreMean;
    SpeedShockPre(k) = MouseData.SpeedShockPreStd;
    SpeedSafePre(k) = MouseData.SpeedSafePreMean;
    SpeedSafePreStd(k) = MouseData.SpeedSafePreStd;
    SpeedShockPosPAG(k) = MouseData.SpeedShockPosPAGMean;
    SpeedShockPosPAGStd(k) = MouseData.SpeedShockPosPAGStd;
    SpeedSafePosPAG(k) = MouseData.SpeedSafePosPAGMean;
    SpeedSafePosPAGStd(k) = MouseData.SpeedSafePosPAGStd;
end

%% Plots Shock zone occupancy during reversal experiments

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

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(0.1,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',10);

for i=1:numel(D)
plot([1 2]+0.1,100*[OccupPre(1,i) OccupPosPAG(1,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
ylim([0 40]);
title('Shock zone occupancy during sleep importance experiment');

%% First time to enter shock zone plot 

FirstTimeShockPreMean=mean(FirstTimeShockPre);
FirstTimeShockPreMeanStd=std(FirstTimeShockPre);
FirstTimeShockPosPAGMean=mean(FirstTimeShockPosPAG);
FirstTimeShockPosPAGMeanStd=std(FirstTimeShockPosPAG);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};


figure
bar([1 2],[FirstTimeShockPreMean FirstTimeShockPosPAGMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1 2],[FirstTimeShockPreMean FirstTimeShockPosPAGMean],[FirstTimeShockPreMeanStd FirstTimeShockPosPAGMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1 2]+0.1,[FirstTimeShockPre(i) FirstTimeShockPosPAG(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
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
set(gca,'xticklabel',OccupLabels)
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

ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
ylim(y_range_bar);
title('Shock zone occupancy during reversal experiment');


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
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
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
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy PAG conditioning');
ylim(y_range_bar);

line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2.5);
text(xlimits(1)+0.1,24,{'Random','Occupancy'}, 'vert','bottom', ...
    'FontSize',10, 'FontWeight','bold')

for i=1:numel(D)
plot([1 2]+0.1,100*[OccupPAG(1,i) OccupPAG(2,i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

subplot(2,2,4)

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
bar([1 2],[NumEntPreMean NumEntPosPAGMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1 2],[NumEntPreMean NumEntPosPAGMean],[NumEntPreMeanStd NumEntPosPAGMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

for i=1:numel(D)
plot([1 2]+0.1,[NumEntPre(i) NumEntPosPAG(i)],'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',6);
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 5]);
title('Number of entries in shock zone during sleep importance experiment');