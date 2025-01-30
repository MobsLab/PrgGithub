directoryName_Mouse243_Day1=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243');
directoryName_Mouse244_Day1=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244');

directoryName_Mouse243_Day2=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243');
directoryName_Mouse244_Day2=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244');

directoryName_Mouse243_Day3=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243');
directoryName_Mouse244_Day3=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244');


% <><><><><><><><><><><><><><>  Mouse 243  <><><><><><><><><><><><><><><><><><><>
cd([directoryName_Mouse243_Day1])
load newDeltaPaCx
DeltaPaCx_M243_Day1=tDelta;
load newDeltaPFCx
DeltaPFCx_M243_Day1=tDelta;
load newDeltaMoCx
DeltaMoCx_M243_Day1=tDelta;

cd([directoryName_Mouse243_Day2])
load newDeltaPaCx
DeltaPaCx_M243_Day2=tDelta;
load newDeltaPFCx
DeltaPFCx_M243_Day2=tDelta;
load newDeltaMoCx
DeltaMoCx_M243_Day2=tDelta;

cd([directoryName_Mouse243_Day3])
load newDeltaPaCx
DeltaPaCx_M243_Day3=tDelta;
load newDeltaPFCx
DeltaPFCx_M243_Day3=tDelta;
load newDeltaMoCx
DeltaMoCx_M243_Day3=tDelta;

% <><><><><><><><><><><><><><>  Mouse 244  <><><><><><><><><><><><><><><><><><><>
cd([directoryName_Mouse244_Day1])
load newDeltaPaCx
DeltaPaCx_M244_Day1=tDelta;
load newDeltaPFCx
DeltaPFCx_M244_Day1=tDelta;
load newDeltaMoCx
DeltaMoCx_M244_Day1=tDelta;

cd([directoryName_Mouse244_Day2])
load newDeltaPaCx
DeltaPaCx_M244_Day2=tDelta;
load newDeltaPFCx
DeltaPFCx_M244_Day2=tDelta;
load newDeltaMoCx
DeltaMoCx_M244_Day2=tDelta;

cd([directoryName_Mouse244_Day3])
load newDeltaPaCx
DeltaPaCx_M244_Day3=tDelta;
load newDeltaPFCx
DeltaPFCx_M244_Day3=tDelta;
load newDeltaMoCx
DeltaMoCx_M244_Day3=tDelta;

%--------------------------------------------------------------------------
%                        FIND RHYTHMS
%--------------------------------------------------------------------------
Delta=ts(DeltaPaCx_M244_Day1);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1a,b1]=hist(d,[-0.01:0.02:3.1]);
[h2a,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
figure, plot(b1,smooth(h1a,3),'k','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3])
title('DeltaPaCx_M244_Day1')
Delta=ts(DeltaPaCx_M244_Day2);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1b,b1]=hist(d,[-0.01:0.02:3.1]);
[h2b,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
figure, plot(b1,smooth(h1b,3),'k','linewidth',2), hold on, plot(b2,smooth(h2b,3),'r'), xlim([0 3])
title('DeltaPaCx_M244_Day2')
Delta=ts(DeltaPaCx_M244_Day3);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1c,b1]=hist(d,[-0.01:0.02:3.1]);
[h2c,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
figure, plot(b1,smooth(h1c,3),'k','linewidth',2), hold on, plot(b2,smooth(h2c,3),'r'), xlim([0 3])
title('DeltaPaCx_M244_Day3')

Delta=ts(DeltaPaCx_M243_Day1);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1d,b1]=hist(d,[-0.01:0.02:3.1]);
[h2d,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
figure, plot(b1,smooth(h1d,3),'k','linewidth',2), hold on, plot(b2,smooth(h2d,3),'r'), xlim([0 3])
title('DeltaPaCx_M243_Day1')
Delta=ts(DeltaPaCx_M243_Day2);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1e,b1]=hist(d,[-0.01:0.02:3.1]);
[h2e,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
figure, plot(b1,smooth(h1e,3),'k','linewidth',2), hold on, plot(b2,smooth(h2e,3),'r'), xlim([0 3])
title('DeltaPaCx_M243_Day2')
Delta=ts(DeltaPaCx_M243_Day3);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,0.6);
d=diff(Range(Delta,'s'));
[h1f,b1]=hist(d,[-0.01:0.02:3.1]);
[h2f,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
figure, plot(b1,smooth(h1f,3),'k','linewidth',2), hold on, plot(b2,smooth(h2f,3),'r'), xlim([0 3])
title('DeltaPaCx_M243_Day3')


%------------------------------------------------------------------------------------------------------------
%                         PLOT ALL THAT
%------------------------------------------------------------------------------------------------------------

figure('color',[1 1 1]), 
subplot(2,3,1), plot(b1,smooth(h1a,3),'k','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3])
title('DeltaPaCx_M244_Day1')
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,3,2), plot(b1,smooth(h1b,3),'k','linewidth',2), hold on, plot(b2,smooth(h2b,3),'r'), xlim([0 3])
title('DeltaPaCx_M244_Day2')
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,3,3),  plot(b1,smooth(h1c,3),'k','linewidth',2), hold on, plot(b2,smooth(h2c,3),'r'), xlim([0 3])
title('DeltaPaCx_M244_Day3')
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,3,4),  plot(b1,smooth(h1d,3),'k','linewidth',2), hold on, plot(b2,smooth(h2d,3),'r'), xlim([0 3])
title('DeltaPaCx_M243_Day1')
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,3,5),  plot(b1,smooth(h1e,3),'k','linewidth',2), hold on, plot(b2,smooth(h2e,3),'r'), xlim([0 3])
title('DeltaPaCx_M243_Day2')
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])
subplot(2,3,6),  plot(b1,smooth(h1f,3),'k','linewidth',2), hold on, plot(b2,smooth(h2f,3),'r'), xlim([0 3])
title('DeltaPaCx_M243_Day3')
line([0.3 0.3],[0 250])
line([0.48 0.48],[0 250])
line([0.65 0.65],[0 250])
line([0.85 0.85],[0 250])



%--------------------------------------------------------------------------
%                         OLDER TRIALS
%--------------------------------------------------------------------------
% [h1,b1]=hist(diff(Range(Delta,'s')),[0:0.01:20]);
% figure, plot(b1,smooth(h1,3),'k','linewidth',2), 
% a=1;
% for i=0.2:0.1:2
%     try
% [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,i);
% [h2,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')),[0:0.01:20]);
% hold on, plot(b2,smooth(h2,3),'color',[a/19 0 (19-a)/19]), xlim([0 3])
%     end
% a=a+1;
% end
% 
% 
% d=diff(Range(Delta,'s'));
% [h1,b1]=hist(d, [-0.01:0.02:3.1]);
% h1s=smooth(h1,3);
% 
% a=1;
% for i=0.2:0.05:2
%     try
%  [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,i);
%  [h2,b2]=hist(diff(Range(Restrict(Delta,BurstDeltaEpoch),'s')), [-0.01:0.02:3.1]);
% h2s=smooth(h2,3);
% temp=(h2s)./h1s*100;
% val(a,1)=i;
% val(a,2)=nanmean(temp(find(b2<i)));
% a=a+1;
%     end
% end
% 
% figure, plot(val(:,1),val(:,2))
% hold on, plot(val(2:end,1),diff(val(:,2)),'-.')
% 
% 
% length(Range(Restrict(Delta,SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))
% length(Range(Restrict(Delta,BurstDeltaEpoch)))/sum(End(BurstDeltaEpoch,'s')-Start(BurstDeltaEpoch,'s'))
% 1/(length(Range(Restrict(Delta,SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s')))
% 1/(length(Range(Restrict(Delta,BurstDeltaEpoch)))/sum(End(BurstDeltaEpoch,'s')-Start(BurstDeltaEpoch,'s')))
