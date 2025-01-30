% ClinicEpisodeDuration
% 29.03.2017 KJ
%
% duration of each sleep stage episode
% 
% 
%   see ClinicQuantitySleep ClinicEpisodeDurationPlot
%


clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('all');

%params
sleepstage_ind = 1:6; %N1, N2, N3, REM, WAKE, N2+N3
NameStages = {'N1', 'N2', 'N3', 'REM', 'WAKE', 'N2+N3'};

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
    StageEpochs{6} = or(StageEpochs{2},StageEpochs{3});
    %slow waves
    SlowWaveEpochs = FindSlowWaves(signals{Dir.channel_sw{p}(1)},'threshold',-100,'noiseThreshold',260);
    BurstEpochs = FindBurstSlowWave(SlowWaveEpochs);
    
    start_slowwaves = ts(Start(SlowWaveEpochs));
    start_burst = ts(Start(BurstEpochs));
    
    %tones
    stim_tmp = Range(stimulations);
    stim_tmp = ts(stim_tmp(Data(stimulations)>0)); %true tones, not sham
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% QUANTIF
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for sstage=1:length(StageEpochs)
        durations = End(StageEpochs{sstage}) - Start(StageEpochs{sstage});
        quantity_res.duration{p,sstage} = durations / 1E4;
        
        nb_slowwave = [];
        nb_burst = [];
        nb_tone = [];
        for i=1:length(Start(StageEpochs{sstage})) %number of episode
            sub_intv = subset(StageEpochs{sstage},i);
            nb_slowwave = [nb_slowwave length(Restrict(start_slowwaves, sub_intv))];
            nb_burst = [nb_burst length(Restrict(start_burst, sub_intv))];
            nb_tone = [nb_tone length(Restrict(stim_tmp, sub_intv))];
        end
        quantity_res.nb.slowwaves{p,sstage} = nb_slowwave;
        quantity_res.nb.burst{p,sstage} = nb_burst;
        quantity_res.nb.tones{p,sstage} = nb_tone;
    end
        
end


%saving data
cd(FolderPrecomputeDreem)
save ClinicEpisodeDuration.mat quantity_res sleepstage_ind NameStages






