load('LFPData/LFP2.mat')
events=Start(TTLEpoch_merged)/1E4;
[M,T] = PlotRipRaw(LFP, events, 180, 0, 1);




%%%%%



pf = mean(Spectro{1},1),mean(Data(Restrict(tsd,REMEpoch)))
pf = mean(Spectro{1},1)
plot(freq,10*log10(pf))
Spectr=Restrict(SpectroH{1},REMEpoch)


%%%%A utiliser 
sptsd = tsd(Spectro{2}*1e4, Spectro{1})
pREM = mean(Data(Restrict(sptsd,REMEpoch)))
freq = Spectro{3};
plot(freq,freq.*pf)

sptsd = tsd(Spectro{2}*1e4, Spectro{1})
pSWS = mean(Data(Restrict(sptsd,SWSEpoch)))
freq = Spectro{3};
plot(freq,freq.*pf)


sptsd = tsd(Spectro{2}*1e4, Spectro{1})
pREM = mean(Data(Restrict(sptsd,WakeEpoch)))
freq = Spectro{3};
plot(freq,freq.*pf)






