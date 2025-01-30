%%ProbabilityTonesUpDownTransition
% 24.05.2018 KJ
%
% Assess the probability for a tones/sham to create a transition up>down or down>up
%   -> Collect Data
%
% see
%   QuantifDelayTonesStartEndDown ProbabilityRipplesUpDownTransition ProbabilityShamUpDownTransition
%


clear


Dir = PathForExperimentsRandomTonesSpikes;


%get data for each record
for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p transit_res
    
    transit_res.path{p}   = Dir.path{p};
    transit_res.manipe{p} = Dir.manipe{p};
    transit_res.name{p}   = Dir.name{p};
    transit_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 2; %2ms
    minDurationDown = 40;
    minDurationUp = 0.05e4;
    maxDurationUp = 30e4;
    
    range_down = [0 60]*10;   % [0-50ms] after tone in Down
    range_up = [30 110]*10;    % [0-100ms] after tone in Up
    
    
    %% load
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_tmp = Range(ToneEvent);

    %substages
    load('SleepSubstages.mat')
    NREM = CleanUpEpoch(or(Epoch{1}, or(Epoch{2},Epoch{3})));
    
    %MUA
    [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDurationUp); %sec
    up_PFCx = dropShortIntervals(up_PFCx, minDurationUp); %sec
    up_PFCx = and(up_PFCx, NREM);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Tones in or out
    ToneDown      = Restrict(ToneEvent, down_PFCx);
    tonesdown_tmp = Range(ToneDown);
    IntvToneDown  = intervalSet(tonesdown_tmp+range_down(1),tonesdown_tmp+range_down(2));
    
    ToneUp      = Restrict(ToneEvent, up_PFCx);
    tonesup_tmp = Range(ToneUp);
    IntvToneUp  = intervalSet(tonesup_tmp+range_up(1),tonesup_tmp+range_up(2)); 
    
    
%     %% Create Sham 
%     
%     %down
%     nb_sham = 1000;
%     idx = randsample(length(st_down), nb_sham);
%     shamdown_tmp = [];
%     for i=1:length(idx)
%         min_tmp = st_down(idx(i));
%         duree = end_down(idx(i))-st_down(idx(i));
%         shamdown_tmp = [shamdown_tmp min_tmp+rand(1)*duree];
%     end
%     shamdown_tmp = sort(shamdown_tmp);
%     
%     %up
%     nb_sham = 2000;
%     idx = randsample(length(st_up), nb_sham);
%     shamup_tmp = [];
%     for i=1:length(idx)
%         min_tmp = st_up(idx(i));
%         duree = end_up(idx(i))-st_up(idx(i));
%         shamup_tmp = [shamup_tmp min_tmp+rand(1)*duree];
%     end
%     shamup_tmp = sort(shamup_tmp);
%     
%     %intervals post sham
%     IntvShamDown = intervalSet(shamdown_tmp+range_down(1), shamdown_tmp+range_down(2));
%     IntvShamUp   = intervalSet(shamup_tmp+range_up(1), shamup_tmp+range_up(2)); 
    
    
    %% Tones and transitions
    
    %Tones in Down
    transit_res.tones.down.nb{p} = length(ToneDown);
    transit_res.tones.down.delay{p} = nan(length(tonesdown_tmp), 1);
    transit_res.tones.down.success{p} = zeros(length(tonesdown_tmp), 1);
    
    %delay
    for i=1:length(tonesdown_tmp)
        try
            idx_bef = find(st_down < tonesdown_tmp(i), 1,'last');
            transit_res.tones.down.delay{p}(i) = tonesdown_tmp(i) - st_down(idx_bef);    
        end
    end

    %success
    intv = [Start(IntvToneDown) End(IntvToneDown)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    transit_res.tones.down.success{p}(intervals) = 1;
    

    %Tones in Up
    transit_res.tones.up.nb{p} = length(ToneUp);
    transit_res.tones.up.delay{p} = nan(length(tonesup_tmp), 1);
    transit_res.tones.up.success{p} = zeros(length(tonesup_tmp), 1);
    
    %delay
    for i=1:length(tonesup_tmp)
        try
            idx_bef = find(st_up < tonesup_tmp(i), 1,'last');
            transit_res.tones.up.delay{p}(i) = tonesup_tmp(i) - st_up(idx_bef);    
        end
    end

    %success
    intv = [Start(IntvToneUp) End(IntvToneUp)];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    transit_res.tones.up.success{p}(intervals) = 1;
    

%     %% Sham and transitions
%     
%     %Sham in Down
%     transit_res.sham.down.nb{p} = length(shamdown_tmp);
%     transit_res.sham.down.delay{p} = nan(length(shamdown_tmp), 1);
%     transit_res.sham.down.success{p} = zeros(length(shamdown_tmp), 1);
%     
%     %delay
%     for i=1:length(shamdown_tmp)
%         try
%             idx_bef = find(st_down < shamdown_tmp(i), 1,'last');
%             transit_res.sham.down.delay{p}(i) = shamdown_tmp(i) - st_down(idx_bef);    
%         end
%     end
% 
%     %success
%     intv = [Start(IntvShamDown) End(IntvShamDown)];
%     [~,intervals,~] = InIntervals(end_down, intv);
%     intervals(intervals==0)=[];
%     intervals = unique(intervals);
%     transit_res.sham.down.success{p}(intervals) = 1;
%     
% 
%     %Sham in Up
%     transit_res.sham.up.nb{p} = length(shamup_tmp);
%     transit_res.sham.up.delay{p} = nan(length(shamup_tmp), 1);
%     transit_res.sham.up.success{p} = zeros(length(shamup_tmp), 1);
%     
%     %delay
%     for i=1:length(shamup_tmp)
%         try
%             idx_bef = find(st_up < shamup_tmp(i), 1,'last');
%             transit_res.sham.up.delay{p}(i) = shamup_tmp(i) - st_up(idx_bef);    
%         end
%     end
% 
%     %success
%     intv = [Start(IntvShamUp) End(IntvShamUp)];
%     [~,intervals,~] = InIntervals(st_down, intv);
%     intervals(intervals==0)=[];
%     intervals = unique(intervals);
%     transit_res.sham.up.success{p}(intervals) = 1;
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save ProbabilityTonesUpDownTransition.mat transit_res range_down range_up



