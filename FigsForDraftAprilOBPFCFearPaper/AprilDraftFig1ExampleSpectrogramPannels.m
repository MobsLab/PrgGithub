% This code generates pannels used in april draft
% It generates Fig1F

%cd('/Volumes/My Passport/Project4Hz/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228')
cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228
fig=figure;
load('behavResources.mat')
FreezeEpoch=mergeCloseIntervals(FreezeEpoch,5*1e4);
FreezeEpoch=dropShortIntervals(FreezeEpoch,10*1e4);
a=[15 15]'*ones(length(Start(FreezeEpoch,'s')),1)';
load('BreathingInfo.mat')
subplot(411)
plot(Range(Frequecytsd,'s'),runmean(Data(Frequecytsd),50),'linewidth',2,'color','k')
 line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',a,'color',[0 0.29 0.58],'linewidth',3)
xlim([0 500]),ylim([0 20]), box off
 box off
% line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',a,'color','c','linewidth',3)
set(gca,'XTick',[])
subplot(412)
load('B_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
 xlim([0 500])
box off
clim([6 14])
line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',a,'color',[0 0.29 0.58],'linewidth',3)
set(gca,'XTick',[])
subplot(413)
load('PFCx_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
%  clim([-2 5])
xlim([0 500])
box off
clim([5 11.7])
line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',a,'color',[0 0.29 0.58],'linewidth',3)
set(gca,'XTick',[])
subplot(414)
plot(Range(Movtsd,'s'),Data(Movtsd),'k','linewidth',2)
line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',a,'color',[0 0.29 0.58],'linewidth',3)
set(gca,'XTick',[])
xlim([0 500])
box off


figure
Ep=intervalSet(266*1e4,271*1e4);
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/LFPData/LFP32.mat')
FilLFP=FilterLFP((LFP),[1 30],1024);
plot(Range(Restrict(FilLFP,Ep),'s'),Data(Restrict(FilLFP,Ep)),'color',[0 0.29 0.58]), hold on
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/LFPData/LFP14.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))/20-500,'color',[0 0.29 0.58])
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/LFPData/LFP6.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))/20-1000,'color',[0 0.29 0.58])
xlim([266 271])
line([269.5 270.5],[-1300 -1300],'color','k','linewidth',3)
ylim([-1700 500])
Xvals=[Range(Restrict(Breathtsd,Ep),'s'),Range(Restrict(Breathtsd,Ep),'s')];
Yvals=Xvals*0;
Yl=ylim;
Yvals(:,1)=Yl(1);
Yvals(:,2)=Yl(2);
line(Xvals',Yvals','linestyle',':','color',[0.6 0.6 0.6])
set(gca,'XTick',[],'YTick',[],'xcolor','w','ycolor','w')

figure
Ep=intervalSet(100*1e4,571*1e4);
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/LFPData/LFP32.mat')
FilLFP=FilterLFP((LFP),[1 30],1024);
plot(Range(LFP,'s'),Data(FilLFP),'color',[0.39 0 0]), hold on
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/LFPData/LFP14.mat')
plot(Range(LFP,'s'),Data(LFP)/20-500,'color',[0.39 0 0])
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/LFPData/LFP6.mat')
plot(Range(LFP,'s'),Data(LFP)/20-1000,'color',[0.39 0 0])
xlim([566 571])
ylim([-1700 500])
Xvals=[Range(Restrict(Breathtsd,Ep),'s'),Range(Restrict(Breathtsd,Ep),'s')];
Yvals=Xvals*0;
Yl=ylim;
Yvals(:,1)=Yl(1);
Yvals(:,2)=Yl(2);
line(Xvals',Yvals','linestyle',':','color',[0.6 0.6 0.6])
line([569.5 570.5],[-1300 -1300],'color','k','linewidth',3)
set(gca,'XTick',[],'YTick',[],'xcolor','w','ycolor','w')


Ep=intervalSet(250*1e4,271*1e4);
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/LFPData/LFP32.mat')
FilLFP=FilterLFP((LFP),[1 30],1024);
plot(Range(Restrict(FilLFP,Ep),'s'),Data(Restrict(FilLFP,Ep)),'color',[0 0.29 0.58]), hold on
DatRespi =Data(Restrict(FilLFP,Ep));
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/LFPData/LFP14.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))/20-500,'color',[0 0.29 0.58])
DatOB =Data(Restrict(LFP,Ep));
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/LFPData/LFP6.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))/20-1000,'color',[0 0.29 0.58])
DatPFC =Data(Restrict(LFP,Ep));