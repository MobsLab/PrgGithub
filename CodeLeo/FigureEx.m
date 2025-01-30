cd /media/DataMOBS33/DataLeo/Invivo/160527/TG31TG32/ProjetPFC-VLPO_20162705_SleepStim-wideband/TG31
%% Exemple Leo
load('ChannelsToAnalyse/EMG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
FilLFP=FilterLFP(LFP,[50 300],1024);
load('ChannelsToAnalyse/dHPC_deep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
LFPH=FilterLFP(LFP,[1 300],1024);
load('ChannelsToAnalyse/PFC_sup.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
LFPP=FilterLFP(LFP,[1 300],1024);
figure
WakeInt=intervalSet(123*1e4,128*1e4);
subplot(131)
plot(Range(Restrict(FilLFP,WakeInt),'s')-123,Data(Restrict(FilLFP,WakeInt)),'k')
hold on
plot(Range(Restrict(LFPH,WakeInt),'s')-123,Data(Restrict(LFPH,WakeInt))-10000,'k')
plot(Range(Restrict(LFPP,WakeInt),'s')-123,Data(Restrict(LFPP,WakeInt))-20000,'k')
set(gca,'Ytick',[],'XTick',[],'TickLength',[0 0],'Linewidth',0.1,'Xcolor','w','Ycolor','w')
subplot(133)
SleepInt=intervalSet(12025*1e4,12030*1e4);
plot(Range(Restrict(FilLFP,SleepInt),'s')-12025,Data(Restrict(FilLFP,SleepInt)),'k')
hold on
plot(Range(Restrict(LFPH,SleepInt),'s')-12025,Data(Restrict(LFPH,SleepInt))-10000,'k')
plot(Range(Restrict(LFPP,SleepInt),'s')-12025,Data(Restrict(LFPP,SleepInt))-20000,'k')
set(gca,'Ytick',[],'XTick',[],'TickLength',[0 0],'Linewidth',0.1,'Xcolor','w','Ycolor','w')
subplot(132)
SleepInt=intervalSet(12319*1e4,12324*1e4);
plot(Range(Restrict(FilLFP,SleepInt),'s')-12025,Data(Restrict(FilLFP,SleepInt)),'k')
hold on
plot(Range(Restrict(LFPH,SleepInt),'s')-12025,Data(Restrict(LFPH,SleepInt))-10000,'k')
plot(Range(Restrict(LFPP,SleepInt),'s')-12025,Data(Restrict(LFPP,SleepInt))-20000,'k')
set(gca,'Ytick',[],'XTick',[],'TickLength',[0 0],'Linewidth',0.1,'Xcolor','w','Ycolor','w')