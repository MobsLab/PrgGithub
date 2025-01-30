load('LFPData/LFP2.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);