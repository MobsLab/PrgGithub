figure

OccupPreMean=mean(OccupPre,2);
OccupPreMeanStd=std(OccupPre,0,2);

OccupPosPAGMean=mean(OccupPosPAG,2);
OccupPosPAGMeanStd=std(OccupPosPAG,0,2);

OccupLabels={'Pre-test';'Post PAG';'Post MFB'};

hb = bar([1 2],100*[OccupPreMean(1) OccupPreMean(2);OccupPosPAGMean(1) OccupPosPAGMean(2)],'k')
hb(2).FaceColor = [1 1 1];
hb(2).LineWidth = 2;
leg = {'Safe Zone','Shock Zone'};
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
text(1,23.2,'random level', 'FontWeight','bold','FontSize',8,'FontAngle', 'italic');

for i=1:numel(D)
plot(xBar(:,1)+0.02,100*[OccupPre(1,i) OccupPosPAG(1,i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');

plot(xBar(:,2)+0.02,100*[OccupPre(2,i) OccupPosPAG(2,i)],'color',[0.6 0.6 0.6],...
    'linestyle','-','marker','o','MarkerEdgeColor', [0 0 0]','MarkerFaceColor',...
    'w','MarkerSize',6,'HandleVisibility','off');
end

ylabel('Percentage of time spent','fontweight','bold','fontsize',10);
ylim([0 58]);
title('Zone Occupancy');