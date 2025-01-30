%%ParcoursShamEffectPhaseLFP
% 30.07.2019 KJ
%
%   
%   
%
% see
%   ScriptTonesEffectPhaseLFP ParcoursTonesEffectPhaseLFP PhaseLFPEffectToneShamPlot
%

clear
Dir = PathForExperimentsRandomShamDelta;

delay_detections = GetDelayBetweenDeltaDown(Dir);
effect_periods = GetEffectPeriodEndDeltaTone(Dir);


%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p sham_res effect_periods
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    
    
    %params
    range_up = effect_periods(p,:);
    
    minduration = 75*10; %for deltas
    maxDuration = 30e4; %for up states

    
    %sleep stage
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [~, N2, N3] = GetSubstages;
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    sham_res.nb_sham{p} = length(SHAMtime);
        
    %LFP Phase Sup
    load PhaseLFP/PhaseSham.mat PhaseShamDeep PhaseShamSup
    if ~exist('PhaseShamSup','var')
        PhaseShamSup = [];
    end

    %Delta waves
    load('DeltaWaves.mat', 'deltamax_PFCx')
    deltamax_PFCx = dropShortIntervals(deltamax_PFCx,minduration);
    deltas_PFCx = CleanUpEpoch(and(deltamax_PFCx,NREM),1);
    st_deltas = Start(deltas_PFCx);
    end_deltas = End(deltas_PFCx);
    
    %Up
    up_PFCx = intervalSet(end_deltas(1:end-1), st_deltas(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Tones in and out - N2 & N3
    shamup_tmp = Range(Restrict(Restrict(PhaseShamDeep, NREM), up_PFCx));
    shamdelta_tmp = Range(Restrict(Restrict(PhaseShamDeep, NREM), deltas_PFCx));
    
    
    %% Phases
    sham_res.up.lfpphase.deep{p}    = Data(Restrict(Restrict(PhaseShamDeep, NREM), up_PFCx));
    sham_res.delta.lfpphase.deep{p} = Data(Restrict(Restrict(PhaseShamDeep, NREM), deltas_PFCx));
    
    if ~isempty(PhaseShamSup)
        sham_res.up.lfpphase.sup{p}    = Data(Restrict(Restrict(PhaseShamSup, NREM), up_PFCx));
        sham_res.delta.lfpphase.sup{p} = Data(Restrict(Restrict(PhaseShamSup, NREM), deltas_PFCx));
    end
    
    
    %% Tones delay before and after
    
    %Up
    nb_sham  = length(shamup_tmp);
    delay_before_up = nan(nb_sham, 1);
    delay_after_up  = nan(nb_sham, 1);
    for i=1:nb_sham
        idx_before = find(end_deltas < shamup_tmp(i),1,'last');
        delay_before_up(i) = shamup_tmp(i) - end_deltas(idx_before);
        
        idx_after = find(st_deltas > shamup_tmp(i), 1);
        delay_after_up(i) = st_deltas(idx_after) - shamup_tmp(i);
    end
    
    %Delta
    nb_sham  = length(shamdelta_tmp);
    delay_before_delta = nan(nb_sham, 1);
    delay_after_delta  = nan(nb_sham, 1);
    for i=1:nb_sham
        idx_before = find(st_deltas < shamdelta_tmp(i),1,'last');
        delay_before_delta(i) = shamdelta_tmp(i) - st_deltas(idx_before);
        
        idx_after = find(end_deltas > shamdelta_tmp(i), 1);
        delay_after_delta(i) = end_deltas(idx_after) - shamdelta_tmp(i);
    end
    
    
    %save
    sham_res.up.delay_before{p}    = delay_before_up;
    sham_res.up.delay_after{p}     = delay_after_up;
    sham_res.delta.delay_before{p} = delay_before_delta;
    sham_res.delta.delay_after{p}  = delay_after_delta;
    
    
    %% Tones in Up Success
    
    nb_sham = length(shamup_tmp);
    induce_delta = zeros(nb_sham, 1);
    [~,intervals,~] = InIntervals(st_deltas, [shamup_tmp+range_up(1), shamup_tmp+range_up(2)]);
    sham_success = unique(intervals);
    induce_delta(sham_success(2:end)) = 1;  %do not consider the first nul element
    %save
    sham_res.induce_delta{p} = induce_delta;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save ParcoursShamEffectPhaseLFP.mat sham_res  




