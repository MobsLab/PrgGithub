function SPWEpoch= GetRipplesInterval(EEGhc,epoch)

%Parameters
Fs = 2083;
FsRip = 1250;
b = fir1(96,[100 300]/Fs);
show = 0;

%Ripples event finding
EEG = Restrict(EEGhc,epoch);
eegRipples = filtfilt(b,1,Data(EEG));

ripplesRaw = FindRipples(-resample(eegRipples,FsRip,Fs));
ripples = ripplesRaw;
nbRipplesBeforeMerge = size(ripples,1)

% Merge ripples in interval of tau se2

t = 1;
tau = 10;

while t < size(ripples,1);

	while (ripples(t + 1,1) - ripples(t,3) < tau) && (t + 1 < size(ripples,1))
		ripples(t,3) = ripples(t + 1,3);
		ripples(t + 1,:) = [];
	end
	
t=t+1;

end

%  nbRipplesBeforeMerge = size(ripples,1)

%Remove lonely ripples

t = 2;
tau = 0.3;

while t <= size(ripples,1);

ix = 0;
	
	if ripples(t,3) - ripples(t,1) < tau
		ripples(t,:) = [];
		t = t - 1;		
	end

t=t+1;

end

%  nbRipplesBeforeMerge = size(ripples,1)

%Remerge in bigger interval to have high density ripples interval

t = 2;
tau = 30;

while t < size(ripples,1);

	while (ripples(t + 1,1) - ripples(t,3) < tau) && (t + 1 < size(ripples,1))
		ripples(t,3) = ripples(t + 1,3);
		ripples(t + 1,:) = [];
	end
	
t=t+1;

end

%  nbRipples = t-1

if show == 1
	
	figure(3),clf
	hold on;
	times = [0:length(eegRipples)-1]/Fs;
	
	fillHeight = max(abs(eegRipples));
	
	for i=1:size(ripples,1)
		fill([ripples(i,1) ripples(i,1) ripples(i,3) ripples(i,3)],[-fillHeight fillHeight fillHeight -fillHeight],'r');
	end
	
	plot((times-times(1)),eegRipples)
	
	
	%  
	%  for i=1:size(ripplesRaw,1)
	%  
	%  	yLim = ylim;	
	%  	plot([ripplesRaw(i,1) ripplesRaw(i,1)],yLim,'g-');
	%  	plot([ripplesRaw(i,3) ripplesRaw(i,3)],yLim,'k-');
	%  
	%  end	
	
	
	%  hold off;

end

%the interval are extended of a extra 5 s.
tau = 5;

SPWEpoch = intervalSet(ripples(:,1)*10000+Start(epoch),(ripples(:,3) + tau)*10000+Start(epoch));

