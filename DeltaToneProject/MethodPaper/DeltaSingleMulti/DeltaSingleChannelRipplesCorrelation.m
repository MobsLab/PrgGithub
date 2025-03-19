%%DeltaSingleChannelRipplesCorrelation
% 11.03.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   Look at their relations with ripples 
%
% see
%   DeltaSingleChannelAnalysis
%


% load
clear
load([FolderProjetDelta 'Data/DetectDeltaDepthSingleChannel.mat'])


for p=1:length(depth_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(depth_res.path{p})
    
    if exist(fullfile(depth_res.path{p}, 'Ripples.mat'),'file')~=2
        continue
    end
    
    clearvars -except correlo_res depth_res p
    
    correlo_res.path{p}   = depth_res.path{p};
    correlo_res.manipe{p} = depth_res.manipe{p};
    correlo_res.name{p}   = depth_res.name{p};
    correlo_res.peak_value{p} = depth_res.peak_value{p};
    %add -1 to channels (multi layer detection)
    try
        channels = [depth_res.channels{p} -1];
    catch
        channels = [depth_res.channels{p}' -1];
    end
    correlo_res.channels{p} = channels;
    
    
    %% init
    %params
    predown_window = 5000; %500ms
    postripples_window = 2000; %200
    binsize_cc = 100; %10ms
    nbins_cc = 100;
    
    %load
    load(fullfile(depth_res.path{p}, 'DownState.mat'), 'down_PFCx')    
    start_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    
    load(fullfile(depth_res.path{p}, 'Ripples.mat'), 'Ripples')
    ripples_tmp = Ripples(:,2) * 10; %in ts
    tRipples = ts(ripples_tmp);
    
    load(fullfile(depth_res.path{p}, 'DeltaWaves.mat'), 'deltas_PFCx')
        
    correlo_res.down.nb(p)    = length(start_down);
    correlo_res.ripples.nb(p) = length(ripples_tmp);
    
    
    %% Correction : down not preceeded by another down, in a time window
    predown_intervals = [start_down-predown_window start_down];
    [~,interval,~] = InIntervals(start_down,predown_intervals);
    interval(interval==0)=[];
    interval=unique(interval);
    start_down_alone = start_down(~ismember(1:length(start_down),interval));

    predown_intervals = [end_down-predown_window end_down];
    [~,interval,~] = InIntervals(end_down,predown_intervals);
    interval(interval==0)=[];
    interval=unique(interval);
    end_down_alone = end_down(~ismember(1:length(end_down),interval));
    
    
    correlo_res.down.rippled(p) = length(start_down) - length(start_down_alone);
    correlo_res.down.alone(p)  = length(start_down_alone);
    
    
    %% correlograms
    %down onset
    correlo_res.down.onset{p} = CrossCorr(ts(start_down), tRipples, binsize_cc, nbins_cc);        
    %down offset
    correlo_res.down.offset{p} = CrossCorr(ts(end_down), tRipples, binsize_cc, nbins_cc);
    %down onset
    correlo_res.down_alone.onset{p} = CrossCorr(ts(start_down_alone), tRipples, binsize_cc, nbins_cc);        
    %down offset
    correlo_res.down_alone.offset{p} = CrossCorr(ts(end_down_alone), tRipples, binsize_cc, nbins_cc);
    
    
    %% loop over channels
    for i=1:length(channels)
        if channels(i)~=-1
            DeltaEpoch = depth_res.deltas{p}{i};
            start_delta = Start(DeltaEpoch);
            end_delta = End(DeltaEpoch);
        else
            DeltaEpoch = deltas_PFCx;
            start_delta = Start(DeltaEpoch);
            end_delta = End(DeltaEpoch);
        end
        
        %% Correlogram
        %delta onset
        correlo_res.delta.onset{p,i} = CrossCorr(ts(start_delta), tRipples, binsize_cc, nbins_cc);        
        %delta offset
        correlo_res.delta.offset{p,i} = CrossCorr(ts(end_delta), tRipples, binsize_cc, nbins_cc);
        
        
        %% Number of delta waves preceded by a SPW-R
        postripples_intervals = [ripples_tmp ripples_tmp + postripples_window];
        [status,interval,~] = InIntervals(start_delta, postripples_intervals);
        nb_delta_ripped = sum(status);
        nb_delta_nonripped = sum(~status);
        
        correlo_res.delta.nb(p,i) = length(start_delta);
        correlo_res.delta.rippled(p,i) = nb_delta_ripped;
        correlo_res.delta.alone(p,i)  = nb_delta_nonripped;
        
    end
    

end

%saving data
load([FolderProjetDelta 'Data/DetectDeltaDepthSingleChannel.mat'])
cd([FolderProjetDelta 'Data/'])
save DeltaSingleChannelRipplesCorrelation.mat correlo_res predown_window binsize_cc nbins_cc freq_delta thresh_std min_duration_delta



