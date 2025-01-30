%%OccurenceRipplesFakeDeltaDeep
% 09.09.2019 KJ
%
% Infos
%   quantify occurence of ripples in relation to fake/real delta sup
%
% see
%     OccurenceRipplesFakeDeltaSup OccurenceRipplesFakeDeltaDeepPlot
%    OccurenceRipplesFakeDeltaDeepPlot2  OccurenceRipplesFakeDeltaDeepPlotAll
% 
% 

clear
Dir = PathForExperimentsFakeSlowWave;


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
    
    Dir.hemisphere{p} = [];
    ripples_res.hemisphere{p} = Dir.hemisphere{p};
    
    %params
    binsize_mua = 5*10; %5ms
    minDurationDown1 = 75;
    minDurationDown2 = 50;
    maxDurationDown = 800; %800ms
    binsize_cc = 5; %10ms
    nb_binscc = 400; 


    %% load
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %Ripples  
    [tRipples, ~] = GetRipples;
    
    %PFC channels
    load('ChannelsToAnalyse/PFCx_clusters.mat')
    load('LFPData/InfoLFP.mat', 'InfoLFP')
    if ~isempty(Dir.hemisphere{p})
        channels_pfc = [];
        clusters_pfc = [];
        for ch=1:length(channels)
            hemisphere = lower(InfoLFP.hemisphere{InfoLFP.channel==channels(ch)}(1));
            if strcmpi(hemisphere, Dir.hemisphere{p})
                channels_pfc = [channels_pfc channels(ch)];
                clusters_pfc = [clusters_pfc clusters(ch)];
            end
        end
    else
        channels_pfc = channels;
        clusters_pfc = clusters;
    end
    idx = clusters_pfc>=4;
    channels_pfc = channels_pfc(idx);    
    ripples_res.channels{p} = channels_pfc;
    ripples_res.clusters{p} = clusters_pfc(idx);
    
    %Deltawaves
    load('DeltaWaves.mat', 'deltas_PFCx')
    DeltaDiff = deltas_PFCx;

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
    
    
    %% Global downstate
    MUA = MakeQfromS(S(all_neurons), binsize_mua);
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    GlobalDown1 = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown1, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    GlobalDown1 = and(GlobalDown1,NREM);
    GlobalDown2 = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown2, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    GlobalDown2 = and(GlobalDown2,NREM);
    
    %save
    ripples_res.nb.diff{p} = length(Start(DeltaDiff));
    ripples_res.nb.down1{p} = length(Start(GlobalDown1));
    ripples_res.nb.down2{p} = length(Start(GlobalDown2));
    ripples_res.nb.allneurons{p} = length(all_neurons);
    ripples_res.nb.ripples{p} = length(tRipples);
    
    
    %% cross corr with delta diff
    [ripples_res.diff.global{p}(:,2), ripples_res.diff.global{p}(:,1)] = CrossCorr(Range(tRipples), Start(DeltaDiff), binsize_cc, nb_binscc);
    
    %% cross corr with down
    [ripples_res.down1.global{p}(:,2), ripples_res.down1.global{p}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDown1), binsize_cc, nb_binscc);
    [ripples_res.down2.global{p}(:,2), ripples_res.down2.global{p}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDown2), binsize_cc, nb_binscc);
    
    
    %% deltas
     for ch=1:length(channels_pfc)
        
        %% delta waves of channel (signle channel detection)
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(channels_pfc(ch))])
        eval(['a = delta_ch_' num2str(channels_pfc(ch)) ';'])
        DeltaWavesCh{ch} = a;
        
        %global delta and other delta 1 - for down > 75ms
        [GlobalDelta1{ch}, ~, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesCh{ch}, GlobalDown1);
        OtherDelta1{ch} = subset(DeltaWavesCh{ch}, setdiff(1:length(Start(DeltaWavesCh{ch})),idGlobDelta)');
        
        %global delta and other delta 1 - for down > 50ms
        [GlobalDelta2{ch}, ~, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesCh{ch}, GlobalDown2);
        OtherDelta2{ch} = subset(DeltaWavesCh{ch}, setdiff(1:length(Start(DeltaWavesCh{ch})),idGlobDelta)');
        
        
        ripples_res.nb.delta1{p,ch} = length(Start(GlobalDelta1{ch}));
        ripples_res.nb.delta2{p,ch} = length(Start(GlobalDelta2{ch}));
        ripples_res.nb.other1{p,ch} = length(Start(OtherDelta1{ch}));
        ripples_res.nb.other2{p,ch} = length(Start(OtherDelta2{ch}));
        
        
        %% cross corr with deltas
        [ripples_res.delta1.global{p,ch}(:,2), ripples_res.delta1.global{p,ch}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDelta1{ch}), binsize_cc, nb_binscc);
        [ripples_res.delta2.global{p,ch}(:,2), ripples_res.delta2.global{p,ch}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDelta2{ch}), binsize_cc, nb_binscc);
        
        [ripples_res.delta1.other{p,ch}(:,2), ripples_res.delta1.other{p,ch}(:,1)] = CrossCorr(Range(tRipples), Start(OtherDelta1{ch}), binsize_cc, nb_binscc);
        [ripples_res.delta2.other{p,ch}(:,2), ripples_res.delta2.other{p,ch}(:,1)] = CrossCorr(Range(tRipples), Start(OtherDelta2{ch}), binsize_cc, nb_binscc);
        
     end
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save OccurenceRipplesFakeDeltaDeep2.mat ripples_res


