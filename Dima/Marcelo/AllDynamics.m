figure
Colors = lines(numel(D)); 
% Colors = ones(numel(D),3); %for white markers
subplot(2,3,1)

OccupPreTrialsMean=mean(OccupPreTrials,3);
OccupPreTrialsStd=std(OccupPreTrials,0,3);

OccupPosPAGTrialsMean=mean(OccupPosPAGTrials,3);
OccupPosPAGTrialsStd=std(OccupPosPAGTrials,0,3);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax = 92;

hb = bar([1:4],100*[OccupPreTrialsMean(1,:);OccupPreTrialsMean(2,:)]','k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
hb(1).LineWidth = 2;
leg = {'Shock Zone','Safe Zone'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,100*[OccupPreTrialsMean(1,:);OccupPreTrialsMean(2,:)]',...
    100*[OccupPreTrialsStd(1,:);OccupPreTrialsStd(2,:)]','HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);

line(xlim,[21.5 21.5],'Color',[0.6 0.6 0.6],'LineStyle','--','LineWidth',1.5,'HandleVisibility','off');
text(1,23.2,'random level', 'FontWeight','bold','FontSize',8,'FontAngle', 'italic','Color',[0.6 0.6 0.6]);

hold on

for i=1:numel(D)
plot(xBar(:,1)+0.02,100*OccupPreTrials(1,:,i),'color',[0 0 0],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    Colors(i,:),'MarkerSize',6,'HandleVisibility','off');

plot(xBar(:,2)+0.02,100*OccupPreTrials(2,:,i),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    Colors(i,:),'MarkerSize',6,'HandleVisibility','off');
end

ylabel('Percentage of time spent','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Zone Occupancy - Pre-tests');



subplot(2,3,4)
OccupPreTrialsMean=mean(OccupPreTrials,3);
OccupPreTrialsStd=std(OccupPreTrials,0,3);

OccupPosPAGTrialsMean=mean(OccupPosPAGTrials,3);
OccupPosPAGTrialsStd=std(OccupPosPAGTrials,0,3);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax = 92;

hb = bar([1:4],100*[OccupPosPAGTrialsMean(1,:);OccupPosPAGTrialsMean(2,:)]','k');
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
hb(1).LineWidth = 2;
leg = {'Shock Zone','Safe Zone'};
legend(hb,leg);
xBar=cell2mat(get(hb,'XData')).' + [hb.XOffset];
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar(xBar,100*[OccupPosPAGTrialsMean(1,:);OccupPosPAGTrialsMean(2,:)]',...
    100*[OccupPosPAGTrialsStd(1,:);OccupPosPAGTrialsStd(2,:)]','HandleVisibility','off');    
er(1).Color = [0 0 0];
er(2).Color = [0 0 0];  
er(1).LineStyle = 'none';
set(er(1),'LineWidth',2);
er(2).LineStyle = 'none';
set(er(2),'LineWidth',2);

line(xlim,[21.5 21.5],'Color',[0.6 0.6 0.6],'LineStyle','--','LineWidth',1.5,'HandleVisibility','off');
text(1,23.2,'random level', 'FontWeight','bold','FontSize',8,'FontAngle', 'italic','Color',[0.6 0.6 0.6]);

hold on

for i=1:numel(D)
plot(xBar(:,1)+0.02,100*OccupPosPAGTrials(1,:,i),'color',[0 0 0],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    Colors(i,:),'MarkerSize',6,'HandleVisibility','off');

plot(xBar(:,2)+0.02,100*OccupPosPAGTrials(2,:,i),'color',[0.6 0.6 0.6],...
    'linestyle','none','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    Colors(i,:),'MarkerSize',6,'HandleVisibility','off');
end

ylabel('Percentage of time spent','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Zone Occupancy - Post-PAG tests');

subplot(2,3,2)
NumEntPreTrialsMean=mean(NumEntPreTrials,2);
NumEntPreTrialsStd=std(NumEntPreTrials,0,2);

NumEntPosPAGTrialsMean=mean(NumEntPosPAGTrials,2);
NumEntPosPAGTrialsStd=std(NumEntPosPAGTrials,0,2);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};

ymax=5;

subplot(2,3,2)
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
plot([1:4]+0.1,NumEntPreTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',Colors(i,:),'MarkerSize',6);
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Shock zone entries - Pre-tests');

subplot(2,3,5)
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
plot([1:4]+0.1,NumEntPosPAGTrials(:,i),'color',[0.6 0.6 0.6],'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',Colors(i,:),'MarkerSize',6);
end

ylabel('Entry count','fontweight','bold','fontsize',10);
ylim([0 ymax]);
title('Shock zone entries - Post-PAG tests');

SpeedSafePreTrialsAverage = cellfun(@nanmean,SpeedSafePreTrials);
SpeedSafePosPAGTrialsAverage = cellfun(@nanmean,SpeedSafePosPAGTrials);

SpeedSafePreTrialsMean = mean(SpeedSafePreTrialsAverage,2);
SpeedSafePreTrialsStd = std(SpeedSafePreTrialsAverage,0,2);

SpeedSafePosPAGTrialsMean = mean(SpeedSafePosPAGTrialsAverage,2);
SpeedSafePosPAGTrialsStd = std(SpeedSafePosPAGTrialsAverage,0,2);

OccupLabels={'Trial 1';'Trial 2';'Trial 3';'Trial 4'};
ymax = 8.1;

subplot(2,3,3)
bar([1:4],SpeedSafePreTrialsMean,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1:4],SpeedSafePreTrialsMean,SpeedSafePreTrialsStd);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Safe zone speed - Pre-tests');
ylim([0 ymax]);
for i=1:numel(D)
plot([1:4]+0.1,SpeedSafePreTrialsAverage(:,i),'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor',Colors(i,:),'MarkerSize',6);
end

subplot(2,3,6)
bar([1:4],SpeedSafePosPAGTrialsMean,'k','HandleVisibility','off')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2);
hold on
er = errorbar([1:4],SpeedSafePosPAGTrialsMean,SpeedSafePosPAGTrialsStd,'HandleVisibility','off');    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Speed (cm/s)','fontweight','bold','fontsize',10);
title('Safe zone speed - Post-PAG tests');
ylim([0 ymax]);
for i=1:numel(D)
plot([1:4]+0.1,SpeedSafePosPAGTrialsAverage(:,i),'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor',Colors(i,:),'MarkerSize',6);
end

lgd=legend(MouseName);
aux=lgd.Location;
lgd.Location='eastoutside';



