% QuantifThresholdDetectionSlowWave
% 20.01.2017 KJ
%
% Number of Slow Waves, in function of the thresholds for detection
% -> Collect and save data 
%
%   see 
%       FindSlowWaves QuantifThresholdDetectionSlowWave2
%

clear

%Dir
Dir=ListOfClinicalTrialDreem('all');

%params
sleepstage_ind = 1:5; %N1, N2, N3, REM, WAKE
sw_detection_channels = [1 2 7 10];
% - name_channel            '1: FP1-M1','2: FP2-M2','3: FP2-FP1','4: FP1-FPz','5: REF O1','6: REF C3','7: REF F3','8: REF O2','9: REF C4','10: REF F4','11: REF E1','12: REF E2','13: REF ECG','14: REF EMG'

threshold_list = -130:5:-70;
threshDuration = 30;
minDuration = 50;
maxDuration = 800;


for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    thresh_res.filename{p} = Dir.filename{p};
    thresh_res.condition{p} = Dir.condition{p};
    thresh_res.subject{p} = Dir.subject{p};
    thresh_res.date{p} = Dir.date{p};
    thresh_res.night{p} = Dir.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    %stages
    N1=StageEpochs{1}; N2=StageEpochs{2}; N3=StageEpochs{3};
    NREM=or(N1,or(N2,N3));

    %standard deviation
    for ch=1:length(sw_detection_channels)
        neg_signal = min(Data(signals{sw_detection_channels(ch)}),0);
        std_signals(ch) = std(neg_signal(neg_signal<0));  % std that determines thresholds
    end
    
    %find Slow Wave
    nb_slowwaves = nan(length(threshold_list),length(sw_detection_channels));
    nb_slowwaves_stage = nan(length(threshold_list),length(sw_detection_channels),length(sleepstage_ind));
    
    for ch=1:length(sw_detection_channels)
        for th=1:length(threshold_list)
            SlowWaveEpochs = FindSlowWaves(signals{sw_detection_channels(ch)},'threshold',threshold_list(th),'threshDuration',threshDuration,'minDuration',minDuration,'maxDuration',maxDuration);
            nb_slowwaves(th,ch) = length(Start(SlowWaveEpochs));
            for sstage=1:length(sleepstage_ind)
                nb_slowwaves_stage(th,ch,sstage) = length(Restrict(ts(Start(SlowWaveEpochs)),StageEpochs{sstage}));
            end
        end
    end
    
    %stage duration
    for sstage=1:length(sleepstage_ind)
        stage_duration(sstage) = tot_length(StageEpochs{sstage}); 
    end
    
    
    thresh_res.std_signals{p} = std_signals;
    thresh_res.nb_slowwaves{p} = nb_slowwaves;
    thresh_res.nb_slowwaves_stage{p} = nb_slowwaves_stage;
    thresh_res.stage_duration{p} = stage_duration;
    
end


%saving data
cd(FolderPrecomputeDreem)
save QuantifThresholdDetectionSlowWave.mat thresh_res sleepstage_ind sw_detection_channels threshold_list threshDuration minDuration maxDuration






