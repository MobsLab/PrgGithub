%%ParcoursTonesEffectPhaseLFP
% 30.07.2019 KJ
%
%   
%   
%
% see
%   ScriptTonesEffectPhaseLFP  ParcoursShamEffectPhaseLFP PhaseLFPEffectToneShamPlot
%

clear
Dir = PathForExperimentsRandomTonesDelta;

delay_detections = GetDelayBetweenDeltaDown(Dir);
effect_periods = GetEffectPeriodEndDeltaTone(Dir);


%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p tones_res effect_periods
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};
    
    
    %params
    range_up = effect_periods(p,:);
    
    minduration = 75*10; %for deltas
    maxDuration = 30e4; %for up states

    
    %sleep stage
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [~, N2, N3] = GetSubstages;
        
    %channels
    load('ChannelsToAnalyse/PFCx_clusters.mat','channels','clusters')
    tones_res.channels{p} = channels;
    tones_res.clusters{p} = clusters;
    %LFP Phase Sup
    load PhaseLFP/PhaseTones.mat PhaseToneDeep PhaseToneSup
    if ~exist('PhaseToneSup','var')
        PhaseToneSup = [];
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
    tonesup_tmp = Range(Restrict(Restrict(PhaseToneDeep, NREM), up_PFCx));
    tonesdelta_tmp = Range(Restrict(Restrict(PhaseToneDeep, NREM), deltas_PFCx));
    
    
    %% Phases
    tones_res.up.lfpphase.deep{p}    = Data(Restrict(Restrict(PhaseToneDeep, NREM), up_PFCx));
    tones_res.delta.lfpphase.deep{p} = Data(Restrict(Restrict(PhaseToneDeep, NREM), deltas_PFCx));
    
    if ~isempty(PhaseToneSup)
        tones_res.up.lfpphase.sup{p}    = Data(Restrict(Restrict(PhaseToneSup, NREM), up_PFCx));
        tones_res.delta.lfpphase.sup{p} = Data(Restrict(Restrict(PhaseToneSup, NREM), deltas_PFCx));
    end
    
    
    %% Tones delay before and after
    
    %Up
    nb_tones  = length(tonesup_tmp);
    delay_before_up = nan(nb_tones, 1);
    delay_after_up  = nan(nb_tones, 1);
    for i=1:nb_tones
        idx_before = find(end_deltas < tonesup_tmp(i),1,'last');
        delay_before_up(i) = tonesup_tmp(i) - end_deltas(idx_before);
        
        idx_after = find(st_deltas > tonesup_tmp(i), 1);
        delay_after_up(i) = st_deltas(idx_after) - tonesup_tmp(i);
    end
    
    %Delta
    nb_tones  = length(tonesdelta_tmp);
    delay_before_delta = nan(nb_tones, 1);
    delay_after_delta  = nan(nb_tones, 1);
    for i=1:nb_tones
        idx_before = find(st_deltas < tonesdelta_tmp(i),1,'last');
        delay_before_delta(i) = tonesdelta_tmp(i) - st_deltas(idx_before);
        
        idx_after = find(end_deltas > tonesdelta_tmp(i), 1);
        delay_after_delta(i) = end_deltas(idx_after) - tonesdelta_tmp(i);
    end
    
    
    %save
    tones_res.up.delay_before{p}    = delay_before_up;
    tones_res.up.delay_after{p}     = delay_after_up;
    tones_res.delta.delay_before{p} = delay_before_delta;
    tones_res.delta.delay_after{p}  = delay_after_delta;
    
    
    %% Tones in Up Success
    
    nb_tones = length(tonesup_tmp);
    induce_delta = zeros(nb_tones, 1);
    [~,intervals,~] = InIntervals(st_deltas, [tonesup_tmp+range_up(1), tonesup_tmp+range_up(2)]);
    tone_success = unique(intervals);
    induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
    %save
    tones_res.induce_delta{p} = induce_delta;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save ParcoursTonesEffectPhaseLFP.mat tones_res  









