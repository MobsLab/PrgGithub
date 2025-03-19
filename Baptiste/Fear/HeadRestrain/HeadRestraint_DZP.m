
cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre3')
load('H_Low_Spectrum.mat'); range_Low=Spectro{3};
load('B_Middle_Spectrum.mat'); range_Middle=Spectro{3};
load('B_High_Spectrum.mat'); range_High=Spectro{3};
load('H_VHigh_Spectrum.mat'); range_VHigh=Spectro{3};

cd('/media/nas6/HeadRestraint/1227/20211110')
load('B_Low_Spectrum.mat')
OB_Low_Sp_tsd_Saline = tsd(Spectro{2}*1e4 , Spectro{1});
load('B_Middle_Spectrum.mat')
OB_Middle_Sp_tsd_Saline = tsd(Spectro{2}*1e4 , Spectro{1});
load('H_Low_Spectrum.mat')
HPC_Low_Sp_tsd_Saline = tsd(Spectro{2}*1e4 , Spectro{1});
load('H_VHigh_Spectrum.mat')
HPC_VHigh_Sp_tsd_Saline = tsd(Spectro{2}*1e4 , Spectro{1});
load('PFCx_Low_Spectrum.mat')
PFC_Low_Sp_tsd_Saline = tsd(Spectro{2}*1e4 , Spectro{1});

cd('/media/nas6/HeadRestraint/1227/20211112')
load('B_Low_Spectrum.mat')
OB_Low_Sp_tsd_DZP = tsd(Spectro{2}*1e4 , Spectro{1});
load('B_Middle_Spectrum.mat')
OB_Middle_Sp_tsd_DZP = tsd(Spectro{2}*1e4 , Spectro{1});
load('H_Low_Spectrum.mat')
HPC_Low_Sp_tsd_DZP = tsd(Spectro{2}*1e4 , Spectro{1});
load('H_VHigh_Spectrum.mat')
HPC_VHigh_Sp_tsd_DZP = tsd(Spectro{2}*1e4 , Spectro{1});
load('PFCx_Low_Spectrum.mat')
PFC_Low_Sp_tsd_DZP = tsd(Spectro{2}*1e4 , Spectro{1});

figure
subplot(231)
plot(range_Low , nanmean(Data(OB_Low_Sp_tsd_Saline)))
hold on
plot(range_Low , nanmean(Data(OB_Low_Sp_tsd_DZP)) , 'r')
makepretty
xlim([0 12])
ylabel('Power (a.u.)')
legend('Saline','DZP')
[u,v]=max(nanmean(Data(OB_Low_Sp_tsd_Saline))); vline(range_Low(v),'--b')
[u,v]=max(nanmean(Data(OB_Low_Sp_tsd_DZP))); vline(range_Low(v),'--r')
title('OB Low')

subplot(232)
plot(range_Middle , nanmean(Data(OB_Middle_Sp_tsd_Saline)))
hold on
plot(range_Middle , nanmean(Data(OB_Middle_Sp_tsd_DZP)) , 'r')
set(gca, 'YScale', 'log');
OB_Middle_Sp_tsd_Saline_mean = nanmean(Data(OB_Middle_Sp_tsd_Saline)); [u,v]=max(OB_Middle_Sp_tsd_Saline_mean(:,21:end)); vline(range_Middle(v+20),'--b')
OB_Middle_Sp_tsd_DZP_mean = nanmean(Data(OB_Middle_Sp_tsd_DZP)); [u,v]=max(OB_Middle_Sp_tsd_DZP_mean(:,21:end)); vline(range_Middle(v+20),'--r')
makepretty
title('OB Middle')

subplot(233)
plot(range_Low , nanmean(Data(HPC_Low_Sp_tsd_Saline)))
hold on
plot(range_Low , nanmean(Data(HPC_Low_Sp_tsd_DZP)) , 'r')
HPC_Low_Sp_tsd_Saline_mean = nanmean(Data(HPC_Low_Sp_tsd_Saline)); [u,v]=max(HPC_Low_Sp_tsd_Saline_mean(:,73:end)); vline(range_Low(v+72),'--b')
HPC_Low_Sp_tsd_DZP_mean = nanmean(Data(HPC_Low_Sp_tsd_DZP)); [u,v]=max(HPC_Low_Sp_tsd_DZP_mean(:,73:end)); vline(range_Low(v+72),'--r')
makepretty
title('HPC Low')

subplot(234)
plot(range_VHigh , nanmean(Data(HPC_VHigh_Sp_tsd_Saline)))
hold on
plot(range_VHigh , nanmean(Data(HPC_VHigh_Sp_tsd_DZP)) , 'r')
makepretty
set(gca, 'YScale', 'log');
xlabel('Frequency (Hz)')
ylabel('Power (a.u.)')
title('HPC VHigh')

subplot(235)
plot(range_Low , nanmean(Data(PFC_Low_Sp_tsd_Saline)))
hold on
plot(range_Low , nanmean(Data(PFC_Low_Sp_tsd_DZP)) , 'r')
makepretty
xlabel('Frequency (Hz)')
title('PFC Low')

a=suptitle('Mean spectrum, head fixed, 1h, Saline & DZP'); a.FontSize=20;

%% Ripples
% Saline
cd('/media/nas6/HeadRestraint/1227/20211110')
clear ripples RipplesEpoch
load('SWR.mat')
ripples_saline = ripples;

load('ChannelsToAnalyse/dHPC_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_HPC_deep_saline = LFP;

load('ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_HPC_rip_saline = LFP;

load('H_VHigh_Spectrum.mat')
Sptsd.HPC_VHigh_Saline = tsd(Spectro{2}*1e4 , Spectro{1});

for rip_numb = 1:length(Start(RipplesEpoch))
    HPC_VHigh_OnRipplesEpoch_Data_Saline = Data(Restrict(Sptsd.HPC_VHigh_Saline , subset(RipplesEpoch,rip_numb)));
    Power_DruingRipple_Saline(rip_numb) = nanmean(nanmean(HPC_VHigh_OnRipplesEpoch_Data_Saline(:,45:94)'));
end

for rip_numb = 1:length(Start(RipplesEpoch))
    RipplesEpoch_extended = intervalSet(Start(subset(RipplesEpoch , rip_numb))-200 , Stop(subset(RipplesEpoch , rip_numb))+200);
    HPC_deep_Amplitude_Saline(rip_numb) = max(runmean(Data(Restrict(LFP_HPC_deep_saline , RipplesEpoch_extended)),3))-min(runmean(Data(Restrict(LFP_HPC_deep_saline , RipplesEpoch_extended)),3));
end

Sptsd.HPC_VHigh_OnRipplesEpoch_Saline = Restrict(Sptsd.HPC_VHigh_Saline , RipplesEpoch);

load('StateEpochSB.mat', 'Epoch')
channel = Get_rip_chan_BM(cd , 'bulb_deep');
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_bulb = LFP;
channel = Get_rip_chan_BM(cd , 'pfc_deep');
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_pfc = LFP;
channel = Get_rip_chan_BM(cd , 'hpc_deep');
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_hpc = LFP;
params.Fs=1/median(diff(Range(LFP_bulb,'s'))); params.tapers=[3 5]; params.fpass=[0.1 20]; params.err=[2,0.05]; params.pad=0; movingwin=[3 0.2];

[Ctemp_bulb_saline,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(LFP_bulb) , Data(LFP_pfc) , movingwin , params);
[Ctemp_hpc_saline,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(LFP_hpc) , Data(LFP_pfc) , movingwin , params);

% DZP
cd('/media/nas6/HeadRestraint/1227/20211112')
clear ripples RipplesEpoch
load('SWR.mat')
ripples_dzp = ripples;

load('ChannelsToAnalyse/dHPC_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_HPC_deep_dzp = LFP;

load('ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_HPC_rip_dzp = LFP;

load('H_VHigh_Spectrum.mat')
Sptsd.HPC_VHigh_DZP = tsd(Spectro{2}*1e4 , Spectro{1});

for rip_numb = 1:length(Start(RipplesEpoch))
    clear HPC_VHigh_OnRipplesEpoch_Data
    HPC_VHigh_OnRipplesEpoch_Data_DZP = Data(Restrict(Sptsd.HPC_VHigh_DZP , subset(RipplesEpoch,rip_numb)));
    Power_DruingRipple_DZP(rip_numb) = nanmean(nanmean(HPC_VHigh_OnRipplesEpoch_Data_DZP(:,45:94)'));
end

for rip_numb = 1:length(Start(RipplesEpoch))
    RipplesEpoch_extended = intervalSet(Start(subset(RipplesEpoch , rip_numb))-200 , Stop(subset(RipplesEpoch , rip_numb))+200);
    HPC_deep_Amplitude_DZP(rip_numb) = max(runmean(Data(Restrict(LFP_HPC_deep_dzp , RipplesEpoch_extended)),3))-min(runmean(Data(Restrict(LFP_HPC_deep_dzp , RipplesEpoch_extended)),3));
end

Sptsd.HPC_VHigh_OnRipplesEpoch_DZP = Restrict(Sptsd.HPC_VHigh_DZP , RipplesEpoch);

load('StateEpochSB.mat', 'Epoch')
channel = Get_rip_chan_BM(cd , 'bulb_deep');
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_bulb = LFP;
channel = Get_rip_chan_BM(cd , 'pfc_deep');
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_pfc = LFP;
channel = Get_rip_chan_BM(cd , 'hpc_deep');
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP_hpc = LFP;
params.Fs=1/median(diff(Range(LFP_bulb,'s'))); params.tapers=[3 5]; params.fpass=[0.1 20]; params.err=[2,0.05]; params.pad=0; movingwin=[3 0.2];

[Ctemp_bulb_DZP,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(LFP_bulb) , Data(LFP_pfc) , movingwin , params);
[Ctemp_hpc_DZP,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc( Data(LFP_hpc) , Data(LFP_pfc) , movingwin , params);


%
figure
subplot(221)
plot(runmean(ripples_saline(:,4),10))
hold on
plot(runmean(ripples_dzp(:,4),10) , 'r')
title('Duration evolution')
ylabel('time (ms)')
makepretty
legend('Saline','DZP')

subplot(222)
plot(runmean(ripples_saline(:,5),10))
hold on
plot(runmean(ripples_dzp(:,5),10) , 'r')
title('Frequency evolution')
ylabel('Frequency (Hz)')
makepretty

subplot(223)
plot(runmean(ripples_saline(:,6),10))
hold on
plot(runmean(ripples_dzp(:,6),10) , 'r')
xlabel('ripples events')
ylabel('amplitude (a.u.)')
title('Amplitude evolution')
makepretty

subplot(224)
plot(runmean(Power_DruingRipple_Saline,10))
hold on
plot(runmean(Power_DruingRipple_DZP,10) , 'r')
xlabel('ripples events')
ylabel('Power (a.u.)')
title('Power evolution')
makepretty

a=suptitle('Ripples features evolution along events, head restraint'); a.FontSize=20;


figure
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude_DZP , Power_DruingRipple_DZP , 10);
hold on
[R,P]=PlotCorrelations_BM(HPC_deep_Amplitude_Saline , Power_DruingRipple_Saline , 10);
makepretty
xlabel('sharp wave amplitude (a.u.)'); ylabel('ripples power (a.u.)')
f=get(gca,'Children'); legend([f(1),f(3)],'Saline','DZP');
title('Ripples Power = f(sharp wave amplitude)')


figure
plot(range_VHigh , nanmean(Data(Sptsd.HPC_VHigh_OnRipplesEpoch_Saline)))
hold on
plot(range_VHigh , nanmean(Data(Sptsd.HPC_VHigh_OnRipplesEpoch_DZP)) , 'r')
set(gca, 'YScale', 'log');
makepretty
xlabel('Frequency (Hz)')
ylabel('Power (a.u.)')
legend('Saline','DZP')
title('HPC VHigh spectrum on ripples epoch')


% compare to sleep
cd('/media/nas6/ProjetEmbReact/Mouse1227/20210813')
load('SWR.mat')

figure
subplot(221)
plot(runmean(ripples(:,4),50))
title('Duration evolution')
ylabel('time (s)')
makepretty

subplot(222)
plot(runmean(ripples(:,5),50))
title('Frequency evolution')
ylabel('Frequency (Hz)')
makepretty

subplot(223)
plot(runmean(ripples(:,6),50))
xlabel('ripples events')
ylabel('amplitude (a.u.)')
title('Amplitude evolution')
makepretty

subplot(224)
plot(runmean(Power_DruingRipple_Saline,50))
hold on
plot(runmean(Power_DruingRipple_DZP,50))
xlabel('ripples events')
ylabel('Power (log scale)')
title('Power evolution')
makepretty



%% coherence

f = linspace(0,20,size(Ctemp_bulb_DZP,2));

figure
plot(f , nanmean(Ctemp_bulb_saline) , '-b')
hold on
plot(f , nanmean(Ctemp_bulb_DZP) , '-r')
makepretty
plot(f , nanmean(Ctemp_hpc_saline) , '--b' , 'LineWidth' , 3)
plot(f , nanmean(Ctemp_hpc_DZP) , '--r' , 'LineWidth' , 3)
ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')
legend('Bulb-PFC Saline','Bulb-PFC DZP','HPC-PFC Saline','HPC-PFC DZP')
title('Coherence in PFCx from Bulb & Hippocampus, head-restraint, Saline-DZP')

