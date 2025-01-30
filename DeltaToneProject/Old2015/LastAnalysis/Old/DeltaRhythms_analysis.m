load behavResources

EpochSleep1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
EpochDelta1=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
EpochSleep2=intervalSet(tpsdeb{3}*1E4,tpsfin{3}*1E4);
EpochDelta2=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
EpochSleep3=intervalSet(tpsdeb{5}*1E4,tpsfin{5}*1E4);

load newDeltaPaCx

figure, subplot(5,1,1)
Delta=Restrict(ts(tDelta),EpochSleep1);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
hold on, plot(b1,smooth(h1a,3),'k','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3])
title(['Sleep Session 1 : 8-10h '])

Delta=Restrict(ts(tDelta),EpochDelta1);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
hold on, subplot(5,1,2)
hold on, plot(b1,smooth(h1a,3),'k','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3])
title(['Delta Session 1 : 10-12h '])

Delta=Restrict(ts(tDelta),EpochSleep2);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
hold on, subplot(5,1,3)
hold on, plot(b1,smooth(h1a,3),'k','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3])
title(['Sleep Session 2 : 12-14h '])

Delta=Restrict(ts(tDelta),EpochDelta2);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
hold on, subplot(5,1,4)
hold on, plot(b1,smooth(h1a,3),'k','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3])
title(['Delta Session 2 : 14-16h '])

Delta=Restrict(ts(tDelta),EpochSleep3);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
hold on, subplot(5,1,5)
hold on, plot(b1,smooth(h1a,3),'k','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3])
title(['Sleep Session 2 : 16-18h '])


%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

load newDeltaPaCx
Delta=Restrict(ts(tDelta),EpochDelta1);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[hD1a,bD1a]=hist(d,[-0.01:0.02:3.1]);
[hD1b,bD1b]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=Restrict(ts(tDelta),EpochDelta2);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[hD2a,bD2a]=hist(d,[-0.01:0.02:3.1]);
[hD2b,bD2b]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);


%---
figure, subplot(2,1,1)

Delta=Restrict(ts(tDelta),EpochSleep1);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
hold on, plot(b1,smooth(h1a,3),'k','linewidth',2), 
hold on, plot(b2,smooth(h2a,3),'k'), xlim([0 3])

Delta=Restrict(ts(tDelta),EpochSleep2);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
hold on, plot(b1,smooth(h1a,3),'b','linewidth',2), 
hold on, plot(b2,smooth(h2a,3),'b'), xlim([0 3])

hold on, plot(bD1a,smooth(hD1a,3),'r','linewidth',2), 
hold on, plot(bD1b,smooth(hD1b,3),'r'), xlim([0 3])
hold on, legend(['PRE Sleep'],['burst'],['POST Sleep'],['burst'],['Delta Sleep'],['burst'])
title(['Delta Session 1 : 10-12h '])

%---
hold on, subplot(2,1,2)

Delta=Restrict(ts(tDelta),EpochSleep2);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
hold on, plot(b1,smooth(h1a,3),'k','linewidth',2), 
hold on, plot(b2,smooth(h2a,3),'k'), xlim([0 3])

Delta=Restrict(ts(tDelta),EpochSleep3);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
hold on, plot(b1,smooth(h1a,3),'b','linewidth',2), 
hold on, plot(b2,smooth(h2a,3),'b'), xlim([0 3])

hold on, plot(bD2a,smooth(hD2a,3),'r','linewidth',2), 
hold on, plot(bD2b,smooth(hD2b,3),'r'), xlim([0 3])

hold on, legend(['PRE Sleep'],['burst'],['POST Sleep'],['burst'],['Delta Sleep'],['burst'])
title(['Delta Session 2 : 14-16h '])
%---


%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

Delta1=Restrict(ts(tDelta),EpochSleep1);
Delta2=Restrict(ts(tDelta),EpochSleep2);
Delta3=Restrict(ts(tDelta),EpochSleep3);
DeltaT1=Restrict(ts(tDelta),EpochDelta1);
DeltaT2=Restrict(ts(tDelta),EpochDelta2);

figure, subplot(5,1,1)
hold on, hist(Range(Delta1),200)
hold on, subplot(5,1,2)
hold on, hist(Range(DeltaT1),200)
hold on, subplot(5,1,3)
hold on, hist(Range(Delta2),200)
hold on, subplot(5,1,4)
hold on, hist(Range(DeltaT2),200)
hold on, subplot(5,1,5)
hold on, hist(Range(Delta3),200)


