
%% input dir

%%1
DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_mCherry_saline = MergePathForExperiment(DirSocialDefeat_mCherry_saline1,DirSocialDefeat_BM_saline1);
Dir_SD_C57_sal = MergePathForExperiment(DirSocialDefeat_classic1,DirSocialDefeat_mCherry_saline);

%%2
DirSocialDefeat_totSleepPost_mCherry_cno1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');
DirSocialDefeat_totSleepPost_BM_cno1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
Dir_SD_C57_cno = MergePathForExperiment(DirSocialDefeat_totSleepPost_mCherry_cno1,DirSocialDefeat_totSleepPost_BM_cno1);

%%3
Dir_SD_CRH_sal = PathForExperiments_SleepPostSD_AD('SleepPostSD_mCherry_CRH_VLPO_SalineInjection_10am');

%%4
Dir_SD_CRH_cno = PathForExperiments_SleepPostSD_AD('SleepPostSD_mCherry_CRH_VLPO_CNOInjection_10am');


%%
%% parameters

tempbin = 3600; %bin size to plot variables overtime

time_st = 0*3600*1e4; %begining of the sleep session
time_end=3*1e8;  %end of the sleep session

time_mid_end_first_period = 1.5*3600*1e4; %1.5         %2 first hours (insomnia)
time_mid_begin_snd_period = 3.3*3600*1e4;%3.3           4 last hours(late pahse of the night)

lim_short_rem_1 = 25; %25 take all rem bouts shorter than limit
lim_short_rem_2 = 15;
lim_short_rem_3 = 20;

lim_long_rem = 25; %25 take all rem bouts longer than limit

mindurSWS = 60;
mindurREM = 25;

%% GET DATA - ctrl group (mCherry saline injection 10h without stress)

for i=1:length(Dir_SD_C57_sal.path)
    cd(Dir_SD_C57_sal.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_C57_sal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_C57_sal{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%Define different periods of time for quantifications
    same_epoch_all_sess_SD_C57_sal{i} = intervalSet(0,time_end); %all session
    same_epoch_begin_SD_C57_sal{i} = intervalSet(time_st,time_mid_begin_snd_period); %beginning of the session (period of insomnia)
    same_epoch_end_SD_C57_sal{i} = intervalSet(time_mid_begin_snd_period,time_end); %late phase of the session (rem frag)
    same_epoch_interPeriod_SD_C57_sal{i} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period); %inter period
    
    %%Compute percentage, mean duration, number of bouts overtime (over all session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_all_sess_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_all_sess_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_all_sess_SD_C57_sal{i}),'wake',tempbin,time_st,time_end);
    dur_WAKE_SD_C57_sal{i}=dur_moyenne_ep_WAKE;
    num_WAKE_SD_C57_sal{i}=num_moyen_ep_WAKE;
    perc_WAKE_SD_C57_sal{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_all_sess_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_all_sess_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_all_sess_SD_C57_sal{i}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_C57_sal{i}=dur_moyenne_ep_SWS;
    num_SWS_SD_C57_sal{i}=num_moyen_ep_SWS;
    perc_SWS_SD_C57_sal{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_all_sess_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_all_sess_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_all_sess_SD_C57_sal{i}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_C57_sal{i}=dur_moyenne_ep_REM;
    num_REM_SD_C57_sal{i}=num_moyen_ep_REM;
    perc_REM_SD_C57_sal{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_all_sess_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_all_sess_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_all_sess_SD_C57_sal{i}),'sleep',tempbin,time_st,time_end);
    dur_totSleepctrl{i}=dur_moyenne_ep_totSleep;
    num_totSleepctrl{i}=num_moyen_ep_totSleep;
    perc_totSleepctrl{i}=perc_moyen_totSleep;
    

    %%First period (beginning)
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_begin_SD_C57_sal{i}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_SD_C57_sal{i}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_SD_C57_sal{i}=num_moyen_ep_WAKE;
    perc_WAKE_begin_SD_C57_sal{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_begin_SD_C57_sal{i}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_SD_C57_sal{i}=dur_moyenne_ep_SWS;
    num_SWS_begin_SD_C57_sal{i}=num_moyen_ep_SWS;
    perc_SWS_begin_SD_C57_sal{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_begin_SD_C57_sal{i}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_SD_C57_sal{i}=dur_moyenne_ep_REM;
    num_REM_begin_SD_C57_sal{i}=num_moyen_ep_REM;
    perc_REM_begin_SD_C57_sal{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_begin_SD_C57_sal{i}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_SD_C57_sal{i}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_SD_C57_sal{i}=num_moyen_ep_totSleep;
    perc_totSleep_begin_SD_C57_sal{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_sal{i}.Wake,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_begin_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_begin_SD_C57_sal{i}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_SD_C57_sal{i} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_SD_C57_sal{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_SD_C57_sal{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_SD_C57_sal{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_SD_C57_sal{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_SD_C57_sal{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_SD_C57_sal{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_SD_C57_sal{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_SD_C57_sal{i} = trans_WAKE_to_WAKE;
    
    
    
    %%Inter period (middle part of the session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_interPeriod_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_interPeriod_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_interPeriod_SD_C57_sal{i}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_SD_C57_sal{i}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD_C57_sal{i}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD_C57_sal{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_interPeriod_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_interPeriod_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_interPeriod_SD_C57_sal{i}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_SD_C57_sal{i}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD_C57_sal{i}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD_C57_sal{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_interPeriod_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_interPeriod_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_interPeriod_SD_C57_sal{i}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_SD_C57_sal{i}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD_C57_sal{i}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD_C57_sal{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_interPeriod_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_interPeriod_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_interPeriod_SD_C57_sal{i}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_SD_C57_sal{i}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_SD_C57_sal{i}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_SD_C57_sal{i}=perc_moyen_totSleep;
    
    
    
    %%Late period of the session
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_SD_C57_sal{i}=dur_moyenne_ep_WAKE;
    num_WAKE_end_SD_C57_sal{i}=num_moyen_ep_WAKE;
    perc_WAKE_end_SD_C57_sal{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_SD_C57_sal{i}=dur_moyenne_ep_SWS;
    num_SWS_end_SD_C57_sal{i}=num_moyen_ep_SWS;
    perc_SWS_end_SD_C57_sal{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_SD_C57_sal{i}=dur_moyenne_ep_REM;
    num_REM_end_SD_C57_sal{i}=num_moyen_ep_REM;
    perc_REM_end_SD_C57_sal{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_sal{i}.Wake,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_SD_C57_sal{i}=dur_moyenne_ep_totSleep;
    num_totSleep_end_SD_C57_sal{i}=num_moyen_ep_totSleep;
    perc_totSleep_end_SD_C57_sal{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_sal{i}.Wake,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_SD_C57_sal{i} = trans_REM_to_REM;
    all_trans_REM_SWS_end_SD_C57_sal{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_SD_C57_sal{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_SD_C57_sal{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_SD_C57_sal{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_SD_C57_sal{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_SD_C57_sal{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_SD_C57_sal{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_SD_C57_sal{i} = trans_WAKE_to_WAKE;
    
    
   
    %%Short versus long REM bouts during late period
    [dur_WAKE_SD_C57_sal_bis{i}, durT_WAKE_SD_C57_sal(i)]=DurationEpoch(and(stages_SD_C57_sal{i}.Wake,same_epoch_end_SD_C57_sal{i}),'s');
    [dur_SWS_SD_C57_sal_bis{i}, durT_SWS_SD_C57_sal(i)]=DurationEpoch(and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_end_SD_C57_sal{i}),'s');

    [dur_REM_SD_C57_sal_bis{i}, durT_REM_SD_C57_sal(i)]=DurationEpoch(and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}),'s');
    
    idx_short_rem_SD_C57_sal_1{i} = find(dur_REM_SD_C57_sal_bis{i}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_SD_C57_sal_1{i} = subset(and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}), idx_short_rem_SD_C57_sal_1{i});
    [dur_rem_short_SD_C57_sal_1{i}, durT_rem_short_SD_C57_sal(i)] = DurationEpoch(short_REMEpoch_SD_C57_sal_1{i},'s');
    perc_rem_short_SD_C57_sal_1(i) = durT_rem_short_SD_C57_sal(i) / durT_REM_SD_C57_sal(i) * 100;
    dur_moyenne_rem_short_SD_C57_sal_1(i) = nanmean(dur_rem_short_SD_C57_sal_1{i});
    num_moyen_rem_short_SD_C57_sal_1(i) = length(dur_rem_short_SD_C57_sal_1{i});
    
    idx_short_rem_SD_C57_sal_2{i} = find(dur_REM_SD_C57_sal_bis{i}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_SD_C57_sal_2{i} = subset(and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}), idx_short_rem_SD_C57_sal_2{i});
    [dur_rem_short_SD_C57_sal_2{i}, durT_rem_short_SD_C57_sal(i)] = DurationEpoch(short_REMEpoch_SD_C57_sal_2{i},'s');
    perc_rem_short_SD_C57_sal_2(i) = durT_rem_short_SD_C57_sal(i) / durT_REM_SD_C57_sal(i) * 100;
    dur_moyenne_rem_short_SD_C57_sal_2(i) = nanmean(dur_rem_short_SD_C57_sal_2{i});
    num_moyen_rem_short_SD_C57_sal_2(i) = length(dur_rem_short_SD_C57_sal_2{i});
    
    idx_short_rem_SD_C57_sal_3{i} = find(dur_REM_SD_C57_sal_bis{i}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_SD_C57_sal_3{i} = subset(and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}), idx_short_rem_SD_C57_sal_3{i});
    [dur_rem_short_SD_C57_sal_3{i}, durT_rem_short_SD_C57_sal(i)] = DurationEpoch(short_REMEpoch_SD_C57_sal_3{i},'s');
    perc_rem_short_SD_C57_sal_3(i) = durT_rem_short_SD_C57_sal(i) / durT_REM_SD_C57_sal(i) * 100;
    dur_moyenne_rem_short_SD_C57_sal_3(i) = nanmean(dur_rem_short_SD_C57_sal_3{i});
    num_moyen_rem_short_SD_C57_sal_3(i) = length(dur_rem_short_SD_C57_sal_3{i});
    
    idx_long_rem_SD_C57_sal{i} = find(dur_REM_SD_C57_sal_bis{i}>lim_long_rem); %long bout
    long_REMEpoch_SD_C57_sal{i} = subset(and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}), idx_long_rem_SD_C57_sal{i});
    [dur_rem_long_SD_C57_sal{i}, durT_rem_long_SD_C57_sal(i)] = DurationEpoch(long_REMEpoch_SD_C57_sal{i},'s');
    perc_rem_long_SD_C57_sal(i) = durT_rem_long_SD_C57_sal(i) / durT_REM_SD_C57_sal(i) * 100;
    dur_moyenne_rem_long_SD_C57_sal(i) = nanmean(dur_rem_long_SD_C57_sal{i});
    num_moyen_rem_long_SD_C57_sal(i) = length(dur_rem_long_SD_C57_sal{i});
    
    idx_mid_rem_SD_C57_sal{i} = find(dur_REM_SD_C57_sal_bis{i}>lim_short_rem_1 & dur_REM_SD_C57_sal_bis{i}<lim_long_rem); % middle bouts
    mid_REMEpoch_SD_C57_sal{i} = subset(and(stages_SD_C57_sal{i}.REMEpoch,same_epoch_end_SD_C57_sal{i}), idx_mid_rem_SD_C57_sal{i});
    [dur_rem_mid_SD_C57_sal{i}, durT_rem_mid_SD_C57_sal(i)] = DurationEpoch(mid_REMEpoch_SD_C57_sal{i},'s');
    perc_rem_mid_SD_C57_sal(i) = durT_rem_mid_SD_C57_sal(i) / durT_REM_SD_C57_sal(i) * 100;
    dur_moyenne_rem_mid_SD_C57_sal(i) = nanmean(dur_rem_mid_SD_C57_sal{i});
    num_moyen_rem_mid_SD_C57_sal(i) = length(dur_rem_mid_SD_C57_sal{i});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_sal{i}.Wake,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_end_SD_C57_sal{i}),and(short_REMEpoch_SD_C57_sal_1{i},same_epoch_end_SD_C57_sal{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_SD_C57_sal{i} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_SD_C57_sal{i} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_SD_C57_sal{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_sal{i}.Wake,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_end_SD_C57_sal{i}),and(mid_REMEpoch_SD_C57_sal{i},same_epoch_end_SD_C57_sal{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_SD_C57_sal{i} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_SD_C57_sal{i} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_SD_C57_sal{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_sal{i}.Wake,same_epoch_end_SD_C57_sal{i}),and(stages_SD_C57_sal{i}.SWSEpoch,same_epoch_end_SD_C57_sal{i}),and(long_REMEpoch_SD_C57_sal{i},same_epoch_end_SD_C57_sal{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_SD_C57_sal{i} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_SD_C57_sal{i} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_SD_C57_sal{i} = trans_REM_to_REM;
    
    
    
    
    st_sws_SD_C57_sal{i} = Start(stages_SD_C57_sal{i}.SWSEpoch);
    idx_sws_SD_C57_sal{i} = find(mindurSWS<dur_SWS_SD_C57_sal_bis{i},1,'first');
    latency_sws_SD_C57_sal(i) =  st_sws_SD_C57_sal{i}(idx_sws_SD_C57_sal{i});
    
    
    st_rem_SD_C57_sal{i} = Start(stages_SD_C57_sal{i}.REMEpoch);
    idx_rem_SD_C57_sal{i} = find(mindurREM<dur_REM_SD_C57_sal_bis{i},1,'first');
    latency_rem_SD_C57_sal(i) =  st_rem_SD_C57_sal{i}(idx_rem_SD_C57_sal{i});
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for i=1:length(dur_REM_SD_C57_sal)
    %%ALL SESSION
    data_dur_REM_SD_C57_sal(i,:) = dur_REM_SD_C57_sal{i}; data_dur_REM_SD_C57_sal(isnan(data_dur_REM_SD_C57_sal)==1)=0;
    data_dur_SWS_SD_C57_sal(i,:) = dur_SWS_SD_C57_sal{i}; data_dur_SWS_SD_C57_sal(isnan(data_dur_SWS_SD_C57_sal)==1)=0;
    data_dur_WAKE_SD_C57_sal(i,:) = dur_WAKE_SD_C57_sal{i}; data_dur_WAKE_SD_C57_sal(isnan(data_dur_WAKE_SD_C57_sal)==1)=0;
    data_dur_totSleep_SD_C57_sal(i,:) = dur_totSleepctrl{i}; data_dur_totSleep_SD_C57_sal(isnan(data_dur_totSleep_SD_C57_sal)==1)=0;
    
    data_num_REM_SD_C57_sal(i,:) = num_REM_SD_C57_sal{i};data_num_REM_SD_C57_sal(isnan(data_num_REM_SD_C57_sal)==1)=0;
    data_num_SWS_SD_C57_sal(i,:) = num_SWS_SD_C57_sal{i}; data_num_SWS_SD_C57_sal(isnan(data_num_SWS_SD_C57_sal)==1)=0;
    data_num_WAKE_SD_C57_sal(i,:) = num_WAKE_SD_C57_sal{i}; data_num_WAKE_SD_C57_sal(isnan(data_num_WAKE_SD_C57_sal)==1)=0;
    data_num_totSleep_SD_C57_sal(i,:) = num_totSleepctrl{i}; data_num_totSleep_SD_C57_sal(isnan(data_num_totSleep_SD_C57_sal)==1)=0;
    
    data_perc_REM_SD_C57_sal(i,:) = perc_REM_SD_C57_sal{i}; data_perc_REM_SD_C57_sal(isnan(data_perc_REM_SD_C57_sal)==1)=0;
    data_perc_SWS_SD_C57_sal(i,:) = perc_SWS_SD_C57_sal{i}; data_perc_SWS_SD_C57_sal(isnan(data_perc_SWS_SD_C57_sal)==1)=0;
    data_perc_WAKE_SD_C57_sal(i,:) = perc_WAKE_SD_C57_sal{i}; data_perc_WAKE_SD_C57_sal(isnan(data_perc_WAKE_SD_C57_sal)==1)=0;
    data_perc_totSleep_SD_C57_sal(i,:) = perc_totSleepctrl{i}; data_perc_totSleep_SD_C57_sal(isnan(data_perc_totSleep_SD_C57_sal)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_SD_C57_sal(i,:) = dur_REM_begin_SD_C57_sal{i}; data_dur_REM_begin_SD_C57_sal(isnan(data_dur_REM_begin_SD_C57_sal)==1)=0;
    data_dur_SWS_begin_SD_C57_sal(i,:) = dur_SWS_begin_SD_C57_sal{i}; data_dur_SWS_begin_SD_C57_sal(isnan(data_dur_SWS_begin_SD_C57_sal)==1)=0;
    data_dur_WAKE_begin_SD_C57_sal(i,:) = dur_WAKE_begin_SD_C57_sal{i}; data_dur_WAKE_begin_SD_C57_sal(isnan(data_dur_WAKE_begin_SD_C57_sal)==1)=0;
    data_dur_totSleep_begin_SD_C57_sal(i,:) = dur_totSleep_begin_SD_C57_sal{i}; data_dur_totSleep_begin_SD_C57_sal(isnan(data_dur_totSleep_begin_SD_C57_sal)==1)=0;
    
    
    data_num_REM_begin_SD_C57_sal(i,:) = num_REM_begin_SD_C57_sal{i};data_num_REM_begin_SD_C57_sal(isnan(data_num_REM_begin_SD_C57_sal)==1)=0;
    data_num_SWS_begin_SD_C57_sal(i,:) = num_SWS_begin_SD_C57_sal{i}; data_num_SWS_begin_SD_C57_sal(isnan(data_num_SWS_begin_SD_C57_sal)==1)=0;
    data_num_WAKE_begin_SD_C57_sal(i,:) = num_WAKE_begin_SD_C57_sal{i}; data_num_WAKE_begin_SD_C57_sal(isnan(data_num_WAKE_begin_SD_C57_sal)==1)=0;
    data_num_totSleep_begin_SD_C57_sal(i,:) = num_totSleep_begin_SD_C57_sal{i}; data_num_totSleep_begin_SD_C57_sal(isnan(data_num_totSleep_begin_SD_C57_sal)==1)=0;
    
    data_perc_REM_begin_SD_C57_sal(i,:) = perc_REM_begin_SD_C57_sal{i}; data_perc_REM_begin_SD_C57_sal(isnan(data_perc_REM_begin_SD_C57_sal)==1)=0;
    data_perc_SWS_begin_SD_C57_sal(i,:) = perc_SWS_begin_SD_C57_sal{i}; data_perc_SWS_begin_SD_C57_sal(isnan(data_perc_SWS_begin_SD_C57_sal)==1)=0;
    data_perc_WAKE_begin_SD_C57_sal(i,:) = perc_WAKE_begin_SD_C57_sal{i}; data_perc_WAKE_begin_SD_C57_sal(isnan(data_perc_WAKE_begin_SD_C57_sal)==1)=0;
    data_perc_totSleep_begin_SD_C57_sal(i,:) = perc_totSleep_begin_SD_C57_sal{i}; data_perc_totSleep_begin_SD_C57_sal(isnan(data_perc_totSleep_begin_SD_C57_sal)==1)=0;
    
    data_dur_REM_interPeriod_SD_C57_sal(i,:) = dur_REM_interPeriod_SD_C57_sal{i}; data_dur_REM_interPeriod_SD_C57_sal(isnan(data_dur_REM_interPeriod_SD_C57_sal)==1)=0;
    data_dur_SWS_interPeriod_SD_C57_sal(i,:) = dur_SWS_interPeriod_SD_C57_sal{i}; data_dur_SWS_interPeriod_SD_C57_sal(isnan(data_dur_SWS_interPeriod_SD_C57_sal)==1)=0;
    data_dur_WAKE_interPeriod_SD_C57_sal(i,:) = dur_WAKE_interPeriod_SD_C57_sal{i}; data_dur_WAKE_interPeriod_SD_C57_sal(isnan(data_dur_WAKE_interPeriod_SD_C57_sal)==1)=0;
    data_dur_totSleep_interPeriod_SD_C57_sal(i,:) = dur_totSleep_interPeriod_SD_C57_sal{i}; data_dur_totSleep_interPeriod_SD_C57_sal(isnan(data_dur_totSleep_interPeriod_SD_C57_sal)==1)=0;
    
    
    data_num_REM_interPeriod_SD_C57_sal(i,:) = num_REM_interPeriod_SD_C57_sal{i};data_num_REM_interPeriod_SD_C57_sal(isnan(data_num_REM_interPeriod_SD_C57_sal)==1)=0;
    data_num_SWS_interPeriod_SD_C57_sal(i,:) = num_SWS_interPeriod_SD_C57_sal{i}; data_num_SWS_interPeriod_SD_C57_sal(isnan(data_num_SWS_interPeriod_SD_C57_sal)==1)=0;
    data_num_WAKE_interPeriod_SD_C57_sal(i,:) = num_WAKE_interPeriod_SD_C57_sal{i}; data_num_WAKE_interPeriod_SD_C57_sal(isnan(data_num_WAKE_interPeriod_SD_C57_sal)==1)=0;
    data_num_totSleep_interPeriod_SD_C57_sal(i,:) = num_totSleep_interPeriod_SD_C57_sal{i}; data_num_totSleep_interPeriod_SD_C57_sal(isnan(data_num_totSleep_interPeriod_SD_C57_sal)==1)=0;
    
    data_perc_REM_interPeriod_SD_C57_sal(i,:) = perc_REM_interPeriod_SD_C57_sal{i}; data_perc_REM_interPeriod_SD_C57_sal(isnan(data_perc_REM_interPeriod_SD_C57_sal)==1)=0;
    data_perc_SWS_interPeriod_SD_C57_sal(i,:) = perc_SWS_interPeriod_SD_C57_sal{i}; data_perc_SWS_interPeriod_SD_C57_sal(isnan(data_perc_SWS_interPeriod_SD_C57_sal)==1)=0;
    data_perc_WAKE_interPeriod_SD_C57_sal(i,:) = perc_WAKE_interPeriod_SD_C57_sal{i}; data_perc_WAKE_interPeriod_SD_C57_sal(isnan(data_perc_WAKE_interPeriod_SD_C57_sal)==1)=0;
    data_perc_totSleep_interPeriod_SD_C57_sal(i,:) = perc_totSleep_interPeriod_SD_C57_sal{i}; data_perc_totSleep_interPeriod_SD_C57_sal(isnan(data_perc_totSleep_interPeriod_SD_C57_sal)==1)=0;
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_SD_C57_sal(i,:) = dur_REM_end_SD_C57_sal{i}; data_dur_REM_end_SD_C57_sal(isnan(data_dur_REM_end_SD_C57_sal)==1)=0;
    data_dur_SWS_end_SD_C57_sal(i,:) = dur_SWS_end_SD_C57_sal{i}; data_dur_SWS_end_SD_C57_sal(isnan(data_dur_SWS_end_SD_C57_sal)==1)=0;
    data_dur_WAKE_end_SD_C57_sal(i,:) = dur_WAKE_end_SD_C57_sal{i}; data_dur_WAKE_end_SD_C57_sal(isnan(data_dur_WAKE_end_SD_C57_sal)==1)=0;
    data_dur_totSleep_end_SD_C57_sal(i,:) = dur_totSleep_end_SD_C57_sal{i}; data_dur_totSleep_end_SD_C57_sal(isnan(data_dur_totSleep_end_SD_C57_sal)==1)=0;
    
    
    data_num_REM_end_SD_C57_sal(i,:) = num_REM_end_SD_C57_sal{i};data_num_REM_end_SD_C57_sal(isnan(data_num_REM_end_SD_C57_sal)==1)=0;
    data_num_SWS_end_SD_C57_sal(i,:) = num_SWS_end_SD_C57_sal{i}; data_num_SWS_end_SD_C57_sal(isnan(data_num_SWS_end_SD_C57_sal)==1)=0;
    data_num_WAKE_end_SD_C57_sal(i,:) = num_WAKE_end_SD_C57_sal{i}; data_num_WAKE_end_SD_C57_sal(isnan(data_num_WAKE_end_SD_C57_sal)==1)=0;
    data_num_totSleep_end_SD_C57_sal(i,:) = num_totSleep_end_SD_C57_sal{i}; data_num_totSleep_end_SD_C57_sal(isnan(data_num_totSleep_end_SD_C57_sal)==1)=0;
    
    
    data_perc_REM_end_SD_C57_sal(i,:) = perc_REM_end_SD_C57_sal{i}; data_perc_REM_end_SD_C57_sal(isnan(data_perc_REM_end_SD_C57_sal)==1)=0;
    data_perc_SWS_end_SD_C57_sal(i,:) = perc_SWS_end_SD_C57_sal{i}; data_perc_SWS_end_SD_C57_sal(isnan(data_perc_SWS_end_SD_C57_sal)==1)=0;
    data_perc_WAKE_end_SD_C57_sal(i,:) = perc_WAKE_end_SD_C57_sal{i}; data_perc_WAKE_end_SD_C57_sal(isnan(data_perc_WAKE_end_SD_C57_sal)==1)=0;
    data_perc_totSleep_end_SD_C57_sal(i,:) = perc_totSleep_end_SD_C57_sal{i}; data_perc_totSleep_end_SD_C57_sal(isnan(data_perc_totSleep_end_SD_C57_sal)==1)=0;
    
end
%% probability
for i=1:length(all_trans_REM_short_WAKE_end_SD_C57_sal)
%     %%ALL SESSION
%     data_REM_REM_SD_C57_sal(i,:) = all_trans_REM_REM_SD_C57_sal{i}; data_REM_REM_SD_C57_sal(isnan(data_REM_REM_SD_C57_sal)==1)=0;
%     data_REM_SWS_SD_C57_sal(i,:) = all_trans_REM_SWS_SD_C57_sal{i}; data_REM_SWS_SD_C57_sal(isnan(data_REM_SWS_SD_C57_sal)==1)=0;
%     data_REM_WAKE_SD_C57_sal(i,:) = all_trans_REM_WAKE_SD_C57_sal{i}; data_REM_WAKE_SD_C57_sal(isnan(data_REM_WAKE_SD_C57_sal)==1)=0;
%
%     data_SWS_SWS_SD_C57_sal(i,:) = all_trans_SWS_SWS_SD_C57_sal{i}; data_SWS_SWS_SD_C57_sal(isnan(data_SWS_SWS_SD_C57_sal)==1)=0;
%     data_SWS_REM_SD_C57_sal(i,:) = all_trans_SWS_REM_SD_C57_sal{i}; data_SWS_REM_SD_C57_sal(isnan(data_SWS_REM_SD_C57_sal)==1)=0;
%     data_SWS_WAKE_SD_C57_sal(i,:) = all_trans_SWS_WAKE_SD_C57_sal{i}; data_SWS_WAKE_SD_C57_sal(isnan(data_SWS_WAKE_SD_C57_sal)==1)=0;
%
%     data_WAKE_WAKE_SD_C57_sal(i,:) = all_trans_WAKE_WAKE_SD_C57_sal{i}; data_WAKE_WAKE_SD_C57_sal(isnan(data_WAKE_WAKE_SD_C57_sal)==1)=0;
%     data_WAKE_REM_SD_C57_sal(i,:) = all_trans_WAKE_REM_SD_C57_sal{i}; data_WAKE_REM_SD_C57_sal(isnan(data_WAKE_REM_SD_C57_sal)==1)=0;
%     data_WAKE_SWS_SD_C57_sal(i,:) = all_trans_WAKE_SWS_SD_C57_sal{i}; data_WAKE_SWS_SD_C57_sal(isnan(data_WAKE_SWS_SD_C57_sal)==1)=0;
%
%     %%3 PREMI7RES HEURES
%         data_REM_REM_begin_SD_C57_sal(i,:) = all_trans_REM_REM_begin_SD_C57_sal{i}; data_REM_REM_begin_SD_C57_sal(isnan(data_REM_REM_begin_SD_C57_sal)==1)=0;
%     data_REM_SWS_begin_SD_C57_sal(i,:) = all_trans_REM_SWS_begin_SD_C57_sal{i}; data_REM_SWS_begin_SD_C57_sal(isnan(data_REM_SWS_begin_SD_C57_sal)==1)=0;
%     data_REM_WAKE_begin_SD_C57_sal(i,:) = all_trans_REM_WAKE_begin_SD_C57_sal{i}; data_REM_WAKE_begin_SD_C57_sal(isnan(data_REM_WAKE_begin_SD_C57_sal)==1)=0;
%
%     data_SWS_SWS_begin_SD_C57_sal(i,:) = all_trans_SWS_SWS_begin_SD_C57_sal{i}; data_SWS_SWS_begin_SD_C57_sal(isnan(data_SWS_SWS_begin_SD_C57_sal)==1)=0;
%     data_SWS_REM_begin_SD_C57_sal(i,:) = all_trans_SWS_REM_begin_SD_C57_sal{i}; data_SWS_REM_begin_SD_C57_sal(isnan(data_SWS_REM_begin_SD_C57_sal)==1)=0;
%     data_SWS_WAKE_begin_SD_C57_sal(i,:) = all_trans_SWS_WAKE_begin_SD_C57_sal{i}; data_SWS_WAKE_begin_SD_C57_sal(isnan(data_SWS_WAKE_begin_SD_C57_sal)==1)=0;
%
%     data_WAKE_WAKE_begin_SD_C57_sal(i,:) = all_trans_WAKE_WAKE_begin_SD_C57_sal{i}; data_WAKE_WAKE_begin_SD_C57_sal(isnan(data_WAKE_WAKE_begin_SD_C57_sal)==1)=0;
%     data_WAKE_REM_begin_SD_C57_sal(i,:) = all_trans_WAKE_REM_begin_SD_C57_sal{i}; data_WAKE_REM_begin_SD_C57_sal(isnan(data_WAKE_REM_begin_SD_C57_sal)==1)=0;
%     data_WAKE_SWS_begin_SD_C57_sal(i,:) = all_trans_WAKE_SWS_begin_SD_C57_sal{i}; data_WAKE_SWS_begin_SD_C57_sal(isnan(data_WAKE_SWS_begin_SD_C57_sal)==1)=0;
%
%     %%FIN DE LA SESSION
%         data_REM_REM_end_SD_C57_sal(i,:) = all_trans_REM_REM_end_SD_C57_sal{i}; data_REM_REM_end_SD_C57_sal(isnan(data_REM_REM_end_SD_C57_sal)==1)=0;
%     data_REM_SWS_end_SD_C57_sal(i,:) = all_trans_REM_SWS_end_SD_C57_sal{i}; data_REM_SWS_end_SD_C57_sal(isnan(data_REM_SWS_end_SD_C57_sal)==1)=0;
%     data_REM_WAKE_end_SD_C57_sal(i,:) = all_trans_REM_WAKE_end_SD_C57_sal{i}; data_REM_WAKE_end_SD_C57_sal(isnan(data_REM_WAKE_end_SD_C57_sal)==1)=0;
%
%     data_SWS_SWS_end_SD_C57_sal(i,:) = all_trans_SWS_SWS_end_SD_C57_sal{i}; data_SWS_SWS_end_SD_C57_sal(isnan(data_SWS_SWS_end_SD_C57_sal)==1)=0;
%     data_SWS_REM_end_SD_C57_sal(i,:) = all_trans_SWS_REM_end_SD_C57_sal{i}; data_SWS_REM_end_SD_C57_sal(isnan(data_SWS_REM_end_SD_C57_sal)==1)=0;
%     data_SWS_WAKE_end_SD_C57_sal(i,:) = all_trans_SWS_WAKE_end_SD_C57_sal{i}; data_SWS_WAKE_end_SD_C57_sal(isnan(data_SWS_WAKE_end_SD_C57_sal)==1)=0;
%
%     data_WAKE_WAKE_end_SD_C57_sal(i,:) = all_trans_WAKE_WAKE_end_SD_C57_sal{i}; data_WAKE_WAKE_end_SD_C57_sal(isnan(data_WAKE_WAKE_end_SD_C57_sal)==1)=0;
%     data_WAKE_REM_end_SD_C57_sal(i,:) = all_trans_WAKE_REM_end_SD_C57_sal{i}; data_WAKE_REM_end_SD_C57_sal(isnan(data_WAKE_REM_end_SD_C57_sal)==1)=0;
%     data_WAKE_SWS_end_SD_C57_sal(i,:) = all_trans_WAKE_SWS_end_SD_C57_sal{i}; data_WAKE_SWS_end_SD_C57_sal(isnan(data_WAKE_SWS_end_SD_C57_sal)==1)=0;
%
%
%
    data_REM_short_WAKE_end_SD_C57_sal(i,:) = all_trans_REM_short_WAKE_end_SD_C57_sal{i}; %data_REM_short_WAKE_end_SD_C57_sal(isnan(data_REM_short_WAKE_end_SD_C57_sal)==1)=0;
    data_REM_short_SWS_end_SD_C57_sal(i,:) = all_trans_REM_short_SWS_end_SD_C57_sal{i};% data_REM_short_SWS_end_SD_C57_sal(isnan(data_REM_short_SWS_end_SD_C57_sal)==1)=0;
    data_REM_short_REM_end_SD_C57_sal(i,:) = all_trans_REM_short_REM_end_SD_C57_sal{i}; %data_REM_short_WAKE_end_SD_C57_sal(isnan(data_REM_short_WAKE_end_SD_C57_sal)==1)=0;

    data_REM_mid_WAKE_end_SD_C57_sal(i,:) = all_trans_REM_mid_WAKE_end_SD_C57_sal{i}; %data_REM_mid_WAKE_end_SD_C57_sal(isnan(data_REM_mid_WAKE_end_SD_C57_sal)==1)=0;
    data_REM_mid_SWS_end_SD_C57_sal(i,:) = all_trans_REM_mid_SWS_end_SD_C57_sal{i}; %data_REM_mid_SWS_end_SD_C57_sal(isnan(data_REM_mid_SWS_end_SD_C57_sal)==1)=0;
    data_REM_mid_REM_end_SD_C57_sal(i,:) = all_trans_REM_mid_REM_end_SD_C57_sal{i}; %data_REM_mid_WAKE_end_SD_C57_sal(isnan(data_REM_short_WAKE_end_SD_C57_sal)==1)=0;

    data_REM_long_WAKE_end_SD_C57_sal(i,:) = all_trans_REM_long_WAKE_end_SD_C57_sal{i}; %data_REM_long_WAKE_end_SD_C57_sal(isnan(data_REM_long_WAKE_end_SD_C57_sal)==1)=0;
    data_REM_long_SWS_end_SD_C57_sal(i,:) = all_trans_REM_long_SWS_end_SD_C57_sal{i}; %data_REM_long_SWS_end_SD_C57_sal(isnan(data_REM_long_SWS_end_SD_C57_sal)==1)=0;
    data_REM_long_REM_end_SD_C57_sal(i,:) = all_trans_REM_long_REM_end_SD_C57_sal{i}; %data_REM_long_WAKE_end_SD_C57_sal(isnan(data_REM_short_WAKE_end_SD_C57_sal)==1)=0;

end






%% GET DATA - SD mCherry saline
for k=1:length(Dir_SD_C57_cno.path)
    cd(Dir_SD_C57_cno.path{k}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_C57_cno{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_C57_cno{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    same_epoch_SD_C57_cno{k} = intervalSet(0,time_end);
    same_epoch_begin_SD_C57_cno{k} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_SD_C57_cno{k} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_SD_C57_cno{k} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_SD_C57_cno{k}),'wake',tempbin,time_st,time_end);
    dur_WAKE_SD_C57_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_SD_C57_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_SD_C57_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_SD_C57_cno{k}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_C57_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_SD_C57_cno{k}=num_moyen_ep_SWS;
    perc_SWS_SD_C57_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_SD_C57_cno{k}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_C57_cno{k}=dur_moyenne_ep_REM;
    num_REM_SD_C57_cno{k}=num_moyen_ep_REM;
    perc_REM_SD_C57_cno{k}=perc_moyen_REM;
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_SD_C57_cno{k}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_SD_C57_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_SD_C57_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_SD_C57_cno{k}=perc_moyen_totSleep;
    
    
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_begin_SD_C57_cno{k}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_SD_C57_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_SD_C57_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_begin_SD_C57_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_begin_SD_C57_cno{k}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_SD_C57_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_begin_SD_C57_cno{k}=num_moyen_ep_SWS;
    perc_SWS_begin_SD_C57_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_begin_SD_C57_cno{k}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_SD_C57_cno{k}=dur_moyenne_ep_REM;
    num_REM_begin_SD_C57_cno{k}=num_moyen_ep_REM;
    perc_REM_begin_SD_C57_cno{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_begin_SD_C57_cno{k}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_SD_C57_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_SD_C57_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_begin_SD_C57_cno{k}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_cno{k}.Wake,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_begin_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_begin_SD_C57_cno{k}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_SD_C57_cno{k} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_SD_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_SD_C57_cno{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_SD_C57_cno{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_SD_C57_cno{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_SD_C57_cno{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_SD_C57_cno{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_SD_C57_cno{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_SD_C57_cno{k} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_interPeriod_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_interPeriod_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_interPeriod_SD_C57_cno{k}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_SD_C57_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD_C57_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD_C57_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_interPeriod_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_interPeriod_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_interPeriod_SD_C57_cno{k}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_SD_C57_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD_C57_cno{k}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD_C57_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_interPeriod_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_interPeriod_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_interPeriod_SD_C57_cno{k}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_SD_C57_cno{k}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD_C57_cno{k}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD_C57_cno{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_interPeriod_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_interPeriod_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_interPeriod_SD_C57_cno{k}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_SD_C57_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_SD_C57_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_SD_C57_cno{k}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_SD_C57_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_end_SD_C57_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_end_SD_C57_cno{k}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_SD_C57_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_end_SD_C57_cno{k}=num_moyen_ep_SWS;
    perc_SWS_end_SD_C57_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_SD_C57_cno{k}=dur_moyenne_ep_REM;
    num_REM_end_SD_C57_cno{k}=num_moyen_ep_REM;
    perc_REM_end_SD_C57_cno{k}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_C57_cno{k}.Wake,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_SD_C57_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_end_SD_C57_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_end_SD_C57_cno{k}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_cno{k}.Wake,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_SD_C57_cno{k} = trans_REM_to_REM;
    all_trans_REM_SWS_end_SD_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_SD_C57_cno{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_SD_C57_cno{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_SD_C57_cno{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_SD_C57_cno{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_SD_C57_cno{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_SD_C57_cno{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_SD_C57_cno{k} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
        [dur_WAKE_SD_C57_cno_bis{k}, durT_WAKE_SD_C57_cno(k)]=DurationEpoch(and(stages_SD_C57_cno{k}.Wake,same_epoch_end_SD_C57_cno{k}),'s');
    [dur_SWS_SD_C57_cno_bis{k}, durT_SWS_SD_C57_cno(k)]=DurationEpoch(and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_end_SD_C57_cno{k}),'s');
    
    [dur_REM_SD_C57_cno_bis{k}, durT_REM_SD_C57_cno(k)]=DurationEpoch(and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}),'s');
    
    idx_short_rem_SD_C57_cno_1{k} = find(dur_REM_SD_C57_cno_bis{k}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_SD_C57_cno_1{k} = subset(and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}), idx_short_rem_SD_C57_cno_1{k});
    [dur_rem_short_SD_C57_cno_1{k}, durT_rem_short_SD_C57_cno(k)] = DurationEpoch(short_REMEpoch_SD_C57_cno_1{k},'s');
    perc_rem_short_SD_C57_cno_1(k) = durT_rem_short_SD_C57_cno(k) / durT_REM_SD_C57_cno(k) * 100;
    dur_moyenne_rem_short_SD_C57_cno_1(k) = nanmean(dur_rem_short_SD_C57_cno_1{k});
    num_moyen_rem_short_SD_C57_cno_1(k) = length(dur_rem_short_SD_C57_cno_1{k});
    
    idx_short_rem_SD_C57_cno_2{k} = find(dur_REM_SD_C57_cno_bis{k}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_SD_C57_cno_2{k} = subset(and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}), idx_short_rem_SD_C57_cno_2{k});
    [dur_rem_short_SD_C57_cno_2{k}, durT_rem_short_SD_C57_cno(k)] = DurationEpoch(short_REMEpoch_SD_C57_cno_2{k},'s');
    perc_rem_short_SD_C57_cno_2(k) = durT_rem_short_SD_C57_cno(k) / durT_REM_SD_C57_cno(k) * 100;
    dur_moyenne_rem_short_SD_C57_cno_2(k) = nanmean(dur_rem_short_SD_C57_cno_2{k});
    num_moyen_rem_short_SD_C57_cno_2(k) = length(dur_rem_short_SD_C57_cno_2{k});
    
    idx_short_rem_SD_C57_cno_3{k} = find(dur_REM_SD_C57_cno_bis{k}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_SD_C57_cno_3{k} = subset(and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}), idx_short_rem_SD_C57_cno_3{k});
    [dur_rem_short_SD_C57_cno_3{k}, durT_rem_short_SD_C57_cno(k)] = DurationEpoch(short_REMEpoch_SD_C57_cno_3{k},'s');
    perc_rem_short_SD_C57_cno_3(k) = durT_rem_short_SD_C57_cno(k) / durT_REM_SD_C57_cno(k) * 100;
    dur_moyenne_rem_short_SD_C57_cno_3(k) = nanmean(dur_rem_short_SD_C57_cno_3{k});
    num_moyen_rem_short_SD_C57_cno_3(k) = length(dur_rem_short_SD_C57_cno_3{k});
    
    idx_long_rem_SD_C57_cno{k} = find(dur_REM_SD_C57_cno_bis{k}>lim_long_rem); %long bout
    long_REMEpoch_SD_C57_cno{k} = subset(and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}), idx_long_rem_SD_C57_cno{k});
    [dur_rem_long_SD_C57_cno{k}, durT_rem_long_SD_C57_cno(k)] = DurationEpoch(long_REMEpoch_SD_C57_cno{k},'s');
    perc_rem_long_SD_C57_cno(k) = durT_rem_long_SD_C57_cno(k) / durT_REM_SD_C57_cno(k) * 100;
    dur_moyenne_rem_long_SD_C57_cno(k) = nanmean(dur_rem_long_SD_C57_cno{k});
    num_moyen_rem_long_SD_C57_cno(k) = length(dur_rem_long_SD_C57_cno{k});
    
    idx_mid_rem_SD_C57_cno{k} = find(dur_REM_SD_C57_cno_bis{k}>lim_short_rem_1 & dur_REM_SD_C57_cno_bis{k}<lim_long_rem); % middle bouts
    mid_REMEpoch_SD_C57_cno{k} = subset(and(stages_SD_C57_cno{k}.REMEpoch,same_epoch_end_SD_C57_cno{k}), idx_mid_rem_SD_C57_cno{k});
    [dur_rem_mid_SD_C57_cno{k}, durT_rem_mid_SD_C57_cno(k)] = DurationEpoch(mid_REMEpoch_SD_C57_cno{k},'s');
    perc_rem_mid_SD_C57_cno(k) = durT_rem_mid_SD_C57_cno(k) / durT_REM_SD_C57_cno(k) * 100;
    dur_moyenne_rem_mid_SD_C57_cno(k) = nanmean(dur_rem_mid_SD_C57_cno{k});
    num_moyen_rem_mid_SD_C57_cno(k) = length(dur_rem_mid_SD_C57_cno{k});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_cno{k}.Wake,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_end_SD_C57_cno{k}),and(short_REMEpoch_SD_C57_cno_1{k},same_epoch_end_SD_C57_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_SD_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_SD_C57_cno{k} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_SD_C57_cno{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_cno{k}.Wake,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_end_SD_C57_cno{k}),and(mid_REMEpoch_SD_C57_cno{k},same_epoch_end_SD_C57_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_SD_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_SD_C57_cno{k} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_SD_C57_cno{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_C57_cno{k}.Wake,same_epoch_end_SD_C57_cno{k}),and(stages_SD_C57_cno{k}.SWSEpoch,same_epoch_end_SD_C57_cno{k}),and(long_REMEpoch_SD_C57_cno{k},same_epoch_end_SD_C57_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_SD_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_SD_C57_cno{k} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_SD_C57_cno{k} = trans_REM_to_REM;
    
        st_sws_SD_C57_cno{k} = Start(stages_SD_C57_cno{k}.SWSEpoch);
    idx_sws_SD_C57_cno{k} = find(mindurSWS<dur_SWS_SD_C57_cno_bis{k},1,'first');
    latency_sws_SD_C57_cno(k) =  st_sws_SD_C57_cno{k}(idx_sws_SD_C57_cno{k});
    
    
    st_rem_SD_C57_cno{k} = Start(stages_SD_C57_cno{k}.REMEpoch);
    idx_rem_SD_C57_cno{k} = find(mindurREM<dur_REM_SD_C57_cno_bis{k},1,'first');
    latency_rem_SD_C57_cno(k) =  st_rem_SD_C57_cno{k}(idx_rem_SD_C57_cno{k});
    
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for k=1:length(dur_REM_SD_C57_cno)
    %%ALL SESSION
    data_dur_REM_SD_C57_cno(k,:) = dur_REM_SD_C57_cno{k}; data_dur_REM_SD_C57_cno(isnan(data_dur_REM_SD_C57_cno)==1)=0;
    data_dur_SWS_SD_C57_cno(k,:) = dur_SWS_SD_C57_cno{k}; data_dur_SWS_SD_C57_cno(isnan(data_dur_SWS_SD_C57_cno)==1)=0;
    data_dur_WAKE_SD_C57_cno(k,:) = dur_WAKE_SD_C57_cno{k}; data_dur_WAKE_SD_C57_cno(isnan(data_dur_WAKE_SD_C57_cno)==1)=0;
    data_dur_totSleep_SD_C57_cno(k,:) = dur_totSleep_SD_C57_cno{k}; data_dur_totSleep_SD_C57_cno(isnan(data_dur_totSleep_SD_C57_cno)==1)=0;
    
    data_num_REM_SD_C57_cno(k,:) = num_REM_SD_C57_cno{k};data_num_REM_SD_C57_cno(isnan(data_num_REM_SD_C57_cno)==1)=0;
    data_num_SWS_SD_C57_cno(k,:) = num_SWS_SD_C57_cno{k}; data_num_SWS_SD_C57_cno(isnan(data_num_SWS_SD_C57_cno)==1)=0;
    data_num_WAKE_SD_C57_cno(k,:) = num_WAKE_SD_C57_cno{k}; data_num_WAKE_SD_C57_cno(isnan(data_num_WAKE_SD_C57_cno)==1)=0;
    data_num_totSleep_SD_C57_cno(k,:) = num_totSleep_SD_C57_cno{k}; data_num_totSleep_SD_C57_cno(isnan(data_num_totSleep_SD_C57_cno)==1)=0;
    
    data_perc_REM_SD_C57_cno(k,:) = perc_REM_SD_C57_cno{k}; data_perc_REM_SD_C57_cno(isnan(data_perc_REM_SD_C57_cno)==1)=0;
    data_perc_SWS_SD_C57_cno(k,:) = perc_SWS_SD_C57_cno{k}; data_perc_SWS_SD_C57_cno(isnan(data_perc_SWS_SD_C57_cno)==1)=0;
    data_perc_WAKE_SD_C57_cno(k,:) = perc_WAKE_SD_C57_cno{k}; data_perc_WAKE_SD_C57_cno(isnan(data_perc_WAKE_SD_C57_cno)==1)=0;
    data_perc_totSleep_SD_C57_cno(k,:) = perc_totSleep_SD_C57_cno{k}; data_perc_totSleep_SD_C57_cno(isnan(data_perc_totSleep_SD_C57_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_SD_C57_cno(k,:) = dur_REM_begin_SD_C57_cno{k}; data_dur_REM_begin_SD_C57_cno(isnan(data_dur_REM_begin_SD_C57_cno)==1)=0;
    data_dur_SWS_begin_SD_C57_cno(k,:) = dur_SWS_begin_SD_C57_cno{k}; data_dur_SWS_begin_SD_C57_cno(isnan(data_dur_SWS_begin_SD_C57_cno)==1)=0;
    data_dur_WAKE_begin_SD_C57_cno(k,:) = dur_WAKE_begin_SD_C57_cno{k}; data_dur_WAKE_begin_SD_C57_cno(isnan(data_dur_WAKE_begin_SD_C57_cno)==1)=0;
    data_dur_totSleep_begin_SD_C57_cno(k,:) = dur_totSleep_begin_SD_C57_cno{k}; data_dur_totSleep_begin_SD_C57_cno(isnan(data_dur_totSleep_begin_SD_C57_cno)==1)=0;
    
    
    data_num_REM_begin_SD_C57_cno(k,:) = num_REM_begin_SD_C57_cno{k};data_num_REM_begin_SD_C57_cno(isnan(data_num_REM_begin_SD_C57_cno)==1)=0;
    data_num_SWS_begin_SD_C57_cno(k,:) = num_SWS_begin_SD_C57_cno{k}; data_num_SWS_begin_SD_C57_cno(isnan(data_num_SWS_begin_SD_C57_cno)==1)=0;
    data_num_WAKE_begin_SD_C57_cno(k,:) = num_WAKE_begin_SD_C57_cno{k}; data_num_WAKE_begin_SD_C57_cno(isnan(data_num_WAKE_begin_SD_C57_cno)==1)=0;
    data_num_totSleep_begin_SD_C57_cno(k,:) = num_totSleep_begin_SD_C57_cno{k}; data_num_totSleep_begin_SD_C57_cno(isnan(data_num_totSleep_begin_SD_C57_cno)==1)=0;
    
    data_perc_REM_begin_SD_C57_cno(k,:) = perc_REM_begin_SD_C57_cno{k}; data_perc_REM_begin_SD_C57_cno(isnan(data_perc_REM_begin_SD_C57_cno)==1)=0;
    data_perc_SWS_begin_SD_C57_cno(k,:) = perc_SWS_begin_SD_C57_cno{k}; data_perc_SWS_begin_SD_C57_cno(isnan(data_perc_SWS_begin_SD_C57_cno)==1)=0;
    data_perc_WAKE_begin_SD_C57_cno(k,:) = perc_WAKE_begin_SD_C57_cno{k}; data_perc_WAKE_begin_SD_C57_cno(isnan(data_perc_WAKE_begin_SD_C57_cno)==1)=0;
    data_perc_totSleep_begin_SD_C57_cno(k,:) = perc_totSleep_begin_SD_C57_cno{k}; data_perc_totSleep_begin_SD_C57_cno(isnan(data_perc_totSleep_begin_SD_C57_cno)==1)=0;
    
    data_dur_REM_interPeriod_SD_C57_cno(k,:) = dur_REM_interPeriod_SD_C57_cno{k}; data_dur_REM_interPeriod_SD_C57_cno(isnan(data_dur_REM_interPeriod_SD_C57_cno)==1)=0;
    data_dur_SWS_interPeriod_SD_C57_cno(k,:) = dur_SWS_interPeriod_SD_C57_cno{k}; data_dur_SWS_interPeriod_SD_C57_cno(isnan(data_dur_SWS_interPeriod_SD_C57_cno)==1)=0;
    data_dur_WAKE_interPeriod_SD_C57_cno(k,:) = dur_WAKE_interPeriod_SD_C57_cno{k}; data_dur_WAKE_interPeriod_SD_C57_cno(isnan(data_dur_WAKE_interPeriod_SD_C57_cno)==1)=0;
    data_dur_totSleep_interPeriod_SD_C57_cno(k,:) = dur_totSleep_interPeriod_SD_C57_cno{k}; data_dur_totSleep_interPeriod_SD_C57_cno(isnan(data_dur_totSleep_interPeriod_SD_C57_cno)==1)=0;
    
    
    data_num_REM_interPeriod_SD_C57_cno(k,:) = num_REM_interPeriod_SD_C57_cno{k};data_num_REM_interPeriod_SD_C57_cno(isnan(data_num_REM_interPeriod_SD_C57_cno)==1)=0;
    data_num_SWS_interPeriod_SD_C57_cno(k,:) = num_SWS_interPeriod_SD_C57_cno{k}; data_num_SWS_interPeriod_SD_C57_cno(isnan(data_num_SWS_interPeriod_SD_C57_cno)==1)=0;
    data_num_WAKE_interPeriod_SD_C57_cno(k,:) = num_WAKE_interPeriod_SD_C57_cno{k}; data_num_WAKE_interPeriod_SD_C57_cno(isnan(data_num_WAKE_interPeriod_SD_C57_cno)==1)=0;
    data_num_totSleep_interPeriod_SD_C57_cno(k,:) = num_totSleep_interPeriod_SD_C57_cno{k}; data_num_totSleep_interPeriod_SD_C57_cno(isnan(data_num_totSleep_interPeriod_SD_C57_cno)==1)=0;
    
    data_perc_REM_interPeriod_SD_C57_cno(k,:) = perc_REM_interPeriod_SD_C57_cno{k}; data_perc_REM_interPeriod_SD_C57_cno(isnan(data_perc_REM_interPeriod_SD_C57_cno)==1)=0;
    data_perc_SWS_interPeriod_SD_C57_cno(k,:) = perc_SWS_interPeriod_SD_C57_cno{k}; data_perc_SWS_interPeriod_SD_C57_cno(isnan(data_perc_SWS_interPeriod_SD_C57_cno)==1)=0;
    data_perc_WAKE_interPeriod_SD_C57_cno(k,:) = perc_WAKE_interPeriod_SD_C57_cno{k}; data_perc_WAKE_interPeriod_SD_C57_cno(isnan(data_perc_WAKE_interPeriod_SD_C57_cno)==1)=0;
    data_perc_totSleep_interPeriod_SD_C57_cno(k,:) = perc_totSleep_interPeriod_SD_C57_cno{k}; data_perc_totSleep_interPeriod_SD_C57_cno(isnan(data_perc_totSleep_interPeriod_SD_C57_cno)==1)=0;
    
    %%FIN DE LA SESSION
    data_dur_REM_end_SD_C57_cno(k,:) = dur_REM_end_SD_C57_cno{k}; data_dur_REM_end_SD_C57_cno(isnan(data_dur_REM_end_SD_C57_cno)==1)=0;
    data_dur_SWS_end_SD_C57_cno(k,:) = dur_SWS_end_SD_C57_cno{k}; data_dur_SWS_end_SD_C57_cno(isnan(data_dur_SWS_end_SD_C57_cno)==1)=0;
    data_dur_WAKE_end_SD_C57_cno(k,:) = dur_WAKE_end_SD_C57_cno{k}; data_dur_WAKE_end_SD_C57_cno(isnan(data_dur_WAKE_end_SD_C57_cno)==1)=0;
    data_dur_totSleep_end_SD_C57_cno(k,:) = dur_totSleep_end_SD_C57_cno{k}; data_dur_totSleep_end_SD_C57_cno(isnan(data_dur_totSleep_end_SD_C57_cno)==1)=0;
    
    
    data_num_REM_end_SD_C57_cno(k,:) = num_REM_end_SD_C57_cno{k};data_num_REM_end_SD_C57_cno(isnan(data_num_REM_end_SD_C57_cno)==1)=0;
    data_num_SWS_end_SD_C57_cno(k,:) = num_SWS_end_SD_C57_cno{k}; data_num_SWS_end_SD_C57_cno(isnan(data_num_SWS_end_SD_C57_cno)==1)=0;
    data_num_WAKE_end_SD_C57_cno(k,:) = num_WAKE_end_SD_C57_cno{k}; data_num_WAKE_end_SD_C57_cno(isnan(data_num_WAKE_end_SD_C57_cno)==1)=0;
    data_num_totSleep_end_SD_C57_cno(k,:) = num_totSleep_end_SD_C57_cno{k}; data_num_totSleep_end_SD_C57_cno(isnan(data_num_totSleep_end_SD_C57_cno)==1)=0;
    
    
    data_perc_REM_end_SD_C57_cno(k,:) = perc_REM_end_SD_C57_cno{k}; data_perc_REM_end_SD_C57_cno(isnan(data_perc_REM_end_SD_C57_cno)==1)=0;
    data_perc_SWS_end_SD_C57_cno(k,:) = perc_SWS_end_SD_C57_cno{k}; data_perc_SWS_end_SD_C57_cno(isnan(data_perc_SWS_end_SD_C57_cno)==1)=0;
    data_perc_WAKE_end_SD_C57_cno(k,:) = perc_WAKE_end_SD_C57_cno{k}; data_perc_WAKE_end_SD_C57_cno(isnan(data_perc_WAKE_end_SD_C57_cno)==1)=0;
    data_perc_totSleep_end_SD_C57_cno(k,:) = perc_totSleep_end_SD_C57_cno{k}; data_perc_totSleep_end_SD_C57_cno(isnan(data_perc_totSleep_end_SD_C57_cno)==1)=0;
    
end
%%
%probability
for k=1:length(all_trans_REM_short_WAKE_end_SD_C57_cno)
    %     %%ALL SESSION
    %     data_REM_REM_SD_C57_cno(k,:) = all_trans_REM_REM_SD_C57_cno{k}; data_REM_REM_SD_C57_cno(isnan(data_REM_REM_SD_C57_cno)==1)=0;
    %     data_REM_SWS_SD_C57_cno(k,:) = all_trans_REM_SWS_SD_C57_cno{k}; data_REM_SWS_SD_C57_cno(isnan(data_REM_SWS_SD_C57_cno)==1)=0;
    %     data_REM_WAKE_SD_C57_cno(k,:) = all_trans_REM_WAKE_SD_C57_cno{k}; data_REM_WAKE_SD_C57_cno(isnan(data_REM_WAKE_SD_C57_cno)==1)=0;
    %
    %     data_SWS_SWS_SD_C57_cno(k,:) = all_trans_SWS_SWS_SD_C57_cno{k}; data_SWS_SWS_SD_C57_cno(isnan(data_SWS_SWS_SD_C57_cno)==1)=0;
    %     data_SWS_REM_SD_C57_cno(k,:) = all_trans_SWS_REM_SD_C57_cno{k}; data_SWS_REM_SD_C57_cno(isnan(data_SWS_REM_SD_C57_cno)==1)=0;
    %     data_SWS_WAKE_SD_C57_cno(k,:) = all_trans_SWS_WAKE_SD_C57_cno{k}; data_SWS_WAKE_SD_C57_cno(isnan(data_SWS_WAKE_SD_C57_cno)==1)=0;
    %
    %     data_WAKE_WAKE_SD_C57_cno(k,:) = all_trans_WAKE_WAKE_SD_C57_cno{k}; data_WAKE_WAKE_SD_C57_cno(isnan(data_WAKE_WAKE_SD_C57_cno)==1)=0;
    %     data_WAKE_REM_SD_C57_cno(k,:) = all_trans_WAKE_REM_SD_C57_cno{k}; data_WAKE_REM_SD_C57_cno(isnan(data_WAKE_REM_SD_C57_cno)==1)=0;
    %     data_WAKE_SWS_SD_C57_cno(k,:) = all_trans_WAKE_SWS_SD_C57_cno{k}; data_WAKE_SWS_SD_C57_cno(isnan(data_WAKE_SWS_SD_C57_cno)==1)=0;
    %
    %     %%3 PREMI7RES HEURES
    %         data_REM_REM_begin_SD_C57_cno(k,:) = all_trans_REM_REM_begin_SD_C57_cno{k}; data_REM_REM_begin_SD_C57_cno(isnan(data_REM_REM_begin_SD_C57_cno)==1)=0;
    %     data_REM_SWS_begin_SD_C57_cno(k,:) = all_trans_REM_SWS_begin_SD_C57_cno{k}; data_REM_SWS_begin_SD_C57_cno(isnan(data_REM_SWS_begin_SD_C57_cno)==1)=0;
    %     data_REM_WAKE_begin_SD_C57_cno(k,:) = all_trans_REM_WAKE_begin_SD_C57_cno{k}; data_REM_WAKE_begin_SD_C57_cno(isnan(data_REM_WAKE_begin_SD_C57_cno)==1)=0;
    %
    %     data_SWS_SWS_begin_SD_C57_cno(k,:) = all_trans_SWS_SWS_begin_SD_C57_cno{k}; data_SWS_SWS_begin_SD_C57_cno(isnan(data_SWS_SWS_begin_SD_C57_cno)==1)=0;
    %     data_SWS_REM_begin_SD_C57_cno(k,:) = all_trans_SWS_REM_begin_SD_C57_cno{k}; data_SWS_REM_begin_SD_C57_cno(isnan(data_SWS_REM_begin_SD_C57_cno)==1)=0;
    %     data_SWS_WAKE_begin_SD_C57_cno(k,:) = all_trans_SWS_WAKE_begin_SD_C57_cno{k}; data_SWS_WAKE_begin_SD_C57_cno(isnan(data_SWS_WAKE_begin_SD_C57_cno)==1)=0;
    %
    %     data_WAKE_WAKE_begin_SD_C57_cno(k,:) = all_trans_WAKE_WAKE_begin_SD_C57_cno{k}; data_WAKE_WAKE_begin_SD_C57_cno(isnan(data_WAKE_WAKE_begin_SD_C57_cno)==1)=0;
    %     data_WAKE_REM_begin_SD_C57_cno(k,:) = all_trans_WAKE_REM_begin_SD_C57_cno{k}; data_WAKE_REM_begin_SD_C57_cno(isnan(data_WAKE_REM_begin_SD_C57_cno)==1)=0;
    %     data_WAKE_SWS_begin_SD_C57_cno(k,:) = all_trans_WAKE_SWS_begin_SD_C57_cno{k}; data_WAKE_SWS_begin_SD_C57_cno(isnan(data_WAKE_SWS_begin_SD_C57_cno)==1)=0;
    %
    %     %%FIN DE LA SESSION
    %         data_REM_REM_end_SD_C57_cno(k,:) = all_trans_REM_REM_end_SD_C57_cno{k}; data_REM_REM_end_SD_C57_cno(isnan(data_REM_REM_end_SD_C57_cno)==1)=0;
    %     data_REM_SWS_end_SD_C57_cno(k,:) = all_trans_REM_SWS_end_SD_C57_cno{k}; data_REM_SWS_end_SD_C57_cno(isnan(data_REM_SWS_end_SD_C57_cno)==1)=0;
    %     data_REM_WAKE_end_SD_C57_cno(k,:) = all_trans_REM_WAKE_end_SD_C57_cno{k}; data_REM_WAKE_end_SD_C57_cno(isnan(data_REM_WAKE_end_SD_C57_cno)==1)=0;
    %
    %     data_SWS_SWS_end_SD_C57_cno(k,:) = all_trans_SWS_SWS_end_SD_C57_cno{k}; data_SWS_SWS_end_SD_C57_cno(isnan(data_SWS_SWS_end_SD_C57_cno)==1)=0;
    %     data_SWS_REM_end_SD_C57_cno(k,:) = all_trans_SWS_REM_end_SD_C57_cno{k}; data_SWS_REM_end_SD_C57_cno(isnan(data_SWS_REM_end_SD_C57_cno)==1)=0;
    %     data_SWS_WAKE_end_SD_C57_cno(k,:) = all_trans_SWS_WAKE_end_SD_C57_cno{k}; data_SWS_WAKE_end_SD_C57_cno(isnan(data_SWS_WAKE_end_SD_C57_cno)==1)=0;
    %
    %     data_WAKE_WAKE_end_SD_C57_cno(k,:) = all_trans_WAKE_WAKE_end_SD_C57_cno{k}; data_WAKE_WAKE_end_SD_C57_cno(isnan(data_WAKE_WAKE_end_SD_C57_cno)==1)=0;
    %     data_WAKE_REM_end_SD_C57_cno(k,:) = all_trans_WAKE_REM_end_SD_C57_cno{k}; data_WAKE_REM_end_SD_C57_cno(isnan(data_WAKE_REM_end_SD_C57_cno)==1)=0;
    %     data_WAKE_SWS_end_SD_C57_cno(k,:) = all_trans_WAKE_SWS_end_SD_C57_cno{k}; data_WAKE_SWS_end_SD_C57_cno(isnan(data_WAKE_SWS_end_SD_C57_cno)==1)=0;
    %
    data_REM_short_WAKE_end_SD_C57_cno(k,:) = all_trans_REM_short_WAKE_end_SD_C57_cno{k}; data_REM_short_WAKE_end_SD_C57_cno(isnan(data_REM_short_WAKE_end_SD_C57_cno)==1)=0;
    data_REM_short_SWS_end_SD_C57_cno(k,:) = all_trans_REM_short_SWS_end_SD_C57_cno{k}; data_REM_short_SWS_end_SD_C57_cno(isnan(data_REM_short_SWS_end_SD_C57_cno)==1)=0;
    
    data_REM_mid_WAKE_end_SD_C57_cno(k,:) = all_trans_REM_mid_WAKE_end_SD_C57_cno{k}; data_REM_mid_WAKE_end_SD_C57_cno(isnan(data_REM_mid_WAKE_end_SD_C57_cno)==1)=0;
    data_REM_mid_SWS_end_SD_C57_cno(k,:) = all_trans_REM_mid_SWS_end_SD_C57_cno{k}; data_REM_mid_SWS_end_SD_C57_cno(isnan(data_REM_mid_SWS_end_SD_C57_cno)==1)=0;
    
    data_REM_long_WAKE_end_SD_C57_cno(k,:) = all_trans_REM_long_WAKE_end_SD_C57_cno{k}; data_REM_long_WAKE_end_SD_C57_cno(isnan(data_REM_long_WAKE_end_SD_C57_cno)==1)=0;
    data_REM_long_SWS_end_SD_C57_cno(k,:) = all_trans_REM_long_SWS_end_SD_C57_cno{k}; data_REM_long_SWS_end_SD_C57_cno(isnan(data_REM_long_SWS_end_SD_C57_cno)==1)=0;
    
    data_REM_short_REM_end_SD_C57_cno(k,:) = all_trans_REM_short_REM_end_SD_C57_cno{k}; %data_REM_short_REM_end_SD_C57_cno(isnan(data_REM_short_REM_end_SD_C57_cno)==1)=0;
    data_REM_mid_REM_end_SD_C57_cno(k,:) = all_trans_REM_mid_REM_end_SD_C57_cno{k}; %data_REM_mid_REM_end_SD_C57_cno(isnan(data_REM_mid_REM_end_SD_C57_cno)==1)=0;
    data_REM_long_REM_end_SD_C57_cno(k,:) = all_trans_REM_long_REM_end_SD_C57_cno{k}; %data_REM_long_REM_end_SD_C57_cno(isnan(data_REM_long_REM_end_SD_C57_cno)==1)=0;
    
end



%% GET DATA - SD dreadd cno
for j=1:length(Dir_SD_CRH_sal.path)
    cd(Dir_SD_CRH_sal.path{j}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_CRH_sal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_CRH_sal{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_SD_CRH_sal{j} = intervalSet(0,time_end);
    same_epoch_begin_SD_CRH_sal{j} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_SD_CRH_sal{j} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_SD_CRH_sal{j} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_SD_CRH_sal{j}),'wake',tempbin,time_st,time_end);
    dur_WAKE_SD_CRH_sal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_SD_CRH_sal{j}=num_moyen_ep_WAKE;
    perc_WAKE_SD_CRH_sal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_SD_CRH_sal{j}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_CRH_sal{j}=dur_moyenne_ep_SWS;
    num_SWS_SD_CRH_sal{j}=num_moyen_ep_SWS;
    perc_SWS_SD_CRH_sal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_SD_CRH_sal{j}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_CRH_sal{j}=dur_moyenne_ep_REM;
    num_REM_SD_CRH_sal{j}=num_moyen_ep_REM;
    perc_REM_SD_CRH_sal{j}=perc_moyen_REM;
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_SD_CRH_sal{j}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_SD_CRH_sal{j}=dur_moyenne_ep_totSleep;
    num_totSleep_SD_CRH_sal{j}=num_moyen_ep_totSleep;
    perc_totSleep_SD_CRH_sal{j}=perc_moyen_totSleep;
    
    
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_SD_CRH_sal{j}.Wake,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_SD_CRH_sal{j}),tempbin,time_end);
    all_trans_REM_REM_SD_CRH_sal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_SD_CRH_sal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_SD_CRH_sal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_SD_CRH_sal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_SD_CRH_sal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_SD_CRH_sal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_SD_CRH_sal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_SD_CRH_sal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_SD_CRH_sal{j} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_begin_SD_CRH_sal{j}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_SD_CRH_sal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_SD_CRH_sal{j}=num_moyen_ep_WAKE;
    perc_WAKE_begin_SD_CRH_sal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_begin_SD_CRH_sal{j}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_SD_CRH_sal{j}=dur_moyenne_ep_SWS;
    num_SWS_begin_SD_CRH_sal{j}=num_moyen_ep_SWS;
    perc_SWS_begin_SD_CRH_sal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_begin_SD_CRH_sal{j}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_SD_CRH_sal{j}=dur_moyenne_ep_REM;
    num_REM_begin_SD_CRH_sal{j}=num_moyen_ep_REM;
    perc_REM_begin_SD_CRH_sal{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_begin_SD_CRH_sal{j}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_SD_CRH_sal{j}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_SD_CRH_sal{j}=num_moyen_ep_totSleep;
    perc_totSleep_begin_SD_CRH_sal{j}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_sal{j}.Wake,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_begin_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_begin_SD_CRH_sal{j}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_SD_CRH_sal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_SD_CRH_sal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_SD_CRH_sal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_SD_CRH_sal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_SD_CRH_sal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_SD_CRH_sal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_SD_CRH_sal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_SD_CRH_sal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_SD_CRH_sal{j} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_interPeriod_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_interPeriod_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_interPeriod_SD_CRH_sal{j}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_SD_CRH_sal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD_CRH_sal{j}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD_CRH_sal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_interPeriod_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_interPeriod_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_interPeriod_SD_CRH_sal{j}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_SD_CRH_sal{j}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD_CRH_sal{j}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD_CRH_sal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_interPeriod_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_interPeriod_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_interPeriod_SD_CRH_sal{j}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_SD_CRH_sal{j}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD_CRH_sal{j}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD_CRH_sal{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_interPeriod_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_interPeriod_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_interPeriod_SD_CRH_sal{j}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_SD_CRH_sal{j}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_SD_CRH_sal{j}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_SD_CRH_sal{j}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_SD_CRH_sal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_end_SD_CRH_sal{j}=num_moyen_ep_WAKE;
    perc_WAKE_end_SD_CRH_sal{j}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_SD_CRH_sal{j}=dur_moyenne_ep_SWS;
    num_SWS_end_SD_CRH_sal{j}=num_moyen_ep_SWS;
    perc_SWS_end_SD_CRH_sal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_SD_CRH_sal{j}=dur_moyenne_ep_REM;
    num_REM_end_SD_CRH_sal{j}=num_moyen_ep_REM;
    perc_REM_end_SD_CRH_sal{j}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_sal{j}.Wake,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_SD_CRH_sal{j}=dur_moyenne_ep_totSleep;
    num_totSleep_end_SD_CRH_sal{j}=num_moyen_ep_totSleep;
    perc_totSleep_end_SD_CRH_sal{j}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_sal{j}.Wake,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_SD_CRH_sal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_end_SD_CRH_sal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_SD_CRH_sal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_SD_CRH_sal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_SD_CRH_sal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_SD_CRH_sal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_SD_CRH_sal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_SD_CRH_sal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_SD_CRH_sal{j} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_WAKE_SD_CRH_sal_bis{j}, durT_WAKE_SD_CRH_sal(j)]=DurationEpoch(and(stages_SD_CRH_sal{j}.Wake,same_epoch_end_SD_CRH_sal{j}),'s');
    [dur_SWS_SD_CRH_sal_bis{j}, durT_SWS_SD_CRH_sal(j)]=DurationEpoch(and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_end_SD_CRH_sal{j}),'s');
    
    
    [dur_REM_SD_CRH_sal_bis{j}, durT_REM_SD_CRH_sal(j)]=DurationEpoch(and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}),'s');
    
    idx_short_rem_SD_CRH_sal_1{j} = find(dur_REM_SD_CRH_sal_bis{j}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_SD_CRH_sal_1{j} = subset(and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}), idx_short_rem_SD_CRH_sal_1{j});
    [dur_rem_short_SD_CRH_sal_1{j}, durT_rem_short_SD_CRH_sal(j)] = DurationEpoch(short_REMEpoch_SD_CRH_sal_1{j},'s');
    perc_rem_short_SD_CRH_sal_1(j) = durT_rem_short_SD_CRH_sal(j) / durT_REM_SD_CRH_sal(j) * 100;
    dur_moyenne_rem_short_SD_CRH_sal_1(j) = nanmean(dur_rem_short_SD_CRH_sal_1{j});
    num_moyen_rem_short_SD_CRH_sal_1(j) = length(dur_rem_short_SD_CRH_sal_1{j});
    
    idx_short_rem_SD_CRH_sal_2{j} = find(dur_REM_SD_CRH_sal_bis{j}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_SD_CRH_sal_2{j} = subset(and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}), idx_short_rem_SD_CRH_sal_2{j});
    [dur_rem_short_SD_CRH_sal_2{j}, durT_rem_short_SD_CRH_sal(j)] = DurationEpoch(short_REMEpoch_SD_CRH_sal_2{j},'s');
    perc_rem_short_SD_CRH_sal_2(j) = durT_rem_short_SD_CRH_sal(j) / durT_REM_SD_CRH_sal(j) * 100;
    dur_moyenne_rem_short_SD_CRH_sal_2(j) = nanmean(dur_rem_short_SD_CRH_sal_2{j});
    num_moyen_rem_short_SD_CRH_sal_2(j) = length(dur_rem_short_SD_CRH_sal_2{j});
    
    idx_short_rem_SD_CRH_sal_3{j} = find(dur_REM_SD_CRH_sal_bis{j}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_SD_CRH_sal_3{j} = subset(and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}), idx_short_rem_SD_CRH_sal_3{j});
    [dur_rem_short_SD_CRH_sal_3{j}, durT_rem_short_SD_CRH_sal(j)] = DurationEpoch(short_REMEpoch_SD_CRH_sal_3{j},'s');
    perc_rem_short_SD_CRH_sal_3(j) = durT_rem_short_SD_CRH_sal(j) / durT_REM_SD_CRH_sal(j) * 100;
    dur_moyenne_rem_short_SD_CRH_sal_3(j) = nanmean(dur_rem_short_SD_CRH_sal_3{j});
    num_moyen_rem_short_SD_CRH_sal_3(j) = length(dur_rem_short_SD_CRH_sal_3{j});
    
    idx_long_rem_SD_CRH_sal{j} = find(dur_REM_SD_CRH_sal_bis{j}>lim_long_rem); %long bout
    long_REMEpoch_SD_CRH_sal{j} = subset(and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}), idx_long_rem_SD_CRH_sal{j});
    [dur_rem_long_SD_CRH_sal{j}, durT_rem_long_SD_CRH_sal(j)] = DurationEpoch(long_REMEpoch_SD_CRH_sal{j},'s');
    perc_rem_long_SD_CRH_sal(j) = durT_rem_long_SD_CRH_sal(j) / durT_REM_SD_CRH_sal(j) * 100;
    dur_moyenne_rem_long_SD_CRH_sal(j) = nanmean(dur_rem_long_SD_CRH_sal{j});
    num_moyen_rem_long_SD_CRH_sal(j) = length(dur_rem_long_SD_CRH_sal{j});
    
    idx_mid_rem_SD_CRH_sal{j} = find(dur_REM_SD_CRH_sal_bis{j}>lim_short_rem_1 & dur_REM_SD_CRH_sal_bis{j}<lim_long_rem); % middle bouts
    mid_REMEpoch_SD_CRH_sal{j} = subset(and(stages_SD_CRH_sal{j}.REMEpoch,same_epoch_end_SD_CRH_sal{j}), idx_mid_rem_SD_CRH_sal{j});
    [dur_rem_mid_SD_CRH_sal{j}, durT_rem_mid_SD_CRH_sal(j)] = DurationEpoch(mid_REMEpoch_SD_CRH_sal{j},'s');
    perc_rem_mid_SD_CRH_sal(j) = durT_rem_mid_SD_CRH_sal(j) / durT_REM_SD_CRH_sal(j) * 100;
    dur_moyenne_rem_mid_SD_CRH_sal(j) = nanmean(dur_rem_mid_SD_CRH_sal{j});
    num_moyen_rem_mid_SD_CRH_sal(j) = length(dur_rem_mid_SD_CRH_sal{j});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_sal{j}.Wake,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_end_SD_CRH_sal{j}),and(short_REMEpoch_SD_CRH_sal_1{j},same_epoch_end_SD_CRH_sal{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_SD_CRH_sal{j} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_SD_CRH_sal{j} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_SD_CRH_sal{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_sal{j}.Wake,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_end_SD_CRH_sal{j}),and(mid_REMEpoch_SD_CRH_sal{j},same_epoch_end_SD_CRH_sal{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_SD_CRH_sal{j} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_SD_CRH_sal{j} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_SD_CRH_sal{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_sal{j}.Wake,same_epoch_end_SD_CRH_sal{j}),and(stages_SD_CRH_sal{j}.SWSEpoch,same_epoch_end_SD_CRH_sal{j}),and(long_REMEpoch_SD_CRH_sal{j},same_epoch_end_SD_CRH_sal{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_SD_CRH_sal{j} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_SD_CRH_sal{j} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_SD_CRH_sal{j} = trans_REM_to_REM;
    
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for j=1:length(dur_REM_SD_CRH_sal)
    %%ALL SESSION
    data_dur_REM_SD_CRH_sal(j,:) = dur_REM_SD_CRH_sal{j}; data_dur_REM_SD_CRH_sal(isnan(data_dur_REM_SD_CRH_sal)==1)=0;
    data_dur_SWS_SD_CRH_sal(j,:) = dur_SWS_SD_CRH_sal{j}; data_dur_SWS_SD_CRH_sal(isnan(data_dur_SWS_SD_CRH_sal)==1)=0;
    data_dur_WAKE_SD_CRH_sal(j,:) = dur_WAKE_SD_CRH_sal{j}; data_dur_WAKE_SD_CRH_sal(isnan(data_dur_WAKE_SD_CRH_sal)==1)=0;
    data_dur_totSleep_SD_CRH_sal(j,:) = dur_totSleep_SD_CRH_sal{j}; data_dur_totSleep_SD_CRH_sal(isnan(data_dur_totSleep_SD_CRH_sal)==1)=0;
    
    data_num_REM_SD_CRH_sal(j,:) = num_REM_SD_CRH_sal{j};data_num_REM_SD_CRH_sal(isnan(data_num_REM_SD_CRH_sal)==1)=0;
    data_num_SWS_SD_CRH_sal(j,:) = num_SWS_SD_CRH_sal{j}; data_num_SWS_SD_CRH_sal(isnan(data_num_SWS_SD_CRH_sal)==1)=0;
    data_num_WAKE_SD_CRH_sal(j,:) = num_WAKE_SD_CRH_sal{j}; data_num_WAKE_SD_CRH_sal(isnan(data_num_WAKE_SD_CRH_sal)==1)=0;
    data_num_totSleep_SD_CRH_sal(j,:) = num_totSleep_SD_CRH_sal{j}; data_num_totSleep_SD_CRH_sal(isnan(data_num_totSleep_SD_CRH_sal)==1)=0;
    
    data_perc_REM_SD_CRH_sal(j,:) = perc_REM_SD_CRH_sal{j}; data_perc_REM_SD_CRH_sal(isnan(data_perc_REM_SD_CRH_sal)==1)=0;
    data_perc_SWS_SD_CRH_sal(j,:) = perc_SWS_SD_CRH_sal{j}; data_perc_SWS_SD_CRH_sal(isnan(data_perc_SWS_SD_CRH_sal)==1)=0;
    data_perc_WAKE_SD_CRH_sal(j,:) = perc_WAKE_SD_CRH_sal{j}; data_perc_WAKE_SD_CRH_sal(isnan(data_perc_WAKE_SD_CRH_sal)==1)=0;
    data_perc_totSleep_SD_CRH_sal(j,:) = perc_totSleep_SD_CRH_sal{j}; data_perc_totSleep_SD_CRH_sal(isnan(data_perc_totSleep_SD_CRH_sal)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_SD_CRH_sal(j,:) = dur_REM_begin_SD_CRH_sal{j}; data_dur_REM_begin_SD_CRH_sal(isnan(data_dur_REM_begin_SD_CRH_sal)==1)=0;
    data_dur_SWS_begin_SD_CRH_sal(j,:) = dur_SWS_begin_SD_CRH_sal{j}; data_dur_SWS_begin_SD_CRH_sal(isnan(data_dur_SWS_begin_SD_CRH_sal)==1)=0;
    data_dur_WAKE_begin_SD_CRH_sal(j,:) = dur_WAKE_begin_SD_CRH_sal{j}; data_dur_WAKE_begin_SD_CRH_sal(isnan(data_dur_WAKE_begin_SD_CRH_sal)==1)=0;
    data_dur_totSleep_begin_SD_CRH_sal(j,:) = dur_totSleep_begin_SD_CRH_sal{j}; data_dur_totSleep_begin_SD_CRH_sal(isnan(data_dur_totSleep_begin_SD_CRH_sal)==1)=0;
    
    
    data_num_REM_begin_SD_CRH_sal(j,:) = num_REM_begin_SD_CRH_sal{j};data_num_REM_begin_SD_CRH_sal(isnan(data_num_REM_begin_SD_CRH_sal)==1)=0;
    data_num_SWS_begin_SD_CRH_sal(j,:) = num_SWS_begin_SD_CRH_sal{j}; data_num_SWS_begin_SD_CRH_sal(isnan(data_num_SWS_begin_SD_CRH_sal)==1)=0;
    data_num_WAKE_begin_SD_CRH_sal(j,:) = num_WAKE_begin_SD_CRH_sal{j}; data_num_WAKE_begin_SD_CRH_sal(isnan(data_num_WAKE_begin_SD_CRH_sal)==1)=0;
    data_num_totSleep_begin_SD_CRH_sal(j,:) = num_totSleep_begin_SD_CRH_sal{j}; data_num_totSleep_begin_SD_CRH_sal(isnan(data_num_totSleep_begin_SD_CRH_sal)==1)=0;
    
    data_perc_REM_begin_SD_CRH_sal(j,:) = perc_REM_begin_SD_CRH_sal{j}; data_perc_REM_begin_SD_CRH_sal(isnan(data_perc_REM_begin_SD_CRH_sal)==1)=0;
    data_perc_SWS_begin_SD_CRH_sal(j,:) = perc_SWS_begin_SD_CRH_sal{j}; data_perc_SWS_begin_SD_CRH_sal(isnan(data_perc_SWS_begin_SD_CRH_sal)==1)=0;
    data_perc_WAKE_begin_SD_CRH_sal(j,:) = perc_WAKE_begin_SD_CRH_sal{j}; data_perc_WAKE_begin_SD_CRH_sal(isnan(data_perc_WAKE_begin_SD_CRH_sal)==1)=0;
    data_perc_totSleep_begin_SD_CRH_sal(j,:) = perc_totSleep_begin_SD_CRH_sal{j}; data_perc_totSleep_begin_SD_CRH_sal(isnan(data_perc_totSleep_begin_SD_CRH_sal)==1)=0;
    
    data_dur_REM_interPeriod_SD_CRH_sal(j,:) = dur_REM_interPeriod_SD_CRH_sal{j}; data_dur_REM_interPeriod_SD_CRH_sal(isnan(data_dur_REM_interPeriod_SD_CRH_sal)==1)=0;
    data_dur_SWS_interPeriod_SD_CRH_sal(j,:) = dur_SWS_interPeriod_SD_CRH_sal{j}; data_dur_SWS_interPeriod_SD_CRH_sal(isnan(data_dur_SWS_interPeriod_SD_CRH_sal)==1)=0;
    data_dur_WAKE_interPeriod_SD_CRH_sal(j,:) = dur_WAKE_interPeriod_SD_CRH_sal{j}; data_dur_WAKE_interPeriod_SD_CRH_sal(isnan(data_dur_WAKE_interPeriod_SD_CRH_sal)==1)=0;
    data_dur_totSleep_interPeriod_SD_CRH_sal(j,:) = dur_totSleep_interPeriod_SD_CRH_sal{j}; data_dur_totSleep_interPeriod_SD_CRH_sal(isnan(data_dur_totSleep_interPeriod_SD_CRH_sal)==1)=0;
    
    
    data_num_REM_interPeriod_SD_CRH_sal(j,:) = num_REM_interPeriod_SD_CRH_sal{j};data_num_REM_interPeriod_SD_CRH_sal(isnan(data_num_REM_interPeriod_SD_CRH_sal)==1)=0;
    data_num_SWS_interPeriod_SD_CRH_sal(j,:) = num_SWS_interPeriod_SD_CRH_sal{j}; data_num_SWS_interPeriod_SD_CRH_sal(isnan(data_num_SWS_interPeriod_SD_CRH_sal)==1)=0;
    data_num_WAKE_interPeriod_SD_CRH_sal(j,:) = num_WAKE_interPeriod_SD_CRH_sal{j}; data_num_WAKE_interPeriod_SD_CRH_sal(isnan(data_num_WAKE_interPeriod_SD_CRH_sal)==1)=0;
    data_num_totSleep_interPeriod_SD_CRH_sal(j,:) = num_totSleep_interPeriod_SD_CRH_sal{j}; data_num_totSleep_interPeriod_SD_CRH_sal(isnan(data_num_totSleep_interPeriod_SD_CRH_sal)==1)=0;
    
    data_perc_REM_interPeriod_SD_CRH_sal(j,:) = perc_REM_interPeriod_SD_CRH_sal{j}; data_perc_REM_interPeriod_SD_CRH_sal(isnan(data_perc_REM_interPeriod_SD_CRH_sal)==1)=0;
    data_perc_SWS_interPeriod_SD_CRH_sal(j,:) = perc_SWS_interPeriod_SD_CRH_sal{j}; data_perc_SWS_interPeriod_SD_CRH_sal(isnan(data_perc_SWS_interPeriod_SD_CRH_sal)==1)=0;
    data_perc_WAKE_interPeriod_SD_CRH_sal(j,:) = perc_WAKE_interPeriod_SD_CRH_sal{j}; data_perc_WAKE_interPeriod_SD_CRH_sal(isnan(data_perc_WAKE_interPeriod_SD_CRH_sal)==1)=0;
    data_perc_totSleep_interPeriod_SD_CRH_sal(j,:) = perc_totSleep_interPeriod_SD_CRH_sal{j}; data_perc_totSleep_interPeriod_SD_CRH_sal(isnan(data_perc_totSleep_interPeriod_SD_CRH_sal)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_SD_CRH_sal(j,:) = dur_REM_end_SD_CRH_sal{j}; data_dur_REM_end_SD_CRH_sal(isnan(data_dur_REM_end_SD_CRH_sal)==1)=0;
    data_dur_SWS_end_SD_CRH_sal(j,:) = dur_SWS_end_SD_CRH_sal{j}; data_dur_SWS_end_SD_CRH_sal(isnan(data_dur_SWS_end_SD_CRH_sal)==1)=0;
    data_dur_WAKE_end_SD_CRH_sal(j,:) = dur_WAKE_end_SD_CRH_sal{j}; data_dur_WAKE_end_SD_CRH_sal(isnan(data_dur_WAKE_end_SD_CRH_sal)==1)=0;
    data_dur_totSleep_end_SD_CRH_sal(j,:) = dur_totSleep_end_SD_CRH_sal{j}; data_dur_totSleep_end_SD_CRH_sal(isnan(data_dur_totSleep_end_SD_CRH_sal)==1)=0;
    
    
    data_num_REM_end_SD_CRH_sal(j,:) = num_REM_end_SD_CRH_sal{j};data_num_REM_end_SD_CRH_sal(isnan(data_num_REM_end_SD_CRH_sal)==1)=0;
    data_num_SWS_end_SD_CRH_sal(j,:) = num_SWS_end_SD_CRH_sal{j}; data_num_SWS_end_SD_CRH_sal(isnan(data_num_SWS_end_SD_CRH_sal)==1)=0;
    data_num_WAKE_end_SD_CRH_sal(j,:) = num_WAKE_end_SD_CRH_sal{j}; data_num_WAKE_end_SD_CRH_sal(isnan(data_num_WAKE_end_SD_CRH_sal)==1)=0;
    data_num_totSleep_end_SD_CRH_sal(j,:) = num_totSleep_end_SD_CRH_sal{j}; data_num_totSleep_end_SD_CRH_sal(isnan(data_num_totSleep_end_SD_CRH_sal)==1)=0;
    
    
    data_perc_REM_end_SD_CRH_sal(j,:) = perc_REM_end_SD_CRH_sal{j}; data_perc_REM_end_SD_CRH_sal(isnan(data_perc_REM_end_SD_CRH_sal)==1)=0;
    data_perc_SWS_end_SD_CRH_sal(j,:) = perc_SWS_end_SD_CRH_sal{j}; data_perc_SWS_end_SD_CRH_sal(isnan(data_perc_SWS_end_SD_CRH_sal)==1)=0;
    data_perc_WAKE_end_SD_CRH_sal(j,:) = perc_WAKE_end_SD_CRH_sal{j}; data_perc_WAKE_end_SD_CRH_sal(isnan(data_perc_WAKE_end_SD_CRH_sal)==1)=0;
    data_perc_totSleep_end_SD_CRH_sal(j,:) = perc_totSleep_end_SD_CRH_sal{j}; data_perc_totSleep_end_SD_CRH_sal(isnan(data_perc_totSleep_end_SD_CRH_sal)==1)=0;
    
end

for j=1:length(all_trans_REM_REM_SD_CRH_sal)
    data_REM_short_WAKE_end_SD_CRH_sal(j,:) = all_trans_REM_short_WAKE_end_SD_CRH_sal{j}; data_REM_short_WAKE_end_SD_CRH_sal(isnan(data_REM_short_WAKE_end_SD_CRH_sal)==1)=0;
    data_REM_short_SWS_end_SD_CRH_sal(j,:) = all_trans_REM_short_SWS_end_SD_CRH_sal{j}; data_REM_short_SWS_end_SD_CRH_sal(isnan(data_REM_short_SWS_end_SD_CRH_sal)==1)=0;
        data_REM_short_REM_end_SD_CRH_sal(j,:) = all_trans_REM_short_REM_end_SD_CRH_sal{j}; data_REM_short_REM_end_SD_CRH_sal(isnan(data_REM_short_REM_end_SD_CRH_sal)==1)=0;

    data_REM_mid_WAKE_end_SD_CRH_sal(j,:) = all_trans_REM_mid_WAKE_end_SD_CRH_sal{j}; data_REM_mid_WAKE_end_SD_CRH_sal(isnan(data_REM_mid_WAKE_end_SD_CRH_sal)==1)=0;
    data_REM_mid_SWS_end_SD_CRH_sal(j,:) = all_trans_REM_mid_SWS_end_SD_CRH_sal{j}; data_REM_mid_SWS_end_SD_CRH_sal(isnan(data_REM_mid_SWS_end_SD_CRH_sal)==1)=0;
    
    data_REM_long_WAKE_end_SD_CRH_sal(j,:) = all_trans_REM_long_WAKE_end_SD_CRH_sal{j}; data_REM_long_WAKE_end_SD_CRH_sal(isnan(data_REM_long_WAKE_end_SD_CRH_sal)==1)=0;
    data_REM_long_SWS_end_SD_CRH_sal(j,:) = all_trans_REM_long_SWS_end_SD_CRH_sal{j}; data_REM_long_SWS_end_SD_CRH_sal(isnan(data_REM_long_SWS_end_SD_CRH_sal)==1)=0;
    
    data_REM_mid_REM_end_SD_CRH_sal(j,:) = all_trans_REM_mid_REM_end_SD_CRH_sal{j}; data_REM_mid_REM_end_SD_CRH_sal(isnan(data_REM_mid_REM_end_SD_CRH_sal)==1)=0;
    data_REM_long_REM_end_SD_CRH_sal(j,:) = all_trans_REM_long_REM_end_SD_CRH_sal{j}; data_REM_long_REM_end_SD_CRH_sal(isnan(data_REM_long_REM_end_SD_CRH_sal)==1)=0;
    
end



%% GET DATA - SD dreadd cno
for m=1:length(Dir_SD_CRH_cno.path)
    cd(Dir_SD_CRH_cno.path{m}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_CRH_cno{m} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_CRH_cno{m} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_SD_CRH_cno{m} = intervalSet(0,time_end);
    same_epoch_begin_SD_CRH_cno{m} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_SD_CRH_cno{m} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_SD_CRH_cno{m} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_SD_CRH_cno{m}),'wake',tempbin,time_st,time_end);
    dur_WAKE_SD_CRH_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_SD_CRH_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_SD_CRH_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_SD_CRH_cno{m}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_CRH_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_SD_CRH_cno{m}=num_moyen_ep_SWS;
    perc_SWS_SD_CRH_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_SD_CRH_cno{m}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_CRH_cno{m}=dur_moyenne_ep_REM;
    num_REM_SD_CRH_cno{m}=num_moyen_ep_REM;
    perc_REM_SD_CRH_cno{m}=perc_moyen_REM;
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_SD_CRH_cno{m}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_SD_CRH_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_SD_CRH_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_SD_CRH_cno{m}=perc_moyen_totSleep;
    
    
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_SD_CRH_cno{m}.Wake,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_SD_CRH_cno{m}),tempbin,time_end);
    all_trans_REM_REM_SD_CRH_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_SD_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_SD_CRH_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_SD_CRH_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_SD_CRH_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_SD_CRH_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_SD_CRH_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_SD_CRH_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_SD_CRH_cno{m} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_begin_SD_CRH_cno{m}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_SD_CRH_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_SD_CRH_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_begin_SD_CRH_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_begin_SD_CRH_cno{m}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_SD_CRH_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_begin_SD_CRH_cno{m}=num_moyen_ep_SWS;
    perc_SWS_begin_SD_CRH_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_begin_SD_CRH_cno{m}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_SD_CRH_cno{m}=dur_moyenne_ep_REM;
    num_REM_begin_SD_CRH_cno{m}=num_moyen_ep_REM;
    perc_REM_begin_SD_CRH_cno{m}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_begin_SD_CRH_cno{m}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_SD_CRH_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_SD_CRH_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_begin_SD_CRH_cno{m}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_cno{m}.Wake,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_begin_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_begin_SD_CRH_cno{m}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_SD_CRH_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_SD_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_SD_CRH_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_SD_CRH_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_SD_CRH_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_SD_CRH_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_SD_CRH_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_SD_CRH_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_SD_CRH_cno{m} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_interPeriod_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_interPeriod_SD_CRH_cno{m}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_SD_CRH_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD_CRH_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD_CRH_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_interPeriod_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_interPeriod_SD_CRH_cno{m}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_SD_CRH_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD_CRH_cno{m}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD_CRH_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_interPeriod_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_interPeriod_SD_CRH_cno{m}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_SD_CRH_cno{m}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD_CRH_cno{m}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD_CRH_cno{m}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_interPeriod_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_interPeriod_SD_CRH_cno{m}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_SD_CRH_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_SD_CRH_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_SD_CRH_cno{m}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_SD_CRH_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_end_SD_CRH_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_end_SD_CRH_cno{m}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_SD_CRH_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_end_SD_CRH_cno{m}=num_moyen_ep_SWS;
    perc_SWS_end_SD_CRH_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_SD_CRH_cno{m}=dur_moyenne_ep_REM;
    num_REM_end_SD_CRH_cno{m}=num_moyen_ep_REM;
    perc_REM_end_SD_CRH_cno{m}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_CRH_cno{m}.Wake,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_SD_CRH_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_end_SD_CRH_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_end_SD_CRH_cno{m}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_cno{m}.Wake,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_SD_CRH_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_end_SD_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_SD_CRH_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_SD_CRH_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_SD_CRH_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_SD_CRH_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_SD_CRH_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_SD_CRH_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_SD_CRH_cno{m} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_WAKE_SD_CRH_cno_bis{m}, durT_WAKE_SD_CRH_cno(m)]=DurationEpoch(and(stages_SD_CRH_cno{m}.Wake,same_epoch_end_SD_CRH_cno{m}),'s');
    [dur_SWS_SD_CRH_cno_bis{m}, durT_SWS_SD_CRH_cno(m)]=DurationEpoch(and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_end_SD_CRH_cno{m}),'s');
    
    [dur_REM_SD_CRH_cno_bis{m}, durT_REM_SD_CRH_cno(m)]=DurationEpoch(and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}),'s');
    
    idx_short_rem_SD_CRH_cno_1{m} = find(dur_REM_SD_CRH_cno_bis{m}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_SD_CRH_cno_1{m} = subset(and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}), idx_short_rem_SD_CRH_cno_1{m});
    [dur_rem_short_SD_CRH_cno_1{m}, durT_rem_short_SD_CRH_cno(m)] = DurationEpoch(short_REMEpoch_SD_CRH_cno_1{m},'s');
    perc_rem_short_SD_CRH_cno_1(m) = durT_rem_short_SD_CRH_cno(m) / durT_REM_SD_CRH_cno(m) * 100;
    dur_moyenne_rem_short_SD_CRH_cno_1(m) = nanmean(dur_rem_short_SD_CRH_cno_1{m});
    num_moyen_rem_short_SD_CRH_cno_1(m) = length(dur_rem_short_SD_CRH_cno_1{m});
    
    idx_short_rem_SD_CRH_cno_2{m} = find(dur_REM_SD_CRH_cno_bis{m}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_SD_CRH_cno_2{m} = subset(and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}), idx_short_rem_SD_CRH_cno_2{m});
    [dur_rem_short_SD_CRH_cno_2{m}, durT_rem_short_SD_CRH_cno(m)] = DurationEpoch(short_REMEpoch_SD_CRH_cno_2{m},'s');
    perc_rem_short_SD_CRH_cno_2(m) = durT_rem_short_SD_CRH_cno(m) / durT_REM_SD_CRH_cno(m) * 100;
    dur_moyenne_rem_short_SD_CRH_cno_2(m) = nanmean(dur_rem_short_SD_CRH_cno_2{m});
    num_moyen_rem_short_SD_CRH_cno_2(m) = length(dur_rem_short_SD_CRH_cno_2{m});
    
    idx_short_rem_SD_CRH_cno_3{m} = find(dur_REM_SD_CRH_cno_bis{m}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_SD_CRH_cno_3{m} = subset(and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}), idx_short_rem_SD_CRH_cno_3{m});
    [dur_rem_short_SD_CRH_cno_3{m}, durT_rem_short_SD_CRH_cno(m)] = DurationEpoch(short_REMEpoch_SD_CRH_cno_3{m},'s');
    perc_rem_short_SD_CRH_cno_3(m) = durT_rem_short_SD_CRH_cno(m) / durT_REM_SD_CRH_cno(m) * 100;
    dur_moyenne_rem_short_SD_CRH_cno_3(m) = nanmean(dur_rem_short_SD_CRH_cno_3{m});
    num_moyen_rem_short_SD_CRH_cno_3(m) = length(dur_rem_short_SD_CRH_cno_3{m});
    
    idx_long_rem_SD_CRH_cno{m} = find(dur_REM_SD_CRH_cno_bis{m}>lim_long_rem); %long bout
    long_REMEpoch_SD_CRH_cno{m} = subset(and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}), idx_long_rem_SD_CRH_cno{m});
    [dur_rem_long_SD_CRH_cno{m}, durT_rem_long_SD_CRH_cno(m)] = DurationEpoch(long_REMEpoch_SD_CRH_cno{m},'s');
    perc_rem_long_SD_CRH_cno(m) = durT_rem_long_SD_CRH_cno(m) / durT_REM_SD_CRH_cno(m) * 100;
    dur_moyenne_rem_long_SD_CRH_cno(m) = nanmean(dur_rem_long_SD_CRH_cno{m});
    num_moyen_rem_long_SD_CRH_cno(m) = length(dur_rem_long_SD_CRH_cno{m});
    
    idx_mid_rem_SD_CRH_cno{m} = find(dur_REM_SD_CRH_cno_bis{m}>lim_short_rem_1 & dur_REM_SD_CRH_cno_bis{m}<lim_long_rem); % middle bouts
    mid_REMEpoch_SD_CRH_cno{m} = subset(and(stages_SD_CRH_cno{m}.REMEpoch,same_epoch_end_SD_CRH_cno{m}), idx_mid_rem_SD_CRH_cno{m});
    [dur_rem_mid_SD_CRH_cno{m}, durT_rem_mid_SD_CRH_cno(m)] = DurationEpoch(mid_REMEpoch_SD_CRH_cno{m},'s');
    perc_rem_mid_SD_CRH_cno(m) = durT_rem_mid_SD_CRH_cno(m) / durT_REM_SD_CRH_cno(m) * 100;
    dur_moyenne_rem_mid_SD_CRH_cno(m) = nanmean(dur_rem_mid_SD_CRH_cno{m});
    num_moyen_rem_mid_SD_CRH_cno(m) = length(dur_rem_mid_SD_CRH_cno{m});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_cno{m}.Wake,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_end_SD_CRH_cno{m}),and(short_REMEpoch_SD_CRH_cno_1{m},same_epoch_end_SD_CRH_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_SD_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_SD_CRH_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_SD_CRH_cno{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_cno{m}.Wake,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_end_SD_CRH_cno{m}),and(mid_REMEpoch_SD_CRH_cno{m},same_epoch_end_SD_CRH_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_SD_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_SD_CRH_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_SD_CRH_cno{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_CRH_cno{m}.Wake,same_epoch_end_SD_CRH_cno{m}),and(stages_SD_CRH_cno{m}.SWSEpoch,same_epoch_end_SD_CRH_cno{m}),and(long_REMEpoch_SD_CRH_cno{m},same_epoch_end_SD_CRH_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_SD_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_SD_CRH_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_SD_CRH_cno{m} = trans_REM_to_REM;
    
    
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for m=1:length(dur_REM_SD_CRH_cno)
    %%ALL SESSION
    data_dur_REM_SD_CRH_cno(m,:) = dur_REM_SD_CRH_cno{m}; data_dur_REM_SD_CRH_cno(isnan(data_dur_REM_SD_CRH_cno)==1)=0;
    data_dur_SWS_SD_CRH_cno(m,:) = dur_SWS_SD_CRH_cno{m}; data_dur_SWS_SD_CRH_cno(isnan(data_dur_SWS_SD_CRH_cno)==1)=0;
    data_dur_WAKE_SD_CRH_cno(m,:) = dur_WAKE_SD_CRH_cno{m}; data_dur_WAKE_SD_CRH_cno(isnan(data_dur_WAKE_SD_CRH_cno)==1)=0;
    data_dur_totSleep_SD_CRH_cno(m,:) = dur_totSleep_SD_CRH_cno{m}; data_dur_totSleep_SD_CRH_cno(isnan(data_dur_totSleep_SD_CRH_cno)==1)=0;
    
    data_num_REM_SD_CRH_cno(m,:) = num_REM_SD_CRH_cno{m};data_num_REM_SD_CRH_cno(isnan(data_num_REM_SD_CRH_cno)==1)=0;
    data_num_SWS_SD_CRH_cno(m,:) = num_SWS_SD_CRH_cno{m}; data_num_SWS_SD_CRH_cno(isnan(data_num_SWS_SD_CRH_cno)==1)=0;
    data_num_WAKE_SD_CRH_cno(m,:) = num_WAKE_SD_CRH_cno{m}; data_num_WAKE_SD_CRH_cno(isnan(data_num_WAKE_SD_CRH_cno)==1)=0;
    data_num_totSleep_SD_CRH_cno(m,:) = num_totSleep_SD_CRH_cno{m}; data_num_totSleep_SD_CRH_cno(isnan(data_num_totSleep_SD_CRH_cno)==1)=0;
    
    data_perc_REM_SD_CRH_cno(m,:) = perc_REM_SD_CRH_cno{m}; data_perc_REM_SD_CRH_cno(isnan(data_perc_REM_SD_CRH_cno)==1)=0;
    data_perc_SWS_SD_CRH_cno(m,:) = perc_SWS_SD_CRH_cno{m}; data_perc_SWS_SD_CRH_cno(isnan(data_perc_SWS_SD_CRH_cno)==1)=0;
    data_perc_WAKE_SD_CRH_cno(m,:) = perc_WAKE_SD_CRH_cno{m}; data_perc_WAKE_SD_CRH_cno(isnan(data_perc_WAKE_SD_CRH_cno)==1)=0;
    data_perc_totSleep_SD_CRH_cno(m,:) = perc_totSleep_SD_CRH_cno{m}; data_perc_totSleep_SD_CRH_cno(isnan(data_perc_totSleep_SD_CRH_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_SD_CRH_cno(m,:) = dur_REM_begin_SD_CRH_cno{m}; data_dur_REM_begin_SD_CRH_cno(isnan(data_dur_REM_begin_SD_CRH_cno)==1)=0;
    data_dur_SWS_begin_SD_CRH_cno(m,:) = dur_SWS_begin_SD_CRH_cno{m}; data_dur_SWS_begin_SD_CRH_cno(isnan(data_dur_SWS_begin_SD_CRH_cno)==1)=0;
    data_dur_WAKE_begin_SD_CRH_cno(m,:) = dur_WAKE_begin_SD_CRH_cno{m}; data_dur_WAKE_begin_SD_CRH_cno(isnan(data_dur_WAKE_begin_SD_CRH_cno)==1)=0;
    data_dur_totSleep_begin_SD_CRH_cno(m,:) = dur_totSleep_begin_SD_CRH_cno{m}; data_dur_totSleep_begin_SD_CRH_cno(isnan(data_dur_totSleep_begin_SD_CRH_cno)==1)=0;
    
    
    data_num_REM_begin_SD_CRH_cno(m,:) = num_REM_begin_SD_CRH_cno{m};data_num_REM_begin_SD_CRH_cno(isnan(data_num_REM_begin_SD_CRH_cno)==1)=0;
    data_num_SWS_begin_SD_CRH_cno(m,:) = num_SWS_begin_SD_CRH_cno{m}; data_num_SWS_begin_SD_CRH_cno(isnan(data_num_SWS_begin_SD_CRH_cno)==1)=0;
    data_num_WAKE_begin_SD_CRH_cno(m,:) = num_WAKE_begin_SD_CRH_cno{m}; data_num_WAKE_begin_SD_CRH_cno(isnan(data_num_WAKE_begin_SD_CRH_cno)==1)=0;
    data_num_totSleep_begin_SD_CRH_cno(m,:) = num_totSleep_begin_SD_CRH_cno{m}; data_num_totSleep_begin_SD_CRH_cno(isnan(data_num_totSleep_begin_SD_CRH_cno)==1)=0;
    
    data_perc_REM_begin_SD_CRH_cno(m,:) = perc_REM_begin_SD_CRH_cno{m}; data_perc_REM_begin_SD_CRH_cno(isnan(data_perc_REM_begin_SD_CRH_cno)==1)=0;
    data_perc_SWS_begin_SD_CRH_cno(m,:) = perc_SWS_begin_SD_CRH_cno{m}; data_perc_SWS_begin_SD_CRH_cno(isnan(data_perc_SWS_begin_SD_CRH_cno)==1)=0;
    data_perc_WAKE_begin_SD_CRH_cno(m,:) = perc_WAKE_begin_SD_CRH_cno{m}; data_perc_WAKE_begin_SD_CRH_cno(isnan(data_perc_WAKE_begin_SD_CRH_cno)==1)=0;
    data_perc_totSleep_begin_SD_CRH_cno(m,:) = perc_totSleep_begin_SD_CRH_cno{m}; data_perc_totSleep_begin_SD_CRH_cno(isnan(data_perc_totSleep_begin_SD_CRH_cno)==1)=0;
    
    data_dur_REM_interPeriod_SD_CRH_cno(m,:) = dur_REM_interPeriod_SD_CRH_cno{m}; data_dur_REM_interPeriod_SD_CRH_cno(isnan(data_dur_REM_interPeriod_SD_CRH_cno)==1)=0;
    data_dur_SWS_interPeriod_SD_CRH_cno(m,:) = dur_SWS_interPeriod_SD_CRH_cno{m}; data_dur_SWS_interPeriod_SD_CRH_cno(isnan(data_dur_SWS_interPeriod_SD_CRH_cno)==1)=0;
    data_dur_WAKE_interPeriod_SD_CRH_cno(m,:) = dur_WAKE_interPeriod_SD_CRH_cno{m}; data_dur_WAKE_interPeriod_SD_CRH_cno(isnan(data_dur_WAKE_interPeriod_SD_CRH_cno)==1)=0;
    data_dur_totSleep_interPeriod_SD_CRH_cno(m,:) = dur_totSleep_interPeriod_SD_CRH_cno{m}; data_dur_totSleep_interPeriod_SD_CRH_cno(isnan(data_dur_totSleep_interPeriod_SD_CRH_cno)==1)=0;
    
    
    data_num_REM_interPeriod_SD_CRH_cno(m,:) = num_REM_interPeriod_SD_CRH_cno{m};data_num_REM_interPeriod_SD_CRH_cno(isnan(data_num_REM_interPeriod_SD_CRH_cno)==1)=0;
    data_num_SWS_interPeriod_SD_CRH_cno(m,:) = num_SWS_interPeriod_SD_CRH_cno{m}; data_num_SWS_interPeriod_SD_CRH_cno(isnan(data_num_SWS_interPeriod_SD_CRH_cno)==1)=0;
    data_num_WAKE_interPeriod_SD_CRH_cno(m,:) = num_WAKE_interPeriod_SD_CRH_cno{m}; data_num_WAKE_interPeriod_SD_CRH_cno(isnan(data_num_WAKE_interPeriod_SD_CRH_cno)==1)=0;
    data_num_totSleep_interPeriod_SD_CRH_cno(m,:) = num_totSleep_interPeriod_SD_CRH_cno{m}; data_num_totSleep_interPeriod_SD_CRH_cno(isnan(data_num_totSleep_interPeriod_SD_CRH_cno)==1)=0;
    
    data_perc_REM_interPeriod_SD_CRH_cno(m,:) = perc_REM_interPeriod_SD_CRH_cno{m}; data_perc_REM_interPeriod_SD_CRH_cno(isnan(data_perc_REM_interPeriod_SD_CRH_cno)==1)=0;
    data_perc_SWS_interPeriod_SD_CRH_cno(m,:) = perc_SWS_interPeriod_SD_CRH_cno{m}; data_perc_SWS_interPeriod_SD_CRH_cno(isnan(data_perc_SWS_interPeriod_SD_CRH_cno)==1)=0;
    data_perc_WAKE_interPeriod_SD_CRH_cno(m,:) = perc_WAKE_interPeriod_SD_CRH_cno{m}; data_perc_WAKE_interPeriod_SD_CRH_cno(isnan(data_perc_WAKE_interPeriod_SD_CRH_cno)==1)=0;
    data_perc_totSleep_interPeriod_SD_CRH_cno(m,:) = perc_totSleep_interPeriod_SD_CRH_cno{m}; data_perc_totSleep_interPeriod_SD_CRH_cno(isnan(data_perc_totSleep_interPeriod_SD_CRH_cno)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_SD_CRH_cno(m,:) = dur_REM_end_SD_CRH_cno{m}; data_dur_REM_end_SD_CRH_cno(isnan(data_dur_REM_end_SD_CRH_cno)==1)=0;
    data_dur_SWS_end_SD_CRH_cno(m,:) = dur_SWS_end_SD_CRH_cno{m}; data_dur_SWS_end_SD_CRH_cno(isnan(data_dur_SWS_end_SD_CRH_cno)==1)=0;
    data_dur_WAKE_end_SD_CRH_cno(m,:) = dur_WAKE_end_SD_CRH_cno{m}; data_dur_WAKE_end_SD_CRH_cno(isnan(data_dur_WAKE_end_SD_CRH_cno)==1)=0;
    data_dur_totSleep_end_SD_CRH_cno(m,:) = dur_totSleep_end_SD_CRH_cno{m}; data_dur_totSleep_end_SD_CRH_cno(isnan(data_dur_totSleep_end_SD_CRH_cno)==1)=0;
    
    
    data_num_REM_end_SD_CRH_cno(m,:) = num_REM_end_SD_CRH_cno{m};data_num_REM_end_SD_CRH_cno(isnan(data_num_REM_end_SD_CRH_cno)==1)=0;
    data_num_SWS_end_SD_CRH_cno(m,:) = num_SWS_end_SD_CRH_cno{m}; data_num_SWS_end_SD_CRH_cno(isnan(data_num_SWS_end_SD_CRH_cno)==1)=0;
    data_num_WAKE_end_SD_CRH_cno(m,:) = num_WAKE_end_SD_CRH_cno{m}; data_num_WAKE_end_SD_CRH_cno(isnan(data_num_WAKE_end_SD_CRH_cno)==1)=0;
    data_num_totSleep_end_SD_CRH_cno(m,:) = num_totSleep_end_SD_CRH_cno{m}; data_num_totSleep_end_SD_CRH_cno(isnan(data_num_totSleep_end_SD_CRH_cno)==1)=0;
    
    
    data_perc_REM_end_SD_CRH_cno(m,:) = perc_REM_end_SD_CRH_cno{m}; data_perc_REM_end_SD_CRH_cno(isnan(data_perc_REM_end_SD_CRH_cno)==1)=0;
    data_perc_SWS_end_SD_CRH_cno(m,:) = perc_SWS_end_SD_CRH_cno{m}; data_perc_SWS_end_SD_CRH_cno(isnan(data_perc_SWS_end_SD_CRH_cno)==1)=0;
    data_perc_WAKE_end_SD_CRH_cno(m,:) = perc_WAKE_end_SD_CRH_cno{m}; data_perc_WAKE_end_SD_CRH_cno(isnan(data_perc_WAKE_end_SD_CRH_cno)==1)=0;
    data_perc_totSleep_end_SD_CRH_cno(m,:) = perc_totSleep_end_SD_CRH_cno{m}; data_perc_totSleep_end_SD_CRH_cno(isnan(data_perc_totSleep_end_SD_CRH_cno)==1)=0;
    
end
%%probability
for m=1:length(all_trans_REM_REM_SD_CRH_cno)
% %     %%ALL SESSION
% %     data_REM_REM_SD_CRH_cno(m,:) = all_trans_REM_REM_SD_CRH_cno{m}; data_REM_REM_SD_CRH_cno(isnan(data_REM_REM_SD_CRH_cno)==1)=0;
% %     data_REM_SWS_SD_CRH_cno(m,:) = all_trans_REM_SWS_SD_CRH_cno{m}; data_REM_SWS_SD_CRH_cno(isnan(data_REM_SWS_SD_CRH_cno)==1)=0;
% %     data_REM_WAKE_SD_CRH_cno(m,:) = all_trans_REM_WAKE_SD_CRH_cno{m}; data_REM_WAKE_SD_CRH_cno(isnan(data_REM_WAKE_SD_CRH_cno)==1)=0;
% %
% %     data_SWS_SWS_SD_CRH_cno(m,:) = all_trans_SWS_SWS_SD_CRH_cno{m}; data_SWS_SWS_SD_CRH_cno(isnan(data_SWS_SWS_SD_CRH_cno)==1)=0;
% %     data_SWS_REM_SD_CRH_cno(m,:) = all_trans_SWS_REM_SD_CRH_cno{m}; data_SWS_REM_SD_CRH_cno(isnan(data_SWS_REM_SD_CRH_cno)==1)=0;
% %     data_SWS_WAKE_SD_CRH_cno(m,:) = all_trans_SWS_WAKE_SD_CRH_cno{m}; data_SWS_WAKE_SD_CRH_cno(isnan(data_SWS_WAKE_SD_CRH_cno)==1)=0;
% %
% %     data_WAKE_WAKE_SD_CRH_cno(m,:) = all_trans_WAKE_WAKE_SD_CRH_cno{m}; data_WAKE_WAKE_SD_CRH_cno(isnan(data_WAKE_WAKE_SD_CRH_cno)==1)=0;
% %     data_WAKE_REM_SD_CRH_cno(m,:) = all_trans_WAKE_REM_SD_CRH_cno{m}; data_WAKE_REM_SD_CRH_cno(isnan(data_WAKE_REM_SD_CRH_cno)==1)=0;
% %     data_WAKE_SWS_SD_CRH_cno(m,:) = all_trans_WAKE_SWS_SD_CRH_cno{m}; data_WAKE_SWS_SD_CRH_cno(isnan(data_WAKE_SWS_SD_CRH_cno)==1)=0;
% %
% %     %%3 PREMI7RES HEURES
% %         data_REM_REM_begin_SD_CRH_cno(m,:) = all_trans_REM_REM_begin_SD_CRH_cno{m}; data_REM_REM_begin_SD_CRH_cno(isnan(data_REM_REM_begin_SD_CRH_cno)==1)=0;
% %     data_REM_SWS_begin_SD_CRH_cno(m,:) = all_trans_REM_SWS_begin_SD_CRH_cno{m}; data_REM_SWS_begin_SD_CRH_cno(isnan(data_REM_SWS_begin_SD_CRH_cno)==1)=0;
% %     data_REM_WAKE_begin_SD_CRH_cno(m,:) = all_trans_REM_WAKE_begin_SD_CRH_cno{m}; data_REM_WAKE_begin_SD_CRH_cno(isnan(data_REM_WAKE_begin_SD_CRH_cno)==1)=0;
% %
% %     data_SWS_SWS_begin_SD_CRH_cno(m,:) = all_trans_SWS_SWS_begin_SD_CRH_cno{m}; data_SWS_SWS_begin_SD_CRH_cno(isnan(data_SWS_SWS_begin_SD_CRH_cno)==1)=0;
% %     data_SWS_REM_begin_SD_CRH_cno(m,:) = all_trans_SWS_REM_begin_SD_CRH_cno{m}; data_SWS_REM_begin_SD_CRH_cno(isnan(data_SWS_REM_begin_SD_CRH_cno)==1)=0;
% %     data_SWS_WAKE_begin_SD_CRH_cno(m,:) = all_trans_SWS_WAKE_begin_SD_CRH_cno{m}; data_SWS_WAKE_begin_SD_CRH_cno(isnan(data_SWS_WAKE_begin_SD_CRH_cno)==1)=0;
% %
% %     data_WAKE_WAKE_begin_SD_CRH_cno(m,:) = all_trans_WAKE_WAKE_begin_SD_CRH_cno{m}; data_WAKE_WAKE_begin_SD_CRH_cno(isnan(data_WAKE_WAKE_begin_SD_CRH_cno)==1)=0;
% %     data_WAKE_REM_begin_SD_CRH_cno(m,:) = all_trans_WAKE_REM_begin_SD_CRH_cno{m}; data_WAKE_REM_begin_SD_CRH_cno(isnan(data_WAKE_REM_begin_SD_CRH_cno)==1)=0;
% %     data_WAKE_SWS_begin_SD_CRH_cno(m,:) = all_trans_WAKE_SWS_begin_SD_CRH_cno{m}; data_WAKE_SWS_begin_SD_CRH_cno(isnan(data_WAKE_SWS_begin_SD_CRH_cno)==1)=0;
% %
% %     %%FIN DE LA SESSION
% %         data_REM_REM_end_SD_CRH_cno(m,:) = all_trans_REM_REM_end_SD_CRH_cno{m}; data_REM_REM_end_SD_CRH_cno(isnan(data_REM_REM_end_SD_CRH_cno)==1)=0;
% %     data_REM_SWS_end_SD_CRH_cno(m,:) = all_trans_REM_SWS_end_SD_CRH_cno{m}; data_REM_SWS_end_SD_CRH_cno(isnan(data_REM_SWS_end_SD_CRH_cno)==1)=0;
% %     data_REM_WAKE_end_SD_CRH_cno(m,:) = all_trans_REM_WAKE_end_SD_CRH_cno{m}; data_REM_WAKE_end_SD_CRH_cno(isnan(data_REM_WAKE_end_SD_CRH_cno)==1)=0;
% %
% %     data_SWS_SWS_end_SD_CRH_cno(m,:) = all_trans_SWS_SWS_end_SD_CRH_cno{m}; data_SWS_SWS_end_SD_CRH_cno(isnan(data_SWS_SWS_end_SD_CRH_cno)==1)=0;
% %     data_SWS_REM_end_SD_CRH_cno(m,:) = all_trans_SWS_REM_end_SD_CRH_cno{m}; data_SWS_REM_end_SD_CRH_cno(isnan(data_SWS_REM_end_SD_CRH_cno)==1)=0;
% %     data_SWS_WAKE_end_SD_CRH_cno(m,:) = all_trans_SWS_WAKE_end_SD_CRH_cno{m}; data_SWS_WAKE_end_SD_CRH_cno(isnan(data_SWS_WAKE_end_SD_CRH_cno)==1)=0;
% %
% %     data_WAKE_WAKE_end_SD_CRH_cno(m,:) = all_trans_WAKE_WAKE_end_SD_CRH_cno{m}; data_WAKE_WAKE_end_SD_CRH_cno(isnan(data_WAKE_WAKE_end_SD_CRH_cno)==1)=0;
% %     data_WAKE_REM_end_SD_CRH_cno(m,:) = all_trans_WAKE_REM_end_SD_CRH_cno{m}; data_WAKE_REM_end_SD_CRH_cno(isnan(data_WAKE_REM_end_SD_CRH_cno)==1)=0;
% %     data_WAKE_SWS_end_SD_CRH_cno(m,:) = all_trans_WAKE_SWS_end_SD_CRH_cno{m}; data_WAKE_SWS_end_SD_CRH_cno(isnan(data_WAKE_SWS_end_SD_CRH_cno)==1)=0;
data_REM_short_WAKE_end_SD_CRH_cno(m,:) = all_trans_REM_short_WAKE_end_SD_CRH_cno{m}; data_REM_short_WAKE_end_SD_CRH_cno(isnan(data_REM_short_WAKE_end_SD_CRH_cno)==1)=0;
data_REM_short_SWS_end_SD_CRH_cno(m,:) = all_trans_REM_short_SWS_end_SD_CRH_cno{m}; data_REM_short_SWS_end_SD_CRH_cno(isnan(data_REM_short_SWS_end_SD_CRH_cno)==1)=0;

data_REM_mid_WAKE_end_SD_CRH_cno(m,:) = all_trans_REM_mid_WAKE_end_SD_CRH_cno{m}; data_REM_mid_WAKE_end_SD_CRH_cno(isnan(data_REM_mid_WAKE_end_SD_CRH_cno)==1)=0;
data_REM_mid_SWS_end_SD_CRH_cno(m,:) = all_trans_REM_mid_SWS_end_SD_CRH_cno{m}; data_REM_mid_SWS_end_SD_CRH_cno(isnan(data_REM_mid_SWS_end_SD_CRH_cno)==1)=0;

data_REM_long_WAKE_end_SD_CRH_cno(m,:) = all_trans_REM_long_WAKE_end_SD_CRH_cno{m}; data_REM_long_WAKE_end_SD_CRH_cno(isnan(data_REM_long_WAKE_end_SD_CRH_cno)==1)=0;
data_REM_long_SWS_end_SD_CRH_cno(m,:) = all_trans_REM_long_SWS_end_SD_CRH_cno{m}; data_REM_long_SWS_end_SD_CRH_cno(isnan(data_REM_long_SWS_end_SD_CRH_cno)==1)=0;


data_REM_short_REM_end_SD_CRH_cno(m,:) = all_trans_REM_short_REM_end_SD_CRH_cno{m}; data_REM_short_REM_end_SD_CRH_cno(isnan(data_REM_short_REM_end_SD_CRH_cno)==1)=0;
data_REM_mid_REM_end_SD_CRH_cno(m,:) = all_trans_REM_mid_REM_end_SD_CRH_cno{m}; data_REM_mid_REM_end_SD_CRH_cno(isnan(data_REM_mid_REM_end_SD_CRH_cno)==1)=0;
data_REM_long_REM_end_SD_CRH_cno(m,:) = all_trans_REM_long_REM_end_SD_CRH_cno{m}; data_REM_long_REM_end_SD_CRH_cno(isnan(data_REM_long_REM_end_SD_CRH_cno)==1)=0;


end

