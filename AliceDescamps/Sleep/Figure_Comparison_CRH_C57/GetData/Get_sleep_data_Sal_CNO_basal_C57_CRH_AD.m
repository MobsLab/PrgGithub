
%% input dir

%%1
Dir_C57_Sal = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');

%%2
Dir_C57_CNO = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_CNOInjection_10am');

%%3
Dir_CRH_Sal = PathForExperiments_DREADD_AD('mCherry_CRH_VLPO_SalineInjection_10am');

%%4
Dir_CRH_CNO = PathForExperiments_DREADD_AD('mCherry_CRH_VLPO_CNOInjection_10am');


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

%% GET DATA 
% C57 mCherry saline injection 10h without stress

for i=1:length(Dir_C57_Sal.path)
    cd(Dir_C57_Sal.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_C57_Sal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_C57_Sal{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%Define different periods of time for quantifications
    same_epoch_all_sess_C57_Sal{i} = intervalSet(0,time_end); %all session
    same_epoch_begin_C57_Sal{i} = intervalSet(time_st,time_mid_begin_snd_period); %beginning of the session (period of insomnia)
    same_epoch_end_C57_Sal{i} = intervalSet(time_mid_begin_snd_period,time_end); %late phase of the session (rem frag)
    same_epoch_interPeriod_C57_Sal{i} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period); %inter period
    
    %%Compute percentage, mean duration, number of bouts overtime (over all session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_C57_Sal{i}.Wake,same_epoch_all_sess_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_all_sess_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_all_sess_C57_Sal{i}),'wake',tempbin,time_st,time_end);
    dur_WAKE_C57_Sal{i}=dur_moyenne_ep_WAKE;
    num_WAKE_C57_Sal{i}=num_moyen_ep_WAKE;
    perc_WAKE_C57_Sal{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_C57_Sal{i}.Wake,same_epoch_all_sess_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_all_sess_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_all_sess_C57_Sal{i}),'sws',tempbin,time_st,time_end);
    dur_SWS_C57_Sal{i}=dur_moyenne_ep_SWS;
    num_SWS_C57_Sal{i}=num_moyen_ep_SWS;
    perc_SWS_C57_Sal{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_C57_Sal{i}.Wake,same_epoch_all_sess_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_all_sess_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_all_sess_C57_Sal{i}),'rem',tempbin,time_st,time_end);
    dur_REM_C57_Sal{i}=dur_moyenne_ep_REM;
    num_REM_C57_Sal{i}=num_moyen_ep_REM;
    perc_REM_C57_Sal{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_C57_Sal{i}.Wake,same_epoch_all_sess_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_all_sess_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_all_sess_C57_Sal{i}),'sleep',tempbin,time_st,time_end);
    dur_totSleepctrl{i}=dur_moyenne_ep_totSleep;
    num_totSleepctrl{i}=num_moyen_ep_totSleep;
    perc_totSleepctrl{i}=perc_moyen_totSleep;
    

    %%First period (beginning)
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_begin_C57_Sal{i}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_C57_Sal{i}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_C57_Sal{i}=num_moyen_ep_WAKE;
    perc_WAKE_begin_C57_Sal{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_begin_C57_Sal{i}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_C57_Sal{i}=dur_moyenne_ep_SWS;
    num_SWS_begin_C57_Sal{i}=num_moyen_ep_SWS;
    perc_SWS_begin_C57_Sal{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_begin_C57_Sal{i}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_C57_Sal{i}=dur_moyenne_ep_REM;
    num_REM_begin_C57_Sal{i}=num_moyen_ep_REM;
    perc_REM_begin_C57_Sal{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_begin_C57_Sal{i}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_C57_Sal{i}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_C57_Sal{i}=num_moyen_ep_totSleep;
    perc_totSleep_begin_C57_Sal{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_Sal{i}.Wake,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_begin_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_begin_C57_Sal{i}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_C57_Sal{i} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_C57_Sal{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_C57_Sal{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_C57_Sal{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_C57_Sal{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_C57_Sal{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_C57_Sal{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_C57_Sal{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_C57_Sal{i} = trans_WAKE_to_WAKE;
    
    
    
    %%Inter period (middle part of the session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_interPeriod_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_interPeriod_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_interPeriod_C57_Sal{i}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_C57_Sal{i}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_C57_Sal{i}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_C57_Sal{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_interPeriod_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_interPeriod_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_interPeriod_C57_Sal{i}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_C57_Sal{i}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_C57_Sal{i}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_C57_Sal{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_interPeriod_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_interPeriod_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_interPeriod_C57_Sal{i}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_C57_Sal{i}=dur_moyenne_ep_REM;
    num_REM_interPeriod_C57_Sal{i}=num_moyen_ep_REM;
    perc_REM_interPeriod_C57_Sal{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_interPeriod_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_interPeriod_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_interPeriod_C57_Sal{i}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_C57_Sal{i}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_C57_Sal{i}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_C57_Sal{i}=perc_moyen_totSleep;
    
    
    
    %%Late period of the session
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_C57_Sal{i}=dur_moyenne_ep_WAKE;
    num_WAKE_end_C57_Sal{i}=num_moyen_ep_WAKE;
    perc_WAKE_end_C57_Sal{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_C57_Sal{i}=dur_moyenne_ep_SWS;
    num_SWS_end_C57_Sal{i}=num_moyen_ep_SWS;
    perc_SWS_end_C57_Sal{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_C57_Sal{i}=dur_moyenne_ep_REM;
    num_REM_end_C57_Sal{i}=num_moyen_ep_REM;
    perc_REM_end_C57_Sal{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_Sal{i}.Wake,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_C57_Sal{i}=dur_moyenne_ep_totSleep;
    num_totSleep_end_C57_Sal{i}=num_moyen_ep_totSleep;
    perc_totSleep_end_C57_Sal{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_Sal{i}.Wake,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_C57_Sal{i} = trans_REM_to_REM;
    all_trans_REM_SWS_end_C57_Sal{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_C57_Sal{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_C57_Sal{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_C57_Sal{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_C57_Sal{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_C57_Sal{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_C57_Sal{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_C57_Sal{i} = trans_WAKE_to_WAKE;
    
    
   
    %%Short versus long REM bouts during late period
    [dur_WAKE_C57_Sal_bis{i}, durT_WAKE_C57_Sal(i)]=DurationEpoch(and(stages_C57_Sal{i}.Wake,same_epoch_end_C57_Sal{i}),'s');
    [dur_SWS_C57_Sal_bis{i}, durT_SWS_C57_Sal(i)]=DurationEpoch(and(stages_C57_Sal{i}.SWSEpoch,same_epoch_end_C57_Sal{i}),'s');

    [dur_REM_C57_Sal_bis{i}, durT_REM_C57_Sal(i)]=DurationEpoch(and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}),'s');
    
    idx_short_rem_C57_Sal_1{i} = find(dur_REM_C57_Sal_bis{i}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_C57_Sal_1{i} = subset(and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}), idx_short_rem_C57_Sal_1{i});
    [dur_rem_short_C57_Sal_1{i}, durT_rem_short_C57_Sal(i)] = DurationEpoch(short_REMEpoch_C57_Sal_1{i},'s');
    perc_rem_short_C57_Sal_1(i) = durT_rem_short_C57_Sal(i) / durT_REM_C57_Sal(i) * 100;
    dur_moyenne_rem_short_C57_Sal_1(i) = nanmean(dur_rem_short_C57_Sal_1{i});
    num_moyen_rem_short_C57_Sal_1(i) = length(dur_rem_short_C57_Sal_1{i});
    
    idx_short_rem_C57_Sal_2{i} = find(dur_REM_C57_Sal_bis{i}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_C57_Sal_2{i} = subset(and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}), idx_short_rem_C57_Sal_2{i});
    [dur_rem_short_C57_Sal_2{i}, durT_rem_short_C57_Sal(i)] = DurationEpoch(short_REMEpoch_C57_Sal_2{i},'s');
    perc_rem_short_C57_Sal_2(i) = durT_rem_short_C57_Sal(i) / durT_REM_C57_Sal(i) * 100;
    dur_moyenne_rem_short_C57_Sal_2(i) = nanmean(dur_rem_short_C57_Sal_2{i});
    num_moyen_rem_short_C57_Sal_2(i) = length(dur_rem_short_C57_Sal_2{i});
    
    idx_short_rem_C57_Sal_3{i} = find(dur_REM_C57_Sal_bis{i}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_C57_Sal_3{i} = subset(and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}), idx_short_rem_C57_Sal_3{i});
    [dur_rem_short_C57_Sal_3{i}, durT_rem_short_C57_Sal(i)] = DurationEpoch(short_REMEpoch_C57_Sal_3{i},'s');
    perc_rem_short_C57_Sal_3(i) = durT_rem_short_C57_Sal(i) / durT_REM_C57_Sal(i) * 100;
    dur_moyenne_rem_short_C57_Sal_3(i) = nanmean(dur_rem_short_C57_Sal_3{i});
    num_moyen_rem_short_C57_Sal_3(i) = length(dur_rem_short_C57_Sal_3{i});
    
    idx_long_rem_C57_Sal{i} = find(dur_REM_C57_Sal_bis{i}>lim_long_rem); %long bout
    long_REMEpoch_C57_Sal{i} = subset(and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}), idx_long_rem_C57_Sal{i});
    [dur_rem_long_C57_Sal{i}, durT_rem_long_C57_Sal(i)] = DurationEpoch(long_REMEpoch_C57_Sal{i},'s');
    perc_rem_long_C57_Sal(i) = durT_rem_long_C57_Sal(i) / durT_REM_C57_Sal(i) * 100;
    dur_moyenne_rem_long_C57_Sal(i) = nanmean(dur_rem_long_C57_Sal{i});
    num_moyen_rem_long_C57_Sal(i) = length(dur_rem_long_C57_Sal{i});
    
    idx_mid_rem_C57_Sal{i} = find(dur_REM_C57_Sal_bis{i}>lim_short_rem_1 & dur_REM_C57_Sal_bis{i}<lim_long_rem); % middle bouts
    mid_REMEpoch_C57_Sal{i} = subset(and(stages_C57_Sal{i}.REMEpoch,same_epoch_end_C57_Sal{i}), idx_mid_rem_C57_Sal{i});
    [dur_rem_mid_C57_Sal{i}, durT_rem_mid_C57_Sal(i)] = DurationEpoch(mid_REMEpoch_C57_Sal{i},'s');
    perc_rem_mid_C57_Sal(i) = durT_rem_mid_C57_Sal(i) / durT_REM_C57_Sal(i) * 100;
    dur_moyenne_rem_mid_C57_Sal(i) = nanmean(dur_rem_mid_C57_Sal{i});
    num_moyen_rem_mid_C57_Sal(i) = length(dur_rem_mid_C57_Sal{i});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_Sal{i}.Wake,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_end_C57_Sal{i}),and(short_REMEpoch_C57_Sal_1{i},same_epoch_end_C57_Sal{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_C57_Sal{i} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_C57_Sal{i} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_C57_Sal{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_Sal{i}.Wake,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_end_C57_Sal{i}),and(mid_REMEpoch_C57_Sal{i},same_epoch_end_C57_Sal{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_C57_Sal{i} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_C57_Sal{i} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_C57_Sal{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_Sal{i}.Wake,same_epoch_end_C57_Sal{i}),and(stages_C57_Sal{i}.SWSEpoch,same_epoch_end_C57_Sal{i}),and(long_REMEpoch_C57_Sal{i},same_epoch_end_C57_Sal{i}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_C57_Sal{i} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_C57_Sal{i} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_C57_Sal{i} = trans_REM_to_REM;
    
    
    st_sws_C57_Sal{i} = Start(stages_C57_Sal{i}.SWSEpoch);
    idx_sws_C57_Sal{i} = find(mindurSWS<dur_SWS_C57_Sal_bis{i},1,'first');
    latency_sws_C57_Sal(i) =  st_sws_C57_Sal{i}(idx_sws_C57_Sal{i});
    
    
    st_rem_C57_Sal{i} = Start(stages_C57_Sal{i}.REMEpoch);
    idx_rem_C57_Sal{i} = find(mindurREM<dur_REM_C57_Sal_bis{i},1,'first');
    latency_rem_C57_Sal(i) =  st_rem_C57_Sal{i}(idx_rem_C57_Sal{i});
end

%% compute average - C57 mCherry saline injection 10h without stress
%%percentage/duration/number
for i=1:length(dur_REM_C57_Sal)
    %%ALL SESSION
    data_dur_REM_C57_Sal(i,:) = dur_REM_C57_Sal{i}; data_dur_REM_C57_Sal(isnan(data_dur_REM_C57_Sal)==1)=0;
    data_dur_SWS_C57_Sal(i,:) = dur_SWS_C57_Sal{i}; data_dur_SWS_C57_Sal(isnan(data_dur_SWS_C57_Sal)==1)=0;
    data_dur_WAKE_C57_Sal(i,:) = dur_WAKE_C57_Sal{i}; data_dur_WAKE_C57_Sal(isnan(data_dur_WAKE_C57_Sal)==1)=0;
    data_dur_totSleep_C57_Sal(i,:) = dur_totSleepctrl{i}; data_dur_totSleep_C57_Sal(isnan(data_dur_totSleep_C57_Sal)==1)=0;
    
    data_num_REM_C57_Sal(i,:) = num_REM_C57_Sal{i};data_num_REM_C57_Sal(isnan(data_num_REM_C57_Sal)==1)=0;
    data_num_SWS_C57_Sal(i,:) = num_SWS_C57_Sal{i}; data_num_SWS_C57_Sal(isnan(data_num_SWS_C57_Sal)==1)=0;
    data_num_WAKE_C57_Sal(i,:) = num_WAKE_C57_Sal{i}; data_num_WAKE_C57_Sal(isnan(data_num_WAKE_C57_Sal)==1)=0;
    data_num_totSleep_C57_Sal(i,:) = num_totSleepctrl{i}; data_num_totSleep_C57_Sal(isnan(data_num_totSleep_C57_Sal)==1)=0;
    
    data_perc_REM_C57_Sal(i,:) = perc_REM_C57_Sal{i}; data_perc_REM_C57_Sal(isnan(data_perc_REM_C57_Sal)==1)=0;
    data_perc_SWS_C57_Sal(i,:) = perc_SWS_C57_Sal{i}; data_perc_SWS_C57_Sal(isnan(data_perc_SWS_C57_Sal)==1)=0;
    data_perc_WAKE_C57_Sal(i,:) = perc_WAKE_C57_Sal{i}; data_perc_WAKE_C57_Sal(isnan(data_perc_WAKE_C57_Sal)==1)=0;
    data_perc_totSleep_C57_Sal(i,:) = perc_totSleepctrl{i}; data_perc_totSleep_C57_Sal(isnan(data_perc_totSleep_C57_Sal)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_C57_Sal(i,:) = dur_REM_begin_C57_Sal{i}; data_dur_REM_begin_C57_Sal(isnan(data_dur_REM_begin_C57_Sal)==1)=0;
    data_dur_SWS_begin_C57_Sal(i,:) = dur_SWS_begin_C57_Sal{i}; data_dur_SWS_begin_C57_Sal(isnan(data_dur_SWS_begin_C57_Sal)==1)=0;
    data_dur_WAKE_begin_C57_Sal(i,:) = dur_WAKE_begin_C57_Sal{i}; data_dur_WAKE_begin_C57_Sal(isnan(data_dur_WAKE_begin_C57_Sal)==1)=0;
    data_dur_totSleep_begin_C57_Sal(i,:) = dur_totSleep_begin_C57_Sal{i}; data_dur_totSleep_begin_C57_Sal(isnan(data_dur_totSleep_begin_C57_Sal)==1)=0;
    
    
    data_num_REM_begin_C57_Sal(i,:) = num_REM_begin_C57_Sal{i};data_num_REM_begin_C57_Sal(isnan(data_num_REM_begin_C57_Sal)==1)=0;
    data_num_SWS_begin_C57_Sal(i,:) = num_SWS_begin_C57_Sal{i}; data_num_SWS_begin_C57_Sal(isnan(data_num_SWS_begin_C57_Sal)==1)=0;
    data_num_WAKE_begin_C57_Sal(i,:) = num_WAKE_begin_C57_Sal{i}; data_num_WAKE_begin_C57_Sal(isnan(data_num_WAKE_begin_C57_Sal)==1)=0;
    data_num_totSleep_begin_C57_Sal(i,:) = num_totSleep_begin_C57_Sal{i}; data_num_totSleep_begin_C57_Sal(isnan(data_num_totSleep_begin_C57_Sal)==1)=0;
    
    data_perc_REM_begin_C57_Sal(i,:) = perc_REM_begin_C57_Sal{i}; data_perc_REM_begin_C57_Sal(isnan(data_perc_REM_begin_C57_Sal)==1)=0;
    data_perc_SWS_begin_C57_Sal(i,:) = perc_SWS_begin_C57_Sal{i}; data_perc_SWS_begin_C57_Sal(isnan(data_perc_SWS_begin_C57_Sal)==1)=0;
    data_perc_WAKE_begin_C57_Sal(i,:) = perc_WAKE_begin_C57_Sal{i}; data_perc_WAKE_begin_C57_Sal(isnan(data_perc_WAKE_begin_C57_Sal)==1)=0;
    data_perc_totSleep_begin_C57_Sal(i,:) = perc_totSleep_begin_C57_Sal{i}; data_perc_totSleep_begin_C57_Sal(isnan(data_perc_totSleep_begin_C57_Sal)==1)=0;
    
    data_dur_REM_interPeriod_C57_Sal(i,:) = dur_REM_interPeriod_C57_Sal{i}; data_dur_REM_interPeriod_C57_Sal(isnan(data_dur_REM_interPeriod_C57_Sal)==1)=0;
    data_dur_SWS_interPeriod_C57_Sal(i,:) = dur_SWS_interPeriod_C57_Sal{i}; data_dur_SWS_interPeriod_C57_Sal(isnan(data_dur_SWS_interPeriod_C57_Sal)==1)=0;
    data_dur_WAKE_interPeriod_C57_Sal(i,:) = dur_WAKE_interPeriod_C57_Sal{i}; data_dur_WAKE_interPeriod_C57_Sal(isnan(data_dur_WAKE_interPeriod_C57_Sal)==1)=0;
    data_dur_totSleep_interPeriod_C57_Sal(i,:) = dur_totSleep_interPeriod_C57_Sal{i}; data_dur_totSleep_interPeriod_C57_Sal(isnan(data_dur_totSleep_interPeriod_C57_Sal)==1)=0;
    
    
    data_num_REM_interPeriod_C57_Sal(i,:) = num_REM_interPeriod_C57_Sal{i};data_num_REM_interPeriod_C57_Sal(isnan(data_num_REM_interPeriod_C57_Sal)==1)=0;
    data_num_SWS_interPeriod_C57_Sal(i,:) = num_SWS_interPeriod_C57_Sal{i}; data_num_SWS_interPeriod_C57_Sal(isnan(data_num_SWS_interPeriod_C57_Sal)==1)=0;
    data_num_WAKE_interPeriod_C57_Sal(i,:) = num_WAKE_interPeriod_C57_Sal{i}; data_num_WAKE_interPeriod_C57_Sal(isnan(data_num_WAKE_interPeriod_C57_Sal)==1)=0;
    data_num_totSleep_interPeriod_C57_Sal(i,:) = num_totSleep_interPeriod_C57_Sal{i}; data_num_totSleep_interPeriod_C57_Sal(isnan(data_num_totSleep_interPeriod_C57_Sal)==1)=0;
    
    data_perc_REM_interPeriod_C57_Sal(i,:) = perc_REM_interPeriod_C57_Sal{i}; data_perc_REM_interPeriod_C57_Sal(isnan(data_perc_REM_interPeriod_C57_Sal)==1)=0;
    data_perc_SWS_interPeriod_C57_Sal(i,:) = perc_SWS_interPeriod_C57_Sal{i}; data_perc_SWS_interPeriod_C57_Sal(isnan(data_perc_SWS_interPeriod_C57_Sal)==1)=0;
    data_perc_WAKE_interPeriod_C57_Sal(i,:) = perc_WAKE_interPeriod_C57_Sal{i}; data_perc_WAKE_interPeriod_C57_Sal(isnan(data_perc_WAKE_interPeriod_C57_Sal)==1)=0;
    data_perc_totSleep_interPeriod_C57_Sal(i,:) = perc_totSleep_interPeriod_C57_Sal{i}; data_perc_totSleep_interPeriod_C57_Sal(isnan(data_perc_totSleep_interPeriod_C57_Sal)==1)=0;
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_C57_Sal(i,:) = dur_REM_end_C57_Sal{i}; data_dur_REM_end_C57_Sal(isnan(data_dur_REM_end_C57_Sal)==1)=0;
    data_dur_SWS_end_C57_Sal(i,:) = dur_SWS_end_C57_Sal{i}; data_dur_SWS_end_C57_Sal(isnan(data_dur_SWS_end_C57_Sal)==1)=0;
    data_dur_WAKE_end_C57_Sal(i,:) = dur_WAKE_end_C57_Sal{i}; data_dur_WAKE_end_C57_Sal(isnan(data_dur_WAKE_end_C57_Sal)==1)=0;
    data_dur_totSleep_end_C57_Sal(i,:) = dur_totSleep_end_C57_Sal{i}; data_dur_totSleep_end_C57_Sal(isnan(data_dur_totSleep_end_C57_Sal)==1)=0;
    
    
    data_num_REM_end_C57_Sal(i,:) = num_REM_end_C57_Sal{i};data_num_REM_end_C57_Sal(isnan(data_num_REM_end_C57_Sal)==1)=0;
    data_num_SWS_end_C57_Sal(i,:) = num_SWS_end_C57_Sal{i}; data_num_SWS_end_C57_Sal(isnan(data_num_SWS_end_C57_Sal)==1)=0;
    data_num_WAKE_end_C57_Sal(i,:) = num_WAKE_end_C57_Sal{i}; data_num_WAKE_end_C57_Sal(isnan(data_num_WAKE_end_C57_Sal)==1)=0;
    data_num_totSleep_end_C57_Sal(i,:) = num_totSleep_end_C57_Sal{i}; data_num_totSleep_end_C57_Sal(isnan(data_num_totSleep_end_C57_Sal)==1)=0;
    
    
    data_perc_REM_end_C57_Sal(i,:) = perc_REM_end_C57_Sal{i}; data_perc_REM_end_C57_Sal(isnan(data_perc_REM_end_C57_Sal)==1)=0;
    data_perc_SWS_end_C57_Sal(i,:) = perc_SWS_end_C57_Sal{i}; data_perc_SWS_end_C57_Sal(isnan(data_perc_SWS_end_C57_Sal)==1)=0;
    data_perc_WAKE_end_C57_Sal(i,:) = perc_WAKE_end_C57_Sal{i}; data_perc_WAKE_end_C57_Sal(isnan(data_perc_WAKE_end_C57_Sal)==1)=0;
    data_perc_totSleep_end_C57_Sal(i,:) = perc_totSleep_end_C57_Sal{i}; data_perc_totSleep_end_C57_Sal(isnan(data_perc_totSleep_end_C57_Sal)==1)=0;
    
end
%% probability
for i=1:length(all_trans_REM_short_WAKE_end_C57_Sal)
%     %%ALL SESSION
%     data_REM_REM_C57_Sal(i,:) = all_trans_REM_REM_C57_Sal{i}; data_REM_REM_C57_Sal(isnan(data_REM_REM_C57_Sal)==1)=0;
%     data_REM_SWS_C57_Sal(i,:) = all_trans_REM_SWS_C57_Sal{i}; data_REM_SWS_C57_Sal(isnan(data_REM_SWS_C57_Sal)==1)=0;
%     data_REM_WAKE_C57_Sal(i,:) = all_trans_REM_WAKE_C57_Sal{i}; data_REM_WAKE_C57_Sal(isnan(data_REM_WAKE_C57_Sal)==1)=0;
%
%     data_SWS_SWS_C57_Sal(i,:) = all_trans_SWS_SWS_C57_Sal{i}; data_SWS_SWS_C57_Sal(isnan(data_SWS_SWS_C57_Sal)==1)=0;
%     data_SWS_REM_C57_Sal(i,:) = all_trans_SWS_REM_C57_Sal{i}; data_SWS_REM_C57_Sal(isnan(data_SWS_REM_C57_Sal)==1)=0;
%     data_SWS_WAKE_C57_Sal(i,:) = all_trans_SWS_WAKE_C57_Sal{i}; data_SWS_WAKE_C57_Sal(isnan(data_SWS_WAKE_C57_Sal)==1)=0;
%
%     data_WAKE_WAKE_C57_Sal(i,:) = all_trans_WAKE_WAKE_C57_Sal{i}; data_WAKE_WAKE_C57_Sal(isnan(data_WAKE_WAKE_C57_Sal)==1)=0;
%     data_WAKE_REM_C57_Sal(i,:) = all_trans_WAKE_REM_C57_Sal{i}; data_WAKE_REM_C57_Sal(isnan(data_WAKE_REM_C57_Sal)==1)=0;
%     data_WAKE_SWS_C57_Sal(i,:) = all_trans_WAKE_SWS_C57_Sal{i}; data_WAKE_SWS_C57_Sal(isnan(data_WAKE_SWS_C57_Sal)==1)=0;
%
%     %%3 PREMI7RES HEURES
%         data_REM_REM_begin_C57_Sal(i,:) = all_trans_REM_REM_begin_C57_Sal{i}; data_REM_REM_begin_C57_Sal(isnan(data_REM_REM_begin_C57_Sal)==1)=0;
%     data_REM_SWS_begin_C57_Sal(i,:) = all_trans_REM_SWS_begin_C57_Sal{i}; data_REM_SWS_begin_C57_Sal(isnan(data_REM_SWS_begin_C57_Sal)==1)=0;
%     data_REM_WAKE_begin_C57_Sal(i,:) = all_trans_REM_WAKE_begin_C57_Sal{i}; data_REM_WAKE_begin_C57_Sal(isnan(data_REM_WAKE_begin_C57_Sal)==1)=0;
%
%     data_SWS_SWS_begin_C57_Sal(i,:) = all_trans_SWS_SWS_begin_C57_Sal{i}; data_SWS_SWS_begin_C57_Sal(isnan(data_SWS_SWS_begin_C57_Sal)==1)=0;
%     data_SWS_REM_begin_C57_Sal(i,:) = all_trans_SWS_REM_begin_C57_Sal{i}; data_SWS_REM_begin_C57_Sal(isnan(data_SWS_REM_begin_C57_Sal)==1)=0;
%     data_SWS_WAKE_begin_C57_Sal(i,:) = all_trans_SWS_WAKE_begin_C57_Sal{i}; data_SWS_WAKE_begin_C57_Sal(isnan(data_SWS_WAKE_begin_C57_Sal)==1)=0;
%
%     data_WAKE_WAKE_begin_C57_Sal(i,:) = all_trans_WAKE_WAKE_begin_C57_Sal{i}; data_WAKE_WAKE_begin_C57_Sal(isnan(data_WAKE_WAKE_begin_C57_Sal)==1)=0;
%     data_WAKE_REM_begin_C57_Sal(i,:) = all_trans_WAKE_REM_begin_C57_Sal{i}; data_WAKE_REM_begin_C57_Sal(isnan(data_WAKE_REM_begin_C57_Sal)==1)=0;
%     data_WAKE_SWS_begin_C57_Sal(i,:) = all_trans_WAKE_SWS_begin_C57_Sal{i}; data_WAKE_SWS_begin_C57_Sal(isnan(data_WAKE_SWS_begin_C57_Sal)==1)=0;
%
%     %%FIN DE LA SESSION
%         data_REM_REM_end_C57_Sal(i,:) = all_trans_REM_REM_end_C57_Sal{i}; data_REM_REM_end_C57_Sal(isnan(data_REM_REM_end_C57_Sal)==1)=0;
%     data_REM_SWS_end_C57_Sal(i,:) = all_trans_REM_SWS_end_C57_Sal{i}; data_REM_SWS_end_C57_Sal(isnan(data_REM_SWS_end_C57_Sal)==1)=0;
%     data_REM_WAKE_end_C57_Sal(i,:) = all_trans_REM_WAKE_end_C57_Sal{i}; data_REM_WAKE_end_C57_Sal(isnan(data_REM_WAKE_end_C57_Sal)==1)=0;
%
%     data_SWS_SWS_end_C57_Sal(i,:) = all_trans_SWS_SWS_end_C57_Sal{i}; data_SWS_SWS_end_C57_Sal(isnan(data_SWS_SWS_end_C57_Sal)==1)=0;
%     data_SWS_REM_end_C57_Sal(i,:) = all_trans_SWS_REM_end_C57_Sal{i}; data_SWS_REM_end_C57_Sal(isnan(data_SWS_REM_end_C57_Sal)==1)=0;
%     data_SWS_WAKE_end_C57_Sal(i,:) = all_trans_SWS_WAKE_end_C57_Sal{i}; data_SWS_WAKE_end_C57_Sal(isnan(data_SWS_WAKE_end_C57_Sal)==1)=0;
%
%     data_WAKE_WAKE_end_C57_Sal(i,:) = all_trans_WAKE_WAKE_end_C57_Sal{i}; data_WAKE_WAKE_end_C57_Sal(isnan(data_WAKE_WAKE_end_C57_Sal)==1)=0;
%     data_WAKE_REM_end_C57_Sal(i,:) = all_trans_WAKE_REM_end_C57_Sal{i}; data_WAKE_REM_end_C57_Sal(isnan(data_WAKE_REM_end_C57_Sal)==1)=0;
%     data_WAKE_SWS_end_C57_Sal(i,:) = all_trans_WAKE_SWS_end_C57_Sal{i}; data_WAKE_SWS_end_C57_Sal(isnan(data_WAKE_SWS_end_C57_Sal)==1)=0;
%
%
%
    data_REM_short_WAKE_end_C57_Sal(i,:) = all_trans_REM_short_WAKE_end_C57_Sal{i}; %data_REM_short_WAKE_end_C57_Sal(isnan(data_REM_short_WAKE_end_C57_Sal)==1)=0;
    data_REM_short_SWS_end_C57_Sal(i,:) = all_trans_REM_short_SWS_end_C57_Sal{i};% data_REM_short_SWS_end_C57_Sal(isnan(data_REM_short_SWS_end_C57_Sal)==1)=0;
    data_REM_short_REM_end_C57_Sal(i,:) = all_trans_REM_short_REM_end_C57_Sal{i}; %data_REM_short_WAKE_end_C57_Sal(isnan(data_REM_short_WAKE_end_C57_Sal)==1)=0;

    data_REM_mid_WAKE_end_C57_Sal(i,:) = all_trans_REM_mid_WAKE_end_C57_Sal{i}; %data_REM_mid_WAKE_end_C57_Sal(isnan(data_REM_mid_WAKE_end_C57_Sal)==1)=0;
    data_REM_mid_SWS_end_C57_Sal(i,:) = all_trans_REM_mid_SWS_end_C57_Sal{i}; %data_REM_mid_SWS_end_C57_Sal(isnan(data_REM_mid_SWS_end_C57_Sal)==1)=0;
    data_REM_mid_REM_end_C57_Sal(i,:) = all_trans_REM_mid_REM_end_C57_Sal{i}; %data_REM_mid_WAKE_end_C57_Sal(isnan(data_REM_short_WAKE_end_C57_Sal)==1)=0;

    data_REM_long_WAKE_end_C57_Sal(i,:) = all_trans_REM_long_WAKE_end_C57_Sal{i}; %data_REM_long_WAKE_end_C57_Sal(isnan(data_REM_long_WAKE_end_C57_Sal)==1)=0;
    data_REM_long_SWS_end_C57_Sal(i,:) = all_trans_REM_long_SWS_end_C57_Sal{i}; %data_REM_long_SWS_end_C57_Sal(isnan(data_REM_long_SWS_end_C57_Sal)==1)=0;
    data_REM_long_REM_end_C57_Sal(i,:) = all_trans_REM_long_REM_end_C57_Sal{i}; %data_REM_long_WAKE_end_C57_Sal(isnan(data_REM_short_WAKE_end_C57_Sal)==1)=0;

end






%% GET DATA 
% C57 mCherry cno injection 10h without stress
for k=1:length(Dir_C57_CNO.path)
    cd(Dir_C57_CNO.path{k}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_C57_cno{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_C57_cno{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    same_epoch_C57_cno{k} = intervalSet(0,time_end);
    same_epoch_begin_C57_cno{k} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_C57_cno{k} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_C57_cno{k} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_C57_cno{k}.Wake,same_epoch_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_C57_cno{k}),'wake',tempbin,time_st,time_end);
    dur_WAKE_C57_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_C57_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_C57_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_C57_cno{k}.Wake,same_epoch_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_C57_cno{k}),'sws',tempbin,time_st,time_end);
    dur_SWS_C57_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_C57_cno{k}=num_moyen_ep_SWS;
    perc_SWS_C57_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_C57_cno{k}.Wake,same_epoch_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_C57_cno{k}),'rem',tempbin,time_st,time_end);
    dur_REM_C57_cno{k}=dur_moyenne_ep_REM;
    num_REM_C57_cno{k}=num_moyen_ep_REM;
    perc_REM_C57_cno{k}=perc_moyen_REM;
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_C57_cno{k}.Wake,same_epoch_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_C57_cno{k}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_C57_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_C57_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_C57_cno{k}=perc_moyen_totSleep;
    
    
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_begin_C57_cno{k}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_C57_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_C57_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_begin_C57_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_begin_C57_cno{k}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_C57_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_begin_C57_cno{k}=num_moyen_ep_SWS;
    perc_SWS_begin_C57_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_begin_C57_cno{k}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_C57_cno{k}=dur_moyenne_ep_REM;
    num_REM_begin_C57_cno{k}=num_moyen_ep_REM;
    perc_REM_begin_C57_cno{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_begin_C57_cno{k}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_C57_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_C57_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_begin_C57_cno{k}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_cno{k}.Wake,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_begin_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_begin_C57_cno{k}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_C57_cno{k} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_C57_cno{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_C57_cno{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_C57_cno{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_C57_cno{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_C57_cno{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_C57_cno{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_C57_cno{k} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_interPeriod_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_interPeriod_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_interPeriod_C57_cno{k}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_C57_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_C57_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_C57_cno{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_interPeriod_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_interPeriod_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_interPeriod_C57_cno{k}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_C57_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_C57_cno{k}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_C57_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_interPeriod_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_interPeriod_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_interPeriod_C57_cno{k}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_C57_cno{k}=dur_moyenne_ep_REM;
    num_REM_interPeriod_C57_cno{k}=num_moyen_ep_REM;
    perc_REM_interPeriod_C57_cno{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_interPeriod_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_interPeriod_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_interPeriod_C57_cno{k}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_C57_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_C57_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_C57_cno{k}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_C57_cno{k}=dur_moyenne_ep_WAKE;
    num_WAKE_end_C57_cno{k}=num_moyen_ep_WAKE;
    perc_WAKE_end_C57_cno{k}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_C57_cno{k}=dur_moyenne_ep_SWS;
    num_SWS_end_C57_cno{k}=num_moyen_ep_SWS;
    perc_SWS_end_C57_cno{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_C57_cno{k}=dur_moyenne_ep_REM;
    num_REM_end_C57_cno{k}=num_moyen_ep_REM;
    perc_REM_end_C57_cno{k}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_C57_cno{k}.Wake,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_C57_cno{k}=dur_moyenne_ep_totSleep;
    num_totSleep_end_C57_cno{k}=num_moyen_ep_totSleep;
    perc_totSleep_end_C57_cno{k}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_cno{k}.Wake,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_C57_cno{k} = trans_REM_to_REM;
    all_trans_REM_SWS_end_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_C57_cno{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_C57_cno{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_C57_cno{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_C57_cno{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_C57_cno{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_C57_cno{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_C57_cno{k} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
        [dur_WAKE_C57_cno_bis{k}, durT_WAKE_C57_cno(k)]=DurationEpoch(and(stages_C57_cno{k}.Wake,same_epoch_end_C57_cno{k}),'s');
    [dur_SWS_C57_cno_bis{k}, durT_SWS_C57_cno(k)]=DurationEpoch(and(stages_C57_cno{k}.SWSEpoch,same_epoch_end_C57_cno{k}),'s');
    
    [dur_REM_C57_cno_bis{k}, durT_REM_C57_cno(k)]=DurationEpoch(and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}),'s');
    
    idx_short_rem_C57_cno_1{k} = find(dur_REM_C57_cno_bis{k}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_C57_cno_1{k} = subset(and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}), idx_short_rem_C57_cno_1{k});
    [dur_rem_short_C57_cno_1{k}, durT_rem_short_C57_cno(k)] = DurationEpoch(short_REMEpoch_C57_cno_1{k},'s');
    perc_rem_short_C57_cno_1(k) = durT_rem_short_C57_cno(k) / durT_REM_C57_cno(k) * 100;
    dur_moyenne_rem_short_C57_cno_1(k) = nanmean(dur_rem_short_C57_cno_1{k});
    num_moyen_rem_short_C57_cno_1(k) = length(dur_rem_short_C57_cno_1{k});
    
    idx_short_rem_C57_cno_2{k} = find(dur_REM_C57_cno_bis{k}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_C57_cno_2{k} = subset(and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}), idx_short_rem_C57_cno_2{k});
    [dur_rem_short_C57_cno_2{k}, durT_rem_short_C57_cno(k)] = DurationEpoch(short_REMEpoch_C57_cno_2{k},'s');
    perc_rem_short_C57_cno_2(k) = durT_rem_short_C57_cno(k) / durT_REM_C57_cno(k) * 100;
    dur_moyenne_rem_short_C57_cno_2(k) = nanmean(dur_rem_short_C57_cno_2{k});
    num_moyen_rem_short_C57_cno_2(k) = length(dur_rem_short_C57_cno_2{k});
    
    idx_short_rem_C57_cno_3{k} = find(dur_REM_C57_cno_bis{k}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_C57_cno_3{k} = subset(and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}), idx_short_rem_C57_cno_3{k});
    [dur_rem_short_C57_cno_3{k}, durT_rem_short_C57_cno(k)] = DurationEpoch(short_REMEpoch_C57_cno_3{k},'s');
    perc_rem_short_C57_cno_3(k) = durT_rem_short_C57_cno(k) / durT_REM_C57_cno(k) * 100;
    dur_moyenne_rem_short_C57_cno_3(k) = nanmean(dur_rem_short_C57_cno_3{k});
    num_moyen_rem_short_C57_cno_3(k) = length(dur_rem_short_C57_cno_3{k});
    
    idx_long_rem_C57_cno{k} = find(dur_REM_C57_cno_bis{k}>lim_long_rem); %long bout
    long_REMEpoch_C57_cno{k} = subset(and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}), idx_long_rem_C57_cno{k});
    [dur_rem_long_C57_cno{k}, durT_rem_long_C57_cno(k)] = DurationEpoch(long_REMEpoch_C57_cno{k},'s');
    perc_rem_long_C57_cno(k) = durT_rem_long_C57_cno(k) / durT_REM_C57_cno(k) * 100;
    dur_moyenne_rem_long_C57_cno(k) = nanmean(dur_rem_long_C57_cno{k});
    num_moyen_rem_long_C57_cno(k) = length(dur_rem_long_C57_cno{k});
    
    idx_mid_rem_C57_cno{k} = find(dur_REM_C57_cno_bis{k}>lim_short_rem_1 & dur_REM_C57_cno_bis{k}<lim_long_rem); % middle bouts
    mid_REMEpoch_C57_cno{k} = subset(and(stages_C57_cno{k}.REMEpoch,same_epoch_end_C57_cno{k}), idx_mid_rem_C57_cno{k});
    [dur_rem_mid_C57_cno{k}, durT_rem_mid_C57_cno(k)] = DurationEpoch(mid_REMEpoch_C57_cno{k},'s');
    perc_rem_mid_C57_cno(k) = durT_rem_mid_C57_cno(k) / durT_REM_C57_cno(k) * 100;
    dur_moyenne_rem_mid_C57_cno(k) = nanmean(dur_rem_mid_C57_cno{k});
    num_moyen_rem_mid_C57_cno(k) = length(dur_rem_mid_C57_cno{k});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_cno{k}.Wake,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_end_C57_cno{k}),and(short_REMEpoch_C57_cno_1{k},same_epoch_end_C57_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_C57_cno{k} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_C57_cno{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_cno{k}.Wake,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_end_C57_cno{k}),and(mid_REMEpoch_C57_cno{k},same_epoch_end_C57_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_C57_cno{k} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_C57_cno{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_C57_cno{k}.Wake,same_epoch_end_C57_cno{k}),and(stages_C57_cno{k}.SWSEpoch,same_epoch_end_C57_cno{k}),and(long_REMEpoch_C57_cno{k},same_epoch_end_C57_cno{k}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_C57_cno{k} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_C57_cno{k} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_C57_cno{k} = trans_REM_to_REM;
    
        st_sws_C57_cno{k} = Start(stages_C57_cno{k}.SWSEpoch);
    idx_sws_C57_cno{k} = find(mindurSWS<dur_SWS_C57_cno_bis{k},1,'first');
    latency_sws_C57_cno(k) =  st_sws_C57_cno{k}(idx_sws_C57_cno{k});
    
    
    st_rem_C57_cno{k} = Start(stages_C57_cno{k}.REMEpoch);
    idx_rem_C57_cno{k} = find(mindurREM<dur_REM_C57_cno_bis{k},1,'first');
    latency_rem_C57_cno(k) =  st_rem_C57_cno{k}(idx_rem_C57_cno{k});
    
end

%% compute average - C57 mCherry saline injection 10h without stress
%%percentage/duration/number
for k=1:length(dur_REM_C57_cno)
    %%ALL SESSION
    data_dur_REM_C57_cno(k,:) = dur_REM_C57_cno{k}; data_dur_REM_C57_cno(isnan(data_dur_REM_C57_cno)==1)=0;
    data_dur_SWS_C57_cno(k,:) = dur_SWS_C57_cno{k}; data_dur_SWS_C57_cno(isnan(data_dur_SWS_C57_cno)==1)=0;
    data_dur_WAKE_C57_cno(k,:) = dur_WAKE_C57_cno{k}; data_dur_WAKE_C57_cno(isnan(data_dur_WAKE_C57_cno)==1)=0;
    data_dur_totSleep_C57_cno(k,:) = dur_totSleep_C57_cno{k}; data_dur_totSleep_C57_cno(isnan(data_dur_totSleep_C57_cno)==1)=0;
    
    data_num_REM_C57_cno(k,:) = num_REM_C57_cno{k};data_num_REM_C57_cno(isnan(data_num_REM_C57_cno)==1)=0;
    data_num_SWS_C57_cno(k,:) = num_SWS_C57_cno{k}; data_num_SWS_C57_cno(isnan(data_num_SWS_C57_cno)==1)=0;
    data_num_WAKE_C57_cno(k,:) = num_WAKE_C57_cno{k}; data_num_WAKE_C57_cno(isnan(data_num_WAKE_C57_cno)==1)=0;
    data_num_totSleep_C57_cno(k,:) = num_totSleep_C57_cno{k}; data_num_totSleep_C57_cno(isnan(data_num_totSleep_C57_cno)==1)=0;
    
    data_perc_REM_C57_cno(k,:) = perc_REM_C57_cno{k}; data_perc_REM_C57_cno(isnan(data_perc_REM_C57_cno)==1)=0;
    data_perc_SWS_C57_cno(k,:) = perc_SWS_C57_cno{k}; data_perc_SWS_C57_cno(isnan(data_perc_SWS_C57_cno)==1)=0;
    data_perc_WAKE_C57_cno(k,:) = perc_WAKE_C57_cno{k}; data_perc_WAKE_C57_cno(isnan(data_perc_WAKE_C57_cno)==1)=0;
    data_perc_totSleep_C57_cno(k,:) = perc_totSleep_C57_cno{k}; data_perc_totSleep_C57_cno(isnan(data_perc_totSleep_C57_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_C57_cno(k,:) = dur_REM_begin_C57_cno{k}; data_dur_REM_begin_C57_cno(isnan(data_dur_REM_begin_C57_cno)==1)=0;
    data_dur_SWS_begin_C57_cno(k,:) = dur_SWS_begin_C57_cno{k}; data_dur_SWS_begin_C57_cno(isnan(data_dur_SWS_begin_C57_cno)==1)=0;
    data_dur_WAKE_begin_C57_cno(k,:) = dur_WAKE_begin_C57_cno{k}; data_dur_WAKE_begin_C57_cno(isnan(data_dur_WAKE_begin_C57_cno)==1)=0;
    data_dur_totSleep_begin_C57_cno(k,:) = dur_totSleep_begin_C57_cno{k}; data_dur_totSleep_begin_C57_cno(isnan(data_dur_totSleep_begin_C57_cno)==1)=0;
    
    
    data_num_REM_begin_C57_cno(k,:) = num_REM_begin_C57_cno{k};data_num_REM_begin_C57_cno(isnan(data_num_REM_begin_C57_cno)==1)=0;
    data_num_SWS_begin_C57_cno(k,:) = num_SWS_begin_C57_cno{k}; data_num_SWS_begin_C57_cno(isnan(data_num_SWS_begin_C57_cno)==1)=0;
    data_num_WAKE_begin_C57_cno(k,:) = num_WAKE_begin_C57_cno{k}; data_num_WAKE_begin_C57_cno(isnan(data_num_WAKE_begin_C57_cno)==1)=0;
    data_num_totSleep_begin_C57_cno(k,:) = num_totSleep_begin_C57_cno{k}; data_num_totSleep_begin_C57_cno(isnan(data_num_totSleep_begin_C57_cno)==1)=0;
    
    data_perc_REM_begin_C57_cno(k,:) = perc_REM_begin_C57_cno{k}; data_perc_REM_begin_C57_cno(isnan(data_perc_REM_begin_C57_cno)==1)=0;
    data_perc_SWS_begin_C57_cno(k,:) = perc_SWS_begin_C57_cno{k}; data_perc_SWS_begin_C57_cno(isnan(data_perc_SWS_begin_C57_cno)==1)=0;
    data_perc_WAKE_begin_C57_cno(k,:) = perc_WAKE_begin_C57_cno{k}; data_perc_WAKE_begin_C57_cno(isnan(data_perc_WAKE_begin_C57_cno)==1)=0;
    data_perc_totSleep_begin_C57_cno(k,:) = perc_totSleep_begin_C57_cno{k}; data_perc_totSleep_begin_C57_cno(isnan(data_perc_totSleep_begin_C57_cno)==1)=0;
    
    data_dur_REM_interPeriod_C57_cno(k,:) = dur_REM_interPeriod_C57_cno{k}; data_dur_REM_interPeriod_C57_cno(isnan(data_dur_REM_interPeriod_C57_cno)==1)=0;
    data_dur_SWS_interPeriod_C57_cno(k,:) = dur_SWS_interPeriod_C57_cno{k}; data_dur_SWS_interPeriod_C57_cno(isnan(data_dur_SWS_interPeriod_C57_cno)==1)=0;
    data_dur_WAKE_interPeriod_C57_cno(k,:) = dur_WAKE_interPeriod_C57_cno{k}; data_dur_WAKE_interPeriod_C57_cno(isnan(data_dur_WAKE_interPeriod_C57_cno)==1)=0;
    data_dur_totSleep_interPeriod_C57_cno(k,:) = dur_totSleep_interPeriod_C57_cno{k}; data_dur_totSleep_interPeriod_C57_cno(isnan(data_dur_totSleep_interPeriod_C57_cno)==1)=0;
    
    
    data_num_REM_interPeriod_C57_cno(k,:) = num_REM_interPeriod_C57_cno{k};data_num_REM_interPeriod_C57_cno(isnan(data_num_REM_interPeriod_C57_cno)==1)=0;
    data_num_SWS_interPeriod_C57_cno(k,:) = num_SWS_interPeriod_C57_cno{k}; data_num_SWS_interPeriod_C57_cno(isnan(data_num_SWS_interPeriod_C57_cno)==1)=0;
    data_num_WAKE_interPeriod_C57_cno(k,:) = num_WAKE_interPeriod_C57_cno{k}; data_num_WAKE_interPeriod_C57_cno(isnan(data_num_WAKE_interPeriod_C57_cno)==1)=0;
    data_num_totSleep_interPeriod_C57_cno(k,:) = num_totSleep_interPeriod_C57_cno{k}; data_num_totSleep_interPeriod_C57_cno(isnan(data_num_totSleep_interPeriod_C57_cno)==1)=0;
    
    data_perc_REM_interPeriod_C57_cno(k,:) = perc_REM_interPeriod_C57_cno{k}; data_perc_REM_interPeriod_C57_cno(isnan(data_perc_REM_interPeriod_C57_cno)==1)=0;
    data_perc_SWS_interPeriod_C57_cno(k,:) = perc_SWS_interPeriod_C57_cno{k}; data_perc_SWS_interPeriod_C57_cno(isnan(data_perc_SWS_interPeriod_C57_cno)==1)=0;
    data_perc_WAKE_interPeriod_C57_cno(k,:) = perc_WAKE_interPeriod_C57_cno{k}; data_perc_WAKE_interPeriod_C57_cno(isnan(data_perc_WAKE_interPeriod_C57_cno)==1)=0;
    data_perc_totSleep_interPeriod_C57_cno(k,:) = perc_totSleep_interPeriod_C57_cno{k}; data_perc_totSleep_interPeriod_C57_cno(isnan(data_perc_totSleep_interPeriod_C57_cno)==1)=0;
    
    %%FIN DE LA SESSION
    data_dur_REM_end_C57_cno(k,:) = dur_REM_end_C57_cno{k}; data_dur_REM_end_C57_cno(isnan(data_dur_REM_end_C57_cno)==1)=0;
    data_dur_SWS_end_C57_cno(k,:) = dur_SWS_end_C57_cno{k}; data_dur_SWS_end_C57_cno(isnan(data_dur_SWS_end_C57_cno)==1)=0;
    data_dur_WAKE_end_C57_cno(k,:) = dur_WAKE_end_C57_cno{k}; data_dur_WAKE_end_C57_cno(isnan(data_dur_WAKE_end_C57_cno)==1)=0;
    data_dur_totSleep_end_C57_cno(k,:) = dur_totSleep_end_C57_cno{k}; data_dur_totSleep_end_C57_cno(isnan(data_dur_totSleep_end_C57_cno)==1)=0;
    
    
    data_num_REM_end_C57_cno(k,:) = num_REM_end_C57_cno{k};data_num_REM_end_C57_cno(isnan(data_num_REM_end_C57_cno)==1)=0;
    data_num_SWS_end_C57_cno(k,:) = num_SWS_end_C57_cno{k}; data_num_SWS_end_C57_cno(isnan(data_num_SWS_end_C57_cno)==1)=0;
    data_num_WAKE_end_C57_cno(k,:) = num_WAKE_end_C57_cno{k}; data_num_WAKE_end_C57_cno(isnan(data_num_WAKE_end_C57_cno)==1)=0;
    data_num_totSleep_end_C57_cno(k,:) = num_totSleep_end_C57_cno{k}; data_num_totSleep_end_C57_cno(isnan(data_num_totSleep_end_C57_cno)==1)=0;
    
    
    data_perc_REM_end_C57_cno(k,:) = perc_REM_end_C57_cno{k}; data_perc_REM_end_C57_cno(isnan(data_perc_REM_end_C57_cno)==1)=0;
    data_perc_SWS_end_C57_cno(k,:) = perc_SWS_end_C57_cno{k}; data_perc_SWS_end_C57_cno(isnan(data_perc_SWS_end_C57_cno)==1)=0;
    data_perc_WAKE_end_C57_cno(k,:) = perc_WAKE_end_C57_cno{k}; data_perc_WAKE_end_C57_cno(isnan(data_perc_WAKE_end_C57_cno)==1)=0;
    data_perc_totSleep_end_C57_cno(k,:) = perc_totSleep_end_C57_cno{k}; data_perc_totSleep_end_C57_cno(isnan(data_perc_totSleep_end_C57_cno)==1)=0;
    
end
%%
%probability
for k=1:length(all_trans_REM_short_WAKE_end_C57_cno)
    %     %%ALL SESSION
    %     data_REM_REM_C57_cno(k,:) = all_trans_REM_REM_C57_cno{k}; data_REM_REM_C57_cno(isnan(data_REM_REM_C57_cno)==1)=0;
    %     data_REM_SWS_C57_cno(k,:) = all_trans_REM_SWS_C57_cno{k}; data_REM_SWS_C57_cno(isnan(data_REM_SWS_C57_cno)==1)=0;
    %     data_REM_WAKE_C57_cno(k,:) = all_trans_REM_WAKE_C57_cno{k}; data_REM_WAKE_C57_cno(isnan(data_REM_WAKE_C57_cno)==1)=0;
    %
    %     data_SWS_SWS_C57_cno(k,:) = all_trans_SWS_SWS_C57_cno{k}; data_SWS_SWS_C57_cno(isnan(data_SWS_SWS_C57_cno)==1)=0;
    %     data_SWS_REM_C57_cno(k,:) = all_trans_SWS_REM_C57_cno{k}; data_SWS_REM_C57_cno(isnan(data_SWS_REM_C57_cno)==1)=0;
    %     data_SWS_WAKE_C57_cno(k,:) = all_trans_SWS_WAKE_C57_cno{k}; data_SWS_WAKE_C57_cno(isnan(data_SWS_WAKE_C57_cno)==1)=0;
    %
    %     data_WAKE_WAKE_C57_cno(k,:) = all_trans_WAKE_WAKE_C57_cno{k}; data_WAKE_WAKE_C57_cno(isnan(data_WAKE_WAKE_C57_cno)==1)=0;
    %     data_WAKE_REM_C57_cno(k,:) = all_trans_WAKE_REM_C57_cno{k}; data_WAKE_REM_C57_cno(isnan(data_WAKE_REM_C57_cno)==1)=0;
    %     data_WAKE_SWS_C57_cno(k,:) = all_trans_WAKE_SWS_C57_cno{k}; data_WAKE_SWS_C57_cno(isnan(data_WAKE_SWS_C57_cno)==1)=0;
    %
    %     %%3 PREMI7RES HEURES
    %         data_REM_REM_begin_C57_cno(k,:) = all_trans_REM_REM_begin_C57_cno{k}; data_REM_REM_begin_C57_cno(isnan(data_REM_REM_begin_C57_cno)==1)=0;
    %     data_REM_SWS_begin_C57_cno(k,:) = all_trans_REM_SWS_begin_C57_cno{k}; data_REM_SWS_begin_C57_cno(isnan(data_REM_SWS_begin_C57_cno)==1)=0;
    %     data_REM_WAKE_begin_C57_cno(k,:) = all_trans_REM_WAKE_begin_C57_cno{k}; data_REM_WAKE_begin_C57_cno(isnan(data_REM_WAKE_begin_C57_cno)==1)=0;
    %
    %     data_SWS_SWS_begin_C57_cno(k,:) = all_trans_SWS_SWS_begin_C57_cno{k}; data_SWS_SWS_begin_C57_cno(isnan(data_SWS_SWS_begin_C57_cno)==1)=0;
    %     data_SWS_REM_begin_C57_cno(k,:) = all_trans_SWS_REM_begin_C57_cno{k}; data_SWS_REM_begin_C57_cno(isnan(data_SWS_REM_begin_C57_cno)==1)=0;
    %     data_SWS_WAKE_begin_C57_cno(k,:) = all_trans_SWS_WAKE_begin_C57_cno{k}; data_SWS_WAKE_begin_C57_cno(isnan(data_SWS_WAKE_begin_C57_cno)==1)=0;
    %
    %     data_WAKE_WAKE_begin_C57_cno(k,:) = all_trans_WAKE_WAKE_begin_C57_cno{k}; data_WAKE_WAKE_begin_C57_cno(isnan(data_WAKE_WAKE_begin_C57_cno)==1)=0;
    %     data_WAKE_REM_begin_C57_cno(k,:) = all_trans_WAKE_REM_begin_C57_cno{k}; data_WAKE_REM_begin_C57_cno(isnan(data_WAKE_REM_begin_C57_cno)==1)=0;
    %     data_WAKE_SWS_begin_C57_cno(k,:) = all_trans_WAKE_SWS_begin_C57_cno{k}; data_WAKE_SWS_begin_C57_cno(isnan(data_WAKE_SWS_begin_C57_cno)==1)=0;
    %
    %     %%FIN DE LA SESSION
    %         data_REM_REM_end_C57_cno(k,:) = all_trans_REM_REM_end_C57_cno{k}; data_REM_REM_end_C57_cno(isnan(data_REM_REM_end_C57_cno)==1)=0;
    %     data_REM_SWS_end_C57_cno(k,:) = all_trans_REM_SWS_end_C57_cno{k}; data_REM_SWS_end_C57_cno(isnan(data_REM_SWS_end_C57_cno)==1)=0;
    %     data_REM_WAKE_end_C57_cno(k,:) = all_trans_REM_WAKE_end_C57_cno{k}; data_REM_WAKE_end_C57_cno(isnan(data_REM_WAKE_end_C57_cno)==1)=0;
    %
    %     data_SWS_SWS_end_C57_cno(k,:) = all_trans_SWS_SWS_end_C57_cno{k}; data_SWS_SWS_end_C57_cno(isnan(data_SWS_SWS_end_C57_cno)==1)=0;
    %     data_SWS_REM_end_C57_cno(k,:) = all_trans_SWS_REM_end_C57_cno{k}; data_SWS_REM_end_C57_cno(isnan(data_SWS_REM_end_C57_cno)==1)=0;
    %     data_SWS_WAKE_end_C57_cno(k,:) = all_trans_SWS_WAKE_end_C57_cno{k}; data_SWS_WAKE_end_C57_cno(isnan(data_SWS_WAKE_end_C57_cno)==1)=0;
    %
    %     data_WAKE_WAKE_end_C57_cno(k,:) = all_trans_WAKE_WAKE_end_C57_cno{k}; data_WAKE_WAKE_end_C57_cno(isnan(data_WAKE_WAKE_end_C57_cno)==1)=0;
    %     data_WAKE_REM_end_C57_cno(k,:) = all_trans_WAKE_REM_end_C57_cno{k}; data_WAKE_REM_end_C57_cno(isnan(data_WAKE_REM_end_C57_cno)==1)=0;
    %     data_WAKE_SWS_end_C57_cno(k,:) = all_trans_WAKE_SWS_end_C57_cno{k}; data_WAKE_SWS_end_C57_cno(isnan(data_WAKE_SWS_end_C57_cno)==1)=0;
    %
    data_REM_short_WAKE_end_C57_cno(k,:) = all_trans_REM_short_WAKE_end_C57_cno{k}; data_REM_short_WAKE_end_C57_cno(isnan(data_REM_short_WAKE_end_C57_cno)==1)=0;
    data_REM_short_SWS_end_C57_cno(k,:) = all_trans_REM_short_SWS_end_C57_cno{k}; data_REM_short_SWS_end_C57_cno(isnan(data_REM_short_SWS_end_C57_cno)==1)=0;
    
    data_REM_mid_WAKE_end_C57_cno(k,:) = all_trans_REM_mid_WAKE_end_C57_cno{k}; data_REM_mid_WAKE_end_C57_cno(isnan(data_REM_mid_WAKE_end_C57_cno)==1)=0;
    data_REM_mid_SWS_end_C57_cno(k,:) = all_trans_REM_mid_SWS_end_C57_cno{k}; data_REM_mid_SWS_end_C57_cno(isnan(data_REM_mid_SWS_end_C57_cno)==1)=0;
    
    data_REM_long_WAKE_end_C57_cno(k,:) = all_trans_REM_long_WAKE_end_C57_cno{k}; data_REM_long_WAKE_end_C57_cno(isnan(data_REM_long_WAKE_end_C57_cno)==1)=0;
    data_REM_long_SWS_end_C57_cno(k,:) = all_trans_REM_long_SWS_end_C57_cno{k}; data_REM_long_SWS_end_C57_cno(isnan(data_REM_long_SWS_end_C57_cno)==1)=0;
    
    data_REM_short_REM_end_C57_cno(k,:) = all_trans_REM_short_REM_end_C57_cno{k}; %data_REM_short_REM_end_C57_cno(isnan(data_REM_short_REM_end_C57_cno)==1)=0;
    data_REM_mid_REM_end_C57_cno(k,:) = all_trans_REM_mid_REM_end_C57_cno{k}; %data_REM_mid_REM_end_C57_cno(isnan(data_REM_mid_REM_end_C57_cno)==1)=0;
    data_REM_long_REM_end_C57_cno(k,:) = all_trans_REM_long_REM_end_C57_cno{k}; %data_REM_long_REM_end_C57_cno(isnan(data_REM_long_REM_end_C57_cno)==1)=0;
    
end



%% GET DATA
% CRH mCherry saline injection 10h without stress

for j=1:length(Dir_CRH_Sal.path)
    cd(Dir_CRH_Sal.path{j}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_CRH_Sal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_CRH_Sal{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_CRH_Sal{j} = intervalSet(0,time_end);
    same_epoch_begin_CRH_Sal{j} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_CRH_Sal{j} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_CRH_Sal{j} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_CRH_Sal{j}),'wake',tempbin,time_st,time_end);
    dur_WAKE_CRH_Sal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_CRH_Sal{j}=num_moyen_ep_WAKE;
    perc_WAKE_CRH_Sal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_CRH_Sal{j}),'sws',tempbin,time_st,time_end);
    dur_SWS_CRH_Sal{j}=dur_moyenne_ep_SWS;
    num_SWS_CRH_Sal{j}=num_moyen_ep_SWS;
    perc_SWS_CRH_Sal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_CRH_Sal{j}),'rem',tempbin,time_st,time_end);
    dur_REM_CRH_Sal{j}=dur_moyenne_ep_REM;
    num_REM_CRH_Sal{j}=num_moyen_ep_REM;
    perc_REM_CRH_Sal{j}=perc_moyen_REM;
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_CRH_Sal{j}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_CRH_Sal{j}=dur_moyenne_ep_totSleep;
    num_totSleep_CRH_Sal{j}=num_moyen_ep_totSleep;
    perc_totSleep_CRH_Sal{j}=perc_moyen_totSleep;
    
    
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_CRH_Sal{j}.Wake,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_CRH_Sal{j}),tempbin,time_end);
    all_trans_REM_REM_CRH_Sal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_CRH_Sal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_CRH_Sal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_CRH_Sal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_CRH_Sal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_CRH_Sal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_CRH_Sal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_CRH_Sal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_CRH_Sal{j} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_begin_CRH_Sal{j}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_CRH_Sal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_CRH_Sal{j}=num_moyen_ep_WAKE;
    perc_WAKE_begin_CRH_Sal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_begin_CRH_Sal{j}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_CRH_Sal{j}=dur_moyenne_ep_SWS;
    num_SWS_begin_CRH_Sal{j}=num_moyen_ep_SWS;
    perc_SWS_begin_CRH_Sal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_begin_CRH_Sal{j}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_CRH_Sal{j}=dur_moyenne_ep_REM;
    num_REM_begin_CRH_Sal{j}=num_moyen_ep_REM;
    perc_REM_begin_CRH_Sal{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_begin_CRH_Sal{j}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_CRH_Sal{j}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_CRH_Sal{j}=num_moyen_ep_totSleep;
    perc_totSleep_begin_CRH_Sal{j}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_Sal{j}.Wake,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_begin_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_begin_CRH_Sal{j}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_CRH_Sal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_CRH_Sal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_CRH_Sal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_CRH_Sal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_CRH_Sal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_CRH_Sal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_CRH_Sal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_CRH_Sal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_CRH_Sal{j} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_interPeriod_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_interPeriod_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_interPeriod_CRH_Sal{j}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_CRH_Sal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_CRH_Sal{j}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_CRH_Sal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_interPeriod_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_interPeriod_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_interPeriod_CRH_Sal{j}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_CRH_Sal{j}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_CRH_Sal{j}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_CRH_Sal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_interPeriod_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_interPeriod_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_interPeriod_CRH_Sal{j}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_CRH_Sal{j}=dur_moyenne_ep_REM;
    num_REM_interPeriod_CRH_Sal{j}=num_moyen_ep_REM;
    perc_REM_interPeriod_CRH_Sal{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_interPeriod_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_interPeriod_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_interPeriod_CRH_Sal{j}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_CRH_Sal{j}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_CRH_Sal{j}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_CRH_Sal{j}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_CRH_Sal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_end_CRH_Sal{j}=num_moyen_ep_WAKE;
    perc_WAKE_end_CRH_Sal{j}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_CRH_Sal{j}=dur_moyenne_ep_SWS;
    num_SWS_end_CRH_Sal{j}=num_moyen_ep_SWS;
    perc_SWS_end_CRH_Sal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_CRH_Sal{j}=dur_moyenne_ep_REM;
    num_REM_end_CRH_Sal{j}=num_moyen_ep_REM;
    perc_REM_end_CRH_Sal{j}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_Sal{j}.Wake,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_CRH_Sal{j}=dur_moyenne_ep_totSleep;
    num_totSleep_end_CRH_Sal{j}=num_moyen_ep_totSleep;
    perc_totSleep_end_CRH_Sal{j}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_Sal{j}.Wake,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_CRH_Sal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_end_CRH_Sal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_CRH_Sal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_CRH_Sal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_CRH_Sal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_CRH_Sal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_CRH_Sal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_CRH_Sal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_CRH_Sal{j} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_WAKE_CRH_Sal_bis{j}, durT_WAKE_CRH_Sal(j)]=DurationEpoch(and(stages_CRH_Sal{j}.Wake,same_epoch_end_CRH_Sal{j}),'s');
    [dur_SWS_CRH_Sal_bis{j}, durT_SWS_CRH_Sal(j)]=DurationEpoch(and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_end_CRH_Sal{j}),'s');
    
    
    [dur_REM_CRH_Sal_bis{j}, durT_REM_CRH_Sal(j)]=DurationEpoch(and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}),'s');
    
    idx_short_rem_CRH_Sal_1{j} = find(dur_REM_CRH_Sal_bis{j}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_CRH_Sal_1{j} = subset(and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}), idx_short_rem_CRH_Sal_1{j});
    [dur_rem_short_CRH_Sal_1{j}, durT_rem_short_CRH_Sal(j)] = DurationEpoch(short_REMEpoch_CRH_Sal_1{j},'s');
    perc_rem_short_CRH_Sal_1(j) = durT_rem_short_CRH_Sal(j) / durT_REM_CRH_Sal(j) * 100;
    dur_moyenne_rem_short_CRH_Sal_1(j) = nanmean(dur_rem_short_CRH_Sal_1{j});
    num_moyen_rem_short_CRH_Sal_1(j) = length(dur_rem_short_CRH_Sal_1{j});
    
    idx_short_rem_CRH_Sal_2{j} = find(dur_REM_CRH_Sal_bis{j}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_CRH_Sal_2{j} = subset(and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}), idx_short_rem_CRH_Sal_2{j});
    [dur_rem_short_CRH_Sal_2{j}, durT_rem_short_CRH_Sal(j)] = DurationEpoch(short_REMEpoch_CRH_Sal_2{j},'s');
    perc_rem_short_CRH_Sal_2(j) = durT_rem_short_CRH_Sal(j) / durT_REM_CRH_Sal(j) * 100;
    dur_moyenne_rem_short_CRH_Sal_2(j) = nanmean(dur_rem_short_CRH_Sal_2{j});
    num_moyen_rem_short_CRH_Sal_2(j) = length(dur_rem_short_CRH_Sal_2{j});
    
    idx_short_rem_CRH_Sal_3{j} = find(dur_REM_CRH_Sal_bis{j}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_CRH_Sal_3{j} = subset(and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}), idx_short_rem_CRH_Sal_3{j});
    [dur_rem_short_CRH_Sal_3{j}, durT_rem_short_CRH_Sal(j)] = DurationEpoch(short_REMEpoch_CRH_Sal_3{j},'s');
    perc_rem_short_CRH_Sal_3(j) = durT_rem_short_CRH_Sal(j) / durT_REM_CRH_Sal(j) * 100;
    dur_moyenne_rem_short_CRH_Sal_3(j) = nanmean(dur_rem_short_CRH_Sal_3{j});
    num_moyen_rem_short_CRH_Sal_3(j) = length(dur_rem_short_CRH_Sal_3{j});
    
    idx_long_rem_CRH_Sal{j} = find(dur_REM_CRH_Sal_bis{j}>lim_long_rem); %long bout
    long_REMEpoch_CRH_Sal{j} = subset(and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}), idx_long_rem_CRH_Sal{j});
    [dur_rem_long_CRH_Sal{j}, durT_rem_long_CRH_Sal(j)] = DurationEpoch(long_REMEpoch_CRH_Sal{j},'s');
    perc_rem_long_CRH_Sal(j) = durT_rem_long_CRH_Sal(j) / durT_REM_CRH_Sal(j) * 100;
    dur_moyenne_rem_long_CRH_Sal(j) = nanmean(dur_rem_long_CRH_Sal{j});
    num_moyen_rem_long_CRH_Sal(j) = length(dur_rem_long_CRH_Sal{j});
    
    idx_mid_rem_CRH_Sal{j} = find(dur_REM_CRH_Sal_bis{j}>lim_short_rem_1 & dur_REM_CRH_Sal_bis{j}<lim_long_rem); % middle bouts
    mid_REMEpoch_CRH_Sal{j} = subset(and(stages_CRH_Sal{j}.REMEpoch,same_epoch_end_CRH_Sal{j}), idx_mid_rem_CRH_Sal{j});
    [dur_rem_mid_CRH_Sal{j}, durT_rem_mid_CRH_Sal(j)] = DurationEpoch(mid_REMEpoch_CRH_Sal{j},'s');
    perc_rem_mid_CRH_Sal(j) = durT_rem_mid_CRH_Sal(j) / durT_REM_CRH_Sal(j) * 100;
    dur_moyenne_rem_mid_CRH_Sal(j) = nanmean(dur_rem_mid_CRH_Sal{j});
    num_moyen_rem_mid_CRH_Sal(j) = length(dur_rem_mid_CRH_Sal{j});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_Sal{j}.Wake,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_end_CRH_Sal{j}),and(short_REMEpoch_CRH_Sal_1{j},same_epoch_end_CRH_Sal{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_CRH_Sal{j} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_CRH_Sal{j} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_CRH_Sal{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_Sal{j}.Wake,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_end_CRH_Sal{j}),and(mid_REMEpoch_CRH_Sal{j},same_epoch_end_CRH_Sal{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_CRH_Sal{j} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_CRH_Sal{j} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_CRH_Sal{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_Sal{j}.Wake,same_epoch_end_CRH_Sal{j}),and(stages_CRH_Sal{j}.SWSEpoch,same_epoch_end_CRH_Sal{j}),and(long_REMEpoch_CRH_Sal{j},same_epoch_end_CRH_Sal{j}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_CRH_Sal{j} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_CRH_Sal{j} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_CRH_Sal{j} = trans_REM_to_REM;
    
end

%% compute average - CRH mCherry saline injection 10h without stress
%%percentage/duration/number
for j=1:length(dur_REM_CRH_Sal)
    %%ALL SESSION
    data_dur_REM_CRH_Sal(j,:) = dur_REM_CRH_Sal{j}; data_dur_REM_CRH_Sal(isnan(data_dur_REM_CRH_Sal)==1)=0;
    data_dur_SWS_CRH_Sal(j,:) = dur_SWS_CRH_Sal{j}; data_dur_SWS_CRH_Sal(isnan(data_dur_SWS_CRH_Sal)==1)=0;
    data_dur_WAKE_CRH_Sal(j,:) = dur_WAKE_CRH_Sal{j}; data_dur_WAKE_CRH_Sal(isnan(data_dur_WAKE_CRH_Sal)==1)=0;
    data_dur_totSleep_CRH_Sal(j,:) = dur_totSleep_CRH_Sal{j}; data_dur_totSleep_CRH_Sal(isnan(data_dur_totSleep_CRH_Sal)==1)=0;
    
    data_num_REM_CRH_Sal(j,:) = num_REM_CRH_Sal{j};data_num_REM_CRH_Sal(isnan(data_num_REM_CRH_Sal)==1)=0;
    data_num_SWS_CRH_Sal(j,:) = num_SWS_CRH_Sal{j}; data_num_SWS_CRH_Sal(isnan(data_num_SWS_CRH_Sal)==1)=0;
    data_num_WAKE_CRH_Sal(j,:) = num_WAKE_CRH_Sal{j}; data_num_WAKE_CRH_Sal(isnan(data_num_WAKE_CRH_Sal)==1)=0;
    data_num_totSleep_CRH_Sal(j,:) = num_totSleep_CRH_Sal{j}; data_num_totSleep_CRH_Sal(isnan(data_num_totSleep_CRH_Sal)==1)=0;
    
    data_perc_REM_CRH_Sal(j,:) = perc_REM_CRH_Sal{j}; data_perc_REM_CRH_Sal(isnan(data_perc_REM_CRH_Sal)==1)=0;
    data_perc_SWS_CRH_Sal(j,:) = perc_SWS_CRH_Sal{j}; data_perc_SWS_CRH_Sal(isnan(data_perc_SWS_CRH_Sal)==1)=0;
    data_perc_WAKE_CRH_Sal(j,:) = perc_WAKE_CRH_Sal{j}; data_perc_WAKE_CRH_Sal(isnan(data_perc_WAKE_CRH_Sal)==1)=0;
    data_perc_totSleep_CRH_Sal(j,:) = perc_totSleep_CRH_Sal{j}; data_perc_totSleep_CRH_Sal(isnan(data_perc_totSleep_CRH_Sal)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_CRH_Sal(j,:) = dur_REM_begin_CRH_Sal{j}; data_dur_REM_begin_CRH_Sal(isnan(data_dur_REM_begin_CRH_Sal)==1)=0;
    data_dur_SWS_begin_CRH_Sal(j,:) = dur_SWS_begin_CRH_Sal{j}; data_dur_SWS_begin_CRH_Sal(isnan(data_dur_SWS_begin_CRH_Sal)==1)=0;
    data_dur_WAKE_begin_CRH_Sal(j,:) = dur_WAKE_begin_CRH_Sal{j}; data_dur_WAKE_begin_CRH_Sal(isnan(data_dur_WAKE_begin_CRH_Sal)==1)=0;
    data_dur_totSleep_begin_CRH_Sal(j,:) = dur_totSleep_begin_CRH_Sal{j}; data_dur_totSleep_begin_CRH_Sal(isnan(data_dur_totSleep_begin_CRH_Sal)==1)=0;
    
    
    data_num_REM_begin_CRH_Sal(j,:) = num_REM_begin_CRH_Sal{j};data_num_REM_begin_CRH_Sal(isnan(data_num_REM_begin_CRH_Sal)==1)=0;
    data_num_SWS_begin_CRH_Sal(j,:) = num_SWS_begin_CRH_Sal{j}; data_num_SWS_begin_CRH_Sal(isnan(data_num_SWS_begin_CRH_Sal)==1)=0;
    data_num_WAKE_begin_CRH_Sal(j,:) = num_WAKE_begin_CRH_Sal{j}; data_num_WAKE_begin_CRH_Sal(isnan(data_num_WAKE_begin_CRH_Sal)==1)=0;
    data_num_totSleep_begin_CRH_Sal(j,:) = num_totSleep_begin_CRH_Sal{j}; data_num_totSleep_begin_CRH_Sal(isnan(data_num_totSleep_begin_CRH_Sal)==1)=0;
    
    data_perc_REM_begin_CRH_Sal(j,:) = perc_REM_begin_CRH_Sal{j}; data_perc_REM_begin_CRH_Sal(isnan(data_perc_REM_begin_CRH_Sal)==1)=0;
    data_perc_SWS_begin_CRH_Sal(j,:) = perc_SWS_begin_CRH_Sal{j}; data_perc_SWS_begin_CRH_Sal(isnan(data_perc_SWS_begin_CRH_Sal)==1)=0;
    data_perc_WAKE_begin_CRH_Sal(j,:) = perc_WAKE_begin_CRH_Sal{j}; data_perc_WAKE_begin_CRH_Sal(isnan(data_perc_WAKE_begin_CRH_Sal)==1)=0;
    data_perc_totSleep_begin_CRH_Sal(j,:) = perc_totSleep_begin_CRH_Sal{j}; data_perc_totSleep_begin_CRH_Sal(isnan(data_perc_totSleep_begin_CRH_Sal)==1)=0;
    
    data_dur_REM_interPeriod_CRH_Sal(j,:) = dur_REM_interPeriod_CRH_Sal{j}; data_dur_REM_interPeriod_CRH_Sal(isnan(data_dur_REM_interPeriod_CRH_Sal)==1)=0;
    data_dur_SWS_interPeriod_CRH_Sal(j,:) = dur_SWS_interPeriod_CRH_Sal{j}; data_dur_SWS_interPeriod_CRH_Sal(isnan(data_dur_SWS_interPeriod_CRH_Sal)==1)=0;
    data_dur_WAKE_interPeriod_CRH_Sal(j,:) = dur_WAKE_interPeriod_CRH_Sal{j}; data_dur_WAKE_interPeriod_CRH_Sal(isnan(data_dur_WAKE_interPeriod_CRH_Sal)==1)=0;
    data_dur_totSleep_interPeriod_CRH_Sal(j,:) = dur_totSleep_interPeriod_CRH_Sal{j}; data_dur_totSleep_interPeriod_CRH_Sal(isnan(data_dur_totSleep_interPeriod_CRH_Sal)==1)=0;
    
    
    data_num_REM_interPeriod_CRH_Sal(j,:) = num_REM_interPeriod_CRH_Sal{j};data_num_REM_interPeriod_CRH_Sal(isnan(data_num_REM_interPeriod_CRH_Sal)==1)=0;
    data_num_SWS_interPeriod_CRH_Sal(j,:) = num_SWS_interPeriod_CRH_Sal{j}; data_num_SWS_interPeriod_CRH_Sal(isnan(data_num_SWS_interPeriod_CRH_Sal)==1)=0;
    data_num_WAKE_interPeriod_CRH_Sal(j,:) = num_WAKE_interPeriod_CRH_Sal{j}; data_num_WAKE_interPeriod_CRH_Sal(isnan(data_num_WAKE_interPeriod_CRH_Sal)==1)=0;
    data_num_totSleep_interPeriod_CRH_Sal(j,:) = num_totSleep_interPeriod_CRH_Sal{j}; data_num_totSleep_interPeriod_CRH_Sal(isnan(data_num_totSleep_interPeriod_CRH_Sal)==1)=0;
    
    data_perc_REM_interPeriod_CRH_Sal(j,:) = perc_REM_interPeriod_CRH_Sal{j}; data_perc_REM_interPeriod_CRH_Sal(isnan(data_perc_REM_interPeriod_CRH_Sal)==1)=0;
    data_perc_SWS_interPeriod_CRH_Sal(j,:) = perc_SWS_interPeriod_CRH_Sal{j}; data_perc_SWS_interPeriod_CRH_Sal(isnan(data_perc_SWS_interPeriod_CRH_Sal)==1)=0;
    data_perc_WAKE_interPeriod_CRH_Sal(j,:) = perc_WAKE_interPeriod_CRH_Sal{j}; data_perc_WAKE_interPeriod_CRH_Sal(isnan(data_perc_WAKE_interPeriod_CRH_Sal)==1)=0;
    data_perc_totSleep_interPeriod_CRH_Sal(j,:) = perc_totSleep_interPeriod_CRH_Sal{j}; data_perc_totSleep_interPeriod_CRH_Sal(isnan(data_perc_totSleep_interPeriod_CRH_Sal)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_CRH_Sal(j,:) = dur_REM_end_CRH_Sal{j}; data_dur_REM_end_CRH_Sal(isnan(data_dur_REM_end_CRH_Sal)==1)=0;
    data_dur_SWS_end_CRH_Sal(j,:) = dur_SWS_end_CRH_Sal{j}; data_dur_SWS_end_CRH_Sal(isnan(data_dur_SWS_end_CRH_Sal)==1)=0;
    data_dur_WAKE_end_CRH_Sal(j,:) = dur_WAKE_end_CRH_Sal{j}; data_dur_WAKE_end_CRH_Sal(isnan(data_dur_WAKE_end_CRH_Sal)==1)=0;
    data_dur_totSleep_end_CRH_Sal(j,:) = dur_totSleep_end_CRH_Sal{j}; data_dur_totSleep_end_CRH_Sal(isnan(data_dur_totSleep_end_CRH_Sal)==1)=0;
    
    
    data_num_REM_end_CRH_Sal(j,:) = num_REM_end_CRH_Sal{j};data_num_REM_end_CRH_Sal(isnan(data_num_REM_end_CRH_Sal)==1)=0;
    data_num_SWS_end_CRH_Sal(j,:) = num_SWS_end_CRH_Sal{j}; data_num_SWS_end_CRH_Sal(isnan(data_num_SWS_end_CRH_Sal)==1)=0;
    data_num_WAKE_end_CRH_Sal(j,:) = num_WAKE_end_CRH_Sal{j}; data_num_WAKE_end_CRH_Sal(isnan(data_num_WAKE_end_CRH_Sal)==1)=0;
    data_num_totSleep_end_CRH_Sal(j,:) = num_totSleep_end_CRH_Sal{j}; data_num_totSleep_end_CRH_Sal(isnan(data_num_totSleep_end_CRH_Sal)==1)=0;
    
    
    data_perc_REM_end_CRH_Sal(j,:) = perc_REM_end_CRH_Sal{j}; data_perc_REM_end_CRH_Sal(isnan(data_perc_REM_end_CRH_Sal)==1)=0;
    data_perc_SWS_end_CRH_Sal(j,:) = perc_SWS_end_CRH_Sal{j}; data_perc_SWS_end_CRH_Sal(isnan(data_perc_SWS_end_CRH_Sal)==1)=0;
    data_perc_WAKE_end_CRH_Sal(j,:) = perc_WAKE_end_CRH_Sal{j}; data_perc_WAKE_end_CRH_Sal(isnan(data_perc_WAKE_end_CRH_Sal)==1)=0;
    data_perc_totSleep_end_CRH_Sal(j,:) = perc_totSleep_end_CRH_Sal{j}; data_perc_totSleep_end_CRH_Sal(isnan(data_perc_totSleep_end_CRH_Sal)==1)=0;
    
end

%% probability
for j=1:length(all_trans_REM_REM_CRH_Sal)
    data_REM_short_WAKE_end_CRH_Sal(j,:) = all_trans_REM_short_WAKE_end_CRH_Sal{j}; data_REM_short_WAKE_end_CRH_Sal(isnan(data_REM_short_WAKE_end_CRH_Sal)==1)=0;
    data_REM_short_SWS_end_CRH_Sal(j,:) = all_trans_REM_short_SWS_end_CRH_Sal{j}; data_REM_short_SWS_end_CRH_Sal(isnan(data_REM_short_SWS_end_CRH_Sal)==1)=0;
        data_REM_short_REM_end_CRH_Sal(j,:) = all_trans_REM_short_REM_end_CRH_Sal{j}; data_REM_short_REM_end_CRH_Sal(isnan(data_REM_short_REM_end_CRH_Sal)==1)=0;

    data_REM_mid_WAKE_end_CRH_Sal(j,:) = all_trans_REM_mid_WAKE_end_CRH_Sal{j}; data_REM_mid_WAKE_end_CRH_Sal(isnan(data_REM_mid_WAKE_end_CRH_Sal)==1)=0;
    data_REM_mid_SWS_end_CRH_Sal(j,:) = all_trans_REM_mid_SWS_end_CRH_Sal{j}; data_REM_mid_SWS_end_CRH_Sal(isnan(data_REM_mid_SWS_end_CRH_Sal)==1)=0;
    
    data_REM_long_WAKE_end_CRH_Sal(j,:) = all_trans_REM_long_WAKE_end_CRH_Sal{j}; data_REM_long_WAKE_end_CRH_Sal(isnan(data_REM_long_WAKE_end_CRH_Sal)==1)=0;
    data_REM_long_SWS_end_CRH_Sal(j,:) = all_trans_REM_long_SWS_end_CRH_Sal{j}; data_REM_long_SWS_end_CRH_Sal(isnan(data_REM_long_SWS_end_CRH_Sal)==1)=0;
    
    data_REM_mid_REM_end_CRH_Sal(j,:) = all_trans_REM_mid_REM_end_CRH_Sal{j}; data_REM_mid_REM_end_CRH_Sal(isnan(data_REM_mid_REM_end_CRH_Sal)==1)=0;
    data_REM_long_REM_end_CRH_Sal(j,:) = all_trans_REM_long_REM_end_CRH_Sal{j}; data_REM_long_REM_end_CRH_Sal(isnan(data_REM_long_REM_end_CRH_Sal)==1)=0;
    
end



%% GET DATA - CRH mCherry CNO injection 10h without stress

for m=1:length(Dir_CRH_CNO.path)
    cd(Dir_CRH_CNO.path{m}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_CRH_cno{m} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_CRH_cno{m} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_CRH_cno{m} = intervalSet(0,time_end);
    same_epoch_begin_CRH_cno{m} = intervalSet(time_st,time_mid_begin_snd_period);
    same_epoch_end_CRH_cno{m} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_CRH_cno{m} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_CRH_cno{m}.Wake,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_CRH_cno{m}),'wake',tempbin,time_st,time_end);
    dur_WAKE_CRH_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_CRH_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_CRH_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_CRH_cno{m}.Wake,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_CRH_cno{m}),'sws',tempbin,time_st,time_end);
    dur_SWS_CRH_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_CRH_cno{m}=num_moyen_ep_SWS;
    perc_SWS_CRH_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_CRH_cno{m}.Wake,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_CRH_cno{m}),'rem',tempbin,time_st,time_end);
    dur_REM_CRH_cno{m}=dur_moyenne_ep_REM;
    num_REM_CRH_cno{m}=num_moyen_ep_REM;
    perc_REM_CRH_cno{m}=perc_moyen_REM;
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_CRH_cno{m}.Wake,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_CRH_cno{m}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_CRH_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_CRH_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_CRH_cno{m}=perc_moyen_totSleep;
    
    
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_CRH_cno{m}.Wake,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_CRH_cno{m}),tempbin,time_end);
    all_trans_REM_REM_CRH_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_CRH_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_CRH_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_CRH_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_CRH_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_CRH_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_CRH_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_CRH_cno{m} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_begin_CRH_cno{m}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_CRH_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_CRH_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_begin_CRH_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_begin_CRH_cno{m}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_CRH_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_begin_CRH_cno{m}=num_moyen_ep_SWS;
    perc_SWS_begin_CRH_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_begin_CRH_cno{m}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_CRH_cno{m}=dur_moyenne_ep_REM;
    num_REM_begin_CRH_cno{m}=num_moyen_ep_REM;
    perc_REM_begin_CRH_cno{m}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_begin_CRH_cno{m}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_CRH_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_CRH_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_begin_CRH_cno{m}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_cno{m}.Wake,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_begin_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_begin_CRH_cno{m}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_CRH_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_CRH_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_CRH_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_CRH_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_CRH_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_CRH_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_CRH_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_CRH_cno{m} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_interPeriod_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_interPeriod_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_interPeriod_CRH_cno{m}),'wake',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_WAKE_interPeriod_CRH_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_CRH_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_CRH_cno{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_interPeriod_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_interPeriod_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_interPeriod_CRH_cno{m}),'sws',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_SWS_interPeriod_CRH_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_CRH_cno{m}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_CRH_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_interPeriod_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_interPeriod_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_interPeriod_CRH_cno{m}),'rem',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_REM_interPeriod_CRH_cno{m}=dur_moyenne_ep_REM;
    num_REM_interPeriod_CRH_cno{m}=num_moyen_ep_REM;
    perc_REM_interPeriod_CRH_cno{m}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_interPeriod_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_interPeriod_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_interPeriod_CRH_cno{m}),'sleep',tempbin,time_mid_end_first_period,time_mid_begin_snd_period);
    dur_totSleep_interPeriod_CRH_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_CRH_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_CRH_cno{m}=perc_moyen_totSleep;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}),'wake',tempbin,time_mid_begin_snd_period,time_end);
    dur_WAKE_end_CRH_cno{m}=dur_moyenne_ep_WAKE;
    num_WAKE_end_CRH_cno{m}=num_moyen_ep_WAKE;
    perc_WAKE_end_CRH_cno{m}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}),'sws',tempbin,time_mid_begin_snd_period,time_end);
    dur_SWS_end_CRH_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_end_CRH_cno{m}=num_moyen_ep_SWS;
    perc_SWS_end_CRH_cno{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}),'rem',tempbin,time_mid_begin_snd_period,time_end);
    dur_REM_end_CRH_cno{m}=dur_moyenne_ep_REM;
    num_REM_end_CRH_cno{m}=num_moyen_ep_REM;
    perc_REM_end_CRH_cno{m}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_CRH_cno{m}.Wake,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}),'sleep',tempbin,time_mid_begin_snd_period,time_end);
    dur_totSleep_end_CRH_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_end_CRH_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_end_CRH_cno{m}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_cno{m}.Wake,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_REM_end_CRH_cno{m} = trans_REM_to_REM;
    all_trans_REM_SWS_end_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_CRH_cno{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_CRH_cno{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_CRH_cno{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_CRH_cno{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_CRH_cno{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_CRH_cno{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_CRH_cno{m} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_WAKE_CRH_cno_bis{m}, durT_WAKE_CRH_cno(m)]=DurationEpoch(and(stages_CRH_cno{m}.Wake,same_epoch_end_CRH_cno{m}),'s');
    [dur_SWS_CRH_cno_bis{m}, durT_SWS_CRH_cno(m)]=DurationEpoch(and(stages_CRH_cno{m}.SWSEpoch,same_epoch_end_CRH_cno{m}),'s');
    
    [dur_REM_CRH_cno_bis{m}, durT_REM_CRH_cno(m)]=DurationEpoch(and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}),'s');
    
    idx_short_rem_CRH_cno_1{m} = find(dur_REM_CRH_cno_bis{m}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_CRH_cno_1{m} = subset(and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}), idx_short_rem_CRH_cno_1{m});
    [dur_rem_short_CRH_cno_1{m}, durT_rem_short_CRH_cno(m)] = DurationEpoch(short_REMEpoch_CRH_cno_1{m},'s');
    perc_rem_short_CRH_cno_1(m) = durT_rem_short_CRH_cno(m) / durT_REM_CRH_cno(m) * 100;
    dur_moyenne_rem_short_CRH_cno_1(m) = nanmean(dur_rem_short_CRH_cno_1{m});
    num_moyen_rem_short_CRH_cno_1(m) = length(dur_rem_short_CRH_cno_1{m});
    
    idx_short_rem_CRH_cno_2{m} = find(dur_REM_CRH_cno_bis{m}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_CRH_cno_2{m} = subset(and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}), idx_short_rem_CRH_cno_2{m});
    [dur_rem_short_CRH_cno_2{m}, durT_rem_short_CRH_cno(m)] = DurationEpoch(short_REMEpoch_CRH_cno_2{m},'s');
    perc_rem_short_CRH_cno_2(m) = durT_rem_short_CRH_cno(m) / durT_REM_CRH_cno(m) * 100;
    dur_moyenne_rem_short_CRH_cno_2(m) = nanmean(dur_rem_short_CRH_cno_2{m});
    num_moyen_rem_short_CRH_cno_2(m) = length(dur_rem_short_CRH_cno_2{m});
    
    idx_short_rem_CRH_cno_3{m} = find(dur_REM_CRH_cno_bis{m}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_CRH_cno_3{m} = subset(and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}), idx_short_rem_CRH_cno_3{m});
    [dur_rem_short_CRH_cno_3{m}, durT_rem_short_CRH_cno(m)] = DurationEpoch(short_REMEpoch_CRH_cno_3{m},'s');
    perc_rem_short_CRH_cno_3(m) = durT_rem_short_CRH_cno(m) / durT_REM_CRH_cno(m) * 100;
    dur_moyenne_rem_short_CRH_cno_3(m) = nanmean(dur_rem_short_CRH_cno_3{m});
    num_moyen_rem_short_CRH_cno_3(m) = length(dur_rem_short_CRH_cno_3{m});
    
    idx_long_rem_CRH_cno{m} = find(dur_REM_CRH_cno_bis{m}>lim_long_rem); %long bout
    long_REMEpoch_CRH_cno{m} = subset(and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}), idx_long_rem_CRH_cno{m});
    [dur_rem_long_CRH_cno{m}, durT_rem_long_CRH_cno(m)] = DurationEpoch(long_REMEpoch_CRH_cno{m},'s');
    perc_rem_long_CRH_cno(m) = durT_rem_long_CRH_cno(m) / durT_REM_CRH_cno(m) * 100;
    dur_moyenne_rem_long_CRH_cno(m) = nanmean(dur_rem_long_CRH_cno{m});
    num_moyen_rem_long_CRH_cno(m) = length(dur_rem_long_CRH_cno{m});
    
    idx_mid_rem_CRH_cno{m} = find(dur_REM_CRH_cno_bis{m}>lim_short_rem_1 & dur_REM_CRH_cno_bis{m}<lim_long_rem); % middle bouts
    mid_REMEpoch_CRH_cno{m} = subset(and(stages_CRH_cno{m}.REMEpoch,same_epoch_end_CRH_cno{m}), idx_mid_rem_CRH_cno{m});
    [dur_rem_mid_CRH_cno{m}, durT_rem_mid_CRH_cno(m)] = DurationEpoch(mid_REMEpoch_CRH_cno{m},'s');
    perc_rem_mid_CRH_cno(m) = durT_rem_mid_CRH_cno(m) / durT_REM_CRH_cno(m) * 100;
    dur_moyenne_rem_mid_CRH_cno(m) = nanmean(dur_rem_mid_CRH_cno{m});
    num_moyen_rem_mid_CRH_cno(m) = length(dur_rem_mid_CRH_cno{m});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_cno{m}.Wake,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_end_CRH_cno{m}),and(short_REMEpoch_CRH_cno_1{m},same_epoch_end_CRH_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_short_SWS_end_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_CRH_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_CRH_cno{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_cno{m}.Wake,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_end_CRH_cno{m}),and(mid_REMEpoch_CRH_cno{m},same_epoch_end_CRH_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_mid_SWS_end_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_CRH_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_CRH_cno{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_CRH_cno{m}.Wake,same_epoch_end_CRH_cno{m}),and(stages_CRH_cno{m}.SWSEpoch,same_epoch_end_CRH_cno{m}),and(long_REMEpoch_CRH_cno{m},same_epoch_end_CRH_cno{m}),tempbin,time_mid_begin_snd_period,time_end);
    all_trans_REM_long_SWS_end_CRH_cno{m} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_CRH_cno{m} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_CRH_cno{m} = trans_REM_to_REM;
    
    
end

%% compute average - CRH mCherry cno injection 10h without stress
%%percentage/duration/number
for m=1:length(dur_REM_CRH_cno)
    %%ALL SESSION
    data_dur_REM_CRH_cno(m,:) = dur_REM_CRH_cno{m}; data_dur_REM_CRH_cno(isnan(data_dur_REM_CRH_cno)==1)=0;
    data_dur_SWS_CRH_cno(m,:) = dur_SWS_CRH_cno{m}; data_dur_SWS_CRH_cno(isnan(data_dur_SWS_CRH_cno)==1)=0;
    data_dur_WAKE_CRH_cno(m,:) = dur_WAKE_CRH_cno{m}; data_dur_WAKE_CRH_cno(isnan(data_dur_WAKE_CRH_cno)==1)=0;
    data_dur_totSleep_CRH_cno(m,:) = dur_totSleep_CRH_cno{m}; data_dur_totSleep_CRH_cno(isnan(data_dur_totSleep_CRH_cno)==1)=0;
    
    data_num_REM_CRH_cno(m,:) = num_REM_CRH_cno{m};data_num_REM_CRH_cno(isnan(data_num_REM_CRH_cno)==1)=0;
    data_num_SWS_CRH_cno(m,:) = num_SWS_CRH_cno{m}; data_num_SWS_CRH_cno(isnan(data_num_SWS_CRH_cno)==1)=0;
    data_num_WAKE_CRH_cno(m,:) = num_WAKE_CRH_cno{m}; data_num_WAKE_CRH_cno(isnan(data_num_WAKE_CRH_cno)==1)=0;
    data_num_totSleep_CRH_cno(m,:) = num_totSleep_CRH_cno{m}; data_num_totSleep_CRH_cno(isnan(data_num_totSleep_CRH_cno)==1)=0;
    
    data_perc_REM_CRH_cno(m,:) = perc_REM_CRH_cno{m}; data_perc_REM_CRH_cno(isnan(data_perc_REM_CRH_cno)==1)=0;
    data_perc_SWS_CRH_cno(m,:) = perc_SWS_CRH_cno{m}; data_perc_SWS_CRH_cno(isnan(data_perc_SWS_CRH_cno)==1)=0;
    data_perc_WAKE_CRH_cno(m,:) = perc_WAKE_CRH_cno{m}; data_perc_WAKE_CRH_cno(isnan(data_perc_WAKE_CRH_cno)==1)=0;
    data_perc_totSleep_CRH_cno(m,:) = perc_totSleep_CRH_cno{m}; data_perc_totSleep_CRH_cno(isnan(data_perc_totSleep_CRH_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_CRH_cno(m,:) = dur_REM_begin_CRH_cno{m}; data_dur_REM_begin_CRH_cno(isnan(data_dur_REM_begin_CRH_cno)==1)=0;
    data_dur_SWS_begin_CRH_cno(m,:) = dur_SWS_begin_CRH_cno{m}; data_dur_SWS_begin_CRH_cno(isnan(data_dur_SWS_begin_CRH_cno)==1)=0;
    data_dur_WAKE_begin_CRH_cno(m,:) = dur_WAKE_begin_CRH_cno{m}; data_dur_WAKE_begin_CRH_cno(isnan(data_dur_WAKE_begin_CRH_cno)==1)=0;
    data_dur_totSleep_begin_CRH_cno(m,:) = dur_totSleep_begin_CRH_cno{m}; data_dur_totSleep_begin_CRH_cno(isnan(data_dur_totSleep_begin_CRH_cno)==1)=0;
    
    
    data_num_REM_begin_CRH_cno(m,:) = num_REM_begin_CRH_cno{m};data_num_REM_begin_CRH_cno(isnan(data_num_REM_begin_CRH_cno)==1)=0;
    data_num_SWS_begin_CRH_cno(m,:) = num_SWS_begin_CRH_cno{m}; data_num_SWS_begin_CRH_cno(isnan(data_num_SWS_begin_CRH_cno)==1)=0;
    data_num_WAKE_begin_CRH_cno(m,:) = num_WAKE_begin_CRH_cno{m}; data_num_WAKE_begin_CRH_cno(isnan(data_num_WAKE_begin_CRH_cno)==1)=0;
    data_num_totSleep_begin_CRH_cno(m,:) = num_totSleep_begin_CRH_cno{m}; data_num_totSleep_begin_CRH_cno(isnan(data_num_totSleep_begin_CRH_cno)==1)=0;
    
    data_perc_REM_begin_CRH_cno(m,:) = perc_REM_begin_CRH_cno{m}; data_perc_REM_begin_CRH_cno(isnan(data_perc_REM_begin_CRH_cno)==1)=0;
    data_perc_SWS_begin_CRH_cno(m,:) = perc_SWS_begin_CRH_cno{m}; data_perc_SWS_begin_CRH_cno(isnan(data_perc_SWS_begin_CRH_cno)==1)=0;
    data_perc_WAKE_begin_CRH_cno(m,:) = perc_WAKE_begin_CRH_cno{m}; data_perc_WAKE_begin_CRH_cno(isnan(data_perc_WAKE_begin_CRH_cno)==1)=0;
    data_perc_totSleep_begin_CRH_cno(m,:) = perc_totSleep_begin_CRH_cno{m}; data_perc_totSleep_begin_CRH_cno(isnan(data_perc_totSleep_begin_CRH_cno)==1)=0;
    
    data_dur_REM_interPeriod_CRH_cno(m,:) = dur_REM_interPeriod_CRH_cno{m}; data_dur_REM_interPeriod_CRH_cno(isnan(data_dur_REM_interPeriod_CRH_cno)==1)=0;
    data_dur_SWS_interPeriod_CRH_cno(m,:) = dur_SWS_interPeriod_CRH_cno{m}; data_dur_SWS_interPeriod_CRH_cno(isnan(data_dur_SWS_interPeriod_CRH_cno)==1)=0;
    data_dur_WAKE_interPeriod_CRH_cno(m,:) = dur_WAKE_interPeriod_CRH_cno{m}; data_dur_WAKE_interPeriod_CRH_cno(isnan(data_dur_WAKE_interPeriod_CRH_cno)==1)=0;
    data_dur_totSleep_interPeriod_CRH_cno(m,:) = dur_totSleep_interPeriod_CRH_cno{m}; data_dur_totSleep_interPeriod_CRH_cno(isnan(data_dur_totSleep_interPeriod_CRH_cno)==1)=0;
    
    
    data_num_REM_interPeriod_CRH_cno(m,:) = num_REM_interPeriod_CRH_cno{m};data_num_REM_interPeriod_CRH_cno(isnan(data_num_REM_interPeriod_CRH_cno)==1)=0;
    data_num_SWS_interPeriod_CRH_cno(m,:) = num_SWS_interPeriod_CRH_cno{m}; data_num_SWS_interPeriod_CRH_cno(isnan(data_num_SWS_interPeriod_CRH_cno)==1)=0;
    data_num_WAKE_interPeriod_CRH_cno(m,:) = num_WAKE_interPeriod_CRH_cno{m}; data_num_WAKE_interPeriod_CRH_cno(isnan(data_num_WAKE_interPeriod_CRH_cno)==1)=0;
    data_num_totSleep_interPeriod_CRH_cno(m,:) = num_totSleep_interPeriod_CRH_cno{m}; data_num_totSleep_interPeriod_CRH_cno(isnan(data_num_totSleep_interPeriod_CRH_cno)==1)=0;
    
    data_perc_REM_interPeriod_CRH_cno(m,:) = perc_REM_interPeriod_CRH_cno{m}; data_perc_REM_interPeriod_CRH_cno(isnan(data_perc_REM_interPeriod_CRH_cno)==1)=0;
    data_perc_SWS_interPeriod_CRH_cno(m,:) = perc_SWS_interPeriod_CRH_cno{m}; data_perc_SWS_interPeriod_CRH_cno(isnan(data_perc_SWS_interPeriod_CRH_cno)==1)=0;
    data_perc_WAKE_interPeriod_CRH_cno(m,:) = perc_WAKE_interPeriod_CRH_cno{m}; data_perc_WAKE_interPeriod_CRH_cno(isnan(data_perc_WAKE_interPeriod_CRH_cno)==1)=0;
    data_perc_totSleep_interPeriod_CRH_cno(m,:) = perc_totSleep_interPeriod_CRH_cno{m}; data_perc_totSleep_interPeriod_CRH_cno(isnan(data_perc_totSleep_interPeriod_CRH_cno)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_CRH_cno(m,:) = dur_REM_end_CRH_cno{m}; data_dur_REM_end_CRH_cno(isnan(data_dur_REM_end_CRH_cno)==1)=0;
    data_dur_SWS_end_CRH_cno(m,:) = dur_SWS_end_CRH_cno{m}; data_dur_SWS_end_CRH_cno(isnan(data_dur_SWS_end_CRH_cno)==1)=0;
    data_dur_WAKE_end_CRH_cno(m,:) = dur_WAKE_end_CRH_cno{m}; data_dur_WAKE_end_CRH_cno(isnan(data_dur_WAKE_end_CRH_cno)==1)=0;
    data_dur_totSleep_end_CRH_cno(m,:) = dur_totSleep_end_CRH_cno{m}; data_dur_totSleep_end_CRH_cno(isnan(data_dur_totSleep_end_CRH_cno)==1)=0;
    
    
    data_num_REM_end_CRH_cno(m,:) = num_REM_end_CRH_cno{m};data_num_REM_end_CRH_cno(isnan(data_num_REM_end_CRH_cno)==1)=0;
    data_num_SWS_end_CRH_cno(m,:) = num_SWS_end_CRH_cno{m}; data_num_SWS_end_CRH_cno(isnan(data_num_SWS_end_CRH_cno)==1)=0;
    data_num_WAKE_end_CRH_cno(m,:) = num_WAKE_end_CRH_cno{m}; data_num_WAKE_end_CRH_cno(isnan(data_num_WAKE_end_CRH_cno)==1)=0;
    data_num_totSleep_end_CRH_cno(m,:) = num_totSleep_end_CRH_cno{m}; data_num_totSleep_end_CRH_cno(isnan(data_num_totSleep_end_CRH_cno)==1)=0;
    
    
    data_perc_REM_end_CRH_cno(m,:) = perc_REM_end_CRH_cno{m}; data_perc_REM_end_CRH_cno(isnan(data_perc_REM_end_CRH_cno)==1)=0;
    data_perc_SWS_end_CRH_cno(m,:) = perc_SWS_end_CRH_cno{m}; data_perc_SWS_end_CRH_cno(isnan(data_perc_SWS_end_CRH_cno)==1)=0;
    data_perc_WAKE_end_CRH_cno(m,:) = perc_WAKE_end_CRH_cno{m}; data_perc_WAKE_end_CRH_cno(isnan(data_perc_WAKE_end_CRH_cno)==1)=0;
    data_perc_totSleep_end_CRH_cno(m,:) = perc_totSleep_end_CRH_cno{m}; data_perc_totSleep_end_CRH_cno(isnan(data_perc_totSleep_end_CRH_cno)==1)=0;
    
end

%% probability
for m=1:length(all_trans_REM_REM_CRH_cno)
    % %     %%ALL SESSION
    % %     data_REM_REM_CRH_cno(m,:) = all_trans_REM_REM_CRH_cno{m}; data_REM_REM_CRH_cno(isnan(data_REM_REM_CRH_cno)==1)=0;
    % %     data_REM_SWS_CRH_cno(m,:) = all_trans_REM_SWS_CRH_cno{m}; data_REM_SWS_CRH_cno(isnan(data_REM_SWS_CRH_cno)==1)=0;
    % %     data_REM_WAKE_CRH_cno(m,:) = all_trans_REM_WAKE_CRH_cno{m}; data_REM_WAKE_CRH_cno(isnan(data_REM_WAKE_CRH_cno)==1)=0;
    % %
    % %     data_SWS_SWS_CRH_cno(m,:) = all_trans_SWS_SWS_CRH_cno{m}; data_SWS_SWS_CRH_cno(isnan(data_SWS_SWS_CRH_cno)==1)=0;
    % %     data_SWS_REM_CRH_cno(m,:) = all_trans_SWS_REM_CRH_cno{m}; data_SWS_REM_CRH_cno(isnan(data_SWS_REM_CRH_cno)==1)=0;
    % %     data_SWS_WAKE_CRH_cno(m,:) = all_trans_SWS_WAKE_CRH_cno{m}; data_SWS_WAKE_CRH_cno(isnan(data_SWS_WAKE_CRH_cno)==1)=0;
    % %
    % %     data_WAKE_WAKE_CRH_cno(m,:) = all_trans_WAKE_WAKE_CRH_cno{m}; data_WAKE_WAKE_CRH_cno(isnan(data_WAKE_WAKE_CRH_cno)==1)=0;
    % %     data_WAKE_REM_CRH_cno(m,:) = all_trans_WAKE_REM_CRH_cno{m}; data_WAKE_REM_CRH_cno(isnan(data_WAKE_REM_CRH_cno)==1)=0;
    % %     data_WAKE_SWS_CRH_cno(m,:) = all_trans_WAKE_SWS_CRH_cno{m}; data_WAKE_SWS_CRH_cno(isnan(data_WAKE_SWS_CRH_cno)==1)=0;
    % %
    % %     %%3 PREMI7RES HEURES
    % %         data_REM_REM_begin_CRH_cno(m,:) = all_trans_REM_REM_begin_CRH_cno{m}; data_REM_REM_begin_CRH_cno(isnan(data_REM_REM_begin_CRH_cno)==1)=0;
    % %     data_REM_SWS_begin_CRH_cno(m,:) = all_trans_REM_SWS_begin_CRH_cno{m}; data_REM_SWS_begin_CRH_cno(isnan(data_REM_SWS_begin_CRH_cno)==1)=0;
    % %     data_REM_WAKE_begin_CRH_cno(m,:) = all_trans_REM_WAKE_begin_CRH_cno{m}; data_REM_WAKE_begin_CRH_cno(isnan(data_REM_WAKE_begin_CRH_cno)==1)=0;
    % %
    % %     data_SWS_SWS_begin_CRH_cno(m,:) = all_trans_SWS_SWS_begin_CRH_cno{m}; data_SWS_SWS_begin_CRH_cno(isnan(data_SWS_SWS_begin_CRH_cno)==1)=0;
    % %     data_SWS_REM_begin_CRH_cno(m,:) = all_trans_SWS_REM_begin_CRH_cno{m}; data_SWS_REM_begin_CRH_cno(isnan(data_SWS_REM_begin_CRH_cno)==1)=0;
    % %     data_SWS_WAKE_begin_CRH_cno(m,:) = all_trans_SWS_WAKE_begin_CRH_cno{m}; data_SWS_WAKE_begin_CRH_cno(isnan(data_SWS_WAKE_begin_CRH_cno)==1)=0;
    % %
    % %     data_WAKE_WAKE_begin_CRH_cno(m,:) = all_trans_WAKE_WAKE_begin_CRH_cno{m}; data_WAKE_WAKE_begin_CRH_cno(isnan(data_WAKE_WAKE_begin_CRH_cno)==1)=0;
    % %     data_WAKE_REM_begin_CRH_cno(m,:) = all_trans_WAKE_REM_begin_CRH_cno{m}; data_WAKE_REM_begin_CRH_cno(isnan(data_WAKE_REM_begin_CRH_cno)==1)=0;
    % %     data_WAKE_SWS_begin_CRH_cno(m,:) = all_trans_WAKE_SWS_begin_CRH_cno{m}; data_WAKE_SWS_begin_CRH_cno(isnan(data_WAKE_SWS_begin_CRH_cno)==1)=0;
    % %
    % %     %%FIN DE LA SESSION
    % %         data_REM_REM_end_CRH_cno(m,:) = all_trans_REM_REM_end_CRH_cno{m}; data_REM_REM_end_CRH_cno(isnan(data_REM_REM_end_CRH_cno)==1)=0;
    % %     data_REM_SWS_end_CRH_cno(m,:) = all_trans_REM_SWS_end_CRH_cno{m}; data_REM_SWS_end_CRH_cno(isnan(data_REM_SWS_end_CRH_cno)==1)=0;
    % %     data_REM_WAKE_end_CRH_cno(m,:) = all_trans_REM_WAKE_end_CRH_cno{m}; data_REM_WAKE_end_CRH_cno(isnan(data_REM_WAKE_end_CRH_cno)==1)=0;
    % %
    % %     data_SWS_SWS_end_CRH_cno(m,:) = all_trans_SWS_SWS_end_CRH_cno{m}; data_SWS_SWS_end_CRH_cno(isnan(data_SWS_SWS_end_CRH_cno)==1)=0;
    % %     data_SWS_REM_end_CRH_cno(m,:) = all_trans_SWS_REM_end_CRH_cno{m}; data_SWS_REM_end_CRH_cno(isnan(data_SWS_REM_end_CRH_cno)==1)=0;
    % %     data_SWS_WAKE_end_CRH_cno(m,:) = all_trans_SWS_WAKE_end_CRH_cno{m}; data_SWS_WAKE_end_CRH_cno(isnan(data_SWS_WAKE_end_CRH_cno)==1)=0;
    % %
    % %     data_WAKE_WAKE_end_CRH_cno(m,:) = all_trans_WAKE_WAKE_end_CRH_cno{m}; data_WAKE_WAKE_end_CRH_cno(isnan(data_WAKE_WAKE_end_CRH_cno)==1)=0;
    % %     data_WAKE_REM_end_CRH_cno(m,:) = all_trans_WAKE_REM_end_CRH_cno{m}; data_WAKE_REM_end_CRH_cno(isnan(data_WAKE_REM_end_CRH_cno)==1)=0;
    % %     data_WAKE_SWS_end_CRH_cno(m,:) = all_trans_WAKE_SWS_end_CRH_cno{m}; data_WAKE_SWS_end_CRH_cno(isnan(data_WAKE_SWS_end_CRH_cno)==1)=0;
    data_REM_short_WAKE_end_CRH_cno(m,:) = all_trans_REM_short_WAKE_end_CRH_cno{m}; data_REM_short_WAKE_end_CRH_cno(isnan(data_REM_short_WAKE_end_CRH_cno)==1)=0;
    data_REM_short_SWS_end_CRH_cno(m,:) = all_trans_REM_short_SWS_end_CRH_cno{m}; data_REM_short_SWS_end_CRH_cno(isnan(data_REM_short_SWS_end_CRH_cno)==1)=0;
    
    data_REM_mid_WAKE_end_CRH_cno(m,:) = all_trans_REM_mid_WAKE_end_CRH_cno{m}; data_REM_mid_WAKE_end_CRH_cno(isnan(data_REM_mid_WAKE_end_CRH_cno)==1)=0;
    data_REM_mid_SWS_end_CRH_cno(m,:) = all_trans_REM_mid_SWS_end_CRH_cno{m}; data_REM_mid_SWS_end_CRH_cno(isnan(data_REM_mid_SWS_end_CRH_cno)==1)=0;
    
    data_REM_long_WAKE_end_CRH_cno(m,:) = all_trans_REM_long_WAKE_end_CRH_cno{m}; data_REM_long_WAKE_end_CRH_cno(isnan(data_REM_long_WAKE_end_CRH_cno)==1)=0;
    data_REM_long_SWS_end_CRH_cno(m,:) = all_trans_REM_long_SWS_end_CRH_cno{m}; data_REM_long_SWS_end_CRH_cno(isnan(data_REM_long_SWS_end_CRH_cno)==1)=0;
    
    
    data_REM_short_REM_end_CRH_cno(m,:) = all_trans_REM_short_REM_end_CRH_cno{m}; data_REM_short_REM_end_CRH_cno(isnan(data_REM_short_REM_end_CRH_cno)==1)=0;
    data_REM_mid_REM_end_CRH_cno(m,:) = all_trans_REM_mid_REM_end_CRH_cno{m}; data_REM_mid_REM_end_CRH_cno(isnan(data_REM_mid_REM_end_CRH_cno)==1)=0;
    data_REM_long_REM_end_CRH_cno(m,:) = all_trans_REM_long_REM_end_CRH_cno{m}; data_REM_long_REM_end_CRH_cno(isnan(data_REM_long_REM_end_CRH_cno)==1)=0;
    
    
end

