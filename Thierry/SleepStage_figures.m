
%%Detect spindles; ripples; delta
CreateSleepSignals('recompute',1,'scoring','ob');

%% Substages
[featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','ob');
save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
[Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
save('SleepSubstages', 'Epoch', 'NameEpoch')

%% Id figure 1
MakeIDSleepData('recompute',1)
PlotIDSleepData('scoring','ob')
saveas(1,'IDFig1.png')

%% Id figure 2
MakeIDSleepData2('scoring','ob','recompute',1)
PlotIDSleepData2
saveas(1,'IDFig2.png')

% [tSpindles, ~] = GetSpindles('foldernameP',cd,'area','PFCx'); 
% Range(tSpindles,'s')