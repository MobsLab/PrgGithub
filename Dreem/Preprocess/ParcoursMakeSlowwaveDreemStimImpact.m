% ParcoursMakeSlowwaveDreemStimImpact
% 15.05.2018 KJ
%
% Infos
%   Loop over all record: generate slow waves
%
% SEE 
%   ParcoursGenerateIDDreemStimImpact GenerateIDDreemStimImpact
%

Dir = ListOfDreemRecordsStimImpact('all');

for p=1:length(Dir.filereference)
    clearvars -except Dir p

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    %params
    method = 3;
    
    %load
    [signals, ~, ~, StageEpochs, labels] = GetRecordDreem(Dir.filename{p});
    
    
    %% Detection
    
    %classic with std threshold
    if method==1
        %find Slow Wave
        N2N3 = or(StageEpochs{2}, StageEpochs{3}); 
        for ch=1:length(signals)
            SlowWaveEpochs{ch} = and(FindSlowWaves(signals{ch}), N2N3);
        end
        savefile = fullfile(FolderStimImpactPreprocess, 'SlowWaves2',['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
        save(savefile, 'SlowWaveEpochs','labels')
        
    
    %MultiChan with double std threshold    
    elseif method==2
        try
            [eeg, ~, ~, StageEpochs, ~, ~] = GetRecordDreem(Dir.filename{p});
            [~, NoiseEpoch] = GetDreemQuality(Dir.filereference{p});
            eeg_occipital = eeg([1 2 5 6]);
            NoiseEpoch = [NoiseEpoch([1 2]) {intervalSet([],[])} {intervalSet([],[])}];

            for i=1:length(NoiseEpoch)
                NoiseEpoch{i} = or(or(NoiseEpoch{i},StageEpochs{4}), StageEpochs{5}); %exclude REM and Wake
            end

            [SlowWaveEpochs, SlowWaveChan] = FindSlowWavesMultiChan(eeg_occipital, 'noiseepoch',NoiseEpoch, 'nb_channel',2);

            savefile = fullfile(FolderStimImpactPreprocess, 'SlowWaves2',['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
            save(savefile, 'SlowWaveEpochs', 'SlowWaveChan')

        catch
            disp('error')
        end
    
    %MultiChan with solo std threshold 
    elseif method==3
        try
            [eeg, ~, ~, StageEpochs, ~, ~] = GetRecordDreem(Dir.filename{p});
            [~, NoiseEpoch] = GetDreemQuality(Dir.filereference{p});
            eeg_occipital = eeg([1 2 5 6]);
            NoiseEpoch = [NoiseEpoch([1 2]) {intervalSet([],[])} {intervalSet([],[])}];

            for i=1:length(NoiseEpoch)
                NoiseEpoch{i} = or(or(NoiseEpoch{i},StageEpochs{4}), StageEpochs{5}); %exclude REM and Wake
            end
            
            [SlowWaveEpochs, SlowWaveChan] = FindSlowWavesMultiChan(eeg_occipital, 'noiseepoch',NoiseEpoch, 'nb_channel',2);

            savefile = fullfile(FolderStimImpactPreprocess, 'SlowWaves',['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
            save(savefile, 'SlowWaveEpochs', 'SlowWaveChan')
            
        catch
            disp('error')
        end
    end
    

    
end



