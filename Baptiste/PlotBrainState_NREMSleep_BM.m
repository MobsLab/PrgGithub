

cd('/media/nas4/ProjetEmbReact/VideosOthman')

Cols1 = {[1, 0.8, 0.8],[1, 0.4, 0.4],[0.8, 0, 0]};
X1 = [1,2,3];
Legends1 = {'N1','N2','N3'};

%% 1) Plot mean spectrum
figure
subplot(351); thr=20;
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_low.mean(:,6,:))./max([OutPutData.BaselineSleep.ob_low.power(:,6) OutPutData.BaselineSleep.ob_low.power(:,7) OutPutData.BaselineSleep.ob_low.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeLow(d),'--m')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_low.mean(:,7,:))./max([OutPutData.BaselineSleep.ob_low.power(:,6) OutPutData.BaselineSleep.ob_low.power(:,7) OutPutData.BaselineSleep.ob_low.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_low.mean(:,8,:))./max([OutPutData.BaselineSleep.ob_low.power(:,6) OutPutData.BaselineSleep.ob_low.power(:,7) OutPutData.BaselineSleep.ob_low.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--k')
f=get(gca,'Children'); a=legend([f(12),f(8),f(4)],'N1','N2','N3');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
title('Low OB')

subplot(352); thr=21;
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_middle.mean(:,6,:))./max([OutPutData.BaselineSleep.ob_middle.power(:,6) OutPutData.BaselineSleep.ob_middle.power(:,7) OutPutData.BaselineSleep.ob_middle.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeMiddle(d),'--m')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_middle.mean(:,7,:))./max([OutPutData.BaselineSleep.ob_middle.power(:,6) OutPutData.BaselineSleep.ob_middle.power(:,7) OutPutData.BaselineSleep.ob_middle.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeMiddle(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_middle.mean(:,8,:))./max([OutPutData.BaselineSleep.ob_middle.power(:,6) OutPutData.BaselineSleep.ob_middle.power(:,7) OutPutData.BaselineSleep.ob_middle.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeMiddle(d+thr-1),'--k')
makepretty; xlabel('Frequency (Hz)'); xlim([20 100]); ylim([0 1.5])
title('High OB')

subplot(353); thr= 25;
Data_to_use = squeeze(OutPutData.BaselineSleep.hpc_low.mean(:,6,:))./max([OutPutData.BaselineSleep.hpc_low.power(:,6) OutPutData.BaselineSleep.hpc_low.power(:,7) OutPutData.BaselineSleep.hpc_low.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeLow(d),'--m')
Data_to_use = squeeze(OutPutData.BaselineSleep.hpc_low.mean(:,7,:))./max([OutPutData.BaselineSleep.hpc_low.power(:,6) OutPutData.BaselineSleep.hpc_low.power(:,7) OutPutData.BaselineSleep.hpc_low.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.hpc_low.mean(:,8,:))./max([OutPutData.BaselineSleep.hpc_low.power(:,6) OutPutData.BaselineSleep.hpc_low.power(:,7) OutPutData.BaselineSleep.hpc_low.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--k')
makepretty; xlabel('Frequency (Hz)'); xlim([0 15]); ylim([0 1.1])
title('Low HPC')

subplot(354); thr= 5;
Data_to_use = squeeze(OutPutData.BaselineSleep.pfc_low.mean(:,6,:))./max([OutPutData.BaselineSleep.pfc_low.power(:,6) OutPutData.BaselineSleep.pfc_low.power(:,7) OutPutData.BaselineSleep.pfc_low.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeLow(d),'--m')
Data_to_use = squeeze(OutPutData.BaselineSleep.pfc_low.mean(:,7,:))./max([OutPutData.BaselineSleep.pfc_low.power(:,6) OutPutData.BaselineSleep.pfc_low.power(:,7) OutPutData.BaselineSleep.pfc_low.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr:end)); vline(RangeLow(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.pfc_low.mean(:,8,:))./max([OutPutData.BaselineSleep.pfc_low.power(:,6) OutPutData.BaselineSleep.pfc_low.power(:,7) OutPutData.BaselineSleep.pfc_low.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--k')
makepretty; xlabel('Frequency (Hz)'); xlim([0 10]); ylim([0 1])
title('Low PFC')

subplot(355); thr= 30;
Data_to_use = squeeze(OutPutData.BaselineSleep.h_vhigh.mean(:,6,:))./max([OutPutData.BaselineSleep.h_vhigh.power(:,6) OutPutData.BaselineSleep.h_vhigh.power(:,7) OutPutData.BaselineSleep.h_vhigh.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeVHigh(d),'--m')
Data_to_use = squeeze(OutPutData.BaselineSleep.h_vhigh.mean(:,7,:))./max([OutPutData.BaselineSleep.h_vhigh.power(:,6) OutPutData.BaselineSleep.h_vhigh.power(:,7) OutPutData.BaselineSleep.h_vhigh.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr:end)); vline(RangeVHigh(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.h_vhigh.mean(:,8,:))./max([OutPutData.BaselineSleep.h_vhigh.power(:,6) OutPutData.BaselineSleep.h_vhigh.power(:,7) OutPutData.BaselineSleep.h_vhigh.power(:,8)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeVHigh(d+thr-1),'--k')
makepretty; xlabel('Frequency (Hz)'); xlim([120 250]); ylim([0 1]);
title('VHigh on ripples Epoch')


%% 2) Plot data paired MakeSpreadAndBoxPlot2_SB
OutPutData.BaselineSleep.ob_low.max_freq(7,[7 8])=[2.975 3.204]; OutPutData.BaselineSleep.ob_low.power(7,[7 8])=[1.282e5 1.817e5];
subplot(3,10,11)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.ob_low.max_freq(:,6:8),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency'); ylim([2 5])
subplot(3,10,12)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.ob_low.power(:,6:8)),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power'); ylim([5.1 6.1])

subplot(3,10,13)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.ob_middle.max_freq(:,6:8),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency'); ylim([25 35])
subplot(3,10,14)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.ob_middle.power(:,6:8)),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

OutPutData.BaselineSleep.hpc_low.max_freq(:,6)=[6.561 6.104 5.493 6.561 6.18 6.027 5.569 6.485 6.638]; OutPutData.BaselineSleep.pfc_low.power(:,6)=[2.223e4 6.679e4 4.127e4 3.296e4 1.879e4 1.17e5 6.665e4 2.323e4 2.974e4];
OutPutData.BaselineSleep.hpc_low.max_freq(:,7)=[1.221 1.526 1.221 1.45 1.221 1.297 1.373 NaN 1.221]; OutPutData.BaselineSleep.pfc_low.power(:,7)=[5.813e4 1.88e5 1.11e5 7.597e4 8.096e4 2.644e5 1.41e5 NaN 7.745e4];
OutPutData.BaselineSleep.hpc_low.max_freq(:,8)=[1.297 1.373 NaN 1.526 1.297 1.297 1.297 0.9918 1.297]; OutPutData.BaselineSleep.pfc_low.power(:,8)=[7.18e4 2.242e5 NaN 9.103e4 1.065e5 3.7e5 1.81e5 1e5 1.065e5];
subplot(3,10,15)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.hpc_low.max_freq(:,6:8),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,16)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.hpc_low.power(:,6:8)),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

OutPutData.BaselineSleep.pfc_low.max_freq(:,6)=[2.975 2.441 1.45 NaN 2.899 2.594 2.06 1.755 2.899]; OutPutData.BaselineSleep.pfc_low.power(:,6)=[2.662e4 3.5e4 2.459e4 NaN 2.79e4 2.095e4 5.063e4 3.137e4 1.63e4];
subplot(3,10,17)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.pfc_low.max_freq(:,6:8),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,18)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.pfc_low.power(:,6:8)),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

OutPutData.BaselineSleep.h_vhigh.max_freq(OutPutData.BaselineSleep.h_vhigh.max_freq==0)=NaN; OutPutData.BaselineSleep.h_vhigh.power(OutPutData.BaselineSleep.h_vhigh.power==0)=NaN; 
subplot(3,10,19)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.h_vhigh.max_freq(:,6:8),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,20)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.h_vhigh.power(:,6:8)),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

%% 3) Funny things
% OB mean waveform
subplot(3,5,11)
Data_to_use = squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,6,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use); max_Respi = max([max(nanmean(squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,6,:)))) max(nanmean(squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,7,:)))) max(nanmean(squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,8,:))))]);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-m',1); hold on;
Data_to_use = squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,7,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-r',1); hold on;
Data_to_use = squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,8,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-k',1); hold on;
makepretty; ylabel('Amplitude (a.u.)'); xlabel('time (ms)'); xlim([0 751]); ylim([-.7 1.2])
xticks([0 376 751]); xticklabels({'-300','0','+300'})
title('Mean OB waveform')

% Phase Pref
for mouse=1:length(Mouse)
    PhasePref_N1(mouse,:,:) = OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 6}'./max([max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 6}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 7}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 8}(:,21:end))]);
    PhasePref_N2(mouse,:,:) = OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 7}'./max([max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 6}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 7}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 8}(:,21:end))]);
    PhasePref_N3(mouse,:,:) = OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 8}'./max([max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 6}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 7}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 8}(:,21:end))]);
end

PhasePref_N1_Averaged = squeeze(nanmean(PhasePref_N1));
PhasePref_N2_Averaged = squeeze(nanmean(PhasePref_N2));
PhasePref_N3_Averaged = squeeze(nanmean(PhasePref_N3));

subplot(3,15,34)
imagesc(OutPutData.BaselineSleep.phase_pref.BinnedPhase , OutPutData.BaselineSleep.phase_pref.Frequency , PhasePref_N1_Averaged);
axis xy; caxis([0 1.1]); ylim([20 100])
makepretty; ylabel('Frequency (Hz)');
title('N1'); xlabel('Phase (°)')
subplot(3,15,35)
imagesc(OutPutData.BaselineSleep.phase_pref.BinnedPhase , OutPutData.BaselineSleep.phase_pref.Frequency , PhasePref_N2_Averaged);
axis xy; caxis([0 1.1]); ylim([20 100])
makepretty;  
title('N2'); xlabel('Phase (°)')
subplot(3,15,36)
imagesc(OutPutData.BaselineSleep.phase_pref.BinnedPhase , OutPutData.BaselineSleep.phase_pref.Frequency , PhasePref_N3_Averaged);
axis xy; caxis([0 1.1]); ylim([20 100])
makepretty;  
title('N3'); xlabel('Phase (°)')
u=text(-300,115,'Gamma preference'); set(u,'FontSize',20,'FontWeight','bold');
colormap jet

% HPC around ripples
subplot(3,5,13)

cd('/media/nas4/ProjetEmbReact/Mouse750/20180702/ProjectEmbReact_M750_20180702_BaselineSleep')
load('Ripples.mat')
load('behavResources_SB.mat')
load('SleepSubstages.mat')

AroundRipples = intervalSet(Start(RipplesEpoch)-.3e4 , Stop(RipplesEpoch)+.3e4);

% LowSpectrumSB([cd filesep],2,'H_deep')
load('H_deep_Low_Spectrum.mat')

HPC_Low_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
HPC_Low_AroundRipples_N1 = Restrict(HPC_Low_tsd , and(Epoch{1} , AroundRipples));
HPC_Low_AroundRipples_N2 = Restrict(HPC_Low_tsd , and(Epoch{2} , AroundRipples));
HPC_Low_AroundRipples_N3 = Restrict(HPC_Low_tsd , and(Epoch{3} , AroundRipples));

plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_N1)) , 'm' , 'LineWidth' , 2)
hold on
plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_N2)) , 'r' , 'LineWidth' , 2)
plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_N3)) , 'k' , 'LineWidth' , 2)
makepretty;
title('HPC Low around ripples'); ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')

cd('/media/nas4/ProjetEmbReact/Mouse750/20180702/ProjectEmbReact_M750_20180702_BaselineSleep')
load('IdFigureData2.mat', 'ripples_curves')
axes('Position',[.53 .24 .05 .07]); box on
plot(ripples_curves{1, 1}(:,2),'k')
hold on
plot(ripples_curves{1, 2}(:,2),'g')
xlim([200 801]); ylim([-3.5e3 3e3]); makepretty

% OB-PFC coherence
subplot(3,5,14); thr=1;
cd('/media/nas6/ProjetEmbReact/transfer')
f = linspace(0,20,size(OutPutData.BaselineSleep.ob_pfc_coherence.mean,3));
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_pfc_coherence.mean(:,6,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-m',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--m')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_pfc_coherence.mean(:,7,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_pfc_coherence.mean(:,8,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--k')
makepretty; xlim([0 10]); ylim([.32 .8])
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')
title('OB-PFC coherence')

% Ripples
subplot(3,5,15)
OutPutData.BaselineSleep.sleep_ripples.mean(OutPutData.BaselineSleep.sleep_ripples.mean==0)=NaN;
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.sleep_ripples.mean(:,6:8),Cols1,X1,Legends1,'showpoints',0,'paired',1);
ylabel('Density (#/s)'); title('Ripples density')

    
a=suptitle('Brain characterization, BaselineSleep, NREM features n=9'); a.FontSize=30;








