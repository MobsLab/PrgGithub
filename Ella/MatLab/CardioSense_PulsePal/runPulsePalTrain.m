function runPulsePalTrain(configsByFreq, targetFreq, configIndex, phaseVoltage, channel)
    % Default arguments
    if nargin < 5
        channel = 1;
    end
    if nargin < 4
        phaseVoltage = 3;  % default voltage
    end

    % Find the struct for the given frequency
    freqIdx = find([configsByFreq.Frequency] == targetFreq, 1);
    if isempty(freqIdx)
        error('Frequency %.2f Hz not found in configsByFreq.', targetFreq);
    end

    configs = configsByFreq(freqIdx).Configs;

    if configIndex < 1 || configIndex > length(configs)
        error('configIndex %d out of range for frequency %.2f Hz (1-%d)', ...
            configIndex, targetFreq, length(configs));
    end

    cfg = configs(configIndex);

    % Display config details
    fprintf('\n>> Ready to run Pulse Pal train for frequency %.2f Hz, config #%d on channel %d:\n', ...
        targetFreq, configIndex, channel);
    disp(cfg);

    % Prompt user
    answer = input('Type "y" to trigger, or type "n" to skip: ', 's');
    if ~strcmpi(answer, 'y')
        disp('>> Skipped.');
        return;
    end

    % Program Pulse Pal parameters
    ProgramPulsePalParam(channel, 'Phase1Voltage', phaseVoltage);
    ProgramPulsePalParam(channel, 'Phase1Duration', cfg.PhaseDuration);
    ProgramPulsePalParam(channel, 'InterPulseInterval', cfg.InterPulseInterval);
    ProgramPulsePalParam(channel, 'BurstDuration', cfg.BurstDuration);
    ProgramPulsePalParam(channel, 'InterBurstInterval', cfg.InterBurstInterval);
    ProgramPulsePalParam(channel, 'PulseTrainDuration', cfg.PulseTrainDuration);
    ProgramPulsePalParam(channel, 'PulseTrainDelay', 0);
    ProgramPulsePalParam(channel, 'TriggerMode', 1);  % Normal trigger

    % Trigger
    disp('>> Triggering Pulse Pal...');
    TriggerPulsePal(channel);

    % Wait for train duration
    pause(cfg.PulseTrainDuration);
    disp('>> Pulse Pal train complete.');
end







% function runPulsePalTrain(cfg, phaseVoltage, channel)
%     if nargin < 3
%         channel = 1;
%     end
% 
%     % Display configuration details
%     fprintf('\n>> Ready to run the following Pulse Pal configuration on channel %d:\n', channel);
%     disp(cfg);
% 
%     % Prompt for "y" to trigger, "n" to skip
%     answer = input('Type "y" to trigger, or type "n" to skip: ', 's');
%     if ~strcmpi(answer, 'y')
%         disp('>> Skipped.');
%         return;
%     end
% 
%     % Program parameters
%     ProgramPulsePalParam(channel, 'Phase1Voltage', phaseVoltage); 
%     ProgramPulsePalParam(channel, 'Phase1Duration', cfg.PhaseDuration); 
%     ProgramPulsePalParam(channel, 'InterPulseInterval', cfg.InterPulseInterval); 
%     ProgramPulsePalParam(channel, 'BurstDuration', cfg.BurstDuration); 
%     ProgramPulsePalParam(channel, 'InterBurstInterval', cfg.InterBurstInterval); 
%     ProgramPulsePalParam(channel, 'PulseTrainDuration', cfg.PulseTrainDuration); 
%     ProgramPulsePalParam(channel, 'PulseTrainDelay', 0);
%     ProgramPulsePalParam(channel, 'TriggerMode', 1);  % Normal trigger
% 
%     % Trigger
%     disp('>> Triggering Pulse Pal...');
%     TriggerPulsePal(channel);
% 
%     % Wait for train duration
%     pause(cfg.PulseTrainDuration);
%     disp('>> Pulse Pal train complete.');
% end
