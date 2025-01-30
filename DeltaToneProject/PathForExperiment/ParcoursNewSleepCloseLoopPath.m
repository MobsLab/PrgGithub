%ParcoursNewSleepCloseLoopPath
%


Dir=PathForExperimentsDeltaCloseLoop('all');

for p=83:length(Dir.path)
%     disp(' ')
%     disp('****************************************************************')
    cd(Dir.path{p})
%     disp(pwd)
%     disp(Dir.manipe{p})
    
    clearvars -except Dir p

    
%     load('behavResources.mat', 'ToneEvent')
%     if ~exist('ToneEvent','var') && ~strcmpi(Dir.manipe{p},'basal')
%         disp('****************************************************************')
%         disp(pwd)
%         disp('ToneEvent missing')
%     end
%

%     
%     load('DeltaWaves.mat', 'deltas_PFCx')
%     if ~exist('deltas_PFCx','var')
%         disp('****************************************************************')
%         disp(pwd)
%         disp('deltas_PFCx missing')
%     end
%     
    
%     %% Sound
%     try
%         load('behavResources.mat', 'ToneEvent')
%         ToneEvent;
%     catch
%          disp('missing ToneEvent')
%     end

% 
%     %% SleepScoring
%     if exist('SleepScoring_OBGamma.mat','file')==2
%         disp('ok new sleep scoring')
%     elseif exist('StateEpochSB.mat','file')==2
%         load('StateEpochSB.mat', 'SWSEpoch','Wake','REMEpoch','TotalNoiseEpoch','Sleep','ThetaEpoch')
%         save('SleepScoring_OBGamma.mat', 'SWSEpoch','Wake','REMEpoch','TotalNoiseEpoch','Sleep','ThetaEpoch')
%     else
%         disp('missing sleep scoring')
%     end
%     


%     %% Signals
%     try
%         CreateSleepSignals('recompute',0,'scoring','ob');
%     catch
%          disp('error with sleep signals')
%     end
%     
    %% Signals SleepSubstages
    try
        if exist('SleepSubstages.mat','file')~=2
            [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','ob');
            save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
            [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
            save('SleepSubstages', 'Epoch', 'NameEpoch')
        end
    catch
        disp('problem with substages')
    end
        
%     
%     %% ID sleep data
%     try
%         MakeIDSleepData;
%     catch
%          disp('error SLEEP DATA 1')
%     end
%     
%     try
%         MakeIDSleepData2;
%     catch
%          disp('error SLEEP DATA 2')
%     end
    
end