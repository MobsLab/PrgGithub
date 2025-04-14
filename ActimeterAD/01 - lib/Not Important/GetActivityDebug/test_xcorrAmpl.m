function [ state, f ] = test_xcorrAmpl(  group, sampleRate, lastState )
%TEST_XCORRAMPL look at the amplitude of the auto-correlation of the signal
%

% Define constantes
IS_SLEEPING = -1;
IS_UNDECIDABLE = 0;
IS_AWAKE = 1;

IS_MOVING = 2;

% Compute the normalized auto-correlation of the signal
c = group - mean(group);
C = xcorr(c);
C = C/max(C);

if var(C(end-3*sampleRate:end-2*sampleRate)) > 0.25^2
    state = IS_SLEEPING;
else
    state = IS_UNDECIDABLE;
end

end

