%%ProbabilityShamUpDownTransition
% 14.06.2018 KJ
%
% Assess the probability for a sham to create a transition up>down or down>up
%   -> Collect Data
%
% see
%   ProbabilityTonesUpDownTransition
%

clear

Dir = PathForExperimentsRandomShamSpikes;


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p transitsham_res
    
    transitsham_res.path{p}   = Dir.path{p};
    transitsham_res.manipe{p} = Dir.manipe{p};
    transitsham_res.name{p}   = Dir.name{p};
    transitsham_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 2; %2ms
    minDurationDown = 40;
    minDurationUp = 0.05e4;
    maxDurationUp = 30e4;
    
    range_down = [0 60]*10;   % [0-50ms] after tone in Down
    range_up = [30 110]*10;    % [0-100ms] after tone in Up
    
    
    %% load
    
    %tones
    load('ShamSleepEventRandom.mat', 'SHAMtime')

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
    

    %% Sham
    ShamDown = Restrict(SHAMtime, down_PFCx);
    shamdown_tmp = Range(ShamDown);
    IntvShamDown  = intervalSet(shamdown_tmp+range_down(1),shamdown_tmp+range_down(2));
    
    ShamUp = Restrict(SHAMtime, CleanUpEpoch(NREM-down_PFCx));
    shamup_tmp = Range(ShamUp);
    IntvShamUp  = intervalSet(shamup_tmp+range_up(1),shamup_tmp+range_up(2)); 
        
    
    %% Sham and transitions
    
    %Sham in Down
    transitsham_res.sham.down.nb{p} = length(shamdown_tmp);
    transitsham_res.sham.down.delay{p} = nan(length(shamdown_tmp), 1);
    transitsham_res.sham.down.success{p} = zeros(length(shamdown_tmp), 1);
    
    %delay
    for i=1:length(shamdown_tmp)
        try
            idx_bef = find(st_down < shamdown_tmp(i), 1,'last');
            transitsham_res.sham.down.delay{p}(i) = shamdown_tmp(i) - st_down(idx_bef);    
        end
    end

    %success
    intv = [Start(IntvShamDown) End(IntvShamDown)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    transitsham_res.sham.down.success{p}(intervals) = 1;
    

    %Sham in Up
    transitsham_res.sham.up.nb{p} = length(shamup_tmp);
    transitsham_res.sham.up.delay{p} = nan(length(shamup_tmp), 1);
    transitsham_res.sham.up.success{p} = zeros(length(shamup_tmp), 1);
    
    %delay
    for i=1:length(shamup_tmp)
        try
            idx_bef = find(st_up < shamup_tmp(i), 1,'last');
            transitsham_res.sham.up.delay{p}(i) = shamup_tmp(i) - st_up(idx_bef);    
        end
    end

    %success
    intv = [Start(IntvShamUp) End(IntvShamUp)];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    transitsham_res.sham.up.success{p}(intervals) = 1;
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save ProbabilityShamUpDownTransition.mat transitsham_res range_down range_up



