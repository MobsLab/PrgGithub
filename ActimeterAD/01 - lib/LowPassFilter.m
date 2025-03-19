function [ out, OUT ] = LowPassFilter( in, fCut, sampleRate )
%LOWPASSFILTER Cut freq > fCut
%   Cut frequencies greater than fCut in the Fourier Space
%   by antoine.delhomme@espci.fr

% Scale in well
if size(in, 1) == 1
    in = in';
end

% Define some aliases
n = length(in);

% Compute the FFT
IN = fftshift(fft(in));
f_IN = ((-ceil(n/2):floor(n/2)-1)*sampleRate/n)';

% Apply the filter
OUT = IN.*(abs(f_IN) < fCut);

% Reverse the FFT
out = ifft(ifftshift(OUT));

end