%% Parameters

% Common base parameters
PhaseVoltage = 3.0;

% Generate config
frequencies = 11;
phaseDurations = [0.01, 0.005];
burstDurations = [1.5];

configsByFreq = generate_stim_configs(frequencies, phaseDurations, burstDurations);

% Create directory if needed
folderPath = 'C:/OpenEphysData/1753';
savePath = fullfile(folderPath, 'configData.mat');
if ~exist(folderPath, 'dir')
    mkdir(folderPath);
end

% Build frequency string
if isscalar(frequencies)
    freqStr = sprintf('f%.1f', frequencies);
else
    freqStr = sprintf('f%.1f_to_%.1f', frequencies(1), frequencies(end));
end
freqStr = strrep(freqStr, '.', 'p');  % make MATLAB-variable-safe

% Add timestamp
timestamp = datestr(now, 'yyyymmdd_HHMMSS');
varName = sprintf('configs_%s_%s', freqStr, timestamp);

% Create struct
S.(varName) = configsByFreq;

% Check if file exists
if isfile(savePath)
    save(savePath, '-struct', 'S', '-append');
else
    save(savePath, '-struct', 'S');  % no -append on first save
end

fprintf('Saved configs as "%s" to:\n%s\n', varName, savePath);


%% Start communication
PulsePal('COM6');

%% Run all pulse train configurations across all frequencies and configs
for fIdx = 1:length(configsByFreq)
    targetFreq = configsByFreq(fIdx).Frequency;
    numConfigs = length(configsByFreq(fIdx).Configs);

    for configIndex = 1:numConfigs
        fprintf('\n=== Running freq %.2f Hz, config %d ===\n', targetFreq, configIndex);
        runPulsePalTrain(configsByFreq, targetFreq, configIndex, PhaseVoltage, 1);
        disp('>> Pausing for 10 seconds between configurations');
        pause(10)
    end
end
pause(10)

%% End communication
EndPulsePal;



% %% Parameters
% 
% % Common base parameters
% PhaseVoltage = 3.0;
% 
% frequencies = 9.5:-0.5:5.0;
% phaseDurations = [0.01, 0.005];
% burstDurations = [0.5, 1.0, 1.5];
% 
% configsByFreq = generate_stim_configs(frequencies, phaseDurations, burstDurations);
% 
% %% Start communication
% PulsePal('COM6');
% 
% %% Run all pulse train configurations
% for i = 1:length(configs)
%     fprintf('\n=== Running config %d ===\n', i);
%     runPulsePalTrain(configs(i), PhaseVoltage, 1);
%     disp('>> Pausing for 10 seconds between configurations');
%     pause(10)
% end
% 
% %% End communication
% EndPulsePal;
% 
