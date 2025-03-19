

DirSocialDefeat_sleep = PathForExperimentsSD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO');
% DirSocialDefeat_sleep = RestrictPathForExperiment(DirSocialDefeat_sleep, 'nMice', [1148 1149 1150 1217 1218 1219 1220]);

Dir = DirSocialDefeat_sleep;

%% Parameters
thtps_immob=2;
th_immob = 20;

%% Do the job
for i=1:length(Dir.path)
    DirCur=Dir.path{i}{1};
    
    cd(DirCur);
    
    load('behavResources.mat');
    
    if exist('Imdifftsd')>0
        FreezeCamEpoch = thresholdIntervals(Imdifftsd, th_immob, 'Direction', 'Below');
        FreezeCamEpoch = mergeCloseIntervals(FreezeCamEpoch, 0.3*1E4);
        FreezeCamEpoch = dropShortIntervals(FreezeCamEpoch, thtps_immob*1E4);
  
        save ('behavResources.mat', 'FreezeCamEpoch', 'thtps_immob', 'th_immob',  '-append');
    end
    clearvars -except Dir thtps_immob th_immob
end
