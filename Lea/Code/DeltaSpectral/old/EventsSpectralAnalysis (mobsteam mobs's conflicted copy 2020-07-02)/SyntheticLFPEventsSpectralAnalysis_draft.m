%% SyntheticLFPEventsSpectralAnalysis_draft
%
% 12/05/2020  LP
%
% Script to create a synthetic LFP signal by keeping only the detected
% eventss (ex. events waves) from a raw LFP signal. 
% -> set the signal outside of events to 0, and keep only the eventss
% (starting from this 0 'baseline') 
%
% -> Plot LFP signals, spectrograms of raw vs. synthetic signals, and power
% spectrum.


%% CHOOSE LFP SIGNAL & INTERVAL to use for the analysis

%cd(Dir.path{18}) ; 

% Choose LFP signal : 
%LFP = LFPdeep ; 
%int = intervalSet(52100000,52300000) ;


LFP = Restrict(LFPdeep,SWS) ; 

%int = subset(SWS,30); 
int = subset(SWS,30);




% Choose events :
events = alldeltas_PFCx ; 



%% CREATE SYNTHETIC SIGNAL : keep LFP during events only 

% interval in SWS 
LFP_int = Restrict(LFP,int) ;
r = Range(LFP_int) ; 
%figure, plot(Range(LFP_int),Data(LFP_int))
LFP2 = Restrict(LFPsup,SWS) ; 
LFP2_int = Restrict(LFP2,int) ;

% replace by 0 ot of events
LFP_int2 = replaceinTSD(LFP_int,events,0,'out',1) ; 
%figure, plot(Range(LFP_int2),Data(LFP_int2))

% bring each events to baseline with 1st value at 0 
events_int = intersect(events,int) ;
events_start = Start(events_int) ; events_end = End(events_int) ; 
LFP_int3 = LFP_int2 ; 

for d = 1:length(events_start)
    events_is = intervalSet(events_start(d),events_end(d)) ; 
    events_LFP_int = Restrict(LFP_int2,events_is);
    firstvalue = getfield(Data(events_LFP_int),{1}) ; 
    new_values = Data(events_LFP_int) - firstvalue ; 
    LFP_int3 = replaceinTSD(LFP_int3,events_is, new_values) ; 
end

%figure, plot(Range(LFP_int3),Data(LFP_int3))

% smooth synthetic signal : 
d = runmean(Data(LFP_int3),20) ;
LFP_int3 = tsd(Range(LFP_int3),d) ; 



% ----- Compare spectrograms ----- : 


[params,movingwin,suffix]=SpectrumParametersML('lowkb');

LFP_temp=ResampleTSD(LFP_int,params.Fs);
[Sp,t,f]=mtspecgramc(Data(LFP_temp),movingwin,params);

LFP_temp3=ResampleTSD(LFP_int3,params.Fs);
[Sp3,t,f]=mtspecgramc(Data(LFP_temp3),movingwin,params);


% ----- Power Spectrum ----- : 

PS = mean(Sp,1) ;
PS3 = mean(Sp3,1) ;

%figure, hold on, plot(f,PS) ; plot(f,PS3) ;

% LFP_temp = ResampleTSD(LFP,params.Fs);
% [S,f,Serr]=mtspectrumc(Data(LFP),params) ; 
% figure, plot(f,S) ; 
% [S3,f,Serr]=mtspectrumc(Data(LFP_temp3),params) ; 
% figure, plot(f,S3) ; 


% -------------- FULL PLOT -------------- : 

figure,
sgtitle() ; 

% Raw signal :
subplot(3,2,1), 
plot((r-r(1))/1e4,Data(LFP_int))
hold on, plot((r-r(1))/1e4,Data(LFP2_int))

hold on, plot((r-r(1))/1e4,Data(LFP_int2))
title('Raw LFP signal') ; xlabel('time (s)')
subplot(3,2,3),
imagesc(t,f,10*log10(Sp)'), axis xy
title('Spectrogram of raw LFP') ; xlabel('time (s)') ; ylabel(('frequency (Hz)') ) ; 
cl = clim ; 

% Synthetic signal : 
subplot(3,2,2), 
plot((r-r(1))/1e4,Data(LFP_int3))
title('Synthetic LFP signal with delta waves only ') ; xlabel('time (s)')
subplot(3,2,4), 
imagesc(t,f,10*log10(Sp3)'), axis xy
clim(cl) ; 
title('Spectrogram of synthetic LFP with delta waves only') ; xlabel('time (s)') ; ylabel(('frequency (Hz)') ) ; 

% PSD
% subplot(3,6,[14 15 16 17]), hold on,
% plot(f,PS) ;
% plot(f,PS3) ;
% legend({'raw LFP','synthetic LFP'})

subplot(3,2,5),
plot(f,PS) ;
title('Power spectrum of raw LFP (from spectrogram)') ; xlabel('frequency (Hz)') ; ylabel('Power') ; 

subplot(3,2,6),
plot(f,PS3) ;
title('Power spectrum of synthetic LFP (from spectrogram)') ; xlabel('frequency (Hz)') ; ylabel('Power') ; 






