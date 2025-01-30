
%Parameters
Fs = 2083;
FsRip = 1250;

%  EGSignal = Data(Restrict(EEGpfc,sleep1Epoch));
%  
%  b = fir1(96,[100 300]/Fs);
%  eegRipples = filter(b,1,EEGSignal);
%  

%  ripples = FindRipples(-resample(eegRipples,FsRip,Fs));

nbRipples = size(ripples,1);



for i=1:nbRipples

	figure(1),clf
	RasterPETHRipples(eegRipples(ripples(i,2)*Fs-Fs*0.05:ripples(i,2)*Fs+Fs*0.05-1),S, ripples(i,2), 50, 50);

end;

