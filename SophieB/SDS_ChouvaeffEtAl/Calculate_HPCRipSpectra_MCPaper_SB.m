clear all
Cols = {'k','r'};
%%1
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);
for mm = 1:length(Dir_ctrl.path)
    enregistrements{1}{mm} = Dir_ctrl.path{mm}{1};
end

%%3
DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_mCherry_saline = MergePathForExperiment(DirSocialDefeat_mCherry_saline1,DirSocialDefeat_BM_saline1);
DirSocialDefeat_classic = MergePathForExperiment(DirSocialDefeat_classic1,DirSocialDefeat_mCherry_saline);

for mm = 1:length(DirSocialDefeat_classic.path)
    enregistrements{2}{mm} = DirSocialDefeat_classic.path{mm}{1};
end

for grp = 1:2
    for mm = 1:length(enregistrements{grp})
        cd(enregistrements{grp}{mm})
        mm
        % load SeepScoring
        load('SleepScoring_Accelero.mat','REMEpoch','Wake','SWSEpoch')
        % Restrict to the same duration for everyone
        Epoch = intervalSet(0*3600*1e4,7.5*3600*1e4);
        Wake = and(Wake,Epoch);
        REMEpoch = and(REMEpoch,Epoch);
        SWSEpoch = and(SWSEpoch,Epoch);
        
        clear Spectro
        
        if exist('ChannelsToAnalyse/dHPC_rip.mat')
            load('ChannelsToAnalyse/dHPC_rip.mat')
            load('H_Low_Spectrum.mat', 'ch')
            LowSpectrumSB(cd,ch,'dHPC_rip')
        end
        
    end
end
    
    
