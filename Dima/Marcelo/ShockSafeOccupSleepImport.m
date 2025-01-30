figure
manualjitter = linspace(-0.08,0.08,numel(D));
subplot(2,2,1)
OccupPreMean=mean(OccupPre,2);
OccupPreMeanStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGMeanStd=std(OccupPosPAG,0,2);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

hb = bar([1 2],100*[OccupPreMean(1) OccupPreMean(2);OccupPosPAGMean(1) OccupPosPAGMean(2)],'k')
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'Shock Zone','Safe Zone'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,100*[OccupPreMean(1) OccupPreMean(2);OccupPosPAGMean(1) OccupPosPAGMean(2)],...
    100*[OccupPreMeanStd(1) OccupPreMeanStd(2);OccupPosPAGMeanStd(1) OccupPosPAGMeanStd(2)],'HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);

line(xlim,[21.5 21.5],'Color',[0.6 0.6 0.6],'LineStyle','--','LineWidth',1.5,'HandleVisibility','off');
text(1,23.2,'random level', 'FontWeight','bold','FontSize',8,'FontAngle', 'italic','Color',[0.6 0.6 0.6]);

for i=1:numel(D)
plot(xBar(:,1)+0.02,100*[OccupPre(1,i) OccupPosPAG(1,i)],'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');

plot(xBar(:,2)+0.02,100*[OccupPre(2,i) OccupPosPAG(2,i)],'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Percentage of time spent','fontweight','bold','fontsize',10);
ylim([0 58]);
title('Zone Occupancy');


subplot(2,2,2)

NumEntPreMean=mean(NumEntPre);
NumEntPreMeanStd=std(NumEntPre);

NumEntPosPAGMean=mean(NumEntPosPAG);
NumEntPosPAGMeanStd=std(NumEntPosPAG);


OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

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
plot([1 2]+manualjitter(i),[NumEntPre(i) NumEntPosPAG(i)],'color',[0.6,0.6,0.6],'linestyle','-','linewidth',1.2,...
    'marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor','w','MarkerSize',6,...
    'DisplayName',MouseName{i});
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 7]);
title('Number of entries in shock zone');


subplot(2,2,3)
FirstTimeShockPreMean=mean(FirstTimeShockPre);
FirstTimeShockPreMeanStd=std(FirstTimeShockPre);

FirstTimeShockPosPAGMean=mean(FirstTimeShockPosPAG);
FirstTimeShockPosPAGMeanStd=std(FirstTimeShockPosPAG);

FirstTimeShockProbeMean=mean(FirstTimeShockProbe);
FirstTimeShockProbeStd=std(FirstTimeShockProbe);

OccupLabels={'Pre-test';'Probe test';'Post PAG'};

hb = bar([1:3],[FirstTimeShockPreMean FirstTimeShockProbeMean FirstTimeShockPosPAGMean],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1:3],[FirstTimeShockPreMean FirstTimeShockProbeMean FirstTimeShockPosPAGMean],[FirstTimeShockPreMeanStd FirstTimeShockProbeStd FirstTimeShockPosPAGMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

hb.FaceColor = 'flat';
hb.CData(2,:) = [.5 .5 .5];


for i=1:numel(D)
plot([1:3]+manualjitter(i),[FirstTimeShockPre(i) FirstTimeShockProbe(i) FirstTimeShockPosPAG(i)],...
    'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]',...
    'MarkerFaceColor','w','MarkerSize',6);
end

xrange = xlim;
line(xrange,[240,240],'Color','red','LineWidth',2)
text(xrange(1),234,' no entries during test','Color','red','FontSize',8, 'FontWeight','bold','FontAngle', 'italic')

ylabel('Time (s)','fontweight','bold','fontsize',10);
% ylim([0 1300]);
title('First time to enter shock zone');

subplot(2,2,4)

SpeedShockPreMean=nanmean(SpeedShockPre);
SpeedShockPreMeanStd=nanstd(SpeedShockPre);

SpeedSafePreMean=nanmean(SpeedSafePre);
SpeedSafePreMeanStd=nanstd(SpeedSafePre);

SpeedShockPosPAGMean=nanmean(SpeedShockPosPAG);
SpeedShockPosPAGMeanStd=nanstd(SpeedShockPosPAG);

SpeedSafePosPAGMean=nanmean(SpeedSafePosPAG);
SpeedSafePosPAGMeanStd=nanstd(SpeedSafePosPAG);

bar([1 2],[SpeedSafePreMean SpeedSafePosPAGMean],'k')
set(gca,'xticklabel',{'Pre-tests';'Post-PAG';'Post-MFB'})
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1,2],[SpeedSafePreMean SpeedSafePosPAGMean],[SpeedSafePreMeanStd SpeedSafePosPAGMeanStd]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Speed in safe zone');
ylim([0 6.5]);

SpeedSafePosPAGZeroes=SpeedSafePosPAG;
SpeedSafePosPAGZeroes(isnan(SpeedSafePosPAGZeroes))= 0;

for i=1:numel(D)
plot([1 2]+manualjitter(i),[SpeedSafePre(i) SpeedSafePosPAGZeroes(i)],...
    'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]',...
    'MarkerFaceColor','w','MarkerSize',6);
end

text(find(isnan([SpeedSafePreMean SpeedSafePosPAGMean])),ones(length(find(isnan([SpeedShockPreMean SpeedShockPosPAGMean])))),{'No entries', 'in this zone'},'Color','red','vert','bottom','horiz','center','FontSize',8, 'FontWeight','bold')
