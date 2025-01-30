%%MeancurvesLocalDownState
% 09.09.2019 KJ
%
% Infos
%   meancurves of local down states
%
% see
%




%% load

clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p curves_res
    
    curves_res.path{p}   = Dir.path{p};
    curves_res.manipe{p} = Dir.manipe{p};
    curves_res.name{p}   = Dir.name{p};
    curves_res.date{p}   = Dir.date{p};
    curves_res.hemisphere{p} = Dir.hemisphere{p};
    curves_res.tetrodes{p} = Dir.tetrodes{p};
    
    %params
    binsize_mua = 5*10; %5ms
    minDurationDown = 75;
    maxDurationDown = 800; %800ms
    binsize_met = 5;
    nbBins_met  = 300;


    %% load
    
    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %PFC
    load('ChannelsToAnalyse/PFCx_locations.mat')
    channels_pfc = channels;

    %Spikes
    load('SpikeData.mat', 'S');
    if ~isempty(Dir.hemisphere{p})
        load(['SpikesToAnalyse/PFCx_' Dir.hemisphere{p} '_Neurons.mat'])
    else
        load('SpikesToAnalyse/PFCx_Neurons.mat')
    end
    all_neurons = number;
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
    
    %LFP
    for tt=1:nb_tetrodes
        load(['LFPData/LFP' num2str(tetrodeChannels(tt)) '.mat'])
        PFC{tt} = LFP;
    end
    clear LFP
    
    
    %% Global downstate
    MUA = MakeQfromS(S(all_neurons), binsize_mua);
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    GlobalDown = and(GlobalDown,NREM);
    st_down = Start(GlobalDown);
    
    %save
    curves_res.nb.down{p} = length(st_down);
    curves_res.nb.tetrodes{p} = nb_tetrodes;
    curves_res.nb.allneurons{p} = length(all_neurons);
    
    
    %% single channel delta waves 
    for tt=1:nb_tetrodes
        
        %% MUA
        local_neurons{tt} = NeuronTetrodes{tt};
        MUA_local{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua);
        MUA_local{tt} = tsd(Range(MUA_local{tt}), sum(full(Data(MUA_local{tt})),2));
        
        ext_neurons{tt} = setdiff(all_neurons,local_neurons{tt});
        MUA_ext{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua);
        MUA_ext{tt} = tsd(Range(MUA_ext{tt}), sum(full(Data(MUA_ext{tt})),2));
        
        
        %% local down states
        %all
        AllDown_local{tt} = FindDownKJ(MUA_local{tt}, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        AllDown_local{tt} = and(AllDown_local{tt},NREM);
        
        %distinguish local and global
        [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(AllDown_local{tt}, GlobalDown);
        LocalDown{tt} = subset(AllDown_local{tt}, setdiff(1:length(Start(AllDown_local{tt})), idAlocal)');
        st_localdown{tt} = Start(LocalDown{tt});
        center_localdown{tt} = (Start(LocalDown{tt}) + End(LocalDown{tt})) /2;
        
        
        %% delta waves of channel (signle channel detection)
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(tetrodeChannels(tt))])
        eval(['a = delta_ch_' num2str(tetrodeChannels(tt)) ';'])
        DeltaWavesTT{tt} = a;
        
        %global delta and other delta
        [GlobalDelta{tt}, ~, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesTT{tt}, GlobalDown);
        OtherDelta{tt} = subset(DeltaWavesTT{tt}, setdiff(1:length(Start(DeltaWavesTT{tt})),idGlobDelta)');
        
        %Local delta and fake delta
        [LocalDelta{tt}, ~, ~,idLocDelta,~] = GetIntersectionsEpochs(OtherDelta{tt}, LocalDown{tt});
        FakeDelta{tt} = subset(OtherDelta{tt}, setdiff(1:length(Start(OtherDelta{tt})),idLocDelta)');
        
        
        
        %% save infos number
        curves_res.nb.neurons_tet{p}(tt) = length(local_neurons{tt});
        curves_res.nb.localdown{p}(tt)   = length(Start(LocalDown{tt}));
        curves_res.nb.delta.all{p}(tt)    = length(Start(DeltaWavesTT{tt}));
        curves_res.nb.delta.global{p}(tt) = length(Start(GlobalDelta{tt}));
        curves_res.nb.delta.local{p}(tt)  = length(Start(LocalDelta{tt}));
        curves_res.nb.delta.fake{p}(tt)   = length(Start(FakeDelta{tt}));
        
        
        %% MEANCURVES
        
        %% mua 
        
        %local down
        [m,~,tps] = mETAverage(Start(LocalDown{tt}), Range(MUA), Data(MUA), binsize_met, nbBins_met);
        curves_res.down.local.mua_all{p,tt}(:,1) = tps; curves_res.down.local.mua_all{p,tt}(:,2) = m;
        
        [m,~,tps] = mETAverage(Start(LocalDown{tt}), Range(MUA_ext{tt}), Data(MUA_ext{tt}), binsize_met, nbBins_met);
        curves_res.down.local.mua_ext{p,tt}(:,1) = tps; curves_res.down.local.mua_ext{p,tt}(:,2) = m;
        
        
        %global delta
        [m,~,tps] = mETAverage(Start(GlobalDelta{tt}), Range(MUA), Data(MUA), binsize_met, nbBins_met);
        curves_res.delta.global.mua_all{p,tt}(:,1) = tps; curves_res.delta.global.mua_all{p,tt}(:,2) = m;
        
        [m,~,tps] = mETAverage(Start(GlobalDelta{tt}), Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
        curves_res.delta.global.mua_loc{p,tt}(:,1) = tps; curves_res.delta.global.mua_loc{p,tt}(:,2) = m;
        
        [m,~,tps] = mETAverage(Start(GlobalDelta{tt}), Range(MUA_ext{tt}), Data(MUA_ext{tt}), binsize_met, nbBins_met);
        curves_res.delta.global.mua_ext{p,tt}(:,1) = tps; curves_res.delta.global.mua_ext{p,tt}(:,2) = m;
        
        
        %other delta
        [m,~,tps] = mETAverage(Start(OtherDelta{tt}), Range(MUA), Data(MUA), binsize_met, nbBins_met);
        curves_res.delta.other.mua_all{p,tt}(:,1) = tps; curves_res.delta.local.mua_all{p,tt}(:,2) = m;
        
        [m,~,tps] = mETAverage(Start(OtherDelta{tt}), Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
        curves_res.delta.other.mua_loc{p,tt}(:,1) = tps; curves_res.delta.local.mua_loc{p,tt}(:,2) = m;
        
        [m,~,tps] = mETAverage(Start(OtherDelta{tt}), Range(MUA_ext{tt}), Data(MUA_ext{tt}), binsize_met, nbBins_met);
        curves_res.delta.other.mua_ext{p,tt}(:,1) = tps; curves_res.delta.local.mua_ext{p,tt}(:,2) = m;
        
        
        %local delta
        [m,~,tps] = mETAverage(Start(LocalDelta{tt}), Range(MUA_ext{tt}), Data(MUA_ext{tt}), binsize_met, nbBins_met);
        curves_res.delta.local.mua_ext{p,tt}(:,1) = tps; curves_res.delta.local.mua_ext{p,tt}(:,2) = m;
        
        
        %fake delta
        [m,~,tps] = mETAverage(Start(FakeDelta{tt}), Range(MUA), Data(MUA), binsize_met, nbBins_met);
        curves_res.delta.fake.mua_all{p,tt}(:,1) = tps; curves_res.delta.fake.mua_all{p,tt}(:,2) = m;
        
        [m,~,tps] = mETAverage(Start(FakeDelta{tt}), Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
        curves_res.delta.fake.mua_loc{p,tt}(:,1) = tps; curves_res.delta.fake.mua_loc{p,tt}(:,2) = m;
        
        [m,~,tps] = mETAverage(Start(FakeDelta{tt}), Range(MUA_ext{tt}), Data(MUA_ext{tt}), binsize_met, nbBins_met);
        curves_res.delta.fake.mua_ext{p,tt}(:,1) = tps; curves_res.delta.fake.mua_ext{p,tt}(:,2) = m;
        
        
        
        %% lfp
        %Global down
        [m,~,tps] = mETAverage(Start(GlobalDown), Range(PFC{tt}), Data(PFC{tt}), binsize_met, nbBins_met);
        curves_res.down.global.pfc{p,tt}(:,1) = tps; curves_res.down.global.pfc{p,tt}(:,2) = m;
        
        for i=1:nb_tetrodes
            %Local down
            [m,~,tps] = mETAverage(Start(LocalDown{tt}), Range(PFC{i}), Data(PFC{i}), binsize_met, nbBins_met);
            curves_res.down.local.pfc{p}{tt,i}(:,1) = tps; curves_res.down.local.pfc{p}{tt,i}(:,2) = m;
            
            %global delta
            [m,~,tps] = mETAverage(Start(GlobalDelta{tt}), Range(PFC{i}), Data(PFC{i}), binsize_met, nbBins_met);
            curves_res.delta.global.pfc{p}{tt,i}(:,1) = tps; curves_res.delta.global.pfc{p}{tt,i}(:,2) = m;
            
            %other delta
            [m,~,tps] = mETAverage(Start(OtherDelta{tt}), Range(PFC{i}), Data(PFC{i}), binsize_met, nbBins_met);
            curves_res.delta.other.pfc{p}{tt,i}(:,1) = tps; curves_res.delta.other.pfc{p}{tt,i}(:,2) = m;
            
            %local delta
            [m,~,tps] = mETAverage(Start(LocalDelta{tt}), Range(PFC{i}), Data(PFC{i}), binsize_met, nbBins_met);
            curves_res.delta.local.pfc{p}{tt,i}(:,1) = tps; curves_res.delta.local.pfc{p}{tt,i}(:,2) = m;
            
            %fake delta
            [m,~,tps] = mETAverage(Start(FakeDelta{tt}), Range(PFC{i}), Data(PFC{i}), binsize_met, nbBins_met);
            curves_res.delta.fake.pfc{p}{tt,i}(:,1) = tps; curves_res.delta.fake.pfc{p}{tt,i}(:,2) = m;
        end
        
        
        %% cross-corr
        
        
        
        
    end
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save MeancurvesLocalDownState.mat curves_res






