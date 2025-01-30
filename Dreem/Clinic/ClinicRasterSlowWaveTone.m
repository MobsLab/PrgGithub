% ClinicRasterSlowWaveTone
% 11.01.2017 KJ
%
% Raster plot of the EEG, synchronized on tones
% -> Collect and save data 
%
%   see 
%       RandomPethAnalysis
%

clear

%Dir
Dir=ListOfClinicalTrialDreem('all');

%params
sleepstage_ind = 1:5; %N1, N2, N3, REM, WAKE
lim_between_stim = 1.6E4;  %1.6sec maximum between two stim of the same train
channels = [1 2 3 4 5 6 7 8 9 10];
sw_detection_channel = 1;
effect_period = 8000; %800ms
t_before = -6E4; %in 1E-4s
t_after = 6E4; %in 1E-4s


for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    raster_res.filename{p} = Dir.filename{p};
    raster_res.condition{p} = Dir.condition{p};
    raster_res.subject{p} = Dir.subject{p};
    raster_res.date{p} = Dir.date{p};
    raster_res.night{p} = Dir.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    labels = name_channel(channels);
    
    %find Slow Wave
    SlowWaveEpochs = FindSlowWaves(signals{sw_detection_channel});
    center_slowwave = (Start(SlowWaveEpochs) + End(SlowWaveEpochs)) / 2;
    start_slowwaves = Start(SlowWaveEpochs);
    
    %tones
    all_tones = Range(stimulations);
    nb_tones = length(all_tones);
    tone_intv_post = intervalSet(all_tones, all_tones + effect_period);  % Tone and its window where an effect could be observed
    
    
    %% TONES - distinguish 1st and 2nd tones    
    second_idx = [0 ; diff(all_tones)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    
    first_tones = (second_idx==0) .* (isolated_idx==0);
    second_tones = second_idx;
    isolated_tones = isolated_idx;
    
    % isolated=0 / first=1 / second=2
    raster_res.rank_tones{p} = 0*isolated_tones + first_tones + 2*second_tones; 
    
    
    %% TONES - Delay 
    %all tones
    delay_slowwave_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        idx_sw_before = find(center_slowwave < all_tones(i), 1,'last');
        delay_slowwave_tone(i) = all_tones(i) - center_slowwave(idx_sw_before);    
    end  
    raster_res.delay_slowwave_tone{p} = delay_slowwave_tone;
    
    
    %% TONES - induced a slow wave?
    induce_slow_wave = zeros(nb_tones, 1);
    [~,interval,~] = InIntervals(start_slowwaves, [Start(tone_intv_post) End(tone_intv_post)]);
    tone_success = unique(interval);
    tone_success(tone_success==0)=[];
    induce_slow_wave(tone_success) = 1;
    
    raster_res.induce_slow_wave{p} = induce_slow_wave;

    
    %% TONES - SUBSTAGE
    sleepstage_tone = nan(1,nb_tones);
    for sstage=sleepstage_ind
        sleepstage_tone(ismember(all_tones, Range(Restrict(ts(all_tones), StageEpochs{sstage})))) = sstage;
    end
    raster_res.sleepstage_tone{p} = sleepstage_tone;
    
    
    %% Raster
    for ch=1:length(channels)
        raster_res.raster{p,ch} = RasterMatrixKJ(signals{ch}, ts(all_tones), t_before, t_after);
    end
    
end


%saving data
cd(FolderPrecomputeDreem)
save ClinicRasterSlowWaveTone.mat raster_res sleepstage_ind channels sw_detection_channel labels t_before t_after 




