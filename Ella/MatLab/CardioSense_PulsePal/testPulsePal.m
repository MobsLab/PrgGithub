%% Set Parameters

PhaseVoltage = 3.0;

% 10Hz 10ms pulse
PhaseDuration10 = 0.01;
InterPulseInterval10 = 0.09;

% 10Hz 5ms pulse
PhaseDuration5 = 0.005;
InterPulseInterval5 = 0.095;

% write down other parameters

%% Start communication with Pulse Pal

% PulsePalGUI()
PulsePal('COM6')

%% 

ProgramPulsePalParam(1, 'Phase1Voltage', PhaseVoltage); 
ProgramPulsePalParam(1, 'Phase1Duration', PhaseDuration10); 
ProgramPulsePalParam(1, 'InterPulseInterval', InterPulseInterval10); 
ProgramPulsePalParam(1, 'BurstDuration', 0.5); 
ProgramPulsePalParam(1, 'InterBurstInterval', 4.5); 
ProgramPulsePalParam(1, 'PulseTrainDuration', 75); 
ProgramPulsePalParam(1, 'PulseTrainDelay', 0);
ProgramPulsePalParam(1, 'TriggerMode', 1);

TriggerPulsePal(1)
PulsePalDisplay('Finished')


%% 

ProgramPulsePalParam(1, 'Phase1Voltage', PhaseVoltage); 
ProgramPulsePalParam(1, 'Phase1Duration', PhaseDuration5); 
ProgramPulsePalParam(1, 'InterPulseInterval', InterPulseInterval5); 
ProgramPulsePalParam(1, 'BurstDuration', 0.5); 
ProgramPulsePalParam(1, 'InterBurstInterval', 4.5); 
ProgramPulsePalParam(1, 'PulseTrainDuration', 75); 
ProgramPulsePalParam(1, 'PulseTrainDelay', 0);
ProgramPulsePalParam(1, 'TriggerMode', 1);

TriggerPulsePal(1)
PulsePalDisplay('Finished')

%%

ProgramPulsePalParam(1, 'Phase1Voltage', PhaseVoltage); 
ProgramPulsePalParam(1, 'Phase1Duration', PhaseDuration10); 
ProgramPulsePalParam(1, 'InterPulseInterval', InterPulseInterval10); 
ProgramPulsePalParam(1, 'BurstDuration', 1); 
ProgramPulsePalParam(1, 'InterBurstInterval', 5); 
ProgramPulsePalParam(1, 'PulseTrainDuration', 90); 
ProgramPulsePalParam(1, 'PulseTrainDelay', 0);
ProgramPulsePalParam(1, 'TriggerMode', 1);

TriggerPulsePal(1)
PulsePalDisplay('Finished')

%%

ProgramPulsePalParam(1, 'Phase1Voltage', PhaseVoltage); 
ProgramPulsePalParam(1, 'Phase1Duration', PhaseDuration5); 
ProgramPulsePalParam(1, 'InterPulseInterval', InterPulseInterval5); 
ProgramPulsePalParam(1, 'BurstDuration', 1); 
ProgramPulsePalParam(1, 'InterBurstInterval', 5); 
ProgramPulsePalParam(1, 'PulseTrainDuration', 90); 
ProgramPulsePalParam(1, 'PulseTrainDelay', 0);
ProgramPulsePalParam(1, 'TriggerMode', 1);

TriggerPulsePal(1)
PulsePalDisplay('Finished')

%%

ProgramPulsePalParam(1, 'Phase1Voltage', PhaseVoltage); 
ProgramPulsePalParam(1, 'Phase1Duration', PhaseDuration10); 
ProgramPulsePalParam(1, 'InterPulseInterval', InterPulseInterval10); 
ProgramPulsePalParam(1, 'BurstDuration', 1.5); 
ProgramPulsePalParam(1, 'InterBurstInterval', 5.5); 
ProgramPulsePalParam(1, 'PulseTrainDuration', 105); 
ProgramPulsePalParam(1, 'PulseTrainDelay', 0);
ProgramPulsePalParam(1, 'TriggerMode', 1);

TriggerPulsePal(1)
PulsePalDisplay('Finished')

%%

ProgramPulsePalParam(1, 'Phase1Voltage', PhaseVoltage); 
ProgramPulsePalParam(1, 'Phase1Duration', PhaseDuration5); 
ProgramPulsePalParam(1, 'InterPulseInterval', InterPulseInterval5); 
ProgramPulsePalParam(1, 'BurstDuration', 1.5); 
ProgramPulsePalParam(1, 'InterBurstInterval', 5.5); 
ProgramPulsePalParam(1, 'PulseTrainDuration', 105); 
ProgramPulsePalParam(1, 'PulseTrainDelay', 0);
ProgramPulsePalParam(1, 'TriggerMode', 1);

TriggerPulsePal(1)
PulsePalDisplay('Finished')


%% End Communication

EndPulsePal
