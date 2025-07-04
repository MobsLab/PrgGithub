%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Violet Noise Generation with MATLAB Implementation  %
%                                                      %
% Author: M.Sc. Eng. Hristo Zhivomirov       07/31/13  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = violetnoise(N)

% function: y = violetnoise(N) 
% N - number of samples to be returned in row vector
% y - row vector of violet noise samples

% The function generates a sequence of violet (purple) noise samples. 
% In terms of power at a constant bandwidth, violet noise increase in at 6 dB per octave. 

% difine the length of the vector
% ensure that the M is even
if rem(N,2)
    M = N+1;
else
    M = N;
end

% generate white noise 
x = randn(1, M);

% FFT
X = fft(x);

% prepare a vector for f^2 multiplication
NumUniquePts = M/2 + 1;
n = 1:NumUniquePts;

% multiplicate the left half of the spectrum so the power spectral density
% is proportional to the frequency by factor f^2, i.e. the
% amplitudes are proportional to f
X(1:NumUniquePts) = X(1:NumUniquePts).*n;

% prepare a right half of the spectrum - a copy of the left one,
% except the DC component and Nyquist frequency - they are unique
X(NumUniquePts+1:M) = real(X(M/2:-1:2)) -1i*imag(X(M/2:-1:2));

% IFFT
y = ifft(X);

% prepare output vector y
y = real(y(1, 1:N));

% ensure unity standard deviation and zero mean value
y = y - mean(y);
yrms = sqrt(mean(y.^2));
y = y/yrms;

end