% %% input dir
% % dirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% % % dirCNO=RestrictPathForExperiment(dirCNO,'nMice',[1217 1218 1219 1220]); %%small volume
% % dirCNO=RestrictPathForExperiment(dirCNO,'nMice',[1105 1106 1148 1149]); %%big volume
% 
% dirSaline_CRH_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% dirSaline_CRH_VLPO=RestrictPathForExperiment(dirSaline_CRH_VLPO,'nMice',[1217 1218 1219 1220]);
% 
% %%dir basal
% Dir_dreadd1=PathForExperiments_DREADD_MC('BaselineSleep');
% Dir_dreadd2=PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
% Dir_dreadd2=RestrictPathForExperiment(Dir_dreadd2,'nMice',[1197 1198]);
% DirBasal = MergePathForExperiment(Dir_dreadd1,Dir_dreadd2);
% 
% % DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% % DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
% % DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
% % DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
% % DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);
% % DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% % DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);
% 
% % DirCNO = PathForExperimentsAtropine_MC('Atropine');
% 
% %%%
% % DirSaline = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% % DirSaline=RestrictPathForExperiment(DirSaline,'nMice',[1245 1247]);
% 
% % DirCNO = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');
% % DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1245 1247]);
% 
% %merge saline path
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% 
% dirSaline = MergePathForExperiment(dirSaline_CRH_VLPO,DirSaline_retoCre);
% 
% 
% DirCNO = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');


% %%DIR EXCI DREADDS CRH VLPO SAL/CNO (basal sleep)
dirSaline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% dirSaline = RestrictPathForExperiment(dirSaline, 'nMice', [1218 1219 1220 1371 1372 1373 1374]);%1217

dirCNO = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');
% dirCNO = RestrictPathForExperiment(dirCNO, 'nMice', [1218 1219 1220 1371 1372 1373 1374]);%1217
% dirCNO_bigVolume = RestrictPathForExperiment(dirCNO,'nMice',[1105 1106 1148 1149 ]);%1150

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

same_ending = 234880;

%% get Data
%% Baseline sleep 
for i = 1:length(DirBasal.path)
    cd(DirBasal.path{i}{1});
    MiceNum{i} = DirBasal.name{i};
    %%load behaviour
    if exist('behavResources.mat')
        behav_basal{i} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    
    %%load sleep scoring
    stage_basal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%define time periods
    durtotal_basal{i} = max([max(End(stage_basal{i}.Wake)),max(End(stage_basal{i}.SWSEpoch))]);
    epoch_PreInj_basal{i} = intervalSet(0, en_epoch_preInj); %pre injection
    epoch_PostInj_basal{i} = intervalSet(st_epoch_postInj,durtotal_basal{i}); %post injection
    epoch_3hPostInj_basal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %3h post injection
    
    temp_basal{i} = Data(behav_basal{i}.MouseTemp_tsd);
    %%temperature pre injection
    temp_rem_pre_basal{i} = Data(Restrict(behav_basal{i}.MouseTemp_tsd, and(stage_basal{i}.REMEpoch,epoch_PreInj_basal{i})));
    temp_sws_pre_basal{i} = Data(Restrict(behav_basal{i}.MouseTemp_tsd, and(stage_basal{i}.SWSEpoch,epoch_PreInj_basal{i})));
    temp_wake_pre_basal{i} = Data(Restrict(behav_basal{i}.MouseTemp_tsd, and(stage_basal{i}.Wake,epoch_PreInj_basal{i})));
    %%temperature post injection
    temp_rem_post_basal{i} = Data(Restrict(behav_basal{i}.MouseTemp_tsd, and(stage_basal{i}.REMEpoch,epoch_PostInj_basal{i})));
    temp_sws_post_basal{i} = Data(Restrict(behav_basal{i}.MouseTemp_tsd, and(stage_basal{i}.SWSEpoch,epoch_PostInj_basal{i})));
    temp_wake_post_basal{i} = Data(Restrict(behav_basal{i}.MouseTemp_tsd, and(stage_basal{i}.Wake,epoch_PostInj_basal{i})));
    %%temperature retricted 3h post injection
    temp_rem_3hpost_basal{i} = Data(Restrict(behav_basal{i}.MouseTemp_tsd, and(stage_basal{i}.REMEpoch,epoch_3hPostInj_basal{i})));
    temp_sws_3hpost_basal{i} = Data(Restrict(behav_basal{i}.MouseTemp_tsd, and(stage_basal{i}.SWSEpoch,epoch_3hPostInj_basal{i})));
    temp_wake_3hpost_basal{i} = Data(Restrict(behav_basal{i}.MouseTemp_tsd, and(stage_basal{i}.Wake,epoch_3hPostInj_basal{i})));
end

%%  
%% Saline injection 
for j = 1:length(dirSaline.path)
    cd(dirSaline.path{j}{1});
    MiceNum{j} = dirSaline.name{j};
    %%load behaviour
    if exist('behavResources.mat')
        behav_saline{j} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    
    %%load sleep scoring
    stage_saline{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%define time periods
    durtotal_saline{j} = max([max(End(stage_saline{j}.Wake)),max(End(stage_saline{j}.SWSEpoch))]);
    epoch_PreInj_saline{j} = intervalSet(0, en_epoch_preInj); %pre injection
    epoch_PostInj_saline{j} = intervalSet(st_epoch_postInj,durtotal_saline{j}); %post injection
    epoch_3hPostInj_saline{j}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %3h post injection
    
    temp_saline{j} = Data(behav_saline{j}.MouseTemp_tsd);
    %%temperature pre injection
    temp_rem_pre_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.REMEpoch,epoch_PreInj_saline{j})));
    temp_sws_pre_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.SWSEpoch,epoch_PreInj_saline{j})));
    temp_wake_pre_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.Wake,epoch_PreInj_saline{j})));
    %%temperature post injection
    temp_rem_post_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.REMEpoch,epoch_PostInj_saline{j})));
    temp_sws_post_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.SWSEpoch,epoch_PostInj_saline{j})));
    temp_wake_post_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.Wake,epoch_PostInj_saline{j})));
    %%temperature retricted 3h post injection
    temp_rem_3hpost_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.REMEpoch,epoch_3hPostInj_saline{j})));
    temp_sws_3hpost_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.SWSEpoch,epoch_3hPostInj_saline{j})));
    temp_wake_3hpost_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.Wake,epoch_3hPostInj_saline{j})));
end





%% CNO injection 
for k = 1:length(dirCNO.path)
    cd(dirCNO.path{k}{1});
    MiceNum{k} = dirCNO.name{k};
    %%load behaviour
    if exist('behavResources.mat')
        behav_cno{k} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    
    %%load sleep scoring
    stage_cno{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%define time periods
    durtotal_cno{k} = max([max(End(stage_cno{k}.Wake)),max(End(stage_cno{k}.SWSEpoch))]);
    epoch_PreInj_cno{k} = intervalSet(0, en_epoch_preInj); %pre injection
    epoch_PostInj_cno{k} = intervalSet(st_epoch_postInj,durtotal_cno{k}); %post injection
    epoch_3hPostInj_cno{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %3h post injection
    
    temp_cno{k} = Data(behav_cno{k}.MouseTemp_tsd);
    time_cno{k} = Range(behav_cno{k}.MouseTemp_tsd);
    %%temperature pre injection
    temp_rem_pre_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.REMEpoch,epoch_PreInj_cno{k})));
    temp_sws_pre_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.SWSEpoch,epoch_PreInj_cno{k})));
    temp_wake_pre_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.Wake,epoch_PreInj_cno{k})));
    %%temperature post injection
    temp_rem_post_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.REMEpoch,epoch_PostInj_cno{k})));
    temp_sws_post_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.SWSEpoch,epoch_PostInj_cno{k})));
    temp_wake_post_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.Wake,epoch_PostInj_cno{k})));
    %%temperature retricted 3h post injection
    temp_rem_3hpost_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.REMEpoch,epoch_3hPostInj_cno{k})));
    temp_sws_3hpost_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.SWSEpoch,epoch_3hPostInj_cno{k})));
    temp_wake_3hpost_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.Wake,epoch_3hPostInj_cno{k})));
end


%% calculate mean
%%basal sleep session
for ii=1:length(temp_rem_pre_basal)
    temp_basal_all(ii,:) = temp_basal{ii}(1:same_ending,:);
    %%temperature pre injection
    avTemp_rem_pre_basal(ii,:) = nanmean(temp_rem_pre_basal{ii}(:,:),1);
    avTemp_sws_pre_basal(ii,:) = nanmean(temp_sws_pre_basal{ii}(:,:),1);
    avTemp_wake_pre_basal(ii,:) = nanmean(temp_wake_pre_basal{ii}(:,:),1);
    %%temperature post injection
    avTemp_rem_post_basal(ii,:) = nanmean(temp_rem_post_basal{ii}(:,:),1);
    avTemp_sws_post_basal(ii,:) = nanmean(temp_sws_post_basal{ii}(:,:),1);
    avTemp_wake_post_basal(ii,:) = nanmean(temp_wake_post_basal{ii}(:,:),1);
    %%temperature retricted 3h post injection
    avTemp_rem_3hpost_basal(ii,:) = nanmean(temp_rem_3hpost_basal{ii}(:,:),1);
    avTemp_sws_3hpost_basal(ii,:) = nanmean(temp_sws_3hpost_basal{ii}(:,:),1);
    avTemp_wake_3hpost_basal(ii,:) = nanmean(temp_wake_3hpost_basal{ii}(:,:),1);
end

%%saline injection
for jj=1:length(temp_rem_pre_saline)
    temp_saline_all(jj,:) = temp_saline{jj}(1:same_ending,:);
    %%temperature pre injection
    avTemp_rem_pre_saline(jj,:) = nanmean(temp_rem_pre_saline{jj}(:,:),1);
    avTemp_sws_pre_saline(jj,:) = nanmean(temp_sws_pre_saline{jj}(:,:),1);
    avTemp_wake_pre_saline(jj,:) = nanmean(temp_wake_pre_saline{jj}(:,:),1);
    %%temperature post injection
    avTemp_rem_post_saline(jj,:) = nanmean(temp_rem_post_saline{jj}(:,:),1);
    avTemp_sws_post_saline(jj,:) = nanmean(temp_sws_post_saline{jj}(:,:),1);
    avTemp_wake_post_saline(jj,:) = nanmean(temp_wake_post_saline{jj}(:,:),1);
    %%temperature retricted 3h post injection
    avTemp_rem_3hpost_saline(jj,:) = nanmean(temp_rem_3hpost_saline{jj}(:,:),1);
    avTemp_sws_3hpost_saline(jj,:) = nanmean(temp_sws_3hpost_saline{jj}(:,:),1);
    avTemp_wake_3hpost_saline(jj,:) = nanmean(temp_wake_3hpost_saline{jj}(:,:),1);
end

%%CNO injection
for kk=1:length(temp_rem_pre_cno)
    temp_cno_all(kk,:) = temp_cno{kk}(1:same_ending,:);
    time_cno_all(kk,:) = time_cno{kk}(1:same_ending,:);

    %%temperature pre injection
    avTemp_rem_pre_cno(kk,:) = nanmean(temp_rem_pre_cno{kk}(:,:),1);
    avTemp_sws_pre_cno(kk,:) = nanmean(temp_sws_pre_cno{kk}(:,:),1);
    avTemp_wake_pre_cno(kk,:) = nanmean(temp_wake_pre_cno{kk}(:,:),1);
    %%temperature post injection
    avTemp_rem_post_cno(kk,:) = nanmean(temp_rem_post_cno{kk}(:,:),1);
    avTemp_sws_post_cno(kk,:) = nanmean(temp_sws_post_cno{kk}(:,:),1);
    avTemp_wake_post_cno(kk,:) = nanmean(temp_wake_post_cno{kk}(:,:),1);
    %%temperature retricted 3h post injection
    avTemp_rem_3hpost_cno(kk,:) = nanmean(temp_rem_3hpost_cno{kk}(:,:),1);
    avTemp_sws_3hpost_cno(kk,:) = nanmean(temp_sws_3hpost_cno{kk}(:,:),1);
    avTemp_wake_3hpost_cno(kk,:) = nanmean(temp_wake_3hpost_cno{kk}(:,:),1);
end

%% figures
%% av temperature overtime
figure, hold on
shadedErrorBar(time_cno_all(1,:), runmean(mean(temp_basal_all),100),stdError((temp_basal_all)),'k',1)
shadedErrorBar(time_cno_all(1,:), runmean(mean(temp_saline_all),100),stdError((temp_saline_all)),'b',1)
shadedErrorBar(time_cno_all(1,:), runmean(mean(temp_cno_all),100),stdError((temp_cno_all)),'r',1)

%%

col_basal = [0 0 0];
col_sal = [1 0.6 0.6];
col_cno = [1 0 0];

figure
hold on
plot(time_cno_all(1,:), runmean(mean(temp_saline_all),50),'color',col_sal)
plot(time_cno_all(1,:), runmean(mean(temp_basal_all),50),'color',col_basal)
plot(time_cno_all(1,:), runmean(mean(temp_cno_all),50),'color',col_cno)


figure
hold on
plot(time_cno_all(1,:), runmean(mean(temp_saline_all),50)/mean(mean(temp_saline_all)),'color',col_sal)
plot(time_cno_all(1,:), runmean(mean(temp_basal_all),50)/mean(mean(temp_basal_all)),'color',col_basal)
plot(time_cno_all(1,:), runmean(mean(temp_cno_all),50)/mean(mean(temp_cno_all)),'color',col_cno)



%% temperature pre VS post (all session)
col_basal = [0.9 0.9 0.9];
col_sal = [1 0.6 0.6];
col_cno = [1 0 0];

figure,subplot(131)
MakeBoxPlot_MC({avTemp_wake_pre_basal avTemp_wake_pre_saline avTemp_wake_pre_cno avTemp_wake_post_basal avTemp_wake_post_saline avTemp_wake_post_cno},...
    {col_basal col_sal col_cno col_basal col_sal col_cno},[1,2,3,5,6,7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylim([27 33])
title('Wake')
%%Rank sum test
%%pre
p = ranksum(avTemp_wake_pre_basal, avTemp_wake_pre_saline);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_wake_pre_basal, avTemp_wake_pre_cno);
if p<0.05
    sigstar_DB({[1 3]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_wake_pre_saline, avTemp_wake_pre_cno);
if p<0.05
    sigstar_DB({[2 3]},p,0,'LineWigth',16,'StarSize',24);
end
%%post
p = ranksum(avTemp_wake_post_basal, avTemp_wake_post_saline);
if p<0.05
    sigstar_DB({[5 6]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_wake_post_basal, avTemp_wake_post_cno);
if p<0.05
    sigstar_DB({[5 7]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_wake_post_saline, avTemp_wake_post_cno);
if p<0.05
    sigstar_DB({[6 7]},p,0,'LineWigth',16,'StarSize',24);
end


subplot(132)
MakeBoxPlot_MC({avTemp_sws_pre_basal avTemp_sws_pre_saline avTemp_sws_pre_cno avTemp_sws_post_basal avTemp_sws_post_saline avTemp_sws_post_cno},...
    {col_basal col_sal col_cno col_basal col_sal col_cno},[1,2,3,5,6,7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylim([27 33])
title('NREM')
%%Rank sum test
%%pre
p = ranksum(avTemp_sws_pre_basal, avTemp_sws_pre_saline);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_sws_pre_basal, avTemp_sws_pre_cno);
if p<0.05
    sigstar_DB({[1 3]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_sws_pre_saline, avTemp_sws_pre_cno);
if p<0.05
    sigstar_DB({[2 3]},p,0,'LineWigth',16,'StarSize',24);
end
%%post
p = ranksum(avTemp_sws_post_basal, avTemp_sws_post_saline);
if p<0.05
    sigstar_DB({[5 6]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_sws_post_basal, avTemp_sws_post_cno);
if p<0.05
    sigstar_DB({[5 7]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_sws_post_saline, avTemp_sws_post_cno);
if p<0.05
    sigstar_DB({[6 7]},p,0,'LineWigth',16,'StarSize',24);
end

subplot(133)

MakeBoxPlot_MC({avTemp_rem_pre_basal avTemp_rem_pre_saline avTemp_rem_pre_cno avTemp_rem_post_basal avTemp_rem_post_saline avTemp_rem_post_cno},...
    {col_basal col_sal col_cno col_basal col_sal col_cno},[1,2,3,5,6,7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylim([27 33])
title('REM')
%%Rank sum test
%%pre
p = ranksum(avTemp_rem_pre_basal, avTemp_rem_pre_saline);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_rem_pre_basal, avTemp_rem_pre_cno);
if p<0.05
    sigstar_DB({[1 3]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_rem_pre_saline, avTemp_rem_pre_cno);
if p<0.05
    sigstar_DB({[2 3]},p,0,'LineWigth',16,'StarSize',24);
end
%%post
p = ranksum(avTemp_rem_post_basal, avTemp_rem_post_saline);
if p<0.05
    sigstar_DB({[5 6]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_rem_post_basal, avTemp_rem_post_cno);
if p<0.05
    sigstar_DB({[5 7]},p,0,'LineWigth',16,'StarSize',24);
end

p = ranksum(avTemp_rem_post_saline, avTemp_rem_post_cno);
if p<0.05
    sigstar_DB({[6 7]},p,0,'LineWigth',16,'StarSize',24);
end

%%

figure,subplot(131)
MakeBoxPlot_MC({avTemp_wake_pre_basal avTemp_wake_pre_saline avTemp_wake_pre_cno avTemp_wake_3hpost_basal avTemp_wake_3hpost_saline avTemp_wake_3hpost_cno},...
    {col_basal col_sal col_cno col_basal col_sal col_cno},[1,2,3,5,6,7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylim([27 33])
title('Wake')

subplot(132)
MakeBoxPlot_MC({avTemp_sws_pre_basal avTemp_sws_pre_saline avTemp_sws_pre_cno avTemp_sws_3hpost_basal avTemp_sws_3hpost_saline avTemp_sws_3hpost_cno},...
    {col_basal col_sal col_cno col_basal col_sal col_cno},[1,2,3,5,6,7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylim([27 33])
title('NREM')

subplot(133)
MakeBoxPlot_MC({avTemp_rem_pre_basal avTemp_rem_pre_saline avTemp_rem_pre_cno avTemp_rem_3hpost_basal avTemp_rem_3hpost_saline avTemp_rem_3hpost_cno},...
    {col_basal col_sal col_cno col_basal col_sal col_cno},[1,2,3,5,6,7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylim([27 33])
title('REM')

