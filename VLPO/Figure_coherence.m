%%Figure cohérence VLPO-PFCx
load('SleepScoring_OBGamma.mat')
LowCohgramSB([cd filesep],14,'VLPO',1,'PFCx')
load('VLPO_PFCx_Low_Coherence.mat')
Cohtsd = tsd(Coherence{2}*1e4,Coherence{1});
Spectsd_PFC = tsd(SingleSpectro.ch2{2}*1e4,SingleSpectro.ch2{1});
Spectsd_VLPO = tsd(SingleSpectro.ch1{2}*1e4,SingleSpectro.ch1{1});

plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,Wake))),'b')
hold on
plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,SWSEpoch))),'r')
hold on
plot(Coherence{3},mean(Data(Restrict(Cohtsd,REMEpoch))),'g')


%%Figure cohérence VLPO-HPC
LowCohgramSB([cd filesep],14,'VLPO',6,'dHPC_deep')
load('VLPO_dHPC_deep_Low_Coherence.mat')
Cohtsd = tsd(Coherence{2}*1e4,Coherence{1});
Spectsd_PFC = tsd(SingleSpectro.ch2{2}*1e4,SingleSpectro.ch2{1});
Spectsd_VLPO = tsd(SingleSpectro.ch1{2}*1e4,SingleSpectro.ch1{1});

plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,Wake))),'b')
hold on
plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,SWSEpoch))),'r')
hold on
plot(Coherence{3},mean(Data(Restrict(Cohtsd,REMEpoch))),'g')

%%Figure cohérence VLPO-Bulb

LowCohgramSB([cd filesep],14,'VLPO',3,'Bulb_deep')
load('VLPO_Bulb_deep_Low_Coherence.mat')
Cohtsd = tsd(Coherence{2}*1e4,Coherence{1});
Spectsd_PFC = tsd(SingleSpectro.ch2{2}*1e4,SingleSpectro.ch2{1});
Spectsd_VLPO = tsd(SingleSpectro.ch1{2}*1e4,SingleSpectro.ch1{1});

plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,Wake))),'b')
hold on
plot(Coherence{3},nanmean(Data(Restrict(Cohtsd,SWSEpoch))),'r')
hold on
plot(Coherence{3},mean(Data(Restrict(Cohtsd,REMEpoch))),'g')
