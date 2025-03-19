function [ state, f ] = test_reccPlot(  group, sampleRate, lastState )
%TEST_RECCPLOT look at the reccurence plot
%

% Define constantes
IS_SLEEPING = -1;
IS_UNDECIDABLE = 0;
IS_AWAKE = 1;

IS_MOVING = 2;

% Compute the reccurence plot
r = reccPlot(group);
rr = sum(sum(r < 0.05));

if rr <15500
    state = IS_AWAKE;
else
    state = IS_UNDECIDABLE;
end

end

