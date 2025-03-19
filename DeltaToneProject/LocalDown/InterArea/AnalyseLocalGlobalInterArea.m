%%AnalyseLocalGlobalInterArea
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%     ScriptLocalDeltaWavesParietal
%    


clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1:length(Dir.path)
    
    if ~strcmpi(Dir.name{p},'Mouse243') && ~strcmpi(Dir.name{p},'Mouse244')
        continue
    end
        
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p local_res
    
    local_res.path{p}   = Dir.path{p};
    local_res.manipe{p} = Dir.manipe{p};
    local_res.name{p}   = Dir.name{p};
    local_res.date{p}   = Dir.date{p};
    local_res.hemisphere{p}  = Dir.hemisphere{p};
    local_res.tetrodes{p} = Dir.tetrodes{p};
    
    %params
    windowsize_density = 60e4; %60s  

    
    %% load

    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %NREM in ZT
    new_st = Data(Restrict(NewtsdZT, ts(Start(NREM))));
    new_end = Data(Restrict(NewtsdZT, ts(End(NREM))));
    %check duration
    event_dur = End(NREM) - Start(NREM);
    new_event_dur = new_end - new_st;
    event_ok = new_event_dur<1.3*event_dur;
    %new events Epoch
    NREMzt = intervalSet(new_st(event_ok), new_end(event_ok));

    start_nrem = Start(NREM); 
    StartSleep = intervalSet(start_nrem(1), start_nrem(1)+2*3600e4);
    end_nrem = End(NREM); 
    EndSleep = intervalSet(end_nrem(end)-2*3600e4, end_nrem(end));


    %PFC
    load('ChannelsToAnalyse/PFCx_locations.mat')
    channels_pfc = channels;

    %tetrodes
    load('SpikesToAnalyse/PFCx_tetrodes.mat','channels')
    idtetrodes = Dir.tetrodes{p};
    tetrodeChannelsCell = channels;
    tetrodeChannels = [];
    for tt=1:length(tetrodeChannelsCell)
        tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
    end
    nb_tetrodes = length(tetrodeChannels);


    %% Down
    %global
    load('DownState.mat', 'down_PFCx')
    GlobalDownPFC = down_PFCx;
    GlobalStart = and(down_PFCx,StartSleep);
    GlobalEnd = and(down_PFCx,EndSleep);

    
    %% Deltas

    %PaCx
    load('DeltaWaves.mat', 'deltas_PaCx')
    PaDeltas = deltas_PaCx;
    PaCxStart = and(PaDeltas,StartSleep);
    PaCxEnd = and(PaDeltas,EndSleep);

    %MoCx
    load('DeltaWaves.mat', 'deltas_MoCx')
    MoDeltas = deltas_MoCx;
    MoCxStart = and(MoDeltas,StartSleep);
    MoCxEnd = and(MoDeltas,EndSleep);


    %PFCx Diff
    load('DeltaWaves.mat', 'deltas_PFCx')
    PFCxDeltas = deltas_PFCx;
    st_deltas = Start(deltas_PFCx);
    end_deltas = Start(deltas_PFCx);
    
    
    %% Inter et Intra
    
    %PaCx et PFCx
    [Inter_PfcPaCxRaw, ~, ~, id1,id2] = GetIntersectionsEpochs(GlobalDownPFC, PaDeltas);
    Intra_PfcNoPa = subset(GlobalDownPFC, setdiff(1:length(Start(GlobalDownPFC)),id1)');
    Intra_PaCxNoPFC = subset(PaDeltas, setdiff(1:length(Start(PaDeltas)),id2)');
    %remove MoCx
    [~, ~, ~, id1,~] = GetIntersectionsEpochs(Intra_PfcNoPa, MoDeltas);
    Intra_PFC = subset(Intra_PfcNoPa, setdiff(1:length(Start(Intra_PfcNoPa)),id1)');
    
    %MoCx et PFCx
    [Inter_PfcMoCxRaw, ~, ~, id1,id2] = GetIntersectionsEpochs(GlobalDownPFC, MoDeltas);
    Intra_PfcNoMo = subset(GlobalDownPFC, setdiff(1:length(Start(GlobalDownPFC)),id1)');
    Intra_MoCxNoPFC = subset(MoDeltas, setdiff(1:length(Start(MoDeltas)),id2)');

    %Inter Pa-Mo, Intra PaCx et Intra MoCx
    [Inter_MoPa, ~, ~, idMo,idPa] = GetIntersectionsEpochs(Intra_MoCxNoPFC, Intra_PaCxNoPFC);
    Intra_MoCx = subset(Intra_MoCxNoPFC, setdiff(1:length(Start(Intra_MoCxNoPFC)),idMo)');
    Intra_PaCx = subset(Intra_PaCxNoPFC, setdiff(1:length(Start(Intra_PaCxNoPFC)),idPa)');
    
    %Inter ALL, Inter PFC-Mo et Inter PFC-Pa
    [Inter_All, ~, ~, id1,id2] = GetIntersectionsEpochs(Inter_PfcPaCxRaw, Inter_PfcMoCxRaw);
    Inter_PfcPa = subset(Inter_PfcPaCxRaw, setdiff(1:length(Start(Inter_PfcPaCxRaw)),id1)');
    Inter_PfcMo = subset(Inter_PfcMoCxRaw, setdiff(1:length(Start(Inter_PfcMoCxRaw)),id2)');
    
    %nb
    local_res.inter_all.nb{p} = length(Start(Inter_All));
    
    local_res.pfc_pa.nb{p} = length(Start(Inter_PfcPa));
    local_res.pfc_mo.nb{p} = length(Start(Inter_PfcMo));
    local_res.mo_pa.nb{p} = length(Start(Inter_MoPa));
    
    local_res.intra_pfc.nb{p} = length(Start(Intra_PFC));
    local_res.intra_pa.nb{p} = length(Start(Intra_PaCx));
    local_res.intra_mo.nb{p} = length(Start(Intra_MoCx));
    
    
    
    %% Cross-correlogram
    
    
    

end


%saving data
cd(FolderDeltaDataKJ)
save AnalyseLocalGlobalInterArea.mat local_res



