clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPostSound
[params,movingwin,suffix]=SpectrumParametersML('low');


% Sleep
% PFC sup
% load('ChannelsToAnalyse/PFCx_deep.mat')
channel_deep = 29;
load('IdFigureData.mat', 'Mdeep_long_delta')
load(['LFPData/LFP',num2str(channel_deep),'.mat'])
LFP_deep = LFP;

% PFC deep
% load('ChannelsToAnalyse/PFCx_sup.mat')
channel_sup = 25;
load('IdFigureData.mat', 'Msup_long_delta')
load(['LFPData/LFP',num2str(channel_sup),'.mat'])
LFP_sup = LFP;

% PFC diff
LFP_diff = tsd(Range(LFP),Data(LFP_deep)-Data(LFP_sup));

% OB
load('ChannelsToAnalyse/Bulb_deep.mat')
channel_OB = channel;
load(['LFPData/LFP',num2str(channel_OB),'.mat'])
LFP_OB = LFP;

% HPC
if exist('ChannelsToAnalyse/dHPC_deep.mat','file')==2
    load('ChannelsToAnalyse/dHPC_deep.mat')
    channel_hpc=channel;
elseif exist('ChannelsToAnalyse/dHPC_rip.mat','file')==2
    load('ChannelsToAnalyse/dHPC_rip.mat')
    channel_hpc=channel;
elseif exist('ChannelsToAnalyse/dHPC_sup.mat','file')==2
    load('ChannelsToAnalyse/dHPC_sup.mat')
    channel_hpc=channel;
else
    error('No HPC channel, cannot do sleep scoring');
end
load(['LFPData/LFP',num2str(channel_hpc),'.mat'])
LFP_HPC = LFP;


load('SleepSubstages.mat')


% Spectra
[Sp,t,f]=mtspecgramc(Data(LFP_deep),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
    
for ep = 1:5
   MeanSpec_deep(ep,:) = nanmean(Data(Restrict(Sptsd,Epoch{ep})));
end

[Sp,t,f]=mtspecgramc(Data(LFP_sup),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
for ep = 1:5
   MeanSpec_sup(ep,:) = nanmean(Data(Restrict(Sptsd,Epoch{ep})));
end

[Sp,t,f]=mtspecgramc(Data(LFP_diff),movingwin,params);
save('SpectrumDataL/SpectrumPFC_diff.mat','Sp','t','f','movingwin','params')
Sptsd = tsd(t*1e4,Sp);
    
for ep = 1:5
   MeanSpec_diff(ep,:) = nanmean(Data(Restrict(Sptsd,Epoch{ep})));
end

% Coherence
[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_HPC),movingwin,params);
save(['CohgramcDataL/Cohgram_HPC_PFCx_Deep','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:5
   MeanCoh_HPC_deep(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_HPC),movingwin,params);
save(['CohgramcDataL/Cohgram_HPC_PFCx_Sup','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:5
   MeanCoh_HPC_sup(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_HPC),movingwin,params);
save(['CohgramcDataL/Cohgram_HPC_PFCx_Diff','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:5
   MeanCoh_HPC_diff(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_OB),movingwin,params);
save(['CohgramcDataL/Cohgram_OB_PFCx_Deep','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:5
   MeanCoh_OB_deep(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_OB),movingwin,params);
save(['CohgramcDataL/Cohgram_OB_PFCx_Sup','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:5
   MeanCoh_OB_sup(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_OB),movingwin,params);
save(['CohgramcDataL/Cohgram_OB_PFCx_Diff','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:5
   MeanCoh_OB_diff(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end



%% Freezing
clear LFP_OB LFP_HPC LFP_deep LFP_sup LFP_diff
Dir = GetAllMouseTaskSessions(514);
x1 = strfind(Dir,'UMazeCond');
ToKeep = find(~cellfun(@isempty,x1));
Dir = Dir(ToKeep);

FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
StimEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
FreezeEpoch = FreezeEpoch - StimEpochToRemove;
LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
LFP_OB  = ConcatenateDataFromFolders_SB(Dir,'lfp','channumber',channel_OB);
LFP_HPC  = ConcatenateDataFromFolders_SB(Dir,'lfp','channumber',channel_hpc);
LFP_deep  = ConcatenateDataFromFolders_SB(Dir,'lfp','channumber',channel_deep);
LFP_sup  = ConcatenateDataFromFolders_SB(Dir,'lfp','channumber',channel_sup);
LFP_diff = tsd(Range(LFP_deep),Data(LFP_deep)-Data(LFP_sup));

% Spectra
[Sp,t,f]=mtspecgramc(Data(LFP_deep),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
MeanSpec_deep(6,:) = nanmean(Data(Restrict(Sptsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
MeanSpec_deep(7,:) = nanmean(Data(Restrict(Sptsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));

[Sp,t,f]=mtspecgramc(Data(LFP_sup),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
MeanSpec_sup(6,:) = nanmean(Data(Restrict(Sptsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
MeanSpec_sup(7,:) = nanmean(Data(Restrict(Sptsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));

[Sp,t,f]=mtspecgramc(Data(LFP_diff),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
MeanSpec_diff(6,:) = nanmean(Data(Restrict(Sptsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
MeanSpec_diff(7,:) = nanmean(Data(Restrict(Sptsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));


% Coherence
[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_HPC),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_HPC_deep(6,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
MeanCoh_HPC_deep(7,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_HPC),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_HPC_sup(6,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
MeanCoh_HPC_sup(7,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_HPC),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_HPC_diff(6,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
MeanCoh_HPC_diff(7,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_OB),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_OB_deep(6,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
MeanCoh_OB_deep(7,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_OB),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_OB_sup(6,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
MeanCoh_OB_sup(7,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_OB),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_OB_diff(6,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')))));
MeanCoh_OB_diff(7,:) = nanmean(Data(Restrict(Ctsd,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')))));


NameEpoch{5} = 'Wake-homecage';
NameEpoch{6} = 'Fz-Safe';
NameEpoch{7} = 'Fz-Shock';


figure
subplot(4,3,1)
plot(f,MeanCoh_OB_sup','linewidth',3)
legend(NameEpoch(1:7))
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
subplot(4,3,2)
plot(f,MeanCoh_OB_deep','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
subplot(4,3,3)
plot(f,MeanCoh_OB_diff','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)

subplot(4,3,4)
plot(f,MeanCoh_HPC_sup','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
subplot(4,3,5)
plot(f,MeanCoh_HPC_deep','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
subplot(4,3,6)
plot(f,MeanCoh_HPC_diff','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)

subplot(4,3,7)
plot(f,MeanSpec_sup','linewidth',3)
subplot(4,3,8)
plot(f,MeanSpec_deep','linewidth',3)
subplot(4,3,9)
plot(f,MeanSpec_diff','linewidth',3)

subplot(4,3,10)
plot(f,log(MeanSpec_sup'),'linewidth',3)
subplot(4,3,11)
plot(f,log(MeanSpec_deep'),'linewidth',3)
subplot(4,3,12)
plot(f,log(MeanSpec_diff'),'linewidth',3)


