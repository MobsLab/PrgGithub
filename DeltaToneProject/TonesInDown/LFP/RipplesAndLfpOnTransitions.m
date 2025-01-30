%%RipplesAndLfpOnTransitions
% 03.10.2018 KJ
%
%
%
%
% see
%   ScriptTonesOnDeltaWavesEffect RipplesInDownN2N3Effect
%


clear

Dir=PathForExperimentsBasalSleepSpike;
Dir=RestrictPathForExperiment(Dir, 'nMice', [243,244,403,451]);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripples_res
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};
    
    
    
    %% init
    
    %params
    binsize_met = 5;
    nbBins_met  = 300;
    range_down = [0 30]*10;   % [0-30ms] after tone in Down
    range_up = [30 100]*10;    % [30-100ms] after tone in Up
    binsize_mua = 2;

    minDuration = 40;
    maxDuration = 30e4;

    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    ripples_res.nb_down{p} = length(st_down);
    
    %ripples    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;
    RipplesEvent = ts(ripples_tmp);
    

    %% LFP PFCx
    
    %LFP
    load('ChannelsToAnalyse/PFCx_clusters.mat')
    ripples_res.clusters{p} = clusters;
    
    load('ChannelsToAnalyse/PFCx_locations.mat')

    PFC = cell(0);
    for ch=1:length(channels)
        load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
        PFC{ch} = LFP;
        clear LFP
    end

    
    
    %% Ripples in down
    RipplesDown = Restrict(RipplesEvent, down_PFCx);
    IntvTransitDown  = intervalSet(Range(RipplesDown)+range_down(1), Range(RipplesDown)+range_down(2));

    %transition ?
    intv = [Start(IntvTransitDown) End(IntvTransitDown)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];

    success_idx = unique(intervals);
    failed_idx = setdiff(1:length(RipplesDown), success_idx);

    %class of ripples
    ripples_down = Range(RipplesDown);
    success_down = ripples_down(success_idx);
    failed_down = ripples_down(failed_idx);
    
    
    ripples_res.down.nb_ripples{p} = length(RipplesDown);
    ripples_res.down.nb_transit{p} = length(success_down);
    
    %% Ripples in up
    RipplesUp = Restrict(RipplesEvent, up_PFCx);
    IntvTransitUp = intervalSet(Range(RipplesUp)+range_up(1), Range(RipplesUp)+range_up(2));

    %transition ?
    intv = [Start(IntvTransitUp) End(IntvTransitUp)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];

    success_idx = unique(intervals);
    failed_idx = setdiff(1:length(RipplesUp), success_idx);

    %class of ripples
    ripples_up = Range(RipplesUp);
    success_up = ripples_up(success_idx);
    failed_up = ripples_up(failed_idx);
    
    ripples_res.up.nb_ripples{p} = length(RipplesUp);
    ripples_res.up.nb_transit{p} = length(success_up);
    
    
    %% mean curves on ripples, LFP of PFCx

    %Success
    for ch=1:length(PFC)
        %down
        [m,~,tps] = mETAverage(success_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        ripples_res.down.up{p}{ch}(:,1) = tps; ripples_res.down.up{p}{ch}(:,2) = m; 
        %up
        [m,~,tps] = mETAverage(success_up, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        ripples_res.up.down{p}{ch}(:,1) = tps; ripples_res.up.down{p}{ch}(:,2) = m;
    end

    %Failed
    for ch=1:length(PFC)
        %down
        [m,~,tps] = mETAverage(failed_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        ripples_res.down.down{p}{ch}(:,1) = tps; ripples_res.down.down{p}{ch}(:,2) = m; 
        %up
        [m,~,tps] = mETAverage(failed_up, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        ripples_res.up.up{p}{ch}(:,1) = tps; ripples_res.up.up{p}{ch}(:,2) = m; 
    end
    
    
    %% mean curves on down, states, LFP of PFCx

    %Success
    for ch=1:length(PFC)
        %down
        [m,~,tps] = mETAverage(st_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        ripples_res.st_down{p}{ch}(:,1) = tps; ripples_res.st_down{p}{ch}(:,2) = m; 
        %up
        [m,~,tps] = mETAverage(end_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        ripples_res.end_down{p}{ch}(:,1) = tps; ripples_res.end_down{p}{ch}(:,2) = m;
    end
    
   
end


%saving data
cd(FolderDeltaDataKJ)
save RipplesAndLfpOnTransitions.mat ripples_res binsize_met nbBins_met binsize_mua minDuration maxDuration range_down range_up


