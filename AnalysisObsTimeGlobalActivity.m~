function [M2t,tps2]=AnalysisObsTimeGlobalActivity



load StateEpochSB SWSEpoch REMEpoch Wake

load RipplesdHPC25
rip=ts(dHPCrip(:,2)*1E4);
[M1t,tps1,M2t{1},tps2,id]=ObsTimeGlobalActivity(Restrict(rip,Wake));title(['SPWR Wake ',num2str(length(Range(Restrict(rip,SWSEpoch))))])
[M1t,tps1,M2t{2},tps2,id]=ObsTimeGlobalActivity(Restrict(rip,SWSEpoch));title(['SPW SWS ',num2str(length(Range(Restrict(rip,SWSEpoch))))])

load DeltaPFCx
[M1t,tps1,M2t{3},tps2,id]=ObsTimeGlobalActivity(Restrict(tDeltaT2,Wake));title(['Delta Wave PFC Wake ',num2str(length(Range(Restrict(tDeltaT2,Wake))))])
[M1t,tps1,M2t{4},tps2,id]=ObsTimeGlobalActivity(Restrict(tDeltaT2,SWSEpoch));title(['Delta Wave PFC SWS ',num2str(length(Range(Restrict(tDeltaT2,SWSEpoch))))])

load DeltaPaCx
[M1t,tps1,M2t{5},tps2,id]=ObsTimeGlobalActivity(Restrict(tDeltaT2,Wake));title(['Delta Wave Par Wake ',num2str(length(Range(Restrict(tDeltaT2,Wake))))])
[M1t,tps1,M2t{6},tps2,id]=ObsTimeGlobalActivity(Restrict(tDeltaT2,SWSEpoch));title(['Delta Wave Par SWS ',num2str(length(Range(Restrict(tDeltaT2,SWSEpoch))))])

load SpindlesPFCxDeep
spiL=ts(SpiLow(:,2)*1E4);
spiH=ts(SpiHigh(:,2)*1E4);
[M1t,tps1,M2t{7},tps2,id]=ObsTimeGlobalActivity(Restrict(spiH,Wake));title(['High Spindles PFC Wake ',num2str(length(Range(Restrict(spiH,Wake))))])
[M1t,tps1,M2t{8},tps2,id]=ObsTimeGlobalActivity(Restrict(spiH,SWSEpoch));title(['High Spindles PFC SWS ',num2str(length(Range(Restrict(spiH,SWSEpoch))))])
[M1t,tps1,M2t{9},tps2,id]=ObsTimeGlobalActivity(Restrict(spiL,Wake));title(['Low Spindles PFC Wake ',num2str(length(Range(Restrict(spiL,Wake))))])
[M1t,tps1,M2t{10},tps2,id]=ObsTimeGlobalActivity(Restrict(spiL,SWSEpoch));title(['Low Spindles PFC SWS ',num2str(length(Range(Restrict(spiL,SWSEpoch))))])

load SpindlesPFCxSup
spiL=ts(SpiLow(:,2)*1E4);
spiH=ts(SpiHigh(:,2)*1E4);
[M1t,tps1,M2t{11},tps2,id]=ObsTimeGlobalActivity(Restrict(spiH,Wake));title(['High Spindles (sup) PFC Wake ',num2str(length(Range(Restrict(spiH,Wake))))])
[M1t,tps1,M2t{12},tps2,id]=ObsTimeGlobalActivity(Restrict(spiH,SWSEpoch));title(['High Spindles (sup) PFC SWS ',num2str(length(Range(Restrict(spiH,SWSEpoch))))])
[M1t,tps1,M2t{13},tps2,id]=ObsTimeGlobalActivity(Restrict(spiL,Wake));title(['Low Spindles PFC Wake ',num2str(length(Range(Restrict(spiL,Wake))))])
[M1t,tps1,M2t{14},tps2,id]=ObsTimeGlobalActivity(Restrict(spiL,SWSEpoch));title(['Low Spindles PFC SWS ',num2str(length(Range(Restrict(spiL,SWSEpoch))))])

load SpindlesPaCxDeep
spiL=ts(SpiLow(:,2)*1E4);
spiH=ts(SpiHigh(:,2)*1E4);
[M1t,tps1,M2t{15},tps2,id]=ObsTimeGlobalActivity(Restrict(spiH,Wake));title(['High Spindles Par Wake ',num2str(length(Range(Restrict(spiH,Wake))))])
[M1t,tps1,M2t{16},tps2,id]=ObsTimeGlobalActivity(Restrict(spiH,SWSEpoch));title(['High Spindles Par SWS ',num2str(length(Range(Restrict(spiH,SWSEpoch))))])
[M1t,tps1,M2t{17},tps2,id]=ObsTimeGlobalActivity(Restrict(spiL,Wake));title(['Low Spindles Par Wake ',num2str(length(Range(Restrict(spiL,Wake))))])
[M1t,tps1,M2t{18},tps2,id]=ObsTimeGlobalActivity(Restrict(spiL,SWSEpoch));title(['Low Spindles Par SWS ',num2str(length(Range(Restrict(spiL,SWSEpoch))))])
