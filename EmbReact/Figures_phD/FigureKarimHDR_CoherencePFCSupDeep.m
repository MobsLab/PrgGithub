clear all
[params,movingwin,suffix]=SpectrumParametersML('low');

    cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPostSound
    
% Sleep
% PFC sup
load('ChannelsToAnalyse/PFCx_deep.mat')
channel_deep = 16;
load('IdFigureData.mat', 'Mdeep_long_delta')
load(['LFPData/LFP',num2str(channel_deep),'.mat'])
LFP_deep = LFP;

% PFC deep
% load('ChannelsToAnalyse/PFCx_sup.mat')
channel_sup = 8;
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

Epoch2{1} = or(or(Epoch{1},Epoch{2}),Epoch{3});
Epoch2{2} = Epoch{4};
Epoch2{3} = Epoch{5};
Epoch = Epoch2;

% Spectra
[Sp,t,f]=mtspecgramc(Data(LFP_deep),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
    
for ep = 1:3
   MeanSpec_deep(ep,:) = nanmean(Data(Restrict(Sptsd,Epoch{ep})));
end

[Sp,t,f]=mtspecgramc(Data(LFP_sup),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
for ep = 1:3
   MeanSpec_sup(ep,:) = nanmean(Data(Restrict(Sptsd,Epoch{ep})));
end

[Sp,t,f]=mtspecgramc(Data(LFP_diff),movingwin,params);
save('SpectrumDataL/SpectrumPFC_diff.mat','Sp','t','f','movingwin','params')
Sptsd = tsd(t*1e4,Sp);
    
for ep = 1:3
   MeanSpec_diff(ep,:) = nanmean(Data(Restrict(Sptsd,Epoch{ep})));
end

% Coherence
[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_HPC),movingwin,params);
save(['CohgramcDataL/Cohgram_HPC_PFCx_Deep','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:3
   MeanCoh_HPC_deep(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_HPC),movingwin,params);
save(['CohgramcDataL/Cohgram_HPC_PFCx_Sup','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:3
   MeanCoh_HPC_sup(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_HPC),movingwin,params);
save(['CohgramcDataL/Cohgram_HPC_PFCx_Diff','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:3
   MeanCoh_HPC_diff(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_OB),movingwin,params);
save(['CohgramcDataL/Cohgram_OB_PFCx_Deep','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:3
   MeanCoh_OB_deep(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_OB),movingwin,params);
save(['CohgramcDataL/Cohgram_OB_PFCx_Sup','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:3
   MeanCoh_OB_sup(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_OB),movingwin,params);
save(['CohgramcDataL/Cohgram_OB_PFCx_Diff','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
for ep = 1:3
   MeanCoh_OB_diff(ep,:) = nanmean(Data(Restrict(Ctsd,Epoch{ep})));
end

%% Freezing
clear LFP_OB LFP_HPC LFP_deep LFP_sup LFP_diff
Dir = GetAllMouseTaskSessions(510);
x1 = strfind(Dir,'UMazeCond');
ToKeep = find(~cellfun(@isempty,x1));
Dir = Dir(ToKeep);

FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
StimEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');
StimEpochToRemove = or(intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4),NoiseEpoch);
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
MeanSpec_deep(5,:) = nanmean(Data(Restrict(Sptsd,FreezeEpoch)));

[Sp,t,f]=mtspecgramc(Data(LFP_sup),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
MeanSpec_sup(5,:) = nanmean(Data(Restrict(Sptsd,FreezeEpoch)));

[Sp,t,f]=mtspecgramc(Data(LFP_diff),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
MeanSpec_diff(5,:) = nanmean(Data(Restrict(Sptsd,FreezeEpoch)));

% Coherence
[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_HPC),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_HPC_deep(4,:) = nanmean(Data(Restrict(Ctsd,FreezeEpoch)));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_HPC),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_HPC_sup(4,:) = nanmean(Data(Restrict(Ctsd,FreezeEpoch)));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_HPC),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_HPC_diff(4,:) = nanmean(Data(Restrict(Ctsd,FreezeEpoch)));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_OB),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_OB_deep(4,:) = nanmean(Data(Restrict(Ctsd,FreezeEpoch)));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_OB),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_OB_sup(4,:) = nanmean(Data(Restrict(Ctsd,FreezeEpoch)));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_OB),movingwin,params);
Ctsd = tsd(t*1e4,C);
MeanCoh_OB_diff(4,:) = nanmean(Data(Restrict(Ctsd,FreezeEpoch)));

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_Habituation
% Movement
% PFC sup
channel_deep = 16;
load(['LFPData/LFP',num2str(channel_deep),'.mat'])
LFP_deep = LFP;

% PFC deep
channel_sup = 8;
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

load('StateEpochSB.mat')
TotEpoch = intervalSet(0,max(Range(LFP)));
EpochOfInt = TotEpoch-NoiseEpoch;

% Spectra
[Sp,t,f]=mtspecgramc(Data(LFP_deep),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
    
MeanSpec_deep(3,:) = nanmean(Data(Restrict(Sptsd,EpochOfInt)));

[Sp,t,f]=mtspecgramc(Data(LFP_sup),movingwin,params);
Sptsd = tsd(t*1e4,Sp);
   MeanSpec_sup(3,:) = nanmean(Data(Restrict(Sptsd,EpochOfInt)));


[Sp,t,f]=mtspecgramc(Data(LFP_diff),movingwin,params);
save('SpectrumDataL/SpectrumPFC_diff.mat','Sp','t','f','movingwin','params')
Sptsd = tsd(t*1e4,Sp);
       MeanSpec_diff(3,:) = nanmean(Data(Restrict(Sptsd,EpochOfInt)));


% Coherence
[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_HPC),movingwin,params);
save(['CohgramcDataL/Cohgram_HPC_PFCx_Deep','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
   MeanCoh_HPC_deep(3,:) = nanmean(Data(Restrict(Ctsd,EpochOfInt)));


[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_HPC),movingwin,params);
save(['CohgramcDataL/Cohgram_HPC_PFCx_Sup','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
   MeanCoh_HPC_sup(3,:) = nanmean(Data(Restrict(Ctsd,EpochOfInt)));


[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_HPC),movingwin,params);
save(['CohgramcDataL/Cohgram_HPC_PFCx_Diff','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
   MeanCoh_HPC_diff(3,:) = nanmean(Data(Restrict(Ctsd,EpochOfInt)));


[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_deep),Data(LFP_OB),movingwin,params);
save(['CohgramcDataL/Cohgram_OB_PFCx_Deep','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
   MeanCoh_OB_deep(3,:) = nanmean(Data(Restrict(Ctsd,EpochOfInt)));


[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_sup),Data(LFP_OB),movingwin,params);
save(['CohgramcDataL/Cohgram_OB_PFCx_Sup','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
   MeanCoh_OB_sup(3,:) = nanmean(Data(Restrict(Ctsd,EpochOfInt)));

[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_diff),Data(LFP_OB),movingwin,params);
save(['CohgramcDataL/Cohgram_OB_PFCx_Diff','.mat'],'C','phi','S12','confC','t','f')
Ctsd = tsd(t*1e4,C);
   MeanCoh_OB_diff(3,:) = nanmean(Data(Restrict(Ctsd,EpochOfInt)));


NameEpoch{1} = 'NREM';
NameEpoch{2} = 'REM';
NameEpoch{3} = 'Wake-Running';
NameEpoch{4} = 'Wake-freezing';

figure
colori=[0.2 0.2 0.8;0.8 0.2 0.2 ;0.2 0.2 0.2 ;0 0.8 0;0.3 1 0.3 ];
subplot(2,3,1)
set(gca,'ColorOrder',colori),hold on
plot(f,MeanCoh_OB_sup','linewidth',3)
legend(NameEpoch(1:5))
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
subplot(2,3,2)
set(gca,'ColorOrder',colori),hold on
plot(f,MeanCoh_OB_deep','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
subplot(2,3,3)
set(gca,'ColorOrder',colori),hold on
plot(f,MeanCoh_OB_diff','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)

subplot(2,3,4)
set(gca,'ColorOrder',colori),hold on
plot(f,MeanCoh_HPC_sup','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
subplot(2,3,5)
set(gca,'ColorOrder',colori),hold on
plot(f,MeanCoh_HPC_deep','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
subplot(2,3,6)
set(gca,'ColorOrder',colori),hold on
plot(f,MeanCoh_HPC_diff','linewidth',3)
ylim([0.3 1])
xlabel('Frequency (Hz)'), box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
