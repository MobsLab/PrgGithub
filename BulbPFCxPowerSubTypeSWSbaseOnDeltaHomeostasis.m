%BulbPFCxPowerSubTypeSWSbaseOnDeltaHomeostasis

[As,Aw,Ar,rs,rsZ,rr,rrZ,rw,rwZ,idx1,idx2,S,NumNeurons,LFPd,LFPs,SWSEpoch,REMEpoch,Wake]=PowerDownHomeostasis(1,2);

idx=idx2;


clear t
clear f
clear Sp


load ChannelsToAnalyse/Bulb_deep
eval(['load SpectrumDataL/Spectrum',num2str(channel)])
Stsd1=tsd(t*1E4,Sp);

try
clear Sp
load ChannelsToAnalyse/PFCx_deep
eval(['load SpectrumDataL/Spectrum',num2str(channel)])
Stsd2=tsd(t*1E4,Sp);

end


figure('color',[1 1 1]), 
subplot(5,2,1), imagesc(t,f,10*log10(Data(Stsd1)')), axis xy
subplot(5,2,3), imagesc(Range((Restrict(Stsd1,subset(SWSEpoch,idx)')),'s'),f,10*log10(Data(Restrict(Stsd1,subset(SWSEpoch,idx))))'), axis xy
subplot(5,2,5), imagesc(Range((Restrict(Stsd1,subset(SWSEpoch,find(ismember([1:max(idx)],idx)-1))')),'s'),f,10*log10(Data(Restrict(Stsd1,subset(SWSEpoch,find(ismember([1:max(idx)],idx)-1)))))'), axis xy
try
subplot(5,2,2), imagesc(t,f,10*log10(Data(Stsd2)')), axis xy
subplot(5,2,4), imagesc(Range((Restrict(Stsd2,subset(SWSEpoch,idx)')),'s'),f,10*log10(Data(Restrict(Stsd2,subset(SWSEpoch,idx2))))'), axis xy
subplot(5,2,6), imagesc(Range((Restrict(Stsd2,subset(SWSEpoch,find(ismember([1:max(idx)],idx)-1))')),'s'),f,10*log10(Data(Restrict(Stsd2,subset(SWSEpoch,find(ismember([1:max(idx)],idx)-1)))))'), axis xy
end

subplot(5,2,7), hold on
plot(f,mean(Data(Restrict(Stsd1,subset(SWSEpoch,idx)))),'k','linewidth',2)
plot(f,mean(Data(Restrict(Stsd1,subset(SWSEpoch,find(ismember([1:max(idx)],idx)-1))))),'r','linewidth',2)

try
subplot(5,2,8), hold on
plot(f,mean(Data(Restrict(Stsd2,subset(SWSEpoch,idx)))),'k','linewidth',2)
plot(f,mean(Data(Restrict(Stsd2,subset(SWSEpoch,find(ismember([1:max(idx)],idx)-1))))),'r','linewidth',2)
end


subplot(5,2,9), hold on
plot(f,mean(Data(Restrict(Stsd1,subset(SWSEpoch,idx)))),'k','linewidth',2)
plot(f,mean(Data(Restrict(Stsd1,subset(SWSEpoch,find(ismember([1:max(idx)],idx)-1))))),'r','linewidth',2)
set(gca,'yscale','log')

try
subplot(5,2,10), hold on
plot(f,mean(Data(Restrict(Stsd2,subset(SWSEpoch,idx)))),'k','linewidth',2)
plot(f,mean(Data(Restrict(Stsd2,subset(SWSEpoch,find(ismember([1:max(idx)],idx)-1))))),'r','linewidth',2)
set(gca,'yscale','log')
end


