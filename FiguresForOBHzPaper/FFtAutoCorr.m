function [f,P1]=FFtAutoCorr(B,H,plo)

T=median(diff(B))/1000; % Sampling period
Fs = 1/T;            % Sampling frequency
L = length(B);             % Length of signal
t = (0:L-1)*T;        % Time vector

Y = fft(H);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
if plo
    plot(f,P1)
    title('Single-Sided Amplitude Spectrum of X(t)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
end
end