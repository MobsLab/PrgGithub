for i=2:3
    subplot(3,1,1), hold on
    
    if i == 2
        plot(Range(SmoothTheta)/3600e4, Data(SmoothTheta), 'linewidth',1, 'color','k')
        try
            line([begin endin], [Info.theta_thresh Info.theta_thresh], 'linewidth',1, 'color',[0.7 0.7 0.7])
%         catch
%             load('StateEpochSB','Info')
%             line([begin endin], [Info.theta_thresh Info.theta_thresh], 'linewidth',1, 'color',[0.7 0.7 0.7])
        end
        xlim([begin endin]),
        title('Theta/Delta ratio')
        set(gca,'XTick',[])
    elseif i == 3
        plot(Range(tsdMovement)/3600e4, Data(tsdMovement), 'linewidth',1, 'color','k')
        line([begin endin], [Info.mov_threshold Info.mov_threshold], 'linewidth',1, 'color',[0.7 0.7 0.7])
        xlim([begin endin]),
        title('Movement')
    end
    yl=ylim;
    LineHeight = yl(2);
    line([begin endin], [LineHeight LineHeight], 'linewidth',10, 'color','w')
    try % décommenté le 190724 pour check
        PlotPerAsLine(REMEpochAcc, LineHeight, Colors.REM, 'timescaling', 3600e4, 'linewidth',10);
        PlotPerAsLine(SWSEpochAcc, LineHeight, Colors.SWS, 'timescaling', 3600e4, 'linewidth',10);
        PlotPerAsLine(WakeAcc, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
        PlotPerAsLine(TotalNoiseEpoch, LineHeight, Colors.Noise, 'timescaling', 3600e4, 'linewidth',5);
%     catch
%         load('StateEpochSB')
%         PlotPerAsLine(REMEpochAcc, LineHeight, Colors.REM, 'timescaling', 3600e4, 'linewidth',10);
%         PlotPerAsLine(SWSEpochAcc, LineHeight, Colors.SWS, 'timescaling', 3600e4, 'linewidth',10);
%         PlotPerAsLine(WakeAcc, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
%         PlotPerAsLine(TotalNoiseEpoch, LineHeight, Colors.Noise, 'timescaling', 3600e4, 'linewidth',5);
    end
end
    
%% save figure
try    
    res=pwd;
    cd(foldername);
    saveas(SleepScoringFigure, 'SleepScoringAccelero.png', 'png');
    cd(res);
catch    
    res=pwd;
    cd(foldername);
    saveas(SleepScoringFigure.Number, 'SleepScoringAccelero.png', 'png');
    cd(res);
end


