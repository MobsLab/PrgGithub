Dur = 0.2;
DurPause = 30;

Voltage = [ones(1,10)*0.5,ones(1,10)*1,ones(1,10)*2,ones(1,10)*3,ones(1,10)*4];
Voltage(randperm(length(Voltage)));

%% Parameters for the sync channel (1)
ProgramPulsePalParam(1, 'Phase1Voltage', 3.3); %voltage ch1
ProgramPulsePalParam(1, 'Phase2Voltage', 0); %voltage ch1
ProgramPulsePalParam(1, 'IsBiphasic', 0);
ProgramPulsePalParam(1, 'Phase1Duration', 0.002); %duree 2ms
ProgramPulsePalParam(1, 'Phase2Duration', 0.002); %duree 2ms
ProgramPulsePalParam(1,'PulseTrainDuration',0.002);

%% Parameters for the stim channel (2)
ProgramPulsePalParam(2, 'Phase1Duration', Dur/2); %duree ch2
ProgramPulsePalParam(2, 'Phase2Duration', Dur/2); %duree ch2
ProgramPulsePalParam(2, 'IsBiphasic', 1);
ProgramPulsePalParam(2,'PulseTrainDuration',Dur);

for t = 1:length(Voltage)
ProgramPulsePalParam(2, 'Phase1Voltage', Voltage(t)); %voltage ch2
ProgramPulsePalParam(2, 'Phase2Voltage', -Voltage(t)); %voltage ch1

TriggerPulsePal(1,2)
pause(DurPause)
end

ProgramPulsePalParam(3, 'Phase1Voltage', 5); %voltage ch1
ProgramPulsePalParam(3, 'Phase2Voltage', 0); %voltage ch1
ProgramPulsePalParam(3, 'IsBiphasic', 0);
ProgramPulsePalParam(3, 'Phase1Duration', 0.200); %duree 2ms
ProgramPulsePalParam(3, 'Phase2Duration', 0.002); %duree 2ms
ProgramPulsePalParam(3,'PulseTrainDuration',0.200);
