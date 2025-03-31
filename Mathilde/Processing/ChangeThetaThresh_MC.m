

% DirCtrl=PathForExperiments_Opto_MC('SST_Sham_20Hz');
% DirOpto=PathForExperiments_Opto_MC('SST_Stim_20Hz');

DirCtrl=PathForExperiments_Opto_MC('sham_wake');
% DirOpto=PathForExperiments_Opto_MC('stim_wake');


for i=1:length(DirCtrl.path)
    cd(DirCtrl.path{i}{1});
    if exist('SleepScoring_OBGamma.mat')
    load('SleepScoring_OBGamma.mat');
    else
        load('SleepScoring_Accelero.mat')
    end
    
    
    
    
    %%%
    minduration=3;
    LowThetaEpochMC=thresholdIntervals(SmoothTheta,2.2,'Direction','Above'); %2
    LowThetaEpochMC = mergeCloseIntervals(LowThetaEpochMC, minduration*1E4);
    LowThetaEpochMC = dropShortIntervals(LowThetaEpochMC, minduration*1E4);
    
        if exist('SleepScoring_OBGamma.mat')

    save('SleepScoring_OBGamma','LowThetaEpochMC','-append')
        else
                save('SleepScoring_Accelero','LowThetaEpochMC','-append')

        end
    %%%
end