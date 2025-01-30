clear all
FolderName = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks/';
Binsize = 1*1e4;
SpeedLim = 3;

Titles = {'EPM','UMazeFz','UMazeMv','UMazeAll'};

MiceNumber=[490,507,508,509,510,512,514];

permnum = 1000;

for mm = 1 : length(MiceNumber)
    
    disp(MiceNumber(mm))
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
    AlignedPostsd = ConcatenateDataFromFolders_SB(Dir,'alignedposition');

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
%     SessNames.EPM{1} = and(SessNames.EPM{1},intervalSet(Start(SessNames.EPM{1}),Start(SessNames.EPM{1})+300*1e4));
    
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
    
    
    % Calculate projection vectors and get X-Y position
    clear ProjVect
    % EPM
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
    ProjVect{1} = full(nanmean(Data(Restrict(Q,EPOI.EPMClose)))-nanmean(Data(Restrict(Q,EPOI.EPMOpen))));
    XY = Data(Restrict(Postsd,ts(Range(Q))));
    Xtsd_EPM = tsd(Range(Q),XY(:,1));
    Xtsd_EPM = tsd(Range(Xtsd_EPM),(Data(Xtsd_EPM) - nanmean(Data(Restrict(Xtsd_EPM,EPOI.EPMCentre)))));
    Ytsd_EPM = tsd(Range(Q),XY(:,2));
    Ytsd_EPM = tsd(Range(Ytsd_EPM),(Data(Ytsd_EPM) - nanmean(Data(Restrict(Ytsd_EPM,EPOI.EPMCentre)))));
    
    % Random EPM
    AllClose = Data(Restrict(Q,EPOI.EPMClose));
    AllOpen = Data(Restrict(Q,EPOI.EPMOpen));
    minlong  = min([size(AllClose,1),size(AllOpen,1)]);
    for p = 1 : permnum
        AllCloseRand = AllClose(randperm(length(AllClose),minlong),:);
        AllOpenRand = AllOpen(randperm(length(AllOpen),minlong),:);
        AllCloseRandFinal = [AllCloseRand(1:floor(minlong/2),:);AllOpenRand(floor(minlong/2):end,:)];
        AllOpenRandFinal = [AllOpenRand(1:floor(minlong/2),:);AllCloseRand(floor(minlong/2):end,:)];
        ProjVectRand{1}(p,:) = full(nanmean(AllCloseRandFinal)-nanmean(AllOpenRandFinal));
    end
    
    % UMaze
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,UMaze);    Q = tsd(Range(Q),zscore(Data(Q)));
    ProjVect{2} = full(nanmean(Data(Restrict(Q,EPOI.UMazeFzSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeFzSk))));
    AllClose = Data(Restrict(Q,EPOI.UMazeFzSf));
    AllOpen = Data(Restrict(Q,EPOI.UMazeFzSk));
    minlong  = min([size(AllClose,1),size(AllOpen,1)]);
    for p = 1 : permnum
        AllCloseRand = AllClose(randperm(length(AllClose),minlong),:);
        AllOpenRand = AllOpen(randperm(length(AllOpen),minlong),:);
        AllCloseRandFinal = [AllCloseRand(1:floor(minlong/2),:);AllOpenRand(floor(minlong/2):end,:)];
        AllOpenRandFinal = [AllOpenRand(1:floor(minlong/2),:);AllCloseRand(floor(minlong/2):end,:)];
        ProjVectRand{2}(p,:) = full(nanmean(AllCloseRandFinal)-nanmean(AllOpenRandFinal));
    end
    
    ProjVect{3} = full(nanmean(Data(Restrict(Q,EPOI.UMazeMovSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeMovSk))));
    AllClose = Data(Restrict(Q,EPOI.UMazeMovSf));
    AllOpen = Data(Restrict(Q,EPOI.UMazeMovSk));
    minlong  = min([size(AllClose,1),size(AllOpen,1)]);
    for p = 1 : permnum
        AllCloseRand = AllClose(randperm(length(AllClose),minlong),:);
        AllOpenRand = AllOpen(randperm(length(AllOpen),minlong),:);
        AllCloseRandFinal = [AllCloseRand(1:floor(minlong/2),:);AllOpenRand(floor(minlong/2):end,:)];
        AllOpenRandFinal = [AllOpenRand(1:floor(minlong/2),:);AllCloseRand(floor(minlong/2):end,:)];
        ProjVectRand{3}(p,:) = full(nanmean(AllCloseRandFinal)-nanmean(AllOpenRandFinal));
    end
    
    ProjVect{4} = full(nanmean(Data(Restrict(Q,EPOI.UMazeSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeSk))));
    AllClose = Data(Restrict(Q,EPOI.UMazeSf));
    AllOpen = Data(Restrict(Q,EPOI.UMazeSk));
    minlong  = min([size(AllClose,1),size(AllOpen,1)]);
    for p = 1 : permnum
        AllCloseRand = AllClose(randperm(length(AllClose),minlong),:);
        AllOpenRand = AllOpen(randperm(length(AllOpen),minlong),:);
        AllCloseRandFinal = [AllCloseRand(1:floor(minlong/2),:);AllOpenRand(floor(minlong/2):end,:)];
        AllOpenRandFinal = [AllOpenRand(1:floor(minlong/2),:);AllCloseRand(floor(minlong/2):end,:)];
        ProjVectRand{4}(p,:) = full(nanmean(AllCloseRandFinal)-nanmean(AllOpenRandFinal));
    end
    
    XY = Data(Restrict(AlignedPostsd,ts(Range(Q))));
    Xtsd_UMaze = tsd(Range(Q),XY(:,1));
    Ytsd_UMaze = tsd(Range(Q),XY(:,2));

   
    % Get projections and decode
    for k  = 1:4

        %% EPM data
        Q = MakeQfromS(Spikes(numNeurons),Binsize);
        Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
        Projtsd = tsd(Range(Q),full(Data(Q))*ProjVect{k}');

        % Accuracy
        Thresh.EPM(k) = (nanmean(Data(Restrict(Projtsd,EPOI.EPMClose))) + nanmean(Data(Restrict(Projtsd,EPOI.EPMOpen))))/2;
        Accuracy.EPM(k) = (nanmean(Data(Restrict(Projtsd,EPOI.EPMClose))>Thresh.EPM(k)) + nanmean(Data(Restrict(Projtsd,EPOI.EPMOpen))<Thresh.EPM(k)))/2;
        
        % AccuracyRand
        for p = 1 : permnum
            ProjtsdRand = tsd(Range(Q),full(Data(Q))*ProjVectRand{k}(p,:)');
            ThreshRand = (nanmean(Data(Restrict(ProjtsdRand,EPOI.EPMClose))) + nanmean(Data(Restrict(ProjtsdRand,EPOI.EPMOpen))))/2;
            AccuracyRand.EPM(k,p) = (nanmean(Data(Restrict(ProjtsdRand,EPOI.EPMClose))>ThreshRand) + nanmean(Data(Restrict(ProjtsdRand,EPOI.EPMOpen))<ThreshRand))/2;
        end
        
        
        % Projected data
        ProjectedData.EPM{k} = Data(Projtsd);
        
        % Correlation
        X = [-abs(Data(Restrict(Ytsd_EPM,EPOI.EPMClose)));abs(Data(Restrict(Xtsd_EPM,EPOI.EPMOpen)))];
        Y = [(Data(Restrict(Projtsd,EPOI.EPMClose)));(Data(Restrict(Projtsd,EPOI.EPMOpen)))];
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        Corr.EPM(k,:) = [R(1,2),P(1,2)];
        
        % Mean difference
        MeanVals.EPM(k,:) = [nanmean((Data(Restrict(Projtsd,EPOI.EPMClose)))),nanmean((Data(Restrict(Projtsd,EPOI.EPMOpen))))];
        [p,h] = ranksum(((Data(Restrict(Projtsd,EPOI.EPMClose)))),((Data(Restrict(Projtsd,EPOI.EPMOpen)))));
        SigDiff.EPM(k) = p;
        
        
        %% UMaze
        Q = MakeQfromS(Spikes(numNeurons),Binsize);
        Q = Restrict(Q,UMaze);    Q = tsd(Range(Q),zscore(Data(Q)));
        Projtsd = tsd(Range(Q),full(Data(Q))*ProjVect{k}');
        Lintsd = Restrict(LinPos,ts(Range(Projtsd)));
        
        % Accuracy
        Thresh.UMaze(k)  = (nanmean(Data(Restrict(Projtsd,EPOI.UMazeSf))) + nanmean(Data(Restrict(Projtsd,EPOI.UMazeSk))))/2;
        Accuracy.UMaze(k) = (nanmean(Data(Restrict(Projtsd,EPOI.UMazeSf))>Thresh.UMaze(k)) + nanmean(Data(Restrict(Projtsd,EPOI.UMazeSk))<Thresh.UMaze(k)))/2;

        
        % AccuracyRand
        for p = 1 : permnum
            ProjtsdRand = tsd(Range(Q),full(Data(Q))*ProjVectRand{k}(p,:)');
            ThreshRand = (nanmean(Data(Restrict(ProjtsdRand,EPOI.UMazeSf))) + nanmean(Data(Restrict(ProjtsdRand,EPOI.UMazeSk))))/2;
            AccuracyRand.UMaze(k,p) = (nanmean(Data(Restrict(ProjtsdRand,EPOI.UMazeSf))>ThreshRand) + nanmean(Data(Restrict(ProjtsdRand,EPOI.UMazeSk))<ThreshRand))/2;
        end

        
        % Projected data
        ProjectedData.UMaze{k} = Data(Projtsd);

        % Correlation
        X = Data(Lintsd); Y = full(Data(Projtsd));
        B = find(or(isnan(X),isnan(Y)));
        X(B) = []; Y(B) = [];
        [R,P] = corrcoef(X,Y);
        Corr.UMaze(k,:) = [R(1,2),P(1,2)];
        
        % Mean difference
        MeanVals.UMaze(k,:)  = [nanmean(Data(Restrict(Projtsd,EPOI.UMazeSf))),nanmean(Data(Restrict(Projtsd,EPOI.UMazeSk)))];
        [p,h] = ranksum(((Data(Restrict(Projtsd,EPOI.UMazeSf)))),((Data(Restrict(Projtsd,EPOI.UMazeSk)))));
        SigDiff.UMaze(k,:) = p;

    end
    
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks/DecodingResults
    save(['EPMShort_UMazeDecoding' num2str(MiceNumber(mm)) '.mat'],'SigDiff','Corr','Accuracy','MeanVals','Xtsd_UMaze','Ytsd_UMaze',...
        'Ytsd_EPM','Xtsd_EPM')
    clear SigDiff Corr Accuracy MeanVals Xtsd_UMaze Ytsd_UMaze Ytsd_EPM Xtsd_EPM
    
end


clf
for mm = 1 : length(MiceNumber)
    if mm~=4
        load(['EPMShort_UMazeDecoding' num2str(MiceNumber(mm)) '.mat'])
        AllEPMCorr(mm,:) = -Corr.EPM(:,1);
        AllUMazeCorr(mm,:) = Corr.UMaze(:,1);
        
        AllEPMAcc(mm,:) = Accuracy.EPM;
        AllUMazeAcc(mm,:) = Accuracy.UMaze;
    else
        AllEPMCorr(mm,:) = NaN;
        AllUMazeCorr(mm,:) = NaN;
        
        AllEPMAcc(mm,:) = NaN;
        AllUMazeAcc(mm,:) =NaN;
    end
    
end

figure
subplot(2,2,1)
PlotErrorBarN_KJ(AllEPMCorr(:,[1,4]),'newfig',0,'ShowSigstar','none')
for k = 1:4
    p(k) = signrank(AllEPMCorr(:,k));
end
sigstar({[0.9,1.1],[1.9,2.1]},p([1,4]))
title('EPM data')
set(gca,'XTick',[1,2],'XTickLabel',{'EPM train','Umaze train'},'LineWidth',2)
ylabel('Corr coeff')
xtickangle(30)
ylim([-0.05 1])

subplot(2,2,2)
PlotErrorBarN_KJ(AllUMazeCorr(:,[1,4]),'newfig',0,'ShowSigstar','none')
for k = 1:4
    p(k) = signrank(AllUMazeCorr(:,k));
end
sigstar({[0.9,1.1],[1.9,2.1]},p([1,4]))
title('UMaze data')
set(gca,'XTick',[1,2],'XTickLabel',{'EPM train','Umaze train'},'LineWidth',2)
ylabel('Corr coeff')
xtickangle(30)
ylim([-0.05 1])


subplot(2,2,3)
PlotErrorBarN_KJ(AllEPMAcc(:,[1,4]),'newfig',0,'ShowSigstar','none')
for k = 1:4
    p(k) = signrank(AllEPMAcc(:,k),0.5);
end
sigstar({[0.9,1.1],[1.9,2.1]},p([1,4]))
line(xlim,[0.5 0.5])
title('EPM data')
set(gca,'XTick',[1,2],'XTickLabel',{'EPM train','Umaze train'},'LineWidth',2)
ylabel('Accuracy')
xtickangle(30)


subplot(2,2,4)
PlotErrorBarN_KJ(AllUMazeAcc(:,[1,4]),'newfig',0,'ShowSigstar','none')
for k = 1:4
    p(k) = signrank(AllUMazeAcc(:,k),0.5);
end
sigstar({[0.9,1.1],[1.9,2.1]},p([1,4]))
line(xlim,[0.5 0.5])
title('UMaze data')
set(gca,'XTick',[1,2],'XTickLabel',{'EPM train','Umaze train'},'LineWidth',2)
ylabel('Accuracy')
xtickangle(30)


figure
clear p
subplot(1,2,1)
PlotErrorBarN_KJ((AllEPMCorr(:,[1,4])+AllUMazeCorr(:,[4,1]))/2,'newfig',0,'ShowSigstar','none')

p(1) = signrank((AllEPMCorr(:,1)+AllUMazeCorr(:,4))/2);
p(2) = signrank((AllEPMCorr(:,4)+AllUMazeCorr(:,1))/2);
sigstar({[0.9,1.1],[1.9,2.1]},p)

clear p
subplot(1,2,2)
PlotErrorBarN_KJ((AllEPMAcc(:,[1,4])+AllUMazeAcc(:,[4,1]))/2,'newfig',0,'ShowSigstar','none')
p(1) = signrank((AllEPMAcc(:,1)+AllUMazeAcc(:,4))/2,0.5);
p(2) = signrank((AllEPMAcc(:,4)+AllUMazeAcc(:,1))/2,0.5);
sigstar({[0.9,1.1],[1.9,2.1]},p)
line(xlim,[0.5 0.5])
