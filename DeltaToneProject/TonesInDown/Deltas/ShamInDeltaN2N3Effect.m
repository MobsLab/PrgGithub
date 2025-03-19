%%ShamInDeltaN2N3Effect
% 18.09.2018 KJ
%
%
%
%
% see
%   FigTonesInDeltaN2N3 ShamInDownN2N3Effect ShamInDeltaN2N3Raster
%   ShamOutDeltaN2N3Effect TonesInDeltaN2N3Effect



clear

Dir = PathForExperimentsRandomShamDelta;

delay_detections = GetDelayBetweenDeltaDown(Dir);
effect_periods = GetEffectPeriodEndDeltaTone(Dir);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p sham_res delay_detections effect_periods
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    
    
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
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    shamras_res.nb_sham = length(SHAMtime);
    
    %channels
    load('ChannelsToAnalyse/PFCx_clusters.mat','channels','clusters')
    sham_res.channels{p} = channels;
    sham_res.clusters{p} = clusters;
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
    
    
    %% Sham in - N2 & N3
    ShamDeltaN2   = Restrict(Restrict(SHAMtime, N2), deltas_PFCx);
    ShamDeltaN3   = Restrict(Restrict(SHAMtime, N3), deltas_PFCx);
    ShamDeltaNREM = Restrict(Restrict(SHAMtime, NREM), deltas_PFCx);
    
    IntvTransitN2  = intervalSet(Range(ShamDeltaN2)+range_delta(1), Range(ShamDeltaN2)+range_delta(2));
    IntvTransitN3  = intervalSet(Range(ShamDeltaN3)+range_delta(1), Range(ShamDeltaN3)+range_delta(2));
    IntvTransitNREM  = intervalSet(Range(ShamDeltaNREM)+range_delta(1), Range(ShamDeltaNREM)+range_delta(2));
    
    sham_res.n2.nb_sham{p} = length(ShamDeltaN2);
    sham_res.n3.nb_sham{p} = length(ShamDeltaN3);
    sham_res.nrem.nb_sham{p} = length(ShamDeltaNREM);
    
    
    %% Delay between sham and transitions
    
    %N2
    shamin_tmp = Range(ShamDeltaN2);
    sham_res.n2.sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_res.n2.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        sham_res.n2.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        sham_res.n2.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end

    %N3
    shamin_tmp = Range(ShamDeltaN3);
    sham_res.n3.sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_res.n3.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        sham_res.n3.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        sham_res.n3.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %NREM
    shamin_tmp = Range(ShamDeltaNREM);
    sham_res.nrem.sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_res.nrem.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        sham_res.nrem.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        sham_res.nrem.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    
    %% Success to create a transition
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_deltas, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.n2.nb_transit{p} = length(intervals);
    sham_res.n2.transit_rate{p} = length(intervals) / sham_res.n2.nb_sham{p};
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_deltas, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.n3.nb_transit{p} = length(intervals);
    sham_res.n3.transit_rate{p} = length(intervals) / sham_res.n3.nb_sham{p};
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_deltas, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.nrem.nb_transit{p} = length(intervals);
    sham_res.nrem.transit_rate{p} = length(intervals) / sham_res.nrem.nb_sham{p};
    
    
    
    %% LFP response for tones
    %average by clusters
    for c=1:5
        y_clu.n2 = []; y_clu.n3 = []; y_clu.nrem = [];
        x_clu.n2 = []; x_clu.n3 = []; x_clu.nrem = [];
        for ch=1:length(PFC)
            if clusters(ch)==c
                %N2
                [m,~,tps] = mETAverage(Range(ShamDeltaN2), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.n2 = [y_clu.n2 m]; x_clu.n2 = tps;
                %N3
                [m,~,tps] = mETAverage(Range(ShamDeltaN3), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.n3 = [y_clu.n3 m]; x_clu.n3 = tps;
                %NREM
                [m,~,tps] = mETAverage(Range(ShamDeltaNREM), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
                y_clu.nrem = [y_clu.nrem m]; x_clu.nrem = tps;
            end
        end
        if ~isempty(x_clu.n2)
            %N2
            sham_res.n2.met_lfp{p,c}(:,1) = x_clu.n2;
            sham_res.n2.met_lfp{p,c}(:,2) = mean(y_clu.n2,2); 
            %N2
            sham_res.n3.met_lfp{p,c}(:,2) = mean(y_clu.n3,2); 
            sham_res.n3.met_lfp{p,c}(:,1) = x_clu.n3;
            %N2
            sham_res.nrem.met_lfp{p,c}(:,2) = mean(y_clu.nrem,2); 
            sham_res.nrem.met_lfp{p,c}(:,1) = x_clu.nrem;
        end
    end
    

    
end


%saving data
cd(FolderDeltaDataKJ)
save ShamInDeltaN2N3Effect.mat sham_res binsize_met nbBins_met range_delta



