% QuantifClinicSuccessSubstage
% 15.01.2017 KJ
%
% collect data for the quantification of the success of tone to induce slow wave, 
% for different sleep stages
%   - Sleep stages = N1, N2, N3, REM, WAKE
%
% Here, the data are collected
%
%   see QuantifClinicSuccessSubstage2 QuantifClinicSuccessSubstage3 QuantifClinicSuccessSubstage4


clear

%Dir
Dir=ListOfClinicalTrialDreemAnalyse('all');

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
    % infos.name_channel = {'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'};
    % domain = {'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'};
    % Sleep stages: 1:N1 , 2:N2 , 3:N3 , 4:REM , 5:Wake
    
    %find Slow Wave
    SlowWaveEpochs = FindSlowWaves(signals{Dir.channel_sw{p}(1)});
    start_slowwaves = Start(SlowWaveEpochs);
    
    %tones
    all_tones = Range(stimulations);
    all_tones = all_tones(Data(stimulations)>0);
    nb_tones = length(all_tones);
    tone_intv_post = intervalSet(all_tones, all_tones + effect_period);  % Tone and its window where an effect could be observed
    
    
    %% TONES - distinguish 1st and 2nd tones    
    second_idx = [0 ; diff(all_tones)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    
    first_tones = (second_idx==0) .* (isolated_idx==0);
    second_tones = second_idx;
    isolated_tones = isolated_idx;
    
    % isolated=0 / first=1 / second=2
    success_res.rank_tones{p} = 0*isolated_tones + first_tones + 2*second_tones;
    
    
    %% TONES - induced a slow wave?
    induce_slow_wave = zeros(nb_tones, 1);
    [~,interval,~] = InIntervals(start_slowwaves, [Start(tone_intv_post) End(tone_intv_post)]);
    tone_success = unique(interval);
    tone_success(tone_success==0)=[];
    induce_slow_wave(tone_success) = 1;
    
    success_res.induce_slow_wave{p} = induce_slow_wave;
    
    
    %% TONES - SUBSTAGE
    sleepstage_tone = nan(1,nb_tones);
    stage_duration = zeros(1,length(sleepstage_ind));
    for sstage=sleepstage_ind
        sleepstage_tone(ismember(all_tones, Range(Restrict(ts(all_tones), StageEpochs{sstage})))) = sstage;
        stage_duration(sstage) = tot_length(StageEpochs{sstage});
    end
    success_res.sleepstage_tone{p} = sleepstage_tone;
    success_res.sleepstage_duration{p} = stage_duration;
    
end


%saving data
cd(FolderPrecomputeDreem)
save QuantifClinicSuccessSubstage.mat success_res sleepstage_ind sw_detection_channel 














