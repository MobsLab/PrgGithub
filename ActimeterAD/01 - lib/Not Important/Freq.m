function [ state, f ] = Freq( s, sampleRate, lastState )
%Freq
%

s = s(end - sampleRate + 1:end);

% Define some aliases
n = length(s);

% Center the signal
s = s - mean(s);

% Filter the signal and get is spectrum
[~, S] = LowPassFilter(s, 5, sampleRate);
S = abs(S((floor(n/2)+1:end)));

[~, f_index] = max(S);
f = (f_index - 1)*sampleRate/n;

% if f >= 2 && f <=3
%     state = -1;
% else
%     state = 1;
% end

if f < 2
    state = 1;
else
    state = 0;
end

end

