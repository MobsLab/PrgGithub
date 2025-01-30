
%DeltaWaveToneCrossCorr

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% ------------     Generate cross correlogram of Delta Waves/ToneEvent     -------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
directoryName1=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/');
directoryName2=('/media/DataMOBs24/BreathFeedBack/Mouse243-244/');
smo=1;
binS=10;nbin=1000;

% -------------------------- Motor cortex --------------------------
% Mouse 244 - Random Single Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load ToneEvent
load DeltaMoCx
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
figure, subplot(5,1,1)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('RandomTone*1 Day')
hold on, ylabel('MoCx Delta')

% Mouse 244 - Random Sequence Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load ToneEvent
load DeltaMoCx
[C2,B2]=CrossCorr(SeqTone(1:10:end),Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,2)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('RandomTone*10 Day')
hold on, ylabel('MoCx Delta')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load ToneEvent
load DeltaMoCx
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,3)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('MoCxDelta Tone*1 Day')
hold on, ylabel('MoCx Delta')

% Mouse 244 - Single Tone triggered by PaCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load ToneEvent
load DeltaMoCx
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,4)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('PaCxDelta Tone*1 Day')
hold on, ylabel('MoCx Delta')

% Mouse 244 - Sequence Tone triggered by PaCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load ToneEvent
load DeltaMoCx
[C2,B2]=CrossCorr(SeqTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,5)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('PaCxDelta Tone*10 Day')
hold on, ylabel('MoCx Delta')



% -------------------------- Parietal cortex --------------------------
% Mouse 244 - Random Single Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load ToneEvent
load DeltaPaCx
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
figure, subplot(5,1,1)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('RandomTone*1 Day')
hold on, ylabel('PaCx Delta')

% Mouse 244 - Random Sequence Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load ToneEvent
load DeltaPaCx
[C2,B2]=CrossCorr(SeqTone(1:10:end),Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,2)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('RandomTone*10 Day')
hold on, ylabel('PaCx Delta')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load ToneEvent
load DeltaPaCx
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,3)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('MoCxDelta Tone*1 Day')
hold on, ylabel('PaCx Delta')

% Mouse 244 - Single Tone triggered by PaCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load ToneEvent
load DeltaPaCx
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,4)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('PaCxDelta Tone*1 Day')
hold on, ylabel('PaCx Delta')

% Mouse 244 - Sequence Tone triggered by PaCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load ToneEvent
load DeltaPaCx
[C2,B2]=CrossCorr(SeqTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,5)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('PaCxDelta Tone*10 Day')
hold on, ylabel('PaCx Delta')




% -------------------------- Parietal cortex --------------------------
% Mouse 244 - Random Single Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load ToneEvent
load DeltaPFCx
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
figure, subplot(5,1,1)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('RandomTone*1 Day')
hold on, ylabel('PFCx Delta')

% Mouse 244 - Random Sequence Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load ToneEvent
load DeltaPFCx
[C2,B2]=CrossCorr(SeqTone(1:10:end),Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,2)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('RandomTone*10 Day')
hold on, ylabel('PFCx Delta')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load ToneEvent
load DeltaPFCx
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,3)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('MoCxDelta Tone*1 Day')
hold on, ylabel('PFCx Delta')

% Mouse 244 - Single Tone triggered by PaCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load ToneEvent
load DeltaPFCx
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,4)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('PaCxDelta Tone*1 Day')
hold on, ylabel('PFCx Delta')

% Mouse 244 - Sequence Tone triggered by PaCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load ToneEvent
load DeltaPFCx
[C2,B2]=CrossCorr(SeqTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(5,1,5)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('PaCxDelta Tone*10 Day')
hold on, ylabel('PFCx Delta')



% -------------------------- dHPC ripples  --------------------------
% Mouse 244 - Random Single Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load ToneEvent
load RipplesdHPC25
[C2,B2]=CrossCorr(SingleTone,dHPCrip(:,2)*1E4,binS,nbin);
figure, subplot(5,1,1)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('RandomTone*1 Day')
hold on, ylabel('dHPC Ripples')

% Mouse 244 - Random Sequence Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load ToneEvent
load RipplesdHPC25
[C2,B2]=CrossCorr(SeqTone(1:10:end),dHPCrip(:,2)*1E4,binS,nbin);
hold on, subplot(5,1,2)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('RandomTone*10 Day')
hold on, ylabel('dHPC Ripples')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load ToneEvent
load RipplesdHPC25
[C2,B2]=CrossCorr(SingleTone,dHPCrip(:,2)*1E4,binS,nbin);
hold on, subplot(5,1,3)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('MoCxDelta Tone*1 Day')
hold on, ylabel('dHPC Ripples')

% Mouse 244 - Single Tone triggered by PaCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load ToneEvent
load RipplesdHPC25
[C2,B2]=CrossCorr(SingleTone,dHPCrip(:,2)*1E4,binS,nbin);
hold on, subplot(5,1,4)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('PaCxDelta Tone*1 Day')
hold on, ylabel('dHPC Ripples')

% Mouse 244 - Sequence Tone triggered by PaCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load ToneEvent
load RipplesdHPC25
[C2,B2]=CrossCorr(SeqTone,dHPCrip(:,2)*1E4,binS,nbin);
hold on, subplot(5,1,5)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
hold on, title('PaCxDelta Tone*10 Day')
hold on, ylabel('dHPC Ripples')


