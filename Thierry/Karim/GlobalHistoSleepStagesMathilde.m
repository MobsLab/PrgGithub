% GlobalHistoSleepStagesMathilde

cd /Users/karimbenchenane/Dropbox/Mobs_member/MathildeChouvaeff/KB_data

%vec=-30:0.5:30;
vec=-300:1:300;

[h1,hc1,he1,hce1,rg1,rgc1,rge1,rgce1,vec]=HistoSleepStagesMathilde(1,1,100,vec);
[h2,hc2,he2,hce2,rg2,rgc2,rge2,rgce2,vec]=HistoSleepStagesMathilde(2,1,100,vec);
[h3,hc3,he3,hce3,rg3,rgc3,rge3,rgce3,vec]=HistoSleepStagesMathilde(3,1,100,vec);
[h4,hc4,he4,hce4,rg4,rgc4,rge4,rgce4,vec]=HistoSleepStagesMathilde(4,1,100,vec);

% REMhist=[h1(:,2)';h2(:,2)';h3(:,2)';h4(:,2)'];
% REMhistc=[hc1(:,2)';hc2(:,2)';hc3(:,2)';hc4(:,2)'];
% SWShist=[h1(:,1)';h2(:,1)';h3(:,1)';h4(:,1)'];
% SWShistc=[hc1(:,1)';hc2(:,1)';hc3(:,1)';hc4(:,1)'];
% Wakehist=[h1(:,3)';h2(:,3)';h3(:,3)';h4(:,3)'];
% Wakehistc=[hc1(:,3)';hc2(:,3)';hc3(:,3)';hc4(:,3)'];

REMhist=[h2(:,2)';h3(:,2)';h4(:,2)'];
REMhistc=[hc2(:,2)';hc3(:,2)';hc4(:,2)'];
SWShist=[h2(:,1)';h3(:,1)';h4(:,1)'];
SWShistc=[hc2(:,1)';hc3(:,1)';hc4(:,1)'];
Wakehist=[h2(:,3)';h3(:,3)';h4(:,3)'];
Wakehistc=[hc2(:,3)';hc3(:,3)';hc4(:,3)'];

[h,p]=ttest(REMhist,REMhistc);
[h,p2]=ttest(SWShist,SWShistc);
[h,p3]=ttest(Wakehist,Wakehistc);


figure('color',[1 1 1]), 
subplot(4,3,[1,4,7]), hold on, 
shadedErrorBar(vec,mean(REMhist),stdError(REMhist),'-g',1);
shadedErrorBar(vec,mean(REMhistc),stdError(REMhistc),'-k',1);
plot(vec, mean(REMhistc),'color','k','linewidth',2)
plot(vec, mean(REMhist),'color','g','linewidth',2)
% plot(vec,p*100,'color',[0 0.5 0])
line([0 0],[0 100],'color','k','linestyle',':'),
xlim([vec(1) vec(end)])
ylim([0 100])
title('REM')
subplot(4,3,[2,5,8]), hold on, 
shadedErrorBar(vec,mean(SWShist),stdError(SWShist),'-r',1);
shadedErrorBar(vec,mean(SWShistc),stdError(SWShistc),'-k',1);
plot(vec, mean(SWShistc),'color','k','linewidth',2)
plot(vec, mean(SWShist),'color','r','linewidth',2)
% plot(vec,p2*100,'color',[0 0.5 0])
line([0 0],[0 100],'color','k','linestyle',':'),
xlim([vec(1) vec(end)])
ylim([0 100])
title('SWS')
subplot(4,3,[3,6,9]), hold on, 
shadedErrorBar(vec,mean(Wakehist),stdError(Wakehist),'-b',1);
shadedErrorBar(vec,mean(Wakehistc),stdError(Wakehistc),'-k',1);
plot(vec, mean(Wakehistc),'color','k','linewidth',2)
plot(vec, mean(Wakehist),'color','b','linewidth',2)
% plot(vec,p3*50,'color',[0 0.5 0])
line([0 0],[0 50],'color','k','linestyle',':'),
xlim([vec(1) vec(end)])
ylim([0 50])
title('Wake')

subplot(4,3,10), hold on,
plot(vec,p,'color','k')
plot(vec(p<0.05),p(p<0.05),'ko','markerfacecolor','k')
line([0 0],[0 1],'color','k','linestyle',':'),
xlim([vec(1) vec(end)])
subplot(4,3,11), hold on,
plot(vec,p2,'color','k')
plot(vec(p2<0.05),p2(p2<0.05),'ko','markerfacecolor','k')
line([0 0],[0 1],'color','k','linestyle',':'),
xlim([vec(1) vec(end)])
subplot(4,3,12), hold on,
plot(vec,p3,'color','k')
plot(vec(p3<0.05),p3(p3<0.05),'ko','markerfacecolor','k')
line([0 0],[0 1],'color','k','linestyle',':'),
xlim([vec(1) vec(end)])

% 
% [C1,B1]=CrossCorr(rg1,Start(Delta1),1200,100);
% [Cc1,Bc1]=CrossCorr(rgc1,Start(Delta1),1200,100);
% [C3,B3]=CrossCorr(rg3,Start(Delta3),1200,100);
% [Cc3,Bc3]=CrossCorr(rgc3,Start(Delta3),1200,100);
% [C4,B4]=CrossCorr(rg4,Start(Delta4),1200,100);
% [Cc4,Bc4]=CrossCorr(rgc4,Start(Delta4),1200,100);
% 
% figure, 
% subplot(1,3,1), hold on, 
% plot(B1/1E3,C1,'r'),plot(Bc1/1E3,Cc1,'k') 
% line([0 0],ylim,'color','k','linestyle',':')
% subplot(1,3,2), hold on, 
% plot(B3/1E3,C3,'r'),plot(Bc3/1E3,Cc3,'k') 
% line([0 0],ylim,'color','k','linestyle',':')
% subplot(1,3,3), hold on, 
% plot(B4/1E3,C4,'r'),plot(Bc4/1E3,Cc4,'k') 
% line([0 0],ylim,'color','k','linestyle',':')
% 

% 
% if 0
%     
% REMhiste=[he1(:,2)';he2(:,2)';he3(:,2)';he4(:,2)'];
% REMhistce=[hce1(:,2)';hce2(:,2)';hce3(:,2)';hce4(:,2)'];
% SWShiste=[he1(:,1)';he2(:,1)';he3(:,1)';he4(:,1)'];
% SWShistce=[hce1(:,1)';hce2(:,1)';hce3(:,1)';hce4(:,1)'];
% Wakehiste=[he1(:,3)';he2(:,3)';he3(:,3)';he4(:,3)'];
% Wakehistce=[hce1(:,3)';hce2(:,3)';hce3(:,3)';hce4(:,3)'];
% 
% [h,p]=ttest(REMhiste,REMhistce);
% [h,p2]=ttest(SWShiste,SWShistce);
% [h,p3]=ttest(Wakehiste,Wakehistce);
% 
% figure('color',[1 1 1]), 
% subplot(1,3,1), hold on, 
% errorbar(vec,mean(REMhiste),stdError(REMhiste),'color','r'),
% plot(vec, mean(REMhiste),'color','r','linewidth',2)
% errorbar(vec,mean(REMhistce),stdError(REMhistce),'color','k'),
% plot(vec,p*100,'color',[0 0.5 0])
% line([0 0],[0 100],'color','k','linestyle',':'),
% xlim([vec(1) vec(end)])
% title('REM')
% subplot(1,3,2), hold on, 
% errorbar(vec,mean(SWShiste),stdError(SWShiste),'color','r'),
% plot(vec, mean(SWShiste),'color','r','linewidth',2)
% errorbar(vec,mean(SWShistce),stdError(SWShistce),'color','k'),
% plot(vec,p2*100,'color',[0 0.5 0])
% line([0 0],[0 100],'color','k','linestyle',':'),
% xlim([vec(1) vec(end)])
% title('SWS')
% subplot(1,3,3), hold on, 
% errorbar(vec,mean(Wakehiste),stdError(Wakehiste),'color','r'),
% errorbar(vec,mean(Wakehistce),stdError(Wakehistce),'color','k'),
% plot(vec, mean(Wakehiste),'color','r','linewidth',2)
% plot(vec,p3*50,'color',[0 0.5 0])
% line([0 0],[0 50],'color','k','linestyle',':'),
% xlim([vec(1) vec(end)])
% ylim([0 50])
% title('Wake')
% 
% end


figure('color',[1 1 1]),
subplot(2,1,1), hold on, 
shadedErrorBar(vec,mean(REMhist),stdError(REMhist),'-g',1);
shadedErrorBar(vec,mean(REMhistc),stdError(REMhistc),'-k',1);
plot(vec, mean(REMhistc),'color','k','linewidth',2)
plot(vec, mean(REMhist),'color','g','linewidth',2)
line([0 0],[0 100],'color','k','linestyle',':'),
xlim([vec(1) vec(end)])
ylabel('Percentage of REM')
ylim([0 100])
subplot(2,1,2), hold on, 
plot(vec, mean(REMhist)-mean(REMhistc),'color','b','linewidth',2)
line([0 0],ylim,'color','k','linestyle',':'),
line([vec(1) vec(end)],[0 0],ylim,'color','k'),
xlim([vec(1) vec(end)])


REMhistM=mean(REMhist);
REMhistcM=mean(REMhistc);
figure('color',[1 1 1]),
subplot(2,1,1), 
plot(vec(vec>0),REMhistM(vec>0)-REMhistcM(vec>0),'bo-','markerfacecolor','b')
line([0 vec(end)],[0 0],'color','k'),
subplot(2,1,2), 
plot(vec(vec>0),cumsum(REMhistM(vec>0)-REMhistcM(vec>0)),'ko-','markerfacecolor','k')
line([0 vec(end)],[0 0],'color','k'),
