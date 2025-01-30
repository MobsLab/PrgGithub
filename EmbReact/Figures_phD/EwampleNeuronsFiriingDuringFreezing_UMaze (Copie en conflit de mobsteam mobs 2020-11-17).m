clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice

DecodingLimits = [0.4,0.6]; MiceNumber=[490,507,508,509,510,512,514];
% DecodingLimits = [0.2,0.8]; MiceNumber=[490,507,508,509,510,512,514];

Binsize = 0.1*1e4;
SpeedLim = 3;
WndwSz = 0.5*1e4;
FigureLocation = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/AllUnitsAllTime';
fig = figure;
for mm=1:length(MiceNumber)
    mm
    clear Dir Spikes numNeurons NoiseEpoch FreezeEpoch Vtsd StimEpoch MovEpoch
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'UMazeCond');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    MovAcctsd = ConcatenateDataFromFolders_SB(Dir,'accelero');
    SpB = ConcatenateDataFromFolders_SB(Dir,'Spectrum','Prefix','B_Low');
    ZoneEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','zoneepoch');
    StimEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
    LinPos= ConcatenateDataFromFolders_SB(Dir,'linearposition');
    Spikes = ConcatenateDataFromFolders_SB(Dir,'Spikes');
    cd(Dir{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
    Spikes = Spikes(numNeurons);
    TotalEpoch = intervalSet(0,max(Range(LinPos)));
    
    
    subplot(411)
    plot(Range(LinPos,'s'),Data(LinPos))
    xlim([0 2400])
    
    subplot(4,1,2:3)
    imagesc(Range(SpB,'s'),fLow,log(Data(SpB))'), axis xy
    colormap jet
    ylim([0 15])
    hold on
    plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+10,'*')
    yyaxis right
    plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k')
    title(num2str(MiceNumber(mm)))
    xlim([0 2400])
    subplot(414)
    for sp = 1 :length(Spikes)
        Q = MakeQfromS(Spikes(sp),*1e4);
        Q = Restrict(Q,TotalEpoch-intervalSet(Start(StimEpoch)-0.5,Start(StimEpoch)+1*1e4));
        plot(Range(Q,'s'),Data(Q))
        xlim([0 2400])
        title(num2str(sp))
        saveas(fig.Number, [FigureLocation filesep 'Mouse' num2str(MiceNumber(mm)) 'Unit' num2str(sp) '.png'])
    end
    
    
end

   
    
    
     mm=3

    clear Dir Spikes numNeurons NoiseEpoch FreezeEpoch Vtsd StimEpoch MovEpoch
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'UMazeCond');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    MovAcctsd = ConcatenateDataFromFolders_SB(Dir,'accelero');
    SpB = ConcatenateDataFromFolders_SB(Dir,'Spectrum','Prefix','B_Low');
    ZoneEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','zoneepoch');
    StimEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
    LinPos= ConcatenateDataFromFolders_SB(Dir,'linearposition');
    Spikes = ConcatenateDataFromFolders_SB(Dir,'Spikes');
    Vtsd = ConcatenateDataFromFolders_SB(Dir,'speed');
    FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
    
    SpeedLim = 3;
    MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
    cd(Dir{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
    Spikes = Spikes(numNeurons);
    TotalEpoch = intervalSet(0,max(Range(LinPos)));
    
    Q = MakeQfromS(Spikes,0.5*1E4);
    Q = tsd(Range(Q),nanzscore(Data(Q)')');
    VectShock = nanmean(Data(Restrict(Q,and(MovEpoch,or(ZoneEpoch{1},ZoneEpoch{4})))));
    VectSafe = nanmean(Data(Restrict(Q,and(MovEpoch,or(ZoneEpoch{2},ZoneEpoch{5})))));
    W = VectShock - VectSafe;
    Proj = tsd(Range(Q),Data(Q)*W');
    
   % figure
    clf
    subplot(6,2,[1,3])
    imagesc(Range(SpB,'s'),fLow,log(Data(SpB))'), axis xy
    hold on
    colormap jet
    ylim([0 15])
    plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+10,'.y','MarkerSize',30)
    plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+10,'k*')
    plot(Range((LinPos),'s'),Range((LinPos),'s')*0+12,'.','color',UMazeColors('center'),'MarkerSize',20)
    plot(Range(Restrict(LinPos,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),Range(Restrict(LinPos,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s')*0+12,'.','color',UMazeColors('shock'),'MarkerSize',20)
    plot(Range(Restrict(LinPos,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),Range(Restrict(LinPos,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s')*0+12,'.','color',UMazeColors('safe'),'MarkerSize',20)
    yyaxis right
    plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k')
    title('Session 1')
    xlim([0 600])
    set(gca,'FontSize',15,'linewidth',2)
    box off
    
    subplot(6,2,[1,3]+1)
    imagesc(Range(SpB,'s'),fLow,log(Data(SpB))'), axis xy
    colormap jet
    ylim([0 15])
    hold on
    plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+10,'.y','MarkerSize',30)
    hold on
    plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+10,'k*')
    plot(Range((LinPos),'s'),Range((LinPos),'s')*0+12,'.','color',UMazeColors('center'),'MarkerSize',20)
    plot(Range(Restrict(LinPos,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),Range(Restrict(LinPos,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s')*0+12,'.','color',UMazeColors('shock'),'MarkerSize',20)
    plot(Range(Restrict(LinPos,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),Range(Restrict(LinPos,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s')*0+12,'.','color',UMazeColors('safe'),'MarkerSize',20)
    yyaxis right
    plot(Range(MovAcctsd,'s'),runmean(Data(MovAcctsd),20),'k')
    title('Session 2')
    xlim([1940 2420])
    set(gca,'FontSize',15,'linewidth',2)
    box off
    
    
    GoodSpikes = [12,33,25]
    for sp = 1:length(GoodSpikes)
        Q = MakeQfromS(Spikes(GoodSpikes(sp)),2*1e4);
        Q = Restrict(Q,TotalEpoch-intervalSet(Start(StimEpoch)-0.5,Start(StimEpoch)+1*1e4));
        
        subplot(6,2,5+(sp-1)*2)
        bar(Range(Q,'s'),Data(Q))
        
        xlim([0 600])
        Yl1 = ylim;
        hold on
        set(gca,'FontSize',15,'linewidth',2)
        box off
        ylabel('FR (Hz)')

        
        subplot(6,2,6+(sp-1)*2)
        bar(Range(Q,'s'),Data(Q))
        xlim([1940 2420])
        Yl2 = ylim;
        
        subplot(6,2,5+(sp-1)*2)
        ylim([min([Yl1(1),Yl2(1)]) max([Yl1(2),Yl2(2)])])
        subplot(6,2,6+(sp-1)*2)
        ylim([min([Yl1(1),Yl2(1)]) max([Yl1(2),Yl2(2)])])
        hold off
        set(gca,'FontSize',15,'linewidth',2)
        box off
        ylabel('FR (Hz)')

    end
    
    subplot(6,2,5+(sp)*2)
    plot(Range(Proj,'s'),runmean(Data(Proj),1),'k')
    xlim([0 600])
%     ylim([-800 0])
    
    subplot(6,2,6+(sp)*2)
    plot(Range(Proj,'s'),runmean(Data(Proj),2),'k')
    xlim([1940 2420])
%     ylim([-800 0])

    figure
    GoodSpikes = [12,33,25]
    clear Fr
    for sp = 1:length(GoodSpikes)
        Q = MakeQfromS(Spikes(GoodSpikes(sp)),2*1e4);
        Q = Restrict(Q,TotalEpoch-intervalSet(Start(StimEpoch)-0.5,Start(StimEpoch)+1*1e4));
        subplot(3,1,sp)
        Fr(1) = nanmean(Data(Restrict(Q,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))))
        Fr(2) = nanmean(Data(Restrict(Q,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))))
        Fr(3) = nanmean(Data(Restrict(Q,(MovEpoch))));
        bar(Fr)
        set(gca,'FontSize',15,'linewidth',2,'XTick',[1:3],'XTIckLabel',{'SafeFz','ShockFz','Mov'})
        box off
        
    end

