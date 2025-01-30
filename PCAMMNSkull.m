function [tps1,tps2,tps3,tps4,tps5,tps6,M1,M2,M3,M4,M5,M6]=PCAMMNSkull(numSession, elec, th, tempTh, ThSig)

load ManipeName
disp(' ')
disp(manipe{numSession})
disp(' ')



LFPnames{1}='Prefrontal Cortex, superfical layer';
LFPnames{2}='Prefrontal Cortex, superfical layer';
LFPnames{3}='Prefrontal Cortex, superfical layer';
LFPnames{4}='Prefrontal Cortex, superfical layer';

LFPnames{5}='Parietal Cortex, EEG';
LFPnames{6}='Parietal Cortex, ECog';
LFPnames{7}='Parietal Cortex, deep layer';
LFPnames{8}='Parietal Cortex, deep layer';
LFPnames{9}='Parietal Cortex, deep layer';

LFPnames{10}='Auditory Cortex, EEG';
LFPnames{11}='Auditory Cortex, ECog';
LFPnames{12}='Auditory Cortex, deep layer';
LFPnames{13}='Auditory Cortex, deep layer';
LFPnames{14}='Auditory Cortex, superficial layer';
LFPnames{15}='Auditory Cortex, superficial layer';





[tpsstd,Mstd, tpsmmn,Mmmn]= ObsMMNSkull(numSession, elec, th,tempTh,ThSig);


  if size(Mstd,1)>2&size(Mmmn,1)>2  
tps=tpsstd(1:min(length(tpsmmn),length(tpsstd)));
  elseif size(Mstd,1)>2
  tps=tpsstd;
  else
      tps=tpsmmn;
  end
    id1=find(tps>-tempTh);
    id1=id1(1);
    id2=find(tps<tempTh);
    id2=id2(end);
    
    
    
[r1,p1]=corrcoef(Mstd(:,id1:id2)');
[V1,L1]=pcacov(r1);
pc11=V1(:,1);
[BE,id1]=sort(pc11);
[tps1,M1]=SubplotObsMMNSkull(tpsstd,Mstd(id1,:),1 ,length(pc11)/4);


[tps2,M2]=SubplotObsMMNSkull(tpsstd,Mstd(id1,:),length(pc11)/4 ,length(pc11)-length(pc11)/4);
[tps3,M3]=SubplotObsMMNSkull(tpsstd,Mstd(id1,:),length(pc11)-length(pc11)/4 ,length(pc11));


[r2,p2]=corrcoef(Mmmn(:,id1:id2)');
[V2,L2]=pcacov(r2);
pc12=V2(:,1);
[BE,id2]=sort(pc12);
[tps4,M4]=SubplotObsMMNSkull(tpsmmn,Mmmn(id2,:),1 ,length(pc12)/4);title(LFPnames{elec})
[tps5,M5]=SubplotObsMMNSkull(tpsmmn,Mmmn(id2,:),length(pc12)/4 ,length(pc12)-length(pc12)/4);title(LFPnames{elec})
[tps6,M6]=SubplotObsMMNSkull(tpsmmn,Mmmn(id2,:),length(pc12)-length(pc12)/4 ,length(pc12));title(LFPnames{elec})




figure('color',[1 1 1]), 
subplot(2,1,1), imagesc(Mstd)
caxis([-th th])
numfi=gcf;
load('MyColormaps','mycmap')
set(numfi,'Colormap',mycmap)
%hold on, plot(pc11*5500+1500,[1:length(pc11)],'color','k')
hold on, plot(pc11(id1(1:length(pc11)/4))*5500+1500,id1(1:length(pc11)/4),'ro','markerfacecolor','r')
%hold on, plot(pc12(id2(length(pc12)/4:length(pc12)-length(pc12)/4))*5500+1500,id2(length(pc12)/4:length(pc12)-length(pc12)/4),'k.','markerfacecolor','k')
hold on, plot(pc11(id1(length(pc11)-length(pc11)/4:length(pc11)))*5500+1500,id1(length(pc11)-length(pc11)/4:length(pc11)),'bo','markerfacecolor','b')
%hold on, plot(smooth(pc12*5500+1500,10),[1:length(pc12)],'color','k','linewidth',2)




subplot(2,1,2), imagesc(Mmmn)
caxis([-th th])
numfi=gcf;
load('MyColormaps','mycmap')
set(numfi,'Colormap',mycmap)
%hold on, plot(pc12*5500+1500,[1:length(pc12)],'color','k')
hold on, plot(pc12(id2(1:length(pc12)/4))*5500+1500,id2(1:length(pc12)/4),'ro','markerfacecolor','r')
%hold on, plot(pc12(id2(length(pc12)/4:length(pc12)-length(pc12)/4))*5500+1500,id2(length(pc12)/4:length(pc12)-length(pc12)/4),'k.','markerfacecolor','k')
hold on, plot(pc12(id2(length(pc12)-length(pc12)/4:length(pc12)))*5500+1500,id2(length(pc12)-length(pc12)/4:length(pc12)),'bo','markerfacecolor','b')
%hold on, plot(smooth(pc12*5500+1500,10),[1:length(pc12)],'color','k','linewidth',2)






M1tsd=tsd(tps1*1E4,mean(M1)');
Filt1=FilterLFP(M1tsd,[0.001 4],512);
M3tsd=tsd(tps2*1E4,mean(M3)');
Filt3=FilterLFP(M3tsd,[0.001 4],512);

figure('color',[1 1 1]), 

subplot(3,2,1), hold on
plot(tps1,mean(M1))
hold on, plot(tps2,mean(M2),'r')
hold on, plot(tps2,mean(M1)-Data(Filt1)','m')
hold on, plot(tps2,Data(Filt1)','k')

subplot(3,2,3), hold on
hold on, plot(tps2,mean(M2),'k','linewidth',2)
hold on, plot(tps2,mean(M1)-Data(Filt1)','r','linewidth',2)


subplot(3,2,2), hold on
plot(tps3,mean(M3))
hold on, plot(tps2,mean(M2),'r')
hold on, plot(tps2,mean(M3)-Data(Filt3)','m')
hold on, plot(tps2,Data(Filt3)','k')

subplot(3,2,4), hold on
hold on, plot(tps2,mean(M2),'k','linewidth',2)
hold on, plot(tps2,mean(M3)-Data(Filt3)','r','linewidth',2)

subplot(3,2,5:6), hold on
hold on, plot(tps2,mean(M2),'k','linewidth',1)
hold on, plot(tps2,mean(M1)-Data(Filt1)','b','linewidth',1)
hold on, plot(tps2,mean(M3)-Data(Filt3)','r','linewidth',1)
