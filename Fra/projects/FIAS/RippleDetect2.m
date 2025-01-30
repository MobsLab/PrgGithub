

Fs = 1000; 
%  
%  
%  EEGIntervalHc = Restrict(EEGhc,sleep1Epoch);
%  
%  filtEEG_signal = filtEEGBand(EEGIntervalHc,100,300)
%  
[StartRipple EndRipple PeakRipple] = findRipples(filtEEG_signal,0.2,0.2);

%  RippleTime = Range(PeakRipple);
StartRipple = Range(StartRipple);
EndRipple = Range(EndRipple);

RippleWave = zeros(length(PeakRipple),167);


for t = 1:length(RippleTime)
%  
%  	RippleWave(t,:) = Data(Restrict(filtEEG_signal,intervalSet(RippleTime(t)-400,RippleTime(t)+400)));
	


%  	figure(1)
%  	subplot(2,1,1);
%  		plot([-RippleDuration/2*Fs:RippleDuration/2*Fs],RippleWave(t,:))
%  		title(['Ripple n°' , num2str(t)]);
%  	subplot(2,1,2);
%  		plot([1:length(gaborWindow170)],gaborWindow170);
%  		title(['Max Correlation =' , num2str(max(abs(RippleConv))), ' Shift=', num2str(ShiftVect(RippleConv == max(RippleConv)))])
	
	
	pause(2)
	plot([1:length(Data(Restrict(filtEEG_signal,intervalSet(StartRipple(t),EndRipple(t)))))],Data(Restrict(filtEEG_signal,intervalSet(StartRipple(t),EndRipple(t)))));
end;
  
%  
imagesc(RippleWave);           