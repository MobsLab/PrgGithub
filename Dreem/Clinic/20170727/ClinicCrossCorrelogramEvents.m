% ClinicCrossCorrelogramEvents
% 24.07.2017 KJ
%
% Cross-correlogram Tones-SlowWaves
% -> Collect data
%
%   see 
%       
%

clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');


%params
common_data = GetClinicCommonData();
lim_between_stim = common_data.lim_between_stim;  %1.6sec maximum between two stim of the same train
binsize = 100; %10ms
nbins = 500;


for p=1:length(Dir.filename)
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    crosscor_res.filename{p} = Dir.filename{p};
    crosscor_res.condition{p} = Dir.condition{p};
    crosscor_res.subject{p} = Dir.subject{p};
    crosscor_res.date{p} = Dir.date{p};
    crosscor_res.night{p} = Dir.night{p};


    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    N2N3 = or(StageEpochs{2},StageEpochs{3});
    
    % VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    [signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;
    
    
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


    %% Slow waves
    SlowWaveEpochs= FindSlowWaves(signals_dreem_vc);
    BurstEpochs = FindBurstSlowWave(SlowWaveEpochs);
    start_slowwaves = Restrict(ts(Start(SlowWaveEpochs)),N2N3);
    start_burst = Restrict(ts(Start(BurstEpochs)),N2N3);


    %% Cross corr
    crosscor_res.Cc.tone_slowwave{p} = CrossCorr(first_stim, start_slowwaves, binsize, nbins);
    crosscor_res.Cc.tone_burst{p} = CrossCorr(first_stim, start_burst, binsize, nbins);
    crosscor_res.Ac.slowwave{p} = CrossCorr(start_slowwaves, start_slowwaves, binsize, nbins);
    crosscor_res.Ac.burst{p} = CrossCorr(start_burst, start_burst, binsize, nbins);

    %nb
    crosscor_res.nb.tones{p} = length(first_stim);
    crosscor_res.nb.slowwaves{p} = length(start_slowwaves);
    crosscor_res.nb.burst{p} = length(start_burst);
    
end


%saving data
cd(FolderPrecomputeDreem)
save ClinicCrossCorrelogramEvents.mat crosscor_res binsize nbins Dir




