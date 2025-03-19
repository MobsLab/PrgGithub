%%RipplesOutDeltaN2N3Effect
% 27.07.2019 KJ
%
%
%
%
% see
%   TonesInDownN2N3Effect RipplesOutDeltaN2N3Raster
%   RipplesInDeltaN2N3Effect
%


% clear

Dir = PathForExperimentsRipplesDelta;

effect_periods = GetEffectPeriodUpDeltaRipples(Dir);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripples_res delay_detections effect_periods
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
%     range_up = [0 200]*10;   % [0-80ms] after tone in Down
    range_up = effect_periods(p,:);
    mindurationDelta = 75;
    minDurationUp = 0.5e4;
    maxDurationUp = 30e4;
    
    %sleep stage
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [~, N2, N3] = GetSubstages;
    
    %ripples       
    [tRipples, ~] = GetRipples;
    ripples_res.nb_ripples = length(tRipples);
        
    %channels
    load('ChannelsToAnalyse/PFCx_clusters.mat','channels','clusters')
    ripples_res.channels{p} = channels;
    ripples_res.clusters{p} = clusters;
    %LFP
    PFC = cell(0);
    for ch=1:length(channels)
        load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
        PFC{ch} = LFP;
        clear LFP
    end
    
    %Delta waves
    load('DeltaWaves.mat', 'deltamax_PFCx')
    deltamax_PFCx = dropShortIntervals(deltamax_PFCx,mindurationDelta);
    deltas_PFCx = CleanUpEpoch(and(deltamax_PFCx,NREM),1);
    st_deltas = Start(deltas_PFCx);
    end_deltas = End(deltas_PFCx);
    %Up
    up_PFCx = intervalSet(end_deltas(1:end-1), st_deltas(2:end));
    up_PFCx = dropShortIntervals(up_PFCx,minDurationUp);
    up_PFCx = dropLongIntervals(up_PFCx, maxDurationUp);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Create sham
    nb_sham = min(5000, length(st_up));
    idx = randsample(length(st_up), nb_sham);
    sham_tmp = [];

    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end    
    ShamEvent = ts(sort(sham_tmp));
    
    
    %% Ripples in - N2 & N3
    RipplesUpN2   = Restrict(Restrict(tRipples, N2), up_PFCx);
    RipplesUpN3   = Restrict(Restrict(tRipples, N3), up_PFCx);
    RipplesUpNREM = Restrict(Restrict(tRipples, NREM), up_PFCx);
    
    IntvTransitN2  = intervalSet(Range(RipplesUpN2)+range_up(1), Range(RipplesUpN2)+range_up(2));
    IntvTransitN3  = intervalSet(Range(RipplesUpN3)+range_up(1), Range(RipplesUpN3)+range_up(2));
    IntvTransitNREM  = intervalSet(Range(RipplesUpNREM)+range_up(1), Range(RipplesUpNREM)+range_up(2));
    
    ripples_res.n2.nb_ripples{p}   = length(RipplesUpN2);
    ripples_res.n3.nb_ripples{p}   = length(RipplesUpN3);
    ripples_res.nrem.nb_ripples{p} = length(RipplesUpNREM);
    
    
    %% Sham in - N2 & N3 & NREM
    ShamUpN2 = Restrict(Restrict(ShamEvent, N2), up_PFCx);
    ShamUpN3 = Restrict(Restrict(ShamEvent, N3), up_PFCx);
    ShamUpNREM = Restrict(Restrict(ShamEvent, NREM), up_PFCx);
    
    ShamTransitN2   = intervalSet(Range(ShamUpN2)+range_up(1), Range(ShamUpN2)+range_up(2));
    ShamTransitN3   = intervalSet(Range(ShamUpN3)+range_up(1), Range(ShamUpN3)+range_up(2));
    ShamTransitNREM = intervalSet(Range(ShamUpNREM)+range_up(1), Range(ShamUpNREM)+range_up(2));
    
    ripples_res.n2.nb_sham{p}   = length(ShamUpN2);
    ripples_res.n3.nb_sham{p}   = length(ShamUpN3);
    ripples_res.nrem.nb_sham{p} = length(ShamUpNREM);
    
     %% Delay between ripples and transitions
    
    %N2
    ripplesin_tmp = Range(RipplesUpN2);
    ripples_res.n2.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.n2.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        st_bef = st_up(find(st_up<ripplesin_tmp(i),1,'last'));
        ripples_res.n2.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>ripplesin_tmp(i),1));
        ripples_res.n2.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end

    %N3
    ripplesin_tmp = Range(RipplesUpN3);
    ripples_res.n3.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.n3.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        st_bef = st_up(find(st_up<ripplesin_tmp(i),1,'last'));
        ripples_res.n3.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>ripplesin_tmp(i),1));
        ripples_res.n3.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    %NREM
    ripplesin_tmp = Range(RipplesUpNREM);
    ripples_res.nrem.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.nrem.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        st_bef = st_up(find(st_up<ripplesin_tmp(i),1,'last'));
        ripples_res.nrem.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>ripplesin_tmp(i),1));
        ripples_res.nrem.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    
    %% Delay between sham and transitions
    
    %N2
    shamin_tmp = Range(ShamUpN2);
    ripples_res.n2.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripples_res.n2.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        ripples_res.n2.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        ripples_res.n2.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end

    %N3
    shamin_tmp = Range(ShamUpN3);
    ripples_res.n3.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripples_res.n3.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        ripples_res.n3.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        ripples_res.n3.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %NREM
    shamin_tmp = Range(ShamUpNREM);
    ripples_res.nrem.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripples_res.nrem.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        ripples_res.nrem.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        ripples_res.nrem.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    
    %% Success to create a transition for TONES
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.n2.nb_transit.ripples{p} = length(intervals);
    ripples_res.n2.transit_rate.ripples{p} = length(intervals) / ripples_res.n2.nb_ripples{p};
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.n3.nb_transit.ripples{p} = length(intervals);
    ripples_res.n3.transit_rate.ripples{p} = length(intervals) / ripples_res.n3.nb_ripples{p};
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.nrem.nb_transit.ripples{p} = length(intervals);
    ripples_res.nrem.transit_rate.ripples{p} = length(intervals) / ripples_res.nrem.nb_ripples{p};
    
    %% Success to create a transition for SHAM
    
    %N2
    intv = [Start(ShamTransitN2) End(ShamTransitN2)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.n2.nb_transit.sham{p} = length(intervals);
    ripples_res.n2.transit_rate.sham{p} = length(intervals) / ripples_res.n2.nb_sham{p};
    
    %N3
    intv = [Start(ShamTransitN3) End(ShamTransitN3)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.n3.nb_transit.sham{p} = length(intervals);
    ripples_res.n3.transit_rate.sham{p} = length(intervals) / ripples_res.n3.nb_sham{p};
    
    %NREM
    intv = [Start(ShamTransitNREM) End(ShamTransitNREM)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.nrem.nb_transit.sham{p} = length(intervals);
    ripples_res.nrem.transit_rate.sham{p} = length(intervals) / ripples_res.nrem.nb_sham{p};
    
    
    %% LFP response for ripples
    %average by clusters
    for c=1:5
        y_clu.n2 = []; y_clu.n3 = []; y_clu.nrem = [];
        x_clu.n2 = []; x_clu.n3 = []; x_clu.nrem = [];
        for ch=1:length(PFC)
            if clusters(ch)==c
                %N2
                [m,~,tps] = mETAverage(Range(RipplesUpN2), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.n2 = [y_clu.n2 m]; x_clu.n2 = tps;
                %N3
                [m,~,tps] = mETAverage(Range(RipplesUpN3), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.n3 = [y_clu.n3 m]; x_clu.n3 = tps;
                %NREM
                [m,~,tps] = mETAverage(Range(RipplesUpNREM), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.nrem = [y_clu.nrem m]; x_clu.nrem = tps;
            end
        end
        if ~isempty(x_clu.n2)
            %N2
            ripples_res.n2.met_rip{p,c}(:,1) = x_clu.n2;
            ripples_res.n2.met_rip{p,c}(:,2) = mean(y_clu.n2,2); 
            %N2
            ripples_res.n3.met_rip{p,c}(:,2) = mean(y_clu.n3,2); 
            ripples_res.n3.met_rip{p,c}(:,1) = x_clu.n3;
            %N2
            ripples_res.nrem.met_rip{p,c}(:,2) = mean(y_clu.nrem,2); 
            ripples_res.nrem.met_rip{p,c}(:,1) = x_clu.nrem;
        end
    end
    
    
    
    %% LFP response for sham
    %average by clusters
    for c=1:5
        y_clu.n2 = []; y_clu.n3 = []; y_clu.nrem = [];
        x_clu.n2 = []; x_clu.n3 = []; x_clu.nrem = [];
        for ch=1:length(PFC)
            if clusters(ch)==c
                %N2
                [m,~,tps] = mETAverage(Range(ShamUpN2), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.n2 = [y_clu.n2 m]; x_clu.n2 = tps;
                %N3
                [m,~,tps] = mETAverage(Range(ShamUpN3), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.n3 = [y_clu.n3 m]; x_clu.n3 = tps;
                %NREM
                [m,~,tps] = mETAverage(Range(ShamUpNREM), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.nrem = [y_clu.nrem m]; x_clu.nrem = tps;
            end
        end
        if ~isempty(x_clu.n2)
            %N2
            ripples_res.n2.met_sham{p,c}(:,1) = x_clu.n2;
            ripples_res.n2.met_sham{p,c}(:,2) = mean(y_clu.n2,2); 
            %N2
            ripples_res.n3.met_sham{p,c}(:,2) = mean(y_clu.n3,2); 
            ripples_res.n3.met_sham{p,c}(:,1) = x_clu.n3;
            %N2
            ripples_res.nrem.met_sham{p,c}(:,2) = mean(y_clu.nrem,2); 
            ripples_res.nrem.met_sham{p,c}(:,1) = x_clu.nrem;
        end
    end
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save RipplesOutDeltaN2N3Effect.mat ripples_res binsize_met nbBins_met minDurationUp effect_periods



