function [RippleTime RippleWave] = RippleDetect(EEGSignal)

%Parameters

Fs = 2083; 
NumStdDetect = 8;
MinRippleDuration = 0.03; %in sec

RippleDuration = 0.15; % size of ripple interval
rippleFreq1 = 150;
rippleFreq2 = 170;
EnvWidth = RippleDuration/2*Fs;

filtEEG_signal = Data(filtEEGBand(EEGSignal,Fs,100,300));

RippleEEG = filtEEG_signal;
RippleEEG(RippleEEG < NumStdDetect * std(RippleEEG)) = 0; 

RippleTime = (RippleEEG > 0);
RippleTime = RippleTime.*[1:length(RippleTime)]';
RippleTime(RippleTime == 0) = [];

t = 2;

while t < length(RippleTime) 

	if (RippleTime(t)-RippleTime(t-1) < MinRippleDuration*Fs)

		RippleTime(t) = [];

	else
		t = t + 1;
	end;

end;


%Defintion of Ripples Interval

RippleWave = zeros( length(RippleTime) , RippleDuration*Fs + 1 );
RippleWave2 = zeros( length(RippleTime) , RippleDuration*Fs + 1 );
RippleConv = zeros( length(RippleTime) , 2*RippleDuration*Fs + 1 );
RippleMark = zeros( length(RippleTime) , 1 );

%  RippleMark(:,1) = RippleTime;


%Definition of Gabor Filters

time = [-RippleDuration/2*Fs:RippleDuration/2*Fs];

gaborWindow150 = 1/(sqrt(2*pi*EnvWidth))*exp(-time.^2/(2*EnvWidth)).*cos(2*pi*rippleFreq1*time/Fs);
gaborWindow170 = 1/(sqrt(2*pi*EnvWidth))*exp(-time.^2/(2*EnvWidth)).*cos(2*pi*rippleFreq2*time/Fs);
gaborWindow = gaborWindow150 + gaborWindow170;

%Ddefinition of shift Vector

ShiftVect = [-RippleDuration*Fs:RippleDuration*Fs-1];

for t = 1:length(RippleTime)

	RippleWave(t,:) = filtEEG_signal(RippleTime(t)-RippleDuration/2*Fs:RippleTime(t)+RippleDuration/2*Fs);
	RippleConv = xcorr(RippleWave(t,:),gaborWindow);	
	
	if max(RippleConv) > 0.25
		
		RippleMark(t) = 1;
		shift = ShiftVect(RippleConv == max(RippleConv));
  		RippleTime(t) = RippleTime(t) + shift;
		RippleWave(t,:) = filtEEG_signal( RippleTime(t)- RippleDuration/2*Fs : RippleTime(t) + RippleDuration/2*Fs );
		
	end
%  
%  	figure(1)
%  	subplot(3,1,1);
%  		plot([-RippleDuration/2*Fs:RippleDuration/2*Fs],RippleWave(t,:))
%  		title(['Ripple n°' , num2str(t)]);
%  	subplot(3,1,2);
%  		plot([1:length(gaborWindow)],gaborWindow);
%  		title(['Max Correlation =' , num2str(max(abs(RippleConv))), ' Shift=', num2str(ShiftVect(RippleConv == max(RippleConv)))])
%  	subplot(3,1,3);
%  		plot([1:length(RippleConv)],RippleWave(t,:)*gaborwindow');
%  		title(['Max Correlation =' , num2str(max(abs(RippleConv))), ' Shift=', num2str(ShiftVect(RippleConv == max(RippleConv)))])
%  	pause(2)

end;
%  
%  RippleMarkSort = sort(RippleMark)
%  
%  for t = 1:length(RippleTime)
%  
%  	RippleWave2(t,:) = RippleWave(RippleMark == RippleMarkSort(t),:);
%  
%  end

%  figure(1)
RippleWave = RippleWave(RippleMark ~= 0,:);
%  
%  figure(2)

