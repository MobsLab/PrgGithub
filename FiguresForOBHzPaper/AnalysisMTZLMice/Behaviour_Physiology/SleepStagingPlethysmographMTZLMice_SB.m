Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');

for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        load('SpikeData.mat')
        try
            load('SleepSubstages.mat')
        catch
            
            if exist('SleepScoring_Accelero.mat')==0
                disp('sleepscoring')
                SleepScoringAccelerometer
            end
            
            disp('spiike classif')
            CreateSpikeToAnalyse_KJ
            load('MeanWaveform.mat')
            [UnitID,AllParamsNew,WFInfo,BestElec,figid] = MakeData_ClassifySpikeWaveforms(W,'/home/vador/Dropbox/Kteam',1,'recompute',1)  
            
            disp('sleep events')
            %% Sleep event
            CreateSleepSignals('recompute',0,'scoring','accelero');
            
            disp('substages')
            %% Substages
            [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','accelero');
            save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
            [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
            save('SleepSubstages', 'Epoch', 'NameEpoch')
            
            %% Id figure 1
            MakeIDSleepData('recompute',1)
            PlotIDSleepData('scoring','accelero')
            saveas(1,'IDFig1.png')
            close all
            
            %% Id figure 2
            MakeIDSleepData2('scoring','accelero','recompute',1)
            PlotIDSleepData2('recompute',1)
            saveas(1,'IDFig2.png')
            close all
        end
    end
end