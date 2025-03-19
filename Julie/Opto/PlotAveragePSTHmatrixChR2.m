function PlotAveragePSTHmatrixChR2(matrix, color,plottitle, yaxistitle,sav,mean_or_raw)

if strcmp(mean_or_raw,'mean')
    shadedErrorBar([-80:80],nanmean(matrix')',stdError(matrix'), {'Color', color},1), hold on;
    shadedErrorBar([-80:80],nanmean((matrix'))',stdError((matrix')),'-k',1);
elseif strcmp(mean_or_raw,'raw')
    colori={[0 0.9 0.1],[0 0 1],[1 0 0],[0.7 0.3 0]};
    for i=1:size(matrix,2)
        plot([-80:80],matrix(:,i),'Color',colori {i}), hold on;% hold off
    end
end

ylabel(yaxistitle)
%title(plottitle)
xlim([-30 80])
YL=ylim;
line([0 0],[YL(1) YL(2)],'Color',[0.7 0.7 0.7])
line([30 30],[YL(1) YL(2)],'Color',[0.7 0.7 0.7])
line([45 45],[YL(1) YL(2)],'Color',[0.7 0.7 0.7])  


if sav
    set(gcf,'PaperPosition', [1 1 28 21])
    saveas (gcf, 'PSTHaveraged.fig')
    saveas (gcf, 'PSTHaveraged.png')
end

end