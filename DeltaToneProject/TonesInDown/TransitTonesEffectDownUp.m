%%TransitTonesEffectDownUp
% 05.06.2018 KJ
%
% Assess the effect of a failed tones on the activity
%   -> Collect Data
%
% see
%   FailedTonesEffectUpDown
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


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
    maxDuration = 10e4;
    
    range_down = [0 50]*10;    % [0-50ms] after tone in Down
    
    binsize = 10; %10ms
    nb_bins = 150;
    smoothing = 1;
    durations = 800;
    
    
    %% load
    
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);

    %substages
    load('SleepSubstages.mat')
    NREM = CleanUpEpoch(or(Epoch{1}, or(Epoch{2},Epoch{3})));
    
    %MUA
    [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    
    
    %% Tones in or out
    ToneIn      = Restrict(ToneEvent, down_PFCx);
    tonesdown_tmp = Range(ToneIn);
    IntvToneDown  = intervalSet(tonesdown_tmp+range_down(1),tonesdown_tmp+range_down(2)); 
    
    
    %% Create Sham 
    
    %down
    nb_sham = 2000;
    idx = randsample(length(st_down), nb_sham);
    shamdown_tmp = [];
    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree = end_down(idx(i))-st_down(idx(i));
        shamdown_tmp = [shamdown_tmp ; min_tmp+rand(1)*duree];
    end
    shamdown_tmp = sort(shamdown_tmp);
    
    %intervals post sham
    IntvShamDown   = intervalSet(shamdown_tmp+range_down(1), shamdown_tmp+range_down(2));
    
    
    %% Tones and transitions   

    %Tones in Up
    transit_res.tones.down.nb{p} = length(ToneIn);
    transit_res.tones.down.delay{p} = nan(length(tonesdown_tmp), 1);
    transit_res.tones.down.success{p} = zeros(length(tonesdown_tmp), 1);
    
    %delay
    for i=1:length(tonesdown_tmp)
        idx_bef = find(st_down < tonesdown_tmp(i), 1,'last');
        transit_res.tones.down.delay{p}(i) = tonesdown_tmp(i) - st_down(idx_bef);    
    end

    %success
    intv = [Start(IntvToneDown) End(IntvToneDown)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    transit_res.tones.down.success{p}(intervals) = 1;
    
    delay_tones = transit_res.tones.down.delay{p}(transit_res.tones.down.success{p}==1);
    tonessuccess_tmp = tonesdown_tmp(transit_res.tones.down.success{p}==1);

    
    %% Sham and transitions
    
    %Sham in Up
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
    
    delay_sham = transit_res.sham.down.delay{p}(transit_res.sham.down.success{p}==1);
    shamsuccess_tmp = shamdown_tmp(transit_res.sham.down.success{p}==1);
    
    
    %% Correlogram tones/sham success vs next down
    [Cc_tones, x_corr] = CrossCorr(tonessuccess_tmp, st_down, binsize, nb_bins);
    transit_res.tones.corr.x{p} = x_corr;
    transit_res.tones.corr.y{p} = Cc_tones;
    transit_res.tones.corr.nb{p} = length(tonessuccess_tmp);
    
    [Cc_tones, x_corr] = CrossCorr(shamsuccess_tmp, st_down, binsize, nb_bins);
    transit_res.sham.corr.x{p} = x_corr;
    transit_res.sham.corr.y{p} = Cc_tones;
    transit_res.sham.corr.nb{p} = length(shamsuccess_tmp);
    
    
    %% Mean curves of MUA after success tones
    [transit_res.tones.mua{p},~] = PlotRipRaw(MUA, tonessuccess_tmp/1e4, durations, 0, 0);
    [transit_res.sham.mua{p},~]  = PlotRipRaw(MUA, shamsuccess_tmp/1e4, durations, 0, 0);
    
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save TransitTonesEffectDownUp.mat transit_res range_down binsize_mua minDuration maxDuration binsize nb_bins smoothing durations     


