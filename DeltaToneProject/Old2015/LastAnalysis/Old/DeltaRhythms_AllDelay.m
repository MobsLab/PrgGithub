%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
directoryName_Mouse243_140ms=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015');               % 21-04-2015
directoryName_Mouse243_200ms=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243');  % 17-04-2015
directoryName_Mouse243_320ms=('/media/DataMOBs28/Mice-243-244/20150423/Breath-Mouse-243-23042015');                                          % 23-04-2015

directoryName_Mouse244_140ms=('/media/DataMOBs28/Mice-243-244/20150422/Breath-Mouse-244-22042015');                                          % 22-04-2015
directoryName_Mouse244_200ms=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244');  % 16-04-2015
directoryName_Mouse244_320ms=('/media/DataMOBs28/Mice-243-244/20150424/Breath-Mouse-244-24042015');                                          % 24-04-2015
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

struct='PaCx';
% <><><><><><><><><><><><><><>  Mouse 243  <><><><><><><><><><><><><><><><><><><>
cd([directoryName_Mouse243_140ms])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M243_140ms=tDelta;

cd([directoryName_Mouse243_200ms])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M243_200ms=tDelta;

cd([directoryName_Mouse243_320ms])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M243_320ms=tDelta;

% <><><><><><><><><><><><><><>  Mouse 244  <><><><><><><><><><><><><><><><><><><>
cd([directoryName_Mouse244_140ms])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M244_140ms=tDelta;

cd([directoryName_Mouse244_200ms])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M244_200ms=tDelta;

cd([directoryName_Mouse244_320ms])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M244_320ms=tDelta;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%--------------------------------------------------------------------------
%                        FIND RHYTHMS
%--------------------------------------------------------------------------
Delta=ts(Delta_M244_140ms);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M244_200ms);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1b,b1]=hist(d,[-0.01:0.02:3.1]);
[h2b,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M244_320ms);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1c,b1]=hist(d,[-0.01:0.02:3.1]);
[h2c,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);



Delta=ts(Delta_M243_140ms);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1f,b1]=hist(d,[-0.01:0.02:3.1]);
[h2f,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M243_200ms);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1g,b1]=hist(d,[-0.01:0.02:3.1]);
[h2g,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M243_320ms);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1h,b1]=hist(d,[-0.01:0.02:3.1]);
[h2h,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);



%------------------------------------------------------------------------------------------------------------
%                         PLOT ALL THAT
%------------------------------------------------------------------------------------------------------------

figure('color',[1 1 1]), 
subplot(2,3,1), plot(b1,smooth(h_M244,3),'k','linewidth',2)
hold on, plot(b1,smooth(h1a,3),'b','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3]), ylim([0 450])
title([struct,'Delta M244 140ms delay'])
line([0.3 0.3],[0 450],'color','r')
line([0.48 0.48],[0 450])
line([0.65 0.65],[0 450])
line([0.85 0.85],[0 450])
subplot(2,3,2),plot(b1,smooth(h_M244,3),'k','linewidth',2)
hold on, plot(b1,smooth(h1b,3),'b','linewidth',2), hold on, plot(b2,smooth(h2b,3),'r'), xlim([0 3]), ylim([0 450])
title([struct,'Delta M244 200ms delay'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 450])
line([0.65 0.65],[0 450])
line([0.85 0.85],[0 450])
subplot(2,3,3), plot(b1,smooth(h_M244,3),'k','linewidth',2)
hold on, plot(b1,smooth(h1c,3),'b','linewidth',2), hold on, plot(b2,smooth(h2c,3),'r'), xlim([0 3]), ylim([0 450])
title([struct,'Delta M244 320ms delay'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 450])
line([0.65 0.65],[0 450],'color','r')
line([0.85 0.85],[0 450])


subplot(2,3,4), plot(b1,smooth(h_M243,3),'k','linewidth',2)
hold on, plot(b1,smooth(h1f,3),'b','linewidth',2), hold on, plot(b2,smooth(h2f,3),'r'), xlim([0 3]), ylim([0 350])
title([struct,'Delta M243 140ms delay'])
line([0.3 0.3],[0 350],'color','r')
line([0.48 0.48],[0 350])
line([0.65 0.65],[0 350])
line([0.85 0.85],[0 350])
subplot(2,3,5),  plot(b1,smooth(h_M243,3),'k','linewidth',2)
hold on,plot(b1,smooth(h1g,3),'b','linewidth',2), hold on, plot(b2,smooth(h2g,3),'r'), xlim([0 3]), ylim([0 350])
title([struct,'Delta M243 200ms delay'])
line([0.3 0.3],[0 350])
line([0.48 0.48],[0 350])
line([0.65 0.65],[0 350])
line([0.85 0.85],[0 350])
subplot(2,3,6), plot(b1,smooth(h_M243,3),'k','linewidth',2)
hold on, plot(b1,smooth(h1h,3),'b','linewidth',2), hold on, plot(b2,smooth(h2h,3),'r'), xlim([0 3]), ylim([0 350])
title([struct,'Delta M243 320ms delay'])
line([0.3 0.3],[0 350])
line([0.48 0.48],[0 350],'color','r')
line([0.65 0.65],[0 350])
line([0.85 0.85],[0 350])






