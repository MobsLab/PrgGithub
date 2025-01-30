

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% ----------------      Analysis of tone versus Delta/spindles/Ripples           -------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

load ToneEvent
smo=1;
figure,

load DeltaPaCx
binS=10;nbin=1000;
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(3,2,1)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
title('Delta PaCx')

load DeltaPFCx
binS=10;nbin=1000;
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(3,2,2)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
title('Delta PFCx')

load DeltaMoCx
binS=10;nbin=1000;
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
hold on, subplot(3,2,3)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
title('Delta MoCx')

load SpindlesPFCxDeep
binS=100;nbin=200;
[C2,B2]=CrossCorr(SingleTone,SpiHigh(:,1)*1E4,binS,nbin);
load SpindlesPFCxSup
binS=100;nbin=200;
[C3,B3]=CrossCorr(SingleTone,SpiHigh(:,1)*1E4,binS,nbin);
hold on, subplot(3,2,4)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; 
hold on, plot(B3/1E3,SmoothDec(C3,smo),'c'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
title('Spindles PFCx deep(b) VS sup(c)')

load SpindlesPaCxDeep
binS=100;nbin=200;
[C2,B2]=CrossCorr(SingleTone,SpiHigh(:,1)*1E4,binS,nbin);
load SpindlesPaCxSup
binS=100;nbin=200;
[C3,B3]=CrossCorr(SingleTone,SpiHigh(:,1)*1E4,binS,nbin);
hold on, subplot(3,2,5)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim;
hold on, plot(B3/1E3,SmoothDec(C3,smo),'c'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
title('Spindles PaCx deep(b) VS sup(c)')

load SpindlesMoCxDeep
binS=100;nbin=200;
[C2,B2]=CrossCorr(SingleTone,SpiHigh(:,1)*1E4,binS,nbin);
load SpindlesMoCxSup
binS=100;nbin=200;
[C3,B3]=CrossCorr(SingleTone,SpiHigh(:,1)*1E4,binS,nbin);
hold on, subplot(3,2,6)
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim;
hold on, plot(B3/1E3,SmoothDec(C3,smo),'c'), yl=ylim; hold on,line([0 0],yl,'color','r')
xlim([-2 4])
title('Spindles MoCx deep(b) VS sup(c)')

%--------------------------------------------------------

load RipplesdHPC25
[C,B]=CrossCorr(SeqTone(1:10:end),dHPCrip(:,2)*1E4,binS,nbin);
[C2,B2]=CrossCorr(SingleTone,dHPCrip(:,2)*1E4,binS,nbin);
subplot(3,1,3), plot(B/1E3,SmoothDec(C,smo),'k'), yl=ylim; hold on,line([0 0],yl,'color','r')
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
title('Ripples')



%--------------------------------------------------------



load SpindlesPaCxDeep
binS=1;nbin=1500;
[C,B]=CrossCorr(SeqTone(1:10:end),SpiHigh(:,2)*1E4,binS,nbin);
[C2,B2]=CrossCorr(SingleTone,SpiHigh(:,2)*1E4,binS,nbin);
figure, 
subplot(3,1,1), plot(B/1E3,SmoothDec(C,smo),'k'), yl=ylim; hold on,line([0 0],yl,'color','r')
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
%xlim([-2 4])
title('Spindles PaCx')

load DeltaPaCx
[C,B]=CrossCorr(SeqTone(1:10:end),Range(tDeltaT2),binS,nbin);
[C2,B2]=CrossCorr(SingleTone,Range(tDeltaT2),binS,nbin);
subplot(3,1,2), plot(B/1E3,SmoothDec(C,smo),'k'), yl=ylim; hold on,line([0 0],yl,'color','r')
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
title('Delta PaCx')

load RipplesdHPC25
[C,B]=CrossCorr(SeqTone(1:10:end),dHPCrip(:,2)*1E4,binS,nbin);
[C2,B2]=CrossCorr(SingleTone,dHPCrip(:,2)*1E4,binS,nbin);
subplot(3,1,3), plot(B/1E3,SmoothDec(C,smo),'k'), yl=ylim; hold on,line([0 0],yl,'color','r')
hold on, plot(B2/1E3,SmoothDec(C2,smo),'b'), yl=ylim; hold on,line([0 0],yl,'color','r')
title('Ripples')


%-------------------------------------------------------------------------

load DeltaPaCx
Dpac=tDeltaT2;
load DeltaPFCx
Dpfc=tDeltaT2;

binS=50;nbin=100;

Epoch=intervalSet(0,SingleTone(1)-1E4);
Epoch=and(Epoch,SWSEpoch);
[C,B]=CrossCorr(Range(Restrict(Dpac,Epoch)),Range(Restrict(Dpfc,Epoch)),binS,nbin);
figure(100), 
subplot(4,1,1), plot(B/1E3,SmoothDec(C,smo),'k'), yl=ylim; hold on,line([0 0],yl,'color','r')
rg=Range(Restrict(Dpfc,Epoch),'s');
M1=PlotRipRaw(LFP,rg,1000);close
Md1=PlotRipRaw(LFPde,rg,1000);close

Epoch=intervalSet(SingleTone(1),SeqTone(1));
Epoch=and(Epoch,SWSEpoch);
[C,B]=CrossCorr(Range(Restrict(Dpac,Epoch)),Range(Restrict(Dpfc,Epoch)),binS,nbin);
figure(100), subplot(4,1,2), plot(B/1E3,SmoothDec(C,smo),'k'), yl=ylim; hold on,line([0 0],yl,'color','r')
rg=Range(Restrict(Dpfc,Epoch),'s');
M2=PlotRipRaw(LFP,rg,1000);close
Md2=PlotRipRaw(LFPde,rg,1000);close

Epoch=intervalSet(SeqTone(1),SeqTone(end));
Epoch=and(Epoch,SWSEpoch);
[C,B]=CrossCorr(Range(Restrict(Dpac,Epoch)),Range(Restrict(Dpfc,Epoch)),binS,nbin);
figure(100), subplot(4,1,3), plot(B/1E3,SmoothDec(C,smo),'k'), yl=ylim; hold on,line([0 0],yl,'color','r')
rg=Range(Restrict(Dpfc,Epoch),'s');
M3=PlotRipRaw(LFP,rg,1000);close
Md3=PlotRipRaw(LFPde,rg,1000);close

en=End(SWSEpoch);
Epoch=intervalSet(SeqTone(1),en(end));
Epoch=and(Epoch,SWSEpoch);
[C,B]=CrossCorr(Range(Restrict(Dpac,Epoch)),Range(Restrict(Dpfc,Epoch)),binS,nbin);
figure(100), subplot(4,1,4), plot(B/1E3,SmoothDec(C,smo),'k'), yl=ylim; hold on,line([0 0],yl,'color','r')
rg=Range(Restrict(Dpfc,Epoch),'s');
M4=PlotRipRaw(LFP,rg,1000);close
Md4=PlotRipRaw(LFPde,rg,1000);close



figure('color',[1 1 1]), 
subplot(4,1,1), hold on, 
plot(M1(:,1),M1(:,2),'k')
plot(Md1(:,1),Md1(:,2),'r')

subplot(4,1,2), hold on, 
plot(M2(:,1),M2(:,2),'k')
plot(Md2(:,1),Md2(:,2),'r')

subplot(4,1,3), hold on, 
plot(M3(:,1),M3(:,2),'k')
plot(Md3(:,1),Md3(:,2),'r')

subplot(4,1,4), hold on, 
plot(M4(:,1),M4(:,2),'k')
plot(Md4(:,1),Md4(:,2),'r')



rg=Range(Dpfc,'s');
Ma=PlotRipRaw(LFP,rg,800); close
MaDE=PlotRipRaw(LFPde,rg,800); close
Mb=PlotRipRaw(LFP,SingleTone/1E4,800); close
MbDE=PlotRipRaw(LFPde,SingleTone/1E4,800); close
Mc=PlotRipRaw(LFP,SeqTone(1:10:end)/1E4,800); close
McDE=PlotRipRaw(LFPde,SeqTone(1:10:end)/1E4,800); close

figure, 
subplot(1,5,1), hold on
plot(Ma(:,1),Ma(:,2),'k')
plot(MaDE(:,1),MaDE(:,2),'r')

subplot(1,5,2), hold on
plot(Mb(:,1),Mb(:,2),'k')
plot(MbDE(:,1),MbDE(:,2),'r')

subplot(1,5,3), hold on
plot(Mc(:,1),Mc(:,2),'k')
plot(McDE(:,1),McDE(:,2),'r')

subplot(1,5,4), hold on
plot(MaDE(:,1),MaDE(:,2),'k')
plot(MbDE(:,1)-0.12,MbDE(:,2),'m')
plot(McDE(:,1)-0.12,McDE(:,2),'b')

subplot(1,5,5), hold on
plot(Ma(:,1),Ma(:,2),'k')
plot(Mb(:,1)-0.12,Mb(:,2),'m')
plot(Mc(:,1)-0.12,Mc(:,2),'b')


rg=Range(Dpac,'s');
Ma=PlotRipRaw(LFP,rg,800); close
MaDE=PlotRipRaw(LFPde,rg,800); close
Mb=PlotRipRaw(LFP,SingleTone/1E4,800); close
MbDE=PlotRipRaw(LFPde,SingleTone/1E4,800); close
Mc=PlotRipRaw(LFP,SeqTone(1:10:end)/1E4,800); close
McDE=PlotRipRaw(LFPde,SeqTone(1:10:end)/1E4,800); close




