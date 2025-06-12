%% Visualize heart beats
% clear all
% BaseFileName = '/media/nas8-2/ProjectCardioSense/K1712/2025-05-05_14-19-25/Record Node 103/experiment2/recording5/continuous/OE_FPGA_Acquisition_Board-100.Rhythm Data-B/continuous'; % name of .dat
% channel = 7; % chaneel to load
% SetCurrentSession([BaseFileName '.xml'])
% dat = GetWideBandData(channel);
% LFP = tsd(dat(1:16:end,1)*1e4,dat(1:16:end,2));
% 
% FilEKG = FilterLFP(LFP,[10 200],1024);
% plot(Range(LFP,'s'),Data(FilEKG))

%% Load and filter LFP
% 5Hz
filename = '/media/nas8-2/ProjectCardioSense/K1712/2025-05-05_14-19-25/Record Node 103/experiment2/recording7/continuous/OE_FPGA_Acquisition_Board-100.Rhythm Data-B/continuous.dat';
% 6Hz
filename = '/media/nas8-2/ProjectCardioSense/K1712/2025-05-05_14-19-25/Record Node 103/experiment2/recording5/continuous/OE_FPGA_Acquisition_Board-100.Rhythm Data-B/continuous.dat';
% 8Hz
filename = '/media/nas8-2/ProjectCardioSense/K1712/2025-05-05_14-19-25/Record Node 103/experiment1/recording3/continuous/OE_FPGA_Acquisition_Board-100.Rhythm Data-B/continuous.dat';
% 10HZ
filename = '/media/nas8-2/ProjectCardioSense/K1712/2025-05-02_15-38-34/Record Node 103/experiment1/recording5/continuous/OE_FPGA_Acquisition_Board-100.Rhythm Data-B/continuous.dat';

nChannels = 24;       % From <STREAM> in the Open Ephys settings
samplingRate = 5000;  % From <STREAM sample_rate="5000.0">
channel = 8;

% Load binary data
dat = LoadBinary(filename, ...
    'nChannels', nChannels, ...
    'frequency', samplingRate, ...
    'channels', channel);

pulse = LoadBinary(filename, ...
    'nChannels', nChannels, ...
    'frequency', samplingRate, ...
    'channels', 20);

% Convert to time series object
timestamps = (0:length(dat)-1)' / samplingRate *1e4;
LFP = tsd(timestamps, dat);
STIM = tsd(timestamps, pulse);

% Filter between 10–200 Hz
FilEKG = FilterLFP(LFP, [10 200], samplingRate);

%% Plot with vertical stims showed

% Time vector
t = Range(STIM, 's');
stimData = Data(STIM);

% Condition: change to avoid hard code
% 5 and 6Hz
stimOn = (stimData + 10000) > -800;
% 8 Hz
stimOn = (stimData + 8800) > -900;
% 10 Hz
stimOn = (stimData + 11000) > -800;


% Find rising edges (stim ON times)
stimOn_diff = diff([0; stimOn]);
onsets = find(stimOn_diff == 1);

% Plot LFP
figure;
plot(t, Data(FilEKG), 'k', 'LineWidth', 3);
hold on;

% Plot vertical red bars at each onset time
for i = 1:length(onsets)
    x = t(onsets(i));
    % line([x x], [-1050, -850], 'Color', 'r', 'LineWidth', 3, 'LineStyle', '-');
    line([x x], [-1100, -900], 'Color', 'r', 'LineWidth', 3, 'LineStyle', '-');
end



% 5Hz
xlim([0.7, 2.9]);
% 6Hz
xlim([16.4, 18.6]);
% 8Hz
xlim([78.65, 80.85]);
% 10HZ
xlim([3.55, 5.75]);

ylim([-1100, 800])
ylim([-1150, 750])
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered LFP with Stim Onsets');
% legend({'Filtered LFP', 'Stim Onset'});
box off                          % Remove top and right box lines
set(gca, ...
    'TickDir', 'out', ...       % Ticks pointing outward
    'LineWidth', 2, ...
    'Box', 'off')               % Ensures no top/right axis lines

xlim([9, 13]);
ylim([-1150, 900])





%% Plot with line when stim on

% Get time vector and sampling rate
t = Range(STIM, 's');
dt = mean(diff(t));                      % Time step
stimData = Data(STIM);
stimOn = stimData + 10000 > -800;               % Logical: stim active

% Find transitions
stimOn_diff = diff([0; stimOn; 0]);
starts = find(stimOn_diff == 1);
ends = find(stimOn_diff == -1) - 1;

% Merge events closer than 300 ms
min_gap = 0.3;                          % 300 ms
merged_starts = [];
merged_ends = [];

i = 1;
while i <= length(starts)
    current_start = starts(i);
    current_end = ends(i);
    j = i + 1;
    while j <= length(starts) && (t(starts(j)) - t(current_end)) < min_gap
        current_end = ends(j);
        j = j + 1;
    end
    merged_starts(end+1) = current_start; %#ok<*SAGROW>
    merged_ends(end+1) = current_end;
    i = j;
end

% Create NaN array for plotting merged stim line
stimLine = nan(size(stimData));
for k = 1:length(merged_starts)
    stimLine(merged_starts(k):merged_ends(k)) = -1000;
end

% Plotting
figure;
plot(t, Data(FilEKG), 'k', 'LineWidth', 3);   % Filtered LFP
hold on;
plot(t, stimLine, 'r', 'LineWidth', 10);         % Flat red line for stim
xlim([16, 19]);
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered LFP with Merged Stim Periods');
% legend({'Filtered LFP', 'Stimulus ON'});

%% Old

% % Plot
figure;
plot(Range(LFP, 's'), Data(FilEKG));
hold on; 
plot(Range(LFP, 's'), Data(STIM)+11000);
xlim([17,20])
% 
% figure;
% plot(Range(LFP, 's'), Data(FilEKG), 'k', 'LineWidth', 1.5);  % Black line, thicker
% hold on;
% plot(Range(LFP, 's'), Data(STIM) + 10000, 'r');  % Optional: specify color for STIM
% xlim([17, 20]);
% xlabel('Time (s)');
% ylabel('Amplitude');
% title('Filtered LFP and Stimulus');
% legend({'Filtered LFP', 'Stimulus'});
% 
% xlabel('Time (s)');
% ylabel('Filtered Signal');
% title('LFP Channel 7');



% % Get time vector
% t = Range(LFP, 's');
% stimData = Data(STIM);
% 
% % Define threshold for when stim is ON (e.g., below -500)
% stimOn = stimData + 10000 > -800;
% 
% % Create flat line at -1000 where stim is ON, NaN elsewhere (so it doesn't plot)
% stimLine = nan(size(stimData));
% stimLine(stimOn) = -1000;
% 
% % Plot
% figure;
% plot(t, Data(FilEKG), 'k', 'LineWidth', 1.5);  % LFP in black
% hold on;
% plot(t, stimLine, 'r', 'LineWidth', 2);  % Flat line for STIM ON
% xlim([17, 20]);
% xlabel('Time (s)');
% ylabel('Amplitude');
% title('Filtered LFP with STIM Periods');
% legend({'Filtered LFP', 'Stimulus ON'});