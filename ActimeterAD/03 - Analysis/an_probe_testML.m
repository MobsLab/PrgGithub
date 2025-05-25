function [sleepWakeDuration,deltaT_sleepToWakeHist,deltaT_wakeToSleepHist,deltaTs,deltaTMax_true,evt_stimTimeStamps,...
    a]=an_probe_testML(acqID,channelIDs,simulateStim,deltaTMax_true,deltaTMax)

    
%   This scritp do some offline analyses to quantify the effect of the
%   conditionning. It is typically applied on data acquired with
%   SWExperiment_sleepTest().
%
%   This script may also be used to simulate a probe test on basal data.
%   The simulateStim flag has just to be true.
%
% developed for the ProjetSLEEPcontrol-Antoine project
% by antoine.delhomme@espci.fr
%

%% Set parameters of the quantification

% acqID:            ID of the acquisition
% channelIDs:       channels included in the analysis
% simulateStim:     set to true to simulate stimulations. This may be used
%                   to pass a probe test on basal data.

if ~exist('acqID','var')
   acqID = 69;
end

if ~exist('channelIDs','var')
    channelIDs = 1:12;
end

if ~exist('simulateStim','var')
    simulateStim = false; % default : false, for simulation: true
end

% deltaTMax_true:   events occuring more than deltaTMax_true seconds after
%                   a stimulation are not considered caused by the
%                   stimulation.
% deltaTMax:        events occuring more than deltaTMax seconds after a
%                   stimulation are stacked together in the analysis.

if ~exist('deltaTMax_true','var')
    deltaTMax_true = 30;
end

if ~exist('deltaTMax','var')
    deltaTMax = 100;
end

% Time limit: events after this time will be ignored. This permits to crop
% an acquistion that lasts after 8 pm.
timeLimit = 8.5*3600;

%%  Do the quantification

% Init matrix of data
deltaTs = 0:5:(deltaTMax+5);
deltaT_wakeToSleepHist = zeros(length(deltaTs), length(channelIDs));
deltaT_sleepToWakeHist = zeros(length(deltaTs), length(channelIDs));
sleepWakeDuration = zeros(2, length(channelIDs));

for channelID = channelIDs

    %% Load data
    try
        a = Activity_linux(acqID, channelID);
    catch
        a = Activity(acqID, channelID);
    end
    
    % Update the timelimit
    timeLimit = min(timeLimit, length(a.activity));

    % Get the sleep scoring (smoothed scoring with corrected beginning and
    % ending of events.
    [sleepScoring, timeStamps] = a.computeSleepScoring();

    
    %% Do the quantification

    if simulateStim
        fprintf('Simulate a probe test.\n');
        evt_stimTimeStamps = getStimulationAsAProbeTest(sleepScoring, a.activity, timeStamps, a.SWc);
    else
        % Get timestamps of triggered sounds
        evt_stimTimeStamps = a.timeStamps_evt(a.evts == a.SWc.EVT_SOUND_STIM);
    end

    % Init the list of delta t between stimulations and wake to sleep
    % transitions
    deltaT_wakeToSleep = nan(1, length(evt_stimTimeStamps));

    % Init the list of delta t between stimulation and sleep to wake
    % transitions
    deltaT_sleepToWake = nan(1, length(evt_stimTimeStamps));

    for evtID = 1:length(evt_stimTimeStamps)
        % From this event ...
        timeStamp_start = evt_stimTimeStamps(evtID);
        timeStamp_end = timeStamp_start + deltaTMax;
        
        % See if the event is after the time limit
        if timeStamp_start >= timeLimit * a.sampleRate
            break;
        end

        if sleepScoring(timeStamp_start) == a.SWc.IS_AWAKE
            % ... find the nearest wake to sleep transition
            if timeStamp_end <= length(sleepScoring)
                deltaT = find(sleepScoring(timeStamp_start:timeStamp_end) == a.SWc.IS_SLEEPING, 1);
            else
                deltaT = find(sleepScoring(timeStamp_start:end) == a.SWc.IS_SLEEPING, 1);
            end

            if ~isempty(deltaT)
                % A transition is found, save its delta t
                deltaT_wakeToSleep(evtID) = deltaT;
            else
                % No transition is found, nevertheless, save a conventional
                % delta t.
                deltaT_wakeToSleep(evtID) = deltaTMax + 5;
            end

        elseif sleepScoring(timeStamp_start) == a.SWc.IS_SLEEPING
            % ... and the nearest sleep to wake transition
            if timeStamp_end <= length(sleepScoring)
                deltaT = find(sleepScoring(timeStamp_start:timeStamp_end) == a.SWc.IS_AWAKE, 1);
            else
                deltaT = find(sleepScoring(timeStamp_start:end) == a.SWc.IS_AWAKE, 1);
            end

            if ~isempty(deltaT)
                % A transition is found, save its delta t
                deltaT_sleepToWake(evtID) = deltaT;
            else
                % No transition is found, nevertheless, save a conventional
                % delta t.
                deltaT_sleepToWake(evtID) = deltaTMax + 5;
            end
        end
    end

    % Clean lists of delta t
    deltaT_wakeToSleep(isnan(deltaT_wakeToSleep)) = [];
    deltaT_sleepToWake(isnan(deltaT_sleepToWake)) = [];

    %% Save data
    
    deltaT_wakeToSleepHist(:, channelID) = hist(deltaT_wakeToSleep, deltaTs);
    deltaT_sleepToWakeHist(:, channelID) = hist(deltaT_sleepToWake, deltaTs);
    
    sleepWakeDuration(:, channelID) = [a.durationOf(a.SWc.IS_SLEEPING, 'm', 1:timeLimit), a.durationOf(a.SWc.IS_AWAKE, 'm', 1:timeLimit)]';

end

%% Plot results

fig = figure('Color',[1 1 1],'unit','normalized','Position',[0.2 0.4 0.3 0.5]);

% Define some aliases
histMax = max( [max(max(deltaT_wakeToSleepHist(1:end-1, :))), max(max(deltaT_sleepToWakeHist(1:end-1, :)))]);
nbOfStimsMax = max( [max(sum(deltaT_wakeToSleepHist)), max(sum(deltaT_sleepToWakeHist))]);

% Plots
subplot(3, 2, 1:2);
b = bar(sleepWakeDuration', 'stack');
title(sprintf('Sleep duration - acq %d', acqID));
ylabel('duration (in min)');
xlabel('Mouse ID');
legend('sleep epochs', 'awake epochs')

stimHistWS_h = subplot(3, 2, [3, 5]);
b = bar([sum(deltaT_wakeToSleepHist(deltaTs <= deltaTMax_true , :)) ; sum(deltaT_wakeToSleepHist(deltaTs > deltaTMax_true, :))]', 'stack');
ylim([0, nbOfStimsMax + 1]);
xlim([0.5, 0.5 + length(channelIDs)]);
%title('Stimulations');
title('Delay between stimulation and wake to sleep transition');
ylabel('Nb of stims');
xlabel('Mouse ID');
legend(sprintf('Events with \\Deltat \\leq %d s', deltaTMax_true), ...
    sprintf('Events with \\Deltat > %d s', deltaTMax_true));

stimHistSW_h = subplot(3, 2, [4, 6]);
b = bar([sum(deltaT_sleepToWakeHist(deltaTs <= deltaTMax_true, :)) ; sum(deltaT_sleepToWakeHist(deltaTs > deltaTMax_true, :))]', 'stack');
ylim([0, nbOfStimsMax + 1]);
xlim([0.5, 0.5 + length(channelIDs)]);
%title('Stimulations');
title('Delay between stimulation and sleep to wake transition');
ylabel('Nb of stims');
xlabel('Mouse ID');
legend(sprintf('Events with \\Deltat \\leq %d s', deltaTMax_true), ...
    sprintf('Events with \\Deltat > %d s', deltaTMax_true));


if 1
    nameTosave=[a.dataFile_time(1:end-8),'anProbeTest.mat'];
    save(nameTosave,'sleepWakeDuration','deltaT_sleepToWakeHist',...
        'deltaT_wakeToSleepHist','deltaTs','deltaTMax_true','channelIDs')
end
