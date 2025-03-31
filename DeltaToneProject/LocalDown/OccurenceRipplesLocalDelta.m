%%OccurenceRipplesLocalDelta
% 09.09.2019 KJ
%
% Infos
%   quantify occurence of ripples in relation to fake/real delta sup
%
% see
%     OccurenceRipplesFakeDeltaDeep OccurenceRipplesLocalDeltaPlot
%       OccurenceRipplesLocalDeltaplot2
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
    ripples_res.hemisphere{p}   = Dir.hemisphere{p};
    ripples_res.tetrodes{p} = Dir.tetrodes{p};

    %params
    binsize_mua = 10;
    binsize_cc = 10; %10ms
    binsize_met       = 5; %for mETAverage  
    nbBins_met        = 240; %for mETAverage 
    nb_binscc = 200;
    minDurationDown = 75;
    maxDurationDown = 800; %800ms

    %NREM
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);
    
    %PFC
    load('ChannelsToAnalyse/PFCx_locations.mat')
    channels_pfc = channels;

    %Ripples  
    [tRipples, ~] = GetRipples;

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
    
    load('NeuronClassification.mat', 'UnitID')
    
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


    %% downstates
    %global
    MUA = MakeQfromS(S(all_neurons), binsize_mua);
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    GlobalDown = and(GlobalDown,NREM);
    
    %global down
    [ripples_res.down.global{p}(:,2), ripples_res.down.global{p}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDown), binsize_cc, nb_binscc);

    
    for tt=1:nb_tetrodes
        
        %% local down states
        local_neurons{tt} = NeuronTetrodes{tt};
        %MUA & down
        MUA_local{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua);
        MUA_local{tt} = tsd(Range(MUA_local{tt}), sum(full(Data(MUA_local{tt})),2));
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

        %% cross-corr with ripples

        %local down
        [ripples_res.down.local{p,tt}(:,2), ripples_res.down.local{p,tt}(:,1)] = CrossCorr(Range(tRipples), Start(LocalDown{tt}), binsize_cc, nb_binscc);
        %global delta
        [ripples_res.delta.global{p,tt}(:,2), ripples_res.delta.global{p,tt}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDelta{tt}), binsize_cc, nb_binscc);
        %other delta
        [ripples_res.delta.other{p,tt}(:,2), ripples_res.delta.other{p,tt}(:,1)] = CrossCorr(Range(tRipples), Start(OtherDelta{tt}), binsize_cc, nb_binscc);
        %local delta
        if ~isempty(Start(LocalDelta{tt}))
            [ripples_res.delta.local{p,tt}(:,2), ripples_res.delta.local{p,tt}(:,1)] = CrossCorr(Range(tRipples), Start(LocalDelta{tt}), binsize_cc, nb_binscc);
        else
            ripples_res.delta.local{p,tt} = nan(size(ripples_res.delta.global{p,tt}));
        end
        
        %fake delta
        if ~isempty(Start(FakeDelta{tt}))
            [ripples_res.delta.fake{p,tt}(:,2), ripples_res.delta.fake{p,tt}(:,1)] = CrossCorr(Range(tRipples), Start(FakeDelta{tt}), binsize_cc, nb_binscc);
        else
            ripples_res.delta.fake{p,tt} = nan(size(ripples_res.delta.fake{p,tt}));
        end
        
        
        %% meancurves on down and ripples
        
        load(['LFPData/LFP' num2str(tetrodeChannels(tt)) '.mat'])
        
        %down
        durRange = [100 200] * 10; 
        st_down = Start(GlobalDown);
        down_dur = End(GlobalDown) - Start(GlobalDown);
        selected_down = st_down(down_dur>durRange(1) & down_dur<durRange(2));
        
        [m,~,tps] = mETAverage(selected_down, Range(LFP), Data(LFP), binsize_met, nbBins_met);
        ripples_res.meandown{p,tt}(:,1) = tps; ripples_res.meandown{p,tt}(:,2) = m;
        
        %ripples
        [m,~,tps] = mETAverage(Range(tRipples), Range(LFP), Data(LFP), binsize_met, nbBins_met);
        ripples_res.meanripples{p,tt}(:,1) = tps; ripples_res.meanripples{p,tt}(:,2) = m;
        
        
        %% infos stat
        channels_pfc = tetrodeChannelsCell{tt}; 
        nb_neurons_tet.all(tt) = length(local_neurons{tt});
        nb_neurons_tet.int(tt) = sum(UnitID(local_neurons{tt})<0);
        nb_neurons_tet.pyr(tt) = sum(UnitID(local_neurons{tt})>0);

        fr.nrem.local{tt} = mean(Data(Restrict(MUA_local{tt},NREM)))*(1e4/binsize_mua);
        fr.wake.local{tt} = mean(Data(Restrict(MUA_local{tt},Wake)))*(1e4/binsize_mua);
        
        
        ripples_res.textbox_str{p,tt} = {Dir.name{p}, Dir.date{p}, ['Tetrode ' num2str(Dir.tetrodes{p}(tt)) '(tt=' num2str(tt) ')'], ['channel ' num2str(tetrodeChannelsCell{tt})], ...
                          [num2str(nb_neurons_tet.all(tt)) ' neurons'], ...
                          [num2str(nb_neurons_tet.pyr(tt)) ' pyramidal(s)'], ...
                          [num2str(nb_neurons_tet.int(tt)) ' interneuron(s)'],...
                          ['FR (SWS) = ' num2str(fr.nrem.local{tt}) ' Hz ( ' num2str(fr.nrem.local{tt}/nb_neurons_tet.all(tt)) ' Hz)'],...
                          ['FR (Wake) = ' num2str(fr.wake.local{tt}) ' Hz ( ' num2str(fr.wake.local{tt}/nb_neurons_tet.all(tt)) ' Hz)'],...
                          [num2str(length(Range(tRipples))) ' SPW-ripples' ], ...
                          [num2str(length(Start(GlobalDown))) ' Global Down' ], ...
                          [num2str(length(Start(LocalDown{tt}))) ' Local Down' ], ...
                          [num2str(length(Start(GlobalDelta{tt}))) ' Global Delta' ], ...
                          [num2str(length(Start(LocalDelta{tt}))) ' Local Delta' ], ...
                          [num2str(length(Start(FakeDelta{tt}))) ' Fake Delta' ]};
                      
        ripples_res.idtetrode{p,tt} = Dir.tetrodes{p}(tt);
        ripples_res.tetrodeChannels{p,tt} = tetrodeChannelsCell{tt};
        ripples_res.mainchannel{p,tt} = tetrodeChannels(tt);

    end
    
end


%saving data
cd(FolderDeltaDataKJ)
save OccurenceRipplesLocalDelta.mat ripples_res




