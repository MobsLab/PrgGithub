% DownDurationIntervals


cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150223/Breath-Mouse-243-244-23022015/Mouse244
% [As,Aw,Ar,rs,rsZ,rr,rrZ,rw,rwZ,idx1,idx2,S,NumNeurons,LFPd,LFPs,SWSEpoch,REMEpoch,Wake]=PowerDownHomeostasis(1,2);

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150223/Breath-Mouse-243-244-23022015/Mouse243


cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015


cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015



%'BASAL'

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244

%----------------------------------------------------------------------------------------------------------------


cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244

%----------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------

% 
% load DeltaPFCx
% DpfcO=tDeltaT2;
% 
% load newDeltaPFCx
% Dpfc=ts(tDelta);
% 
% [Ca,Ba]=CrossCorr(Range(DpfcO),Range(DpfcO),10,100);
% [Cb,Bb]=CrossCorr(Range(Dpfc),Range(Dpfc),10,100);
% [Cc,Bc]=CrossCorr(Range(DpfcO),Range(Dpfc),10,100);
% [Cd,Bd]=CrossCorr(Range(Dpfc),Range(DpfcO),10,100);
% 
% figure('color',[1 1 1]), hold on
% plot(Ba/1E3,Ca,'k')
% plot(Bb/1E3,Cb,'color',[0.5 0.5 0.5])
% plot(Bc/1E3,Cc,'r')
% plot(Bd/1E3,Cd,'b')


%----------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------


ch=1;
limSizDown=70;
binSize=5;
limIntDown=0.6;
%limIntDown=0.9;

load newDeltaPFCx
Dpfc=ts(tDelta);




% load DeltaPFCx
% Dpfc=tDeltaT2;

% load newDeltaPaCx
% Dpfc=ts(tDelta);

load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPd=LFP;
clear LFP

load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPs=LFP;
clear LFP

rg=Range(LFPd);
%Epoch=intervalSet(5*rg(1)/10,7*rg(end)/10);
Epoch=intervalSet(rg(1),rg(end)/2);
Epoch=intervalSet(rg(end)/2,rg(end));
Epoch=intervalSet(rg(1),rg(end));

%[As,Aw,Ar,rs,rsZ,rr,rrZ,rw,rwZ,idx1,idx2,S,NumNeurons,LFPd,LFPs,SWSEpoch,REMEpoch,Wake,Down,PowTsd]=PowerDownHomeostasis(1,2);

load SpikeData 
[Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');

load StateEpochSB SWSEpoch REMEpoch Wake

try
SWSEpoch=and(SWSEpoch,Epoch);
REMEpoch=and(REMEpoch,Epoch);
Wake=and(Wake,Epoch);
end

if ch
    [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,binSize,0.01,1,0,[0 limSizDown],1);close
else
    [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,binSize,0.01,1,0,[20 limSizDown],1);close
end

Down2=mergeCloseIntervals(Down,500);

[BurstDeltaEpoch2,NbD]=FindDeltaBurst(Epoch,limIntDown);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(ts(Start(Down2)),limIntDown,1);
[BurstDeltaEpochB,NbD]=FindDeltaBurst2(Dpfc,limIntDown,1);


[MM1,TT1]=PlotRipRaw(LFPd,Range(Dpfc,'s'),800);close
test=max(TT1');
rg=Range(Dpfc,'s');

[rho1a,pval1a] = partialcorr(log(diff(Range(Dpfc,'s'))),test(2:end)',rg(2:end));rho1a
[rho1b,pval1b] = corrcoef(log(diff(Range(Dpfc,'s'))),test(2:end)');rho1b(2,1)
[rho2a,pval2a] = partialcorr(rg(2:end),test(2:end)',log(diff(Range(Dpfc,'s'))));rho2a
[rho2b,pval2b] = corrcoef(rg(2:end),test(2:end)');rho2b(2,1)
%[rho1a,rho1b(2,1),rho2a,rho2b(2,1)]
%[pval1a,pval1b(2,1),pval2a,pval2b(2,1)]

[MM2,TT2]=PlotRipRaw(LFPd,Range(Restrict(Dpfc,BurstDeltaEpochB),'s'),800);close
test2=max(TT2');
rg2=Range(Restrict(Dpfc,BurstDeltaEpochB),'s');
[rho1aE,pval1aE] = partialcorr(log(diff(Range(Restrict(Dpfc,BurstDeltaEpochB),'s'))),test2(2:end)',rg2(2:end));rho1a
[rho1bE,pval1bE] = corrcoef(log(diff(Range(Restrict(Dpfc,BurstDeltaEpochB),'s'))),test2(2:end)');rho1b(2,1)
[rho2aE,pval2aE] = partialcorr(rg2(2:end),test2(2:end)',log(diff(Range(Restrict(Dpfc,BurstDeltaEpochB),'s'))));rho2a
[rho2bE,pval2bE] = corrcoef(rg2(2:end),test2(2:end)');rho2b(2,1)
[rho1a,rho1b(2,1),rho2a,rho2b(2,1),rho1aE,rho1bE(2,1),rho2aE,rho2bE(2,1)]
[pval1a,pval1b(2,1),pval2a,pval2b(2,1),pval1aE,pval1bE(2,1),pval2aE,pval2bE(2,1)]

figure('color',[1 1 1]), hold on, 
subplot(2,2,1), scatter(log(diff(Range(Dpfc,'s'))),test(2:end)',10,rg(2:end),'filled')
subplot(2,2,2), scatter(log(diff(Range(Restrict(Dpfc,BurstDeltaEpochB),'s'))),test2(2:end)',20,rg2(2:end),'filled')
subplot(2,2,3), scatter(rg(2:end),test(2:end)',10,log(diff(Range(Dpfc,'s'))),'filled')
subplot(2,2,4), scatter(rg2(2:end),test2(2:end)',20,log(diff(Range(Restrict(Dpfc,BurstDeltaEpochB),'s'))),'filled')




% 
% BurstDeltaEpoch2: old Delta burst
% BurstDeltaEpochB: new Delta burst
% BurstDeltaEpoch: Down burst

% 
% [C1,B1]=CrossCorr(Start(Down),Range(Dpfc),150,10);
% [C2,B2]=CrossCorr(Range(Dpfc),Start(Down),150,10); 
% [C3,B3]=CrossCorr(Range(Dpfc),Range(Dpfc),150,10);
% [C4,B4]=CrossCorr(Start(Down),Start(Down),150,10);
% 
% figure('color',[1 1 1]), hold on, 
% plot(B4/1E3,C4,'o-','color',[0.5 0.5 0.5]),
% plot(B3/1E3,C3,'bo-'),
% plot(B2/1E3,C2,'ro-'),
% plot(B1/1E3,C1,'ko-'), 


%Down2=Down;


% 
% BurstDeltaEpoch2: old Delta burst
% BurstDeltaEpochB: new Delta burst
% BurstDeltaEpoch: Down burst

st=Start(Down2);en=End(Down2);
DurTsd=tsd(st(1:end-1),(en(1:end-1)-st(1:end-1)));
IntTsd=tsd(st(1:end-1),(st(2:end)-en(1:end-1)));

dur=Data(DurTsd);
in=Data(IntTsd);
durB=Data(Restrict(DurTsd,BurstDeltaEpoch));
inB=Data(Restrict(IntTsd,BurstDeltaEpoch));
% 
% figure('color',[1 1 1]), 
% subplot(2,2,1), plot(dur(2:end),dur(1:end-1),'k')
% subplot(2,2,2), plot(durB(2:end),durB(1:end-1),'k')
% subplot(2,2,3), plot(in(2:end),in(1:end-1),'k')
% subplot(2,2,4), plot(inB(2:end),inB(1:end-1),'k')


[Mdt,Tdt]=PlotRipRaw(LFPd,Start(Down2,'s'),1500,1);close
[Mst,Tst]=PlotRipRaw(LFPs,Start(Down2,'s'),1500,1);close

[MAd,idmad]=max(Tdt');
[MAs,idmas]=min(Tst');MAs=abs(MAs);
[Mat1d,bin11d,bin21d]=hist2d(10*log10(dur),10*log10(MAd(1:end-1)),[28:0.3:50],[28:0.1:38]);%50,50);
[Mat2d,bin12d,bin22d]=hist2d(10*log10(in),10*log10(MAd(1:end-1)),[28:0.3:50],[28:0.1:38]);%100,100);
[Mat1s,bin11s,bin21s]=hist2d(10*log10(dur),10*log10(MAs(1:end-1)),[28:0.3:50],[28:0.1:38]);%50,50);
[Mat2s,bin12s,bin22s]=hist2d(10*log10(in),10*log10(MAs(1:end-1)),[28:0.3:50],[28:0.1:38]);%100,100);

[rdd,pdd]=corrcoef(10*log10(dur),10*log10(MAd(1:end-1)));
[rsd,psd]=corrcoef(10*log10(dur),10*log10(MAs(1:end-1)));

[rd,pd]=corrcoef(10*log10(in),10*log10(MAd(1:end-1)));
[rs,ps]=corrcoef(10*log10(in),10*log10(MAs(1:end-1)));

smo=1;
figure('color',[1 1 1]),
subplot(2,2,1), imagesc(bin11d,bin21d,SmoothDec(Mat1d',[smo smo])), axis xy, title(['r=',num2str(rdd(2,1)),', p=',num2str(pdd(2,1))]), ylabel('Max delta deep'), xlabel('Dur Down')
subplot(2,2,2), imagesc(bin12d,bin22d,SmoothDec(Mat2d',[smo smo])), axis xy, title(['r=',num2str(rd(2,1)),', p=',num2str(pd(2,1))]), ylabel('Max delta deep'), xlabel('Int Down')
subplot(2,2,3), imagesc(bin11s,bin21s,SmoothDec(Mat1s',[smo smo])), axis xy, title(['r=',num2str(rsd(2,1)),', p=',num2str(psd(2,1))]), ylabel('Min delta sup'), xlabel('Dur Down')
subplot(2,2,4), imagesc(bin12s,bin22s,SmoothDec(Mat2s',[smo smo])), axis xy, title(['r=',num2str(rs(2,1)),', p=',num2str(ps(2,1))]), ylabel('Min delta sup'), xlabel('Int Down')




[Mat1d,bin11d,bin21d]=hist2d((dur)/1E4,(MAd(1:end-1)),[0:0.01:0.6],[1000:50:5000]);
[Mat2d,bin12d,bin22d]=hist2d((in)/1E4,(MAd(1:end-1)),[0:0.1:6],[1000:50:5000]);
[Mat1s,bin11s,bin21s]=hist2d((dur)/1E4,(MAs(1:end-1)),[0:0.01:0.6],[1000:50:5000]);
[Mat2s,bin12s,bin22s]=hist2d((in)/1E4,(MAs(1:end-1)),[0:0.1:6],[1000:50:5000]);


[rdd,pdd]=corrcoef((dur),(MAd(1:end-1)));
[rsd,psd]=corrcoef((dur),(MAs(1:end-1)));

[rd,pd]=corrcoef((in),(MAd(1:end-1)));
[rs,ps]=corrcoef((in),(MAs(1:end-1)));

smo=1;
figure('color',[1 1 1]),
subplot(2,2,1), imagesc(bin11d,bin21d,SmoothDec(Mat1d',[smo smo])), axis xy, title(['r=',num2str(rdd(2,1)),', p=',num2str(pdd(2,1))]), ylabel('Max delta deep'), xlabel('Dur Down')
subplot(2,2,2), imagesc(bin12d,bin22d,SmoothDec(Mat2d',[smo smo])), axis xy, title(['r=',num2str(rd(2,1)),', p=',num2str(pd(2,1))]), ylabel('Max delta deep'), xlabel('Int Down')
subplot(2,2,3), imagesc(bin11s,bin21s,SmoothDec(Mat1s',[smo smo])), axis xy, title(['r=',num2str(rsd(2,1)),', p=',num2str(psd(2,1))]), ylabel('Min delta sup'), xlabel('Dur Down')
subplot(2,2,4), imagesc(bin12s,bin22s,SmoothDec(Mat2s',[smo smo])), axis xy, title(['r=',num2str(rs(2,1)),', p=',num2str(ps(2,1))]), ylabel('Min delta sup'), xlabel('Int Down')


smo=1;
figure('color',[1 1 1]),
subplot(2,2,1), imagesc(bin11d,bin21d,SmoothDec(log(Mat1d+eps)',[smo smo])), axis xy, title(['r=',num2str(rdd(2,1)),', p=',num2str(pdd(2,1))]), ylabel('Max delta deep'), xlabel('Dur Down')
subplot(2,2,2), imagesc(bin12d,bin22d,SmoothDec(log(Mat2d+eps)',[smo smo])), axis xy, title(['r=',num2str(rd(2,1)),', p=',num2str(pd(2,1))]), ylabel('Max delta deep'), xlabel('Int Down')
subplot(2,2,3), imagesc(bin11s,bin21s,SmoothDec(log(Mat1s+eps)',[smo smo])), axis xy, title(['r=',num2str(rsd(2,1)),', p=',num2str(psd(2,1))]), ylabel('Min delta sup'), xlabel('Dur Down')
subplot(2,2,4), imagesc(bin12s,bin22s,SmoothDec(log(Mat2s+eps)',[smo smo])), axis xy, title(['r=',num2str(rs(2,1)),', p=',num2str(ps(2,1))]), ylabel('Min delta sup'), xlabel('Int Down')







%----------------------------------------------------------------------------

[hh1,bb1]=hist(Data(Restrict(DurTsd,Epoch-BurstDeltaEpoch))/1E4,[0:0.01:1.01]);
[hh2,bb2]=hist(Data(Restrict(DurTsd,BurstDeltaEpoch))/1E4,[0:0.01:1.01]);
[hh3,bb3]=hist(Data(Restrict(IntTsd,Epoch-BurstDeltaEpoch))/1E4,[0:0.01:5.01]);
[hh4,bb4]=hist(Data(Restrict(IntTsd,BurstDeltaEpoch))/1E4,[0:0.01:5.01]);

figure('color',[1 1 1]), 
subplot(3,3,[4,5 7,8]),hold on
plot(Data(Restrict(DurTsd,Epoch-BurstDeltaEpoch))/1E4,Data(Restrict(IntTsd,Epoch-BurstDeltaEpoch))/1E4,'ko','markersize',1)
plot(Data(Restrict(DurTsd,BurstDeltaEpoch))/1E4,Data(Restrict(IntTsd,BurstDeltaEpoch))/1E4,'ro','markersize',1)
xlim([0 1]), ylim([0 5])
subplot(3,3,1:2), hold on, 
plot(bb1,hh1,'k')
plot(bb2,hh2,'r'), xlim([0 1])
subplot(3,3,[6 9]), hold on, 
plot(hh3,bb3,'k')
plot(hh4,bb4,'r'), ylim([0 5])


[h1,b1]=hist(diff(Range(Dpfc,'s')),0:0.05:600);
[h,b]=hist(diff(Range(Restrict(Dpfc,BurstDeltaEpoch),'s')),0:0.05:600);
[hB,bB]=hist(diff(Range(Restrict(Dpfc,BurstDeltaEpochB),'s')),0:0.05:600);
[h2,b2]=hist(diff(Range(Restrict(Dpfc,BurstDeltaEpoch2),'s')),0:0.05:600);

[hd1,bd1]=hist(Data(IntTsd)/1E4,0:0.05:600);
[hd,bd]=hist((Data(Restrict(IntTsd,BurstDeltaEpoch))/1E4),0:0.05:600);
[hBd,bBd]=hist((Data(Restrict(IntTsd,BurstDeltaEpochB))/1E4),0:0.05:600);
[h2d,b2d]=hist((Data(Restrict(IntTsd,BurstDeltaEpoch2))/1E4),0:0.05:600);

[he1,be1]=hist(diff(Range(ts((Start(Down2)+End(Down2))/2),'s')),0:0.05:600);
[he,be]=hist(diff(Range(Restrict(ts((Start(Down2)+End(Down2))/2),BurstDeltaEpoch),'s')),0:0.05:600);
[hBe,bBe]=hist(diff(Range(Restrict(ts((Start(Down2)+End(Down2))/2),BurstDeltaEpochB),'s')),0:0.05:600);
[h2e,b2e]=hist(diff(Range(Restrict(ts((Start(Down2)+End(Down2))/2),BurstDeltaEpoch2),'s')),0:0.05:600);

% 
% BurstDeltaEpoch2: old Delta burst
% BurstDeltaEpochB: new Delta burst
% BurstDeltaEpoch: Down burst


figure('color',[1 1 1]), hold on, 
subplot(3,2,1), hold on, plot(b1,h1,'color',[0.5 0.5 0.5]), plot(b,h,'k'), plot(bB,hB,'b'), plot(b2,h2,'r'), xlim([0 5]), ylabel('Delta waves'), title('gray: total, black: Down ,blue: New burst, red: old burst')
subplot(3,2,2), hold on, plot(b1,h1,'color',[0.5 0.5 0.5]), plot(b,h,'k'), plot(bB,hB,'b'), plot(b2,h2,'r'), xlim([0 1])

subplot(3,2,3), hold on, plot(be1,he1,'color',[0.5 0.5 0.5]), plot(be,he,'k'), plot(bBe,hBe,'b'), plot(b2e,h2e,'r'), xlim([0 5]), ylabel('Down states (mid)')
subplot(3,2,4), hold on, plot(be1,he1,'color',[0.5 0.5 0.5]), plot(be,he,'k'), plot(bBe,hBe,'b'), plot(b2e,h2e,'r'), xlim([0 1])

subplot(3,2,5), hold on, plot(bd1,hd1,'color',[0.5 0.5 0.5]), plot(bd,hd,'k'), plot(bBd,hBd,'b'), plot(b2d,h2d,'r'), xlim([0 5]), ylabel('Down states (int)')
subplot(3,2,6), hold on, plot(bd1,hd1,'color',[0.5 0.5 0.5]), plot(bd,hd,'k'), plot(bBd,hBd,'b'), plot(b2d,h2d,'r'), xlim([0 1])



%----------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------
%----------------------------------------------------------------------------------------------------------------


% 
% BurstDeltaEpoch2: old Delta burst
% BurstDeltaEpochB: new Delta burst
% BurstDeltaEpoch: Down burst

[Md,Td]=PlotRipRaw(LFPd,Range(Restrict(ts((Start(Down2)+End(Down2))/2),BurstDeltaEpoch),'s'),800);close
[Ms,Ts]=PlotRipRaw(LFPs,Range(Restrict(ts((Start(Down2)+End(Down2))/2),BurstDeltaEpoch),'s'),800);close
[Md2,Td2]=PlotRipRaw(LFPd,Range(Restrict(ts((Start(Down2)+End(Down2))/2),Epoch-BurstDeltaEpoch),'s'),800);close
[Ms2,Ts2]=PlotRipRaw(LFPs,Range(Restrict(ts((Start(Down2)+End(Down2))/2),Epoch-BurstDeltaEpoch),'s'),800);close

figure('color',[1 1 1]), 
subplot(3,2,1), hold on, plot(Md(:,1),Md(:,2),'b'), plot(Ms(:,1),Ms(:,2),'r'), ylim([-800 800]), xlim([-0.8 0.8]), ylabel('Down'), title('Burst')
subplot(3,2,2), hold on, plot(Md2(:,1),Md2(:,2),'b'), plot(Ms2(:,1),Ms2(:,2),'r'), ylim([-800 800]), xlim([-0.8 0.8]), title('No Burst')

[Mdb,Tdb]=PlotRipRaw(LFPd,Range(Restrict(ts((Start(Down2)+End(Down2))/2),BurstDeltaEpoch2),'s'),800);close
[Msb,Tsb]=PlotRipRaw(LFPs,Range(Restrict(ts((Start(Down2)+End(Down2))/2),BurstDeltaEpoch2),'s'),800);close
[Md2b,Td2b]=PlotRipRaw(LFPd,Range(Restrict(ts((Start(Down2)+End(Down2))/2),Epoch-BurstDeltaEpoch2),'s'),800);close
[Ms2b,Ts2b]=PlotRipRaw(LFPs,Range(Restrict(ts((Start(Down2)+End(Down2))/2),Epoch-BurstDeltaEpoch2),'s'),800);close

% figure('color',[1 1 1]), 
subplot(3,2,3), hold on, plot(Mdb(:,1),Mdb(:,2),'b'), plot(Msb(:,1),Msb(:,2),'r'), ylim([-800 800]), xlim([-0.8 0.8]), ylabel('old')
subplot(3,2,4), hold on, plot(Md2b(:,1),Md2b(:,2),'b'), plot(Ms2b(:,1),Ms2b(:,2),'r'), ylim([-800 800]), xlim([-0.8 0.8])

[Mdc,Tdc]=PlotRipRaw(LFPd,Range(Restrict(ts((Start(Down2)+End(Down2))/2),BurstDeltaEpochB),'s'),800);close
[Msc,Tsc]=PlotRipRaw(LFPs,Range(Restrict(ts((Start(Down2)+End(Down2))/2),BurstDeltaEpochB),'s'),800);close
[Md2c,Td2c]=PlotRipRaw(LFPd,Range(Restrict(ts((Start(Down2)+End(Down2))/2),Epoch-BurstDeltaEpochB),'s'),800);close
[Ms2c,Ts2c]=PlotRipRaw(LFPs,Range(Restrict(ts((Start(Down2)+End(Down2))/2),Epoch-BurstDeltaEpochB),'s'),800);close

% figure('color',[1 1 1]), 
subplot(3,2,5), hold on, plot(Mdc(:,1),Mdc(:,2),'b'), plot(Msc(:,1),Msc(:,2),'r'), ylim([-800 800]), xlim([-0.8 0.8]), ylabel('new')
subplot(3,2,6), hold on, plot(Md2c(:,1),Md2c(:,2),'b'), plot(Ms2c(:,1),Ms2c(:,2),'r'), ylim([-800 800]), xlim([-0.8 0.8])


% 
% BurstDeltaEpoch2: old Delta burst
% BurstDeltaEpochB: new Delta burst
% BurstDeltaEpoch: Down burst
% 
% [m,s,tps]=mETAverage(Start(and(Down2,BurstDeltaEpoch)),Range(Qt),Data(Qt),10,500);
% [m2,s2,tps2]=mETAverage(Start(and(Down2,BurstDeltaEpoch2)),Range(Qt),Data(Qt),10,500);
% [mB,sB,tpsB]=mETAverage(Start(and(Down2,BurstDeltaEpochB)),Range(Qt),Data(Qt),10,500);
% 
% [mE,sE,tpsE]=mETAverage(Start(and(Down2,Epoch-BurstDeltaEpoch)),Range(Qt),Data(Qt),10,500);
% [m2E,s2E,tps2E]=mETAverage(Start(and(Down2,Epoch-BurstDeltaEpoch2)),Range(Qt),Data(Qt),10,500);
% [mBE,sBE,tpsBE]=mETAverage(Start(and(Down2,Epoch-BurstDeltaEpochB)),Range(Qt),Data(Qt),10,500);
% 
% figure('color',[1 1 1]),
% subplot(1,2,1), hold on,  
% plot(tps,m,'k'), 
% plot(tps2,m2,'r')
% plot(tpsB,mB,'b')
% xlim([tps(1) tps(end)])
% subplot(1,2,2), hold on,  
% plot(tpsE,mE,'k'), 
% plot(tps2E,m2E,'r')
% plot(tpsBE,mBE,'b')
% xlim([tps(1) tps(end)])
% 
% 
% figure('color',[1 1 1]),
% subplot(1,3,1), hold on,  
% plot(tps,m,'k'), 
% plot(tpsE,mE,'r'), 
% xlim([tps(1) tps(end)])
% subplot(1,3,2), hold on,  
% plot(tps2,m2,'k'),
% plot(tps2E,m2E,'r')
% xlim([tps(1) tps(end)])
% subplot(1,3,3), hold on,  
% plot(tpsB,mB,'k') 
% plot(tpsBE,mBE,'r')
% xlim([tps(1) tps(end)])


[M,T]=PlotRipRaw(Qt,Start(and(Down2,BurstDeltaEpoch),'s'),1500,1);close
[M2,T2]=PlotRipRaw(Qt,Start(and(Down2,BurstDeltaEpoch2),'s'),1500,1);close
[MB,TB]=PlotRipRaw(Qt,Start(and(Down2,BurstDeltaEpochB),'s'),1500,1);close

[ME,TE]=PlotRipRaw(Qt,Start(and(Down2,Epoch-BurstDeltaEpoch),'s'),1500,1);close
[M2E,T2E]=PlotRipRaw(Qt,Start(and(Down2,Epoch-BurstDeltaEpoch2),'s'),1500,1);close
[MBE,TBE]=PlotRipRaw(Qt,Start(and(Down2,Epoch-BurstDeltaEpochB),'s'),1500,1);close

figure('color',[1 1 1])
subplot(2,6,[1 2]), hold on, plot(M(:,1),M(:,2),'k'), plot(ME(:,1),ME(:,2),'r'), xlim([-1.5 1.5]), title('Down')
subplot(2,6,7),imagesc(T)
subplot(2,6,8),imagesc(TE)

subplot(2,6,[3 4]), hold on, plot(M2(:,1),M2(:,2),'k'), plot(M2E(:,1),M2E(:,2),'r'), xlim([-1.5 1.5]), title('old')
subplot(2,6,9),imagesc(T2)
subplot(2,6,10),imagesc(T2E)

subplot(2,6,[5 6]), hold on, plot(MB(:,1),MB(:,2),'k'), plot(MBE(:,1),MBE(:,2),'r'), xlim([-1.5 1.5]), title('new')
subplot(2,6,11),imagesc(TB)
subplot(2,6,12),imagesc(TBE)

% 
% BurstDeltaEpoch2: old Delta burst
% BurstDeltaEpochB: new Delta burst
% BurstDeltaEpoch: Down burst
