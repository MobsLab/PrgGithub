
DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_retroCre');
% DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');
% DirSocialDefeat_inhibPFC=RestrictPathForExperiment(DirSocialDefeat_inhibPFC,'nMice',[1196 1197 1238]);% %1107

DirSleepInhibPFC=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');
% DirSleepInhibPFC=PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirSleepInhibPFC=RestrictPathForExperiment(DirSleepInhibPFC,'nMice',[1196 1197 1198 1235 1236 1238]);% %1107


%% input dir : social defeat
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1148 1149 1150]);

% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');

DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);

Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');

DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);

% DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);

%%parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;


%% get data (baseline)
for j=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{j}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        b{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    %%compute stages density
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        D_WAKE_basal=DensitySleepStage_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,'wake',100);
        density_WAKE_basal{j}=D_WAKE_basal;
        D_SWS_basal=DensitySleepStage_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,'sws',100);
        density_SWS_basal{j}=D_SWS_basal;
        D_REM_basal=DensitySleepStage_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,'rem',100);
        density_REM_basal{j}=D_REM_basal;
        %%get time of the day
        VecTimeDay_basal{j} = GetTimeOfTheDay_MC(Range(density_WAKE_basal{j}), 0);
        end_rec_basal(j) = min(length(density_REM_basal{j}));
        max_end_basal(j) = max(length(density_REM_basal{j}));
    else
    end
end



%% get data (SD)
for i=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{i}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    %%compute stages density
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        D_WAKE=DensitySleepStage_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,'wake',100);
        density_WAKE{i}=D_WAKE;
        D_SWS=DensitySleepStage_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,'sws',100);
        density_SWS{i}=D_SWS;
        D_REM=DensitySleepStage_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,'rem',100);
        density_REM{i}=D_REM;
        %%get time of the day
        VecTimeDay{i} = GetTimeOfTheDay_MC(Range(density_WAKE{i}), 0);
        end_rec(i) = min(length(density_REM{i}));
        
        
        max_end(i) = max(length(density_REM{i}));
    else
    end
end

%%

clear jj
for jj=1:length(density_REM_basal)
    if isempty(density_REM_basal{jj})==0
%%time vector
VecTimeDay_basal{jj}(end_rec_basal(jj):max(max_end_basal))=NaN;
        %%get density for each stage
        data_density_WAKE_basal{jj}=Data(density_WAKE_basal{jj})';
        data_density_SWS_basal{jj}=Data(density_SWS_basal{jj})';
        data_density_REM_basal{jj}=Data(density_REM_basal{jj})';
        %%make vector of same length
        data_density_WAKE_basal{jj}(end_rec_basal(jj):max(max_end_basal))=NaN;
        data_density_SWS_basal{jj}(end_rec_basal(jj):max(max_end_basal))=NaN;
        data_density_REM_basal{jj}(end_rec_basal(jj):max(max_end_basal))=NaN;
        %%store data for all mice
        av_data_density_WAKE_basal(jj,:) = data_density_WAKE_basal{jj};
        av_data_density_REM_basal(jj,:) = data_density_REM_basal{jj};
        av_data_density_SWS_basal(jj,:) = data_density_SWS_basal{jj};
    else
    end
end
%%
clear ii
for ii=1:length(density_REM)
    if isempty(density_REM{ii})==0
%%time vector
VecTimeDay{ii}(end_rec(ii):max(max_end))=NaN;
        %%get density for each stage
        data_density_WAKE{ii}=Data(density_WAKE{ii})';
        data_density_SWS{ii}=Data(density_SWS{ii})';
        data_density_REM{ii}=Data(density_REM{ii})';
        %%make vector of same length
        data_density_WAKE{ii}(end_rec(ii):max(max_end))=NaN;
        data_density_SWS{ii}(end_rec(ii):max(max_end))=NaN;
        data_density_REM{ii}(end_rec(ii):max(max_end))=NaN;
        %%store data for all mice
        av_data_density_WAKE(ii,:) = data_density_WAKE{ii};
        av_data_density_REM(ii,:) = data_density_REM{ii};
        av_data_density_SWS(ii,:) = data_density_SWS{ii};
    else
    end
end

%% figure


figure,

subplot(211), hold on
shadedErrorBar(VecTimeDay_basal{10}, av_data_density_WAKE_basal, {@nanmean,@stdError}, 'k', 1);
shadedErrorBar(VecTimeDay_basal{10}, av_data_density_SWS_basal, {@nanmean,@stdError}, 'b', 1);
shadedErrorBar(VecTimeDay_basal{10}, av_data_density_REM_basal, {@nanmean,@stdError}, 'r', 1);


subplot(212), hold on
shadedErrorBar(VecTimeDay{10}, av_data_density_WAKE, {@nanmean,@stdError}, 'k', 1);
shadedErrorBar(VecTimeDay{10}, av_data_density_SWS, {@nanmean,@stdError}, 'b', 1);
shadedErrorBar(VecTimeDay{10}, av_data_density_REM, {@nanmean,@stdError}, 'r', 1);



%%

col_basal = [0.9 0.9 0.9];
col_sal = [0.9 0.9 0.9];

col_saline = [0.9 0.9 0.9];
col_PFCinhib = [1 .4 .2];
col_SD = [1 0 0];
col_atropine = [1 0 0];
col_PFCinhib_SD = [.4 0 0];
col_inhib = [.4 0 0];

figure, subplot(311)
plot(nanmean(data_density_WAKE_saline),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_density_WAKE_saline), stdError(data_density_WAKE_saline),'color',[.5 .5 .5])
plot(nanmean(data_density_WAKE_atropine),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_density_WAKE_atropine), stdError(data_density_WAKE_atropine),'color',col_SD)
plot(nanmean(data_density_WAKE_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_density_WAKE_inhib), stdError(data_density_WAKE_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
xlim([0 8])
makepretty
ylabel('Percentage')
xlabel('Time after stress (h)')
title('WAKE')

subplot(312), 
plot(nanmean(data_density_SWS_saline),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_density_SWS_saline), stdError(data_density_SWS_saline),'color',[.5 .5 .5])
plot(nanmean(data_density_SWS_atropine),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_density_SWS_atropine), stdError(data_density_SWS_atropine),'color',col_SD)
plot(nanmean(data_density_SWS_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_density_SWS_inhib), stdError(data_density_SWS_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
% xlim([4 9])
makepretty
ylabel('Percentage')
xlabel('Time after stress (h)')
title('NREM sleep')

subplot(313), 
plot(nanmean(data_density_REM_saline),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_density_REM_saline), stdError(data_density_REM_saline),'color',[.5 .5 .5])
plot(nanmean(data_density_REM_atropine),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_density_REM_atropine), stdError(data_density_REM_atropine),'color',col_SD)
plot(nanmean(data_density_REM_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_density_REM_inhib), stdError(data_density_REM_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
% xlim([4 9])
makepretty
ylabel('Percentage')
xlabel('Time after stress (h)')
title('REM sleep')
