% QuantifHypnogramSlowDyn
% 15.09.2018 KJ
%
% Infos
%   for each night :
%       - Sleep stages stat
%       - Waso - SOL - Sleep Efficiency
%       
%
% SEE 
%   QuantifSlowWaveSlowDyn QuantifHypnogramSlowDynPlot
%   QuantifHypnogramSlowDyn2
%

clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))

for p=1:length(Dir.filereference)
% p=120;
    clearvars -except Dir p hypno_res

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    %% init
    
    hypno_res.filename{p} = Dir.filename{p};
    hypno_res.filereference{p} = Dir.filereference{p};
    hypno_res.subject{p} = Dir.subject{p};
    hypno_res.date{p} = Dir.date(p);
    hypno_res.age{p} = Dir.age{p};
    hypno_res.gender{p} = Dir.gender{p};
    
    %params
    stage_epoch_duration = 30e4;
    
    %load signals and data
    [~, ~, stimulations, StageEpochs, labels_eeg] = GetRecordDreem(Dir.filename{p});
    N1 = StageEpochs{1}; N2 = StageEpochs{2}; N3 = StageEpochs{3}; REM = StageEpochs{4}; Wake = StageEpochs{5};
    
    %quality
%     [~, NoiseEpoch, TotalNoise] = GetDreemQuality(Dir.filereference{p});
    
    
    %% SOL - WASO - Sleep Efficiency
    [hypno_res.sleep_efficiency{p}, hypno_res.sol{p}, hypno_res.waso{p}] = GetDataSleepClinic(StageEpochs, stage_epoch_duration);
    
    
    %%
    for i=1:5
        hypno_res.stage.nb_episodes{p}(i)     = length(Start(StageEpochs{i}));
        hypno_res.stage.total{p}(i) = tot_length(StageEpochs{i});
        hypno_res.stage.mean_durations{p}(i)  = mean(End(StageEpochs{i}) - Start(StageEpochs{i}));
        hypno_res.stage.durations{p,i}  = End(StageEpochs{i}) - Start(StageEpochs{i});
    end
    
    
    
end

%saving data
cd(FolderSlowDynData)
save QuantifHypnogramSlowDyn.mat hypno_res



