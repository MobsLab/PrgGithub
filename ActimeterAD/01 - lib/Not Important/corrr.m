function [ state, f ] = corrr( s, sampleRate, lastState )
%corr
%

pick_threshold = 1/5;
n = length(s);
fCut = 5;
sd = sqrt(var(s));  % On the last block

% Center the signal
s = s - mean(s);

% Filter the signal and get is spectrum
[s, ~] = LowPassFilter(s, fCut, sampleRate);

% Crop the signal to cut off picks and help the crosscorrelation
s(s > sd) = sd;
s(s < -sd) = -sd;

% Compute the crosscorrelation
r = xcorr(s);
r = r((end-n+1):end);

% Get picks
[~, pick_ampl] = pickDetector(r, 20, r(1)*pick_threshold);

if length(pick_ampl) > 6
    state = -1;
else
    state = 0;
end

% state = length(pick_ampl);

end

