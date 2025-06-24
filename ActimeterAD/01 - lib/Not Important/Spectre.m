function [ state, f ] = Spectre( s, sampleRate, lastState )
%Freq
%

persistent last_spectrum;

if isempty(last_spectrum)
    last_spectrum = zeros(15, 1);
end

s = s(end - sampleRate + 1:end);

% Center the signal
s = s - mean(s);

% Get the spectrum of the signal
S = abs(fft(s))';
S = S(1:15);
S = S./max(S);

% Do the correlation with the last spectrum
r = corr(S, last_spectrum);

last_spectrum = S;

state = 4*(r-0.5);

% if f < 2
%     state = 1;
% else
%     state = 0;
% end

end

