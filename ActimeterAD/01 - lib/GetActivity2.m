function [ state, f ] = GetActivity2( group, sampleRate, lastState )
%GETACTIVITYSTATE2 Given an actimetry signal, return the activity state
%   Two activity state are detected : awake and sleeping.
%

% Define constantes
IS_SLEEPING = -1;
IS_UNDECIDABLE = 0;
IS_AWAKE = 1;

IS_MOVING = 2;

% Init the result of each test
state_1 = IS_UNDECIDABLE;
state_2 = IS_UNDECIDABLE;
state_3 = IS_UNDECIDABLE;
state_4 = IS_UNDECIDABLE;
state_5 = IS_UNDECIDABLE;



%% Test #1 : search the main frequency between 0 and 5 Hz in the last block
block = group(end - sampleRate + 1:end);

% Define some aliases
n_block = length(block);

% Center the signal
block = block - mean(block);

% Filter the signal and get is spectrum
[~, B] = LowPassFilter(block, 5, sampleRate);
B = abs(B((floor(n_block/2)+1:end)));

[~, f_index] = max(B);
f = (f_index - 1)*sampleRate/n_block;

if f < 2 %|| f > 3
    state_1 = IS_AWAKE;
end

%% Test #2 : look at the amplitude of the auto-correlation of the signal
% Compute the normalized auto-correlation of the signal
c = group - mean(group);
C = xcorr(c);
C = C/max(C);

if var(C(end-3*sampleRate:end-2*sampleRate)) > 0.25^2
    state_2 = IS_SLEEPING;
end

%% Test #3 : look at the amplitude of the signal
% Compute the std of all but the last block of the group
std_before = sqrt(var( group(1:end-sampleRate) ));
cross_threshold = 0.2*std_before;
lim_threshold = 1.3;

% Count the number of threshold crossing
cross_up = block > (std_before + cross_threshold);
cross_down = block < (std_before - cross_threshold);
nbOfCross_up = sum(xor(cross_up(1:end-1), cross_up(2:end)));
nbOfCross_down = sum(xor(cross_down(1:end-1), cross_down(2:end)));

% Count the number of sample higher than a high threshold
nbOfExtrema = sum(block > mean(block) + lim_threshold);

if nbOfExtrema > 5
    state_3 = IS_AWAKE;
elseif nbOfCross_up + nbOfCross_down > 1
    state_3 = IS_MOVING;
end

%% Test #4 : look at the reccurence plot
% Compute the reccurence plot
r = reccPlot(group);
rr = sum(sum(r < 0.05));

if rr <15500
    state_4 = IS_AWAKE;
else
    state_4 = IS_UNDECIDABLE;
end

%% Test #5: look at the picks of the autocorrelation
% Define parameters of the test
pick_threshold = 1/5;
fCut = 5;
sd = sqrt(var(group));

% Define aliases
n_group = length(group);

% Filter the signal and get is spectrum
[g, ~] = LowPassFilter(c, fCut, sampleRate);

% Crop the signal to cut off picks and help the crosscorrelation
g(g > sd) = sd;
g(g < -sd) = -sd;

% Compute the crosscorrelation
gg = xcorr(g);
gg = gg((end-n_group+1):end);

% Get picks
[~, pick_ampl] = pickDetector(gg, 20, gg(1)*pick_threshold);

if length(pick_ampl) > 6
    state_5 = IS_SLEEPING;
end


%% END: Compute the last state

% % the 2015/06/12
if state_3 == IS_AWAKE
    state = IS_AWAKE;
elseif state_5 == IS_SLEEPING || state_2 == IS_SLEEPING
    state = IS_SLEEPING;
elseif state_4 == IS_AWAKE
    state = IS_AWAKE;
elseif state_1 == IS_AWAKE && state_2 == IS_UNDECIDABLE
    if lastState == IS_SLEEPING && state_3 ~= IS_MOVING
        state = IS_SLEEPING;
    else
        state = IS_AWAKE;
    end
elseif state_1 == IS_AWAKE && state_2 == IS_SLEEPING
    if f < 2
        state = IS_AWAKE;
    else
        state = lastState;
        %state = IS_UNDECIDABLE;
    end
else
    %state = IS_UNDECIDABLE;
    state = lastState;
end

% % % before the 2015/06/03
% if state_3 == IS_AWAKE
%     state = IS_AWAKE;
% elseif state_5 == IS_SLEEPING
%     state = IS_SLEEPING;
% elseif state_4 == IS_AWAKE
%     state = IS_AWAKE;
% elseif state_1 == IS_UNDECIDABLE && state_2 == IS_SLEEPING
%     state = IS_SLEEPING;
% elseif state_1 == IS_AWAKE && state_2 == IS_UNDECIDABLE
%     if lastState == IS_SLEEPING && state_3 ~= IS_MOVING
%         state = IS_SLEEPING;
%     else
%         state = IS_AWAKE;
%     end
% elseif state_1 == IS_AWAKE && state_2 == IS_SLEEPING
%     if f < 2
%         state = IS_AWAKE;
%     else
%         state = lastState;
%         %state = IS_UNDECIDABLE;
%     end
% else
%     %state = IS_UNDECIDABLE;
%     state = lastState;
% end



% %% VERY END: Do the reclassification
% % The reclassification is used to smooth noise on the activity state
% if state == IS_SLEEPING;
%     % The sleepCounter is just reset
%     sleepCounter = 0;
%     
% elseif state ~= IS_UNDECIDABLE && sleepCounter < sleepCounterLim
%     % The sleepCounter is incremented and the state is forced to be
%     % IS_SLEEPING.
%     sleepCounter = sleepCounter + 1;
%     state = IS_SLEEPING;
%     
% end

end

