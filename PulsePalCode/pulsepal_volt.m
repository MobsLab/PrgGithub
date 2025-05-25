function pulsepal_volt(v)            

ProgramPulsePalParam(1,'IsBiphasic',1);
ProgramPulsePalParam(1,'Phase1Voltage', v);
ProgramPulsePalParam(1,'Phase1Duration', 0.0005);
ProgramPulsePalParam(1,'InterPhaseInterval', 0);
ProgramPulsePalParam(1,'Phase2Voltage', -v);
ProgramPulsePalParam(1,'Phase2Duration', 0.0005);
ProgramPulsePalParam(1,'InterPulseInterval', 0.0071);
ProgramPulsePalParam(1,'BurstDuration', 0.1);
ProgramPulsePalParam(1,'InterBurstInterval', 0);
ProgramPulsePalParam(1,'PulseTrainDelay', 0);
ProgramPulsePalParam(1,'PulseTrainDuration', 0.1);
ProgramPulsePalParam(1,'LinkTriggerChannel1', 1);
ProgramPulsePalParam(1,'LinkTriggerChannel2', 0);
ProgramPulsePalParam(1,'RestingVoltage', 0);
ProgramPulsePalParam(1,'TriggerMode', 0);

ProgramPulsePalParam(2,'IsBiphasic',1);
ProgramPulsePalParam(2,'Phase1Voltage', v);
ProgramPulsePalParam(2,'Phase1Duration', 0.0005);
ProgramPulsePalParam(2,'InterPhaseInterval', 0);
ProgramPulsePalParam(2,'Phase2Voltage', -v);
ProgramPulsePalParam(2,'Phase2Duration', 0.0005);
ProgramPulsePalParam(2,'InterPulseInterval', 0.0071);
ProgramPulsePalParam(2,'BurstDuration', 0.1);
ProgramPulsePalParam(2,'InterBurstInterval', 0);
ProgramPulsePalParam(2,'PulseTrainDelay', 0);
ProgramPulsePalParam(2,'PulseTrainDuration', 0.1);
ProgramPulsePalParam(2,'LinkTriggerChannel1', 0);
ProgramPulsePalParam(2,'LinkTriggerChannel2', 1);
ProgramPulsePalParam(2,'RestingVoltage', 0);
ProgramPulsePalParam(2,'TriggerMode', 0);


ProgramPulsePalParam(3,'LinkTriggerChannel1', 0);
ProgramPulsePalParam(3,'LinkTriggerChannel2', 0);
ProgramPulsePalParam(4,'LinkTriggerChannel1', 0);
ProgramPulsePalParam(4,'LinkTriggerChannel2', 0);
end