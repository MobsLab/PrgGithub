clear all
Dir=PathForExperimentsSleepRipplesSpikes('Basal')
FolderName = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks/';
cols = lines(5);
RemoveDown = 0;
Binsize = 1*1e4;
SpeedLim = 3;
FieldGroups{1} = {'HomeMov','EPMOpen','EPMClose','SoundFz','UMazeHab','SoundHab','UMazeMov' ,'UMazeFzSk','UMazeFzSf'};
FieldGroups{2} = {'EPMOpen','EPMClose','SoundFz','UMazeMov' ,'UMazeFzSk','UMazeFzSf'};
FieldGroups{3} = {'UMazeMov' ,'UMazeFzSk','UMazeFzSf'};
FieldGroups{4} = {'EPMOpen','EPMClose','EPMCentre'};

figure(2)
clf

MiceNumber=[490,507,508,509,510,512,514];

for mm = 1 : length(MiceNumber)
    
    tic
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    toc
    
    tic
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
    toc
    
    % Epoch of interest
    clear EPOI
    HomeCage = or(or(SessNames.SleepPost{1},SessNames.SleepPostSound{1}),or(SessNames.SleepPre{1},SessNames.SleepPreSound{1}));
    EPOI.HomeMov = and(SleepStates{1},HomeCage);
    
    EPOI.EPMOpen = and(SessNames.EPM{1},ZoneEpoch{1});
    EPOI.EPMClose = and(SessNames.EPM{1},ZoneEpoch{2});
    EPOI.EPMCentre = and(SessNames.EPM{1},ZoneEpoch{3});

    EPOI.SoundFz = and(SessNames.SoundTest{1},FreezeEpoch);
    EPOI.SoundHab = SessNames.SoundHab{1};

    UMaze = SessNames.UMazeCond{1};
    for i = 2:length(SessNames.UMazeCond)
        UMaze = or(UMaze, SessNames.UMazeCond{i});
    end
    EPOI.UMazeHab = SessNames.Habituation{1};
    EPOI.UMazeMov = and(UMaze,MovEpoch);
    EPOI.UMazeFzSf = and(and(UMaze,FreezeEpoch),thresholdIntervals(LinPos,0.6,'Direction','Above'));
    EPOI.UMazeFzSk = and(and(UMaze,FreezeEpoch),thresholdIntervals(LinPos,0.4,'Direction','Below'));
    

    clf
    subplot(241)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,or(EPOI.UMazeFzSf,EPOI.UMazeFzSk));
    Q = tsd(Range(Q),zscore(Data(Q)));
    SkSfProj = nanmean(Data(Restrict(Q,EPOI.UMazeFzSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeFzSk)));
    nhist({full(Data(Restrict(Q,EPOI.UMazeFzSf))*SkSfProj'),full(Data(Restrict(Q,EPOI.UMazeFzSk))*SkSfProj')},'noerror')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    xlabel('Sf vs Sk projection')
    legend('Sf','Sk')
    
    subplot(242)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,or(EPOI.EPMClose,EPOI.EPMOpen));
    Q = tsd(Range(Q),zscore(Data(Q)));
    nhist({full(Data(Restrict(Q,EPOI.EPMClose))*SkSfProj'),full(Data(Restrict(Q,EPOI.EPMOpen))*SkSfProj')},'noerror')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    xlabel('Sf vs Sk projection')
    legend('Close','Open')

    subplot(243)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,UMaze);
    Q = tsd(Range(Q),zscore(Data(Q)));
    plot(Data(Restrict(LinPos,ts(Range(Q)))),full(Data(Q)*SkSfProj'),'.k','linewidth',2)
    box off
    set(gca,'linewidth',2,'FontSize',16)
    ylabel('Sf vs Sk projection')
    xlabel('LinPos')

    subplot(244)
        XY = Data(Restrict(Postsd,EPOI.EPMClose));
    K=convhull(XY(:,1),XY(:,2));
    hold on
    plot(XY(K,1),XY(K,2),'linewidth',3,'color','k')
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
    XY = Data(Restrict(Postsd,ts(Range(Q))));
    scatter(XY(:,1),XY(:,2),15,full(Data(Q))*SkSfProj','filled')
    colormap(fliplr(redblue')')
    colorbar
    clim([-7 7])
    box off
    set(gca,'ycolor','w','xcolor','w','FontSize',16,'XTick',[],'YTick',[])
    axis tight

    subplot(245)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,or(EPOI.EPMClose,EPOI.EPMOpen));
    Q = tsd(Range(Q),zscore(Data(Q)));
    SkSfProj = nanmean(Data(Restrict(Q,EPOI.EPMClose)))-nanmean(Data(Restrict(Q,EPOI.EPMOpen)));
    nhist({full(Data(Restrict(Q,EPOI.EPMClose))*SkSfProj'),full(Data(Restrict(Q,EPOI.EPMOpen))*SkSfProj')},'noerror')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    xlabel('Close vs Open projection')
    legend('Close','Open')
    
    
    subplot(246)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,or(EPOI.UMazeFzSf,EPOI.UMazeFzSk));
    Q = tsd(Range(Q),zscore(Data(Q)));
    nhist({full(Data(Restrict(Q,EPOI.UMazeFzSf))*SkSfProj'),full(Data(Restrict(Q,EPOI.UMazeFzSk))*SkSfProj')},'noerror')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    xlabel('Close vs Open projection')
    legend('Sf','Sk')

    subplot(247)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);    
    Q = Restrict(Q,UMaze);
    Q = tsd(Range(Q),zscore(Data(Q)));
    plot(Data(Restrict(LinPos,ts(Range(Q)))),full(Data(Q)*SkSfProj'),'.k','linewidth',2)
     box off
    set(gca,'linewidth',2,'FontSize',16)
    ylabel('Sf vs Sk projection')
    xlabel('LinPos')
    
    subplot(248)
   XY = Data(Restrict(Postsd,EPOI.EPMClose));
    K=convhull(XY(:,1),XY(:,2));
    hold on
    plot(XY(K,1),XY(K,2),'linewidth',3,'color','k')
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
    XY = Data(Restrict(Postsd,ts(Range(Q))));
    scatter(XY(:,1),XY(:,2),15,full(Data(Q))*SkSfProj','filled')
    colormap(fliplr(redblue')')
    colorbar
    clim([-7 7])
    box off
    set(gca,'ycolor','w','xcolor','w','FontSize',16,'XTick',[],'YTick',[])
    axis tight

    saveas(2,[FolderName 'EPMvsUmazeALL',num2str(mm),'.png'])
    
    
        clf
    subplot(241)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,or(EPOI.UMazeFzSf,EPOI.UMazeFzSk));
    Q = tsd(Range(Q),zscore(Data(Q)));
    SkSfProj = nanmean(Data(Restrict(Q,EPOI.UMazeFzSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeFzSk)));
    SkSfProj = SkSfProj(randperm(length(SkSfProj)));
    nhist({full(Data(Restrict(Q,EPOI.UMazeFzSf))*SkSfProj'),full(Data(Restrict(Q,EPOI.UMazeFzSk))*SkSfProj')},'noerror')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    xlabel('Sf vs Sk projection')
    legend('Sf','Sk')
    
    subplot(242)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,or(EPOI.EPMClose,EPOI.EPMOpen));
    Q = tsd(Range(Q),zscore(Data(Q)));
    nhist({full(Data(Restrict(Q,EPOI.EPMClose))*SkSfProj'),full(Data(Restrict(Q,EPOI.EPMOpen))*SkSfProj')},'noerror')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    xlabel('Sf vs Sk projection')
    legend('Close','Open')

    subplot(243)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,UMaze);
    Q = tsd(Range(Q),zscore(Data(Q)));
    plot(Data(Restrict(LinPos,ts(Range(Q)))),full(Data(Q)*SkSfProj'),'.k','linewidth',2)
    box off
    set(gca,'linewidth',2,'FontSize',16)
    ylabel('Sf vs Sk projection')
    xlabel('LinPos')

    subplot(244)
        XY = Data(Restrict(Postsd,EPOI.EPMClose));
    K=convhull(XY(:,1),XY(:,2));
    hold on
    plot(XY(K,1),XY(K,2),'linewidth',3,'color','k')
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
    XY = Data(Restrict(Postsd,ts(Range(Q))));
    scatter(XY(:,1),XY(:,2),15,full(Data(Q))*SkSfProj','filled')
    colormap(fliplr(redblue')')
    colorbar
    clim([-7 7])
    box off
    set(gca,'ycolor','w','xcolor','w','FontSize',16,'XTick',[],'YTick',[])
    axis tight

    subplot(245)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,or(EPOI.EPMClose,EPOI.EPMOpen));
    Q = tsd(Range(Q),zscore(Data(Q)));
    SkSfProj = nanmean(Data(Restrict(Q,EPOI.EPMClose)))-nanmean(Data(Restrict(Q,EPOI.EPMOpen)));
        SkSfProj = SkSfProj(randperm(length(SkSfProj)));
    nhist({full(Data(Restrict(Q,EPOI.EPMClose))*SkSfProj'),full(Data(Restrict(Q,EPOI.EPMOpen))*SkSfProj')},'noerror')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    xlabel('Close vs Open projection')
    legend('Close','Open')
    
    
    subplot(246)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,or(EPOI.UMazeFzSf,EPOI.UMazeFzSk));
    Q = tsd(Range(Q),zscore(Data(Q)));
    nhist({full(Data(Restrict(Q,EPOI.UMazeFzSf))*SkSfProj'),full(Data(Restrict(Q,EPOI.UMazeFzSk))*SkSfProj')},'noerror')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    xlabel('Close vs Open projection')
    legend('Sf','Sk')

    subplot(247)
    Q = MakeQfromS(Spikes(numNeurons),Binsize);    
    Q = Restrict(Q,UMaze);
    Q = tsd(Range(Q),zscore(Data(Q)));
    plot(Data(Restrict(LinPos,ts(Range(Q)))),full(Data(Q)*SkSfProj'),'.k','linewidth',2)
     box off
    set(gca,'linewidth',2,'FontSize',16)
    ylabel('Sf vs Sk projection')
    xlabel('LinPos')
    
    subplot(248)
   XY = Data(Restrict(Postsd,EPOI.EPMClose));
    K=convhull(XY(:,1),XY(:,2));
    hold on
    plot(XY(K,1),XY(K,2),'linewidth',3,'color','k')
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
    XY = Data(Restrict(Postsd,ts(Range(Q))));
    scatter(XY(:,1),XY(:,2),15,full(Data(Q))*SkSfProj','filled')
    colormap(fliplr(redblue')')
    colorbar
    clim([-7 7])
    box off
    set(gca,'ycolor','w','xcolor','w','FontSize',16,'XTick',[],'YTick',[])
    axis tight

    saveas(2,[FolderName 'EPMvsUmazeRandALL',num2str(mm),'.png'])

end
