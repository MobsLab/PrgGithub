% This code generates pannels used in april draft
% It generates Fig1F

cd('/Volumes/My Passport/Project4Hz/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228')
%cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228
fig=figure;
load('behavResources.mat')
FreezeEpoch=mergeCloseIntervals(FreezeEpoch,5*1e4);
FreezeEpoch=dropShortIntervals(FreezeEpoch,10*1e4);
a=[15 15]'*ones(length(Start(FreezeEpoch,'s')),1)';
load('BreathingInfo.mat')
subplot(311)
plot(Range(Frequecytsd,'s'),runmean(Data(Frequecytsd),50),'linewidth',2,'color','k')
 line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',a,'color','c','linewidth',3)
xlim([0 500]),ylim([0 20]), box off
% clim([-0.5 7.5])
% box off
% line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',a,'color','c','linewidth',3)
subplot(312)
load('B_Low_SpectrumWh.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
 xlim([0 500])
box off
line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',a,'color','c','linewidth',3)
subplot(313)
load('PFCx_Low_SpectrumWh.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
clim([-2 5])
xlim([0 500])
box off
line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',a,'color','c','linewidth',3)
