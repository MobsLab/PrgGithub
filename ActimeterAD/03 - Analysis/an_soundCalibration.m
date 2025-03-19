% SWExperiment_soundCalibration analysis
%   This script analyses data from a sound calibration. It plots the raw
%   signal in epochs near stimulations.
%
% developed for the ProjetSLEEPcontrol-Antoine project
% by antoine.delhomme@espci.fr
%

% Load data
acqID = 41;
channelID = 1;

a = Activity(acqID, channelID);

% Get stimulation timeStamps
evt_stimTimeStamps = a.timeStamps_evt(a.evts == a.SWc.EVT_SOUND_STIM);

% Informations
stimulationLength = 2;

% Extract signal near those events
windowSize_before = 1;
windowSize_after = 5;
postStimSignal = zeros((windowSize_after + windowSize_before) * a.sampleRate, length(evt_stimTimeStamps));
for eventID = 1:length(evt_stimTimeStamps)
    time_start = (evt_stimTimeStamps(eventID) - 1) * a.sampleRate + 1;
    time_end = (evt_stimTimeStamps(eventID) + windowSize_after) * a.sampleRate;
    
    if time_start <= 0
        continue
    elseif time_end >= length(a.data) - windowSize_after * a.sampleRate;
        continue
    end
    
    % Data are centered before being saved 
    postStimSignal(:, eventID) = a.data(time_start:time_end) - mean(a.data(time_start:time_end));
end

% Plot
figure, clf,

hold on;
title('Actimetry on sound trigger.');
for eventID = 1:length(evt_stimTimeStamps)
    plot([1:(windowSize_after + windowSize_before) * a.sampleRate] / a.sampleRate, eventID + postStimSignal(:, eventID));
    plot([1, 1 + stimulationLength], eventID - [0.5, 0.5], 'k', 'LineWidth', 4);
end

plot(windowSize_before * [1, 1], [0, length(evt_stimTimeStamps) + 1 ], '--', 'LineWidth', 1);

ylabel('signal (ua)');
xlabel('time (s)');

hold off;
