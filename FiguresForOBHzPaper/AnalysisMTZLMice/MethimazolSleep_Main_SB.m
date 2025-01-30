Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');

%% Detect breathing
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        movefile('BreathingInfo_ZeroCross.mat','BreathingInfo_ZeroCrossOld.mat')d
        GetBreathingInfoZeroCross_SB
    end
end

%% Get neuron locking
LockingToRespiPlethysmo_SleepSession

%% Get accelero events and breathing locking + neuron response
AllMtzlMiceCOuplingBreathingAccelero_SB

%% Trigger Accelero on breathing
TriggerAllAcceleroChannelsOnBreathing_MTZL_SB

%% PredictPhaseFromMovementaAndBreathingReset
PredictPhaseFromMove_MTZL_SB