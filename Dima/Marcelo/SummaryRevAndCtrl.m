figure

manualjitterExpe = linspace(0.02,0.06,numel(Expe));
manualjitterControl = linspace(0.02,0.06,numel(Control));

subplot(2,3,1)
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

hb = bar([1:3],100*[OccupPreMean(1) OccupPreMeanControl(1);...
    OccupPosPAGMean(1) OccupPosPAGMeanControl(1);...
    OccupPosMFBMean(1) OccupPosMFBMeanControl(1)],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,100*[OccupPreMean(1) OccupPreMeanControl(1);...
    OccupPosPAGMean(1) OccupPosPAGMeanControl(1);...
    OccupPosMFBMean(1) OccupPosMFBMeanControl(1)],...
    100*[OccupPreMeanStd(1) OccupPreMeanStdControl(1);...
    OccupPosPAGMeanStd(1) OccupPosPAGMeanStdControl(1);...
    OccupPosMFBMeanStd(1) OccupPosMFBMeanStdControl(1)],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);

line(xlim,[21.5 21.5],'Color',[0.6 0.6 0.6],'LineStyle','--','LineWidth',1.5,'HandleVisibility','off');
text(1,23.2,'random level', 'FontWeight','bold','FontSize',8,'FontAngle', 'italic','Color',[0.6 0.6 0.6]);

for i=1:numel(Expe)
plot(xBar(:,1)+manualjitterExpe(i),100*[OccupPre(1,i) OccupPosPAG(1,i) OccupPosMFB(1,i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+manualjitterControl(i),100*[OccupPreControl(1,i) OccupPosPAGControl(1,i) OccupPosMFBControl(1,i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Percentage of time spent','fontweight','bold','fontsize',10);
ylim([0 31]);
title('Shock Zone Occupancy');


subplot(2,3,2)

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

hb = bar([1:3],[NumEntPreMean NumEntPreMeanControl;...
    NumEntPosPAGMean NumEntPosPAGMeanControl;...
    NumEntPosMFBMean NumEntPosMFBMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[NumEntPreMean NumEntPreMeanControl;...
    NumEntPosPAGMean NumEntPosPAGMeanControl;...
    NumEntPosMFBMean NumEntPosMFBMeanControl],...
    [NumEntPreMeanStd NumEntPreMeanStdControl;...
    NumEntPosPAGMeanStd NumEntPosPAGMeanStdControl;...
    NumEntPosMFBMeanStd NumEntPosMFBMeanStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+manualjitterExpe(i),[NumEntPre(i) NumEntPosPAG(i) NumEntPosMFB(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+manualjitterControl(i),[NumEntPreControl(i) NumEntPosPAGControl(i) NumEntPosMFBControl(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Entry Count','fontweight','bold','fontsize',10);
ylim([0 3.5]);
title('Entries in Shock Zone');

subplot(2,3,3)
ymax = 300;

NumCondPAGMean = mean(NumCondPAG);
NumCondPAGStd = std(NumCondPAG);

NumCondMFBMean = mean(NumCondMFB);
NumCondMFBStd = std(NumCondMFB);

NumCondPAGMeanControl = mean(NumCondPAGControl);
NumCondPAGStdControl = std(NumCondPAGControl);

NumCondMFBMeanControl = mean(NumCondMFBControl);
NumCondMFBStdControl = std(NumCondMFBControl);

OccupLabels={'PAG Conditioning';'MFB Conditioning'};

hb = bar([1 2],[NumCondPAGMean NumCondPAGMeanControl;...
    NumCondMFBMean NumCondMFBMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[NumCondPAGMean NumCondPAGMeanControl;...
    NumCondMFBMean NumCondMFBMeanControl],...
    [NumCondPAGStd NumCondPAGStdControl;...
    NumCondMFBStd NumCondMFBStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+manualjitterExpe(i),[NumCondPAG(i) NumCondMFB(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+manualjitterControl(i),[NumCondPAGControl(i) NumCondMFBControl(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Stimulations count','fontweight','bold','fontsize',10);
ylim([0 250]);
title('Number of stimulations');


subplot(2,3,4)
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

hb = bar([1:3],[FirstTimeShockPreMean FirstTimeShockPreMeanControl;...
    FirstTimeShockPosPAGMean FirstTimeShockPosPAGMeanControl;...
    FirstTimeShockPosMFBMean FirstTimeShockPosMFBMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[FirstTimeShockPreMean FirstTimeShockPreMeanControl;...
    FirstTimeShockPosPAGMean FirstTimeShockPosPAGMeanControl;...
    FirstTimeShockPosMFBMean FirstTimeShockPosMFBMeanControl],...
    [FirstTimeShockPreMeanStd FirstTimeShockPreMeanStdControl;...
    FirstTimeShockPosPAGMeanStd FirstTimeShockPosPAGMeanStdControl;...
    FirstTimeShockPosMFBMeanStd FirstTimeShockPosMFBMeanStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+manualjitterExpe(i),[FirstTimeShockPre(i) FirstTimeShockPosPAG(i) FirstTimeShockPosMFB(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+manualjitterControl(i),[FirstTimeShockPreControl(i) FirstTimeShockPosPAGControl(i) FirstTimeShockPosMFBControl(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

xrange = xlim;
line(xrange,[120,120],'Color','red','LineWidth',2,'HandleVisibility','off')
text(xrange(1),114,' no entries during test','Color','red','FontSize',8, 'FontWeight','bold','FontAngle', 'italic')


ylabel('Time of entry (s)','fontweight','bold','fontsize',10);
ylim([0 130]);
title('First time to enter shock zone');

subplot(2,3,5)

SpeedSafePreMean=nanmean(SpeedSafePre);
SpeedSafePreMeanStd=nanstd(SpeedSafePre);

SpeedSafePosPAGMean=nanmean(SpeedSafePosPAG);
SpeedSafePosPAGMeanStd=nanstd(SpeedSafePosPAG);

SpeedSafePosMFBMean=nanmean(SpeedSafePosMFB);
SpeedSafePosMFBMeanStd=nanstd(SpeedSafePosMFB);

SpeedSafePreMeanControl=nanmean(SpeedSafePreControl);
SpeedSafePreMeanStdControl=nanstd(SpeedSafePreControl);

SpeedSafePosPAGMeanControl=nanmean(SpeedSafePosPAGControl);
SpeedSafePosPAGMeanStdControl=nanstd(SpeedSafePosPAGControl);

SpeedSafePosMFBMeanControl=nanmean(SpeedSafePosMFBControl);
SpeedSafePosMFBMeanStdControl=nanstd(SpeedSafePosMFBControl);

hb = bar([1:3],[SpeedSafePreMean SpeedSafePreMeanControl;...
    SpeedSafePosPAGMean SpeedSafePosPAGMeanControl;...
    SpeedSafePosMFBMean SpeedSafePosMFBMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[SpeedSafePreMean SpeedSafePreMeanControl;...
    SpeedSafePosPAGMean SpeedSafePosPAGMeanControl;...
    SpeedSafePosMFBMean SpeedSafePosMFBMeanControl],...
    [SpeedSafePreMeanStd SpeedSafePreMeanStdControl;...
    SpeedSafePosPAGMeanStd SpeedSafePosPAGMeanStdControl;...
    SpeedSafePosMFBMeanStd SpeedSafePosMFBMeanStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);

SpeedSafePosPAGZeroes=SpeedSafePosPAG;
SpeedSafePosPAGZeroes(isnan(SpeedSafePosPAGZeroes))= 0;

SpeedSafePosPAGZeroesControl=SpeedSafePosPAGControl;
SpeedSafePosPAGZeroesControl(isnan(SpeedSafePosPAGZeroesControl))= 0;

for i=1:numel(Expe)
plot(xBar(:,1)+0.02,[SpeedSafePre(i) SpeedSafePosPAGZeroes(i) SpeedSafePosMFB(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+0.02,[SpeedSafePreControl(i) SpeedSafePosPAGZeroesControl(i) SpeedSafePosMFBControl(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

text(find(isnan([SpeedSafePreMean SpeedSafePosPAGMean SpeedSafePosMFBMean])),...
    ones(length(find(isnan([SpeedSafePreMean SpeedSafePosPAGMean SpeedSafePosMFBMean])))),...
    {'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center',...
    'FontSize',8, 'FontWeight','bold')

ylabel('Safe zone speed (cm/s)','fontweight','bold','fontsize',10);
ylim([0 8]);
title('Speed in safe zone');

subplot(2,3,6)

EscapeWallShockPAGMean=nanmean(EscapeWallShockPAG);
EscapeWallShockPAGMeanStd=nanstd(EscapeWallShockPAG);

EscapeWallShockMFBMean=nanmean(EscapeWallShockMFB);
EscapeWallShockMFBMeanStd=nanstd(EscapeWallShockMFB);

EscapeWallShockPAGMeanControl=nanmean(EscapeWallShockPAGControl);
EscapeWallShockPAGMeanStdControl=nanstd(EscapeWallShockPAGControl);

EscapeWallShockMFBMeanControl=nanmean(EscapeWallShockMFBControl);
EscapeWallShockMFBMeanStdControl=nanstd(EscapeWallShockMFBControl);

ymax = 75;

OccupLabels={'PAG Conditioning';'MFB Conditioning'};

hb = bar([1 2],[EscapeWallShockPAGMean EscapeWallShockPAGMeanControl;...
    EscapeWallShockMFBMean EscapeWallShockMFBMeanControl],'k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'MFB','Sham'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,[EscapeWallShockPAGMean EscapeWallShockPAGMeanControl;...
    EscapeWallShockMFBMean EscapeWallShockMFBMeanControl],...
    [EscapeWallShockPAGMeanStd EscapeWallShockPAGMeanStdControl;...
    EscapeWallShockMFBMeanStd EscapeWallShockMFBMeanStdControl],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);


for i=1:numel(Expe)
plot(xBar(:,1)+manualjitterExpe(i),[EscapeWallShockPAG(i) EscapeWallShockMFB(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

for i=1:numel(Control)
plot(xBar(:,2)+manualjitterControl(i),[EscapeWallShockPAGControl(i) EscapeWallShockMFBControl(i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Time of escape (s)','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Escape Latency from shock zone');
