
cd('/media/nas4/ProjetEmbReact/VideosOthman')

Cols2 = {[0 0 1],[1, 0, 0],[0 1 0],[1, 0.8, 0.8],[1, 0.4, 0.4],[0.8, 0, 0]};
X2 = [1,2,3,4,5,6];
Legends2 = {'Wake','NREM','REM','N1','N2','N3'};
NoLegends2 = {'','','','','',''};

Cols2 = {[0 0 1],[1, 0, 0],[0 1 0]};
X2 = [1,2,3];
Legends2 = {'Wake','NREM','REM'};

Cols3 = {[1, 0, 0],[0 1 0]};
X3 = [1,2];
Legends3 = {'NREM','REM'};

Cols4 = {[0 0 1],[0 1 0]};
X4 = [1,2];
Legends4 = {'Wake','REM'};


%% 1) Plot mean spectrum
figure
subplot(351); thr=20;
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_low.mean(:,2,:))./max([OutPutData.BaselineSleep.ob_low.power(:,2) OutPutData.BaselineSleep.ob_low.power(:,4) OutPutData.BaselineSleep.ob_low.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeLow(d),'--b')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_low.mean(:,4,:))./max([OutPutData.BaselineSleep.ob_low.power(:,2) OutPutData.BaselineSleep.ob_low.power(:,4) OutPutData.BaselineSleep.ob_low.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_low.mean(:,5,:))./max([OutPutData.BaselineSleep.ob_low.power(:,2) OutPutData.BaselineSleep.ob_low.power(:,4) OutPutData.BaselineSleep.ob_low.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--g')
f=get(gca,'Children'); a=legend([f(12),f(8),f(4)],'Wake','NREM','REM');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
title('Low OB')

subplot(352); thr=21;
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_middle.mean(:,2,:))./max([OutPutData.BaselineSleep.ob_middle.power(:,2) OutPutData.BaselineSleep.ob_middle.power(:,4) OutPutData.BaselineSleep.ob_middle.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeMiddle(d),'--b')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_middle.mean(:,4,:))./max([OutPutData.BaselineSleep.ob_middle.power(:,2) OutPutData.BaselineSleep.ob_middle.power(:,4) OutPutData.BaselineSleep.ob_middle.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeMiddle(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_middle.mean(:,5,:))./max([OutPutData.BaselineSleep.ob_middle.power(:,2) OutPutData.BaselineSleep.ob_middle.power(:,4) OutPutData.BaselineSleep.ob_middle.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeMiddle , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeMiddle(d+thr-1),'--g')
makepretty; xlabel('Frequency (Hz)'); xlim([20 100]); ylim([0 1.2])
title('High OB')

OutPutData.BaselineSleep.hpc_low.mean(8,2,:)=NaN;
subplot(353); thr= 25;
Data_to_use = squeeze(OutPutData.BaselineSleep.hpc_low.mean(:,2,:))./max([OutPutData.BaselineSleep.hpc_low.power(:,2) OutPutData.BaselineSleep.hpc_low.power(:,4) OutPutData.BaselineSleep.hpc_low.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeLow(d),'--b')
Data_to_use = squeeze(OutPutData.BaselineSleep.hpc_low.mean(:,4,:))./max([OutPutData.BaselineSleep.hpc_low.power(:,2) OutPutData.BaselineSleep.hpc_low.power(:,4) OutPutData.BaselineSleep.hpc_low.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.hpc_low.mean(:,5,:))./max([OutPutData.BaselineSleep.hpc_low.power(:,2) OutPutData.BaselineSleep.hpc_low.power(:,4) OutPutData.BaselineSleep.hpc_low.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--g')
makepretty; xlabel('Frequency (Hz)'); xlim([0 15]); ylim([0 1.1])
title('Low HPC')

subplot(354); thr= 5;
Data_to_use = squeeze(OutPutData.BaselineSleep.pfc_low.mean(:,2,:))./max([OutPutData.BaselineSleep.pfc_low.power(:,2) OutPutData.BaselineSleep.pfc_low.power(:,4) OutPutData.BaselineSleep.pfc_low.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeLow(d),'--b')
Data_to_use = squeeze(OutPutData.BaselineSleep.pfc_low.mean(:,4,:))./max([OutPutData.BaselineSleep.pfc_low.power(:,2) OutPutData.BaselineSleep.pfc_low.power(:,4) OutPutData.BaselineSleep.pfc_low.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr:end)); vline(RangeLow(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.pfc_low.mean(:,5,:))./max([OutPutData.BaselineSleep.pfc_low.power(:,2) OutPutData.BaselineSleep.pfc_low.power(:,4) OutPutData.BaselineSleep.pfc_low.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeLow(d+thr-1),'--g')
makepretty; xlabel('Frequency (Hz)'); xlim([0 10]); ylim([0 1])
title('Low PFC')

subplot(355); thr= 30;
Data_to_use = squeeze(OutPutData.BaselineSleep.h_vhigh.mean(:,2,:))./max([OutPutData.BaselineSleep.h_vhigh.power(:,2) OutPutData.BaselineSleep.h_vhigh.power(:,4) OutPutData.BaselineSleep.h_vhigh.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp); vline(RangeVHigh(d),'--b')
Data_to_use = squeeze(OutPutData.BaselineSleep.h_vhigh.mean(:,4,:))./max([OutPutData.BaselineSleep.h_vhigh.power(:,2) OutPutData.BaselineSleep.h_vhigh.power(:,4) OutPutData.BaselineSleep.h_vhigh.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr:end)); vline(RangeVHigh(d+thr-1),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.h_vhigh.mean(:,5,:))./max([OutPutData.BaselineSleep.h_vhigh.power(:,2) OutPutData.BaselineSleep.h_vhigh.power(:,4) OutPutData.BaselineSleep.h_vhigh.power(:,5)]')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeVHigh , Mean_All_Sp,Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr:end)); vline(RangeVHigh(d+thr-1),'--g')
makepretty; xlabel('Frequency (Hz)'); xlim([70 250]); ylim([0 1]);
title('VHigh on ripples epoch')


%% 2) Plot data paired MakeSpreadAndBoxPlot2_SB
OutPutData.BaselineSleep.ob_low.max_freq(7,4)=3.052; OutPutData.BaselineSleep.ob_low.power(7,4)=1.482e5;
subplot(3,10,11)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.ob_low.max_freq(:,[4 5]),Cols3,X3,Legends3,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency'); ylim([2 5])
subplot(3,10,12)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.ob_low.power(:,[4 5])),Cols3,X2,Legends3,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power'); ylim([4.7 5.8])

OutPutData.BaselineSleep.ob_middle.max_freq(8,2)=NaN; OutPutData.BaselineSleep.ob_middle.power(8,2)=NaN;
subplot(3,10,13)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.ob_middle.max_freq(:,[2 5]),Cols4,X4,Legends4,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,14)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.ob_middle.power(:,[2 5])),Cols4,X4,Legends4,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

OutPutData.BaselineSleep.hpc_low.max_freq([5 8],2)=[7.324 NaN]; OutPutData.BaselineSleep.hpc_low.power([5 8],2)=[1.212e4 NaN];
subplot(3,10,15)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.hpc_low.max_freq(:,[2 5]),Cols4,X4,Legends4,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,16)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.hpc_low.power(:,[2 5])),Cols4,X4,Legends4,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

OutPutData.BaselineSleep.pfc_low.max_freq(:,5)=[7.324 6.943 6.561 7.248 7.095 7.019 6.943 7.019 7.401]; OutPutData.BaselineSleep.pfc_low.power(:,5)=[1.09e4 7560 7450 9218 7831 8736 8746 9143 1.49e4];
subplot(3,10,17)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.pfc_low.max_freq(:,[4 5]),Cols3,X3,Legends3,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,18)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.pfc_low.power(:,[4 5])),Cols3,X3,Legends3,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

OutPutData.BaselineSleep.h_vhigh.max_freq(OutPutData.BaselineSleep.h_vhigh.max_freq==0)=NaN; OutPutData.BaselineSleep.h_vhigh.power(OutPutData.BaselineSleep.h_vhigh.power==0)=NaN; 
OutPutData.BaselineSleep.h_vhigh.max_freq(3,2)=163.6; OutPutData.BaselineSleep.h_vhigh.power(3,2)=467.3; 
subplot(3,10,19)
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.h_vhigh.max_freq(:,[2 4 5]),Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Frequency')
subplot(3,10,20)
MakeSpreadAndBoxPlot2_SB(log10(OutPutData.BaselineSleep.h_vhigh.power(:,[2 4 5])),Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('Power (a.u.)'); title('Power')

%% 3) Funny things
% OB mean waveform
subplot(3,5,11)
Data_to_use = squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,2,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use); max_Respi = max([max(nanmean(squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,2,:)))) max(nanmean(squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,4,:)))) max(nanmean(squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,5,:))))]);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-b',1); hold on;
Data_to_use = squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,4,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-r',1); hold on;
Data_to_use = squeeze(OutPutData.BaselineSleep.respi_meanwaveform(:,5,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:751] , Mean_All_Sp/max_Respi,Conf_Inter/max_Respi,'-g',1); hold on;
makepretty; ylabel('Amplitude (a.u.)'); xlabel('time (ms)'); xlim([0 751]); ylim([-1.1 1.2])
xticks([0 376 751]); xticklabels({'-300','0','+300'})
title('Mean OB waveform')

% Phase Pref
for mouse=1:length(Mouse)
    PhasePref_Wake(mouse,:,:) = OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 2}'./max([max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 2}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 4}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 5}(:,21:end))]);
    PhasePref_NREM(mouse,:,:) = OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 4}'./max([max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 2}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 4}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 5}(:,21:end))]);
    PhasePref_REM(mouse,:,:) = OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 5}'./max([max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 2}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 4}(:,21:end)) max(OutPutData.BaselineSleep.phase_pref.PhasePref{mouse, 5}(:,21:end))]);
end

PhasePref_Wake_Averaged = squeeze(nanmean(PhasePref_Wake));
PhasePref_NREM_Averaged = squeeze(nanmean(PhasePref_NREM));
PhasePref_REM_Averaged = squeeze(nanmean(PhasePref_REM));

subplot(3,15,34)
imagesc(OutPutData.BaselineSleep.phase_pref.BinnedPhase , OutPutData.BaselineSleep.phase_pref.Frequency , PhasePref_Wake_Averaged);
axis xy; caxis([0 0.8]); ylim([20 100])
makepretty; ylabel('Frequency (Hz)');
title('Wake'); xlabel('Phase (°)')
subplot(3,15,35)
imagesc(OutPutData.BaselineSleep.phase_pref.BinnedPhase , OutPutData.BaselineSleep.phase_pref.Frequency , PhasePref_NREM_Averaged);
axis xy; caxis([0 0.8]); ylim([20 100])
makepretty;  
title('NREM'); xlabel('Phase (°)')
subplot(3,15,36)
imagesc(OutPutData.BaselineSleep.phase_pref.BinnedPhase , OutPutData.BaselineSleep.phase_pref.Frequency , PhasePref_REM_Averaged);
axis xy; caxis([0 0.8]); ylim([20 100])
makepretty;  
title('REM'); xlabel('Phase (°)')
u=text(-300,115,'Gamma preference'); set(u,'FontSize',20,'FontWeight','bold');
colormap jet

% HPC around ripples
subplot(3,5,13)

cd('/media/nas4/ProjetEmbReact/Mouse750/20180702/ProjectEmbReact_M750_20180702_BaselineSleep')
load('Ripples.mat')
load('behavResources_SB.mat')
load('SleepScoring_OBGamma.mat')

AroundRipples = intervalSet(Start(RipplesEpoch)-.3e4 , Stop(RipplesEpoch)+.3e4);

% LowSpectrumSB([cd filesep],2,'H_deep')
load('H_deep_Low_Spectrum.mat')

HPC_Low_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
HPC_Low_AroundRipples_Wake = Restrict(HPC_Low_tsd , and(Wake , AroundRipples));
HPC_Low_AroundRipples_NREM = Restrict(HPC_Low_tsd , and(SWSEpoch , AroundRipples));
HPC_Low_AroundRipples_REM = Restrict(HPC_Low_tsd , and(REMEpoch , AroundRipples));

plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_Wake)) , 'b' , 'LineWidth' , 2)
hold on
plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_NREM)) , 'r' , 'LineWidth' , 2)
plot(RangeLow , nanmean(Data(HPC_Low_AroundRipples_REM)) , 'g' , 'LineWidth' , 2)
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
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_pfc_coherence.mean(:,2,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--b')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_pfc_coherence.mean(:,4,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--r')
Data_to_use = squeeze(OutPutData.BaselineSleep.ob_pfc_coherence.mean(:,5,:));
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(f , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end)); vline(f(d+thr),'--g')
makepretty; xlim([0 10]); ylim([.4 .82])
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')
title('OB-PFC coherence')


% Ripples
subplot(3,5,15)
OutPutData.BaselineSleep.sleep_ripples.mean(OutPutData.BaselineSleep.sleep_ripples.mean==0)=NaN;
MakeSpreadAndBoxPlot2_SB(OutPutData.BaselineSleep.sleep_ripples.mean(:,[2 4 5]),Cols2,X2,Legends2,'showpoints',0,'paired',1);
ylabel('Density (#/s)'); title('Ripples density')

    
a=suptitle('Brain characterization, BaselineSleep, n=9'); a.FontSize=30;





