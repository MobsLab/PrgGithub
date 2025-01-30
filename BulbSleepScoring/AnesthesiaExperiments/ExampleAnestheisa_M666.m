clf
sb=tight_subplot(5,1);
chB = 29;
cd('/media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse666/Mouse666_20180331_PreKetamine/')
load('LFPData/LFP6.mat')
Ep = intervalSet(9565.5*1e4,9570.5*1e4);
subplot(5,1,1)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[50,70],1024); 
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*2-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep)),'k','linewidth',1)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')

Ep = intervalSet(13458*1e4,13463*1e4);
subplot(5,1,2)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[50,70],1024); 
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*2-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep)),'k','linewidth',1)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')

cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_08/baseline/
load('LFPData/LFP6.mat')
Ep = intervalSet(114.3*1e4,119.3*1e4);
subplot(5,1,3)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[50,70],1024); 
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*2-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep)),'k','linewidth',1)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')


cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_18/
load('LFPData/LFP6.mat')
Ep = intervalSet(334*1e4,339*1e4);
subplot(5,1,4)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[50,70],1024); 
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*2-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep))*2,'k','linewidth',1)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')

cd /media/DataMOBsRAIDN/ProjetSlSc/KetamineExp/Ketamine_Mouse666/Mouse666_20180331_PostKetamine/
load('LFPData/LFP6.mat')
Ep = intervalSet(1231*1e4,1236*1e4);
subplot(5,1,5)
hold on
Filt_g=FilterLFP(Restrict(LFP,Ep),[50,70],1024); 
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Filt_g)*2-1e4,'r')
plot(Range(Restrict(LFP,Ep),'s')-min(Range(Restrict(LFP,Ep),'s')),Data(Restrict(LFP,Ep)),'k','linewidth',1)
ylim([-2 1]*1e4)
set(gca,'XTick',[],'YTick',[],'color','w')
