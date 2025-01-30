%%ShamOutDeltaN2N3Effect
% 24.07.2019 KJ
%
%
%
%
% see
%   ShamInUpN2N3Effect TonesOutDeltaN2N3Raster ShamInDeltaN2N3Effect
%



clear

Dir=PathForExperimentsRandomShamDelta;
effect_periods = GetEffectPeriodDeltaTone(Dir);


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p sham_res effect_periods
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    range_up = effect_periods(p,:);
    
    freq_delta = [1 12];
    thresh_std = 2;
    thresh_std2 = 1;
    minduration = 75*10; %for deltas
    maxDuration = 30e4; %for up states

    %sleep stage
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [~, N2, N3] = GetSubstages;
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    sham_res.nb_sham = length(SHAMtime);
    
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
    deltas_PFCx = CleanUpEpoch(and(deltamax_PFCx,NREM),1);
    st_deltas = Start(deltas_PFCx);
    end_deltas = End(deltas_PFCx);
    
    %Up
    up_PFCx = intervalSet(end_deltas(1:end-1), st_deltas(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Sham in - N2 & N3 & NREM
    ShamUpN2 = Restrict(Restrict(SHAMtime, N2), up_PFCx);
    ShamUpN3 = Restrict(Restrict(SHAMtime, N3), up_PFCx);
    ShamUpNREM = Restrict(Restrict(SHAMtime, NREM), up_PFCx);
    
    IntvTransitN2  = intervalSet(Range(ShamUpN2)+range_up(1), Range(ShamUpN2)+range_up(2));
    IntvTransitN3  = intervalSet(Range(ShamUpN3)+range_up(1), Range(ShamUpN3)+range_up(2));
    IntvTransitNREM  = intervalSet(Range(ShamUpNREM)+range_up(1), Range(ShamUpNREM)+range_up(2));
    
    sham_res.n2.nb_sham{p} = length(ShamUpN2);
    sham_res.n3.nb_sham{p} = length(ShamUpN3);
    sham_res.nrem.nb_sham{p} = length(ShamUpNREM);
    
    
    %% Delay between sham and transitions
    
    %N2
    shamin_tmp = Range(ShamUpN2);
    sham_res.n2.sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_res.n2.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        sham_res.n2.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        sham_res.n2.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end

    %N3
    shamin_tmp = Range(ShamUpN3);
    sham_res.n3.sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_res.n3.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        sham_res.n3.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        sham_res.n3.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %NREM
    shamin_tmp = Range(ShamUpNREM);
    sham_res.nrem.sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_res.nrem.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        sham_res.nrem.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        sham_res.nrem.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    
    %% Success to create a transition
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.n2.nb_transit{p} = length(intervals);
    sham_res.n2.transit_rate{p} = length(intervals) / sham_res.n2.nb_sham{p};
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.n3.nb_transit{p} = length(intervals);
    sham_res.n3.transit_rate{p} = length(intervals) / sham_res.n3.nb_sham{p};
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_up, intv);
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
save ShamOutDeltaN2N3Effect.mat sham_res binsize_met nbBins_met 



