% DeltaToneRefractoryPeriodAnalysis
% 11.07.2019 KJ
%
% Format data to analyse the delays and refractory period with random tones
% Here, the data are collected
%
%   see QuantifSuccessDeltaShamToneSubstage QuantifSuccessDeltaShamToneSubstage_bis
%       DeltaToneRefractoryPeriodAnalysisPlot
%

clear

Dir_sham = PathForExperimentsDeltaCloseLoop('basal'); 
Dir_rdm  = PathForExperimentsDeltaCloseLoop('RdmTone');

%params
effectperiod_sham = GetEffectPeriodDeltaTone(Dir_sham);
effectperiod_rdm  = GetEffectPeriodDeltaTone(Dir_rdm);

substage_ind  = 1:5;
NamesSubstages = {'N1','N2','N3','REM','Wake'};


%% Random TONE
for p=1:length(Dir_sham.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_sham.path{',num2str(p),'}'')'])
    disp(pwd)
    
    sham_res.path{p}     = Dir_sham.path{p};
    sham_res.manipe{p}   = Dir_sham.manipe{p};
    sham_res.delay{p}    = 0;
    sham_res.name{p}     = Dir_sham.name{p};
    sham_res.date{p}     = Dir_sham.date{p};

    %% Load
    %Delta waves
    delta_PFCx = GetDeltaWaves;
    start_deltas = Start(delta_PFCx);
    end_deltas = End(delta_PFCx);
    
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    NREM = or(N1,or(N2,N3));
    Substages = {N1,N2,N3,REM,Wake,NREM};

    %shams
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    SHAMtime = Restrict(SHAMtime, intervalSet(end_deltas(1)+10, max(Range(SHAMtime))+100)); % remove sham before the very first deltas
    nb_sham = length(SHAMtime);
    sham_tmp = Range(SHAMtime);
    sham_intv_post = intervalSet(sham_tmp+effectperiod_sham(p,1), sham_tmp+effectperiod_sham(p,2));  % Sham and its window where an effect could be observed
    
    %% Sham not in delta waves
    sham_in = zeros(1,length(sham_tmp));
    sham_in(ismember(sham_tmp, Range(Restrict(SHAMtime, delta_PFCx)))) = 1;
    
    %% DELAY 
    %delta
    delay_delta_sham = zeros(nb_sham, 1);
    for i=1:nb_sham
        idx_delta_before = find(start_deltas < sham_tmp(i), 1,'last');
        delay_delta_sham(i) = sham_tmp(i) - start_deltas(idx_delta_before);    
    end        


    %% INDUCE a delta waves ?
    induce_delta = zeros(nb_sham, 1);
    [~,interval,~] = InIntervals(start_deltas, [Start(sham_intv_post) End(sham_intv_post)]);
    tone_success = unique(interval);
    induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element


    %% SUBSTAGE
    substage_sham = nan(1,length(sham_tmp));
    for sub=substage_ind
        substage_sham(ismember(sham_tmp, Range(Restrict(SHAMtime, Substages{sub})))) = sub;
    end


    %% SAVE
    sham_res.sham_in{p}       = sham_in;
    sham_res.delay{p}         = delay_delta_sham;
    sham_res.induced{p}       = induce_delta;
    sham_res.substage_sham{p} = substage_sham;
    
end



%% Random TONE
for p=1:length(Dir_rdm.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_rdm.path{',num2str(p),'}'')'])
    disp(pwd)
    
    refract_res.path{p}     = Dir_rdm.path{p};
    refract_res.manipe{p}   = Dir_rdm.manipe{p};
    refract_res.delay{p}    = Dir_rdm.delay{p};
    refract_res.name{p}     = Dir_rdm.name{p};
    refract_res.date{p}     = Dir_rdm.date{p};

    %% Load
    %tones
    load('behavResources.mat', 'ToneEvent')
    nb_tones = length(ToneEvent);
    tones_tmp = Range(ToneEvent);
    tone_intv_post = intervalSet(tones_tmp+effectperiod_rdm(p,1), tones_tmp+effectperiod_rdm(p,2));  % Tone and its window where an effect could be observed
    %Delta waves
    delta_PFCx = GetDeltaWaves;
    start_deltas = Start(delta_PFCx);
    end_deltas = End(delta_PFCx);
    
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    NREM = or(N1,or(N2,N3));
    Substages = {N1,N2,N3,REM,Wake,NREM};

    
    %% Tones not in delta waves
    tones_in = zeros(1,length(tones_tmp));
    tones_in(ismember(tones_tmp, Range(Restrict(ToneEvent, delta_PFCx)))) = 1;
    
    %% DELAY 
    %delta
    delay_delta_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        idx_delta_before = find(start_deltas < tones_tmp(i), 1,'last');
        delay_delta_tone(i) = tones_tmp(i) - start_deltas(idx_delta_before);    
    end        


    %% INDUCE a delta waves ?
    induce_delta = zeros(nb_tones, 1);
    [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
    tone_success = unique(interval);
    induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element


    %% SUBSTAGE
    substage_tone = nan(1,length(tones_tmp));
    for sub=substage_ind
        substage_tone(ismember(tones_tmp, Range(Restrict(ToneEvent, Substages{sub})))) = sub;
    end


    %% SAVE
    refract_res.tones_in{p}      = tones_in;
    refract_res.delay{p}         = delay_delta_tone;
    refract_res.induced{p}       = induce_delta;
    refract_res.substage_tone{p} = substage_tone;
    
end


%saving data
cd(FolderDeltaDataKJ)
save DeltaToneRefractoryPeriodAnalysis.mat refract_res sham_res substage_ind NamesSubstages effectperiod_sham effectperiod_rdm

