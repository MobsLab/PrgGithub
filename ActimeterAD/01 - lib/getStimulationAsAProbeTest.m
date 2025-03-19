function [ evt_stimTimeStamps ] = getStimulationAsAProbeTest( sleepScoring, activity, timeStamps, SWc )
%getStimulationAsAProbeTest Simulate a probe test and returns
%                           stimulations timestamps.
%   This function simulate offline a SWExperiment_sleepTest() on given
%   data. Transitions are detected and stimulations are randomly triggered.
%
%   sleepscoring:   sleepScoring (ie activity smotthed on the windows with
%                   corrected transition. (eg the scoring given by
%                   Activity.computeSleepScoring())
%   activity:       the raw activity (ie not even smoothed)
%   timeStamps:     time stamps of the sleepscoring and of the activity
%

%% Parameters of the simulation

% /!\	Those parameters have to be in correspondance with those in
% /!\   SWExperiment_sleepTest()

% Probability that a stimulation is triggered
stimProba = 2/5;

% Timing

% Delay before event for transition sleep > wake (in s)
delay_sleepToWake = [20, 60, 5*60];
% Delay before event for transition wake > sleep (in s)
delay_wakeToSleep = [20, 60, 5*60];

%%%%

% Define some aliases
activityTriggered = 0;
evt_stimTimeStamps = [];

%% Do the simulation
for blockID = 1:length(sleepScoring)
    % The activity changes from wake to sleep.
    if sleepScoring(blockID) < 0 && activityTriggered >= 0
        % The mouse falls asleep
        activityTriggered = SWc.IS_SLEEPING;
        
        % A stimulation is not triggered every time
        if (rand() < stimProba)
            % Find the beginning of the event (in the ref of last
            % activities)
            evt_beginning = timeStamps(blockID) + 1;

            % Set the timer
            % Take a delay in the set of possible delays
            delay = delay_wakeToSleep(randi([1, length(delay_wakeToSleep)]));

            % The stimulation amy be performed, just do a last check
            % of the activity.
            if evt_beginning + delay < length(activity)
                lastActivities = activity(evt_beginning:evt_beginning + delay);
                if isempty(find(lastActivities == SWc.IS_AWAKE, 1))
                    evt_stimTimeStamps = [evt_stimTimeStamps, evt_beginning + delay];
                end
            end
        end
        
    % The activity changes from sleep to wake.
    elseif sleepScoring(blockID) > 0 && activityTriggered <= 0
        % The mouse wakes up
        activityTriggered = SWc.IS_AWAKE;
        
    	% A stimulation is not triggered every time
        if (rand() < stimProba)
            % Find the beginning of the event (in the ref of last
            % activities)
            evt_beginning = timeStamps(blockID) + 1;

            % Set the timer
            % Take a delay in the set of possible delays
            delay = delay_sleepToWake(randi([1, length(delay_sleepToWake)]));

            % The stimulation amy be performed, just do a last check
            % of the activity.
            if evt_beginning + delay < length(activity)
                lastActivities = activity(evt_beginning:evt_beginning + delay);
                if isempty(find(lastActivities == SWc.IS_SLEEPING, 1))
                    evt_stimTimeStamps = [evt_stimTimeStamps, evt_beginning + delay];
                end
            end
        end
    
    end
end


end

