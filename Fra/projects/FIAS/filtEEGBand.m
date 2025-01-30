function filtEEGBand = filtEEGBand(EEGSignal,Fs,flow,fhigh)

n = 10; Rp = 0.5;
Wn = [flow fhigh]/(Fs/2);   %Nyquist frequency for frequency normalisation
[b a] = cheby1(n,Rp,Wn);

filtEEGBand = tsd(Range(EEGSignal),filter(b,a,Data(EEGSignal)));
