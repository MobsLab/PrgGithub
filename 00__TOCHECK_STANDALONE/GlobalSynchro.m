% GlobalSynchro
% Granger coherence crosscorr crosscorrpower enveloppe

LFP1=lfp1;
LFP2=lfp2;
try
    
try
    EpochOK;
    lfp1=Restrict(lfp1,EpochOK);
    lfp2=Restrict(lfp2,EpochOK);
end

params.tapers=[3 5];
params.Fs=1/median(diff(Range(lfp1,'s')));
params.fpass=[0 30];
params.err=[1 0.0500];
movingwin=[2.5 0.1];
GrangerOrder=14;
freq=[5,10];

tps=Range(lfp1);
Epoch=intervalSet(tps(1),tps(end));

[granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin]= GrangerMarie(lfp1,lfp2,Epoch,GrangerOrder,params,movingwin,1);
xlim(params.fpass)


[PeaksCH1,PeaksCH1,PeaksCH1,PeaksIdxCH1,upPeaksIdxCH1,downPeaksIdxCH1]=DetectExtremas(Data(FilterLFP(lfp1,freq,1048)));
[PeaksCH2,PeaksCH2,PeaksCH2,PeaksIdxCH2,upPeaksIdxCH2,downPeaksIdxCH2]=DetectExtremas(Data(FilterLFP(lfp2,freq,1048)));

tp=Range(lfp1,'ms');

[val,tiden,tadv,tdelay]=MinimalDistanceEvents(tp(upPeaksIdxCH1),tp(upPeaksIdxCH2));

[Hi,Bi]=hist(tiden,1E2);
[Ha,Ba]=hist(tadv,1E2);
[Hd,Bd]=hist(tdelay,1E2);

figure, 
subplot(1,2,1), hist(val,40), hold on, line([nanmean(val) nanmean(val)],ylim,'color','r'), title(num2str(mean(val)))
subplot(1,2,2), hold on, 
plot(Bi,Hi./(Hi+Ha+Hd)*100,'k'), 
plot(Ba,Ha./(Hi+Ha+Hd)*100,'b'), 
plot(Bd,Hd./(Hi+Ha+Hd)*100,'r')  


[X11,lag11]=xcorr(Data(lfp1),Data(lfp1),1E3);
[X22,lag22]=xcorr(Data(lfp2),Data(lfp2),1E3);
[X12,lag12]=xcorr(Data(lfp1),Data(lfp2),1E3);

[X11f,lag11f]=xcorr(Data(FilterLFP(lfp1,freq,1048)),Data(FilterLFP(lfp1,freq,1048)),1E3);
[X22f,lag22f]=xcorr(Data(FilterLFP(lfp2,freq,1048)),Data(FilterLFP(lfp2,freq,1048)),1E3);
[X12f,lag12f]=xcorr(Data(FilterLFP(lfp1,freq,1048)),Data(FilterLFP(lfp2,freq,1048)),1E3);

[lags, crosscorr, max_crosscorr_lag]=amp_crosscorr(Data(lfp1),Data(lfp2),1/median(diff(Range(lfp1,'s'))),freq(1),freq(2));
[C,phi,S12,S1,S2,t,f]=cohgramc(Data(lfp1),Data(lfp2),movingwin,params);

[Peaks11,PeaksU11,PeaksD11,PeaksIdx11,upPeaksIdx11,downPeaksIdx11]=DetectExtremas(X11);
[BE,id11]=sort(PeaksU11,'descend');idx11=upPeaksIdx11(id11(1:3));
[Peaks22,PeaksU22,PeaksD22,PeaksIdx22,upPeaksIdx22,downPeaksIdx22]=DetectExtremas(X22);
[BE,id22]=sort(PeaksU22,'descend');idx22=upPeaksIdx22(id22(1:3));
[Mx12,idx12]=max(abs(zscore(X12)));

[Peaks11f,PeaksU11f,PeaksD11f,PeaksIdx11f,upPeaksIdx11f,downPeaksIdx11f]=DetectExtremas(X11f);
[BE,id11f]=sort(PeaksU11f,'descend');idx11f=upPeaksIdx11f(id11f(1:3));
[Peaks22f,PeaksU22f,PeaksD22f,PeaksIdx22f,upPeaksIdx22f,downPeaksIdx22f]=DetectExtremas(X22f);
[BE,id22f]=sort(PeaksU22f,'descend');idx22f=upPeaksIdx22f(id22f(1:3));
[Mx12f,idx12f]=max(abs(zscore(X12f)));


figure, 
subplot(711),imagesc(t,f,10*log10(S1)'), axis xy, title('Spectrum S1')
subplot(712),imagesc(t,f,10*log10(S2)'), axis xy, title('Spectrum S2')
subplot(713),imagesc(t,f,phi'), axis xy, title('Phase difference')
subplot(714),imagesc(t,f,C'), axis xy, title('Coherence')
subplot(715),imagesc(t,f,10*log10(abs(S12))'), axis xy, title('Comodulation Power')
subplot(716),imagesc(t,f,zscore(real(S12))), axis xy, title('Real coherency')
subplot(717),imagesc(t,f,imag(S12)'), axis xy, caxis([-5 5]*1E3), title('Imaginary coherency')

figure, 
subplot(231),plot(lag11,X11);hold on, line([0 0],ylim,'color','k'), line([lag11(idx11)' lag11(idx11)'],ylim,'color',[0.8 0.5 0.1]), title(['Max = ',num2str(lag11(idx11))])
subplot(232),plot(lag22,X22);hold on, line([0 0],ylim,'color','k'), line([lag22(idx22)' lag22(idx22)'],ylim,'color',[0.8 0.5 0.1]), title(['Max = ',num2str(lag22(idx22))])
subplot(233),plot(lag12,X12);hold on, line([0 0],ylim,'color','k'), line([lag12(idx12)' lag12(idx12)'],ylim,'color',[0.8 0.5 0.1]), title(['Max = ',num2str(lag12(idx12))])
subplot(234),plot(lag11f,X11f);hold on, line([0 0],ylim,'color','k'), line([lag11f(idx11f)' lag11f(idx11f)'],ylim,'color',[0.8 0.5 0.1]), title(['Max = ',num2str(lag11f(idx11f))])
subplot(235),plot(lag22f,X22f);hold on, line([0 0],ylim,'color','k'), line([lag22f(idx22f)' lag22f(idx22f)'],ylim,'color',[0.8 0.5 0.1]), title(['Max = ',num2str(lag22f(idx22f))])
subplot(236),plot(lag12f,X12f);hold on, line([0 0],ylim,'color','k'), line([lag12f(idx12f)' lag12f(idx12f)'],ylim,'color',[0.8 0.5 0.1]), title(['Max = ',num2str(lag12f(idx12f))])

clear h b theta Kappa pval Rmean delta
for i=1:size(phi,2)
[theta(i), Kappa(i), pval(i), Rmean(i), delta(i)] = CircularMean(phi(:,i));
[h(i,:),b]=hist(phi(:,i),[-pi-pi/10:0.1:pi+pi/10]);
end

[Mkappa,idMaxKappa]=max(Kappa);
[Mpval,idMaxpval]=min(pval(2:end));
[Mrmean,idMaxRmean]=max(Rmean);
[Mdelta,idMaxdelta]=min(delta(2:end));
idMaxpval=idMaxpval+1;
idMaxdelta=idMaxdelta+1;

[Mc,idMaxC]=max(mean(C));
[MabsS12,idMaxAbsS12]=max(mean(abs(S12)));
[MimagS12,idMaxImageS12]=max(mean(abs(imag(S12))));
[Ms1,idMaxS1]=max(mean(S1));
[Ms2,idMaxS2]=max(mean(S2));
[Mphi,idMaxPhi]=max(mean(phi));

[R1,P1]=corrcoef(S1);
[R2,P2]=corrcoef(S2);
[RC,PC]=corrcoef(C);
[R,P]=corrcoef([S1 S2 C]);

figure, 
subplot(331),imagesc(f,f,R1), axis xy, ylabel('S1')
set(gca,'xtick',[0:2:10,15 20 25 30]), set(gca,'ytick',[0:2:10,15 20 25 30])
subplot(334),imagesc(f,f,R2), axis xy, ylabel('S2')
set(gca,'xtick',[0:2:10,15 20 25 30]), set(gca,'ytick',[0:2:10,15 20 25 30])
subplot(337),imagesc(f,f,RC), axis xy, ylabel('C')
set(gca,'xtick',[0:2:10,15 20 25 30]), set(gca,'ytick',[0:2:10,15 20 25 30])
subplot(3,3,[2 3 5 6 8 9]),imagesc(R), axis xy


figure, 
subplot(161), 
hold on, plot(f,theta,'color',[0.1 0.5 0.8])
hold on, plot(f,2*pi+theta,'color',[0.1 0.5 0.8])
hold on, plot(f,4*pi+theta,'color',[0.1 0.5 0.8])
hold on, plot(f,6*pi+theta,'color',[0.1 0.5 0.8])
title('mean Phase difference')
set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(162), imagesc(f,[-pi-pi/10:0.1:pi+pi/10],h'),title('Phase difference'),caxis([0 size(phi,1)/5]),set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(163), plot(f,Kappa),hold on, line([f(idMaxKappa) f(idMaxKappa)],ylim,'color','k'),title('mean Kappa'),set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(164), plot(f,pval),hold on, line([f(idMaxpval) f(idMaxpval)],ylim,'color','k'),title('mean p value'),set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(165), plot(f,Rmean),hold on, line([f(idMaxRmean) f(idMaxRmean)],ylim,'color','k'),title('mean Rmean'),set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(166), plot(f,delta),hold on, line([f(idMaxdelta) f(idMaxdelta)],ylim,'color','k'),title('mean Delta'),set(gca,'xtick',[0:2:10,15 20 25 30])

figure, 
subplot(161),plot(f,mean(C)),hold on, line([f(idMaxC) f(idMaxC)],ylim,'color','k'),title('Coherence'),set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(162),plot(f,mean(abs(S12))),hold on, line([f(idMaxAbsS12) f(idMaxAbsS12)],ylim,'color','k'),title('Amplitude comodulation'),set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(163),plot(f,mean(abs(imag(S12)))),hold on, line([f(idMaxImageS12) f(idMaxImageS12)],ylim,'color','k'),title('Imaginary coherence'),set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(164),plot(f,mean(S1)),hold on, line([f(idMaxS1) f(idMaxS1)],ylim,'color','k'),title('Power ch1'),set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(165),plot(f,mean(S2)),hold on, line([f(idMaxS2) f(idMaxS2)],ylim,'color','k'),title('Power ch2'),set(gca,'xtick',[0:2:10,15 20 25 30])
subplot(166),plot(f,mean(phi)),hold on, line([f(idMaxPhi) f(idMaxPhi)],ylim,'color','k'),title('Mean phase difference'),set(gca,'xtick',[0:2:10,15 20 25 30])

end

lfp1=LFP1;
lfp2=LFP2;

