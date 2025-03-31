
DirCtrl=PathForExperiments_Opto_MC('SST_Sham_20Hz');
DirOpto=PathForExperiments_Opto_MC('SST_Stim_20Hz');


%% get data
number=1;
for i=1:length(DirCtrl.path)
    cd(DirCtrl.path{i}{1});
    if exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    else
        a{i} = load('SleepScoring_Accelero.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    end
    
    REMDurationBeforeStim_ctrl{i} = GetDurationBetweenStimStartAndStartOfPreviousEpisode_MC(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise,'rem',5);
    
    for ii=1:length(REMDurationBeforeStim_ctrl)
        av_REMDurationBeforeStim_ctrl(ii,:)=nanmean(nanmean(REMDurationBeforeStim_ctrl{ii}));
    end
end


%%
number=1;
for j=1:length(DirOpto.path)
    cd(DirOpto.path{j}{1});
    if exist('SleepScoring_OBGamma.mat')
        b{j} = load('SleepScoring_OBGamma.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    else
        b{j} = load('SleepScoring_Accelero.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    end
    
    REMDurationBeforeStim_opto{j} = GetDurationBetweenStimStartAndStartOfPreviousEpisode_MC(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise,'rem',5);
    
    for jj=1:length(REMDurationBeforeStim_opto)
        av_REMDurationBeforeStim_opto(jj,:)=nanmean(nanmean(REMDurationBeforeStim_opto{jj}));
    end
end