% MotherCurvesPhaseDelay
% 12.07.2017 KJ
%
% Mean curves sync on stimulation time - VIRTUAL CHANNEL DATA
% In function of the delay
% -> Collect data
%
%   see 
%       MotherCurves1 MotherCurvesPlot_VC1 MotherCurvesPhasePlot
%

clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');


%params
common_data = GetClinicCommonData();
lim_between_stim = common_data.lim_between_stim;  %1.6sec maximum between two stim of the same train
met_window = 5000; %in ms



for p=1:length(Dir.filename)
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    mother_res.filename{p} = Dir.filename{p};
    mother_res.condition{p} = Dir.condition{p};
    mother_res.subject{p} = Dir.subject{p};
    mother_res.date{p} = Dir.date{p};
    mother_res.night{p} = Dir.night{p};


    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    
    %Hypnograms
    [Hypnograms, ~, ~] = GetHypnogramClinic(Dir.filereference{p});
    if ~isempty(Hypnograms)
        StageEpochs = Hypnograms{2};
    end

    % VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    [signals_dreem_vc, ~, badEpochsDreem, ~] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    [phase_vc, ~] = ComputeHilbertData(signals_dreem_vc,'bandpass',[0.5 4]); %phase
    
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;
    
    %Slow Waves measures
    SlowWaveEpochs = FindSlowWaves(signals_dreem_vc);
    center_slowwaves = ts((Start(SlowWaveEpochs)+End(SlowWaveEpochs))/2);
    center_slowwaves = Range(Restrict(center_slowwaves, goodEpochs));
    
    
    %% TONES
    %only real auditory stimulations 
    time_stim = Range(stimulations);
    int_stim = Data(stimulations);
    if any(int_stim>0)
        time_stim = time_stim(int_stim>0);
    end
    
    %distinguish 1st and 2nd tones  
    second_idx = [0 ; diff(time_stim)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    first_tones = (second_idx==0) .* (isolated_idx==0);
    first_stim = Restrict(ts(time_stim(first_tones==1)), goodEpochs);
    stim_tmp = Range(first_stim);
    nb_tones = length(stim_tmp);
    
    %% phase and delay
    %tone phases
    phase_value = Data(phase_vc);
    phase_tmp = Range(phase_vc);
    phase_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        [~,min_idx] = min(abs(phase_tmp-stim_tmp(i)));
        phase_tone(i) = phase_value(min_idx);
    end
    
    %delay
    delay_slowwave_tone = nan(nb_tones, 1);
    slowwave_before_tone = nan(nb_tones, 1);
    for i=1:nb_tones
        idx_sw_before = find(center_slowwaves < stim_tmp(i), 1,'last');
        if ~isempty(idx_sw_before)
            delay_slowwave_tone(i) = stim_tmp(i) - center_slowwaves(idx_sw_before);
            slowwave_before_tone(i) = idx_sw_before; %index of the previous slow wave
        end
    end  
    
    mother_res.nb_tones{p} = nb_tones;
    mother_res.phase{p} = phase_tone;
    mother_res.delay{p} = delay_slowwave_tone;
    
    
    %% Mean Curves sync on Tones
    [Ms_tone, sync_map] = PlotRipRaw(signals_dreem_vc, stim_tmp/1E4, met_window); close
    
    mother_res.Tone_map{p} = sync_map;
    mother_res.times{p} = Ms_tone(:,1);
    
    
end


%saving data
cd(FolderPrecomputeDreem)
save MotherCurvesPhaseDelay.mat mother_res met_window Dir


