%% input dir
%%1
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');

%%2
DirSocialDefeat_sleepPost_mCherry_cno1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');
DirSocialDefeat_sleepPost_BM_cno1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
DirSocialDefeat_sleepPost_mCherry_cno = MergePathForExperiment(DirSocialDefeat_sleepPost_mCherry_cno1,DirSocialDefeat_sleepPost_BM_cno1);

%%3
DirSocialDefeat_sleepPost_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_sleepPost_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_sleepPost_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_sleepPost_mCherry_saline = MergePathForExperiment(DirSocialDefeat_sleepPost_mCherry_saline1,DirSocialDefeat_sleepPost_BM_saline1);
DirSocialDefeat_sleepPost_classic = MergePathForExperiment(DirSocialDefeat_sleepPost_classic1,DirSocialDefeat_sleepPost_mCherry_saline);

% DirSocialDefeat_sleepPost_classic = MergePathForExperiment(DirSocialDefeat_sleepPost_classic1,DirSocialDefeat_sleepPost_mCherry_cno);

%%4
DirSocialDefeat_sleepPost_dreadd_cno = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_CNOInjection');
%%4 bis (PFC inhibition)
% DirSocialDefeat_sleepPost_dreadd_cno = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_PFC_cnoInjection');

% %% input dir compare 2 controle stress groups
% Dir_ctrl = DirSocialDefeat_sleepPost_classic1;
% DirSocialDefeat_sleepPost_classic = DirSocialDefeat_sleepPost_mCherry_cno;
% DirSocialDefeat_sleepPost_classic = DirSocialDefeat_sleepPost_classic1;


%%
% Dir_ctrl=PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_SalineInjection_10am');
% DirSocialDefeat_sleepPost_mCherry_cno = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_CNOInjection_10am');
% DirSocialDefeat_sleepPost_classic = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_CRH_VLPO_SalineInjection_secondrun');
% DirSocialDefeat_sleepPost_dreadd_cno = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_CRH_VLPO_CNOInjection');


%% parameters
tempbin = 3600;%3600;


time_st = 0*3600*1e4;%0;
time_end=3*1e8;

time_mid_1 = 1.5*3600*1e4;

time_mid = 1.5*3600*1e4;%3.5


min_sws_time = 3*1e4*60;
binH = 2;

lim_short_1 = 10;
lim_short_2 = 15;
lim_short_3 = 20;

lim_long = 30;


%% GET DATA - ctrl group (mCherry saline injection 10h)
for i=1:length(Dir_ctrl.path)
    cd(Dir_ctrl.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_ctrl{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_ctrl{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    same_epoch_ctrl{i} = intervalSet(0,time_end);
    same_epoch_1_3h_ctrl{i} = intervalSet(time_st,time_mid);
    same_epoch_3_end_ctrl{i} = intervalSet(time_mid,time_end);
    same_epoch_interPeriod_ctrl{i} = intervalSet(time_mid_1,time_mid);
    
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
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_ctrl{i}),'sleep',tempbin,time_st,time_end);
    dur_SLEEP_ctrl{i}=dur_moyenne_ep_SLEEP;
    num_SLEEP_ctrl{i}=num_moyen_ep_SLEEP;
    perc_SLEEP_ctrl{i}=perc_moyen_SLEEP;
    
    
    %     %%Compute transition probabilities - overtime
    %     [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
    %         Get_proba_timebins_Overtime_MC_VF(and(stages_ctrl{i}.Wake,same_epoch_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_ctrl{i}),tempbin,time_end);
    %     all_trans_REM_REM_ctrl{i} = trans_REM_to_REM;
    %     all_trans_REM_SWS_ctrl{i} = trans_REM_to_SWS;
    %     all_trans_REM_WAKE_ctrl{i} = trans_REM_to_WAKE;
    %
    %     all_trans_SWS_REM_ctrl{i} = trans_SWS_to_REM;
    %     all_trans_SWS_SWS_ctrl{i} = trans_SWS_to_SWS;
    %     all_trans_SWS_WAKE_ctrl{i} = trans_SWS_to_WAKE;
    %
    %     all_trans_WAKE_REM_ctrl{i} = trans_WAKE_to_REM;
    %     all_trans_WAKE_SWS_ctrl{i} = trans_WAKE_to_SWS;
    %     all_trans_WAKE_WAKE_ctrl{i} = trans_WAKE_to_WAKE;
    %
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_1_3h_ctrl{i}),'wake',tempbin,time_st,time_mid);
    dur_WAKE_1_3h_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_1_3h_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_1_3h_ctrl{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_1_3h_ctrl{i}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_1_3h_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_1_3h_ctrl{i}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_1_3h_ctrl{i}=num_moyen_ep_REM;
    perc_REM_1_3h_ctrl{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_1_3h_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_1_3h_ctrl{i}),'sleep',tempbin,time_st,time_mid);
    dur_SLEEP_1_3h_ctrl{i}=dur_moyenne_ep_SLEEP;
    num_SLEEP_1_3h_ctrl{i}=num_moyen_ep_SLEEP;
    perc_SLEEP_1_3h_ctrl{i}=perc_moyen_SLEEP;
    
    
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
    
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_interPeriod_ctrl{i}),'wake',tempbin,time_mid_1,time_mid);
    dur_WAKE_interPeriod_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_ctrl{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_interPeriod_ctrl{i}),'sws',tempbin,time_mid_1,time_mid);
    dur_SWS_interPeriod_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_interPeriod_ctrl{i}),'rem',tempbin,time_mid_1,time_mid);
    dur_REM_interPeriod_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_interPeriod_ctrl{i}=num_moyen_ep_REM;
    perc_REM_interPeriod_ctrl{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_interPeriod_ctrl{i}),'sleep',tempbin,time_mid_1,time_mid);
    dur_SLEEP_interPeriod_ctrl{i}=dur_moyenne_ep_SLEEP;
    num_SLEEP_interPeriod_ctrl{i}=num_moyen_ep_SLEEP;
    perc_SLEEP_interPeriod_ctrl{i}=perc_moyen_SLEEP;
    
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_ctrl{i}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_3_end_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_3_end_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_3_end_ctrl{i}=num_moyen_ep_REM;
    perc_REM_3_end_ctrl{i}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}),'sleep',tempbin,time_mid,time_end);
    dur_SLEEP_3_end_ctrl{i}=dur_moyenne_ep_SLEEP;
    num_SLEEP_3_end_ctrl{i}=num_moyen_ep_SLEEP;
    perc_SLEEP_3_end_ctrl{i}=perc_moyen_SLEEP;
    
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
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(short_REMEpoch_ctrl_1{i},same_epoch_3_end_ctrl{i}),tempbin,time_mid,time_end);
    all_trans_REM_short_SWS_3_end_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_3_end_ctrl{i} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_3_end_ctrl{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(mid_REMEpoch_ctrl{i},same_epoch_3_end_ctrl{i}),tempbin,time_mid,time_end);
    all_trans_REM_mid_SWS_3_end_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_3_end_ctrl{i} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_3_end_ctrl{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_3_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_3_end_ctrl{i}),and(long_REMEpoch_ctrl{i},same_epoch_3_end_ctrl{i}),tempbin,time_mid,time_end);
    all_trans_REM_long_SWS_3_end_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_3_end_ctrl{i} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_3_end_ctrl{i} = trans_REM_to_REM;
    
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for i=1:length(dur_REM_ctrl)
    %%ALL SESSION
    data_dur_REM_ctrl(i,:) = dur_REM_ctrl{i}; data_dur_REM_ctrl(isnan(data_dur_REM_ctrl)==1)=0;
    data_dur_SWS_ctrl(i,:) = dur_SWS_ctrl{i}; data_dur_SWS_ctrl(isnan(data_dur_SWS_ctrl)==1)=0;
    data_dur_WAKE_ctrl(i,:) = dur_WAKE_ctrl{i}; data_dur_WAKE_ctrl(isnan(data_dur_WAKE_ctrl)==1)=0;
    data_dur_SLEEP_ctrl(i,:) = dur_SLEEP_ctrl{i}; data_dur_SLEEP_ctrl(isnan(data_dur_SLEEP_ctrl)==1)=0;
    
    data_num_REM_ctrl(i,:) = num_REM_ctrl{i};data_num_REM_ctrl(isnan(data_num_REM_ctrl)==1)=0;
    data_num_SWS_ctrl(i,:) = num_SWS_ctrl{i}; data_num_SWS_ctrl(isnan(data_num_SWS_ctrl)==1)=0;
    data_num_WAKE_ctrl(i,:) = num_WAKE_ctrl{i}; data_num_WAKE_ctrl(isnan(data_num_WAKE_ctrl)==1)=0;
    data_num_SLEEP_ctrl(i,:) = num_SLEEP_ctrl{i}; data_num_SLEEP_ctrl(isnan(data_num_SLEEP_ctrl)==1)=0;
    
    data_perc_REM_ctrl(i,:) = perc_REM_ctrl{i}; data_perc_REM_ctrl(isnan(data_perc_REM_ctrl)==1)=0;
    data_perc_SWS_ctrl(i,:) = perc_SWS_ctrl{i}; data_perc_SWS_ctrl(isnan(data_perc_SWS_ctrl)==1)=0;
    data_perc_WAKE_ctrl(i,:) = perc_WAKE_ctrl{i}; data_perc_WAKE_ctrl(isnan(data_perc_WAKE_ctrl)==1)=0;
    data_perc_SLEEP_ctrl(i,:) = perc_SLEEP_ctrl{i}; data_perc_SLEEP_ctrl(isnan(data_perc_SLEEP_ctrl)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_ctrl(i,:) = dur_REM_1_3h_ctrl{i}; data_dur_REM_1_3h_ctrl(isnan(data_dur_REM_1_3h_ctrl)==1)=0;
    data_dur_SWS_1_3h_ctrl(i,:) = dur_SWS_1_3h_ctrl{i}; data_dur_SWS_1_3h_ctrl(isnan(data_dur_SWS_1_3h_ctrl)==1)=0;
    data_dur_WAKE_1_3h_ctrl(i,:) = dur_WAKE_1_3h_ctrl{i}; data_dur_WAKE_1_3h_ctrl(isnan(data_dur_WAKE_1_3h_ctrl)==1)=0;
    data_dur_SLEEP_1_3h_ctrl(i,:) = dur_SLEEP_1_3h_ctrl{i}; data_dur_SLEEP_1_3h_ctrl(isnan(data_dur_SLEEP_1_3h_ctrl)==1)=0;
    
    
    data_num_REM_1_3h_ctrl(i,:) = num_REM_1_3h_ctrl{i};data_num_REM_1_3h_ctrl(isnan(data_num_REM_1_3h_ctrl)==1)=0;
    data_num_SWS_1_3h_ctrl(i,:) = num_SWS_1_3h_ctrl{i}; data_num_SWS_1_3h_ctrl(isnan(data_num_SWS_1_3h_ctrl)==1)=0;
    data_num_WAKE_1_3h_ctrl(i,:) = num_WAKE_1_3h_ctrl{i}; data_num_WAKE_1_3h_ctrl(isnan(data_num_WAKE_1_3h_ctrl)==1)=0;
    data_num_SLEEP_1_3h_ctrl(i,:) = num_SLEEP_1_3h_ctrl{i}; data_num_SLEEP_1_3h_ctrl(isnan(data_num_SLEEP_1_3h_ctrl)==1)=0;
    
    data_perc_REM_1_3h_ctrl(i,:) = perc_REM_1_3h_ctrl{i}; data_perc_REM_1_3h_ctrl(isnan(data_perc_REM_1_3h_ctrl)==1)=0;
    data_perc_SWS_1_3h_ctrl(i,:) = perc_SWS_1_3h_ctrl{i}; data_perc_SWS_1_3h_ctrl(isnan(data_perc_SWS_1_3h_ctrl)==1)=0;
    data_perc_WAKE_1_3h_ctrl(i,:) = perc_WAKE_1_3h_ctrl{i}; data_perc_WAKE_1_3h_ctrl(isnan(data_perc_WAKE_1_3h_ctrl)==1)=0;
    data_perc_SLEEP_1_3h_ctrl(i,:) = perc_SLEEP_1_3h_ctrl{i}; data_perc_SLEEP_1_3h_ctrl(isnan(data_perc_SLEEP_1_3h_ctrl)==1)=0;
    
    data_dur_REM_interPeriod_ctrl(i,:) = dur_REM_interPeriod_ctrl{i}; data_dur_REM_interPeriod_ctrl(isnan(data_dur_REM_interPeriod_ctrl)==1)=0;
    data_dur_SWS_interPeriod_ctrl(i,:) = dur_SWS_interPeriod_ctrl{i}; data_dur_SWS_interPeriod_ctrl(isnan(data_dur_SWS_interPeriod_ctrl)==1)=0;
    data_dur_WAKE_interPeriod_ctrl(i,:) = dur_WAKE_interPeriod_ctrl{i}; data_dur_WAKE_interPeriod_ctrl(isnan(data_dur_WAKE_interPeriod_ctrl)==1)=0;
    data_dur_SLEEP_interPeriod_ctrl(i,:) = dur_SLEEP_interPeriod_ctrl{i}; data_dur_SLEEP_interPeriod_ctrl(isnan(data_dur_SLEEP_interPeriod_ctrl)==1)=0;
    
    
    data_num_REM_interPeriod_ctrl(i,:) = num_REM_interPeriod_ctrl{i};data_num_REM_interPeriod_ctrl(isnan(data_num_REM_interPeriod_ctrl)==1)=0;
    data_num_SWS_interPeriod_ctrl(i,:) = num_SWS_interPeriod_ctrl{i}; data_num_SWS_interPeriod_ctrl(isnan(data_num_SWS_interPeriod_ctrl)==1)=0;
    data_num_WAKE_interPeriod_ctrl(i,:) = num_WAKE_interPeriod_ctrl{i}; data_num_WAKE_interPeriod_ctrl(isnan(data_num_WAKE_interPeriod_ctrl)==1)=0;
    data_num_SLEEP_interPeriod_ctrl(i,:) = num_SLEEP_interPeriod_ctrl{i}; data_num_SLEEP_interPeriod_ctrl(isnan(data_num_SLEEP_interPeriod_ctrl)==1)=0;
    
    data_perc_REM_interPeriod_ctrl(i,:) = perc_REM_interPeriod_ctrl{i}; data_perc_REM_interPeriod_ctrl(isnan(data_perc_REM_interPeriod_ctrl)==1)=0;
    data_perc_SWS_interPeriod_ctrl(i,:) = perc_SWS_interPeriod_ctrl{i}; data_perc_SWS_interPeriod_ctrl(isnan(data_perc_SWS_interPeriod_ctrl)==1)=0;
    data_perc_WAKE_interPeriod_ctrl(i,:) = perc_WAKE_interPeriod_ctrl{i}; data_perc_WAKE_interPeriod_ctrl(isnan(data_perc_WAKE_interPeriod_ctrl)==1)=0;
    data_perc_SLEEP_interPeriod_ctrl(i,:) = perc_SLEEP_interPeriod_ctrl{i}; data_perc_SLEEP_interPeriod_ctrl(isnan(data_perc_SLEEP_interPeriod_ctrl)==1)=0;
    
    
    %%FIN DE LA SESSION
    data_dur_REM_3_end_ctrl(i,:) = dur_REM_3_end_ctrl{i}; data_dur_REM_3_end_ctrl(isnan(data_dur_REM_3_end_ctrl)==1)=0;
    data_dur_SWS_3_end_ctrl(i,:) = dur_SWS_3_end_ctrl{i}; data_dur_SWS_3_end_ctrl(isnan(data_dur_SWS_3_end_ctrl)==1)=0;
    data_dur_WAKE_3_end_ctrl(i,:) = dur_WAKE_3_end_ctrl{i}; data_dur_WAKE_3_end_ctrl(isnan(data_dur_WAKE_3_end_ctrl)==1)=0;
    data_dur_SLEEP_3_end_ctrl(i,:) = dur_SLEEP_3_end_ctrl{i}; data_dur_SLEEP_3_end_ctrl(isnan(data_dur_SLEEP_3_end_ctrl)==1)=0;
    
    
    data_num_REM_3_end_ctrl(i,:) = num_REM_3_end_ctrl{i};data_num_REM_3_end_ctrl(isnan(data_num_REM_3_end_ctrl)==1)=0;
    data_num_SWS_3_end_ctrl(i,:) = num_SWS_3_end_ctrl{i}; data_num_SWS_3_end_ctrl(isnan(data_num_SWS_3_end_ctrl)==1)=0;
    data_num_WAKE_3_end_ctrl(i,:) = num_WAKE_3_end_ctrl{i}; data_num_WAKE_3_end_ctrl(isnan(data_num_WAKE_3_end_ctrl)==1)=0;
    data_num_SLEEP_3_end_ctrl(i,:) = num_SLEEP_3_end_ctrl{i}; data_num_SLEEP_3_end_ctrl(isnan(data_num_SLEEP_3_end_ctrl)==1)=0;
    
    
    data_perc_REM_3_end_ctrl(i,:) = perc_REM_3_end_ctrl{i}; data_perc_REM_3_end_ctrl(isnan(data_perc_REM_3_end_ctrl)==1)=0;
    data_perc_SWS_3_end_ctrl(i,:) = perc_SWS_3_end_ctrl{i}; data_perc_SWS_3_end_ctrl(isnan(data_perc_SWS_3_end_ctrl)==1)=0;
    data_perc_WAKE_3_end_ctrl(i,:) = perc_WAKE_3_end_ctrl{i}; data_perc_WAKE_3_end_ctrl(isnan(data_perc_WAKE_3_end_ctrl)==1)=0;
    data_perc_SLEEP_3_end_ctrl(i,:) = perc_SLEEP_3_end_ctrl{i}; data_perc_SLEEP_3_end_ctrl(isnan(data_perc_SLEEP_3_end_ctrl)==1)=0;
    
end
%% probability
for i=1:length(all_trans_REM_short_WAKE_3_end_ctrl)
%     %%ALL SESSION
%     data_REM_REM_ctrl(i,:) = all_trans_REM_REM_ctrl{i}; data_REM_REM_ctrl(isnan(data_REM_REM_ctrl)==1)=0;
%     data_REM_SWS_ctrl(i,:) = all_trans_REM_SWS_ctrl{i}; data_REM_SWS_ctrl(isnan(data_REM_SWS_ctrl)==1)=0;
%     data_REM_WAKE_ctrl(i,:) = all_trans_REM_WAKE_ctrl{i}; data_REM_WAKE_ctrl(isnan(data_REM_WAKE_ctrl)==1)=0;
%
%     data_SWS_SWS_ctrl(i,:) = all_trans_SWS_SWS_ctrl{i}; data_SWS_SWS_ctrl(isnan(data_SWS_SWS_ctrl)==1)=0;
%     data_SWS_REM_ctrl(i,:) = all_trans_SWS_REM_ctrl{i}; data_SWS_REM_ctrl(isnan(data_SWS_REM_ctrl)==1)=0;
%     data_SWS_WAKE_ctrl(i,:) = all_trans_SWS_WAKE_ctrl{i}; data_SWS_WAKE_ctrl(isnan(data_SWS_WAKE_ctrl)==1)=0;
%
%     data_WAKE_WAKE_ctrl(i,:) = all_trans_WAKE_WAKE_ctrl{i}; data_WAKE_WAKE_ctrl(isnan(data_WAKE_WAKE_ctrl)==1)=0;
%     data_WAKE_REM_ctrl(i,:) = all_trans_WAKE_REM_ctrl{i}; data_WAKE_REM_ctrl(isnan(data_WAKE_REM_ctrl)==1)=0;
%     data_WAKE_SWS_ctrl(i,:) = all_trans_WAKE_SWS_ctrl{i}; data_WAKE_SWS_ctrl(isnan(data_WAKE_SWS_ctrl)==1)=0;
%
%     %%3 PREMI7RES HEURES
%         data_REM_REM_1_3h_ctrl(i,:) = all_trans_REM_REM_1_3h_ctrl{i}; data_REM_REM_1_3h_ctrl(isnan(data_REM_REM_1_3h_ctrl)==1)=0;
%     data_REM_SWS_1_3h_ctrl(i,:) = all_trans_REM_SWS_1_3h_ctrl{i}; data_REM_SWS_1_3h_ctrl(isnan(data_REM_SWS_1_3h_ctrl)==1)=0;
%     data_REM_WAKE_1_3h_ctrl(i,:) = all_trans_REM_WAKE_1_3h_ctrl{i}; data_REM_WAKE_1_3h_ctrl(isnan(data_REM_WAKE_1_3h_ctrl)==1)=0;
%
%     data_SWS_SWS_1_3h_ctrl(i,:) = all_trans_SWS_SWS_1_3h_ctrl{i}; data_SWS_SWS_1_3h_ctrl(isnan(data_SWS_SWS_1_3h_ctrl)==1)=0;
%     data_SWS_REM_1_3h_ctrl(i,:) = all_trans_SWS_REM_1_3h_ctrl{i}; data_SWS_REM_1_3h_ctrl(isnan(data_SWS_REM_1_3h_ctrl)==1)=0;
%     data_SWS_WAKE_1_3h_ctrl(i,:) = all_trans_SWS_WAKE_1_3h_ctrl{i}; data_SWS_WAKE_1_3h_ctrl(isnan(data_SWS_WAKE_1_3h_ctrl)==1)=0;
%
%     data_WAKE_WAKE_1_3h_ctrl(i,:) = all_trans_WAKE_WAKE_1_3h_ctrl{i}; data_WAKE_WAKE_1_3h_ctrl(isnan(data_WAKE_WAKE_1_3h_ctrl)==1)=0;
%     data_WAKE_REM_1_3h_ctrl(i,:) = all_trans_WAKE_REM_1_3h_ctrl{i}; data_WAKE_REM_1_3h_ctrl(isnan(data_WAKE_REM_1_3h_ctrl)==1)=0;
%     data_WAKE_SWS_1_3h_ctrl(i,:) = all_trans_WAKE_SWS_1_3h_ctrl{i}; data_WAKE_SWS_1_3h_ctrl(isnan(data_WAKE_SWS_1_3h_ctrl)==1)=0;
%
%     %%FIN DE LA SESSION
%         data_REM_REM_3_end_ctrl(i,:) = all_trans_REM_REM_3_end_ctrl{i}; data_REM_REM_3_end_ctrl(isnan(data_REM_REM_3_end_ctrl)==1)=0;
%     data_REM_SWS_3_end_ctrl(i,:) = all_trans_REM_SWS_3_end_ctrl{i}; data_REM_SWS_3_end_ctrl(isnan(data_REM_SWS_3_end_ctrl)==1)=0;
%     data_REM_WAKE_3_end_ctrl(i,:) = all_trans_REM_WAKE_3_end_ctrl{i}; data_REM_WAKE_3_end_ctrl(isnan(data_REM_WAKE_3_end_ctrl)==1)=0;
%
%     data_SWS_SWS_3_end_ctrl(i,:) = all_trans_SWS_SWS_3_end_ctrl{i}; data_SWS_SWS_3_end_ctrl(isnan(data_SWS_SWS_3_end_ctrl)==1)=0;
%     data_SWS_REM_3_end_ctrl(i,:) = all_trans_SWS_REM_3_end_ctrl{i}; data_SWS_REM_3_end_ctrl(isnan(data_SWS_REM_3_end_ctrl)==1)=0;
%     data_SWS_WAKE_3_end_ctrl(i,:) = all_trans_SWS_WAKE_3_end_ctrl{i}; data_SWS_WAKE_3_end_ctrl(isnan(data_SWS_WAKE_3_end_ctrl)==1)=0;
%
%     data_WAKE_WAKE_3_end_ctrl(i,:) = all_trans_WAKE_WAKE_3_end_ctrl{i}; data_WAKE_WAKE_3_end_ctrl(isnan(data_WAKE_WAKE_3_end_ctrl)==1)=0;
%     data_WAKE_REM_3_end_ctrl(i,:) = all_trans_WAKE_REM_3_end_ctrl{i}; data_WAKE_REM_3_end_ctrl(isnan(data_WAKE_REM_3_end_ctrl)==1)=0;
%     data_WAKE_SWS_3_end_ctrl(i,:) = all_trans_WAKE_SWS_3_end_ctrl{i}; data_WAKE_SWS_3_end_ctrl(isnan(data_WAKE_SWS_3_end_ctrl)==1)=0;
%
%
%
    data_REM_short_WAKE_3_end_ctrl(i,:) = all_trans_REM_short_WAKE_3_end_ctrl{i}; %data_REM_short_WAKE_3_end_ctrl(isnan(data_REM_short_WAKE_3_end_ctrl)==1)=0;
    data_REM_short_SWS_3_end_ctrl(i,:) = all_trans_REM_short_SWS_3_end_ctrl{i};% data_REM_short_SWS_3_end_ctrl(isnan(data_REM_short_SWS_3_end_ctrl)==1)=0;
    data_REM_short_REM_3_end_ctrl(i,:) = all_trans_REM_short_REM_3_end_ctrl{i}; %data_REM_short_WAKE_3_end_ctrl(isnan(data_REM_short_WAKE_3_end_ctrl)==1)=0;

    data_REM_mid_WAKE_3_end_ctrl(i,:) = all_trans_REM_mid_WAKE_3_end_ctrl{i}; %data_REM_mid_WAKE_3_end_ctrl(isnan(data_REM_mid_WAKE_3_end_ctrl)==1)=0;
    data_REM_mid_SWS_3_end_ctrl(i,:) = all_trans_REM_mid_SWS_3_end_ctrl{i}; %data_REM_mid_SWS_3_end_ctrl(isnan(data_REM_mid_SWS_3_end_ctrl)==1)=0;
    data_REM_mid_REM_3_end_ctrl(i,:) = all_trans_REM_mid_REM_3_end_ctrl{i}; %data_REM_mid_WAKE_3_end_ctrl(isnan(data_REM_short_WAKE_3_end_ctrl)==1)=0;

    data_REM_long_WAKE_3_end_ctrl(i,:) = all_trans_REM_long_WAKE_3_end_ctrl{i}; %data_REM_long_WAKE_3_end_ctrl(isnan(data_REM_long_WAKE_3_end_ctrl)==1)=0;
    data_REM_long_SWS_3_end_ctrl(i,:) = all_trans_REM_long_SWS_3_end_ctrl{i}; %data_REM_long_SWS_3_end_ctrl(isnan(data_REM_long_SWS_3_end_ctrl)==1)=0;
    data_REM_long_REM_3_end_ctrl(i,:) = all_trans_REM_long_REM_3_end_ctrl{i}; %data_REM_long_WAKE_3_end_ctrl(isnan(data_REM_short_WAKE_3_end_ctrl)==1)=0;

end



%% GET DATA - SD mCherry saline
for k=1:length(DirSocialDefeat_sleepPost_classic.path)
    cd(DirSocialDefeat_sleepPost_classic.path{k}{1});
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
    same_epoch_interPeriod_SD{k} = intervalSet(time_mid_1,time_mid);
    
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
    
    
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'sleep',tempbin,time_st,time_end);
    dur_SLEEP_SD{k}=dur_moyenne_ep_SLEEP;
    num_SLEEP_SD{k}=num_moyen_ep_SLEEP;
    perc_SLEEP_SD{k}=perc_moyen_SLEEP;
    
    
    
    %     %%Compute transition probabilities - overtime
    %     [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
    %         Get_proba_timebins_Overtime_MC_VF(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),tempbin,time_end);
    %     all_trans_REM_REM_SD{k} = trans_REM_to_REM;
    %     all_trans_REM_SWS_SD{k} = trans_REM_to_SWS;
    %     all_trans_REM_WAKE_SD{k} = trans_REM_to_WAKE;
    %
    %     all_trans_SWS_REM_SD{k} = trans_SWS_to_REM;
    %     all_trans_SWS_SWS_SD{k} = trans_SWS_to_SWS;
    %     all_trans_SWS_WAKE_SD{k} = trans_SWS_to_WAKE;
    %
    %     all_trans_WAKE_REM_SD{k} = trans_WAKE_to_REM;
    %     all_trans_WAKE_SWS_SD{k} = trans_WAKE_to_SWS;
    %     all_trans_WAKE_WAKE_SD{k} = trans_WAKE_to_WAKE;
    
    
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
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_1_3h_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_1_3h_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_1_3h_SD{k}),'sleep',tempbin,time_st,time_mid);
    dur_SLEEP_1_3h_SD{k}=dur_moyenne_ep_SLEEP;
    num_SLEEP_1_3h_SD{k}=num_moyen_ep_SLEEP;
    perc_SLEEP_1_3h_SD{k}=perc_moyen_SLEEP;
    
    
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
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_interPeriod_SD{k}),'wake',tempbin,time_mid_1,time_mid);
    dur_WAKE_interPeriod_SD{k}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD{k}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_interPeriod_SD{k}),'sws',tempbin,time_mid_1,time_mid);
    dur_SWS_interPeriod_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD{k}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_interPeriod_SD{k}),'rem',tempbin,time_mid_1,time_mid);
    dur_REM_interPeriod_SD{k}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD{k}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_interPeriod_SD{k}),'sleep',tempbin,time_mid_1,time_mid);
    dur_SLEEP_interPeriod_SD{k}=dur_moyenne_ep_SLEEP;
    num_SLEEP_interPeriod_SD{k}=num_moyen_ep_SLEEP;
    perc_SLEEP_interPeriod_SD{k}=perc_moyen_SLEEP;
    
    
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
    
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_3_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_3_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}),'sleep',tempbin,time_mid,time_end);
    dur_SLEEP_3_end_SD{k}=dur_moyenne_ep_SLEEP;
    num_SLEEP_3_end_SD{k}=num_moyen_ep_SLEEP;
    perc_SLEEP_3_end_SD{k}=perc_moyen_SLEEP;
    
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
    
    idx_short_rem_SD_1{k} = find(dur_REM_SD_bis{k}<lim_short_1); %short bouts < 10s
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
    
    idx_long_rem_SD{k} = find(dur_REM_SD_bis{k}>lim_long); %long bout
    long_REMEpoch_SD{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_long_rem_SD{k});
    [dur_rem_long_SD{k}, durT_rem_long_SD(k)] = DurationEpoch(long_REMEpoch_SD{k},'s');
    perc_rem_long_SD(k) = durT_rem_long_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_long_SD(k) = nanmean(dur_rem_long_SD{k});
    num_moyen_rem_long_SD(k) = length(dur_rem_long_SD{k});
    
    idx_mid_rem_SD{k} = find(dur_REM_SD_bis{k}>lim_short_1 & dur_REM_SD_bis{k}<lim_long); % middle bouts
    mid_REMEpoch_SD{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_mid_rem_SD{k});
    [dur_rem_mid_SD{k}, durT_rem_mid_SD(k)] = DurationEpoch(mid_REMEpoch_SD{k},'s');
    perc_rem_mid_SD(k) = durT_rem_mid_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_mid_SD(k) = nanmean(dur_rem_mid_SD{k});
    num_moyen_rem_mid_SD(k) = length(dur_rem_mid_SD{k});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_3_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_3_end_SD{k}),and(short_REMEpoch_SD_1{k},same_epoch_3_end_SD{k}),tempbin,time_mid,time_end);
    all_trans_REM_short_SWS_3_end_SD{k} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_3_end_SD{k} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_3_end_SD{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_3_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_3_end_SD{k}),and(mid_REMEpoch_SD{k},same_epoch_3_end_SD{k}),tempbin,time_mid,time_end);
    all_trans_REM_mid_SWS_3_end_SD{k} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_3_end_SD{k} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_3_end_SD{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_3_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_3_end_SD{k}),and(long_REMEpoch_SD{k},same_epoch_3_end_SD{k}),tempbin,time_mid,time_end);
    all_trans_REM_long_SWS_3_end_SD{k} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_3_end_SD{k} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_3_end_SD{k} = trans_REM_to_REM;
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for k=1:length(dur_REM_SD)
    %%ALL SESSION
    data_dur_REM_SD(k,:) = dur_REM_SD{k}; data_dur_REM_SD(isnan(data_dur_REM_SD)==1)=0;
    data_dur_SWS_SD(k,:) = dur_SWS_SD{k}; data_dur_SWS_SD(isnan(data_dur_SWS_SD)==1)=0;
    data_dur_WAKE_SD(k,:) = dur_WAKE_SD{k}; data_dur_WAKE_SD(isnan(data_dur_WAKE_SD)==1)=0;
    data_dur_SLEEP_SD(k,:) = dur_SLEEP_SD{k}; data_dur_SLEEP_SD(isnan(data_dur_SLEEP_SD)==1)=0;
    
    data_num_REM_SD(k,:) = num_REM_SD{k};data_num_REM_SD(isnan(data_num_REM_SD)==1)=0;
    data_num_SWS_SD(k,:) = num_SWS_SD{k}; data_num_SWS_SD(isnan(data_num_SWS_SD)==1)=0;
    data_num_WAKE_SD(k,:) = num_WAKE_SD{k}; data_num_WAKE_SD(isnan(data_num_WAKE_SD)==1)=0;
    data_num_SLEEP_SD(k,:) = num_SLEEP_SD{k}; data_num_SLEEP_SD(isnan(data_num_SLEEP_SD)==1)=0;
    
    data_perc_REM_SD(k,:) = perc_REM_SD{k}; data_perc_REM_SD(isnan(data_perc_REM_SD)==1)=0;
    data_perc_SWS_SD(k,:) = perc_SWS_SD{k}; data_perc_SWS_SD(isnan(data_perc_SWS_SD)==1)=0;
    data_perc_WAKE_SD(k,:) = perc_WAKE_SD{k}; data_perc_WAKE_SD(isnan(data_perc_WAKE_SD)==1)=0;
    data_perc_SLEEP_SD(k,:) = perc_SLEEP_SD{k}; data_perc_SLEEP_SD(isnan(data_perc_SLEEP_SD)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_SD(k,:) = dur_REM_1_3h_SD{k}; data_dur_REM_1_3h_SD(isnan(data_dur_REM_1_3h_SD)==1)=0;
    data_dur_SWS_1_3h_SD(k,:) = dur_SWS_1_3h_SD{k}; data_dur_SWS_1_3h_SD(isnan(data_dur_SWS_1_3h_SD)==1)=0;
    data_dur_WAKE_1_3h_SD(k,:) = dur_WAKE_1_3h_SD{k}; data_dur_WAKE_1_3h_SD(isnan(data_dur_WAKE_1_3h_SD)==1)=0;
    data_dur_SLEEP_1_3h_SD(k,:) = dur_SLEEP_1_3h_SD{k}; data_dur_SLEEP_1_3h_SD(isnan(data_dur_SLEEP_1_3h_SD)==1)=0;
    
    
    data_num_REM_1_3h_SD(k,:) = num_REM_1_3h_SD{k};data_num_REM_1_3h_SD(isnan(data_num_REM_1_3h_SD)==1)=0;
    data_num_SWS_1_3h_SD(k,:) = num_SWS_1_3h_SD{k}; data_num_SWS_1_3h_SD(isnan(data_num_SWS_1_3h_SD)==1)=0;
    data_num_WAKE_1_3h_SD(k,:) = num_WAKE_1_3h_SD{k}; data_num_WAKE_1_3h_SD(isnan(data_num_WAKE_1_3h_SD)==1)=0;
    data_num_SLEEP_1_3h_SD(k,:) = num_SLEEP_1_3h_SD{k}; data_num_SLEEP_1_3h_SD(isnan(data_num_SLEEP_1_3h_SD)==1)=0;
    
    data_perc_REM_1_3h_SD(k,:) = perc_REM_1_3h_SD{k}; data_perc_REM_1_3h_SD(isnan(data_perc_REM_1_3h_SD)==1)=0;
    data_perc_SWS_1_3h_SD(k,:) = perc_SWS_1_3h_SD{k}; data_perc_SWS_1_3h_SD(isnan(data_perc_SWS_1_3h_SD)==1)=0;
    data_perc_WAKE_1_3h_SD(k,:) = perc_WAKE_1_3h_SD{k}; data_perc_WAKE_1_3h_SD(isnan(data_perc_WAKE_1_3h_SD)==1)=0;
    data_perc_SLEEP_1_3h_SD(k,:) = perc_SLEEP_1_3h_SD{k}; data_perc_SLEEP_1_3h_SD(isnan(data_perc_SLEEP_1_3h_SD)==1)=0;
    
    data_dur_REM_interPeriod_SD(k,:) = dur_REM_interPeriod_SD{k}; data_dur_REM_interPeriod_SD(isnan(data_dur_REM_interPeriod_SD)==1)=0;
    data_dur_SWS_interPeriod_SD(k,:) = dur_SWS_interPeriod_SD{k}; data_dur_SWS_interPeriod_SD(isnan(data_dur_SWS_interPeriod_SD)==1)=0;
    data_dur_WAKE_interPeriod_SD(k,:) = dur_WAKE_interPeriod_SD{k}; data_dur_WAKE_interPeriod_SD(isnan(data_dur_WAKE_interPeriod_SD)==1)=0;
    data_dur_SLEEP_interPeriod_SD(k,:) = dur_SLEEP_interPeriod_SD{k}; data_dur_SLEEP_interPeriod_SD(isnan(data_dur_SLEEP_interPeriod_SD)==1)=0;
    
    
    data_num_REM_interPeriod_SD(k,:) = num_REM_interPeriod_SD{k};data_num_REM_interPeriod_SD(isnan(data_num_REM_interPeriod_SD)==1)=0;
    data_num_SWS_interPeriod_SD(k,:) = num_SWS_interPeriod_SD{k}; data_num_SWS_interPeriod_SD(isnan(data_num_SWS_interPeriod_SD)==1)=0;
    data_num_WAKE_interPeriod_SD(k,:) = num_WAKE_interPeriod_SD{k}; data_num_WAKE_interPeriod_SD(isnan(data_num_WAKE_interPeriod_SD)==1)=0;
    data_num_SLEEP_interPeriod_SD(k,:) = num_SLEEP_interPeriod_SD{k}; data_num_SLEEP_interPeriod_SD(isnan(data_num_SLEEP_interPeriod_SD)==1)=0;
    
    data_perc_REM_interPeriod_SD(k,:) = perc_REM_interPeriod_SD{k}; data_perc_REM_interPeriod_SD(isnan(data_perc_REM_interPeriod_SD)==1)=0;
    data_perc_SWS_interPeriod_SD(k,:) = perc_SWS_interPeriod_SD{k}; data_perc_SWS_interPeriod_SD(isnan(data_perc_SWS_interPeriod_SD)==1)=0;
    data_perc_WAKE_interPeriod_SD(k,:) = perc_WAKE_interPeriod_SD{k}; data_perc_WAKE_interPeriod_SD(isnan(data_perc_WAKE_interPeriod_SD)==1)=0;
    data_perc_SLEEP_interPeriod_SD(k,:) = perc_SLEEP_interPeriod_SD{k}; data_perc_SLEEP_interPeriod_SD(isnan(data_perc_SLEEP_interPeriod_SD)==1)=0;
    
    %%FIN DE LA SESSION
    data_dur_REM_3_end_SD(k,:) = dur_REM_3_end_SD{k}; data_dur_REM_3_end_SD(isnan(data_dur_REM_3_end_SD)==1)=0;
    data_dur_SWS_3_end_SD(k,:) = dur_SWS_3_end_SD{k}; data_dur_SWS_3_end_SD(isnan(data_dur_SWS_3_end_SD)==1)=0;
    data_dur_WAKE_3_end_SD(k,:) = dur_WAKE_3_end_SD{k}; data_dur_WAKE_3_end_SD(isnan(data_dur_WAKE_3_end_SD)==1)=0;
    data_dur_SLEEP_3_end_SD(k,:) = dur_SLEEP_3_end_SD{k}; data_dur_SLEEP_3_end_SD(isnan(data_dur_SLEEP_3_end_SD)==1)=0;
    
    
    data_num_REM_3_end_SD(k,:) = num_REM_3_end_SD{k};data_num_REM_3_end_SD(isnan(data_num_REM_3_end_SD)==1)=0;
    data_num_SWS_3_end_SD(k,:) = num_SWS_3_end_SD{k}; data_num_SWS_3_end_SD(isnan(data_num_SWS_3_end_SD)==1)=0;
    data_num_WAKE_3_end_SD(k,:) = num_WAKE_3_end_SD{k}; data_num_WAKE_3_end_SD(isnan(data_num_WAKE_3_end_SD)==1)=0;
    data_num_SLEEP_3_end_SD(k,:) = num_SLEEP_3_end_SD{k}; data_num_SLEEP_3_end_SD(isnan(data_num_SLEEP_3_end_SD)==1)=0;
    
    
    data_perc_REM_3_end_SD(k,:) = perc_REM_3_end_SD{k}; data_perc_REM_3_end_SD(isnan(data_perc_REM_3_end_SD)==1)=0;
    data_perc_SWS_3_end_SD(k,:) = perc_SWS_3_end_SD{k}; data_perc_SWS_3_end_SD(isnan(data_perc_SWS_3_end_SD)==1)=0;
    data_perc_WAKE_3_end_SD(k,:) = perc_WAKE_3_end_SD{k}; data_perc_WAKE_3_end_SD(isnan(data_perc_WAKE_3_end_SD)==1)=0;
    data_perc_SLEEP_3_end_SD(k,:) = perc_SLEEP_3_end_SD{k}; data_perc_SLEEP_3_end_SD(isnan(data_perc_SLEEP_3_end_SD)==1)=0;
    
end
%%
%probability
for k=1:length(all_trans_REM_short_WAKE_3_end_SD)
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
    data_REM_short_WAKE_3_end_SD(k,:) = all_trans_REM_short_WAKE_3_end_SD{k}; data_REM_short_WAKE_3_end_SD(isnan(data_REM_short_WAKE_3_end_SD)==1)=0;
    data_REM_short_SWS_3_end_SD(k,:) = all_trans_REM_short_SWS_3_end_SD{k}; data_REM_short_SWS_3_end_SD(isnan(data_REM_short_SWS_3_end_SD)==1)=0;
    
    data_REM_mid_WAKE_3_end_SD(k,:) = all_trans_REM_mid_WAKE_3_end_SD{k}; data_REM_mid_WAKE_3_end_SD(isnan(data_REM_mid_WAKE_3_end_SD)==1)=0;
    data_REM_mid_SWS_3_end_SD(k,:) = all_trans_REM_mid_SWS_3_end_SD{k}; data_REM_mid_SWS_3_end_SD(isnan(data_REM_mid_SWS_3_end_SD)==1)=0;
    
    data_REM_long_WAKE_3_end_SD(k,:) = all_trans_REM_long_WAKE_3_end_SD{k}; data_REM_long_WAKE_3_end_SD(isnan(data_REM_long_WAKE_3_end_SD)==1)=0;
    data_REM_long_SWS_3_end_SD(k,:) = all_trans_REM_long_SWS_3_end_SD{k}; data_REM_long_SWS_3_end_SD(isnan(data_REM_long_SWS_3_end_SD)==1)=0;
    
    data_REM_short_REM_3_end_SD(k,:) = all_trans_REM_short_REM_3_end_SD{k}; %data_REM_short_REM_3_end_SD(isnan(data_REM_short_REM_3_end_SD)==1)=0;
    data_REM_mid_REM_3_end_SD(k,:) = all_trans_REM_mid_REM_3_end_SD{k}; %data_REM_mid_REM_3_end_SD(isnan(data_REM_mid_REM_3_end_SD)==1)=0;
    data_REM_long_REM_3_end_SD(k,:) = all_trans_REM_long_REM_3_end_SD{k}; %data_REM_long_REM_3_end_SD(isnan(data_REM_long_REM_3_end_SD)==1)=0;
    
end





%% GET DATA - SD dreadd cno
for j=1:length(DirSocialDefeat_sleepPost_mCherry_cno.path)
    cd(DirSocialDefeat_sleepPost_mCherry_cno.path{j}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_mCherry_cno{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_mCherry_cno{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_SD_mCherry_cno{j} = intervalSet(0,time_end);
    same_epoch_1_3h_SD_mCherry_cno{j} = intervalSet(time_st,time_mid);
    same_epoch_3_end_SD_mCherry_cno{j} = intervalSet(time_mid,time_end);
    same_epoch_interPeriod_SD_mCherry_cno{j} = intervalSet(time_mid_1,time_mid);
    
    
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
    
    
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_SD_mCherry_cno{j}),'sleep',tempbin,time_st,time_end);
    dur_SLEEP_SD_mCherry_cno{j}=dur_moyenne_ep_SLEEP;
    num_SLEEP_SD_mCherry_cno{j}=num_moyen_ep_SLEEP;
    perc_SLEEP_SD_mCherry_cno{j}=perc_moyen_SLEEP;
    
    
    
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
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_1_3h_SD_mCherry_cno{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_1_3h_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_1_3h_SD_mCherry_cno{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{j}),'sleep',tempbin,time_st,time_mid);
    dur_SLEEP_1_3h_SD_mCherry_cno{j}=dur_moyenne_ep_SLEEP;
    num_SLEEP_1_3h_SD_mCherry_cno{j}=num_moyen_ep_SLEEP;
    perc_SLEEP_1_3h_SD_mCherry_cno{j}=perc_moyen_SLEEP;
    
    
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
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),'wake',tempbin,time_mid_1,time_mid);
    dur_WAKE_interPeriod_SD_mCherry_cno{j}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD_mCherry_cno{j}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD_mCherry_cno{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),'sws',tempbin,time_mid_1,time_mid);
    dur_SWS_interPeriod_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD_mCherry_cno{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),'rem',tempbin,time_mid_1,time_mid);
    dur_REM_interPeriod_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD_mCherry_cno{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),'sleep',tempbin,time_mid_1,time_mid);
    dur_SLEEP_interPeriod_SD_mCherry_cno{j}=dur_moyenne_ep_SLEEP;
    num_SLEEP_interPeriod_SD_mCherry_cno{j}=num_moyen_ep_SLEEP;
    perc_SLEEP_interPeriod_SD_mCherry_cno{j}=perc_moyen_SLEEP;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_SD_mCherry_cno{j}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_SD_mCherry_cno{j}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_SD_mCherry_cno{j}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_3_end_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_3_end_SD_mCherry_cno{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_3_end_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_3_end_SD_mCherry_cno{j}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}),'sleep',tempbin,time_mid,time_end);
    dur_SLEEP_3_end_SD_mCherry_cno{j}=dur_moyenne_ep_SLEEP;
    num_SLEEP_3_end_SD_mCherry_cno{j}=num_moyen_ep_SLEEP;
    perc_SLEEP_3_end_SD_mCherry_cno{j}=perc_moyen_SLEEP;
    
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
    
    idx_short_rem_SD_mCherry_cno_1{j} = find(dur_REM_SD_mCherry_cno_bis{j}<lim_short_1); %short bouts < 10s
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
    
    idx_long_rem_SD_mCherry_cno{j} = find(dur_REM_SD_mCherry_cno_bis{j}>lim_long); %long bout
    long_REMEpoch_SD_mCherry_cno{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}), idx_long_rem_SD_mCherry_cno{j});
    [dur_rem_long_SD_mCherry_cno{j}, durT_rem_long_SD_mCherry_cno(j)] = DurationEpoch(long_REMEpoch_SD_mCherry_cno{j},'s');
    perc_rem_long_SD_mCherry_cno(j) = durT_rem_long_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_long_SD_mCherry_cno(j) = nanmean(dur_rem_long_SD_mCherry_cno{j});
    num_moyen_rem_long_SD_mCherry_cno(j) = length(dur_rem_long_SD_mCherry_cno{j});
    
    idx_mid_rem_SD_mCherry_cno{j} = find(dur_REM_SD_mCherry_cno_bis{j}>lim_short_1 & dur_REM_SD_mCherry_cno_bis{j}<lim_long); % middle bouts
    mid_REMEpoch_SD_mCherry_cno{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{j}), idx_mid_rem_SD_mCherry_cno{j});
    [dur_rem_mid_SD_mCherry_cno{j}, durT_rem_mid_SD_mCherry_cno(j)] = DurationEpoch(mid_REMEpoch_SD_mCherry_cno{j},'s');
    perc_rem_mid_SD_mCherry_cno(j) = durT_rem_mid_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_mid_SD_mCherry_cno(j) = nanmean(dur_rem_mid_SD_mCherry_cno{j});
    num_moyen_rem_mid_SD_mCherry_cno(j) = length(dur_rem_mid_SD_mCherry_cno{j});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(short_REMEpoch_SD_mCherry_cno_1{j},same_epoch_3_end_SD_mCherry_cno{j}),tempbin,time_mid,time_end);
    all_trans_REM_short_SWS_3_end_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_3_end_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_3_end_SD_mCherry_cno{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(mid_REMEpoch_SD_mCherry_cno{j},same_epoch_3_end_SD_mCherry_cno{j}),tempbin,time_mid,time_end);
    all_trans_REM_mid_SWS_3_end_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_3_end_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_3_end_SD_mCherry_cno{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_3_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{j}),and(long_REMEpoch_SD_mCherry_cno{j},same_epoch_3_end_SD_mCherry_cno{j}),tempbin,time_mid,time_end);
    all_trans_REM_long_SWS_3_end_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_3_end_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_3_end_SD_mCherry_cno{j} = trans_REM_to_REM;
    
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for j=1:length(dur_REM_SD_mCherry_cno)
    %%ALL SESSION
    data_dur_REM_SD_mCherry_cno(j,:) = dur_REM_SD_mCherry_cno{j}; data_dur_REM_SD_mCherry_cno(isnan(data_dur_REM_SD_mCherry_cno)==1)=0;
    data_dur_SWS_SD_mCherry_cno(j,:) = dur_SWS_SD_mCherry_cno{j}; data_dur_SWS_SD_mCherry_cno(isnan(data_dur_SWS_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_SD_mCherry_cno(j,:) = dur_WAKE_SD_mCherry_cno{j}; data_dur_WAKE_SD_mCherry_cno(isnan(data_dur_WAKE_SD_mCherry_cno)==1)=0;
    data_dur_SLEEP_SD_mCherry_cno(j,:) = dur_SLEEP_SD_mCherry_cno{j}; data_dur_SLEEP_SD_mCherry_cno(isnan(data_dur_SLEEP_SD_mCherry_cno)==1)=0;
    
    data_num_REM_SD_mCherry_cno(j,:) = num_REM_SD_mCherry_cno{j};data_num_REM_SD_mCherry_cno(isnan(data_num_REM_SD_mCherry_cno)==1)=0;
    data_num_SWS_SD_mCherry_cno(j,:) = num_SWS_SD_mCherry_cno{j}; data_num_SWS_SD_mCherry_cno(isnan(data_num_SWS_SD_mCherry_cno)==1)=0;
    data_num_WAKE_SD_mCherry_cno(j,:) = num_WAKE_SD_mCherry_cno{j}; data_num_WAKE_SD_mCherry_cno(isnan(data_num_WAKE_SD_mCherry_cno)==1)=0;
    data_num_SLEEP_SD_mCherry_cno(j,:) = num_SLEEP_SD_mCherry_cno{j}; data_num_SLEEP_SD_mCherry_cno(isnan(data_num_SLEEP_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_SD_mCherry_cno(j,:) = perc_REM_SD_mCherry_cno{j}; data_perc_REM_SD_mCherry_cno(isnan(data_perc_REM_SD_mCherry_cno)==1)=0;
    data_perc_SWS_SD_mCherry_cno(j,:) = perc_SWS_SD_mCherry_cno{j}; data_perc_SWS_SD_mCherry_cno(isnan(data_perc_SWS_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_SD_mCherry_cno(j,:) = perc_WAKE_SD_mCherry_cno{j}; data_perc_WAKE_SD_mCherry_cno(isnan(data_perc_WAKE_SD_mCherry_cno)==1)=0;
    data_perc_SLEEP_SD_mCherry_cno(j,:) = perc_SLEEP_SD_mCherry_cno{j}; data_perc_SLEEP_SD_mCherry_cno(isnan(data_perc_SLEEP_SD_mCherry_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_SD_mCherry_cno(j,:) = dur_REM_1_3h_SD_mCherry_cno{j}; data_dur_REM_1_3h_SD_mCherry_cno(isnan(data_dur_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_dur_SWS_1_3h_SD_mCherry_cno(j,:) = dur_SWS_1_3h_SD_mCherry_cno{j}; data_dur_SWS_1_3h_SD_mCherry_cno(isnan(data_dur_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_1_3h_SD_mCherry_cno(j,:) = dur_WAKE_1_3h_SD_mCherry_cno{j}; data_dur_WAKE_1_3h_SD_mCherry_cno(isnan(data_dur_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    data_dur_SLEEP_1_3h_SD_mCherry_cno(j,:) = dur_SLEEP_1_3h_SD_mCherry_cno{j}; data_dur_SLEEP_1_3h_SD_mCherry_cno(isnan(data_dur_SLEEP_1_3h_SD_mCherry_cno)==1)=0;
    
    
    data_num_REM_1_3h_SD_mCherry_cno(j,:) = num_REM_1_3h_SD_mCherry_cno{j};data_num_REM_1_3h_SD_mCherry_cno(isnan(data_num_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_num_SWS_1_3h_SD_mCherry_cno(j,:) = num_SWS_1_3h_SD_mCherry_cno{j}; data_num_SWS_1_3h_SD_mCherry_cno(isnan(data_num_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_num_WAKE_1_3h_SD_mCherry_cno(j,:) = num_WAKE_1_3h_SD_mCherry_cno{j}; data_num_WAKE_1_3h_SD_mCherry_cno(isnan(data_num_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    data_num_SLEEP_1_3h_SD_mCherry_cno(j,:) = num_SLEEP_1_3h_SD_mCherry_cno{j}; data_num_SLEEP_1_3h_SD_mCherry_cno(isnan(data_num_SLEEP_1_3h_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_1_3h_SD_mCherry_cno(j,:) = perc_REM_1_3h_SD_mCherry_cno{j}; data_perc_REM_1_3h_SD_mCherry_cno(isnan(data_perc_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_perc_SWS_1_3h_SD_mCherry_cno(j,:) = perc_SWS_1_3h_SD_mCherry_cno{j}; data_perc_SWS_1_3h_SD_mCherry_cno(isnan(data_perc_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_1_3h_SD_mCherry_cno(j,:) = perc_WAKE_1_3h_SD_mCherry_cno{j}; data_perc_WAKE_1_3h_SD_mCherry_cno(isnan(data_perc_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    data_perc_SLEEP_1_3h_SD_mCherry_cno(j,:) = perc_SLEEP_1_3h_SD_mCherry_cno{j}; data_perc_SLEEP_1_3h_SD_mCherry_cno(isnan(data_perc_SLEEP_1_3h_SD_mCherry_cno)==1)=0;
    
    data_dur_REM_interPeriod_SD_mCherry_cno(j,:) = dur_REM_interPeriod_SD_mCherry_cno{j}; data_dur_REM_interPeriod_SD_mCherry_cno(isnan(data_dur_REM_interPeriod_SD_mCherry_cno)==1)=0;
    data_dur_SWS_interPeriod_SD_mCherry_cno(j,:) = dur_SWS_interPeriod_SD_mCherry_cno{j}; data_dur_SWS_interPeriod_SD_mCherry_cno(isnan(data_dur_SWS_interPeriod_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_interPeriod_SD_mCherry_cno(j,:) = dur_WAKE_interPeriod_SD_mCherry_cno{j}; data_dur_WAKE_interPeriod_SD_mCherry_cno(isnan(data_dur_WAKE_interPeriod_SD_mCherry_cno)==1)=0;
    data_dur_SLEEP_interPeriod_SD_mCherry_cno(j,:) = dur_SLEEP_interPeriod_SD_mCherry_cno{j}; data_dur_SLEEP_interPeriod_SD_mCherry_cno(isnan(data_dur_SLEEP_interPeriod_SD_mCherry_cno)==1)=0;
    
    
    data_num_REM_interPeriod_SD_mCherry_cno(j,:) = num_REM_interPeriod_SD_mCherry_cno{j};data_num_REM_interPeriod_SD_mCherry_cno(isnan(data_num_REM_interPeriod_SD_mCherry_cno)==1)=0;
    data_num_SWS_interPeriod_SD_mCherry_cno(j,:) = num_SWS_interPeriod_SD_mCherry_cno{j}; data_num_SWS_interPeriod_SD_mCherry_cno(isnan(data_num_SWS_interPeriod_SD_mCherry_cno)==1)=0;
    data_num_WAKE_interPeriod_SD_mCherry_cno(j,:) = num_WAKE_interPeriod_SD_mCherry_cno{j}; data_num_WAKE_interPeriod_SD_mCherry_cno(isnan(data_num_WAKE_interPeriod_SD_mCherry_cno)==1)=0;
    data_num_SLEEP_interPeriod_SD_mCherry_cno(j,:) = num_SLEEP_interPeriod_SD_mCherry_cno{j}; data_num_SLEEP_interPeriod_SD_mCherry_cno(isnan(data_num_SLEEP_interPeriod_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_interPeriod_SD_mCherry_cno(j,:) = perc_REM_interPeriod_SD_mCherry_cno{j}; data_perc_REM_interPeriod_SD_mCherry_cno(isnan(data_perc_REM_interPeriod_SD_mCherry_cno)==1)=0;
    data_perc_SWS_interPeriod_SD_mCherry_cno(j,:) = perc_SWS_interPeriod_SD_mCherry_cno{j}; data_perc_SWS_interPeriod_SD_mCherry_cno(isnan(data_perc_SWS_interPeriod_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_interPeriod_SD_mCherry_cno(j,:) = perc_WAKE_interPeriod_SD_mCherry_cno{j}; data_perc_WAKE_interPeriod_SD_mCherry_cno(isnan(data_perc_WAKE_interPeriod_SD_mCherry_cno)==1)=0;
    data_perc_SLEEP_interPeriod_SD_mCherry_cno(j,:) = perc_SLEEP_interPeriod_SD_mCherry_cno{j}; data_perc_SLEEP_interPeriod_SD_mCherry_cno(isnan(data_perc_SLEEP_interPeriod_SD_mCherry_cno)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_3_end_SD_mCherry_cno(j,:) = dur_REM_3_end_SD_mCherry_cno{j}; data_dur_REM_3_end_SD_mCherry_cno(isnan(data_dur_REM_3_end_SD_mCherry_cno)==1)=0;
    data_dur_SWS_3_end_SD_mCherry_cno(j,:) = dur_SWS_3_end_SD_mCherry_cno{j}; data_dur_SWS_3_end_SD_mCherry_cno(isnan(data_dur_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_3_end_SD_mCherry_cno(j,:) = dur_WAKE_3_end_SD_mCherry_cno{j}; data_dur_WAKE_3_end_SD_mCherry_cno(isnan(data_dur_WAKE_3_end_SD_mCherry_cno)==1)=0;
    data_dur_SLEEP_3_end_SD_mCherry_cno(j,:) = dur_SLEEP_3_end_SD_mCherry_cno{j}; data_dur_SLEEP_3_end_SD_mCherry_cno(isnan(data_dur_SLEEP_3_end_SD_mCherry_cno)==1)=0;
    
    
    data_num_REM_3_end_SD_mCherry_cno(j,:) = num_REM_3_end_SD_mCherry_cno{j};data_num_REM_3_end_SD_mCherry_cno(isnan(data_num_REM_3_end_SD_mCherry_cno)==1)=0;
    data_num_SWS_3_end_SD_mCherry_cno(j,:) = num_SWS_3_end_SD_mCherry_cno{j}; data_num_SWS_3_end_SD_mCherry_cno(isnan(data_num_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_num_WAKE_3_end_SD_mCherry_cno(j,:) = num_WAKE_3_end_SD_mCherry_cno{j}; data_num_WAKE_3_end_SD_mCherry_cno(isnan(data_num_WAKE_3_end_SD_mCherry_cno)==1)=0;
    data_num_SLEEP_3_end_SD_mCherry_cno(j,:) = num_SLEEP_3_end_SD_mCherry_cno{j}; data_num_SLEEP_3_end_SD_mCherry_cno(isnan(data_num_SLEEP_3_end_SD_mCherry_cno)==1)=0;
    
    
    data_perc_REM_3_end_SD_mCherry_cno(j,:) = perc_REM_3_end_SD_mCherry_cno{j}; data_perc_REM_3_end_SD_mCherry_cno(isnan(data_perc_REM_3_end_SD_mCherry_cno)==1)=0;
    data_perc_SWS_3_end_SD_mCherry_cno(j,:) = perc_SWS_3_end_SD_mCherry_cno{j}; data_perc_SWS_3_end_SD_mCherry_cno(isnan(data_perc_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_3_end_SD_mCherry_cno(j,:) = perc_WAKE_3_end_SD_mCherry_cno{j}; data_perc_WAKE_3_end_SD_mCherry_cno(isnan(data_perc_WAKE_3_end_SD_mCherry_cno)==1)=0;
    data_perc_SLEEP_3_end_SD_mCherry_cno(j,:) = perc_SLEEP_3_end_SD_mCherry_cno{j}; data_perc_SLEEP_3_end_SD_mCherry_cno(isnan(data_perc_SLEEP_3_end_SD_mCherry_cno)==1)=0;
    
end

for j=1:length(all_trans_REM_REM_SD_mCherry_cno)
    data_REM_short_WAKE_3_end_SD_mCherry_cno(j,:) = all_trans_REM_short_WAKE_3_end_SD_mCherry_cno{j}; data_REM_short_WAKE_3_end_SD_mCherry_cno(isnan(data_REM_short_WAKE_3_end_SD_mCherry_cno)==1)=0;
    data_REM_short_SWS_3_end_SD_mCherry_cno(j,:) = all_trans_REM_short_SWS_3_end_SD_mCherry_cno{j}; data_REM_short_SWS_3_end_SD_mCherry_cno(isnan(data_REM_short_SWS_3_end_SD_mCherry_cno)==1)=0;
        data_REM_short_REM_3_end_SD_mCherry_cno(j,:) = all_trans_REM_short_REM_3_end_SD_mCherry_cno{j}; data_REM_short_REM_3_end_SD_mCherry_cno(isnan(data_REM_short_REM_3_end_SD_mCherry_cno)==1)=0;

    data_REM_mid_WAKE_3_end_SD_mCherry_cno(j,:) = all_trans_REM_mid_WAKE_3_end_SD_mCherry_cno{j}; data_REM_mid_WAKE_3_end_SD_mCherry_cno(isnan(data_REM_mid_WAKE_3_end_SD_mCherry_cno)==1)=0;
    data_REM_mid_SWS_3_end_SD_mCherry_cno(j,:) = all_trans_REM_mid_SWS_3_end_SD_mCherry_cno{j}; data_REM_mid_SWS_3_end_SD_mCherry_cno(isnan(data_REM_mid_SWS_3_end_SD_mCherry_cno)==1)=0;
    
    data_REM_long_WAKE_3_end_SD_mCherry_cno(j,:) = all_trans_REM_long_WAKE_3_end_SD_mCherry_cno{j}; data_REM_long_WAKE_3_end_SD_mCherry_cno(isnan(data_REM_long_WAKE_3_end_SD_mCherry_cno)==1)=0;
    data_REM_long_SWS_3_end_SD_mCherry_cno(j,:) = all_trans_REM_long_SWS_3_end_SD_mCherry_cno{j}; data_REM_long_SWS_3_end_SD_mCherry_cno(isnan(data_REM_long_SWS_3_end_SD_mCherry_cno)==1)=0;
    
    data_REM_mid_REM_3_end_SD_mCherry_cno(j,:) = all_trans_REM_mid_REM_3_end_SD_mCherry_cno{j}; data_REM_mid_REM_3_end_SD_mCherry_cno(isnan(data_REM_mid_REM_3_end_SD_mCherry_cno)==1)=0;
    data_REM_long_REM_3_end_SD_mCherry_cno(j,:) = all_trans_REM_long_REM_3_end_SD_mCherry_cno{j}; data_REM_long_REM_3_end_SD_mCherry_cno(isnan(data_REM_long_REM_3_end_SD_mCherry_cno)==1)=0;
    
end



%% GET DATA - SD dreadd cno
for m=1:length(DirSocialDefeat_sleepPost_dreadd_cno.path)
    cd(DirSocialDefeat_sleepPost_dreadd_cno.path{m}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_dreadd_cno{m} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_dreadd_cno{m} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_SD_dreadd_cno{m} = intervalSet(0,time_end);
    same_epoch_1_3h_SD_dreadd_cno{m} = intervalSet(time_st,time_mid);
    same_epoch_3_end_SD_dreadd_cno{m} = intervalSet(time_mid,time_end);
    same_epoch_interPeriod_SD_dreadd_cno{m} = intervalSet(time_mid_1,time_mid);
    
    
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
    
    
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_SD_dreadd_cno{m}),'sleep',tempbin,time_st,time_end);
    dur_SLEEP_SD_dreadd_cno{m}=dur_moyenne_ep_SLEEP;
    num_SLEEP_SD_dreadd_cno{m}=num_moyen_ep_SLEEP;
    perc_SLEEP_SD_dreadd_cno{m}=perc_moyen_SLEEP;
    
    
    
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
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_1_3h_SD_dreadd_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_1_3h_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_1_3h_SD_dreadd_cno{m}=perc_moyen_REM;
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{m}),'sleep',tempbin,time_st,time_mid);
    dur_SLEEP_1_3h_SD_dreadd_cno{m}=dur_moyenne_ep_SLEEP;
    num_SLEEP_1_3h_SD_dreadd_cno{m}=num_moyen_ep_SLEEP;
    perc_SLEEP_1_3h_SD_dreadd_cno{m}=perc_moyen_SLEEP;
    
    
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
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),'wake',tempbin,time_mid_1,time_mid);
    dur_WAKE_interPeriod_SD_dreadd_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD_dreadd_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD_dreadd_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),'sws',tempbin,time_mid_1,time_mid);
    dur_SWS_interPeriod_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD_dreadd_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),'rem',tempbin,time_mid_1,time_mid);
    dur_REM_interPeriod_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD_dreadd_cno{m}=perc_moyen_REM;
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),'sleep',tempbin,time_mid_1,time_mid);
    dur_SLEEP_interPeriod_SD_dreadd_cno{m}=dur_moyenne_ep_SLEEP;
    num_SLEEP_interPeriod_SD_dreadd_cno{m}=num_moyen_ep_SLEEP;
    perc_SLEEP_interPeriod_SD_dreadd_cno{m}=perc_moyen_SLEEP;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_SD_dreadd_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_SD_dreadd_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_SD_dreadd_cno{m}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_3_end_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_3_end_SD_dreadd_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_3_end_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_3_end_SD_dreadd_cno{m}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_SLEEP, num_moyen_ep_SLEEP,perc_moyen_SLEEP, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}),'sleep',tempbin,time_mid,time_end);
    dur_SLEEP_3_end_SD_dreadd_cno{m}=dur_moyenne_ep_SLEEP;
    num_SLEEP_3_end_SD_dreadd_cno{m}=num_moyen_ep_SLEEP;
    perc_SLEEP_3_end_SD_dreadd_cno{m}=perc_moyen_SLEEP;
    
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
    
    idx_short_rem_SD_dreadd_cno_1{m} = find(dur_REM_SD_dreadd_cno_bis{m}<lim_short_1); %short bouts < 10s
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
    
    idx_long_rem_SD_dreadd_cno{m} = find(dur_REM_SD_dreadd_cno_bis{m}>lim_long); %long bout
    long_REMEpoch_SD_dreadd_cno{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}), idx_long_rem_SD_dreadd_cno{m});
    [dur_rem_long_SD_dreadd_cno{m}, durT_rem_long_SD_dreadd_cno(m)] = DurationEpoch(long_REMEpoch_SD_dreadd_cno{m},'s');
    perc_rem_long_SD_dreadd_cno(m) = durT_rem_long_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_long_SD_dreadd_cno(m) = nanmean(dur_rem_long_SD_dreadd_cno{m});
    num_moyen_rem_long_SD_dreadd_cno(m) = length(dur_rem_long_SD_dreadd_cno{m});
    
    idx_mid_rem_SD_dreadd_cno{m} = find(dur_REM_SD_dreadd_cno_bis{m}>lim_short_1 & dur_REM_SD_dreadd_cno_bis{m}<lim_long); % middle bouts
    mid_REMEpoch_SD_dreadd_cno{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{m}), idx_mid_rem_SD_dreadd_cno{m});
    [dur_rem_mid_SD_dreadd_cno{m}, durT_rem_mid_SD_dreadd_cno(m)] = DurationEpoch(mid_REMEpoch_SD_dreadd_cno{m},'s');
    perc_rem_mid_SD_dreadd_cno(m) = durT_rem_mid_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_mid_SD_dreadd_cno(m) = nanmean(dur_rem_mid_SD_dreadd_cno{m});
    num_moyen_rem_mid_SD_dreadd_cno(m) = length(dur_rem_mid_SD_dreadd_cno{m});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(short_REMEpoch_SD_dreadd_cno_1{m},same_epoch_3_end_SD_dreadd_cno{m}),tempbin,time_mid,time_end);
    all_trans_REM_short_SWS_3_end_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_3_end_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_3_end_SD_dreadd_cno{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(mid_REMEpoch_SD_dreadd_cno{m},same_epoch_3_end_SD_dreadd_cno{m}),tempbin,time_mid,time_end);
    all_trans_REM_mid_SWS_3_end_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_3_end_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_3_end_SD_dreadd_cno{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_3_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{m}),and(long_REMEpoch_SD_dreadd_cno{m},same_epoch_3_end_SD_dreadd_cno{m}),tempbin,time_mid,time_end);
    all_trans_REM_long_SWS_3_end_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_3_end_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_3_end_SD_dreadd_cno{m} = trans_REM_to_REM;
    
    
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for m=1:length(dur_REM_SD_dreadd_cno)
    %%ALL SESSION
    data_dur_REM_SD_dreadd_cno(m,:) = dur_REM_SD_dreadd_cno{m}; data_dur_REM_SD_dreadd_cno(isnan(data_dur_REM_SD_dreadd_cno)==1)=0;
    data_dur_SWS_SD_dreadd_cno(m,:) = dur_SWS_SD_dreadd_cno{m}; data_dur_SWS_SD_dreadd_cno(isnan(data_dur_SWS_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_SD_dreadd_cno(m,:) = dur_WAKE_SD_dreadd_cno{m}; data_dur_WAKE_SD_dreadd_cno(isnan(data_dur_WAKE_SD_dreadd_cno)==1)=0;
    data_dur_SLEEP_SD_dreadd_cno(m,:) = dur_SLEEP_SD_dreadd_cno{m}; data_dur_SLEEP_SD_dreadd_cno(isnan(data_dur_SLEEP_SD_dreadd_cno)==1)=0;
    
    data_num_REM_SD_dreadd_cno(m,:) = num_REM_SD_dreadd_cno{m};data_num_REM_SD_dreadd_cno(isnan(data_num_REM_SD_dreadd_cno)==1)=0;
    data_num_SWS_SD_dreadd_cno(m,:) = num_SWS_SD_dreadd_cno{m}; data_num_SWS_SD_dreadd_cno(isnan(data_num_SWS_SD_dreadd_cno)==1)=0;
    data_num_WAKE_SD_dreadd_cno(m,:) = num_WAKE_SD_dreadd_cno{m}; data_num_WAKE_SD_dreadd_cno(isnan(data_num_WAKE_SD_dreadd_cno)==1)=0;
    data_num_SLEEP_SD_dreadd_cno(m,:) = num_SLEEP_SD_dreadd_cno{m}; data_num_SLEEP_SD_dreadd_cno(isnan(data_num_SLEEP_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_SD_dreadd_cno(m,:) = perc_REM_SD_dreadd_cno{m}; data_perc_REM_SD_dreadd_cno(isnan(data_perc_REM_SD_dreadd_cno)==1)=0;
    data_perc_SWS_SD_dreadd_cno(m,:) = perc_SWS_SD_dreadd_cno{m}; data_perc_SWS_SD_dreadd_cno(isnan(data_perc_SWS_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_SD_dreadd_cno(m,:) = perc_WAKE_SD_dreadd_cno{m}; data_perc_WAKE_SD_dreadd_cno(isnan(data_perc_WAKE_SD_dreadd_cno)==1)=0;
    data_perc_SLEEP_SD_dreadd_cno(m,:) = perc_SLEEP_SD_dreadd_cno{m}; data_perc_SLEEP_SD_dreadd_cno(isnan(data_perc_SLEEP_SD_dreadd_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_SD_dreadd_cno(m,:) = dur_REM_1_3h_SD_dreadd_cno{m}; data_dur_REM_1_3h_SD_dreadd_cno(isnan(data_dur_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_dur_SWS_1_3h_SD_dreadd_cno(m,:) = dur_SWS_1_3h_SD_dreadd_cno{m}; data_dur_SWS_1_3h_SD_dreadd_cno(isnan(data_dur_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_1_3h_SD_dreadd_cno(m,:) = dur_WAKE_1_3h_SD_dreadd_cno{m}; data_dur_WAKE_1_3h_SD_dreadd_cno(isnan(data_dur_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    data_dur_SLEEP_1_3h_SD_dreadd_cno(m,:) = dur_SLEEP_1_3h_SD_dreadd_cno{m}; data_dur_SLEEP_1_3h_SD_dreadd_cno(isnan(data_dur_SLEEP_1_3h_SD_dreadd_cno)==1)=0;
    
    
    data_num_REM_1_3h_SD_dreadd_cno(m,:) = num_REM_1_3h_SD_dreadd_cno{m};data_num_REM_1_3h_SD_dreadd_cno(isnan(data_num_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_num_SWS_1_3h_SD_dreadd_cno(m,:) = num_SWS_1_3h_SD_dreadd_cno{m}; data_num_SWS_1_3h_SD_dreadd_cno(isnan(data_num_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_num_WAKE_1_3h_SD_dreadd_cno(m,:) = num_WAKE_1_3h_SD_dreadd_cno{m}; data_num_WAKE_1_3h_SD_dreadd_cno(isnan(data_num_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    data_num_SLEEP_1_3h_SD_dreadd_cno(m,:) = num_SLEEP_1_3h_SD_dreadd_cno{m}; data_num_SLEEP_1_3h_SD_dreadd_cno(isnan(data_num_SLEEP_1_3h_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_1_3h_SD_dreadd_cno(m,:) = perc_REM_1_3h_SD_dreadd_cno{m}; data_perc_REM_1_3h_SD_dreadd_cno(isnan(data_perc_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_perc_SWS_1_3h_SD_dreadd_cno(m,:) = perc_SWS_1_3h_SD_dreadd_cno{m}; data_perc_SWS_1_3h_SD_dreadd_cno(isnan(data_perc_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_1_3h_SD_dreadd_cno(m,:) = perc_WAKE_1_3h_SD_dreadd_cno{m}; data_perc_WAKE_1_3h_SD_dreadd_cno(isnan(data_perc_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    data_perc_SLEEP_1_3h_SD_dreadd_cno(m,:) = perc_SLEEP_1_3h_SD_dreadd_cno{m}; data_perc_SLEEP_1_3h_SD_dreadd_cno(isnan(data_perc_SLEEP_1_3h_SD_dreadd_cno)==1)=0;
    
    data_dur_REM_interPeriod_SD_dreadd_cno(m,:) = dur_REM_interPeriod_SD_dreadd_cno{m}; data_dur_REM_interPeriod_SD_dreadd_cno(isnan(data_dur_REM_interPeriod_SD_dreadd_cno)==1)=0;
    data_dur_SWS_interPeriod_SD_dreadd_cno(m,:) = dur_SWS_interPeriod_SD_dreadd_cno{m}; data_dur_SWS_interPeriod_SD_dreadd_cno(isnan(data_dur_SWS_interPeriod_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_interPeriod_SD_dreadd_cno(m,:) = dur_WAKE_interPeriod_SD_dreadd_cno{m}; data_dur_WAKE_interPeriod_SD_dreadd_cno(isnan(data_dur_WAKE_interPeriod_SD_dreadd_cno)==1)=0;
    data_dur_SLEEP_interPeriod_SD_dreadd_cno(m,:) = dur_SLEEP_interPeriod_SD_dreadd_cno{m}; data_dur_SLEEP_interPeriod_SD_dreadd_cno(isnan(data_dur_SLEEP_interPeriod_SD_dreadd_cno)==1)=0;
    
    
    data_num_REM_interPeriod_SD_dreadd_cno(m,:) = num_REM_interPeriod_SD_dreadd_cno{m};data_num_REM_interPeriod_SD_dreadd_cno(isnan(data_num_REM_interPeriod_SD_dreadd_cno)==1)=0;
    data_num_SWS_interPeriod_SD_dreadd_cno(m,:) = num_SWS_interPeriod_SD_dreadd_cno{m}; data_num_SWS_interPeriod_SD_dreadd_cno(isnan(data_num_SWS_interPeriod_SD_dreadd_cno)==1)=0;
    data_num_WAKE_interPeriod_SD_dreadd_cno(m,:) = num_WAKE_interPeriod_SD_dreadd_cno{m}; data_num_WAKE_interPeriod_SD_dreadd_cno(isnan(data_num_WAKE_interPeriod_SD_dreadd_cno)==1)=0;
    data_num_SLEEP_interPeriod_SD_dreadd_cno(m,:) = num_SLEEP_interPeriod_SD_dreadd_cno{m}; data_num_SLEEP_interPeriod_SD_dreadd_cno(isnan(data_num_SLEEP_interPeriod_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_interPeriod_SD_dreadd_cno(m,:) = perc_REM_interPeriod_SD_dreadd_cno{m}; data_perc_REM_interPeriod_SD_dreadd_cno(isnan(data_perc_REM_interPeriod_SD_dreadd_cno)==1)=0;
    data_perc_SWS_interPeriod_SD_dreadd_cno(m,:) = perc_SWS_interPeriod_SD_dreadd_cno{m}; data_perc_SWS_interPeriod_SD_dreadd_cno(isnan(data_perc_SWS_interPeriod_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_interPeriod_SD_dreadd_cno(m,:) = perc_WAKE_interPeriod_SD_dreadd_cno{m}; data_perc_WAKE_interPeriod_SD_dreadd_cno(isnan(data_perc_WAKE_interPeriod_SD_dreadd_cno)==1)=0;
    data_perc_SLEEP_interPeriod_SD_dreadd_cno(m,:) = perc_SLEEP_interPeriod_SD_dreadd_cno{m}; data_perc_SLEEP_interPeriod_SD_dreadd_cno(isnan(data_perc_SLEEP_interPeriod_SD_dreadd_cno)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_3_end_SD_dreadd_cno(m,:) = dur_REM_3_end_SD_dreadd_cno{m}; data_dur_REM_3_end_SD_dreadd_cno(isnan(data_dur_REM_3_end_SD_dreadd_cno)==1)=0;
    data_dur_SWS_3_end_SD_dreadd_cno(m,:) = dur_SWS_3_end_SD_dreadd_cno{m}; data_dur_SWS_3_end_SD_dreadd_cno(isnan(data_dur_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_3_end_SD_dreadd_cno(m,:) = dur_WAKE_3_end_SD_dreadd_cno{m}; data_dur_WAKE_3_end_SD_dreadd_cno(isnan(data_dur_WAKE_3_end_SD_dreadd_cno)==1)=0;
    data_dur_SLEEP_3_end_SD_dreadd_cno(m,:) = dur_SLEEP_3_end_SD_dreadd_cno{m}; data_dur_SLEEP_3_end_SD_dreadd_cno(isnan(data_dur_SLEEP_3_end_SD_dreadd_cno)==1)=0;
    
    
    data_num_REM_3_end_SD_dreadd_cno(m,:) = num_REM_3_end_SD_dreadd_cno{m};data_num_REM_3_end_SD_dreadd_cno(isnan(data_num_REM_3_end_SD_dreadd_cno)==1)=0;
    data_num_SWS_3_end_SD_dreadd_cno(m,:) = num_SWS_3_end_SD_dreadd_cno{m}; data_num_SWS_3_end_SD_dreadd_cno(isnan(data_num_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_num_WAKE_3_end_SD_dreadd_cno(m,:) = num_WAKE_3_end_SD_dreadd_cno{m}; data_num_WAKE_3_end_SD_dreadd_cno(isnan(data_num_WAKE_3_end_SD_dreadd_cno)==1)=0;
    data_num_SLEEP_3_end_SD_dreadd_cno(m,:) = num_SLEEP_3_end_SD_dreadd_cno{m}; data_num_SLEEP_3_end_SD_dreadd_cno(isnan(data_num_SLEEP_3_end_SD_dreadd_cno)==1)=0;
    
    
    data_perc_REM_3_end_SD_dreadd_cno(m,:) = perc_REM_3_end_SD_dreadd_cno{m}; data_perc_REM_3_end_SD_dreadd_cno(isnan(data_perc_REM_3_end_SD_dreadd_cno)==1)=0;
    data_perc_SWS_3_end_SD_dreadd_cno(m,:) = perc_SWS_3_end_SD_dreadd_cno{m}; data_perc_SWS_3_end_SD_dreadd_cno(isnan(data_perc_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_3_end_SD_dreadd_cno(m,:) = perc_WAKE_3_end_SD_dreadd_cno{m}; data_perc_WAKE_3_end_SD_dreadd_cno(isnan(data_perc_WAKE_3_end_SD_dreadd_cno)==1)=0;
    data_perc_SLEEP_3_end_SD_dreadd_cno(m,:) = perc_SLEEP_3_end_SD_dreadd_cno{m}; data_perc_SLEEP_3_end_SD_dreadd_cno(isnan(data_perc_SLEEP_3_end_SD_dreadd_cno)==1)=0;
    
end
%%probability
for m=1:length(all_trans_REM_REM_SD_dreadd_cno)
% %     %%ALL SESSION
% %     data_REM_REM_SD_dreadd_cno(m,:) = all_trans_REM_REM_SD_dreadd_cno{m}; data_REM_REM_SD_dreadd_cno(isnan(data_REM_REM_SD_dreadd_cno)==1)=0;
% %     data_REM_SWS_SD_dreadd_cno(m,:) = all_trans_REM_SWS_SD_dreadd_cno{m}; data_REM_SWS_SD_dreadd_cno(isnan(data_REM_SWS_SD_dreadd_cno)==1)=0;
% %     data_REM_WAKE_SD_dreadd_cno(m,:) = all_trans_REM_WAKE_SD_dreadd_cno{m}; data_REM_WAKE_SD_dreadd_cno(isnan(data_REM_WAKE_SD_dreadd_cno)==1)=0;
% %
% %     data_SWS_SWS_SD_dreadd_cno(m,:) = all_trans_SWS_SWS_SD_dreadd_cno{m}; data_SWS_SWS_SD_dreadd_cno(isnan(data_SWS_SWS_SD_dreadd_cno)==1)=0;
% %     data_SWS_REM_SD_dreadd_cno(m,:) = all_trans_SWS_REM_SD_dreadd_cno{m}; data_SWS_REM_SD_dreadd_cno(isnan(data_SWS_REM_SD_dreadd_cno)==1)=0;
% %     data_SWS_WAKE_SD_dreadd_cno(m,:) = all_trans_SWS_WAKE_SD_dreadd_cno{m}; data_SWS_WAKE_SD_dreadd_cno(isnan(data_SWS_WAKE_SD_dreadd_cno)==1)=0;
% %
% %     data_WAKE_WAKE_SD_dreadd_cno(m,:) = all_trans_WAKE_WAKE_SD_dreadd_cno{m}; data_WAKE_WAKE_SD_dreadd_cno(isnan(data_WAKE_WAKE_SD_dreadd_cno)==1)=0;
% %     data_WAKE_REM_SD_dreadd_cno(m,:) = all_trans_WAKE_REM_SD_dreadd_cno{m}; data_WAKE_REM_SD_dreadd_cno(isnan(data_WAKE_REM_SD_dreadd_cno)==1)=0;
% %     data_WAKE_SWS_SD_dreadd_cno(m,:) = all_trans_WAKE_SWS_SD_dreadd_cno{m}; data_WAKE_SWS_SD_dreadd_cno(isnan(data_WAKE_SWS_SD_dreadd_cno)==1)=0;
% %
% %     %%3 PREMI7RES HEURES
% %         data_REM_REM_1_3h_SD_dreadd_cno(m,:) = all_trans_REM_REM_1_3h_SD_dreadd_cno{m}; data_REM_REM_1_3h_SD_dreadd_cno(isnan(data_REM_REM_1_3h_SD_dreadd_cno)==1)=0;
% %     data_REM_SWS_1_3h_SD_dreadd_cno(m,:) = all_trans_REM_SWS_1_3h_SD_dreadd_cno{m}; data_REM_SWS_1_3h_SD_dreadd_cno(isnan(data_REM_SWS_1_3h_SD_dreadd_cno)==1)=0;
% %     data_REM_WAKE_1_3h_SD_dreadd_cno(m,:) = all_trans_REM_WAKE_1_3h_SD_dreadd_cno{m}; data_REM_WAKE_1_3h_SD_dreadd_cno(isnan(data_REM_WAKE_1_3h_SD_dreadd_cno)==1)=0;
% %
% %     data_SWS_SWS_1_3h_SD_dreadd_cno(m,:) = all_trans_SWS_SWS_1_3h_SD_dreadd_cno{m}; data_SWS_SWS_1_3h_SD_dreadd_cno(isnan(data_SWS_SWS_1_3h_SD_dreadd_cno)==1)=0;
% %     data_SWS_REM_1_3h_SD_dreadd_cno(m,:) = all_trans_SWS_REM_1_3h_SD_dreadd_cno{m}; data_SWS_REM_1_3h_SD_dreadd_cno(isnan(data_SWS_REM_1_3h_SD_dreadd_cno)==1)=0;
% %     data_SWS_WAKE_1_3h_SD_dreadd_cno(m,:) = all_trans_SWS_WAKE_1_3h_SD_dreadd_cno{m}; data_SWS_WAKE_1_3h_SD_dreadd_cno(isnan(data_SWS_WAKE_1_3h_SD_dreadd_cno)==1)=0;
% %
% %     data_WAKE_WAKE_1_3h_SD_dreadd_cno(m,:) = all_trans_WAKE_WAKE_1_3h_SD_dreadd_cno{m}; data_WAKE_WAKE_1_3h_SD_dreadd_cno(isnan(data_WAKE_WAKE_1_3h_SD_dreadd_cno)==1)=0;
% %     data_WAKE_REM_1_3h_SD_dreadd_cno(m,:) = all_trans_WAKE_REM_1_3h_SD_dreadd_cno{m}; data_WAKE_REM_1_3h_SD_dreadd_cno(isnan(data_WAKE_REM_1_3h_SD_dreadd_cno)==1)=0;
% %     data_WAKE_SWS_1_3h_SD_dreadd_cno(m,:) = all_trans_WAKE_SWS_1_3h_SD_dreadd_cno{m}; data_WAKE_SWS_1_3h_SD_dreadd_cno(isnan(data_WAKE_SWS_1_3h_SD_dreadd_cno)==1)=0;
% %
% %     %%FIN DE LA SESSION
% %         data_REM_REM_3_end_SD_dreadd_cno(m,:) = all_trans_REM_REM_3_end_SD_dreadd_cno{m}; data_REM_REM_3_end_SD_dreadd_cno(isnan(data_REM_REM_3_end_SD_dreadd_cno)==1)=0;
% %     data_REM_SWS_3_end_SD_dreadd_cno(m,:) = all_trans_REM_SWS_3_end_SD_dreadd_cno{m}; data_REM_SWS_3_end_SD_dreadd_cno(isnan(data_REM_SWS_3_end_SD_dreadd_cno)==1)=0;
% %     data_REM_WAKE_3_end_SD_dreadd_cno(m,:) = all_trans_REM_WAKE_3_end_SD_dreadd_cno{m}; data_REM_WAKE_3_end_SD_dreadd_cno(isnan(data_REM_WAKE_3_end_SD_dreadd_cno)==1)=0;
% %
% %     data_SWS_SWS_3_end_SD_dreadd_cno(m,:) = all_trans_SWS_SWS_3_end_SD_dreadd_cno{m}; data_SWS_SWS_3_end_SD_dreadd_cno(isnan(data_SWS_SWS_3_end_SD_dreadd_cno)==1)=0;
% %     data_SWS_REM_3_end_SD_dreadd_cno(m,:) = all_trans_SWS_REM_3_end_SD_dreadd_cno{m}; data_SWS_REM_3_end_SD_dreadd_cno(isnan(data_SWS_REM_3_end_SD_dreadd_cno)==1)=0;
% %     data_SWS_WAKE_3_end_SD_dreadd_cno(m,:) = all_trans_SWS_WAKE_3_end_SD_dreadd_cno{m}; data_SWS_WAKE_3_end_SD_dreadd_cno(isnan(data_SWS_WAKE_3_end_SD_dreadd_cno)==1)=0;
% %
% %     data_WAKE_WAKE_3_end_SD_dreadd_cno(m,:) = all_trans_WAKE_WAKE_3_end_SD_dreadd_cno{m}; data_WAKE_WAKE_3_end_SD_dreadd_cno(isnan(data_WAKE_WAKE_3_end_SD_dreadd_cno)==1)=0;
% %     data_WAKE_REM_3_end_SD_dreadd_cno(m,:) = all_trans_WAKE_REM_3_end_SD_dreadd_cno{m}; data_WAKE_REM_3_end_SD_dreadd_cno(isnan(data_WAKE_REM_3_end_SD_dreadd_cno)==1)=0;
% %     data_WAKE_SWS_3_end_SD_dreadd_cno(m,:) = all_trans_WAKE_SWS_3_end_SD_dreadd_cno{m}; data_WAKE_SWS_3_end_SD_dreadd_cno(isnan(data_WAKE_SWS_3_end_SD_dreadd_cno)==1)=0;
data_REM_short_WAKE_3_end_SD_dreadd_cno(m,:) = all_trans_REM_short_WAKE_3_end_SD_dreadd_cno{m}; data_REM_short_WAKE_3_end_SD_dreadd_cno(isnan(data_REM_short_WAKE_3_end_SD_dreadd_cno)==1)=0;
data_REM_short_SWS_3_end_SD_dreadd_cno(m,:) = all_trans_REM_short_SWS_3_end_SD_dreadd_cno{m}; data_REM_short_SWS_3_end_SD_dreadd_cno(isnan(data_REM_short_SWS_3_end_SD_dreadd_cno)==1)=0;

data_REM_mid_WAKE_3_end_SD_dreadd_cno(m,:) = all_trans_REM_mid_WAKE_3_end_SD_dreadd_cno{m}; data_REM_mid_WAKE_3_end_SD_dreadd_cno(isnan(data_REM_mid_WAKE_3_end_SD_dreadd_cno)==1)=0;
data_REM_mid_SWS_3_end_SD_dreadd_cno(m,:) = all_trans_REM_mid_SWS_3_end_SD_dreadd_cno{m}; data_REM_mid_SWS_3_end_SD_dreadd_cno(isnan(data_REM_mid_SWS_3_end_SD_dreadd_cno)==1)=0;

data_REM_long_WAKE_3_end_SD_dreadd_cno(m,:) = all_trans_REM_long_WAKE_3_end_SD_dreadd_cno{m}; data_REM_long_WAKE_3_end_SD_dreadd_cno(isnan(data_REM_long_WAKE_3_end_SD_dreadd_cno)==1)=0;
data_REM_long_SWS_3_end_SD_dreadd_cno(m,:) = all_trans_REM_long_SWS_3_end_SD_dreadd_cno{m}; data_REM_long_SWS_3_end_SD_dreadd_cno(isnan(data_REM_long_SWS_3_end_SD_dreadd_cno)==1)=0;


data_REM_short_REM_3_end_SD_dreadd_cno(m,:) = all_trans_REM_short_REM_3_end_SD_dreadd_cno{m}; data_REM_short_REM_3_end_SD_dreadd_cno(isnan(data_REM_short_REM_3_end_SD_dreadd_cno)==1)=0;
data_REM_mid_REM_3_end_SD_dreadd_cno(m,:) = all_trans_REM_mid_REM_3_end_SD_dreadd_cno{m}; data_REM_mid_REM_3_end_SD_dreadd_cno(isnan(data_REM_mid_REM_3_end_SD_dreadd_cno)==1)=0;
data_REM_long_REM_3_end_SD_dreadd_cno(m,:) = all_trans_REM_long_REM_3_end_SD_dreadd_cno{m}; data_REM_long_REM_3_end_SD_dreadd_cno(isnan(data_REM_long_REM_3_end_SD_dreadd_cno)==1)=0;


end



%% FIGURE w/ all statges (perc, num, mean dur) overtime
col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];

isparam = 0; %%use parametric test
iscorr = 1; %%show corrected pvalues

figure, hold on
subplot(4,6,[1,2]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('Wake percentage')
%%stats wake perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_WAKE_ctrl(:,1), data_perc_WAKE_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_WAKE_ctrl(:,2), data_perc_WAKE_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_WAKE_ctrl(:,3), data_perc_WAKE_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_WAKE_ctrl(:,4), data_perc_WAKE_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_WAKE_ctrl(:,5), data_perc_WAKE_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_WAKE_ctrl(:,6), data_perc_WAKE_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_WAKE_ctrl(:,7), data_perc_WAKE_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_WAKE_ctrl(:,8), data_perc_WAKE_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_WAKE_ctrl(:,1), data_perc_WAKE_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_WAKE_ctrl(:,2), data_perc_WAKE_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_WAKE_ctrl(:,3), data_perc_WAKE_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_WAKE_ctrl(:,4), data_perc_WAKE_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_WAKE_ctrl(:,5), data_perc_WAKE_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_WAKE_ctrl(:,6), data_perc_WAKE_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_WAKE_ctrl(:,7), data_perc_WAKE_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_WAKE_ctrl(:,8), data_perc_WAKE_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[7,8]), hold on % Sleep percentage overtime
plot(nanmean(data_perc_SLEEP_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_SLEEP_ctrl), stdError(data_perc_SLEEP_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_SLEEP_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_SLEEP_SD), stdError(data_perc_SLEEP_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('SLEEP percentage')
%%stats all sleep perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_SLEEP_ctrl(:,1), data_perc_SLEEP_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_SLEEP_ctrl(:,2), data_perc_SLEEP_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_SLEEP_ctrl(:,3), data_perc_SLEEP_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_SLEEP_ctrl(:,4), data_perc_SLEEP_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_SLEEP_ctrl(:,5), data_perc_SLEEP_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_SLEEP_ctrl(:,6), data_perc_SLEEP_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_SLEEP_ctrl(:,7), data_perc_SLEEP_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_SLEEP_ctrl(:,8), data_perc_SLEEP_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_SLEEP_ctrl(:,1), data_perc_SLEEP_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_SLEEP_ctrl(:,2), data_perc_SLEEP_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_SLEEP_ctrl(:,3), data_perc_SLEEP_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_SLEEP_ctrl(:,4), data_perc_SLEEP_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_SLEEP_ctrl(:,5), data_perc_SLEEP_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_SLEEP_ctrl(:,6), data_perc_SLEEP_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_SLEEP_ctrl(:,7), data_perc_SLEEP_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_SLEEP_ctrl(:,8), data_perc_SLEEP_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[13,14]), hold on
plot(nanmean(data_perc_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_SWS_ctrl), stdError(data_perc_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('NREM percentage')
%%stats all SWS perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_SWS_ctrl(:,1), data_perc_SWS_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_SWS_ctrl(:,2), data_perc_SWS_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_SWS_ctrl(:,3), data_perc_SWS_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_SWS_ctrl(:,4), data_perc_SWS_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_SWS_ctrl(:,5), data_perc_SWS_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_SWS_ctrl(:,6), data_perc_SWS_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_SWS_ctrl(:,7), data_perc_SWS_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_SWS_ctrl(:,8), data_perc_SWS_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_SWS_ctrl(:,1), data_perc_SWS_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_SWS_ctrl(:,2), data_perc_SWS_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_SWS_ctrl(:,3), data_perc_SWS_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_SWS_ctrl(:,4), data_perc_SWS_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_SWS_ctrl(:,5), data_perc_SWS_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_SWS_ctrl(:,6), data_perc_SWS_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_SWS_ctrl(:,7), data_perc_SWS_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_SWS_ctrl(:,8), data_perc_SWS_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[19,20]) %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('REM percentage')
%%stats all REM perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_REM_ctrl(:,1), data_perc_REM_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_REM_ctrl(:,2), data_perc_REM_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_REM_ctrl(:,3), data_perc_REM_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_REM_ctrl(:,4), data_perc_REM_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_REM_ctrl(:,5), data_perc_REM_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_REM_ctrl(:,6), data_perc_REM_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_REM_ctrl(:,7), data_perc_REM_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_REM_ctrl(:,8), data_perc_REM_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_REM_ctrl(:,1), data_perc_REM_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_REM_ctrl(:,2), data_perc_REM_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_REM_ctrl(:,3), data_perc_REM_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_REM_ctrl(:,4), data_perc_REM_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_REM_ctrl(:,5), data_perc_REM_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_REM_ctrl(:,6), data_perc_REM_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_REM_ctrl(:,7), data_perc_REM_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_REM_ctrl(:,8), data_perc_REM_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[3,4]) % wake numentage overtime
plot(nanmean(data_num_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_WAKE_ctrl), stdError(data_num_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_num_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_WAKE_SD), stdError(data_num_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('Wake num')
%%stats wake num overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_num_WAKE_ctrl(:,1), data_num_WAKE_SD(:,1));
    [p_2,h_2] = ranksum(data_num_WAKE_ctrl(:,2), data_num_WAKE_SD(:,2));
    [p_3,h_3] = ranksum(data_num_WAKE_ctrl(:,3), data_num_WAKE_SD(:,3));
    [p_4,h_4] = ranksum(data_num_WAKE_ctrl(:,4), data_num_WAKE_SD(:,4));
    [p_5,h_5] = ranksum(data_num_WAKE_ctrl(:,5), data_num_WAKE_SD(:,5));
    [p_6,h_6] = ranksum(data_num_WAKE_ctrl(:,6), data_num_WAKE_SD(:,6));
    [p_7,h_7] = ranksum(data_num_WAKE_ctrl(:,7), data_num_WAKE_SD(:,7));
    [p_8,h_8] = ranksum(data_num_WAKE_ctrl(:,8), data_num_WAKE_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_WAKE_ctrl(:,1), data_num_WAKE_SD(:,1));
    [h_2,p_2] = ttest2(data_num_WAKE_ctrl(:,2), data_num_WAKE_SD(:,2));
    [h_3,p_3] = ttest2(data_num_WAKE_ctrl(:,3), data_num_WAKE_SD(:,3));
    [h_4,p_4] = ttest2(data_num_WAKE_ctrl(:,4), data_num_WAKE_SD(:,4));
    [h_5,p_5] = ttest2(data_num_WAKE_ctrl(:,5), data_num_WAKE_SD(:,5));
    [h_6,p_6] = ttest2(data_num_WAKE_ctrl(:,6), data_num_WAKE_SD(:,6));
    [h_7,p_7] = ttest2(data_num_WAKE_ctrl(:,7), data_num_WAKE_SD(:,7));
    [h_8,p_8] = ttest2(data_num_WAKE_ctrl(:,8), data_num_WAKE_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[9,10]), hold on % Sleep numentage overtime
plot(nanmean(data_num_SLEEP_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_SLEEP_ctrl), stdError(data_num_SLEEP_ctrl),'color',col_ctrl)
plot(nanmean(data_num_SLEEP_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_SLEEP_SD), stdError(data_num_SLEEP_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('SLEEP num')
%%stats SLEEP num overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_num_SLEEP_ctrl(:,1), data_num_SLEEP_SD(:,1));
    [p_2,h_2] = ranksum(data_num_SLEEP_ctrl(:,2), data_num_SLEEP_SD(:,2));
    [p_3,h_3] = ranksum(data_num_SLEEP_ctrl(:,3), data_num_SLEEP_SD(:,3));
    [p_4,h_4] = ranksum(data_num_SLEEP_ctrl(:,4), data_num_SLEEP_SD(:,4));
    [p_5,h_5] = ranksum(data_num_SLEEP_ctrl(:,5), data_num_SLEEP_SD(:,5));
    [p_6,h_6] = ranksum(data_num_SLEEP_ctrl(:,6), data_num_SLEEP_SD(:,6));
    [p_7,h_7] = ranksum(data_num_SLEEP_ctrl(:,7), data_num_SLEEP_SD(:,7));
    [p_8,h_8] = ranksum(data_num_SLEEP_ctrl(:,8), data_num_SLEEP_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_SLEEP_ctrl(:,1), data_num_SLEEP_SD(:,1));
    [h_2,p_2] = ttest2(data_num_SLEEP_ctrl(:,2), data_num_SLEEP_SD(:,2));
    [h_3,p_3] = ttest2(data_num_SLEEP_ctrl(:,3), data_num_SLEEP_SD(:,3));
    [h_4,p_4] = ttest2(data_num_SLEEP_ctrl(:,4), data_num_SLEEP_SD(:,4));
    [h_5,p_5] = ttest2(data_num_SLEEP_ctrl(:,5), data_num_SLEEP_SD(:,5));
    [h_6,p_6] = ttest2(data_num_SLEEP_ctrl(:,6), data_num_SLEEP_SD(:,6));
    [h_7,p_7] = ttest2(data_num_SLEEP_ctrl(:,7), data_num_SLEEP_SD(:,7));
    [h_8,p_8] = ttest2(data_num_SLEEP_ctrl(:,8), data_num_SLEEP_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[15,16]), hold on
plot(nanmean(data_num_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_SWS_ctrl), stdError(data_num_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_num_SWS_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_SWS_SD), stdError(data_num_SWS_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('NREM num')
%%stats SWS num overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_num_SWS_ctrl(:,1), data_num_SWS_SD(:,1));
    [p_2,h_2] = ranksum(data_num_SWS_ctrl(:,2), data_num_SWS_SD(:,2));
    [p_3,h_3] = ranksum(data_num_SWS_ctrl(:,3), data_num_SWS_SD(:,3));
    [p_4,h_4] = ranksum(data_num_SWS_ctrl(:,4), data_num_SWS_SD(:,4));
    [p_5,h_5] = ranksum(data_num_SWS_ctrl(:,5), data_num_SWS_SD(:,5));
    [p_6,h_6] = ranksum(data_num_SWS_ctrl(:,6), data_num_SWS_SD(:,6));
    [p_7,h_7] = ranksum(data_num_SWS_ctrl(:,7), data_num_SWS_SD(:,7));
    [p_8,h_8] = ranksum(data_num_SWS_ctrl(:,8), data_num_SWS_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_SWS_ctrl(:,1), data_num_SWS_SD(:,1));
    [h_2,p_2] = ttest2(data_num_SWS_ctrl(:,2), data_num_SWS_SD(:,2));
    [h_3,p_3] = ttest2(data_num_SWS_ctrl(:,3), data_num_SWS_SD(:,3));
    [h_4,p_4] = ttest2(data_num_SWS_ctrl(:,4), data_num_SWS_SD(:,4));
    [h_5,p_5] = ttest2(data_num_SWS_ctrl(:,5), data_num_SWS_SD(:,5));
    [h_6,p_6] = ttest2(data_num_SWS_ctrl(:,6), data_num_SWS_SD(:,6));
    [h_7,p_7] = ttest2(data_num_SWS_ctrl(:,7), data_num_SWS_SD(:,7));
    [h_8,p_8] = ttest2(data_num_SWS_ctrl(:,8), data_num_SWS_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[21,22]) %REM numentage overtime
plot(nanmean(data_num_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_REM_ctrl), stdError(data_num_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('REM num')
%%stats REM num overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_num_REM_ctrl(:,1), data_num_REM_SD(:,1));
    [p_2,h_2] = ranksum(data_num_REM_ctrl(:,2), data_num_REM_SD(:,2));
    [p_3,h_3] = ranksum(data_num_REM_ctrl(:,3), data_num_REM_SD(:,3));
    [p_4,h_4] = ranksum(data_num_REM_ctrl(:,4), data_num_REM_SD(:,4));
    [p_5,h_5] = ranksum(data_num_REM_ctrl(:,5), data_num_REM_SD(:,5));
    [p_6,h_6] = ranksum(data_num_REM_ctrl(:,6), data_num_REM_SD(:,6));
    [p_7,h_7] = ranksum(data_num_REM_ctrl(:,7), data_num_REM_SD(:,7));
    [p_8,h_8] = ranksum(data_num_REM_ctrl(:,8), data_num_REM_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_REM_ctrl(:,1), data_num_REM_SD(:,1));
    [h_2,p_2] = ttest2(data_num_REM_ctrl(:,2), data_num_REM_SD(:,2));
    [h_3,p_3] = ttest2(data_num_REM_ctrl(:,3), data_num_REM_SD(:,3));
    [h_4,p_4] = ttest2(data_num_REM_ctrl(:,4), data_num_REM_SD(:,4));
    [h_5,p_5] = ttest2(data_num_REM_ctrl(:,5), data_num_REM_SD(:,5));
    [h_6,p_6] = ttest2(data_num_REM_ctrl(:,6), data_num_REM_SD(:,6));
    [h_7,p_7] = ttest2(data_num_REM_ctrl(:,7), data_num_REM_SD(:,7));
    [h_8,p_8] = ttest2(data_num_REM_ctrl(:,8), data_num_REM_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[5,6]) % wake durentage overtime
plot(nanmean(data_dur_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_WAKE_ctrl), stdError(data_dur_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_WAKE_SD), stdError(data_dur_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('Wake dur')
%%stats wake dur overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_dur_WAKE_ctrl(:,1), data_dur_WAKE_SD(:,1));
    [p_2,h_2] = ranksum(data_dur_WAKE_ctrl(:,2), data_dur_WAKE_SD(:,2));
    [p_3,h_3] = ranksum(data_dur_WAKE_ctrl(:,3), data_dur_WAKE_SD(:,3));
    [p_4,h_4] = ranksum(data_dur_WAKE_ctrl(:,4), data_dur_WAKE_SD(:,4));
    [p_5,h_5] = ranksum(data_dur_WAKE_ctrl(:,5), data_dur_WAKE_SD(:,5));
    [p_6,h_6] = ranksum(data_dur_WAKE_ctrl(:,6), data_dur_WAKE_SD(:,6));
    [p_7,h_7] = ranksum(data_dur_WAKE_ctrl(:,7), data_dur_WAKE_SD(:,7));
    [p_8,h_8] = ranksum(data_dur_WAKE_ctrl(:,8), data_dur_WAKE_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_WAKE_ctrl(:,1), data_dur_WAKE_SD(:,1));
    [h_2,p_2] = ttest2(data_dur_WAKE_ctrl(:,2), data_dur_WAKE_SD(:,2));
    [h_3,p_3] = ttest2(data_dur_WAKE_ctrl(:,3), data_dur_WAKE_SD(:,3));
    [h_4,p_4] = ttest2(data_dur_WAKE_ctrl(:,4), data_dur_WAKE_SD(:,4));
    [h_5,p_5] = ttest2(data_dur_WAKE_ctrl(:,5), data_dur_WAKE_SD(:,5));
    [h_6,p_6] = ttest2(data_dur_WAKE_ctrl(:,6), data_dur_WAKE_SD(:,6));
    [h_7,p_7] = ttest2(data_dur_WAKE_ctrl(:,7), data_dur_WAKE_SD(:,7));
    [h_8,p_8] = ttest2(data_dur_WAKE_ctrl(:,8), data_dur_WAKE_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[11,12]), hold on % Sleep durentage overtime
plot(nanmean(data_dur_SLEEP_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_SLEEP_ctrl), stdError(data_dur_SLEEP_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_SLEEP_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_SLEEP_SD), stdError(data_dur_SLEEP_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('SLEEP dur')
%%stats SLEEP dur overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_dur_SLEEP_ctrl(:,1), data_dur_SLEEP_SD(:,1));
    [p_2,h_2] = ranksum(data_dur_SLEEP_ctrl(:,2), data_dur_SLEEP_SD(:,2));
    [p_3,h_3] = ranksum(data_dur_SLEEP_ctrl(:,3), data_dur_SLEEP_SD(:,3));
    [p_4,h_4] = ranksum(data_dur_SLEEP_ctrl(:,4), data_dur_SLEEP_SD(:,4));
    [p_5,h_5] = ranksum(data_dur_SLEEP_ctrl(:,5), data_dur_SLEEP_SD(:,5));
    [p_6,h_6] = ranksum(data_dur_SLEEP_ctrl(:,6), data_dur_SLEEP_SD(:,6));
    [p_7,h_7] = ranksum(data_dur_SLEEP_ctrl(:,7), data_dur_SLEEP_SD(:,7));
    [p_8,h_8] = ranksum(data_dur_SLEEP_ctrl(:,8), data_dur_SLEEP_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_SLEEP_ctrl(:,1), data_dur_SLEEP_SD(:,1));
    [h_2,p_2] = ttest2(data_dur_SLEEP_ctrl(:,2), data_dur_SLEEP_SD(:,2));
    [h_3,p_3] = ttest2(data_dur_SLEEP_ctrl(:,3), data_dur_SLEEP_SD(:,3));
    [h_4,p_4] = ttest2(data_dur_SLEEP_ctrl(:,4), data_dur_SLEEP_SD(:,4));
    [h_5,p_5] = ttest2(data_dur_SLEEP_ctrl(:,5), data_dur_SLEEP_SD(:,5));
    [h_6,p_6] = ttest2(data_dur_SLEEP_ctrl(:,6), data_dur_SLEEP_SD(:,6));
    [h_7,p_7] = ttest2(data_dur_SLEEP_ctrl(:,7), data_dur_SLEEP_SD(:,7));
    [h_8,p_8] = ttest2(data_dur_SLEEP_ctrl(:,8), data_dur_SLEEP_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[17,18]), hold on
plot(nanmean(data_dur_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_SWS_ctrl), stdError(data_dur_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_SWS_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_SWS_SD), stdError(data_dur_SWS_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('NREM dur')
%%stats SWS dur overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_dur_SWS_ctrl(:,1), data_dur_SWS_SD(:,1));
    [p_2,h_2] = ranksum(data_dur_SWS_ctrl(:,2), data_dur_SWS_SD(:,2));
    [p_3,h_3] = ranksum(data_dur_SWS_ctrl(:,3), data_dur_SWS_SD(:,3));
    [p_4,h_4] = ranksum(data_dur_SWS_ctrl(:,4), data_dur_SWS_SD(:,4));
    [p_5,h_5] = ranksum(data_dur_SWS_ctrl(:,5), data_dur_SWS_SD(:,5));
    [p_6,h_6] = ranksum(data_dur_SWS_ctrl(:,6), data_dur_SWS_SD(:,6));
    [p_7,h_7] = ranksum(data_dur_SWS_ctrl(:,7), data_dur_SWS_SD(:,7));
    [p_8,h_8] = ranksum(data_dur_SWS_ctrl(:,8), data_dur_SWS_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_SWS_ctrl(:,1), data_dur_SWS_SD(:,1));
    [h_2,p_2] = ttest2(data_dur_SWS_ctrl(:,2), data_dur_SWS_SD(:,2));
    [h_3,p_3] = ttest2(data_dur_SWS_ctrl(:,3), data_dur_SWS_SD(:,3));
    [h_4,p_4] = ttest2(data_dur_SWS_ctrl(:,4), data_dur_SWS_SD(:,4));
    [h_5,p_5] = ttest2(data_dur_SWS_ctrl(:,5), data_dur_SWS_SD(:,5));
    [h_6,p_6] = ttest2(data_dur_SWS_ctrl(:,6), data_dur_SWS_SD(:,6));
    [h_7,p_7] = ttest2(data_dur_SWS_ctrl(:,7), data_dur_SWS_SD(:,7));
    [h_8,p_8] = ttest2(data_dur_SWS_ctrl(:,8), data_dur_SWS_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[23,24]) %REM durentage overtime
plot(nanmean(data_dur_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_REM_ctrl), stdError(data_dur_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('REM dur')
%%stats REM dur overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_dur_REM_ctrl(:,1), data_dur_REM_SD(:,1));
    [p_2,h_2] = ranksum(data_dur_REM_ctrl(:,2), data_dur_REM_SD(:,2));
    [p_3,h_3] = ranksum(data_dur_REM_ctrl(:,3), data_dur_REM_SD(:,3));
    [p_4,h_4] = ranksum(data_dur_REM_ctrl(:,4), data_dur_REM_SD(:,4));
    [p_5,h_5] = ranksum(data_dur_REM_ctrl(:,5), data_dur_REM_SD(:,5));
    [p_6,h_6] = ranksum(data_dur_REM_ctrl(:,6), data_dur_REM_SD(:,6));
    [p_7,h_7] = ranksum(data_dur_REM_ctrl(:,7), data_dur_REM_SD(:,7));
    [p_8,h_8] = ranksum(data_dur_REM_ctrl(:,8), data_dur_REM_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_REM_ctrl(:,1), data_dur_REM_SD(:,1));
    [h_2,p_2] = ttest2(data_dur_REM_ctrl(:,2), data_dur_REM_SD(:,2));
    [h_3,p_3] = ttest2(data_dur_REM_ctrl(:,3), data_dur_REM_SD(:,3));
    [h_4,p_4] = ttest2(data_dur_REM_ctrl(:,4), data_dur_REM_SD(:,4));
    [h_5,p_5] = ttest2(data_dur_REM_ctrl(:,5), data_dur_REM_SD(:,5));
    [h_6,p_6] = ttest2(data_dur_REM_ctrl(:,6), data_dur_REM_SD(:,6));
    [h_7,p_7] = ttest2(data_dur_REM_ctrl(:,7), data_dur_REM_SD(:,7));
    [h_8,p_8] = ttest2(data_dur_REM_ctrl(:,8), data_dur_REM_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end














































































%%
txt_size = 15;

col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];
col_mCherry_cno = [1 .2 0];
col_dreadd_cno = [0 .4 .4];

% col_ctrl = col_mCherry_cno;

figure, hold on
subplot(4,6,[7,8]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9 11 13 15]); xticklabels({'10','11','12','13','14','15','16','17'})
makepretty
ylabel('Wake percentage')
xlim([0 17])


subplot(4,6,[9,10]), hold on % SLEEP percentage overtime
plot(nanmean(data_perc_SLEEP_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_SLEEP_ctrl), stdError(data_perc_SLEEP_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_SLEEP_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_SLEEP_SD), stdError(data_perc_SLEEP_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9 11 13 15]); xticklabels({'10','11','12','13','14','15','16','17'})
makepretty
ylabel('SLEEP percentage')
xlim([0 17])


subplot(4,6,[11,12]) %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9 11 13 15]); xticklabels({'10','11','12','13','14','15','16','17'})
makepretty
ylabel('REM percentage')
xlim([0 17])
ylim([0 15])


subplot(4,6,[15,16]) % SLEEP bouts mean duraion overtime
plot(nanmean(data_dur_SLEEP_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_SLEEP_ctrl), stdError(data_dur_SLEEP_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_SLEEP_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_SLEEP_SD), stdError(data_dur_SLEEP_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9 11 13 15]); xticklabels({'10','11','12','13','14','15','16','17'})
makepretty
ylabel('SLEEP mean duration (s)')
xlim([0 17])


subplot(4,6,[17,18]) % REM bouts mean duraion overtime
plot(nanmean(data_dur_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_REM_ctrl), stdError(data_dur_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9 11 13 15]); xticklabels({'10','11','12','13','14','15','16','17'})
makepretty
ylabel('REM mean duration (s)')
xlim([0 17])


subplot(4,6,[21,22]) % SLEEP bouts number overtime
plot(nanmean(data_num_SLEEP_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_SLEEP_ctrl), stdError(data_num_SLEEP_ctrl),'color',col_ctrl)
plot(nanmean(data_num_SLEEP_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_SLEEP_SD), stdError(data_num_SLEEP_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9 11 13 15]); xticklabels({'10','11','12','13','14','15','16','17'})
makepretty
ylabel('SLEEP #')
xlim([0 17])



subplot(4,6,[23,24]) % REM bouts number overtime
plot(nanmean(data_num_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_REM_ctrl), stdError(data_num_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9 11 13 15]); xticklabels({'10','11','12','13','14','15','16','17'})
makepretty
ylabel('REM #')
xlim([0 17])





%% bar plot 4 experimental groups + 3 periodes de quantif
figure, hold on
subplot(4,6,[7,8]) % WAKE percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('Wake percentage')
makepretty

% %%version ranksum
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2),nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


%%version ttest
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2),nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[9,10]) %Sleep percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SLEEP percentage')
makepretty

% %%version ranksum
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_ctrl,2),nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_ctrl,2),nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_ctrl,2),nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


%%version ttest
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_ctrl,2),nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_ctrl,2),nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_ctrl,2),nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end





subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('REM percentage')
makepretty

% %%version ranksum
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2),nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


%%version ttest
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2),nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end





subplot(4,6,[15,16]) % sleep bouts mean duration quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SLEEP durentage')
makepretty

% %%version ranksum
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_ctrl,2),nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_ctrl,2),nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_ctrl,2),nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


%%version ttest
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_ctrl,2),nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_ctrl,2),nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_ctrl,2),nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end







subplot(4,6,[17,18]) % REM bouts mean duration quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('REM durentage')
makepretty

% %%version ranksum
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2),nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
%
% [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
% [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
% [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
% [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
% [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
% [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
% if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
% if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
% if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


%%version ttest
[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2),nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

[h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
[h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
[h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
[h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
[h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
[h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end







%% bar plot all states 4 groups and 3 periods

figure, hold on
subplot(4,6,[1,2]) % WAKE percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('Wake percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2),nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2),nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,6,[7,8]) % SLEEP percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SLEEP percentage')
makepretty

if isparam==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_ctrl,2),nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_ctrl,2),nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_ctrl,2),nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_ctrl,2),nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_ctrl,2),nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_ctrl,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_SD,2), nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_ctrl,2),nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,6,[13,14]) % SWS percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SWS percentage')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_ctrl,2),nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_ctrl,2),nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[19,20]) % REM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('REM percentage')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2),nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2),nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[3,4]) % WAKE numentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('Wake num')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_1_3h_ctrl,2),nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_ctrl,2),nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2),nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_ctrl,2),nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[9,10]) % SLEEP numentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_SLEEP_interPeriod_ctrl,2), nanmean(data_num_SLEEP_interPeriod_SD,2), nanmean(data_num_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SLEEP_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SLEEP num')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SLEEP_1_3h_ctrl,2),nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SLEEP_interPeriod_ctrl,2), nanmean(data_num_SLEEP_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SLEEP_interPeriod_ctrl,2),nanmean(data_num_SLEEP_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SLEEP_interPeriod_SD,2), nanmean(data_num_SLEEP_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SLEEP_interPeriod_ctrl,2), nanmean(data_num_SLEEP_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SLEEP_interPeriod_SD,2), nanmean(data_num_SLEEP_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SLEEP_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SLEEP_3_end_ctrl,2),nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SLEEP_1_3h_ctrl,2),nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SLEEP_interPeriod_ctrl,2), nanmean(data_num_SLEEP_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SLEEP_interPeriod_ctrl,2),nanmean(data_num_SLEEP_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SLEEP_interPeriod_SD,2), nanmean(data_num_SLEEP_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SLEEP_interPeriod_ctrl,2), nanmean(data_num_SLEEP_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SLEEP_interPeriod_SD,2), nanmean(data_num_SLEEP_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SLEEP_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SLEEP_3_end_ctrl,2),nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[15,16]) % SWS numentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SWS num')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_1_3h_ctrl,2),nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_ctrl,2),nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_3_end_ctrl,2),nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_3_end_SD_mCherry_cno,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2),nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_interPeriod_ctrl,2),nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2),nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_3_end_SD_mCherry_cno,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[21,22]) % REM numentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('REM num')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_1_3h_ctrl,2),nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_1_3h_SD_mCherry_cno,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_ctrl,2),nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_3_end_ctrl,2),nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_3_end_SD_mCherry_cno,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_1_3h_ctrl,2),nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_1_3h_SD_mCherry_cno,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_interPeriod_ctrl,2),nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_3_end_ctrl,2),nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_3_end_SD_mCherry_cno,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[5,6]) % WAKE durentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('Wake dur')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_1_3h_ctrl,2),nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_ctrl,2),nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_3_end_ctrl,2),nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2),nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_ctrl,2),nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2),nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[11,12]) % SLEEP durentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SLEEP dur')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_ctrl,2),nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_ctrl,2),nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_ctrl,2),nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_ctrl,2),nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_ctrl,2),nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_ctrl,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_SD,2), nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_ctrl,2),nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[17,18]) % SWS durentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SWS dur')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_1_3h_ctrl,2),nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_ctrl,2),nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_3_end_ctrl,2),nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2),nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_ctrl,2),nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2),nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[23,24]) % REM durentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('REM dur')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2),nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2),nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end



%%


%%
figure
    subplot(4,7,1,'align')
PlotErrorBarN_MC({(num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100,...
    (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100,...
    (num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100,...
    (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('Short REM percentage')

[p_1_2 ,h_1_2] = ranksum((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100);
[p_1_3, h_1_3] = ranksum((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100);
[p_1_4 ,h_1_4] = ranksum((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_2_3, h_2_3] = ranksum((num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100);
[p_2_4, h_2_4] = ranksum((num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_3_4, h_3_4] = ranksum((num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);

% [h_1_2 ,p_1_2] = ttest2((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100);
% [h_1_3, p_1_3] = ttest2((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100);
% [h_1_4 ,p_1_4] = ttest2((num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
% [h_2_3, p_2_3] = ttest2((num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100);
% [h_2_4, p_2_4] = ttest2((num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);
% [h_3_4, p_3_4] = ttest2((num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100);

% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end


p_values = [p_1_2 p_1_3 p_1_4 p_2_3 p_2_4 p_3_4];
[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);

if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
if adj_p(4)<0.05; sigstar_MC({[2 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
if adj_p(5)<0.05; sigstar_MC({[2 4]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end





    subplot(4,7,3,'align')
PlotErrorBarN_MC({(num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100,...
    (num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100,...
    (num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100,...
    (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('long REM percentage')

[p_1_2 ,h_1_2] = ranksum((num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100);
[p_1_3, h_1_3] = ranksum((num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100);
[p_1_4 ,h_1_4] = ranksum((num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_2_3, h_2_3] = ranksum((num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100);
[p_2_4, h_2_4] = ranksum((num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_3_4, h_3_4] = ranksum((num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);

% [h_1_2 ,p_1_2] = ttest2((num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100);
% [h_1_3, p_1_3] = ttest2((num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100);
% [h_1_4 ,p_1_4] = ttest2((num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
% [h_2_3, p_2_3] = ttest2((num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100);
% [h_2_4, p_2_4] = ttest2((num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
% [h_3_4, p_3_4] = ttest2((num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);

% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end

p_values = [p_1_2 p_1_3 p_1_4 p_2_3 p_2_4 p_3_4];
[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);

if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
if adj_p(4)<0.05; sigstar_MC({[2 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
if adj_p(5)<0.05; sigstar_MC({[2 4]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end



    subplot(4,7,2,'align')
PlotErrorBarN_MC({(num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100,...
    (num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100,...
    (num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100,...
    (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');
ylabel('mid REM percentage')

[p_1_2 ,h_1_2] = ranksum((num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100);
[p_1_3, h_1_3] = ranksum((num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100);
[p_1_4 ,h_1_4] = ranksum((num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_2_3, h_2_3] = ranksum((num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100);
[p_2_4, h_2_4] = ranksum((num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
[p_3_4, h_3_4] = ranksum((num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);

% 
% [h_1_2 ,p_1_2] = ttest2((num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100);
% [h_1_3, p_1_3] = ttest2((num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100);
% [h_1_4 ,p_1_4] = ttest2((num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100, (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
% [h_2_3, p_2_3] = ttest2((num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100);
% [h_2_4, p_2_4] = ttest2((num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100, (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);
% [h_3_4, p_3_4] = ttest2((num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100, (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100);

% if p_1_2<0.05; sigstar_MC({[1 2]},p_1_2,0,'LineWigth',16,'StarSize',24);end
% if p_1_3<0.05; sigstar_MC({[1 3]},p_1_3,0,'LineWigth',16,'StarSize',24);end
% if p_1_4<0.05; sigstar_MC({[1 4]},p_1_4,0,'LineWigth',16,'StarSize',24);end
% if p_2_3<0.05; sigstar_MC({[2 3]},p_2_3,0,'LineWigth',16,'StarSize',24);end
% if p_2_4<0.05; sigstar_MC({[2 4]},p_2_4,0,'LineWigth',16,'StarSize',24);end
% if p_3_4<0.05; sigstar_MC({[3 4]},p_3_4,0,'LineWigth',16,'StarSize',24);end


p_values = [p_1_2 p_1_3 p_1_4 p_2_3 p_2_4 p_3_4];
[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);

if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
if adj_p(4)<0.05; sigstar_MC({[2 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
if adj_p(5)<0.05; sigstar_MC({[2 4]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end


%%


%% CHECK QUANTIF
%
% col_ctrl = [.7 .7 .7];
% col_SD = [1 .4 0];
%
% figure
% subplot(5,2,5)
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     hold on
% plot(data_dur_tot_WAKE_SD(i,:),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% end
%
% % figure
% for i=1:length(Dir_ctrl.path)
%     hold on
% plot(data_dur_tot_WAKE_ctrl(i,:),'linestyle','-','marker','^','markerfacecolor',col_ctrl,'markersize',8,'color',col_ctrl)
% end
% makepretty
% xlim([0 9])
%
%
%
% subplot(5,2,6)
% plot(nanmean(data_dur_tot_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
% errorbar(nanmean(data_dur_tot_WAKE_ctrl), stdError(data_dur_tot_WAKE_ctrl),'color',col_ctrl)
% plot(nanmean(data_dur_tot_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% errorbar(nanmean(data_dur_tot_WAKE_SD), stdError(data_dur_tot_WAKE_SD),'linestyle','-','color',col_SD)
% xlim([0 8.5])
% xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
% makepretty
% ylabel('Wake dur total')
%
%
% subplot(5,2,7)
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     hold on
% plot(data_perc_WAKE_SD(i,:),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% end
%
% % figure
% for i=1:length(Dir_ctrl.path)
%     hold on
% plot(data_perc_WAKE_ctrl(i,:),'linestyle','-','marker','^','markerfacecolor',col_ctrl,'markersize',8,'color',col_ctrl)
% end
% makepretty
% xlim([0 9])
%
%
%
% subplot(5,2,8)
% plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
% errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_ctrl)
% plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'linestyle','-','color',col_SD)
% xlim([0 8.5])
% xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
% makepretty
% ylabel('Wake perc')
%
%
%
%
% subplot(5,2,9)
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     hold on
% plot(data_num_WAKE_SD(i,:) .* data_dur_WAKE_SD(i,:),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% end
%
% % figure
% for i=1:length(Dir_ctrl.path)
%     hold on
% plot(data_num_WAKE_ctrl(i,:) .* data_dur_WAKE_ctrl(i,:),'linestyle','-','marker','^','markerfacecolor',col_ctrl,'markersize',8,'color',col_ctrl)
% end
% makepretty
% xlim([0 9])
%
%
%
% subplot(5,2,10)
% plot(nanmean(data_dur_WAKE_ctrl .* data_num_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
% errorbar(nanmean(data_dur_WAKE_ctrl .* data_num_WAKE_ctrl), stdError(data_dur_WAKE_ctrl .* data_num_WAKE_ctrl),'color',col_ctrl)
% plot(nanmean(data_dur_WAKE_SD .* data_num_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% errorbar(nanmean(data_dur_WAKE_SD .* data_num_WAKE_SD), stdError(data_dur_WAKE_SD .* data_num_WAKE_SD),'linestyle','-','color',col_SD)
% xlim([0 8.5])
% xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
% makepretty
% ylabel('Wake num*dur')
%
%
%
%
% subplot(5,2,1)
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     hold on
% plot(data_num_WAKE_SD(i,:),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% end
% for i=1:length(Dir_ctrl.path)
%     hold on
% plot(data_num_WAKE_ctrl(i,:),'linestyle','-','marker','^','markerfacecolor',col_ctrl,'markersize',8,'color',col_ctrl)
% end
% makepretty
% xlim([0 9])
%
% subplot(5,2,2)
% plot(nanmean(data_num_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
% errorbar(nanmean(data_num_WAKE_ctrl), stdError(data_num_WAKE_ctrl),'color',col_ctrl)
% plot(nanmean(data_num_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% errorbar(nanmean(data_num_WAKE_SD), stdError(data_num_WAKE_SD),'linestyle','-','color',col_SD)
% xlim([0 8.5])
% xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
% makepretty
% ylabel('Wake num')
%
%
%
% subplot(5,2,3)
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     hold on
% plot(data_dur_WAKE_SD(i,:),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% end
% for i=1:length(Dir_ctrl.path)
%     hold on
% plot(data_dur_WAKE_ctrl(i,:),'linestyle','-','marker','^','markerfacecolor',col_ctrl,'markersize',8,'color',col_ctrl)
% end
% makepretty
% xlim([0 9])
%
%
%
% subplot(5,2,4)
% plot(nanmean(data_dur_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
% errorbar(nanmean(data_dur_WAKE_ctrl), stdError(data_dur_WAKE_ctrl),'color',col_ctrl)
% plot(nanmean(data_dur_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% errorbar(nanmean(data_dur_WAKE_SD), stdError(data_dur_WAKE_SD),'linestyle','-','color',col_SD)
% xlim([0 8.5])
% xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
% makepretty
% ylabel('Wake dur')
%
%
%
%
%
%
% %%
%
%
% figure
% plot(nanmean(data_perc_WAKE_ctrl+data_perc_SWS_ctrl+data_perc_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
% errorbar(nanmean(data_perc_WAKE_ctrl+data_perc_SWS_ctrl+data_perc_REM_ctrl), stdError(data_perc_WAKE_ctrl+data_perc_SWS_ctrl+data_perc_REM_ctrl),'color',col_ctrl)
% plot(nanmean(data_perc_WAKE_SD+data_perc_SWS_SD+data_perc_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% errorbar(nanmean(data_perc_WAKE_SD+data_perc_SWS_SD+data_perc_REM_SD), stdError(data_perc_WAKE_SD+data_perc_SWS_SD+data_perc_REM_SD),'linestyle','-','color',col_SD)
% xlim([0 8.5])
% xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
% makepretty
%
%
% %%
%
% figure
% for i=1:length(DirSocialDefeat_sleepPost_classic.path)
%     hold on
% plot(data_perc_WAKE_SD(i,:)+data_perc_SWS_SD(i,:)+data_perc_REM_SD(i,:),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
% end
%
% % figure
% for i=1:length(Dir_ctrl.path)
%     hold on
% plot(data_perc_WAKE_ctrl(i,:)+data_perc_SWS_ctrl(i,:)+data_perc_REM_ctrl(i,:),'linestyle','-','marker','^','markerfacecolor',col_ctrl,'markersize',8,'color',col_ctrl)
% end
% makepretty
% xlim([0 9])
% title('individual mouse')


%%




col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];

isparam = 0; %%use parametric test
iscorr = 1; %%show corrected pvalues

figure, hold on
subplot(4,6,[7,8],'align') % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 120])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('Wake percentage')
xlabel('Time after stress (h)')
%%stats wake perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_WAKE_ctrl(:,1), data_perc_WAKE_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_WAKE_ctrl(:,2), data_perc_WAKE_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_WAKE_ctrl(:,3), data_perc_WAKE_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_WAKE_ctrl(:,4), data_perc_WAKE_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_WAKE_ctrl(:,5), data_perc_WAKE_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_WAKE_ctrl(:,6), data_perc_WAKE_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_WAKE_ctrl(:,7), data_perc_WAKE_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_WAKE_ctrl(:,8), data_perc_WAKE_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_WAKE_ctrl(:,1), data_perc_WAKE_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_WAKE_ctrl(:,2), data_perc_WAKE_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_WAKE_ctrl(:,3), data_perc_WAKE_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_WAKE_ctrl(:,4), data_perc_WAKE_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_WAKE_ctrl(:,5), data_perc_WAKE_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_WAKE_ctrl(:,6), data_perc_WAKE_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_WAKE_ctrl(:,7), data_perc_WAKE_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_WAKE_ctrl(:,8), data_perc_WAKE_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[9,10],'align'), hold on
plot(nanmean(data_perc_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_SWS_ctrl), stdError(data_perc_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 80])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('NREM percentage')
xlabel('Time after stress (h)')

%%stats all SWS perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_SWS_ctrl(:,1), data_perc_SWS_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_SWS_ctrl(:,2), data_perc_SWS_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_SWS_ctrl(:,3), data_perc_SWS_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_SWS_ctrl(:,4), data_perc_SWS_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_SWS_ctrl(:,5), data_perc_SWS_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_SWS_ctrl(:,6), data_perc_SWS_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_SWS_ctrl(:,7), data_perc_SWS_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_SWS_ctrl(:,8), data_perc_SWS_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_SWS_ctrl(:,1), data_perc_SWS_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_SWS_ctrl(:,2), data_perc_SWS_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_SWS_ctrl(:,3), data_perc_SWS_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_SWS_ctrl(:,4), data_perc_SWS_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_SWS_ctrl(:,5), data_perc_SWS_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_SWS_ctrl(:,6), data_perc_SWS_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_SWS_ctrl(:,7), data_perc_SWS_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_SWS_ctrl(:,8), data_perc_SWS_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


subplot(4,6,[11,12],'align') %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 15])

xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('REM percentage')
xlabel('Time after stress (h)')

%%stats all REM perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_REM_ctrl(:,1), data_perc_REM_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_REM_ctrl(:,2), data_perc_REM_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_REM_ctrl(:,3), data_perc_REM_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_REM_ctrl(:,4), data_perc_REM_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_REM_ctrl(:,5), data_perc_REM_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_REM_ctrl(:,6), data_perc_REM_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_REM_ctrl(:,7), data_perc_REM_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_REM_ctrl(:,8), data_perc_REM_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_REM_ctrl(:,1), data_perc_REM_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_REM_ctrl(:,2), data_perc_REM_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_REM_ctrl(:,3), data_perc_REM_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_REM_ctrl(:,4), data_perc_REM_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_REM_ctrl(:,5), data_perc_REM_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_REM_ctrl(:,6), data_perc_REM_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_REM_ctrl(:,7), data_perc_REM_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_REM_ctrl(:,8), data_perc_REM_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end




subplot(4,6,[13,14],'align') %REM numentage overtime
plot(nanmean(data_num_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_REM_ctrl), stdError(data_num_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 10])

xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('REM bouts number')
xlabel('Time after stress (h)')

%%stats REM num overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_num_REM_ctrl(:,1), data_num_REM_SD(:,1));
    [p_2,h_2] = ranksum(data_num_REM_ctrl(:,2), data_num_REM_SD(:,2));
    [p_3,h_3] = ranksum(data_num_REM_ctrl(:,3), data_num_REM_SD(:,3));
    [p_4,h_4] = ranksum(data_num_REM_ctrl(:,4), data_num_REM_SD(:,4));
    [p_5,h_5] = ranksum(data_num_REM_ctrl(:,5), data_num_REM_SD(:,5));
    [p_6,h_6] = ranksum(data_num_REM_ctrl(:,6), data_num_REM_SD(:,6));
    [p_7,h_7] = ranksum(data_num_REM_ctrl(:,7), data_num_REM_SD(:,7));
    [p_8,h_8] = ranksum(data_num_REM_ctrl(:,8), data_num_REM_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_REM_ctrl(:,1), data_num_REM_SD(:,1));
    [h_2,p_2] = ttest2(data_num_REM_ctrl(:,2), data_num_REM_SD(:,2));
    [h_3,p_3] = ttest2(data_num_REM_ctrl(:,3), data_num_REM_SD(:,3));
    [h_4,p_4] = ttest2(data_num_REM_ctrl(:,4), data_num_REM_SD(:,4));
    [h_5,p_5] = ttest2(data_num_REM_ctrl(:,5), data_num_REM_SD(:,5));
    [h_6,p_6] = ttest2(data_num_REM_ctrl(:,6), data_num_REM_SD(:,6));
    [h_7,p_7] = ttest2(data_num_REM_ctrl(:,7), data_num_REM_SD(:,7));
    [h_8,p_8] = ttest2(data_num_REM_ctrl(:,8), data_num_REM_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end



subplot(4,6,[15,16],'align') %REM durentage overtime
plot(nanmean(data_dur_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_REM_ctrl), stdError(data_dur_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 120])

xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('REM bouts mean duration (s)')
xlabel('Time after stress (h)')

%%stats REM dur overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_dur_REM_ctrl(:,1), data_dur_REM_SD(:,1));
    [p_2,h_2] = ranksum(data_dur_REM_ctrl(:,2), data_dur_REM_SD(:,2));
    [p_3,h_3] = ranksum(data_dur_REM_ctrl(:,3), data_dur_REM_SD(:,3));
    [p_4,h_4] = ranksum(data_dur_REM_ctrl(:,4), data_dur_REM_SD(:,4));
    [p_5,h_5] = ranksum(data_dur_REM_ctrl(:,5), data_dur_REM_SD(:,5));
    [p_6,h_6] = ranksum(data_dur_REM_ctrl(:,6), data_dur_REM_SD(:,6));
    [p_7,h_7] = ranksum(data_dur_REM_ctrl(:,7), data_dur_REM_SD(:,7));
    [p_8,h_8] = ranksum(data_dur_REM_ctrl(:,8), data_dur_REM_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_REM_ctrl(:,1), data_dur_REM_SD(:,1));
    [h_2,p_2] = ttest2(data_dur_REM_ctrl(:,2), data_dur_REM_SD(:,2));
    [h_3,p_3] = ttest2(data_dur_REM_ctrl(:,3), data_dur_REM_SD(:,3));
    [h_4,p_4] = ttest2(data_dur_REM_ctrl(:,4), data_dur_REM_SD(:,4));
    [h_5,p_5] = ttest2(data_dur_REM_ctrl(:,5), data_dur_REM_SD(:,5));
    [h_6,p_6] = ttest2(data_dur_REM_ctrl(:,6), data_dur_REM_SD(:,6));
    [h_7,p_7] = ttest2(data_dur_REM_ctrl(:,7), data_dur_REM_SD(:,7));
    [h_8,p_8] = ttest2(data_dur_REM_ctrl(:,8), data_dur_REM_SD(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


%%

isparam=0;
iscorr=1;

figure, hold on
subplot(4,6,[1,2]) % WAKE percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('Wake percentage')
makepretty

if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,6,[7,8]) % SLEEP percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('SLEEP percentage')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SLEEP_1_3h_ctrl,2),nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SLEEP_3_end_ctrl,2),nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SLEEP_1_3h_ctrl,2),nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_SLEEP_1_3h_ctrl,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_SLEEP_1_3h_SD,2), nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SLEEP_3_end_ctrl,2),nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_SLEEP_3_end_ctrl,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_SLEEP_3_end_SD,2), nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_perc_SLEEP_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,6,[13,14]) % SWS percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('SWS percentage')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,6,[19,20]) % REM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('REM percentage')
makepretty

if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[3,4]) % WAKE numentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('Wake num')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_WAKE_1_3h_ctrl,2),nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2),nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,6,[9,10]) % SLEEP numentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('SLEEP num')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_SLEEP_1_3h_ctrl,2),nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_SLEEP_3_end_ctrl,2),nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_num_SLEEP_1_3h_ctrl,2),nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_num_SLEEP_1_3h_ctrl,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_num_SLEEP_1_3h_SD,2), nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_num_SLEEP_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_num_SLEEP_3_end_ctrl,2),nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_num_SLEEP_3_end_ctrl,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_num_SLEEP_3_end_SD,2), nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_num_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_num_SLEEP_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,6,[15,16]) % SWS numentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('SWS num')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_SWS_1_3h_ctrl,2),nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_SWS_3_end_ctrl,2),nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_SWS_3_end_SD_mCherry_cno,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2),nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_num_SWS_1_3h_SD,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_num_SWS_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2),nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_num_SWS_3_end_SD,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_num_SWS_3_end_SD_mCherry_cno,2), nanmean(data_num_SWS_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,6,[21,22]) % REM numentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('REM num')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_ctrl,2),nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_SD_mCherry_cno,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_ctrl,2),nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_SD_mCherry_cno,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_1_3h_ctrl,2),nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_1_3h_SD_mCherry_cno,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_3_end_ctrl,2),nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_3_end_SD_mCherry_cno,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,6,[5,6]) % WAKE durentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('Wake dur')
makepretty

if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_WAKE_1_3h_ctrl,2),nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_WAKE_3_end_ctrl,2),nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2),nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2),nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,6,[11,12]) % SLEEP durentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('SLEEP dur')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_SLEEP_1_3h_ctrl,2),nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_SLEEP_3_end_ctrl,2),nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_SLEEP_1_3h_ctrl,2),nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_dur_SLEEP_1_3h_ctrl,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_dur_SLEEP_1_3h_SD,2), nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_SLEEP_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_SLEEP_3_end_ctrl,2),nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_dur_SLEEP_3_end_ctrl,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_dur_SLEEP_3_end_SD,2), nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_SLEEP_3_end_SD_mCherry_cno,2), nanmean(data_dur_SLEEP_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end




subplot(4,6,[17,18]) % SWS durentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('SWS dur')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_1_3h_ctrl,2),nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_SWS_3_end_ctrl,2),nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2),nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_dur_SWS_1_3h_SD,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_dur_SWS_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2),nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_dur_SWS_3_end_SD,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end




subplot(4,6,[23,24]) % REM durentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('REM dur')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
    if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
    
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
    if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
else
end






%% FIGURE 2 PAPIER (new version)

figure
isparam=1;
iscorr=1;


subplot(4,7,[15,16],'align') %WAKE percentage
PlotErrorBarN_MC({...
    nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('Wake percentage')
makepretty
ylim([0 130])

if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
%     p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
%     [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
%     if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',12);end
%     if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
%     
%     p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
%     [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
%     if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,7,[17,18],'align') %SWS percentage
PlotErrorBarN_MC({...
    nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('SWS percentage')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
%     p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
%     [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
%     if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
%     
%     p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
%     [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
%     if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end

    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end
    
    
else
end


subplot(4,7,[19,20],'align') %REM percentage
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('REM percentage')
makepretty

if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
%     p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
%     [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
%     if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
%     
%     p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
%     [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
%     if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end

    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
   
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end
    
    
else
end





subplot(4,7,[22,23],'align') %REM bouts number
PlotErrorBarN_MC({...
    nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('REM num')
makepretty


if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_ctrl,2),nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_1_3h_SD_mCherry_cno,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_ctrl,2),nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_3_end_SD_mCherry_cno,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_1_3h_ctrl,2),nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_num_REM_1_3h_ctrl,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_num_REM_1_3h_SD,2), nanmean(data_num_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_1_3h_SD_mCherry_cno,2), nanmean(data_num_REM_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_3_end_ctrl,2),nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_num_REM_3_end_ctrl,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_num_REM_3_end_SD,2), nanmean(data_num_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_3_end_SD_mCherry_cno,2), nanmean(data_num_REM_3_end_SD_dreadd_cno,2));
else
end

if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
%     p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
%     [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
%     if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
%     
%     p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
%     [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
%     if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end

    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',12);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end
    
else
end



subplot(4,7,[24,25],'align') % REM bouts mean duration
PlotErrorBarN_MC({...
    nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno});
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('REM dur')
makepretty
%%test stats
if isparam==0 %%version ranksum
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    
elseif isparam==1 % %%version ttest
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2),nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_ctrl,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_SD,2), nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_1_3h_SD_mCherry_cno,2), nanmean(data_dur_REM_1_3h_SD_dreadd_cno,2));
    
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2),nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_dur_REM_3_end_ctrl,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_dur_REM_3_end_SD,2), nanmean(data_dur_REM_3_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_3_end_SD_mCherry_cno,2), nanmean(data_dur_REM_3_end_SD_dreadd_cno,2));
else
end
%%correction for multiple comparison
if iscorr==0
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end

elseif iscorr==1
%     p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
%     [h_1, crit_p_1, adj_ci_cvrg_1, adj_p_1] = fdr_bh(p_values);
%     if adj_p_1(1)<0.05; sigstar_MC({[1 2]},adj_p_1(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(2)<0.05; sigstar_MC({[1 4]},adj_p_1(2),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(3)<0.05; sigstar_MC({[2 4]},adj_p_1(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(4)<0.05; sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p_1(4),0,'LineWigth',16,'StarSize',12);end
%     if adj_p_1(5)<0.05; sigstar_MC({[2 3]},adj_p_1(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_1(6)<0.05; sigstar_MC({[3 4]},adj_p_1(6),0,'LineWigth',16,'StarSize',24);end
%     
%     p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
%     [h_2, crit_p_2, adj_ci_cvrg_2, adj_p_2] = fdr_bh(p_values);
%     if adj_p_2(1)<0.05; sigstar_MC({[6 7]},adj_p_2(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(2)<0.05; sigstar_MC({[6 9]},adj_p_2(2),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(3)<0.05; sigstar_MC({[7 9]},adj_p_2(3),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(4)<0.05; sigstar_MC({[6 8]},adj_p_2(4),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(5)<0.05; sigstar_MC({[7 8]},adj_p_2(5),0,'LineWigth',16,'StarSize',24);end
%     if adj_p_2(6)<0.05; sigstar_MC({[8 9]},adj_p_2(6),0,'LineWigth',16,'StarSize',24);end
    
    
    
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end
    
    
    
else
end


%%
short_long_ctrl = [(num_moyen_rem_short_ctrl_1./sum(data_num_REM_ctrl,2)')*100; (num_moyen_rem_mid_ctrl./sum(data_num_REM_ctrl,2)')*100; (num_moyen_rem_long_ctrl./sum(data_num_REM_ctrl,2)')*100]';
short_long_SD = [(num_moyen_rem_short_SD_1./sum(data_num_REM_SD,2)')*100; (num_moyen_rem_mid_SD./sum(data_num_REM_SD,2)')*100; (num_moyen_rem_long_SD./sum(data_num_REM_SD,2)')*100]';
short_long_SD_mCherry_cno = [(num_moyen_rem_short_SD_mCherry_cno_1./sum(data_num_REM_SD_mCherry_cno,2)')*100; (num_moyen_rem_mid_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100; (num_moyen_rem_long_SD_mCherry_cno./sum(data_num_REM_SD_mCherry_cno,2)')*100]';
short_long_SD_dreadd_cno = [(num_moyen_rem_short_SD_dreadd_cno_1./sum(data_num_REM_SD_dreadd_cno,2)')*100; (num_moyen_rem_mid_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100; (num_moyen_rem_long_SD_dreadd_cno./sum(data_num_REM_SD_dreadd_cno,2)')*100]';








%% figure

col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];
col_mCherry_cno = [1 .2 0];
col_dreadd_cno = [0 .4 .4];


figure, hold on

plot([nanmean(short_long_ctrl(:,1)),nanmean(short_long_ctrl(:,2)),nanmean(short_long_ctrl(:,3))],'o-','color',col_ctrl)
errorbar([nanmean(short_long_ctrl(:,1)),nanmean(short_long_ctrl(:,2)),nanmean(short_long_ctrl(:,3))], stdError([(short_long_ctrl(:,1)),(short_long_ctrl(:,2)),(short_long_ctrl(:,3))]),'color',col_ctrl)



plot([nanmean(short_long_SD(:,1)),nanmean(short_long_SD(:,2)),nanmean(short_long_SD(:,3))],'o-','color',col_SD)
errorbar([nanmean(short_long_SD(:,1)),nanmean(short_long_SD(:,2)),nanmean(short_long_SD(:,3))], stdError([(short_long_SD(:,1)),(short_long_SD(:,2)),(short_long_SD(:,3))]),'color',col_SD)



plot([nanmean(short_long_SD_mCherry_cno(:,1)),nanmean(short_long_SD_mCherry_cno(:,2)),nanmean(short_long_SD_mCherry_cno(:,3))],'o-','color',col_mCherry_cno)
errorbar([nanmean(short_long_SD_mCherry_cno(:,1)),nanmean(short_long_SD_mCherry_cno(:,2)),nanmean(short_long_SD_mCherry_cno(:,3))], stdError([(short_long_SD_mCherry_cno(:,1)),(short_long_SD_mCherry_cno(:,2)),(short_long_SD_mCherry_cno(:,3))]),'color',col_mCherry_cno)




plot([nanmean(short_long_SD_dreadd_cno(:,1)),nanmean(short_long_SD_dreadd_cno(:,2)),nanmean(short_long_SD_dreadd_cno(:,3))],'o-','color',col_dreadd_cno)
errorbar([nanmean(short_long_SD_dreadd_cno(:,1)),nanmean(short_long_SD_dreadd_cno(:,2)),nanmean(short_long_SD_dreadd_cno(:,3))], stdError([(short_long_SD_dreadd_cno(:,1)),(short_long_SD_dreadd_cno(:,2)),(short_long_SD_dreadd_cno(:,3))]),'color',col_dreadd_cno)

makepretty



%%


    [p_1,h_1] = ranksum(data_perc_WAKE_ctrl(:,1), data_perc_WAKE_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_WAKE_ctrl(:,2), data_perc_WAKE_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_WAKE_ctrl(:,3), data_perc_WAKE_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_WAKE_ctrl(:,4), data_perc_WAKE_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_WAKE_ctrl(:,5), data_perc_WAKE_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_WAKE_ctrl(:,6), data_perc_WAKE_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_WAKE_ctrl(:,7), data_perc_WAKE_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_WAKE_ctrl(:,8), data_perc_WAKE_SD(:,8));
    [p_9,h_9] = ranksum(data_perc_WAKE_ctrl(:,9), data_perc_WAKE_SD(:,9));
    [p_10,h_10] = ranksum(data_perc_WAKE_ctrl(:,10), data_perc_WAKE_SD(:,10));
    [p_11,h_11] = ranksum(data_perc_WAKE_ctrl(:,11), data_perc_WAKE_SD(:,11));
    [p_12,h_12] = ranksum(data_perc_WAKE_ctrl(:,12), data_perc_WAKE_SD(:,12));
    [p_13,h_13] = ranksum(data_perc_WAKE_ctrl(:,13), data_perc_WAKE_SD(:,13));
    [p_14,h_14] = ranksum(data_perc_WAKE_ctrl(:,14), data_perc_WAKE_SD(:,14));
    [p_15,h_15] = ranksum(data_perc_WAKE_ctrl(:,15), data_perc_WAKE_SD(:,15));
    [p_16,h_16] = ranksum(data_perc_WAKE_ctrl(:,16), data_perc_WAKE_SD(:,16));
    
    
    
    
        p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8 p_9 p_10 p_11 p_12 p_13 p_14 p_15 p_16];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(9)<0.05; sigstar_MC({[8.8 9.2]},adj_p(9),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(10)<0.05; sigstar_MC({[9.8 10.2]},adj_p(10),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(11)<0.05; sigstar_MC({[10.8 11.2]},adj_p(11),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(12)<0.05; sigstar_MC({[11.8 12.2]},adj_p(12),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(13)<0.05; sigstar_MC({[12.8 13.2]},adj_p(13),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(14)<0.05; sigstar_MC({[13.8 14.2]},adj_p(14),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(15)<0.05; sigstar_MC({[14.8 15.2]},adj_p(15),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(16)<0.05; sigstar_MC({[15.8 16.2]},adj_p(16),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    
    
%%
figure
PlotErrorBarN_MC({data_REM_short_WAKE_3_end_ctrl,...
    data_REM_short_WAKE_3_end_SD,...
    data_REM_short_WAKE_3_end_SD_mCherry_cno,...
    data_REM_short_WAKE_3_end_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');

%%

figure
PlotErrorBarN_MC({data_REM_short_SWS_3_end_ctrl,...
    data_REM_short_SWS_3_end_SD,...
    data_REM_short_SWS_3_end_SD_mCherry_cno,...
    data_REM_short_SWS_3_end_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');


%%



figure
PlotErrorBarN_MC({data_REM_long_WAKE_3_end_ctrl,...
    data_REM_long_WAKE_3_end_SD,...
    data_REM_long_WAKE_3_end_SD_mCherry_cno,...
    data_REM_long_WAKE_3_end_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');

%%

figure
PlotErrorBarN_MC({data_REM_long_SWS_3_end_ctrl,...
    data_REM_long_SWS_3_end_SD,...
    data_REM_long_SWS_3_end_SD_mCherry_cno,...
    data_REM_long_SWS_3_end_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');




%%

figure
PlotErrorBarN_MC({data_REM_mid_WAKE_3_end_ctrl,...
    data_REM_mid_WAKE_3_end_SD,...
    data_REM_mid_WAKE_3_end_SD_mCherry_cno,...
    data_REM_mid_WAKE_3_end_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');

%%

figure
PlotErrorBarN_MC({data_REM_mid_SWS_3_end_ctrl,...
    data_REM_mid_SWS_3_end_SD,...
    data_REM_mid_SWS_3_end_SD_mCherry_cno,...
    data_REM_mid_SWS_3_end_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');








%%


figure
PlotErrorBarN_MC({data_REM_short_REM_3_end_ctrl,...
    data_REM_short_REM_3_end_SD,...
    data_REM_short_REM_3_end_SD_mCherry_cno,...
    data_REM_short_REM_3_end_SD_dreadd_cno},'newfig',0,'paired',0,'barcolors',{col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},'showsigstar','none');


