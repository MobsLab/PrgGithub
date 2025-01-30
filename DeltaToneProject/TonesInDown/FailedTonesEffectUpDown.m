%%FailedTonesEffectUpDown
% 31.05.2018 KJ
%
% Assess the effect of a failed tones on the activity
%   -> Collect Data
%
% see
%   ProbabilityTonesUpDownTransition
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
    
    clearvars -except Dir p failed_res
    
    failed_res.path{p}   = Dir.path{p};
    failed_res.manipe{p} = Dir.manipe{p};
    failed_res.name{p}   = Dir.name{p};
    failed_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 2; %2ms
    minDuration = 40;
    maxDuration = 10e4;
    
    range_up = [0 100]*10;    % [0-100ms] after tone in Up
    
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
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); 
    up_PFCx = and(up_PFCx, NREM);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Tones in or out
    ToneUp      = Restrict(ToneEvent, up_PFCx);
    tonesup_tmp = Range(ToneUp);
    IntvToneUp  = intervalSet(tonesup_tmp+range_up(1),tonesup_tmp+range_up(2)); 
    
    
    %% Create Sham 
    
    %up
    nb_sham = 2000;
    idx = randsample(length(st_up), nb_sham);
    shamup_tmp = [];
    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        shamup_tmp = [shamup_tmp ; min_tmp+rand(1)*duree];
    end
    shamup_tmp = sort(shamup_tmp);
    
    %intervals post sham
    IntvShamUp   = intervalSet(shamup_tmp+range_up(1), shamup_tmp+range_up(2)); 
    
    
    %% Tones and transitions   

    %Tones in Up
    failed_res.tones.up.nb{p} = length(ToneUp);
    failed_res.tones.up.delay{p} = nan(length(tonesup_tmp), 1);
    failed_res.tones.up.success{p} = zeros(length(tonesup_tmp), 1);
    
    %delay
    for i=1:length(tonesup_tmp)
        idx_bef = find(st_up < tonesup_tmp(i), 1,'last');
        failed_res.tones.up.delay{p}(i) = tonesup_tmp(i) - st_up(idx_bef);    
    end

    %success
    intv = [Start(IntvToneUp) End(IntvToneUp)];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    failed_res.tones.up.success{p}(intervals) = 1;
    
    delay_tones = failed_res.tones.up.delay{p}(failed_res.tones.up.success{p}==0);
    tonesfail_tmp = tonesup_tmp(failed_res.tones.up.success{p}==0);

    
    %% Sham and transitions
    
    %Sham in Up
    failed_res.sham.up.nb{p} = length(shamup_tmp);
    failed_res.sham.up.delay{p} = nan(length(shamup_tmp), 1);
    failed_res.sham.up.success{p} = zeros(length(shamup_tmp), 1);
    
    %delay
    for i=1:length(shamup_tmp)
        idx_bef = find(st_up < shamup_tmp(i), 1,'last');
        failed_res.sham.up.delay{p}(i) = shamup_tmp(i) - st_up(idx_bef);    
    end

    %success
    intv = [Start(IntvShamUp) End(IntvShamUp)];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    failed_res.sham.up.success{p}(intervals) = 1;
    
    delay_sham = failed_res.sham.up.delay{p}(failed_res.sham.up.success{p}==0);
    shamfail_tmp = shamup_tmp(failed_res.sham.up.success{p}==0);
    
    
    %% Correlogram tones/sham failed vs transitions
    [Cc_tones, x_corr] = CrossCorr(tonesfail_tmp, st_down, binsize, nb_bins);
    failed_res.tones.corr.x{p} = x_corr;
    failed_res.tones.corr.y{p} = Cc_tones;
    failed_res.tones.corr.nb{p} = length(tonesfail_tmp);
    
    [Cc_tones, x_corr] = CrossCorr(shamfail_tmp, st_down, binsize, nb_bins);
    failed_res.sham.corr.x{p} = x_corr;
    failed_res.sham.corr.y{p} = Cc_tones;
    failed_res.sham.corr.nb{p} = length(shamfail_tmp);
    
    
    %% Mean curves of MUA after failed tones
    [failed_res.tones.mua{p},~] = PlotRipRaw(MUA, tonesfail_tmp/1e4, durations, 0, 0);
    [failed_res.sham.mua{p},~] = PlotRipRaw(MUA, shamfail_tmp/1e4, durations, 0, 0);
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save FailedTonesEffectUpDown.mat failed_res range_up binsize_mua minDuration maxDuration binsize nb_bins smoothing durations     


