% SoundControl_performance
%   Test the performance of soundControl in case of high stress, ie if
%   every channel are drive dynamicly.
%
% by antoine.delhomme@€spci.fr
%

%% Initialisation
% Set parameters
%   sampling:   sampling rate of the modulation
sampling = 20;

% Create the sound control object
c = soundControl('COM4');

% % Create an alias for the callback function
% updateSound = @(timerObj, ~) soundControl_sin(c, timerObj.TasksExecuted);
% 
% % Create the timer
% t = timer;
% t.TimerFcn = updateSound;
% t.StopFcn = @(~, thisEvent) c.delete();
% t.Period = 1/sampling;
% t.ExecutionMode = 'fixedRate';
% t.BusyMode = 'drop';
% 
% 
% 
% 
% %% Start the timer
% % To stop id, use stop(t);
% start(t);

for channel = 0:11
    c.setChannel(channel, c.SOUND_NOISE, 192, c.MODE_OSC);
end