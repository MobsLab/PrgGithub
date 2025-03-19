% Sleep scoring
SleepScoring_Accelero_OBgamma('recompute',1), close all

% Heart rate
MakeHeartRateForSession_BM

% InstFreq
MakeInstFreqForSession_BM

% Spectrograms
MakeSpectrogramsForSession_BM

% Find injection time
FindInjectionTime_BM

% Find ripples
CreateRipplesSleep('restrict',1)


%% Sleep event
disp('getting sleep signals')
CreateSleepSignals('recompute',0,'scoring','ob','rip',0);

%% Substages
disp('getting sleep stages')
[featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures;
save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
[Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
save('SleepSubstages', 'Epoch', 'NameEpoch')

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




