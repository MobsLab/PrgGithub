function [ state, f ] = test_mainFreq( group, sampleRate, lastState )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Define constantes
IS_SLEEPING = -1;
IS_UNDECIDABLE = 0;
IS_AWAKE = 1;

IS_MOVING = 2;

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

if f < 2
    state = IS_AWAKE;
else
    state = IS_UNDECIDABLE;
end

end

