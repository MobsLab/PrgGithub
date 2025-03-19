% ClinicDelayRefractoryPeriod
% 11.01.2017 KJ
%
% Raster plot of the EEG, synchronized on tones
% -> Collect and save data 
%
%   see 
%       RandomPethAnalysis ClinicDelayRefractoryPeriodPlot
%

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
    refractory_res.filename{p} = Dir.filename{p};
    refractory_res.condition{p} = Dir.condition{p};
    refractory_res.subject{p} = Dir.subject{p};
    refractory_res.date{p} = Dir.date{p};
    refractory_res.night{p} = Dir.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    
    %find Slow Wave
    SlowWaveEpochs = FindSlowWaves(signals{Dir.channel_sw{p}(1)});
    center_slowwave = (Start(SlowWaveEpochs) + End(SlowWaveEpochs)) / 2;
    start_slowwaves = Start(SlowWaveEpochs);
    
    %tones
    all_tones = Range(stimulations);
    int_stim = Data(stimulations);
    nb_tones = length(all_tones);
    tone_intv_post = intervalSet(all_tones, all_tones + effect_period);  % Tone and its window where an effect could be observed
    
    
    %% TONES - distinguish 1st and 2nd tones    
    second_idx = [0 ; diff(all_tones)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    
    first_tones = (second_idx==0) .* (isolated_idx==0);
    second_tones = second_idx;
    isolated_tones = isolated_idx;
    
    % isolated=0 / first=1 / second=2
    refractory_res.rank_tones{p} = 0*isolated_tones + first_tones + 2*second_tones;
    
    
    %% TONES - intensity 
    refractory_res.intensity_tone{p} = int_stim;
    
    %% TONES - Delay 
    %all tones
    delay_slowwave_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        idx_sw_before = find(center_slowwave < all_tones(i), 1,'last');
        delay_slowwave_tone(i) = all_tones(i) - center_slowwave(idx_sw_before);
    end  
    refractory_res.delay_slowwave_tone{p} = delay_slowwave_tone;
    
    
    %% TONES - induced a slow wave?
    induce_slow_wave = zeros(nb_tones, 1);
    [~,interval,~] = InIntervals(start_slowwaves, [Start(tone_intv_post) End(tone_intv_post)]);
    tone_success = unique(interval);
    tone_success(tone_success==0)=[];
    induce_slow_wave(tone_success) = 1;
    
    refractory_res.induce_slow_wave{p} = induce_slow_wave;

    
    %% TONES - SUBSTAGE
    sleepstage_tone = nan(1,nb_tones);
    for sstage=sleepstage_ind
        sleepstage_tone(ismember(all_tones, Range(Restrict(ts(all_tones), StageEpochs{sstage})))) = sstage;
    end
    refractory_res.sleepstage_tone{p} = sleepstage_tone;
    
    
    
end


%saving data
cd(FolderPrecomputeDreem)
save ClinicDelayRefractoryPeriod.mat refractory_res sleepstage_ind effect_period name_channel 




