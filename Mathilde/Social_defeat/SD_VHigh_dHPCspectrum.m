%% input dir
%%baseline
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);

Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');

DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);

DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);

%%social defeat
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');


%% BASELINE
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
%     a{i} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
    if exist('dHPC_VHigh_Spectrum.mat')==2
        Vhigh_mean_spectro_basal{i} = load('dHPC_VHigh_mean_spectrum.mat');
    else
    end
end

for i=1:length(DirMyBasal.path)
    if isempty(Vhigh_mean_spectro_basal{i})==0
        sp_basal_WAKE_mean(i,:)=nanmean(10*(Vhigh_mean_spectro_basal{i}.dHPC_V_High_mean_spectrum_wake),1);
        sp_basal_SWS_mean(i,:)=nanmean(10*(Vhigh_mean_spectro_basal{i}.dHPC_V_High_mean_spectrum_sws),1);
        sp_basal_REM_mean(i,:)=nanmean(10*(Vhigh_mean_spectro_basal{i}.dHPC_V_High_mean_spectrum_rem),1);
    else
    end
end

sp_basal_WAKE_mean(sp_basal_WAKE_mean==0)=NaN;
sp_basal_SWS_mean(sp_basal_SWS_mean==0)=NaN;
sp_basal_REM_mean(sp_basal_REM_mean==0)=NaN;



%%SOCIAL DEFEAT
for j=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{j}{1});
    b{j} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
    if exist('dHPC_VHigh_Spectrum.mat')==2
        Vhigh_mean_spectro_SD{j} = load('dHPC_VHigh_mean_spectrum.mat');
    else
    end
end

for j=1:length(DirSocialDefeat.path)
    if isempty(Vhigh_mean_spectro_SD{j})==0
        sp_SD_WAKE_mean(j,:)=nanmean(10*(Vhigh_mean_spectro_SD{j}.dHPC_V_High_mean_spectrum_wake),1);
        sp_SD_SWS_mean(j,:)=nanmean(10*(Vhigh_mean_spectro_SD{j}.dHPC_V_High_mean_spectrum_sws),1);
        sp_SD_REM_mean(j,:)=nanmean(10*(Vhigh_mean_spectro_SD{j}.dHPC_V_High_mean_spectrum_rem),1);
    else
    end
end

sp_SD_WAKE_mean(sp_SD_WAKE_mean==0)=NaN;
sp_SD_SWS_mean(sp_SD_SWS_mean==0)=NaN;
sp_SD_REM_mean(sp_SD_REM_mean==0)=NaN;

%%
figure
ax(1) = subplot(131)
hold on
shadedErrorBar(Vhigh_mean_spectro_basal{j}.frequence, nanmean(sp_basal_WAKE_mean).*Vhigh_mean_spectro_basal{j}.frequence, stdError(sp_basal_WAKE_mean).*Vhigh_mean_spectro_basal{j}.frequence,'k',1)
shadedErrorBar(Vhigh_mean_spectro_SD{j}.frequence, nanmean(sp_SD_WAKE_mean).*Vhigh_mean_spectro_SD{j}.frequence, stdError(sp_SD_WAKE_mean).*Vhigh_mean_spectro_SD{j}.frequence,'r',1)
ylabel('Power (a.u)')
xlabel('Frequency (Hz)')
makepretty
title('Wake')

ax(2) = subplot(132)
hold on
shadedErrorBar(Vhigh_mean_spectro_basal{j}.frequence, nanmean(sp_basal_SWS_mean).*Vhigh_mean_spectro_basal{j}.frequence, stdError(sp_basal_SWS_mean).*Vhigh_mean_spectro_basal{j}.frequence,'k',1)
shadedErrorBar(Vhigh_mean_spectro_SD{j}.frequence, nanmean(sp_SD_SWS_mean).*Vhigh_mean_spectro_SD{j}.frequence, stdError(sp_SD_SWS_mean).*Vhigh_mean_spectro_SD{j}.frequence,'r',1)
xlabel('Frequency (Hz)')
makepretty
title('NREM')

ax(3) = subplot(133)
hold on
shadedErrorBar(Vhigh_mean_spectro_basal{j}.frequence, nanmean(sp_basal_REM_mean).*Vhigh_mean_spectro_basal{j}.frequence, stdError(sp_basal_REM_mean).*Vhigh_mean_spectro_basal{j}.frequence,'k',1)
shadedErrorBar(Vhigh_mean_spectro_SD{j}.frequence, nanmean(sp_SD_REM_mean).*Vhigh_mean_spectro_SD{j}.frequence, stdError(sp_SD_REM_mean).*Vhigh_mean_spectro_SD{j}.frequence,'r',1)
xlabel('Frequency (Hz)')
makepretty
title('REM')

% set(ax,'ylim',[0 10e5],'xlim',[0 300])


%%
figure
hold on
shadedErrorBar(Vhigh_mean_spectro_basal{j}.frequence, log10(nanmean(sp_basal_WAKE_mean)), stdError(sp_basal_WAKE_mean),'k',1)
shadedErrorBar(Vhigh_mean_spectro_SD{j}.frequence, log10(nanmean(sp_SD_WAKE_mean)), stdError(sp_SD_WAKE_mean),'r',1)



