function MakeSpreadAndBoxPlot_SB(A,Cols,X,Legends)
ShowPoints = 1;
% A should be a cell of data
% Cols should be a cell of colors
% X is the position for the ploits

for k = 1 : length(A)
    if sum(isnan(A{k}))<length(A{k})
    a=iosr.statistics.boxPlot(X(k),A{k}(:),'boxColor',Cols{k},'lineColor',[0.95 0.95 0.95],'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 5;
    hold on
if ShowPoints
    handlesplot=plotSpread(A{k}(:),'distributionColors','k','xValues',X(k),'spreadWidth',0.8); hold on;
    set(handlesplot{1},'MarkerSize',20)
    handlesplot=plotSpread(A{k}(:),'distributionColors',Cols{k}*0.4,'xValues',X(k),'spreadWidth',0.8); hold on;
    set(handlesplot{1},'MarkerSize',10)
end
    end
    MinA(k) = min(A{k});
    MaxA(k) = max(A{k});

end
xlim([min(X)-1 max(X)+1])
rg = max(MaxA)-min(MinA);

ylim([min(MinA)-rg*0.1 max(MaxA)+rg*0.1])
if exist('Legends')
set(gca,'XTick',X,'XTickLabel',Legends)
box off
set(gca,'FontSize',10,'Linewidth',1)
end