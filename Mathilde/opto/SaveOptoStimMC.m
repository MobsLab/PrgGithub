DirOpto_ChR = PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirOpto_Ctrl = PathForExperiments_Opto_MC('PFC_Control_20Hz');
% DirOpto_Ctrl = RestrictPathForExperiment(DirOpto_Ctrl,'nMice',[1179 1180 1181]);

DirOpto = MergePathForExperiment(DirOpto_ChR,DirOpto_Ctrl);


for i=1:length(DirOpto.path)
    cd(DirOpto.path{i}{1});
    if exist('SleepScoring_OBGamma.mat')
    load('SleepScoring_OBGamma.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise');
    else
        load('SleepScoring_Accelero.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise');
    end
    [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
    save('StimOpto_new.mat', 'Stim','StimREM','StimSWS','StimWake','Stimts')
    
    clear WakeWiNoise SWSEpochWiNoise REMEpochWiNoise Stim StimREM StimSWS StimWake Stimts
end