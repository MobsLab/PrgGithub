clear all
FolderName = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks/';
Binsize = 1*1e4;
SpeedLim = 3;

Titles = {'EPM','UMazeFz','UMazeMv','UMazeAll'};

MiceNumber=[490,507,508,509,510,512,514];

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
    
    EPOI.EPMOpen = and(SessNames.EPM{1},ZoneEpoch{1});
    EPOI.EPMClose = and(SessNames.EPM{1},ZoneEpoch{2});
    EPOI.EPMCentre = and(SessNames.EPM{1},ZoneEpoch{3});
    
    
    UMaze = SessNames.Habituation{1};
    
    
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

    
    % UMaze
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    Q = Restrict(Q,UMaze);    Q = tsd(Range(Q),zscore(Data(Q)));
    ProjVect{2} = full(nanmean(Data(Restrict(Q,EPOI.UMazeFzSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeFzSk))));
    ProjVect{3} = full(nanmean(Data(Restrict(Q,EPOI.UMazeMovSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeMovSk))));
    ProjVect{4} = full(nanmean(Data(Restrict(Q,EPOI.UMazeSf)))-nanmean(Data(Restrict(Q,EPOI.UMazeSk))));
    XY = Data(Restrict(AlignedPostsd,ts(Range(Q))));
    Xtsd_UMaze = tsd(Range(Q),XY(:,1));
    Ytsd_UMaze = tsd(Range(Q),XY(:,2));

   
    % Get projections and decode
    for k  = [1,4]

        %% EPM data
        Q = MakeQfromS(Spikes(numNeurons),Binsize);
        Q = Restrict(Q,SessNames.EPM{1});    Q = tsd(Range(Q),zscore(Data(Q)));
        Projtsd = tsd(Range(Q),full(Data(Q))*ProjVect{k}');
        
        % Accuracy
        Thresh.EPM(k) = (nanmean(Data(Restrict(Projtsd,EPOI.EPMClose))) + nanmean(Data(Restrict(Projtsd,EPOI.EPMOpen))))/2;
        Accuracy.EPM(k) = (nanmean(Data(Restrict(Projtsd,EPOI.EPMClose))>Thresh.EPM(k)) + nanmean(Data(Restrict(Projtsd,EPOI.EPMOpen))<Thresh.EPM(k)))/2;
        
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
    save(['EPM_UMazeHabDecoding' num2str(MiceNumber(mm)) '.mat'],'SigDiff','Corr','Accuracy','MeanVals','Xtsd_UMaze','Ytsd_UMaze',...
        'Ytsd_EPM','Xtsd_EPM')
    clear SigDiff Corr Accuracy MeanVals Xtsd_UMaze Ytsd_UMaze Ytsd_EPM Xtsd_EPM
    
end


clf
for mm = 1 : length(MiceNumber)
    if mm~=4
        load(['EPM_UMazeHabDecoding' num2str(MiceNumber(mm)) '.mat'])
        AllEPMCorrH(mm,:) = -Corr.EPM(:,1);
        AllUMazeCorrH(mm,:) = Corr.UMaze(:,1);
        
        AllEPMAccH(mm,:) = Accuracy.EPM;
        AllUMazeAccH(mm,:) = Accuracy.UMaze;
    else
        AllEPMCorrH(mm,:) = NaN;
        AllUMazeCorrH(mm,:) = NaN;
        
        AllEPMAccH(mm,:) = NaN;
        AllUMazeAccH(mm,:) =NaN;
    end
    
end

clf
for mm = 1 : length(MiceNumber)
    if mm~=4
        load(['EPM_UMazeDecoding' num2str(MiceNumber(mm)) '.mat'])
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
PlotErrorBarN_KJ(AllEPMCorrH(:,[1,4]),'newfig',0,'ShowSigstar','none')
for k = 1:4
    p(k) = signrank(AllEPMCorrH(:,k));
end
sigstar({[0.9,1.1],[1.9,2.1]},p([1,4]))
title('EPM data')
set(gca,'XTick',[1,2],'XTickLabel',{'EPM train','Umaze train'},'LineWidth',2)
ylabel('Corr coeff')
xtickangle(30)
ylim([-0.05 1])

subplot(2,2,2)
PlotErrorBarN_KJ(AllUMazeCorrH(:,[1,4]),'newfig',0,'ShowSigstar','none')
for k = 1:4
    p(k) = signrank(AllUMazeCorrH(:,k));
end
sigstar({[0.9,1.1],[1.9,2.1]},p([1,4]))
title('UMaze data')
set(gca,'XTick',[1,2],'XTickLabel',{'EPM train','Umaze train'},'LineWidth',2)
ylabel('Corr coeff')
xtickangle(30)
ylim([-0.05 1])


subplot(2,2,3)
PlotErrorBarN_KJ(AllEPMAccH(:,[1,4]),'newfig',0,'ShowSigstar','none')
for k = 1:4
    p(k) = signrank(AllEPMAccH(:,k),0.5);
end
sigstar({[0.9,1.1],[1.9,2.1]},p([1,4]))
line(xlim,[0.5 0.5])
title('EPM data')
set(gca,'XTick',[1,2],'XTickLabel',{'EPM train','Umaze train'},'LineWidth',2)
ylabel('Accuracy')
xtickangle(30)


subplot(2,2,4)
PlotErrorBarN_KJ(AllUMazeAccH(:,[1,4]),'newfig',0,'ShowSigstar','none')
for k = 1:4
    p(k) = signrank(AllUMazeAccH(:,k),0.5);
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

figure





clf

subplot(2,2,1)
PlotErrorBarN_KJ([AllEPMCorr(:,4),AllEPMCorrH(:,4)],'newfig',0,'paired',1)
title('EPM data')
set(gca,'XTick',[1,2],'XTickLabel',{'Umaze','Umaze Hab'},'LineWidth',2)
ylabel('Corr coeff')
xtickangle(30)
ylim([-0.5 1])

subplot(2,2,2)
PlotErrorBarN_KJ([AllUMazeCorr(:,1),AllUMazeCorrH(:,1)],'newfig',0,'paired',1)
title('UMaze data')
set(gca,'XTick',[1,2],'XTickLabel',{'Umaze','Umaze Hab'},'LineWidth',2)
ylabel('Corr coeff')
xtickangle(30)
ylim([-0.5 1])


subplot(2,2,3)
PlotErrorBarN_KJ([AllEPMAcc(:,4),AllEPMAccH(:,4)],'newfig',0,'paired',1)
line(xlim,[0.5 0.5])
title('EPM data')
set(gca,'XTick',[1,2],'XTickLabel',{'Umaze','Umaze Hab'},'LineWidth',2)
ylabel('Accuracy')
xtickangle(30)


subplot(2,2,4)
PlotErrorBarN_KJ([AllUMazeAcc(:,1),AllUMazeAccH(:,1)],'newfig',0,'paired',1)
line(xlim,[0.5 0.5])
title('UMaze data')
set(gca,'XTick',[1,2],'XTickLabel',{'Umaze','Umaze Hab'},'LineWidth',2)
ylabel('Accuracy')
xtickangle(30)
