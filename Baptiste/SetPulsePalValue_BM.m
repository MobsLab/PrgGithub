
addpath(genpath('/home/mobs/Dropbox/Kteam/PrgMatlab'))

PulsePal_BM
% press enter

% set basic features of stim
ProgramPulsePalParam(1,'IsBiphasic',1);
ProgramPulsePalParam(1,'Phase1Voltage', 0);
ProgramPulsePalParam(1,'Phase1Duration', 2e-4);
ProgramPulsePalParam(1,'InterPhaseInterval', 1e-4);
ProgramPulsePalParam(1,'Phase2Voltage', 0);
ProgramPulsePalParam(1,'Phase2Duration', 2e-4);
ProgramPulsePalParam(1,'InterPulseInterval', 1e-3);
ProgramPulsePalParam(1,'BurstDuration', 0.1);
ProgramPulsePalParam(1,'InterBurstInterval', 0);
ProgramPulsePalParam(1,'PulseTrainDelay', 0);
ProgramPulsePalParam(1,'PulseTrainDuration', 5e-4);
ProgramPulsePalParam(1,'LinkTriggerChannel1', 1);
ProgramPulsePalParam(1,'LinkTriggerChannel2', 0);
ProgramPulsePalParam(1,'RestingVoltage', 0);
ProgramPulsePalParam(1,'TriggerMode', 0);


% differents voltages, choose one
x = 0;
x = .5;
x = 1;
x = 1.5;
x = 2;
x = 2.5;
x = 3;
x = 3.5;
x = 4;
x = 5;
x = 6;
x = 7;
x = 8;
x = 9;
x = 10;



% apply your voltage

ProgramPulsePalParam(1,'Phase1Voltage', x);
ProgramPulsePalParam(1,'Phase2Voltage', -x);




