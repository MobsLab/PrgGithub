

GetEmbReactMiceFolderList_BM

Session_type={'Cond','Ext'};
Mouse2 = Mouse([1:59 61 63:65]); clear Mouse; Mouse=Mouse2;

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM([688,739,777,779,849,893],lower(Session_type{sess}),'hpc_around_ripples');
end

figure
plot(Spectro{3} , (squeeze(TSD_DATA.Cond.hpc_around_ripples.mean(:,5,:))./TSD_DATA.Cond.hpc_around_ripples.power(:,5))')
figure
plot(Spectro{3} , (squeeze(TSD_DATA.Cond.hpc_around_ripples.mean(:,6,:))./TSD_DATA.Cond.hpc_around_ripples.power(:,6))')
figure
plot(Spectro{3} , (squeeze(TSD_DATA.Ext.hpc_around_ripples.mean(:,5,:))./TSD_DATA.Ext.hpc_around_ripples.power(:,5))')
figure
plot(Spectro{3} , (squeeze(TSD_DATA.Ext.hpc_around_ripples.mean(:,6,:))./TSD_DATA.Ext.hpc_around_ripples.power(:,6))')


A=nanmean(squeeze(TSD_DATA.Cond.hpc_around_ripples.mean(:,5,:))./TSD_DATA.Cond.hpc_around_ripples.power(:,5));
B=nanmean(squeeze(TSD_DATA.Cond.hpc_around_ripples.mean(:,6,:))./TSD_DATA.Cond.hpc_around_ripples.power(:,6));
C=nanmean(squeeze(TSD_DATA.Ext.hpc_around_ripples.mean(:,5,:))./TSD_DATA.Ext.hpc_around_ripples.power(:,5));
D=nanmean(squeeze(TSD_DATA.Ext.hpc_around_ripples.mean(:,6,:))./TSD_DATA.Ext.hpc_around_ripples.power(:,6));

figure
plot(Spectro{3} , A)
hold on
plot(Spectro{3} , B)

figure
plot(Spectro{3} , C)
hold on
plot(Spectro{3} , D)



%%
cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondBlockedShock_PostDrug/Cond1')
load('RipplesSleepThresh.mat')
load('behavResources_SB.mat')

load('ChannelsToAnalyse/dHPC_deep.mat')

movefile H_Low_Spectrum.mat H_Low_Spectrum_rip.mat
LowSpectrumSB([cd filesep],channel,'H')
movefile H_Low_Spectrum.mat H_Low_Spectrum_deep.mat
movefile H_Low_Spectrum_rip.mat H_Low_Spectrum.mat

Fz_shock = and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1});
Fz_safe = and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{5} , Behav.ZoneEpoch{2}));

AroundRipples = intervalSet(Start(RipplesEpochR)-1e4 , Stop(RipplesEpochR)+1e4);

load('H_Low_Spectrum_deep.mat')
HPC_Low_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
RangeLow = Spectro{3};

HPC_Low_AroundRipples_FzShock = Restrict(HPC_Low_tsd , and(Fz_shock , AroundRipples));
HPC_Low_FzShock = Restrict(HPC_Low_tsd , Fz_shock);
HPC_Low_AroundRipples_FzSafe = Restrict(HPC_Low_tsd , and(Fz_safe , AroundRipples));
HPC_Low_FzSafe = Restrict(HPC_Low_tsd , Fz_safe);


figure
subplot(121)
plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzShock)))
hold on
plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzSafe)))
makepretty; 
title('HPC Low'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')
vline(6.8,'--r'); xlim([0 15])

subplot(122)
hold on
plot(RangeLow , nanmean(Data(HPC_Low_FzSafe)))
makepretty; legend('Around Safe Ripples','Fz safe')
title('HPC Low'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')
vline(6.8,'--r'); xlim([0 15])


%%
load('RipplesSleepThresh.mat')
load('behavResources_SB.mat')

load('ChannelsToAnalyse/dHPC_deep.mat')

movefile H_Low_Spectrum.mat H_Low_Spectrum_rip.mat
LowSpectrumSB([cd filesep],channel,'H')
movefile H_Low_Spectrum.mat H_Low_Spectrum_deep.mat
movefile H_Low_Spectrum_rip.mat H_Low_Spectrum.mat

Fz_shock = and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1});
Fz_safe = and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{5} , Behav.ZoneEpoch{2}));

AroundRipples = intervalSet(Start(RipplesEpochR)-1e4 , Stop(RipplesEpochR)+1e4);

load('H_Low_Spectrum_deep.mat')
HPC_Low_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
RangeLow = Spectro{3};

load('H_VHigh_Spectrum.mat')
HPC_VHigh_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
RangeVHigh = Spectro{3};

HR_AroundRipples_FzShock = Restrict(EKG.HBRate , and(Fz_shock , AroundRipples));
HPC_Low_AroundRipples_FzShock = Restrict(HPC_Low_tsd , and(Fz_shock , AroundRipples));
HPC_VHigh_AroundRipples_FzShock = Restrict(HPC_VHigh_tsd , and(Fz_shock , AroundRipples));

HR_FzShock = Restrict(EKG.HBRate , Fz_shock);
HPC_Low_FzShock = Restrict(HPC_Low_tsd , Fz_shock);
HPC_VHigh_FzShock = Restrict(HPC_VHigh_tsd , Fz_shock);

HR_AroundRipples_FzSafe = Restrict(EKG.HBRate , and(Fz_safe , AroundRipples));
HPC_Low_AroundRipples_FzSafe = Restrict(HPC_Low_tsd , and(Fz_safe , AroundRipples));
HPC_VHigh_AroundRipples_FzSafe = Restrict(HPC_VHigh_tsd , and(Fz_safe , AroundRipples));

HR_FzSafe = Restrict(EKG.HBRate , Fz_safe);
HPC_Low_FzSafe = Restrict(HPC_Low_tsd , Fz_safe);
HPC_VHigh_FzSafe = Restrict(HPC_VHigh_tsd , Fz_safe);


figure
subplot(331)
bar([nanmean(Data(HR_AroundRipples_FzShock)) nanmean(Data(HR_FzShock))])
ylim([11.4 11.7]); ylabel('Frequency (Hz)')
xticklabels({'Around Shock Ripples','Fz shock'}); xtickangle(45)
makepretty; title('HR')

subplot(332)
plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzShock)))
hold on
plot(RangeLow , nanmean(Data(HPC_Low_FzShock)))
makepretty; legend('Around Shock Ripples','Fz shock')
title('HPC Low'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')
vline(6.8,'--r'); xlim([0 15])

subplot(333)
plot(RangeVHigh , nanmean(Data(HPC_VHigh_AroundRipples_FzShock)))
hold on
plot(RangeVHigh , nanmean(Data(HPC_VHigh_FzShock)))
makepretty; legend('Around Shock Ripples','Fz shock')
title('HPC VHigh'); xlabel('Frequency (Hz)')
set(gca, 'YScale', 'log'); xlim([120 220]); ylim([10 100]); vline(187,'--r')

subplot(334)
bar([nanmean(Data(HR_AroundRipples_FzSafe))  nanmean(Data(HR_FzSafe))])
ylim([10.4 11]); ylabel('Frequency (Hz)')
xticklabels({'Around Safe Ripples','Fz safe'}); xtickangle(45)
makepretty; title('HR')

subplot(335)
plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzSafe)))
hold on
plot(RangeLow , nanmean(Data(HPC_Low_FzSafe)))
makepretty; legend('Around Shock Ripples','Fz safe')
title('HPC Low'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')
vline(6.8,'--r'); xlim([0 15])

subplot(336)
plot(RangeVHigh , nanmean(Data(HPC_VHigh_AroundRipples_FzSafe)))
hold on
plot(RangeVHigh , nanmean(Data(HPC_VHigh_FzSafe)))
makepretty; legend('Around Shock Ripples','Fz shock')
title('HPC VHigh'); xlabel('Frequency (Hz)')
set(gca, 'YScale', 'log'); xlim([120 220]); ylim([10 100]); vline(187,'--r')


a=suptitle('Some characteristics around ripples'); a.FontSize=20;



%% Sleep
try
    load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch')
catch
      load('StateEpochSB.mat', 'Wake', 'REMEpoch', 'SWSEpoch')  
end
try
    load('Ripples.mat', 'RipplesEpochR')
catch
    load('SWR.mat', 'RipplesEpoch')
end
load('H_VHigh_Spectrum.mat')
HPC_VHigh_Sleep_tsd = tsd(Spectro{2}*1e4 , Spectro{1});

VHigh_Spec_Wake = Restrict(HPC_VHigh_Sleep_tsd , and(Wake , RipplesEpochR));
VHigh_Spec_NREM = Restrict(HPC_VHigh_Sleep_tsd , and(SWSEpoch , RipplesEpochR));
VHigh_Spec_REM = Restrict(HPC_VHigh_Sleep_tsd , and(REMEpoch , RipplesEpochR));


subplot(337)
plot(RangeVHigh , Spectro{3}.*nanmean(Data(VHigh_Spec_Wake)))
hold on
plot(RangeVHigh , Spectro{3}.*nanmean(Data(VHigh_Spec_NREM)))
plot(RangeVHigh , Spectro{3}.*nanmean(Data(VHigh_Spec_REM)))
makepretty; 
legend('Wake','NREM','REM')
set(gca, 'YScale', 'log');
xlim([50 220]); ylim([10 100]);
 
title('HPC Low'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')
vline(6.8,'--r'); xlim([0 15])
 xlim([120 220]); ylim([10 100]); vline(187,'--r')
















