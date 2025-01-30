% QuantifClinicSuccessSubstage_VC
% 26.06.2017 KJ
%
% collect data for the quantification of the success of tone to induce slow wave, 
% for different sleep stages
%   - Sleep stages = N1, N2, N3, REM, WAKE
%
% Here, the data are collected
%
%   see QuantifClinicSuccessSubstage_VC


clear

%Dir
Dir=ListOfClinicalTrialDreemAnalyse('study');

%params
sleepstage_ind = 1:5; %N1, N2, N3, REM, WAKE
lim_between_stim = 1.6E4;  %1.6sec maximum between two stim of the same train
effect_period = 8000; %800ms


for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    success_res.filename{p} = Dir.filename{p};
    success_res.condition{p} = Dir.condition{p};
    success_res.subject{p} = Dir.subject{p};
    success_res.date{p} = Dir.date{p};
    success_res.night{p} = Dir.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, infos.name_channel, domain, ~] = GetRecordClinic(Dir.filename{p});
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    % infos.name_channel = {'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'};
    % domain = {'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'};
    % Sleep stages: 1:N1 , 2:N2 , 3:N3 , 4:REM , 5:Wake
    
    %Hypnograms
    [Hypnograms, scorer, ref_score] = GetHypnogramClinic(Dir.filereference{p});
    if isempty(Hypnograms)
        Hypnograms{1} = StageEpochs;
        scorer{1} = 'dreem';
        ref_score{1} = 'dreem';
    end
    
    
    %% VIRTUAL CHANNEL SIGNAL
    % Dreem 
    dreem_ch1 = find(strcmpi(infos.name_channel,'FP1-M1'));
    dreem_ch2 = find(strcmpi(infos.name_channel,'FP2-M2'));

    sig_f1 = Data(signals{dreem_ch1}) .* (index_dreem==0);
    sig_f2 = Data(signals{dreem_ch2}) .* (index_dreem==1);

    signals_dreem_vc = sig_f1 + sig_f2;
    signals_dreem_vc = tsd(Range(signals{dreem_ch1}), signals_dreem_vc);

    % Actiwave
    psg_ch1 = find(strcmpi(infos.name_channel,'REF F3'));
    psg_ch2 = find(strcmpi(infos.name_channel,'REF F4'));

    sig_f3 = Data(signals{psg_ch1}) .* (index_psg==0);
    sig_f4 = Data(signals{psg_ch2}) .* (index_psg==1);

    signals_psg_vc = sig_f3 + sig_f4;
    signals_psg_vc = tsd(Range(signals{psg_ch1}), signals_psg_vc);

    
    %% find Slow Wave
    SlowWaveEpochs{1} = FindSlowWaves(signals_dreem_vc);
    start_slowwaves{1} = Start(SlowWaveEpochs{1});
    SlowWaveEpochs{2} = FindSlowWaves(signals_psg_vc);
    start_slowwaves{2} = Start(SlowWaveEpochs{2});
    
    %% TONES
    all_tones = Range(stimulations);
    if ~strcmpi(Dir.condition{p},'sham')
        all_tones = all_tones(Data(stimulations)>0);
    end
    nb_tones = length(all_tones);
    tone_intv_post = intervalSet(all_tones, all_tones + effect_period);  % Tone and its window where an effect could be observed
    
    %distinguish 1st and 2nd tones    
    second_idx = [0 ; diff(all_tones)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    
    first_tones = (second_idx==0) .* (isolated_idx==0);
    second_tones = second_idx;
    isolated_tones = isolated_idx;
    
    % isolated=0 / first=1 / second=2
    success_res.rank_tones{p} = 0*isolated_tones + first_tones + 2*second_tones;
    
    
    %% TONES - induced a slow wave?
    for i=1:2
        induce_slow_wave = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_slowwaves{i}, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        tone_success(tone_success==0)=[];
        induce_slow_wave(tone_success) = 1;

        success_res.induce_slow_wave{p,i} = induce_slow_wave;
    end
    
    
    %% TONES - SUBSTAGE
    for s=1:length(Hypnograms)
        StageEpochs = Hypnograms{s};
        
        sleepstage_tone = nan(1,nb_tones);
        stage_duration = zeros(1,length(sleepstage_ind));
        for sstage=sleepstage_ind
            sleepstage_tone(ismember(all_tones, Range(Restrict(ts(all_tones), StageEpochs{sstage})))) = sstage;
            stage_duration(sstage) = tot_length(StageEpochs{sstage});
        end
        success_res.sleepstage_tone{p,s} = sleepstage_tone;
        success_res.sleepstage_duration{p,s} = stage_duration;
    end
    
end


%saving data
cd(FolderPrecomputeDreem)
save QuantifClinicSuccessSubstage_VC.mat success_res sleepstage_ind scorer ref_score






