
%DIR INHI DREADDS PFC-VLPO SAL/CNO (basal sleep)
Dir_saline=PathForExperiments_DREADD_MC('inhibDREADD_retroCre_PFC_VLPO_SalineInjection_1pm');
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_retroCre_PFC_VLPO_CNOInjection_1pm');

Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_PFC_CNOInjection_1pm');


%%
% Dir_saline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% Dir_cno = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');


%% parameters

tempbin = 3600; %bin size to plot variables overtime

time_st = 0*3600*1e4; %begining of the sleep session
time_end=3*1e8;  %end of the sleep session
% time_end=3*1e8;  %end of the sleep session

% time_mid_end_first_period = 1.5*3600*1e4; %2 first hours (insomnia)
% time_mid_begin_snd_period = 3.3*3600*1e4;% 4 last hours(late pahse of the night)

time_mid_end_first_period = 1.4*1e8; %2 first hours (insomnia)
time_mid_begin_snd_period = 1.5*1e8;% 4 last hours(late pahse of the night)

t_inj = 13;
t_start = 8;
t_end = 18;

lim_short_rem_1 = 10; %take all rem bouts shorter than limit
lim_short_rem_2 = 15;
lim_short_rem_3 = 20;
lim_long_rem = 40; %take all rem bouts longer than limit



%% GET DATA - saline

for i=1:length(Dir_saline.path)
    cd(Dir_saline.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_saline{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_saline{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    vec_tps_recording_saline{i} = Range(stages_saline{i}.tsdMovement); %get vector to keep track of the reocrding time
    VecTimeDay_saline{i}  = GetTimeOfTheDay_MC(vec_tps_recording_saline{i} );

    idx_injection_time_saline{i} = find(ceil(VecTimeDay_saline{i})==t_inj,1,'last'); %last %get index for the injection time
    idx_same_st_saline{i} = find(ceil(VecTimeDay_saline{i})>=t_start,1,'first'); % get index to get same beg and end of the time period to analyze
    idx_same_en_saline{i}= find(ceil(VecTimeDay_saline{i})>=t_end,1,'last');%== last
    
    injection_time_saline{i} = vec_tps_recording_saline{i}(idx_injection_time_saline{i}); %get the corresponding values
    same_st_saline{i} = vec_tps_recording_saline{i}(idx_same_st_saline{i});
    same_en_saline{i} = vec_tps_recording_saline{i}(idx_same_en_saline{i});
    
    %%Define different periods of time for quantifications
    same_epoch_all_sess_saline{i} = intervalSet(0,same_en_saline{i}); %all session
    same_epoch_begin_saline{i} = intervalSet(same_st_saline{i},injection_time_saline{i}); %beginning of the session (period of insomnia)
    same_epoch_end_saline{i} = intervalSet(injection_time_saline{i},same_en_saline{i}); %late phase of the session (rem frag)
    same_epoch_interPeriod_saline{i} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period); %inter period
    
        
%     %%Define different periods of time for quantifications
%     same_epoch_all_sess_saline{i} = intervalSet(0,time_end); %all session
%     same_epoch_begin_saline{i} = intervalSet(time_st,time_mid_begin_snd_period); %beginning of the session (period of insomnia)
%     same_epoch_end_saline{i} = intervalSet(time_mid_begin_snd_period,time_end); %late phase of the session (rem frag)
%     same_epoch_interPeriod_saline{i} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period); %inter period
    
    
    
    %%Compute percentage, mean duration, number of bouts overtime (over all session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_saline{i}.Wake,same_epoch_all_sess_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_all_sess_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_all_sess_saline{i}),'wake',tempbin,time_st,time_end);
    dur_WAKE_saline{i}=dur_moyenne_ep_WAKE;
    num_WAKE_saline{i}=num_moyen_ep_WAKE;
    perc_WAKE_saline{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_saline{i}.Wake,same_epoch_all_sess_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_all_sess_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_all_sess_saline{i}),'sws',tempbin,time_st,time_end);
    dur_SWS_saline{i}=dur_moyenne_ep_SWS;
    num_SWS_saline{i}=num_moyen_ep_SWS;
    perc_SWS_saline{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_saline{i}.Wake,same_epoch_all_sess_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_all_sess_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_all_sess_saline{i}),'rem',tempbin,time_st,time_end);
    dur_REM_saline{i}=dur_moyenne_ep_REM;
    num_REM_saline{i}=num_moyen_ep_REM;
    perc_REM_saline{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_saline{i}.Wake,same_epoch_all_sess_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_all_sess_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_all_sess_saline{i}),'sleep',tempbin,time_st,time_end);
    dur_totSleepctrl{i}=dur_moyenne_ep_totSleep;
    num_totSleepctrl{i}=num_moyen_ep_totSleep;
    perc_totSleepctrl{i}=perc_moyen_totSleep;
    

    %%First period (beginning)
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_begin_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_begin_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_begin_saline{i}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_saline{i}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_saline{i}=num_moyen_ep_WAKE;
    perc_WAKE_begin_saline{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_begin_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_begin_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_begin_saline{i}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_saline{i}=dur_moyenne_ep_SWS;
    num_SWS_begin_saline{i}=num_moyen_ep_SWS;
    perc_SWS_begin_saline{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_begin_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_begin_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_begin_saline{i}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_saline{i}=dur_moyenne_ep_REM;
    num_REM_begin_saline{i}=num_moyen_ep_REM;
    perc_REM_begin_saline{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_begin_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_begin_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_begin_saline{i}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_saline{i}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_saline{i}=num_moyen_ep_totSleep;
    perc_totSleep_begin_saline{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_saline{i}.Wake,same_epoch_begin_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_begin_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_begin_saline{i}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_saline{i} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_saline{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_saline{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_saline{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_saline{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_saline{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_saline{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_saline{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_saline{i} = trans_WAKE_to_WAKE;
    
    
    
    %%Inter period (middle part of the session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_interPeriod_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_interPeriod_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_interPeriod_saline{i}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_saline{i}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_saline{i}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_saline{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_interPeriod_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_interPeriod_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_interPeriod_saline{i}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_saline{i}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_saline{i}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_saline{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_interPeriod_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_interPeriod_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_interPeriod_saline{i}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_saline{i}=dur_moyenne_ep_REM;
    num_REM_interPeriod_saline{i}=num_moyen_ep_REM;
    perc_REM_interPeriod_saline{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_interPeriod_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_interPeriod_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_interPeriod_saline{i}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_saline{i}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_saline{i}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_saline{i}=perc_moyen_totSleep;
    
    
    
    %%Late period of the session
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_end_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_end_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_saline{i}=dur_moyenne_ep_WAKE;
    num_WAKE_end_saline{i}=num_moyen_ep_WAKE;
    perc_WAKE_end_saline{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_end_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_end_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_saline{i}=dur_moyenne_ep_SWS;
    num_SWS_end_saline{i}=num_moyen_ep_SWS;
    perc_SWS_end_saline{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_end_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_end_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_saline{i}=dur_moyenne_ep_REM;
    num_REM_end_saline{i}=num_moyen_ep_REM;
    perc_REM_end_saline{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_saline{i}.Wake,same_epoch_end_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_end_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_saline{i}=dur_moyenne_ep_totSleep;
    num_totSleep_end_saline{i}=num_moyen_ep_totSleep;
    perc_totSleep_end_saline{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_saline{i}.Wake,same_epoch_end_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_end_saline{i}),and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_saline{i} = trans_REM_to_REM;
    all_trans_REM_SWS_end_saline{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_saline{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_saline{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_saline{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_saline{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_saline{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_saline{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_saline{i} = trans_WAKE_to_WAKE;
    
    
   
    %%Short versus long REM bouts during late period
    [dur_REM_saline_bis{i}, durT_REM_saline(i)]=DurationEpoch(and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}),'s');
    
    idx_short_rem_saline_1{i} = find(dur_REM_saline_bis{i}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_saline_1{i} = subset(and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}), idx_short_rem_saline_1{i});
    [dur_rem_short_saline_1{i}, durT_rem_short_saline(i)] = DurationEpoch(short_REMEpoch_saline_1{i},'s');
    perc_rem_short_saline_1(i) = durT_rem_short_saline(i) / durT_REM_saline(i) * 100;
    dur_moyenne_rem_short_saline_1(i) = nanmean(dur_rem_short_saline_1{i});
    num_moyen_rem_short_saline_1(i) = length(dur_rem_short_saline_1{i});
    
    idx_short_rem_saline_2{i} = find(dur_REM_saline_bis{i}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_saline_2{i} = subset(and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}), idx_short_rem_saline_2{i});
    [dur_rem_short_saline_2{i}, durT_rem_short_saline(i)] = DurationEpoch(short_REMEpoch_saline_2{i},'s');
    perc_rem_short_saline_2(i) = durT_rem_short_saline(i) / durT_REM_saline(i) * 100;
    dur_moyenne_rem_short_saline_2(i) = nanmean(dur_rem_short_saline_2{i});
    num_moyen_rem_short_saline_2(i) = length(dur_rem_short_saline_2{i});
    
    idx_short_rem_saline_3{i} = find(dur_REM_saline_bis{i}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_saline_3{i} = subset(and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}), idx_short_rem_saline_3{i});
    [dur_rem_short_saline_3{i}, durT_rem_short_saline(i)] = DurationEpoch(short_REMEpoch_saline_3{i},'s');
    perc_rem_short_saline_3(i) = durT_rem_short_saline(i) / durT_REM_saline(i) * 100;
    dur_moyenne_rem_short_saline_3(i) = nanmean(dur_rem_short_saline_3{i});
    num_moyen_rem_short_saline_3(i) = length(dur_rem_short_saline_3{i});
    
    idx_long_rem_saline{i} = find(dur_REM_saline_bis{i}>lim_long_rem); %long bout
    long_REMEpoch_saline{i} = subset(and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}), idx_long_rem_saline{i});
    [dur_rem_long_saline{i}, durT_rem_long_saline(i)] = DurationEpoch(long_REMEpoch_saline{i},'s');
    perc_rem_long_saline(i) = durT_rem_long_saline(i) / durT_REM_saline(i) * 100;
    dur_moyenne_rem_long_saline(i) = nanmean(dur_rem_long_saline{i});
    num_moyen_rem_long_saline(i) = length(dur_rem_long_saline{i});
    
    idx_mid_rem_saline{i} = find(dur_REM_saline_bis{i}>lim_short_rem_1 & dur_REM_saline_bis{i}<lim_long_rem); % middle bouts
    mid_REMEpoch_saline{i} = subset(and(stages_saline{i}.REMEpoch,same_epoch_end_saline{i}), idx_mid_rem_saline{i});
    [dur_rem_mid_saline{i}, durT_rem_mid_saline(i)] = DurationEpoch(mid_REMEpoch_saline{i},'s');
    perc_rem_mid_saline(i) = durT_rem_mid_saline(i) / durT_REM_saline(i) * 100;
    dur_moyenne_rem_mid_saline(i) = nanmean(dur_rem_mid_saline{i});
    num_moyen_rem_mid_saline(i) = length(dur_rem_mid_saline{i});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_saline{i}.Wake,same_epoch_end_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_end_saline{i}),and(short_REMEpoch_saline_1{i},same_epoch_end_saline{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_saline{i} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_saline{i} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_saline{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_saline{i}.Wake,same_epoch_end_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_end_saline{i}),and(mid_REMEpoch_saline{i},same_epoch_end_saline{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_saline{i} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_saline{i} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_saline{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_saline{i}.Wake,same_epoch_end_saline{i}),and(stages_saline{i}.SWSEpoch,same_epoch_end_saline{i}),and(long_REMEpoch_saline{i},same_epoch_end_saline{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_saline{i} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_saline{i} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_saline{i} = trans_REM_to_REM;
    
end

%% compute average - saline
%%percentage/duration/number
for i=1:length(dur_REM_saline)
    %%ALL SESSION
    data_dur_REM_saline(i,:) = dur_REM_saline{i}; data_dur_REM_saline(isnan(data_dur_REM_saline)==1)=0;
    data_dur_SWS_saline(i,:) = dur_SWS_saline{i}; data_dur_SWS_saline(isnan(data_dur_SWS_saline)==1)=0;
    data_dur_WAKE_saline(i,:) = dur_WAKE_saline{i}; data_dur_WAKE_saline(isnan(data_dur_WAKE_saline)==1)=0;
    data_dur_totSleep_saline(i,:) = dur_totSleepctrl{i}; data_dur_totSleep_saline(isnan(data_dur_totSleep_saline)==1)=0;
    
    data_num_REM_saline(i,:) = num_REM_saline{i};data_num_REM_saline(isnan(data_num_REM_saline)==1)=0;
    data_num_SWS_saline(i,:) = num_SWS_saline{i}; data_num_SWS_saline(isnan(data_num_SWS_saline)==1)=0;
    data_num_WAKE_saline(i,:) = num_WAKE_saline{i}; data_num_WAKE_saline(isnan(data_num_WAKE_saline)==1)=0;
    data_num_totSleep_saline(i,:) = num_totSleepctrl{i}; data_num_totSleep_saline(isnan(data_num_totSleep_saline)==1)=0;
    
    data_perc_REM_saline(i,:) = perc_REM_saline{i}; data_perc_REM_saline(isnan(data_perc_REM_saline)==1)=0;
    data_perc_SWS_saline(i,:) = perc_SWS_saline{i}; data_perc_SWS_saline(isnan(data_perc_SWS_saline)==1)=0;
    data_perc_WAKE_saline(i,:) = perc_WAKE_saline{i}; data_perc_WAKE_saline(isnan(data_perc_WAKE_saline)==1)=0;
    data_perc_totSleep_saline(i,:) = perc_totSleepctrl{i}; data_perc_totSleep_saline(isnan(data_perc_totSleep_saline)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_saline(i,:) = dur_REM_begin_saline{i}; data_dur_REM_begin_saline(isnan(data_dur_REM_begin_saline)==1)=0;
    data_dur_SWS_begin_saline(i,:) = dur_SWS_begin_saline{i}; data_dur_SWS_begin_saline(isnan(data_dur_SWS_begin_saline)==1)=0;
    data_dur_WAKE_begin_saline(i,:) = dur_WAKE_begin_saline{i}; data_dur_WAKE_begin_saline(isnan(data_dur_WAKE_begin_saline)==1)=0;
    data_dur_totSleep_begin_saline(i,:) = dur_totSleep_begin_saline{i}; data_dur_totSleep_begin_saline(isnan(data_dur_totSleep_begin_saline)==1)=0;
    
    
    data_num_REM_begin_saline(i,:) = num_REM_begin_saline{i};data_num_REM_begin_saline(isnan(data_num_REM_begin_saline)==1)=0;
    data_num_SWS_begin_saline(i,:) = num_SWS_begin_saline{i}; data_num_SWS_begin_saline(isnan(data_num_SWS_begin_saline)==1)=0;
    data_num_WAKE_begin_saline(i,:) = num_WAKE_begin_saline{i}; data_num_WAKE_begin_saline(isnan(data_num_WAKE_begin_saline)==1)=0;
    data_num_totSleep_begin_saline(i,:) = num_totSleep_begin_saline{i}; data_num_totSleep_begin_saline(isnan(data_num_totSleep_begin_saline)==1)=0;
    
    data_perc_REM_begin_saline(i,:) = perc_REM_begin_saline{i}; data_perc_REM_begin_saline(isnan(data_perc_REM_begin_saline)==1)=0;
    data_perc_SWS_begin_saline(i,:) = perc_SWS_begin_saline{i}; data_perc_SWS_begin_saline(isnan(data_perc_SWS_begin_saline)==1)=0;
    data_perc_WAKE_begin_saline(i,:) = perc_WAKE_begin_saline{i}; data_perc_WAKE_begin_saline(isnan(data_perc_WAKE_begin_saline)==1)=0;
    data_perc_totSleep_begin_saline(i,:) = perc_totSleep_begin_saline{i}; data_perc_totSleep_begin_saline(isnan(data_perc_totSleep_begin_saline)==1)=0;
    
    data_dur_REM_interPeriod_saline(i,:) = dur_REM_interPeriod_saline{i}; data_dur_REM_interPeriod_saline(isnan(data_dur_REM_interPeriod_saline)==1)=0;
    data_dur_SWS_interPeriod_saline(i,:) = dur_SWS_interPeriod_saline{i}; data_dur_SWS_interPeriod_saline(isnan(data_dur_SWS_interPeriod_saline)==1)=0;
    data_dur_WAKE_interPeriod_saline(i,:) = dur_WAKE_interPeriod_saline{i}; data_dur_WAKE_interPeriod_saline(isnan(data_dur_WAKE_interPeriod_saline)==1)=0;
    data_dur_totSleep_interPeriod_saline(i,:) = dur_totSleep_interPeriod_saline{i}; data_dur_totSleep_interPeriod_saline(isnan(data_dur_totSleep_interPeriod_saline)==1)=0;
    
    
    data_num_REM_interPeriod_saline(i,:) = num_REM_interPeriod_saline{i};data_num_REM_interPeriod_saline(isnan(data_num_REM_interPeriod_saline)==1)=0;
    data_num_SWS_interPeriod_saline(i,:) = num_SWS_interPeriod_saline{i}; data_num_SWS_interPeriod_saline(isnan(data_num_SWS_interPeriod_saline)==1)=0;
    data_num_WAKE_interPeriod_saline(i,:) = num_WAKE_interPeriod_saline{i}; data_num_WAKE_interPeriod_saline(isnan(data_num_WAKE_interPeriod_saline)==1)=0;
    data_num_totSleep_interPeriod_saline(i,:) = num_totSleep_interPeriod_saline{i}; data_num_totSleep_interPeriod_saline(isnan(data_num_totSleep_interPeriod_saline)==1)=0;
    
    data_perc_REM_interPeriod_saline(i,:) = perc_REM_interPeriod_saline{i}; data_perc_REM_interPeriod_saline(isnan(data_perc_REM_interPeriod_saline)==1)=0;
    data_perc_SWS_interPeriod_saline(i,:) = perc_SWS_interPeriod_saline{i}; data_perc_SWS_interPeriod_saline(isnan(data_perc_SWS_interPeriod_saline)==1)=0;
    data_perc_WAKE_interPeriod_saline(i,:) = perc_WAKE_interPeriod_saline{i}; data_perc_WAKE_interPeriod_saline(isnan(data_perc_WAKE_interPeriod_saline)==1)=0;
    data_perc_totSleep_interPeriod_saline(i,:) = perc_totSleep_interPeriod_saline{i}; data_perc_totSleep_interPeriod_saline(isnan(data_perc_totSleep_interPeriod_saline)==1)=0;
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_saline(i,:) = dur_REM_end_saline{i}; data_dur_REM_end_saline(isnan(data_dur_REM_end_saline)==1)=0;
    data_dur_SWS_end_saline(i,:) = dur_SWS_end_saline{i}; data_dur_SWS_end_saline(isnan(data_dur_SWS_end_saline)==1)=0;
    data_dur_WAKE_end_saline(i,:) = dur_WAKE_end_saline{i}; data_dur_WAKE_end_saline(isnan(data_dur_WAKE_end_saline)==1)=0;
    data_dur_totSleep_end_saline(i,:) = dur_totSleep_end_saline{i}; data_dur_totSleep_end_saline(isnan(data_dur_totSleep_end_saline)==1)=0;
    
    
    data_num_REM_end_saline(i,:) = num_REM_end_saline{i};data_num_REM_end_saline(isnan(data_num_REM_end_saline)==1)=0;
    data_num_SWS_end_saline(i,:) = num_SWS_end_saline{i}; data_num_SWS_end_saline(isnan(data_num_SWS_end_saline)==1)=0;
    data_num_WAKE_end_saline(i,:) = num_WAKE_end_saline{i}; data_num_WAKE_end_saline(isnan(data_num_WAKE_end_saline)==1)=0;
    data_num_totSleep_end_saline(i,:) = num_totSleep_end_saline{i}; data_num_totSleep_end_saline(isnan(data_num_totSleep_end_saline)==1)=0;
    
    
    data_perc_REM_end_saline(i,:) = perc_REM_end_saline{i}; data_perc_REM_end_saline(isnan(data_perc_REM_end_saline)==1)=0;
    data_perc_SWS_end_saline(i,:) = perc_SWS_end_saline{i}; data_perc_SWS_end_saline(isnan(data_perc_SWS_end_saline)==1)=0;
    data_perc_WAKE_end_saline(i,:) = perc_WAKE_end_saline{i}; data_perc_WAKE_end_saline(isnan(data_perc_WAKE_end_saline)==1)=0;
    data_perc_totSleep_end_saline(i,:) = perc_totSleep_end_saline{i}; data_perc_totSleep_end_saline(isnan(data_perc_totSleep_end_saline)==1)=0;
    
end
%% probability
for i=1:length(all_trans_REM_short_WAKE_end_saline)
%     %%ALL SESSION
%     data_REM_REM_saline(i,:) = all_trans_REM_REM_saline{i}; data_REM_REM_saline(isnan(data_REM_REM_saline)==1)=0;
%     data_REM_SWS_saline(i,:) = all_trans_REM_SWS_saline{i}; data_REM_SWS_saline(isnan(data_REM_SWS_saline)==1)=0;
%     data_REM_WAKE_saline(i,:) = all_trans_REM_WAKE_saline{i}; data_REM_WAKE_saline(isnan(data_REM_WAKE_saline)==1)=0;
%
%     data_SWS_SWS_saline(i,:) = all_trans_SWS_SWS_saline{i}; data_SWS_SWS_saline(isnan(data_SWS_SWS_saline)==1)=0;
%     data_SWS_REM_saline(i,:) = all_trans_SWS_REM_saline{i}; data_SWS_REM_saline(isnan(data_SWS_REM_saline)==1)=0;
%     data_SWS_WAKE_saline(i,:) = all_trans_SWS_WAKE_saline{i}; data_SWS_WAKE_saline(isnan(data_SWS_WAKE_saline)==1)=0;
%
%     data_WAKE_WAKE_saline(i,:) = all_trans_WAKE_WAKE_saline{i}; data_WAKE_WAKE_saline(isnan(data_WAKE_WAKE_saline)==1)=0;
%     data_WAKE_REM_saline(i,:) = all_trans_WAKE_REM_saline{i}; data_WAKE_REM_saline(isnan(data_WAKE_REM_saline)==1)=0;
%     data_WAKE_SWS_saline(i,:) = all_trans_WAKE_SWS_saline{i}; data_WAKE_SWS_saline(isnan(data_WAKE_SWS_saline)==1)=0;
%
%     %%3 PREMI7RES HEURES
%         data_REM_REM_begin_saline(i,:) = all_trans_REM_REM_begin_saline{i}; data_REM_REM_begin_saline(isnan(data_REM_REM_begin_saline)==1)=0;
%     data_REM_SWS_begin_saline(i,:) = all_trans_REM_SWS_begin_saline{i}; data_REM_SWS_begin_saline(isnan(data_REM_SWS_begin_saline)==1)=0;
%     data_REM_WAKE_begin_saline(i,:) = all_trans_REM_WAKE_begin_saline{i}; data_REM_WAKE_begin_saline(isnan(data_REM_WAKE_begin_saline)==1)=0;
%
%     data_SWS_SWS_begin_saline(i,:) = all_trans_SWS_SWS_begin_saline{i}; data_SWS_SWS_begin_saline(isnan(data_SWS_SWS_begin_saline)==1)=0;
%     data_SWS_REM_begin_saline(i,:) = all_trans_SWS_REM_begin_saline{i}; data_SWS_REM_begin_saline(isnan(data_SWS_REM_begin_saline)==1)=0;
%     data_SWS_WAKE_begin_saline(i,:) = all_trans_SWS_WAKE_begin_saline{i}; data_SWS_WAKE_begin_saline(isnan(data_SWS_WAKE_begin_saline)==1)=0;
%
%     data_WAKE_WAKE_begin_saline(i,:) = all_trans_WAKE_WAKE_begin_saline{i}; data_WAKE_WAKE_begin_saline(isnan(data_WAKE_WAKE_begin_saline)==1)=0;
%     data_WAKE_REM_begin_saline(i,:) = all_trans_WAKE_REM_begin_saline{i}; data_WAKE_REM_begin_saline(isnan(data_WAKE_REM_begin_saline)==1)=0;
%     data_WAKE_SWS_begin_saline(i,:) = all_trans_WAKE_SWS_begin_saline{i}; data_WAKE_SWS_begin_saline(isnan(data_WAKE_SWS_begin_saline)==1)=0;
%
%     %%FIN DE LA SESSION
%         data_REM_REM_end_saline(i,:) = all_trans_REM_REM_end_saline{i}; data_REM_REM_end_saline(isnan(data_REM_REM_end_saline)==1)=0;
%     data_REM_SWS_end_saline(i,:) = all_trans_REM_SWS_end_saline{i}; data_REM_SWS_end_saline(isnan(data_REM_SWS_end_saline)==1)=0;
%     data_REM_WAKE_end_saline(i,:) = all_trans_REM_WAKE_end_saline{i}; data_REM_WAKE_end_saline(isnan(data_REM_WAKE_end_saline)==1)=0;
%
%     data_SWS_SWS_end_saline(i,:) = all_trans_SWS_SWS_end_saline{i}; data_SWS_SWS_end_saline(isnan(data_SWS_SWS_end_saline)==1)=0;
%     data_SWS_REM_end_saline(i,:) = all_trans_SWS_REM_end_saline{i}; data_SWS_REM_end_saline(isnan(data_SWS_REM_end_saline)==1)=0;
%     data_SWS_WAKE_end_saline(i,:) = all_trans_SWS_WAKE_end_saline{i}; data_SWS_WAKE_end_saline(isnan(data_SWS_WAKE_end_saline)==1)=0;
%
%     data_WAKE_WAKE_end_saline(i,:) = all_trans_WAKE_WAKE_end_saline{i}; data_WAKE_WAKE_end_saline(isnan(data_WAKE_WAKE_end_saline)==1)=0;
%     data_WAKE_REM_end_saline(i,:) = all_trans_WAKE_REM_end_saline{i}; data_WAKE_REM_end_saline(isnan(data_WAKE_REM_end_saline)==1)=0;
%     data_WAKE_SWS_end_saline(i,:) = all_trans_WAKE_SWS_end_saline{i}; data_WAKE_SWS_end_saline(isnan(data_WAKE_SWS_end_saline)==1)=0;
%
%
%
    data_REM_short_WAKE_end_saline(i,:) = all_trans_REM_short_WAKE_end_saline{i}; %data_REM_short_WAKE_end_saline(isnan(data_REM_short_WAKE_end_saline)==1)=0;
    data_REM_short_SWS_end_saline(i,:) = all_trans_REM_short_SWS_end_saline{i};% data_REM_short_SWS_end_saline(isnan(data_REM_short_SWS_end_saline)==1)=0;
    data_REM_short_REM_end_saline(i,:) = all_trans_REM_short_REM_end_saline{i}; %data_REM_short_WAKE_end_saline(isnan(data_REM_short_WAKE_end_saline)==1)=0;

    data_REM_mid_WAKE_end_saline(i,:) = all_trans_REM_mid_WAKE_end_saline{i}; %data_REM_mid_WAKE_end_saline(isnan(data_REM_mid_WAKE_end_saline)==1)=0;
    data_REM_mid_SWS_end_saline(i,:) = all_trans_REM_mid_SWS_end_saline{i}; %data_REM_mid_SWS_end_saline(isnan(data_REM_mid_SWS_end_saline)==1)=0;
    data_REM_mid_REM_end_saline(i,:) = all_trans_REM_mid_REM_end_saline{i}; %data_REM_mid_WAKE_end_saline(isnan(data_REM_short_WAKE_end_saline)==1)=0;

    data_REM_long_WAKE_end_saline(i,:) = all_trans_REM_long_WAKE_end_saline{i}; %data_REM_long_WAKE_end_saline(isnan(data_REM_long_WAKE_end_saline)==1)=0;
    data_REM_long_SWS_end_saline(i,:) = all_trans_REM_long_SWS_end_saline{i}; %data_REM_long_SWS_end_saline(isnan(data_REM_long_SWS_end_saline)==1)=0;
    data_REM_long_REM_end_saline(i,:) = all_trans_REM_long_REM_end_saline{i}; %data_REM_long_WAKE_end_saline(isnan(data_REM_short_WAKE_end_saline)==1)=0;

end




%% GET DATA - CNO
for k=1:length(Dir_cno.path)
    cd(Dir_cno.path{k}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_cno{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_cno{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    vec_tps_recording_cno{k} = Range(stages_cno{k}.tsdMovement); %get vector to keep track of the reocrding time
    VecTimeDay_cno{k}  = GetTimeOfTheDay_MC(vec_tps_recording_cno{k} );

    idx_injection_time_cno{k} = find(ceil(VecTimeDay_cno{k})==t_inj,1,'last'); %last %get index for the injection time
    idx_same_st_cno{k} = find(ceil(VecTimeDay_cno{k})>=t_start,1,'first'); % get index to get same beg and end of the time period to analyze
    idx_same_en_cno{k}= find(ceil(VecTimeDay_cno{k})>=t_end,1,'last');%== last
    
    injection_time_cno{k} = vec_tps_recording_cno{k}(idx_injection_time_cno{k}); %get the corresponding values
    same_st_cno{k} = vec_tps_recording_cno{k}(idx_same_st_cno{k});
    same_en_cno{k} = vec_tps_recording_cno{k}(idx_same_en_cno{k});
    
    %%Define different periods of time for quantifications
    same_epoch_all_sess_cno{k} = intervalSet(0,same_en_cno{k}); %all session
    same_epoch_begin_cno{k} = intervalSet(same_st_cno{k},injection_time_cno{k}); %beginning of the session (period of insomnia)
    same_epoch_end_cno{k} = intervalSet(injection_time_cno{k},same_en_cno{k}); %late phase of the session (rem frag)
    same_epoch_interPeriod_cno{k} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period); %inter period
    
        
%     %%Define different periods of time for quantifications
%     same_epoch_all_sess_cno{i} = intervalSet(0,time_end); %all session
%     same_epoch_begin_cno{i} = intervalSet(time_st,time_mid_begin_snd_period); %beginning of the session (period of insomnia)
%     same_epoch_end_cno{i} = intervalSet(time_mid_begin_snd_period,time_end); %late phase of the session (rem frag)
%     same_epoch_interPeriod_cno{i} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period); %inter period
    
    
    
    %%Compute percentage, mean duration, number of bouts overtime (over all session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_cno{k}.Wake,same_epoch_all_sess_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_all_sess_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_all_sess_cno{k}),'wake',tempbin,time_st,time_end);
    dur_WAKE_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_cno{k}.Wake,same_epoch_all_sess_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_all_sess_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_all_sess_cno{k}),'sws',tempbin,time_st,time_end);
    dur_SWS_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_cno{k}=num_moyen_ep_SWS;
    perc_SWS_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_cno{k}.Wake,same_epoch_all_sess_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_all_sess_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_all_sess_cno{k}),'rem',tempbin,time_st,time_end);
    dur_REM_cno{k}=dur_moyenne_ep_REM;
    num_REM_cno{k}=num_moyen_ep_REM;
    perc_REM_cno{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_cno{k}.Wake,same_epoch_all_sess_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_all_sess_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_all_sess_cno{k}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_cno{k}=perc_moyen_totSleep;
    

    %%First period (beginning)
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_begin_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_begin_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_begin_cno{k}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_begin_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_begin_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_begin_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_begin_cno{k}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_begin_cno{k}=num_moyen_ep_SWS;
    perc_SWS_begin_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_begin_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_begin_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_begin_cno{k}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_cno{k}=dur_moyenne_ep_REM;
    num_REM_begin_cno{k}=num_moyen_ep_REM;
    perc_REM_begin_cno{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_begin_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_begin_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_begin_cno{k}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_begin_cno{k}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_cno{k}.Wake,same_epoch_begin_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_begin_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_begin_cno{k}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_cno{k} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_cno{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_cno{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_cno{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_cno{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_cno{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_cno{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_cno{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_cno{k} = trans_WAKE_to_WAKE;
    
    
    
    %%Inter period (middle part of the session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_interPeriod_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_interPeriod_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_interPeriod_cno{k}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_interPeriod_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_interPeriod_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_interPeriod_cno{k}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_cno{k}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_interPeriod_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_interPeriod_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_interPeriod_cno{k}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_cno{k}=dur_moyenne_ep_REM;
    num_REM_interPeriod_cno{k}=num_moyen_ep_REM;
    perc_REM_interPeriod_cno{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_interPeriod_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_interPeriod_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_interPeriod_cno{k}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_cno{k}=perc_moyen_totSleep;
    
    
    
    %%Late period of the session
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_end_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_end_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_end_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_end_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_end_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_end_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_end_cno{k}=num_moyen_ep_SWS;
    perc_SWS_end_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_end_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_end_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_cno{k}=dur_moyenne_ep_REM;
    num_REM_end_cno{k}=num_moyen_ep_REM;
    perc_REM_end_cno{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_cno{k}.Wake,same_epoch_end_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_end_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_end_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_end_cno{k}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_cno{k}.Wake,same_epoch_end_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_end_cno{k}),and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_cno{k} = trans_REM_to_REM;
    all_trans_REM_SWS_end_cno{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_cno{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_cno{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_cno{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_cno{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_cno{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_cno{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_cno{k} = trans_WAKE_to_WAKE;
    
    
   
    %%Short versus long REM bouts during late period
    [dur_REM_cno_bis{k}, durT_REM_cno(k)]=DurationEpoch(and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}),'s');
    
    idx_short_rem_cno_1{k} = find(dur_REM_cno_bis{k}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_cno_1{k} = subset(and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}), idx_short_rem_cno_1{k});
    [dur_rem_short_cno_1{k}, durT_rem_short_cno(k)] = DurationEpoch(short_REMEpoch_cno_1{k},'s');
    perc_rem_short_cno_1(k) = durT_rem_short_cno(k) / durT_REM_cno(k) * 100;
    dur_moyenne_rem_short_cno_1(k) = nanmean(dur_rem_short_cno_1{k});
    num_moyen_rem_short_cno_1(k) = length(dur_rem_short_cno_1{k});
    
    idx_short_rem_cno_2{k} = find(dur_REM_cno_bis{k}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_cno_2{k} = subset(and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}), idx_short_rem_cno_2{k});
    [dur_rem_short_cno_2{k}, durT_rem_short_cno(k)] = DurationEpoch(short_REMEpoch_cno_2{k},'s');
    perc_rem_short_cno_2(k) = durT_rem_short_cno(k) / durT_REM_cno(k) * 100;
    dur_moyenne_rem_short_cno_2(k) = nanmean(dur_rem_short_cno_2{k});
    num_moyen_rem_short_cno_2(k) = length(dur_rem_short_cno_2{k});
    
    idx_short_rem_cno_3{k} = find(dur_REM_cno_bis{k}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_cno_3{k} = subset(and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}), idx_short_rem_cno_3{k});
    [dur_rem_short_cno_3{k}, durT_rem_short_cno(k)] = DurationEpoch(short_REMEpoch_cno_3{k},'s');
    perc_rem_short_cno_3(k) = durT_rem_short_cno(k) / durT_REM_cno(k) * 100;
    dur_moyenne_rem_short_cno_3(k) = nanmean(dur_rem_short_cno_3{k});
    num_moyen_rem_short_cno_3(k) = length(dur_rem_short_cno_3{k});
    
    idx_long_rem_cno{k} = find(dur_REM_cno_bis{k}>lim_long_rem); %long bout
    long_REMEpoch_cno{k} = subset(and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}), idx_long_rem_cno{k});
    [dur_rem_long_cno{k}, durT_rem_long_cno(k)] = DurationEpoch(long_REMEpoch_cno{k},'s');
    perc_rem_long_cno(k) = durT_rem_long_cno(k) / durT_REM_cno(k) * 100;
    dur_moyenne_rem_long_cno(k) = nanmean(dur_rem_long_cno{k});
    num_moyen_rem_long_cno(k) = length(dur_rem_long_cno{k});
    
    idx_mid_rem_cno{k} = find(dur_REM_cno_bis{k}>lim_short_rem_1 & dur_REM_cno_bis{k}<lim_long_rem); % middle bouts
    mid_REMEpoch_cno{k} = subset(and(stages_cno{k}.REMEpoch,same_epoch_end_cno{k}), idx_mid_rem_cno{k});
    [dur_rem_mid_cno{k}, durT_rem_mid_cno(k)] = DurationEpoch(mid_REMEpoch_cno{k},'s');
    perc_rem_mid_cno(k) = durT_rem_mid_cno(k) / durT_REM_cno(k) * 100;
    dur_moyenne_rem_mid_cno(k) = nanmean(dur_rem_mid_cno{k});
    num_moyen_rem_mid_cno(k) = length(dur_rem_mid_cno{k});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_cno{k}.Wake,same_epoch_end_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_end_cno{k}),and(short_REMEpoch_cno_1{k},same_epoch_end_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_cno{k} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_cno{k} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_cno{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_cno{k}.Wake,same_epoch_end_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_end_cno{k}),and(mid_REMEpoch_cno{k},same_epoch_end_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_cno{k} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_cno{k} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_cno{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_cno{k}.Wake,same_epoch_end_cno{k}),and(stages_cno{k}.SWSEpoch,same_epoch_end_cno{k}),and(long_REMEpoch_cno{k},same_epoch_end_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_cno{k} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_cno{k} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_cno{k} = trans_REM_to_REM;
    
end

%% compute average - CNO
%%percentage/duration/number
for k=1:length(dur_REM_cno)
    %%ALL SESSION
    data_dur_REM_cno(k,:) = dur_REM_cno{k}; data_dur_REM_cno(isnan(data_dur_REM_cno)==1)=0;
    data_dur_SWS_cno(k,:) = dur_SWS_cno{k}; data_dur_SWS_cno(isnan(data_dur_SWS_cno)==1)=0;
    data_dur_WAKE_cno(k,:) = dur_WAKE_cno{k}; data_dur_WAKE_cno(isnan(data_dur_WAKE_cno)==1)=0;
    data_dur_totSleep_cno(k,:) = dur_totSleep_cno{k}; data_dur_totSleep_cno(isnan(data_dur_totSleep_cno)==1)=0;
    
    data_num_REM_cno(k,:) = num_REM_cno{k};data_num_REM_cno(isnan(data_num_REM_cno)==1)=0;
    data_num_SWS_cno(k,:) = num_SWS_cno{k}; data_num_SWS_cno(isnan(data_num_SWS_cno)==1)=0;
    data_num_WAKE_cno(k,:) = num_WAKE_cno{k}; data_num_WAKE_cno(isnan(data_num_WAKE_cno)==1)=0;
    data_num_totSleep_cno(k,:) = num_totSleep_cno{k}; data_num_totSleep_cno(isnan(data_num_totSleep_cno)==1)=0;
    
    data_perc_REM_cno(k,:) = perc_REM_cno{k}; data_perc_REM_cno(isnan(data_perc_REM_cno)==1)=0;
    data_perc_SWS_cno(k,:) = perc_SWS_cno{k}; data_perc_SWS_cno(isnan(data_perc_SWS_cno)==1)=0;
    data_perc_WAKE_cno(k,:) = perc_WAKE_cno{k}; data_perc_WAKE_cno(isnan(data_perc_WAKE_cno)==1)=0;
    data_perc_totSleep_cno(k,:) = perc_totSleep_cno{k}; data_perc_totSleep_cno(isnan(data_perc_totSleep_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_cno(k,:) = dur_REM_begin_cno{k}; data_dur_REM_begin_cno(isnan(data_dur_REM_begin_cno)==1)=0;
    data_dur_SWS_begin_cno(k,:) = dur_SWS_begin_cno{k}; data_dur_SWS_begin_cno(isnan(data_dur_SWS_begin_cno)==1)=0;
    data_dur_WAKE_begin_cno(k,:) = dur_WAKE_begin_cno{k}; data_dur_WAKE_begin_cno(isnan(data_dur_WAKE_begin_cno)==1)=0;
    data_dur_totSleep_begin_cno(k,:) = dur_totSleep_begin_cno{k}; data_dur_totSleep_begin_cno(isnan(data_dur_totSleep_begin_cno)==1)=0;
    
    
    data_num_REM_begin_cno(k,:) = num_REM_begin_cno{k};data_num_REM_begin_cno(isnan(data_num_REM_begin_cno)==1)=0;
    data_num_SWS_begin_cno(k,:) = num_SWS_begin_cno{k}; data_num_SWS_begin_cno(isnan(data_num_SWS_begin_cno)==1)=0;
    data_num_WAKE_begin_cno(k,:) = num_WAKE_begin_cno{k}; data_num_WAKE_begin_cno(isnan(data_num_WAKE_begin_cno)==1)=0;
    data_num_totSleep_begin_cno(k,:) = num_totSleep_begin_cno{k}; data_num_totSleep_begin_cno(isnan(data_num_totSleep_begin_cno)==1)=0;
    
    data_perc_REM_begin_cno(k,:) = perc_REM_begin_cno{k}; data_perc_REM_begin_cno(isnan(data_perc_REM_begin_cno)==1)=0;
    data_perc_SWS_begin_cno(k,:) = perc_SWS_begin_cno{k}; data_perc_SWS_begin_cno(isnan(data_perc_SWS_begin_cno)==1)=0;
    data_perc_WAKE_begin_cno(k,:) = perc_WAKE_begin_cno{k}; data_perc_WAKE_begin_cno(isnan(data_perc_WAKE_begin_cno)==1)=0;
    data_perc_totSleep_begin_cno(k,:) = perc_totSleep_begin_cno{k}; data_perc_totSleep_begin_cno(isnan(data_perc_totSleep_begin_cno)==1)=0;
    
    data_dur_REM_interPeriod_cno(k,:) = dur_REM_interPeriod_cno{k}; data_dur_REM_interPeriod_cno(isnan(data_dur_REM_interPeriod_cno)==1)=0;
    data_dur_SWS_interPeriod_cno(k,:) = dur_SWS_interPeriod_cno{k}; data_dur_SWS_interPeriod_cno(isnan(data_dur_SWS_interPeriod_cno)==1)=0;
    data_dur_WAKE_interPeriod_cno(k,:) = dur_WAKE_interPeriod_cno{k}; data_dur_WAKE_interPeriod_cno(isnan(data_dur_WAKE_interPeriod_cno)==1)=0;
    data_dur_totSleep_interPeriod_cno(k,:) = dur_totSleep_interPeriod_cno{k}; data_dur_totSleep_interPeriod_cno(isnan(data_dur_totSleep_interPeriod_cno)==1)=0;
    
    
    data_num_REM_interPeriod_cno(k,:) = num_REM_interPeriod_cno{k};data_num_REM_interPeriod_cno(isnan(data_num_REM_interPeriod_cno)==1)=0;
    data_num_SWS_interPeriod_cno(k,:) = num_SWS_interPeriod_cno{k}; data_num_SWS_interPeriod_cno(isnan(data_num_SWS_interPeriod_cno)==1)=0;
    data_num_WAKE_interPeriod_cno(k,:) = num_WAKE_interPeriod_cno{k}; data_num_WAKE_interPeriod_cno(isnan(data_num_WAKE_interPeriod_cno)==1)=0;
    data_num_totSleep_interPeriod_cno(k,:) = num_totSleep_interPeriod_cno{k}; data_num_totSleep_interPeriod_cno(isnan(data_num_totSleep_interPeriod_cno)==1)=0;
    
    data_perc_REM_interPeriod_cno(k,:) = perc_REM_interPeriod_cno{k}; data_perc_REM_interPeriod_cno(isnan(data_perc_REM_interPeriod_cno)==1)=0;
    data_perc_SWS_interPeriod_cno(k,:) = perc_SWS_interPeriod_cno{k}; data_perc_SWS_interPeriod_cno(isnan(data_perc_SWS_interPeriod_cno)==1)=0;
    data_perc_WAKE_interPeriod_cno(k,:) = perc_WAKE_interPeriod_cno{k}; data_perc_WAKE_interPeriod_cno(isnan(data_perc_WAKE_interPeriod_cno)==1)=0;
    data_perc_totSleep_interPeriod_cno(k,:) = perc_totSleep_interPeriod_cno{k}; data_perc_totSleep_interPeriod_cno(isnan(data_perc_totSleep_interPeriod_cno)==1)=0;
    
    %%FIN DE LA SESSION
    data_dur_REM_end_cno(k,:) = dur_REM_end_cno{k}; data_dur_REM_end_cno(isnan(data_dur_REM_end_cno)==1)=0;
    data_dur_SWS_end_cno(k,:) = dur_SWS_end_cno{k}; data_dur_SWS_end_cno(isnan(data_dur_SWS_end_cno)==1)=0;
    data_dur_WAKE_end_cno(k,:) = dur_WAKE_end_cno{k}; data_dur_WAKE_end_cno(isnan(data_dur_WAKE_end_cno)==1)=0;
    data_dur_totSleep_end_cno(k,:) = dur_totSleep_end_cno{k}; data_dur_totSleep_end_cno(isnan(data_dur_totSleep_end_cno)==1)=0;
    
    
    data_num_REM_end_cno(k,:) = num_REM_end_cno{k};data_num_REM_end_cno(isnan(data_num_REM_end_cno)==1)=0;
    data_num_SWS_end_cno(k,:) = num_SWS_end_cno{k}; data_num_SWS_end_cno(isnan(data_num_SWS_end_cno)==1)=0;
    data_num_WAKE_end_cno(k,:) = num_WAKE_end_cno{k}; data_num_WAKE_end_cno(isnan(data_num_WAKE_end_cno)==1)=0;
    data_num_totSleep_end_cno(k,:) = num_totSleep_end_cno{k}; data_num_totSleep_end_cno(isnan(data_num_totSleep_end_cno)==1)=0;
    
    
    data_perc_REM_end_cno(k,:) = perc_REM_end_cno{k}; data_perc_REM_end_cno(isnan(data_perc_REM_end_cno)==1)=0;
    data_perc_SWS_end_cno(k,:) = perc_SWS_end_cno{k}; data_perc_SWS_end_cno(isnan(data_perc_SWS_end_cno)==1)=0;
    data_perc_WAKE_end_cno(k,:) = perc_WAKE_end_cno{k}; data_perc_WAKE_end_cno(isnan(data_perc_WAKE_end_cno)==1)=0;
    data_perc_totSleep_end_cno(k,:) = perc_totSleep_end_cno{k}; data_perc_totSleep_end_cno(isnan(data_perc_totSleep_end_cno)==1)=0;
    
end
%%
%probability
for k=1:length(all_trans_REM_short_WAKE_end_cno)
    %     %%ALL SESSION
    %     data_REM_REM_cno(k,:) = all_trans_REM_REM_cno{k}; data_REM_REM_cno(isnan(data_REM_REM_cno)==1)=0;
    %     data_REM_SWS_cno(k,:) = all_trans_REM_SWS_cno{k}; data_REM_SWS_cno(isnan(data_REM_SWS_cno)==1)=0;
    %     data_REM_WAKE_cno(k,:) = all_trans_REM_WAKE_cno{k}; data_REM_WAKE_cno(isnan(data_REM_WAKE_cno)==1)=0;
    %
    %     data_SWS_SWS_cno(k,:) = all_trans_SWS_SWS_cno{k}; data_SWS_SWS_cno(isnan(data_SWS_SWS_cno)==1)=0;
    %     data_SWS_REM_cno(k,:) = all_trans_SWS_REM_cno{k}; data_SWS_REM_cno(isnan(data_SWS_REM_cno)==1)=0;
    %     data_SWS_WAKE_cno(k,:) = all_trans_SWS_WAKE_cno{k}; data_SWS_WAKE_cno(isnan(data_SWS_WAKE_cno)==1)=0;
    %
    %     data_WAKE_WAKE_cno(k,:) = all_trans_WAKE_WAKE_cno{k}; data_WAKE_WAKE_cno(isnan(data_WAKE_WAKE_cno)==1)=0;
    %     data_WAKE_REM_cno(k,:) = all_trans_WAKE_REM_cno{k}; data_WAKE_REM_cno(isnan(data_WAKE_REM_cno)==1)=0;
    %     data_WAKE_SWS_cno(k,:) = all_trans_WAKE_SWS_cno{k}; data_WAKE_SWS_cno(isnan(data_WAKE_SWS_cno)==1)=0;
    %
    %     %%3 PREMI7RES HEURES
    %         data_REM_REM_begin_cno(k,:) = all_trans_REM_REM_begin_cno{k}; data_REM_REM_begin_cno(isnan(data_REM_REM_begin_cno)==1)=0;
    %     data_REM_SWS_begin_cno(k,:) = all_trans_REM_SWS_begin_cno{k}; data_REM_SWS_begin_cno(isnan(data_REM_SWS_begin_cno)==1)=0;
    %     data_REM_WAKE_begin_cno(k,:) = all_trans_REM_WAKE_begin_cno{k}; data_REM_WAKE_begin_cno(isnan(data_REM_WAKE_begin_cno)==1)=0;
    %
    %     data_SWS_SWS_begin_cno(k,:) = all_trans_SWS_SWS_begin_cno{k}; data_SWS_SWS_begin_cno(isnan(data_SWS_SWS_begin_cno)==1)=0;
    %     data_SWS_REM_begin_cno(k,:) = all_trans_SWS_REM_begin_cno{k}; data_SWS_REM_begin_cno(isnan(data_SWS_REM_begin_cno)==1)=0;
    %     data_SWS_WAKE_begin_cno(k,:) = all_trans_SWS_WAKE_begin_cno{k}; data_SWS_WAKE_begin_cno(isnan(data_SWS_WAKE_begin_cno)==1)=0;
    %
    %     data_WAKE_WAKE_begin_cno(k,:) = all_trans_WAKE_WAKE_begin_cno{k}; data_WAKE_WAKE_begin_cno(isnan(data_WAKE_WAKE_begin_cno)==1)=0;
    %     data_WAKE_REM_begin_cno(k,:) = all_trans_WAKE_REM_begin_cno{k}; data_WAKE_REM_begin_cno(isnan(data_WAKE_REM_begin_cno)==1)=0;
    %     data_WAKE_SWS_begin_cno(k,:) = all_trans_WAKE_SWS_begin_cno{k}; data_WAKE_SWS_begin_cno(isnan(data_WAKE_SWS_begin_cno)==1)=0;
    %
    %     %%FIN DE LA SESSION
    %         data_REM_REM_end_cno(k,:) = all_trans_REM_REM_end_cno{k}; data_REM_REM_end_cno(isnan(data_REM_REM_end_cno)==1)=0;
    %     data_REM_SWS_end_cno(k,:) = all_trans_REM_SWS_end_cno{k}; data_REM_SWS_end_cno(isnan(data_REM_SWS_end_cno)==1)=0;
    %     data_REM_WAKE_end_cno(k,:) = all_trans_REM_WAKE_end_cno{k}; data_REM_WAKE_end_cno(isnan(data_REM_WAKE_end_cno)==1)=0;
    %
    %     data_SWS_SWS_end_cno(k,:) = all_trans_SWS_SWS_end_cno{k}; data_SWS_SWS_end_cno(isnan(data_SWS_SWS_end_cno)==1)=0;
    %     data_SWS_REM_end_cno(k,:) = all_trans_SWS_REM_end_cno{k}; data_SWS_REM_end_cno(isnan(data_SWS_REM_end_cno)==1)=0;
    %     data_SWS_WAKE_end_cno(k,:) = all_trans_SWS_WAKE_end_cno{k}; data_SWS_WAKE_end_cno(isnan(data_SWS_WAKE_end_cno)==1)=0;
    %
    %     data_WAKE_WAKE_end_cno(k,:) = all_trans_WAKE_WAKE_end_cno{k}; data_WAKE_WAKE_end_cno(isnan(data_WAKE_WAKE_end_cno)==1)=0;
    %     data_WAKE_REM_end_cno(k,:) = all_trans_WAKE_REM_end_cno{k}; data_WAKE_REM_end_cno(isnan(data_WAKE_REM_end_cno)==1)=0;
    %     data_WAKE_SWS_end_cno(k,:) = all_trans_WAKE_SWS_end_cno{k}; data_WAKE_SWS_end_cno(isnan(data_WAKE_SWS_end_cno)==1)=0;
    %
    data_REM_short_WAKE_end_cno(k,:) = all_trans_REM_short_WAKE_end_cno{k}; data_REM_short_WAKE_end_cno(isnan(data_REM_short_WAKE_end_cno)==1)=0;
    data_REM_short_SWS_end_cno(k,:) = all_trans_REM_short_SWS_end_cno{k}; data_REM_short_SWS_end_cno(isnan(data_REM_short_SWS_end_cno)==1)=0;
    
    data_REM_mid_WAKE_end_cno(k,:) = all_trans_REM_mid_WAKE_end_cno{k}; data_REM_mid_WAKE_end_cno(isnan(data_REM_mid_WAKE_end_cno)==1)=0;
    data_REM_mid_SWS_end_cno(k,:) = all_trans_REM_mid_SWS_end_cno{k}; data_REM_mid_SWS_end_cno(isnan(data_REM_mid_SWS_end_cno)==1)=0;
    
    data_REM_long_WAKE_end_cno(k,:) = all_trans_REM_long_WAKE_end_cno{k}; data_REM_long_WAKE_end_cno(isnan(data_REM_long_WAKE_end_cno)==1)=0;
    data_REM_long_SWS_end_cno(k,:) = all_trans_REM_long_SWS_end_cno{k}; data_REM_long_SWS_end_cno(isnan(data_REM_long_SWS_end_cno)==1)=0;
    
    data_REM_short_REM_end_cno(k,:) = all_trans_REM_short_REM_end_cno{k}; %data_REM_short_REM_end_cno(isnan(data_REM_short_REM_end_cno)==1)=0;
    data_REM_mid_REM_end_cno(k,:) = all_trans_REM_mid_REM_end_cno{k}; %data_REM_mid_REM_end_cno(isnan(data_REM_mid_REM_end_cno)==1)=0;
    data_REM_long_REM_end_cno(k,:) = all_trans_REM_long_REM_end_cno{k}; %data_REM_long_REM_end_cno(isnan(data_REM_long_REM_end_cno)==1)=0;
    
end


