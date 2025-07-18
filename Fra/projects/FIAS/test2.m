%  
%  
%  %Parameters
%  epoch = sleep1Epoch;
%  Fs = 2083;
%  FsRip = 1250;
%  FsTheta = 30;
%  b = fir1(96,[100 300]/Fs);
%  
%  %Ripples event finding
%  
%  EEG = Restrict(EEGhc,epoch)
%  
%  eegRipples = filter(b,1,Data(Restrict(EEG,epoch)));
%  
%  ripples = FindRipples(-resample(eegRipples,FsRip,Fs));
%  
%  
b = fir1(96,[7.5 8.5]/FsTheta);
%  %  
%  Filt_EEG = filter(b,1,resample(Data(EEG),FsTheta,Fs));
%  %  
%  Filt_EEGResampled = resample(Filt_EEG,Fs,FsTheta);
%  %  
%  Filt_EEGtsd = tsd(Range(EEG),Filt_EEGResampled(1:length(Range(EEG))));
%  %  
%  [StartTheta, EndTheta] = findTheta(Filt_EEGtsd, 0.2, 0.1);
%  %  
%  SThetaVect = Range(StartTheta);
%  EThetaVect = Range(EndTheta);


dh = Data(Restrict(EEG,Start(epoch),Start(epoch)+5000000));

deegHc = resample(dh, 600, 6250);
clear dh
params.Fs = 200;
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 0;
movingwin = [10, 3];
%  FsOrig = 1 / median(diff(Range(EEGhc, 's')));
%  times = Range(EEGhc);
%  t1 = 0:(1/FsOrig):((1/FsOrig)*(length(times)-1));
%  [t2, ix] = Restrict(ts(t1), t-movingwin(1)/2);
%  times = times(ix);
 
[Spec,t,f,Serr]=mtspecgramc(deegHc,movingwin,params);
imagesc(Spec,[0 0.01]);

%  
%  
%  figure(1), clf
%  hold on;
%  plot(Range(EEG)/10000,Filt_EEGResampled(1:length(Range(EEG))))
%  
%  
%  for i=1:size(ripples,1)
%  
%  	yLim = ylim;	
%  %  	hold on;
%  	plot([ripples(i,1) ripples(i,1)],yLim,'g-');
%  
%  	
%  end
%  
%  for i=1:size(SThetaVect)
%  
%  	yLim = ylim;
%  %  	hold on;
%  	plot([SThetaVect(i)/10000 SThetaVect(i)/10000],yLim,'k-');
%  	plot([EThetaVect(i)/10000 EThetaVect(i)/10000],yLim,'r-');
%  
%  end
%  hold off;