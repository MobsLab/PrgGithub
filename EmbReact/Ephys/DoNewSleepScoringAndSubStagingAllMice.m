clear all

Dir = PathForExperimentsEmbReact('BaselineSleep')

for mm = 16 :length(Dir.path)
    for ff = 1 : length(Dir.path{mm})
        cd(Dir.path{mm}{ff})
        
        
        %         SleepScoring_Accelero_OBgamma_UpdateOldFolders('recompute',1,'PlotFigure',1)
        if exist('SleepScoring_OBGamma.mat')>0
            try
                        disp(Dir.path{mm}{ff})
                %% Sleep event
                disp('getting sleep signals')
                CreateSleepSignals('recompute',0,'scoring','ob');
                close all
                
                %% Substages with bulb
                try,disp('getting sleep stages')
                    [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','ob');
                    save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
                    [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch,'verbose',0);
                    save('SleepSubstages', 'Epoch', 'NameEpoch')
                end
                
                %% Id figure 1
                disp('making ID fig1')
                MakeIDSleepData
                PlotIDSleepData
                saveas(1,'IDFig1.png')
                close all
                
                %% Id figure 2
                disp('making ID fig2')
                MakeIDSleepData2
                PlotIDSleepData2
                saveas(1,'IDFig2.png')
                close all
                disp('success')
            catch
                disp('fail')
            end
        end
    end
end