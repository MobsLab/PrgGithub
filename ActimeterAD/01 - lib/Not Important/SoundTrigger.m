function [ trigger, f ] = SoundTrigger( group, sampleRate, ~, sleepCounterLim )
%SOUNDTRIGGER Say which sound to play in function of the mouse activity.
%   This function simulate a sound trigger. If it considers that the mouse
%   is starting to sleep, a -1 is triggered. If it considers that the mouse
%   is awking, a +1 is triggered.
%

% Define persistent variables
persistent activityBuffer stateTriggered lastState;

% Define some aliases
nbOfBlocks = floor(length(group)/sampleRate);

% Init the activityBuffer if necessary
if isempty(activityBuffer)
    activityBuffer = zeros(1, nbOfBlocks);
end

if isempty(stateTriggered)
    stateTriggered = 0;
end

if isempty(lastState)
    lastState = 0;
end



% Prepare the activity buffer
activityBuffer(1:(nbOfBlocks - 1)) = activityBuffer(2:end);

% Get the activity state
[activityBuffer(end), f] = GetActivity2(group, sampleRate, lastState, sleepCounterLim);
lastState = activityBuffer(end);

% If the all activities in the activityBuffer is the same, and different of
% the current state, trigger.
if isempty(find(activityBuffer ~= activityBuffer(1), 1)) ...
        && activityBuffer(1) ~= stateTriggered
    trigger = activityBuffer(1);
    stateTriggered = activityBuffer(1);
else
    trigger = 0;
end

end

