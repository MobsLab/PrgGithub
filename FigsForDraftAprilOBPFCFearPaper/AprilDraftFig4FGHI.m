% This code generates pannels used in april draft
% It generates Fig4FGHI
% Need to toggle file name for Montreal vs Paris
% Data location
close all
% cd('/Volumes/My Passport/Project4Hz/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015')
cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015')
% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigTest/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];


load('behavResources.mat')
load('LFPData/InfoLFP.mat')
AllHPCCHans=InfoLFP.channel(find(~cellfun(@isempty,strfind(InfoLFP.structure,'dHPC'))));

fig=figure;
load('LFPData/LFP0.mat')
plot(Range(LFP,'s'),Data(LFP),'color',[0.3 0.5 1],'linewidth',2),hold on
load('LFPData/LFP1.mat')
plot(Range(LFP,'s'),Data(LFP)-3000,'color',[0 0 1],'linewidth',2)
load('LFPData/LFP2.mat')
plot(Range(LFP,'s'),Data(LFP)-7000,'color',[0.5 0 0.6],'linewidth',2)
xlim([511.5 513])
set(gca,'FontSize',18,'XTick',[],'YTick',[-7000,-3000,0],'YTickLabel',{'E3','E2','E1'}), box off
line([512.4 512.9],[-12500 -12500],'color','k','linewidth',4), text(512.6,-11000,'500ms')
saveas(fig,[SaveFigFolder,'M253','LFPs.fig']); close all;

load('LFPCorr/AllHPC_PFCx_OB_Loc_NonLoc_Corr.mat')

fig=figure;
plot(TimeBin.HPC_PFC{1},CorrVals.HPC_PFC{1},'color',[0.3 0.5 1],'linewidth',2)
hold on
plot(TimeBin.HPC_PFC{1},CorrVals.HPC_PFC{2}-4e-3,'color',[0 0 1],'linewidth',2)
plot(TimeBin.HPC_PFC{1},CorrVals.HPC_PFC{3}-8e-3,'color',[0.5 0 0.6],'linewidth',2)
plot(TimeBin.HPC_PFC{1},-CorrVals.HPCLoc_PFC-13e-3,'color',[0.6 0.6 0.6],'linewidth',2)
saveas(fig,[SaveFigFolder,'M253','LFPCorrPFC.fig']); close all;

fig=figure;
plot(TimeBin.HPC_PFC{1},CorrVals.HPC_OB{1},'color',[0.3 0.5 1],'linewidth',2)
hold on
plot(TimeBin.HPC_PFC{1},CorrVals.HPC_OB{2}-4e-3,'color',[0 0 1],'linewidth',2)
plot(TimeBin.HPC_PFC{1},CorrVals.HPC_OB{3}-8e-3,'color',[0.5 0 0.6],'linewidth',2)
plot(TimeBin.HPC_PFC{1},-CorrVals.HPCLoc_OB{1}-13e-3,'color',[0.6 0.6 0.6],'linewidth',2)
saveas(fig,[SaveFigFolder,'M253','LFPCorrOB.fig']); close all;


fig=figure;
load('CohgramcDataL/Cohgram_0_OBLoc.mat')
Ctsd=tsd(t*1e4,C);
plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'linewidth',3,'color',[0.3 0.5 1]), hold on
load('CohgramcDataL/Cohgram_1_OBLoc.mat')
Ctsd=tsd(t*1e4,C);
plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'linewidth',3,'color',[0 0 1]), hold on
load('CohgramcDataL/Cohgram_2_OBLoc.mat')
Ctsd=tsd(t*1e4,C);
plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'linewidth',3,'color',[0.5 0 0.6]), hold on
load('CohgramcDataL/Cohgram_HPCLoc_OBLoc.mat')
Ctsd=tsd(t*1e4,C);
plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'color',[0.6 0.6 0.6],'linewidth',3), hold on
legend({'E1','E2','E3','Local:E1-E3'}), box off
ylabel('coherence with OB'), xlabel('Frequency (Hz)')
set(gca,'FontSize',12)
ylim([0.3 0.8])
saveas(fig,[SaveFigFolder,'M253','CohOB.fig']); close all;

fig=figure;
load('CohgramcDataL/Cohgram_8_0.mat')
Ctsd=tsd(t*1e4,C);
plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'linewidth',3,'color',[0.3 0.5 1]), hold on
load('CohgramcDataL/Cohgram_1_8.mat')
Ctsd=tsd(t*1e4,C);
plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'linewidth',3,'color',[0 0 1]), hold on
load('CohgramcDataL/Cohgram_2_8.mat')
Ctsd=tsd(t*1e4,C);
plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'linewidth',3,'color',[0.5 0 0.6]), hold on
load('CohgramcDataL/Cohgram_HPCLoc_8.mat')
Ctsd=tsd(t*1e4,C);
plot(f,mean(Data(Restrict(Ctsd,FreezeEpoch))),'color',[0.6 0.6 0.6],'linewidth',3), hold on
legend({'E1','E2','E3','Local:E1-E3'}), box off
ylabel('coherence with PFCx'), xlabel('Frequency (Hz)')
set(gca,'FontSize',12)
ylim([0.3 0.8])
saveas(fig,[SaveFigFolder,'M253','CohPFCx.fig']); close all;

fig=figure;
load('HPC1_Low_Spectrum.mat')
Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
subplot(211)
plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'color',[0.3 0.5 1],'linewidth',3), hold on
hold on
subplot(212)
plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch)))./sum(mean(Data(Restrict(Sptsd,FreezeEpoch)))),'color',[0.3 0.5 1],'linewidth',3), hold on
hold on
load('HPC3_Low_Spectrum.mat')
Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
subplot(211)
plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'color',[0 0 1],'linewidth',3), hold on
hold on
subplot(212)
plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch)))./sum(mean(Data(Restrict(Sptsd,FreezeEpoch)))),'color',[0 0 1],'linewidth',3), hold on
hold on
load('HPC2_Low_Spectrum.mat')
Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
subplot(211)
plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'color',[0.5 0 0.6],'linewidth',3), hold on
hold on
subplot(212)
plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch)))./sum(mean(Data(Restrict(Sptsd,FreezeEpoch)))),'color',[0.5 0 0.6],'linewidth',3), hold on
hold on
('power - norm'), xlabel('Frequency (Hz)')
load('HPCLoc_Low_Spectrum.mat')
Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
subplot(211)
plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch))),'color',[0.6 0.6 0.6],'linewidth',3), hold on
hold on
legend({'E1','E2','E3','Loc'}), box off
ylabel('power'), xlabel('Frequency (Hz)')
subplot(212)
plot(Spectro{3},mean(Data(Restrict(Sptsd,FreezeEpoch)))./sum(mean(Data(Restrict(Sptsd,FreezeEpoch)))),'color',[0.6 0.6 0.6],'linewidth',3), hold on
hold on
ylabel('power - norm'), xlabel('Frequency (Hz)')
saveas(fig,[SaveFigFolder,'M253','Spectra.fig']); close all;
