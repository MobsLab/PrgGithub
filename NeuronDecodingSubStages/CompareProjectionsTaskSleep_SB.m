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
    DirUMaze = Dir(find(~(cellfun(@isempty,strfind(Dir,'UMazeCond')))));
    DirSleep = Dir(find(~(cellfun(@isempty,strfind(Dir,'SleepPost/')))));
    DirEPM = Dir(find(~(cellfun(@isempty,strfind(Dir,'EPM')))));
    
    
    % data from umaze conditionning
    NoiseEpoch = ConcatenateDataFromFolders_SB(DirUMaze,'epoch','epochname','noiseepoch');
    FreezeEpoch = ConcatenateDataFromFolders_SB(DirUMaze,'epoch','epochname','freezeepoch');
    StimEpoch = ConcatenateDataFromFolders_SB(DirUMaze,'epoch','epochname','stimepoch');
    SessNames = ConcatenateDataFromFolders_SB(DirUMaze,'epoch','epochname','sessiontype');
    ZoneEpoch = ConcatenateDataFromFolders_SB(DirUMaze,'epoch','epochname','zoneepoch');
    SleepStates = ConcatenateDataFromFolders_SB(DirUMaze,'epoch','epochname','sleepstates');
    
    Vtsd = ConcatenateDataFromFolders_SB(DirUMaze,'speed');
    Postsd = ConcatenateDataFromFolders_SB(DirUMaze,'position');
    
    MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
    MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4) - FreezeEpoch;
    
    LinPos = ConcatenateDataFromFolders_SB(DirUMaze,'linearposition');
    
    % Spikes
    Spikes = ConcatenateDataFromFolders_SB(DirUMaze,'Spikes');
    cd(Dir{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
    Spikes = Spikes(numNeurons);
    Q = MakeQfromS(Spikes(numNeurons),Binsize);
    
    
    % Sleep
    cd(DirSleep{1})
    load('SpikeData.mat')
    load('SleepSubstages.mat')
    noNoise = load('StateEpochSB.mat','Epoch');
    
    QSleep = MakeQfromS(S(numNeurons),Binsize);
    QSleep = Restrict(QSleep,noNoise.Epoch);
    
    % EPM
    cd(DirEPM{1})
    load('SpikeData.mat')
    load('behavResources_SB.mat')
    
    QEPM = MakeQfromS(S(numNeurons),Binsize);
    
    
    % should zscore evently by state
    % zscore
    meanSleep = nanmean(Data(QSleep));
    meanMaze = nanmean(Data(Q));
    meanEPM = nanmean(Data(QEPM));
    
    meanFR = (meanMaze+meanSleep+meanEPM)/3;
    
    stdSleep = nanstd(Data(QSleep));
    stdMaze = nanstd(Data(Q));
    stdEPM = nanstd(Data(QEPM));
    
    meanstd = (stdMaze+stdSleep+stdEPM)/3;
    
    
    datQ = Data(Q);
    datQSleep = Data(QSleep);
    datQEPM = Data(QEPM);
    
    for q = 1 : size(datQ,2)
        datQ(:,q) = (datQ(:,q) - meanFR(q))./meanstd(q);
        datQSleep(:,q) = (datQSleep(:,q) - meanFR(q))./meanstd(q);
        datQEPM(:,q) = (datQEPM(:,q) - meanFR(q))./meanstd(q);
        
    end
    
    Q = tsd(Range(Q),datQ);
    QSleep = tsd(Range(QSleep),datQSleep);
    QEPM = tsd(Range(QEPM),datQEPM);
    
    clf
    VectN3Wake  = full(nanmean(Data(Restrict(QSleep,Epoch{3}))) - nanmean(Data(Restrict(QSleep,Epoch{5}))));
    VectN3N1  = full(nanmean(Data(Restrict(QSleep,Epoch{3}))) - nanmean(Data(Restrict(QSleep,Epoch{1}))));
    SfVsShock  = full(nanmean(Data(Restrict(Q,thresholdIntervals(LinPos,0.6,'Direction','Above')))) - nanmean(Data(Restrict(Q,thresholdIntervals(LinPos,0.4,'Direction','Below')))));
    FzvsMov  = full(nanmean(Data(Restrict(Q,FreezeEpoch))) - nanmean(Data(Restrict(Q,MovEpoch))));
    OpenVsClose = full(nanmean(Data(Restrict(QEPM,Behav.ZoneEpoch{1}))) - nanmean(Data(Restrict(QEPM,Behav.ZoneEpoch{2}))));
    
    for ep = 1:5
        plot(Data(Restrict(QSleep,Epoch{ep}))*VectN3Wake',Data(Restrict(QSleep,Epoch{ep}))*FzvsMov','*')
        hold on
    end
    
    plot(Data(Restrict(Q,FreezeEpoch))*VectN3Wake',Data(Restrict(Q,FreezeEpoch))*FzvsMov','b*')
    plot(Data(Restrict(Q,MovEpoch))*VectN3Wake',Data(Restrict(Q,MovEpoch))*FzvsMov','r*')
    
    plot(Data(Restrict(QEPM,Behav.ZoneEpoch{1}))*VectN3Wake',Data(Restrict(QEPM,Behav.ZoneEpoch{1}))*FzvsMov','k*')
    plot(Data(Restrict(QEPM,Behav.ZoneEpoch{2}))*VectN3Wake',Data(Restrict(QEPM,Behav.ZoneEpoch{2}))*FzvsMov','m*')
    
    
    clf
    
    for ep = 1:5
        plot(Data(Restrict(QSleep,Epoch{ep}))*VectN3Wake',Data(Restrict(QSleep,Epoch{ep}))*OpenVsClose','*')
        hold on
    end
    
    plot(Data(Restrict(Q,FreezeEpoch))*VectN3Wake',Data(Restrict(Q,FreezeEpoch))*OpenVsClose','b*')
    plot(Data(Restrict(Q,MovEpoch))*VectN3Wake',Data(Restrict(Q,MovEpoch))*OpenVsClose','r*')
    
    plot(Data(Restrict(QEPM,Behav.ZoneEpoch{1}))*VectN3Wake',Data(Restrict(QEPM,Behav.ZoneEpoch{1}))*OpenVsClose','k*')
    plot(Data(Restrict(QEPM,Behav.ZoneEpoch{2}))*VectN3Wake',Data(Restrict(QEPM,Behav.ZoneEpoch{2}))*OpenVsClose','m*')
    
    
    clf
    
    for ep = 1:5
        plot(Data(Restrict(QSleep,Epoch{ep}))*FzvsMov',Data(Restrict(QSleep,Epoch{ep}))*OpenVsClose','*')
        hold on
    end
    
    plot(Data(Restrict(Q,FreezeEpoch))*FzvsMov',Data(Restrict(Q,FreezeEpoch))*OpenVsClose','b*')
    plot(Data(Restrict(Q,MovEpoch))*FzvsMov',Data(Restrict(Q,MovEpoch))*OpenVsClose','r*')
    
    plot(Data(Restrict(QEPM,Behav.ZoneEpoch{1}))*FzvsMov',Data(Restrict(QEPM,Behav.ZoneEpoch{1}))*OpenVsClose','k*')
    plot(Data(Restrict(QEPM,Behav.ZoneEpoch{2}))*FzvsMov',Data(Restrict(QEPM,Behav.ZoneEpoch{2}))*OpenVsClose','m*')
    
end