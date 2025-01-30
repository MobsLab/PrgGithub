%ObsNoellia



load SpindlesRipples Rip
load Spindles SpiH SpiL

load LFPdHPC

M1=PlotRipRaw(LFP{1},Rip(:,2),80);
M1=PlotRipRaw(LFP{2},Rip(:,2),80);
M1=PlotRipRaw(LFP{3},Rip(:,2),80);

load LFPPFCx


load StateEpoch NoiseEpoch WeirdNoiseEpoch GndNoiseEpoch SWSEpoch
Epoch=SWSEpoch;
Epoch=Epoch-NoiseEpoch;
Epoch=Epoch-GndNoiseEpoch;
Epoch=Epoch-WeirdNoiseEpoch;
load behavResources PreEpoch VEHEpoch LPSEpoch H24Epoch H48Epoch

Epoch1=and(Epoch,PreEpoch);
Epoch1=and(Epoch,LPSEpoch);
%[tDeltaT2,tDeltaP2,spiPeaks,ripts,ma,sa,tpsa,mb,sb,tpsb,mc,sc,tpsc,md,sd,tpsd,me,se,tpse]=IdentifyDeltaSpindlesRipples(Restrict(LFP,Epoch1),3,1,2000,1);
%[]

ylF=[0 0];
figure('color',[1 1 1]), 
for i=1:3
M1{i}=PlotRipRaw(LFP{1},SpiH{2,i},500);close
M2{i}=PlotRipRaw(LFP{2},SpiH{2,i},500);close
M3{i}=PlotRipRaw(LFP{3},SpiH{2,i},500);close
subplot(3,1,i),plot(M1{i}(:,1),M1{i}(:,2),'b','linewidth',2)
hold on, plot(M2{i}(:,1),M2{i}(:,2),'k','linewidth',2)
hold on, plot(M3{i}(:,1),M3{i}(:,2),'r','linewidth',2)
yl=ylim;
ylF=[min(ylF(1),yl(1)) max(ylF(2),yl(2))];
end
subplot(3,1,1),ylim(ylF)
subplot(3,1,2),ylim(ylF)
subplot(3,1,3),ylim(ylF)




