%% input dir : social defeat
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1107 1149]);

% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');

%% input dir basal sleep
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
    
    %%load ripples
    if exist('SWR.mat')
        ripp_basal{i}=load('SWR.mat','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_basal{i}=load('Ripples.mat','RipplesEpoch');
    else
        ripp_basal{i}=[];
    end
    if isempty(ripp_basal{i})==0 
    %get ripples density
    [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_basal{i}.RipplesEpoch);
    RippDensity_basal{i} = Ripples_tsd; %store it for all mice
    
        rippDensitySWS_basal{i} = Restrict(RippDensity_basal{i}, a{i}.SWSEpoch);
    rippDensityWake_basal{i} = Restrict(RippDensity_basal{i}, a{i}.Wake);
    rippDensityREM_basal{i} = Restrict(RippDensity_basal{i}, a{i}.REMEpoch);
    %'3h following SD'
    rippDensitySWS_3hPostSD_basal{i} = Restrict(RippDensity_basal{i}, and(a{i}.SWSEpoch, epoch_3hPostSD_Basal{i}));
    rippDensityWake_3hPostSD_basal{i} = Restrict(RippDensity_basal{i}, and(a{i}.Wake, epoch_3hPostSD_Basal{i}));
    rippDensityREM_3hPostSD_basal{i} = Restrict(RippDensity_basal{i}, and(a{i}.REMEpoch, epoch_3hPostSD_Basal{i}));
    %end of the 3h up to the end of the recording
    rippDensitySWS_3hPostSDend_basal{i} = Restrict(RippDensity_basal{i}, and(a{i}.SWSEpoch, epoch_endPostSD_Basal{i}));
    rippDensityWake_3hPostSDend_basal{i} = Restrict(RippDensity_basal{i}, and(a{i}.Wake, epoch_endPostSD_Basal{i}));
    rippDensityREM_3hPostSDend_basal{i} = Restrict(RippDensity_basal{i}, and(a{i}.REMEpoch, epoch_endPostSD_Basal{i}));
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
    
    %%load ripples
    if exist('SWR.mat')
        ripp_SD{j}=load('SWR.mat','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_SD{j}=load('Ripples.mat','RipplesEpoch');
    else
        ripp_SD{j}=[];
    end
      if isempty(ripp_SD{j})==0 
    %%get ripples density
    [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_SD{j}.RipplesEpoch);
    RippDensity_SD{j} = Ripples_tsd;
        rippDensitySWS_SD{j} = Restrict(RippDensity_SD{j}, b{j}.SWSEpoch);
    rippDensityWake_SD{j} = Restrict(RippDensity_SD{j}, b{j}.Wake);
    rippDensityREM_SD{j} = Restrict(RippDensity_SD{j}, b{j}.REMEpoch);
    
    %3h following SD
    rippDensitySWS_3hPostSD_SD{j} = Restrict(RippDensity_SD{j}, and(b{j}.SWSEpoch, epoch_3hPostSD_SD{j}));
    rippDensityWake_3hPostSD_SD{j} = Restrict(RippDensity_SD{j}, and(b{j}.Wake, epoch_3hPostSD_SD{j}));
    rippDensityREM_3hPostSD_SD{j} = Restrict(RippDensity_SD{j}, and(b{j}.REMEpoch, epoch_3hPostSD_SD{j}));
    %end of the 3h up to the end of the recording
    rippDensitySWS_3hPostSDend_SD{j} = Restrict(RippDensity_SD{j}, and(b{j}.SWSEpoch, epoch_endPostSD_SD{j}));
    rippDensityWake_3hPostSDend_SD{j} = Restrict(RippDensity_SD{j}, and(b{j}.Wake, epoch_endPostSD_SD{j}));
    rippDensityREM_3hPostSDend_SD{j} = Restrict(RippDensity_SD{j}, and(b{j}.REMEpoch, epoch_endPostSD_SD{j}));
      else
      end
end

%% calculate mean
%%baseline sleep
for ii=1:length(rippDensitySWS_3hPostSD_basal)
    if isempty(rippDensitySWS_3hPostSD_basal{ii})==0
        avRippDensitySWS_basal(ii,:)=nanmean(Data(rippDensitySWS_basal{ii}(:,:)),1); avRippDensitySWS_basal(avRippDensitySWS_basal==0)=NaN;
    avRippDensityWake_basal(ii,:)=nanmean(Data(rippDensityWake_basal{ii}(:,:)),1); avRippDensityWake_basal(avRippDensityWake_basal==0)=NaN;
    avRippDensityREM_basal(ii,:)=nanmean(Data(rippDensityREM_basal{ii}(:,:)),1); avRippDensityREM_basal(avRippDensityREM_basal==0)=NaN;
    
    %'3h following SD'
    avRippDensitySWS_3hPostSD_basal(ii,:)=nanmean(Data(rippDensitySWS_3hPostSD_basal{ii}(:,:)),1); avRippDensitySWS_3hPostSD_basal(avRippDensitySWS_3hPostSD_basal==0)=NaN;
    avRippDensityWake_3hPostSD_basal(ii,:)=nanmean(Data(rippDensityWake_3hPostSD_basal{ii}(:,:)),1); avRippDensityWake_3hPostSD_basal(avRippDensityWake_3hPostSD_basal==0)=NaN;
    avRippDensityREM_3hPostSD_basal(ii,:)=nanmean(Data(rippDensityREM_3hPostSD_basal{ii}(:,:)),1); avRippDensityREM_3hPostSD_basal(avRippDensityREM_3hPostSD_basal==0)=NaN;
    %end of the 3h up to the end of the recording
    avRippDensitySWS_3hPostSDend_basal(ii,:)=nanmean(Data(rippDensitySWS_3hPostSDend_basal{ii}(:,:)),1);
    avRippDensityWake_3hPostSDend_basal(ii,:)=nanmean(Data(rippDensityWake_3hPostSDend_basal{ii}(:,:)),1);
    avRippDensityREM_3hPostSDend_basal(ii,:)=nanmean(Data(rippDensityREM_3hPostSDend_basal{ii}(:,:)),1);
    else
    end
end
%%sleep post SD
for jj=1:length(rippDensitySWS_3hPostSD_SD)
    if isempty(rippDensitySWS_3hPostSD_SD{jj})==0
        avRippDensitySWS_SD(jj,:)=nanmean(Data(rippDensitySWS_SD{jj}(:,:)),1); avRippDensitySWS_SD(avRippDensitySWS_SD==0)=NaN;
    avRippDensityWake_SD(jj,:)=nanmean(Data(rippDensityWake_SD{jj}(:,:)),1); avRippDensityWake_SD(avRippDensityWake_SD==0)=NaN;
    avRippDensityREM_SD(jj,:)=nanmean(Data(rippDensityREM_SD{jj}(:,:)),1); avRippDensityREM_SD(avRippDensityREM_SD==0)=NaN;
    
    %3h following SD
    avRippDensitySWS_3hPostSD_SD(jj,:)=nanmean(Data(rippDensitySWS_3hPostSD_SD{jj}(:,:)),1); avRippDensitySWS_3hPostSD_SD(avRippDensitySWS_3hPostSD_SD==0)=NaN;
    avRippDensityWake_3hPostSD_SD(jj,:)=nanmean(Data(rippDensityWake_3hPostSD_SD{jj}(:,:)),1); avRippDensityWake_3hPostSD_SD(avRippDensityWake_3hPostSD_SD==0)=NaN;
    avRippDensityREM_3hPostSD_SD(jj,:)=nanmean(Data(rippDensityREM_3hPostSD_SD{jj}(:,:)),1); avRippDensityREM_3hPostSD_SD(avRippDensityREM_3hPostSD_SD==0)=NaN;
    %end of the 3h up to the end of the recording
    avRippDensitySWS_3hPostSDend_SD(jj,:)=nanmean(Data(rippDensitySWS_3hPostSDend_SD{jj}(:,:)),1);
    avRippDensityWake_3hPostSDend_SD(jj,:)=nanmean(Data(rippDensityWake_3hPostSDend_SD{jj}(:,:)),1);
    avRippDensityREM_3hPostSDend_SD(jj,:)=nanmean(Data(rippDensityREM_3hPostSDend_SD{jj}(:,:)),1);
    else
    end
end


%% figure : ripples density (bars)
col_basal = [.8 .8 .8];
col_SD = [1 0 0];

figure
ax(1)=subplot(231),MakeBoxPlot_MC({avRippDensityWake_basal,avRippDensityWake_SD},...
    {col_basal,col_SD},[1:2],{},1,0);
xticks([1:2]); xticklabels({'Baseline','SD'});% xtickangle(45);
ylabel('Ripples/s')
title('WAKE - post SD')

ax(2)=subplot(232),MakeBoxPlot_MC({avRippDensitySWS_basal,avRippDensitySWS_SD},...
    {col_basal,col_SD},[1:2],{},1,0);
xticks([1:2]); xticklabels({'Baseline','SD'});% xtickangle(45);
ylabel('Ripples/s')
title('NREM - post SD')

ax(3)=subplot(233),MakeBoxPlot_MC({avRippDensityREM_basal,avRippDensityREM_SD},...
    {col_basal,col_SD},[1:2],{},1,0);
xticks([1:2]); xticklabels({'Baseline','SD'});% xtickangle(45);
ylabel('Ripples/s')
title('REM - post SD')




ax(4)=subplot(234),MakeBoxPlot_MC({avRippDensityWake_3hPostSD_basal,avRippDensityWake_3hPostSD_SD},...
    {col_basal,col_SD},[1:2],{},1,0);
xticks([1:2]); xticklabels({'Baseline','SD'});% xtickangle(45);
ylabel('Ripples/s')
title('WAKE - 3h post SD')

ax(5)=subplot(235),MakeBoxPlot_MC({avRippDensitySWS_3hPostSD_basal,avRippDensitySWS_3hPostSD_SD},...
    {col_basal,col_SD},[1:2],{},1,0);
xticks([1:2]); xticklabels({'Baseline','SD'});% xtickangle(45);
ylabel('Ripples/s')
title('NREM - 3h post SD')

ax(6)=subplot(236),MakeBoxPlot_MC({avRippDensityREM_3hPostSD_basal,avRippDensityREM_3hPostSD_SD},...
    {col_basal,col_SD},[1:2],{},1,0);
xticks([1:2]); xticklabels({'Baseline','SD'});% xtickangle(45);
ylabel('Ripples/s')
title('REM - 3h post SD')


%%
% %% figure : ripples density (bars)
% figure,
% subplot(311),PlotErrorBarN_KJ({avRippDensityWake_3hPostSD_basal,avRippDensityWake_3hPostSD_SD,avRippDensityWake_3hPostSDend_basal,avRippDensityWake_3hPostSDend_SD},'newfig',0,'paired',0);
% ylabel('Ripples/s')
% ylim([0 1])
% xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% title('WAKE')
% makepretty
% subplot(312),PlotErrorBarN_KJ({avRippDensitySWS_3hPostSD_basal,avRippDensitySWS_3hPostSD_SD,avRippDensitySWS_3hPostSDend_basal,avRippDensitySWS_3hPostSDend_SD},'newfig',0,'paired',0);
% ylabel('Ripples/s')
% ylim([0 1])
% xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% title('NREM')
% makepretty
% subplot(313),PlotErrorBarN_KJ({avRippDensityREM_3hPostSD_basal,avRippDensityREM_3hPostSD_SD,avRippDensityREM_3hPostSDend_basal,avRippDensityREM_3hPostSDend_SD},'newfig',0,'paired',0);
% ylabel('Ripples/s')
% ylim([0 1])
% xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% title('REM')
% makepretty

%% figure : ripples density overtime
figure
%%ripples density overtime (saline)
for i=1:length(DirMyBasal.path)
    if isempty(RippDensity_basal{i})==0
    VecTimeDay_WAKE_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_basal{i},a{i}.Wake)), 0);
    VecTimeDay_SWS_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_basal{i},a{i}.SWSEpoch)), 0);
    VecTimeDay_REM_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_basal{i},a{i}.REMEpoch)), 0);

    
    subplot(3,5,[1,2]),
    plot(VecTimeDay_WAKE_basal{i}, runmean(Data(Restrict(RippDensity_basal{i},a{i}.Wake)),70),'.','MarkerSize',0.2), hold on
    ylabel('Ripples/s')
    ylim([0 1.8])
    xlim([9 20])
    title('WAKE (baseline)')
%     makepretty
    subplot(3,5,[6,7]),
    plot(VecTimeDay_SWS_basal{i}, runmean(Data(Restrict(RippDensity_basal{i},a{i}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
    ylabel('Ripples/s')
    title('NREM (baseline)')
    ylim([0 1.8])
    xlim([9 20])
%     makepretty
    subplot(3,5,[11,12]),
    plot(VecTimeDay_REM_basal{i}, runmean(Data(Restrict(RippDensity_basal{i},a{i}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
    ylabel('Ripples/s')
    title('REM (baseline)')
    ylim([0 1.8])
    xlim([9 20])
    xlabel('Time (hours)')
%     makepretty
    % legend({'m1196','m1197','m1105','m1106','m1149'})
    else 
    end
end

%%ripples density overtime (CNO)
for j=1:length(DirSocialDefeat.path)
        if isempty(RippDensity_SD{j})==0

    VecTimeDay_WAKE_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_SD{j},b{j}.Wake)), 0);
    VecTimeDay_SWS_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_SD{j},b{j}.SWSEpoch)), 0);
    VecTimeDay_REM_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_SD{j},b{j}.REMEpoch)), 0);
    
    subplot(3,5,[3,4]),
    plot(VecTimeDay_WAKE_SD{j}, runmean(Data(Restrict(RippDensity_SD{j},b{j}.Wake)),70),'.','MarkerSize',0.2), hold on
    ylim([0 1.8])
    xlim([9 20])
    title('WAKE (SD)')
%     makepretty
    subplot(3,5,[8,9]),
    plot(VecTimeDay_SWS_SD{j}, runmean(Data(Restrict(RippDensity_SD{j},b{j}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
    title('NREM (SD)')
    ylim([0 1.8])
    xlim([9 20])
%     makepretty
    subplot(3,5,[13,14]),
    plot(VecTimeDay_REM_SD{j}, runmean(Data(Restrict(RippDensity_SD{j},b{j}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
    title('REM (SD)')
    ylim([0 1.8])
    xlim([9 20])
    xlabel('Time (hours)')
%     makepretty
        else
        end
end

%% bar plot
%%wake
ax(1)=subplot(3,5,5),
PlotErrorBarN_KJ({avRippDensityWake_3hPostSD_basal,avRippDensityWake_3hPostSD_SD,avRippDensityWake_3hPostSDend_basal,avRippDensityWake_3hPostSDend_SD},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 1])
xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
title('WAKE')
makepretty
%%sws
ax(2)=subplot(3,5,10),
PlotErrorBarN_KJ({avRippDensitySWS_3hPostSD_basal,avRippDensitySWS_3hPostSD_SD,avRippDensitySWS_3hPostSDend_basal,avRippDensitySWS_3hPostSDend_SD},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 1])
xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
title('NREM')
makepretty
%%rem
ax(3)=subplot(3,5,15),
PlotErrorBarN_KJ({avRippDensityREM_3hPostSD_basal,avRippDensityREM_3hPostSD_SD,avRippDensityREM_3hPostSDend_basal,avRippDensityREM_3hPostSDend_SD},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 1])
xticks([1:4]); xticklabels({'Baseline st-3h','SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
title('REM')
makepretty

set(ax,'ylim',[0 1]);
