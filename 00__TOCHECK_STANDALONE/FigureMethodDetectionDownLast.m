
%FigureMethodDetectionDownLast







cd('/Volumes/My Passport/DataElectroPhy/DataMice/SonsRandom/Mouse244')
cd('/Volumes/My Passport/DataElectroPhy/DataMice/SonsRandom/Mouse243')
cd('/Volumes/My Passport/DataElectroPhy/DataMice/SleepBasal/Mouse243')
 cd('/Volumes/My Passport/DataElectroPhy/DataMice/SleepBasal/Mouse244')

clear

load SpikeData
[Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');
load StateEpochSB SWSEpoch Wake REMEpoch
[Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4,MQ,TQ]=FindDown(S,NumNeurons,SWSEpoch,10,0.01,1,1,[0 70],1);close

FR=length(Range(Restrict(poolNeurons(S,NumNeurons),SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
FR2=FR/length(NumNeurons);

figure('color',[1 1 1]), 
subplot(1,2,1), hold on
plot(b1,h1,'r','linewidth',2)
plot(b2,h2,'k','linewidth',2)
set(gca,'yscale','log')
set(gca,'xscale','log')
set(gca,'xtick',[10 50 100 500 1500])
xlim([0 1900])
yl=ylim; line([50 50],yl,'color',[0.8 0.8 0.8],'linestyle','--')
yl=ylim; line([100 100],yl,'color',[0.8 0.8 0.8],'linestyle','--')
yl=ylim; line([250 250],yl,'color',[0.8 0.8 0.8],'linestyle','--')
yl=ylim; line([70 70],yl,'color','b','linewidth',2)
xlabel('Duration of Down (ms)')
ylabel('Nb of Down')
title(' 50ms           100ms             250ms         ')

st=Start(Down,'s');en=End(Down,'s');
dur=en-st;
[BD,id]=sort(dur,'Descend');

subplot(1,2,2), hold on
try
imagesc(TQ(id,:))
catch
    dur=en(1:5000)-st(1:5000);
    [BD,id]=sort(dur,'Descend');
    imagesc(MQ(:,1),1:size(TQ,1), TQ(id,:)), xlim([-0.3 0.6]), ylim([0 size(TQ,1)]), colorbar, title([num2str(length(NumNeurons)),',  Fr: ',num2str(FR),',  Fr2: ',num2str(FR2)])
end
caxis([0 0.2])
