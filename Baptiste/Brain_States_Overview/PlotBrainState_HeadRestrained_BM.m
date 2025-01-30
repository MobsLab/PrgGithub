
sess=1; %group=;
Cols = {[0.75, 0, 0.75],[0, 1, 0]};
X = [1,2];
Legends = {'Immobile','Moving'};

%% 1) Plot mean spectrum
figure
subplot(351)
Data_to_use = squeeze(OutPutData.ob_low.mean(:,2,:))./max([OutPutData.ob_low.power(:,2) OutPutData.ob_low.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp);
vline(RangeLow(d),'--r')
Data_to_use = squeeze(OutPutData.ob_low.mean(:,3,:))./max([OutPutData.ob_low.power(:,2) OutPutData.ob_low.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp);
vline(RangeLow(d),'--b')
f=get(gca,'Children');
a=legend([f(8),f(4)],'Immobile','Moving');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
title('Low OB')

subplot(352); thr=21;
Data_to_use = squeeze(OutPutData.ob_middle.mean(:,2,:))./max([OutPutData.ob_middle.power(:,2) OutPutData.ob_middle.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeMiddle(d+thr),'--r')
Data_to_use = squeeze(OutPutData.ob_middle.mean(:,3,:))./max([OutPutData.ob_middle.power(:,2) OutPutData.ob_middle.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeMiddle(d+thr),'--g')
makepretty; xlabel('Frequency (Hz)'); xlim([30 100]); ylim([0 1])
title('High OB')

subplot(353); thr= 25;
Data_to_use = squeeze(OutPutData.hpc_low.mean(:,2,:))./max([OutPutData.hpc_low.power(:,2) OutPutData.hpc_low.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--r')
Data_to_use = squeeze(OutPutData.hpc_low.mean(:,3,:))./max([OutPutData.hpc_low.power(:,2) OutPutData.hpc_low.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
%vline(RangeLow(d+thr),'--g')
makepretty; xlabel('Frequency (Hz)'); xlim([0 15]); ylim([0 1.3])
title('Low HPC')

subplot(354)
Data_to_use = squeeze(OutPutData.pfc_low.mean(:,2,:))./max([OutPutData.pfc_low.power(:,2) OutPutData.pfc_low.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--r')
Data_to_use = squeeze(OutPutData.pfc_low.mean(:,3,:))./max([OutPutData.pfc_low.power(:,2) OutPutData.pfc_low.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--g')
makepretty; xlabel('Frequency (Hz)'); xlim([0 10]); ylim([0 1])
title('Low PFC')

subplot(355); thr= 30;
Data_to_use = squeeze(OutPutData.h_vhigh.mean(:,2,:))./max([OutPutData.h_vhigh.power(:,2) OutPutData.h_vhigh.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeVHigh(d+thr),'--r')
Data_to_use = squeeze(OutPutData.h_vhigh.mean(:,3,:))./max([OutPutData.h_vhigh.power(:,2) OutPutData.h_vhigh.power(:,3)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeVHigh(d+thr),'--g')
makepretty; xlabel('Frequency (Hz)'); xlim([120 250]); ylim([0 1]);
title('VHigh')


%% 2) Plot data paired MakeSpreadAndBoxPlot2_SB
subplot(3,10,11)
MakeSpreadAndBoxPlot2_SB(OutPutData.ob_low.max_freq(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,12)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.ob_low.power(:,2:3)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power'); ylim([5.3 6.1])

subplot(3,10,13)
MakeSpreadAndBoxPlot2_SB(OutPutData.ob_middle.max_freq(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,14)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.ob_middle.power(:,2:3)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

subplot(3,10,15)
MakeSpreadAndBoxPlot2_SB(OutPutData.hpc_low.max_freq(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,16)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.hpc_low.power(:,2:3)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

subplot(3,10,17)
MakeSpreadAndBoxPlot2_SB(OutPutData.pfc_low.max_freq(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,18)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.pfc_low.power(:,2:3)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

subplot(3,10,19)
MakeSpreadAndBoxPlot2_SB(OutPutData.h_vhigh.max_freq(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,20)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.h_vhigh.power(:,2:3)),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

%% 3) Funny things
% OB mean waveform
subplot(3,5,11)
Data_to_use = squeeze(OutPutData.respi_meanwaveform(:,2,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use); max_Respi = max([max(nanmean(squeeze(OutPutData.respi_meanwaveform(:,2,:)))) max(nanmean(squeeze(OutPutData.respi_meanwaveform(:,3,:))))]);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-m',1); hold on;
Data_to_use = squeeze(OutPutData.respi_meanwaveform(:,3,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-g',1); hold on;
makepretty; ylabel('Amplitude (a.u.)'); xlabel('time (ms)'); xlim([0 751]); ylim([-1.1 1.2])
xticks([0 376 751]); xticklabels({'-300','0','+300'})
title('Mean OB waveform')

% Phase Pref
for mouse=1:length(Mouse)
    PhasePref_Immobile(mouse,:,:) = OutPutData.phase_pref.PhasePref{mouse, 2}'./max([max(OutPutData.phase_pref.PhasePref{mouse, 2}(:,21:end)) max(OutPutData.phase_pref.PhasePref{mouse, 3}(:,21:end))]);
    PhasePref_Moving(mouse,:,:) = OutPutData.phase_pref.PhasePref{mouse, 3}'./max([max(OutPutData.phase_pref.PhasePref{mouse, 2}(:,21:end)) max(OutPutData.phase_pref.PhasePref{mouse, 3}(:,21:end))]);
end

PhasePref_Immobile_Averaged = squeeze(nanmean(PhasePref_Immobile));
PhasePref_Moving_Averaged = squeeze(nanmean(PhasePref_Moving));

subplot(3,10,23)
imagesc(OutPutData.phase_pref.BinnedPhase , OutPutData.phase_pref.Frequency , PhasePref_Immobile_Averaged);
axis xy; caxis([0 0.9]); ylim([20 100])
makepretty; ylabel('Frequency (Hz)');
title('Immobile'); xlabel('Phase (°)')
subplot(3,10,24)
imagesc(OutPutData.phase_pref.BinnedPhase , OutPutData.phase_pref.Frequency , PhasePref_Moving_Averaged);
axis xy; caxis([0 0.9]); ylim([20 100])
makepretty;  
title('Moving'); xlabel('Phase (°)')
u=text(-300,115,'Gamma preference'); set(u,'FontSize',20,'FontWeight','bold');
colormap jet

% HPC around ripples
subplot(3,5,13)

if sess==1;
    cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondBlockedShock_PostDrug/Cond2')
    load('RipplesSleepThresh.mat')
    load('behavResources_SB.mat')
    
    Fz_shock = and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1});
    Fz_safe = and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{5} , Behav.ZoneEpoch{2}));
    
    AroundRipples = intervalSet(Start(RipplesEpochR)-.3e4 , Stop(RipplesEpochR)+.3e4);
    
    load('H_Low_Spectrum_deep.mat')
    HPC_Low_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
    
    HPC_Low_AroundRipples_FzShock = Restrict(HPC_Low_tsd , and(Fz_shock , AroundRipples));
    HPC_Low_FzShock = Restrict(HPC_Low_tsd , Fz_shock);
    HPC_Low_AroundRipples_FzSafe = Restrict(HPC_Low_tsd , and(Fz_safe , AroundRipples));
    HPC_Low_FzSafe = Restrict(HPC_Low_tsd , Fz_safe);
    
    plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzShock)) , 'r' , 'LineWidth' , 2)
    hold on
    plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzSafe)) , 'b' , 'LineWidth' , 2)
    makepretty;
    title('HPC Low around ripples'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')
    
    cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_SleepPost_PreDrug')
    load('IdFigureData2.mat', 'ripples_curves')
    axes('Position',[.53 .24 .05 .07]); box on
    plot(ripples_curves{1, 1}(:,2),'k')
    hold on
    plot(ripples_curves{1, 3}(:,2),'g')
    xlim([200 801]); ylim([-2.5e3 2e3]); makepretty
    
else
    
    cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_ExtinctionBlockedShock_PostDrug/Ext2/')
    load('RipplesSleepThresh.mat')
    load('behavResources_SB.mat')
    
    Fz_shock = and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1});
    
    AroundRipples = intervalSet(Start(RipplesEpochR)-.3e4 , Stop(RipplesEpochR)+.3e4);
    
    load('H_Low_Spectrum_deep.mat')
    HPC_Low_tsd_Sk = tsd(Spectro{2}*1e4 , Spectro{1});
    HPC_Low_AroundRipples_FzShock = Restrict(HPC_Low_tsd , and(Fz_shock , AroundRipples));
    
    cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_ExtinctionBlockedSafe_PostDrug/Ext2/')
    load('RipplesSleepThresh.mat')
    load('behavResources_SB.mat')
    
    Fz_safe = and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{5} , Behav.ZoneEpoch{2}));
    
    AroundRipples = intervalSet(Start(RipplesEpochR)-.3e4 , Stop(RipplesEpochR)+.3e4);
    
    load('H_Low_Spectrum_deep.mat')
    HPC_Low_tsd_Sf = tsd(Spectro{2}*1e4 , Spectro{1});
    HPC_Low_AroundRipples_FzSafe = Restrict(HPC_Low_tsd , and(Fz_safe , AroundRipples));
    
    plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzShock)) , 'r' , 'LineWidth' , 2)
    hold on
    plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_FzSafe)) , 'b' , 'LineWidth' , 2)
    makepretty;
    title('HPC Low around ripples'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)'); ylim([0 3e5])
    
    cd('/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_SleepPost_PreDrug')
    load('IdFigureData2.mat', 'ripples_curves')
    axes('Position',[.53 .24 .05 .07]); box on
    plot(ripples_curves{1, 1}(:,2),'k')
    hold on
    plot(ripples_curves{1, 3}(:,2),'g')
    xlim([200 801]); ylim([-2.5e3 2e3]); makepretty
    
end


% OB-PFC coherence
subplot(3,5,14); thr=1;
f = linspace(0,20,size(OutPutData.ob_pfc_coherence.mean,3));
Data_to_use = squeeze(OutPutData.ob_pfc_coherence.mean(:,2,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--m')
Data_to_use = squeeze(OutPutData.ob_pfc_coherence.mean(:,3,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--g')
makepretty; xlim([0 20]); 
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')
title('OB-PFC coherence')


% Ripples
subplot(3,5,15)
OutPutData.wake_ripples.mean(OutPutData.wake_ripples.mean==0)=NaN;
MakeSpreadAndBoxPlot2_SB(OutPutData.wake_ripples.mean(:,2:3),Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Density (#/s)'); title('Ripples density')

if sess==1
    a=suptitle('Brain characterization, saline SB, Cond sessions, n=8'); a.FontSize=30;
else
    a=suptitle('Brain characterization, saline SB, Ext sessions, n=8'); a.FontSize=30;
end












