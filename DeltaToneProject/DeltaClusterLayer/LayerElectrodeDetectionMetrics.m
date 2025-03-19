%%LayerElectrodeDetectionMetrics
% 30.07.2019 KJ
%
%   
%   
%
% see
%   LFPlayerInfluenceOnDetection LFPonDownStatesLayer DeltaSingleChannelAnalysis
%   LayerElectrodeDetectionMetricsPlot

% clear

Dir = PathForExperimentsBasalSleepSpike;

%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p layer_res
    
    layer_res.path{p}   = Dir.path{p};
    layer_res.manipe{p} = Dir.manipe{p};
    layer_res.name{p}   = Dir.name{p};
    layer_res.date{p}   = Dir.date{p};
    
    
    %% params
    durRange          = [125 175] * 10; 
    binsize_met       = 5; %for mETAverage  
    nbBins_met        = 240; %for mETAverage 
    preripples_window = 300*10; %300ms
    hemisphere        = 0;
    
    binsize_cc = 10; %10ms
    nb_binscc = 100;
    
    intvDur_deep = 0*10; %0ms
    intvDur_sup = 10*10; %10ms
    smoothing = 1;
    windowsize = 60E4; %60s
    
    
    %% load data

    % Epoch
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    load(fullfile(layer_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    
    %PFC channels
    load('IdFigureData2.mat', 'channel_curves', 'structures_curves', 'peak_value')
    idx = find(strcmpi(structures_curves,'PFCx'));
    channel_curves = channel_curves(idx);
    peak_value = peak_value(idx);
    %peak value
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    for ch=1:length(channels)
        peak_value_new(ch) = peak_value(channel_curves==channels(ch));
    end
    peak_value = peak_value_new;
    %LFP load
    Signals = cell(0); hemi_channel = cell(0);
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    load(fullfile(Dir.path{p}, 'LFPData', 'InfoLFP.mat'))
    for ch=1:length(channels)
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels(ch));
        hemi_channel{ch} = char(lower(hemi_channel{ch}));
        hemi_channel{ch} = hemi_channel{ch}(1);
        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
        Signals{ch} = LFP; clear LFP
    end
    
    layer_res.channels{p}     = channels;
    layer_res.peak_value{p}   = peak_value;
    layer_res.hemi_channel{p} = hemi_channel;
    
    %ECOG ?
    ecogs = [];
    if exist('ChannelsToAnalyse/PFCx_ecog.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog.mat','channel')
        ecogs = [ecogs channel];
    end
    if exist('ChannelsToAnalyse/PFCx_ecog_right.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog_right.mat','channel')
        ecogs = [ecogs channel];
    end
    if exist('ChannelsToAnalyse/PFCx_ecog_left.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog_left.mat','channel')
        ecogs = [ecogs channel];
    end
    layer_res.ecogs{p} = unique(ecogs);
    
    
    %Delta detection
    for ch=1:length(channels)
        name_var = ['delta_ch_' num2str(channels(ch))];
        load('DeltaWavesChannels.mat', name_var)
        eval(['deltas = ' name_var ';'])
        %Restrict    
        deltas_chan{ch}  = and(deltas, NREM);
        st_deltachan{ch} = Start(deltas_chan{ch});
    end

    
    %% load events
    %down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    center_down = (End(down_PFCx) + Start(down_PFCx))/2;
    end_down = End(down_PFCx);
    down_durations = End(down_PFCx) - Start(down_PFCx);
    selected_down = st_down(down_durations>durRange(1) & down_durations<durRange(2));
    
    %other hemisphere
    load('DownState.mat', 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        hemisphere=1;
        st_down_r = Start(down_PFCx_r);
        center_down_r = (End(down_PFCx_r) + Start(down_PFCx_r))/2;
        dur = End(down_PFCx_r) - Start(down_PFCx_r);
        selected_down_r = st_down_r(dur>durRange(1) & dur<durRange(2));
    end
    load('DownState.mat', 'down_PFCx_l')
    if exist('down_PFCx_l','var')
        hemisphere=1;
        st_down_l = Start(down_PFCx_l);
        center_down_l = (End(down_PFCx_l) + Start(down_PFCx_l))/2;
        dur = End(down_PFCx_l) - Start(down_PFCx_l);
        selected_down_l = st_down_l(dur>durRange(1) & dur<durRange(2));
    end
    
    
    %deltas
    load('DeltaWaves.mat', 'deltas_PFCx')
    st_delta = Start(deltas_PFCx);
    dur = End(deltas_PFCx) - Start(deltas_PFCx);
    selected_delta = st_delta(dur>durRange(1) & dur<durRange(2));
    
    %other hemisphere
    load('DeltaWaves.mat', 'deltas_PFCx_r')
    if exist('deltas_PFCx_r','var')
        Delta_r = deltas_PFCx_r;
        st_delta_r = Start(Delta_r);
        delta_durations_r = End(Delta_r) - Start(Delta_r);
        selected_delta_r = st_delta_r(delta_durations_r>durRange(1) & delta_durations_r<durRange(2));
    end
    load('DeltaWaves.mat', 'deltas_PFCx_l')
    if exist('deltas_PFCx_l','var')
        Delta_l = deltas_PFCx_l;
        st_delta_l = Start(Delta_l);
        delta_durations_l = End(Delta_l) - Start(Delta_l);
        selected_delta_l = st_delta_l(delta_durations_l>durRange(1) & delta_durations_l<durRange(2));
    end
    
    %ripples
    if exist('Ripples.mat','file')==2
        [tRipples, ~] = GetRipples;
        ripples_tmp = Range(Restrict(tRipples, NREM));
        
        %ripples without down before
        intvdownripples = [st_down end_down+preripples_window];
        [status,~,~] = InIntervals(ripples_tmp, intvdownripples);
        ripples_alone = ripples_tmp(status==0);
        
        %hemisphere
        load('ChannelsToAnalyse/dHPC_rip.mat','channel')
        hemi_rip = InfoLFP.hemisphere(InfoLFP.channel==channel); 
        hemi_rip = char(lower(hemi_rip));
        hemi_rip = hemi_rip(1);
        
    else
        ripples_tmp = [];
        ripples_alone = [];
    end

    %spindles
    if exist('Spindles.mat','file')==2
        [tSpindles, ~] = GetSpindles;
        spindles_tmp = Range(tSpindles);
    else
        spindles_tmp = [];
    end
    
    
    %% MEAN CURVES   
    for ch=1:length(channels)
        %event for the hemisphere
        if hemisphere && strcmpi(hemi_channel{ch},'r') %right
            seldown = selected_down_r;
            seldelta = selected_delta_r;
        elseif hemisphere && strcmpi(hemi_channel{ch},'l') %left
            seldown = selected_down_l;
            seldelta = selected_delta_l;
        else 
            seldown = selected_down;
            seldelta = selected_delta;
        end
        
        %down
        [m,~,tps] = mETAverage(seldown, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandown{ch}(:,1) = tps; meandown{ch}(:,2) = m;
        
        %ripples
        if ~isempty(ripples_tmp)
            [m,s,tps] = mETAverage(ripples_tmp, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meanripples{ch}(:,1) = tps; meanripples{ch}(:,2) = m;
        else
            meanripples{ch} = [];
        end
        
        %ripples without down before
        if ~isempty(ripples_alone)
            [m,s,tps] = mETAverage(ripples_alone, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meanripplesco{ch}(:,1) = tps; meanripplesco{ch}(:,2) = m;
        else
            meanripplesco{ch} = [];
        end
        
        %spindles
        if ~isempty(spindles_tmp)
            [m,s,tps] = mETAverage(spindles_tmp*10, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meanspindles{ch}(:,1) = tps; meanspindles{ch}(:,2) = m;
        else
            meanspindles{ch} = [];
        end
        
        %delta
        [m,~,tps] = mETAverage(seldelta, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandelta{ch}(:,1) = tps; meandelta{ch}(:,2) = m;      
        
        %deltas of channel
        dur = End(deltas_chan{ch}) - Start(deltas_chan{ch});
        selected_deltach = st_deltachan{ch}(dur>durRange(1) & dur<durRange(2));
        try
            [m,~,tps] = mETAverage(selected_deltach, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
            meandelta_ch{ch}(:,1) = tps; meandelta_ch{ch}(:,2) = m;
        end
    end
    
    save meancurves
    layer_res.down.meandown{p}              = meandown;
    layer_res.down.nb{p}                    = sum(selected_down);
    layer_res.ripples.meancurves{p}         = meanripples;
    layer_res.ripples.nb{p}                 = length(ripples_tmp);
    layer_res.ripples_correct.meancurves{p} = meanripplesco;
    layer_res.ripples_correct.nb{p}         = length(ripples_alone);
    layer_res.spindles.meancurves{p}        = meanspindles;
    layer_res.spindles.nb{p}                = length(spindles_tmp);
    layer_res.delta.meandelta{p}            = meandelta;
    layer_res.delta.nb{p}                   = sum(selected_delta);
    layer_res.delta.meandelta_ch{p}         = meandelta_ch;
    
    
    %% Delta down correlogram
    if hemisphere %left and right
        %% right
        %Cross-corr down_delta
        [layer_res.down_delta.y{p}{1}, layer_res.down_delta.x{p}{1}] = CrossCorr(st_down_r, st_delta_r, binsize_cc, nb_binscc);
        [layer_res.delta_down.y{p}{1}, layer_res.delta_down.x{p}{1}] = CrossCorr(st_delta_r, st_down_r, binsize_cc, nb_binscc);
        layer_res.peakcc.down_delta{p}(1)=max(layer_res.down_delta.y{p}{1});
        layer_res.peakcc.delta_down{p}(1)=max(layer_res.delta_down.y{p}{1});
        
        %% left
        %Cross-corr down_delta
        [layer_res.down_delta.y{p}{2}, layer_res.down_delta.x{p}{2}] = CrossCorr(st_down_l, st_delta_l, binsize_cc, nb_binscc);
        [layer_res.delta_down.y{p}{2}, layer_res.delta_down.x{p}{2}] = CrossCorr(st_delta_l, st_down_l, binsize_cc, nb_binscc);
        layer_res.peakcc.down_delta{p}(2) = max(layer_res.down_delta.y{p}{2});
        layer_res.peakcc.delta_down{p}(2) = max(layer_res.delta_down.y{p}{2});
        
        % for each individual channels
        for ch=1:length(layer_res.channels{p})
            h = char(hemi_channel{ch});
            if strcmpi(hemi_channel{ch},'r') 
                st_down_h = st_down_r;
            elseif strcmpi(hemi_channel{ch},'l')
                st_down_h = st_down_l;
            end
            %Cross-corr down_delta
            [layer_res.down_deltach.y{p}{ch}, layer_res.down_deltach.x{p}{ch}] = CrossCorr(st_down_h, st_deltachan{ch}, binsize_cc, nb_binscc);
            [layer_res.deltach_down.y{p}{ch}, layer_res.deltach_down.x{p}{ch}] = CrossCorr(st_deltachan{ch}, st_down_h, binsize_cc, nb_binscc);
            layer_res.peakcc.down_deltach{p}(ch) = max(layer_res.down_deltach.y{p}{ch});
            layer_res.peakcc.deltach_down{p}(ch) = max(layer_res.deltach_down.y{p}{ch});
        end
        
    else
        %Cross-corr down_delta
        [layer_res.down_delta.y{p}{1}, layer_res.down_delta.x{p}{1}] = CrossCorr(st_down, st_delta, binsize_cc, nb_binscc);
        [layer_res.delta_down.y{p}{1}, layer_res.delta_down.x{p}{1}] = CrossCorr(st_delta, st_down, binsize_cc, nb_binscc);
        layer_res.peakcc.down_delta{p}(1)=max(layer_res.down_delta.y{p}{1});
        layer_res.peakcc.delta_down{p}(1)=max(layer_res.delta_down.y{p}{1});
        
        % for each individual channels
        for ch=1:length(layer_res.channels{p})
            %Cross-corr down_delta
            [layer_res.down_deltach.y{p}{ch}, layer_res.down_deltach.x{p}{ch}] = CrossCorr(st_down, st_deltachan{ch}, binsize_cc, nb_binscc);
            [layer_res.deltach_down.y{p}{ch}, layer_res.deltach_down.x{p}{ch}] = CrossCorr(st_deltachan{ch}, st_down, binsize_cc, nb_binscc);
            layer_res.peakcc.down_deltach{p}(ch) = max(layer_res.down_deltach.y{p}{ch});
            layer_res.peakcc.deltach_down{p}(ch) = max(layer_res.deltach_down.y{p}{ch});
        end
        
    end
    
    
    %% Ripples Correlogram
    if ~isempty(ripples_tmp)

        %with down
        [layer_res.down_rip.y{p}, layer_res.down_rip.x{p}] = CrossCorr(st_down, ripples_tmp, binsize_cc, nb_binscc);
        [layer_res.rip_down.y{p}, layer_res.rip_down.x{p}] = CrossCorr(ripples_tmp, st_down, binsize_cc, nb_binscc);
        layer_res.peakcc.down_rip{p} = max(layer_res.down_rip.y{p});
        layer_res.peakcc.rip_down{p} = max(layer_res.rip_down.y{p});
        
        %with deltas
        [layer_res.delta_rip.y{p}, layer_res.delta_rip.x{p}] = CrossCorr(st_delta, ripples_tmp, binsize_cc, nb_binscc);
        [layer_res.rip_delta.y{p}, layer_res.rip_delta.x{p}] = CrossCorr(ripples_tmp, st_delta, binsize_cc, nb_binscc);
        layer_res.peakcc.delta_rip{p} = max(layer_res.delta_rip.y{p});
        layer_res.peakcc.rip_delta{p} = max(layer_res.rip_delta.y{p});
            
        for ch=1:length(layer_res.channels{p})
            if strcmpi(hemi_channel{ch}, hemi_rip)
                [layer_res.deltach_rip.y{p}{ch}, layer_res.deltach_rip.x{p}{ch}] = CrossCorr(st_deltachan{ch}, ripples_tmp, binsize_cc, nb_binscc);
                [layer_res.rip_deltach.y{p}{ch}, layer_res.rip_deltach.x{p}{ch}] = CrossCorr(ripples_tmp, st_deltachan{ch}, binsize_cc, nb_binscc);
                layer_res.peakcc.deltach_rip{p}(ch) = max(layer_res.deltach_rip.y{p}{ch});
                layer_res.peakcc.rip_deltach{p}(ch) = max(layer_res.rip_deltach.y{p}{ch});
            else
                layer_res.peakcc.deltach_rip{p}(ch) = nan;
                layer_res.peakcc.rip_deltach{p}(ch) = nan;
            end
        end
        
    end
    
    
    %% Quantification 
    if hemisphere %left and right
        
        %% right        
        %intersection delta waves and down states
        margin = [-intvDur_deep intvDur_deep];
        [layer_res.multi.precision{p}(1), layer_res.multi.recall{p}(1), layer_res.multi.fscore{p}(1)] = DetectionMetrics_KJ(down_PFCx_r, deltas_PFCx_r, 'margin',margin);
        
        %down
        [density.x, density.down_r] = DensityCurves_KJ(ts(st_down_r), 'endtime',night_duration,'windowsize',windowsize,'smoothing',smoothing);
        
        %deltas
        [density.x, density.delta_r] = DensityCurves_KJ(ts(st_delta_r), 'endtime',night_duration,'windowsize',windowsize,'smoothing',smoothing);
        %similarity
        layer_res.multi.frechet_distance{p}(1) = DiscreteFrechetDist(density.down_r, density.delta_r);
        layer_res.multi.ratio_decrease{p}(1)   = CompareDecreaseDensity(density.down_r, density.delta_r, density.x);
        
        
        %% left
        %intersection delta waves and down states
        margin = [-intvDur_deep intvDur_deep];
        [layer_res.multi.precision{p}(2), layer_res.multi.recall{p}(2), layer_res.multi.fscore{p}(2)] = DetectionMetrics_KJ(down_PFCx_l, deltas_PFCx_l, 'margin',margin);
        
        %down
        [density.x, density.down_l] = DensityCurves_KJ(ts(st_down_l), 'endtime',night_duration,'windowsize',windowsize,'smoothing',smoothing);
        %deltas
        [density.x, density.delta_l] = DensityCurves_KJ(ts(st_delta_l), 'endtime',night_duration,'windowsize',windowsize,'smoothing',smoothing);
        %similarity
        layer_res.multi.frechet_distance{p}(2) = DiscreteFrechetDist(density.down_l, density.delta_l);
        layer_res.multi.ratio_decrease{p}(2)   = CompareDecreaseDensity(density.down_l, density.delta_l, density.x);
        

        % for each individual channels (recall, precision, fscore, frechet distance, ratio decrease ...)
        for ch=1:length(layer_res.channels{p})
            h = char(hemi_channel{ch});
            if strcmpi(hemi_channel{ch},'r')
                down_PFCx_h    = down_PFCx_r;
                density.down_h = density.down_r;
            elseif strcmpi(hemi_channel{ch},'l')
                down_PFCx_h    = down_PFCx_l;
                density.down_h = density.down_l;
            end
            
            %intersection delta waves and down states
            if peak_value(ch)>0
                margin = [-intvDur_deep intvDur_deep];
            else
                margin = [-intvDur_sup intvDur_sup];
            end
            [layer_res.single.precision{p}(ch), layer_res.single.recall{p}(ch), layer_res.single.fscore{p}(ch)] = DetectionMetrics_KJ(down_PFCx_h, deltas_chan{ch}, 'margin',margin);
            
            %deltas channels density
            [density.x, density.deltachan{ch}] = DensityCurves_KJ(ts(st_deltachan{ch}), 'endtime',night_duration,'windowsize',windowsize,'smoothing',smoothing);
            %similarity
            layer_res.single.frechet_distance{p}(ch) = DiscreteFrechetDist(density.down_h, density.deltachan{ch});
            layer_res.single.ratio_decrease{p}(ch)   = CompareDecreaseDensity(density.down_h, density.deltachan{ch}, density.x);
        end
        
        
        
    else
        %intersection delta waves and down states
        margin = [-intvDur_deep intvDur_deep];
        [layer_res.multi.precision{p}, layer_res.multi.recall{p}, layer_res.multi.fscore{p}] = DetectionMetrics_KJ(down_PFCx, deltas_PFCx, 'margin',margin);
        
        %down
        [density.x, density.down] = DensityCurves_KJ(ts(st_down), 'endtime',night_duration,'windowsize',windowsize,'smoothing',smoothing);
        %deltas
        [density.x, density.delta] = DensityCurves_KJ(ts(st_delta), 'endtime',night_duration,'windowsize',windowsize,'smoothing',smoothing);
        %similarity
        layer_res.multi.frechet_distance{p} = DiscreteFrechetDist(density.down, density.delta);
        layer_res.multi.ratio_decrease{p}   = CompareDecreaseDensity(density.down, density.delta, density.x);
        
        
        % for each individual channels (recall, precision, fscore, frechet distance, ratio decrease ...)
        for ch=1:length(layer_res.channels{p})
            %Cross-corr down_delta
            [corr_down_deltach, layer_res.down_deltach.x{p}{ch}] = CrossCorr(st_down, st_deltachan{ch}, binsize_cc, nb_binscc);
            [corr_deltach_down, layer_res.deltach_down.x{p}{ch}] = CrossCorr(st_deltachan{ch}, st_down, binsize_cc, nb_binscc);
            layer_res.down_deltach.y{p}{ch} = Smooth(corr_down_deltach, smoothing);
            layer_res.deltach_down.y{p}{ch} = Smooth(corr_deltach_down, smoothing);
        
            %intersection delta waves and down states
            if peak_value(ch)>0
                margin = [-intvDur_deep intvDur_deep];
            else
                margin = [-intvDur_sup intvDur_sup];
            end
            [layer_res.single.precision{p}(ch), layer_res.single.recall{p}(ch), layer_res.single.fscore{p}(ch)] = DetectionMetrics_KJ(down_PFCx, deltas_chan{ch}, 'margin',margin);
                        
            %deltas channels density
            [density.x, density.deltachan{ch}] = DensityCurves_KJ(ts(st_deltachan{ch}), 'endtime',night_duration,'windowsize',windowsize,'smoothing',smoothing);
            %similarity
            layer_res.single.frechet_distance{p}(ch) = DiscreteFrechetDist(density.down, density.deltachan{ch});
            layer_res.single.ratio_decrease{p}(ch)   = CompareDecreaseDensity(density.down, density.deltachan{ch}, density.x);
        end
        
    end

    
end


%saving data
cd(FolderDeltaDataKJ)
save LayerElectrodeDetectionMetrics.mat layer_res  




