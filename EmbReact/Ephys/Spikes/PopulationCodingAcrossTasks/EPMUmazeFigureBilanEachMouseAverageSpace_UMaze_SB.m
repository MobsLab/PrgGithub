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
    AlignePostsd = ConcatenateDataFromFolders_SB(Dir,'alignedposition');
    
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
    
    EPOI.UMaze = UMaze;
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
    SkSfProj{2} = full(nanmean(Data(Restrict(Q,EPOI.UMazeMovSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeMovSk))));
    
    figure(1)
    clf
    
    for k  = 1:2
        
        figure(1)
        % Project with UMaze
        Q = MakeQfromS(Spikes(numNeurons),Binsize);
        Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
        Projtsd = tsd(Range(Q),full(Data(Q))*SkSfProj{k}');
        XY = Data(Restrict(Postsd,ts(Range(Q))));
        Xtsd = tsd(Range(Q),XY(:,1));
        Xtsd = tsd(Range(Xtsd),(Data(Xtsd) - nanmean(Data(Restrict(Xtsd,EPOI.EPMCentre))))/40);
        Ytsd = tsd(Range(Q),XY(:,2));
        Ytsd = tsd(Range(Ytsd),(Data(Ytsd) - nanmean(Data(Restrict(Ytsd,EPOI.EPMCentre))))/40);
        
        subplot(2,4,1+(k-1)*4)
        XTemp = Data(Restrict(Xtsd,EPOI.EPMClose));
        YTemp = Data(Restrict(Ytsd,EPOI.EPMClose));
        K=convhull(XTemp,YTemp);
        hold on
        plot(XTemp(K)*1.2,YTemp(K)*1.2,'linewidth',2,'color','k')
        scatter(Data(Xtsd),Data(Ytsd),15,Data(Projtsd)','filled')
        colormap(fliplr(redblue')')
        clim([-7 7])
        box off
        set(gca,'ycolor','w','xcolor','w','FontSize',16,'XTick',[],'YTick',[])
        axis tight
        
        AllData{k}.XEPM{mm} = Data(Xtsd);
        AllData{k}.YEPM{mm} = Data(Ytsd);
        AllData{k}.XYEPMProj{mm} = Data(Projtsd);

        
        
        subplot(2,4,2+(k-1)*4)
        plot(abs(Data(Restrict(Xtsd,EPOI.EPMOpen))),Data(Restrict(Projtsd,EPOI.EPMOpen)),'k.'), hold on
        plot(-abs(Data(Restrict(Ytsd,EPOI.EPMClose))),Data(Restrict(Projtsd,EPOI.EPMClose)),'k.')
        plot((Data(Restrict(Ytsd,EPOI.EPMCentre))),Data(Restrict(Projtsd,EPOI.EPMCentre)),'k.')
        xlabel('Position along EPM')
        ylabel('PFC unit projection')
        set(gca,'linewidth',2,'FontSize',11)
        box off
        X = [abs(Data(Restrict(Xtsd,EPOI.EPMOpen)));-abs(Data(Restrict(Ytsd,EPOI.EPMClose)))];
        Y = [Data(Restrict(Projtsd,EPOI.EPMOpen));Data(Restrict(Projtsd,EPOI.EPMClose))];
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        if k==1
            title(['R-EPMtrain-EPMtest = ' num2str(round(R(1,2)*100)/100)])
        else
            title(['R-UMazetrain-EPMtest = ' num2str(round(R(1,2)*100)/100)])
        end
        
        AllData{k}.LinEPM{mm} = X;
        AllData{k}.ProjLinEPM{mm} = Y;

        
        Q = MakeQfromS(Spikes(numNeurons),Binsize);
        Q = Restrict(Q,UMaze);    Q = tsd(Range(Q),zscore(Data(Q)));
        Projtsd = tsd(Range(Q),full(Data(Q))*SkSfProj{k}');
        Lintsd = Restrict(LinPos,ts(Range(Projtsd)));
        
        subplot(2,4,3+(k-1)*4)
        XY = Data(Restrict(AlignePostsd,ts(Range(Q))));
        Xtsd = tsd(Range(Q),XY(:,1));
        Ytsd = tsd(Range(Q),XY(:,2));
        scatter(Data(Xtsd),Data(Ytsd),15,Data(Projtsd)','filled')
        clim([-7 7])
        colormap(fliplr(redblue')')
        clim([-7 7])
        box off
        set(gca,'ycolor','w','xcolor','w','FontSize',16,'XTick',[],'YTick',[])
        axis tightXAlignPosUMaze

        AllData{k}.XAlignPosUMaze{mm} = Data(Xtsd);
        AllData{k}.YAlignPosUMaze{mm} = Data(Ytsd);

        
        subplot(2,4,4+(k-1)*4)
        plot(Data(Lintsd),full(Data(Projtsd)),'.k','linewidth',2)
        title(Titles{k})
        xlabel('Linearized UMaze')
        ylabel('PFC unit projection')
        set(gca,'linewidth',2,'FontSize',11)
        box off
        xlim([0 1])
        X = [Data(Lintsd)];
        Y = [full(Data(Projtsd))];
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        if k==1
            title(['R-EPMtrain-UMazetest = ' num2str(round(R(1,2)*100)/100)])
        else
            title(['R-UMazetrain-UMazetest = ' num2str(round(R(1,2)*100)/100)])
        end
        
        
        AllData{k}.LinPosUMaze{mm} = Data(Lintsd);
        AllData{k}.ProjLinPosUMaze{mm} = full(Data(Projtsd));

    end
    pause
%     saveas(1,[FolderName 'FigBilanEPMUMaze',num2str(mm),'.fig'])    
%     saveas(1,[FolderName 'FigBilanEPMUMaze',num2str(mm),'.png'])    
end

UMazeVals = [0:0.05:1];
EPMVals = [-1:0.05:1];

figure
clf
for mm = 1 : length(MiceNumber)-1
    subplot(221)
    k=1;
    scatter(AllData{k}.XEPM{mm},AllData{k}.YEPM{mm},5,AllData{k}.XYEPMProj{mm}','filled')
    hold on
    clim([-7 7])
    xlim([-1 1])
    ylim([-1 1])
    for ii=1:length(EPMVals)-1
        for iii = 1:length(EPMVals)-1
            GoodX = AllData{k}.XEPM{mm}>EPMVals(ii) & AllData{k}.XEPM{mm}<EPMVals(ii+1);
            GoodY = AllData{k}.YEPM{mm}>EPMVals(iii) & AllData{k}.YEPM{mm}<EPMVals(iii+1);
            
            AllDatEPMTrainEPMTest(mm,ii,iii) = nanmean(AllData{k}.XYEPMProj{mm}(find(and(GoodX,GoodY))));
            
        end
    end
%     AllDatEPMTrainEPMTest(mm,:,:) = AllDatEPMTrainEPMTest(mm,:,:)./nansum(nansum(squeeze(AllDatEPMTrainEPMTest(mm,:,:))));
    
    subplot(222)
    k=1;
    scatter(AllData{k}.XAlignPosUMaze{mm},AllData{k}.YAlignPosUMaze{mm},5,AllData{k}.ProjLinPosUMaze{mm}','filled')
    hold on
    clim([-7 7])
    for ii=1:length(UMazeVals)-1
        for iii = 1:length(UMazeVals)-1
            GoodX = AllData{k}.XAlignPosUMaze{mm}>UMazeVals(ii) & AllData{k}.XAlignPosUMaze{mm}<UMazeVals(ii+1);
            GoodY = AllData{k}.YAlignPosUMaze{mm}>UMazeVals(iii) & AllData{k}.YAlignPosUMaze{mm}<UMazeVals(iii+1);
            
            AllDatEPMTrainUMazeTest(mm,ii,iii) = nanmean(AllData{k}.ProjLinPosUMaze{mm}(find(and(GoodX,GoodY))));
            
        end
    end
%     AllDatEPMTrainUMazeTest(mm,:,:) = AllDatEPMTrainUMazeTest(mm,:,:)./nansum(nansum(squeeze(AllDatEPMTrainUMazeTest(mm,:,:))));
    
    subplot(223)
    k=2;
    scatter(AllData{k}.XEPM{mm},AllData{k}.YEPM{mm},5,AllData{k}.XYEPMProj{mm}','filled')
    hold on
    clim([-7 7])
    xlim([-1 1])
    ylim([-1 1])
    for ii=1:length(EPMVals)-1
        for iii = 1:length(EPMVals)-1
            GoodX = AllData{k}.XEPM{mm}>EPMVals(ii) & AllData{k}.XEPM{mm}<EPMVals(ii+1);
            GoodY = AllData{k}.YEPM{mm}>EPMVals(iii) & AllData{k}.YEPM{mm}<EPMVals(iii+1);
            
            AllDatUMazeTrainEPMTest(mm,ii,iii) = nanmean(AllData{k}.XYEPMProj{mm}(find(and(GoodX,GoodY))));
            
        end
    end
%     AllDatUMazeTrainEPMTest(mm,:,:) = AllDatUMazeTrainEPMTest(mm,:,:)./nansum(nansum(squeeze(AllDatUMazeTrainEPMTest(mm,:,:))));
    
    subplot(224)
    k=2;
    scatter(AllData{k}.XAlignPosUMaze{mm},AllData{k}.YAlignPosUMaze{mm},5,AllData{k}.ProjLinPosUMaze{mm}','filled')
    hold on
    clim([-7 7])
    for ii=1:length(UMazeVals)-1
        for iii = 1:length(UMazeVals)-1
            GoodX = AllData{k}.XAlignPosUMaze{mm}>UMazeVals(ii) & AllData{k}.XAlignPosUMaze{mm}<UMazeVals(ii+1);
            GoodY = AllData{k}.YAlignPosUMaze{mm}>UMazeVals(iii) & AllData{k}.YAlignPosUMaze{mm}<UMazeVals(iii+1);
            
            AllDatUMazeTrainUMazeTest(mm,ii,iii) = nanmean(AllData{k}.ProjLinPosUMaze{mm}(find(and(GoodX,GoodY))));
            
        end
    end
%     AllDatUMazeTrainUMazeTest(mm,:,:) = AllDatUMazeTrainUMazeTest(mm,:,:)./nansum(nansum(squeeze(AllDatUMazeTrainUMazeTest(mm,:,:))));
    
end

clf
subplot(2,2,1)
imagesc(squeeze(nanmean(AllDatEPMTrainEPMTest,1))'), axis xy
colormap([0,0,0,;fliplr(redblue')'])
colorbar
set(gca,'ycolor','w','xcolor','w','FontSize',11,'XTick',[],'YTick',[])
set(gca,'linewidth',2,'FontSize',11)

subplot(2,2,2)
imagesc(squeeze(nanmean(AllDatEPMTrainUMazeTest,1))'), axis xy
colorbar
set(gca,'ycolor','w','xcolor','w','FontSize',11,'XTick',[],'YTick',[])
set(gca,'linewidth',2,'FontSize',11)

subplot(2,2,3)
imagesc(squeeze(nanmean(AllDatUMazeTrainEPMTest,1))'), axis xy
colorbar
set(gca,'ycolor','w','xcolor','w','FontSize',11,'XTick',[],'YTick',[])
set(gca,'linewidth',2,'FontSize',11)

subplot(2,2,4)
imagesc(squeeze(nanmean(AllDatUMazeTrainUMazeTest,1))'), axis xy
colorbar
set(gca,'ycolor','w','xcolor','w','FontSize',11,'XTick',[],'YTick',[])
set(gca,'linewidth',2,'FontSize',11)












