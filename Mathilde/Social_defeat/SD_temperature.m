%% input dir
dirSocialDefeat_CD1cage = PathForExperimentsSD_MC('SensoryExposureCD1cage');
dirSocialDefeat_C57cage = PathForExperimentsSD_MC('SensoryExposureC57cage');
dirSocialDefeat_sleep = PathForExperimentsSD_MC('SleepPostSD');

%%dir basal
Dir_dreadd1=PathForExperiments_DREADD_MC('BaselineSleep');
Dir_dreadd2=PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
Dir_dreadd2=RestrictPathForExperiment(Dir_dreadd2,'nMice',[1197 1198]);
DirBasal = MergePathForExperiment(Dir_dreadd1,Dir_dreadd2);

% DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
% DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
% DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
% DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);
% DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);

%% get Data
%% Baseline sleep 
for imouse = 1:length(DirBasal.path)
    cd(DirBasal.path{imouse}{1});
    MiceNum{imouse} = DirBasal.name{imouse};
    
%load sleep scoring
    stage_basal{imouse} = load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    beg_epoch{imouse} = intervalSet(0,0.3*3600*1E4); %%first 20 min of the recording to compare to the sensory exposure (SD)
    %%load behaviour
    if exist('behavResources_Offline.mat')
        behav_basalSleep{imouse} = load('behavResources_Offline.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    elseif exist('behavResources.mat')
        behav_basalSleep{imouse} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    %%temperature    
    temperature_basal{imouse} = Data(behav_basalSleep{imouse}.MouseTemp_tsd);
    temperature_beg_basal{imouse} = Data(Restrict(behav_basalSleep{imouse}.MouseTemp_tsd,beg_epoch{imouse}));

        
    temp_rem_basal{imouse} = Data(Restrict(behav_basalSleep{imouse}.MouseTemp_tsd, stage_basal{imouse}.REMEpoch));
    temp_sws_basal{imouse} = Data(Restrict(behav_basalSleep{imouse}.MouseTemp_tsd, stage_basal{imouse}.SWSEpoch));
    temp_wake_basal{imouse} = Data(Restrict(behav_basalSleep{imouse}.MouseTemp_tsd, stage_basal{imouse}.Wake));
end

%%
for imouse = 1:length(DirBasal.path)
    cd(DirBasal.path{imouse}{1});
    T_basal(imouse,:)=temperature_basal{imouse}(1:263000,:);

end
%%  
%% social defeat - sensory exposure CD1 cage
for i=1:length(dirSocialDefeat_CD1cage.path)
    cd(dirSocialDefeat_CD1cage.path{i}{1});
    MiceNum{i} = dirSocialDefeat_CD1cage.name{i};
    %%load behaviour
    if exist('behavResources_Offline.mat')
        behav_stressCD1cage{i} = load('behavResources_Offline.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    elseif exist('behavResources.mat')
        behav_stressCD1cage{i} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    %%temperature    
    temp_stressCD1cage{i} = Data(behav_stressCD1cage{i}.MouseTemp_tsd);
end

%% social defeat - sensory exposure C57 cage
for j=1:length(dirSocialDefeat_C57cage.path)
    cd(dirSocialDefeat_C57cage.path{j}{1});
    MiceNum{j} = dirSocialDefeat_C57cage.name{j};
    %%load behaviour
    if exist('behavResources_Offline.mat')
        behav_stressC57cage{j} = load('behavResources_Offline.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    elseif exist('behavResources.mat')
        behav_stressC57cage{j} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    %%temperature    
    temp_stressC57cage{j} = Data(behav_stressC57cage{j}.MouseTemp_tsd);
end

%% social defeat - sleep session
for k=1:length(dirSocialDefeat_sleep.path)
    cd(dirSocialDefeat_sleep.path{k}{1});
    MiceNum{k} = dirSocialDefeat_sleep.name{k};
    %%load sleep scoring
    stage{k} = load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    %%load behaviour
    if exist('behavResources_Offline.mat')
        behav_sleep{k} = load('behavResources_Offline.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    elseif exist('behavResources.mat')
        behav_sleep{k} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    %%temperature    
    temperature{k} = Data(behav_sleep{k}.MouseTemp_tsd);
    temp_rem{k} = Data(Restrict(behav_sleep{k}.MouseTemp_tsd, stage{k}.REMEpoch));
    temp_sws{k} = Data(Restrict(behav_sleep{k}.MouseTemp_tsd, stage{k}.SWSEpoch));
    temp_wake{k} = Data(Restrict(behav_sleep{k}.MouseTemp_tsd, stage{k}.Wake));
end
%%

for k=1:length(dirSocialDefeat_sleep.path)
    cd(dirSocialDefeat_sleep.path{k}{1});
T_SD(k,:)=temperature{k}(1:245000,:);
end

%% calculate mean
%%sensory exposure in CD1 cage
for ii=1:length(temp_stressCD1cage)
    avTemp_stressCD1cage(ii,:) = nanmean(temp_stressCD1cage{ii}(:,:),1);
end
%%sensory exposure in C57 cage
for jj=1:length(temp_stressC57cage)
    avTemp_stressC57cage(jj,:) = nanmean(temp_stressC57cage{jj}(:,:),1);
end
%%sleep session post SD
for kk=1:length(temperature)
    avTemp(kk,:) = nanmean(temperature{kk}(:,:),1);
    avTemp_rem(kk,:) = nanmean(temp_rem{kk}(:,:),1);
    avTemp_sws(kk,:) = nanmean(temp_sws{kk}(:,:),1);
    avTemp_wake(kk,:) = nanmean(temp_wake{kk}(:,:),1);
end
%%basal sleep session
for mm=1:length(temperature_basal)
    avTemp_basal(mm,:) = nanmean(temperature_basal{mm}(:,:),1);
    avTemp_beg_basal(mm,:) = nanmean(temperature_beg_basal{mm}(:,:),1);
    avTemp_rem_basal(mm,:) = nanmean(temp_rem_basal{mm}(:,:),1);
    avTemp_sws_basal(mm,:) = nanmean(temp_sws_basal{mm}(:,:),1);
    avTemp_wake_basal(mm,:) = nanmean(temp_wake_basal{mm}(:,:),1);
end
%%
figure, subplot(121)
MakeBoxPlot_MC({avTemp_beg_basal avTemp_stressCD1cage avTemp_stressC57cage},{[0.8 0.8 0.8],[1 0 0],[1 0 0]},[1:3],{'BaselineSleep','SensoryExpoCD1cage','SensoryExpoC57cage'},1,0);
xtickangle(45)
ylabel('Temperature (°C)')
 title('Social defeat stress')
%%Rank sum test
p = ranksum(avTemp_beg_basal, avTemp_stressCD1cage);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_beg_basal, avTemp_stressC57cage);
if p<0.05
    sigstar_DB({[1 3]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_stressCD1cage, avTemp_stressC57cage);
if p<0.05
    sigstar_DB({[2 3]},p,0,'LineWigth',16,'StarSize',24);
end

% %%
% figure, 

subplot(122)
MakeBoxPlot_MC({avTemp_wake_basal avTemp_wake avTemp_sws_basal avTemp_sws avTemp_rem_basal avTemp_rem},{[0.8 0.8 0.8],[1 0 0],[0.8 0.8 0.8],[1 0 0],[0.8 0.8 0.8],[1 0 0]},[1,2,4,5,7,8],{},1,0);
xticks([1.5, 4.5, 7.5]); xticklabels({'Wake','NREM','REM'})
ylabel('Temperature (°C)')
title('Sleep session post SD')
%%Rank sum test
p = ranksum(avTemp_wake_basal, avTemp_wake);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_sws_basal, avTemp_sws);
if p<0.05
    sigstar_DB({[4,5]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_rem_basal, avTemp_rem);
if p<0.05
    sigstar_DB({[7,8]},p,0,'LineWigth',16,'StarSize',24);
end

%%
% for k=1:length(DirSocialDefeat.path)
%     cd(DirSocialDefeat.path{k}{1});
%     MiceNum{k} = DirSocialDefeat.name{k};
% 
%     if exist(behav{k}.MouseTemp_InDegrees)==1
%     figure,plot(Range(behav{k}.Xtsd)/1E4,runmean(behav{k}.MouseTemp_InDegrees,20))
% SleepStages=PlotSleepStage(stage{k}.Wake,stage{k}.SWSEpoch,stage{k}.REMEpoch,0,[33 1]);
%     
%     else
%     end
% 
% end



%%
% figure, hold on
% plot(runmean(temp_stressC57cage{1},25))
% plot(runmean(temp_stressC57cage{2},25))
% plot(runmean(temp_stressC57cage{3},25))
% plot(runmean(temp_stressC57cage{4},25))
% plot(runmean(temp_stressC57cage{5},25))
% plot(runmean(temp_stressC57cage{6},25))
% plot(runmean(temp_stressC57cage{7},25))
% makepretty


figure
MakeBoxPlot_MC({avTemp_wake_basal  avTemp_sws_basal  avTemp_rem_basal},{[0.8 0.8 0.8],[0.8 0.8 0.8],[0.8 0.8 0.8]},[1:3],{},1,0);
xticks([1:3]); xticklabels({'Wake','NREM','REM'})
ylabel('Temperature (°C)')
title('Sleep session post SD')
%%Rank sum test
p = ranksum(avTemp_wake_basal, avTemp_sws_basal);
if p<0.05
    sigstar_DB({[1,2]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_sws_basal, avTemp_rem_basal);
if p<0.05
    sigstar_DB({[2,3]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_wake_basal, avTemp_rem_basal);
if p<0.05
    sigstar_DB({[1,3]},p,0,'LineWigth',16,'StarSize',24);
end


%%
figure
MakeBoxPlot_MC({avTemp_wake  avTemp_sws  avTemp_rem},{[1 0 0],[1 0 0],[1 0 0]},[1:3],{},1,0);
xticks([1:3]); xticklabels({'Wake','NREM','REM'})
ylabel('Temperature (°C)')
title('Sleep session post SD')
%%Rank sum test
p = ranksum(avTemp_wake, avTemp_sws);
if p<0.05
    sigstar_DB({[1,2]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_sws, avTemp_rem);
if p<0.05
    sigstar_DB({[2,3]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_wake, avTemp_rem);
if p<0.05
    sigstar_DB({[1,3]},p,0,'LineWigth',16,'StarSize',24);
end


%%
tps_basal=Range(behav_basalSleep{i}.MouseTemp_tsd);
tps_basal=tps_basal(1:263000,:);

T_SD_mean = runmean(nanmean(T_SD),30);
T_basal_mean = runmean(nanmean(T_basal),30);

figure,shadedErrorBar(tps,T_SD_mean,stdError(T_SD),'r')


figure
plot(T_SD_mean,'r')
hold on
plot(T_basal_mean,'k')