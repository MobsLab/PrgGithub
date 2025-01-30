
%  EEGSignal = Data(Restrict(EEGpfc,sleep1Epoch));
%  
%  EEGResampled = resample(EEGSignal,20,2083);

flow = 0.2;
fhigh = 3;
Fs = 2083;

n = 5; 
Rp = 0.1; 
Rs = 50;
Wn = [flow fhigh]/(20/2)   %Nyquist frequency for frequency normalisation

b = fir1(96,[flow/20 fhigh/20]);
%  fvtool(b,1,512);



%  freqz(cheby1(n,Rp,fhigh/(Fs/2),'low'))
eegLow = filter(b,1,EEGResampled);

windowLength = 0.2;

eegLow = resample(eegLow,2083,20);

chunk = floor(length(eegLow)/(Fs*windowLength))

for t=85/windowLength:chunk
%  t = 85/windowLength

	plot([t*windowLength:1/Fs:t*windowLength+6],eegLow(t*Fs:t*Fs+6*Fs),[t*windowLength:1/Fs:t*windowLength+6],EEGSignal(t*Fs:t*Fs+6*Fs))
	axis([t*windowLength t*windowLength+6 -2 2])
	pause(0.1);
end;