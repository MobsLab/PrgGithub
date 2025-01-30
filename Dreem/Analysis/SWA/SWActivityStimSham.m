% SWActivityStimSham
% 24.08.2017 KJ
%
% Effect of Stim on Slow Wave Activity
% 
% 
%   see
%


clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');

%% params

%params so detection
params_so.threshold = -80;
params_so.threshDuration = 20; 
params_so.minDuration = 200;
params_so.maxDuration = 1000;
params_so.noiseThreshold = 210;

%params SWA
params_swa.tapers = [3 5];
params_swa.Fs = 250;
params_swa.fpass = [0.4 4];

%intv
thresh_train = 4.5E4; %4.5s
thresh_epochs = 25E4; % 25s 

%% loop over nights
for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    swa_res.filename{p} = Dir.filename{p};
    swa_res.condition{p} = Dir.condition{p};
    swa_res.subject{p} = Dir.subject{p};
    swa_res.date{p} = Dir.date{p};
    swa_res.night{p} = Dir.night{p};
    

    %% load data
    [signals, stimulations, StageEpochs, name_channel, domain, ~] = GetRecordClinic(Dir.filename{p});
    % infos.name_channel = {'FP1-M1','FP2-M2','FP2-FP1','FP1-FPz','REF O1','REF C3','REF F3','REF O2','REF C4','REF F4','REF E1','REF E2','REF ECG','REF EMG'};
    % domain = {'EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EEG','EOG','EOG','ECG','EMG'};
    % Sleep stages: 1:N1 , 2:N2 , 3:N3 , 4:REM , 5:Wake

    %Epochs from the dreem headband
    N2N3 = or(StageEpochs{2},StageEpochs{3});
    NREM = or(N2N3,StageEpochs{1});

    %VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    [signals_dreem_vc, ~, badEpochsDreem, ~] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;


    %stimulation
    stimulations = Restrict(stimulations, goodEpochs);
    stim_tmp = Range(stimulations);
    stim_intensities = Data(stimulations);
    if strcmpi(Dir.condition{p},'sham')
        stim_tmp = stim_tmp(Data(stimulations)==0); %sham
        stim_intensities = stim_intensities(Data(stimulations)==0);
    else
        stim_tmp = stim_tmp(Data(stimulations)>0); %true tones, not sham
        stim_intensities = stim_intensities(Data(stimulations)>0);
    end
    stimulations = tsd(stim_tmp, stim_intensities);


    %% Create Epochs of Stim
    stim_intv = intervalSet(stim_tmp, stim_tmp + 0.1E4);
    stim_intv = mergeCloseIntervals(stim_intv, thresh_train);

    stim_epochs = mergeCloseIntervals(stim_intv, thresh_epochs);

    %% Slow Waves
    SlowWaveEpochs = FindSlowWaves(signals_dreem_vc, 'method','karimjr','params',params_so);


    %% SWA: 2-4Hz Oscillation power
    for t=1:length(Start(stim_epochs))
        try
            subepochs = subset(stim_epochs,t);
            [Spectral_power, ~] = mtspectrumc(Data(Restrict(signals_dreem_vc, subepochs)), params_swa);
            swa_res.stim_epochs.power(t) = sum(Spectral_power);
            swa_res.stim_epochs.duration(t) = tot_length(subepochs);
            swa_res.stim_epochs.nb_stim(t) = length(Restrict(stimulations,subepochs));
            swa_res.stim_epochs.nb_slowwaves(t) = length(Restrict(Start(SlowWaveEpochs),subepochs));
        catch
            swa_power(t) = 0;
        end
    end

end


%saving data
cd(FolderPrecomputeDreem)
save SWActivityStimSham.mat swa_res params_so params_swa






