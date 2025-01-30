
%%Detect spindles; ripples; delta
CreateSleepSignals('recompute',0,'scoring','ob');

%% Substages
[featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','ob');
save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
[Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
save('SleepSubstages', 'Epoch', 'NameEpoch')

%% Id figure 1
MakeIDSleepData('recompute',0)
PlotIDSleepData('scoring','ob')
saveas(1,'IDFig1.png')

%% Id figure 2
MakeIDSleepData2('scoring','ob')
PlotIDSleepData2
saveas(1,'IDFig2.png')

% [tSpindles, ~] = GetSpindles('foldername',cd,'area','PFCx'); 
% Range(tSpindles,'s')