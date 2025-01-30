%% input dir

% %%DIR EXCI DREADDS CRH VLPO SAL/CNO (basal sleep)
dirSaline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
dirSaline = RestrictPathForExperiment(dirSaline, 'nMice', [1217 1218 1219 1220 1371 1372 1373 1374]);

dirCNO = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');
dirCNO = RestrictPathForExperiment(dirCNO, 'nMice', [1217 1218 1219 1220 1371 1372 1373 1374]);

%% parameters
tempbin = 3600;

%%sleep W/ injection at 1pm
t_inj = 13;
t_start = 8;
t_end = 18;

%% get Data
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
    stage_saline{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    
    %%define time periods
    vec_tps_recording_saline{j} = Range(stage_saline{j}.tsdMovement); %get vector to keep track of the reocrding time
    VecTimeDay_saline{j} = GetTimeOfTheDay_MC(vec_tps_recording_saline{j});
    
    idx_injection_time_saline{j} = find(ceil(VecTimeDay_saline{j})==t_inj,1,'first'); %get index for the injection time
    idx_same_st_saline{j} = find(ceil(VecTimeDay_saline{j})>=t_start,1,'first'); % get index to get same beg and end of the time period to analyze
    idx_same_en_saline{j} = find(ceil(VecTimeDay_saline{j})==t_end,1,'last');
    
    
    injection_time_saline{j} = vec_tps_recording_saline{j}(idx_injection_time_saline{j}); %get the corresponding values
    same_st_saline{j} = vec_tps_recording_saline{j}(idx_same_st_saline{j});
    same_en_saline{j} = vec_tps_recording_saline{j}(idx_same_en_saline{j});
    
    same_epoch_saline{j} =  intervalSet(same_st_saline{j}, same_en_saline{j});
    same_epoch_pre_saline{j} =  intervalSet(same_st_saline{j}, injection_time_saline{j});
    same_epoch_post_saline{j} =  intervalSet(injection_time_saline{j}, same_en_saline{j});
        
    
    %temperature
    temp_saline{j} = Data(behav_saline{j}.MouseTemp_tsd);
    %%temperature pre injection
    temp_rem_pre_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.REMEpoch,same_epoch_pre_saline{j})));
    temp_sws_pre_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.SWSEpoch,same_epoch_pre_saline{j})));
    temp_wake_pre_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.Wake,same_epoch_pre_saline{j})));
    %%temperature post injection
    temp_rem_post_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.REMEpoch,same_epoch_post_saline{j})));
    temp_sws_post_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.SWSEpoch,same_epoch_post_saline{j})));
    temp_wake_post_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.Wake,same_epoch_post_saline{j})));
%     %%temperature retricted 3h post injection
%     temp_rem_3hpost_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.REMEpoch,epoch_3hPostInj_saline{j})));
%     temp_sws_3hpost_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.SWSEpoch,epoch_3hPostInj_saline{j})));
%     temp_wake_3hpost_saline{j} = Data(Restrict(behav_saline{j}.MouseTemp_tsd, and(stage_saline{j}.Wake,epoch_3hPostInj_saline{j})));
        
    
    %%compute percentage mean duration and number of bouts
%     %%wake all session
%     [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stage_saline{j}.Wake,same_epoch_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_saline{j}),'wake',tempbin,same_st_saline,same_en_saline{j});
%     dur_WAKE_all_saline(j)=dur_moyenne_ep_WAKE;
%     num_WAKE_all_saline(j)=num_moyen_ep_WAKE;
%     perc_WAKE_all_saline(j)=perc_moyen_WAKE;
    %%wake pre injection
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_saline{j}.Wake,same_epoch_pre_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_pre_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_pre_saline{j}),'wake',tempbin,same_st_saline{j},injection_time_saline{j});
    dur_WAKE_pre_saline(j)=dur_moyenne_ep_WAKE;
    num_WAKE_pre_saline(j)=num_moyen_ep_WAKE;
    perc_WAKE_pre_saline(j)=perc_moyen_WAKE;
    %%wake post injection
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_saline{j}.Wake,same_epoch_post_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_post_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_post_saline{j}),'wake',tempbin,injection_time_saline{j},same_en_saline{j});
    dur_WAKE_post_saline(j)=dur_moyenne_ep_WAKE;
    num_WAKE_post_saline(j)=num_moyen_ep_WAKE;
    perc_WAKE_post_saline(j)=perc_moyen_WAKE;
%     %%NREM all session
%     [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stage_saline{j}.Wake,same_epoch_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_saline{j}),'SWS',tempbin,same_st_saline,same_en_saline{j});
%     dur_SWS_all_saline(j)=dur_moyenne_ep_SWS;
%     num_SWS_all_saline(j)=num_moyen_ep_SWS;
%     perc_SWS_all_saline(j)=perc_moyen_SWS;
    %%NREM pre injection
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_saline{j}.Wake,same_epoch_pre_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_pre_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_pre_saline{j}),'SWS',tempbin,same_st_saline{j},injection_time_saline{j});
    dur_SWS_pre_saline(j)=dur_moyenne_ep_SWS;
    num_SWS_pre_saline(j)=num_moyen_ep_SWS;
    perc_SWS_pre_saline(j)=perc_moyen_SWS;
    %%NREM pre injection
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_saline{j}.Wake,same_epoch_post_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_post_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_post_saline{j}),'SWS',tempbin,injection_time_saline{j},same_en_saline{j});
    dur_SWS_post_saline(j)=dur_moyenne_ep_SWS;
    num_SWS_post_saline(j)=num_moyen_ep_SWS;
    perc_SWS_post_saline(j)=perc_moyen_SWS;
%     %%REM all session
%     [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stage_saline{j}.Wake,same_epoch_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_saline{j}),'REM',tempbin,same_st_saline,same_en_saline{j});
%     dur_REM_all_saline(j)=dur_moyenne_ep_REM;
%     num_REM_all_saline(j)=num_moyen_ep_REM;
%     perc_REM_all_saline(j)=perc_moyen_REM;
    %%REM pre injection
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_saline{j}.Wake,same_epoch_pre_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_pre_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_pre_saline{j}),'REM',tempbin,same_st_saline{j},injection_time_saline{j});
    dur_REM_pre_saline(j)=dur_moyenne_ep_REM;
    num_REM_pre_saline(j)=num_moyen_ep_REM;
    perc_REM_pre_saline(j)=perc_moyen_REM;
    %%REM post injection
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_saline{j}.Wake,same_epoch_post_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_post_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_post_saline{j}),'REM',tempbin,injection_time_saline{j},same_en_saline{j});
    dur_REM_post_saline(j)=dur_moyenne_ep_REM;
    num_REM_post_saline(j)=num_moyen_ep_REM;
    perc_REM_post_saline(j)=perc_moyen_REM;
    
    
%     %%total sleep duration
%     [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stage_saline{j}.Wake,same_epoch_pre_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_pre_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_pre_saline{j}),same_st_saline{j},injection_time_saline{j});
%     tot_sleep_dur_pre_saline(j)=sleep_Tduration;
% 
%     [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stage_saline{j}.Wake,same_epoch_post_saline{j}),and(stage_saline{j}.SWSEpoch,same_epoch_post_saline{j}),and(stage_saline{j}.REMEpoch,same_epoch_post_saline{j}),injection_time_saline{j},same_en_saline{j});
%     tot_sleep_dur_post_saline(j)=sleep_Tduration;

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
    stage_cno{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    
    %%define time periods
    vec_tps_recording_cno{k} = Range(stage_cno{k}.tsdMovement); %get vector to keep track of the reocrding time
    VecTimeDay_cno{k} = GetTimeOfTheDay_MC(vec_tps_recording_cno{k});
    
    idx_injection_time_cno{k} = find(ceil(VecTimeDay_cno{k})==t_inj,1,'first'); %get index for the injection time
    idx_same_st_cno{k} = find(ceil(VecTimeDay_cno{k})>=t_start,1,'first'); % get index to get same beg and end of the time period to analyze
    idx_same_en_cno{k} = find(ceil(VecTimeDay_cno{k})==t_end,1,'last');
    
    
    injection_time_cno{k} = vec_tps_recording_cno{k}(idx_injection_time_cno{k}); %get the corresponding values
    same_st_cno{k} = vec_tps_recording_cno{k}(idx_same_st_cno{k});
    same_en_cno{k} = vec_tps_recording_cno{k}(idx_same_en_cno{k});
    
    same_epoch_cno{k} =  intervalSet(same_st_cno{k}, same_en_cno{k});
    same_epoch_pre_cno{k} =  intervalSet(same_st_cno{k}, injection_time_cno{k});
    same_epoch_post_cno{k} =  intervalSet(injection_time_cno{k}, same_en_cno{k});
    
    temp_cno{k} = Data(behav_cno{k}.MouseTemp_tsd);
    time_cno{k} = Range(behav_cno{k}.MouseTemp_tsd);
    %%temperature pre injection
    temp_rem_pre_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.REMEpoch,same_epoch_pre_cno{k})));
    temp_sws_pre_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.SWSEpoch,same_epoch_pre_cno{k})));
    temp_wake_pre_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.Wake,same_epoch_pre_cno{k})));
    %%temperature post injection
    temp_rem_post_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.REMEpoch,same_epoch_post_cno{k})));
    temp_sws_post_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.SWSEpoch,same_epoch_post_cno{k})));
    temp_wake_post_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.Wake,same_epoch_post_cno{k})));
%     %%temperature retricted 3h post injection
%     temp_rem_3hpost_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.REMEpoch,epoch_3hPostInk_cno{k})));
%     temp_sws_3hpost_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.SWSEpoch,epoch_3hPostInk_cno{k})));
%     temp_wake_3hpost_cno{k} = Data(Restrict(behav_cno{k}.MouseTemp_tsd, and(stage_cno{k}.Wake,epoch_3hPostInk_cno{k})));
    
    %%compute percentage mean duration and number of bouts
%     %%wake all session
%     [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stage_cno{k}.Wake,same_epoch_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_cno{k}),'wake',tempbin,same_st_cno,same_en_cno{k});
%     dur_WAKE_all_cno(k)=dur_moyenne_ep_WAKE;
%     num_WAKE_all_cno(k)=num_moyen_ep_WAKE;
%     perc_WAKE_all_cno(k)=perc_moyen_WAKE;
    %%wake pre injection
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_cno{k}.Wake,same_epoch_pre_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_pre_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_pre_cno{k}),'wake',tempbin,same_st_cno{k},injection_time_cno{k});
    dur_WAKE_pre_cno(k)=dur_moyenne_ep_WAKE;
    num_WAKE_pre_cno(k)=num_moyen_ep_WAKE;
    perc_WAKE_pre_cno(k)=perc_moyen_WAKE;
    %%wake post injection
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_cno{k}.Wake,same_epoch_post_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_post_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_post_cno{k}),'wake',tempbin,injection_time_cno{k},same_en_cno{k});
    dur_WAKE_post_cno(k)=dur_moyenne_ep_WAKE;
    num_WAKE_post_cno(k)=num_moyen_ep_WAKE;
    perc_WAKE_post_cno(k)=perc_moyen_WAKE;
%     %%NREM all session
%     [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stage_cno{k}.Wake,same_epoch_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_cno{k}),'SWS',tempbin,same_st_cno,same_en_cno{k});
%     dur_SWS_all_cno(k)=dur_moyenne_ep_SWS;
%     num_SWS_all_cno(k)=num_moyen_ep_SWS;
%     perc_SWS_all_cno(k)=perc_moyen_SWS;
    %%NREM pre injection
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_cno{k}.Wake,same_epoch_pre_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_pre_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_pre_cno{k}),'SWS',tempbin,same_st_cno{k},injection_time_cno{k});
    dur_SWS_pre_cno(k)=dur_moyenne_ep_SWS;
    num_SWS_pre_cno(k)=num_moyen_ep_SWS;
    perc_SWS_pre_cno(k)=perc_moyen_SWS;
    %%NREM pre injection
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_cno{k}.Wake,same_epoch_post_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_post_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_post_cno{k}),'SWS',tempbin,injection_time_cno{k},same_en_cno{k});
    dur_SWS_post_cno(k)=dur_moyenne_ep_SWS;
    num_SWS_post_cno(k)=num_moyen_ep_SWS;
    perc_SWS_post_cno(k)=perc_moyen_SWS;
%     %%REM all session
%     [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stage_cno{k}.Wake,same_epoch_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_cno{k}),'REM',tempbin,same_st_cno,same_en_cno{k});
%     dur_REM_all_cno(k)=dur_moyenne_ep_REM;
%     num_REM_all_cno(k)=num_moyen_ep_REM;
%     perc_REM_all_cno(k)=perc_moyen_REM;
    %%REM pre injection
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_cno{k}.Wake,same_epoch_pre_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_pre_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_pre_cno{k}),'REM',tempbin,same_st_cno{k},injection_time_cno{k});
    dur_REM_pre_cno(k)=dur_moyenne_ep_REM;
    num_REM_pre_cno(k)=num_moyen_ep_REM;
    perc_REM_pre_cno(k)=perc_moyen_REM;
    %%REM post injection
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stage_cno{k}.Wake,same_epoch_post_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_post_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_post_cno{k}),'REM',tempbin,injection_time_cno{k},same_en_cno{k});
    dur_REM_post_cno(k)=dur_moyenne_ep_REM;
    num_REM_post_cno(k)=num_moyen_ep_REM;
    perc_REM_post_cno(k)=perc_moyen_REM;
    
    
%     %%total sleep duration
%     [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stage_cno{k}.Wake,same_epoch_pre_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_pre_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_pre_cno{k}),same_st_cno{k},injection_time_cno{k});
%     tot_sleep_dur_pre_cno(k)=sleep_Tduration;
% 
%     [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stage_cno{k}.Wake,same_epoch_post_cno{k}),and(stage_cno{k}.SWSEpoch,same_epoch_post_cno{k}),and(stage_cno{k}.REMEpoch,same_epoch_post_cno{k}),injection_time_cno{k},same_en_cno{k});
%     tot_sleep_dur_post_cno(k)=sleep_Tduration;

end


%% calculate mean

%%saline injection
for jj=1:length(temp_rem_pre_saline)
    temp_saline_all(jj,:) = nanmean(temp_saline{jj}(:,:),1);
    %%temperature pre injection
    avTemp_rem_pre_saline(jj,:) = nanmean(temp_rem_pre_saline{jj}(:,:),1);
    avTemp_sws_pre_saline(jj,:) = nanmean(temp_sws_pre_saline{jj}(:,:),1);
    avTemp_wake_pre_saline(jj,:) = nanmean(temp_wake_pre_saline{jj}(:,:),1);
    %%temperature post injection
    avTemp_rem_post_saline(jj,:) = nanmean(temp_rem_post_saline{jj}(:,:),1);
    avTemp_sws_post_saline(jj,:) = nanmean(temp_sws_post_saline{jj}(:,:),1);
    avTemp_wake_post_saline(jj,:) = nanmean(temp_wake_post_saline{jj}(:,:),1);
%     %%temperature retricted 3h post injection
%     avTemp_rem_3hpost_saline(jj,:) = nanmean(temp_rem_3hpost_saline{jj}(:,:),1);
%     avTemp_sws_3hpost_saline(jj,:) = nanmean(temp_sws_3hpost_saline{jj}(:,:),1);
%     avTemp_wake_3hpost_saline(jj,:) = nanmean(temp_wake_3hpost_saline{jj}(:,:),1);
end

%%CNO injection
for kk=1:length(temp_rem_pre_cno)
    temp_cno_all(kk,:) = nanmean(temp_cno{kk}(:,:),1);
    time_cno_all(kk,:) = nanmean(time_cno{kk}(:,:),1);
    %%temperature pre injection
    avTemp_rem_pre_cno(kk,:) = nanmean(temp_rem_pre_cno{kk}(:,:),1);
    avTemp_sws_pre_cno(kk,:) = nanmean(temp_sws_pre_cno{kk}(:,:),1);
    avTemp_wake_pre_cno(kk,:) = nanmean(temp_wake_pre_cno{kk}(:,:),1);
    %%temperature post injection
    avTemp_rem_post_cno(kk,:) = nanmean(temp_rem_post_cno{kk}(:,:),1);
    avTemp_sws_post_cno(kk,:) = nanmean(temp_sws_post_cno{kk}(:,:),1);
    avTemp_wake_post_cno(kk,:) = nanmean(temp_wake_post_cno{kk}(:,:),1);
%     %%temperature retricted 3h post injection
%     avTemp_rem_3hpost_cno(kk,:) = nanmean(temp_rem_3hpost_cno{kk}(:,:),1);
%     avTemp_sws_3hpost_cno(kk,:) = nanmean(temp_sws_3hpost_cno{kk}(:,:),1);
%     avTemp_wake_3hpost_cno(kk,:) = nanmean(temp_wake_3hpost_cno{kk}(:,:),1);
end

%% figures
%% av temperature overtime
figure, hold on
shadedErrorBar(time_cno(1,:), runmean(mean(temp_saline),100),stdError((temp_saline)),'b',1)
shadedErrorBar(time_cno(1,:), runmean(mean(temp_cno),100),stdError((temp_cno)),'r',1)

%%
col_sal = [1 0.6 0.6];
col_cno = [1 0 0];

figure %mean
hold on
plot(time_cno_all(1,:), runmean(mean(temp_saline_all),50),'color',col_sal)
plot(time_cno_all(1,:), runmean(mean(temp_cno_all),50),'color',col_cno)

% 
% figure
% hold on
% plot(time_cno_all(1,:), runmean(mean(temp_saline_all),50)/mean(mean(temp_saline_all)),'color',col_sal)
% plot(time_cno_all(1,:), runmean(mean(temp_cno_all),50)/mean(mean(temp_cno_all)),'color',col_cno)
% 

%%
col_sal = [0.9 0.9 0.9];
col_cno = [1 0.6 0.6];

figure %separation between mice
hold on 
for j = 1:length(dirSaline.path)
    hold on, plot(time_cno_all(1,:), runmean(temp_saline_all(j,:),50),'color',col_sal)
end

for k = 1:length(dirCNO.path)
    hold on, plot(time_cno_all(1,:), runmean(temp_cno_all(k,:),50),'color',col_cno)
end
plot(time_cno_all(1,:), runmean(mean(temp_saline_all),50),'linewidth',2,'color','k')
plot(time_cno_all(1,:), runmean(mean(temp_cno_all),50),'linewidth',2,'color','r')


%% temperature pre VS post (all session) ERRORBAR
col_sal = [0.9 0.9 0.9];
col_cno = [1 0 0];

figure,subplot(131)
PlotErrorBarN_KJ({avTemp_wake_pre_saline avTemp_wake_pre_cno avTemp_wake_post_saline avTemp_wake_post_cno},...
    'newfig',0,'paired',1,'barcolors',{col_sal col_cno col_sal col_cno},'x_data',[1,2,4,5]);
xticks([1.5 4.5]); xticklabels({'pre','post'})
ylim([25 33])
title('Wake')
%%Rank sum test
%%pre
p = ranksum(avTemp_wake_pre_saline, avTemp_wake_pre_cno);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
%%post
p = ranksum(avTemp_wake_post_saline, avTemp_wake_post_cno);
if p<0.05
    sigstar_DB({[4 5]},p,0,'LineWigth',16,'StarSize',24);
end

subplot(132)
PlotErrorBarN_KJ({avTemp_sws_pre_saline avTemp_sws_pre_cno avTemp_sws_post_saline avTemp_sws_post_cno},...
    'newfig',0,'paired',1,'barcolors',{col_sal col_cno col_sal col_cno},'x_data',[1,2,4,5]);
xticks([1.5 4.5]); xticklabels({'pre','post'})
ylim([25 33])
title('NREM')
%%Rank sum test
%%pre
p = ranksum(avTemp_sws_pre_saline, avTemp_sws_pre_cno);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
%%post
p = ranksum(avTemp_sws_post_saline, avTemp_sws_post_cno);
if p<0.05
    sigstar_DB({[4 5]},p,0,'LineWigth',16,'StarSize',24);
end

subplot(133)
PlotErrorBarN_KJ({avTemp_rem_pre_saline avTemp_rem_pre_cno avTemp_rem_post_saline avTemp_rem_post_cno},...
    'newfig',0,'paired',1,'barcolors',{col_sal col_cno col_sal col_cno},'x_data',[1,2,4,5]);
xticks([1.5 4.5]); xticklabels({'pre','post'})
ylim([25 33])
title('REM')
%%Rank sum test
%%pre
p = ranksum(avTemp_rem_pre_saline, avTemp_rem_pre_cno);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
%%post
p = ranksum(avTemp_rem_post_saline, avTemp_rem_post_cno);
if p<0.05
    sigstar_DB({[4 5]},p,0,'LineWigth',16,'StarSize',24);
end

%% temperature pre VS post (all session) BOXPLOT
% col_sal = [0.9 0.9 0.9];
% col_cno = [1 0 0];
% 
% 
% figure,subplot(131)
% MakeBoxPlot_MC({avTemp_wake_pre_saline avTemp_wake_pre_cno avTemp_wake_post_saline avTemp_wake_post_cno},...
%     {col_sal col_cno col_sal col_cno},[1,2,4,5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'pre','post'})
% ylim([26 33])
% title('Wake')
% %%Rank sum test
% %%pre
% p = ranksum(avTemp_wake_pre_saline, avTemp_wake_pre_cno);
% if p<0.05
%     sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
% end
% %%post
% p = ranksum(avTemp_wake_post_saline, avTemp_wake_post_cno);
% if p<0.05
%     sigstar_DB({[4 5]},p,0,'LineWigth',16,'StarSize',24);
% end
% 
% 
% subplot(132)
% MakeBoxPlot_MC({avTemp_sws_pre_saline avTemp_sws_pre_cno avTemp_sws_post_saline avTemp_sws_post_cno},...
%     {col_sal col_cno col_sal col_cno},[1,2,4,5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'pre','post'})
% ylim([26 33])
% title('NREM')
% %%Rank sum test
% %%pre
% p = ranksum(avTemp_sws_pre_saline, avTemp_sws_pre_cno);
% if p<0.05
%     sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
% end
% %%post
% p = ranksum(avTemp_sws_post_saline, avTemp_sws_post_cno);
% if p<0.05
%     sigstar_DB({[4 5]},p,0,'LineWigth',16,'StarSize',24);
% end
% 
% subplot(133)
% MakeBoxPlot_MC({avTemp_rem_pre_saline avTemp_rem_pre_cno avTemp_rem_post_saline avTemp_rem_post_cno},...
%     {col_sal col_cno col_sal col_cno},[1,2,4,5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'pre','post'})
% ylim([26 33])
% title('REM')
% %%Rank sum test
% %%pre
% p = ranksum(avTemp_rem_pre_saline, avTemp_rem_pre_cno);
% if p<0.05
%     sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
% end
% %%post
% p = ranksum(avTemp_rem_post_saline, avTemp_rem_post_cno);
% if p<0.05
%     sigstar_DB({[4 5]},p,0,'LineWigth',16,'StarSize',24);
% end

%% correlation %REM vs temperature


figure
suptitle('Mice temperature pre/post saline/CNO injections in function of state percentage')
subplot(321)
s1=plot(perc_WAKE_pre_saline, avTemp_wake_pre_saline,'ko', perc_WAKE_pre_cno, avTemp_wake_pre_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2);
hold on
l=lsline;
set(l,'LineWidth',1.5)
xlabel('Wake percentage')
ylabel('Temperature (°C)')
ylim([26 34])
xlim([0 100])
title('pre')

subplot(322)
s1=plot(perc_WAKE_post_saline, avTemp_wake_post_saline,'ko', perc_WAKE_post_cno, avTemp_wake_post_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2);
hold on
l=lsline;
set(l,'LineWidth',1.5)
xlabel('Wake percentage')
ylabel('Temperature (°C)')
ylim([26 34])
xlim([0 100])
title('post')

subplot(323)
s1=plot(perc_SWS_pre_saline, avTemp_sws_pre_saline,'ko', perc_SWS_pre_cno, avTemp_sws_pre_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2);
hold on
l=lsline;
set(l,'LineWidth',1.5)
xlabel('NREM percentage')
ylabel('Temperature (°C)')
ylim([26 34])
xlim([0 100])
title('pre')

subplot(324)
s1=plot(perc_SWS_post_saline, avTemp_sws_post_saline,'ko', perc_SWS_post_cno, avTemp_sws_post_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2);
hold on
l=lsline;
set(l,'LineWidth',1.5)
xlabel('NREM percentage')
ylabel('Temperature (°C)')
ylim([26 34])
xlim([0 100])
title('post')

subplot(325)
s1=plot(perc_REM_pre_saline, avTemp_rem_pre_saline,'ko', perc_REM_pre_cno, avTemp_rem_pre_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2);
hold on
l=lsline;
set(l,'LineWidth',1.5)
xlabel('REM percentage')
ylabel('Temperature (°C)')
ylim([26 34])
xlim([0 100])
title('pre')

subplot(326)
s1=plot(perc_REM_post_saline, avTemp_rem_post_saline,'ko', perc_REM_post_cno, avTemp_rem_post_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2);
hold on
l=lsline;
set(l,'LineWidth',1.5)
xlabel('REM percentage')
ylabel('Temperature (°C)')
ylim([26 34])
xlim([0 100])
title('post')

%%
% 
% figure,subplot(131)
% MakeBoxPlot_MC({avTemp_wake_pre_basal avTemp_wake_pre_saline avTemp_wake_pre_cno avTemp_wake_3hpost_basal avTemp_wake_3hpost_saline avTemp_wake_3hpost_cno},...
%     {col_basal col_sal col_cno col_basal col_sal col_cno},[1,2,3,5,6,7],{},1,0);
% xticks([2 6]); xticklabels({'pre','3h post'})
% ylim([27 33])
% title('Wake')
% 
% subplot(132)
% MakeBoxPlot_MC({avTemp_sws_pre_basal avTemp_sws_pre_saline avTemp_sws_pre_cno avTemp_sws_3hpost_basal avTemp_sws_3hpost_saline avTemp_sws_3hpost_cno},...
%     {col_basal col_sal col_cno col_basal col_sal col_cno},[1,2,3,5,6,7],{},1,0);
% xticks([2 6]); xticklabels({'pre','3h post'})
% ylim([27 33])
% title('NREM')
% 
% subplot(133)
% MakeBoxPlot_MC({avTemp_rem_pre_basal avTemp_rem_pre_saline avTemp_rem_pre_cno avTemp_rem_3hpost_basal avTemp_rem_3hpost_saline avTemp_rem_3hpost_cno},...
%     {col_basal col_sal col_cno col_basal col_sal col_cno},[1,2,3,5,6,7],{},1,0);
% xticks([2 6]); xticklabels({'pre','3h post'})
% ylim([27 33])
% title('REM')

