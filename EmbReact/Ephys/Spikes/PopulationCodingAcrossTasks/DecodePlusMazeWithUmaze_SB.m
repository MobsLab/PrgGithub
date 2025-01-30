clear all
FolderName = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks/';
Binsize = 1*1e4;
SpeedLim = 3;

Titles = {'EPM','UMazeFz','UMazeMv','UMazeAll'};

MiceNumber=[490,507,508,509,510,512,514];
figure(1)
figure(2)

for mm = 1 : length(MiceNumber)
    
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    
    
    % epochs
    NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');
    FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
    StimEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
    SessNames = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','sessiontype');
    ZoneEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','zoneepoch');
    SleepStates = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','sleepstates');
    
    Vtsd = ConcatenateDataFromFolders_SB(Dir,'speed');
    Postsd = ConcatenateDataFromFolders_SB(Dir,'position');
    
    MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
    MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4) - FreezeEpoch;
    
    LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
    
    % Spikes
    Spikes = ConcatenateDataFromFolders_SB(Dir,'Spikes');
    cd(Dir{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
    Spikes = Spikes(numNeurons);
    Q = MakeQfromS(Spikes(numNeurons),Binsize);


    % Epoch of interest
    clear EPOI
    
    EPOI.EPMOpen = and(SessNames.EPM{1},ZoneEpoch{1});
    EPOI.EPMClose = and(SessNames.EPM{1},ZoneEpoch{2});
    EPOI.EPMCentre = and(SessNames.EPM{1},ZoneEpoch{3});
    
    
    UMaze = SessNames.UMazeCond{1};
    for i = 2:length(SessNames.UMazeCond)
        UMaze = or(UMaze, SessNames.UMazeCond{i});
    end
    
    
    EPOI.UMazeFzSf = and(and(UMaze,FreezeEpoch),thresholdIntervals(LinPos,0.6,'Direction','Above'));
    EPOI.UMazeFzSk = and(and(UMaze,FreezeEpoch),thresholdIntervals(LinPos,0.4,'Direction','Below'));
    EPOI.UMazeMovSf = and(and(UMaze,MovEpoch),thresholdIntervals(LinPos,0.6,'Direction','Above'));
    EPOI.UMazeMovSk = and(and(UMaze,MovEpoch),thresholdIntervals(LinPos,0.4,'Direction','Below'));
    EPOI.UMazeSf = and(UMaze,thresholdIntervals(LinPos,0.6,'Direction','Above'));
    EPOI.UMazeSk = and(UMaze,thresholdIntervals(LinPos,0.4,'Direction','Below'));
    
    EPOI.UMazeMov = and(UMaze,MovEpoch);
    EPOI.UMazeFz = and(UMaze,FreezeEpoch);

    % X tracks the open arm position, Y tracks the closed arm position
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));

    XY = Data(Restrict(Postsd,ts(Range(Q))));
    Xtsd = tsd(Range(Q),XY(:,1));
    Xtsd = tsd(Range(Xtsd),(Data(Xtsd) - nanmean(Data(Restrict(Xtsd,EPOI.EPMCentre)))));
    EPOI.EPMOpenTrain = and(EPOI.EPMOpen,thresholdIntervals(Xtsd,0));
    EPOI.EPMOpenTest = EPOI.EPMOpen - EPOI.EPMOpenTrain;
    
    Ytsd = tsd(Range(Q),XY(:,2));
    Ytsd = tsd(Range(Ytsd),(Data(Ytsd) - nanmean(Data(Restrict(Ytsd,EPOI.EPMCentre)))));
    EPOI.EPMCloseTrain = and(EPOI.EPMClose,thresholdIntervals(Ytsd,0));
    EPOI.EPMCloseTest = EPOI.EPMClose - EPOI.EPMCloseTrain;
    
    clear SkSfProj
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
    SkSfProj{1} = full(nanmean(Data(Restrict(Q,EPOI.EPMCloseTrain)))-nanmean(Data(Restrict(Q,EPOI.EPMOpenTrain))));
    
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,UMaze);    Q = tsd(Range(Q),zscore(Data(Q)));
    SkSfProj{2} = full(nanmean(Data(Restrict(Q,EPOI.UMazeFzSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeFzSk))));
    SkSfProj{3} = full(nanmean(Data(Restrict(Q,EPOI.UMazeMovSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeMovSk))));
    SkSfProj{4} = full(nanmean(Data(Restrict(Q,EPOI.UMazeSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeSk))));
    
    figure(1)
    clf
    figure(2)
    clf

    for k  = 1:4
        figure(1)
        Q = MakeQfromS(Spikes(numNeurons),Binsize);
        Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
        Projtsd = tsd(Range(Q),full(Data(Q))*SkSfProj{k}');
        
        subplot(2,8,[1,2]+(k-1)*2)
        XTemp = Data(Restrict(Xtsd,EPOI.EPMClose));
        YTemp = Data(Restrict(Ytsd,EPOI.EPMClose));
        K=convhull(XTemp,YTemp);
        hold on
        plot(XTemp(K)*1.2,YTemp(K)*1.2,'linewidth',2,'color','k')
        scatter(Data(Xtsd),Data(Ytsd),15,Data(Projtsd)','filled')
        colormap(fliplr(redblue')')
        colorbar
        clim([-7 7])
        box off
        set(gca,'ycolor','w','xcolor','w','FontSize',16,'XTick',[],'YTick',[])
        axis tight
        title(Titles{k})
        
        subplot(4,4,9+(k-1))
        plot(abs(Data(Restrict(Xtsd,EPOI.EPMOpenTrain))),Data(Restrict(Projtsd,EPOI.EPMOpenTrain)),'r.'), hold on
        plot(-abs(Data(Restrict(Ytsd,EPOI.EPMCloseTrain))),Data(Restrict(Projtsd,EPOI.EPMCloseTrain)),'b.')
        plot((Data(Restrict(Ytsd,EPOI.EPMCentre))),Data(Restrict(Projtsd,EPOI.EPMCentre)),'.','color',[0.6 0.6 0.6])
        title('Train data')
        xlabel('Position along EPM')
        ylabel('PFC unit projection')
        set(gca,'linewidth',2,'FontSize',11)
        box off
        
        X = [-abs(Data(Restrict(Ytsd,EPOI.EPMCloseTrain)));abs(Data(Restrict(Xtsd,EPOI.EPMOpenTrain)))];
        Y = [(Data(Restrict(Projtsd,EPOI.EPMCloseTrain)));(Data(Restrict(Projtsd,EPOI.EPMOpenTrain)))];
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        AllMice.(Titles{k}).CorrEPMTrain(mm,1:2) = [R(1,2),P(1,2)];
        AllMice.(Titles{k}).MeanEPMTrain(mm,1:2) = [nanmean((Data(Restrict(Projtsd,EPOI.EPMCloseTrain)))),nanmean((Data(Restrict(Projtsd,EPOI.EPMOpenTrain))))];
        [p,h] = ranksum(((Data(Restrict(Projtsd,EPOI.EPMCloseTrain)))),((Data(Restrict(Projtsd,EPOI.EPMOpenTrain)))));
        AllMice.(Titles{k}).IsSigEPMTrain(mm) = p;
        
        
        subplot(4,4,13+(k-1))
        plot(abs(Data(Restrict(Xtsd,EPOI.EPMOpenTest))),Data(Restrict(Projtsd,EPOI.EPMOpenTest)),'r.'), hold on
        plot(-abs(Data(Restrict(Ytsd,EPOI.EPMCloseTest))),Data(Restrict(Projtsd,EPOI.EPMCloseTest)),'b.')
        plot((Data(Restrict(Ytsd,EPOI.EPMCentre))),Data(Restrict(Projtsd,EPOI.EPMCentre)),'.','color',[0.6 0.6 0.6])
        title('Test data')
        xlabel('Position along EPM')
        ylabel('PFC unit projection')
        set(gca,'linewidth',2,'FontSize',11)
        box off
        
        X = [-abs(Data(Restrict(Ytsd,EPOI.EPMCloseTest)));abs(Data(Restrict(Xtsd,EPOI.EPMOpenTest)))];
        Y = [(Data(Restrict(Projtsd,EPOI.EPMCloseTest)));(Data(Restrict(Projtsd,EPOI.EPMOpenTest)))];
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        AllMice.(Titles{k}).CorrEPMTest(mm,1:2) = [R(1,2),P(1,2)];
        AllMice.(Titles{k}).MeanEPMTest(mm,1:2) = [nanmean((Data(Restrict(Projtsd,EPOI.EPMCloseTest)))),nanmean((Data(Restrict(Projtsd,EPOI.EPMOpenTest))))];
        [p,h] = ranksum(((Data(Restrict(Projtsd,EPOI.EPMCloseTest)))),((Data(Restrict(Projtsd,EPOI.EPMOpenTest)))));
        AllMice.(Titles{k}).IsSigEPMTest(mm) = p;
         
                X = [-abs(Data(Restrict(Ytsd,EPOI.EPMClose)));abs(Data(Restrict(Xtsd,EPOI.EPMOpen)))];
        Y = [(Data(Restrict(Projtsd,EPOI.EPMClose)));(Data(Restrict(Projtsd,EPOI.EPMOpen)))];
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        AllMice.(Titles{k}).CorrEPMAll(mm,1:2) = [R(1,2),P(1,2)];
        AllMice.(Titles{k}).MeanEPMAll(mm,1:2) = [nanmean((Data(Restrict(Projtsd,EPOI.EPMClose)))),nanmean((Data(Restrict(Projtsd,EPOI.EPMOpen))))];
        [p,h] = ranksum(((Data(Restrict(Projtsd,EPOI.EPMClose)))),((Data(Restrict(Projtsd,EPOI.EPMOpen)))));
        AllMice.(Titles{k}).IsSigEPMAll(mm) = p;

        
        
        figure(2)
        Q = MakeQfromS(Spikes(numNeurons),Binsize);
        Q = Restrict(Q,UMaze);    Q = tsd(Range(Q),zscore(Data(Q)));
        Projtsd = tsd(Range(Q),full(Data(Q))*SkSfProj{k}');
        Lintsd = Restrict(LinPos,ts(Range(Projtsd)));
        
        subplot(3,4,k)
        plot(Data(Lintsd),full(Data(Projtsd)),'.k','linewidth',2)
        title(Titles{k})
        xlabel('Linearized UMaze')
        ylabel('PFC unit projection')
        set(gca,'linewidth',2,'FontSize',11)
        box off
        xlim([0 1])
        
        X = Data(Lintsd); Y = full(Data(Projtsd));
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        AllMice.(Titles{k}).CorrUMazeAll(mm,1:2) = [R(1,2),P(1,2)];
        AllMice.(Titles{k}).MeanUMazeValAll(mm,1:2) = [nanmean(Data(Restrict(Projtsd,EPOI.UMazeSf))),nanmean(Data(Restrict(Projtsd,EPOI.UMazeSk)))];
        [p,h] = ranksum(((Data(Restrict(Projtsd,EPOI.UMazeSf)))),((Data(Restrict(Projtsd,EPOI.UMazeSk)))));
        AllMice.(Titles{k}).IsUMazeValAll(mm) = p;

        subplot(3,4,k+4)
        plot(Data(Restrict(Lintsd,EPOI.UMazeMov)),full(Data(Restrict(Projtsd,ts(Range(Restrict(Lintsd,EPOI.UMazeMov)))))),'.k','linewidth',2)
        title('Mov only')
        xlabel('Linearized UMaze')
        ylabel('PFC unit projection')
        set(gca,'linewidth',2,'FontSize',11)
        box off
        xlim([0 1])
        
        X = Data(Restrict(Lintsd,EPOI.UMazeMov)); Y = full(Data(Restrict(Projtsd,ts(Range(Restrict(Lintsd,EPOI.UMazeMov))))));
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        AllMice.(Titles{k}).CorrUMazeMov(mm,1:2) = [R(1,2),P(1,2)];
        AllMice.(Titles{k}).MeanUMazeValMov(mm,1:2) = [nanmean(Data(Restrict(Projtsd,EPOI.UMazeMovSf))),nanmean(Data(Restrict(Projtsd,EPOI.UMazeMovSk)))];
        [p,h] = ranksum(((Data(Restrict(Projtsd,EPOI.UMazeMovSf)))),((Data(Restrict(Projtsd,EPOI.UMazeMovSk)))));
        AllMice.(Titles{k}).IsUMazeValMov(mm) = p;

        
        subplot(3,4,k+8)
        plot(Data(Restrict(Lintsd,EPOI.UMazeFz)),full(Data(Restrict(Projtsd,ts(Range(Restrict(Lintsd,EPOI.UMazeFz)))))),'.k','linewidth',2)
        title('Fz only')
        xlabel('Linearized UMaze')
        ylabel('PFC unit projection')
        set(gca,'linewidth',2,'FontSize',11)
        box off
        xlim([0 1])
        
        X = Data(Restrict(Lintsd,EPOI.UMazeFz)); Y = full(Data(Restrict(Projtsd,ts(Range(Restrict(Lintsd,EPOI.UMazeFz))))));
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        AllMice.(Titles{k}).CorrUMazeFz(mm,1:2) = [R(1,2),P(1,2)];
        AllMice.(Titles{k}).MeanUMazeValFz(mm,1:2) = [nanmean(Data(Restrict(Projtsd,EPOI.UMazeFzSf))),nanmean(Data(Restrict(Projtsd,EPOI.UMazeFzSk)))];
        [p,h] = ranksum(((Data(Restrict(Projtsd,EPOI.UMazeFzSf)))),((Data(Restrict(Projtsd,EPOI.UMazeFzSk)))));
        AllMice.(Titles{k}).IsUMazeValFz(mm) = p;


    end
    AllMice.Weights{mm} = SkSfProj;
    
    saveas(1,[FolderName 'EPMDataProjectedEPMUMaze',num2str(mm),'.png'])
    saveas(2,[FolderName 'UMazeDataProjectedEPMUMaze',num2str(mm),'.png'])
    
end


cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks
save('AllMiceEPMUmaze.mat','AllMice')

% MeanValues

clf
for k  = 1:4
    
    %     Vals{k} = AllMice.(Titles{k}).CorrEPMTrain(:,1);
    Vals{1}{k} = -AllMice.(Titles{k}).CorrEPMAll(:,1);
    
    %     Vals{k} = AllMice.(Titles{k}).CorrEPMTest(:,1);
    Vals{2}{k} = AllMice.(Titles{k}).MeanEPMTrain(:,1)-AllMice.(Titles{k}).MeanEPMTrain(:,2);
    Vals{3}{k} = AllMice.(Titles{k}).CorrUMazeAll(:,1);
    %     Vals{k} = AllMice.(Titles{k}).CorrUMazeFz(:,1);
    Vals{4}{k} = AllMice.(Titles{k}).MeanUMazeValAll(:,1)-AllMice.(Titles{k}).MeanUMazeValAll(:,2);
    
end

PlotTitles = {'CorrEPM','DiffEPM','CorrUMaze','DiffUMaze'};
for k = 1:4
subplot(2,2,k)
PlotErrorBarN_KJ(Vals{k}([1,3]),'newfig',0,'ShowSigStar','none','paired',0)
YL = ylim;
ylim([YL(1) YL(2)*1.2])
text(1.75, YL(2)*1.1,num2str(signrank(Vals{k}{3})))
text(0.75, YL(2)*1.1,num2str(signrank(Vals{k}{1})))
title(PlotTitles{k})
set(gca,'XTick', [1,2],'XTickLabel',{'EPM trained','UMaze trained'})
set(gca,'linewidth',2,'FontSize',15)
xlim([0.5 2.5])
end



