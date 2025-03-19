%%MeancurvesDeltaAfterRipples
% 16.09.2019 KJ
%
% Infos
%   mean curves of delta after ripples
%
% see
%     OccurenceRipplesFakeDeltaDownSup MeancurvesDeltaAfterRipplesPlot
% 
% 

% clear
Dir = PathForExperimentsFakeSlowWave('hemisup');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p meanc_res
    
    meanc_res.path{p}   = Dir.path{p};
    meanc_res.manipe{p} = Dir.manipe{p};
    meanc_res.name{p}   = Dir.name{p};
    meanc_res.date{p}   = Dir.date{p};
    meanc_res.hemisphere{p} = Dir.hemisphere{p};
    
    %params
    binsize_met = 10;
    nbBins_met  = 160;
    

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
    idx = clusters_pfc<=2;
    channels_pfc = channels_pfc(idx);    
    meanc_res.channels{p} = channels_pfc;
    meanc_res.clusters{p} = clusters_pfc(idx);
    
    %LFP deep and sup
    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(['LFPData/LFP' num2str(channel) '.mat'])
    PFCdeep = LFP;
%     load('ChannelsToAnalyse/PFCx_sup.mat')
%     load(['LFPData/LFP' num2str(channel) '.mat'])
%     PFCsup = LFP;
    clear channel LFP
    
    
    %Deltawaves
    if ~isempty(Dir.hemisphere{p})
        load('DeltaWaves.mat', ['deltas_PFCx_' Dir.hemisphere{p}])
        eval(['DeltaDiff = and(deltas_PFCx_' Dir.hemisphere{p} ',NREM);'])
    else
        load('DeltaWaves.mat', 'deltas_PFCx')
        DeltaDiff = deltas_PFCx;
    end
    st_diff = Start(DeltaDiff);
    
    %Global downstate
    if ~isempty(Dir.hemisphere{p})
        load('DownState.mat', ['down_PFCx_' Dir.hemisphere{p}])
        eval(['GlobalDown = and(down_PFCx_' Dir.hemisphere{p} ',NREM);'])
    else
        load('DownState.mat', 'down_PFCx')
        GlobalDown = and(down_PFCx,NREM);
    end
    st_down = Start(GlobalDown);
    
    %save
    meanc_res.nb.diff{p} = length(Start(DeltaDiff));
    meanc_res.nb.down{p} = length(Start(GlobalDown));
    meanc_res.nb.ripples{p} = length(tRipples);
    
    
    %% Select down/delta after ripples and others
    
    %down
    intv = [Range(tRipples) Range(tRipples)+250*10];
    [status,~,~] = InIntervals(st_down, intv);
    DownRipples = subset(GlobalDown, find(status));
    DownOut = subset(GlobalDown, setdiff(1:length(st_down),find(status)));
    %diff
    intv = [Range(tRipples) Range(tRipples)+250*10];
    [status,~,~] = InIntervals(st_diff, intv);
    DiffRipples = subset(DeltaDiff, find(status));
    DiffOut = subset(DeltaDiff, setdiff(1:length(st_diff),find(status)));
    
    
    %% Meancurves
    %Down
    [m,~,tps] = mETAverage((Start(DownRipples)+End(DownRipples))/2, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    meanc_res.met_down.ripples{p}(:,1) = tps; meanc_res.met_down.ripples{p}(:,2) = m;
    [m,~,tps] = mETAverage((Start(DownOut)+End(DownOut))/2, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    meanc_res.met_down.out{p}(:,1) = tps; meanc_res.met_down.out{p}(:,2) = m;
    
    %Diff
    [m,~,tps] = mETAverage((Start(DiffRipples)+End(DiffRipples))/2, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    meanc_res.met_diff.ripples{p}(:,1) = tps; meanc_res.met_diff.ripples{p}(:,2) = m;
    [m,~,tps] = mETAverage((Start(DiffOut)+End(DiffOut))/2, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    meanc_res.met_diff.out{p}(:,1) = tps; meanc_res.met_diff.out{p}(:,2) = m;
        
        
    %% amplitude and durations
    
    %durations
    meanc_res.durations.down.ripples{p} = End(DownRipples) - Start(DownRipples);
    meanc_res.durations.down.out{p} = End(DownOut) - Start(DownOut);
    
    meanc_res.durations.diff.ripples{p} = End(DiffRipples) - Start(DiffRipples);
    meanc_res.durations.diff.out{p} = End(DiffOut) - Start(DiffOut);
    
    %amplitude
    func_max = @(a) measureOnSignal(a,'maximum');
    func_min = @(a) measureOnSignal(a,'minimum');
    
    centersdt = ts((Start(DownRipples) + End(DownRipples))/2);
    meanc_res.amplitudes.down.ripples{p} = Data(Restrict(PFCdeep, centersdt));
    
    centersdt = ts((Start(DownOut) + End(DownOut))/2);
    meanc_res.amplitudes.down.out{p} = Data(Restrict(PFCdeep, centersdt));
    
    centersdt = ts((Start(DiffRipples) + End(DiffRipples))/2);
    meanc_res.amplitudes.diff.ripples{p} = Data(Restrict(PFCdeep, centersdt));
    
    centersdt = ts((Start(DiffOut) + End(DiffOut))/2);
    meanc_res.amplitudes.diff.out{p} = Data(Restrict(PFCdeep, centersdt));
    
    
    
%         
%     [meanc_res.amplitudes.down.ripples{p}, ~, ~] = functionOnEpochs(PFCdeep, DownRipples, func_max);
%     [meanc_res.amplitudes.down.out{p}, ~, ~] = functionOnEpochs(PFCdeep, DownOut, func_max);
%     
%     [meanc_res.amplitudes.diff.ripples{p}, ~, ~] = functionOnEpochs(PFCdeep, DiffRipples, func_max);
%     [meanc_res.amplitudes.diff.out{p}, ~, ~] = functionOnEpochs(PFCdeep, DiffOut, func_max);
    
    
    %% deltas
     for ch=1:length(channels_pfc)
        
        %% delta waves of channel (signle channel detection)
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(channels_pfc(ch))])
        eval(['a = delta_ch_' num2str(channels_pfc(ch)) ';'])
        DeltaWavesCh = a;
        
        %global delta and other delta 1 - for down > 75ms
        [RealDelta, ~, ~,idGoodDelta,~] = GetIntersectionsEpochs(DeltaWavesCh, GlobalDown);
        FakeDelta = subset(DeltaWavesCh, setdiff(1:length(Start(DeltaWavesCh)),idGoodDelta)');
        
        meanc_res.nb.good{p,ch} = length(Start(RealDelta));
        meanc_res.nb.fake{p,ch} = length(Start(FakeDelta));
        
        
        %% Select down/delta after ripples and others
        %real deltas
        intv = [Range(tRipples) Range(tRipples)+450*10];
        [status,~,~] = InIntervals(Start(RealDelta), intv);
        RealdtRipples = subset(RealDelta, find(status));
        RealdtOut = subset(RealDelta, setdiff(1:length(Start(RealDelta)),find(status)));
        %fake deltas
        intv = [Range(tRipples) Range(tRipples)+450*10];
        [status,~,~] = InIntervals(Start(FakeDelta), intv);
        FakedtRipples = subset(FakeDelta, find(status));
        FakedtOut = subset(FakeDelta, setdiff(1:length(Start(FakeDelta)),find(status)));
        
        
        
        %% meancurves
        
        %Good
        [m,~,tps] = mETAverage(Start(RealdtRipples), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
        meanc_res.met_good.ripples{p,ch}(:,1) = tps; meanc_res.met_good.ripples{p,ch}(:,2) = m;
        [m,~,tps] = mETAverage(Start(RealdtOut), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
        meanc_res.met_good.out{p,ch}(:,1) = tps; meanc_res.met_good.out{p,ch}(:,2) = m;
        
        %Fake
        [m,~,tps] = mETAverage(Start(FakedtRipples), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
        meanc_res.met_fake.ripples{p,ch}(:,1) = tps; meanc_res.met_fake.ripples{p,ch}(:,2) = m;
        [m,~,tps] = mETAverage(Start(FakedtOut), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
        meanc_res.met_fake.out{p,ch}(:,1) = tps; meanc_res.met_fake.out{p,ch}(:,2) = m;
        
        
        
        %% durations and amplitudes
        
        %durations
        meanc_res.durations.good.ripples{p,ch} = End(RealdtRipples) - Start(RealdtRipples);
        meanc_res.durations.good.out{p,ch} = End(RealdtOut) - Start(RealdtOut);

        meanc_res.durations.fake.ripples{p,ch} = End(FakedtRipples) - Start(FakedtRipples);
        meanc_res.durations.fake.out{p,ch} = End(FakedtOut) - Start(FakedtOut);
        
        %amplitude
        centersdt = ts(Start(RealdtRipples));
        meanc_res.amplitudes.good.ripples{p,ch} = Data(Restrict(PFCdeep, centersdt));
        
        centersdt = ts(Start(RealdtOut));
        meanc_res.amplitudes.good.out{p,ch} = Data(Restrict(PFCdeep, centersdt));
        
        centersdt = ts(Start(FakedtRipples));
        meanc_res.amplitudes.fake.ripples{p,ch} = Data(Restrict(PFCdeep, centersdt));
        
        centersdt = ts(Start(FakedtOut));
        meanc_res.amplitudes.fake.out{p,ch} = Data(Restrict(PFCdeep, centersdt));

%         %amplitude
%         func_max = @(a) measureOnSignal(a,'peak');
%         func_min = @(a) measureOnSignal(a,'trough');
% 
%         [meanc_res.amplitudes.good.ripples{p,ch}, ~, ~] = functionOnEpochs(PFCdeep, RealdtRipples, func_max);
%         [meanc_res.amplitudes.good.out{p,ch}, ~, ~] = functionOnEpochs(PFCdeep, RealdtOut, func_max);
% 
%         [meanc_res.amplitudes.fake.ripples{p,ch}, ~, ~] = functionOnEpochs(PFCdeep, FakedtRipples, func_max);
%         [meanc_res.amplitudes.fake.out{p,ch}, ~, ~] = functionOnEpochs(PFCdeep, FakedtOut, func_max);
        
        
     end
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save MeancurvesDeltaAfterRipples.mat meanc_res

