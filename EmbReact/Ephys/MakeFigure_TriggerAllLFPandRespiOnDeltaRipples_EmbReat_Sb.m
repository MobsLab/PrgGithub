clear all
load('Ripples.mat')
Ripples_ts = ts(Ripples(:,2)*10);
Ripples_ts  = Restrict(Ripples_ts,SWSEpoch);
load('DeltaWaves.mat')

load('ChannelsToAnalyse/Respi.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
FilLFP=FilterLFP((LFP),[1 20],1024);
[M.Resp.StartDelta,T] = PlotRipRaw(FilLFP,Start(deltas_PFCx,'s'),2000,0,0);
[M.Resp.StopDelta,T] = PlotRipRaw(FilLFP,Stop(deltas_PFCx,'s'),2000,0,0);
[M.Resp.Ripples,T] = PlotRipRaw(FilLFP,Range(Ripples_ts,'s'),2000,0,0); 

load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
[M.OB.StartDelta,T] = PlotRipRaw(LFP,Start(deltas_PFCx,'s'),2000,0,0);
[M.OB.StopDelta,T] = PlotRipRaw(LFP,Stop(deltas_PFCx,'s'),2000,0,0);
[M.OB.Ripples,T] = PlotRipRaw(LFP,Range(Ripples_ts,'s'),2000,0,0);

load('ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
[M.EKG.StartDelta,T] = PlotRipRaw(LFP,Start(deltas_PFCx,'s'),2000,0,0);
[M.EKG.StopDelta,T] = PlotRipRaw(LFP,Stop(deltas_PFCx,'s'),2000,0,0);
[M.EKG.Ripples,T] = PlotRipRaw(LFP,Range(Ripples_ts,'s'),2000,0,0);

load('ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
[M.HPC.StartDelta,T] = PlotRipRaw(LFP,Start(deltas_PFCx,'s'),2000,0,0);
[M.HPC.StopDelta,T] = PlotRipRaw(LFP,Stop(deltas_PFCx,'s'),2000,0,0);
[M.HPC.Ripples,T] = PlotRipRaw(LFP,Range(Ripples_ts,'s'),2000,0,0);

load('ChannelsToAnalyse/PFCx_deltadeep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
[M.PFCx_deltadeep.StartDelta,T] = PlotRipRaw(LFP,Start(deltas_PFCx,'s'),2000,0,0);
[M.PFCx_deltadeep.StopDelta,T] = PlotRipRaw(LFP,Stop(deltas_PFCx,'s'),2000,0,0);
[M.PFCx_deltadeep.Ripples,T] = PlotRipRaw(LFP,Range(Ripples_ts,'s'),2000,0,0);

load('ChannelsToAnalyse/PFCx_deltasup.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
[M.PFCx_deltasup.StartDelta,T] = PlotRipRaw(LFP,Start(deltas_PFCx,'s'),2000,0,0);
[M.PFCx_deltasup.StopDelta,T] = PlotRipRaw(LFP,Stop(deltas_PFCx,'s'),2000,0,0);
[M.PFCx_deltasup.Ripples,T] = PlotRipRaw(LFP,Range(Ripples_ts,'s'),2000,0,0);

figure
subplot(5,3,1)
shadedErrorBar(M.EKG.StartDelta(:,1),M.EKG.StartDelta(:,2),M.EKG.StartDelta(:,4))
title('Start Delta')
ylabel('EKG')

subplot(5,3,2)
shadedErrorBar(M.EKG.StopDelta(:,1),M.EKG.StopDelta(:,2),M.EKG.StopDelta(:,4))
title('Stop Delta')

subplot(5,3,3)
shadedErrorBar(M.EKG.Ripples(:,1),M.EKG.Ripples(:,2),M.EKG.Ripples(:,4))
title('Ripples')

subplot(5,3,4)
shadedErrorBar(M.Resp.StartDelta(:,1),M.Resp.StartDelta(:,2),M.Resp.StartDelta(:,4))
title('Start Delta')
ylabel('Resp')

subplot(5,3,5)
shadedErrorBar(M.Resp.StopDelta(:,1),M.Resp.StopDelta(:,2),M.Resp.StopDelta(:,4))
title('Stop Delta')

subplot(5,3,6)
shadedErrorBar(M.Resp.Ripples(:,1),M.Resp.Ripples(:,2),M.Resp.Ripples(:,4))
title('Ripples')

subplot(5,3,7)
shadedErrorBar(M.OB.StartDelta(:,1),M.OB.StartDelta(:,2),M.OB.StartDelta(:,4))
title('Start Delta')
ylabel('OB')

subplot(5,3,8)
shadedErrorBar(M.OB.StopDelta(:,1),M.OB.StopDelta(:,2),M.OB.StopDelta(:,4))
title('Stop Delta')

subplot(5,3,9)
shadedErrorBar(M.OB.Ripples(:,1),M.OB.Ripples(:,2),M.OB.Ripples(:,4))
title('Ripples')

subplot(5,3,10)
shadedErrorBar(M.PFCx_deltadeep.StartDelta(:,1),M.PFCx_deltadeep.StartDelta(:,2),M.PFCx_deltadeep.StartDelta(:,4),'r'), hold on
shadedErrorBar(M.PFCx_deltasup.StartDelta(:,1),M.PFCx_deltasup.StartDelta(:,2),M.PFCx_deltasup.StartDelta(:,4),'b'), hold on
title('Start Delta')
ylabel('PFC')

subplot(5,3,11)
shadedErrorBar(M.PFCx_deltadeep.StopDelta(:,1),M.PFCx_deltadeep.StopDelta(:,2),M.PFCx_deltadeep.StopDelta(:,4),'r'), hold on
shadedErrorBar(M.PFCx_deltasup.StopDelta(:,1),M.PFCx_deltasup.StopDelta(:,2),M.PFCx_deltasup.StopDelta(:,4),'b'), hold on
title('Stop Delta')

subplot(5,3,12)
shadedErrorBar(M.PFCx_deltadeep.Ripples(:,1),M.PFCx_deltadeep.Ripples(:,2),M.PFCx_deltadeep.Ripples(:,4),'r'), hold on
shadedErrorBar(M.PFCx_deltasup.Ripples(:,1),M.PFCx_deltasup.Ripples(:,2),M.PFCx_deltasup.Ripples(:,4),'b'), hold on
title('Ripples')

subplot(5,3,13)
shadedErrorBar(M.HPC.StartDelta(:,1),M.HPC.StartDelta(:,2),M.HPC.StartDelta(:,4)), hold on
title('Start Delta')
ylabel('HPC')

subplot(5,3,14)
shadedErrorBar(M.HPC.StopDelta(:,1),M.HPC.StopDelta(:,2),M.HPC.StopDelta(:,4)), hold on
title('Stop Delta')

subplot(5,3,15)
shadedErrorBar(M.HPC.Ripples(:,1),M.HPC.Ripples(:,2),M.HPC.Ripples(:,4)), hold on
title('Ripples')










