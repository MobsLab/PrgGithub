% ClinicMeanCurveSpindleSuccess
% 27.07.2017 KJ
%
% Mean curves, sync on stim, in function of the success of the stim
% 
% 
%   see MeanCurvesSpindle_VC1
%



clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');
[performance_word, delta] = GetClinicWordPerformance(Dir);

%params
common_data = GetClinicCommonData();

sleepstage_ind = 1:6; %N1, N2, N3, REM, WAKE, N2+N3
effect_period = common_data.effect_period;
lim_between_stim = common_data.lim_between_stim;
spindle_band = common_data.spindle_band;
met_window = 6000; %in ms


%% loop over nights
for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    curves_res.filename{p} = Dir.filename{p};
    curves_res.condition{p} = Dir.condition{p};
    curves_res.subject{p} = Dir.subject{p};
    curves_res.date{p} = Dir.date{p};
    curves_res.night{p} = Dir.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    N2N3 = or(StageEpochs{2},StageEpochs{3});

    % VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    [signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;

    [~, signal_spindles] = ComputeHilbertData(signals_dreem_vc,'bandpass',spindle_band);
    
    %% Slow Waves measures
    SlowWaveEpochs = FindSlowWaves(signals_dreem_vc);
    start_slowwaves = Restrict(ts(Start(SlowWaveEpochs)), and(goodEpochs,N2N3));    
    slowwaves_tmp = Range(start_slowwaves);
    
    
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
    second_tones = [0 ; diff(stim_tmp)<lim_between_stim];
    isolated_idx = [diff(second_tones)==0;0].* (second_tones==0);
    first_tones = (second_tones==0) .* (isolated_idx==0);
    if first_tones(end)
        isolated_idx(end)=1;
        first_tones(end)=0;
    end
        
    curves_res.tones.total{p} = length(all_tones);
    curves_res.tones.rank_tones{p} = 0*isolated_idx + first_tones + 2*second_tones;
    
    
    %% Induced delta
    induce_slow_wave = zeros(nb_tones, 1);
    [~,interval,~] = InIntervals(slowwaves_tmp, [Start(tone_intv_post) End(tone_intv_post)]);
    tone_success = unique(interval);
    tone_success(tone_success==0)=[];
    induce_slow_wave(tone_success) = 1;

    
    %% MEAN CURVES
    first_stim = stim_tmp(first_tones==1);
    first_stim_success = stim_tmp(induce_slow_wave==1 & first_tones==1);
    first_stim_failed = stim_tmp(induce_slow_wave==0 & first_tones==1);
    second_stim = stim_tmp(second_tones==1);
    second_stim_success = stim_tmp(induce_slow_wave==1 & second_tones==1);
    second_stim_failed = stim_tmp(induce_slow_wave==0 & second_tones==1);
    
    second_stim_firstsuccess = stim_tmp(find(induce_slow_wave==1 & first_tones==1)+1);
    second_stim_firstfailed = stim_tmp(find(induce_slow_wave==0 & first_tones==1)+1);
    
    %curves
    curves_res.nb_first{p} = length(first_stim);
    curves_res.Ms_first{p} = PlotRipRaw(signal_spindles,first_stim/1E4, met_window); close 
    curves_res.nb_first_success{p} = length(first_stim_success);
    curves_res.Ms_first_success{p} = PlotRipRaw(signal_spindles,first_stim_success/1E4, met_window); close
    curves_res.nb_first_failed{p} = length(first_stim_failed);
    curves_res.Ms_first_failed{p} = PlotRipRaw(signal_spindles,first_stim_failed/1E4, met_window); close 
    
    curves_res.nb_second{p} = length(second_stim);
    curves_res.Ms_second{p} = PlotRipRaw(signal_spindles,second_stim/1E4, met_window); close 
    curves_res.nb_second_success{p} = length(second_stim_success);
    curves_res.Ms_second_success{p} = PlotRipRaw(signal_spindles,second_stim_success/1E4, met_window); close
    curves_res.nb_second_failed{p} = length(second_stim_failed);
    curves_res.Ms_second_failed{p} = PlotRipRaw(signal_spindles,second_stim_failed/1E4, met_window); close 
    
    curves_res.nb_second_first_success{p} = length(second_stim_firstsuccess);
    curves_res.Ms_second_first_success{p} = PlotRipRaw(signal_spindles,second_stim_firstsuccess/1E4, met_window); close 
    curves_res.nb_second_first_failed{p} = length(second_stim_firstfailed);
    curves_res.Ms_second_first_failed{p} = PlotRipRaw(signal_spindles,second_stim_firstfailed/1E4, met_window); close 
    
    
end


%saving data
cd(FolderPrecomputeDreem)
save ClinicMeanCurveSpindleSuccess.mat curves_res met_window spindle_band Dir







    