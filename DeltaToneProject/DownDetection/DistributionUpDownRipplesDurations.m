%%DistributionUpDownRipplesDurations
% 28.06.2018 KJ
%
%
% see
%   UpDownDurations ShortUpAnalysis DistributionUpDownRipplesDurationsPlot
%


% clear

%% Dir


Dir=PathForExperimentsFakeSlowWave('hemisphere');


%% get data for each record

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p distrib_res
    
    distrib_res.path{p}   = Dir.path{p};
    distrib_res.manipe{p} = Dir.manipe{p};
    distrib_res.name{p}   = Dir.name{p};
    distrib_res.date{p}   = Dir.date{p};
    distrib_res.hemisphere{p}   = Dir.hemisphere{p};
    
    %params
    minDurationDown = 75; %50ms
    binsize_mua = 5;
        
    
    %% load
    
    %night duration
    load('IdFigureData2.mat', 'night_duration')
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %MUA
    if ~isempty(Dir.hemisphere{p})
        MUA = GetMuaNeurons_KJ(['PFCx_' Dir.hemisphere{p}], 'binsize',binsize_mua);
    else
        MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    end
    
    %ripples
    [tRipples, RipplesEpoch] = GetRipples;
    
    
    %% Down and up
    
    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');    
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    
    
    %NREM
    down_PFCx = CleanUpEpoch(and(down_PFCx,NREM),1);
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    up_PFCx = CleanUpEpoch(and(up_PFCx,NREM),1);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %% Up-Down with Ripples
    
    %Up
    intv_up = [st_up end_up];
    [~,intervals,~] = InIntervals(Range(tRipples), intv_up);
    intervals = unique(intervals);
    intervals(intervals==0) = [];
    UpRipples = subset(up_PFCx, intervals);

    %Down
    intv_down = [st_down end_down];
    [~,intervals,~] = InIntervals(Range(tRipples), intv_down);
    intervals = unique(intervals);
    intervals(intervals==0) = [];
    DownRipples = subset(down_PFCx, intervals);
    
    
    %% durations
    distrib_res.all.down.duration{p} = End(down_PFCx) - Start(down_PFCx); 
    distrib_res.all.up.duration{p}   = End(up_PFCx) - Start(up_PFCx);
    distrib_res.all.down.ripDur{p} = End(DownRipples) - Start(DownRipples); 
    distrib_res.all.up.ripDur{p}   = End(UpRipples) - Start(UpRipples);
    
    distrib_res.ripples.duration{p}   = End(RipplesEpoch) - Start(RipplesEpoch);
    
    
    
    %% duration start and end of night
    
    %start and end
    st_nrem = Start(NREM); end_nrem = End(NREM);
    night_start = st_nrem(1);
    night_end = end_nrem(end);
    firstEpoch = intervalSet(night_start, night_start+2*3600e4);
    lastEpoch = intervalSet(night_end-2*3600e4, night_end);
  
    %Down
    down_first = and(down_PFCx,firstEpoch);
    down_ripfirst = and(DownRipples,firstEpoch);
    down_last = and(down_PFCx,lastEpoch);
    down_riplast = and(DownRipples,lastEpoch);
    
    %Up
    up_first = and(up_PFCx,firstEpoch);
    up_ripfirst = and(UpRipples,firstEpoch);
    up_last = and(up_PFCx,lastEpoch);
    up_riplast = and(UpRipples,lastEpoch);
    
    %Ripples
    rip_first = and(RipplesEpoch,firstEpoch);
    rip_last = and(RipplesEpoch,lastEpoch);
    
    
    %durations
    distrib_res.first.down.duration{p} = End(down_first) - Start(down_first); 
    distrib_res.first.down.ripDur{p}   = End(down_ripfirst) - Start(down_ripfirst); 
    distrib_res.last.down.duration{p}  = End(down_last) - Start(down_last); 
    distrib_res.last.down.ripDur{p}    = End(down_riplast) - Start(down_riplast); 
    
    distrib_res.first.up.duration{p} = End(up_first) - Start(up_first); 
    distrib_res.first.up.ripDur{p}   = End(up_ripfirst) - Start(up_ripfirst); 
    distrib_res.last.up.duration{p}  = End(up_last) - Start(up_last); 
    distrib_res.last.up.ripDur{p}    = End(up_riplast) - Start(up_riplast);

    distrib_res.first.ripples.duration{p} = End(rip_first) - Start(rip_first); 
    distrib_res.last.ripples.duration{p}  = End(rip_last) - Start(rip_last); 
    
    
    %% quarters of night
    nbepoch = 5;
    dur_night = (night_end - night_start) / nbepoch;
    for i=1:nbepoch
        SubEpoch{i} = intervalSet(night_start + dur_night*(i-1), night_start + dur_night*i);
        
        durTotal = tot_length(SubEpoch{i});
        
        down_ep = and(down_PFCx,SubEpoch{i});
        down_eprip = and(DownRipples,SubEpoch{i});
        up_ep = and(up_PFCx,SubEpoch{i});
        up_eprip = and(UpRipples,SubEpoch{i});
        ripples_ep = and(RipplesEpoch,SubEpoch{i});
        
        distrib_res.epoch.down.duration{p,i} = End(down_ep) - Start(down_ep); 
        distrib_res.epoch.down.ripDur{p,i}   = End(down_eprip) - Start(down_eprip); 
        distrib_res.epoch.up.duration{p,i}   = End(up_ep) - Start(up_ep); 
        distrib_res.epoch.up.ripDur{p,i}     = End(up_eprip) - Start(up_eprip);
        
        distrib_res.epoch.ripples.duration{p,i} = End(ripples_ep) - Start(ripples_ep);
    
    end
    
    

        
end


%saving data
cd(FolderDeltaDataKJ)
save DistributionUpDownDurations.mat distrib_res


