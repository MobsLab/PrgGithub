%%ProbabilityRipplesUpDownTransition
% 31.05.2018 KJ
%
% Assess the probability for a ripples to create a transition up>down or down>up
%   -> Collect Data
%
% see
%   ProbabilityTonesUpDownTransition QuantifDelayRipplesStartEndDown
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
    
    clearvars -except Dir p transit_res
    
    transit_res.path{p}   = Dir.path{p};
    transit_res.manipe{p} = Dir.manipe{p};
    transit_res.name{p}   = Dir.name{p};
    transit_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 2; %2ms
    minDuration = 40;
    maxDuration = 5e4;
    
    range_down = [0 30]*10;   % [0-30ms] after tone in Down
    range_up = [30 80]*10;    % [30-80ms] after tone in Up
    
    
    %% load
    
    %ripples    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;
    RipplesEvent = ts(ripples_tmp);

    %substages
    load('SleepSubstages.mat')
    NREM = CleanUpEpoch(or(Epoch{1}, or(Epoch{2},Epoch{3})));
    
    
    %MUA
    [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); 
    up_PFCx = and(up_PFCx, NREM);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Ripples in or out
    RipplesDown      = Restrict(RipplesEvent, down_PFCx);
    ripplesdown_tmp = Range(RipplesDown);
    IntvRippleDown  = intervalSet(ripplesdown_tmp+range_down(1),ripplesdown_tmp+range_down(2));
    
    RipplesUp      = Restrict(RipplesEvent, up_PFCx);
    ripplesup_tmp = Range(RipplesUp);
    IntvRippleUp  = intervalSet(ripplesup_tmp+range_up(1),ripplesup_tmp+range_up(2)); 
    
    
    %% Create Sham 
    
    %down
    nb_sham = 3000;
    idx = randsample(length(st_down), nb_sham);
    shamdown_tmp = [];
    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree = end_down(idx(i))-st_down(idx(i));
        shamdown_tmp = [shamdown_tmp min_tmp+rand(1)*duree];
    end
    shamdown_tmp = sort(shamdown_tmp);
    
    %up
    nb_sham = 3000;
    idx = randsample(length(st_up), nb_sham);
    shamup_tmp = [];
    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        shamup_tmp = [shamup_tmp min_tmp+rand(1)*duree];
    end
    shamup_tmp = sort(shamup_tmp);
    
    %intervals post sham
    IntvShamDown = intervalSet(shamdown_tmp+range_down(1), shamdown_tmp+range_down(2));
    IntvShamUp   = intervalSet(shamup_tmp+range_up(1), shamup_tmp+range_up(2)); 
    
    
    %% Ripples and transitions
    
    %Ripples in Down
    transit_res.ripples.down.nb{p} = length(RipplesDown);
    transit_res.ripples.down.delay{p} = nan(length(ripplesdown_tmp), 1);
    transit_res.ripples.down.success{p} = zeros(length(ripplesdown_tmp), 1);
    
    %delay
    for i=1:length(ripplesdown_tmp)
        idx_bef = find(st_down < ripplesdown_tmp(i), 1,'last');
        transit_res.ripples.down.delay{p}(i) = ripplesdown_tmp(i) - st_down(idx_bef);    
    end

    %success
    intv = [Start(IntvRippleDown) End(IntvRippleDown)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    transit_res.ripples.down.success{p}(intervals) = 1;
    

    %Ripples in Up
    transit_res.ripples.up.nb{p} = length(RipplesUp);
    transit_res.ripples.up.delay{p} = nan(length(ripplesup_tmp), 1);
    transit_res.ripples.up.success{p} = zeros(length(ripplesup_tmp), 1);
    
    %delay
    for i=1:length(ripplesup_tmp)
        idx_bef = find(st_up < ripplesup_tmp(i), 1,'last');
        transit_res.ripples.up.delay{p}(i) = ripplesup_tmp(i) - st_up(idx_bef);    
    end

    %success
    intv = [Start(IntvRippleUp) End(IntvRippleUp)];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    transit_res.ripples.up.success{p}(intervals) = 1;

    
    
    %% Sham and transitions
    
    %Sham in Down
    transit_res.sham.down.nb{p} = length(shamdown_tmp);
    transit_res.sham.down.delay{p} = nan(length(shamdown_tmp), 1);
    transit_res.sham.down.success{p} = zeros(length(shamdown_tmp), 1);
    
    %delay
    for i=1:length(shamdown_tmp)
        idx_bef = find(st_down < shamdown_tmp(i), 1,'last');
        transit_res.sham.down.delay{p}(i) = shamdown_tmp(i) - st_down(idx_bef);    
    end

    %success
    intv = [Start(IntvShamDown) End(IntvShamDown)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    transit_res.sham.down.success{p}(intervals) = 1;
    

    %Sham in Up
    transit_res.sham.up.nb{p} = length(shamup_tmp);
    transit_res.sham.up.delay{p} = nan(length(shamup_tmp), 1);
    transit_res.sham.up.success{p} = zeros(length(shamup_tmp), 1);
    
    %delay
    for i=1:length(shamup_tmp)
        idx_bef = find(st_up < shamup_tmp(i), 1,'last');
        transit_res.sham.up.delay{p}(i) = shamup_tmp(i) - st_up(idx_bef);    
    end

    %success
    intv = [Start(IntvShamUp) End(IntvShamUp)];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    transit_res.sham.up.success{p}(intervals) = 1;
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save ProbabilityRipplesUpDownTransition.mat transit_res range_down range_up



