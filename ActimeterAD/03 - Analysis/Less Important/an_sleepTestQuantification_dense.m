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
deltaTMax = 60;

acqID = 41;
channelIDs = 1:12;

% Time limit: events after this time will be ignored
timeLimit = 3060000;

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
        if timeStamp_start >= timeLimit
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
                deltaT_wakeToSleep(evtID) = 2 * deltaTMax;
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
                deltaT_wakeToSleep(evtID) = 2 * deltaTMax;
            end
        end
    end

    % Clean lists of delta t
    deltaT_wakeToSleep(isnan(deltaT_wakeToSleep)) = [];
    deltaT_sleepToWake(isnan(deltaT_sleepToWake)) = [];

    %% Figure
    subplot(length(channelIDs), 3, 3 * (channelID - 1) + 1);
    hist(deltaT_wakeToSleep, 0:5:2*deltaTMax);
    
    if (channelID == 1)
        title(sprintf('Acq. %d - Wake to sleep transitions', a.acqID));
    elseif (channelID == channelIDs(end))
        xlabel('\Deltat (in s)');
    end
    ylabel(sprintf('#%d\n%d stims', a.channelID, length(deltaT_wakeToSleep)));
    
    xlim([0, 2 * deltaTMax]);
    ylim([0, 40]);
    

    subplot(length(channelIDs), 3, 3 * (channelID - 1) + 2);
    hist(deltaT_sleepToWake, 0:5:2*deltaTMax);
    
    if (channelID == 1)
        title(sprintf('Acq. %d - Sleep to wake transitions', a.acqID));
    elseif (channelID == channelIDs(end))
        xlabel('\Deltat (in s)');
    end
    
    xlim([0, 2 * deltaTMax]);
    ylim([0, 5]);

    subplot(length(channelIDs), 3, 3 * (channelID - 1) + 3);
    bar([-1, 1], [a.durationOf(a.SWc.IS_SLEEPING, 'm'), a.durationOf(a.SWc.IS_AWAKE, 'm')]);
    
    if (channelID == 1)
        title('Duration of sleep/awake (in min)')
    end
    ylim([0, 500]);
    
    drawnow;

end