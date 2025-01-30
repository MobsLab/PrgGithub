cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')


for sess = 1:length(Sess.(Mouse_names{1}))
    cd(Sess.(Mouse_names{1}){sess})
    disp(Sess.(Mouse_names{1}){sess})
    if contains(Sess.(Mouse_names{1}){sess},'Sleep')
        clear SWSEpoch SWSEpochAcc
        load('StateEpochSB.mat','SWSEpoch','SWSEpochAcc','Wake','WakeAcc','Sleep','REMEpoch')
        load('behavResources_SB.mat','Behav')
        try
            SWSEpoch
        catch
            BulbSleepScript
        end
        try
            SWSEpochAcc
        catch
            SleepScoringAccelerometer_UseOBNoise_CH
        end
        load('StateEpochSB.mat')
        Behav.FreezeAccEpoch = Behav.FreezeAccEpoch - REMEpoch - SWSEpoch;
        Behav.FreezeEpoch = Behav.FreezeEpoch - REMEpoch - SWSEpoch;
        save('behavResources_SB.mat','Behav','-append')
    end
end












