% ClinicStatSlowWaves
% 06.07.2017 KJ
%
% Slow Waves Stat : number / generated / amplitude / AUC / Slop / Amplitude
% 
% 
%   see ClinicQuantitySleepNew ClinicStatSlowWavesPlot1 ClinicStatSlowWavesPlot2
%



clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');
[performance_word, delta] = GetClinicWordPerformance(Dir);

%params
common_data = GetClinicCommonData();

sleepstage_ind = 1:6; %N1, N2, N3, REM, WAKE, N2+N3
hours_expe = 0:1:8;
for h=1:length(hours_expe)
    hours_epoch{h} = intervalSet(hours_expe(h)*3600E4, (hours_expe(h)+1)*3600E4-1);
end
effect_period = common_data.effect_period;
lim_between_stim = common_data.lim_between_stim;
spindle_band = common_data.spindle_band;



%% loop over nights
for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    quantity_res.filename{p} = Dir.filename{p};
    quantity_res.condition{p} = Dir.condition{p};
    quantity_res.subject{p} = Dir.subject{p};
    quantity_res.date{p} = Dir.date{p};
    quantity_res.night{p} = Dir.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    
%     %Hypnograms
%     [Hypnograms, ~, ~] = GetHypnogramClinic(Dir.filereference{p});
%     if ~isempty(Hypnograms)
%         StageEpochs = Hypnograms{2};
%     end
    StageEpochs{6} = or(StageEpochs{2},StageEpochs{3});

    % VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    [signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    [phase_vc, ~] = ComputeHilbertData(signals_dreem_vc,'bandpass',[0.5 4]);
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;

    [~, signal_spindles] = ComputeHilbertData(signals_dreem_vc,'bandpass',spindle_band);
    
    %% TONES
    %only real auditory stimulations 
    stimulations = Restrict(stimulations, goodEpochs);
    stim_tmp = Range(stimulations);
    if strcmpi(Dir.condition{p},'sham')
        stim_tmp = stim_tmp(Data(stimulations)==0); %sham
    else
        stim_tmp = stim_tmp(Data(stimulations)>0); %true tones, not sham
    end
    tone_intv_post = intervalSet(stim_tmp, stim_tmp + effect_period);  % Tone and its window where an effect could be observed
    all_tones = ts(stim_tmp);
    nb_tones = length(all_tones);
    
    %distinguish 1st and 2nd tones   
    second_idx = [0 ; diff(stim_tmp)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    first_tones = (second_idx==0) .* (isolated_idx==0);

    quantity_res.tones.total{p} = length(all_tones);
    quantity_res.tones.rank_tones{p} = 0*isolated_idx + first_tones + 2*second_idx;
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% QUANTIF
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% night duration
    quantity_res.night_duration{p} = max(Range(signals_dreem_vc));
    
    %% total
    for sstage=1:length(StageEpochs)
        quantity_res.sleepstages.total{p}(sstage) = tot_length(StageEpochs{sstage});
    end
    
    
    %% Slow Waves measures
    SlowWaveEpochs = DetectSlowWavesTree(signals_dreem_vc);
    SlowWaveEpochs = intersect(SlowWaveEpochs, goodEpochs);
    
    start_slowwaves = ts(Start(SlowWaveEpochs));    
    slowwaves_tmp = Range(start_slowwaves);
    centersw_tmp = (Start(SlowWaveEpochs)+End(SlowWaveEpochs))/2;
    
    BurstEpochs = FindBurstSlowWave(SlowWaveEpochs);
    start_burst = ts(Start(BurstEpochs));

    auc = [];
    amplitude = [];
    slope = [];

    %stat
    for i=1:length(start_slowwaves)
        sub_epoch = subset(SlowWaveEpochs, i);
        eeg_signal = Data(Restrict(signals_dreem_vc, sub_epoch));
        eeg_tmp = Range(Restrict(signals_dreem_vc, sub_epoch));
        [trough_value, trough_pos] = min(eeg_signal);

        auc(i) = sum(eeg_signal(eeg_signal<0));
        amplitude(i) = trough_value;
        slope(i) = (eeg_signal(end)-eeg_signal(trough_pos)) / (eeg_tmp(end)-eeg_tmp(trough_pos));
    end

    quantity_res.slowwaves.auc{p} = auc;
    quantity_res.slowwaves.amplitude{p} = amplitude;
    quantity_res.slowwaves.slope{p} = slope;

    quantity_res.slowwaves.total{p} = length(start_slowwaves);
    quantity_res.burst.total{p} = length(start_burst);


    %% TONES 
    
    %induced a slow wave?
    induce_slow_wave = zeros(nb_tones, 1);
    [status,interval,~] = InIntervals(slowwaves_tmp, [Start(tone_intv_post) End(tone_intv_post)]);
    tone_success = unique(interval);
    tone_success(tone_success==0)=[];
    induce_slow_wave(tone_success) = 1;
    stim_success = ts(stim_tmp(tone_success));

    slowwave_after_tone = zeros(nb_tones, 1);
    for i=1:length(interval)
        if interval(i)>0
            slowwave_after_tone(interval(i)) = i;
        end
    end
    
    quantity_res.slowwaves.induced{p} = status;
    quantity_res.tones.sw_after{p} = slowwave_after_tone;
    quantity_res.tones.nb_success{p} = length(stim_success);
    quantity_res.tones.induce{p} = induce_slow_wave;
    
    
    %delay
    delay_slowwave_tone = nan(nb_tones, 1);
    slowwave_before_tone = nan(nb_tones, 1);
    for i=1:nb_tones
        idx_sw_before = find(centersw_tmp < stim_tmp(i), 1,'last');
        if ~isempty(idx_sw_before)
            delay_slowwave_tone(i) = stim_tmp(i) - centersw_tmp(idx_sw_before);
            slowwave_before_tone(i) = idx_sw_before; %index of the previous slow wave
        end
    end  
    quantity_res.tones.delay{p} = delay_slowwave_tone;
    quantity_res.tones.sw_before{p} = slowwave_before_tone;

    %phase phase_vc
    phase_value = Data(phase_vc);
    phase_tmp = Range(phase_vc);
    phase_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        [~,min_idx] = min(abs(phase_tmp-stim_tmp(i)));
        phase_tone(i) = phase_value(min_idx);
    end
    quantity_res.tones.phase{p} = phase_tone;
    
    %value of EEG during tones
    eeg_value = Data(signals_dreem_vc);
    eeg_tmp = Range(signals_dreem_vc);
    eeg_value_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        [~,min_idx] = min(abs(eeg_tmp-stim_tmp(i)));
        eeg_value_tone(i) = eeg_value(min_idx);
    end
    quantity_res.tones.eeg_amplitude{p} = eeg_value_tone;
    
    %value of spindle power
    spindle_value = Data(phase_vc);
    spindle_tmp = Range(phase_vc);
    spindle_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        [~,min_idx] = min(abs(spindle_tmp-stim_tmp(i)));
        spindle_tone(i) = spindle_value(min_idx);
    end
    quantity_res.tones.spindle{p} = spindle_tone;
    

    %% hours
    quantity_res.sleepstages.hours{p} = nan(length(hours_epoch),length(sleepstage_ind));
    for h=1:length(hours_epoch)
        %sleep stages
        for sstage=1:length(StageEpochs)
            quantity_res.sleepstages.hours{p}(h,sstage) = tot_length(and(hours_epoch{h},StageEpochs{sstage}));
        end
        %deltas
        quantity_res.slowwaves.hours{p,h} = length(Restrict(start_slowwaves,hours_epoch{h}));
        quantity_res.burst.hours{p,h} = length(Restrict(start_burst,hours_epoch{h}));
        quantity_res.tones.hours{p,h} = length(Restrict(all_tones,hours_epoch{h}));
        quantity_res.success.hours{p,h} = length(Restrict(stim_success,hours_epoch{h}));
    end

    %% words
    quantity_res.word.delta(p) = delta(p);
    
end


%saving data
cd(FolderPrecomputeDreem)
save ClinicStatSlowWaves.mat quantity_res sleepstage_ind hours_expe



