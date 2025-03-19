%% Plots Shock zone occupancy during sleep importance experiments

OccupLabels={'Pre-test';'Post PAG'};

OccupPreMean=mean(OccupPre,2);
OccupPreStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGStd=std(OccupPosPAG,0,2);

OccupPAGMean=mean(OccupPAG,2);
OccupPAGStd=std(OccupPAG,0,2);

Maze = [0 0 1 1 0.65 0.65 0.35 0.35 0;0 1 1 0 0 0.8 0.8 0 0]';
ShockZone = [0 0.35 0.35 0 0;0 0 0.425 0.425 0]';

y_range=[0 1];
x_range=[0 1];

figure
subplot(2,2,1)
hold on
set(gca,'ColorOrderIndex',1)

for i=1:4
    plot(TrajPre{i}(:,1),TrajPre{i}(:,2));
end
ColOrd = get(gca,'ColorOrder');
plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
set(gca, 'YTick', []);
title('Pre-test Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim(x_range);
ylim(y_range);

subplot(2,2,2)
hold on
set(gca,'ColorOrderIndex',1)
for i=1:4
    plot(TrajPosPAG{i}(:,1),TrajPosPAG{i}(:,2));
end
plot(Maze(:,1),Maze(:,2),'k','linewidth',2)
plot(ShockZone(:,1),ShockZone(:,2),'r','linewidth',2)
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
set(gca, 'XTick', []);
lgd=legend('Trial 1','Trial 2','Trial 3','Trial 4');
aux=lgd.Location;
lgd.Location='southoutside';
aux=lgd.Orientation;
lgd.Orientation = 'horizontal';
title('Post-PAG Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',1.2);
xlim(x_range);
ylim(y_range);



subplot(2,2,3:4)
bar([1 2],100*[OccupPreMean(1) OccupPosPAGMean(1)],'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',1.2)
hold on
er = errorbar([1 2],100*[OccupPreMean(1) OccupPosPAGMean(1)],100*[OccupPreStd(1) OccupPosPAGStd(1)]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);

plot(ones(size(OccupPre,2))+0.1,100*OccupPre(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);
plot(2*ones(size(OccupPosPAG,2))+0.1,100*OccupPosPAG(1,:),'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',7);

ylabel('Occupancy of shock zone (%)','fontweight','bold','fontsize',10);
ylim([0 80]);
title('Shock zone occupancy during sleep importance experiment');

annotation('textbox', [0 0.9 1 0.1],'String'...
    ,'Mouse 932','EdgeColor',...
    'none','HorizontalAlignment', 'center','FontSize',14, 'FontWeight','bold')