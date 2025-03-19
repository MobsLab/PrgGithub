



eve=ts(spindles_PFCx(:,2)*1E4);
eve=Restrict(eve,SWSEpoch-TotalNoiseEpoch);
eve=Range(eve);
[m,s,tps]=mETAverage(eve,Range(LFPp),Data(LFPp),10,200);
[md,sd,tpsd]=mETAverage(eve,Range(LFPpd),Data(LFPpd),10,200);
[mv,sv,tpsv]=mETAverage(eve,Range(LFPv),Data(LFPv),10,200);
[mh,sh,tpsh]=mETAverage(eve,Range(LFPh),Data(LFPh),10,200);

figure, plot(tps,m,'k')
hold on, plot(tpsd,md,'color',[0.7 0.7 0.7])
hold on, plot(tpsv,mv,'r')
hold on, plot(tpsh,mh,'b')
title('spindles')

eve=ts(Ripples(:,2)*10);
eve=Restrict(eve,SWSEpoch-TotalNoiseEpoch);
eve=Range(eve);
[m,s,tps]=mETAverage(eve,Range(LFPp),Data(LFPp),1,400);
[md,sd,tpsd]=mETAverage(eve,Range(LFPpd),Data(LFPpd),1,400);
[mv,sv,tpsv]=mETAverage(eve,Range(LFPv),Data(LFPv),1,400);
[mh,sh,tpsh]=mETAverage(eve,Range(LFPh),Data(LFPh),1,400);

figure, plot(tps,m,'k')
hold on, plot(tpsd,md,'color',[0.7 0.7 0.7])
hold on, plot(tpsv,mv,'r')
hold on, plot(tpsh,mh,'b')
title('ripples')

eve=ts(Start(deltas_PFCx));
eve=Restrict(eve,SWSEpoch-TotalNoiseEpoch);
eve=Range(eve);
[m,s,tps]=mETAverage(eve,Range(LFPp),Data(LFPp),10,200);
[md,sd,tpsd]=mETAverage(eve,Range(LFPpd),Data(LFPpd),10,200);
[mv,sv,tpsv]=mETAverage(eve,Range(LFPv),Data(LFPv),10,200);
[mh,sh,tpsh]=mETAverage(eve,Range(LFPh),Data(LFPh),10,200);

figure, plot(tps,m,'k')
hold on, plot(tpsd,md,'color',[0.7 0.7 0.7])
hold on, plot(tpsv,mv,'r')
hold on, plot(tpsh,mh,'b')
title('delta waves')

