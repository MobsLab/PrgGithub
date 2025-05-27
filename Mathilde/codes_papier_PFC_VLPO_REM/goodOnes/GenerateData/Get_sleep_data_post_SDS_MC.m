
%% input dir
%%1
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);

%%2
DirSocialDefeat_totSleepPost_mCherry_cno1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');
DirSocialDefeat_totSleepPost_BM_cno1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
DirSocialDefeat_totSleepPost_mCherry_cno = MergePathForExperiment(DirSocialDefeat_totSleepPost_mCherry_cno1,DirSocialDefeat_totSleepPost_BM_cno1);

%%3
DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_mCherry_saline = MergePathForExperiment(DirSocialDefeat_mCherry_saline1,DirSocialDefeat_BM_saline1);
DirSocialDefeat_classic = MergePathForExperiment(DirSocialDefeat_classic1,DirSocialDefeat_mCherry_saline);

%%4
DirSocialDefeat_totSleepPost_dreadd_cno = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_CNOInjection');

% DirSocialDefeat_totSleepPost_dreadd_cno = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_PFC_CNOInjection');

%% TEST SOURIS ALICE
% 
% % Dir_ctrl = PathForExperiments_DREADD_AD('mCherry_CRH_VLPO_SalineInjection_10am');
% Dir_ctrl=PathForExperiments_DREADD_AD('inhibDREADD_CRH_VLPO_SalineInjection_10am');
% 
% DirSocialDefeat_classic = PathForExperiments_SleepPostSD_AD('SleepPostSD_mCherry_CRH_VLPO_SalineInjection_10am');
% DirSocialDefeat_classic = PathForExperiments_SleepPostSD_AD('SleepPostSD_SecondRun_mCherry_CRH_VLPO_SalineInjection_10am');
% DirSocialDefeat_classic = PathForExperiments_SleepPostSD_AD('SleepPostSD_SecondRun_inhibDREADD_CRH_VLPO_SalineInjection_10am');


% DirSocialDefeat_classic = PathForExperiments_SleepPostSD_AD('SleepPostSD_mCherry_CRH_VLPO_CNOInjection_10am');
% DirSocialDefeat_classic = PathForExperiments_SleepPostSD_AD('SleepPostSD_SecondRun_mCherry_CRH_VLPO_CNOInjection_10am');

% DirSocialDefeat_classic = PathForExperiments_SleepPostSD_AD('SleepPostSD_inhibDREADD_CRH_VLPO_CNOInjection_10am');
% DirSocialDefeat_classic = PathForExperiments_SleepPostSD_AD('SleepPostSD_inhibDREADD_CRH_VLPO_CNOInjection_10am');


%%
%% parameters

tempbin = 3600; %bin size to plot variables overtime

time_st = 0*3600*1e4; %begining of the sleep session
 time_end=3*1e8;  %end of the sleep session


time_mid_end_first_period = 1.5*3600*1e4; %1.5         %2 first hours (insomnia)
time_mid_begin_snd_period = 3.3*3600*1e4;%3.3           4 last hours(late pahse of the night)
 
%% Suggested correction SB to follow late period
% time_mid_begin_snd_period = 5*3600*1e4;%3.3           4 last hours(late pahse of the night)
%  time_end=7.5*3600*1e4;  %end of the sleep session

lim_short_rem_1 = 25; %25 take all rem bouts shorter than limit
lim_short_rem_2 = 15;
lim_short_rem_3 = 20;

lim_long_rem = 25; %25 take all rem bouts longer than limit

mindurSWS = 60;
mindurREM = 25;

%% GET DATA - ctrl group (mCherry saline injection 10h without stress)

for i=1:length(Dir_ctrl.path)
    cd(Dir_ctrl.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_ctrl{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_ctrl{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%Define different periods of time for quantifications
    same_epoch_all_sess_ctrl{i} = intervalSet(0,time_end); %all session
    same_epoch_begin_ctrl{i} = intervalSet(time_st,time_mid_begin_snd_period); %beginning of the session (period of insomnia)
    same_epoch_end_ctrl{i} = intervalSet(time_mid_begin_snd_period,time_end); %late phase of the session (rem frag)
    same_epoch_interPeriod_ctrl{i} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period); %inter period
    
    %%Compute percentage, mean duration, number of bouts overtime (over all session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_all_sess_ctrl{i}),'wake',tempbin,time_st,time_end);
    dur_WAKE_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_ctrl{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_all_sess_ctrl{i}),'sws',tempbin,time_st,time_end);
    dur_SWS_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_all_sess_ctrl{i}),'rem',tempbin,time_st,time_end);
    dur_REM_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_ctrl{i}=num_moyen_ep_REM;
    perc_REM_ctrl{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_all_sess_ctrl{i}),'sleep',tempbin,time_st,time_end);
    dur_totSleepctrl{i}=dur_moyenne_ep_totSleep;
    num_totSleepctrl{i}=num_moyen_ep_totSleep;
    perc_totSleepctrl{i}=perc_moyen_totSleep;
    

    %%First period (beginning)
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_begin_ctrl{i}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_begin_ctrl{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_begin_ctrl{i}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_begin_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_begin_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_begin_ctrl{i}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_begin_ctrl{i}=num_moyen_ep_REM;
    perc_REM_begin_ctrl{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_begin_ctrl{i}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_ctrl{i}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_ctrl{i}=num_moyen_ep_totSleep;
    perc_totSleep_begin_ctrl{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_begin_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_begin_ctrl{i}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_ctrl{i} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_ctrl{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_ctrl{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_ctrl{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_ctrl{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_ctrl{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_ctrl{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_ctrl{i} = trans_WAKE_to_WAKE;
    
    
    
    %%Inter period (middle part of the session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_interPeriod_ctrl{i}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_ctrl{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_interPeriod_ctrl{i}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_interPeriod_ctrl{i}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_interPeriod_ctrl{i}=num_moyen_ep_REM;
    perc_REM_interPeriod_ctrl{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_interPeriod_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_interPeriod_ctrl{i}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_ctrl{i}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_ctrl{i}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_ctrl{i}=perc_moyen_totSleep;
    
    
    
    %%Late period of the session
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_end_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_end_ctrl{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_end_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_end_ctrl{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_end_ctrl{i}=num_moyen_ep_REM;
    perc_REM_end_ctrl{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{i}.Wake,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_ctrl{i}=dur_moyenne_ep_totSleep;
    num_totSleep_end_ctrl{i}=num_moyen_ep_totSleep;
    perc_totSleep_end_ctrl{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_ctrl{i} = trans_REM_to_REM;
    all_trans_REM_SWS_end_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_ctrl{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_ctrl{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_ctrl{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_ctrl{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_ctrl{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_ctrl{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_ctrl{i} = trans_WAKE_to_WAKE;
    
    
   
    %%Short versus long REM bouts during late period
    [dur_WAKE_ctrl_bis{i}, durT_WAKE_ctrl(i)]=DurationEpoch(and(stages_ctrl{i}.Wake,same_epoch_end_ctrl{i}),'s');
    [dur_SWS_ctrl_bis{i}, durT_SWS_ctrl(i)]=DurationEpoch(and(stages_ctrl{i}.SWSEpoch,same_epoch_end_ctrl{i}),'s');

    [dur_REM_ctrl_bis{i}, durT_REM_ctrl(i)]=DurationEpoch(and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}),'s');
    
    idx_short_rem_ctrl_1{i} = find(dur_REM_ctrl_bis{i}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_ctrl_1{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}), idx_short_rem_ctrl_1{i});
    [dur_rem_short_ctrl_1{i}, durT_rem_short_ctrl(i)] = DurationEpoch(short_REMEpoch_ctrl_1{i},'s');
    perc_rem_short_ctrl_1(i) = durT_rem_short_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_short_ctrl_1(i) = nanmean(dur_rem_short_ctrl_1{i});
    num_moyen_rem_short_ctrl_1(i) = length(dur_rem_short_ctrl_1{i});
    
    idx_short_rem_ctrl_2{i} = find(dur_REM_ctrl_bis{i}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_ctrl_2{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}), idx_short_rem_ctrl_2{i});
    [dur_rem_short_ctrl_2{i}, durT_rem_short_ctrl(i)] = DurationEpoch(short_REMEpoch_ctrl_2{i},'s');
    perc_rem_short_ctrl_2(i) = durT_rem_short_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_short_ctrl_2(i) = nanmean(dur_rem_short_ctrl_2{i});
    num_moyen_rem_short_ctrl_2(i) = length(dur_rem_short_ctrl_2{i});
    
    idx_short_rem_ctrl_3{i} = find(dur_REM_ctrl_bis{i}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_ctrl_3{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}), idx_short_rem_ctrl_3{i});
    [dur_rem_short_ctrl_3{i}, durT_rem_short_ctrl(i)] = DurationEpoch(short_REMEpoch_ctrl_3{i},'s');
    perc_rem_short_ctrl_3(i) = durT_rem_short_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_short_ctrl_3(i) = nanmean(dur_rem_short_ctrl_3{i});
    num_moyen_rem_short_ctrl_3(i) = length(dur_rem_short_ctrl_3{i});
    
    idx_long_rem_ctrl{i} = find(dur_REM_ctrl_bis{i}>lim_long_rem); %long bout
    long_REMEpoch_ctrl{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}), idx_long_rem_ctrl{i});
    [dur_rem_long_ctrl{i}, durT_rem_long_ctrl(i)] = DurationEpoch(long_REMEpoch_ctrl{i},'s');
    perc_rem_long_ctrl(i) = durT_rem_long_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_long_ctrl(i) = nanmean(dur_rem_long_ctrl{i});
    num_moyen_rem_long_ctrl(i) = length(dur_rem_long_ctrl{i});
    
    idx_mid_rem_ctrl{i} = find(dur_REM_ctrl_bis{i}>lim_short_rem_1 & dur_REM_ctrl_bis{i}<lim_long_rem); % middle bouts
    mid_REMEpoch_ctrl{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_end_ctrl{i}), idx_mid_rem_ctrl{i});
    [dur_rem_mid_ctrl{i}, durT_rem_mid_ctrl(i)] = DurationEpoch(mid_REMEpoch_ctrl{i},'s');
    perc_rem_mid_ctrl(i) = durT_rem_mid_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_mid_ctrl(i) = nanmean(dur_rem_mid_ctrl{i});
    num_moyen_rem_mid_ctrl(i) = length(dur_rem_mid_ctrl{i});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_end_ctrl{i}),and(short_REMEpoch_ctrl_1{i},same_epoch_end_ctrl{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_ctrl{i} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_ctrl{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_end_ctrl{i}),and(mid_REMEpoch_ctrl{i},same_epoch_end_ctrl{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_ctrl{i} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_ctrl{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{i}.Wake,same_epoch_end_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_end_ctrl{i}),and(long_REMEpoch_ctrl{i},same_epoch_end_ctrl{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_ctrl{i} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_ctrl{i} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_ctrl{i} = trans_REM_to_REM;
    
    
    
    
    st_sws_ctrl{i} = Start(stages_ctrl{i}.SWSEpoch);
    idx_sws_ctrl{i} = find(mindurSWS<dur_SWS_ctrl_bis{i},1,'first');
    latency_sws_ctrl(i) =  st_sws_ctrl{i}(idx_sws_ctrl{i});
    
    
    st_rem_ctrl{i} = Start(stages_ctrl{i}.REMEpoch);
    idx_rem_ctrl{i} = find(mindurREM<dur_REM_ctrl_bis{i},1,'first');
    latency_rem_ctrl(i) =  st_rem_ctrl{i}(idx_rem_ctrl{i});
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for i=1:length(dur_REM_ctrl)
    %%ALL SESSION
    data_dur_REM_ctrl(i,:) = dur_REM_ctrl{i}; data_dur_REM_ctrl(isnan(data_dur_REM_ctrl)==1)=0;
    data_dur_SWS_ctrl(i,:) = dur_SWS_ctrl{i}; data_dur_SWS_ctrl(isnan(data_dur_SWS_ctrl)==1)=0;
    data_dur_WAKE_ctrl(i,:) = dur_WAKE_ctrl{i}; data_dur_WAKE_ctrl(isnan(data_dur_WAKE_ctrl)==1)=0;
    data_dur_totSleep_ctrl(i,:) = dur_totSleepctrl{i}; data_dur_totSleep_ctrl(isnan(data_dur_totSleep_ctrl)==1)=0;
    
    data_num_REM_ctrl(i,:) = num_REM_ctrl{i};data_num_REM_ctrl(isnan(data_num_REM_ctrl)==1)=0;
    data_num_SWS_ctrl(i,:) = num_SWS_ctrl{i}; data_num_SWS_ctrl(isnan(data_num_SWS_ctrl)==1)=0;
    data_num_WAKE_ctrl(i,:) = num_WAKE_ctrl{i}; data_num_WAKE_ctrl(isnan(data_num_WAKE_ctrl)==1)=0;
    data_num_totSleep_ctrl(i,:) = num_totSleepctrl{i}; data_num_totSleep_ctrl(isnan(data_num_totSleep_ctrl)==1)=0;
    
    data_perc_REM_ctrl(i,:) = perc_REM_ctrl{i}; data_perc_REM_ctrl(isnan(data_perc_REM_ctrl)==1)=0;
    data_perc_SWS_ctrl(i,:) = perc_SWS_ctrl{i}; data_perc_SWS_ctrl(isnan(data_perc_SWS_ctrl)==1)=0;
    data_perc_WAKE_ctrl(i,:) = perc_WAKE_ctrl{i}; data_perc_WAKE_ctrl(isnan(data_perc_WAKE_ctrl)==1)=0;
    data_perc_totSleep_ctrl(i,:) = perc_totSleepctrl{i}; data_perc_totSleep_ctrl(isnan(data_perc_totSleep_ctrl)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_ctrl(i,:) = dur_REM_begin_ctrl{i}; data_dur_REM_begin_ctrl(isnan(data_dur_REM_begin_ctrl)==1)=0;
    data_dur_SWS_begin_ctrl(i,:) = dur_SWS_begin_ctrl{i}; data_dur_SWS_begin_ctrl(isnan(data_dur_SWS_begin_ctrl)==1)=0;
    data_dur_WAKE_begin_ctrl(i,:) = dur_WAKE_begin_ctrl{i}; data_dur_WAKE_begin_ctrl(isnan(data_dur_WAKE_begin_ctrl)==1)=0;
    data_dur_totSleep_begin_ctrl(i,:) = dur_totSleep_begin_ctrl{i}; data_dur_totSleep_begin_ctrl(isnan(data_dur_totSleep_begin_ctrl)==1)=0;
    
    
    data_num_REM_begin_ctrl(i,:) = num_REM_begin_ctrl{i};data_num_REM_begin_ctrl(isnan(data_num_REM_begin_ctrl)==1)=0;
    data_num_SWS_begin_ctrl(i,:) = num_SWS_begin_ctrl{i}; data_num_SWS_begin_ctrl(isnan(data_num_SWS_begin_ctrl)==1)=0;
    data_num_WAKE_begin_ctrl(i,:) = num_WAKE_begin_ctrl{i}; data_num_WAKE_begin_ctrl(isnan(data_num_WAKE_begin_ctrl)==1)=0;
    data_num_totSleep_begin_ctrl(i,:) = num_totSleep_begin_ctrl{i}; data_num_totSleep_begin_ctrl(isnan(data_num_totSleep_begin_ctrl)==1)=0;
    
    data_perc_REM_begin_ctrl(i,:) = perc_REM_begin_ctrl{i}; data_perc_REM_begin_ctrl(isnan(data_perc_REM_begin_ctrl)==1)=0;
    data_perc_SWS_begin_ctrl(i,:) = perc_SWS_begin_ctrl{i}; data_perc_SWS_begin_ctrl(isnan(data_perc_SWS_begin_ctrl)==1)=0;
    data_perc_WAKE_begin_ctrl(i,:) = perc_WAKE_begin_ctrl{i}; data_perc_WAKE_begin_ctrl(isnan(data_perc_WAKE_begin_ctrl)==1)=0;
    data_perc_totSleep_begin_ctrl(i,:) = perc_totSleep_begin_ctrl{i}; data_perc_totSleep_begin_ctrl(isnan(data_perc_totSleep_begin_ctrl)==1)=0;
    
    data_dur_REM_interPeriod_ctrl(i,:) = dur_REM_interPeriod_ctrl{i}; data_dur_REM_interPeriod_ctrl(isnan(data_dur_REM_interPeriod_ctrl)==1)=0;
    data_dur_SWS_interPeriod_ctrl(i,:) = dur_SWS_interPeriod_ctrl{i}; data_dur_SWS_interPeriod_ctrl(isnan(data_dur_SWS_interPeriod_ctrl)==1)=0;
    data_dur_WAKE_interPeriod_ctrl(i,:) = dur_WAKE_interPeriod_ctrl{i}; data_dur_WAKE_interPeriod_ctrl(isnan(data_dur_WAKE_interPeriod_ctrl)==1)=0;
    data_dur_totSleep_interPeriod_ctrl(i,:) = dur_totSleep_interPeriod_ctrl{i}; data_dur_totSleep_interPeriod_ctrl(isnan(data_dur_totSleep_interPeriod_ctrl)==1)=0;
    
    
    data_num_REM_interPeriod_ctrl(i,:) = num_REM_interPeriod_ctrl{i};data_num_REM_interPeriod_ctrl(isnan(data_num_REM_interPeriod_ctrl)==1)=0;
    data_num_SWS_interPeriod_ctrl(i,:) = num_SWS_interPeriod_ctrl{i}; data_num_SWS_interPeriod_ctrl(isnan(data_num_SWS_interPeriod_ctrl)==1)=0;
    data_num_WAKE_interPeriod_ctrl(i,:) = num_WAKE_interPeriod_ctrl{i}; data_num_WAKE_interPeriod_ctrl(isnan(data_num_WAKE_interPeriod_ctrl)==1)=0;
    data_num_totSleep_interPeriod_ctrl(i,:) = num_totSleep_interPeriod_ctrl{i}; data_num_totSleep_interPeriod_ctrl(isnan(data_num_totSleep_interPeriod_ctrl)==1)=0;
    
    data_perc_REM_interPeriod_ctrl(i,:) = perc_REM_interPeriod_ctrl{i}; data_perc_REM_interPeriod_ctrl(isnan(data_perc_REM_interPeriod_ctrl)==1)=0;
    data_perc_SWS_interPeriod_ctrl(i,:) = perc_SWS_interPeriod_ctrl{i}; data_perc_SWS_interPeriod_ctrl(isnan(data_perc_SWS_interPeriod_ctrl)==1)=0;
    data_perc_WAKE_interPeriod_ctrl(i,:) = perc_WAKE_interPeriod_ctrl{i}; data_perc_WAKE_interPeriod_ctrl(isnan(data_perc_WAKE_interPeriod_ctrl)==1)=0;
    data_perc_totSleep_interPeriod_ctrl(i,:) = perc_totSleep_interPeriod_ctrl{i}; data_perc_totSleep_interPeriod_ctrl(isnan(data_perc_totSleep_interPeriod_ctrl)==1)=0;
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_ctrl(i,:) = dur_REM_end_ctrl{i}; data_dur_REM_end_ctrl(isnan(data_dur_REM_end_ctrl)==1)=0;
    data_dur_SWS_end_ctrl(i,:) = dur_SWS_end_ctrl{i}; data_dur_SWS_end_ctrl(isnan(data_dur_SWS_end_ctrl)==1)=0;
    data_dur_WAKE_end_ctrl(i,:) = dur_WAKE_end_ctrl{i}; data_dur_WAKE_end_ctrl(isnan(data_dur_WAKE_end_ctrl)==1)=0;
    data_dur_totSleep_end_ctrl(i,:) = dur_totSleep_end_ctrl{i}; data_dur_totSleep_end_ctrl(isnan(data_dur_totSleep_end_ctrl)==1)=0;
    
    
    data_num_REM_end_ctrl(i,:) = num_REM_end_ctrl{i};data_num_REM_end_ctrl(isnan(data_num_REM_end_ctrl)==1)=0;
    data_num_SWS_end_ctrl(i,:) = num_SWS_end_ctrl{i}; data_num_SWS_end_ctrl(isnan(data_num_SWS_end_ctrl)==1)=0;
    data_num_WAKE_end_ctrl(i,:) = num_WAKE_end_ctrl{i}; data_num_WAKE_end_ctrl(isnan(data_num_WAKE_end_ctrl)==1)=0;
    data_num_totSleep_end_ctrl(i,:) = num_totSleep_end_ctrl{i}; data_num_totSleep_end_ctrl(isnan(data_num_totSleep_end_ctrl)==1)=0;
    
    
    data_perc_REM_end_ctrl(i,:) = perc_REM_end_ctrl{i}; data_perc_REM_end_ctrl(isnan(data_perc_REM_end_ctrl)==1)=0;
    data_perc_SWS_end_ctrl(i,:) = perc_SWS_end_ctrl{i}; data_perc_SWS_end_ctrl(isnan(data_perc_SWS_end_ctrl)==1)=0;
    data_perc_WAKE_end_ctrl(i,:) = perc_WAKE_end_ctrl{i}; data_perc_WAKE_end_ctrl(isnan(data_perc_WAKE_end_ctrl)==1)=0;
    data_perc_totSleep_end_ctrl(i,:) = perc_totSleep_end_ctrl{i}; data_perc_totSleep_end_ctrl(isnan(data_perc_totSleep_end_ctrl)==1)=0;
    
end
%% probability
for i=1:length(all_trans_REM_short_WAKE_end_ctrl)
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
%         data_REM_REM_begin_ctrl(i,:) = all_trans_REM_REM_begin_ctrl{i}; data_REM_REM_begin_ctrl(isnan(data_REM_REM_begin_ctrl)==1)=0;
%     data_REM_SWS_begin_ctrl(i,:) = all_trans_REM_SWS_begin_ctrl{i}; data_REM_SWS_begin_ctrl(isnan(data_REM_SWS_begin_ctrl)==1)=0;
%     data_REM_WAKE_begin_ctrl(i,:) = all_trans_REM_WAKE_begin_ctrl{i}; data_REM_WAKE_begin_ctrl(isnan(data_REM_WAKE_begin_ctrl)==1)=0;
%
%     data_SWS_SWS_begin_ctrl(i,:) = all_trans_SWS_SWS_begin_ctrl{i}; data_SWS_SWS_begin_ctrl(isnan(data_SWS_SWS_begin_ctrl)==1)=0;
%     data_SWS_REM_begin_ctrl(i,:) = all_trans_SWS_REM_begin_ctrl{i}; data_SWS_REM_begin_ctrl(isnan(data_SWS_REM_begin_ctrl)==1)=0;
%     data_SWS_WAKE_begin_ctrl(i,:) = all_trans_SWS_WAKE_begin_ctrl{i}; data_SWS_WAKE_begin_ctrl(isnan(data_SWS_WAKE_begin_ctrl)==1)=0;
%
%     data_WAKE_WAKE_begin_ctrl(i,:) = all_trans_WAKE_WAKE_begin_ctrl{i}; data_WAKE_WAKE_begin_ctrl(isnan(data_WAKE_WAKE_begin_ctrl)==1)=0;
%     data_WAKE_REM_begin_ctrl(i,:) = all_trans_WAKE_REM_begin_ctrl{i}; data_WAKE_REM_begin_ctrl(isnan(data_WAKE_REM_begin_ctrl)==1)=0;
%     data_WAKE_SWS_begin_ctrl(i,:) = all_trans_WAKE_SWS_begin_ctrl{i}; data_WAKE_SWS_begin_ctrl(isnan(data_WAKE_SWS_begin_ctrl)==1)=0;
%
%     %%FIN DE LA SESSION
%         data_REM_REM_end_ctrl(i,:) = all_trans_REM_REM_end_ctrl{i}; data_REM_REM_end_ctrl(isnan(data_REM_REM_end_ctrl)==1)=0;
%     data_REM_SWS_end_ctrl(i,:) = all_trans_REM_SWS_end_ctrl{i}; data_REM_SWS_end_ctrl(isnan(data_REM_SWS_end_ctrl)==1)=0;
%     data_REM_WAKE_end_ctrl(i,:) = all_trans_REM_WAKE_end_ctrl{i}; data_REM_WAKE_end_ctrl(isnan(data_REM_WAKE_end_ctrl)==1)=0;
%
%     data_SWS_SWS_end_ctrl(i,:) = all_trans_SWS_SWS_end_ctrl{i}; data_SWS_SWS_end_ctrl(isnan(data_SWS_SWS_end_ctrl)==1)=0;
%     data_SWS_REM_end_ctrl(i,:) = all_trans_SWS_REM_end_ctrl{i}; data_SWS_REM_end_ctrl(isnan(data_SWS_REM_end_ctrl)==1)=0;
%     data_SWS_WAKE_end_ctrl(i,:) = all_trans_SWS_WAKE_end_ctrl{i}; data_SWS_WAKE_end_ctrl(isnan(data_SWS_WAKE_end_ctrl)==1)=0;
%
%     data_WAKE_WAKE_end_ctrl(i,:) = all_trans_WAKE_WAKE_end_ctrl{i}; data_WAKE_WAKE_end_ctrl(isnan(data_WAKE_WAKE_end_ctrl)==1)=0;
%     data_WAKE_REM_end_ctrl(i,:) = all_trans_WAKE_REM_end_ctrl{i}; data_WAKE_REM_end_ctrl(isnan(data_WAKE_REM_end_ctrl)==1)=0;
%     data_WAKE_SWS_end_ctrl(i,:) = all_trans_WAKE_SWS_end_ctrl{i}; data_WAKE_SWS_end_ctrl(isnan(data_WAKE_SWS_end_ctrl)==1)=0;
%
%
%
    data_REM_short_WAKE_end_ctrl(i,:) = all_trans_REM_short_WAKE_end_ctrl{i}; %data_REM_short_WAKE_end_ctrl(isnan(data_REM_short_WAKE_end_ctrl)==1)=0;
    data_REM_short_SWS_end_ctrl(i,:) = all_trans_REM_short_SWS_end_ctrl{i};% data_REM_short_SWS_end_ctrl(isnan(data_REM_short_SWS_end_ctrl)==1)=0;
    data_REM_short_REM_end_ctrl(i,:) = all_trans_REM_short_REM_end_ctrl{i}; %data_REM_short_WAKE_end_ctrl(isnan(data_REM_short_WAKE_end_ctrl)==1)=0;

    data_REM_mid_WAKE_end_ctrl(i,:) = all_trans_REM_mid_WAKE_end_ctrl{i}; %data_REM_mid_WAKE_end_ctrl(isnan(data_REM_mid_WAKE_end_ctrl)==1)=0;
    data_REM_mid_SWS_end_ctrl(i,:) = all_trans_REM_mid_SWS_end_ctrl{i}; %data_REM_mid_SWS_end_ctrl(isnan(data_REM_mid_SWS_end_ctrl)==1)=0;
    data_REM_mid_REM_end_ctrl(i,:) = all_trans_REM_mid_REM_end_ctrl{i}; %data_REM_mid_WAKE_end_ctrl(isnan(data_REM_short_WAKE_end_ctrl)==1)=0;

    data_REM_long_WAKE_end_ctrl(i,:) = all_trans_REM_long_WAKE_end_ctrl{i}; %data_REM_long_WAKE_end_ctrl(isnan(data_REM_long_WAKE_end_ctrl)==1)=0;
    data_REM_long_SWS_end_ctrl(i,:) = all_trans_REM_long_SWS_end_ctrl{i}; %data_REM_long_SWS_end_ctrl(isnan(data_REM_long_SWS_end_ctrl)==1)=0;
    data_REM_long_REM_end_ctrl(i,:) = all_trans_REM_long_REM_end_ctrl{i}; %data_REM_long_WAKE_end_ctrl(isnan(data_REM_short_WAKE_end_ctrl)==1)=0;

end






%% GET DATA - SD mCherry saline
for k=1:length(DirSocialDefeat_classic.path)
    cd(DirSocialDefeat_classic.path{k}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    same_epoch_SD{k} = intervalSet(0,time_end);
    same_epoch_begin_SD{k} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_SD{k} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_SD{k} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
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
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_SD{k}=dur_moyenne_ep_totSleep;
    num_totSleep_SD{k}=num_moyen_ep_totSleep;
    perc_totSleep_SD{k}=perc_moyen_totSleep;
    
    
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_begin_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_begin_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_begin_SD{k}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_SD{k}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_SD{k}=num_moyen_ep_WAKE;
    perc_WAKE_begin_SD{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_begin_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_begin_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_begin_SD{k}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_begin_SD{k}=num_moyen_ep_SWS;
    perc_SWS_begin_SD{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_begin_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_begin_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_begin_SD{k}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_SD{k}=dur_moyenne_ep_REM;
    num_REM_begin_SD{k}=num_moyen_ep_REM;
    perc_REM_begin_SD{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_begin_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_begin_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_begin_SD{k}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_SD{k}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_SD{k}=num_moyen_ep_totSleep;
    perc_totSleep_begin_SD{k}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_begin_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_begin_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_begin_SD{k}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_SD{k} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_SD{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_SD{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_SD{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_SD{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_SD{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_SD{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_SD{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_SD{k} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_interPeriod_SD{k}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_SD{k}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD{k}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_interPeriod_SD{k}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD{k}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_interPeriod_SD{k}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_SD{k}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD{k}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_interPeriod_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_interPeriod_SD{k}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_SD{k}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_SD{k}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_SD{k}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_SD{k}=dur_moyenne_ep_WAKE;
    num_WAKE_end_SD{k}=num_moyen_ep_WAKE;
    perc_WAKE_end_SD{k}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_end_SD{k}=num_moyen_ep_SWS;
    perc_SWS_end_SD{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_SD{k}=dur_moyenne_ep_REM;
    num_REM_end_SD{k}=num_moyen_ep_REM;
    perc_REM_end_SD{k}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD{k}.Wake,same_epoch_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_SD{k}=dur_moyenne_ep_totSleep;
    num_totSleep_end_SD{k}=num_moyen_ep_totSleep;
    perc_totSleep_end_SD{k}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_end_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_SD{k} = trans_REM_to_REM;
    all_trans_REM_SWS_end_SD{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_SD{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_SD{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_SD{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_SD{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_SD{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_SD{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_SD{k} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
        [dur_WAKE_SD_bis{k}, durT_WAKE_SD(k)]=DurationEpoch(and(stages_SD{k}.Wake,same_epoch_end_SD{k}),'s');
    [dur_SWS_SD_bis{k}, durT_SWS_SD(k)]=DurationEpoch(and(stages_SD{k}.SWSEpoch,same_epoch_end_SD{k}),'s');
    
    [dur_REM_SD_bis{k}, durT_REM_SD(k)]=DurationEpoch(and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}),'s');
    
    idx_short_rem_SD_1{k} = find(dur_REM_SD_bis{k}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_SD_1{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}), idx_short_rem_SD_1{k});
    [dur_rem_short_SD_1{k}, durT_rem_short_SD(k)] = DurationEpoch(short_REMEpoch_SD_1{k},'s');
    perc_rem_short_SD_1(k) = durT_rem_short_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_short_SD_1(k) = nanmean(dur_rem_short_SD_1{k});
    num_moyen_rem_short_SD_1(k) = length(dur_rem_short_SD_1{k});
    
    idx_short_rem_SD_2{k} = find(dur_REM_SD_bis{k}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_SD_2{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}), idx_short_rem_SD_2{k});
    [dur_rem_short_SD_2{k}, durT_rem_short_SD(k)] = DurationEpoch(short_REMEpoch_SD_2{k},'s');
    perc_rem_short_SD_2(k) = durT_rem_short_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_short_SD_2(k) = nanmean(dur_rem_short_SD_2{k});
    num_moyen_rem_short_SD_2(k) = length(dur_rem_short_SD_2{k});
    
    idx_short_rem_SD_3{k} = find(dur_REM_SD_bis{k}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_SD_3{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}), idx_short_rem_SD_3{k});
    [dur_rem_short_SD_3{k}, durT_rem_short_SD(k)] = DurationEpoch(short_REMEpoch_SD_3{k},'s');
    perc_rem_short_SD_3(k) = durT_rem_short_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_short_SD_3(k) = nanmean(dur_rem_short_SD_3{k});
    num_moyen_rem_short_SD_3(k) = length(dur_rem_short_SD_3{k});
    
    idx_long_rem_SD{k} = find(dur_REM_SD_bis{k}>lim_long_rem); %long bout
    long_REMEpoch_SD{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}), idx_long_rem_SD{k});
    [dur_rem_long_SD{k}, durT_rem_long_SD(k)] = DurationEpoch(long_REMEpoch_SD{k},'s');
    perc_rem_long_SD(k) = durT_rem_long_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_long_SD(k) = nanmean(dur_rem_long_SD{k});
    num_moyen_rem_long_SD(k) = length(dur_rem_long_SD{k});
    
    idx_mid_rem_SD{k} = find(dur_REM_SD_bis{k}>lim_short_rem_1 & dur_REM_SD_bis{k}<lim_long_rem); % middle bouts
    mid_REMEpoch_SD{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_end_SD{k}), idx_mid_rem_SD{k});
    [dur_rem_mid_SD{k}, durT_rem_mid_SD(k)] = DurationEpoch(mid_REMEpoch_SD{k},'s');
    perc_rem_mid_SD(k) = durT_rem_mid_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_mid_SD(k) = nanmean(dur_rem_mid_SD{k});
    num_moyen_rem_mid_SD(k) = length(dur_rem_mid_SD{k});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_end_SD{k}),and(short_REMEpoch_SD_1{k},same_epoch_end_SD{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_SD{k} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_SD{k} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_SD{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_end_SD{k}),and(mid_REMEpoch_SD{k},same_epoch_end_SD{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_SD{k} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_SD{k} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_SD{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_end_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_end_SD{k}),and(long_REMEpoch_SD{k},same_epoch_end_SD{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_SD{k} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_SD{k} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_SD{k} = trans_REM_to_REM;
    
        st_sws_SD{k} = Start(stages_SD{k}.SWSEpoch);
    idx_sws_SD{k} = find(mindurSWS<dur_SWS_SD_bis{k},1,'first');
    latency_sws_SD(k) =  st_sws_SD{k}(idx_sws_SD{k});
    
    
    st_rem_SD{k} = Start(stages_SD{k}.REMEpoch);
    idx_rem_SD{k} = find(mindurREM<dur_REM_SD_bis{k},1,'first');
    latency_rem_SD(k) =  st_rem_SD{k}(idx_rem_SD{k});
    
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for k=1:length(dur_REM_SD)
    %%ALL SESSION
    data_dur_REM_SD(k,:) = dur_REM_SD{k}; data_dur_REM_SD(isnan(data_dur_REM_SD)==1)=0;
    data_dur_SWS_SD(k,:) = dur_SWS_SD{k}; data_dur_SWS_SD(isnan(data_dur_SWS_SD)==1)=0;
    data_dur_WAKE_SD(k,:) = dur_WAKE_SD{k}; data_dur_WAKE_SD(isnan(data_dur_WAKE_SD)==1)=0;
    data_dur_totSleep_SD(k,:) = dur_totSleep_SD{k}; data_dur_totSleep_SD(isnan(data_dur_totSleep_SD)==1)=0;
    
    data_num_REM_SD(k,:) = num_REM_SD{k};data_num_REM_SD(isnan(data_num_REM_SD)==1)=0;
    data_num_SWS_SD(k,:) = num_SWS_SD{k}; data_num_SWS_SD(isnan(data_num_SWS_SD)==1)=0;
    data_num_WAKE_SD(k,:) = num_WAKE_SD{k}; data_num_WAKE_SD(isnan(data_num_WAKE_SD)==1)=0;
    data_num_totSleep_SD(k,:) = num_totSleep_SD{k}; data_num_totSleep_SD(isnan(data_num_totSleep_SD)==1)=0;
    
    data_perc_REM_SD(k,:) = perc_REM_SD{k}; data_perc_REM_SD(isnan(data_perc_REM_SD)==1)=0;
    data_perc_SWS_SD(k,:) = perc_SWS_SD{k}; data_perc_SWS_SD(isnan(data_perc_SWS_SD)==1)=0;
    data_perc_WAKE_SD(k,:) = perc_WAKE_SD{k}; data_perc_WAKE_SD(isnan(data_perc_WAKE_SD)==1)=0;
    data_perc_totSleep_SD(k,:) = perc_totSleep_SD{k}; data_perc_totSleep_SD(isnan(data_perc_totSleep_SD)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_SD(k,:) = dur_REM_begin_SD{k}; data_dur_REM_begin_SD(isnan(data_dur_REM_begin_SD)==1)=0;
    data_dur_SWS_begin_SD(k,:) = dur_SWS_begin_SD{k}; data_dur_SWS_begin_SD(isnan(data_dur_SWS_begin_SD)==1)=0;
    data_dur_WAKE_begin_SD(k,:) = dur_WAKE_begin_SD{k}; data_dur_WAKE_begin_SD(isnan(data_dur_WAKE_begin_SD)==1)=0;
    data_dur_totSleep_begin_SD(k,:) = dur_totSleep_begin_SD{k}; data_dur_totSleep_begin_SD(isnan(data_dur_totSleep_begin_SD)==1)=0;
    
    
    data_num_REM_begin_SD(k,:) = num_REM_begin_SD{k};data_num_REM_begin_SD(isnan(data_num_REM_begin_SD)==1)=0;
    data_num_SWS_begin_SD(k,:) = num_SWS_begin_SD{k}; data_num_SWS_begin_SD(isnan(data_num_SWS_begin_SD)==1)=0;
    data_num_WAKE_begin_SD(k,:) = num_WAKE_begin_SD{k}; data_num_WAKE_begin_SD(isnan(data_num_WAKE_begin_SD)==1)=0;
    data_num_totSleep_begin_SD(k,:) = num_totSleep_begin_SD{k}; data_num_totSleep_begin_SD(isnan(data_num_totSleep_begin_SD)==1)=0;
    
    data_perc_REM_begin_SD(k,:) = perc_REM_begin_SD{k}; data_perc_REM_begin_SD(isnan(data_perc_REM_begin_SD)==1)=0;
    data_perc_SWS_begin_SD(k,:) = perc_SWS_begin_SD{k}; data_perc_SWS_begin_SD(isnan(data_perc_SWS_begin_SD)==1)=0;
    data_perc_WAKE_begin_SD(k,:) = perc_WAKE_begin_SD{k}; data_perc_WAKE_begin_SD(isnan(data_perc_WAKE_begin_SD)==1)=0;
    data_perc_totSleep_begin_SD(k,:) = perc_totSleep_begin_SD{k}; data_perc_totSleep_begin_SD(isnan(data_perc_totSleep_begin_SD)==1)=0;
    
    data_dur_REM_interPeriod_SD(k,:) = dur_REM_interPeriod_SD{k}; data_dur_REM_interPeriod_SD(isnan(data_dur_REM_interPeriod_SD)==1)=0;
    data_dur_SWS_interPeriod_SD(k,:) = dur_SWS_interPeriod_SD{k}; data_dur_SWS_interPeriod_SD(isnan(data_dur_SWS_interPeriod_SD)==1)=0;
    data_dur_WAKE_interPeriod_SD(k,:) = dur_WAKE_interPeriod_SD{k}; data_dur_WAKE_interPeriod_SD(isnan(data_dur_WAKE_interPeriod_SD)==1)=0;
    data_dur_totSleep_interPeriod_SD(k,:) = dur_totSleep_interPeriod_SD{k}; data_dur_totSleep_interPeriod_SD(isnan(data_dur_totSleep_interPeriod_SD)==1)=0;
    
    
    data_num_REM_interPeriod_SD(k,:) = num_REM_interPeriod_SD{k};data_num_REM_interPeriod_SD(isnan(data_num_REM_interPeriod_SD)==1)=0;
    data_num_SWS_interPeriod_SD(k,:) = num_SWS_interPeriod_SD{k}; data_num_SWS_interPeriod_SD(isnan(data_num_SWS_interPeriod_SD)==1)=0;
    data_num_WAKE_interPeriod_SD(k,:) = num_WAKE_interPeriod_SD{k}; data_num_WAKE_interPeriod_SD(isnan(data_num_WAKE_interPeriod_SD)==1)=0;
    data_num_totSleep_interPeriod_SD(k,:) = num_totSleep_interPeriod_SD{k}; data_num_totSleep_interPeriod_SD(isnan(data_num_totSleep_interPeriod_SD)==1)=0;
    
    data_perc_REM_interPeriod_SD(k,:) = perc_REM_interPeriod_SD{k}; data_perc_REM_interPeriod_SD(isnan(data_perc_REM_interPeriod_SD)==1)=0;
    data_perc_SWS_interPeriod_SD(k,:) = perc_SWS_interPeriod_SD{k}; data_perc_SWS_interPeriod_SD(isnan(data_perc_SWS_interPeriod_SD)==1)=0;
    data_perc_WAKE_interPeriod_SD(k,:) = perc_WAKE_interPeriod_SD{k}; data_perc_WAKE_interPeriod_SD(isnan(data_perc_WAKE_interPeriod_SD)==1)=0;
    data_perc_totSleep_interPeriod_SD(k,:) = perc_totSleep_interPeriod_SD{k}; data_perc_totSleep_interPeriod_SD(isnan(data_perc_totSleep_interPeriod_SD)==1)=0;
    
    %%FIN DE LA SESSION
    data_dur_REM_end_SD(k,:) = dur_REM_end_SD{k}; data_dur_REM_end_SD(isnan(data_dur_REM_end_SD)==1)=0;
    data_dur_SWS_end_SD(k,:) = dur_SWS_end_SD{k}; data_dur_SWS_end_SD(isnan(data_dur_SWS_end_SD)==1)=0;
    data_dur_WAKE_end_SD(k,:) = dur_WAKE_end_SD{k}; data_dur_WAKE_end_SD(isnan(data_dur_WAKE_end_SD)==1)=0;
    data_dur_totSleep_end_SD(k,:) = dur_totSleep_end_SD{k}; data_dur_totSleep_end_SD(isnan(data_dur_totSleep_end_SD)==1)=0;
    
    
    data_num_REM_end_SD(k,:) = num_REM_end_SD{k};data_num_REM_end_SD(isnan(data_num_REM_end_SD)==1)=0;
    data_num_SWS_end_SD(k,:) = num_SWS_end_SD{k}; data_num_SWS_end_SD(isnan(data_num_SWS_end_SD)==1)=0;
    data_num_WAKE_end_SD(k,:) = num_WAKE_end_SD{k}; data_num_WAKE_end_SD(isnan(data_num_WAKE_end_SD)==1)=0;
    data_num_totSleep_end_SD(k,:) = num_totSleep_end_SD{k}; data_num_totSleep_end_SD(isnan(data_num_totSleep_end_SD)==1)=0;
    
    
    data_perc_REM_end_SD(k,:) = perc_REM_end_SD{k}; data_perc_REM_end_SD(isnan(data_perc_REM_end_SD)==1)=0;
    data_perc_SWS_end_SD(k,:) = perc_SWS_end_SD{k}; data_perc_SWS_end_SD(isnan(data_perc_SWS_end_SD)==1)=0;
    data_perc_WAKE_end_SD(k,:) = perc_WAKE_end_SD{k}; data_perc_WAKE_end_SD(isnan(data_perc_WAKE_end_SD)==1)=0;
    data_perc_totSleep_end_SD(k,:) = perc_totSleep_end_SD{k}; data_perc_totSleep_end_SD(isnan(data_perc_totSleep_end_SD)==1)=0;
    
end
%%
%probability
for k=1:length(all_trans_REM_short_WAKE_end_SD)
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
    %         data_REM_REM_begin_SD(k,:) = all_trans_REM_REM_begin_SD{k}; data_REM_REM_begin_SD(isnan(data_REM_REM_begin_SD)==1)=0;
    %     data_REM_SWS_begin_SD(k,:) = all_trans_REM_SWS_begin_SD{k}; data_REM_SWS_begin_SD(isnan(data_REM_SWS_begin_SD)==1)=0;
    %     data_REM_WAKE_begin_SD(k,:) = all_trans_REM_WAKE_begin_SD{k}; data_REM_WAKE_begin_SD(isnan(data_REM_WAKE_begin_SD)==1)=0;
    %
    %     data_SWS_SWS_begin_SD(k,:) = all_trans_SWS_SWS_begin_SD{k}; data_SWS_SWS_begin_SD(isnan(data_SWS_SWS_begin_SD)==1)=0;
    %     data_SWS_REM_begin_SD(k,:) = all_trans_SWS_REM_begin_SD{k}; data_SWS_REM_begin_SD(isnan(data_SWS_REM_begin_SD)==1)=0;
    %     data_SWS_WAKE_begin_SD(k,:) = all_trans_SWS_WAKE_begin_SD{k}; data_SWS_WAKE_begin_SD(isnan(data_SWS_WAKE_begin_SD)==1)=0;
    %
    %     data_WAKE_WAKE_begin_SD(k,:) = all_trans_WAKE_WAKE_begin_SD{k}; data_WAKE_WAKE_begin_SD(isnan(data_WAKE_WAKE_begin_SD)==1)=0;
    %     data_WAKE_REM_begin_SD(k,:) = all_trans_WAKE_REM_begin_SD{k}; data_WAKE_REM_begin_SD(isnan(data_WAKE_REM_begin_SD)==1)=0;
    %     data_WAKE_SWS_begin_SD(k,:) = all_trans_WAKE_SWS_begin_SD{k}; data_WAKE_SWS_begin_SD(isnan(data_WAKE_SWS_begin_SD)==1)=0;
    %
    %     %%FIN DE LA SESSION
    %         data_REM_REM_end_SD(k,:) = all_trans_REM_REM_end_SD{k}; data_REM_REM_end_SD(isnan(data_REM_REM_end_SD)==1)=0;
    %     data_REM_SWS_end_SD(k,:) = all_trans_REM_SWS_end_SD{k}; data_REM_SWS_end_SD(isnan(data_REM_SWS_end_SD)==1)=0;
    %     data_REM_WAKE_end_SD(k,:) = all_trans_REM_WAKE_end_SD{k}; data_REM_WAKE_end_SD(isnan(data_REM_WAKE_end_SD)==1)=0;
    %
    %     data_SWS_SWS_end_SD(k,:) = all_trans_SWS_SWS_end_SD{k}; data_SWS_SWS_end_SD(isnan(data_SWS_SWS_end_SD)==1)=0;
    %     data_SWS_REM_end_SD(k,:) = all_trans_SWS_REM_end_SD{k}; data_SWS_REM_end_SD(isnan(data_SWS_REM_end_SD)==1)=0;
    %     data_SWS_WAKE_end_SD(k,:) = all_trans_SWS_WAKE_end_SD{k}; data_SWS_WAKE_end_SD(isnan(data_SWS_WAKE_end_SD)==1)=0;
    %
    %     data_WAKE_WAKE_end_SD(k,:) = all_trans_WAKE_WAKE_end_SD{k}; data_WAKE_WAKE_end_SD(isnan(data_WAKE_WAKE_end_SD)==1)=0;
    %     data_WAKE_REM_end_SD(k,:) = all_trans_WAKE_REM_end_SD{k}; data_WAKE_REM_end_SD(isnan(data_WAKE_REM_end_SD)==1)=0;
    %     data_WAKE_SWS_end_SD(k,:) = all_trans_WAKE_SWS_end_SD{k}; data_WAKE_SWS_end_SD(isnan(data_WAKE_SWS_end_SD)==1)=0;
    %
    data_REM_short_WAKE_end_SD(k,:) = all_trans_REM_short_WAKE_end_SD{k}; data_REM_short_WAKE_end_SD(isnan(data_REM_short_WAKE_end_SD)==1)=0;
    data_REM_short_SWS_end_SD(k,:) = all_trans_REM_short_SWS_end_SD{k}; data_REM_short_SWS_end_SD(isnan(data_REM_short_SWS_end_SD)==1)=0;
    
    data_REM_mid_WAKE_end_SD(k,:) = all_trans_REM_mid_WAKE_end_SD{k}; data_REM_mid_WAKE_end_SD(isnan(data_REM_mid_WAKE_end_SD)==1)=0;
    data_REM_mid_SWS_end_SD(k,:) = all_trans_REM_mid_SWS_end_SD{k}; data_REM_mid_SWS_end_SD(isnan(data_REM_mid_SWS_end_SD)==1)=0;
    
    data_REM_long_WAKE_end_SD(k,:) = all_trans_REM_long_WAKE_end_SD{k}; data_REM_long_WAKE_end_SD(isnan(data_REM_long_WAKE_end_SD)==1)=0;
    data_REM_long_SWS_end_SD(k,:) = all_trans_REM_long_SWS_end_SD{k}; data_REM_long_SWS_end_SD(isnan(data_REM_long_SWS_end_SD)==1)=0;
    
    data_REM_short_REM_end_SD(k,:) = all_trans_REM_short_REM_end_SD{k}; %data_REM_short_REM_end_SD(isnan(data_REM_short_REM_end_SD)==1)=0;
    data_REM_mid_REM_end_SD(k,:) = all_trans_REM_mid_REM_end_SD{k}; %data_REM_mid_REM_end_SD(isnan(data_REM_mid_REM_end_SD)==1)=0;
    data_REM_long_REM_end_SD(k,:) = all_trans_REM_long_REM_end_SD{k}; %data_REM_long_REM_end_SD(isnan(data_REM_long_REM_end_SD)==1)=0;
    
end





%% GET DATA - SD dreadd cno
for j=1:length(DirSocialDefeat_totSleepPost_mCherry_cno.path)
    cd(DirSocialDefeat_totSleepPost_mCherry_cno.path{j}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_mCherry_cno{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_mCherry_cno{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_SD_mCherry_cno{j} = intervalSet(0,time_end);
    same_epoch_begin_SD_mCherry_cno{j} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_SD_mCherry_cno{j} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_SD_mCherry_cno{j} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    
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
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_SD_mCherry_cno{j}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_SD_mCherry_cno{j}=dur_moyenne_ep_totSleep;
    num_totSleep_SD_mCherry_cno{j}=num_moyen_ep_totSleep;
    perc_totSleep_SD_mCherry_cno{j}=perc_moyen_totSleep;
    
    
    
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
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_begin_SD_mCherry_cno{j}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_SD_mCherry_cno{j}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_SD_mCherry_cno{j}=num_moyen_ep_WAKE;
    perc_WAKE_begin_SD_mCherry_cno{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_begin_SD_mCherry_cno{j}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_begin_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_begin_SD_mCherry_cno{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_begin_SD_mCherry_cno{j}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_begin_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_begin_SD_mCherry_cno{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_begin_SD_mCherry_cno{j}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_SD_mCherry_cno{j}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_SD_mCherry_cno{j}=num_moyen_ep_totSleep;
    perc_totSleep_begin_SD_mCherry_cno{j}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_begin_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_begin_SD_mCherry_cno{j}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_SD_mCherry_cno{j} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_SD_mCherry_cno{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_SD_mCherry_cno{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_SD_mCherry_cno{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_SD_mCherry_cno{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_SD_mCherry_cno{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_SD_mCherry_cno{j} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_SD_mCherry_cno{j}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD_mCherry_cno{j}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD_mCherry_cno{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD_mCherry_cno{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD_mCherry_cno{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_interPeriod_SD_mCherry_cno{j}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_SD_mCherry_cno{j}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_SD_mCherry_cno{j}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_SD_mCherry_cno{j}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_SD_mCherry_cno{j}=dur_moyenne_ep_WAKE;
    num_WAKE_end_SD_mCherry_cno{j}=num_moyen_ep_WAKE;
    perc_WAKE_end_SD_mCherry_cno{j}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_end_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_end_SD_mCherry_cno{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_end_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_end_SD_mCherry_cno{j}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_SD_mCherry_cno{j}=dur_moyenne_ep_totSleep;
    num_totSleep_end_SD_mCherry_cno{j}=num_moyen_ep_totSleep;
    perc_totSleep_end_SD_mCherry_cno{j}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_SD_mCherry_cno{j} = trans_REM_to_REM;
    all_trans_REM_SWS_end_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_SD_mCherry_cno{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_SD_mCherry_cno{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_SD_mCherry_cno{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_SD_mCherry_cno{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_SD_mCherry_cno{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_SD_mCherry_cno{j} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_WAKE_SD_mCherry_cno_bis{j}, durT_WAKE_SD_mCherry_cno(j)]=DurationEpoch(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_end_SD_mCherry_cno{j}),'s');
    [dur_SWS_SD_mCherry_cno_bis{j}, durT_SWS_SD_mCherry_cno(j)]=DurationEpoch(and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_end_SD_mCherry_cno{j}),'s');
    
    
    [dur_REM_SD_mCherry_cno_bis{j}, durT_REM_SD_mCherry_cno(j)]=DurationEpoch(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}),'s');
    
    idx_short_rem_SD_mCherry_cno_1{j} = find(dur_REM_SD_mCherry_cno_bis{j}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_SD_mCherry_cno_1{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}), idx_short_rem_SD_mCherry_cno_1{j});
    [dur_rem_short_SD_mCherry_cno_1{j}, durT_rem_short_SD_mCherry_cno(j)] = DurationEpoch(short_REMEpoch_SD_mCherry_cno_1{j},'s');
    perc_rem_short_SD_mCherry_cno_1(j) = durT_rem_short_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_short_SD_mCherry_cno_1(j) = nanmean(dur_rem_short_SD_mCherry_cno_1{j});
    num_moyen_rem_short_SD_mCherry_cno_1(j) = length(dur_rem_short_SD_mCherry_cno_1{j});
    
    idx_short_rem_SD_mCherry_cno_2{j} = find(dur_REM_SD_mCherry_cno_bis{j}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_SD_mCherry_cno_2{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}), idx_short_rem_SD_mCherry_cno_2{j});
    [dur_rem_short_SD_mCherry_cno_2{j}, durT_rem_short_SD_mCherry_cno(j)] = DurationEpoch(short_REMEpoch_SD_mCherry_cno_2{j},'s');
    perc_rem_short_SD_mCherry_cno_2(j) = durT_rem_short_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_short_SD_mCherry_cno_2(j) = nanmean(dur_rem_short_SD_mCherry_cno_2{j});
    num_moyen_rem_short_SD_mCherry_cno_2(j) = length(dur_rem_short_SD_mCherry_cno_2{j});
    
    idx_short_rem_SD_mCherry_cno_3{j} = find(dur_REM_SD_mCherry_cno_bis{j}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_SD_mCherry_cno_3{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}), idx_short_rem_SD_mCherry_cno_3{j});
    [dur_rem_short_SD_mCherry_cno_3{j}, durT_rem_short_SD_mCherry_cno(j)] = DurationEpoch(short_REMEpoch_SD_mCherry_cno_3{j},'s');
    perc_rem_short_SD_mCherry_cno_3(j) = durT_rem_short_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_short_SD_mCherry_cno_3(j) = nanmean(dur_rem_short_SD_mCherry_cno_3{j});
    num_moyen_rem_short_SD_mCherry_cno_3(j) = length(dur_rem_short_SD_mCherry_cno_3{j});
    
    idx_long_rem_SD_mCherry_cno{j} = find(dur_REM_SD_mCherry_cno_bis{j}>lim_long_rem); %long bout
    long_REMEpoch_SD_mCherry_cno{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}), idx_long_rem_SD_mCherry_cno{j});
    [dur_rem_long_SD_mCherry_cno{j}, durT_rem_long_SD_mCherry_cno(j)] = DurationEpoch(long_REMEpoch_SD_mCherry_cno{j},'s');
    perc_rem_long_SD_mCherry_cno(j) = durT_rem_long_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_long_SD_mCherry_cno(j) = nanmean(dur_rem_long_SD_mCherry_cno{j});
    num_moyen_rem_long_SD_mCherry_cno(j) = length(dur_rem_long_SD_mCherry_cno{j});
    
    idx_mid_rem_SD_mCherry_cno{j} = find(dur_REM_SD_mCherry_cno_bis{j}>lim_short_rem_1 & dur_REM_SD_mCherry_cno_bis{j}<lim_long_rem); % middle bouts
    mid_REMEpoch_SD_mCherry_cno{j} = subset(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_end_SD_mCherry_cno{j}), idx_mid_rem_SD_mCherry_cno{j});
    [dur_rem_mid_SD_mCherry_cno{j}, durT_rem_mid_SD_mCherry_cno(j)] = DurationEpoch(mid_REMEpoch_SD_mCherry_cno{j},'s');
    perc_rem_mid_SD_mCherry_cno(j) = durT_rem_mid_SD_mCherry_cno(j) / durT_REM_SD_mCherry_cno(j) * 100;
    dur_moyenne_rem_mid_SD_mCherry_cno(j) = nanmean(dur_rem_mid_SD_mCherry_cno{j});
    num_moyen_rem_mid_SD_mCherry_cno(j) = length(dur_rem_mid_SD_mCherry_cno{j});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_end_SD_mCherry_cno{j}),and(short_REMEpoch_SD_mCherry_cno_1{j},same_epoch_end_SD_mCherry_cno{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_SD_mCherry_cno{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_end_SD_mCherry_cno{j}),and(mid_REMEpoch_SD_mCherry_cno{j},same_epoch_end_SD_mCherry_cno{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_SD_mCherry_cno{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_end_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_end_SD_mCherry_cno{j}),and(long_REMEpoch_SD_mCherry_cno{j},same_epoch_end_SD_mCherry_cno{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_SD_mCherry_cno{j} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_SD_mCherry_cno{j} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_SD_mCherry_cno{j} = trans_REM_to_REM;
    
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for j=1:length(dur_REM_SD_mCherry_cno)
    %%ALL SESSION
    data_dur_REM_SD_mCherry_cno(j,:) = dur_REM_SD_mCherry_cno{j}; data_dur_REM_SD_mCherry_cno(isnan(data_dur_REM_SD_mCherry_cno)==1)=0;
    data_dur_SWS_SD_mCherry_cno(j,:) = dur_SWS_SD_mCherry_cno{j}; data_dur_SWS_SD_mCherry_cno(isnan(data_dur_SWS_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_SD_mCherry_cno(j,:) = dur_WAKE_SD_mCherry_cno{j}; data_dur_WAKE_SD_mCherry_cno(isnan(data_dur_WAKE_SD_mCherry_cno)==1)=0;
    data_dur_totSleep_SD_mCherry_cno(j,:) = dur_totSleep_SD_mCherry_cno{j}; data_dur_totSleep_SD_mCherry_cno(isnan(data_dur_totSleep_SD_mCherry_cno)==1)=0;
    
    data_num_REM_SD_mCherry_cno(j,:) = num_REM_SD_mCherry_cno{j};data_num_REM_SD_mCherry_cno(isnan(data_num_REM_SD_mCherry_cno)==1)=0;
    data_num_SWS_SD_mCherry_cno(j,:) = num_SWS_SD_mCherry_cno{j}; data_num_SWS_SD_mCherry_cno(isnan(data_num_SWS_SD_mCherry_cno)==1)=0;
    data_num_WAKE_SD_mCherry_cno(j,:) = num_WAKE_SD_mCherry_cno{j}; data_num_WAKE_SD_mCherry_cno(isnan(data_num_WAKE_SD_mCherry_cno)==1)=0;
    data_num_totSleep_SD_mCherry_cno(j,:) = num_totSleep_SD_mCherry_cno{j}; data_num_totSleep_SD_mCherry_cno(isnan(data_num_totSleep_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_SD_mCherry_cno(j,:) = perc_REM_SD_mCherry_cno{j}; data_perc_REM_SD_mCherry_cno(isnan(data_perc_REM_SD_mCherry_cno)==1)=0;
    data_perc_SWS_SD_mCherry_cno(j,:) = perc_SWS_SD_mCherry_cno{j}; data_perc_SWS_SD_mCherry_cno(isnan(data_perc_SWS_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_SD_mCherry_cno(j,:) = perc_WAKE_SD_mCherry_cno{j}; data_perc_WAKE_SD_mCherry_cno(isnan(data_perc_WAKE_SD_mCherry_cno)==1)=0;
    data_perc_totSleep_SD_mCherry_cno(j,:) = perc_totSleep_SD_mCherry_cno{j}; data_perc_totSleep_SD_mCherry_cno(isnan(data_perc_totSleep_SD_mCherry_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_SD_mCherry_cno(j,:) = dur_REM_begin_SD_mCherry_cno{j}; data_dur_REM_begin_SD_mCherry_cno(isnan(data_dur_REM_begin_SD_mCherry_cno)==1)=0;
    data_dur_SWS_begin_SD_mCherry_cno(j,:) = dur_SWS_begin_SD_mCherry_cno{j}; data_dur_SWS_begin_SD_mCherry_cno(isnan(data_dur_SWS_begin_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_begin_SD_mCherry_cno(j,:) = dur_WAKE_begin_SD_mCherry_cno{j}; data_dur_WAKE_begin_SD_mCherry_cno(isnan(data_dur_WAKE_begin_SD_mCherry_cno)==1)=0;
    data_dur_totSleep_begin_SD_mCherry_cno(j,:) = dur_totSleep_begin_SD_mCherry_cno{j}; data_dur_totSleep_begin_SD_mCherry_cno(isnan(data_dur_totSleep_begin_SD_mCherry_cno)==1)=0;
    
    
    data_num_REM_begin_SD_mCherry_cno(j,:) = num_REM_begin_SD_mCherry_cno{j};data_num_REM_begin_SD_mCherry_cno(isnan(data_num_REM_begin_SD_mCherry_cno)==1)=0;
    data_num_SWS_begin_SD_mCherry_cno(j,:) = num_SWS_begin_SD_mCherry_cno{j}; data_num_SWS_begin_SD_mCherry_cno(isnan(data_num_SWS_begin_SD_mCherry_cno)==1)=0;
    data_num_WAKE_begin_SD_mCherry_cno(j,:) = num_WAKE_begin_SD_mCherry_cno{j}; data_num_WAKE_begin_SD_mCherry_cno(isnan(data_num_WAKE_begin_SD_mCherry_cno)==1)=0;
    data_num_totSleep_begin_SD_mCherry_cno(j,:) = num_totSleep_begin_SD_mCherry_cno{j}; data_num_totSleep_begin_SD_mCherry_cno(isnan(data_num_totSleep_begin_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_begin_SD_mCherry_cno(j,:) = perc_REM_begin_SD_mCherry_cno{j}; data_perc_REM_begin_SD_mCherry_cno(isnan(data_perc_REM_begin_SD_mCherry_cno)==1)=0;
    data_perc_SWS_begin_SD_mCherry_cno(j,:) = perc_SWS_begin_SD_mCherry_cno{j}; data_perc_SWS_begin_SD_mCherry_cno(isnan(data_perc_SWS_begin_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_begin_SD_mCherry_cno(j,:) = perc_WAKE_begin_SD_mCherry_cno{j}; data_perc_WAKE_begin_SD_mCherry_cno(isnan(data_perc_WAKE_begin_SD_mCherry_cno)==1)=0;
    data_perc_totSleep_begin_SD_mCherry_cno(j,:) = perc_totSleep_begin_SD_mCherry_cno{j}; data_perc_totSleep_begin_SD_mCherry_cno(isnan(data_perc_totSleep_begin_SD_mCherry_cno)==1)=0;
    
    data_dur_REM_interPeriod_SD_mCherry_cno(j,:) = dur_REM_interPeriod_SD_mCherry_cno{j}; data_dur_REM_interPeriod_SD_mCherry_cno(isnan(data_dur_REM_interPeriod_SD_mCherry_cno)==1)=0;
    data_dur_SWS_interPeriod_SD_mCherry_cno(j,:) = dur_SWS_interPeriod_SD_mCherry_cno{j}; data_dur_SWS_interPeriod_SD_mCherry_cno(isnan(data_dur_SWS_interPeriod_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_interPeriod_SD_mCherry_cno(j,:) = dur_WAKE_interPeriod_SD_mCherry_cno{j}; data_dur_WAKE_interPeriod_SD_mCherry_cno(isnan(data_dur_WAKE_interPeriod_SD_mCherry_cno)==1)=0;
    data_dur_totSleep_interPeriod_SD_mCherry_cno(j,:) = dur_totSleep_interPeriod_SD_mCherry_cno{j}; data_dur_totSleep_interPeriod_SD_mCherry_cno(isnan(data_dur_totSleep_interPeriod_SD_mCherry_cno)==1)=0;
    
    
    data_num_REM_interPeriod_SD_mCherry_cno(j,:) = num_REM_interPeriod_SD_mCherry_cno{j};data_num_REM_interPeriod_SD_mCherry_cno(isnan(data_num_REM_interPeriod_SD_mCherry_cno)==1)=0;
    data_num_SWS_interPeriod_SD_mCherry_cno(j,:) = num_SWS_interPeriod_SD_mCherry_cno{j}; data_num_SWS_interPeriod_SD_mCherry_cno(isnan(data_num_SWS_interPeriod_SD_mCherry_cno)==1)=0;
    data_num_WAKE_interPeriod_SD_mCherry_cno(j,:) = num_WAKE_interPeriod_SD_mCherry_cno{j}; data_num_WAKE_interPeriod_SD_mCherry_cno(isnan(data_num_WAKE_interPeriod_SD_mCherry_cno)==1)=0;
    data_num_totSleep_interPeriod_SD_mCherry_cno(j,:) = num_totSleep_interPeriod_SD_mCherry_cno{j}; data_num_totSleep_interPeriod_SD_mCherry_cno(isnan(data_num_totSleep_interPeriod_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_interPeriod_SD_mCherry_cno(j,:) = perc_REM_interPeriod_SD_mCherry_cno{j}; data_perc_REM_interPeriod_SD_mCherry_cno(isnan(data_perc_REM_interPeriod_SD_mCherry_cno)==1)=0;
    data_perc_SWS_interPeriod_SD_mCherry_cno(j,:) = perc_SWS_interPeriod_SD_mCherry_cno{j}; data_perc_SWS_interPeriod_SD_mCherry_cno(isnan(data_perc_SWS_interPeriod_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_interPeriod_SD_mCherry_cno(j,:) = perc_WAKE_interPeriod_SD_mCherry_cno{j}; data_perc_WAKE_interPeriod_SD_mCherry_cno(isnan(data_perc_WAKE_interPeriod_SD_mCherry_cno)==1)=0;
    data_perc_totSleep_interPeriod_SD_mCherry_cno(j,:) = perc_totSleep_interPeriod_SD_mCherry_cno{j}; data_perc_totSleep_interPeriod_SD_mCherry_cno(isnan(data_perc_totSleep_interPeriod_SD_mCherry_cno)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_SD_mCherry_cno(j,:) = dur_REM_end_SD_mCherry_cno{j}; data_dur_REM_end_SD_mCherry_cno(isnan(data_dur_REM_end_SD_mCherry_cno)==1)=0;
    data_dur_SWS_end_SD_mCherry_cno(j,:) = dur_SWS_end_SD_mCherry_cno{j}; data_dur_SWS_end_SD_mCherry_cno(isnan(data_dur_SWS_end_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_end_SD_mCherry_cno(j,:) = dur_WAKE_end_SD_mCherry_cno{j}; data_dur_WAKE_end_SD_mCherry_cno(isnan(data_dur_WAKE_end_SD_mCherry_cno)==1)=0;
    data_dur_totSleep_end_SD_mCherry_cno(j,:) = dur_totSleep_end_SD_mCherry_cno{j}; data_dur_totSleep_end_SD_mCherry_cno(isnan(data_dur_totSleep_end_SD_mCherry_cno)==1)=0;
    
    
    data_num_REM_end_SD_mCherry_cno(j,:) = num_REM_end_SD_mCherry_cno{j};data_num_REM_end_SD_mCherry_cno(isnan(data_num_REM_end_SD_mCherry_cno)==1)=0;
    data_num_SWS_end_SD_mCherry_cno(j,:) = num_SWS_end_SD_mCherry_cno{j}; data_num_SWS_end_SD_mCherry_cno(isnan(data_num_SWS_end_SD_mCherry_cno)==1)=0;
    data_num_WAKE_end_SD_mCherry_cno(j,:) = num_WAKE_end_SD_mCherry_cno{j}; data_num_WAKE_end_SD_mCherry_cno(isnan(data_num_WAKE_end_SD_mCherry_cno)==1)=0;
    data_num_totSleep_end_SD_mCherry_cno(j,:) = num_totSleep_end_SD_mCherry_cno{j}; data_num_totSleep_end_SD_mCherry_cno(isnan(data_num_totSleep_end_SD_mCherry_cno)==1)=0;
    
    
    data_perc_REM_end_SD_mCherry_cno(j,:) = perc_REM_end_SD_mCherry_cno{j}; data_perc_REM_end_SD_mCherry_cno(isnan(data_perc_REM_end_SD_mCherry_cno)==1)=0;
    data_perc_SWS_end_SD_mCherry_cno(j,:) = perc_SWS_end_SD_mCherry_cno{j}; data_perc_SWS_end_SD_mCherry_cno(isnan(data_perc_SWS_end_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_end_SD_mCherry_cno(j,:) = perc_WAKE_end_SD_mCherry_cno{j}; data_perc_WAKE_end_SD_mCherry_cno(isnan(data_perc_WAKE_end_SD_mCherry_cno)==1)=0;
    data_perc_totSleep_end_SD_mCherry_cno(j,:) = perc_totSleep_end_SD_mCherry_cno{j}; data_perc_totSleep_end_SD_mCherry_cno(isnan(data_perc_totSleep_end_SD_mCherry_cno)==1)=0;
    
end

for j=1:length(all_trans_REM_REM_SD_mCherry_cno)
    data_REM_short_WAKE_end_SD_mCherry_cno(j,:) = all_trans_REM_short_WAKE_end_SD_mCherry_cno{j}; data_REM_short_WAKE_end_SD_mCherry_cno(isnan(data_REM_short_WAKE_end_SD_mCherry_cno)==1)=0;
    data_REM_short_SWS_end_SD_mCherry_cno(j,:) = all_trans_REM_short_SWS_end_SD_mCherry_cno{j}; data_REM_short_SWS_end_SD_mCherry_cno(isnan(data_REM_short_SWS_end_SD_mCherry_cno)==1)=0;
        data_REM_short_REM_end_SD_mCherry_cno(j,:) = all_trans_REM_short_REM_end_SD_mCherry_cno{j}; data_REM_short_REM_end_SD_mCherry_cno(isnan(data_REM_short_REM_end_SD_mCherry_cno)==1)=0;

    data_REM_mid_WAKE_end_SD_mCherry_cno(j,:) = all_trans_REM_mid_WAKE_end_SD_mCherry_cno{j}; data_REM_mid_WAKE_end_SD_mCherry_cno(isnan(data_REM_mid_WAKE_end_SD_mCherry_cno)==1)=0;
    data_REM_mid_SWS_end_SD_mCherry_cno(j,:) = all_trans_REM_mid_SWS_end_SD_mCherry_cno{j}; data_REM_mid_SWS_end_SD_mCherry_cno(isnan(data_REM_mid_SWS_end_SD_mCherry_cno)==1)=0;
    
    data_REM_long_WAKE_end_SD_mCherry_cno(j,:) = all_trans_REM_long_WAKE_end_SD_mCherry_cno{j}; data_REM_long_WAKE_end_SD_mCherry_cno(isnan(data_REM_long_WAKE_end_SD_mCherry_cno)==1)=0;
    data_REM_long_SWS_end_SD_mCherry_cno(j,:) = all_trans_REM_long_SWS_end_SD_mCherry_cno{j}; data_REM_long_SWS_end_SD_mCherry_cno(isnan(data_REM_long_SWS_end_SD_mCherry_cno)==1)=0;
    
    data_REM_mid_REM_end_SD_mCherry_cno(j,:) = all_trans_REM_mid_REM_end_SD_mCherry_cno{j}; data_REM_mid_REM_end_SD_mCherry_cno(isnan(data_REM_mid_REM_end_SD_mCherry_cno)==1)=0;
    data_REM_long_REM_end_SD_mCherry_cno(j,:) = all_trans_REM_long_REM_end_SD_mCherry_cno{j}; data_REM_long_REM_end_SD_mCherry_cno(isnan(data_REM_long_REM_end_SD_mCherry_cno)==1)=0;
    
end





%% GET DATA - SD dreadd cno
for m=1:length(DirSocialDefeat_totSleepPost_dreadd_cno.path)
    cd(DirSocialDefeat_totSleepPost_dreadd_cno.path{m}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_dreadd_cno{m} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_dreadd_cno{m} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_SD_dreadd_cno{m} = intervalSet(0,time_end);
    same_epoch_begin_SD_dreadd_cno{m} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_SD_dreadd_cno{m} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_SD_dreadd_cno{m} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    
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
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_SD_dreadd_cno{m}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_SD_dreadd_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_SD_dreadd_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_SD_dreadd_cno{m}=perc_moyen_totSleep;
    
    
    
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
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_begin_SD_dreadd_cno{m}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_SD_dreadd_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_SD_dreadd_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_begin_SD_dreadd_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_begin_SD_dreadd_cno{m}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_begin_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_begin_SD_dreadd_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_begin_SD_dreadd_cno{m}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_begin_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_begin_SD_dreadd_cno{m}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_begin_SD_dreadd_cno{m}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_SD_dreadd_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_SD_dreadd_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_begin_SD_dreadd_cno{m}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_begin_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_begin_SD_dreadd_cno{m}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_SD_dreadd_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_SD_dreadd_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_SD_dreadd_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_SD_dreadd_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_SD_dreadd_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_SD_dreadd_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_SD_dreadd_cno{m} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_SD_dreadd_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_SD_dreadd_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_SD_dreadd_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_SD_dreadd_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_interPeriod_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_interPeriod_SD_dreadd_cno{m}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_interPeriod_SD_dreadd_cno{m}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_SD_dreadd_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_SD_dreadd_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_SD_dreadd_cno{m}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_SD_dreadd_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_end_SD_dreadd_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_end_SD_dreadd_cno{m}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_end_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_end_SD_dreadd_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_end_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_end_SD_dreadd_cno{m}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_SD_dreadd_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_end_SD_dreadd_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_end_SD_dreadd_cno{m}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_SD_dreadd_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_end_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_SD_dreadd_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_SD_dreadd_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_SD_dreadd_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_SD_dreadd_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_SD_dreadd_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_SD_dreadd_cno{m} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_WAKE_SD_dreadd_cno_bis{m}, durT_WAKE_SD_dreadd_cno(m)]=DurationEpoch(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_end_SD_dreadd_cno{m}),'s');
    [dur_SWS_SD_dreadd_cno_bis{m}, durT_SWS_SD_dreadd_cno(m)]=DurationEpoch(and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_end_SD_dreadd_cno{m}),'s');
    
    [dur_REM_SD_dreadd_cno_bis{m}, durT_REM_SD_dreadd_cno(m)]=DurationEpoch(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}),'s');
    
    idx_short_rem_SD_dreadd_cno_1{m} = find(dur_REM_SD_dreadd_cno_bis{m}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_SD_dreadd_cno_1{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}), idx_short_rem_SD_dreadd_cno_1{m});
    [dur_rem_short_SD_dreadd_cno_1{m}, durT_rem_short_SD_dreadd_cno(m)] = DurationEpoch(short_REMEpoch_SD_dreadd_cno_1{m},'s');
    perc_rem_short_SD_dreadd_cno_1(m) = durT_rem_short_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_short_SD_dreadd_cno_1(m) = nanmean(dur_rem_short_SD_dreadd_cno_1{m});
    num_moyen_rem_short_SD_dreadd_cno_1(m) = length(dur_rem_short_SD_dreadd_cno_1{m});
    
    idx_short_rem_SD_dreadd_cno_2{m} = find(dur_REM_SD_dreadd_cno_bis{m}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_SD_dreadd_cno_2{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}), idx_short_rem_SD_dreadd_cno_2{m});
    [dur_rem_short_SD_dreadd_cno_2{m}, durT_rem_short_SD_dreadd_cno(m)] = DurationEpoch(short_REMEpoch_SD_dreadd_cno_2{m},'s');
    perc_rem_short_SD_dreadd_cno_2(m) = durT_rem_short_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_short_SD_dreadd_cno_2(m) = nanmean(dur_rem_short_SD_dreadd_cno_2{m});
    num_moyen_rem_short_SD_dreadd_cno_2(m) = length(dur_rem_short_SD_dreadd_cno_2{m});
    
    idx_short_rem_SD_dreadd_cno_3{m} = find(dur_REM_SD_dreadd_cno_bis{m}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_SD_dreadd_cno_3{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}), idx_short_rem_SD_dreadd_cno_3{m});
    [dur_rem_short_SD_dreadd_cno_3{m}, durT_rem_short_SD_dreadd_cno(m)] = DurationEpoch(short_REMEpoch_SD_dreadd_cno_3{m},'s');
    perc_rem_short_SD_dreadd_cno_3(m) = durT_rem_short_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_short_SD_dreadd_cno_3(m) = nanmean(dur_rem_short_SD_dreadd_cno_3{m});
    num_moyen_rem_short_SD_dreadd_cno_3(m) = length(dur_rem_short_SD_dreadd_cno_3{m});
    
    idx_long_rem_SD_dreadd_cno{m} = find(dur_REM_SD_dreadd_cno_bis{m}>lim_long_rem); %long bout
    long_REMEpoch_SD_dreadd_cno{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}), idx_long_rem_SD_dreadd_cno{m});
    [dur_rem_long_SD_dreadd_cno{m}, durT_rem_long_SD_dreadd_cno(m)] = DurationEpoch(long_REMEpoch_SD_dreadd_cno{m},'s');
    perc_rem_long_SD_dreadd_cno(m) = durT_rem_long_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_long_SD_dreadd_cno(m) = nanmean(dur_rem_long_SD_dreadd_cno{m});
    num_moyen_rem_long_SD_dreadd_cno(m) = length(dur_rem_long_SD_dreadd_cno{m});
    
    idx_mid_rem_SD_dreadd_cno{m} = find(dur_REM_SD_dreadd_cno_bis{m}>lim_short_rem_1 & dur_REM_SD_dreadd_cno_bis{m}<lim_long_rem); % middle bouts
    mid_REMEpoch_SD_dreadd_cno{m} = subset(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_end_SD_dreadd_cno{m}), idx_mid_rem_SD_dreadd_cno{m});
    [dur_rem_mid_SD_dreadd_cno{m}, durT_rem_mid_SD_dreadd_cno(m)] = DurationEpoch(mid_REMEpoch_SD_dreadd_cno{m},'s');
    perc_rem_mid_SD_dreadd_cno(m) = durT_rem_mid_SD_dreadd_cno(m) / durT_REM_SD_dreadd_cno(m) * 100;
    dur_moyenne_rem_mid_SD_dreadd_cno(m) = nanmean(dur_rem_mid_SD_dreadd_cno{m});
    num_moyen_rem_mid_SD_dreadd_cno(m) = length(dur_rem_mid_SD_dreadd_cno{m});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_end_SD_dreadd_cno{m}),and(short_REMEpoch_SD_dreadd_cno_1{m},same_epoch_end_SD_dreadd_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_SD_dreadd_cno{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_end_SD_dreadd_cno{m}),and(mid_REMEpoch_SD_dreadd_cno{m},same_epoch_end_SD_dreadd_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_SD_dreadd_cno{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_end_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_end_SD_dreadd_cno{m}),and(long_REMEpoch_SD_dreadd_cno{m},same_epoch_end_SD_dreadd_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_SD_dreadd_cno{m} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_SD_dreadd_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_SD_dreadd_cno{m} = trans_REM_to_REM;
    
    
end

%% compute average - ctrl group (mCherry saline injection 10h)
%%percentage/duration/number
for m=1:length(dur_REM_SD_dreadd_cno)
    %%ALL SESSION
    data_dur_REM_SD_dreadd_cno(m,:) = dur_REM_SD_dreadd_cno{m}; data_dur_REM_SD_dreadd_cno(isnan(data_dur_REM_SD_dreadd_cno)==1)=0;
    data_dur_SWS_SD_dreadd_cno(m,:) = dur_SWS_SD_dreadd_cno{m}; data_dur_SWS_SD_dreadd_cno(isnan(data_dur_SWS_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_SD_dreadd_cno(m,:) = dur_WAKE_SD_dreadd_cno{m}; data_dur_WAKE_SD_dreadd_cno(isnan(data_dur_WAKE_SD_dreadd_cno)==1)=0;
    data_dur_totSleep_SD_dreadd_cno(m,:) = dur_totSleep_SD_dreadd_cno{m}; data_dur_totSleep_SD_dreadd_cno(isnan(data_dur_totSleep_SD_dreadd_cno)==1)=0;
    
    data_num_REM_SD_dreadd_cno(m,:) = num_REM_SD_dreadd_cno{m};data_num_REM_SD_dreadd_cno(isnan(data_num_REM_SD_dreadd_cno)==1)=0;
    data_num_SWS_SD_dreadd_cno(m,:) = num_SWS_SD_dreadd_cno{m}; data_num_SWS_SD_dreadd_cno(isnan(data_num_SWS_SD_dreadd_cno)==1)=0;
    data_num_WAKE_SD_dreadd_cno(m,:) = num_WAKE_SD_dreadd_cno{m}; data_num_WAKE_SD_dreadd_cno(isnan(data_num_WAKE_SD_dreadd_cno)==1)=0;
    data_num_totSleep_SD_dreadd_cno(m,:) = num_totSleep_SD_dreadd_cno{m}; data_num_totSleep_SD_dreadd_cno(isnan(data_num_totSleep_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_SD_dreadd_cno(m,:) = perc_REM_SD_dreadd_cno{m}; data_perc_REM_SD_dreadd_cno(isnan(data_perc_REM_SD_dreadd_cno)==1)=0;
    data_perc_SWS_SD_dreadd_cno(m,:) = perc_SWS_SD_dreadd_cno{m}; data_perc_SWS_SD_dreadd_cno(isnan(data_perc_SWS_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_SD_dreadd_cno(m,:) = perc_WAKE_SD_dreadd_cno{m}; data_perc_WAKE_SD_dreadd_cno(isnan(data_perc_WAKE_SD_dreadd_cno)==1)=0;
    data_perc_totSleep_SD_dreadd_cno(m,:) = perc_totSleep_SD_dreadd_cno{m}; data_perc_totSleep_SD_dreadd_cno(isnan(data_perc_totSleep_SD_dreadd_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_SD_dreadd_cno(m,:) = dur_REM_begin_SD_dreadd_cno{m}; data_dur_REM_begin_SD_dreadd_cno(isnan(data_dur_REM_begin_SD_dreadd_cno)==1)=0;
    data_dur_SWS_begin_SD_dreadd_cno(m,:) = dur_SWS_begin_SD_dreadd_cno{m}; data_dur_SWS_begin_SD_dreadd_cno(isnan(data_dur_SWS_begin_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_begin_SD_dreadd_cno(m,:) = dur_WAKE_begin_SD_dreadd_cno{m}; data_dur_WAKE_begin_SD_dreadd_cno(isnan(data_dur_WAKE_begin_SD_dreadd_cno)==1)=0;
    data_dur_totSleep_begin_SD_dreadd_cno(m,:) = dur_totSleep_begin_SD_dreadd_cno{m}; data_dur_totSleep_begin_SD_dreadd_cno(isnan(data_dur_totSleep_begin_SD_dreadd_cno)==1)=0;
    
    
    data_num_REM_begin_SD_dreadd_cno(m,:) = num_REM_begin_SD_dreadd_cno{m};data_num_REM_begin_SD_dreadd_cno(isnan(data_num_REM_begin_SD_dreadd_cno)==1)=0;
    data_num_SWS_begin_SD_dreadd_cno(m,:) = num_SWS_begin_SD_dreadd_cno{m}; data_num_SWS_begin_SD_dreadd_cno(isnan(data_num_SWS_begin_SD_dreadd_cno)==1)=0;
    data_num_WAKE_begin_SD_dreadd_cno(m,:) = num_WAKE_begin_SD_dreadd_cno{m}; data_num_WAKE_begin_SD_dreadd_cno(isnan(data_num_WAKE_begin_SD_dreadd_cno)==1)=0;
    data_num_totSleep_begin_SD_dreadd_cno(m,:) = num_totSleep_begin_SD_dreadd_cno{m}; data_num_totSleep_begin_SD_dreadd_cno(isnan(data_num_totSleep_begin_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_begin_SD_dreadd_cno(m,:) = perc_REM_begin_SD_dreadd_cno{m}; data_perc_REM_begin_SD_dreadd_cno(isnan(data_perc_REM_begin_SD_dreadd_cno)==1)=0;
    data_perc_SWS_begin_SD_dreadd_cno(m,:) = perc_SWS_begin_SD_dreadd_cno{m}; data_perc_SWS_begin_SD_dreadd_cno(isnan(data_perc_SWS_begin_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_begin_SD_dreadd_cno(m,:) = perc_WAKE_begin_SD_dreadd_cno{m}; data_perc_WAKE_begin_SD_dreadd_cno(isnan(data_perc_WAKE_begin_SD_dreadd_cno)==1)=0;
    data_perc_totSleep_begin_SD_dreadd_cno(m,:) = perc_totSleep_begin_SD_dreadd_cno{m}; data_perc_totSleep_begin_SD_dreadd_cno(isnan(data_perc_totSleep_begin_SD_dreadd_cno)==1)=0;
    
    data_dur_REM_interPeriod_SD_dreadd_cno(m,:) = dur_REM_interPeriod_SD_dreadd_cno{m}; data_dur_REM_interPeriod_SD_dreadd_cno(isnan(data_dur_REM_interPeriod_SD_dreadd_cno)==1)=0;
    data_dur_SWS_interPeriod_SD_dreadd_cno(m,:) = dur_SWS_interPeriod_SD_dreadd_cno{m}; data_dur_SWS_interPeriod_SD_dreadd_cno(isnan(data_dur_SWS_interPeriod_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_interPeriod_SD_dreadd_cno(m,:) = dur_WAKE_interPeriod_SD_dreadd_cno{m}; data_dur_WAKE_interPeriod_SD_dreadd_cno(isnan(data_dur_WAKE_interPeriod_SD_dreadd_cno)==1)=0;
    data_dur_totSleep_interPeriod_SD_dreadd_cno(m,:) = dur_totSleep_interPeriod_SD_dreadd_cno{m}; data_dur_totSleep_interPeriod_SD_dreadd_cno(isnan(data_dur_totSleep_interPeriod_SD_dreadd_cno)==1)=0;
    
    
    data_num_REM_interPeriod_SD_dreadd_cno(m,:) = num_REM_interPeriod_SD_dreadd_cno{m};data_num_REM_interPeriod_SD_dreadd_cno(isnan(data_num_REM_interPeriod_SD_dreadd_cno)==1)=0;
    data_num_SWS_interPeriod_SD_dreadd_cno(m,:) = num_SWS_interPeriod_SD_dreadd_cno{m}; data_num_SWS_interPeriod_SD_dreadd_cno(isnan(data_num_SWS_interPeriod_SD_dreadd_cno)==1)=0;
    data_num_WAKE_interPeriod_SD_dreadd_cno(m,:) = num_WAKE_interPeriod_SD_dreadd_cno{m}; data_num_WAKE_interPeriod_SD_dreadd_cno(isnan(data_num_WAKE_interPeriod_SD_dreadd_cno)==1)=0;
    data_num_totSleep_interPeriod_SD_dreadd_cno(m,:) = num_totSleep_interPeriod_SD_dreadd_cno{m}; data_num_totSleep_interPeriod_SD_dreadd_cno(isnan(data_num_totSleep_interPeriod_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_interPeriod_SD_dreadd_cno(m,:) = perc_REM_interPeriod_SD_dreadd_cno{m}; data_perc_REM_interPeriod_SD_dreadd_cno(isnan(data_perc_REM_interPeriod_SD_dreadd_cno)==1)=0;
    data_perc_SWS_interPeriod_SD_dreadd_cno(m,:) = perc_SWS_interPeriod_SD_dreadd_cno{m}; data_perc_SWS_interPeriod_SD_dreadd_cno(isnan(data_perc_SWS_interPeriod_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_interPeriod_SD_dreadd_cno(m,:) = perc_WAKE_interPeriod_SD_dreadd_cno{m}; data_perc_WAKE_interPeriod_SD_dreadd_cno(isnan(data_perc_WAKE_interPeriod_SD_dreadd_cno)==1)=0;
    data_perc_totSleep_interPeriod_SD_dreadd_cno(m,:) = perc_totSleep_interPeriod_SD_dreadd_cno{m}; data_perc_totSleep_interPeriod_SD_dreadd_cno(isnan(data_perc_totSleep_interPeriod_SD_dreadd_cno)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_SD_dreadd_cno(m,:) = dur_REM_end_SD_dreadd_cno{m}; data_dur_REM_end_SD_dreadd_cno(isnan(data_dur_REM_end_SD_dreadd_cno)==1)=0;
    data_dur_SWS_end_SD_dreadd_cno(m,:) = dur_SWS_end_SD_dreadd_cno{m}; data_dur_SWS_end_SD_dreadd_cno(isnan(data_dur_SWS_end_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_end_SD_dreadd_cno(m,:) = dur_WAKE_end_SD_dreadd_cno{m}; data_dur_WAKE_end_SD_dreadd_cno(isnan(data_dur_WAKE_end_SD_dreadd_cno)==1)=0;
    data_dur_totSleep_end_SD_dreadd_cno(m,:) = dur_totSleep_end_SD_dreadd_cno{m}; data_dur_totSleep_end_SD_dreadd_cno(isnan(data_dur_totSleep_end_SD_dreadd_cno)==1)=0;
    
    
    data_num_REM_end_SD_dreadd_cno(m,:) = num_REM_end_SD_dreadd_cno{m};data_num_REM_end_SD_dreadd_cno(isnan(data_num_REM_end_SD_dreadd_cno)==1)=0;
    data_num_SWS_end_SD_dreadd_cno(m,:) = num_SWS_end_SD_dreadd_cno{m}; data_num_SWS_end_SD_dreadd_cno(isnan(data_num_SWS_end_SD_dreadd_cno)==1)=0;
    data_num_WAKE_end_SD_dreadd_cno(m,:) = num_WAKE_end_SD_dreadd_cno{m}; data_num_WAKE_end_SD_dreadd_cno(isnan(data_num_WAKE_end_SD_dreadd_cno)==1)=0;
    data_num_totSleep_end_SD_dreadd_cno(m,:) = num_totSleep_end_SD_dreadd_cno{m}; data_num_totSleep_end_SD_dreadd_cno(isnan(data_num_totSleep_end_SD_dreadd_cno)==1)=0;
    
    
    data_perc_REM_end_SD_dreadd_cno(m,:) = perc_REM_end_SD_dreadd_cno{m}; data_perc_REM_end_SD_dreadd_cno(isnan(data_perc_REM_end_SD_dreadd_cno)==1)=0;
    data_perc_SWS_end_SD_dreadd_cno(m,:) = perc_SWS_end_SD_dreadd_cno{m}; data_perc_SWS_end_SD_dreadd_cno(isnan(data_perc_SWS_end_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_end_SD_dreadd_cno(m,:) = perc_WAKE_end_SD_dreadd_cno{m}; data_perc_WAKE_end_SD_dreadd_cno(isnan(data_perc_WAKE_end_SD_dreadd_cno)==1)=0;
    data_perc_totSleep_end_SD_dreadd_cno(m,:) = perc_totSleep_end_SD_dreadd_cno{m}; data_perc_totSleep_end_SD_dreadd_cno(isnan(data_perc_totSleep_end_SD_dreadd_cno)==1)=0;
    
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
% %         data_REM_REM_begin_SD_dreadd_cno(m,:) = all_trans_REM_REM_begin_SD_dreadd_cno{m}; data_REM_REM_begin_SD_dreadd_cno(isnan(data_REM_REM_begin_SD_dreadd_cno)==1)=0;
% %     data_REM_SWS_begin_SD_dreadd_cno(m,:) = all_trans_REM_SWS_begin_SD_dreadd_cno{m}; data_REM_SWS_begin_SD_dreadd_cno(isnan(data_REM_SWS_begin_SD_dreadd_cno)==1)=0;
% %     data_REM_WAKE_begin_SD_dreadd_cno(m,:) = all_trans_REM_WAKE_begin_SD_dreadd_cno{m}; data_REM_WAKE_begin_SD_dreadd_cno(isnan(data_REM_WAKE_begin_SD_dreadd_cno)==1)=0;
% %
% %     data_SWS_SWS_begin_SD_dreadd_cno(m,:) = all_trans_SWS_SWS_begin_SD_dreadd_cno{m}; data_SWS_SWS_begin_SD_dreadd_cno(isnan(data_SWS_SWS_begin_SD_dreadd_cno)==1)=0;
% %     data_SWS_REM_begin_SD_dreadd_cno(m,:) = all_trans_SWS_REM_begin_SD_dreadd_cno{m}; data_SWS_REM_begin_SD_dreadd_cno(isnan(data_SWS_REM_begin_SD_dreadd_cno)==1)=0;
% %     data_SWS_WAKE_begin_SD_dreadd_cno(m,:) = all_trans_SWS_WAKE_begin_SD_dreadd_cno{m}; data_SWS_WAKE_begin_SD_dreadd_cno(isnan(data_SWS_WAKE_begin_SD_dreadd_cno)==1)=0;
% %
% %     data_WAKE_WAKE_begin_SD_dreadd_cno(m,:) = all_trans_WAKE_WAKE_begin_SD_dreadd_cno{m}; data_WAKE_WAKE_begin_SD_dreadd_cno(isnan(data_WAKE_WAKE_begin_SD_dreadd_cno)==1)=0;
% %     data_WAKE_REM_begin_SD_dreadd_cno(m,:) = all_trans_WAKE_REM_begin_SD_dreadd_cno{m}; data_WAKE_REM_begin_SD_dreadd_cno(isnan(data_WAKE_REM_begin_SD_dreadd_cno)==1)=0;
% %     data_WAKE_SWS_begin_SD_dreadd_cno(m,:) = all_trans_WAKE_SWS_begin_SD_dreadd_cno{m}; data_WAKE_SWS_begin_SD_dreadd_cno(isnan(data_WAKE_SWS_begin_SD_dreadd_cno)==1)=0;
% %
% %     %%FIN DE LA SESSION
% %         data_REM_REM_end_SD_dreadd_cno(m,:) = all_trans_REM_REM_end_SD_dreadd_cno{m}; data_REM_REM_end_SD_dreadd_cno(isnan(data_REM_REM_end_SD_dreadd_cno)==1)=0;
% %     data_REM_SWS_end_SD_dreadd_cno(m,:) = all_trans_REM_SWS_end_SD_dreadd_cno{m}; data_REM_SWS_end_SD_dreadd_cno(isnan(data_REM_SWS_end_SD_dreadd_cno)==1)=0;
% %     data_REM_WAKE_end_SD_dreadd_cno(m,:) = all_trans_REM_WAKE_end_SD_dreadd_cno{m}; data_REM_WAKE_end_SD_dreadd_cno(isnan(data_REM_WAKE_end_SD_dreadd_cno)==1)=0;
% %
% %     data_SWS_SWS_end_SD_dreadd_cno(m,:) = all_trans_SWS_SWS_end_SD_dreadd_cno{m}; data_SWS_SWS_end_SD_dreadd_cno(isnan(data_SWS_SWS_end_SD_dreadd_cno)==1)=0;
% %     data_SWS_REM_end_SD_dreadd_cno(m,:) = all_trans_SWS_REM_end_SD_dreadd_cno{m}; data_SWS_REM_end_SD_dreadd_cno(isnan(data_SWS_REM_end_SD_dreadd_cno)==1)=0;
% %     data_SWS_WAKE_end_SD_dreadd_cno(m,:) = all_trans_SWS_WAKE_end_SD_dreadd_cno{m}; data_SWS_WAKE_end_SD_dreadd_cno(isnan(data_SWS_WAKE_end_SD_dreadd_cno)==1)=0;
% %
% %     data_WAKE_WAKE_end_SD_dreadd_cno(m,:) = all_trans_WAKE_WAKE_end_SD_dreadd_cno{m}; data_WAKE_WAKE_end_SD_dreadd_cno(isnan(data_WAKE_WAKE_end_SD_dreadd_cno)==1)=0;
% %     data_WAKE_REM_end_SD_dreadd_cno(m,:) = all_trans_WAKE_REM_end_SD_dreadd_cno{m}; data_WAKE_REM_end_SD_dreadd_cno(isnan(data_WAKE_REM_end_SD_dreadd_cno)==1)=0;
% %     data_WAKE_SWS_end_SD_dreadd_cno(m,:) = all_trans_WAKE_SWS_end_SD_dreadd_cno{m}; data_WAKE_SWS_end_SD_dreadd_cno(isnan(data_WAKE_SWS_end_SD_dreadd_cno)==1)=0;
data_REM_short_WAKE_end_SD_dreadd_cno(m,:) = all_trans_REM_short_WAKE_end_SD_dreadd_cno{m}; data_REM_short_WAKE_end_SD_dreadd_cno(isnan(data_REM_short_WAKE_end_SD_dreadd_cno)==1)=0;
data_REM_short_SWS_end_SD_dreadd_cno(m,:) = all_trans_REM_short_SWS_end_SD_dreadd_cno{m}; data_REM_short_SWS_end_SD_dreadd_cno(isnan(data_REM_short_SWS_end_SD_dreadd_cno)==1)=0;

data_REM_mid_WAKE_end_SD_dreadd_cno(m,:) = all_trans_REM_mid_WAKE_end_SD_dreadd_cno{m}; data_REM_mid_WAKE_end_SD_dreadd_cno(isnan(data_REM_mid_WAKE_end_SD_dreadd_cno)==1)=0;
data_REM_mid_SWS_end_SD_dreadd_cno(m,:) = all_trans_REM_mid_SWS_end_SD_dreadd_cno{m}; data_REM_mid_SWS_end_SD_dreadd_cno(isnan(data_REM_mid_SWS_end_SD_dreadd_cno)==1)=0;

data_REM_long_WAKE_end_SD_dreadd_cno(m,:) = all_trans_REM_long_WAKE_end_SD_dreadd_cno{m}; data_REM_long_WAKE_end_SD_dreadd_cno(isnan(data_REM_long_WAKE_end_SD_dreadd_cno)==1)=0;
data_REM_long_SWS_end_SD_dreadd_cno(m,:) = all_trans_REM_long_SWS_end_SD_dreadd_cno{m}; data_REM_long_SWS_end_SD_dreadd_cno(isnan(data_REM_long_SWS_end_SD_dreadd_cno)==1)=0;


data_REM_short_REM_end_SD_dreadd_cno(m,:) = all_trans_REM_short_REM_end_SD_dreadd_cno{m}; data_REM_short_REM_end_SD_dreadd_cno(isnan(data_REM_short_REM_end_SD_dreadd_cno)==1)=0;
data_REM_mid_REM_end_SD_dreadd_cno(m,:) = all_trans_REM_mid_REM_end_SD_dreadd_cno{m}; data_REM_mid_REM_end_SD_dreadd_cno(isnan(data_REM_mid_REM_end_SD_dreadd_cno)==1)=0;
data_REM_long_REM_end_SD_dreadd_cno(m,:) = all_trans_REM_long_REM_end_SD_dreadd_cno{m}; data_REM_long_REM_end_SD_dreadd_cno(isnan(data_REM_long_REM_end_SD_dreadd_cno)==1)=0;


end

