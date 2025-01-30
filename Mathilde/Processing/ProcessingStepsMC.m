%% sleep scoring

%%
SleepScoring_Accelero_OBgamma('recompute',1,'continuity',1);
SleepScoring_Accelero_OBgamma_newgamma('recompute',1,'continuity',1);
%%
PreInjectionEpoch = intervalSet(0, 1.4e8);
SleepScoring_Accelero_OBgamma('continuity',1,'controlepoch',PreInjectionEpoch);

%% Detect spindles; ripples; delta
CreateSleepSignals('recompute',1,'scoring','accelero');

%% Substages
[featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','accelero');
save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
[Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch,'burstis3',1,'removesi',0);
save('SleepSubstages', 'Epoch', 'NameEpoch')

%% global figures
% Id figure 1
MakeIDSleepData('recompute',0)
PlotIDSleepData('scoring','ob')
saveas(1,'IDFig1.png')

% Id figure 2
MakeIDSleepData2('scoring','ob')
PlotIDSleepData2
saveas(1,'IDFig2.png')









%% MANIP OPTO
CreateSleepSignals_OptoMice_MC('recompute',1,'scoring','ob');

%%
[featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures_ForOptoMice_MC('scoring','ob');
save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
[Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch,'burstis3',1,'removesi',0);
save('SleepSubstages', 'Epoch', 'NameEpoch')
