directoryName_Mouse243_Day1=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243');
directoryName_Mouse244_Day1=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244');
directoryName_Mouse243_Day2=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243');
directoryName_Mouse244_Day2=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244');
directoryName_Mouse243_Day3=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243');
directoryName_Mouse244_Day3=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244');
directoryName_Mouse243_Day4=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243');
directoryName_Mouse244_Day4=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244');
directoryName_Mouse243_Day5=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243');
directoryName_Mouse244_Day5=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244');


struct='PaCx';
% <><><><><><><><><><><><><><>  Mouse 243  <><><><><><><><><><><><><><><><><><><>
cd([directoryName_Mouse243_Day1])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M243_Day1=tDelta;

cd([directoryName_Mouse243_Day2])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M243_Day2=tDelta;

cd([directoryName_Mouse243_Day3])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M243_Day3=tDelta;

cd([directoryName_Mouse243_Day4])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M243_Day4=tDelta;

cd([directoryName_Mouse243_Day5])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M243_Day5=tDelta;

% <><><><><><><><><><><><><><>  Mouse 244  <><><><><><><><><><><><><><><><><><><>
cd([directoryName_Mouse244_Day1])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M244_Day1=tDelta;

cd([directoryName_Mouse244_Day2])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M244_Day2=tDelta;

cd([directoryName_Mouse244_Day3])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M244_Day3=tDelta;

cd([directoryName_Mouse244_Day4])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M244_Day4=tDelta;

cd([directoryName_Mouse244_Day5])
res=pwd;
load([res,'/newDelta',struct]);
Delta_M244_Day5=tDelta;

%--------------------------------------------------------------------------
%                        FIND RHYTHMS
%--------------------------------------------------------------------------
Delta=ts(Delta_M244_Day1);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M244_Day2);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1b,b1]=hist(d,[-0.01:0.02:3.1]);
[h2b,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M244_Day3);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1c,b1]=hist(d,[-0.01:0.02:3.1]);
[h2c,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M244_Day4);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1d,b1]=hist(d,[-0.01:0.02:3.1]);
[h2d,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M244_Day5);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1e,b1]=hist(d,[-0.01:0.02:3.1]);
[h2e,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);


Delta=ts(Delta_M243_Day1);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1f,b1]=hist(d,[-0.01:0.02:3.1]);
[h2f,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M243_Day2);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1g,b1]=hist(d,[-0.01:0.02:3.1]);
[h2g,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M243_Day3);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1h,b1]=hist(d,[-0.01:0.02:3.1]);
[h2h,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M243_Day4);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1i,b1]=hist(d,[-0.01:0.02:3.1]);
[h2i,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);

Delta=ts(Delta_M243_Day5);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1j,b1]=hist(d,[-0.01:0.02:3.1]);
[h2j,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);



%------------------------------------------------------------------------------------------------------------
h_M244=mean([h1a;h1b;h1c;h1d;h1e],1);
h_M243=mean([h1f;h1g;h1h;h1i;h1j],1);
b1all=b1;
%------------------------------------------------------------------------------------------------------------

%------------------------------------------------------------------------------------------------------------
%                         PLOT ALL THAT
%------------------------------------------------------------------------------------------------------------

figure('color',[1 1 1]), 
subplot(2,5,1), plot(b1,smooth(h1a,3),'k','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3])
title([struct,'Delta M244 Day1'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,5,2), plot(b1,smooth(h1b,3),'k','linewidth',2), hold on, plot(b2,smooth(h2b,3),'r'), xlim([0 3])
title([struct,'Delta M244 Day2'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,5,3),  plot(b1,smooth(h1c,3),'k','linewidth',2), hold on, plot(b2,smooth(h2c,3),'r'), xlim([0 3])
title([struct,'Delta M244 Day3'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,5,4),  plot(b1,smooth(h1d,3),'k','linewidth',2), hold on, plot(b2,smooth(h2d,3),'r'), xlim([0 3])
title([struct,'Delta M244 Day4'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,5,5),  plot(b1,smooth(h1e,3),'k','linewidth',2), hold on, plot(b2,smooth(h2e,3),'r'), xlim([0 3])
title([struct,'Delta M244 Day5'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])

subplot(2,5,6),  plot(b1,smooth(h1f,3),'k','linewidth',2), hold on, plot(b2,smooth(h2f,3),'r'), xlim([0 3])
title([struct,'Delta M243 Day1'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,5,7),  plot(b1,smooth(h1g,3),'k','linewidth',2), hold on, plot(b2,smooth(h2g,3),'r'), xlim([0 3])
title([struct,'Delta M243 Day1'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,5,8),  plot(b1,smooth(h1h,3),'k','linewidth',2), hold on, plot(b2,smooth(h2h,3),'r'), xlim([0 3])
title([struct,'Delta M243 Day3'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,5,9),  plot(b1,smooth(h1i,3),'k','linewidth',2), hold on, plot(b2,smooth(h2i,3),'r'), xlim([0 3])
title([struct,'Delta M243 Day4'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,5,10),  plot(b1,smooth(h1j,3),'k','linewidth',2), hold on, plot(b2,smooth(h2j,3),'r'), xlim([0 3])
title([struct,'Delta M243 Day5'])
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])


