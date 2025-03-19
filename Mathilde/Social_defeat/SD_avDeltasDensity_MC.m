%% input dir : social defeat
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1107 1149]);

% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');

% %%%%dir baseline sleep
% DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
% DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
% DirBasal_dreadd = PathForExperiments_DREADD_MC('BaselineSleep');
% 
% DirMyBasal1 = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
% DirMyBasal = MergePathForExperiment(DirMyBasal1,DirBasal_dreadd);
% 
% DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% 
% DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);


%%
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);

Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');

DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);
%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get the data
%%baseline sleep
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_basal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    %3h post SD (first 3h of recording)
    epoch_3hPostSD_Basal{i}=intervalSet(0*3600*1E4,3*3600*1E4);
    % end of the 3h post SD up to the end of the session
    epoch_endPostSD_Basal{i}=intervalSet(End(epoch_3hPostSD_Basal{i}),durtotal_basal{i});
    
    %%load deltas
    if exist('DeltaWaves.mat')
        delt_basal{i} = load('DeltaWaves.mat','alldeltas_PFCx');
        %get deltas density
        [Deltas_tsd] = GetDeltasDensityTSD_MC(delt_basal{i}.alldeltas_PFCx);
        DeltDensity_basal{i} = Deltas_tsd; %store it for all mice
                deltDensitySWS_basal{i} = Restrict(DeltDensity_basal{i}, a{i}.SWSEpoch);
        deltDensityWake_basal{i} = Restrict(DeltDensity_basal{i}, a{i}.Wake);
        deltDensityREM_basal{i} = Restrict(DeltDensity_basal{i}, a{i}.REMEpoch);
        
        %deltas within '3h post SD'
        deltDensitySWS_3hPostSD_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.SWSEpoch, epoch_3hPostSD_Basal{i}));
        deltDensityWake_3hPostSD_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.Wake, epoch_3hPostSD_Basal{i}));
        deltDensityREM_3hPostSD_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.REMEpoch, epoch_3hPostSD_Basal{i}));
        %deltas for the rest of the recording
        deltDensitySWS_3hPostSDend_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.SWSEpoch, epoch_endPostSD_Basal{i}));
        deltDensityWake_3hPostSDend_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.Wake, epoch_endPostSD_Basal{i}));
        deltDensityREM_3hPostSDend_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.REMEpoch, epoch_endPostSD_Basal{i}));
    else
    end
end
%%
% get data sleep post SD
for j=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{j}{1});
    b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_SD{j} = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
    %3h post SD (first 3h of recording)
    epoch_3hPostSD_SD{j}=intervalSet(0*3600*1E4,3*3600*1E4);
    % end of the 3h post SD up to the end of the session
    epoch_endPostSD_SD{j}=intervalSet(End(epoch_3hPostSD_SD{j}),durtotal_SD{j});
    
    %%load deltas
    if exist('DeltaWaves.mat')
        delt_SD{j} = load('DeltaWaves.mat','alldeltas_PFCx');
        %%get deltas density
        [Deltas_tsd] = GetDeltasDensityTSD_MC(delt_SD{j}.alldeltas_PFCx);
        DeltDensity_SD{j} = Deltas_tsd;
                deltDensitySWS_SD{j} = Restrict(DeltDensity_SD{j}, b{j}.SWSEpoch);
        deltDensityWake_SD{j} = Restrict(DeltDensity_SD{j}, b{j}.Wake);
        deltDensityREM_SD{j} = Restrict(DeltDensity_SD{j}, b{j}.REMEpoch);
        
        %deltas within 3h post SD
        deltDensitySWS_3hPostSD_SD{j} = Restrict(DeltDensity_SD{j}, and(b{j}.SWSEpoch, epoch_3hPostSD_SD{j}));
        deltDensityWake_3hPostSD_SD{j} = Restrict(DeltDensity_SD{j}, and(b{j}.Wake, epoch_3hPostSD_SD{j}));
        deltDensityREM_3hPostSD_SD{j} = Restrict(DeltDensity_SD{j}, and(b{j}.REMEpoch, epoch_3hPostSD_SD{j}));
        %deltas for the rest of the recording
        deltDensitySWS_3hPostSDend_SD{j} = Restrict(DeltDensity_SD{j}, and(b{j}.SWSEpoch, epoch_endPostSD_SD{j}));
        deltDensityWake_3hPostSDend_SD{j} = Restrict(DeltDensity_SD{j}, and(b{j}.Wake, epoch_endPostSD_SD{j}));
        deltDensityREM_3hPostSDend_SD{j} = Restrict(DeltDensity_SD{j}, and(b{j}.REMEpoch, epoch_endPostSD_SD{j}));
    else
    end
end

%% calculate mean
%%baseline sleep
for ii=1:length(deltDensitySWS_3hPostSD_basal)
    avDeltDensitySWS_basal(ii,:)=nanmean(Data(deltDensitySWS_basal{ii}(:,:)),1);
    avDeltDensityWake_basal(ii,:)=nanmean(Data(deltDensityWake_basal{ii}(:,:)),1);
    avDeltDensityREM_basal(ii,:)=nanmean(Data(deltDensityREM_basal{ii}(:,:)),1);
    
    %'3h following SD'
    avDeltDensitySWS_3hPostSD_basal(ii,:)=nanmean(Data(deltDensitySWS_3hPostSD_basal{ii}(:,:)),1);
    avDeltDensityWake_3hPostSD_basal(ii,:)=nanmean(Data(deltDensityWake_3hPostSD_basal{ii}(:,:)),1);
    avDeltDensityREM_3hPostSD_basal(ii,:)=nanmean(Data(deltDensityREM_3hPostSD_basal{ii}(:,:)),1);
    %end of the 3h up to the end of the recording
    avDeltDensitySWS_3hPostSDend_basal(ii,:)=nanmean(Data(deltDensitySWS_3hPostSDend_basal{ii}(:,:)),1);
    avDeltDensityWake_3hPostSDend_basal(ii,:)=nanmean(Data(deltDensityWake_3hPostSDend_basal{ii}(:,:)),1);
    avDeltDensityREM_3hPostSDend_basal(ii,:)=nanmean(Data(deltDensityREM_3hPostSDend_basal{ii}(:,:)),1);
end
%sleep post SD
for jj=1:length(deltDensitySWS_3hPostSD_SD)
    avDeltDensitySWS_SD(jj,:)=nanmean(Data(deltDensitySWS_SD{jj}(:,:)),1);
    avDeltDensityWake_SD(jj,:)=nanmean(Data(deltDensityWake_SD{jj}(:,:)),1);
    avDeltDensityREM_SD(jj,:)=nanmean(Data(deltDensityREM_SD{jj}(:,:)),1);
    
    %3h following SD
    avDeltDensitySWS_3hPostSD_SD(jj,:)=nanmean(Data(deltDensitySWS_3hPostSD_SD{jj}(:,:)),1);
    avDeltDensityWake_3hPostSD_SD(jj,:)=nanmean(Data(deltDensityWake_3hPostSD_SD{jj}(:,:)),1);
    avDeltDensityREM_3hPostSD_SD(jj,:)=nanmean(Data(deltDensityREM_3hPostSD_SD{jj}(:,:)),1);
    %end of the 3h up to the end of the recording
    avDeltDensitySWS_3hPostSDend_SD(jj,:)=nanmean(Data(deltDensitySWS_3hPostSDend_SD{jj}(:,:)),1);
    avDeltDensityWake_3hPostSDend_SD(jj,:)=nanmean(Data(deltDensityWake_3hPostSDend_SD{jj}(:,:)),1);
    avDeltDensityREM_3hPostSDend_SD(jj,:)=nanmean(Data(deltDensityREM_3hPostSDend_SD{jj}(:,:)),1);
end

%% figure : deltas density (bars)
figure,
ax(1)=subplot(321),PlotErrorBarN_KJ({avDeltDensityWake_basal,avDeltDensityWake_SD},'newfig',0,'paired',0);
ylabel('Deltas/s')
xticks([1:2]); xticklabels({'Baseline','post SD'});
title('WAKE')
makepretty
ax(2)=subplot(323),PlotErrorBarN_KJ({avDeltDensitySWS_basal,avDeltDensitySWS_SD},'newfig',0,'paired',0);
ylabel('Deltas/s')
xticks([1:2]); xticklabels({'Baseline','post SD'});
title('NREM')
makepretty
ax(3)=subplot(325),PlotErrorBarN_KJ({avDeltDensityREM_basal,avDeltDensityREM_SD},'newfig',0,'paired',0);
ylabel('Deltas/s')
xticks([1:2]); xticklabels({'Baseline','post SD'}); xtickangle(45)
title('REM')
makepretty


ax(1)=subplot(322),PlotErrorBarN_KJ({avDeltDensityWake_3hPostSD_basal,avDeltDensityWake_3hPostSD_SD},'newfig',0,'paired',0);
ylabel('Deltas/s')
xticks([1:2]); xticklabels({'Baseline','3h post SD'});
title('WAKE')
makepretty
ax(2)=subplot(324),PlotErrorBarN_KJ({avDeltDensitySWS_3hPostSD_basal,avDeltDensitySWS_3hPostSD_SD},'newfig',0,'paired',0);
ylabel('Deltas/s')
xticks([1:2]); xticklabels({'Baseline','3h post SD'});
title('NREM')
makepretty
ax(3)=subplot(326),PlotErrorBarN_KJ({avDeltDensityREM_3hPostSD_basal,avDeltDensityREM_3hPostSD_SD},'newfig',0,'paired',0);
ylabel('Deltas/s')
xticks([1:2]); xticklabels({'Baseline','3h post SD'}); xtickangle(45)
title('REM')
makepretty

set(ax,'ylim',[0 2])




% figure,
% ax(1)=subplot(131),PlotErrorBarN_KJ({avDeltDensityWake_3hPostSD_basal,avDeltDensityWake_3hPostSD_SD,avDeltDensityWake_3hPostSDend_basal,avDeltDensityWake_3hPostSDend_SD},'newfig',0,'paired',0);
% ylabel('Deltas/s')
% xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% title('WAKE')
% makepretty
% ax(2)=subplot(132),PlotErrorBarN_KJ({avDeltDensitySWS_3hPostSD_basal,avDeltDensitySWS_3hPostSD_SD,avDeltDensitySWS_3hPostSDend_basal,avDeltDensitySWS_3hPostSDend_SD},'newfig',0,'paired',0);
% ylabel('Deltas/s')
% xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% title('NREM')
% makepretty
% ax(3)=subplot(133),PlotErrorBarN_KJ({avDeltDensityREM_3hPostSD_basal,avDeltDensityREM_3hPostSD_SD,avDeltDensityREM_3hPostSDend_basal,avDeltDensityREM_3hPostSDend_SD},'newfig',0,'paired',0);
% ylabel('Deltas/s')
% xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% title('REM')
% makepretty
% 
% set(ax,'ylim',[0 1.5])



%% figure : deltas density overtime
figure
%%deltas density overtime (baseline)
for i=1:length(DirMyBasal.path)
    VecTimeDay_WAKE_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_basal{i},a{i}.Wake)), 0);
    VecTimeDay_SWS_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_basal{i},a{i}.SWSEpoch)), 0);
    VecTimeDay_REM_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_basal{i},a{i}.REMEpoch)), 0);
    
    subplot(3,5,[1,2]),
    plot(VecTimeDay_WAKE_basal{i}, runmean(Data(Restrict(DeltDensity_basal{i},a{i}.Wake)),70),'.','MarkerSize',0.2), hold on
    ylabel('Deltas/s')
    ylim([0 1.8])
    xlim([9 20])
    title('WAKE (baseline)')
%     makepretty
    subplot(3,5,[6,7]),
    plot(VecTimeDay_SWS_basal{i}, runmean(Data(Restrict(DeltDensity_basal{i},a{i}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
    ylabel('Deltas/s')
    title('NREM (baseline)')
    ylim([0 1.8])
    xlim([9 20])
%     makepretty
    subplot(3,5,[11,12]),
    plot(VecTimeDay_REM_basal{i}, runmean(Data(Restrict(DeltDensity_basal{i},a{i}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
    ylabel('Deltas/s')
    title('REM (baseline)')
    ylim([0 1.8])
    xlim([9 20])
    xlabel('Time (hours)')
%     makepretty
    % legend({'m1196','m1197','m1105','m1106','m1149'})
end

%%ripples density overtime (CNO)
for j=1:length(DirSocialDefeat.path)
    VecTimeDay_WAKE_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_SD{j},b{j}.Wake)), 0);
    VecTimeDay_SWS_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_SD{j},b{j}.SWSEpoch)), 0);
    VecTimeDay_REM_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_SD{j},b{j}.REMEpoch)), 0);
    
    subplot(3,5,[3,4]),
    plot(VecTimeDay_WAKE_SD{j}, runmean(Data(Restrict(DeltDensity_SD{j},b{j}.Wake)),70),'.','MarkerSize',0.2), hold on
    ylim([0 1.8])
    xlim([9 20])
    title('WAKE (SD)')
%     makepretty
    subplot(3,5,[8,9]),
    plot(VecTimeDay_SWS_SD{j}, runmean(Data(Restrict(DeltDensity_SD{j},b{j}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
    title('NREM (SD)')
    ylim([0 1.8])
    xlim([9 20])
%     makepretty
    subplot(3,5,[13,14]),
    plot(VecTimeDay_REM_SD{j}, runmean(Data(Restrict(DeltDensity_SD{j},b{j}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
    title('REM (SD)')
    ylim([0 1.8])
    xlim([9 20])
    xlabel('Time (hours)')
%     makepretty
end

%% bar plot
%%wake
ax(1)=subplot(3,5,5),
PlotErrorBarN_KJ({avDeltDensityWake_3hPostSD_basal,avDeltDensityWake_3hPostSD_SD,avDeltDensityWake_3hPostSDend_basal,avDeltDensityWake_3hPostSDend_SD},'newfig',0,'paired',0);
ylabel('Deltas/s')
ylim([0 1])
xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
title('WAKE')
makepretty
%%sws
ax(2)=subplot(3,5,10),
PlotErrorBarN_KJ({avDeltDensitySWS_3hPostSD_basal,avDeltDensitySWS_3hPostSD_SD,avDeltDensitySWS_3hPostSDend_basal,avDeltDensitySWS_3hPostSDend_SD},'newfig',0,'paired',0);
ylabel('Deltas/s')
ylim([0 1.5])
xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
title('NREM')
makepretty
%%rem
ax(3)=subplot(3,5,15),
PlotErrorBarN_KJ({avDeltDensityREM_3hPostSD_basal,avDeltDensityREM_3hPostSD_SD,avDeltDensityREM_3hPostSDend_basal,avDeltDensityREM_3hPostSDend_SD},'newfig',0,'paired',0);
ylabel('Deltas/s')
ylim([0 1])
xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
title('REM')
makepretty

set(ax,'ylim',[0 1.5]);
