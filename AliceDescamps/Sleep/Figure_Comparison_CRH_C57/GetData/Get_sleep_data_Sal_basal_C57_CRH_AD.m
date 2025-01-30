
%% input dir

%%1
Dir_sal_mCherry_C57 = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_sal_noDREADD_C57 = PathForExperiments_DREADD_MC('noDREADD_SalineInjection_10am');
Dir_sal_C57 = MergePathForExperiment(Dir_sal_mCherry_C57,Dir_sal_noDREADD_C57);

%%2
Dir_sal_mCherry_CRH = PathForExperiments_DREADD_AD('mCherry_CRH_VLPO_SalineInjection_10am');
Dir_sal_DREADDinhib_CRH = PathForExperiments_DREADD_AD('inhibDREADD_CRH_VLPO_SalineInjection_10am');
Dir_sal_CRH = MergePathForExperiment(Dir_sal_mCherry_CRH,Dir_sal_DREADDinhib_CRH);

%%Comparision between 9 and 10am when brought into the room
% Dir_sal_mCherry_CRH = PathForExperiments_DREADD_AD('mCherry_CRH_VLPO_SalineInjection_10am');
% Dir_sal_DREADDinhib_CRH = PathForExperiments_DREADD_AD('inhibDREADD_CRH_VLPO_SalineInjection_10am');
% Dir_sal_CRH_all = MergePathForExperiment(Dir_sal_mCherry_CRH,Dir_sal_DREADDinhib_CRH);
% 
% %%1
% Dir_sal_C57 = RestrictPathForExperiment(Dir_sal_CRH_all, 'nMice', [1566 1567 1568 1569 1578 1579 1580 1581 1488 1489 1510 1511 1512]);
% 
% %%2
% Dir_sal_CRH = RestrictPathForExperiment(Dir_sal_CRH_all, 'nMice', [1631 1634 1635 1636 1637 1638 1639]);


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

%% GET DATA - C57 saline

for i=1:length(Dir_sal_C57.path)
    cd(Dir_sal_C57.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_sal_C57{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_sal_C57{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%Define different periods of time for quantifications
    same_epoch_all_sess_sal_C57{i} = intervalSet(0,time_end); %all session
    same_epoch_begin_sal_C57{i} = intervalSet(time_st,time_mid_begin_snd_period); %beginning of the session (period of insomnia)
    same_epoch_end_sal_C57{i} = intervalSet(time_mid_begin_snd_period,time_end); %late phase of the session (rem frag)
    same_epoch_interPeriod_sal_C57{i} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period); %inter period
    
    %%Compute percentage, mean duration, number of bouts overtime (over all session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_sal_C57{i}.Wake,same_epoch_all_sess_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_all_sess_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_all_sess_sal_C57{i}),'wake',tempbin,time_st,time_end);
    dur_WAKE_sal_C57{i}=dur_moyenne_ep_WAKE;
    num_WAKE_sal_C57{i}=num_moyen_ep_WAKE;
    perc_WAKE_sal_C57{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_sal_C57{i}.Wake,same_epoch_all_sess_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_all_sess_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_all_sess_sal_C57{i}),'sws',tempbin,time_st,time_end);
    dur_SWS_sal_C57{i}=dur_moyenne_ep_SWS;
    num_SWS_sal_C57{i}=num_moyen_ep_SWS;
    perc_SWS_sal_C57{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_sal_C57{i}.Wake,same_epoch_all_sess_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_all_sess_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_all_sess_sal_C57{i}),'rem',tempbin,time_st,time_end);
    dur_REM_sal_C57{i}=dur_moyenne_ep_REM;
    num_REM_sal_C57{i}=num_moyen_ep_REM;
    perc_REM_sal_C57{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_sal_C57{i}.Wake,same_epoch_all_sess_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_all_sess_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_all_sess_sal_C57{i}),'sleep',tempbin,time_st,time_end);
    dur_totSleepsal_C57{i}=dur_moyenne_ep_totSleep;
    num_totSleepsal_C57{i}=num_moyen_ep_totSleep;
    perc_totSleepsal_C57{i}=perc_moyen_totSleep;
    

    %%First period (beginning)
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_begin_sal_C57{i}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_sal_C57{i}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_sal_C57{i}=num_moyen_ep_WAKE;
    perc_WAKE_begin_sal_C57{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_begin_sal_C57{i}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_sal_C57{i}=dur_moyenne_ep_SWS;
    num_SWS_begin_sal_C57{i}=num_moyen_ep_SWS;
    perc_SWS_begin_sal_C57{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_begin_sal_C57{i}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_sal_C57{i}=dur_moyenne_ep_REM;
    num_REM_begin_sal_C57{i}=num_moyen_ep_REM;
    perc_REM_begin_sal_C57{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_begin_sal_C57{i}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_sal_C57{i}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_sal_C57{i}=num_moyen_ep_totSleep;
    perc_totSleep_begin_sal_C57{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_C57{i}.Wake,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_begin_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_begin_sal_C57{i}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_sal_C57{i} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_sal_C57{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_sal_C57{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_sal_C57{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_sal_C57{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_sal_C57{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_sal_C57{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_sal_C57{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_sal_C57{i} = trans_WAKE_to_WAKE;
    
    
    
    %%Inter period (middle part of the session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_interPeriod_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_interPeriod_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_interPeriod_sal_C57{i}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_sal_C57{i}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_sal_C57{i}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_sal_C57{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_interPeriod_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_interPeriod_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_interPeriod_sal_C57{i}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_sal_C57{i}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_sal_C57{i}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_sal_C57{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_interPeriod_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_interPeriod_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_interPeriod_sal_C57{i}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_sal_C57{i}=dur_moyenne_ep_REM;
    num_REM_interPeriod_sal_C57{i}=num_moyen_ep_REM;
    perc_REM_interPeriod_sal_C57{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_interPeriod_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_interPeriod_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_interPeriod_sal_C57{i}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_sal_C57{i}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_sal_C57{i}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_sal_C57{i}=perc_moyen_totSleep;
    
    
    
    %%Late period of the session
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_sal_C57{i}=dur_moyenne_ep_WAKE;
    num_WAKE_end_sal_C57{i}=num_moyen_ep_WAKE;
    perc_WAKE_end_sal_C57{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_sal_C57{i}=dur_moyenne_ep_SWS;
    num_SWS_end_sal_C57{i}=num_moyen_ep_SWS;
    perc_SWS_end_sal_C57{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_sal_C57{i}=dur_moyenne_ep_REM;
    num_REM_end_sal_C57{i}=num_moyen_ep_REM;
    perc_REM_end_sal_C57{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_C57{i}.Wake,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_sal_C57{i}=dur_moyenne_ep_totSleep;
    num_totSleep_end_sal_C57{i}=num_moyen_ep_totSleep;
    perc_totSleep_end_sal_C57{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_C57{i}.Wake,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_sal_C57{i} = trans_REM_to_REM;
    all_trans_REM_SWS_end_sal_C57{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_sal_C57{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_sal_C57{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_sal_C57{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_sal_C57{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_sal_C57{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_sal_C57{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_sal_C57{i} = trans_WAKE_to_WAKE;
    
    
   
    %%Short versus long REM bouts during late period
    [dur_WAKE_sal_C57_bis{i}, durT_WAKE_sal_C57(i)]=DurationEpoch(and(stages_sal_C57{i}.Wake,same_epoch_end_sal_C57{i}),'s');
    [dur_SWS_sal_C57_bis{i}, durT_SWS_sal_C57(i)]=DurationEpoch(and(stages_sal_C57{i}.SWSEpoch,same_epoch_end_sal_C57{i}),'s');

    [dur_REM_sal_C57_bis{i}, durT_REM_sal_C57(i)]=DurationEpoch(and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}),'s');
    
    idx_short_rem_sal_C57_1{i} = find(dur_REM_sal_C57_bis{i}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_sal_C57_1{i} = subset(and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}), idx_short_rem_sal_C57_1{i});
    [dur_rem_short_sal_C57_1{i}, durT_rem_short_sal_C57(i)] = DurationEpoch(short_REMEpoch_sal_C57_1{i},'s');
    perc_rem_short_sal_C57_1(i) = durT_rem_short_sal_C57(i) / durT_REM_sal_C57(i) * 100;
    dur_moyenne_rem_short_sal_C57_1(i) = nanmean(dur_rem_short_sal_C57_1{i});
    num_moyen_rem_short_sal_C57_1(i) = length(dur_rem_short_sal_C57_1{i});
    
    idx_short_rem_sal_C57_2{i} = find(dur_REM_sal_C57_bis{i}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_sal_C57_2{i} = subset(and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}), idx_short_rem_sal_C57_2{i});
    [dur_rem_short_sal_C57_2{i}, durT_rem_short_sal_C57(i)] = DurationEpoch(short_REMEpoch_sal_C57_2{i},'s');
    perc_rem_short_sal_C57_2(i) = durT_rem_short_sal_C57(i) / durT_REM_sal_C57(i) * 100;
    dur_moyenne_rem_short_sal_C57_2(i) = nanmean(dur_rem_short_sal_C57_2{i});
    num_moyen_rem_short_sal_C57_2(i) = length(dur_rem_short_sal_C57_2{i});
    
    idx_short_rem_sal_C57_3{i} = find(dur_REM_sal_C57_bis{i}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_sal_C57_3{i} = subset(and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}), idx_short_rem_sal_C57_3{i});
    [dur_rem_short_sal_C57_3{i}, durT_rem_short_sal_C57(i)] = DurationEpoch(short_REMEpoch_sal_C57_3{i},'s');
    perc_rem_short_sal_C57_3(i) = durT_rem_short_sal_C57(i) / durT_REM_sal_C57(i) * 100;
    dur_moyenne_rem_short_sal_C57_3(i) = nanmean(dur_rem_short_sal_C57_3{i});
    num_moyen_rem_short_sal_C57_3(i) = length(dur_rem_short_sal_C57_3{i});
    
    idx_long_rem_sal_C57{i} = find(dur_REM_sal_C57_bis{i}>lim_long_rem); %long bout
    long_REMEpoch_sal_C57{i} = subset(and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}), idx_long_rem_sal_C57{i});
    [dur_rem_long_sal_C57{i}, durT_rem_long_sal_C57(i)] = DurationEpoch(long_REMEpoch_sal_C57{i},'s');
    perc_rem_long_sal_C57(i) = durT_rem_long_sal_C57(i) / durT_REM_sal_C57(i) * 100;
    dur_moyenne_rem_long_sal_C57(i) = nanmean(dur_rem_long_sal_C57{i});
    num_moyen_rem_long_sal_C57(i) = length(dur_rem_long_sal_C57{i});
    
    idx_mid_rem_sal_C57{i} = find(dur_REM_sal_C57_bis{i}>lim_short_rem_1 & dur_REM_sal_C57_bis{i}<lim_long_rem); % middle bouts
    mid_REMEpoch_sal_C57{i} = subset(and(stages_sal_C57{i}.REMEpoch,same_epoch_end_sal_C57{i}), idx_mid_rem_sal_C57{i});
    [dur_rem_mid_sal_C57{i}, durT_rem_mid_sal_C57(i)] = DurationEpoch(mid_REMEpoch_sal_C57{i},'s');
    perc_rem_mid_sal_C57(i) = durT_rem_mid_sal_C57(i) / durT_REM_sal_C57(i) * 100;
    dur_moyenne_rem_mid_sal_C57(i) = nanmean(dur_rem_mid_sal_C57{i});
    num_moyen_rem_mid_sal_C57(i) = length(dur_rem_mid_sal_C57{i});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_C57{i}.Wake,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_end_sal_C57{i}),and(short_REMEpoch_sal_C57_1{i},same_epoch_end_sal_C57{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_sal_C57{i} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_sal_C57{i} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_sal_C57{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_C57{i}.Wake,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_end_sal_C57{i}),and(mid_REMEpoch_sal_C57{i},same_epoch_end_sal_C57{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_sal_C57{i} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_sal_C57{i} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_sal_C57{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_C57{i}.Wake,same_epoch_end_sal_C57{i}),and(stages_sal_C57{i}.SWSEpoch,same_epoch_end_sal_C57{i}),and(long_REMEpoch_sal_C57{i},same_epoch_end_sal_C57{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_sal_C57{i} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_sal_C57{i} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_sal_C57{i} = trans_REM_to_REM;
    
    
    
    
    st_sws_sal_C57{i} = Start(stages_sal_C57{i}.SWSEpoch);
    idx_sws_sal_C57{i} = find(mindurSWS<dur_SWS_sal_C57_bis{i},1,'first');
    latency_sws_sal_C57(i) =  st_sws_sal_C57{i}(idx_sws_sal_C57{i});
    
    
    st_rem_sal_C57{i} = Start(stages_sal_C57{i}.REMEpoch);
    idx_rem_sal_C57{i} = find(mindurREM<dur_REM_sal_C57_bis{i},1,'first');
    latency_rem_sal_C57(i) =  st_rem_sal_C57{i}(idx_rem_sal_C57{i});
end

%% compute average - C57 saline
%%percentage/duration/number
for i=1:length(dur_REM_sal_C57)
    %%ALL SESSION
    data_dur_REM_sal_C57(i,:) = dur_REM_sal_C57{i}; data_dur_REM_sal_C57(isnan(data_dur_REM_sal_C57)==1)=0;
    data_dur_SWS_sal_C57(i,:) = dur_SWS_sal_C57{i}; data_dur_SWS_sal_C57(isnan(data_dur_SWS_sal_C57)==1)=0;
    data_dur_WAKE_sal_C57(i,:) = dur_WAKE_sal_C57{i}; data_dur_WAKE_sal_C57(isnan(data_dur_WAKE_sal_C57)==1)=0;
    data_dur_totSleep_sal_C57(i,:) = dur_totSleepsal_C57{i}; data_dur_totSleep_sal_C57(isnan(data_dur_totSleep_sal_C57)==1)=0;
    
    data_num_REM_sal_C57(i,:) = num_REM_sal_C57{i};data_num_REM_sal_C57(isnan(data_num_REM_sal_C57)==1)=0;
    data_num_SWS_sal_C57(i,:) = num_SWS_sal_C57{i}; data_num_SWS_sal_C57(isnan(data_num_SWS_sal_C57)==1)=0;
    data_num_WAKE_sal_C57(i,:) = num_WAKE_sal_C57{i}; data_num_WAKE_sal_C57(isnan(data_num_WAKE_sal_C57)==1)=0;
    data_num_totSleep_sal_C57(i,:) = num_totSleepsal_C57{i}; data_num_totSleep_sal_C57(isnan(data_num_totSleep_sal_C57)==1)=0;
    
    data_perc_REM_sal_C57(i,:) = perc_REM_sal_C57{i}; data_perc_REM_sal_C57(isnan(data_perc_REM_sal_C57)==1)=0;
    data_perc_SWS_sal_C57(i,:) = perc_SWS_sal_C57{i}; data_perc_SWS_sal_C57(isnan(data_perc_SWS_sal_C57)==1)=0;
    data_perc_WAKE_sal_C57(i,:) = perc_WAKE_sal_C57{i}; data_perc_WAKE_sal_C57(isnan(data_perc_WAKE_sal_C57)==1)=0;
    data_perc_totSleep_sal_C57(i,:) = perc_totSleepsal_C57{i}; data_perc_totSleep_sal_C57(isnan(data_perc_totSleep_sal_C57)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_sal_C57(i,:) = dur_REM_begin_sal_C57{i}; data_dur_REM_begin_sal_C57(isnan(data_dur_REM_begin_sal_C57)==1)=0;
    data_dur_SWS_begin_sal_C57(i,:) = dur_SWS_begin_sal_C57{i}; data_dur_SWS_begin_sal_C57(isnan(data_dur_SWS_begin_sal_C57)==1)=0;
    data_dur_WAKE_begin_sal_C57(i,:) = dur_WAKE_begin_sal_C57{i}; data_dur_WAKE_begin_sal_C57(isnan(data_dur_WAKE_begin_sal_C57)==1)=0;
    data_dur_totSleep_begin_sal_C57(i,:) = dur_totSleep_begin_sal_C57{i}; data_dur_totSleep_begin_sal_C57(isnan(data_dur_totSleep_begin_sal_C57)==1)=0;
    
    
    data_num_REM_begin_sal_C57(i,:) = num_REM_begin_sal_C57{i};data_num_REM_begin_sal_C57(isnan(data_num_REM_begin_sal_C57)==1)=0;
    data_num_SWS_begin_sal_C57(i,:) = num_SWS_begin_sal_C57{i}; data_num_SWS_begin_sal_C57(isnan(data_num_SWS_begin_sal_C57)==1)=0;
    data_num_WAKE_begin_sal_C57(i,:) = num_WAKE_begin_sal_C57{i}; data_num_WAKE_begin_sal_C57(isnan(data_num_WAKE_begin_sal_C57)==1)=0;
    data_num_totSleep_begin_sal_C57(i,:) = num_totSleep_begin_sal_C57{i}; data_num_totSleep_begin_sal_C57(isnan(data_num_totSleep_begin_sal_C57)==1)=0;
    
    data_perc_REM_begin_sal_C57(i,:) = perc_REM_begin_sal_C57{i}; data_perc_REM_begin_sal_C57(isnan(data_perc_REM_begin_sal_C57)==1)=0;
    data_perc_SWS_begin_sal_C57(i,:) = perc_SWS_begin_sal_C57{i}; data_perc_SWS_begin_sal_C57(isnan(data_perc_SWS_begin_sal_C57)==1)=0;
    data_perc_WAKE_begin_sal_C57(i,:) = perc_WAKE_begin_sal_C57{i}; data_perc_WAKE_begin_sal_C57(isnan(data_perc_WAKE_begin_sal_C57)==1)=0;
    data_perc_totSleep_begin_sal_C57(i,:) = perc_totSleep_begin_sal_C57{i}; data_perc_totSleep_begin_sal_C57(isnan(data_perc_totSleep_begin_sal_C57)==1)=0;
    
    data_dur_REM_interPeriod_sal_C57(i,:) = dur_REM_interPeriod_sal_C57{i}; data_dur_REM_interPeriod_sal_C57(isnan(data_dur_REM_interPeriod_sal_C57)==1)=0;
    data_dur_SWS_interPeriod_sal_C57(i,:) = dur_SWS_interPeriod_sal_C57{i}; data_dur_SWS_interPeriod_sal_C57(isnan(data_dur_SWS_interPeriod_sal_C57)==1)=0;
    data_dur_WAKE_interPeriod_sal_C57(i,:) = dur_WAKE_interPeriod_sal_C57{i}; data_dur_WAKE_interPeriod_sal_C57(isnan(data_dur_WAKE_interPeriod_sal_C57)==1)=0;
    data_dur_totSleep_interPeriod_sal_C57(i,:) = dur_totSleep_interPeriod_sal_C57{i}; data_dur_totSleep_interPeriod_sal_C57(isnan(data_dur_totSleep_interPeriod_sal_C57)==1)=0;
    
    
    data_num_REM_interPeriod_sal_C57(i,:) = num_REM_interPeriod_sal_C57{i};data_num_REM_interPeriod_sal_C57(isnan(data_num_REM_interPeriod_sal_C57)==1)=0;
    data_num_SWS_interPeriod_sal_C57(i,:) = num_SWS_interPeriod_sal_C57{i}; data_num_SWS_interPeriod_sal_C57(isnan(data_num_SWS_interPeriod_sal_C57)==1)=0;
    data_num_WAKE_interPeriod_sal_C57(i,:) = num_WAKE_interPeriod_sal_C57{i}; data_num_WAKE_interPeriod_sal_C57(isnan(data_num_WAKE_interPeriod_sal_C57)==1)=0;
    data_num_totSleep_interPeriod_sal_C57(i,:) = num_totSleep_interPeriod_sal_C57{i}; data_num_totSleep_interPeriod_sal_C57(isnan(data_num_totSleep_interPeriod_sal_C57)==1)=0;
    
    data_perc_REM_interPeriod_sal_C57(i,:) = perc_REM_interPeriod_sal_C57{i}; data_perc_REM_interPeriod_sal_C57(isnan(data_perc_REM_interPeriod_sal_C57)==1)=0;
    data_perc_SWS_interPeriod_sal_C57(i,:) = perc_SWS_interPeriod_sal_C57{i}; data_perc_SWS_interPeriod_sal_C57(isnan(data_perc_SWS_interPeriod_sal_C57)==1)=0;
    data_perc_WAKE_interPeriod_sal_C57(i,:) = perc_WAKE_interPeriod_sal_C57{i}; data_perc_WAKE_interPeriod_sal_C57(isnan(data_perc_WAKE_interPeriod_sal_C57)==1)=0;
    data_perc_totSleep_interPeriod_sal_C57(i,:) = perc_totSleep_interPeriod_sal_C57{i}; data_perc_totSleep_interPeriod_sal_C57(isnan(data_perc_totSleep_interPeriod_sal_C57)==1)=0;
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_sal_C57(i,:) = dur_REM_end_sal_C57{i}; data_dur_REM_end_sal_C57(isnan(data_dur_REM_end_sal_C57)==1)=0;
    data_dur_SWS_end_sal_C57(i,:) = dur_SWS_end_sal_C57{i}; data_dur_SWS_end_sal_C57(isnan(data_dur_SWS_end_sal_C57)==1)=0;
    data_dur_WAKE_end_sal_C57(i,:) = dur_WAKE_end_sal_C57{i}; data_dur_WAKE_end_sal_C57(isnan(data_dur_WAKE_end_sal_C57)==1)=0;
    data_dur_totSleep_end_sal_C57(i,:) = dur_totSleep_end_sal_C57{i}; data_dur_totSleep_end_sal_C57(isnan(data_dur_totSleep_end_sal_C57)==1)=0;
    
    
    data_num_REM_end_sal_C57(i,:) = num_REM_end_sal_C57{i};data_num_REM_end_sal_C57(isnan(data_num_REM_end_sal_C57)==1)=0;
    data_num_SWS_end_sal_C57(i,:) = num_SWS_end_sal_C57{i}; data_num_SWS_end_sal_C57(isnan(data_num_SWS_end_sal_C57)==1)=0;
    data_num_WAKE_end_sal_C57(i,:) = num_WAKE_end_sal_C57{i}; data_num_WAKE_end_sal_C57(isnan(data_num_WAKE_end_sal_C57)==1)=0;
    data_num_totSleep_end_sal_C57(i,:) = num_totSleep_end_sal_C57{i}; data_num_totSleep_end_sal_C57(isnan(data_num_totSleep_end_sal_C57)==1)=0;
    
    
    data_perc_REM_end_sal_C57(i,:) = perc_REM_end_sal_C57{i}; data_perc_REM_end_sal_C57(isnan(data_perc_REM_end_sal_C57)==1)=0;
    data_perc_SWS_end_sal_C57(i,:) = perc_SWS_end_sal_C57{i}; data_perc_SWS_end_sal_C57(isnan(data_perc_SWS_end_sal_C57)==1)=0;
    data_perc_WAKE_end_sal_C57(i,:) = perc_WAKE_end_sal_C57{i}; data_perc_WAKE_end_sal_C57(isnan(data_perc_WAKE_end_sal_C57)==1)=0;
    data_perc_totSleep_end_sal_C57(i,:) = perc_totSleep_end_sal_C57{i}; data_perc_totSleep_end_sal_C57(isnan(data_perc_totSleep_end_sal_C57)==1)=0;
    
end
%% probability
for i=1:length(all_trans_REM_short_WAKE_end_sal_C57)
%     %%ALL SESSION
%     data_REM_REM_sal_C57(i,:) = all_trans_REM_REM_sal_C57{i}; data_REM_REM_sal_C57(isnan(data_REM_REM_sal_C57)==1)=0;
%     data_REM_SWS_sal_C57(i,:) = all_trans_REM_SWS_sal_C57{i}; data_REM_SWS_sal_C57(isnan(data_REM_SWS_sal_C57)==1)=0;
%     data_REM_WAKE_sal_C57(i,:) = all_trans_REM_WAKE_sal_C57{i}; data_REM_WAKE_sal_C57(isnan(data_REM_WAKE_sal_C57)==1)=0;
%
%     data_SWS_SWS_sal_C57(i,:) = all_trans_SWS_SWS_sal_C57{i}; data_SWS_SWS_sal_C57(isnan(data_SWS_SWS_sal_C57)==1)=0;
%     data_SWS_REM_sal_C57(i,:) = all_trans_SWS_REM_sal_C57{i}; data_SWS_REM_sal_C57(isnan(data_SWS_REM_sal_C57)==1)=0;
%     data_SWS_WAKE_sal_C57(i,:) = all_trans_SWS_WAKE_sal_C57{i}; data_SWS_WAKE_sal_C57(isnan(data_SWS_WAKE_sal_C57)==1)=0;
%
%     data_WAKE_WAKE_sal_C57(i,:) = all_trans_WAKE_WAKE_sal_C57{i}; data_WAKE_WAKE_sal_C57(isnan(data_WAKE_WAKE_sal_C57)==1)=0;
%     data_WAKE_REM_sal_C57(i,:) = all_trans_WAKE_REM_sal_C57{i}; data_WAKE_REM_sal_C57(isnan(data_WAKE_REM_sal_C57)==1)=0;
%     data_WAKE_SWS_sal_C57(i,:) = all_trans_WAKE_SWS_sal_C57{i}; data_WAKE_SWS_sal_C57(isnan(data_WAKE_SWS_sal_C57)==1)=0;
%
%     %%3 PREMI7RES HEURES
%         data_REM_REM_begin_sal_C57(i,:) = all_trans_REM_REM_begin_sal_C57{i}; data_REM_REM_begin_sal_C57(isnan(data_REM_REM_begin_sal_C57)==1)=0;
%     data_REM_SWS_begin_sal_C57(i,:) = all_trans_REM_SWS_begin_sal_C57{i}; data_REM_SWS_begin_sal_C57(isnan(data_REM_SWS_begin_sal_C57)==1)=0;
%     data_REM_WAKE_begin_sal_C57(i,:) = all_trans_REM_WAKE_begin_sal_C57{i}; data_REM_WAKE_begin_sal_C57(isnan(data_REM_WAKE_begin_sal_C57)==1)=0;
%
%     data_SWS_SWS_begin_sal_C57(i,:) = all_trans_SWS_SWS_begin_sal_C57{i}; data_SWS_SWS_begin_sal_C57(isnan(data_SWS_SWS_begin_sal_C57)==1)=0;
%     data_SWS_REM_begin_sal_C57(i,:) = all_trans_SWS_REM_begin_sal_C57{i}; data_SWS_REM_begin_sal_C57(isnan(data_SWS_REM_begin_sal_C57)==1)=0;
%     data_SWS_WAKE_begin_sal_C57(i,:) = all_trans_SWS_WAKE_begin_sal_C57{i}; data_SWS_WAKE_begin_sal_C57(isnan(data_SWS_WAKE_begin_sal_C57)==1)=0;
%
%     data_WAKE_WAKE_begin_sal_C57(i,:) = all_trans_WAKE_WAKE_begin_sal_C57{i}; data_WAKE_WAKE_begin_sal_C57(isnan(data_WAKE_WAKE_begin_sal_C57)==1)=0;
%     data_WAKE_REM_begin_sal_C57(i,:) = all_trans_WAKE_REM_begin_sal_C57{i}; data_WAKE_REM_begin_sal_C57(isnan(data_WAKE_REM_begin_sal_C57)==1)=0;
%     data_WAKE_SWS_begin_sal_C57(i,:) = all_trans_WAKE_SWS_begin_sal_C57{i}; data_WAKE_SWS_begin_sal_C57(isnan(data_WAKE_SWS_begin_sal_C57)==1)=0;
%
%     %%FIN DE LA SESSION
%         data_REM_REM_end_sal_C57(i,:) = all_trans_REM_REM_end_sal_C57{i}; data_REM_REM_end_sal_C57(isnan(data_REM_REM_end_sal_C57)==1)=0;
%     data_REM_SWS_end_sal_C57(i,:) = all_trans_REM_SWS_end_sal_C57{i}; data_REM_SWS_end_sal_C57(isnan(data_REM_SWS_end_sal_C57)==1)=0;
%     data_REM_WAKE_end_sal_C57(i,:) = all_trans_REM_WAKE_end_sal_C57{i}; data_REM_WAKE_end_sal_C57(isnan(data_REM_WAKE_end_sal_C57)==1)=0;
%
%     data_SWS_SWS_end_sal_C57(i,:) = all_trans_SWS_SWS_end_sal_C57{i}; data_SWS_SWS_end_sal_C57(isnan(data_SWS_SWS_end_sal_C57)==1)=0;
%     data_SWS_REM_end_sal_C57(i,:) = all_trans_SWS_REM_end_sal_C57{i}; data_SWS_REM_end_sal_C57(isnan(data_SWS_REM_end_sal_C57)==1)=0;
%     data_SWS_WAKE_end_sal_C57(i,:) = all_trans_SWS_WAKE_end_sal_C57{i}; data_SWS_WAKE_end_sal_C57(isnan(data_SWS_WAKE_end_sal_C57)==1)=0;
%
%     data_WAKE_WAKE_end_sal_C57(i,:) = all_trans_WAKE_WAKE_end_sal_C57{i}; data_WAKE_WAKE_end_sal_C57(isnan(data_WAKE_WAKE_end_sal_C57)==1)=0;
%     data_WAKE_REM_end_sal_C57(i,:) = all_trans_WAKE_REM_end_sal_C57{i}; data_WAKE_REM_end_sal_C57(isnan(data_WAKE_REM_end_sal_C57)==1)=0;
%     data_WAKE_SWS_end_sal_C57(i,:) = all_trans_WAKE_SWS_end_sal_C57{i}; data_WAKE_SWS_end_sal_C57(isnan(data_WAKE_SWS_end_sal_C57)==1)=0;
%
%
%
    data_REM_short_WAKE_end_sal_C57(i,:) = all_trans_REM_short_WAKE_end_sal_C57{i}; %data_REM_short_WAKE_end_sal_C57(isnan(data_REM_short_WAKE_end_sal_C57)==1)=0;
    data_REM_short_SWS_end_sal_C57(i,:) = all_trans_REM_short_SWS_end_sal_C57{i};% data_REM_short_SWS_end_sal_C57(isnan(data_REM_short_SWS_end_sal_C57)==1)=0;
    data_REM_short_REM_end_sal_C57(i,:) = all_trans_REM_short_REM_end_sal_C57{i}; %data_REM_short_WAKE_end_sal_C57(isnan(data_REM_short_WAKE_end_sal_C57)==1)=0;

    data_REM_mid_WAKE_end_sal_C57(i,:) = all_trans_REM_mid_WAKE_end_sal_C57{i}; %data_REM_mid_WAKE_end_sal_C57(isnan(data_REM_mid_WAKE_end_sal_C57)==1)=0;
    data_REM_mid_SWS_end_sal_C57(i,:) = all_trans_REM_mid_SWS_end_sal_C57{i}; %data_REM_mid_SWS_end_sal_C57(isnan(data_REM_mid_SWS_end_sal_C57)==1)=0;
    data_REM_mid_REM_end_sal_C57(i,:) = all_trans_REM_mid_REM_end_sal_C57{i}; %data_REM_mid_WAKE_end_sal_C57(isnan(data_REM_short_WAKE_end_sal_C57)==1)=0;

    data_REM_long_WAKE_end_sal_C57(i,:) = all_trans_REM_long_WAKE_end_sal_C57{i}; %data_REM_long_WAKE_end_sal_C57(isnan(data_REM_long_WAKE_end_sal_C57)==1)=0;
    data_REM_long_SWS_end_sal_C57(i,:) = all_trans_REM_long_SWS_end_sal_C57{i}; %data_REM_long_SWS_end_sal_C57(isnan(data_REM_long_SWS_end_sal_C57)==1)=0;
    data_REM_long_REM_end_sal_C57(i,:) = all_trans_REM_long_REM_end_sal_C57{i}; %data_REM_long_WAKE_end_sal_C57(isnan(data_REM_short_WAKE_end_sal_C57)==1)=0;

end



%% GET DATA - CRH saline
for k=1:length(Dir_sal_CRH.path)
    cd(Dir_sal_CRH.path{k}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_sal_CRH{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_sal_CRH{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    same_epoch_sal_CRH{k} = intervalSet(0,time_end);
    same_epoch_begin_sal_CRH{k} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_sal_CRH{k} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_sal_CRH{k} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_sal_CRH{k}.Wake,same_epoch_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_sal_CRH{k}),'wake',tempbin,time_st,time_end);
    dur_WAKE_sal_CRH{k}=dur_moyenne_ep_WAKE;
    num_WAKE_sal_CRH{k}=num_moyen_ep_WAKE;
    perc_WAKE_sal_CRH{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_sal_CRH{k}.Wake,same_epoch_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_sal_CRH{k}),'sws',tempbin,time_st,time_end);
    dur_SWS_sal_CRH{k}=dur_moyenne_ep_SWS;
    num_SWS_sal_CRH{k}=num_moyen_ep_SWS;
    perc_SWS_sal_CRH{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_sal_CRH{k}.Wake,same_epoch_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_sal_CRH{k}),'rem',tempbin,time_st,time_end);
    dur_REM_sal_CRH{k}=dur_moyenne_ep_REM;
    num_REM_sal_CRH{k}=num_moyen_ep_REM;
    perc_REM_sal_CRH{k}=perc_moyen_REM;
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_sal_CRH{k}.Wake,same_epoch_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_sal_CRH{k}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_sal_CRH{k}=dur_moyenne_ep_totSleep;
    num_totSleep_sal_CRH{k}=num_moyen_ep_totSleep;
    perc_totSleep_sal_CRH{k}=perc_moyen_totSleep;
    
    
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_begin_sal_CRH{k}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_sal_CRH{k}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_sal_CRH{k}=num_moyen_ep_WAKE;
    perc_WAKE_begin_sal_CRH{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_begin_sal_CRH{k}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_sal_CRH{k}=dur_moyenne_ep_SWS;
    num_SWS_begin_sal_CRH{k}=num_moyen_ep_SWS;
    perc_SWS_begin_sal_CRH{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_begin_sal_CRH{k}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_sal_CRH{k}=dur_moyenne_ep_REM;
    num_REM_begin_sal_CRH{k}=num_moyen_ep_REM;
    perc_REM_begin_sal_CRH{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_begin_sal_CRH{k}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_sal_CRH{k}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_sal_CRH{k}=num_moyen_ep_totSleep;
    perc_totSleep_begin_sal_CRH{k}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_CRH{k}.Wake,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_begin_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_begin_sal_CRH{k}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_sal_CRH{k} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_sal_CRH{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_sal_CRH{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_sal_CRH{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_sal_CRH{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_sal_CRH{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_sal_CRH{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_sal_CRH{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_sal_CRH{k} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_interPeriod_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_interPeriod_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_interPeriod_sal_CRH{k}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_sal_CRH{k}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_sal_CRH{k}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_sal_CRH{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_interPeriod_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_interPeriod_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_interPeriod_sal_CRH{k}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_sal_CRH{k}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_sal_CRH{k}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_sal_CRH{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_interPeriod_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_interPeriod_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_interPeriod_sal_CRH{k}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_sal_CRH{k}=dur_moyenne_ep_REM;
    num_REM_interPeriod_sal_CRH{k}=num_moyen_ep_REM;
    perc_REM_interPeriod_sal_CRH{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_interPeriod_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_interPeriod_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_interPeriod_sal_CRH{k}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_sal_CRH{k}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_sal_CRH{k}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_sal_CRH{k}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_sal_CRH{k}=dur_moyenne_ep_WAKE;
    num_WAKE_end_sal_CRH{k}=num_moyen_ep_WAKE;
    perc_WAKE_end_sal_CRH{k}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_sal_CRH{k}=dur_moyenne_ep_SWS;
    num_SWS_end_sal_CRH{k}=num_moyen_ep_SWS;
    perc_SWS_end_sal_CRH{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_sal_CRH{k}=dur_moyenne_ep_REM;
    num_REM_end_sal_CRH{k}=num_moyen_ep_REM;
    perc_REM_end_sal_CRH{k}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_sal_CRH{k}.Wake,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_sal_CRH{k}=dur_moyenne_ep_totSleep;
    num_totSleep_end_sal_CRH{k}=num_moyen_ep_totSleep;
    perc_totSleep_end_sal_CRH{k}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_CRH{k}.Wake,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_sal_CRH{k} = trans_REM_to_REM;
    all_trans_REM_SWS_end_sal_CRH{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_sal_CRH{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_sal_CRH{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_sal_CRH{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_sal_CRH{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_sal_CRH{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_sal_CRH{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_sal_CRH{k} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
        [dur_WAKE_sal_CRH_bis{k}, durT_WAKE_sal_CRH(k)]=DurationEpoch(and(stages_sal_CRH{k}.Wake,same_epoch_end_sal_CRH{k}),'s');
    [dur_SWS_sal_CRH_bis{k}, durT_SWS_sal_CRH(k)]=DurationEpoch(and(stages_sal_CRH{k}.SWSEpoch,same_epoch_end_sal_CRH{k}),'s');
    
    [dur_REM_sal_CRH_bis{k}, durT_REM_sal_CRH(k)]=DurationEpoch(and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}),'s');
    
    idx_short_rem_sal_CRH_1{k} = find(dur_REM_sal_CRH_bis{k}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_sal_CRH_1{k} = subset(and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}), idx_short_rem_sal_CRH_1{k});
    [dur_rem_short_sal_CRH_1{k}, durT_rem_short_sal_CRH(k)] = DurationEpoch(short_REMEpoch_sal_CRH_1{k},'s');
    perc_rem_short_sal_CRH_1(k) = durT_rem_short_sal_CRH(k) / durT_REM_sal_CRH(k) * 100;
    dur_moyenne_rem_short_sal_CRH_1(k) = nanmean(dur_rem_short_sal_CRH_1{k});
    num_moyen_rem_short_sal_CRH_1(k) = length(dur_rem_short_sal_CRH_1{k});
    
    idx_short_rem_sal_CRH_2{k} = find(dur_REM_sal_CRH_bis{k}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_sal_CRH_2{k} = subset(and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}), idx_short_rem_sal_CRH_2{k});
    [dur_rem_short_sal_CRH_2{k}, durT_rem_short_sal_CRH(k)] = DurationEpoch(short_REMEpoch_sal_CRH_2{k},'s');
    perc_rem_short_sal_CRH_2(k) = durT_rem_short_sal_CRH(k) / durT_REM_sal_CRH(k) * 100;
    dur_moyenne_rem_short_sal_CRH_2(k) = nanmean(dur_rem_short_sal_CRH_2{k});
    num_moyen_rem_short_sal_CRH_2(k) = length(dur_rem_short_sal_CRH_2{k});
    
    idx_short_rem_sal_CRH_3{k} = find(dur_REM_sal_CRH_bis{k}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_sal_CRH_3{k} = subset(and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}), idx_short_rem_sal_CRH_3{k});
    [dur_rem_short_sal_CRH_3{k}, durT_rem_short_sal_CRH(k)] = DurationEpoch(short_REMEpoch_sal_CRH_3{k},'s');
    perc_rem_short_sal_CRH_3(k) = durT_rem_short_sal_CRH(k) / durT_REM_sal_CRH(k) * 100;
    dur_moyenne_rem_short_sal_CRH_3(k) = nanmean(dur_rem_short_sal_CRH_3{k});
    num_moyen_rem_short_sal_CRH_3(k) = length(dur_rem_short_sal_CRH_3{k});
    
    idx_long_rem_sal_CRH{k} = find(dur_REM_sal_CRH_bis{k}>lim_long_rem); %long bout
    long_REMEpoch_sal_CRH{k} = subset(and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}), idx_long_rem_sal_CRH{k});
    [dur_rem_long_sal_CRH{k}, durT_rem_long_sal_CRH(k)] = DurationEpoch(long_REMEpoch_sal_CRH{k},'s');
    perc_rem_long_sal_CRH(k) = durT_rem_long_sal_CRH(k) / durT_REM_sal_CRH(k) * 100;
    dur_moyenne_rem_long_sal_CRH(k) = nanmean(dur_rem_long_sal_CRH{k});
    num_moyen_rem_long_sal_CRH(k) = length(dur_rem_long_sal_CRH{k});
    
    idx_mid_rem_sal_CRH{k} = find(dur_REM_sal_CRH_bis{k}>lim_short_rem_1 & dur_REM_sal_CRH_bis{k}<lim_long_rem); % middle bouts
    mid_REMEpoch_sal_CRH{k} = subset(and(stages_sal_CRH{k}.REMEpoch,same_epoch_end_sal_CRH{k}), idx_mid_rem_sal_CRH{k});
    [dur_rem_mid_sal_CRH{k}, durT_rem_mid_sal_CRH(k)] = DurationEpoch(mid_REMEpoch_sal_CRH{k},'s');
    perc_rem_mid_sal_CRH(k) = durT_rem_mid_sal_CRH(k) / durT_REM_sal_CRH(k) * 100;
    dur_moyenne_rem_mid_sal_CRH(k) = nanmean(dur_rem_mid_sal_CRH{k});
    num_moyen_rem_mid_sal_CRH(k) = length(dur_rem_mid_sal_CRH{k});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_CRH{k}.Wake,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_end_sal_CRH{k}),and(short_REMEpoch_sal_CRH_1{k},same_epoch_end_sal_CRH{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_sal_CRH{k} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_sal_CRH{k} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_sal_CRH{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_CRH{k}.Wake,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_end_sal_CRH{k}),and(mid_REMEpoch_sal_CRH{k},same_epoch_end_sal_CRH{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_sal_CRH{k} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_sal_CRH{k} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_sal_CRH{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_sal_CRH{k}.Wake,same_epoch_end_sal_CRH{k}),and(stages_sal_CRH{k}.SWSEpoch,same_epoch_end_sal_CRH{k}),and(long_REMEpoch_sal_CRH{k},same_epoch_end_sal_CRH{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_sal_CRH{k} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_sal_CRH{k} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_sal_CRH{k} = trans_REM_to_REM;
    
        st_sws_sal_CRH{k} = Start(stages_sal_CRH{k}.SWSEpoch);
    idx_sws_sal_CRH{k} = find(mindurSWS<dur_SWS_sal_CRH_bis{k},1,'first');
    latency_sws_sal_CRH(k) =  st_sws_sal_CRH{k}(idx_sws_sal_CRH{k});
    
    
    st_rem_sal_CRH{k} = Start(stages_sal_CRH{k}.REMEpoch);
    idx_rem_sal_CRH{k} = find(mindurREM<dur_REM_sal_CRH_bis{k},1,'first');
    latency_rem_sal_CRH(k) =  st_rem_sal_CRH{k}(idx_rem_sal_CRH{k});
    
end

%% compute average - CRH saline
%%percentage/duration/number
for k=1:length(dur_REM_sal_CRH)
    %%ALL SESSION
    data_dur_REM_sal_CRH(k,:) = dur_REM_sal_CRH{k}; data_dur_REM_sal_CRH(isnan(data_dur_REM_sal_CRH)==1)=0;
    data_dur_SWS_sal_CRH(k,:) = dur_SWS_sal_CRH{k}; data_dur_SWS_sal_CRH(isnan(data_dur_SWS_sal_CRH)==1)=0;
    data_dur_WAKE_sal_CRH(k,:) = dur_WAKE_sal_CRH{k}; data_dur_WAKE_sal_CRH(isnan(data_dur_WAKE_sal_CRH)==1)=0;
    data_dur_totSleep_sal_CRH(k,:) = dur_totSleep_sal_CRH{k}; data_dur_totSleep_sal_CRH(isnan(data_dur_totSleep_sal_CRH)==1)=0;
    
    data_num_REM_sal_CRH(k,:) = num_REM_sal_CRH{k};data_num_REM_sal_CRH(isnan(data_num_REM_sal_CRH)==1)=0;
    data_num_SWS_sal_CRH(k,:) = num_SWS_sal_CRH{k}; data_num_SWS_sal_CRH(isnan(data_num_SWS_sal_CRH)==1)=0;
    data_num_WAKE_sal_CRH(k,:) = num_WAKE_sal_CRH{k}; data_num_WAKE_sal_CRH(isnan(data_num_WAKE_sal_CRH)==1)=0;
    data_num_totSleep_sal_CRH(k,:) = num_totSleep_sal_CRH{k}; data_num_totSleep_sal_CRH(isnan(data_num_totSleep_sal_CRH)==1)=0;
    
    data_perc_REM_sal_CRH(k,:) = perc_REM_sal_CRH{k}; data_perc_REM_sal_CRH(isnan(data_perc_REM_sal_CRH)==1)=0;
    data_perc_SWS_sal_CRH(k,:) = perc_SWS_sal_CRH{k}; data_perc_SWS_sal_CRH(isnan(data_perc_SWS_sal_CRH)==1)=0;
    data_perc_WAKE_sal_CRH(k,:) = perc_WAKE_sal_CRH{k}; data_perc_WAKE_sal_CRH(isnan(data_perc_WAKE_sal_CRH)==1)=0;
    data_perc_totSleep_sal_CRH(k,:) = perc_totSleep_sal_CRH{k}; data_perc_totSleep_sal_CRH(isnan(data_perc_totSleep_sal_CRH)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_sal_CRH(k,:) = dur_REM_begin_sal_CRH{k}; data_dur_REM_begin_sal_CRH(isnan(data_dur_REM_begin_sal_CRH)==1)=0;
    data_dur_SWS_begin_sal_CRH(k,:) = dur_SWS_begin_sal_CRH{k}; data_dur_SWS_begin_sal_CRH(isnan(data_dur_SWS_begin_sal_CRH)==1)=0;
    data_dur_WAKE_begin_sal_CRH(k,:) = dur_WAKE_begin_sal_CRH{k}; data_dur_WAKE_begin_sal_CRH(isnan(data_dur_WAKE_begin_sal_CRH)==1)=0;
    data_dur_totSleep_begin_sal_CRH(k,:) = dur_totSleep_begin_sal_CRH{k}; data_dur_totSleep_begin_sal_CRH(isnan(data_dur_totSleep_begin_sal_CRH)==1)=0;
    
    
    data_num_REM_begin_sal_CRH(k,:) = num_REM_begin_sal_CRH{k};data_num_REM_begin_sal_CRH(isnan(data_num_REM_begin_sal_CRH)==1)=0;
    data_num_SWS_begin_sal_CRH(k,:) = num_SWS_begin_sal_CRH{k}; data_num_SWS_begin_sal_CRH(isnan(data_num_SWS_begin_sal_CRH)==1)=0;
    data_num_WAKE_begin_sal_CRH(k,:) = num_WAKE_begin_sal_CRH{k}; data_num_WAKE_begin_sal_CRH(isnan(data_num_WAKE_begin_sal_CRH)==1)=0;
    data_num_totSleep_begin_sal_CRH(k,:) = num_totSleep_begin_sal_CRH{k}; data_num_totSleep_begin_sal_CRH(isnan(data_num_totSleep_begin_sal_CRH)==1)=0;
    
    data_perc_REM_begin_sal_CRH(k,:) = perc_REM_begin_sal_CRH{k}; data_perc_REM_begin_sal_CRH(isnan(data_perc_REM_begin_sal_CRH)==1)=0;
    data_perc_SWS_begin_sal_CRH(k,:) = perc_SWS_begin_sal_CRH{k}; data_perc_SWS_begin_sal_CRH(isnan(data_perc_SWS_begin_sal_CRH)==1)=0;
    data_perc_WAKE_begin_sal_CRH(k,:) = perc_WAKE_begin_sal_CRH{k}; data_perc_WAKE_begin_sal_CRH(isnan(data_perc_WAKE_begin_sal_CRH)==1)=0;
    data_perc_totSleep_begin_sal_CRH(k,:) = perc_totSleep_begin_sal_CRH{k}; data_perc_totSleep_begin_sal_CRH(isnan(data_perc_totSleep_begin_sal_CRH)==1)=0;
    
    data_dur_REM_interPeriod_sal_CRH(k,:) = dur_REM_interPeriod_sal_CRH{k}; data_dur_REM_interPeriod_sal_CRH(isnan(data_dur_REM_interPeriod_sal_CRH)==1)=0;
    data_dur_SWS_interPeriod_sal_CRH(k,:) = dur_SWS_interPeriod_sal_CRH{k}; data_dur_SWS_interPeriod_sal_CRH(isnan(data_dur_SWS_interPeriod_sal_CRH)==1)=0;
    data_dur_WAKE_interPeriod_sal_CRH(k,:) = dur_WAKE_interPeriod_sal_CRH{k}; data_dur_WAKE_interPeriod_sal_CRH(isnan(data_dur_WAKE_interPeriod_sal_CRH)==1)=0;
    data_dur_totSleep_interPeriod_sal_CRH(k,:) = dur_totSleep_interPeriod_sal_CRH{k}; data_dur_totSleep_interPeriod_sal_CRH(isnan(data_dur_totSleep_interPeriod_sal_CRH)==1)=0;
    
    
    data_num_REM_interPeriod_sal_CRH(k,:) = num_REM_interPeriod_sal_CRH{k};data_num_REM_interPeriod_sal_CRH(isnan(data_num_REM_interPeriod_sal_CRH)==1)=0;
    data_num_SWS_interPeriod_sal_CRH(k,:) = num_SWS_interPeriod_sal_CRH{k}; data_num_SWS_interPeriod_sal_CRH(isnan(data_num_SWS_interPeriod_sal_CRH)==1)=0;
    data_num_WAKE_interPeriod_sal_CRH(k,:) = num_WAKE_interPeriod_sal_CRH{k}; data_num_WAKE_interPeriod_sal_CRH(isnan(data_num_WAKE_interPeriod_sal_CRH)==1)=0;
    data_num_totSleep_interPeriod_sal_CRH(k,:) = num_totSleep_interPeriod_sal_CRH{k}; data_num_totSleep_interPeriod_sal_CRH(isnan(data_num_totSleep_interPeriod_sal_CRH)==1)=0;
    
    data_perc_REM_interPeriod_sal_CRH(k,:) = perc_REM_interPeriod_sal_CRH{k}; data_perc_REM_interPeriod_sal_CRH(isnan(data_perc_REM_interPeriod_sal_CRH)==1)=0;
    data_perc_SWS_interPeriod_sal_CRH(k,:) = perc_SWS_interPeriod_sal_CRH{k}; data_perc_SWS_interPeriod_sal_CRH(isnan(data_perc_SWS_interPeriod_sal_CRH)==1)=0;
    data_perc_WAKE_interPeriod_sal_CRH(k,:) = perc_WAKE_interPeriod_sal_CRH{k}; data_perc_WAKE_interPeriod_sal_CRH(isnan(data_perc_WAKE_interPeriod_sal_CRH)==1)=0;
    data_perc_totSleep_interPeriod_sal_CRH(k,:) = perc_totSleep_interPeriod_sal_CRH{k}; data_perc_totSleep_interPeriod_sal_CRH(isnan(data_perc_totSleep_interPeriod_sal_CRH)==1)=0;
    
    %%FIN DE LA SESSION
    data_dur_REM_end_sal_CRH(k,:) = dur_REM_end_sal_CRH{k}; data_dur_REM_end_sal_CRH(isnan(data_dur_REM_end_sal_CRH)==1)=0;
    data_dur_SWS_end_sal_CRH(k,:) = dur_SWS_end_sal_CRH{k}; data_dur_SWS_end_sal_CRH(isnan(data_dur_SWS_end_sal_CRH)==1)=0;
    data_dur_WAKE_end_sal_CRH(k,:) = dur_WAKE_end_sal_CRH{k}; data_dur_WAKE_end_sal_CRH(isnan(data_dur_WAKE_end_sal_CRH)==1)=0;
    data_dur_totSleep_end_sal_CRH(k,:) = dur_totSleep_end_sal_CRH{k}; data_dur_totSleep_end_sal_CRH(isnan(data_dur_totSleep_end_sal_CRH)==1)=0;
    
    
    data_num_REM_end_sal_CRH(k,:) = num_REM_end_sal_CRH{k};data_num_REM_end_sal_CRH(isnan(data_num_REM_end_sal_CRH)==1)=0;
    data_num_SWS_end_sal_CRH(k,:) = num_SWS_end_sal_CRH{k}; data_num_SWS_end_sal_CRH(isnan(data_num_SWS_end_sal_CRH)==1)=0;
    data_num_WAKE_end_sal_CRH(k,:) = num_WAKE_end_sal_CRH{k}; data_num_WAKE_end_sal_CRH(isnan(data_num_WAKE_end_sal_CRH)==1)=0;
    data_num_totSleep_end_sal_CRH(k,:) = num_totSleep_end_sal_CRH{k}; data_num_totSleep_end_sal_CRH(isnan(data_num_totSleep_end_sal_CRH)==1)=0;
    
    
    data_perc_REM_end_sal_CRH(k,:) = perc_REM_end_sal_CRH{k}; data_perc_REM_end_sal_CRH(isnan(data_perc_REM_end_sal_CRH)==1)=0;
    data_perc_SWS_end_sal_CRH(k,:) = perc_SWS_end_sal_CRH{k}; data_perc_SWS_end_sal_CRH(isnan(data_perc_SWS_end_sal_CRH)==1)=0;
    data_perc_WAKE_end_sal_CRH(k,:) = perc_WAKE_end_sal_CRH{k}; data_perc_WAKE_end_sal_CRH(isnan(data_perc_WAKE_end_sal_CRH)==1)=0;
    data_perc_totSleep_end_sal_CRH(k,:) = perc_totSleep_end_sal_CRH{k}; data_perc_totSleep_end_sal_CRH(isnan(data_perc_totSleep_end_sal_CRH)==1)=0;
    
end
%% probability
for k=1:length(all_trans_REM_short_WAKE_end_sal_CRH)
    %     %%ALL SESSION
    %     data_REM_REM_sal_CRH(k,:) = all_trans_REM_REM_sal_CRH{k}; data_REM_REM_sal_CRH(isnan(data_REM_REM_sal_CRH)==1)=0;
    %     data_REM_SWS_sal_CRH(k,:) = all_trans_REM_SWS_sal_CRH{k}; data_REM_SWS_sal_CRH(isnan(data_REM_SWS_sal_CRH)==1)=0;
    %     data_REM_WAKE_sal_CRH(k,:) = all_trans_REM_WAKE_sal_CRH{k}; data_REM_WAKE_sal_CRH(isnan(data_REM_WAKE_sal_CRH)==1)=0;
    %
    %     data_SWS_SWS_sal_CRH(k,:) = all_trans_SWS_SWS_sal_CRH{k}; data_SWS_SWS_sal_CRH(isnan(data_SWS_SWS_sal_CRH)==1)=0;
    %     data_SWS_REM_sal_CRH(k,:) = all_trans_SWS_REM_sal_CRH{k}; data_SWS_REM_sal_CRH(isnan(data_SWS_REM_sal_CRH)==1)=0;
    %     data_SWS_WAKE_sal_CRH(k,:) = all_trans_SWS_WAKE_sal_CRH{k}; data_SWS_WAKE_sal_CRH(isnan(data_SWS_WAKE_sal_CRH)==1)=0;
    %
    %     data_WAKE_WAKE_sal_CRH(k,:) = all_trans_WAKE_WAKE_sal_CRH{k}; data_WAKE_WAKE_sal_CRH(isnan(data_WAKE_WAKE_sal_CRH)==1)=0;
    %     data_WAKE_REM_sal_CRH(k,:) = all_trans_WAKE_REM_sal_CRH{k}; data_WAKE_REM_sal_CRH(isnan(data_WAKE_REM_sal_CRH)==1)=0;
    %     data_WAKE_SWS_sal_CRH(k,:) = all_trans_WAKE_SWS_sal_CRH{k}; data_WAKE_SWS_sal_CRH(isnan(data_WAKE_SWS_sal_CRH)==1)=0;
    %
    %     %%3 PREMI7RES HEURES
    %         data_REM_REM_begin_sal_CRH(k,:) = all_trans_REM_REM_begin_sal_CRH{k}; data_REM_REM_begin_sal_CRH(isnan(data_REM_REM_begin_sal_CRH)==1)=0;
    %     data_REM_SWS_begin_sal_CRH(k,:) = all_trans_REM_SWS_begin_sal_CRH{k}; data_REM_SWS_begin_sal_CRH(isnan(data_REM_SWS_begin_sal_CRH)==1)=0;
    %     data_REM_WAKE_begin_sal_CRH(k,:) = all_trans_REM_WAKE_begin_sal_CRH{k}; data_REM_WAKE_begin_sal_CRH(isnan(data_REM_WAKE_begin_sal_CRH)==1)=0;
    %
    %     data_SWS_SWS_begin_sal_CRH(k,:) = all_trans_SWS_SWS_begin_sal_CRH{k}; data_SWS_SWS_begin_sal_CRH(isnan(data_SWS_SWS_begin_sal_CRH)==1)=0;
    %     data_SWS_REM_begin_sal_CRH(k,:) = all_trans_SWS_REM_begin_sal_CRH{k}; data_SWS_REM_begin_sal_CRH(isnan(data_SWS_REM_begin_sal_CRH)==1)=0;
    %     data_SWS_WAKE_begin_sal_CRH(k,:) = all_trans_SWS_WAKE_begin_sal_CRH{k}; data_SWS_WAKE_begin_sal_CRH(isnan(data_SWS_WAKE_begin_sal_CRH)==1)=0;
    %
    %     data_WAKE_WAKE_begin_sal_CRH(k,:) = all_trans_WAKE_WAKE_begin_sal_CRH{k}; data_WAKE_WAKE_begin_sal_CRH(isnan(data_WAKE_WAKE_begin_sal_CRH)==1)=0;
    %     data_WAKE_REM_begin_sal_CRH(k,:) = all_trans_WAKE_REM_begin_sal_CRH{k}; data_WAKE_REM_begin_sal_CRH(isnan(data_WAKE_REM_begin_sal_CRH)==1)=0;
    %     data_WAKE_SWS_begin_sal_CRH(k,:) = all_trans_WAKE_SWS_begin_sal_CRH{k}; data_WAKE_SWS_begin_sal_CRH(isnan(data_WAKE_SWS_begin_sal_CRH)==1)=0;
    %
    %     %%FIN DE LA SESSION
    %         data_REM_REM_end_sal_CRH(k,:) = all_trans_REM_REM_end_sal_CRH{k}; data_REM_REM_end_sal_CRH(isnan(data_REM_REM_end_sal_CRH)==1)=0;
    %     data_REM_SWS_end_sal_CRH(k,:) = all_trans_REM_SWS_end_sal_CRH{k}; data_REM_SWS_end_sal_CRH(isnan(data_REM_SWS_end_sal_CRH)==1)=0;
    %     data_REM_WAKE_end_sal_CRH(k,:) = all_trans_REM_WAKE_end_sal_CRH{k}; data_REM_WAKE_end_sal_CRH(isnan(data_REM_WAKE_end_sal_CRH)==1)=0;
    %
    %     data_SWS_SWS_end_sal_CRH(k,:) = all_trans_SWS_SWS_end_sal_CRH{k}; data_SWS_SWS_end_sal_CRH(isnan(data_SWS_SWS_end_sal_CRH)==1)=0;
    %     data_SWS_REM_end_sal_CRH(k,:) = all_trans_SWS_REM_end_sal_CRH{k}; data_SWS_REM_end_sal_CRH(isnan(data_SWS_REM_end_sal_CRH)==1)=0;
    %     data_SWS_WAKE_end_sal_CRH(k,:) = all_trans_SWS_WAKE_end_sal_CRH{k}; data_SWS_WAKE_end_sal_CRH(isnan(data_SWS_WAKE_end_sal_CRH)==1)=0;
    %
    %     data_WAKE_WAKE_end_sal_CRH(k,:) = all_trans_WAKE_WAKE_end_sal_CRH{k}; data_WAKE_WAKE_end_sal_CRH(isnan(data_WAKE_WAKE_end_sal_CRH)==1)=0;
    %     data_WAKE_REM_end_sal_CRH(k,:) = all_trans_WAKE_REM_end_sal_CRH{k}; data_WAKE_REM_end_sal_CRH(isnan(data_WAKE_REM_end_sal_CRH)==1)=0;
    %     data_WAKE_SWS_end_sal_CRH(k,:) = all_trans_WAKE_SWS_end_sal_CRH{k}; data_WAKE_SWS_end_sal_CRH(isnan(data_WAKE_SWS_end_sal_CRH)==1)=0;
    %
    data_REM_short_WAKE_end_sal_CRH(k,:) = all_trans_REM_short_WAKE_end_sal_CRH{k}; data_REM_short_WAKE_end_sal_CRH(isnan(data_REM_short_WAKE_end_sal_CRH)==1)=0;
    data_REM_short_SWS_end_sal_CRH(k,:) = all_trans_REM_short_SWS_end_sal_CRH{k}; data_REM_short_SWS_end_sal_CRH(isnan(data_REM_short_SWS_end_sal_CRH)==1)=0;
    
    data_REM_mid_WAKE_end_sal_CRH(k,:) = all_trans_REM_mid_WAKE_end_sal_CRH{k}; data_REM_mid_WAKE_end_sal_CRH(isnan(data_REM_mid_WAKE_end_sal_CRH)==1)=0;
    data_REM_mid_SWS_end_sal_CRH(k,:) = all_trans_REM_mid_SWS_end_sal_CRH{k}; data_REM_mid_SWS_end_sal_CRH(isnan(data_REM_mid_SWS_end_sal_CRH)==1)=0;
    
    data_REM_long_WAKE_end_sal_CRH(k,:) = all_trans_REM_long_WAKE_end_sal_CRH{k}; data_REM_long_WAKE_end_sal_CRH(isnan(data_REM_long_WAKE_end_sal_CRH)==1)=0;
    data_REM_long_SWS_end_sal_CRH(k,:) = all_trans_REM_long_SWS_end_sal_CRH{k}; data_REM_long_SWS_end_sal_CRH(isnan(data_REM_long_SWS_end_sal_CRH)==1)=0;
    
    data_REM_short_REM_end_sal_CRH(k,:) = all_trans_REM_short_REM_end_sal_CRH{k}; %data_REM_short_REM_end_sal_CRH(isnan(data_REM_short_REM_end_sal_CRH)==1)=0;
    data_REM_mid_REM_end_sal_CRH(k,:) = all_trans_REM_mid_REM_end_sal_CRH{k}; %data_REM_mid_REM_end_sal_CRH(isnan(data_REM_mid_REM_end_sal_CRH)==1)=0;
    data_REM_long_REM_end_sal_CRH(k,:) = all_trans_REM_long_REM_end_sal_CRH{k}; %data_REM_long_REM_end_sal_CRH(isnan(data_REM_long_REM_end_sal_CRH)==1)=0;
    
end

