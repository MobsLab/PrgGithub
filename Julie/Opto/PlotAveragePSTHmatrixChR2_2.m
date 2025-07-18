function PlotAveragePSTHmatrixChR2_2(matrix, color,plottitle, yaxistitle,sav,StepName)
% 24.11.2016
% same as PlotAveragePSTHmatrixChR2 but take 



    shadedErrorBar([-80:80],nanmean(matrix')',stdError(matrix'), {'Color', color},1), hold on;
    shadedErrorBar([-80:80],nanmean((matrix'))',stdError((matrix')),'-k',1);
%     % be careful, now the matrices are sorted: first sham, then bulb
%     shadedErrorBar([-50:50],nanmean((matrix(:,size(sham,1)+1:end)'))',stdError((matrix(:,size(sham,1)+1:end)')), {'Color', color},1), hold on;
%     shadedErrorBar([-50:50],nanmean((matrix(:,1:size(sham,1))'))',stdError((matrix(:,1:size(sham,1))')),'-k',1);
%         shadedErrorBar([-50:50],nanmean((matrix(:,1:7)'))',nanstd((matrix(:,1:7)')), {'Color', color},1), hold on;
%         shadedErrorBar([-50:50],nanmean((matrix(:,8:14)'))',nanstd((matrix(:,8:14)')),'-k',1);
    ylabel(yaxistitle)
    title(plottitle)
    xlim([-30 80])
    YL=ylim;
    line([0 0],[YL(1) YL(2)],'Color',[0.7 0.7 0.7])
    line([30 30],[YL(1) YL(2)],'Color',[0.7 0.7 0.7])
    line([45 45],[YL(1) YL(2)],'Color',[0.7 0.7 0.7])  
    %legend (['n_m_i_c_e = ' num2str(size(matrix,2))])
    
    
%     if strcmp(plottitle, StepName{2})
%         ylim([0 20])
%     elseif strcmp(plottitle, 'EXTpleth')
%         ylim([0 10])
%     elseif strcmp(plottitle, StepName{4})
%         ylim([0 20])
%     else 
%         ylim([0 20])
%     end
    
    if sav
        set(gcf,'PaperPosition', [1 1 28 21])
        saveas (gcf, 'PSTHaveraged.fig')
        saveas (gcf, 'PSTHaveraged.png')
    end
end