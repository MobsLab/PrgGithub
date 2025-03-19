load('REMGammaModulation.mat')
load('StateEpochSB.mat','REMEpoch')
load('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251/SpectrumDataL/Spectrum22.mat')
SptsdH=tsd(t*1e4,Sp);
load('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251/SpectrumDataL/Spectrum11.mat')
SptsdP=tsd(t*1e4,Sp);
load('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251/SpectrumDataL/Spectrum12.mat')
SptsdB=tsd(t*1e4,Sp);
dt=median(diff(Range(Sptsd,'s')));
maxt=dt*length(Range(Restrict(Sptsd,REMEpoch),'s'));
figure
subplot(311)
Sptsd=SptsdH;
imagesc([dt:dt:maxt],f,log(Data(Restrict(Sptsd,REMEpoch))')), axis xy
box off, set(gca,'XTick',[])
hold on,line([50 50+60*5],[2 2],'color','k','linewidth',5)
title('HPC')

subplot(312)
Sptsd=SptsdP;
imagesc([dt:dt:maxt],f,log(Data(Restrict(Sptsd,REMEpoch))')), axis xy
title('PFCx')

subplot(313)
Sptsd=SptsdB;
imagesc([dt:dt:maxt],f,log(Data(Restrict(Sptsd,REMEpoch))')), axis xy
title('OB')

ind=47;

subplot(311)
Sptsd=SptsdH;
imagesc(Range(Restrict(Sptsd,subset(REMEpoch,ind)),'s'),f,log(Data(Restrict(Sptsd,subset(REMEpoch,ind)))')), axis xy
title('HPC')

subplot(312)
Sptsd=SptsdP;
imagesc(Range(Restrict(Sptsd,subset(REMEpoch,ind)),'s'),f,log(Data(Restrict(Sptsd,subset(REMEpoch,ind)))')), axis xy
title('PFCx')

subplot(313)
Sptsd=SptsdB;
imagesc(Range(Restrict(Sptsd,subset(REMEpoch,ind)),'s'),f,log(Data(Restrict(Sptsd,subset(REMEpoch,ind)))')), axis xy
title('OB')
caxis([3.4 13.2])


