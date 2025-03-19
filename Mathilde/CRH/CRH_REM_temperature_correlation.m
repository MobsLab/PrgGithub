%% input dir
% % dirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% % dirCNO_bigVolume = RestrictPathForExperiment(dirCNO,'nMice',[1105 1106 1148 1149]);
% % dirCNO_smallVolume = RestrictPathForExperiment(dirCNO,'nMice',[1217 1218 1219 1220]);
% % 
% % dirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % dirSaline=RestrictPathForExperiment(dirSaline,'nMice',[1150 1217 1218 1219 1220]);


% %%DIR EXCI DREADDS CRH VLPO SAL/CNO (basal sleep)
dirSaline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
dirSaline = RestrictPathForExperiment(dirSaline, 'nMice', [1218 1219 1220 1371 1372 1373 1374]);%1217

dirCNO = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');
dirCNO_smallVolume = RestrictPathForExperiment(dirCNO, 'nMice', [1218 1219 1220 1371 1372 1373 1374]);%1217
dirCNO_bigVolume = RestrictPathForExperiment(dirCNO,'nMice',[1105 1106 1148 1149 ]);%1150


%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

same_ending = 182288;

%% saline
for j = 1:length(dirSaline.path)
    cd(dirSaline.path{j}{1});
    %%load behaviour
    if exist('behavResources.mat')
        behav_saline{j} = load('behavResources.mat','MouseTemp_tsd');
    else
    end
    
    if isempty(behav_saline{j})==0
    %%load sleep scoring
    stage_saline{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%define time periods
    durtotal_saline{j} = max([max(End(stage_saline{j}.Wake)),max(End(stage_saline{j}.SWSEpoch))]);
    epoch_PreInj_saline{j} = intervalSet(0, en_epoch_preInj); %pre injection
    epoch_PostInj_saline{j} = intervalSet(st_epoch_postInj,durtotal_saline{j}); %post injection
    epoch_3hPostInj_saline{j}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %3h post injection
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_saline{j}=ComputeSleepStagesPercentagesWithoutWakeMC(stage_saline{j}.Wake,stage_saline{j}.SWSEpoch,stage_saline{j}.REMEpoch);
    %percentage pre injection
    percREM_totSleep_saline_pre(j)=Restemp_totSleep_saline{j}(3,2); %percREM_totSleep_CNO_pre(percREM_totSleep_CNO_pre==0)=NaN;
    %percentage post injection
    percREM_totSleep_saline_post(j)=Restemp_totSleep_saline{j}(3,3); %percREM_totSleep_CNO_post(percREM_totSleep_CNO_post==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_saline_3hPostInj(j)=Restemp_totSleep_saline{j}(3,4); %percREM_totSleep_CNO_3hPostInj(percREM_totSleep_CNO_3hPostInj==0)=NaN;
    
    %%temperature for each stage
    temp_saline{j} = Data(behav_saline{j}.MouseTemp_tsd);
    time_saline{j} = Range(behav_saline{j}.MouseTemp_tsd);
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
    else
    end
end

%%
%%saline injection
for jj=1:length(temp_rem_pre_saline)
        if isempty(temp_rem_pre_saline{jj})==0

    temp_cno_bigVolume_all(jj,:) = temp_saline{jj}(1:same_ending,:);
    time_cno_bigVolume_all(jj,:) = time_saline{jj}(1:same_ending,:);

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
        else
        end
end


%% big volume of virus
for k = 1:length(dirCNO_bigVolume.path)
    cd(dirCNO_bigVolume.path{k}{1});
    %%load behaviour
    if exist('behavResources.mat')
        behav_bigVolume_cno{k} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    
    %%load sleep scoring
    stage_bigVolume_cno{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%define time periods
    durtotal_bigVolume_cno{k} = max([max(End(stage_bigVolume_cno{k}.Wake)),max(End(stage_bigVolume_cno{k}.SWSEpoch))]);
    epoch_PreInj_bigVolume_cno{k} = intervalSet(0, en_epoch_preInj); %pre injection
    epoch_PostInj_bigVolume_cno{k} = intervalSet(st_epoch_postInj,durtotal_bigVolume_cno{k}); %post injection
    epoch_3hPostInj_bigVolume_cno{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %3h post injection
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_bigVolume_cno{k}=ComputeSleepStagesPercentagesWithoutWakeMC(stage_bigVolume_cno{k}.Wake,stage_bigVolume_cno{k}.SWSEpoch,stage_bigVolume_cno{k}.REMEpoch);
    %percentage pre injection
    percREM_totSleep_bigVolume_CNO_pre(k)=Restemp_totSleep_bigVolume_cno{k}(3,2); %percREM_totSleep_CNO_pre(percREM_totSleep_CNO_pre==0)=NaN;
    %percentage post injection
    percREM_totSleep_bigVolume_CNO_post(k)=Restemp_totSleep_bigVolume_cno{k}(3,3); %percREM_totSleep_CNO_post(percREM_totSleep_CNO_post==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_bigVolume_CNO_3hPostInj(k)=Restemp_totSleep_bigVolume_cno{k}(3,4); %percREM_totSleep_CNO_3hPostInj(percREM_totSleep_CNO_3hPostInj==0)=NaN;
    
    %%temperature for each stage
    temp_bigVolume_cno{k} = Data(behav_bigVolume_cno{k}.MouseTemp_tsd);
    time_bigVolume_cno{k} = Range(behav_bigVolume_cno{k}.MouseTemp_tsd);
    %%temperature pre injection
    temp_rem_pre_bigVolume_cno{k} = Data(Restrict(behav_bigVolume_cno{k}.MouseTemp_tsd, and(stage_bigVolume_cno{k}.REMEpoch,epoch_PreInj_bigVolume_cno{k})));
    temp_sws_pre_bigVolume_cno{k} = Data(Restrict(behav_bigVolume_cno{k}.MouseTemp_tsd, and(stage_bigVolume_cno{k}.SWSEpoch,epoch_PreInj_bigVolume_cno{k})));
    temp_wake_pre_bigVolume_cno{k} = Data(Restrict(behav_bigVolume_cno{k}.MouseTemp_tsd, and(stage_bigVolume_cno{k}.Wake,epoch_PreInj_bigVolume_cno{k})));
    %%temperature post injection
    temp_rem_post_bigVolume_cno{k} = Data(Restrict(behav_bigVolume_cno{k}.MouseTemp_tsd, and(stage_bigVolume_cno{k}.REMEpoch,epoch_PostInj_bigVolume_cno{k})));
    temp_sws_post_bigVolume_cno{k} = Data(Restrict(behav_bigVolume_cno{k}.MouseTemp_tsd, and(stage_bigVolume_cno{k}.SWSEpoch,epoch_PostInj_bigVolume_cno{k})));
    temp_wake_post_bigVolume_cno{k} = Data(Restrict(behav_bigVolume_cno{k}.MouseTemp_tsd, and(stage_bigVolume_cno{k}.Wake,epoch_PostInj_bigVolume_cno{k})));
    %%temperature retricted 3h post injection
    temp_rem_3hpost_bigVolume_cno{k} = Data(Restrict(behav_bigVolume_cno{k}.MouseTemp_tsd, and(stage_bigVolume_cno{k}.REMEpoch,epoch_3hPostInj_bigVolume_cno{k})));
    temp_sws_3hpost_bigVolume_cno{k} = Data(Restrict(behav_bigVolume_cno{k}.MouseTemp_tsd, and(stage_bigVolume_cno{k}.SWSEpoch,epoch_3hPostInj_bigVolume_cno{k})));
    temp_wake_3hpost_bigVolume_cno{k} = Data(Restrict(behav_bigVolume_cno{k}.MouseTemp_tsd, and(stage_bigVolume_cno{k}.Wake,epoch_3hPostInj_bigVolume_cno{k})));
end

%%
%%CNO injection
for kk=1:length(temp_rem_pre_bigVolume_cno)
    temp_cno_bigVolume_all(kk,:) = temp_bigVolume_cno{kk}(1:same_ending,:);
    time_cno_bigVolume_all(kk,:) = time_bigVolume_cno{kk}(1:same_ending,:);

    %%temperature pre injection
    avTemp_rem_pre_bigVolume_cno(kk,:) = nanmean(temp_rem_pre_bigVolume_cno{kk}(:,:),1);
    avTemp_sws_pre_bigVolume_cno(kk,:) = nanmean(temp_sws_pre_bigVolume_cno{kk}(:,:),1);
    avTemp_wake_pre_bigVolume_cno(kk,:) = nanmean(temp_wake_pre_bigVolume_cno{kk}(:,:),1);
    %%temperature post injection
    avTemp_rem_post_bigVolume_cno(kk,:) = nanmean(temp_rem_post_bigVolume_cno{kk}(:,:),1);
    avTemp_sws_post_bigVolume_cno(kk,:) = nanmean(temp_sws_post_bigVolume_cno{kk}(:,:),1);
    avTemp_wake_post_bigVolume_cno(kk,:) = nanmean(temp_wake_post_bigVolume_cno{kk}(:,:),1);
    %%temperature retricted 3h post injection
    avTemp_rem_3hpost_bigVolume_cno(kk,:) = nanmean(temp_rem_3hpost_bigVolume_cno{kk}(:,:),1);
    avTemp_sws_3hpost_bigVolume_cno(kk,:) = nanmean(temp_sws_3hpost_bigVolume_cno{kk}(:,:),1);
    avTemp_wake_3hpost_bigVolume_cno(kk,:) = nanmean(temp_wake_3hpost_bigVolume_cno{kk}(:,:),1);
end


%%
%% small volume of virus
for i = 1:length(dirCNO_smallVolume.path)
    cd(dirCNO_smallVolume.path{i}{1});
    %%load behaviour
    if exist('behavResources.mat')
        behav_smallVolume_cno{i} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    
    %%load sleep scoring
    stage_smallVolume_cno{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%define time periods
    durtotal_smallVolume_cno{i} = max([max(End(stage_smallVolume_cno{i}.Wake)),max(End(stage_smallVolume_cno{i}.SWSEpoch))]);
    epoch_PreInj_smallVolume_cno{i} = intervalSet(0, en_epoch_preInj); %pre injection
    epoch_PostInj_smallVolume_cno{i} = intervalSet(st_epoch_postInj,durtotal_smallVolume_cno{i}); %post injection
    epoch_3hPostInj_smallVolume_cno{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %3h post injection
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_smallVolume_cno{i}=ComputeSleepStagesPercentagesWithoutWakeMC(stage_smallVolume_cno{i}.Wake,stage_smallVolume_cno{i}.SWSEpoch,stage_smallVolume_cno{i}.REMEpoch);
    %percentage pre injection
    percREM_totSleep_smallVolume_CNO_pre(i)=Restemp_totSleep_smallVolume_cno{i}(3,2); %percREM_totSleep_CNO_pre(percREM_totSleep_CNO_pre==0)=NaN;
    %percentage post injection
    percREM_totSleep_smallVolume_CNO_post(i)=Restemp_totSleep_smallVolume_cno{i}(3,3); %percREM_totSleep_CNO_post(percREM_totSleep_CNO_post==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_smallVolume_CNO_3hPostInj(i)=Restemp_totSleep_smallVolume_cno{i}(3,4); %percREM_totSleep_CNO_3hPostInj(percREM_totSleep_CNO_3hPostInj==0)=NaN;
    
    %%temperature for each stage
    temp_smallVolume_cno{i} = Data(behav_smallVolume_cno{i}.MouseTemp_tsd);
    time_smallVolume_cno{i} = Range(behav_smallVolume_cno{i}.MouseTemp_tsd);
    %%temperature pre injection
    temp_rem_pre_smallVolume_cno{i} = Data(Restrict(behav_smallVolume_cno{i}.MouseTemp_tsd, and(stage_smallVolume_cno{i}.REMEpoch,epoch_PreInj_smallVolume_cno{i})));
    temp_sws_pre_smallVolume_cno{i} = Data(Restrict(behav_smallVolume_cno{i}.MouseTemp_tsd, and(stage_smallVolume_cno{i}.SWSEpoch,epoch_PreInj_smallVolume_cno{i})));
    temp_wake_pre_smallVolume_cno{i} = Data(Restrict(behav_smallVolume_cno{i}.MouseTemp_tsd, and(stage_smallVolume_cno{i}.Wake,epoch_PreInj_smallVolume_cno{i})));
    %%temperature post injection
    temp_rem_post_smallVolume_cno{i} = Data(Restrict(behav_smallVolume_cno{i}.MouseTemp_tsd, and(stage_smallVolume_cno{i}.REMEpoch,epoch_PostInj_smallVolume_cno{i})));
    temp_sws_post_smallVolume_cno{i} = Data(Restrict(behav_smallVolume_cno{i}.MouseTemp_tsd, and(stage_smallVolume_cno{i}.SWSEpoch,epoch_PostInj_smallVolume_cno{i})));
    temp_wake_post_smallVolume_cno{i} = Data(Restrict(behav_smallVolume_cno{i}.MouseTemp_tsd, and(stage_smallVolume_cno{i}.Wake,epoch_PostInj_smallVolume_cno{i})));
    %%temperature retricted 3h post injection
    temp_rem_3hpost_smallVolume_cno{i} = Data(Restrict(behav_smallVolume_cno{i}.MouseTemp_tsd, and(stage_smallVolume_cno{i}.REMEpoch,epoch_3hPostInj_smallVolume_cno{i})));
    temp_sws_3hpost_smallVolume_cno{i} = Data(Restrict(behav_smallVolume_cno{i}.MouseTemp_tsd, and(stage_smallVolume_cno{i}.SWSEpoch,epoch_3hPostInj_smallVolume_cno{i})));
    temp_wake_3hpost_smallVolume_cno{i} = Data(Restrict(behav_smallVolume_cno{i}.MouseTemp_tsd, and(stage_smallVolume_cno{i}.Wake,epoch_3hPostInj_smallVolume_cno{i})));
end

%%
%%CNO injection
for ii=1:length(temp_rem_pre_smallVolume_cno)
    temp_cno_smallVolume_all(ii,:) = temp_smallVolume_cno{ii}(1:same_ending,:);
    time_cno_smallVolume_all(ii,:) = time_smallVolume_cno{ii}(1:same_ending,:);

    %%temperature pre injection
    avTemp_rem_pre_smallVolume_cno(ii,:) = nanmean(temp_rem_pre_smallVolume_cno{ii}(:,:),1);
    avTemp_sws_pre_smallVolume_cno(ii,:) = nanmean(temp_sws_pre_smallVolume_cno{ii}(:,:),1);
    avTemp_wake_pre_smallVolume_cno(ii,:) = nanmean(temp_wake_pre_smallVolume_cno{ii}(:,:),1);
    %%temperature post injection
    avTemp_rem_post_smallVolume_cno(ii,:) = nanmean(temp_rem_post_smallVolume_cno{ii}(:,:),1);
    avTemp_sws_post_smallVolume_cno(ii,:) = nanmean(temp_sws_post_smallVolume_cno{ii}(:,:),1);
    avTemp_wake_post_smallVolume_cno(ii,:) = nanmean(temp_wake_post_smallVolume_cno{ii}(:,:),1);
    %%temperature retricted 3h post injection
    avTemp_rem_3hpost_smallVolume_cno(ii,:) = nanmean(temp_rem_3hpost_smallVolume_cno{ii}(:,:),1);
    avTemp_sws_3hpost_smallVolume_cno(ii,:) = nanmean(temp_sws_3hpost_smallVolume_cno{ii}(:,:),1);
    avTemp_wake_3hpost_smallVolume_cno(ii,:) = nanmean(temp_wake_3hpost_smallVolume_cno{ii}(:,:),1);
end




%% correlation %REM vs temperature

figure
subplot(121)
s1=plot(percREM_totSleep_saline_pre, avTemp_rem_pre_saline,'ko', percREM_totSleep_bigVolume_CNO_pre, avTemp_rem_pre_bigVolume_cno,'ro',percREM_totSleep_smallVolume_CNO_pre, avTemp_rem_pre_smallVolume_cno,'bo');
set(s1,'MarkerSize',8,'Linewidth',2);
hold on
% l=lsline;
% set(l,'LineWidth',1.5)
xlabel('')
ylabel('')
ylim([26 34])
xlim([0 20])
title('pre')

subplot(122)
s1=plot(percREM_totSleep_saline_post, avTemp_rem_post_saline,'ko', percREM_totSleep_bigVolume_CNO_post, avTemp_rem_post_bigVolume_cno,'ro',percREM_totSleep_smallVolume_CNO_post, avTemp_rem_post_smallVolume_cno,'bo');
set(s1,'MarkerSize',8,'Linewidth',2);
hold on
% l=lsline;
% set(l,'LineWidth',1.5)
xlabel('')
ylabel('')
ylim([26 34])
xlim([0 20])
title('post')


%% correlation %REM vs temperature : change between pre - post

% REM_saline = percREM_totSleep_saline_pre - percREM_totSleep_saline_post;
% REM_smallVolume = percREM_totSleep_smallVolume_CNO_pre - percREM_totSleep_smallVolume_CNO_post;
% REM_bigVolume = percREM_totSleep_bigVolume_CNO_pre - percREM_totSleep_bigVolume_CNO_post;
% 
% temp_saline = avTemp_rem_pre_saline - avTemp_rem_post_saline;
% temp_smallVolume = avTemp_rem_pre_smallVolume_cno - avTemp_rem_post_smallVolume_cno;
% temp_bigVolume = avTemp_rem_pre_bigVolume_cno - avTemp_rem_post_bigVolume_cno;

change_percREM_saline = ((percREM_totSleep_saline_post - percREM_totSleep_saline_pre) ./ percREM_totSleep_saline_pre).*100;
change_perc_smallVolume = ((percREM_totSleep_smallVolume_CNO_post - percREM_totSleep_smallVolume_CNO_pre) ./ percREM_totSleep_smallVolume_CNO_pre).*100;
change_percREM_bigVolume = ((percREM_totSleep_bigVolume_CNO_post - percREM_totSleep_bigVolume_CNO_pre) ./ percREM_totSleep_bigVolume_CNO_pre).*100;

change_temp_saline = ((avTemp_rem_post_saline - avTemp_rem_pre_saline) ./ avTemp_rem_pre_saline).*100;
change_temp_smallVolume = ((avTemp_rem_post_smallVolume_cno - avTemp_rem_pre_smallVolume_cno) ./ avTemp_rem_pre_smallVolume_cno).*100;
change_temp_bigVolume = ((avTemp_rem_post_bigVolume_cno - avTemp_rem_pre_bigVolume_cno) ./ avTemp_rem_pre_bigVolume_cno).*100;



figure
s1=plot(change_percREM_saline, change_temp_saline,'ko',change_perc_smallVolume, change_temp_smallVolume,'bs', change_percREM_bigVolume, change_temp_bigVolume,'ro');
set(s1,'MarkerSize',8,'Linewidth',2.5);
hold on
% l=lsline;
% set(l,'LineWidth',1.5)
xlabel('REM sleep pecentage change (%)')
ylabel('Temperature pecentage change (%)')
% ylim([26 34])
% xlim([0 20])
title('')
legend('saline','small volume','big volume')

