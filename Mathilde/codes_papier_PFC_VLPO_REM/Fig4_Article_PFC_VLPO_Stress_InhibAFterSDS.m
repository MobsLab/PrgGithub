%% input dir
%%1
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');

%%2
DirSocialDefeat_sleepPost_mCherry_CNO1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');
DirSocialDefeat_sleepPost_BM_cno1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
DirSocialDefeat_sleepPost_mCherry_CNO = MergePathForExperiment(DirSocialDefeat_sleepPost_mCherry_CNO1,DirSocialDefeat_sleepPost_BM_cno1);

%%3
DirSocialDefeat_sleepPost_classic1 = PathForExperiments_SD_MC('SleepPostSD');

DirSocialDefeat_sleepPost_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_sleepPost_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_sleepPost_mCherry_saline = MergePathForExperiment(DirSocialDefeat_sleepPost_mCherry_saline1,DirSocialDefeat_sleepPost_BM_saline1);
DirSocialDefeat_sleepPost_classic = MergePathForExperiment(DirSocialDefeat_sleepPost_classic1,DirSocialDefeat_sleepPost_mCherry_saline);


%%4
DirSocialDefeat_sleepPost_dreadd_CNO = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_CNOInjection');

%%4 bis (PFC inhibition)
% DirSocialDefeat_sleepPost_dreadd_CNO = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_PFC_CNOInjection');



%% W/ DATA CRH

% Dir_ctrl=PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_SalineInjection_10am');
% 
% %%2
% DirSocialDefeat_sleepPost_classic = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_CNOInjection_10am');
% 
% %%3
% % DirSocialDefeat_sleepPost_classic1 = PathForExperiments_SD_MC('SleepPostSD');
% % % DirSocialDefeat_sleepPost_classic1 = RestrictPathForExperiment(DirSocialDefeat_sleepPost_classic1, 'nMice', [1148 1217 1218 1219 1220]);
% % 
% % DirSocialDefeat_sleepPost_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
% % DirSocialDefeat_sleepPost_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
% % DirSocialDefeat_sleepPost_mCherry_saline = MergePathForExperiment(DirSocialDefeat_sleepPost_mCherry_saline1,DirSocialDefeat_sleepPost_BM_saline1);
% % DirSocialDefeat_sleepPost_mCherry_CNO = MergePathForExperiment(DirSocialDefeat_sleepPost_classic1,DirSocialDefeat_sleepPost_mCherry_saline);
% 
% DirSocialDefeat_sleepPost_mCherry_CNO = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_CRH_VLPO_SalineInjection_secondrun');
% 
% %%4
% DirSocialDefeat_sleepPost_dreadd_CNO = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_CRH_VLPO_CNOInjection');



%% parameters
tempbin = 3600/2;%3600;
time_end=3*1e8;
time_st = 0*3600*1e4;%0;
time_mid = 3.5*3600*1e4;%%4

min_sws_time = 3*1e4*60;
binH = 2;

lim_short_1 = 10;
lim_short_2 = 15;
lim_short_3 = 20;

lim_long = 40;

%% GET DATA - ctrl group (mCherry saline injection 10h)
for i=1:length(Dir_ctrl.path)
    cd(Dir_ctrl.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_ctrl{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','microWakeEpochAcc');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_ctrl{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','microWakeEpochAcc');
    else
    end
    same_epoch_ctrl{i} = intervalSet(0,time_end);
    same_epoch_1_3h_ctrl{i} = intervalSet(time_st,time_mid);
    same_epoch_3_end_ctrl{i} = intervalSet(time_mid,time_end);
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_ctrl{i}),'wake',tempbin,time_st,time_end);
    dur_WAKE_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_ctrl{i}=perc_moyen_WAKE;

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_ctrl{i}),'sws',tempbin,time_st,time_end);
    dur_SWS_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_ctrl{i}),'rem',tempbin,time_st,time_end);
    dur_REM_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_ctrl{i}=num_moyen_ep_REM;
    perc_REM_ctrl{i}=perc_moyen_REM;
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_ctrl{i}.Wake,same_epoch_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_ctrl{i}),tempbin,time_end);
    all_trans_REM_REM_ctrl{i} = trans_REM_to_REM;
    all_trans_REM_SWS_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_ctrl{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_ctrl{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_ctrl{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_ctrl{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_ctrl{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_ctrl{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_ctrl{i} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_1_3h_ctrl{i}),'wake',tempbin,time_st,time_mid);
    dur_WAKE_1_3h_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_1_3h_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_1_3h_ctrl{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_micro_WAKE, num_moyen_ep_micro_WAKE, perc_moyen_micro_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.microWakeEpochAcc,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_1_3h_ctrl{i}),'wake',tempbin,time_st,time_mid);
    dur_micro_WAKE_1_3h_ctrl(i)=dur_moyenne_ep_micro_WAKE;
    num_micro_WAKE_1_3h_ctrl(i)=num_moyen_ep_micro_WAKE;
    perc_micro_WAKE_1_3h_ctrl(i)=perc_moyen_micro_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_1_3h_ctrl{i}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_1_3h_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_1_3h_ctrl{i}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_1_3h_ctrl{i}=num_moyen_ep_REM;
    perc_REM_1_3h_ctrl{i}=perc_moyen_REM;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_1_3h_ctrl{i}),tempbin,time_st,time_mid);
    all_trans_REM_REM_1_3h_ctrl{i} = trans_REM_to_REM;
    all_trans_REM_SWS_1_3h_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_1_3h_ctrl{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_1_3h_ctrl{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_1_3h_ctrl{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_1_3h_ctrl{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_1_3h_ctrl{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_1_3h_ctrl{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_1_3h_ctrl{i} = trans_WAKE_to_WAKE;
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_ctrl{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_micro_WAKE, num_moyen_ep_micro_WAKE, perc_moyen_micro_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.microWakeEpochAcc,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),'wake',tempbin,time_st,time_mid);
    dur_micro_WAKE_3_end_ctrl(i)=dur_moyenne_ep_micro_WAKE;
    num_micro_WAKE_3_end_ctrl(i)=num_moyen_ep_micro_WAKE;
    perc_micro_WAKE_3_end_ctrl(i)=perc_moyen_micro_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_3_end_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_3_end_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_3_end_ctrl{i}=num_moyen_ep_REM;
    perc_REM_3_end_ctrl{i}=perc_moyen_REM;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),tempbin,time_mid,time_end);
    all_trans_REM_REM_3_end_ctrl{i} = trans_REM_to_REM;
    all_trans_REM_SWS_3_end_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_3_end_ctrl{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_3_end_ctrl{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_3_end_ctrl{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_3_end_ctrl{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_3_end_ctrl{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_3_end_ctrl{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_3_end_ctrl{i} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_REM_ctrl_bis{i}, durT_REM_ctrl(i)]=DurationEpoch(and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),'s');
    
    idx_short_rem_ctrl_1{i} = find(dur_REM_ctrl_bis{i}<lim_short_1); %short bouts < 10s
    short_REMEpoch_ctrl_1{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}), idx_short_rem_ctrl_1{i});
    [dur_rem_short_ctrl_1{i}, durT_rem_short_ctrl(i)] = DurationEpoch(short_REMEpoch_ctrl_1{i},'s');
    perc_rem_short_ctrl_1(i) = durT_rem_short_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_short_ctrl_1(i) = nanmean(dur_rem_short_ctrl_1{i});
    num_moyen_rem_short_ctrl_1(i) = length(dur_rem_short_ctrl_1{i});
    
    idx_short_rem_ctrl_2{i} = find(dur_REM_ctrl_bis{i}<lim_short_2); %short bouts < 15s
    short_REMEpoch_ctrl_2{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}), idx_short_rem_ctrl_2{i});
    [dur_rem_short_ctrl_2{i}, durT_rem_short_ctrl(i)] = DurationEpoch(short_REMEpoch_ctrl_2{i},'s');
    perc_rem_short_ctrl_2(i) = durT_rem_short_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_short_ctrl_2(i) = nanmean(dur_rem_short_ctrl_2{i});
    num_moyen_rem_short_ctrl_2(i) = length(dur_rem_short_ctrl_2{i});
    
    idx_short_rem_ctrl_3{i} = find(dur_REM_ctrl_bis{i}<lim_short_3);  %short bouts < 20s
    short_REMEpoch_ctrl_3{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}), idx_short_rem_ctrl_3{i});
    [dur_rem_short_ctrl_3{i}, durT_rem_short_ctrl(i)] = DurationEpoch(short_REMEpoch_ctrl_3{i},'s');
    perc_rem_short_ctrl_3(i) = durT_rem_short_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_short_ctrl_3(i) = nanmean(dur_rem_short_ctrl_3{i});
    num_moyen_rem_short_ctrl_3(i) = length(dur_rem_short_ctrl_3{i});
    
    idx_long_rem_ctrl{i} = find(dur_REM_ctrl_bis{i}>lim_long); %long bout
    long_REMEpoch_ctrl{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}), idx_long_rem_ctrl{i});
    [dur_rem_long_ctrl{i}, durT_rem_long_ctrl(i)] = DurationEpoch(long_REMEpoch_ctrl{i},'s');
    perc_rem_long_ctrl(i) = durT_rem_long_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_long_ctrl(i) = nanmean(dur_rem_long_ctrl{i});
    num_moyen_rem_long_ctrl(i) = length(dur_rem_long_ctrl{i});
    
    idx_mid_rem_ctrl{i} = find(dur_REM_ctrl_bis{i}>lim_short_1 & dur_REM_ctrl_bis{i}<lim_long); % middle bouts
    mid_REMEpoch_ctrl{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}), idx_mid_rem_ctrl{i});
    [dur_rem_mid_ctrl{i}, durT_rem_mid_ctrl(i)] = DurationEpoch(mid_REMEpoch_ctrl{i},'s');
    perc_rem_mid_ctrl(i) = durT_rem_mid_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_mid_ctrl(i) = nanmean(dur_rem_mid_ctrl{i});
    num_moyen_rem_mid_ctrl(i) = length(dur_rem_mid_ctrl{i});
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for i=1:length(dur_REM_ctrl)
    %%ALL SESSION 
    data_dur_REM_ctrl(i,:) = dur_REM_ctrl{i}; data_dur_REM_ctrl(isnan(data_dur_REM_ctrl)==1)=0;
    data_dur_SWS_ctrl(i,:) = dur_SWS_ctrl{i}; data_dur_SWS_ctrl(isnan(data_dur_SWS_ctrl)==1)=0;
    data_dur_WAKE_ctrl(i,:) = dur_WAKE_ctrl{i}; data_dur_WAKE_ctrl(isnan(data_dur_WAKE_ctrl)==1)=0;
    
    data_num_REM_ctrl(i,:) = num_REM_ctrl{i};data_num_REM_ctrl(isnan(data_num_REM_ctrl)==1)=0;
    data_num_SWS_ctrl(i,:) = num_SWS_ctrl{i}; data_num_SWS_ctrl(isnan(data_num_SWS_ctrl)==1)=0;
    data_num_WAKE_ctrl(i,:) = num_WAKE_ctrl{i}; data_num_WAKE_ctrl(isnan(data_num_WAKE_ctrl)==1)=0;
    
    data_perc_REM_ctrl(i,:) = perc_REM_ctrl{i}; data_perc_REM_ctrl(isnan(data_perc_REM_ctrl)==1)=0;
    data_perc_SWS_ctrl(i,:) = perc_SWS_ctrl{i}; data_perc_SWS_ctrl(isnan(data_perc_SWS_ctrl)==1)=0;
    data_perc_WAKE_ctrl(i,:) = perc_WAKE_ctrl{i}; data_perc_WAKE_ctrl(isnan(data_perc_WAKE_ctrl)==1)=0;

    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_ctrl(i,:) = dur_REM_1_3h_ctrl{i}; data_dur_REM_1_3h_ctrl(isnan(data_dur_REM_1_3h_ctrl)==1)=0;
    data_dur_SWS_1_3h_ctrl(i,:) = dur_SWS_1_3h_ctrl{i}; data_dur_SWS_1_3h_ctrl(isnan(data_dur_SWS_1_3h_ctrl)==1)=0;
    data_dur_WAKE_1_3h_ctrl(i,:) = dur_WAKE_1_3h_ctrl{i}; data_dur_WAKE_1_3h_ctrl(isnan(data_dur_WAKE_1_3h_ctrl)==1)=0;
    
    data_num_REM_1_3h_ctrl(i,:) = num_REM_1_3h_ctrl{i};data_num_REM_1_3h_ctrl(isnan(data_num_REM_1_3h_ctrl)==1)=0;
    data_num_SWS_1_3h_ctrl(i,:) = num_SWS_1_3h_ctrl{i}; data_num_SWS_1_3h_ctrl(isnan(data_num_SWS_1_3h_ctrl)==1)=0;
    data_num_WAKE_1_3h_ctrl(i,:) = num_WAKE_1_3h_ctrl{i}; data_num_WAKE_1_3h_ctrl(isnan(data_num_WAKE_1_3h_ctrl)==1)=0;
    
    data_perc_REM_1_3h_ctrl(i,:) = perc_REM_1_3h_ctrl{i}; data_perc_REM_1_3h_ctrl(isnan(data_perc_REM_1_3h_ctrl)==1)=0;
    data_perc_SWS_1_3h_ctrl(i,:) = perc_SWS_1_3h_ctrl{i}; data_perc_SWS_1_3h_ctrl(isnan(data_perc_SWS_1_3h_ctrl)==1)=0;
    data_perc_WAKE_1_3h_ctrl(i,:) = perc_WAKE_1_3h_ctrl{i}; data_perc_WAKE_1_3h_ctrl(isnan(data_perc_WAKE_1_3h_ctrl)==1)=0;

    %%FIN DE LA SESSION
    data_dur_REM_3_end_ctrl(i,:) = dur_REM_3_end_ctrl{i}; data_dur_REM_3_end_ctrl(isnan(data_dur_REM_3_end_ctrl)==1)=0;
    data_dur_SWS_3_end_ctrl(i,:) = dur_SWS_3_end_ctrl{i}; data_dur_SWS_3_end_ctrl(isnan(data_dur_SWS_3_end_ctrl)==1)=0;
    data_dur_WAKE_3_end_ctrl(i,:) = dur_WAKE_3_end_ctrl{i}; data_dur_WAKE_3_end_ctrl(isnan(data_dur_WAKE_3_end_ctrl)==1)=0;
    
    data_num_REM_3_end_ctrl(i,:) = num_REM_3_end_ctrl{i};data_num_REM_3_end_ctrl(isnan(data_num_REM_3_end_ctrl)==1)=0;
    data_num_SWS_3_end_ctrl(i,:) = num_SWS_3_end_ctrl{i}; data_num_SWS_3_end_ctrl(isnan(data_num_SWS_3_end_ctrl)==1)=0;
    data_num_WAKE_3_end_ctrl(i,:) = num_WAKE_3_end_ctrl{i}; data_num_WAKE_3_end_ctrl(isnan(data_num_WAKE_3_end_ctrl)==1)=0;
    
    data_perc_REM_3_end_ctrl(i,:) = perc_REM_3_end_ctrl{i}; data_perc_REM_3_end_ctrl(isnan(data_perc_REM_3_end_ctrl)==1)=0;
    data_perc_SWS_3_end_ctrl(i,:) = perc_SWS_3_end_ctrl{i}; data_perc_SWS_3_end_ctrl(isnan(data_perc_SWS_3_end_ctrl)==1)=0;
    data_perc_WAKE_3_end_ctrl(i,:) = perc_WAKE_3_end_ctrl{i}; data_perc_WAKE_3_end_ctrl(isnan(data_perc_WAKE_3_end_ctrl)==1)=0;
end
%%probability
for i=1:length(all_trans_REM_REM_ctrl)
    %%ALL SESSION
    data_REM_REM_ctrl(i,:) = all_trans_REM_REM_ctrl{i}; data_REM_REM_ctrl(isnan(data_REM_REM_ctrl)==1)=0;
    data_REM_SWS_ctrl(i,:) = all_trans_REM_SWS_ctrl{i}; data_REM_SWS_ctrl(isnan(data_REM_SWS_ctrl)==1)=0;
    data_REM_WAKE_ctrl(i,:) = all_trans_REM_WAKE_ctrl{i}; data_REM_WAKE_ctrl(isnan(data_REM_WAKE_ctrl)==1)=0;
    
    data_SWS_SWS_ctrl(i,:) = all_trans_SWS_SWS_ctrl{i}; data_SWS_SWS_ctrl(isnan(data_SWS_SWS_ctrl)==1)=0;
    data_SWS_REM_ctrl(i,:) = all_trans_SWS_REM_ctrl{i}; data_SWS_REM_ctrl(isnan(data_SWS_REM_ctrl)==1)=0;
    data_SWS_WAKE_ctrl(i,:) = all_trans_SWS_WAKE_ctrl{i}; data_SWS_WAKE_ctrl(isnan(data_SWS_WAKE_ctrl)==1)=0;
    
    data_WAKE_WAKE_ctrl(i,:) = all_trans_WAKE_WAKE_ctrl{i}; data_WAKE_WAKE_ctrl(isnan(data_WAKE_WAKE_ctrl)==1)=0;
    data_WAKE_REM_ctrl(i,:) = all_trans_WAKE_REM_ctrl{i}; data_WAKE_REM_ctrl(isnan(data_WAKE_REM_ctrl)==1)=0;
    data_WAKE_SWS_ctrl(i,:) = all_trans_WAKE_SWS_ctrl{i}; data_WAKE_SWS_ctrl(isnan(data_WAKE_SWS_ctrl)==1)=0;
    
    %%3 PREMI7RES HEURES
        data_REM_REM_1_3h_ctrl(i,:) = all_trans_REM_REM_1_3h_ctrl{i}; data_REM_REM_1_3h_ctrl(isnan(data_REM_REM_1_3h_ctrl)==1)=0;
    data_REM_SWS_1_3h_ctrl(i,:) = all_trans_REM_SWS_1_3h_ctrl{i}; data_REM_SWS_1_3h_ctrl(isnan(data_REM_SWS_1_3h_ctrl)==1)=0;
    data_REM_WAKE_1_3h_ctrl(i,:) = all_trans_REM_WAKE_1_3h_ctrl{i}; data_REM_WAKE_1_3h_ctrl(isnan(data_REM_WAKE_1_3h_ctrl)==1)=0;
    
    data_SWS_SWS_1_3h_ctrl(i,:) = all_trans_SWS_SWS_1_3h_ctrl{i}; data_SWS_SWS_1_3h_ctrl(isnan(data_SWS_SWS_1_3h_ctrl)==1)=0;
    data_SWS_REM_1_3h_ctrl(i,:) = all_trans_SWS_REM_1_3h_ctrl{i}; data_SWS_REM_1_3h_ctrl(isnan(data_SWS_REM_1_3h_ctrl)==1)=0;
    data_SWS_WAKE_1_3h_ctrl(i,:) = all_trans_SWS_WAKE_1_3h_ctrl{i}; data_SWS_WAKE_1_3h_ctrl(isnan(data_SWS_WAKE_1_3h_ctrl)==1)=0;
    
    data_WAKE_WAKE_1_3h_ctrl(i,:) = all_trans_WAKE_WAKE_1_3h_ctrl{i}; data_WAKE_WAKE_1_3h_ctrl(isnan(data_WAKE_WAKE_1_3h_ctrl)==1)=0;
    data_WAKE_REM_1_3h_ctrl(i,:) = all_trans_WAKE_REM_1_3h_ctrl{i}; data_WAKE_REM_1_3h_ctrl(isnan(data_WAKE_REM_1_3h_ctrl)==1)=0;
    data_WAKE_SWS_1_3h_ctrl(i,:) = all_trans_WAKE_SWS_1_3h_ctrl{i}; data_WAKE_SWS_1_3h_ctrl(isnan(data_WAKE_SWS_1_3h_ctrl)==1)=0;
    
    %%FIN DE LA SESSION
        data_REM_REM_3_end_ctrl(i,:) = all_trans_REM_REM_3_end_ctrl{i}; data_REM_REM_3_end_ctrl(isnan(data_REM_REM_3_end_ctrl)==1)=0;
    data_REM_SWS_3_end_ctrl(i,:) = all_trans_REM_SWS_3_end_ctrl{i}; data_REM_SWS_3_end_ctrl(isnan(data_REM_SWS_3_end_ctrl)==1)=0;
    data_REM_WAKE_3_end_ctrl(i,:) = all_trans_REM_WAKE_3_end_ctrl{i}; data_REM_WAKE_3_end_ctrl(isnan(data_REM_WAKE_3_end_ctrl)==1)=0;
    
    data_SWS_SWS_3_end_ctrl(i,:) = all_trans_SWS_SWS_3_end_ctrl{i}; data_SWS_SWS_3_end_ctrl(isnan(data_SWS_SWS_3_end_ctrl)==1)=0;
    data_SWS_REM_3_end_ctrl(i,:) = all_trans_SWS_REM_3_end_ctrl{i}; data_SWS_REM_3_end_ctrl(isnan(data_SWS_REM_3_end_ctrl)==1)=0;
    data_SWS_WAKE_3_end_ctrl(i,:) = all_trans_SWS_WAKE_3_end_ctrl{i}; data_SWS_WAKE_3_end_ctrl(isnan(data_SWS_WAKE_3_end_ctrl)==1)=0;
    
    data_WAKE_WAKE_3_end_ctrl(i,:) = all_trans_WAKE_WAKE_3_end_ctrl{i}; data_WAKE_WAKE_3_end_ctrl(isnan(data_WAKE_WAKE_3_end_ctrl)==1)=0;
    data_WAKE_REM_3_end_ctrl(i,:) = all_trans_WAKE_REM_3_end_ctrl{i}; data_WAKE_REM_3_end_ctrl(isnan(data_WAKE_REM_3_end_ctrl)==1)=0;
    data_WAKE_SWS_3_end_ctrl(i,:) = all_trans_WAKE_SWS_3_end_ctrl{i}; data_WAKE_SWS_3_end_ctrl(isnan(data_WAKE_SWS_3_end_ctrl)==1)=0;
    
end



%% GET DATA - SD mCherry saline
for k=1:length(DirSocialDefeat_sleepPost_classic.path)
    cd(DirSocialDefeat_sleepPost_classic.path{k}{1});
   try
       %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    same_epoch_SD{k} = intervalSet(0,time_end);
    same_epoch_1_3h_SD{k} = intervalSet(time_st,time_mid);
    same_epoch_3_end_SD{k} = intervalSet(time_mid,time_end);
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'wake',tempbin,time_st,time_end);
    dur_WAKE_SD{k}=dur_moyenne_ep_WAKE;
    num_WAKE_SD{k}=num_moyen_ep_WAKE;
    perc_WAKE_SD{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_SD{k}=num_moyen_ep_SWS;
    perc_SWS_SD{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'rem',tempbin,time_st,time_end);
    dur_REM_SD{k}=dur_moyenne_ep_REM;
    num_REM_SD{k}=num_moyen_ep_REM;
    perc_REM_SD{k}=perc_moyen_REM;
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),tempbin,time_end);
    all_trans_REM_REM_SD{k} = trans_REM_to_REM;
    all_trans_REM_SWS_SD{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_SD{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_SD{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_SD{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_SD{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_SD{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_SD{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_SD{k} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_1_3h_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_1_3h_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_1_3h_SD{k}),'wake',tempbin,time_st,time_mid);
    dur_WAKE_1_3h_SD{k}=dur_moyenne_ep_WAKE;
    num_WAKE_1_3h_SD{k}=num_moyen_ep_WAKE;
    perc_WAKE_1_3h_SD{k}=perc_moyen_WAKE;

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_1_3h_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_1_3h_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_1_3h_SD{k}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_SD{k}=num_moyen_ep_SWS;
    perc_SWS_1_3h_SD{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_1_3h_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_1_3h_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_1_3h_SD{k}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_SD{k}=dur_moyenne_ep_REM;
    num_REM_1_3h_SD{k}=num_moyen_ep_REM;
    perc_REM_1_3h_SD{k}=perc_moyen_REM;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_1_3h_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_1_3h_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_1_3h_SD{k}),tempbin,time_st,time_mid);
    all_trans_REM_REM_1_3h_SD{k} = trans_REM_to_REM;
    all_trans_REM_SWS_1_3h_SD{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_1_3h_SD{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_1_3h_SD{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_1_3h_SD{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_1_3h_SD{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_1_3h_SD{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_1_3h_SD{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_1_3h_SD{k} = trans_WAKE_to_WAKE;
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_3_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_3_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_SD{k}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_SD{k}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_SD{k}=perc_moyen_WAKE;

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_3_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_3_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_3_end_SD{k}=num_moyen_ep_SWS;
    perc_SWS_3_end_SD{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_3_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_3_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_SD{k}=dur_moyenne_ep_REM;
    num_REM_3_end_SD{k}=num_moyen_ep_REM;
    perc_REM_3_end_SD{k}=perc_moyen_REM;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_3_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_3_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}),tempbin,time_mid,time_end);
    all_trans_REM_REM_3_end_SD{k} = trans_REM_to_REM;
    all_trans_REM_SWS_3_end_SD{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_3_end_SD{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_3_end_SD{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_3_end_SD{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_3_end_SD{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_3_end_SD{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_3_end_SD{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_3_end_SD{k} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_REM_SD_bis{k}, durT_REM_SD(k)]=DurationEpoch(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}),'s');
    
    idx_short_rem_SD_1{k} = find(dur_REM_SD_bis{k}<lim_short_1);
    short_REMEpoch_SD_1{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_short_rem_SD_1{k});
    [dur_rem_short_SD_1{k}, durT_rem_short_SD(k)] = DurationEpoch(short_REMEpoch_SD_1{k},'s');
    perc_rem_short_SD_1(k) = durT_rem_short_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_short_SD_1(k) = nanmean(dur_rem_short_SD_1{k});
    num_moyen_rem_short_SD_1(k) = length(dur_rem_short_SD_1{k});
    
    idx_short_rem_SD_2{k} = find(dur_REM_SD_bis{k}<lim_short_2); %short bouts < 15s
    short_REMEpoch_SD_2{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_short_rem_SD_2{k});
    [dur_rem_short_SD_2{k}, durT_rem_short_SD(k)] = DurationEpoch(short_REMEpoch_SD_2{k},'s');
    perc_rem_short_SD_2(k) = durT_rem_short_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_short_SD_2(k) = nanmean(dur_rem_short_SD_2{k});
    num_moyen_rem_short_SD_2(k) = length(dur_rem_short_SD_2{k});
    
    idx_short_rem_SD_3{k} = find(dur_REM_SD_bis{k}<lim_short_3);  %short bouts < 20s
    short_REMEpoch_SD_3{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_short_rem_SD_3{k});
    [dur_rem_short_SD_3{k}, durT_rem_short_SD(k)] = DurationEpoch(short_REMEpoch_SD_3{k},'s');
    perc_rem_short_SD_3(k) = durT_rem_short_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_short_SD_3(k) = nanmean(dur_rem_short_SD_3{k});
    num_moyen_rem_short_SD_3(k) = length(dur_rem_short_SD_3{k});    
    idx_long_rem_SD{k} = find(dur_REM_SD_bis{k}>lim_long);
    
    long_REMEpoch_SD{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_long_rem_SD{k});
    [dur_rem_long_SD{k}, durT_rem_long_SD(k)] = DurationEpoch(long_REMEpoch_SD{k},'s');
    perc_rem_long_SD(k) = durT_rem_long_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_long_SD(k) = nanmean(dur_rem_long_SD{k});
    num_moyen_rem_long_SD(k) = length(dur_rem_long_SD{k});
  
    idx_mid_rem_SD{k} = find(dur_REM_SD_bis{k}>lim_short_1 & dur_REM_SD_bis{k}<lim_long);
    mid_REMEpoch_SD{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_mid_rem_SD{k});
    [dur_rem_mid_SD{k}, durT_rem_mid_SD(k)] = DurationEpoch(mid_REMEpoch_SD{k},'s');
    perc_rem_mid_SD(k) = durT_rem_mid_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_mid_SD(k) = nanmean(dur_rem_mid_SD{k});
    num_moyen_rem_mid_SD(k) = length(dur_rem_mid_SD{k});
end
end 

%% compute average - SD
%%percentage/duration/number
for k=1:length(dur_REM_SD)
    %%ALL SESSION 
    data_dur_REM_SD(k,:) = dur_REM_SD{k}; data_dur_REM_SD(isnan(data_dur_REM_SD)==1)=0;
    data_dur_SWS_SD(k,:) = dur_SWS_SD{k}; data_dur_SWS_SD(isnan(data_dur_SWS_SD)==1)=0;
    data_dur_WAKE_SD(k,:) = dur_WAKE_SD{k}; data_dur_WAKE_SD(isnan(data_dur_WAKE_SD)==1)=0;
    
    data_num_REM_SD(k,:) = num_REM_SD{k};data_num_REM_SD(isnan(data_num_REM_SD)==1)=0;
    data_num_SWS_SD(k,:) = num_SWS_SD{k}; data_num_SWS_SD(isnan(data_num_SWS_SD)==1)=0;
    data_num_WAKE_SD(k,:) = num_WAKE_SD{k}; data_num_WAKE_SD(isnan(data_num_WAKE_SD)==1)=0;
    
    data_perc_REM_SD(k,:) = perc_REM_SD{k}; data_perc_REM_SD(isnan(data_perc_REM_SD)==1)=0;
    data_perc_SWS_SD(k,:) = perc_SWS_SD{k}; data_perc_SWS_SD(isnan(data_perc_SWS_SD)==1)=0;
    data_perc_WAKE_SD(k,:) = perc_WAKE_SD{k}; data_perc_WAKE_SD(isnan(data_perc_WAKE_SD)==1)=0;

    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_SD(k,:) = dur_REM_1_3h_SD{k}; data_dur_REM_1_3h_SD(isnan(data_dur_REM_1_3h_SD)==1)=0;
    data_dur_SWS_1_3h_SD(k,:) = dur_SWS_1_3h_SD{k}; data_dur_SWS_1_3h_SD(isnan(data_dur_SWS_1_3h_SD)==1)=0;
    data_dur_WAKE_1_3h_SD(k,:) = dur_WAKE_1_3h_SD{k}; data_dur_WAKE_1_3h_SD(isnan(data_dur_WAKE_1_3h_SD)==1)=0;
    
    data_num_REM_1_3h_SD(k,:) = num_REM_1_3h_SD{k};data_num_REM_1_3h_SD(isnan(data_num_REM_1_3h_SD)==1)=0;
    data_num_SWS_1_3h_SD(k,:) = num_SWS_1_3h_SD{k}; data_num_SWS_1_3h_SD(isnan(data_num_SWS_1_3h_SD)==1)=0;
    data_num_WAKE_1_3h_SD(k,:) = num_WAKE_1_3h_SD{k}; data_num_WAKE_1_3h_SD(isnan(data_num_WAKE_1_3h_SD)==1)=0;
    
    data_perc_REM_1_3h_SD(k,:) = perc_REM_1_3h_SD{k}; data_perc_REM_1_3h_SD(isnan(data_perc_REM_1_3h_SD)==1)=0;
    data_perc_SWS_1_3h_SD(k,:) = perc_SWS_1_3h_SD{k}; data_perc_SWS_1_3h_SD(isnan(data_perc_SWS_1_3h_SD)==1)=0;
    data_perc_WAKE_1_3h_SD(k,:) = perc_WAKE_1_3h_SD{k}; data_perc_WAKE_1_3h_SD(isnan(data_perc_WAKE_1_3h_SD)==1)=0;

     
    
    %%FIN DE LA SESSION
    data_dur_REM_3_end_SD(k,:) = dur_REM_3_end_SD{k}; data_dur_REM_3_end_SD(isnan(data_dur_REM_3_end_SD)==1)=0;
    data_dur_SWS_3_end_SD(k,:) = dur_SWS_3_end_SD{k}; data_dur_SWS_3_end_SD(isnan(data_dur_SWS_3_end_SD)==1)=0;
    data_dur_WAKE_3_end_SD(k,:) = dur_WAKE_3_end_SD{k}; data_dur_WAKE_3_end_SD(isnan(data_dur_WAKE_3_end_SD)==1)=0;
    
    data_num_REM_3_end_SD(k,:) = num_REM_3_end_SD{k};data_num_REM_3_end_SD(isnan(data_num_REM_3_end_SD)==1)=0;
    data_num_SWS_3_end_SD(k,:) = num_SWS_3_end_SD{k}; data_num_SWS_3_end_SD(isnan(data_num_SWS_3_end_SD)==1)=0;
    data_num_WAKE_3_end_SD(k,:) = num_WAKE_3_end_SD{k}; data_num_WAKE_3_end_SD(isnan(data_num_WAKE_3_end_SD)==1)=0;
    
    data_perc_REM_3_end_SD(k,:) = perc_REM_3_end_SD{k}; data_perc_REM_3_end_SD(isnan(data_perc_REM_3_end_SD)==1)=0;
    data_perc_SWS_3_end_SD(k,:) = perc_SWS_3_end_SD{k}; data_perc_SWS_3_end_SD(isnan(data_perc_SWS_3_end_SD)==1)=0;
    data_perc_WAKE_3_end_SD(k,:) = perc_WAKE_3_end_SD{k}; data_perc_WAKE_3_end_SD(isnan(data_perc_WAKE_3_end_SD)==1)=0;
end
%%
%%probability
% for k=1:length(all_trans_REM_REM_SD)
%     %%ALL SESSION
%     data_REM_REM_SD(k,:) = all_trans_REM_REM_SD{k}; data_REM_REM_SD(isnan(data_REM_REM_SD)==1)=0;
%     data_REM_SWS_SD(k,:) = all_trans_REM_SWS_SD{k}; data_REM_SWS_SD(isnan(data_REM_SWS_SD)==1)=0;
%     data_REM_WAKE_SD(k,:) = all_trans_REM_WAKE_SD{k}; data_REM_WAKE_SD(isnan(data_REM_WAKE_SD)==1)=0;
%     
%     data_SWS_SWS_SD(k,:) = all_trans_SWS_SWS_SD{k}; data_SWS_SWS_SD(isnan(data_SWS_SWS_SD)==1)=0;
%     data_SWS_REM_SD(k,:) = all_trans_SWS_REM_SD{k}; data_SWS_REM_SD(isnan(data_SWS_REM_SD)==1)=0;
%     data_SWS_WAKE_SD(k,:) = all_trans_SWS_WAKE_SD{k}; data_SWS_WAKE_SD(isnan(data_SWS_WAKE_SD)==1)=0;
%     
%     data_WAKE_WAKE_SD(k,:) = all_trans_WAKE_WAKE_SD{k}; data_WAKE_WAKE_SD(isnan(data_WAKE_WAKE_SD)==1)=0;
%     data_WAKE_REM_SD(k,:) = all_trans_WAKE_REM_SD{k}; data_WAKE_REM_SD(isnan(data_WAKE_REM_SD)==1)=0;
%     data_WAKE_SWS_SD(k,:) = all_trans_WAKE_SWS_SD{k}; data_WAKE_SWS_SD(isnan(data_WAKE_SWS_SD)==1)=0;
%     
%     %%3 PREMI7RES HEURES
%         data_REM_REM_1_3h_SD(k,:) = all_trans_REM_REM_1_3h_SD{k}; data_REM_REM_1_3h_SD(isnan(data_REM_REM_1_3h_SD)==1)=0;
%     data_REM_SWS_1_3h_SD(k,:) = all_trans_REM_SWS_1_3h_SD{k}; data_REM_SWS_1_3h_SD(isnan(data_REM_SWS_1_3h_SD)==1)=0;
%     data_REM_WAKE_1_3h_SD(k,:) = all_trans_REM_WAKE_1_3h_SD{k}; data_REM_WAKE_1_3h_SD(isnan(data_REM_WAKE_1_3h_SD)==1)=0;
%     
%     data_SWS_SWS_1_3h_SD(k,:) = all_trans_SWS_SWS_1_3h_SD{k}; data_SWS_SWS_1_3h_SD(isnan(data_SWS_SWS_1_3h_SD)==1)=0;
%     data_SWS_REM_1_3h_SD(k,:) = all_trans_SWS_REM_1_3h_SD{k}; data_SWS_REM_1_3h_SD(isnan(data_SWS_REM_1_3h_SD)==1)=0;
%     data_SWS_WAKE_1_3h_SD(k,:) = all_trans_SWS_WAKE_1_3h_SD{k}; data_SWS_WAKE_1_3h_SD(isnan(data_SWS_WAKE_1_3h_SD)==1)=0;
%     
%     data_WAKE_WAKE_1_3h_SD(k,:) = all_trans_WAKE_WAKE_1_3h_SD{k}; data_WAKE_WAKE_1_3h_SD(isnan(data_WAKE_WAKE_1_3h_SD)==1)=0;
%     data_WAKE_REM_1_3h_SD(k,:) = all_trans_WAKE_REM_1_3h_SD{k}; data_WAKE_REM_1_3h_SD(isnan(data_WAKE_REM_1_3h_SD)==1)=0;
%     data_WAKE_SWS_1_3h_SD(k,:) = all_trans_WAKE_SWS_1_3h_SD{k}; data_WAKE_SWS_1_3h_SD(isnan(data_WAKE_SWS_1_3h_SD)==1)=0;
%     
%     %%FIN DE LA SESSION
%         data_REM_REM_3_end_SD(k,:) = all_trans_REM_REM_3_end_SD{k}; data_REM_REM_3_end_SD(isnan(data_REM_REM_3_end_SD)==1)=0;
%     data_REM_SWS_3_end_SD(k,:) = all_trans_REM_SWS_3_end_SD{k}; data_REM_SWS_3_end_SD(isnan(data_REM_SWS_3_end_SD)==1)=0;
%     data_REM_WAKE_3_end_SD(k,:) = all_trans_REM_WAKE_3_end_SD{k}; data_REM_WAKE_3_end_SD(isnan(data_REM_WAKE_3_end_SD)==1)=0;
%     
%     data_SWS_SWS_3_end_SD(k,:) = all_trans_SWS_SWS_3_end_SD{k}; data_SWS_SWS_3_end_SD(isnan(data_SWS_SWS_3_end_SD)==1)=0;
%     data_SWS_REM_3_end_SD(k,:) = all_trans_SWS_REM_3_end_SD{k}; data_SWS_REM_3_end_SD(isnan(data_SWS_REM_3_end_SD)==1)=0;
%     data_SWS_WAKE_3_end_SD(k,:) = all_trans_SWS_WAKE_3_end_SD{k}; data_SWS_WAKE_3_end_SD(isnan(data_SWS_WAKE_3_end_SD)==1)=0;
%     
%     data_WAKE_WAKE_3_end_SD(k,:) = all_trans_WAKE_WAKE_3_end_SD{k}; data_WAKE_WAKE_3_end_SD(isnan(data_WAKE_WAKE_3_end_SD)==1)=0;
%     data_WAKE_REM_3_end_SD(k,:) = all_trans_WAKE_REM_3_end_SD{k}; data_WAKE_REM_3_end_SD(isnan(data_WAKE_REM_3_end_SD)==1)=0;
%     data_WAKE_SWS_3_end_SD(k,:) = all_trans_WAKE_SWS_3_end_SD{k}; data_WAKE_SWS_3_end_SD(isnan(data_WAKE_SWS_3_end_SD)==1)=0;
%     
% end




%% GET DATA - SD mCherry cno
for j=1:length(DirSocialDefeat_sleepPost_mCherry_CNO.path)
    cd(DirSocialDefeat_sleepPost_mCherry_CNO.path{j}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_mCherry_cno{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','microWakeEpochAcc');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_mCherry_cno{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','microWakeEpochAcc');
    else
    end
    same_epoch_SD_mCherry_cno{j} = intervalSet(0,time_end);
    same_epoch_1_3h_SD_mCherry_cno{j} = intervalSet(time_st,time_mid);
    same_epoch_3_end_SD_mCherry_cno{j} = intervalSet(time_mid,time_end);
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_SD_mCherry_cno{j}),'wake',tempbin,time_st,time_end);
    dur_WAKE_SD_mCherry_cno{j}=dur_moyenne_ep_WAKE;
    num_WAKE_SD_mCherry_cno{j}=num_moyen_ep_WAKE;
    perc_WAKE_SD_mCherry_cno{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_SD_mCherry_cno{j}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_SD_mCherry_cno{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_SD_mCherry_cno{j}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_SD_mCherry_cno{j}=perc_moyen_REM;
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_SD_mCherry_cno{j}),tempbin,time_end);
    all_trans_REM_REM_SD_mCherry_cno{j} = trans_REM_to_REM;
    all_trans_REM_SWS_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_SD_mCherry_cno{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_SD_mCherry_cno{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_SD_mCherry_cno{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_SD_mCherry_cno{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_SD_mCherry_cno{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_SD_mCherry_cno{j} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),'wake',tempbin,time_st,time_mid);
    dur_WAKE_1_3h_SD_mCherry_cno{j}=dur_moyenne_ep_WAKE;
    num_WAKE_1_3h_SD_mCherry_cno{j}=num_moyen_ep_WAKE;
    perc_WAKE_1_3h_SD_mCherry_cno{j}=perc_moyen_WAKE;
    
%     [dur_moyenne_ep_micro_WAKE, num_moyen_ep_micro_WAKE, perc_moyen_micro_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.microWakeEpochAcc,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),'wake',tempbin,time_st,time_mid);
% dur_micro_WAKE_1_3h_SD_mCherry_cno(j)=dur_moyenne_ep_micro_WAKE;
% num_micro_WAKE_1_3h_SD_mCherry_cno(j)=num_moyen_ep_micro_WAKE;
% perc_micro_WAKE_1_3h_SD_mCherry_cno(j)=perc_moyen_micro_WAKE;

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_1_3h_SD_mCherry_cno{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_1_3h_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_1_3h_SD_mCherry_cno{j}=perc_moyen_REM;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),tempbin,time_st,time_mid);
    all_trans_REM_REM_1_3h_SD_mCherry_cno{j} = trans_REM_to_REM;
    all_trans_REM_SWS_1_3h_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_1_3h_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_1_3h_SD_mCherry_cno{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_1_3h_SD_mCherry_cno{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_1_3h_SD_mCherry_cno{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_1_3h_SD_mCherry_cno{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_1_3h_SD_mCherry_cno{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_1_3h_SD_mCherry_cno{j} = trans_WAKE_to_WAKE;
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_SD_mCherry_cno{j}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_SD_mCherry_cno{j}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_SD_mCherry_cno{j}=perc_moyen_WAKE;
    
%     [dur_moyenne_ep_micro_WAKE, num_moyen_ep_micro_WAKE, perc_moyen_micro_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.microWakeEpochAcc,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),'wake',tempbin,time_st,time_mid);
% dur_micro_WAKE_3_end_SD_mCherry_cno(j)=dur_moyenne_ep_micro_WAKE;
% num_micro_WAKE_3_end_SD_mCherry_cno(j)=num_moyen_ep_micro_WAKE;
% perc_micro_WAKE_3_end_SD_mCherry_cno(j)=perc_moyen_micro_WAKE;

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_3_end_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_3_end_SD_mCherry_cno{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_3_end_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_3_end_SD_mCherry_cno{j}=perc_moyen_REM;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),tempbin,time_mid,time_end);
    all_trans_REM_REM_3_end_SD_mCherry_cno{j} = trans_REM_to_REM;
    all_trans_REM_SWS_3_end_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_3_end_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_3_end_SD_mCherry_cno{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_3_end_SD_mCherry_cno{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_3_end_SD_mCherry_cno{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_3_end_SD_mCherry_cno{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_3_end_SD_mCherry_cno{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_3_end_SD_mCherry_cno{j} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_REM_SD_mCherry_cno_bis{j}, durT_REM_SD_mCherry_cno(j)]=DurationEpoch(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),'s');
    
    idx_short_rem_SD_mCherry_cno_1{j} = find(dur_REM_SD_mCherry_cno_bis{j}<lim_short_1);
    short_REMEpoch_SD_mCherry_cno_1{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}), idx_short_rem_SD_mCherry_cno_1{j});
    [dur_rem_short_SD_mCherry_cno_1{j}, durT_rem_short_SD_mCherry_cno(j)] = DurationEpoch(short_REMEpoch_SD_mCherry_cno_1{j},'s');
    perc_rem_short_SD_mCherry_cno_1(j) = durT_rem_short_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_short_SD_mCherry_cno_1(j) = nanmean(dur_rem_short_SD_mCherry_cno_1{j});
    num_moyen_rem_short_SD_mCherry_cno_1(j) = length(dur_rem_short_SD_mCherry_cno_1{j});
    
    idx_short_rem_SD_mCherry_cno_2{j} = find(dur_REM_SD_mCherry_cno_bis{j}<lim_short_2); %short bouts < 15s
    short_REMEpoch_SD_mCherry_cno_2{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}), idx_short_rem_SD_mCherry_cno_2{j});
    [dur_rem_short_SD_mCherry_cno_2{j}, durT_rem_short_SD_mCherry_cno(j)] = DurationEpoch(short_REMEpoch_SD_mCherry_cno_2{j},'s');
    perc_rem_short_SD_mCherry_cno_2(j) = durT_rem_short_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_short_SD_mCherry_cno_2(j) = nanmean(dur_rem_short_SD_mCherry_cno_2{j});
    num_moyen_rem_short_SD_mCherry_cno_2(j) = length(dur_rem_short_SD_mCherry_cno_2{j});
    
    idx_short_rem_SD_mCherry_cno_3{j} = find(dur_REM_SD_mCherry_cno_bis{j}<lim_short_3);  %short bouts < 20s
    short_REMEpoch_SD_mCherry_cno_3{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}), idx_short_rem_SD_mCherry_cno_3{j});
    [dur_rem_short_SD_mCherry_cno_3{j}, durT_rem_short_SD_mCherry_cno(j)] = DurationEpoch(short_REMEpoch_SD_mCherry_cno_3{j},'s');
    perc_rem_short_SD_mCherry_cno_3(j) = durT_rem_short_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_short_SD_mCherry_cno_3(j) = nanmean(dur_rem_short_SD_mCherry_cno_3{j});
    num_moyen_rem_short_SD_mCherry_cno_3(j) = length(dur_rem_short_SD_mCherry_cno_3{j});
    
    idx_long_rem_SD_mCherry_cno{j} = find(dur_REM_SD_mCherry_cno_bis{j}>lim_long);
    long_REMEpoch_SD_mCherry_cno{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}), idx_long_rem_SD_mCherry_cno{j});
    [dur_rem_long_SD_mCherry_cno{j}, durT_rem_long_SD_mCherry_cno(j)] = DurationEpoch(long_REMEpoch_SD_mCherry_cno{j},'s');
    perc_rem_long_SD_mCherry_cno(j) = durT_rem_long_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_long_SD_mCherry_cno(j) = nanmean(dur_rem_long_SD_mCherry_cno{j});
    num_moyen_rem_long_SD_mCherry_cno(j) = length(dur_rem_long_SD_mCherry_cno{j});
    
    idx_mid_rem_SD_mCherry_cno{j} = find(dur_REM_SD_mCherry_cno_bis{j}>lim_short_1 & dur_REM_SD_mCherry_cno_bis{j}<lim_long);
    mid_REMEpoch_SD_mCherry_cno{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}), idx_mid_rem_SD_mCherry_cno{j});
    [dur_rem_mid_SD_mCherry_cno{j}, durT_rem_mid_SD_mCherry_cno(j)] = DurationEpoch(mid_REMEpoch_SD_mCherry_cno{j},'s');
    perc_rem_mid_SD_mCherry_cno(j) = durT_rem_mid_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_mid_SD_mCherry_cno(j) = nanmean(dur_rem_mid_SD_mCherry_cno{j});
    num_moyen_rem_mid_SD_mCherry_cno(j) = length(dur_rem_mid_SD_mCherry_cno{j});
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for j=1:length(dur_REM_SD_mCherry_cno)
    %%ALL SESSION 
    data_dur_REM_SD_mCherry_cno(j,:) = dur_REM_SD_mCherry_cno{j}; data_dur_REM_SD_mCherry_cno(isnan(data_dur_REM_SD_mCherry_cno)==1)=0;
    data_dur_SWS_SD_mCherry_cno(j,:) = dur_SWS_SD_mCherry_cno{j}; data_dur_SWS_SD_mCherry_cno(isnan(data_dur_SWS_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_SD_mCherry_cno(j,:) = dur_WAKE_SD_mCherry_cno{j}; data_dur_WAKE_SD_mCherry_cno(isnan(data_dur_WAKE_SD_mCherry_cno)==1)=0;
    
    data_num_REM_SD_mCherry_cno(j,:) = num_REM_SD_mCherry_cno{j};data_num_REM_SD_mCherry_cno(isnan(data_num_REM_SD_mCherry_cno)==1)=0;
    data_num_SWS_SD_mCherry_cno(j,:) = num_SWS_SD_mCherry_cno{j}; data_num_SWS_SD_mCherry_cno(isnan(data_num_SWS_SD_mCherry_cno)==1)=0;
    data_num_WAKE_SD_mCherry_cno(j,:) = num_WAKE_SD_mCherry_cno{j}; data_num_WAKE_SD_mCherry_cno(isnan(data_num_WAKE_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_SD_mCherry_cno(j,:) = perc_REM_SD_mCherry_cno{j}; data_perc_REM_SD_mCherry_cno(isnan(data_perc_REM_SD_mCherry_cno)==1)=0;
    data_perc_SWS_SD_mCherry_cno(j,:) = perc_SWS_SD_mCherry_cno{j}; data_perc_SWS_SD_mCherry_cno(isnan(data_perc_SWS_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_SD_mCherry_cno(j,:) = perc_WAKE_SD_mCherry_cno{j}; data_perc_WAKE_SD_mCherry_cno(isnan(data_perc_WAKE_SD_mCherry_cno)==1)=0;

    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_SD_mCherry_cno(j,:) = dur_REM_1_3h_SD_mCherry_cno{j}; data_dur_REM_1_3h_SD_mCherry_cno(isnan(data_dur_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_dur_SWS_1_3h_SD_mCherry_cno(j,:) = dur_SWS_1_3h_SD_mCherry_cno{j}; data_dur_SWS_1_3h_SD_mCherry_cno(isnan(data_dur_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_1_3h_SD_mCherry_cno(j,:) = dur_WAKE_1_3h_SD_mCherry_cno{j}; data_dur_WAKE_1_3h_SD_mCherry_cno(isnan(data_dur_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    
    data_num_REM_1_3h_SD_mCherry_cno(j,:) = num_REM_1_3h_SD_mCherry_cno{j};data_num_REM_1_3h_SD_mCherry_cno(isnan(data_num_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_num_SWS_1_3h_SD_mCherry_cno(j,:) = num_SWS_1_3h_SD_mCherry_cno{j}; data_num_SWS_1_3h_SD_mCherry_cno(isnan(data_num_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_num_WAKE_1_3h_SD_mCherry_cno(j,:) = num_WAKE_1_3h_SD_mCherry_cno{j}; data_num_WAKE_1_3h_SD_mCherry_cno(isnan(data_num_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_1_3h_SD_mCherry_cno(j,:) = perc_REM_1_3h_SD_mCherry_cno{j}; data_perc_REM_1_3h_SD_mCherry_cno(isnan(data_perc_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_perc_SWS_1_3h_SD_mCherry_cno(j,:) = perc_SWS_1_3h_SD_mCherry_cno{j}; data_perc_SWS_1_3h_SD_mCherry_cno(isnan(data_perc_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_1_3h_SD_mCherry_cno(j,:) = perc_WAKE_1_3h_SD_mCherry_cno{j}; data_perc_WAKE_1_3h_SD_mCherry_cno(isnan(data_perc_WAKE_1_3h_SD_mCherry_cno)==1)=0;

    %%FIN DE LA SESSION
    data_dur_REM_3_end_SD_mCherry_cno(j,:) = dur_REM_3_end_SD_mCherry_cno{j}; data_dur_REM_3_end_SD_mCherry_cno(isnan(data_dur_REM_3_end_SD_mCherry_cno)==1)=0;
    data_dur_SWS_3_end_SD_mCherry_cno(j,:) = dur_SWS_3_end_SD_mCherry_cno{j}; data_dur_SWS_3_end_SD_mCherry_cno(isnan(data_dur_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_3_end_SD_mCherry_cno(j,:) = dur_WAKE_3_end_SD_mCherry_cno{j}; data_dur_WAKE_3_end_SD_mCherry_cno(isnan(data_dur_WAKE_3_end_SD_mCherry_cno)==1)=0;
    
    data_num_REM_3_end_SD_mCherry_cno(j,:) = num_REM_3_end_SD_mCherry_cno{j};data_num_REM_3_end_SD_mCherry_cno(isnan(data_num_REM_3_end_SD_mCherry_cno)==1)=0;
    data_num_SWS_3_end_SD_mCherry_cno(j,:) = num_SWS_3_end_SD_mCherry_cno{j}; data_num_SWS_3_end_SD_mCherry_cno(isnan(data_num_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_num_WAKE_3_end_SD_mCherry_cno(j,:) = num_WAKE_3_end_SD_mCherry_cno{j}; data_num_WAKE_3_end_SD_mCherry_cno(isnan(data_num_WAKE_3_end_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_3_end_SD_mCherry_cno(j,:) = perc_REM_3_end_SD_mCherry_cno{j}; data_perc_REM_3_end_SD_mCherry_cno(isnan(data_perc_REM_3_end_SD_mCherry_cno)==1)=0;
    data_perc_SWS_3_end_SD_mCherry_cno(j,:) = perc_SWS_3_end_SD_mCherry_cno{j}; data_perc_SWS_3_end_SD_mCherry_cno(isnan(data_perc_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_3_end_SD_mCherry_cno(j,:) = perc_WAKE_3_end_SD_mCherry_cno{j}; data_perc_WAKE_3_end_SD_mCherry_cno(isnan(data_perc_WAKE_3_end_SD_mCherry_cno)==1)=0;
end
%%probability
for j=1:length(all_trans_REM_REM_SD_mCherry_cno)
    %%ALL SESSION
    data_REM_REM_SD_mCherry_cno(j,:) = all_trans_REM_REM_SD_mCherry_cno{j}; data_REM_REM_SD_mCherry_cno(isnan(data_REM_REM_SD_mCherry_cno)==1)=0;
    data_REM_SWS_SD_mCherry_cno(j,:) = all_trans_REM_SWS_SD_mCherry_cno{j}; data_REM_SWS_SD_mCherry_cno(isnan(data_REM_SWS_SD_mCherry_cno)==1)=0;
    data_REM_WAKE_SD_mCherry_cno(j,:) = all_trans_REM_WAKE_SD_mCherry_cno{j}; data_REM_WAKE_SD_mCherry_cno(isnan(data_REM_WAKE_SD_mCherry_cno)==1)=0;
    
    data_SWS_SWS_SD_mCherry_cno(j,:) = all_trans_SWS_SWS_SD_mCherry_cno{j}; data_SWS_SWS_SD_mCherry_cno(isnan(data_SWS_SWS_SD_mCherry_cno)==1)=0;
    data_SWS_REM_SD_mCherry_cno(j,:) = all_trans_SWS_REM_SD_mCherry_cno{j}; data_SWS_REM_SD_mCherry_cno(isnan(data_SWS_REM_SD_mCherry_cno)==1)=0;
    data_SWS_WAKE_SD_mCherry_cno(j,:) = all_trans_SWS_WAKE_SD_mCherry_cno{j}; data_SWS_WAKE_SD_mCherry_cno(isnan(data_SWS_WAKE_SD_mCherry_cno)==1)=0;
    
    data_WAKE_WAKE_SD_mCherry_cno(j,:) = all_trans_WAKE_WAKE_SD_mCherry_cno{j}; data_WAKE_WAKE_SD_mCherry_cno(isnan(data_WAKE_WAKE_SD_mCherry_cno)==1)=0;
    data_WAKE_REM_SD_mCherry_cno(j,:) = all_trans_WAKE_REM_SD_mCherry_cno{j}; data_WAKE_REM_SD_mCherry_cno(isnan(data_WAKE_REM_SD_mCherry_cno)==1)=0;
    data_WAKE_SWS_SD_mCherry_cno(j,:) = all_trans_WAKE_SWS_SD_mCherry_cno{j}; data_WAKE_SWS_SD_mCherry_cno(isnan(data_WAKE_SWS_SD_mCherry_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
        data_REM_REM_1_3h_SD_mCherry_cno(j,:) = all_trans_REM_REM_1_3h_SD_mCherry_cno{j}; data_REM_REM_1_3h_SD_mCherry_cno(isnan(data_REM_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_REM_SWS_1_3h_SD_mCherry_cno(j,:) = all_trans_REM_SWS_1_3h_SD_mCherry_cno{j}; data_REM_SWS_1_3h_SD_mCherry_cno(isnan(data_REM_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_REM_WAKE_1_3h_SD_mCherry_cno(j,:) = all_trans_REM_WAKE_1_3h_SD_mCherry_cno{j}; data_REM_WAKE_1_3h_SD_mCherry_cno(isnan(data_REM_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    
    data_SWS_SWS_1_3h_SD_mCherry_cno(j,:) = all_trans_SWS_SWS_1_3h_SD_mCherry_cno{j}; data_SWS_SWS_1_3h_SD_mCherry_cno(isnan(data_SWS_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_SWS_REM_1_3h_SD_mCherry_cno(j,:) = all_trans_SWS_REM_1_3h_SD_mCherry_cno{j}; data_SWS_REM_1_3h_SD_mCherry_cno(isnan(data_SWS_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_SWS_WAKE_1_3h_SD_mCherry_cno(j,:) = all_trans_SWS_WAKE_1_3h_SD_mCherry_cno{j}; data_SWS_WAKE_1_3h_SD_mCherry_cno(isnan(data_SWS_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    
    data_WAKE_WAKE_1_3h_SD_mCherry_cno(j,:) = all_trans_WAKE_WAKE_1_3h_SD_mCherry_cno{j}; data_WAKE_WAKE_1_3h_SD_mCherry_cno(isnan(data_WAKE_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    data_WAKE_REM_1_3h_SD_mCherry_cno(j,:) = all_trans_WAKE_REM_1_3h_SD_mCherry_cno{j}; data_WAKE_REM_1_3h_SD_mCherry_cno(isnan(data_WAKE_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_WAKE_SWS_1_3h_SD_mCherry_cno(j,:) = all_trans_WAKE_SWS_1_3h_SD_mCherry_cno{j}; data_WAKE_SWS_1_3h_SD_mCherry_cno(isnan(data_WAKE_SWS_1_3h_SD_mCherry_cno)==1)=0;
    
    %%FIN DE LA SESSION
        data_REM_REM_3_end_SD_mCherry_cno(j,:) = all_trans_REM_REM_3_end_SD_mCherry_cno{j}; data_REM_REM_3_end_SD_mCherry_cno(isnan(data_REM_REM_3_end_SD_mCherry_cno)==1)=0;
    data_REM_SWS_3_end_SD_mCherry_cno(j,:) = all_trans_REM_SWS_3_end_SD_mCherry_cno{j}; data_REM_SWS_3_end_SD_mCherry_cno(isnan(data_REM_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_REM_WAKE_3_end_SD_mCherry_cno(j,:) = all_trans_REM_WAKE_3_end_SD_mCherry_cno{j}; data_REM_WAKE_3_end_SD_mCherry_cno(isnan(data_REM_WAKE_3_end_SD_mCherry_cno)==1)=0;
    
    data_SWS_SWS_3_end_SD_mCherry_cno(j,:) = all_trans_SWS_SWS_3_end_SD_mCherry_cno{j}; data_SWS_SWS_3_end_SD_mCherry_cno(isnan(data_SWS_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_SWS_REM_3_end_SD_mCherry_cno(j,:) = all_trans_SWS_REM_3_end_SD_mCherry_cno{j}; data_SWS_REM_3_end_SD_mCherry_cno(isnan(data_SWS_REM_3_end_SD_mCherry_cno)==1)=0;
    data_SWS_WAKE_3_end_SD_mCherry_cno(j,:) = all_trans_SWS_WAKE_3_end_SD_mCherry_cno{j}; data_SWS_WAKE_3_end_SD_mCherry_cno(isnan(data_SWS_WAKE_3_end_SD_mCherry_cno)==1)=0;
    
    data_WAKE_WAKE_3_end_SD_mCherry_cno(j,:) = all_trans_WAKE_WAKE_3_end_SD_mCherry_cno{j}; data_WAKE_WAKE_3_end_SD_mCherry_cno(isnan(data_WAKE_WAKE_3_end_SD_mCherry_cno)==1)=0;
    data_WAKE_REM_3_end_SD_mCherry_cno(j,:) = all_trans_WAKE_REM_3_end_SD_mCherry_cno{j}; data_WAKE_REM_3_end_SD_mCherry_cno(isnan(data_WAKE_REM_3_end_SD_mCherry_cno)==1)=0;
    data_WAKE_SWS_3_end_SD_mCherry_cno(j,:) = all_trans_WAKE_SWS_3_end_SD_mCherry_cno{j}; data_WAKE_SWS_3_end_SD_mCherry_cno(isnan(data_WAKE_SWS_3_end_SD_mCherry_cno)==1)=0;
    
end




%% GET DATA - SD dreadd cno
for m=1:length(DirSocialDefeat_sleepPost_dreadd_CNO.path)
    cd(DirSocialDefeat_sleepPost_dreadd_CNO.path{m}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_dreadd_cno{m} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','microWakeEpochAcc');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_dreadd_cno{m} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','microWakeEpochAcc');
    else
    end
    same_epoch_SD_dreadd_cno{m} = intervalSet(0,time_end);
    same_epoch_1_3h_SD_dreadd_cno{m} = intervalSet(time_st,time_mid);
    same_epoch_3_end_SD_dreadd_cno{m} = intervalSet(time_mid,time_end);
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_SD_dreadd_cno{m}),'wake',tempbin,time_st,time_end);
    dur_WAKE_SD_dreadd_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_SD_dreadd_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_SD_dreadd_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_SD_dreadd_cno{m}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_SD_dreadd_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_SD_dreadd_cno{m}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_SD_dreadd_cno{m}=perc_moyen_REM;
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_SD_dreadd_cno{m}),tempbin,time_end);
    all_trans_REM_REM_SD_dreadd_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_SD_dreadd_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_SD_dreadd_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_SD_dreadd_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_SD_dreadd_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_SD_dreadd_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_SD_dreadd_cno{m} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),'wake',tempbin,time_st,time_mid);
    dur_WAKE_1_3h_SD_dreadd_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_1_3h_SD_dreadd_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_1_3h_SD_dreadd_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_micro_WAKE, num_moyen_ep_micro_WAKE, perc_moyen_micro_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.microWakeEpochAcc,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),'wake',tempbin,time_st,time_mid);
dur_micro_WAKE_1_3h_SD_dreadd_cno(m)=dur_moyenne_ep_micro_WAKE;
num_micro_WAKE_1_3h_SD_dreadd_cno(m)=num_moyen_ep_micro_WAKE;
perc_micro_WAKE_1_3h_SD_dreadd_cno(m)=perc_moyen_micro_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_1_3h_SD_dreadd_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_1_3h_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_1_3h_SD_dreadd_cno{m}=perc_moyen_REM;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),tempbin,time_st,time_mid);
    all_trans_REM_REM_1_3h_SD_dreadd_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_1_3h_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_1_3h_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_1_3h_SD_dreadd_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_1_3h_SD_dreadd_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_1_3h_SD_dreadd_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_1_3h_SD_dreadd_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_1_3h_SD_dreadd_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_1_3h_SD_dreadd_cno{m} = trans_WAKE_to_WAKE;
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_SD_dreadd_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_SD_dreadd_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_SD_dreadd_cno{m}=perc_moyen_WAKE;
    
    
[dur_moyenne_ep_micro_WAKE, num_moyen_ep_micro_WAKE, perc_moyen_micro_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.microWakeEpochAcc,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),'wake',tempbin,time_st,time_mid);
dur_micro_WAKE_3_end_SD_dreadd_cno(m)=dur_moyenne_ep_micro_WAKE;
num_micro_WAKE_3_end_SD_dreadd_cno(m)=num_moyen_ep_micro_WAKE;
perc_micro_WAKE_3_end_SD_dreadd_cno(m)=perc_moyen_micro_WAKE;


    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_3_end_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_3_end_SD_dreadd_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_3_end_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_3_end_SD_dreadd_cno{m}=perc_moyen_REM;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),tempbin,time_mid,time_end);
    all_trans_REM_REM_3_end_SD_dreadd_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_3_end_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_3_end_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_3_end_SD_dreadd_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_3_end_SD_dreadd_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_3_end_SD_dreadd_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_3_end_SD_dreadd_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_3_end_SD_dreadd_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_3_end_SD_dreadd_cno{m} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_REM_SD_dreadd_cno_bis{m}, durT_REM_SD_dreadd_cno(m)]=DurationEpoch(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),'s');
    
    idx_short_rem_SD_dreadd_cno_1{m} = find(dur_REM_SD_dreadd_cno_bis{m}<lim_short_1);
    short_REMEpoch_SD_dreadd_cno_1{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}), idx_short_rem_SD_dreadd_cno_1{m});
    [dur_rem_short_SD_dreadd_cno_1{m}, durT_rem_short_SD_dreadd_cno(m)] = DurationEpoch(short_REMEpoch_SD_dreadd_cno_1{m},'s');
    perc_rem_short_SD_dreadd_cno_1(m) = durT_rem_short_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_short_SD_dreadd_cno_1(m) = nanmean(dur_rem_short_SD_dreadd_cno_1{m});
    num_moyen_rem_short_SD_dreadd_cno_1(m) = length(dur_rem_short_SD_dreadd_cno_1{m});
    
    idx_short_rem_SD_dreadd_cno_2{m} = find(dur_REM_SD_dreadd_cno_bis{m}<lim_short_2); %short bouts < 15s
    short_REMEpoch_SD_dreadd_cno_2{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}), idx_short_rem_SD_dreadd_cno_2{m});
    [dur_rem_short_SD_dreadd_cno_2{m}, durT_rem_short_SD_dreadd_cno(m)] = DurationEpoch(short_REMEpoch_SD_dreadd_cno_2{m},'s');
    perc_rem_short_SD_dreadd_cno_2(m) = durT_rem_short_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_short_SD_dreadd_cno_2(m) = nanmean(dur_rem_short_SD_dreadd_cno_2{m});
    num_moyen_rem_short_SD_dreadd_cno_2(m) = length(dur_rem_short_SD_dreadd_cno_2{m});
    
    idx_short_rem_SD_dreadd_cno_3{m} = find(dur_REM_SD_dreadd_cno_bis{m}<lim_short_3);  %short bouts < 20s
    short_REMEpoch_SD_dreadd_cno_3{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}), idx_short_rem_SD_dreadd_cno_3{m});
    [dur_rem_short_SD_dreadd_cno_3{m}, durT_rem_short_SD_dreadd_cno(m)] = DurationEpoch(short_REMEpoch_SD_dreadd_cno_3{m},'s');
    perc_rem_short_SD_dreadd_cno_3(m) = durT_rem_short_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_short_SD_dreadd_cno_3(m) = nanmean(dur_rem_short_SD_dreadd_cno_3{m});
    num_moyen_rem_short_SD_dreadd_cno_3(m) = length(dur_rem_short_SD_dreadd_cno_3{m});
    
    idx_long_rem_SD_dreadd_cno{m} = find(dur_REM_SD_dreadd_cno_bis{m}>lim_long);
    long_REMEpoch_SD_dreadd_cno{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}), idx_long_rem_SD_dreadd_cno{m});
    [dur_rem_long_SD_dreadd_cno{m}, durT_rem_long_SD_dreadd_cno(m)] = DurationEpoch(long_REMEpoch_SD_dreadd_cno{m},'s');
    perc_rem_long_SD_dreadd_cno(m) = durT_rem_long_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_long_SD_dreadd_cno(m) = nanmean(dur_rem_long_SD_dreadd_cno{m});
    num_moyen_rem_long_SD_dreadd_cno(m) = length(dur_rem_long_SD_dreadd_cno{m});
    
    idx_mid_rem_SD_dreadd_cno{m} = find(dur_REM_SD_dreadd_cno_bis{m}>lim_short_1 & dur_REM_SD_dreadd_cno_bis{m}<lim_long);
    mid_REMEpoch_SD_dreadd_cno{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}), idx_mid_rem_SD_dreadd_cno{m});
    [dur_rem_mid_SD_dreadd_cno{m}, durT_rem_mid_SD_dreadd_cno(m)] = DurationEpoch(mid_REMEpoch_SD_dreadd_cno{m},'s');
    perc_rem_mid_SD_dreadd_cno(m) = durT_rem_mid_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_mid_SD_dreadd_cno(m) = nanmean(dur_rem_mid_SD_dreadd_cno{m});
    num_moyen_rem_mid_SD_dreadd_cno(m) = length(dur_rem_mid_SD_dreadd_cno{m});
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for m=1:length(dur_REM_SD_dreadd_cno)
    %%ALL SESSION 
    data_dur_REM_SD_dreadd_cno(m,:) = dur_REM_SD_dreadd_cno{m}; data_dur_REM_SD_dreadd_cno(isnan(data_dur_REM_SD_dreadd_cno)==1)=0;
    data_dur_SWS_SD_dreadd_cno(m,:) = dur_SWS_SD_dreadd_cno{m}; data_dur_SWS_SD_dreadd_cno(isnan(data_dur_SWS_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_SD_dreadd_cno(m,:) = dur_WAKE_SD_dreadd_cno{m}; data_dur_WAKE_SD_dreadd_cno(isnan(data_dur_WAKE_SD_dreadd_cno)==1)=0;
    
    data_num_REM_SD_dreadd_cno(m,:) = num_REM_SD_dreadd_cno{m};data_num_REM_SD_dreadd_cno(isnan(data_num_REM_SD_dreadd_cno)==1)=0;
    data_num_SWS_SD_dreadd_cno(m,:) = num_SWS_SD_dreadd_cno{m}; data_num_SWS_SD_dreadd_cno(isnan(data_num_SWS_SD_dreadd_cno)==1)=0;
    data_num_WAKE_SD_dreadd_cno(m,:) = num_WAKE_SD_dreadd_cno{m}; data_num_WAKE_SD_dreadd_cno(isnan(data_num_WAKE_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_SD_dreadd_cno(m,:) = perc_REM_SD_dreadd_cno{m}; data_perc_REM_SD_dreadd_cno(isnan(data_perc_REM_SD_dreadd_cno)==1)=0;
    data_perc_SWS_SD_dreadd_cno(m,:) = perc_SWS_SD_dreadd_cno{m}; data_perc_SWS_SD_dreadd_cno(isnan(data_perc_SWS_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_SD_dreadd_cno(m,:) = perc_WAKE_SD_dreadd_cno{m}; data_perc_WAKE_SD_dreadd_cno(isnan(data_perc_WAKE_SD_dreadd_cno)==1)=0;

    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_SD_dreadd_cno(m,:) = dur_REM_1_3h_SD_dreadd_cno{m}; data_dur_REM_1_3h_SD_dreadd_cno(isnan(data_dur_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_dur_SWS_1_3h_SD_dreadd_cno(m,:) = dur_SWS_1_3h_SD_dreadd_cno{m}; data_dur_SWS_1_3h_SD_dreadd_cno(isnan(data_dur_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_1_3h_SD_dreadd_cno(m,:) = dur_WAKE_1_3h_SD_dreadd_cno{m}; data_dur_WAKE_1_3h_SD_dreadd_cno(isnan(data_dur_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    
    data_num_REM_1_3h_SD_dreadd_cno(m,:) = num_REM_1_3h_SD_dreadd_cno{m};data_num_REM_1_3h_SD_dreadd_cno(isnan(data_num_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_num_SWS_1_3h_SD_dreadd_cno(m,:) = num_SWS_1_3h_SD_dreadd_cno{m}; data_num_SWS_1_3h_SD_dreadd_cno(isnan(data_num_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_num_WAKE_1_3h_SD_dreadd_cno(m,:) = num_WAKE_1_3h_SD_dreadd_cno{m}; data_num_WAKE_1_3h_SD_dreadd_cno(isnan(data_num_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_1_3h_SD_dreadd_cno(m,:) = perc_REM_1_3h_SD_dreadd_cno{m}; data_perc_REM_1_3h_SD_dreadd_cno(isnan(data_perc_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_perc_SWS_1_3h_SD_dreadd_cno(m,:) = perc_SWS_1_3h_SD_dreadd_cno{m}; data_perc_SWS_1_3h_SD_dreadd_cno(isnan(data_perc_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_1_3h_SD_dreadd_cno(m,:) = perc_WAKE_1_3h_SD_dreadd_cno{m}; data_perc_WAKE_1_3h_SD_dreadd_cno(isnan(data_perc_WAKE_1_3h_SD_dreadd_cno)==1)=0;

    %%FIN DE LA SESSION
    data_dur_REM_3_end_SD_dreadd_cno(m,:) = dur_REM_3_end_SD_dreadd_cno{m}; data_dur_REM_3_end_SD_dreadd_cno(isnan(data_dur_REM_3_end_SD_dreadd_cno)==1)=0;
    data_dur_SWS_3_end_SD_dreadd_cno(m,:) = dur_SWS_3_end_SD_dreadd_cno{m}; data_dur_SWS_3_end_SD_dreadd_cno(isnan(data_dur_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_3_end_SD_dreadd_cno(m,:) = dur_WAKE_3_end_SD_dreadd_cno{m}; data_dur_WAKE_3_end_SD_dreadd_cno(isnan(data_dur_WAKE_3_end_SD_dreadd_cno)==1)=0;
    
    data_num_REM_3_end_SD_dreadd_cno(m,:) = num_REM_3_end_SD_dreadd_cno{m};data_num_REM_3_end_SD_dreadd_cno(isnan(data_num_REM_3_end_SD_dreadd_cno)==1)=0;
    data_num_SWS_3_end_SD_dreadd_cno(m,:) = num_SWS_3_end_SD_dreadd_cno{m}; data_num_SWS_3_end_SD_dreadd_cno(isnan(data_num_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_num_WAKE_3_end_SD_dreadd_cno(m,:) = num_WAKE_3_end_SD_dreadd_cno{m}; data_num_WAKE_3_end_SD_dreadd_cno(isnan(data_num_WAKE_3_end_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_3_end_SD_dreadd_cno(m,:) = perc_REM_3_end_SD_dreadd_cno{m}; data_perc_REM_3_end_SD_dreadd_cno(isnan(data_perc_REM_3_end_SD_dreadd_cno)==1)=0;
    data_perc_SWS_3_end_SD_dreadd_cno(m,:) = perc_SWS_3_end_SD_dreadd_cno{m}; data_perc_SWS_3_end_SD_dreadd_cno(isnan(data_perc_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_3_end_SD_dreadd_cno(m,:) = perc_WAKE_3_end_SD_dreadd_cno{m}; data_perc_WAKE_3_end_SD_dreadd_cno(isnan(data_perc_WAKE_3_end_SD_dreadd_cno)==1)=0;
end
%%probability
for m=1:length(all_trans_REM_REM_SD_dreadd_cno)
    %%ALL SESSION
    data_REM_REM_SD_dreadd_cno(m,:) = all_trans_REM_REM_SD_dreadd_cno{m}; data_REM_REM_SD_dreadd_cno(isnan(data_REM_REM_SD_dreadd_cno)==1)=0;
    data_REM_SWS_SD_dreadd_cno(m,:) = all_trans_REM_SWS_SD_dreadd_cno{m}; data_REM_SWS_SD_dreadd_cno(isnan(data_REM_SWS_SD_dreadd_cno)==1)=0;
    data_REM_WAKE_SD_dreadd_cno(m,:) = all_trans_REM_WAKE_SD_dreadd_cno{m}; data_REM_WAKE_SD_dreadd_cno(isnan(data_REM_WAKE_SD_dreadd_cno)==1)=0;
    
    data_SWS_SWS_SD_dreadd_cno(m,:) = all_trans_SWS_SWS_SD_dreadd_cno{m}; data_SWS_SWS_SD_dreadd_cno(isnan(data_SWS_SWS_SD_dreadd_cno)==1)=0;
    data_SWS_REM_SD_dreadd_cno(m,:) = all_trans_SWS_REM_SD_dreadd_cno{m}; data_SWS_REM_SD_dreadd_cno(isnan(data_SWS_REM_SD_dreadd_cno)==1)=0;
    data_SWS_WAKE_SD_dreadd_cno(m,:) = all_trans_SWS_WAKE_SD_dreadd_cno{m}; data_SWS_WAKE_SD_dreadd_cno(isnan(data_SWS_WAKE_SD_dreadd_cno)==1)=0;
    
    data_WAKE_WAKE_SD_dreadd_cno(m,:) = all_trans_WAKE_WAKE_SD_dreadd_cno{m}; data_WAKE_WAKE_SD_dreadd_cno(isnan(data_WAKE_WAKE_SD_dreadd_cno)==1)=0;
    data_WAKE_REM_SD_dreadd_cno(m,:) = all_trans_WAKE_REM_SD_dreadd_cno{m}; data_WAKE_REM_SD_dreadd_cno(isnan(data_WAKE_REM_SD_dreadd_cno)==1)=0;
    data_WAKE_SWS_SD_dreadd_cno(m,:) = all_trans_WAKE_SWS_SD_dreadd_cno{m}; data_WAKE_SWS_SD_dreadd_cno(isnan(data_WAKE_SWS_SD_dreadd_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
        data_REM_REM_1_3h_SD_dreadd_cno(m,:) = all_trans_REM_REM_1_3h_SD_dreadd_cno{m}; data_REM_REM_1_3h_SD_dreadd_cno(isnan(data_REM_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_REM_SWS_1_3h_SD_dreadd_cno(m,:) = all_trans_REM_SWS_1_3h_SD_dreadd_cno{m}; data_REM_SWS_1_3h_SD_dreadd_cno(isnan(data_REM_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_REM_WAKE_1_3h_SD_dreadd_cno(m,:) = all_trans_REM_WAKE_1_3h_SD_dreadd_cno{m}; data_REM_WAKE_1_3h_SD_dreadd_cno(isnan(data_REM_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    
    data_SWS_SWS_1_3h_SD_dreadd_cno(m,:) = all_trans_SWS_SWS_1_3h_SD_dreadd_cno{m}; data_SWS_SWS_1_3h_SD_dreadd_cno(isnan(data_SWS_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_SWS_REM_1_3h_SD_dreadd_cno(m,:) = all_trans_SWS_REM_1_3h_SD_dreadd_cno{m}; data_SWS_REM_1_3h_SD_dreadd_cno(isnan(data_SWS_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_SWS_WAKE_1_3h_SD_dreadd_cno(m,:) = all_trans_SWS_WAKE_1_3h_SD_dreadd_cno{m}; data_SWS_WAKE_1_3h_SD_dreadd_cno(isnan(data_SWS_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    
    data_WAKE_WAKE_1_3h_SD_dreadd_cno(m,:) = all_trans_WAKE_WAKE_1_3h_SD_dreadd_cno{m}; data_WAKE_WAKE_1_3h_SD_dreadd_cno(isnan(data_WAKE_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    data_WAKE_REM_1_3h_SD_dreadd_cno(m,:) = all_trans_WAKE_REM_1_3h_SD_dreadd_cno{m}; data_WAKE_REM_1_3h_SD_dreadd_cno(isnan(data_WAKE_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_WAKE_SWS_1_3h_SD_dreadd_cno(m,:) = all_trans_WAKE_SWS_1_3h_SD_dreadd_cno{m}; data_WAKE_SWS_1_3h_SD_dreadd_cno(isnan(data_WAKE_SWS_1_3h_SD_dreadd_cno)==1)=0;
    
    %%FIN DE LA SESSION
        data_REM_REM_3_end_SD_dreadd_cno(m,:) = all_trans_REM_REM_3_end_SD_dreadd_cno{m}; data_REM_REM_3_end_SD_dreadd_cno(isnan(data_REM_REM_3_end_SD_dreadd_cno)==1)=0;
    data_REM_SWS_3_end_SD_dreadd_cno(m,:) = all_trans_REM_SWS_3_end_SD_dreadd_cno{m}; data_REM_SWS_3_end_SD_dreadd_cno(isnan(data_REM_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_REM_WAKE_3_end_SD_dreadd_cno(m,:) = all_trans_REM_WAKE_3_end_SD_dreadd_cno{m}; data_REM_WAKE_3_end_SD_dreadd_cno(isnan(data_REM_WAKE_3_end_SD_dreadd_cno)==1)=0;
    
    data_SWS_SWS_3_end_SD_dreadd_cno(m,:) = all_trans_SWS_SWS_3_end_SD_dreadd_cno{m}; data_SWS_SWS_3_end_SD_dreadd_cno(isnan(data_SWS_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_SWS_REM_3_end_SD_dreadd_cno(m,:) = all_trans_SWS_REM_3_end_SD_dreadd_cno{m}; data_SWS_REM_3_end_SD_dreadd_cno(isnan(data_SWS_REM_3_end_SD_dreadd_cno)==1)=0;
    data_SWS_WAKE_3_end_SD_dreadd_cno(m,:) = all_trans_SWS_WAKE_3_end_SD_dreadd_cno{m}; data_SWS_WAKE_3_end_SD_dreadd_cno(isnan(data_SWS_WAKE_3_end_SD_dreadd_cno)==1)=0;
    
    data_WAKE_WAKE_3_end_SD_dreadd_cno(m,:) = all_trans_WAKE_WAKE_3_end_SD_dreadd_cno{m}; data_WAKE_WAKE_3_end_SD_dreadd_cno(isnan(data_WAKE_WAKE_3_end_SD_dreadd_cno)==1)=0;
    data_WAKE_REM_3_end_SD_dreadd_cno(m,:) = all_trans_WAKE_REM_3_end_SD_dreadd_cno{m}; data_WAKE_REM_3_end_SD_dreadd_cno(isnan(data_WAKE_REM_3_end_SD_dreadd_cno)==1)=0;
    data_WAKE_SWS_3_end_SD_dreadd_cno(m,:) = all_trans_WAKE_SWS_3_end_SD_dreadd_cno{m}; data_WAKE_SWS_3_end_SD_dreadd_cno(isnan(data_WAKE_SWS_3_end_SD_dreadd_cno)==1)=0;
    
end



%%
rm=3;
 binH=1;
for i=1:length(DirSocialDefeat_sleepPost_classic.path)
    h_SD(i,:)=hist(dur_REM_SD_bis{i},[1:binH:200]);
end

for i=1:length(Dir_ctrl.path)
    h_ctrl(i,:)=hist(dur_REM_ctrl_bis{i},[1:binH:200]);
end

for i=1:length(DirSocialDefeat_sleepPost_mCherry_CNO.path)
    h_SD_mCherry_cno(i,:)=hist(dur_REM_SD_mCherry_cno_bis{i},[1:binH:200]);
end
for i=1:length(DirSocialDefeat_sleepPost_dreadd_CNO.path)
    h_SD_dreadd_cno(i,:)=hist(dur_REM_SD_dreadd_cno_bis{i},[1:binH:200]);
end


%%
hist_cum_ctrl = cumsum(h_ctrl');
hist_cum_SD = cumsum(h_SD');
hist_cum_SD_mCherry_cno = cumsum(h_SD_mCherry_cno');
hist_cum_SD_dreadd_cno = cumsum(h_SD_dreadd_cno');

figure, hold on,
plot(nanmean(hist_cum_ctrl,2),'color',col_ctrl)
plot(nanmean(hist_cum_SD,2),'color',col_SD)

plot(nanmean(hist_cum_SD_mCherry_cno,2),'color',col_mCherry_cno)
plot(nanmean(hist_cum_SD_dreadd_cno,2),'color',col_dreadd_cno)


%%
figure, hold on,
plot(cumsum(h_ctrl')/ sum(h_ctrl'),'color',col_ctrl)
plot(cumsum(h_SD')/ sum(h_SD'),'color',col_SD)
plot(cumsum(h_SD_mCherry_cno')/ sum(h_SD_mCherry_cno'),'color',col_mCherry_cno)
plot(cumsum(h_SD_dreadd_cno')/ sum(h_SD_dreadd_cno'),'color',col_dreadd_cno)

%% FIGURE
txt_size = 15;

col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];
col_mCherry_cno = [1 .2 0];
col_dreadd_cno = [0 .4 .4];

% col_dreadd_cno = [0 .6 .4]; %%PFC inhib


figure, hold on
subplot(4,6,[1,2]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_WAKE_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_perc_WAKE_SD_mCherry_cno), stdError(data_perc_WAKE_SD_mCherry_cno),'color',col_mCherry_cno)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'linestyle','-','color',col_SD)
plot(nanmean(data_perc_WAKE_SD_dreadd_cno),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_perc_WAKE_SD_dreadd_cno), stdError(data_perc_WAKE_SD_dreadd_cno),'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('Wake percentage')
%set(gca,'fontsize',18,'fontname','FreeSans')


subplot(4,6,[7,8]) % WAKE percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('Wake percentage')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[3,4]), hold on % SWS percentage overtime
plot(nanmean(data_perc_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_SWS_ctrl), stdError(data_perc_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_SWS_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_perc_SWS_SD_mCherry_cno), stdError(data_perc_SWS_SD_mCherry_cno),'color',col_mCherry_cno)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'linestyle','-','color',col_SD)
plot(nanmean(data_perc_SWS_SD_dreadd_cno),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_perc_SWS_SD_dreadd_cno), stdError(data_perc_SWS_SD_dreadd_cno),'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('NREM percentage')
%set(gca,'fontsize',18,'fontname','FreeSans')


subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_SWS_1_3h_ctrl,2),  nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')


[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[5,6]) %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_REM_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_perc_REM_SD_mCherry_cno), stdError(data_perc_REM_SD_mCherry_cno),'color',col_mCherry_cno)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'linestyle','-','color',col_SD)
plot(nanmean(data_perc_REM_SD_dreadd_cno),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_perc_REM_SD_dreadd_cno), stdError(data_perc_REM_SD_dreadd_cno),'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('REM percentage')
%set(gca,'fontsize',18,'fontname','FreeSans')


subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('REM percentage')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[13,14]) % REM bouts mean duraion overtime
plot(nanmean(data_dur_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_REM_ctrl), stdError(data_dur_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_REM_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_dur_REM_SD_mCherry_cno), stdError(data_dur_REM_SD_mCherry_cno),'color',col_mCherry_cno)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'linestyle','-','color',col_SD)
plot(nanmean(data_dur_REM_SD_dreadd_cno),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_dur_REM_SD_dreadd_cno), stdError(data_dur_REM_SD_dreadd_cno),'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('REM mean duration (s)')
%set(gca,'fontsize',18,'fontname','FreeSans')



subplot(4,6,[19,20]) % REM bouts mean duration quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('REM mean duration (s)')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[15,16,21,22])
 hold on,
 makepretty
plot([1:binH:200],runmean(mean(h_ctrl),rm),'color',[.5 .5 .5],'linewidth',4)
plot([1:binH:200],runmean(mean(h_SD),rm),'color',col_SD','linewidth',4)
plot([1:binH:200],runmean(mean(h_SD_mCherry_cno),rm),'color',col_mCherry_cno,'linewidth',4)
plot([1:binH:200],runmean(mean(h_SD_dreadd_cno),rm),'color',col_dreadd_cno,'linewidth',4)
% xlim([0 60])
ylim([0 1.2])
line([10 10], ylim, 'color',[.5 .5 .5],'linestyle',':')
legend({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO',''})

xlabel('REM bouts mean duration (s)')
ylabel('Counts')


subplot(4,6,[17,23])

PlotErrorBarN_MC({perc_rem_short_ctrl_1, perc_rem_short_SD_1, perc_rem_short_SD_mCherry_cno_1,perc_rem_short_SD_dreadd_cno_1},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('Short REM percentage')
% title('SHORT')
xticks([1:4]), xticklabels({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO'}), xtickangle(45)
makepretty
% set(gca,'fontsize',18,'fontname','FreeSans')

[h_1_2 ,p_1_2] = ttest2(perc_rem_short_ctrl_1, perc_rem_short_SD_1);
[h_1_3, p_1_3] = ttest2(perc_rem_short_ctrl_1, perc_rem_short_SD_mCherry_cno_1);
[h_1_4 ,p_1_4] = ttest2(perc_rem_short_ctrl_1, perc_rem_short_SD_dreadd_cno_1);
[h_2_3, p_2_3] = ttest2(perc_rem_short_SD_mCherry_cno_1, perc_rem_short_SD_1);
[h_2_4, p_2_4] = ttest2(perc_rem_short_SD_1, perc_rem_short_SD_dreadd_cno_1);
[h_3_4, p_3_4] = ttest2(perc_rem_short_SD_mCherry_cno_1, perc_rem_short_SD_dreadd_cno_1);

% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end
if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',txt_size);end

clear p_1_2 p_1_3 p_1_4 p_2_3 p_2_4 p_3_4

subplot(4,6,[18,24])
PlotErrorBarN_MC({perc_rem_long_ctrl, perc_rem_long_SD,perc_rem_long_SD_mCherry_cno,perc_rem_long_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('Long REM percentage')
xticks([1:4]), xticklabels({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO'}), xtickangle(45)
makepretty
% set(gca,'fontsize',18,'fontname','FreeSans')

[h_1_2 ,p_1_2] = ttest2(perc_rem_long_ctrl, perc_rem_long_SD);
[h_1_3, p_1_3] = ttest2(perc_rem_long_ctrl, perc_rem_long_SD_mCherry_cno);
[h_1_4 ,p_1_4] = ttest2(perc_rem_long_ctrl, perc_rem_long_SD_dreadd_cno);
[h_2_3, p_2_3] = ttest2(perc_rem_long_SD_mCherry_cno, perc_rem_long_SD);
[h_2_4, p_2_4] = ttest2(perc_rem_long_SD, perc_rem_long_SD_dreadd_cno);
[h_3_4, p_3_4] = ttest2(perc_rem_long_SD_mCherry_cno, perc_rem_long_SD_dreadd_cno);
% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end
if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',txt_size);end

%%


figure
subplot(2,4,[1,2,5,6])
hold on,
 makepretty
plot([1:binH:200],runmean(mean(h_ctrl),rm),'color',[.5 .5 .5],'linewidth',4)
plot([1:binH:200],runmean(mean(h_SD),rm),'color',col_SD','linewidth',4)
plot([1:binH:200],runmean(mean(h_SD_mCherry_cno),rm),'color',col_mCherry_cno,'linewidth',4)
plot([1:binH:200],runmean(mean(h_SD_dreadd_cno),rm),'color',col_dreadd_cno,'linewidth',4)
line([10 10], ylim, 'color',[.5 .5 .5],'linestyle',':')
legend({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO',''})
 ylim([0 1.2])
xlabel('REM bouts mean duration (s)')
ylabel('Counts')




subplot(2,4,3)
PlotErrorBarN_MC({num_moyen_rem_mid_ctrl, num_moyen_rem_mid_SD,num_moyen_rem_mid_SD_mCherry_cno,num_moyen_rem_mid_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('mid REM bouts number')
xticks([1:4]), xticklabels({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO'}), xtickangle(45)
makepretty
% set(gca,'fontsize',18,'fontname','FreeSans')

[h_1_2 ,p_1_2] = ttest2(num_moyen_rem_mid_ctrl, num_moyen_rem_mid_SD);
[h_1_3, p_1_3] = ttest2(num_moyen_rem_mid_ctrl, num_moyen_rem_mid_SD_mCherry_cno);
[h_1_4 ,p_1_4] = ttest2(num_moyen_rem_mid_ctrl, num_moyen_rem_mid_SD_dreadd_cno);
[h_2_3, p_2_3] = ttest2(num_moyen_rem_mid_SD_mCherry_cno, num_moyen_rem_mid_SD);
[h_2_4, p_2_4] = ttest2(num_moyen_rem_mid_SD, num_moyen_rem_mid_SD_dreadd_cno);
[h_3_4, p_3_4] = ttest2(num_moyen_rem_mid_SD_mCherry_cno, num_moyen_rem_mid_SD_dreadd_cno);
% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end
if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',txt_size);end



subplot(2,4,4)
PlotErrorBarN_MC({perc_rem_mid_ctrl, perc_rem_mid_SD,perc_rem_mid_SD_mCherry_cno,perc_rem_mid_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('mid REM percentage')
xticks([1:4]), xticklabels({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO'}), xtickangle(45)
makepretty
% set(gca,'fontsize',18,'fontname','FreeSans')

[h_1_2 ,p_1_2] = ttest2(perc_rem_mid_ctrl, perc_rem_mid_SD);
[h_1_3, p_1_3] = ttest2(perc_rem_mid_ctrl, perc_rem_mid_SD_mCherry_cno);
[h_1_4 ,p_1_4] = ttest2(perc_rem_mid_ctrl, perc_rem_mid_SD_dreadd_cno);
[h_2_3, p_2_3] = ttest2(perc_rem_mid_SD_mCherry_cno, perc_rem_mid_SD);
[h_2_4, p_2_4] = ttest2(perc_rem_mid_SD, perc_rem_mid_SD_dreadd_cno);
[h_3_4, p_3_4] = ttest2(perc_rem_mid_SD_mCherry_cno, perc_rem_mid_SD_dreadd_cno);
% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end
if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',txt_size);end



subplot(2,4,7)
PlotErrorBarN_MC({num_moyen_rem_long_ctrl, num_moyen_rem_long_SD,num_moyen_rem_long_SD_mCherry_cno,num_moyen_rem_long_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('Long REM bouts number')
xticks([1:4]), xticklabels({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO'}), xtickangle(45)
makepretty
set(gca,'fontsize',18,'fontname','FreeSans')

[h_1_2 ,p_1_2] = ttest2(num_moyen_rem_long_ctrl, num_moyen_rem_long_SD);
[h_1_3, p_1_3] = ttest2(num_moyen_rem_long_ctrl, num_moyen_rem_long_SD_mCherry_cno);
[h_1_4 ,p_1_4] = ttest2(num_moyen_rem_long_ctrl, num_moyen_rem_long_SD_dreadd_cno);
[h_2_3, p_2_3] = ttest2(num_moyen_rem_long_SD_mCherry_cno, num_moyen_rem_long_SD);
[h_2_4, p_2_4] = ttest2(num_moyen_rem_long_SD, num_moyen_rem_long_SD_dreadd_cno);
[h_3_4, p_3_4] = ttest2(num_moyen_rem_long_SD_mCherry_cno, num_moyen_rem_long_SD_dreadd_cno);
% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end
if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',txt_size);end



subplot(2,4,8)
PlotErrorBarN_MC({perc_rem_long_ctrl, perc_rem_long_SD,perc_rem_long_SD_mCherry_cno,perc_rem_long_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('Long REM percentage')
xticks([1:4]), xticklabels({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO'}), xtickangle(45)
makepretty
set(gca,'fontsize',18,'fontname','FreeSans')

[h_1_2 ,p_1_2] = ttest2(perc_rem_long_ctrl, perc_rem_long_SD);
[h_1_3, p_1_3] = ttest2(perc_rem_long_ctrl, perc_rem_long_SD_mCherry_cno);
[h_1_4 ,p_1_4] = ttest2(perc_rem_long_ctrl, perc_rem_long_SD_dreadd_cno);
[h_2_3, p_2_3] = ttest2(perc_rem_long_SD_mCherry_cno, perc_rem_long_SD);
[h_2_4, p_2_4] = ttest2(perc_rem_long_SD, perc_rem_long_SD_dreadd_cno);
[h_3_4, p_3_4] = ttest2(perc_rem_long_SD_mCherry_cno, perc_rem_long_SD_dreadd_cno);
% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end
if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',txt_size);end





%%



% 
% 
% %% TEST CUMSUM
% all_rem_dur_cum_SD = [];
% all_rem_dur_cum_ctrl = [];
% all_rem_dur_cum_SD_mcherry_cno = [];
% all_rem_dur_cum_SD_dreadd_cno = [];
% 
% for imouse=1:length(DirSocialDefeat_sleepPost_classic.path)
%     all_rem_dur_cum_SD = [all_rem_dur_cum_SD; dur_REM_SD_bis{imouse}];
% end
% 
% for imouse=1:length(Dir_ctrl.path)
%     all_rem_dur_cum_ctrl = [all_rem_dur_cum_ctrl; dur_REM_ctrl_bis{imouse}];
% end
% 
% for imouse=1:length(DirSocialDefeat_sleepPost_mCherry_CNO.path)
%     all_rem_dur_cum_SD_mcherry_cno = [all_rem_dur_cum_SD_mcherry_cno; dur_REM_SD_mCherry_cno_bis{imouse}];
% end
% 
% for imouse=1:length(DirSocialDefeat_sleepPost_dreadd_CNO.path)
%     all_rem_dur_cum_SD_dreadd_cno = [all_rem_dur_cum_SD_dreadd_cno; dur_REM_SD_dreadd_cno_bis{imouse}];
% end
% 
% %%
% for i=1:length(Dir_ctrl.path)
%     B_ctrl{i}=cumsum(dur_REM_ctrl_bis{i});
% end
% 
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     B_SD{i}=cumsum(dur_REM_SD_bis{i});
% end
% 
% for i=1:length(DirSocialDefeat_sleepPost_mCherry_CNO.path)
%     B_SD_mCherry_cno{i}=cumsum(dur_REM_SD_mCherry_cno_bis{i});
% end
% 
% for i=1:length(DirSocialDefeat_sleepPost_dreadd_CNO.path)
%     B_SD_dreadd_cno{i}=cumsum(dur_REM_SD_dreadd_cno_bis{i});
% end
% 
% 
% 
% 
% %%
% 
% table_dur_ctrl(length(Dir_ctrl.path),100) = 0;
% for i=1:length(Dir_ctrl.path)
%     for ii=1:length(dur_REM_ctrl_bis{i})
%     table_dur_ctrl(i,ii) = dur_REM_ctrl_bis{i}(ii);
%     end
% end
% table_dur_ctrl(table_dur_ctrl==0)=NaN;
% 
% 
% table_dur_SD(length(DirSocialDefeat_sleepPost_classic.path),100) = 0;
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     for ii=1:length(dur_REM_SD_bis{i})
%     table_dur_SD(i,ii) = dur_REM_SD_bis{i}(ii);
%     end
% end
% table_dur_SD(table_dur_SD==0)=NaN;
% 
% 
% 
% table_dur_SD_mCherry_cno(length(DirSocialDefeat_sleepPost_mCherry_CNO.path),100) = 0;
% for i=1:length(DirSocialDefeat_sleepPost_mCherry_CNO.path)
%     for ii=1:length(dur_REM_SD_mCherry_cno_bis{i})
%     table_dur_SD_mCherry_cno(i,ii) = dur_REM_SD_mCherry_cno_bis{i}(ii);
%     end
% end
% table_dur_SD_mCherry_cno(table_dur_SD_mCherry_cno==0)=NaN;
% 
% 
% 
% table_dur_SD_dreadd_cno(length(DirSocialDefeat_sleepPost_dreadd_CNO.path),100) = 0;
% for i=1:length(DirSocialDefeat_sleepPost_dreadd_CNO.path)
%     for ii=1:length(dur_REM_SD_dreadd_cno_bis{i})
%     table_dur_SD_dreadd_cno(i,ii) = dur_REM_SD_dreadd_cno_bis{i}(ii);
%     end
% end
% table_dur_SD_dreadd_cno(table_dur_SD_dreadd_cno==0)=NaN;
% 
% 
% %%
% 
% B_ctrl_mean=cumsum(table_dur_ctrl');
% B_SD_mean=cumsum(table_dur_SD');
% B_SD_mCherry_cno_mean=cumsum(table_dur_SD_mCherry_cno');
% B_SD_dreadd_cno_mean=cumsum(table_dur_SD_dreadd_cno');
% 
% 
% %%
% 
% figure, 
% subplot(411), hold on, plot(B_ctrl_mean,'color',col_ctrl)
% subplot(412), hold on, plot(B_SD_mean,'color',col_SD)
% subplot(413), hold on, plot(B_SD_mCherry_cno_mean,'color',col_mCherry_cno)
% subplot(414), hold on, plot(B_SD_dreadd_cno_mean,'color',col_dreadd_cno)
% 
% 
% figure, hold on
% plot(nanmean(B_ctrl_mean,2),'color',col_ctrl)
% plot(nanmean(B_SD_mean,2),'color',col_SD)
% plot(nanmean(B_SD_mCherry_cno_mean,2),'color',col_mCherry_cno)
% plot(nanmean(B_SD_dreadd_cno_mean,2),'color',col_dreadd_cno)
% 
% 
% 
% %%
% 
% figure, 
% subplot(411), hold on, plot(B_ctrl_mean,'color',col_ctrl)
% plot(nanmean(B_ctrl_mean,2),'color',col_ctrl,'linewidth',3)
% 
% subplot(412), hold on, plot(B_SD_mean,'color',col_SD)
% plot(nanmean(B_SD_mean,2),'color',col_SD,'linewidth',3)
% 
% subplot(413), hold on, plot(B_SD_mCherry_cno_mean,'color',col_mCherry_cno)
% plot(nanmean(B_SD_mCherry_cno_mean,2),'color',col_mCherry_cno,'linewidth',3)
% 
% subplot(414), hold on, plot(B_SD_dreadd_cno_mean,'color',col_dreadd_cno)
% plot(nanmean(B_SD_dreadd_cno_mean,2),'color',col_dreadd_cno,'linewidth',3)
% 
% 
% 
% 
% %%
% B_ctrl_all=cumsum(all_rem_dur_cum_ctrl);
% B_SD_all=cumsum(all_rem_dur_cum_SD);
% B_SD_mCherry_cno_all=cumsum(all_rem_dur_cum_SD_mcherry_cno);
% B_SD_dreadd_cno_all=cumsum(all_rem_dur_cum_SD_dreadd_cno);
% 
% 
% 
% %%
% 
% figure, 
% hold on
% for i=1:length(Dir_ctrl.path)
%     plot(B_ctrl{i},'color',col_ctrl)
% end
% 
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     plot(B_SD{i},'color',col_SD)
% end
% 
% for i=1:length(DirSocialDefeat_sleepPost_mCherry_CNO.path)
%     plot(B_SD_mCherry_cno{i},'color',col_mCherry_cno)
% end
% 
% for i=1:length(DirSocialDefeat_sleepPost_dreadd_CNO.path)
%     plot(B_SD_dreadd_cno{i},'color',col_dreadd_cno)
% end
% 
% 
% 
% 
% 
% %%
% figure,
% subplot(4,1,1),hold on
% for i=1:length(Dir_ctrl.path)
% 
%     plot(B_ctrl{i},'color',col_ctrl)
% end
% makepretty
% ylim([0 2500]); xlim([0 60]);
% 
% plot([0 60],[0 2500],'color',[.6 .6 .6])
% plot([0 40],[0 2500],'color',[.6 .6 .6])
% plot([0 30],[0 2500],'color',[.6 .6 .6])
% 
% subplot(4,1,2),hold on
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     plot(B_SD{i},'color',col_SD)
% end
% makepretty
% ylim([0 2500]); xlim([0 60]);
% 
% plot([0 60],[0 2500],'color',[.6 .6 .6])
% plot([0 40],[0 2500],'color',[.6 .6 .6])
% plot([0 30],[0 2500],'color',[.6 .6 .6])
% 
% subplot(4,1,3),hold on
% for i=1:length(DirSocialDefeat_sleepPost_mCherry_CNO.path)
%     plot(B_SD_mCherry_cno{i},'color',col_mCherry_cno)
% end
% makepretty
% ylim([0 2500]); xlim([0 60]);
% 
% plot([0 60],[0 2500],'color',[.6 .6 .6])
% plot([0 40],[0 2500],'color',[.6 .6 .6])
% plot([0 30],[0 2500],'color',[.6 .6 .6])
% 
% subplot(4,1,4),hold on
% for i=1:length(DirSocialDefeat_sleepPost_dreadd_CNO.path)
%     plot(B_SD_dreadd_cno{i},'color',col_dreadd_cno)
% end
% makepretty
% ylim([0 2500]); xlim([0 60]);
% 
% plot([0 60],[0 2500],'color',[.6 .6 .6])
% plot([0 40],[0 2500],'color',[.6 .6 .6])
% plot([0 30],[0 2500],'color',[.6 .6 .6])
% 


%%


txt_size = 15;

col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];
col_mCherry_cno = [1 .2 0];
col_dreadd_cno = [0 .4 .4];



figure, hold on

subplot(4,6,[7,8]) % WAKE percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('Wake percentage')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_SWS_1_3h_ctrl,2),  nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')


[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('REM percentage')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[13,14]) % REM bouts mean duration quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('REM mean duration (s)')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[15])
PlotErrorBarN_MC({perc_rem_short_ctrl_1, perc_rem_short_SD_1, perc_rem_short_SD_mCherry_cno_1,perc_rem_short_SD_dreadd_cno_1},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('Short REM percentage')
makepretty
% xticks([1:4]), xticklabels({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO'}), xtickangle(45)

set(gca,'xticklabels',[])

[h_1_2 ,p_1_2] = ttest2(perc_rem_short_ctrl_1, perc_rem_short_SD_1);
[h_1_3, p_1_3] = ttest2(perc_rem_short_ctrl_1, perc_rem_short_SD_mCherry_cno_1);
[h_1_4 ,p_1_4] = ttest2(perc_rem_short_ctrl_1, perc_rem_short_SD_dreadd_cno_1);
[h_2_3, p_2_3] = ttest2(perc_rem_short_SD_mCherry_cno_1, perc_rem_short_SD_1);
[h_2_4, p_2_4] = ttest2(perc_rem_short_SD_1, perc_rem_short_SD_dreadd_cno_1);
[h_3_4, p_3_4] = ttest2(perc_rem_short_SD_mCherry_cno_1, perc_rem_short_SD_dreadd_cno_1);

% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end
if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',txt_size);end





subplot(4,6,[16])
PlotErrorBarN_MC({perc_rem_short_ctrl_2, perc_rem_short_SD_2, perc_rem_short_SD_mCherry_cno_2,perc_rem_short_SD_dreadd_cno_2},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('Short REM percentage')
% title('SHORT')
% xticks([1:4]), xticklabels({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO'}), xtickangle(45)
makepretty
set(gca,'xticklabels',[])

% set(gca,'fontsize',18,'fontname','FreeSans')

[h_1_2 ,p_1_2] = ttest2(perc_rem_short_ctrl_2, perc_rem_short_SD_2);
[h_1_3, p_1_3] = ttest2(perc_rem_short_ctrl_2, perc_rem_short_SD_mCherry_cno_2);
[h_1_4 ,p_1_4] = ttest2(perc_rem_short_ctrl_2, perc_rem_short_SD_dreadd_cno_2);
[h_2_3, p_2_3] = ttest2(perc_rem_short_SD_mCherry_cno_2, perc_rem_short_SD_2);
[h_2_4, p_2_4] = ttest2(perc_rem_short_SD_2, perc_rem_short_SD_dreadd_cno_2);
[h_3_4, p_3_4] = ttest2(perc_rem_short_SD_mCherry_cno_2, perc_rem_short_SD_dreadd_cno_2);

% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end
if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',txt_size);end




subplot(4,6,[17])
PlotErrorBarN_MC({perc_rem_short_ctrl_3, perc_rem_short_SD_3, perc_rem_short_SD_mCherry_cno_3,perc_rem_short_SD_dreadd_cno_3},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('Short REM percentage')
% title('SHORT')
% xticks([1:4]), xticklabels({'CTRL','mCherry + SAL','mCherry + CNO','hM4Di + CNO'}), xtickangle(45)
makepretty
set(gca,'xticklabels',[])

[h_1_2 ,p_1_2] = ttest2(perc_rem_short_ctrl_3, perc_rem_short_SD_3);
[h_1_3, p_1_3] = ttest2(perc_rem_short_ctrl_3, perc_rem_short_SD_mCherry_cno_3);
[h_1_4 ,p_1_4] = ttest2(perc_rem_short_ctrl_3, perc_rem_short_SD_dreadd_cno_3);
[h_2_3, p_2_3] = ttest2(perc_rem_short_SD_mCherry_cno_3, perc_rem_short_SD_3);
[h_2_4, p_2_4] = ttest2(perc_rem_short_SD_3, perc_rem_short_SD_dreadd_cno_3);
[h_3_4, p_3_4] = ttest2(perc_rem_short_SD_mCherry_cno_3, perc_rem_short_SD_dreadd_cno_3);

% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end
if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',txt_size);end
if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',txt_size);end
if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',txt_size);end



%% suppl


figure,
subplot(4,6,[13,14]) % SWS bouts mean duration quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('SWS mean duration (s)')
makepretty
xlabel('Time after stress (h)')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2),nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SWS_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 2]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[2 3]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2),nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 8]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 7]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[7 8]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[7 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end



subplot(4,6,[15,16])
PlotErrorBarN_MC({...
    nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('SWS mean numation (s)')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2),nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_num_SWS_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));

% if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
% if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
% if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 2]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[2 3]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end


[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2),nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_num_SWS_3_end_SD_mCherry_cno,2), nanmean(data_num_SWS_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_3_end_SD_mCherry_cno,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));

% if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 8]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 7]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[7 8]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[7 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end



subplot(4,6,[19,20]) % WAKE bouts mean duration quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('WAKE mean duration (s)')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2),nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));

% if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
% if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
% if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 2]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[2 3]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end


[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2),nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));

% if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
% % if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 8]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 7]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[7 8]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[7 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end


subplot(4,6,[21,22])
PlotErrorBarN_MC({...
    nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
ylabel('WAKE mean numation (s)')
makepretty
xlabel('Time after stress (h)')
%set(gca,'fontsize',18,'fontname','FreeSans')

[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2),nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));

% if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
% if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
% if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 3]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 2]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); else sigstar_MC({[1 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[2 3]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end


[h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
[h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));

% if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
% % if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 8]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 7]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[6 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_SD<0.05; sigstar_MC({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[7 8]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);else sigstar_MC({[7 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',12);end



