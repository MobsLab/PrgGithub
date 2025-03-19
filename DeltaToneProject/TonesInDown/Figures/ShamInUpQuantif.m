%%ShamInUpQuantif
% 30.08.2019 KJ
%
% effect of tones/sham  in sham on transitions and up&down durations
%
%   see 
%       TonesInUpN2N3Effect
%


clear

Dir = PathForExperimentsRandomShamSpikes;
effect_periods = GetEffectPeriodDownTone(Dir);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p sham_res effect_periods
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    
   
    %params
    range_up = effect_periods(p,:);    
    minDurationUp = 0;
    maxDurationUp = 30e4;
    
    %MUA & Down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropShortIntervals(up_PFCx, minDurationUp);
    up_PFCx = dropLongIntervals(up_PFCx, maxDurationUp);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %tones
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    sham_res.nb_sham = length(SHAMtime);
    
    %substages
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %LFP Phase Sup
    load PhaseLFP/PhaseSham.mat PhaseShamDeep
    load PhaseLFP/PhaseFwSham.mat PhaseFwShamDeep
    
    
    %% Tones
    ShamUpNREM = Restrict(Restrict(SHAMtime, NREM), up_PFCx);
    shamup_tmp = Range(ShamUpNREM);
    sham_res.phasedeep{p} = Data(Restrict(Restrict(PhaseShamDeep, NREM), up_PFCx));
    sham_res.phasefwdeep{p} = Data(Restrict(Restrict(PhaseFwShamDeep, NREM), up_PFCx));
    
    
    %% Delay before and after

    nb_sham  = length(shamup_tmp);
    delay_before_up = nan(nb_sham, 1);
    delay_after_up  = nan(nb_sham, 1);
    for i=1:nb_sham
        idx_before = find(st_up < shamup_tmp(i),1,'last');
        delay_before_up(i) = shamup_tmp(i) - st_up(idx_before);
        
        idx_after = find(st_down > shamup_tmp(i), 1);
        delay_after_up(i) = st_down(idx_after) - shamup_tmp(i);
    end
    
    sham_res.delay_before{p} = delay_before_up;
    sham_res.delay_after{p}  = delay_after_up;
    
    
    %% Tones in Up Success
    
    induce_down = zeros(nb_sham, 1);
    [~,intervals,~] = InIntervals(st_down, [shamup_tmp+range_up(1), shamup_tmp+range_up(2)]);
    sham_success = unique(intervals);
    induce_down(sham_success(2:end)) = 1;  %do not consider the first nul element
    %save
    sham_res.induce_down{p} = induce_down;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save ShamInUpQuantif.mat sham_res



