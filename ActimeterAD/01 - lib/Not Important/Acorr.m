function [ state, f ] = Acorr( s, sampleRate, lastState )
%ACORR
%

%Define some aliases
n = length(s);

% Compute the auto-correlation of the signal
s = s - mean(s);
S = xcorr(s);
S = S/max(S);

% % Look at the second half of the auto-correlation
% if max(S(end-3*sampleRate:end)) > 0.5
%     state = -1;
% else
%     state = 1;
% end
% 
% if var(S(end-3*sampleRate:end-2*sampleRate)) > 0.2^2
%     state = -1;
% else
%     state = 1;
% end

% % Find the first annulation of the auto-correlation
% S = S(n:end);
% if find(S < 0, 1) < 6
%     state = 1;
% else
%     state = -1;
% end

% Look at the amplitude of the autocorrelation
if var(S(end-3*sampleRate:end-2*sampleRate)) > 0.2^2
    state = -1;
else
    state = 0;
end

f = 0;
end

