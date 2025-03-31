
%% input dir
% %DIR INHI DREADDS PFC-VLPO SAL/CNO (basal sleep)
% Dir_sal=PathForExperiments_DREADD_MC('inhibDREADD_retroCre_PFC_VLPO_SalineInjection_1pm');
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_retroCre_PFC_VLPO_CNOInjection_1pm');
% 
% % Dir_sal=PathForExperiments_DREADD_MC('inhibDREADD_PFC_SalineInjection_1pm');
% % Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_PFC_CNOInjection_1pm');


%%



%%
% % Dir_sal = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_9am_SleepPostEPM');
% % Dir_cno = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_9am_SleepPostEPM');
% % % 
% Dir_sal = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% % Dir_sal = RestrictPathForExperiment(Dir_sal, 'nMice', [1105 1148 1149 1150 1218 1371 1372]);
% Dir_sal = RestrictPathForExperiment(Dir_sal, 'nMice', [1106 1217 1219 1220 1373 1374]);
% % 
% Dir_cno = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');
% % Dir_cno = RestrictPathForExperiment(Dir_cno, 'nMice', [1105 1148 1149 1150 1218 1371 1372]);
% Dir_cno = RestrictPathForExperiment(Dir_cno, 'nMice', [1106 1217 1219 1220 1373 1374]);
% 
% % Dir_sal = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_SalineInjection_10am');
% % Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_CNOInjection_10am');
% 
% % 
% Dir_sal = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_SalineInjection_1pm');
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_CNOInjection_1pm');


%% good path
% % Dir_cno = PathForExperimentsAtropine_MC('Atropine');
Dir_sal = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
Dir_cno = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');



%% TEST SOURIS C57 VS CRH
% 
% %%compare CRH-C57
% Dir_basal_2=PathForExperiments_DREADD_MC('inhibDREADD_PFC_BaselineSleep');
% Dir_basal_3=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_BaselineSleep');
% Dir_basal_4 = PathForExperiments_SD_MC('BaselineSleep');
% Dir_basal_merge_1 = MergePathForExperiment(Dir_basal_2,Dir_basal_3);
% Dir_sal = MergePathForExperiment(Dir_basal_merge_1,Dir_basal_4);
% 
% %%dir CRH-cre mice
% DirBasal_dreadd1 = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_BaselineSleep');
% % DirBasal_dreadd2 = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% % DirSocialDefeat_classic = MergePathForExperiment(DirBasal_dreadd1,DirBasal_dreadd2);
% 
% Dir_cno = DirBasal_dreadd1 ;


%% parameters
tempbin = 3600;

lim_short =10;
lim_long = 25;
%%Basal sleep W/ injection at 1pm

t_inj = 13;
t_start = 9;
t_end = 18;

% t_inj = 11;
% t_start = 10;
% t_end = 18;

% ROI = [116 88 40 56 118 24 67 74 7 35 37 46 39];
% ROI = [116 40 56 118 67 35 37];
% ROI = [88 24 74 7 46 39];

ROI = [115 88 40 56 118 24 67 74 7 35 37 46 39];

VLPO_or_not = [1 1 1 1 1 0 1 0 0 0 1 0 1];


%% Get data for saline sessions
for j=1:length(Dir_sal.path)
    cd(Dir_sal.path{j}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_basal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_basal{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    else
    end
    
    vec_tps_recording_basal{j} = Range(stages_basal{j}.tsdMovement); %get vector to keep track of the reocrding time
    VecTimeDay_basal{j} = GetTimeOfTheDay_MC(vec_tps_recording_basal{j});
    idx_injection_time_basal{j} = find(ceil(VecTimeDay_basal{j})==t_inj,1,'last'); %last %get index for the injection time
    idx_same_st_basal{j} = find(ceil(VecTimeDay_basal{j})>=t_start,1,'first'); % first  get index to get same beg and end of the time period to analyze
    idx_same_en_basal{j} = find(ceil(VecTimeDay_basal{j})>=t_end,1,'last');%== last
    
    injection_time_basal{j} = vec_tps_recording_basal{j}(idx_injection_time_basal{j}); %get the corresponding values
    same_st_basal{j} = vec_tps_recording_basal{j}(idx_same_st_basal{j});
    same_en_basal{j} = vec_tps_recording_basal{j}(idx_same_en_basal{j});
    same_epoch_basal{j} =  intervalSet(same_st_basal{j}, same_en_basal{j});
    same_epoch_pre_basal{j} =  intervalSet(same_st_basal{j}, injection_time_basal{j});
    same_epoch_post_basal{j} =  intervalSet(injection_time_basal{j}, same_en_basal{j});
        
    
    %%compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'wake',tempbin,same_st_basal{j},same_en_basal{j});
    dur_WAKE_all_basal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_all_basal{j}=num_moyen_ep_WAKE;
    perc_WAKE_all_basal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_basal{j}.Wake,same_epoch_pre_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_pre_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_pre_basal{j}),'wake',tempbin,same_st_basal{j},injection_time_basal{j});
    dur_WAKE_pre_basal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_pre_basal{j}=num_moyen_ep_WAKE;
    perc_WAKE_pre_basal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_basal{j}.Wake,same_epoch_post_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_post_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}),'wake',tempbin,injection_time_basal{j},same_en_basal{j});
    dur_WAKE_post_basal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_post_basal{j}=num_moyen_ep_WAKE;
    perc_WAKE_post_basal{j}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'SWS',tempbin,same_st_basal{j},same_en_basal{j});
    dur_SWS_all_basal{j}=dur_moyenne_ep_SWS;
    num_SWS_all_basal{j}=num_moyen_ep_SWS;
    perc_SWS_all_basal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_basal{j}.Wake,same_epoch_pre_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_pre_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_pre_basal{j}),'SWS',tempbin,same_st_basal{j},injection_time_basal{j});
    dur_SWS_pre_basal{j}=dur_moyenne_ep_SWS;
    num_SWS_pre_basal{j}=num_moyen_ep_SWS;
    perc_SWS_pre_basal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_basal{j}.Wake,same_epoch_post_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_post_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}),'SWS',tempbin,injection_time_basal{j},same_en_basal{j});
    dur_SWS_post_basal{j}=dur_moyenne_ep_SWS;
    num_SWS_post_basal{j}=num_moyen_ep_SWS;
    perc_SWS_post_basal{j}=perc_moyen_SWS;
    
    
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'REM',tempbin,same_st_basal{j},same_en_basal{j});
    dur_REM_all_basal{j}=dur_moyenne_ep_REM;
    num_REM_all_basal{j}=num_moyen_ep_REM;
    perc_REM_all_basal{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_basal{j}.Wake,same_epoch_pre_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_pre_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_pre_basal{j}),'REM',tempbin,same_st_basal{j},injection_time_basal{j});
    dur_REM_pre_basal{j}=dur_moyenne_ep_REM;
    num_REM_pre_basal{j}=num_moyen_ep_REM;
    perc_REM_pre_basal{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_basal{j}.Wake,same_epoch_post_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_post_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}),'REM',tempbin,injection_time_basal{j},same_en_basal{j});
    dur_REM_post_basal{j}=dur_moyenne_ep_REM;
    num_REM_post_basal{j}=num_moyen_ep_REM;
    perc_REM_post_basal{j}=perc_moyen_REM;
    
    
    %%total sleep duration
    [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stages_basal{j}.Wake,same_epoch_pre_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_pre_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_pre_basal{j}),same_st_basal{j},injection_time_basal{j});
    tot_sleep_dur_pre_basal(j)=sleep_Tduration;

    [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stages_basal{j}.Wake,same_epoch_post_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_post_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}),injection_time_basal{j},same_en_basal{j});
    tot_sleep_dur_post_basal(j)=sleep_Tduration;

        
%     %%Compute transition probabilities overtime
%     [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
%         Get_proba_timebins_Overtime_MC_version2_VF(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),tempbin,same_st_basal{j},same_en_basal{j});
%     all_trans_REM_REM_all_basal{j} = trans_REM_to_REM;
%     all_trans_REM_SWS_all_basal{j} = trans_REM_to_SWS;
%     all_trans_REM_WAKE_all_basal{j} = trans_REM_to_WAKE;
%     
%     all_trans_SWS_REM_all_basal{j} = trans_SWS_to_REM;
%     all_trans_SWS_SWS_all_basal{j} = trans_SWS_to_SWS;
%     all_trans_SWS_WAKE_all_basal{j} = trans_SWS_to_WAKE;
%     
%     all_trans_WAKE_REM_all_basal{j} = trans_WAKE_to_REM;
%     all_trans_WAKE_SWS_all_basal{j} = trans_WAKE_to_SWS;
%     all_trans_WAKE_WAKE_all_basal{j} = trans_WAKE_to_WAKE;
%     
%     %%Compute average transition probabilities during the pre injection period
%     [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
%         Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_basal{j}.Wake,same_epoch_pre_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_pre_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_pre_basal{j}),tempbin,same_st_basal{j},injection_time_basal{j});
%     all_trans_REM_REM_pre_basal{j} = trans_REM_to_REM;
%     all_trans_REM_SWS_pre_basal{j} = trans_REM_to_SWS;
%     all_trans_REM_WAKE_pre_basal{j} = trans_REM_to_WAKE;
%     
%     all_trans_SWS_REM_pre_basal{j} = trans_SWS_to_REM;
%     all_trans_SWS_SWS_pre_basal{j} = trans_SWS_to_SWS;
%     all_trans_SWS_WAKE_pre_basal{j} = trans_SWS_to_WAKE;
%     
%     all_trans_WAKE_REM_pre_basal{j} = trans_WAKE_to_REM;
%     all_trans_WAKE_SWS_pre_basal{j} = trans_WAKE_to_SWS;
%     all_trans_WAKE_WAKE_pre_basal{j} = trans_WAKE_to_WAKE;
%     
%     %%Compute average transition probabilities during the post injection period
%     [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
%         Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_basal{j}.Wake,same_epoch_post_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_post_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}),tempbin,injection_time_basal{j},same_en_basal{j});
%     all_trans_REM_REM_post_basal{j} = trans_REM_to_REM;
%     all_trans_REM_SWS_post_basal{j} = trans_REM_to_SWS;
%     all_trans_REM_WAKE_post_basal{j} = trans_REM_to_WAKE;
%     
%     all_trans_SWS_REM_post_basal{j} = trans_SWS_to_REM;
%     all_trans_SWS_SWS_post_basal{j} = trans_SWS_to_SWS;
%     all_trans_SWS_WAKE_post_basal{j} = trans_SWS_to_WAKE;
%     
%     all_trans_WAKE_REM_post_basal{j} = trans_WAKE_to_REM;
%     all_trans_WAKE_SWS_post_basal{j} = trans_WAKE_to_SWS;
%     all_trans_WAKE_WAKE_post_basal{j} = trans_WAKE_to_WAKE;
%     
 
[dur_REM_basal_bis{j}, durT_REM_basal(j)]=DurationEpoch(and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}),'s');

idx_short_rem_basal{j} = find(dur_REM_basal_bis{j}<lim_short);
short_REMEpoch_basal{j} = subset(and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}), idx_short_rem_basal{j});
[dur_rem_short_basal{j}, durT_rem_short_basal(j)] = DurationEpoch(short_REMEpoch_basal{j},'s');
perc_rem_short_basal(j) = durT_rem_short_basal(j) / durT_REM_basal(j) * 100;
dur_moyenne_rem_short_basal(j) = nanmean(dur_rem_short_basal{j});
num_moyen_rem_short_basal(j) = length(dur_rem_short_basal{j});

idx_long_rem_basal{j} = find(dur_REM_basal_bis{j}>lim_long);
long_REMEpoch_basal{j} = subset(and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}), idx_long_rem_basal{j});
[dur_rem_long_basal{j}, durT_rem_long_basal(j)] = DurationEpoch(long_REMEpoch_basal{j},'s');
perc_rem_long_basal(j) = durT_rem_long_basal(j) / durT_REM_basal(j) * 100;
dur_moyenne_rem_long_basal(j) = nanmean(dur_rem_long_basal{j});
num_moyen_rem_long_basal(j) = length(dur_rem_long_basal{j});

   idx_mid_rem_basal{j} = find(dur_REM_basal_bis{j}>lim_short & dur_REM_basal_bis{j}<lim_long);
    mid_REMEpoch_basal{j} = subset(and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}), idx_mid_rem_basal{j});
    [dur_rem_mid_basal{j}, durT_rem_mid_basal(j)] = DurationEpoch(mid_REMEpoch_basal{j},'s');
    perc_rem_mid_basal(j) = durT_rem_mid_basal(j) / durT_REM_basal(j) * 100;
    dur_moyenne_rem_mid_basal(j) = nanmean(dur_rem_mid_basal{j});
    num_moyen_rem_mid_basal(j) = length(dur_rem_mid_basal{j});
    
    perc_rem_short_basal(j) = num_moyen_rem_short_basal(j) / num_REM_post_basal{j} * 100;
    perc_rem_mid_basal(j) = num_moyen_rem_mid_basal(j) / num_REM_post_basal{j} * 100;
    perc_rem_long_basal(j) = num_moyen_rem_long_basal(j) / num_REM_post_basal{j} * 100;
    
    
end

%% percentage/duration/number
for imouse=1:length(dur_REM_pre_basal)
%     data_dur_WAKE_all_basal(imouse,:) = dur_WAKE_all_basal{imouse}; data_dur_WAKE_all_basal(isnan(data_dur_WAKE_all_basal)==1)=0;
%     data_num_WAKE_all_basal(imouse,:) = num_WAKE_all_basal{imouse}; data_num_WAKE_all_basal(isnan(data_num_WAKE_all_basal)==1)=0;
%     data_perc_WAKE_all_basal(imouse,:) = perc_WAKE_all_basal{imouse}; %data_perc_WAKE_all_basal(isnan(data_perc_WAKE_all_basal)==1)=0;
%     
    data_dur_WAKE_pre_basal(imouse,:) = dur_WAKE_pre_basal{imouse}; data_dur_WAKE_pre_basal(isnan(data_dur_WAKE_pre_basal)==1)=0;
    data_num_WAKE_pre_basal(imouse,:) = num_WAKE_pre_basal{imouse}; data_num_WAKE_pre_basal(isnan(data_num_WAKE_pre_basal)==1)=0;
    data_perc_WAKE_pre_basal(imouse,:) = perc_WAKE_pre_basal{imouse}; data_perc_WAKE_pre_basal(isnan(data_perc_WAKE_pre_basal)==1)=0;
    
    data_dur_WAKE_post_basal(imouse,:) = dur_WAKE_post_basal{imouse}; data_dur_WAKE_post_basal(isnan(data_dur_WAKE_post_basal)==1)=0;
    data_num_WAKE_post_basal(imouse,:) = num_WAKE_post_basal{imouse}; data_num_WAKE_post_basal(isnan(data_num_WAKE_post_basal)==1)=0;
    data_perc_WAKE_post_basal(imouse,:) = perc_WAKE_post_basal{imouse}; data_perc_WAKE_post_basal(isnan(data_perc_WAKE_post_basal)==1)=0;
%     
%     data_dur_SWS_all_basal(imouse,:) = dur_SWS_all_basal{imouse}; data_dur_SWS_all_basal(isnan(data_dur_SWS_all_basal)==1)=0;
%     data_num_SWS_all_basal(imouse,:) = num_SWS_all_basal{imouse}; data_num_SWS_all_basal(isnan(data_num_SWS_all_basal)==1)=0;
%     data_perc_SWS_all_basal(imouse,:) = perc_SWS_all_basal{imouse}; data_perc_SWS_all_basal(isnan(data_perc_SWS_all_basal)==1)=0;
    
    data_dur_SWS_pre_basal(imouse,:) = dur_SWS_pre_basal{imouse}; data_dur_SWS_pre_basal(isnan(data_dur_SWS_pre_basal)==1)=0;
    data_num_SWS_pre_basal(imouse,:) = num_SWS_pre_basal{imouse}; data_num_SWS_pre_basal(isnan(data_num_SWS_pre_basal)==1)=0;
    data_perc_SWS_pre_basal(imouse,:) = perc_SWS_pre_basal{imouse}; data_perc_SWS_pre_basal(isnan(data_perc_SWS_pre_basal)==1)=0;
    
    data_dur_SWS_post_basal(imouse,:) = dur_SWS_post_basal{imouse}; data_dur_SWS_post_basal(isnan(data_dur_SWS_post_basal)==1)=0;
    data_num_SWS_post_basal(imouse,:) = num_SWS_post_basal{imouse}; data_num_SWS_post_basal(isnan(data_num_SWS_post_basal)==1)=0;
    data_perc_SWS_post_basal(imouse,:) = perc_SWS_post_basal{imouse}; data_perc_SWS_post_basal(isnan(data_perc_SWS_post_basal)==1)=0;
    
%     data_dur_REM_all_basal(imouse,:) = dur_REM_all_basal{imouse}; data_dur_REM_all_basal(isnan(data_dur_REM_all_basal)==1)=0;
%     data_num_REM_all_basal(imouse,:) = num_REM_all_basal{imouse}; data_num_REM_all_basal(isnan(data_num_REM_all_basal)==1)=0;
%     data_perc_REM_all_basal(imouse,:) = perc_REM_all_basal{imouse}; data_perc_REM_all_basal(isnan(data_perc_REM_all_basal)==1)=0;
    
    data_dur_REM_pre_basal(imouse,:) = dur_REM_pre_basal{imouse}; data_dur_REM_pre_basal(isnan(data_dur_REM_pre_basal)==1)=0;
    data_num_REM_pre_basal(imouse,:) = num_REM_pre_basal{imouse}; data_num_REM_pre_basal(isnan(data_num_REM_pre_basal)==1)=0;
    data_perc_REM_pre_basal(imouse,:) = perc_REM_pre_basal{imouse}; data_perc_REM_pre_basal(isnan(data_perc_REM_pre_basal)==1)=0;
    
    data_dur_REM_post_basal(imouse,:) = dur_REM_post_basal{imouse}; data_dur_REM_post_basal(isnan(data_dur_REM_post_basal)==1)=0;
    data_num_REM_post_basal(imouse,:) = num_REM_post_basal{imouse}; data_num_REM_post_basal(isnan(data_num_REM_post_basal)==1)=0;
    data_perc_REM_post_basal(imouse,:) = perc_REM_post_basal{imouse}; data_perc_REM_post_basal(isnan(data_perc_REM_post_basal)==1)=0;
    
end
%% probability
% for imouse=1:length(all_trans_REM_REM_all_basal)
%     data_REM_REM_all_basal(imouse,:) = all_trans_REM_REM_all_basal{imouse}; %data_REM_REM_all_basal(isnan(data_REM_REM_all_basal)==1)=0;
%     data_REM_SWS_all_basal(imouse,:) = all_trans_REM_SWS_all_basal{imouse}; %data_REM_SWS_all_basal(isnan(data_REM_SWS_all_basal)==1)=0;
%     data_REM_WAKE_all_basal(imouse,:) = all_trans_REM_WAKE_all_basal{imouse};% data_REM_WAKE_all_basal(isnan(data_REM_WAKE_all_basal)==1)=0;
%     
%     data_SWS_SWS_all_basal(imouse,:) = all_trans_SWS_SWS_all_basal{imouse}; %data_SWS_SWS_all_basal(isnan(data_SWS_SWS_all_basal)==1)=0;
%     data_SWS_REM_all_basal(imouse,:) = all_trans_SWS_REM_all_basal{imouse}; %data_SWS_REM_all_basal(isnan(data_SWS_REM_all_basal)==1)=0;
%     data_SWS_WAKE_all_basal(imouse,:) = all_trans_SWS_WAKE_all_basal{imouse}; %data_SWS_WAKE_all_basal(isnan(data_SWS_WAKE_all_basal)==1)=0;
%     
%     data_WAKE_WAKE_all_basal(imouse,:) = all_trans_WAKE_WAKE_all_basal{imouse}; %data_WAKE_WAKE_all_basal(isnan(data_WAKE_WAKE_all_basal)==1)=0;
%     data_WAKE_REM_all_basal(imouse,:) = all_trans_WAKE_REM_all_basal{imouse}; %data_WAKE_REM_all_basal(isnan(data_WAKE_REM_all_basal)==1)=0;
%     data_WAKE_SWS_all_basal(imouse,:) = all_trans_WAKE_SWS_all_basal{imouse}; %data_WAKE_SWS_all_basal(isnan(data_WAKE_SWS_all_basal)==1)=0;
%     
%     data_REM_REM_pre_basal(imouse,:) = all_trans_REM_REM_pre_basal{imouse}; %data_REM_REM_pre_basal(isnan(data_REM_REM_pre_basal)==1)=0;
%     data_REM_SWS_pre_basal(imouse,:) = all_trans_REM_SWS_pre_basal{imouse}; %data_REM_SWS_pre_basal(isnan(data_REM_SWS_pre_basal)==1)=0;
%     data_REM_WAKE_pre_basal(imouse,:) = all_trans_REM_WAKE_pre_basal{imouse}; %data_REM_WAKE_pre_basal(isnan(data_REM_WAKE_pre_basal)==1)=0;
%     
%     data_SWS_SWS_pre_basal(imouse,:) = all_trans_SWS_SWS_pre_basal{imouse}; %data_SWS_SWS_pre_basal(isnan(data_SWS_SWS_pre_basal)==1)=0;
%     data_SWS_REM_pre_basal(imouse,:) = all_trans_SWS_REM_pre_basal{imouse}; %data_SWS_REM_pre_basal(isnan(data_SWS_REM_pre_basal)==1)=0;
%     data_SWS_WAKE_pre_basal(imouse,:) = all_trans_SWS_WAKE_pre_basal{imouse}; %data_SWS_WAKE_pre_basal(isnan(data_SWS_WAKE_pre_basal)==1)=0;
%     
%     data_WAKE_WAKE_pre_basal(imouse,:) = all_trans_WAKE_WAKE_pre_basal{imouse};% data_WAKE_WAKE_pre_basal(isnan(data_WAKE_WAKE_pre_basal)==1)=0;
%     data_WAKE_REM_pre_basal(imouse,:) = all_trans_WAKE_REM_pre_basal{imouse}; %data_WAKE_REM_pre_basal(isnan(data_WAKE_REM_pre_basal)==1)=0;
%     data_WAKE_SWS_pre_basal(imouse,:) = all_trans_WAKE_SWS_pre_basal{imouse}; %data_WAKE_SWS_pre_basal(isnan(data_WAKE_SWS_pre_basal)==1)=0;
%     
%     data_REM_REM_post_basal(imouse,:) = all_trans_REM_REM_post_basal{imouse}; %data_REM_REM_post_basal(isnan(data_REM_REM_post_basal)==1)=0;
%     data_REM_SWS_post_basal(imouse,:) = all_trans_REM_SWS_post_basal{imouse}; %data_REM_SWS_post_basal(isnan(data_REM_SWS_post_basal)==1)=0;
%     data_REM_WAKE_post_basal(imouse,:) = all_trans_REM_WAKE_post_basal{imouse}; %data_REM_WAKE_post_basal(isnan(data_REM_WAKE_post_basal)==1)=0;
%     
%     data_SWS_SWS_post_basal(imouse,:) = all_trans_SWS_SWS_post_basal{imouse}; %data_SWS_SWS_post_basal(isnan(data_SWS_SWS_post_basal)==1)=0;
%     data_SWS_REM_post_basal(imouse,:) = all_trans_SWS_REM_post_basal{imouse}; %data_SWS_REM_post_basal(isnan(data_SWS_REM_post_basal)==1)=0;
%     data_SWS_WAKE_post_basal(imouse,:) = all_trans_SWS_WAKE_post_basal{imouse}; %data_SWS_WAKE_post_basal(isnan(data_SWS_WAKE_post_basal)==1)=0;
%     
%     data_WAKE_WAKE_post_basal(imouse,:) = all_trans_WAKE_WAKE_post_basal{imouse}; %data_WAKE_WAKE_post_basal(isnan(data_WAKE_WAKE_post_basal)==1)=0;
%     data_WAKE_REM_post_basal(imouse,:) = all_trans_WAKE_REM_post_basal{imouse}; %data_WAKE_REM_post_basal(isnan(data_WAKE_REM_post_basal)==1)=0;
%     data_WAKE_SWS_post_basal(imouse,:) = all_trans_WAKE_SWS_post_basal{imouse};% data_WAKE_SWS_post_basal(isnan(data_WAKE_SWS_post_basal)==1)=0;
% end



%% Get data for CNO sessions
for i=1:length(Dir_cno.path)
    cd(Dir_cno.path{i}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_cno{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_cno{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    else
    end
    
    vec_tps_recording_cno{i} = Range(stages_cno{i}.tsdMovement); %get vector to keep track of the recording time
    VecTimeDay_cno{i} = GetTimeOfTheDay_MC(vec_tps_recording_cno{i});
    
    all_start_time{i}=VecTimeDay_cno{i}(1);
    all_end_time{i}=VecTimeDay_cno{i}(end);
    
    idx_injection_time_cno{i} = find(ceil(VecTimeDay_cno{i})==t_inj,1,'last'); %last %get index for the injection time
    idx_same_st_cno{i} = find(ceil(VecTimeDay_cno{i})>=t_start,1,'first'); %% first avant
    idx_same_en_cno{i} = find(ceil(VecTimeDay_cno{i})>=t_end,1,'last');%== last   %==t_end,1,'last');
    
    injection_time_cno{i} = vec_tps_recording_cno{i}(idx_injection_time_cno{i}); %get the corresponding values
    same_st_cno{i} = vec_tps_recording_cno{i}(idx_same_st_cno{i});
    
    same_en_cno{i} = vec_tps_recording_cno{i}(idx_same_en_cno{i});
    same_epoch_cno{i} =  intervalSet(same_st_cno{i}, same_en_cno{i});
    
    same_epoch_pre_cno{i} =  intervalSet(same_st_cno{i}, injection_time_cno{i});
    same_epoch_post_cno{i} =  intervalSet(injection_time_cno{i}, same_en_cno{i});
    
    
    %%compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_cno{i}.Wake,same_epoch_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_cno{i}),'wake',tempbin,same_st_cno{i},same_en_cno{i});
    dur_WAKE_all_cno{i}=dur_moyenne_ep_WAKE;
    num_WAKE_all_cno{i}=num_moyen_ep_WAKE;
    perc_WAKE_all_cno{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{i}.Wake,same_epoch_pre_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_pre_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_pre_cno{i}),'wake',tempbin,same_st_cno{i},injection_time_cno{i});
    dur_WAKE_pre_cno{i}=dur_moyenne_ep_WAKE;
    num_WAKE_pre_cno{i}=num_moyen_ep_WAKE;
    perc_WAKE_pre_cno{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{i}.Wake,same_epoch_post_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_post_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}),'wake',tempbin,injection_time_cno{i},same_en_cno{i});
    dur_WAKE_post_cno{i}=dur_moyenne_ep_WAKE;
    num_WAKE_post_cno{i}=num_moyen_ep_WAKE;
    perc_WAKE_post_cno{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_cno{i}.Wake,same_epoch_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_cno{i}),'sws',tempbin,same_st_cno{i},same_en_cno{i});
    dur_SWS_all_cno{i}=dur_moyenne_ep_SWS;
    num_SWS_all_cno{i}=num_moyen_ep_SWS;
    perc_SWS_all_cno{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{i}.Wake,same_epoch_pre_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_pre_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_pre_cno{i}),'sws',tempbin,same_st_cno{i},injection_time_cno{i});
    dur_SWS_pre_cno{i}=dur_moyenne_ep_SWS;
    num_SWS_pre_cno{i}=num_moyen_ep_SWS;
    perc_SWS_pre_cno{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{i}.Wake,same_epoch_post_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_post_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}),'sws',tempbin,injection_time_cno{i},same_en_cno{i});
    dur_SWS_post_cno{i}=dur_moyenne_ep_SWS;
    num_SWS_post_cno{i}=num_moyen_ep_SWS;
    perc_SWS_post_cno{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_cno{i}.Wake,same_epoch_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_cno{i}),'rem',tempbin,same_st_cno{i},same_en_cno{i});
    dur_REM_all_cno{i}=dur_moyenne_ep_REM;
    num_REM_all_cno{i}=num_moyen_ep_REM;
    perc_REM_all_cno{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{i}.Wake,same_epoch_pre_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_pre_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_pre_cno{i}),'rem',tempbin,same_st_cno{i},injection_time_cno{i});
    dur_REM_pre_cno{i}=dur_moyenne_ep_REM;
    num_REM_pre_cno{i}=num_moyen_ep_REM;
    perc_REM_pre_cno{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{i}.Wake,same_epoch_post_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_post_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}),'rem',tempbin,injection_time_cno{i},same_en_cno{i});
    dur_REM_post_cno{i}=dur_moyenne_ep_REM;
    num_REM_post_cno{i}=num_moyen_ep_REM;
    perc_REM_post_cno{i}=perc_moyen_REM;
    
    
    %%total sleep duration
    [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stages_cno{i}.Wake,same_epoch_pre_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_pre_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_pre_cno{i}),same_st_cno{i},injection_time_cno{i});
    tot_sleep_dur_pre_cno(i)=sleep_Tduration;
    
    [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stages_cno{i}.Wake,same_epoch_post_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_post_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}),injection_time_cno{i},same_en_cno{i});
    tot_sleep_dur_post_cno(i)=sleep_Tduration;
    
    
    
%     %%Compute transition probabilities overtime
%     [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
%         Get_proba_timebins_Overtime_MC_version2_VF(and(stages_cno{i}.Wake,same_epoch_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_cno{i}),tempbin,same_st_cno{i},same_en_cno{i});
%     all_trans_REM_REM_all_cno{i} = trans_REM_to_REM;
%     all_trans_REM_SWS_all_cno{i} = trans_REM_to_SWS;
%     all_trans_REM_WAKE_all_cno{i} = trans_REM_to_WAKE;
%     
%     all_trans_SWS_REM_all_cno{i} = trans_SWS_to_REM;
%     all_trans_SWS_SWS_all_cno{i} = trans_SWS_to_SWS;
%     all_trans_SWS_WAKE_all_cno{i} = trans_SWS_to_WAKE;
%     
%     all_trans_WAKE_REM_all_cno{i} = trans_WAKE_to_REM;
%     all_trans_WAKE_SWS_all_cno{i} = trans_WAKE_to_SWS;
%     all_trans_WAKE_WAKE_all_cno{i} = trans_WAKE_to_WAKE;
%     
%     %%Compute average transition probabilities during the pre injection period
%     [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
%         Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_cno{i}.Wake,same_epoch_pre_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_pre_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_pre_cno{i}),tempbin,same_st_cno{i},injection_time_cno{i});
%     all_trans_REM_REM_pre_cno{i} = trans_REM_to_REM;
%     all_trans_REM_SWS_pre_cno{i} = trans_REM_to_SWS;
%     all_trans_REM_WAKE_pre_cno{i} = trans_REM_to_WAKE;
%     
%     all_trans_SWS_REM_pre_cno{i} = trans_SWS_to_REM;
%     all_trans_SWS_SWS_pre_cno{i} = trans_SWS_to_SWS;
%     all_trans_SWS_WAKE_pre_cno{i} = trans_SWS_to_WAKE;
%     
%     all_trans_WAKE_REM_pre_cno{i} = trans_WAKE_to_REM;
%     all_trans_WAKE_SWS_pre_cno{i} = trans_WAKE_to_SWS;
%     all_trans_WAKE_WAKE_pre_cno{i} = trans_WAKE_to_WAKE;
%     
%     %%Compute average transition probabilities during the post injection period
%     [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
%         Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_cno{i}.Wake,same_epoch_post_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_post_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}),tempbin,injection_time_cno{i},same_en_cno{i});
%     all_trans_REM_REM_post_cno{i} = trans_REM_to_REM;
%     all_trans_REM_SWS_post_cno{i} = trans_REM_to_SWS;
%     all_trans_REM_WAKE_post_cno{i} = trans_REM_to_WAKE;
%     
%     all_trans_SWS_REM_post_cno{i} = trans_SWS_to_REM;
%     all_trans_SWS_SWS_post_cno{i} = trans_SWS_to_SWS;
%     all_trans_SWS_WAKE_post_cno{i} = trans_SWS_to_WAKE;
%     
%     all_trans_WAKE_REM_post_cno{i} = trans_WAKE_to_REM;
%     all_trans_WAKE_SWS_post_cno{i} = trans_WAKE_to_SWS;
%     all_trans_WAKE_WAKE_post_cno{i} = trans_WAKE_to_WAKE;

[dur_REM_cno_bis{i}, durT_REM_cno(i)]=DurationEpoch(and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}),'s');
    
    idx_short_rem_cno{i} = find(dur_REM_cno_bis{i}<lim_short);
    short_REMEpoch_cno{i} = subset(and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}), idx_short_rem_cno{i});
    [dur_rem_short_cno{i}, durT_rem_short_cno(i)] = DurationEpoch(short_REMEpoch_cno{i},'s');
    perc_rem_short_cno(i) = durT_rem_short_cno(i) / durT_REM_cno(i) * 100;
    dur_moyenne_rem_short_cno(i) = mean(dur_rem_short_cno{i});
    num_moyen_rem_short_cno(i) = length(dur_rem_short_cno{i});
    
    idx_long_rem_cno{i} = find(dur_REM_cno_bis{i}>lim_long);
    long_REMEpoch_cno{i} = subset(and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}), idx_long_rem_cno{i});
    [dur_rem_long_cno{i}, durT_rem_long_cno(i)] = DurationEpoch(long_REMEpoch_cno{i},'s');
    perc_rem_long_cno(i) = durT_rem_long_cno(i) / durT_REM_cno(i) * 100;
    dur_moyenne_rem_long_cno(i) = mean(dur_rem_long_cno{i});
    num_moyen_rem_long_cno(i) = length(dur_rem_long_cno{i});
    
        idx_mid_rem_cno{i} = find(dur_REM_cno_bis{i}>lim_short & dur_REM_cno_bis{i}<lim_long);
    mid_REMEpoch_cno{i} = subset(and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}), idx_mid_rem_cno{i});
    [dur_rem_mid_cno{i}, durT_rem_mid_cno(i)] = DurationEpoch(mid_REMEpoch_cno{i},'s');
    perc_rem_mid_cno(i) = durT_rem_mid_cno(i) / durT_REM_cno(i) * 100;
    dur_moyenne_rem_mid_cno(i) = mean(dur_rem_mid_cno{i});
    num_moyen_rem_mid_cno(i) = length(dur_rem_mid_cno{i});
    
    perc_rem_short_cno(i) = num_moyen_rem_short_cno(i) / num_REM_post_cno{i} * 100;
    perc_rem_mid_cno(i) = num_moyen_rem_mid_cno(i) / num_REM_post_cno{i} * 100;
    perc_rem_long_cno(i) = num_moyen_rem_long_cno(i) / num_REM_post_cno{i} * 100;
    
end


%% percentage/duration/number
for imouse=1:length(dur_REM_pre_cno)
%     data_dur_WAKE_all_cno(imouse,:) = dur_WAKE_all_cno{imouse}; data_dur_WAKE_all_cno(isnan(data_dur_WAKE_all_cno)==1)=0;
%     data_num_WAKE_all_cno(imouse,:) = num_WAKE_all_cno{imouse}; data_num_WAKE_all_cno(isnan(data_num_WAKE_all_cno)==1)=0;
%     data_perc_WAKE_all_cno(imouse,:) = perc_WAKE_all_cno{imouse}; %data_perc_WAKE_all_cno(isnan(data_perc_WAKE_all_cno)==1)=0;
    
    data_dur_WAKE_pre_cno(imouse,:) = dur_WAKE_pre_cno{imouse}; data_dur_WAKE_pre_cno(isnan(data_dur_WAKE_pre_cno)==1)=0;
    data_num_WAKE_pre_cno(imouse,:) = num_WAKE_pre_cno{imouse}; data_num_WAKE_pre_cno(isnan(data_num_WAKE_pre_cno)==1)=0;
    data_perc_WAKE_pre_cno(imouse,:) = perc_WAKE_pre_cno{imouse}; data_perc_WAKE_pre_cno(isnan(data_perc_WAKE_pre_cno)==1)=0;
    
    data_dur_WAKE_post_cno(imouse,:) = dur_WAKE_post_cno{imouse}; data_dur_WAKE_post_cno(isnan(data_dur_WAKE_post_cno)==1)=0;
    data_num_WAKE_post_cno(imouse,:) = num_WAKE_post_cno{imouse}; data_num_WAKE_post_cno(isnan(data_num_WAKE_post_cno)==1)=0;
    data_perc_WAKE_post_cno(imouse,:) = perc_WAKE_post_cno{imouse}; data_perc_WAKE_post_cno(isnan(data_perc_WAKE_post_cno)==1)=0;
    
%     data_dur_SWS_all_cno(imouse,:) = dur_SWS_all_cno{imouse}; data_dur_SWS_all_cno(isnan(data_dur_SWS_all_cno)==1)=0;
%     data_num_SWS_all_cno(imouse,:) = num_SWS_all_cno{imouse}; data_num_SWS_all_cno(isnan(data_num_SWS_all_cno)==1)=0;
%     data_perc_SWS_all_cno(imouse,:) = perc_SWS_all_cno{imouse}; data_perc_SWS_all_cno(isnan(data_perc_SWS_all_cno)==1)=0;
     
    data_dur_SWS_pre_cno(imouse,:) = dur_SWS_pre_cno{imouse}; data_dur_SWS_pre_cno(isnan(data_dur_SWS_pre_cno)==1)=0;
    data_num_SWS_pre_cno(imouse,:) = num_SWS_pre_cno{imouse}; data_num_SWS_pre_cno(isnan(data_num_SWS_pre_cno)==1)=0;
    data_perc_SWS_pre_cno(imouse,:) = perc_SWS_pre_cno{imouse}; data_perc_SWS_pre_cno(isnan(data_perc_SWS_pre_cno)==1)=0;
    
    data_dur_SWS_post_cno(imouse,:) = dur_SWS_post_cno{imouse}; data_dur_SWS_post_cno(isnan(data_dur_SWS_post_cno)==1)=0;
    data_num_SWS_post_cno(imouse,:) = num_SWS_post_cno{imouse}; data_num_SWS_post_cno(isnan(data_num_SWS_post_cno)==1)=0;
    data_perc_SWS_post_cno(imouse,:) = perc_SWS_post_cno{imouse}; data_perc_SWS_post_cno(isnan(data_perc_SWS_post_cno)==1)=0;
    
%     data_dur_REM_all_cno(imouse,:) = dur_REM_all_cno{imouse}; data_dur_REM_all_cno(isnan(data_dur_REM_all_cno)==1)=0;
%     data_num_REM_all_cno(imouse,:) = num_REM_all_cno{imouse}; data_num_REM_all_cno(isnan(data_num_REM_all_cno)==1)=0;
%     data_perc_REM_all_cno(imouse,:) = perc_REM_all_cno{imouse}; %data_perc_REM_all_cno(isnan(data_perc_REM_all_cno)==1)=0;
    
    data_dur_REM_pre_cno(imouse,:) = dur_REM_pre_cno{imouse}; data_dur_REM_pre_cno(isnan(data_dur_REM_pre_cno)==1)=0;
    data_num_REM_pre_cno(imouse,:) = num_REM_pre_cno{imouse}; data_num_REM_pre_cno(isnan(data_num_REM_pre_cno)==1)=0;
    data_perc_REM_pre_cno(imouse,:) = perc_REM_pre_cno{imouse}; data_perc_REM_pre_cno(isnan(data_perc_REM_pre_cno)==1)=0;
    
    data_dur_REM_post_cno(imouse,:) = dur_REM_post_cno{imouse}; data_dur_REM_post_cno(isnan(data_dur_REM_post_cno)==1)=0;
    data_num_REM_post_cno(imouse,:) = num_REM_post_cno{imouse}; data_num_REM_post_cno(isnan(data_num_REM_post_cno)==1)=0;
    data_perc_REM_post_cno(imouse,:) = perc_REM_post_cno{imouse}; data_perc_REM_post_cno(isnan(data_perc_REM_post_cno)==1)=0;
    
end
%% probability
% for imouse=1:length(all_trans_REM_REM_all_cno)
%     data_REM_REM_all_cno(imouse,:) = all_trans_REM_REM_all_cno{imouse}; %data_REM_REM_all_cno(isnan(data_REM_REM_all_cno)==1)=0;
%     data_REM_SWS_all_cno(imouse,:) = all_trans_REM_SWS_all_cno{imouse}; %data_REM_SWS_all_cno(isnan(data_REM_SWS_all_cno)==1)=0;
%     data_REM_WAKE_all_cno(imouse,:) = all_trans_REM_WAKE_all_cno{imouse}; %data_REM_WAKE_all_cno(isnan(data_REM_WAKE_all_cno)==1)=0;
%     
%     data_SWS_SWS_all_cno(imouse,:) = all_trans_SWS_SWS_all_cno{imouse}; %data_SWS_SWS_all_cno(isnan(data_SWS_SWS_all_cno)==1)=0;
%     data_SWS_REM_all_cno(imouse,:) = all_trans_SWS_REM_all_cno{imouse}; %data_SWS_REM_all_cno(isnan(data_SWS_REM_all_cno)==1)=0;
%     data_SWS_WAKE_all_cno(imouse,:) = all_trans_SWS_WAKE_all_cno{imouse}; %data_SWS_WAKE_all_cno(isnan(data_SWS_WAKE_all_cno)==1)=0;
%     
%     data_WAKE_WAKE_all_cno(imouse,:) = all_trans_WAKE_WAKE_all_cno{imouse}; %data_WAKE_WAKE_all_cno(isnan(data_WAKE_WAKE_all_cno)==1)=0;
%     data_WAKE_REM_all_cno(imouse,:) = all_trans_WAKE_REM_all_cno{imouse}; %data_WAKE_REM_all_cno(isnan(data_WAKE_REM_all_cno)==1)=0;
%     data_WAKE_SWS_all_cno(imouse,:) = all_trans_WAKE_SWS_all_cno{imouse};% data_WAKE_SWS_all_cno(isnan(data_WAKE_SWS_all_cno)==1)=0;
%     
%     data_REM_REM_pre_cno(imouse,:) = all_trans_REM_REM_pre_cno{imouse}; %data_REM_REM_pre_cno(isnan(data_REM_REM_pre_cno)==1)=0;
%     data_REM_SWS_pre_cno(imouse,:) = all_trans_REM_SWS_pre_cno{imouse}; %data_REM_SWS_pre_cno(isnan(data_REM_SWS_pre_cno)==1)=0;
%     data_REM_WAKE_pre_cno(imouse,:) = all_trans_REM_WAKE_pre_cno{imouse}; %data_REM_WAKE_pre_cno(isnan(data_REM_WAKE_pre_cno)==1)=0;
%     
%     data_SWS_SWS_pre_cno(imouse,:) = all_trans_SWS_SWS_pre_cno{imouse}; %data_SWS_SWS_pre_cno(isnan(data_SWS_SWS_pre_cno)==1)=0;
%     data_SWS_REM_pre_cno(imouse,:) = all_trans_SWS_REM_pre_cno{imouse}; %data_SWS_REM_pre_cno(isnan(data_SWS_REM_pre_cno)==1)=0;
%     data_SWS_WAKE_pre_cno(imouse,:) = all_trans_SWS_WAKE_pre_cno{imouse}; %data_SWS_WAKE_pre_cno(isnan(data_SWS_WAKE_pre_cno)==1)=0;
%     
%     data_WAKE_WAKE_pre_cno(imouse,:) = all_trans_WAKE_WAKE_pre_cno{imouse}; %data_WAKE_WAKE_pre_cno(isnan(data_WAKE_WAKE_pre_cno)==1)=0;
%     data_WAKE_REM_pre_cno(imouse,:) = all_trans_WAKE_REM_pre_cno{imouse}; %data_WAKE_REM_pre_cno(isnan(data_WAKE_REM_pre_cno)==1)=0;
%     data_WAKE_SWS_pre_cno(imouse,:) = all_trans_WAKE_SWS_pre_cno{imouse}; %data_WAKE_SWS_pre_cno(isnan(data_WAKE_SWS_pre_cno)==1)=0;
%     
%     data_REM_REM_post_cno(imouse,:) = all_trans_REM_REM_post_cno{imouse}; %data_REM_REM_post_cno(isnan(data_REM_REM_post_cno)==1)=0;
%     data_REM_SWS_post_cno(imouse,:) = all_trans_REM_SWS_post_cno{imouse}; %data_REM_SWS_post_cno(isnan(data_REM_SWS_post_cno)==1)=0;
%     data_REM_WAKE_post_cno(imouse,:) = all_trans_REM_WAKE_post_cno{imouse}; %data_REM_WAKE_post_cno(isnan(data_REM_WAKE_post_cno)==1)=0;
%     
%     data_SWS_SWS_post_cno(imouse,:) = all_trans_SWS_SWS_post_cno{imouse}; %data_SWS_SWS_post_cno(isnan(data_SWS_SWS_post_cno)==1)=0;
%     data_SWS_REM_post_cno(imouse,:) = all_trans_SWS_REM_post_cno{imouse}; %data_SWS_REM_post_cno(isnan(data_SWS_REM_post_cno)==1)=0;
%     data_SWS_WAKE_post_cno(imouse,:) = all_trans_SWS_WAKE_post_cno{imouse}; %data_SWS_WAKE_post_cno(isnan(data_SWS_WAKE_post_cno)==1)=0;
%     
%     data_WAKE_WAKE_post_cno(imouse,:) = all_trans_WAKE_WAKE_post_cno{imouse}; %data_WAKE_WAKE_post_cno(isnan(data_WAKE_WAKE_post_cno)==1)=0;
%     data_WAKE_REM_post_cno(imouse,:) = all_trans_WAKE_REM_post_cno{imouse};% data_WAKE_REM_post_cno(isnan(data_WAKE_REM_post_cno)==1)=0;
%     data_WAKE_SWS_post_cno(imouse,:) = all_trans_WAKE_SWS_post_cno{imouse}; %data_WAKE_SWS_post_cno(isnan(data_WAKE_SWS_post_cno)==1)=0;
% end


%%
perc_rem_short_cno(isnan(perc_rem_short_cno)==1)=0;
perc_rem_mid_cno(isnan(perc_rem_mid_cno)==1)=0;
perc_rem_long_cno(isnan(perc_rem_long_cno)==1)=0;

perc_rem_short_basal(isnan(perc_rem_short_basal)==1)=0;
perc_rem_mid_basal(isnan(perc_rem_mid_basal)==1)=0;
perc_rem_long_basal(isnan(perc_rem_long_basal)==1)=0;



%%
col_sal = [.7 .7 .7]; %gray
col_cno = [0 .4 .4]; %dark green
col_cno = [0 .6 .4]; %PFC inhib (light green)

col_cno = [0 0 0]; %PFC inhib (light green)
%Quantifications of general sleep variables during the post injection
%period (comparison of saline versus CNO).

figure

subplot(3,8,1,'align') %Wake percentage
PlotErrorBarN_MC({nanmean(data_perc_WAKE_post_basal,2), nanmean(data_perc_WAKE_post_cno,2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('Wake percentage')
makepretty

[p_post_basal_post_cno,h] = ranksum(nanmean(data_perc_WAKE_post_basal,2),nanmean(data_perc_WAKE_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',12); end


subplot(3,8,2,'align') %NREM percentage
PlotErrorBarN_MC({...
    nanmean(data_perc_SWS_post_basal,2), nanmean(data_perc_SWS_post_cno,2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('NREM percentage')
makepretty

[p_post_basal_post_cno,h] = ranksum(nanmean(data_perc_SWS_post_basal,2),nanmean(data_perc_SWS_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',12); end




subplot(3,8,3,'align') %REM percentage
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_post_basal,2), nanmean(data_perc_REM_post_cno,2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('REM percentage')
makepretty

[p_post_basal_post_cno,h] = ranksum(nanmean(data_perc_REM_post_basal,2),nanmean(data_perc_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',12); end



subplot(3,8,4,'align') %Number of REM bouts
PlotErrorBarN_MC({...
    nanmean(data_num_REM_post_basal,2), nanmean(data_num_REM_post_cno,2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('REM bouts number')
makepretty
[p_post_basal_post_cno,h] = ranksum(nanmean(data_num_REM_post_basal,2),nanmean(data_num_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',12); end



subplot(3,8,5,'align') %Mean duration of REM bouts
PlotErrorBarN_MC({...
    nanmean(data_dur_REM_post_basal,2), nanmean(data_dur_REM_post_cno,2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('REM bouts mean duration (s)')
makepretty

[p_post_basal_post_cno,h] = ranksum(nanmean(data_dur_REM_post_basal,2),nanmean(data_dur_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',12); end




subplot(3,8,6,'align') 
PlotErrorBarN_MC({...
    perc_rem_short_basal, perc_rem_short_cno},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('Short REM percentage')
makepretty

[p_post_basal_post_cno,h] = ranksum(perc_rem_short_basal, perc_rem_short_cno);
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',12); end



subplot(3,8,7,'align') 
PlotErrorBarN_MC({...
    perc_rem_long_basal, perc_rem_long_cno},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('Long REM percentage')
makepretty

[p_post_basal_post_cno,h] = ranksum(perc_rem_long_basal, perc_rem_long_cno);
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',12); end






%% panel REM (with quantifications overtime)
figure

timeBinPre = 1:4;
timeBinPost = 6:9;

% timeBinPre = 1:3;
% timeBinPost = 4:7;

subplot(4,6,[1,2]), hold on %Wake percentage overtime
plot(nanmean(data_perc_WAKE_all_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_perc_WAKE_all_basal), stdError(data_perc_WAKE_all_basal),'color',col_sal)
plot(nanmean(data_perc_WAKE_all_cno),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_perc_WAKE_all_cno), stdError(data_perc_WAKE_all_cno),'color',col_cno)
xlim([0 9])
makepretty
ylabel('Wake percentage')
title('Wake')

subplot(4,6,[3,4]), hold on %NREM percentage overtime
plot(nanmean(data_perc_SWS_all_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_perc_SWS_all_basal), stdError(data_perc_SWS_all_basal),'color',col_sal)
plot(nanmean(data_perc_SWS_all_cno),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_perc_SWS_all_cno), stdError(data_perc_SWS_all_cno),'color',col_cno)
xlim([0 9])
makepretty
ylabel('NREM percentage')
title('NREM sleep')

subplot(4,6,[5,6]), hold on %REM percentage overtime
plot(nanmean(data_perc_REM_all_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_perc_REM_all_basal), stdError(data_perc_REM_all_basal),'color',col_sal)
plot(nanmean(data_perc_REM_all_cno),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_perc_REM_all_cno), stdError(data_perc_REM_all_cno),'color',col_cno)
xlim([0 9])
makepretty
ylabel('REM percentage')
title('REM sleep')


subplot(4,6,[7,8]) % wake percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_WAKE_all_basal(:,timeBinPre),2), nanmean(data_perc_WAKE_all_cno(:,timeBinPre),2),...
    nanmean(data_perc_WAKE_all_basal(:,timeBinPost),2), nanmean(data_perc_WAKE_all_cno(:,timeBinPost),2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('WAKE percentage')
makepretty
xlabel('Time after stress (h)')

timebin=timeBinPre;
[p_basal_cno,h] = ranksum(nanmean(data_perc_WAKE_all_basal(:,timebin),2),nanmean(data_perc_WAKE_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[1 2]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end

timebin=timeBinPost;
[p_basal_cno,h] = ranksum(nanmean(data_perc_WAKE_all_basal(:,timebin),2),nanmean(data_perc_WAKE_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[4 5]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_SWS_all_basal(:,timeBinPre),2), nanmean(data_perc_SWS_all_cno(:,timeBinPre),2),...
    nanmean(data_perc_SWS_all_basal(:,timeBinPost),2), nanmean(data_perc_SWS_all_cno(:,timeBinPost),2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-8'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
xlabel('Time after stress (h)')

timebin=timeBinPre;
[p_basal_cno,h] = ranksum(nanmean(data_perc_REM_all_basal(:,timebin),2),nanmean(data_perc_REM_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[1 2]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end

timebin=timeBinPost;
[p_basal_cno,h] = ranksum(nanmean(data_perc_REM_all_basal(:,timebin),2),nanmean(data_perc_REM_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[4 5]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_REM_all_basal(:,timeBinPre),2), nanmean(data_perc_REM_all_cno(:,timeBinPre),2),...
    nanmean(data_perc_REM_all_basal(:,timeBinPost),2), nanmean(data_perc_REM_all_cno(:,timeBinPost),2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-8'}); xtickangle(0)
ylabel('REM percentage')
makepretty
xlabel('Time after stress (h)')

timebin=timeBinPre;
[p_basal_cno,h] = ranksum(nanmean(data_perc_REM_all_basal(:,timebin),2),nanmean(data_perc_REM_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[1 2]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end

timebin=timeBinPost;
[p_basal_cno,h] = ranksum(nanmean(data_perc_REM_all_basal(:,timebin),2),nanmean(data_perc_REM_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[4 5]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[13,14]), hold on % REM bouts number ovetime
plot(nanmean(data_num_REM_all_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_num_REM_all_basal), stdError(data_num_REM_all_basal),'color',col_sal)
plot(nanmean(data_num_REM_all_cno),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_num_REM_all_cno), stdError(data_num_REM_all_cno),'color',col_cno)
xlim([0 9])
makepretty
ylabel('REM bouts number')


subplot(4,6,[15,16]), hold on % REM bouts mean duraion overtime
plot(nanmean(data_dur_REM_all_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_dur_REM_all_basal), stdError(data_dur_REM_all_basal),'color',col_sal)
plot(nanmean(data_dur_REM_all_cno),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_dur_REM_all_cno), stdError(data_dur_REM_all_cno),'color',col_cno)
xlim([0 9])
makepretty
ylabel('REM bouts mean duration (s)')


subplot(4,6,[17]) % FI REM (5-8h)
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_all_basal(:,timeBinPost),2)./nanmean(data_dur_REM_all_basal(:,timeBinPost),2),...
    nanmean(data_num_REM_all_cno(:,timeBinPost),2)./nanmean(data_dur_REM_all_cno(:,timeBinPost),2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
makepretty
xticks([1:2]);xticklabels({'Control','cnoS+sal'}); xtickangle(0)
ylabel('REM fragmentation index')

timebin=timeBinPost;
[p_basal_cno,h] = ranksum(nanmean(data_num_REM_all_basal(:,timeBinPost),2)./nanmean(data_dur_REM_all_basal(:,timeBinPost),2), nanmean(data_num_REM_all_cno(:,timeBinPost),2)./nanmean(data_dur_REM_all_cno(:,timeBinPost),2));
if p_basal_cno<0.05; sigstar_DB({[1 2]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end

subplot(4,6,[19,20]) % REM bouts number quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_all_basal(:,timeBinPre),2), nanmean(data_num_REM_all_cno(:,timeBinPre),2),...
    nanmean(data_num_REM_all_basal(:,timeBinPost),2), nanmean(data_num_REM_all_cno(:,timeBinPost),2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM bouts number')
makepretty
xlabel('Time after stress (h)')

timebin=timeBinPre;
[p_basal_cno,h] = ranksum(nanmean(data_num_REM_all_basal(:,timebin),2),nanmean(data_num_REM_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[1 2]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end

timebin=timeBinPost;
[p_basal_cno,h] = ranksum(nanmean(data_num_REM_all_basal(:,timebin),2),nanmean(data_num_REM_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[4 5]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[21,22]) % REM bouts mean duraion quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_dur_REM_all_basal(:,timeBinPre),2), nanmean(data_dur_REM_all_cno(:,timeBinPre),2),...
    nanmean(data_dur_REM_all_basal(:,timeBinPost),2), nanmean(data_dur_REM_all_cno(:,timeBinPost),2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM bouts mean duration (s)')
makepretty
xlabel('Time after stress (h)')

timebin=timeBinPre;
[p_basal_cno,h] = ranksum(nanmean(data_dur_REM_all_basal(:,timebin),2),nanmean(data_dur_REM_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[1 2]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end

timebin=timeBinPost;
[p_basal_cno,h] = ranksum(nanmean(data_dur_REM_all_basal(:,timebin),2),nanmean(data_dur_REM_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[4 5]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[23]) %proba stay rem (timeBinPosth)
PlotErrorBarN_KJ({...
    1-(nanmean(data_REM_SWS_all_basal(:,timeBinPost),2)+nanmean(data_REM_WAKE_all_basal(:,timeBinPost),2)),...
    1-(nanmean(data_REM_SWS_all_cno(:,timeBinPost),2)+nanmean(data_REM_WAKE_all_cno(:,timeBinPost),2))},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1:2]); xticklabels({'Control','cnoS+sal'}); xtickangle(0)
ylabel('REM stay probability')
makepretty

timebin=timeBinPost;
[p_basal_cno,h]=ranksum(1-(nanmean(data_REM_SWS_all_basal(:,timebin),2)+nanmean(data_REM_WAKE_all_basal(:,timebin),2)), 1-(nanmean(data_REM_SWS_all_cno(:,timebin),2)+nanmean(data_REM_WAKE_all_cno(:,timebin),2)));
if p_basal_cno<0.05; sigstar_DB({[1 2]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end
ylabel('REM stay probability')
makepretty
ylim([.9 1])


subplot(4,6,[24]) %proba initiate rem (5-9h)
PlotErrorBarN_KJ({...
    nanmean(data_SWS_REM_all_basal(:,timeBinPost),2)+nanmean(data_WAKE_REM_all_basal(:,timeBinPost),2),...
    nanmean(data_SWS_REM_all_cno(:,timeBinPost),2)+nanmean(data_WAKE_REM_all_cno(:,timeBinPost),2)},...
    'newfig',0,'paired',1,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1:2]); xticklabels({'Control','cnoS+sal','cnoS+cno'}); xtickangle(0)
ylabel('REM initiation probability')
makepretty

timebin=timeBinPost;
[p_basal_cno,h]=ranksum(nanmean(data_SWS_REM_all_basal(:,timebin),2)+nanmean(data_WAKE_REM_all_basal(:,timebin),2), nanmean(data_SWS_REM_all_cno(:,timebin),2)+nanmean(data_WAKE_REM_all_cno(:,timebin),2));
if p_basal_cno<0.05; sigstar_DB({[1 2]},p_basal_cno,0,'LineWigth',16,'StarSize',24);end




