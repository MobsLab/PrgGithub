figure
tight_subplot(5,1)
chB = 29;
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_SleepPost')
load('LFPData/LFP29.mat')
Ep = intervalSet(1480*1e4,1485*1e4);
subplot(5,1,1)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[40,90],1024);
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*3-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep)),'k','linewidth',2)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')

Ep = intervalSet(1439*1e4,1440*1e4);
subplot(5,1,2)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[40,90],1024);
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*3-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep)),'k','linewidth',2)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')


cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_08/baseline
load('LFPData/LFP29.mat')
Ep = intervalSet(120*1e4,121*1e4);
subplot(5,1,3)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[40,90],1024);
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*3-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep)),'k','linewidth',2)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')


cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_10
load('LFPData/LFP29.mat')
Ep = intervalSet(415.7*1e4,416.7*1e4);
subplot(5,1,4)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[40,90],1024);
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*3-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep)),'k','linewidth',2)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')

cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_18
load('LFPData/LFP29.mat')
Ep = intervalSet(349*1e4,350*1e4);
subplot(5,1,5)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[40,90],1024);
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*3-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep)),'k','linewidth',2)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')
