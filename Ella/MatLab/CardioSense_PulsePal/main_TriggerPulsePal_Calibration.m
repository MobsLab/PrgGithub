%% Parameters

% Common base parameters
PhaseVoltage = 3.0;

% Define configurations

% 10Hz for a fixed intensity
configs = [
    struct('PhaseDuration', 0.01, 'InterPulseInterval', 0.09, 'BurstDuration', 0.5,  'InterBurstInterval', 4.5, 'PulseTrainDuration', 75);
    struct('PhaseDuration', 0.005,'InterPulseInterval', 0.095,'BurstDuration', 0.5,  'InterBurstInterval', 4.5, 'PulseTrainDuration', 75);
    struct('PhaseDuration', 0.01, 'InterPulseInterval', 0.09, 'BurstDuration', 1.0,  'InterBurstInterval', 5.0, 'PulseTrainDuration', 90);
    struct('PhaseDuration', 0.005,'InterPulseInterval', 0.095,'BurstDuration', 1.0,  'InterBurstInterval', 5.0, 'PulseTrainDuration', 90);
    struct('PhaseDuration', 0.01, 'InterPulseInterval', 0.09, 'BurstDuration', 1.5,  'InterBurstInterval', 5.5, 'PulseTrainDuration', 105);
    struct('PhaseDuration', 0.005,'InterPulseInterval', 0.095,'BurstDuration', 1.5,  'InterBurstInterval', 5.5, 'PulseTrainDuration', 105);
];

% write other configurations

%% Start communication
PulsePal('COM6');

%% Run all pulse train configurations
for i = 1:length(configs)
    fprintf('\n=== Running config %d ===\n', i);
    runPulsePalTrain(configs(i), PhaseVoltage, 1);
end

%% End communication
EndPulsePal;

