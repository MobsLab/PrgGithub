% QuantifClinicISI
% 18.01.2017 KJ
%
% collect data for the quantification of Inter Slow-wave Intervals for different sleep stages
%   - Sleep stages = N1, N2, N3, REM, WAKE
%   - use virtual channel
%
% Here, the data are collected
%
%   see QuantifClinicISIPlot QuantifClinicISI_bis QuantifClinicISI
%       QuantifClinicISI_first


%Dir
Dir_basal = ListOfClinicalTrialDreemAnalyse('Sham');

Dir1 = ListOfClinicalTrialDreemAnalyse('Sham');
Dir2 = ListOfClinicalTrialDreemAnalyse('Random');
Dir3 = ListOfClinicalTrialDreemAnalyse('UpPhase');
Dir = FusionListOfClinicalTrial(Dir1,Dir2);
Dir_tone = FusionListOfClinicalTrial(Dir,Dir3);


clearvars -except Dir

%params
common_data=GetClinicCommonData();

sleepstage_ind = 1:5; %N1, N2, N3, REM, WAKE
lim_between_stim = common_data.lim_between_stim;  %1.6sec maximum between two stim of the same train
effect_period = common_data.effect_period; %800ms
pre_period = common_data.pre_period; %800ms


%% BASAL: NO TONE
for p=1:length(Dir_basal.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir_basal.filename{p})
    basal_res.filename{p} = Dir_basal.filename{p};
    basal_res.condition{p} = Dir_basal.condition{p};
    basal_res.subject{p} = Dir_basal.subject{p};
    basal_res.date{p} = Dir_basal.date{p};
    basal_res.night{p} = Dir_basal.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain, ~] = GetRecordClinic(Dir_basal.filename{p});
    % infos.name_channel = {'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'};
    % domain = {'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'};
    % Sleep stages: 1:N1 , 2:N2 , 3:N3 , 4:REM , 5:Wake
    StageEpochs{6} = or(StageEpochs{2},StageEpochs{3}); %6: N2+N3

    % VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir_basal.filereference{p});
    [signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;
    
    %% Slow Waves measures
    SlowWaveEpochs = FindSlowWaves(signals_dreem_vc);
    SlowWaveEpochs = intersect(SlowWaveEpochs, goodEpochs);
    start_slowwaves = ts(Start(SlowWaveEpochs));    
    slowwaves_tmp = Range(start_slowwaves);
    
    
    %% ISI
    for sstage=sleepstage_ind
        slowwave_substage = Range(Restrict(start_slowwaves, StageEpochs{sstage}));
        %slow waves
        for t=1:length(slowwave_substage)
            for i=1:3
                next_slowwave = slowwaves_tmp(find(slowwaves_tmp>slowwave_substage(t), 3));
                try
                    isi_basal_slowwave_stage{i}(t) = next_slowwave(i) - slowwave_substage(t);
                catch
                    isi_basal_slowwave_stage{i}(t) = nan;
                end
            end
            
        end
        basal_res.isi_slowwave_stage{p,sstage} = isi_basal_slowwave_stage;
    end
    
    
end


%% TONE CONDITION
for p=1:length(Dir_tone.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir_tone.filename{p})
    tone_res.filename{p} = Dir_tone.filename{p};
    tone_res.condition{p} = Dir_tone.condition{p};
    tone_res.subject{p} = Dir_tone.subject{p};
    tone_res.date{p} = Dir_tone.date{p};
    tone_res.night{p} = Dir_tone.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain, ~] = GetRecordClinic(Dir_tone.filename{p});
    % infos.name_channel = {'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'};
    % domain = {'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'};
    % Sleep stages: 1:N1 , 2:N2 , 3:N3 , 4:REM , 5:Wake
    StageEpochs{6} = or(StageEpochs{2},StageEpochs{3}); %6: N2+N3

    % VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir_tone.filereference{p});
    [signals_dreem_vc, ~, badEpochsDreem, ~] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    [phase_vc, ~] = ComputeHilbertData(signals_dreem_vc,'bandpass',[0.5 4]);
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;

    
    %% TONES
    %only real auditory stimulations 
    stimulations = Restrict(stimulations, goodEpochs);
    stim_tmp = Range(stimulations);
    stim_tmp = stim_tmp(Data(stimulations)>0); %true tones, not sham
    tone_intv_post = intervalSet(stim_tmp, stim_tmp + effect_period);  % Tone and its window where an effect could be observed
    tone_intv_pre = intervalSet(stim_tmp - pre_period, stim_tmp);  % Tone and its anterior window
    all_tones = ts(stim_tmp);
    nb_tones = length(all_tones);
    
    %distinguish 1st and 2nd tones   
    second_idx = [0 ; diff(stim_tmp)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    first_tones = (second_idx==0) .* (isolated_idx==0);

    tone_res.tones.total{p} = length(all_tones);
    tone_res.tones.rank_tones{p} = 0*isolated_idx + first_tones + 2*second_idx;
    
    %phase phase_vc
    phase_value = Data(phase_vc);
    phase_tmp = Range(phase_vc);
    phase_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        [~,min_idx] = min(abs(phase_tmp-stim_tmp(i)));
        phase_tone(i) = phase_value(min_idx);
    end
    tone_res.tones.phase{p} = phase_tone;
    
    
    %% Slow Waves measures
    SlowWaveEpochs = FindSlowWaves(signals_dreem_vc);
    SlowWaveEpochs = intersect(SlowWaveEpochs, goodEpochs);
    
    start_slowwaves = ts(Start(SlowWaveEpochs));    
    slowwaves_tmp = Range(start_slowwaves);
    
    
    %% TONES - induced a slow wave?
    induce_slow_wave = zeros(nb_tones, 1);
    [~,interval,~] = InIntervals(slowwaves_tmp, [Start(tone_intv_post) End(tone_intv_post)]);
    tone_success = unique(interval);
    tone_success(tone_success==0)=[];
    induce_slow_wave(tone_success) = 1;
    
    slowwave_triggered = zeros(nb_tones, 1);
    [~,interval,~] = InIntervals(slowwaves_tmp, [Start(tone_intv_pre) End(tone_intv_pre)]);
    tone_trig = unique(interval);
    tone_trig(tone_trig==0)=[];
    slowwave_triggered(tone_trig) = 1;  %do not consider the first nul element
    
    tone_res.slowwave_triggered{p} = slowwave_triggered;
    tone_res.induce_slow_wave{p} = induce_slow_wave;
    
    
    %% TONES - SUBSTAGE
    sleepstage_tone = nan(1,nb_tones);
    stage_duration = zeros(1,length(sleepstage_ind));
    for sstage=sleepstage_ind
        sleepstage_tone(ismember(stim_tmp, Range(Restrict(all_tones, StageEpochs{sstage})))) = sstage;
        stage_duration(sstage) = tot_length(StageEpochs{sstage});
    end
    tone_res.sleepstage_tone{p} = sleepstage_tone;
    tone_res.sleepstage_duration{p} = stage_duration;
    
    
    
    %% ISI
    for t=1:nb_tones
        prev_slowwave = slowwaves_tmp(find(slowwaves_tmp<stim_tmp(t), 1, 'last'));
        next_slowwave = slowwaves_tmp(find(slowwaves_tmp>stim_tmp(t), 3));
        for i=1:3
            try
                isi_tone_slowwave{i}(t) = next_slowwave(i) - prev_slowwave;
            catch
                isi_tone_slowwave{i}(t) = nan;
            end
        end
    end
    for i=1:3
        tone_res.isi_slowwave_stage{p,i} = isi_tone_slowwave{i};
    end
    
end


%saving data
cd(FolderPrecomputeDreem)
save QuantifClinicISI.mat basal_res tone_res sleepstage_ind lim_between_stim effect_period pre_period



