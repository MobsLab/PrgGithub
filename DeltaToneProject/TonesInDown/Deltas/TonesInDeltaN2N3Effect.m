%%TonesInDeltaN2N3Effect
% 23.07.2019 KJ
%
%
%
%
% see
%   TonesInDownN2N3Effect ScriptTonesInDeltaOneNight
%   ScriptLoadDeltaTonesOneNight ShamInDeltaN2N3Effect TonesOutDeltaN2N3Effect
%


% clear

Dir = PathForExperimentsRandomTonesDelta;

delay_detections = GetDelayBetweenDeltaDown(Dir);
effect_periods = GetEffectPeriodEndDeltaTone(Dir);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tones_res delay_detections effect_periods
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
%     range_delta = [0 50]*10;   % [0-80ms] after tone in Down
    range_delta = effect_periods(p,:);
    minduration = 40*10;
    
    %sleep stage
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [~, N2, N3] = GetSubstages;
    
    %tones in deltas
    load('behavResources.mat', 'ToneEvent')
    tones_res.nb_tones{p} = length(ToneEvent);
        
    %channels
    load('ChannelsToAnalyse/PFCx_clusters.mat','channels','clusters')
    tones_res.channels{p} = channels;
    tones_res.clusters{p} = clusters;
    %LFP
    PFC = cell(0);
    for ch=1:length(channels)
        load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
        PFC{ch} = LFP;
        clear LFP
    end
    
    %Delta waves
    load('DeltaWaves.mat', 'deltamax_PFCx')
    deltamax_PFCx = dropShortIntervals(deltamax_PFCx,minduration);
    deltamax_PFCx = and(deltamax_PFCx,NREM);
    
    deltas_PFCx = intervalSet(Start(deltamax_PFCx)+delay_detections(p,1), End(deltamax_PFCx)+delay_detections(p,2));
    deltas_PFCx = CleanUpEpoch(deltas_PFCx,1);
    st_deltas = Start(deltas_PFCx);
    end_deltas = End(deltas_PFCx);
    
    
    %% Tones in - N2 & N3
    ToneDeltaN2 = Restrict(Restrict(ToneEvent, N2), deltas_PFCx);
    ToneDeltaN3 = Restrict(Restrict(ToneEvent, N3), deltas_PFCx);
    ToneDeltaNREM = Restrict(Restrict(ToneEvent, NREM), deltas_PFCx);
    
    IntvTransitN2    = intervalSet(Range(ToneDeltaN2)+range_delta(1), Range(ToneDeltaN2)+range_delta(2));
    IntvTransitN3    = intervalSet(Range(ToneDeltaN3)+range_delta(1), Range(ToneDeltaN3)+range_delta(2));
    IntvTransitNREM  = intervalSet(Range(ToneDeltaNREM)+range_delta(1), Range(ToneDeltaNREM)+range_delta(2));
    
    tones_res.n2.nb_tones{p}   = length(ToneDeltaN2);
    tones_res.n3.nb_tones{p}   = length(ToneDeltaN3);
    tones_res.nrem.nb_tones{p} = length(ToneDeltaNREM);
    
    
    %% Delay between tones and transitions
    
    %N2
    tonesin_tmp = Range(ToneDeltaN2);
    tones_res.n2.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.n2.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_deltas(find(st_deltas<tonesin_tmp(i),1,'last'));
        tones_res.n2.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>tonesin_tmp(i),1));
        tones_res.n2.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end

    %N3
    tonesin_tmp = Range(ToneDeltaN3);
    tones_res.n3.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.n3.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_deltas(find(st_deltas<tonesin_tmp(i),1,'last'));
        tones_res.n3.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>tonesin_tmp(i),1));
        tones_res.n3.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %NREM
    tonesin_tmp = Range(ToneDeltaNREM);
    tones_res.nrem.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.nrem.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_deltas(find(st_deltas<tonesin_tmp(i),1,'last'));
        tones_res.nrem.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>tonesin_tmp(i),1));
        tones_res.nrem.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    
    %% Success to create a transition
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_deltas, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.n2.nb_transit{p} = length(intervals);
    tones_res.n2.transit_rate{p} = length(intervals) / tones_res.n2.nb_tones{p};
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_deltas, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.n3.nb_transit{p} = length(intervals);
    tones_res.n3.transit_rate{p} = length(intervals) / tones_res.n3.nb_tones{p};
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_deltas, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.nrem.nb_transit{p} = length(intervals);
    tones_res.nrem.transit_rate{p} = length(intervals) / tones_res.nrem.nb_tones{p};
    
    
    %% LFP response for tones
    %average by clusters
    for c=1:5
        y_clu.n2 = []; y_clu.n3 = []; y_clu.nrem = [];
        x_clu.n2 = []; x_clu.n3 = []; x_clu.nrem = [];
        for ch=1:length(PFC)
            if clusters(ch)==c
                %N2
                [m,~,tps] = mETAverage(Range(ToneDeltaN2), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.n2 = [y_clu.n2 m]; x_clu.n2 = tps;
                %N3
                [m,~,tps] = mETAverage(Range(ToneDeltaN3), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.n3 = [y_clu.n3 m]; x_clu.n3 = tps;
                %NREM
                [m,~,tps] = mETAverage(Range(ToneDeltaNREM), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.nrem = [y_clu.nrem m]; x_clu.nrem = tps;
            end
        end
        if ~isempty(x_clu.n2)
            %N2
            tones_res.n2.met_lfp{p,c}(:,1) = x_clu.n2;
            tones_res.n2.met_lfp{p,c}(:,2) = mean(y_clu.n2,2); 
            %N2
            tones_res.n3.met_lfp{p,c}(:,2) = mean(y_clu.n3,2); 
            tones_res.n3.met_lfp{p,c}(:,1) = x_clu.n3;
            %N2
            tones_res.nrem.met_lfp{p,c}(:,2) = mean(y_clu.nrem,2); 
            tones_res.nrem.met_lfp{p,c}(:,1) = x_clu.nrem;
        end
    end
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save TonesInDeltaN2N3Effect.mat tones_res binsize_met nbBins_met minduration range_delta



