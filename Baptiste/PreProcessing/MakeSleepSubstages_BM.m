



clear all
cd('/home/mobsmorty/Dropbox/Kteam/PrgMatlab/Baptiste')
load('Sess.mat','Sess')

%% Mean OB Spectrum
Mouse=[561 566 567 568 569];

for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    AllSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

for mouse = 1:length(Mouse) % generate all sessions of interest
    for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
        
        cd(AllSleepSess.(Mouse_names{mouse}){sleep_sess})
        
        
        disp('Detecting sleep events')
        disp(' ')
        CreateSleepSignals('recompute',1,'scoring','ob','stim',0, 'down',0,'delta',1,'rip',0,'spindle',0,'ripthresh',0);
        close
        
        %% Substages
        if exist('SleepSubstages.mat') == 0
            disp('getting sleep stages')
            [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures;
            save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch')
            [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
            save('SleepSubstages', 'Epoch', 'NameEpoch')
        end
        
    end
end










channel = 11;
save('ChannelsToAnalyse/dHPC_rip.mat','channel');



















