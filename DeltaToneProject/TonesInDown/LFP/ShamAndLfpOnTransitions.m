%%ShamAndLfpOnTransitions
% 21.12.2018 KJ
%
%
%
% see
%   ScriptTonesOnDeltaWavesEffect TonesAndLfpOnTransitions
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

Dir=PathForExperimentsDeltaSleepSpikes('RdmTone');



%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tones_res
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};
    
    
    
    %% init
    
    %params
    binsize_met = 2;
    nbBins_met  = 600;
    range_down = [0 50]*10;   % [0-50ms] after tone in Down
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
    
    tones_res.nb_down{p} = length(st_down);
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_res.nb_tones{p} = length(ToneEvent);
    

    %% LFP PFCx
    
    %LFP
    load('ChannelsToAnalyse/PFCx_clusters.mat')
    tones_res.clusters{p} = clusters;
    
    load('ChannelsToAnalyse/PFCx_locations.mat')

    PFC = cell(0);
    for ch=1:length(channels)
        load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
        PFC{ch} = LFP;
        clear LFP
    end

    
    
    %% Tones in down
    ToneDown = Restrict(ToneEvent, down_PFCx);
    IntvTransitDown  = intervalSet(Range(ToneDown)+range_down(1), Range(ToneDown)+range_down(2));

    %transition ?
    intv = [Start(IntvTransitDown) End(IntvTransitDown)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];

    success_idx = unique(intervals);
    failed_idx = setdiff(1:length(ToneDown), success_idx);

    %class of tones
    tones_down = Range(ToneDown);
    success_down = tones_down(success_idx);
    failed_down = tones_down(failed_idx);
    
    
    tones_res.down.nb_tones{p} = length(ToneDown);
    tones_res.down.nb_transit{p} = length(success_down);
    
    %% Tones in up
    ToneUp = Restrict(ToneEvent, up_PFCx);
    IntvTransitUp = intervalSet(Range(ToneUp)+range_up(1), Range(ToneUp)+range_up(2));

    %transition ?
    intv = [Start(IntvTransitUp) End(IntvTransitUp)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];

    success_idx = unique(intervals);
    failed_idx = setdiff(1:length(ToneUp), success_idx);

    %class of tones
    tones_up = Range(ToneUp);
    success_up = tones_up(success_idx);
    failed_up = tones_up(failed_idx);
    
    tones_res.up.nb_tones{p} = length(ToneUp);
    tones_res.up.nb_transit{p} = length(success_up);
    
    
    %% mean curves on tones, LFP of PFCx

    %Success
    for ch=1:length(PFC)
        %down
        [m,~,tps] = mETAverage(success_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        tones_res.down.up{p}{ch}(:,1) = tps; tones_res.down.up{p}{ch}(:,2) = m; 
        %up
        [m,~,tps] = mETAverage(success_up, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        tones_res.up.down{p}{ch}(:,1) = tps; tones_res.up.down{p}{ch}(:,2) = m;
    end

    %Failed
    for ch=1:length(PFC)
        %down
        [m,~,tps] = mETAverage(failed_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        tones_res.down.down{p}{ch}(:,1) = tps; tones_res.down.down{p}{ch}(:,2) = m; 
        %up
        [m,~,tps] = mETAverage(failed_up, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        tones_res.up.up{p}{ch}(:,1) = tps; tones_res.up.up{p}{ch}(:,2) = m; 
    end
    
    
    %% mean curves on down, states, LFP of PFCx

    %Success
    for ch=1:length(PFC)
        %down
        [m,~,tps] = mETAverage(st_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        tones_res.st_down{p}{ch}(:,1) = tps; tones_res.st_down{p}{ch}(:,2) = m; 
        %up
        [m,~,tps] = mETAverage(end_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        tones_res.end_down{p}{ch}(:,1) = tps; tones_res.end_down{p}{ch}(:,2) = m;
    end
    
   
end


%saving data
cd(FolderDeltaDataKJ)
save TonesAndLfpOnTransitions.mat tones_res binsize_met nbBins_met binsize_mua minDuration maxDuration range_down range_up


