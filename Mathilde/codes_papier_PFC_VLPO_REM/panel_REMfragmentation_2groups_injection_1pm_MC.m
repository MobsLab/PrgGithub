%% 06/04/2023
%%ATTENTION : probleme dans la quantification moyenne des variables sur large fenetre (courbe au cours du temps et barplot ne quantifient pas la meme chose)
%%Priviliégier figures with quantification moyenne des points par heures de la courbe jusqu'a résolution

%% input dir
%DIR INHI DREADDS PFC-VLPO SAL/CNO (basal sleep)

% Dir_sal=PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_9am_SleepPostEPM');
% Dir_cno = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_9am_SleepPostEPM');
% Dir_sal=PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_SalineInjection_1pm');
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_CNOInjection_1pm');

% Dir_sal=PathForExperiments_DREADD_MC('inhibDREADD_retroCre_PFC_VLPO_SalineInjection_1pm');
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_retroCre_PFC_VLPO_CNOInjection_1pm');

% Dir_sal=PathForExperiments_DREADD_MC('inhibDREADD_PFC_SalineInjection_1pm');
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_PFC_CNOInjection_1pm');



% %%DIR INHI DREADDS PFC SAL/CNO (basal sleep)
% Dir_sal=PathForExperiments_DREADD_MC('inhibDREADD_retroCre_PFC_VLPO_SalineInjection_1pm');%inhibDREADD_PFC_SalineInjection_1pm
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_PFC_CNOInjection_1pm');

% % %%DIR EXCI DREADDS CRH VLPO SAL/CNO (basal sleep)
% Dir_sal = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% Dir_sal = RestrictPathForExperiment(Dir_sal, 'nMice', [1218 1219 1220 1371 1372 1373 1374]);%1217
% Dir_cno = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');
% Dir_cno = RestrictPathForExperiment(Dir_cno, 'nMice', [1218 1219 1220 1371 1372 1373 1374]);%1217

%SALINE VS BASELINE SLEEP
% Dir_sal_1=PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% Dir_sal_2=PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1mg_1pm');
% Dir_sal_3=PathForExperiments_DREADD_MC('inhibDREADD_PFC_SalineInjection_1pm');
% Dir_sal_4=PathForExperiments_DREADD_MC('inhibDREADD_retroCre_PFC_VLPO_SalineInjection_1pm');
% Dir_sal_6=PathForExperiments_DREADD_MC('noDREADD_SalineInjection_1pm');
% Dir_sal_7=PathForExperiments_DREADD_MC('noDREADD_SalineInjection_1mg_1pm');
% Dir_sal_8 = PathForExperimentsFLX_MC('dreadd_PFC_saline_flx');
% Dir_sal_merge_1 = MergePathForExperiment(Dir_sal_1,Dir_sal_2);
% Dir_sal_merge_2 = MergePathForExperiment(Dir_sal_3,Dir_sal_4);
% Dir_sal_merge_4 = MergePathForExperiment(Dir_sal_7,Dir_sal_8);
% Dir_sal_merge_A = MergePathForExperiment(Dir_sal_merge_1,Dir_sal_merge_2);
% Dir_sal_merge_B = MergePathForExperiment(Dir_sal_6,Dir_sal_merge_4);
% Dir_sal = MergePathForExperiment(Dir_sal_merge_A,Dir_sal_merge_B);

% Dir_basal_1=PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_BaselineSleep');
% Dir_basal_1= RestrictPathForExperiment(Dir_basal_1, 'nMice', [1118 1150 1217 1218 1219 1220]);
% Dir_basal_2=PathForExperiments_DREADD_MC('inhibDREADD_PFC_BaselineSleep');
% Dir_basal_3=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_BaselineSleep');
% Dir_basal_4 = PathForExperimentsSD_MC('BaselineSleep');
% Dir_basal_5=PathForExperiments_Opto_MC('PFC_Baseline');
% Dir_basal_5= RestrictPathForExperiment(Dir_basal_5, 'nMice', [1109]);
% Dir_basal_6 = PathForExperimentsAtropine_MC('BaselineSleep');
% Dir_basal_merge_1 = MergePathForExperiment(Dir_basal_1,Dir_basal_2);
% Dir_basal_merge_2 = MergePathForExperiment(Dir_basal_3,Dir_basal_4);
% Dir_basal_merge_3 = MergePathForExperiment(Dir_basal_5,Dir_basal_6);
% Dir_basal_merge_A = MergePathForExperiment(Dir_basal_merge_1,Dir_basal_merge_2);
% Dir_cno = MergePathForExperiment(Dir_basal_merge_A,Dir_basal_merge_3);
% 
% %%compare CRH-C57
% Dir_basal_2=PathForExperiments_DREADD_MC('inhibDREADD_PFC_BaselineSleep');
% Dir_basal_3=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_BaselineSleep');
% Dir_basal_4 = PathForExperimentsSD_MC('BaselineSleep');
% Dir_basal_merge_1 = MergePathForExperiment(Dir_basal_2,Dir_basal_3);
% Dir_sal = MergePathForExperiment(Dir_basal_merge_1,Dir_basal_4);
% 
% Dir_basal_1=PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_BaselineSleep');
% Dir_basal_1= RestrictPathForExperiment(Dir_basal_1, 'nMice', [1217 1218 1219 1220]); %1148 1150
% Dir_basal_6 = PathForExperimentsAtropine_MC('BaselineSleep');
% Dir_a= RestrictPathForExperiment(Dir_basal_6, 'nMice', [1105 1106 1107]);
% Dir_cno = MergePathForExperiment(Dir_basal_1,Dir_a);

%%

% Dir_basal_1=PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_BaselineSleep');
% Dir_basal_1= RestrictPathForExperiment(Dir_basal_1, 'nMice', [1148 1150 1217 1218 1219 1220]);
% Dir_basal_2=PathForExperiments_DREADD_MC('inhibDREADD_PFC_BaselineSleep');
% Dir_basal_3=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_BaselineSleep');
% Dir_basal_4 = PathForExperimentsSD_MC('BaselineSleep');
% Dir_basal_5=PathForExperiments_Opto_MC('PFC_Baseline');
% Dir_basal_5= RestrictPathForExperiment(Dir_basal_5, 'nMice', [1109]);
% Dir_basal_6 = PathForExperimentsAtropine_MC('BaselineSleep');
% Dir_basal_merge_1 = MergePathForExperiment(Dir_basal_1,Dir_basal_2);
% Dir_basal_merge_2 = MergePathForExperiment(Dir_basal_3,Dir_basal_4);
% Dir_basal_merge_3 = MergePathForExperiment(Dir_basal_5,Dir_basal_6);
% Dir_basal_merge_A = MergePathForExperiment(Dir_basal_merge_1,Dir_basal_merge_2);
% Dir_basal = MergePathForExperiment(Dir_basal_merge_A,Dir_basal_merge_3);
% 
% 
% Dir_sal= RestrictPathForExperiment(Dir_basal, 'nMice', [1150 1236  1424 1217 1218 1219 1220 1196 1197 1198 1235 1423 1425 1433 1434 1237 1238 1426]); %% souris jeunes
% Dir_cno= RestrictPathForExperiment(Dir_basal, 'nMice', [1107 1075 1112 1109 1105 1106]); %% souris vieilles

% Dir_sal = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% Dir_cno = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');

%%

%% compare sleep C57 and CRH-cre
%%dir C57 mice
%%compare CRH-C57
Dir_basal_2=PathForExperiments_DREADD_MC('inhibDREADD_PFC_BaselineSleep');
Dir_basal_3=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_BaselineSleep');
Dir_basal_4 = PathForExperiments_SD_MC('BaselineSleep');
Dir_basal_merge_1 = MergePathForExperiment(Dir_basal_2,Dir_basal_3);
Dir_sal = MergePathForExperiment(Dir_basal_merge_1,Dir_basal_4);

%%dir CRH-cre mice
DirBasal_dreadd1 = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_BaselineSleep');
DirBasal_dreadd2 = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
Dir_cno = MergePathForExperiment(DirBasal_dreadd1,DirBasal_dreadd2);



%% parameters
tempbin = 3600;

%%Basal sleep W/ injection at 1pm
t_inj = 13;
t_start = 9;
t_end = 18;

%% GET DATA
%%saline group
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
    
    idx_injection_time_basal{j} = find(ceil(VecTimeDay_basal{j})==t_inj,1,'first'); %get index for the injection time
    
    idx_same_st_basal{j} = find(VecTimeDay_basal{j}>t_start,1,'first'); % get index to get same beg and end of the time period to analyze
%     idx_same_st_basal{j} = find(ceil(VecTimeDay_basal{j})>=t_start,1,'first'); % get index to get same beg and end of the time period to analyze

    idx_same_en_basal{j} = find(ceil(VecTimeDay_basal{j})==t_end,1,'last');
    

    
    
    
    injection_time_basal{j} = vec_tps_recording_basal{j}(idx_injection_time_basal{j}); %get the corresponding values
    same_st_basal{j} = vec_tps_recording_basal{j}(idx_same_st_basal{j});
    same_en_basal{j} = vec_tps_recording_basal{j}(idx_same_en_basal{j});
    
    same_epoch_basal{j} =  intervalSet(same_st_basal{j}, same_en_basal{j});
    
    same_epoch_pre_basal{j} =  intervalSet(same_st_basal{j}, injection_time_basal{j});
    same_epoch_post_basal{j} =  intervalSet(injection_time_basal{j}, same_en_basal{j});
        
    
    %%compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'wake',tempbin,same_st_basal{j},same_en_basal{j});
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
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'SWS',tempbin,same_st_basal{j},same_en_basal{j});
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
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'REM',tempbin,same_st_basal{j},same_en_basal{j});
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
%     [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stages_basal{j}.Wake,same_epoch_pre_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_pre_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_pre_basal{j}),same_st_basal{j},injection_time_basal{j});
%     tot_sleep_dur_pre_basal(j)=sleep_Tduration;
% 
%     [sleep_Tduration]=Get_TotalSleepDuration_OverTimeWindows_MC(and(stages_basal{j}.Wake,same_epoch_post_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_post_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}),injection_time_basal{j},same_en_basal{j});
%     tot_sleep_dur_post_basal(j)=sleep_Tduration;

        
        
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_version2_VF(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),tempbin,same_st_basal{j},same_en_basal{j});
    all_trans_REM_REM_all_basal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_all_basal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_all_basal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_all_basal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_all_basal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_all_basal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_all_basal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_all_basal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_all_basal{j} = trans_WAKE_to_WAKE;
    
    
    
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_basal{j}.Wake,same_epoch_pre_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_pre_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_pre_basal{j}),tempbin,same_st_basal{j},injection_time_basal{j});
    all_trans_REM_REM_pre_basal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_pre_basal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_pre_basal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_pre_basal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_pre_basal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_pre_basal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_pre_basal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_pre_basal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_pre_basal{j} = trans_WAKE_to_WAKE;
    
    
    
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_basal{j}.Wake,same_epoch_post_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_post_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_post_basal{j}),tempbin,injection_time_basal{j},same_en_basal{j});
    all_trans_REM_REM_post_basal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_post_basal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_post_basal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_post_basal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_post_basal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_post_basal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_post_basal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_post_basal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_post_basal{j} = trans_WAKE_to_WAKE;
    
    
    
end
%%
%%percentage/duration/number
for imouse=1:length(dur_REM_pre_basal)
    %     data_dur_TOT_REM_basal(imouse,:) = dur_TOT_REM_basal{imouse}; data_dur_TOT_REM_basal(isnan(data_dur_TOT_REM_basal)==1)=0;
    
    data_dur_WAKE_all_basal(imouse,:) = dur_WAKE_all_basal{imouse}; data_dur_WAKE_all_basal(isnan(data_dur_WAKE_all_basal)==1)=0;
    data_num_WAKE_all_basal(imouse,:) = num_WAKE_all_basal{imouse}; data_num_WAKE_all_basal(isnan(data_num_WAKE_all_basal)==1)=0;
    data_perc_WAKE_all_basal(imouse,:) = perc_WAKE_all_basal{imouse}; %data_perc_WAKE_all_basal(isnan(data_perc_WAKE_all_basal)==1)=0;
    
    data_dur_WAKE_pre_basal(imouse,:) = dur_WAKE_pre_basal{imouse}; data_dur_WAKE_pre_basal(isnan(data_dur_WAKE_pre_basal)==1)=0;
    data_num_WAKE_pre_basal(imouse,:) = num_WAKE_pre_basal{imouse}; data_num_WAKE_pre_basal(isnan(data_num_WAKE_pre_basal)==1)=0;
    data_perc_WAKE_pre_basal(imouse,:) = perc_WAKE_pre_basal{imouse}; %data_perc_WAKE_pre_basal(isnan(data_perc_WAKE_pre_basal)==1)=0;
    
    data_dur_WAKE_post_basal(imouse,:) = dur_WAKE_post_basal{imouse}; data_dur_WAKE_post_basal(isnan(data_dur_WAKE_post_basal)==1)=0;
    data_num_WAKE_post_basal(imouse,:) = num_WAKE_post_basal{imouse}; data_num_WAKE_post_basal(isnan(data_num_WAKE_post_basal)==1)=0;
    data_perc_WAKE_post_basal(imouse,:) = perc_WAKE_post_basal{imouse}; %data_perc_WAKE_post_basal(isnan(data_perc_WAKE_post_basal)==1)=0;
    
    
    data_dur_SWS_all_basal(imouse,:) = dur_SWS_all_basal{imouse}; data_dur_SWS_all_basal(isnan(data_dur_SWS_all_basal)==1)=0;
    data_num_SWS_all_basal(imouse,:) = num_SWS_all_basal{imouse}; data_num_SWS_all_basal(isnan(data_num_SWS_all_basal)==1)=0;
    data_perc_SWS_all_basal(imouse,:) = perc_SWS_all_basal{imouse};% data_perc_SWS_all_basal(isnan(data_perc_SWS_all_basal)==1)=0;
    
    data_dur_SWS_pre_basal(imouse,:) = dur_SWS_pre_basal{imouse}; data_dur_SWS_pre_basal(isnan(data_dur_SWS_pre_basal)==1)=0;
    data_num_SWS_pre_basal(imouse,:) = num_SWS_pre_basal{imouse}; data_num_SWS_pre_basal(isnan(data_num_SWS_pre_basal)==1)=0;
    data_perc_SWS_pre_basal(imouse,:) = perc_SWS_pre_basal{imouse}; %data_perc_SWS_pre_basal(isnan(data_perc_SWS_pre_basal)==1)=0;
    
    data_dur_SWS_post_basal(imouse,:) = dur_SWS_post_basal{imouse}; data_dur_SWS_post_basal(isnan(data_dur_SWS_post_basal)==1)=0;
    data_num_SWS_post_basal(imouse,:) = num_SWS_post_basal{imouse}; data_num_SWS_post_basal(isnan(data_num_SWS_post_basal)==1)=0;
    data_perc_SWS_post_basal(imouse,:) = perc_SWS_post_basal{imouse}; %data_perc_SWS_post_basal(isnan(data_perc_SWS_post_basal)==1)=0;
    
    
    
    data_dur_REM_all_basal(imouse,:) = dur_REM_all_basal{imouse}; data_dur_REM_all_basal(isnan(data_dur_REM_all_basal)==1)=0;
    data_num_REM_all_basal(imouse,:) = num_REM_all_basal{imouse}; data_num_REM_all_basal(isnan(data_num_REM_all_basal)==1)=0;
    data_perc_REM_all_basal(imouse,:) = perc_REM_all_basal{imouse}; %data_perc_REM_all_basal(isnan(data_perc_REM_all_basal)==1)=0;
    
    data_dur_REM_pre_basal(imouse,:) = dur_REM_pre_basal{imouse}; data_dur_REM_pre_basal(isnan(data_dur_REM_pre_basal)==1)=0;
    data_num_REM_pre_basal(imouse,:) = num_REM_pre_basal{imouse}; data_num_REM_pre_basal(isnan(data_num_REM_pre_basal)==1)=0;
    data_perc_REM_pre_basal(imouse,:) = perc_REM_pre_basal{imouse};% data_perc_REM_pre_basal(isnan(data_perc_REM_pre_basal)==1)=0;
    
    data_dur_REM_post_basal(imouse,:) = dur_REM_post_basal{imouse}; %data_dur_REM_post_basal(isnan(data_dur_REM_post_basal)==1)=0;
    data_num_REM_post_basal(imouse,:) = num_REM_post_basal{imouse}; data_num_REM_post_basal(isnan(data_num_REM_post_basal)==1)=0;
    data_perc_REM_post_basal(imouse,:) = perc_REM_post_basal{imouse}; %data_perc_REM_post_basal(isnan(data_perc_REM_post_basal)==1)=0;
    
end
%% probability
for imouse=1:length(all_trans_REM_REM_all_basal)
    data_REM_REM_all_basal(imouse,:) = all_trans_REM_REM_all_basal{imouse}; %data_REM_REM_all_basal(isnan(data_REM_REM_all_basal)==1)=0;
    data_REM_SWS_all_basal(imouse,:) = all_trans_REM_SWS_all_basal{imouse}; %data_REM_SWS_all_basal(isnan(data_REM_SWS_all_basal)==1)=0;
    data_REM_WAKE_all_basal(imouse,:) = all_trans_REM_WAKE_all_basal{imouse};% data_REM_WAKE_all_basal(isnan(data_REM_WAKE_all_basal)==1)=0;
    
    data_SWS_SWS_all_basal(imouse,:) = all_trans_SWS_SWS_all_basal{imouse}; %data_SWS_SWS_all_basal(isnan(data_SWS_SWS_all_basal)==1)=0;
    data_SWS_REM_all_basal(imouse,:) = all_trans_SWS_REM_all_basal{imouse}; %data_SWS_REM_all_basal(isnan(data_SWS_REM_all_basal)==1)=0;
    data_SWS_WAKE_all_basal(imouse,:) = all_trans_SWS_WAKE_all_basal{imouse}; %data_SWS_WAKE_all_basal(isnan(data_SWS_WAKE_all_basal)==1)=0;
    
    data_WAKE_WAKE_all_basal(imouse,:) = all_trans_WAKE_WAKE_all_basal{imouse}; %data_WAKE_WAKE_all_basal(isnan(data_WAKE_WAKE_all_basal)==1)=0;
    data_WAKE_REM_all_basal(imouse,:) = all_trans_WAKE_REM_all_basal{imouse}; %data_WAKE_REM_all_basal(isnan(data_WAKE_REM_all_basal)==1)=0;
    data_WAKE_SWS_all_basal(imouse,:) = all_trans_WAKE_SWS_all_basal{imouse}; %data_WAKE_SWS_all_basal(isnan(data_WAKE_SWS_all_basal)==1)=0;
    
    
    
    data_REM_REM_pre_basal(imouse,:) = all_trans_REM_REM_pre_basal{imouse}; %data_REM_REM_pre_basal(isnan(data_REM_REM_pre_basal)==1)=0;
    data_REM_SWS_pre_basal(imouse,:) = all_trans_REM_SWS_pre_basal{imouse}; %data_REM_SWS_pre_basal(isnan(data_REM_SWS_pre_basal)==1)=0;
    data_REM_WAKE_pre_basal(imouse,:) = all_trans_REM_WAKE_pre_basal{imouse}; %data_REM_WAKE_pre_basal(isnan(data_REM_WAKE_pre_basal)==1)=0;
    
    data_SWS_SWS_pre_basal(imouse,:) = all_trans_SWS_SWS_pre_basal{imouse}; %data_SWS_SWS_pre_basal(isnan(data_SWS_SWS_pre_basal)==1)=0;
    data_SWS_REM_pre_basal(imouse,:) = all_trans_SWS_REM_pre_basal{imouse}; %data_SWS_REM_pre_basal(isnan(data_SWS_REM_pre_basal)==1)=0;
    data_SWS_WAKE_pre_basal(imouse,:) = all_trans_SWS_WAKE_pre_basal{imouse}; %data_SWS_WAKE_pre_basal(isnan(data_SWS_WAKE_pre_basal)==1)=0;
    
    data_WAKE_WAKE_pre_basal(imouse,:) = all_trans_WAKE_WAKE_pre_basal{imouse};% data_WAKE_WAKE_pre_basal(isnan(data_WAKE_WAKE_pre_basal)==1)=0;
    data_WAKE_REM_pre_basal(imouse,:) = all_trans_WAKE_REM_pre_basal{imouse}; %data_WAKE_REM_pre_basal(isnan(data_WAKE_REM_pre_basal)==1)=0;
    data_WAKE_SWS_pre_basal(imouse,:) = all_trans_WAKE_SWS_pre_basal{imouse}; %data_WAKE_SWS_pre_basal(isnan(data_WAKE_SWS_pre_basal)==1)=0;
    
    data_REM_REM_post_basal(imouse,:) = all_trans_REM_REM_post_basal{imouse}; %data_REM_REM_post_basal(isnan(data_REM_REM_post_basal)==1)=0;
    data_REM_SWS_post_basal(imouse,:) = all_trans_REM_SWS_post_basal{imouse}; %data_REM_SWS_post_basal(isnan(data_REM_SWS_post_basal)==1)=0;
    data_REM_WAKE_post_basal(imouse,:) = all_trans_REM_WAKE_post_basal{imouse}; %data_REM_WAKE_post_basal(isnan(data_REM_WAKE_post_basal)==1)=0;
    
    data_SWS_SWS_post_basal(imouse,:) = all_trans_SWS_SWS_post_basal{imouse}; %data_SWS_SWS_post_basal(isnan(data_SWS_SWS_post_basal)==1)=0;
    data_SWS_REM_post_basal(imouse,:) = all_trans_SWS_REM_post_basal{imouse}; %data_SWS_REM_post_basal(isnan(data_SWS_REM_post_basal)==1)=0;
    data_SWS_WAKE_post_basal(imouse,:) = all_trans_SWS_WAKE_post_basal{imouse}; %data_SWS_WAKE_post_basal(isnan(data_SWS_WAKE_post_basal)==1)=0;
    
    data_WAKE_WAKE_post_basal(imouse,:) = all_trans_WAKE_WAKE_post_basal{imouse}; %data_WAKE_WAKE_post_basal(isnan(data_WAKE_WAKE_post_basal)==1)=0;
    data_WAKE_REM_post_basal(imouse,:) = all_trans_WAKE_REM_post_basal{imouse}; %data_WAKE_REM_post_basal(isnan(data_WAKE_REM_post_basal)==1)=0;
    data_WAKE_SWS_post_basal(imouse,:) = all_trans_WAKE_SWS_post_basal{imouse};% data_WAKE_SWS_post_basal(isnan(data_WAKE_SWS_post_basal)==1)=0;
end




%%
for i=1:length(Dir_cno.path)
    cd(Dir_cno.path{i}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_cno{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_cno{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    else
    end
    
    vec_tps_recording_cno{i} = Range(stages_cno{i}.tsdMovement); %get vector to keep track of the reocrding time
    VecTimeDay_cno{i} = GetTimeOfTheDay_MC(vec_tps_recording_cno{i});
%     

all_start_time{i}=VecTimeDay_cno{i}(1);
all_end_time{i}=VecTimeDay_cno{i}(end);


    idx_injection_time_cno{i} = find(ceil(VecTimeDay_cno{i})==t_inj,1,'first'); %get index for the injection time
%     idx_same_st_cno{i} = find(VecTimeDay_cno{i}>t_start,1,'first'); % get index to get same beg and end of the time period to analyze
    idx_same_st_cno{i} = find(floor(VecTimeDay_cno{i})>=t_start,1,'first');

    idx_same_en_cno{i} = find(ceil(VecTimeDay_cno{i})==t_end,1,'last');
    
    injection_time_cno{i} = vec_tps_recording_cno{i}(idx_injection_time_cno{i}); %get the corresponding values
    same_st_cno{i} = vec_tps_recording_cno{i}(idx_same_st_cno{i});

    same_en_cno{i} = vec_tps_recording_cno{i}(idx_same_en_cno{i});
    
    same_epoch_cno{i} =  intervalSet(same_st_cno{i}, same_en_cno{i});
    
    same_epoch_pre_cno{i} =  intervalSet(same_st_cno{i}, injection_time_cno{i});
    same_epoch_post_cno{i} =  intervalSet(injection_time_cno{i}, same_en_cno{i});
    
    
    %%compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stages_cno{i}.Wake,same_epoch_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_cno{i}),'wake',tempbin,same_st_cno{i},same_en_cno{i});
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
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stages_cno{i}.Wake,same_epoch_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_cno{i}),'sws',tempbin,same_st_cno{i},same_en_cno{i});
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
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_version_2_groups_MC(and(stages_cno{i}.Wake,same_epoch_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_cno{i}),'rem',tempbin,same_st_cno{i},same_en_cno{i});
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
    
    
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_version2_VF(and(stages_cno{i}.Wake,same_epoch_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_cno{i}),tempbin,same_st_cno{i},same_en_cno{i});
    all_trans_REM_REM_all_cno{i} = trans_REM_to_REM;
    all_trans_REM_SWS_all_cno{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_all_cno{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_all_cno{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_all_cno{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_all_cno{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_all_cno{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_all_cno{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_all_cno{i} = trans_WAKE_to_WAKE;
    
    
    
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_cno{i}.Wake,same_epoch_pre_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_pre_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_pre_cno{i}),tempbin,same_st_cno{i},injection_time_cno{i});
    all_trans_REM_REM_pre_cno{i} = trans_REM_to_REM;
    all_trans_REM_SWS_pre_cno{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_pre_cno{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_pre_cno{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_pre_cno{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_pre_cno{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_pre_cno{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_pre_cno{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_pre_cno{i} = trans_WAKE_to_WAKE;
    
    
    
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_cno{i}.Wake,same_epoch_post_cno{i}),and(stages_cno{i}.SWSEpoch,same_epoch_post_cno{i}),and(stages_cno{i}.REMEpoch,same_epoch_post_cno{i}),tempbin,injection_time_cno{i},same_en_cno{i});
    all_trans_REM_REM_post_cno{i} = trans_REM_to_REM;
    all_trans_REM_SWS_post_cno{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_post_cno{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_post_cno{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_post_cno{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_post_cno{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_post_cno{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_post_cno{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_post_cno{i} = trans_WAKE_to_WAKE;
    
    
    
end
%%
%%percentage/duration/number
for imouse=1:length(dur_REM_pre_cno)
    %     data_dur_TOT_REM_cno(imouse,:) = dur_TOT_REM_cno{imouse}; data_dur_TOT_REM_cno(isnan(data_dur_TOT_REM_cno)==1)=0;
    
    data_dur_WAKE_all_cno(imouse,:) = dur_WAKE_all_cno{imouse}; data_dur_WAKE_all_cno(isnan(data_dur_WAKE_all_cno)==1)=0;
    data_num_WAKE_all_cno(imouse,:) = num_WAKE_all_cno{imouse}; data_num_WAKE_all_cno(isnan(data_num_WAKE_all_cno)==1)=0;
    data_perc_WAKE_all_cno(imouse,:) = perc_WAKE_all_cno{imouse}; %data_perc_WAKE_all_cno(isnan(data_perc_WAKE_all_cno)==1)=0;
    
    data_dur_WAKE_pre_cno(imouse,:) = dur_WAKE_pre_cno{imouse}; data_dur_WAKE_pre_cno(isnan(data_dur_WAKE_pre_cno)==1)=0;
    data_num_WAKE_pre_cno(imouse,:) = num_WAKE_pre_cno{imouse}; data_num_WAKE_pre_cno(isnan(data_num_WAKE_pre_cno)==1)=0;
    data_perc_WAKE_pre_cno(imouse,:) = perc_WAKE_pre_cno{imouse}; %data_perc_WAKE_pre_cno(isnan(data_perc_WAKE_pre_cno)==1)=0;
    
    data_dur_WAKE_post_cno(imouse,:) = dur_WAKE_post_cno{imouse}; data_dur_WAKE_post_cno(isnan(data_dur_WAKE_post_cno)==1)=0;
    data_num_WAKE_post_cno(imouse,:) = num_WAKE_post_cno{imouse}; data_num_WAKE_post_cno(isnan(data_num_WAKE_post_cno)==1)=0;
    data_perc_WAKE_post_cno(imouse,:) = perc_WAKE_post_cno{imouse}; %data_perc_WAKE_post_cno(isnan(data_perc_WAKE_post_cno)==1)=0;
    
    
    data_dur_SWS_all_cno(imouse,:) = dur_SWS_all_cno{imouse}; data_dur_SWS_all_cno(isnan(data_dur_SWS_all_cno)==1)=0;
    data_num_SWS_all_cno(imouse,:) = num_SWS_all_cno{imouse}; data_num_SWS_all_cno(isnan(data_num_SWS_all_cno)==1)=0;
    data_perc_SWS_all_cno(imouse,:) = perc_SWS_all_cno{imouse}; %data_perc_SWS_all_cno(isnan(data_perc_SWS_all_cno)==1)=0;
%     
    data_dur_SWS_pre_cno(imouse,:) = dur_SWS_pre_cno{imouse}; data_dur_SWS_pre_cno(isnan(data_dur_SWS_pre_cno)==1)=0;
    data_num_SWS_pre_cno(imouse,:) = num_SWS_pre_cno{imouse}; data_num_SWS_pre_cno(isnan(data_num_SWS_pre_cno)==1)=0;
    data_perc_SWS_pre_cno(imouse,:) = perc_SWS_pre_cno{imouse};% data_perc_SWS_pre_cno(isnan(data_perc_SWS_pre_cno)==1)=0;
    
    data_dur_SWS_post_cno(imouse,:) = dur_SWS_post_cno{imouse}; data_dur_SWS_post_cno(isnan(data_dur_SWS_post_cno)==1)=0;
    data_num_SWS_post_cno(imouse,:) = num_SWS_post_cno{imouse}; data_num_SWS_post_cno(isnan(data_num_SWS_post_cno)==1)=0;
    data_perc_SWS_post_cno(imouse,:) = perc_SWS_post_cno{imouse}; %data_perc_SWS_post_cno(isnan(data_perc_SWS_post_cno)==1)=0;
    
    
    
    data_dur_REM_all_cno(imouse,:) = dur_REM_all_cno{imouse}; data_dur_REM_all_cno(isnan(data_dur_REM_all_cno)==1)=0;
    data_num_REM_all_cno(imouse,:) = num_REM_all_cno{imouse}; data_num_REM_all_cno(isnan(data_num_REM_all_cno)==1)=0;
    data_perc_REM_all_cno(imouse,:) = perc_REM_all_cno{imouse}; %data_perc_REM_all_cno(isnan(data_perc_REM_all_cno)==1)=0;
    
    data_dur_REM_pre_cno(imouse,:) = dur_REM_pre_cno{imouse}; data_dur_REM_pre_cno(isnan(data_dur_REM_pre_cno)==1)=0;
    data_num_REM_pre_cno(imouse,:) = num_REM_pre_cno{imouse}; data_num_REM_pre_cno(isnan(data_num_REM_pre_cno)==1)=0;
    data_perc_REM_pre_cno(imouse,:) = perc_REM_pre_cno{imouse};% data_perc_REM_pre_cno(isnan(data_perc_REM_pre_cno)==1)=0;
    
    data_dur_REM_post_cno(imouse,:) = dur_REM_post_cno{imouse}; data_dur_REM_post_cno(isnan(data_dur_REM_post_cno)==1)=0;
    data_num_REM_post_cno(imouse,:) = num_REM_post_cno{imouse}; data_num_REM_post_cno(isnan(data_num_REM_post_cno)==1)=0;
    data_perc_REM_post_cno(imouse,:) = perc_REM_post_cno{imouse}; %data_perc_REM_post_cno(isnan(data_perc_REM_post_cno)==1)=0;
    
end
%% probability
for imouse=1:length(all_trans_REM_REM_all_cno)
    data_REM_REM_all_cno(imouse,:) = all_trans_REM_REM_all_cno{imouse}; %data_REM_REM_all_cno(isnan(data_REM_REM_all_cno)==1)=0;
    data_REM_SWS_all_cno(imouse,:) = all_trans_REM_SWS_all_cno{imouse}; %data_REM_SWS_all_cno(isnan(data_REM_SWS_all_cno)==1)=0;
    data_REM_WAKE_all_cno(imouse,:) = all_trans_REM_WAKE_all_cno{imouse}; %data_REM_WAKE_all_cno(isnan(data_REM_WAKE_all_cno)==1)=0;
    
    data_SWS_SWS_all_cno(imouse,:) = all_trans_SWS_SWS_all_cno{imouse}; %data_SWS_SWS_all_cno(isnan(data_SWS_SWS_all_cno)==1)=0;
    data_SWS_REM_all_cno(imouse,:) = all_trans_SWS_REM_all_cno{imouse}; %data_SWS_REM_all_cno(isnan(data_SWS_REM_all_cno)==1)=0;
    data_SWS_WAKE_all_cno(imouse,:) = all_trans_SWS_WAKE_all_cno{imouse}; %data_SWS_WAKE_all_cno(isnan(data_SWS_WAKE_all_cno)==1)=0;
    
    data_WAKE_WAKE_all_cno(imouse,:) = all_trans_WAKE_WAKE_all_cno{imouse}; %data_WAKE_WAKE_all_cno(isnan(data_WAKE_WAKE_all_cno)==1)=0;
    data_WAKE_REM_all_cno(imouse,:) = all_trans_WAKE_REM_all_cno{imouse}; %data_WAKE_REM_all_cno(isnan(data_WAKE_REM_all_cno)==1)=0;
    data_WAKE_SWS_all_cno(imouse,:) = all_trans_WAKE_SWS_all_cno{imouse};% data_WAKE_SWS_all_cno(isnan(data_WAKE_SWS_all_cno)==1)=0;
    
    
    
    data_REM_REM_pre_cno(imouse,:) = all_trans_REM_REM_pre_cno{imouse}; %data_REM_REM_pre_cno(isnan(data_REM_REM_pre_cno)==1)=0;
    data_REM_SWS_pre_cno(imouse,:) = all_trans_REM_SWS_pre_cno{imouse}; %data_REM_SWS_pre_cno(isnan(data_REM_SWS_pre_cno)==1)=0;
    data_REM_WAKE_pre_cno(imouse,:) = all_trans_REM_WAKE_pre_cno{imouse}; %data_REM_WAKE_pre_cno(isnan(data_REM_WAKE_pre_cno)==1)=0;
    
    data_SWS_SWS_pre_cno(imouse,:) = all_trans_SWS_SWS_pre_cno{imouse}; %data_SWS_SWS_pre_cno(isnan(data_SWS_SWS_pre_cno)==1)=0;
    data_SWS_REM_pre_cno(imouse,:) = all_trans_SWS_REM_pre_cno{imouse}; %data_SWS_REM_pre_cno(isnan(data_SWS_REM_pre_cno)==1)=0;
    data_SWS_WAKE_pre_cno(imouse,:) = all_trans_SWS_WAKE_pre_cno{imouse}; %data_SWS_WAKE_pre_cno(isnan(data_SWS_WAKE_pre_cno)==1)=0;
    
    data_WAKE_WAKE_pre_cno(imouse,:) = all_trans_WAKE_WAKE_pre_cno{imouse}; %data_WAKE_WAKE_pre_cno(isnan(data_WAKE_WAKE_pre_cno)==1)=0;
    data_WAKE_REM_pre_cno(imouse,:) = all_trans_WAKE_REM_pre_cno{imouse}; %data_WAKE_REM_pre_cno(isnan(data_WAKE_REM_pre_cno)==1)=0;
    data_WAKE_SWS_pre_cno(imouse,:) = all_trans_WAKE_SWS_pre_cno{imouse}; %data_WAKE_SWS_pre_cno(isnan(data_WAKE_SWS_pre_cno)==1)=0;
    
    data_REM_REM_post_cno(imouse,:) = all_trans_REM_REM_post_cno{imouse}; %data_REM_REM_post_cno(isnan(data_REM_REM_post_cno)==1)=0;
    data_REM_SWS_post_cno(imouse,:) = all_trans_REM_SWS_post_cno{imouse}; %data_REM_SWS_post_cno(isnan(data_REM_SWS_post_cno)==1)=0;
    data_REM_WAKE_post_cno(imouse,:) = all_trans_REM_WAKE_post_cno{imouse}; %data_REM_WAKE_post_cno(isnan(data_REM_WAKE_post_cno)==1)=0;
    
    data_SWS_SWS_post_cno(imouse,:) = all_trans_SWS_SWS_post_cno{imouse}; %data_SWS_SWS_post_cno(isnan(data_SWS_SWS_post_cno)==1)=0;
    data_SWS_REM_post_cno(imouse,:) = all_trans_SWS_REM_post_cno{imouse}; %data_SWS_REM_post_cno(isnan(data_SWS_REM_post_cno)==1)=0;
    data_SWS_WAKE_post_cno(imouse,:) = all_trans_SWS_WAKE_post_cno{imouse}; %data_SWS_WAKE_post_cno(isnan(data_SWS_WAKE_post_cno)==1)=0;
    
    data_WAKE_WAKE_post_cno(imouse,:) = all_trans_WAKE_WAKE_post_cno{imouse}; %data_WAKE_WAKE_post_cno(isnan(data_WAKE_WAKE_post_cno)==1)=0;
    data_WAKE_REM_post_cno(imouse,:) = all_trans_WAKE_REM_post_cno{imouse};% data_WAKE_REM_post_cno(isnan(data_WAKE_REM_post_cno)==1)=0;
    data_WAKE_SWS_post_cno(imouse,:) = all_trans_WAKE_SWS_post_cno{imouse}; %data_WAKE_SWS_post_cno(isnan(data_WAKE_SWS_post_cno)==1)=0;
end


%% FIGURE (comparaison 2 groupes)
col_sal = [.8 .8 .8];
% col_cno = [1 .4 .2];

% col_cno = [1 0 0];
col_cno = [.3 .3 .3];


figure
subplot(4,6,[1,2]), hold on % wake percentage overtime
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
    nanmean(data_perc_WAKE_pre_basal,2), nanmean(data_perc_WAKE_pre_cno,2),...
    nanmean(data_perc_WAKE_post_basal,2), nanmean(data_perc_WAKE_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('WAKE percentage')
makepretty
xlabel('Time (h)')

timebin=1:4;
[p_pre_basal_pre_cno,h] = ranksum(nanmean(data_perc_WAKE_pre_basal,2),nanmean(data_perc_WAKE_pre_cno,2));
if p_pre_basal_pre_cno<0.05; sigstar_DB({[1 2]},p_pre_basal_pre_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_post_basal_post_cno,h] = ranksum(nanmean(data_perc_WAKE_post_basal,2),nanmean(data_perc_WAKE_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[4 5]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end





subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_SWS_pre_basal,2), nanmean(data_perc_SWS_pre_cno,2),...
    nanmean(data_perc_SWS_post_basal,2), nanmean(data_perc_SWS_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
xlabel('Time (h)')

[p_pre_basal_pre_cno,h] = ranksum(nanmean(data_perc_SWS_pre_basal,2),nanmean(data_perc_SWS_pre_cno,2));
if p_pre_basal_pre_cno<0.05; sigstar_DB({[1 2]},p_pre_basal_pre_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_post_basal_post_cno,h] = ranksum(nanmean(data_perc_SWS_post_basal,2),nanmean(data_perc_SWS_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[4 5]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end




subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_REM_pre_basal,2), nanmean(data_perc_REM_pre_cno,2),...
    nanmean(data_perc_REM_post_basal,2), nanmean(data_perc_REM_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM percentage')
makepretty
xlabel('Time (h)')

timebin=1:4;
[p_pre_basal_pre_cno,h] = ranksum(nanmean(data_perc_REM_pre_basal,2),nanmean(data_perc_REM_pre_cno,2));
if p_pre_basal_pre_cno<0.05; sigstar_DB({[1 2]},p_pre_basal_pre_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_post_basal_post_cno,h] = ranksum(nanmean(data_perc_REM_post_basal,2),nanmean(data_perc_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[4 5]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end





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




subplot(4,6,[17]) % FI REM (5-9h)
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_post_basal,2)./nanmean(data_dur_REM_post_basal,2),...
    nanmean(data_num_REM_post_cno,2)./nanmean(data_dur_REM_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
makepretty
xticks([1:2]);xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM fragmentation index')

timebin=5:9;
[p_post_basal_post_cno,h] = ranksum(nanmean(data_num_REM_post_basal,2)./nanmean(data_dur_REM_post_basal,2), nanmean(data_num_REM_post_cno,2)./nanmean(data_dur_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end




subplot(4,6,[19,20]) % REM bouts number quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_pre_basal,2), nanmean(data_num_REM_pre_cno,2),...
    nanmean(data_num_REM_post_basal,2), nanmean(data_num_REM_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM bouts number')
makepretty
xlabel('Time (h)')

timebin=1:4;
[p_pre_basal_pre_cno,h] = ranksum(nanmean(data_num_REM_pre_basal,2),nanmean(data_num_REM_pre_cno,2));
if p_pre_basal_pre_cno<0.05; sigstar_DB({[1 2]},p_pre_basal_pre_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_post_basal_post_cno,h] = ranksum(nanmean(data_num_REM_post_basal,2),nanmean(data_num_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[4 5]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end




subplot(4,6,[21,22]) % REM bouts mean duraion quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_dur_REM_pre_basal,2), nanmean(data_dur_REM_pre_cno,2),...
    nanmean(data_dur_REM_post_basal,2), nanmean(data_dur_REM_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM bouts mean duration (s)')
makepretty
xlabel('Time (h)')

[p_pre_basal_pre_cno,h] = ranksum(nanmean(data_dur_REM_pre_basal,2),nanmean(data_dur_REM_pre_cno,2));
if p_pre_basal_pre_cno<0.05; sigstar_DB({[1 2]},p_pre_basal_pre_cno,0,'LineWigth',16,'StarSize',24);end

[p_post_basal_post_cno,h] = ranksum(nanmean(data_dur_REM_post_basal,2),nanmean(data_dur_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[4 5]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end




subplot(4,6,[24]) %proba initiate rem (5-9h)
PlotErrorBarN_KJ({...
    nanmean(data_SWS_REM_post_basal,2)+nanmean(data_WAKE_REM_post_basal,2),...
    nanmean(data_SWS_REM_post_cno,2)+nanmean(data_WAKE_REM_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1:2]); xticklabels({'Control','SDS+sal','SDS+cno'}); xtickangle(0)
ylabel('REM initiation probability')
makepretty

[p_post_basal_post_cno,h]=ranksum(nanmean(data_SWS_REM_post_basal,2)+nanmean(data_WAKE_REM_post_basal,2), nanmean(data_SWS_REM_post_cno,2)+nanmean(data_WAKE_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end




subplot(4,6,[23]) %proba stay rem (5:9h)
PlotErrorBarN_KJ({...
    1-(nanmean(data_REM_SWS_post_basal,2)+nanmean(data_REM_WAKE_post_basal,2)),...
    1-(nanmean(data_REM_SWS_post_cno,2)+nanmean(data_REM_WAKE_post_cno,2))},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1:2]); xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM stay probability')
makepretty

[p_post_basal_post_cno,h]=ranksum(1-(nanmean(data_REM_SWS_post_basal,2)+nanmean(data_REM_WAKE_post_basal,2)), 1-(nanmean(data_REM_SWS_post_cno,2)+nanmean(data_REM_WAKE_post_cno,2)));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end
ylabel('REM stay probability')
makepretty





%% FIGURE (comparaison 2 groupes)
col_sal = [.8 .8 .8];
% col_cno = [1 .4 .2];

% col_cno = [1 0 0];
col_cno = [.2 .2 .2];


figure
subplot(4,6,[1,2]), hold on % wake percentage overtime
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
    nanmean(data_perc_WAKE_all_basal(:,1:4),2), nanmean(data_perc_WAKE_all_cno(:,1:4),2),...
    nanmean(data_perc_WAKE_all_basal(:,5:9),2), nanmean(data_perc_WAKE_all_cno(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('WAKE percentage')
makepretty
xlabel('Time (h)')

timebin=1:4;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_perc_WAKE_all_basal(:,timebin),2),nanmean(data_perc_WAKE_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_perc_WAKE_all_basal(:,timebin),2),nanmean(data_perc_WAKE_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[4 5]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_SWS_all_basal(:,1:4),2), nanmean(data_perc_SWS_all_cno(:,1:4),2),...
    nanmean(data_perc_SWS_all_basal(:,5:9),2), nanmean(data_perc_SWS_all_cno(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
xlabel('Time (h)')

timebin=1:4;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_perc_SWS_all_basal(:,timebin),2),nanmean(data_perc_SWS_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_perc_SWS_all_basal(:,timebin),2),nanmean(data_perc_SWS_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[4 5]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_REM_all_basal(:,1:4),2), nanmean(data_perc_REM_all_cno(:,1:4),2),...
    nanmean(data_perc_REM_all_basal(:,5:9),2), nanmean(data_perc_REM_all_cno(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM percentage')
makepretty
xlabel('Time (h)')

timebin=1:4;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_perc_REM_all_basal(:,timebin),2),nanmean(data_perc_REM_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_perc_REM_all_basal(:,timebin),2),nanmean(data_perc_REM_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[4 5]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end


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


subplot(4,6,[17]) % FI REM (5-9h)
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_all_basal(:,5:9),2)./nanmean(data_dur_REM_all_basal(:,5:9),2),...
    nanmean(data_num_REM_all_cno(:,5:9),2)./nanmean(data_dur_REM_all_cno(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
makepretty
xticks([1:2]);xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM fragmentation index')

timebin=5:9;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_num_REM_all_basal(:,5:9),2)./nanmean(data_dur_REM_all_basal(:,5:9),2), nanmean(data_num_REM_all_cno(:,5:9),2)./nanmean(data_dur_REM_all_cno(:,5:9),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end

subplot(4,6,[19,20]) % REM bouts number quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_all_basal(:,1:4),2), nanmean(data_num_REM_all_cno(:,1:4),2),...
    nanmean(data_num_REM_all_basal(:,5:9),2), nanmean(data_num_REM_all_cno(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM bouts number')
makepretty
xlabel('Time (h)')

timebin=1:4;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_num_REM_all_basal(:,timebin),2),nanmean(data_num_REM_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_num_REM_all_basal(:,timebin),2),nanmean(data_num_REM_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[4 5]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[21,22]) % REM bouts mean duraion quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_dur_REM_all_basal(:,1:4),2), nanmean(data_dur_REM_all_cno(:,1:4),2),...
    nanmean(data_dur_REM_all_basal(:,5:9),2), nanmean(data_dur_REM_all_cno(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM bouts mean duration (s)')
makepretty
xlabel('Time (h)')

timebin=1:4;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_dur_REM_all_basal(:,timebin),2),nanmean(data_dur_REM_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_dur_REM_all_basal(:,timebin),2),nanmean(data_dur_REM_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[4 5]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[23]) %proba stay rem (5:9h)
PlotErrorBarN_KJ({...
    1-(nanmean(data_REM_SWS_all_basal(:,5:9),2)+nanmean(data_REM_WAKE_all_basal(:,5:9),2)),...
    1-(nanmean(data_REM_SWS_all_cno(:,5:9),2)+nanmean(data_REM_WAKE_all_cno(:,5:9),2))},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1:2]); xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM stay probability')
makepretty

timebin=5:9;
[p_all_basal_all_cno,h]=ranksum(1-(nanmean(data_REM_SWS_all_basal(:,timebin),2)+nanmean(data_REM_WAKE_all_basal(:,timebin),2)), 1-(nanmean(data_REM_SWS_all_cno(:,timebin),2)+nanmean(data_REM_WAKE_all_cno(:,timebin),2)));
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end
ylabel('REM stay probability')
makepretty


subplot(4,6,[24]) %proba initiate rem (5-9h)
PlotErrorBarN_KJ({...
    nanmean(data_SWS_REM_all_basal(:,5:9),2)+nanmean(data_WAKE_REM_all_basal(:,5:9),2),...
    nanmean(data_SWS_REM_all_cno(:,5:9),2)+nanmean(data_WAKE_REM_all_cno(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1:2]); xticklabels({'Control','SDS+sal','SDS+cno'}); xtickangle(0)
ylabel('REM initiation probability')
makepretty

timebin=5:9;
[p_all_basal_all_cno,h]=ranksum(nanmean(data_SWS_REM_all_basal(:,timebin),2)+nanmean(data_WAKE_REM_all_basal(:,timebin),2), nanmean(data_SWS_REM_all_cno(:,timebin),2)+nanmean(data_WAKE_REM_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[18]), 
plot(nanmean(data_num_REM_post_basal,2), nanmean(data_dur_REM_post_basal,2),'color',col_sal,'markersize',10,'marker','o','linestyle','none')
hold on, plot(nanmean(data_num_REM_post_cno,2), nanmean(data_dur_REM_post_cno,2),'color',col_cno,'markersize',10,'marker','o','linestyle','none','MarkerFaceColor',col_cno)
lsline
makepretty



%%

figure, 



subplot(3,2,1), plot(nanmean(data_perc_REM_post_basal,2), nanmean(data_perc_SWS_post_basal,2),'ko','markersize',10)
hold on, plot(nanmean(data_perc_REM_post_cno,2), nanmean(data_perc_SWS_post_cno,2),'ro','markersize',10,'MarkerFaceColor','r')
lsline
makepretty
xlabel('% REM'); ylabel('% NREM')

subplot(3,2,2), plot(nanmean(data_perc_REM_post_basal,2), nanmean(data_perc_WAKE_post_basal,2),'ko','markersize',10)
hold on, plot(nanmean(data_perc_REM_post_cno,2), nanmean(data_perc_WAKE_post_cno,2),'ro','markersize',10,'MarkerFaceColor','r')
lsline
makepretty
xlabel('% REM'); ylabel('% WAKE')

subplot(3,2,3), plot(nanmean(data_num_REM_post_basal,2), nanmean(data_num_SWS_post_basal,2),'ko','markersize',10)
hold on, plot(nanmean(data_num_REM_post_cno,2), nanmean(data_num_SWS_post_cno,2),'ro','markersize',10,'MarkerFaceColor','r')
lsline
makepretty
xlabel('# REM'); ylabel('# NREM')

subplot(3,2,4), plot(nanmean(data_num_REM_post_basal,2), nanmean(data_num_WAKE_post_basal,2),'ko','markersize',10)
hold on, plot(nanmean(data_num_REM_post_cno,2), nanmean(data_num_WAKE_post_cno,2),'ro','markersize',10,'MarkerFaceColor','r')
lsline
makepretty
xlabel('# REM'); ylabel('# WAKE')

subplot(3,2,5), plot(nanmean(data_dur_REM_post_basal,2), nanmean(data_dur_SWS_post_basal,2),'ko','markersize',10)
hold on, plot(nanmean(data_dur_REM_post_cno,2), nanmean(data_dur_SWS_post_cno,2),'ro','markersize',10,'MarkerFaceColor','r')
lsline
makepretty
xlabel('dur REM'); ylabel('dur NREM')

subplot(3,2,6), plot(nanmean(data_dur_REM_post_basal,2), nanmean(data_dur_WAKE_post_basal,2),'ko','markersize',10)
hold on, plot(nanmean(data_dur_REM_post_cno,2), nanmean(data_dur_WAKE_post_cno,2),'ro','markersize',10,'MarkerFaceColor','r')
lsline
makepretty
xlabel('dur REM'); ylabel('dur Wake')


%%

figure, plot(nanmean(data_num_REM_post_basal,2), nanmean(data_dur_REM_post_basal,2),'ko','markersize',10)
hold on, plot(nanmean(data_num_REM_post_cno,2), nanmean(data_dur_REM_post_cno,2),'ro','markersize',10,'MarkerFaceColor','r')
lsline
makepretty



%%
col_sal = [.6 .6 .6];
% col_cno = [1 .4 .2];

col_cno = [1 0 0];
% col_cno = [.3 .3 .3];

figure 
subplot(121)
%REM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_REM_all_basal(:,1:4),2), nanmean(data_perc_REM_all_cno(:,1:4),2),...
    nanmean(data_perc_REM_all_basal(:,5:9),2), nanmean(data_perc_REM_all_cno(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('Pourcentage de REM')
makepretty
xlabel('Temps (h)')

timebin=1:4;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_perc_REM_all_basal(:,timebin),2),nanmean(data_perc_REM_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_all_basal_all_cno,h] = ranksum(nanmean(data_perc_REM_all_basal(:,timebin),2),nanmean(data_perc_REM_all_cno(:,timebin),2));
if p_all_basal_all_cno<0.05; sigstar_DB({[4 5]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end


subplot(122)
PlotErrorBarN_KJ({...
    (tot_sleep_dur_pre_basal)/3600, (tot_sleep_dur_pre_cno)/3600,...
    (tot_sleep_dur_post_basal)/3600, (tot_sleep_dur_post_cno)/3600},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('Quantité totale de sommeil (h)')
makepretty
xlabel('Temps (h)')

timebin=1:4;
[p_all_basal_all_cno,h] = ranksum((tot_sleep_dur_pre_basal)/3600, (tot_sleep_dur_pre_cno)/3600);
if p_all_basal_all_cno<0.05; sigstar_DB({[1 2]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[p_all_basal_all_cno,h] = ranksum((tot_sleep_dur_post_basal)/3600, (tot_sleep_dur_post_cno)/3600);
if p_all_basal_all_cno<0.05; sigstar_DB({[4 5]},p_all_basal_all_cno,0,'LineWigth',16,'StarSize',24);end



%%

col_sal = [.7 .7 .7];
col_cno = [0 .4 .4];

figure
subplot(131)
PlotErrorBarN_MC({nanmean(data_perc_WAKE_post_basal,2), nanmean(data_perc_WAKE_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('WAKE percentage')
makepretty
[p_post_basal_post_cno,h] = ranksum(nanmean(data_perc_WAKE_post_basal,2), nanmean(data_perc_WAKE_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end



subplot(132)
PlotErrorBarN_MC({nanmean(data_perc_SWS_post_basal,2), nanmean(data_perc_SWS_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
[p_post_basal_post_cno,h] = ranksum(nanmean(data_perc_SWS_post_basal,2), nanmean(data_perc_SWS_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end


subplot(133)
PlotErrorBarN_MC({nanmean(data_perc_REM_post_basal,2), nanmean(data_perc_REM_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('REM percentage')
makepretty
[p_post_basal_post_cno,h] = ranksum(nanmean(data_perc_REM_post_basal,2), nanmean(data_perc_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end



%%
figure
subplot(131)
PlotErrorBarN_MC({nanmean(data_num_REM_post_basal,2), nanmean(data_num_REM_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('REM bouts number')
makepretty
set(gca,'fontsize',18,'fontname','Helvetica-Narrow')

[p_post_basal_post_cno,h] = ranksum(nanmean(data_num_REM_post_basal,2), nanmean(data_num_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end


subplot(132)
PlotErrorBarN_MC({nanmean(data_dur_REM_post_basal,2), nanmean(data_dur_REM_post_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('REM mean duration (s)')
makepretty
set(gca,'fontsize',18,'fontname','Helvetica-Narrow')

[p_post_basal_post_cno,h] = ranksum(nanmean(data_dur_REM_post_basal,2), nanmean(data_dur_REM_post_cno,2));
if p_post_basal_post_cno<0.05; sigstar_DB({[1 2]},p_post_basal_post_cno,0,'LineWigth',16,'StarSize',24);end


