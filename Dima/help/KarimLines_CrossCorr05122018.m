
load SleepScoring_OBGamma Wake REMEpoch SWSEpoch
load SpikeData
load Ripples
rip=ts(ripples(:,2)*1E4);

for i=1:length(S)
Fr(i,1)=length(Range(Restrict(S{i},Wake)))/sum(End(Wake,'s')-Start(Wake,'s'));
Fr(i,2)=length(Range(Restrict(S{i},SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
Fr(i,3)=length(Range(Restrict(S{i},REMEpoch)))/sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
end

PlotErrorBar3(Fr(:,1),Fr(:,2),Fr(:,3))
PlotErrorBar3(Fr(:,1)./Fr(:,1),Fr(:,2)./Fr(:,1),Fr(:,3)./Fr(:,1))

[C,B]=CrossCorr(Range(rip),Range(PoolNeurons(S,1:length(S))),1,300);
[Cwa,Bwa]=CrossCorr(Range(Restrict(rip,Wake)),Range(PoolNeurons(S,1:length(S))),1,300);
[Csw,Bsw]=CrossCorr(Range(Restrict(rip,SWSEpoch)),Range(PoolNeurons(S,1:length(S))),1,300);
figure, 
subplot(2,1,1),plot(B/1E3,C,'k')
subplot(2,1,2),plot(B/1E3,Cwa,'b'), hold on, plot(B/1E3,Csw,'r','linewidth',2)


clear Cs
for i=1:length(S)  
 [Cs(i,:),Bs]=CrossCorr(Range(rip),Range(S{i}),1,300);   
end
figure, 
subplot(4,1,1), plot(Bs,mean(zscore(Cs')'),'k')
subplot(4,1,2:4), imagesc(Bs,1:length(S),zscore(Cs')')


figure, hold on
plot(Bs,runmean(mean(zscore(Cs')'),1),'k')


plot(Bs,runmean(mean(zscore(Cs(1:22,:)')'),1),'k')
plot(Bs,runmean(mean(zscore(Cs(23:end,:)')'),1),'r')


