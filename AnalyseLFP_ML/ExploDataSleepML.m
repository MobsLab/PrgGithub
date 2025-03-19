% ExploDataSleepML.m

% call:
% SleepStagesDistributionML.m
% PETHSpindlesRipplesMLSB.m
% AnalyseNREMsubstagesML.m

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< figure Poster SFN 2015 <<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%% ---------------------------------------------------------
% -------------- Delta ripples spindles ------------------
% ---------------------------------------------------------

cd /media/DataMOBsRAID/ProjetAstro/Mouse051/20130313/BULB-Mouse-51-13032013

load('StateEpoch.mat','SWSEpoch')
PETHSpindlesRipplesMLSB(pwd,'NameTest',{SWSEpoch});

%% ---------------------------------------------------------
% -- Repartitions of stages across one night of sleep -----
% ---------------------------------------------------------
SleepStagesDistributionML.m;


%% ---------------------------------------------------------
% --------------- Delta ripples spindles -----------------
% ---------------------------------------------------------
AnalyseNREMsubstagesML;


%% ---------------------------------------------------------
% ---- sleep scoring example ------------------------------
% ---------------------------------------------------------
cd /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130729/BULB-Mouse-82-29072013
load('StateEpoch.mat')
Sp=Spectro{1};
t=Spectro{2};
f=Spectro{3};
%
figure('color',[1 1 1]),imagesc(t,f,10*log10(Sp)'), axis xy,caxis([20 60]);
hold on, plot(Range(Mmov,'s'),rescale(Data(Mmov),15,19),'k','Linewidth',1.5); xlim([15000 20000])
hold on, plot(Range(ThetaRatioTSD,'s'),rescale(Data(ThetaRatioTSD),0,4),'r','Linewidth',2)
hold on, plot(Range(ThetaRatioTSD,'s'),rescale(Data(ThetaRatioTSD),0,4),'k')
title(['SleepScoringML ',pwd])
% movEpoch
sta=Start(MovEpoch,'s'); sto=Stop(MovEpoch,'s');
for i=1:length(sta), line([sta(i),sto(i)],[19.3 19.3],'Color',[0.5 0.2 0.1],'Linewidth',4);end
% REMEpoch
sta=Start(REMEpoch,'s'); sto=Stop(REMEpoch,'s');
for i=1:length(sta), line([sta(i),sto(i)],[19 19],'Color',[0.1 0.7 0],'Linewidth',6);end
% SWSEpoch
sta=Start(SWSEpoch,'s'); sto=Stop(SWSEpoch,'s');
for i=1:length(sta), line([sta(i),sto(i)],[18.5 18.5],'Color',[0.8 0 0.7],'Linewidth',4);end


%% ---------------------------------------------------------
% ---------------- Delta occurance -----------------------
% ---------------------------------------------------------

%cd /media/DataMOBsRAID/ProjetAstro/Mouse051/20130313/BULB-Mouse-51-13032013
load('ChannelsToAnalyse/PFCx_deep.mat')

% Spectrum PaCx
disp(['...loading SpectrumDataL/Spectrum',num2str(channel),'.mat'])
eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'')'])

% Hilbert delta PaCx
disp(['...loading LFPData/LFP',num2str(channel),'.mat'])
eval(['load(''LFPData/LFP',num2str(channel),'.mat'')'])
disp('...Calculating hilbert transform')
FilDelta=FilterLFP(LFP,[2 5],1024);
HilDelta=hilbert(Data(FilDelta));
H=abs(HilDelta);

% delta
disp('...loading Delta')
load('DeltaPFCx.mat')
% ripples
disp('...loading Ripples')
load('RipplesdHPC25.mat')
% spindles
disp('...loading SpindlesSup')
load('SpindlesPFCxSup.mat')

% display

figure('Color',[1 1 1]), 
subplot(2,6,1:5), hold on
imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 60]);
plot(Range(LFP,'s'),rescale(H,0,20),'k')
% events
plot(Range(tDeltaP2,'s'),4*ones(1,length(Range(tDeltaP2))),'c.')
plot(SpiLow(:,1),10*ones(1,size(SpiLow,1)),'m.')
plot(dHPCrip(:,1),15*ones(1,size(dHPCrip,1)),'r.')
xlim([18160 18602]),ylim([0 20])
title(pwd)

%SmoothDec(H)
subplot(2,6,7:11), hold on
rg=Range(LFP,'s');
plot(rg(1:10:end),rescale(SmoothDec(H(1:10:end),50),0,20),'k','Linewidth',2)
xlim([18160 18602])
plot(rg(1:10:end),rescale(SmoothDec(H(1:10:end),500),0,20),'b','Linewidth',2)
% add events
plot(Range(tDeltaP2,'s'),2.5*ones(1,length(Range(tDeltaP2))),'c.')   
plot(SpiLow(:,1),3.5*ones(1,size(SpiLow,1)),'m.')
plot(dHPCrip(:,1),4.5*ones(1,size(dHPCrip,1)),'r.')

m=[18232 18278 18306 18350 18366 18403 18439 18183 18213 18329 18460,...
     18477 18497 18512 18528 18555 18594];
line([m(1),m(1)],[0 5],'Color',[0.5 0.5 0.5]);ylim([0 5]) 
title(['Spectrum and LFP hilbert transform (2-5Hz) from channel ',num2str(channel),' (PaCx)'])

% distribution hilbert values
tsdH=tsd(rg*1E4,SmoothDec(H,500));  
[h,xout]=hist(Data(tsdH),[0:5:5E3]);
subplot(2,6,6), hold off
plot(xout,h,'k'); xlim([0 3000])
l=560; a=ylim;
line([l l],a,'Color','r','Linewidth',2)
text(l,2*a(2)/3,['Threshold Low value = ',num2str(l)],'Color','r')
xlabel('Hilbert values'); ylabel('Distribution'), 
%evts
NoDeltaEpoch=thresholdIntervals(tsdH,l,'Direction','Below');
NoDeltaEpoch=mergeCloseIntervals(NoDeltaEpoch,5*1E4);
NoDeltaEpoch=dropShortIntervals(NoDeltaEpoch,5*1E4);
%
%figure, plot(Range(tsdH,'s'),Data(tsdH),'k'), hold on
subplot(2,6,7:11),
line([l l],max(Data(tsdH)),'Color','r','Linewidth',2)
st=Start(NoDeltaEpoch,'s');
for i=1:length(st), line([st(i),st(i)],[0 1E4],'Color','r');end

subplot(2,6,12), 
hist(diff(st),[1:10:110]); xlim([0 100])
a=ylim; ylim(2*a);
xlabel('duration ultraslow (s)')
ylabel('distribution')

subplot(2,6,7:11),
legend({'Smooth(H(1:10:end),50)','Smooth(H(1:10:end),500)','Delta','Spindles','Ripples','Troughs (manual)','Troughs automatic'})
for i=2:length(m), line([m(i),m(i)],[0 5],'Color',[0.5 0.5 0.5]);end



%% look at data
