function [ state, f ] = test_sigAmpl(  group, sampleRate, lastState )
%TEST_SIGAMPL look at the amplitude of the signal
%

% Define constantes
IS_SLEEPING = -1;
IS_UNDECIDABLE = 0;
IS_AWAKE = 1;

IS_MOVING = 2;

% Get back the last block
block = group(end - sampleRate + 1:end);

% Center the signal
block = block - mean(block);

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
    state = IS_AWAKE;
elseif nbOfCross_up + nbOfCross_down > 1
    state = IS_MOVING;
else
    state = IS_UNDECIDABLE;
end
end

