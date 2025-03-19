clear all,
load('behavResources.mat')
load('LFPData/DigInfo2.mat')
StimEpoch=thresholdIntervals(DigTSD,0.8);
StimEpoch=intervalSet(Start(StimEpoch)-5*1e4,Stop(StimEpoch)+5*1e4);
FreezeEpoch=FreezeEpoch-StimEpoch;


load('ChannelsToAnalyse/Bulb_deep.mat')
chB=channel;
load(['LFPData/LFP',num2str(chB),'.mat']);
LFPAll.OB=LFP;
clear y LFP

try
    load('ChannelsToAnalyse/dHPC_deep.mat')
    chH=channel;
catch
    load('ChannelsToAnalyse/dHPC_rip.mat')
    chH=channel;
end
load(['LFPData/LFP',num2str(chH),'.mat']);
LFPAll.HPC=LFP;

clear y LFP
load('ChannelsToAnalyse/PFCx_deep.mat')
chP=channel;
load(['LFPData/LFP',num2str(chP),'.mat']);
LFPAll.PFCx=LFP;

FreqRange=[1:12;[3:14]];
[Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.HPC,FreqRange,FreezeEpoch,500,0);
save OBHPCPhaseCoupling.mat Index IndexRand Phase
clear Index IndexRand Phase 

[Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.PFCx,FreqRange,FreezeEpoch,500,0);
save OBPFCxPhaseCoupling.mat Index IndexRand Phase 
clear Index IndexRand Phase 

[Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.PFCx,LFPAll.HPC,FreqRange,FreezeEpoch,500,0);
save PFCxHPPhaseCoupling.mat Index IndexRand Phase 
clear Index IndexRand Phase 
