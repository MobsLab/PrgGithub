%%QuantifDelayShamStartEndDown
% 14.06.2018 KJ
%
%   Delay between sham and next transitions
%
% see
%   QuantifDelayTonesStartEndDown
%


clear

Dir = PathForExperimentsRandomShamSpikes;

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p delaysham_res
    
    delaysham_res.path{p}   = Dir.path{p};
    delaysham_res.manipe{p} = Dir.manipe{p};
    delaysham_res.name{p}   = Dir.name{p};
    delaysham_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 2; %2ms
    minDurationDown = 40;
    minDurationUp = 0.05e4;
    maxDurationUp = 30e4;
    
    %substages
    load('SleepSubstages.mat')
    NREM = CleanUpEpoch(or(Epoch{1},or(Epoch{2},Epoch{3})));
    
    
    %% MUA
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
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    
    ShamDown = Restrict(SHAMtime, down_PFCx);
    shamdown_tmp = Range(ShamDown);
    ShamUp = Restrict(SHAMtime, up_PFCx);
    shamup_tmp = Range(ShamUp);
    
    
    %% Sham and delay    

    %sham in
    delay_shamdown = zeros(length(shamdown_tmp), 1);
    for i=1:length(shamdown_tmp)
        idx = find(end_down > shamdown_tmp(i), 1);
        delay_shamdown(i) = end_down(idx) - shamdown_tmp(i);
    end
    delaysham_res.sham.inside{p} = delay_shamdown;
    
    %sham out
    delay_shamup = zeros(length(shamup_tmp), 1);
    for i=1:length(shamup_tmp)
        idx = find(st_down > shamup_tmp(i), 1);
        delay_shamup(i) = st_down(idx) - shamup_tmp(i);
    end
    delaysham_res.sham.outside{p} = delay_shamup;
    
end


%saving data
cd(FolderDeltaDataKJ)
save QuantifDelayShamStartEndDown.mat delaysham_res binsize_mua minDurationDown


