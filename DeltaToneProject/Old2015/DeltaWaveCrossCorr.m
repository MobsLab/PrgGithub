%DeltaWaveCrossCorr

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% ------------     Generate cross correlogram of Delta Waves/ToneEvent     -------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
directoryName1=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/');
directoryName2=('/media/DataMOBs24/BreathFeedBack/Mouse243-244/');
smo=1;
binS=10;nbin=1000;

% Mouse 244 - Random Single Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load DeltaMoCx
dMoCx=tDeltaT2;
load DeltaPaCx
dPaCx=tDeltaT2;
load DeltaPFCx
dPFCx=tDeltaT2;

[C1,B1]=CrossCorr(Range(dMoCx),Range(dPaCx),binS,nbin);
[C2,B2]=CrossCorr(Range(dMoCx),Range(dPFCx),binS,nbin);

[C3,B3]=CrossCorr(Range(dPaCx),Range(dMoCx),binS,nbin);
[C4,B4]=CrossCorr(Range(dPaCx),Range(dPFCx),binS,nbin);

[C5,B5]=CrossCorr(Range(dPFCx),Range(dMoCx),binS,nbin);
[C6,B6]=CrossCorr(Range(dPFCx),Range(dPaCx),binS,nbin);

figure, subplot(3,5,1)
hold on, plot(B1/1E3,SmoothDec(C1,smo),'r'), yl=ylim; hold on,line([0 0],yl,'color','g')
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','g')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dMoCx - blue=dPFCx - red=dPaCx')
hold on, subplot(3,5,6)
hold on, plot(B3/1E3,SmoothDec(C3,smo),'g'), yl=ylim; hold on,line([0 0],yl,'color','r')
hold on, plot(B4/1E3,SmoothDec(C4,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dPaCx - green=dMoCx - blue=dPFCx')
hold on, subplot(3,5,11)
hold on, plot(B5/1E3,SmoothDec(C5,smo),'g'), yl=ylim; hold on,line([0 0],yl,'color','b')
hold on, plot(B6/1E3,SmoothDec(C6,smo),'r'), yl=ylim; hold on,line([0 0],yl,'color','b')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dPFCx - green=dMoCx - red=dPaCx')



% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load DeltaMoCx
dMoCx=tDeltaT2;
load DeltaPaCx
dPaCx=tDeltaT2;
load DeltaPFCx
dPFCx=tDeltaT2;

[C1,B1]=CrossCorr(Range(dMoCx),Range(dPaCx),binS,nbin);
[C2,B2]=CrossCorr(Range(dMoCx),Range(dPFCx),binS,nbin);

[C3,B3]=CrossCorr(Range(dPaCx),Range(dMoCx),binS,nbin);
[C4,B4]=CrossCorr(Range(dPaCx),Range(dPFCx),binS,nbin);

[C5,B5]=CrossCorr(Range(dPFCx),Range(dMoCx),binS,nbin);
[C6,B6]=CrossCorr(Range(dPFCx),Range(dPaCx),binS,nbin);

hold on, subplot(3,5,2)
hold on, plot(B1/1E3,SmoothDec(C1,smo),'r'), yl=ylim; hold on,line([0 0],yl,'color','g')
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','g')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dMoCx - blue=dPFCx - red=dPaCx')
hold on, subplot(3,5,7)
hold on, plot(B3/1E3,SmoothDec(C3,smo),'g'), yl=ylim; hold on,line([0 0],yl,'color','r')
hold on, plot(B4/1E3,SmoothDec(C4,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dPaCx - green=dMoCx - blue=dPFCx')
hold on, subplot(3,5,12)
hold on, plot(B5/1E3,SmoothDec(C5,smo),'g'), yl=ylim; hold on,line([0 0],yl,'color','b')
hold on, plot(B6/1E3,SmoothDec(C6,smo),'r'), yl=ylim; hold on,line([0 0],yl,'color','b')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dPFCx - green=dMoCx - red=dPaCx')



% Mouse 244 - Single Tone triggered by MoCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load DeltaMoCx
dMoCx=tDeltaT2;
load DeltaPaCx
dPaCx=tDeltaT2;
load DeltaPFCx
dPFCx=tDeltaT2;

[C1,B1]=CrossCorr(Range(dMoCx),Range(dPaCx),binS,nbin);
[C2,B2]=CrossCorr(Range(dMoCx),Range(dPFCx),binS,nbin);

[C3,B3]=CrossCorr(Range(dPaCx),Range(dMoCx),binS,nbin);
[C4,B4]=CrossCorr(Range(dPaCx),Range(dPFCx),binS,nbin);

[C5,B5]=CrossCorr(Range(dPFCx),Range(dMoCx),binS,nbin);
[C6,B6]=CrossCorr(Range(dPFCx),Range(dPaCx),binS,nbin);

hold on, subplot(3,5,3)
hold on, plot(B1/1E3,SmoothDec(C1,smo),'r'), yl=ylim; hold on,line([0 0],yl,'color','g')
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','g')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dMoCx - blue=dPFCx - red=dPaCx')
hold on, subplot(3,5,8)
hold on, plot(B3/1E3,SmoothDec(C3,smo),'g'), yl=ylim; hold on,line([0 0],yl,'color','r')
hold on, plot(B4/1E3,SmoothDec(C4,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dPaCx - green=dMoCx - blue=dPFCx')
hold on, subplot(3,5,13)
hold on, plot(B5/1E3,SmoothDec(C5,smo),'g'), yl=ylim; hold on,line([0 0],yl,'color','b')
hold on, plot(B6/1E3,SmoothDec(C6,smo),'r'), yl=ylim; hold on,line([0 0],yl,'color','b')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dPFCx - green=dMoCx - red=dPaCx')



% Mouse 244 - Sequence Tone triggered by PaCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load DeltaMoCx
dMoCx=tDeltaT2;
load DeltaPaCx
dPaCx=tDeltaT2;
load DeltaPFCx
dPFCx=tDeltaT2;

[C1,B1]=CrossCorr(Range(dMoCx),Range(dPaCx),binS,nbin);
[C2,B2]=CrossCorr(Range(dMoCx),Range(dPFCx),binS,nbin);

[C3,B3]=CrossCorr(Range(dPaCx),Range(dMoCx),binS,nbin);
[C4,B4]=CrossCorr(Range(dPaCx),Range(dPFCx),binS,nbin);

[C5,B5]=CrossCorr(Range(dPFCx),Range(dMoCx),binS,nbin);
[C6,B6]=CrossCorr(Range(dPFCx),Range(dPaCx),binS,nbin);

hold on, subplot(3,5,4)
hold on, plot(B1/1E3,SmoothDec(C1,smo),'r'), yl=ylim; hold on,line([0 0],yl,'color','g')
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','g')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dMoCx - blue=dPFCx - red=dPaCx')
hold on, subplot(3,5,9)
hold on, plot(B3/1E3,SmoothDec(C3,smo),'g'), yl=ylim; hold on,line([0 0],yl,'color','r')
hold on, plot(B4/1E3,SmoothDec(C4,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dPaCx - green=dMoCx - blue=dPFCx')
hold on, subplot(3,5,14)
hold on, plot(B5/1E3,SmoothDec(C5,smo),'g'), yl=ylim; hold on,line([0 0],yl,'color','b')
hold on, plot(B6/1E3,SmoothDec(C6,smo),'r'), yl=ylim; hold on,line([0 0],yl,'color','b')
xlim([-1 1])
hold on, ylabel('RandomTone*1 Day')
hold on, title('ref=dPFCx - green=dMoCx - red=dPaCx')









