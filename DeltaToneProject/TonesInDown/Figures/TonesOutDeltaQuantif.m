%%TonesOutDeltaQuantif
% 30.08.2019 KJ
%
% effect of tones/sham  in sham on transitions and up&down durations
%
%   see 
%       TonesInUpN2N3Effect
%


clear

Dir = PathForExperimentsRandomTonesDelta;
effect_periods = GetEffectPeriodDeltaTone(Dir);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tones_res effect_periods
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};
    
   
    %params
    range_up = effect_periods(p,:); 
    minDurationUp = 0;
    maxDurationUp = 30e4;
    
    %MUA & Down
    load('DeltaWaves.mat', 'deltas_PFCx')
    st_deltas = Start(deltas_PFCx);
    end_deltas = End(deltas_PFCx);
    %Up
    up_PFCx = intervalSet(end_deltas(1:end-1), st_deltas(2:end));
    up_PFCx = dropShortIntervals(up_PFCx, minDurationUp);
    up_PFCx = dropLongIntervals(up_PFCx, maxDurationUp);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_res.nb_tones = length(ToneEvent);
    
    %substages
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %LFP Phase Sup
    load PhaseLFP/PhaseTones.mat PhaseToneDeep
    
    
    %% Tones
    ToneUpNREM = Restrict(Restrict(ToneEvent, NREM), up_PFCx);
    tonesup_tmp = Range(ToneUpNREM);
    tones_res.phasedeep{p} = Data(Restrict(Restrict(PhaseToneDeep, NREM), up_PFCx));
    
    
    %% Delay before and after

    nb_tones  = length(tonesup_tmp);
    delay_before_up = nan(nb_tones, 1);
    delay_after_up  = nan(nb_tones, 1);
    for i=1:nb_tones
        idx_before = find(st_up < tonesup_tmp(i),1,'last');
        delay_before_up(i) = tonesup_tmp(i) - st_up(idx_before);
        
        idx_after = find(st_deltas > tonesup_tmp(i), 1);
        delay_after_up(i) = st_deltas(idx_after) - tonesup_tmp(i);
    end
    
    tones_res.delay_before{p} = delay_before_up;
    tones_res.delay_after{p}  = delay_after_up;
    
    
    %% Tones in Up Success
    
    induce_delta = zeros(nb_tones, 1);
    [~,intervals,~] = InIntervals(st_deltas, [tonesup_tmp+range_up(1), tonesup_tmp+range_up(2)]);
    tone_success = unique(intervals);
    induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
    %save
    tones_res.induce_delta{p} = induce_delta;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save TonesOutDeltaQuantif.mat tones_res



