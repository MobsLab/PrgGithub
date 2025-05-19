function [ S, f ] = QuickFFT( s, sampleRate)
%Spectrum Return the Fourier Spectrum of s
%   Compute the Fourier Spectrum of s. Only position frequencies are kept.
%
%   s:          raw signal
%   sampleRate: sample rate in Hz
%

% Define some aliases
%   n:  length of the signal
n = length(s);

% Compute the fft and frequencies in Hz and only kept positive frequencies
S = fft(s);
S = S(1:n/2);
f = ((0:floor(n/2)-1)*sampleRate/n)';

end

