function [ state, f ] = test_xcorrPicks(  group, sampleRate, lastState )
%TEST_XCORRPICKS look at the picks of the autocorrelation

% Define constantes
IS_SLEEPING = -1;
IS_UNDECIDABLE = 0;
IS_AWAKE = 1;

IS_MOVING = 2;

% Define parameters of the test
pick_threshold = 1/5;
fCut = 5;
sd = sqrt(var(group));

% Define aliases
n_group = length(group);
c = group - mean(group);

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
    state = IS_SLEEPING;
else
    state = IS_UNDECIDABLE;
end

end

