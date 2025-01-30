%%OccurenceRipplesFakeDeltaDeep
% 09.09.2019 KJ
%
% Infos
%   quantify occurence of ripples in relation to fake/real delta sup
%
% see
%     OccurenceRipplesFakeDeltaSup
%    



Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p ripples_res
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 10;
    binsize_cc = 10; %10ms
    nb_binscc = 200;
    minDurationDown = 75;
    maxDurationDown = 800; %800ms
    
    %night duration
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);

    %delta waves
    deltas_PFCx = GetDeltaWaves('area',['PFCx' hsp]);
    st_deltas = Start(deltas_PFCx);
    %Ripples  
    [tRipples, ~] = GetRipples;
    
    %channel deep
    load('ChannelsToAnalyse/PFCx_deep.mat')
    ch_deep = channel;

    %Spikes
    load('SpikeData.mat', 'S');
    if ~isempty(Dir.hemisphere{p})
        load(['SpikesToAnalyse/PFCx_' Dir.hemisphere{p} '_Neurons.mat'])
    else
        load('SpikesToAnalyse/PFCx_Neurons.mat')
    end
    all_neurons = number; clear number
    if ~isa(S,'tsdArray')
        S = tsdArray(S);
    end
    
    %Spike tetrode
    load('SpikesToAnalyse/PFCx_tetrodes.mat')
    NeuronTetrodes = numbers;
    tetrodeChannelsCell = channels;
    tetrodeChannels = [];
    for tt=1:length(tetrodeChannelsCell)
        tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
    end
    %only good tetrodes
    tetrodeChannels =  tetrodeChannels(Dir.tetrodes{p});
    NeuronTetrodes =  NeuronTetrodes(Dir.tetrodes{p});
    tetrodeChannelsCell =  tetrodeChannelsCell(Dir.tetrodes{p});
    nb_tetrodes = length(Dir.tetrodes{p});
    ripples_res.nb_tetrodes{p} = nb_tetrodes;
    
    ripples_res.nb.ripples{p} = length(Range(tRipples));
    ripples_res.nb.down.global{p}  = length(Start(GlobalDown));
    
    %% downstates
    
    %global
    MUA = MakeQfromS(S(all_neurons), binsize_mua);
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    GlobalDown = and(GlobalDown,NREM);
    up_PFCx = intervalSet(0,night_duration) - GlobalDown;
    
    for tt=1:nb_tetrodes
    %local
    MUA_deep = MakeQfromS(S(NumNeuronsTet), binsize_mua);
    MUA_deep = tsd(Range(MUA_deep), sum(full(Data(MUA_deep)),2));
    
    AllDown_local = FindDownKJ(MUA_deep, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    AllDown_local = and(AllDown_local,NREM);
    %distinguish local and global
    [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(AllDown_local, GlobalDown);
    LocalDown = subset(AllDown_local, setdiff(1:length(Start(AllDown_local)), idAlocal)');
    

    %% delta waves of channel (single channel detection)
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
    eval(['a = delta_ch_' num2str(num2str(ch_deep)) ';'])
    DeltaWavesTT = a;

    %global delta and other delta
    [GlobalDelta, ~, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesTT, GlobalDown);
    OtherDelta = subset(DeltaWavesTT, setdiff(1:length(Start(DeltaWavesTT)),idGlobDelta)');

    %Local delta and fake delta
    [LocalDelta, ~, ~,idLocDelta,~] = GetIntersectionsEpochs(OtherDelta, LocalDown);
    FakeDelta = subset(OtherDelta, setdiff(1:length(Start(OtherDelta)),idLocDelta)');
    
    
    %% cross-corr with ripples
    
    
    %global down
    [ripples_res.cc.down.global{p}(:,2), ripples_res.cc.down.global{p}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDown), binsize_cc, nb_binscc);
    %local down
    [ripples_res.cc.down.local{p}(:,2), ripples_res.cc.down.local{p}(:,1)] = CrossCorr(Range(tRipples), Start(LocalDown), binsize_cc, nb_binscc);
    %global delta
    [ripples_res.cc.delta.global{p}(:,2), ripples_res.cc.delta.global{p}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDelta), binsize_cc, nb_binscc);
    %local delta
    [ripples_res.cc.delta.local{p}(:,2), ripples_res.cc.delta.local{p}(:,1)] = CrossCorr(Range(tRipples), Start(LocalDelta), binsize_cc, nb_binscc);
    %fake delta
    [ripples_res.cc.delta.fake{p}(:,2), ripples_res.cc.delta.fake{p}(:,1)] = CrossCorr(Range(tRipples), Start(FakeDelta), binsize_cc, nb_binscc);

    
    %% save
    ripples_res.nb.down.local{p}   = length(Start(LocalDown));
    ripples_res.nb.delta.global{p} = length(Start(GlobalDelta));
    ripples_res.nb.delta.local{p}  = length(Start(LocalDelta));
    ripples_res.nb.delta.fake{p}   = length(Start(FakeDelta));
    
    end
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save OccurenceRipplesFakeDeltaDeep.mat ripples_res

