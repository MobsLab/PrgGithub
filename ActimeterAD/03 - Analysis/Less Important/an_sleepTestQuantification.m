% sleep test quantification
%   This scritp do some offline analyses to quantify the effect of the
%   conditionning. It is typically applied on data acquired with
%   SWExperiment_sleepTest().
%
% developed for the ProjetSLEEPcontrol-Antoine project
% by antoine.delhomme@espci.fr
%

%% Set parameters of the quantification
% Maximum value of delta t accepted (in s)
deltaTMax_true = 30;
deltaTMax = 100;

% Good acqID
%   38 (3h)
%   41 (13h)
acqID = 41;
channelIDs = 1:12;

% Time limit: events after this time will be ignored
timeLimit = 8.5*3600;

% Init matrix of data
deltaTs = 0:5:(deltaTMax+5);
deltaT_wakeToSleepHist = zeros(length(deltaTs), length(channelIDs));
deltaT_sleepToWakeHist = zeros(length(deltaTs), length(channelIDs));
sleepWakeDuration = zeros(2, length(channelIDs));

for channelID = channelIDs

    %% Load data
    a = Activity(acqID, channelID);

    % Get the sleep scoring (smoothed scoring with corrected beginning and
    % ending of events.
    [sleepScoring, timeStamps] = a.computeSleepScoring();

    
    %% Do the quantification

    % Get timestamps of triggered sounds
    evt_stimTimeStamps = a.timeStamps_evt(a.evts == a.SWc.EVT_SOUND_STIM);

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

%% Plot the figure

% Define some aliases
histMax = max( [max(max(deltaT_wakeToSleepHist(1:end-1, :))), max(max(deltaT_sleepToWakeHist(1:end-1, :)))]);
nbOfStimsMax = max( [max(sum(deltaT_wakeToSleepHist)), max(sum(deltaT_sleepToWakeHist))]);

COLOR_GREEN = [154/255, 222/255, 0];
COLOR_BLUE = [0, 132/255, 200/255];

% Plots
subplot(6, 2, 1:4);
b = bar(sleepWakeDuration', 'stack');
b(1).FaceColor = COLOR_BLUE;
b(2).FaceColor = COLOR_GREEN;
title(sprintf('Sleep duration - acq %d', acqID));
ylabel('duration (in min)');
xlabel('Mouse ID');
legend('sleep epochs', 'awake epochs')

stimHistWS_h = subplot(6, 2, 5);
b = bar([sum(deltaT_wakeToSleepHist(deltaTs <= deltaTMax_true , :)) ; sum(deltaT_wakeToSleepHist(deltaTs > deltaTMax_true, :))]', 'stack');
ylim([0, nbOfStimsMax + 1]);
xlim([0.5, 0.5 + length(channelIDs)]);
%title('Stimulations');
ylabel('Nb of stims');
xlabel('Mouse ID');

stimHistSW_h = subplot(6, 2, 6);
b = bar([sum(deltaT_sleepToWakeHist(deltaTs <= deltaTMax_true, :)) ; sum(deltaT_sleepToWakeHist(deltaTs > deltaTMax_true, :))]', 'stack');
ylim([0, nbOfStimsMax + 1]);
xlim([0.5, 0.5 + length(channelIDs)]);
%title('Stimulations');
ylabel('Nb of stims');
xlabel('Mouse ID');


stimImgWS_h = subplot(2, 2, 3);
hold on;
    imagesc(channelIDs, deltaTs, deltaT_wakeToSleepHist);
    plot([0.5, 12.5], [deltaTMax_true, deltaTMax_true] + 2, 'r', 'LineWidth', 2);
    plot([0.5, 12.5], [deltaTMax, deltaTMax] + 2.25, 'r--', 'LineWidth', 2);
hold off;
axis tight;
caxis([0, histMax]);
colorbar;
title('Delay between stimulation and wake to sleep transition');
ylabel('\Deltat (in s)');
xlabel('Mouse ID');

stimImgSW_h = subplot(2, 2, 4);
hold on;
    imagesc(channelIDs, deltaTs, deltaT_sleepToWakeHist);
    plot([0.5, 12.5], [deltaTMax_true, deltaTMax_true] + 2, 'r', 'LineWidth', 2);
    plot([0.5, 12.5], [deltaTMax, deltaTMax] + 2.25, 'r--', 'LineWidth', 2);
hold off;
axis tight;
caxis([0, histMax]);
colorbar;
title('Delay between stimulation and sleep to wake transition');
ylabel('\Deltat (in s)');
xlabel('Mouse ID');

% Adjust axis
%# find current position [x,y,width,height]
stimHistWS_pos = get(stimHistWS_h,'Position');
stimImgWS_pos = get(stimImgWS_h,'Position');

stimHistSW_pos = get(stimHistSW_h,'Position');
stimImgSW_pos = get(stimImgSW_h,'Position');

%# set width of second axes equal to first
stimHistWS_pos(3) = stimImgWS_pos(3);
set(stimHistWS_h,'Position', stimHistWS_pos)
stimHistSW_pos(3) = stimImgSW_pos(3);
set(stimHistSW_h,'Position', stimHistSW_pos)