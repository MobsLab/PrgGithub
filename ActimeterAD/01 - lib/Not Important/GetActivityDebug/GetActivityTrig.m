% GetActivityTrig
%   Compare the activity with transitions S->W or W->S.
%
% by antoine.delhomme@espci.fr
%

% Load data
a = Activity(26, 4);
m = mean(a.data);

%% GetActivity2
% Get the activity according to GetActivity2
[act, timeStamps_act] = a.applyForEachGroup(@GetActivity2, 1);

%% Triggering
% Build the mask
mask = [ones(1, 20), zeros(1, 20)];
% Smooth the activity with the mask
act_smooth = conv(act, mask);
act_smooth = act_smooth(1:end-39);
act_smooth(act_smooth > 0) = 1;
act_smooth(act_smooth < 0) = -1;

% Do a shifted version of act_smooth to detect rising and falling edges
act_smooth_off = [act_smooth(2:end), 0];
rising_edges = (act_smooth < 0) .* (act_smooth_off == 0);
falling_edges = (act_smooth > 0) .* (act_smooth_off == 0);

% Get transitions
%transitions = xor(act_smooth(1:end-40), act_smooth(2:end-39));

%% Ploting
clf;

%% % Part #1
subplot(2, 1, 1);
hold on;
    plot(a.timeStamps_sign, a.data, 'b');
    plot(timeStamps_act, m + act, 'r');
    plot(timeStamps_act, m + rising_edges, 'g');
    plot(timeStamps_act, m - falling_edges, 'c');
hold off;
drawnow;

%% % Part #2
subplot(2, 1, 2);
hold on;
    plot(a.timeStamps_sign, a.data, 'b');
    plot(timeStamps_act, m + act_smooth, 'r');
    plot(timeStamps_act, m + rising_edges, 'g');
    plot(timeStamps_act, m - falling_edges, 'c');
hold off;
drawnow;