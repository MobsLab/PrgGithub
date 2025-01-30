function [ waveformphase asymmetry ] = getWaveformPhase( signal, fs, fmin, fmax )
% returns phase [DEG] that accounts for the waveform of the LFP oscillation
% implementation  for LFP theta-oscillations
% inputs:
% signal - raw voltage trace or lfp
% fs - sampling frequency
% fmin, fmax - frequency range of interest (eg for theta we used fmin=6.5,
% fmax = 11)
% written by RS 2012

waveformphase = nan(1,length(signal));

maxper = ceil(fs ./ fmin);
minper = floor(fs ./ fmax);

feeg = mybandpassfilter(signal,1,80,fs,2); % apply broad bandpass filter to preserve waveform
minima_feeg = LocalMinima(feeg,minper,maxper); % local minima of the filtered signal
asymmetry = nan(1,minima_feeg);

for i = 3:(length(minima_feeg)-2) % loop through all potential theta cycles (ignore border cycles)
    periodlength = minima_feeg(i+1) - minima_feeg(i); % determine length of current cycle
    if (periodlength < (maxper)) && (periodlength > minper) % check if cycle length is in theta range
        theta_times = minima_feeg(i):minima_feeg(i+1);
        [~, tmp] = max(feeg(theta_times)); % determine local peak of that cycle
        ind_local_max = tmp + minima_feeg(i); % index of the peak
        ascending_times = minima_feeg(i):ind_local_max; % ascending part of the cycle
        descending_times = ind_local_max:minima_feeg(i + 1); % descending part of the cycle
        asc_dur = ind_local_max - minima_feeg(i); % duration of the ascending part
        desc_dur = minima_feeg(i + 1) - ind_local_max; % duration of the descending part
        waveformphase(ascending_times)=((ascending_times - minima_feeg(i)) ./ asc_dur) .* 180; % assign phase through linear interpolation
        waveformphase(descending_times)=((descending_times - ind_local_max) ./ desc_dur) .* 180 + 180;    
        asymmetry(i) = asc_dur ./ desc_dur; % ratio        
    end
end

end

