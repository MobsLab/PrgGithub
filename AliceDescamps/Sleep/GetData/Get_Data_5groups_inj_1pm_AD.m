
%% input dir
% %1
% Dir_1 = PathForExperiments_DREADD_AD ('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% %%2
% Dir_2 = PathForExperiments_DREADD_AD ('exciDREADD_CRH_VLPO_CNOInjection_1pm');
% %%3
% Dir_3 = PathForExperiments_DREADD_AD ('exciDREADD_hetero_CRH_VLPO_SalineInjection_1pm');
% %%4
% Dir_4 = PathForExperiments_DREADD_AD ('exciDREADD_hetero_CRH_VLPO_CNOInjection_1pm');
% %%5
% Dir_5 = PathForExperiments_SleepPostSD_AD('SleepPostSD_SecondRun_inhibDREADD_CRH_VLPO_SalineInjection_10am');

%% input dir
%1
Dir_1 = PathForExperiments_DREADD_AD ('exciDREADD_hetero_CRH_VLPO_SalineInjection_1pm');
%%2
Dir_2 = PathForExperiments_DREADD_AD ('exciDREADD_hetero_CRH_VLPO_CNOInjection_1pm');
%%3
Dir_3 = PathForExperiments_DREADD_AD ('exciDREADD_hetero_CRH_VLPO_SalineInjection_1pm');
%%4
Dir_4 = PathForExperiments_DREADD_AD ('exciDREADD_hetero_CRH_VLPO_CNOInjection_1pm');
%%5
Dir_5 = PathForExperiments_SleepPostSD_AD('SleepPostSD_SecondRun_inhibDREADD_CRH_VLPO_SalineInjection_10am');


%% parameters

tempbin = 3600; %bin size to plot variables overtime
% tempbin = 1800; %bin size to plot variables overtime
% tempbin = 7200; %bin size to plot variables overtime

time_st = 0*3600*1e4; %begining of the sleep session
% time_end=3*1e8;  %end of the sleep session
time_end=3.25*1e8;  %end of the sleep session

%Injection at 1pm
time_mid_end_first_period = 1.4*1E8;
time_mid_end_snd_period = 1.65*1E8;

lim_short_rem_1 = 25; %25 take all rem bouts shorter than limit
lim_short_rem_2 = 15;
lim_short_rem_3 = 20;

lim_long_rem = 25; %25 take all rem bouts longer than limit

mindurSWS = 60;
mindurREM = 25;

%% GET DATA - 1st group

for i=1:length(Dir_1.path)
    cd(Dir_1.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_1{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_1{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%Define different periods of time for quantifications
    same_epoch_all_sess_1{i} = intervalSet(0,time_end); %all session
    same_epoch_begin_1{i} = intervalSet(time_st,time_mid_end_first_period); %beginning of the session (period of insomnia)
    same_epoch_end_1{i} = intervalSet(time_mid_end_snd_period,time_end); %late phase of the session (rem frag)
    same_epoch_interPeriod_1{i} = intervalSet(time_mid_end_first_period,time_mid_end_snd_period); %inter period
    
    %%Compute percentage, mean duration, number of bouts overtime (over all session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_1{i}.Wake,same_epoch_all_sess_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_all_sess_1{i}),and(stages_1{i}.REMEpoch,same_epoch_all_sess_1{i}),'wake',tempbin,time_st,time_end);
    dur_WAKE_1{i}=dur_moyenne_ep_WAKE;
    num_WAKE_1{i}=num_moyen_ep_WAKE;
    perc_WAKE_1{i}=perc_moyen_WAKE;

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_1{i}.Wake,same_epoch_all_sess_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_all_sess_1{i}),and(stages_1{i}.REMEpoch,same_epoch_all_sess_1{i}),'sws',tempbin,time_st,time_end);
    dur_SWS_1{i}=dur_moyenne_ep_SWS;
    num_SWS_1{i}=num_moyen_ep_SWS;
    perc_SWS_1{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_1{i}.Wake,same_epoch_all_sess_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_all_sess_1{i}),and(stages_1{i}.REMEpoch,same_epoch_all_sess_1{i}),'rem',tempbin,time_st,time_end);
    dur_REM_1{i}=dur_moyenne_ep_REM;
    num_REM_1{i}=num_moyen_ep_REM;
    perc_REM_1{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_1{i}.Wake,same_epoch_all_sess_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_all_sess_1{i}),and(stages_1{i}.REMEpoch,same_epoch_all_sess_1{i}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_1{i}=dur_moyenne_ep_totSleep;
    num_totSleep_1{i}=num_moyen_ep_totSleep;
    perc_totSleep_1{i}=perc_moyen_totSleep;
    

    %%First period (beginning)
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_begin_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_begin_1{i}),and(stages_1{i}.REMEpoch,same_epoch_begin_1{i}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_1{i}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_1{i}=num_moyen_ep_WAKE;
    perc_WAKE_begin_1{i}=perc_moyen_WAKE;
    [dur_WAKE_begin_1_bis{i}, durT_WAKE_begin_1(i)]=DurationEpoch(and(stages_1{i}.Wake,same_epoch_begin_1{i}),'min');

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_begin_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_begin_1{i}),and(stages_1{i}.REMEpoch,same_epoch_begin_1{i}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_1{i}=dur_moyenne_ep_SWS;
    num_SWS_begin_1{i}=num_moyen_ep_SWS;
    perc_SWS_begin_1{i}=perc_moyen_SWS;
    [dur_SWS_begin_1_bis{i}, durT_SWS_begin_1(i)]=DurationEpoch(and(stages_1{i}.SWSEpoch,same_epoch_begin_1{i}),'min');

    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_begin_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_begin_1{i}),and(stages_1{i}.REMEpoch,same_epoch_begin_1{i}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_1{i}=dur_moyenne_ep_REM;
    num_REM_begin_1{i}=num_moyen_ep_REM;
    perc_REM_begin_1{i}=perc_moyen_REM;
    [dur_REM_begin_1_bis{i}, durT_REM_begin_1(i)]=DurationEpoch(and(stages_1{i}.REMEpoch,same_epoch_begin_1{i}),'min');

    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_begin_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_begin_1{i}),and(stages_1{i}.REMEpoch,same_epoch_begin_1{i}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_1{i}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_1{i}=num_moyen_ep_totSleep;
    perc_totSleep_begin_1{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_1{i}.Wake,same_epoch_begin_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_begin_1{i}),and(stages_1{i}.REMEpoch,same_epoch_begin_1{i}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_1{i} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_1{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_1{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_1{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_1{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_1{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_1{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_1{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_1{i} = trans_WAKE_to_WAKE;
    
    
    
    %%Inter period (middle part of the session)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_interPeriod_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_interPeriod_1{i}),and(stages_1{i}.REMEpoch,same_epoch_interPeriod_1{i}),'wake',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_WAKE_interPeriod_1{i}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_1{i}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_1{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_interPeriod_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_interPeriod_1{i}),and(stages_1{i}.REMEpoch,same_epoch_interPeriod_1{i}),'sws',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_SWS_interPeriod_1{i}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_1{i}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_1{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_interPeriod_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_interPeriod_1{i}),and(stages_1{i}.REMEpoch,same_epoch_interPeriod_1{i}),'rem',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_REM_interPeriod_1{i}=dur_moyenne_ep_REM;
    num_REM_interPeriod_1{i}=num_moyen_ep_REM;
    perc_REM_interPeriod_1{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_interPeriod_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_interPeriod_1{i}),and(stages_1{i}.REMEpoch,same_epoch_interPeriod_1{i}),'sleep',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_totSleep_interPeriod_1{i}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_1{i}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_1{i}=perc_moyen_totSleep;
    
    
    
    %%Late period of the session
    %%Compute percentage, mean duration and number of bouts (average in the defined time window)
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_end_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_end_1{i}),and(stages_1{i}.REMEpoch,same_epoch_end_1{i}),'wake',tempbin,time_mid_end_snd_period,time_end);
    dur_WAKE_end_1{i}=dur_moyenne_ep_WAKE;
    num_WAKE_end_1{i}=num_moyen_ep_WAKE;
    perc_WAKE_end_1{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_end_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_end_1{i}),and(stages_1{i}.REMEpoch,same_epoch_end_1{i}),'sws',tempbin,time_mid_end_snd_period,time_end);
    dur_SWS_end_1{i}=dur_moyenne_ep_SWS;
    num_SWS_end_1{i}=num_moyen_ep_SWS;
    perc_SWS_end_1{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_end_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_end_1{i}),and(stages_1{i}.REMEpoch,same_epoch_end_1{i}),'rem',tempbin,time_mid_end_snd_period,time_end);
    dur_REM_end_1{i}=dur_moyenne_ep_REM;
    num_REM_end_1{i}=num_moyen_ep_REM;
    perc_REM_end_1{i}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_1{i}.Wake,same_epoch_end_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_end_1{i}),and(stages_1{i}.REMEpoch,same_epoch_end_1{i}),'sleep',tempbin,time_mid_end_snd_period,time_end);
    dur_totSleep_end_1{i}=dur_moyenne_ep_totSleep;
    num_totSleep_end_1{i}=num_moyen_ep_totSleep;
    perc_totSleep_end_1{i}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_1{i}.Wake,same_epoch_end_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_end_1{i}),and(stages_1{i}.REMEpoch,same_epoch_end_1{i}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_REM_end_1{i} = trans_REM_to_REM;
    all_trans_REM_SWS_end_1{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_1{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_1{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_1{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_1{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_1{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_1{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_1{i} = trans_WAKE_to_WAKE;
    
    
   
    %%Short versus long REM bouts during late period
    [dur_WAKE_1_bis{i}, durT_WAKE_1(i)]=DurationEpoch(and(stages_1{i}.Wake,same_epoch_end_1{i}),'s');
    [dur_SWS_1_bis{i}, durT_SWS_1(i)]=DurationEpoch(and(stages_1{i}.SWSEpoch,same_epoch_end_1{i}),'s');

    [dur_REM_1_bis{i}, durT_REM_1(i)]=DurationEpoch(and(stages_1{i}.REMEpoch,same_epoch_end_1{i}),'s');
    
    idx_short_rem_1_1{i} = find(dur_REM_1_bis{i}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_1_1{i} = subset(and(stages_1{i}.REMEpoch,same_epoch_end_1{i}), idx_short_rem_1_1{i});
    [dur_rem_short_1_1{i}, durT_rem_short_1(i)] = DurationEpoch(short_REMEpoch_1_1{i},'s');
    perc_rem_short_1_1(i) = durT_rem_short_1(i) / durT_REM_1(i) * 100;
    dur_moyenne_rem_short_1_1(i) = nanmean(dur_rem_short_1_1{i});
    num_moyen_rem_short_1_1(i) = length(dur_rem_short_1_1{i});
    
    idx_short_rem_1_2{i} = find(dur_REM_1_bis{i}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_1_2{i} = subset(and(stages_1{i}.REMEpoch,same_epoch_end_1{i}), idx_short_rem_1_2{i});
    [dur_rem_short_1_2{i}, durT_rem_short_1(i)] = DurationEpoch(short_REMEpoch_1_2{i},'s');
    perc_rem_short_1_2(i) = durT_rem_short_1(i) / durT_REM_1(i) * 100;
    dur_moyenne_rem_short_1_2(i) = nanmean(dur_rem_short_1_2{i});
    num_moyen_rem_short_1_2(i) = length(dur_rem_short_1_2{i});
    
    idx_short_rem_1_3{i} = find(dur_REM_1_bis{i}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_1_3{i} = subset(and(stages_1{i}.REMEpoch,same_epoch_end_1{i}), idx_short_rem_1_3{i});
    [dur_rem_short_1_3{i}, durT_rem_short_1(i)] = DurationEpoch(short_REMEpoch_1_3{i},'s');
    perc_rem_short_1_3(i) = durT_rem_short_1(i) / durT_REM_1(i) * 100;
    dur_moyenne_rem_short_1_3(i) = nanmean(dur_rem_short_1_3{i});
    num_moyen_rem_short_1_3(i) = length(dur_rem_short_1_3{i});
    
    idx_long_rem_1{i} = find(dur_REM_1_bis{i}>lim_long_rem); %long bout
    long_REMEpoch_1{i} = subset(and(stages_1{i}.REMEpoch,same_epoch_end_1{i}), idx_long_rem_1{i});
    [dur_rem_long_1{i}, durT_rem_long_1(i)] = DurationEpoch(long_REMEpoch_1{i},'s');
    perc_rem_long_1(i) = durT_rem_long_1(i) / durT_REM_1(i) * 100;
    dur_moyenne_rem_long_1(i) = nanmean(dur_rem_long_1{i});
    num_moyen_rem_long_1(i) = length(dur_rem_long_1{i});
    
    idx_mid_rem_1{i} = find(dur_REM_1_bis{i}>lim_short_rem_1 & dur_REM_1_bis{i}<lim_long_rem); % middle bouts
    mid_REMEpoch_1{i} = subset(and(stages_1{i}.REMEpoch,same_epoch_end_1{i}), idx_mid_rem_1{i});
    [dur_rem_mid_1{i}, durT_rem_mid_1(i)] = DurationEpoch(mid_REMEpoch_1{i},'s');
    perc_rem_mid_1(i) = durT_rem_mid_1(i) / durT_REM_1(i) * 100;
    dur_moyenne_rem_mid_1(i) = nanmean(dur_rem_mid_1{i});
    num_moyen_rem_mid_1(i) = length(dur_rem_mid_1{i});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_1{i}.Wake,same_epoch_end_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_end_1{i}),and(short_REMEpoch_1_1{i},same_epoch_end_1{i}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_short_SWS_end_1{i} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_1{i} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_1{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_1{i}.Wake,same_epoch_end_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_end_1{i}),and(mid_REMEpoch_1{i},same_epoch_end_1{i}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_mid_SWS_end_1{i} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_1{i} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_1{i} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_1{i}.Wake,same_epoch_end_1{i}),and(stages_1{i}.SWSEpoch,same_epoch_end_1{i}),and(long_REMEpoch_1{i},same_epoch_end_1{i}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_long_SWS_end_1{i} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_1{i} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_1{i} = trans_REM_to_REM;
    
    
    
    
    st_sws_1{i} = Start(stages_1{i}.SWSEpoch);
    idx_sws_1{i} = find(mindurSWS<dur_SWS_1_bis{i},1,'first');
    latency_sws_1{i} =  st_sws_1{i}(idx_sws_1{i});
    
    
    st_rem_1{i} = Start(stages_1{i}.REMEpoch);
    idx_rem_1{i} = find(mindurREM<dur_REM_1_bis{i},1,'first');
    latency_rem_1{i} =  st_rem_1{i}(idx_rem_1{i});
end

%% compute average - 1 group (mCherry saline injection 10h)
%%percentage/duration/number
for i=1:length(dur_REM_1)
    %%ALL SESSION
    data_dur_REM_1(i,:) = dur_REM_1{i}; data_dur_REM_1(isnan(data_dur_REM_1)==1)=0;
    data_dur_SWS_1(i,:) = dur_SWS_1{i}; data_dur_SWS_1(isnan(data_dur_SWS_1)==1)=0;
    data_dur_WAKE_1(i,:) = dur_WAKE_1{i}; data_dur_WAKE_1(isnan(data_dur_WAKE_1)==1)=0;
    data_dur_totSleep_1(i,:) = dur_totSleep_1{i}; data_dur_totSleep_1(isnan(data_dur_totSleep_1)==1)=0;
    
    data_num_REM_1(i,:) = num_REM_1{i};data_num_REM_1(isnan(data_num_REM_1)==1)=0;
    data_num_SWS_1(i,:) = num_SWS_1{i}; data_num_SWS_1(isnan(data_num_SWS_1)==1)=0;
    data_num_WAKE_1(i,:) = num_WAKE_1{i}; data_num_WAKE_1(isnan(data_num_WAKE_1)==1)=0;
    data_num_totSleep_1(i,:) = num_totSleep_1{i}; data_num_totSleep_1(isnan(data_num_totSleep_1)==1)=0;
    
    data_perc_REM_1(i,:) = perc_REM_1{i}; data_perc_REM_1(isnan(data_perc_REM_1)==1)=0;
    data_perc_SWS_1(i,:) = perc_SWS_1{i}; data_perc_SWS_1(isnan(data_perc_SWS_1)==1)=0;
    data_perc_WAKE_1(i,:) = perc_WAKE_1{i}; data_perc_WAKE_1(isnan(data_perc_WAKE_1)==1)=0;
    data_perc_totSleep_1(i,:) = perc_totSleep_1{i}; data_perc_totSleep_1(isnan(data_perc_totSleep_1)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_1(i,:) = dur_REM_begin_1{i}; data_dur_REM_begin_1(isnan(data_dur_REM_begin_1)==1)=0;
    data_dur_SWS_begin_1(i,:) = dur_SWS_begin_1{i}; data_dur_SWS_begin_1(isnan(data_dur_SWS_begin_1)==1)=0;
    data_dur_WAKE_begin_1(i,:) = dur_WAKE_begin_1{i}; data_dur_WAKE_begin_1(isnan(data_dur_WAKE_begin_1)==1)=0;
    data_dur_totSleep_begin_1(i,:) = dur_totSleep_begin_1{i}; data_dur_totSleep_begin_1(isnan(data_dur_totSleep_begin_1)==1)=0;
    
    data_num_REM_begin_1(i,:) = num_REM_begin_1{i};data_num_REM_begin_1(isnan(data_num_REM_begin_1)==1)=0;
    data_num_SWS_begin_1(i,:) = num_SWS_begin_1{i}; data_num_SWS_begin_1(isnan(data_num_SWS_begin_1)==1)=0;
    data_num_WAKE_begin_1(i,:) = num_WAKE_begin_1{i}; data_num_WAKE_begin_1(isnan(data_num_WAKE_begin_1)==1)=0;
    data_num_totSleep_begin_1(i,:) = num_totSleep_begin_1{i}; data_num_totSleep_begin_1(isnan(data_num_totSleep_begin_1)==1)=0;
    
    data_perc_REM_begin_1(i,:) = perc_REM_begin_1{i}; data_perc_REM_begin_1(isnan(data_perc_REM_begin_1)==1)=0;
    data_perc_SWS_begin_1(i,:) = perc_SWS_begin_1{i}; data_perc_SWS_begin_1(isnan(data_perc_SWS_begin_1)==1)=0;
    data_perc_WAKE_begin_1(i,:) = perc_WAKE_begin_1{i}; data_perc_WAKE_begin_1(isnan(data_perc_WAKE_begin_1)==1)=0;
    data_perc_totSleep_begin_1(i,:) = perc_totSleep_begin_1{i}; data_perc_totSleep_begin_1(isnan(data_perc_totSleep_begin_1)==1)=0;
    
    data_durT_REM_begin_1(i,:) = durT_REM_begin_1(i); data_durT_REM_begin_1(isnan(data_durT_REM_begin_1)==1)=0;
    data_durT_SWS_begin_1(i,:) = durT_SWS_begin_1(i); data_durT_SWS_begin_1(isnan(data_durT_SWS_begin_1)==1)=0;
    data_durT_WAKE_begin_1(i,:) = durT_WAKE_begin_1(i); data_durT_WAKE_begin_1(isnan(data_durT_WAKE_begin_1)==1)=0;
    
    
    %interperiod
    data_dur_REM_interPeriod_1(i,:) = dur_REM_interPeriod_1{i}; data_dur_REM_interPeriod_1(isnan(data_dur_REM_interPeriod_1)==1)=0;
    data_dur_SWS_interPeriod_1(i,:) = dur_SWS_interPeriod_1{i}; data_dur_SWS_interPeriod_1(isnan(data_dur_SWS_interPeriod_1)==1)=0;
    data_dur_WAKE_interPeriod_1(i,:) = dur_WAKE_interPeriod_1{i}; data_dur_WAKE_interPeriod_1(isnan(data_dur_WAKE_interPeriod_1)==1)=0;
    data_dur_totSleep_interPeriod_1(i,:) = dur_totSleep_interPeriod_1{i}; data_dur_totSleep_interPeriod_1(isnan(data_dur_totSleep_interPeriod_1)==1)=0;
    
    data_num_REM_interPeriod_1(i,:) = num_REM_interPeriod_1{i};data_num_REM_interPeriod_1(isnan(data_num_REM_interPeriod_1)==1)=0;
    data_num_SWS_interPeriod_1(i,:) = num_SWS_interPeriod_1{i}; data_num_SWS_interPeriod_1(isnan(data_num_SWS_interPeriod_1)==1)=0;
    data_num_WAKE_interPeriod_1(i,:) = num_WAKE_interPeriod_1{i}; data_num_WAKE_interPeriod_1(isnan(data_num_WAKE_interPeriod_1)==1)=0;
    data_num_totSleep_interPeriod_1(i,:) = num_totSleep_interPeriod_1{i}; data_num_totSleep_interPeriod_1(isnan(data_num_totSleep_interPeriod_1)==1)=0;
    
    data_perc_REM_interPeriod_1(i,:) = perc_REM_interPeriod_1{i}; data_perc_REM_interPeriod_1(isnan(data_perc_REM_interPeriod_1)==1)=0;
    data_perc_SWS_interPeriod_1(i,:) = perc_SWS_interPeriod_1{i}; data_perc_SWS_interPeriod_1(isnan(data_perc_SWS_interPeriod_1)==1)=0;
    data_perc_WAKE_interPeriod_1(i,:) = perc_WAKE_interPeriod_1{i}; data_perc_WAKE_interPeriod_1(isnan(data_perc_WAKE_interPeriod_1)==1)=0;
    data_perc_totSleep_interPeriod_1(i,:) = perc_totSleep_interPeriod_1{i}; data_perc_totSleep_interPeriod_1(isnan(data_perc_totSleep_interPeriod_1)==1)=0;
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_1(i,:) = dur_REM_end_1{i}; data_dur_REM_end_1(isnan(data_dur_REM_end_1)==1)=0;
    data_dur_SWS_end_1(i,:) = dur_SWS_end_1{i}; data_dur_SWS_end_1(isnan(data_dur_SWS_end_1)==1)=0;
    data_dur_WAKE_end_1(i,:) = dur_WAKE_end_1{i}; data_dur_WAKE_end_1(isnan(data_dur_WAKE_end_1)==1)=0;
    data_dur_totSleep_end_1(i,:) = dur_totSleep_end_1{i}; data_dur_totSleep_end_1(isnan(data_dur_totSleep_end_1)==1)=0;
    
    data_num_REM_end_1(i,:) = num_REM_end_1{i};data_num_REM_end_1(isnan(data_num_REM_end_1)==1)=0;
    data_num_SWS_end_1(i,:) = num_SWS_end_1{i}; data_num_SWS_end_1(isnan(data_num_SWS_end_1)==1)=0;
    data_num_WAKE_end_1(i,:) = num_WAKE_end_1{i}; data_num_WAKE_end_1(isnan(data_num_WAKE_end_1)==1)=0;
    data_num_totSleep_end_1(i,:) = num_totSleep_end_1{i}; data_num_totSleep_end_1(isnan(data_num_totSleep_end_1)==1)=0;
    
    data_perc_REM_end_1(i,:) = perc_REM_end_1{i}; data_perc_REM_end_1(isnan(data_perc_REM_end_1)==1)=0;
    data_perc_SWS_end_1(i,:) = perc_SWS_end_1{i}; data_perc_SWS_end_1(isnan(data_perc_SWS_end_1)==1)=0;
    data_perc_WAKE_end_1(i,:) = perc_WAKE_end_1{i}; data_perc_WAKE_end_1(isnan(data_perc_WAKE_end_1)==1)=0;
    data_perc_totSleep_end_1(i,:) = perc_totSleep_end_1{i}; data_perc_totSleep_end_1(isnan(data_perc_totSleep_end_1)==1)=0;
    
end
%% probability
for i=1:length(all_trans_REM_short_WAKE_end_1)
%     %%ALL SESSION
%     data_REM_REM_1(i,:) = all_trans_REM_REM_1{i}; data_REM_REM_1(isnan(data_REM_REM_1)==1)=0;
%     data_REM_SWS_1(i,:) = all_trans_REM_SWS_1{i}; data_REM_SWS_1(isnan(data_REM_SWS_1)==1)=0;
%     data_REM_WAKE_1(i,:) = all_trans_REM_WAKE_1{i}; data_REM_WAKE_1(isnan(data_REM_WAKE_1)==1)=0;
%
%     data_SWS_SWS_1(i,:) = all_trans_SWS_SWS_1{i}; data_SWS_SWS_1(isnan(data_SWS_SWS_1)==1)=0;
%     data_SWS_REM_1(i,:) = all_trans_SWS_REM_1{i}; data_SWS_REM_1(isnan(data_SWS_REM_1)==1)=0;
%     data_SWS_WAKE_1(i,:) = all_trans_SWS_WAKE_1{i}; data_SWS_WAKE_1(isnan(data_SWS_WAKE_1)==1)=0;
%
%     data_WAKE_WAKE_1(i,:) = all_trans_WAKE_WAKE_1{i}; data_WAKE_WAKE_1(isnan(data_WAKE_WAKE_1)==1)=0;
%     data_WAKE_REM_1(i,:) = all_trans_WAKE_REM_1{i}; data_WAKE_REM_1(isnan(data_WAKE_REM_1)==1)=0;
%     data_WAKE_SWS_1(i,:) = all_trans_WAKE_SWS_1{i}; data_WAKE_SWS_1(isnan(data_WAKE_SWS_1)==1)=0;
%
%     %%3 PREMI7RES HEURES
%         data_REM_REM_begin_1(i,:) = all_trans_REM_REM_begin_1{i}; data_REM_REM_begin_1(isnan(data_REM_REM_begin_1)==1)=0;
%     data_REM_SWS_begin_1(i,:) = all_trans_REM_SWS_begin_1{i}; data_REM_SWS_begin_1(isnan(data_REM_SWS_begin_1)==1)=0;
%     data_REM_WAKE_begin_1(i,:) = all_trans_REM_WAKE_begin_1{i}; data_REM_WAKE_begin_1(isnan(data_REM_WAKE_begin_1)==1)=0;
%
%     data_SWS_SWS_begin_1(i,:) = all_trans_SWS_SWS_begin_1{i}; data_SWS_SWS_begin_1(isnan(data_SWS_SWS_begin_1)==1)=0;
%     data_SWS_REM_begin_1(i,:) = all_trans_SWS_REM_begin_1{i}; data_SWS_REM_begin_1(isnan(data_SWS_REM_begin_1)==1)=0;
%     data_SWS_WAKE_begin_1(i,:) = all_trans_SWS_WAKE_begin_1{i}; data_SWS_WAKE_begin_1(isnan(data_SWS_WAKE_begin_1)==1)=0;
%
%     data_WAKE_WAKE_begin_1(i,:) = all_trans_WAKE_WAKE_begin_1{i}; data_WAKE_WAKE_begin_1(isnan(data_WAKE_WAKE_begin_1)==1)=0;
%     data_WAKE_REM_begin_1(i,:) = all_trans_WAKE_REM_begin_1{i}; data_WAKE_REM_begin_1(isnan(data_WAKE_REM_begin_1)==1)=0;
%     data_WAKE_SWS_begin_1(i,:) = all_trans_WAKE_SWS_begin_1{i}; data_WAKE_SWS_begin_1(isnan(data_WAKE_SWS_begin_1)==1)=0;
%
%     %%FIN DE LA SESSION
%         data_REM_REM_end_1(i,:) = all_trans_REM_REM_end_1{i}; data_REM_REM_end_1(isnan(data_REM_REM_end_1)==1)=0;
%     data_REM_SWS_end_1(i,:) = all_trans_REM_SWS_end_1{i}; data_REM_SWS_end_1(isnan(data_REM_SWS_end_1)==1)=0;
%     data_REM_WAKE_end_1(i,:) = all_trans_REM_WAKE_end_1{i}; data_REM_WAKE_end_1(isnan(data_REM_WAKE_end_1)==1)=0;
%
%     data_SWS_SWS_end_1(i,:) = all_trans_SWS_SWS_end_1{i}; data_SWS_SWS_end_1(isnan(data_SWS_SWS_end_1)==1)=0;
%     data_SWS_REM_end_1(i,:) = all_trans_SWS_REM_end_1{i}; data_SWS_REM_end_1(isnan(data_SWS_REM_end_1)==1)=0;
%     data_SWS_WAKE_end_1(i,:) = all_trans_SWS_WAKE_end_1{i}; data_SWS_WAKE_end_1(isnan(data_SWS_WAKE_end_1)==1)=0;
%
%     data_WAKE_WAKE_end_1(i,:) = all_trans_WAKE_WAKE_end_1{i}; data_WAKE_WAKE_end_1(isnan(data_WAKE_WAKE_end_1)==1)=0;
%     data_WAKE_REM_end_1(i,:) = all_trans_WAKE_REM_end_1{i}; data_WAKE_REM_end_1(isnan(data_WAKE_REM_end_1)==1)=0;
%     data_WAKE_SWS_end_1(i,:) = all_trans_WAKE_SWS_end_1{i}; data_WAKE_SWS_end_1(isnan(data_WAKE_SWS_end_1)==1)=0;
%
%
%
    data_REM_short_WAKE_end_1(i,:) = all_trans_REM_short_WAKE_end_1{i}; %data_REM_short_WAKE_end_1(isnan(data_REM_short_WAKE_end_1)==1)=0;
    data_REM_short_SWS_end_1(i,:) = all_trans_REM_short_SWS_end_1{i};% data_REM_short_SWS_end_1(isnan(data_REM_short_SWS_end_1)==1)=0;
    data_REM_short_REM_end_1(i,:) = all_trans_REM_short_REM_end_1{i}; %data_REM_short_WAKE_end_1(isnan(data_REM_short_WAKE_end_1)==1)=0;

    data_REM_mid_WAKE_end_1(i,:) = all_trans_REM_mid_WAKE_end_1{i}; %data_REM_mid_WAKE_end_1(isnan(data_REM_mid_WAKE_end_1)==1)=0;
    data_REM_mid_SWS_end_1(i,:) = all_trans_REM_mid_SWS_end_1{i}; %data_REM_mid_SWS_end_1(isnan(data_REM_mid_SWS_end_1)==1)=0;
    data_REM_mid_REM_end_1(i,:) = all_trans_REM_mid_REM_end_1{i}; %data_REM_mid_WAKE_end_1(isnan(data_REM_short_WAKE_end_1)==1)=0;

    data_REM_long_WAKE_end_1(i,:) = all_trans_REM_long_WAKE_end_1{i}; %data_REM_long_WAKE_end_1(isnan(data_REM_long_WAKE_end_1)==1)=0;
    data_REM_long_SWS_end_1(i,:) = all_trans_REM_long_SWS_end_1{i}; %data_REM_long_SWS_end_1(isnan(data_REM_long_SWS_end_1)==1)=0;
    data_REM_long_REM_end_1(i,:) = all_trans_REM_long_REM_end_1{i}; %data_REM_long_WAKE_end_1(isnan(data_REM_short_WAKE_end_1)==1)=0;

end






%% GET DATA - 2nd group
for k=1:length(Dir_2.path)
    cd(Dir_2.path{k}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_2{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_2{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    same_epoch_2{k} = intervalSet(0,time_end);
    same_epoch_begin_2{k} = intervalSet(time_st,time_mid_end_first_period);
    same_epoch_end_2{k} = intervalSet(time_mid_end_snd_period,time_end);
    same_epoch_interPeriod_2{k} = intervalSet(time_mid_end_first_period,time_mid_end_snd_period);
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_2{k}.Wake,same_epoch_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_2{k}),and(stages_2{k}.REMEpoch,same_epoch_2{k}),'wake',tempbin,time_st,time_end);
    dur_WAKE_2{k}=dur_moyenne_ep_WAKE;
    num_WAKE_2{k}=num_moyen_ep_WAKE;
    perc_WAKE_2{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_2{k}.Wake,same_epoch_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_2{k}),and(stages_2{k}.REMEpoch,same_epoch_2{k}),'sws',tempbin,time_st,time_end);
    dur_SWS_2{k}=dur_moyenne_ep_SWS;
    num_SWS_2{k}=num_moyen_ep_SWS;
    perc_SWS_2{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_2{k}.Wake,same_epoch_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_2{k}),and(stages_2{k}.REMEpoch,same_epoch_2{k}),'rem',tempbin,time_st,time_end);
    dur_REM_2{k}=dur_moyenne_ep_REM;
    num_REM_2{k}=num_moyen_ep_REM;
    perc_REM_2{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_2{k}.Wake,same_epoch_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_2{k}),and(stages_2{k}.REMEpoch,same_epoch_2{k}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_2{k}=dur_moyenne_ep_totSleep;
    num_totSleep_2{k}=num_moyen_ep_totSleep;
    perc_totSleep_2{k}=perc_moyen_totSleep;
    
    
    %%3 PREMIERES HEUES
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_begin_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_begin_2{k}),and(stages_2{k}.REMEpoch,same_epoch_begin_2{k}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_2{k}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_2{k}=num_moyen_ep_WAKE;
    perc_WAKE_begin_2{k}=perc_moyen_WAKE;
    [dur_WAKE_begin_2_bis{k}, durT_WAKE_begin_2(k)]=DurationEpoch(and(stages_2{k}.Wake,same_epoch_begin_2{k}),'min');

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_begin_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_begin_2{k}),and(stages_2{k}.REMEpoch,same_epoch_begin_2{k}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_2{k}=dur_moyenne_ep_SWS;
    num_SWS_begin_2{k}=num_moyen_ep_SWS;
    perc_SWS_begin_2{k}=perc_moyen_SWS;
    [dur_SWS_begin_2_bis{k}, durT_SWS_begin_2(k)]=DurationEpoch(and(stages_2{k}.SWSEpoch,same_epoch_begin_2{k}),'min');

    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_begin_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_begin_2{k}),and(stages_2{k}.REMEpoch,same_epoch_begin_2{k}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_2{k}=dur_moyenne_ep_REM;
    num_REM_begin_2{k}=num_moyen_ep_REM;
    perc_REM_begin_2{k}=perc_moyen_REM;
    [dur_REM_begin_2_bis{k}, durT_REM_begin_2(k)]=DurationEpoch(and(stages_2{k}.REMEpoch,same_epoch_begin_2{k}),'min');
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_begin_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_begin_2{k}),and(stages_2{k}.REMEpoch,same_epoch_begin_2{k}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_2{k}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_2{k}=num_moyen_ep_totSleep;
    perc_totSleep_begin_2{k}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_2{k}.Wake,same_epoch_begin_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_begin_2{k}),and(stages_2{k}.REMEpoch,same_epoch_begin_2{k}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_2{k} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_2{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_2{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_2{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_2{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_2{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_2{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_2{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_2{k} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_interPeriod_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_interPeriod_2{k}),and(stages_2{k}.REMEpoch,same_epoch_interPeriod_2{k}),'wake',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_WAKE_interPeriod_2{k}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_2{k}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_2{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_interPeriod_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_interPeriod_2{k}),and(stages_2{k}.REMEpoch,same_epoch_interPeriod_2{k}),'sws',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_SWS_interPeriod_2{k}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_2{k}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_2{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_interPeriod_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_interPeriod_2{k}),and(stages_2{k}.REMEpoch,same_epoch_interPeriod_2{k}),'rem',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_REM_interPeriod_2{k}=dur_moyenne_ep_REM;
    num_REM_interPeriod_2{k}=num_moyen_ep_REM;
    perc_REM_interPeriod_2{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_interPeriod_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_interPeriod_2{k}),and(stages_2{k}.REMEpoch,same_epoch_interPeriod_2{k}),'sleep',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_totSleep_interPeriod_2{k}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_2{k}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_2{k}=perc_moyen_totSleep;
    
    
    %%3H POST JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_end_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_end_2{k}),and(stages_2{k}.REMEpoch,same_epoch_end_2{k}),'wake',tempbin,time_mid_end_snd_period,time_end);
    dur_WAKE_end_2{k}=dur_moyenne_ep_WAKE;
    num_WAKE_end_2{k}=num_moyen_ep_WAKE;
    perc_WAKE_end_2{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_end_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_end_2{k}),and(stages_2{k}.REMEpoch,same_epoch_end_2{k}),'sws',tempbin,time_mid_end_snd_period,time_end);
    dur_SWS_end_2{k}=dur_moyenne_ep_SWS;
    num_SWS_end_2{k}=num_moyen_ep_SWS;
    perc_SWS_end_2{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_end_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_end_2{k}),and(stages_2{k}.REMEpoch,same_epoch_end_2{k}),'rem',tempbin,time_mid_end_snd_period,time_end);
    dur_REM_end_2{k}=dur_moyenne_ep_REM;
    num_REM_end_2{k}=num_moyen_ep_REM;
    perc_REM_end_2{k}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_2{k}.Wake,same_epoch_end_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_end_2{k}),and(stages_2{k}.REMEpoch,same_epoch_end_2{k}),'sleep',tempbin,time_mid_end_snd_period,time_end);
    dur_totSleep_end_2{k}=dur_moyenne_ep_totSleep;
    num_totSleep_end_2{k}=num_moyen_ep_totSleep;
    perc_totSleep_end_2{k}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_2{k}.Wake,same_epoch_end_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_end_2{k}),and(stages_2{k}.REMEpoch,same_epoch_end_2{k}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_REM_end_2{k} = trans_REM_to_REM;
    all_trans_REM_SWS_end_2{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_2{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_2{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_2{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_2{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_2{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_2{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_2{k} = trans_WAKE_to_WAKE;
   
    %%Short versus long REM bouts
    [dur_WAKE_2_bis{k}, durT_WAKE_2(k)]=DurationEpoch(and(stages_2{k}.Wake,same_epoch_end_2{k}),'s');
    [dur_SWS_2_bis{k}, durT_SWS_2(k)]=DurationEpoch(and(stages_2{k}.SWSEpoch,same_epoch_end_2{k}),'s');
    [dur_REM_2_bis{k}, durT_REM_2(k)]=DurationEpoch(and(stages_2{k}.REMEpoch,same_epoch_end_2{k}),'s');
    
    idx_short_rem_2_1{k} = find(dur_REM_2_bis{k}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_2_1{k} = subset(and(stages_2{k}.REMEpoch,same_epoch_end_2{k}), idx_short_rem_2_1{k});
    [dur_rem_short_2_1{k}, durT_rem_short_2(k)] = DurationEpoch(short_REMEpoch_2_1{k},'s');
    perc_rem_short_2_1(k) = durT_rem_short_2(k) / durT_REM_2(k) * 100;
    dur_moyenne_rem_short_2_1(k) = nanmean(dur_rem_short_2_1{k});
    num_moyen_rem_short_2_1(k) = length(dur_rem_short_2_1{k});
    
    idx_short_rem_2_2{k} = find(dur_REM_2_bis{k}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_2_2{k} = subset(and(stages_2{k}.REMEpoch,same_epoch_end_2{k}), idx_short_rem_2_2{k});
    [dur_rem_short_2_2{k}, durT_rem_short_2(k)] = DurationEpoch(short_REMEpoch_2_2{k},'s');
    perc_rem_short_2_2(k) = durT_rem_short_2(k) / durT_REM_2(k) * 100;
    dur_moyenne_rem_short_2_2(k) = nanmean(dur_rem_short_2_2{k});
    num_moyen_rem_short_2_2(k) = length(dur_rem_short_2_2{k});
    
    idx_short_rem_2_3{k} = find(dur_REM_2_bis{k}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_2_3{k} = subset(and(stages_2{k}.REMEpoch,same_epoch_end_2{k}), idx_short_rem_2_3{k});
    [dur_rem_short_2_3{k}, durT_rem_short_2(k)] = DurationEpoch(short_REMEpoch_2_3{k},'s');
    perc_rem_short_2_3(k) = durT_rem_short_2(k) / durT_REM_2(k) * 100;
    dur_moyenne_rem_short_2_3(k) = nanmean(dur_rem_short_2_3{k});
    num_moyen_rem_short_2_3(k) = length(dur_rem_short_2_3{k});
    
    idx_long_rem_2{k} = find(dur_REM_2_bis{k}>lim_long_rem); %long bout
    long_REMEpoch_2{k} = subset(and(stages_2{k}.REMEpoch,same_epoch_end_2{k}), idx_long_rem_2{k});
    [dur_rem_long_2{k}, durT_rem_long_2(k)] = DurationEpoch(long_REMEpoch_2{k},'s');
    perc_rem_long_2(k) = durT_rem_long_2(k) / durT_REM_2(k) * 100;
    dur_moyenne_rem_long_2(k) = nanmean(dur_rem_long_2{k});
    num_moyen_rem_long_2(k) = length(dur_rem_long_2{k});
    
    idx_mid_rem_2{k} = find(dur_REM_2_bis{k}>lim_short_rem_1 & dur_REM_2_bis{k}<lim_long_rem); % middle bouts
    mid_REMEpoch_2{k} = subset(and(stages_2{k}.REMEpoch,same_epoch_end_2{k}), idx_mid_rem_2{k});
    [dur_rem_mid_2{k}, durT_rem_mid_2(k)] = DurationEpoch(mid_REMEpoch_2{k},'s');
    perc_rem_mid_2(k) = durT_rem_mid_2(k) / durT_REM_2(k) * 100;
    dur_moyenne_rem_mid_2(k) = nanmean(dur_rem_mid_2{k});
    num_moyen_rem_mid_2(k) = length(dur_rem_mid_2{k});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_2{k}.Wake,same_epoch_end_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_end_2{k}),and(short_REMEpoch_2_1{k},same_epoch_end_2{k}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_short_SWS_end_2{k} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_2{k} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_2{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_2{k}.Wake,same_epoch_end_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_end_2{k}),and(mid_REMEpoch_2{k},same_epoch_end_2{k}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_mid_SWS_end_2{k} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_2{k} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_2{k} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_2{k}.Wake,same_epoch_end_2{k}),and(stages_2{k}.SWSEpoch,same_epoch_end_2{k}),and(long_REMEpoch_2{k},same_epoch_end_2{k}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_long_SWS_end_2{k} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_2{k} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_2{k} = trans_REM_to_REM;
    
        st_sws_2{k} = Start(stages_2{k}.SWSEpoch);
    idx_sws_2{k} = find(mindurSWS<dur_SWS_2_bis{k},1,'first');
    latency_sws_2{k} =  st_sws_2{k}(idx_sws_2{k});
    
    
    st_rem_2{k} = Start(stages_2{k}.REMEpoch);
    idx_rem_2{k} = find(mindurREM<dur_REM_2_bis{k},1,'first');
    latency_rem_2{k} =  st_rem_2{k}(idx_rem_2{k});
    
end

%% compute average - 2nd group
%%percentage/duration/number
for k=1:length(dur_REM_2)
    %%ALL SESSION
    data_dur_REM_2(k,:) = dur_REM_2{k}; data_dur_REM_2(isnan(data_dur_REM_2)==1)=0;
    data_dur_SWS_2(k,:) = dur_SWS_2{k}; data_dur_SWS_2(isnan(data_dur_SWS_2)==1)=0;
    data_dur_WAKE_2(k,:) = dur_WAKE_2{k}; data_dur_WAKE_2(isnan(data_dur_WAKE_2)==1)=0;
    data_dur_totSleep_2(k,:) = dur_totSleep_2{k}; data_dur_totSleep_2(isnan(data_dur_totSleep_2)==1)=0;
    
    data_num_REM_2(k,:) = num_REM_2{k};data_num_REM_2(isnan(data_num_REM_2)==1)=0;
    data_num_SWS_2(k,:) = num_SWS_2{k}; data_num_SWS_2(isnan(data_num_SWS_2)==1)=0;
    data_num_WAKE_2(k,:) = num_WAKE_2{k}; data_num_WAKE_2(isnan(data_num_WAKE_2)==1)=0;
    data_num_totSleep_2(k,:) = num_totSleep_2{k}; data_num_totSleep_2(isnan(data_num_totSleep_2)==1)=0;
    
    data_perc_REM_2(k,:) = perc_REM_2{k}; data_perc_REM_2(isnan(data_perc_REM_2)==1)=0;
    data_perc_SWS_2(k,:) = perc_SWS_2{k}; data_perc_SWS_2(isnan(data_perc_SWS_2)==1)=0;
    data_perc_WAKE_2(k,:) = perc_WAKE_2{k}; data_perc_WAKE_2(isnan(data_perc_WAKE_2)==1)=0;
    data_perc_totSleep_2(k,:) = perc_totSleep_2{k}; data_perc_totSleep_2(isnan(data_perc_totSleep_2)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_2(k,:) = dur_REM_begin_2{k}; data_dur_REM_begin_2(isnan(data_dur_REM_begin_2)==1)=0;
    data_dur_SWS_begin_2(k,:) = dur_SWS_begin_2{k}; data_dur_SWS_begin_2(isnan(data_dur_SWS_begin_2)==1)=0;
    data_dur_WAKE_begin_2(k,:) = dur_WAKE_begin_2{k}; data_dur_WAKE_begin_2(isnan(data_dur_WAKE_begin_2)==1)=0;
    data_dur_totSleep_begin_2(k,:) = dur_totSleep_begin_2{k}; data_dur_totSleep_begin_2(isnan(data_dur_totSleep_begin_2)==1)=0;
    
    
    data_num_REM_begin_2(k,:) = num_REM_begin_2{k};data_num_REM_begin_2(isnan(data_num_REM_begin_2)==1)=0;
    data_num_SWS_begin_2(k,:) = num_SWS_begin_2{k}; data_num_SWS_begin_2(isnan(data_num_SWS_begin_2)==1)=0;
    data_num_WAKE_begin_2(k,:) = num_WAKE_begin_2{k}; data_num_WAKE_begin_2(isnan(data_num_WAKE_begin_2)==1)=0;
    data_num_totSleep_begin_2(k,:) = num_totSleep_begin_2{k}; data_num_totSleep_begin_2(isnan(data_num_totSleep_begin_2)==1)=0;
    
    data_perc_REM_begin_2(k,:) = perc_REM_begin_2{k}; data_perc_REM_begin_2(isnan(data_perc_REM_begin_2)==1)=0;
    data_perc_SWS_begin_2(k,:) = perc_SWS_begin_2{k}; data_perc_SWS_begin_2(isnan(data_perc_SWS_begin_2)==1)=0;
    data_perc_WAKE_begin_2(k,:) = perc_WAKE_begin_2{k}; data_perc_WAKE_begin_2(isnan(data_perc_WAKE_begin_2)==1)=0;
    data_perc_totSleep_begin_2(k,:) = perc_totSleep_begin_2{k}; data_perc_totSleep_begin_2(isnan(data_perc_totSleep_begin_2)==1)=0;
    
    data_durT_REM_begin_2(k,:) = durT_REM_begin_2(k); data_durT_REM_begin_2(isnan(data_durT_REM_begin_2)==1)=0;
    data_durT_SWS_begin_2(k,:) = durT_SWS_begin_2(k); data_durT_SWS_begin_2(isnan(data_durT_SWS_begin_2)==1)=0;
    data_durT_WAKE_begin_2(k,:) = durT_WAKE_begin_2(k); data_durT_WAKE_begin_2(isnan(data_durT_WAKE_begin_2)==1)=0;
    
    %%second period
    data_dur_REM_interPeriod_2(k,:) = dur_REM_interPeriod_2{k}; data_dur_REM_interPeriod_2(isnan(data_dur_REM_interPeriod_2)==1)=0;
    data_dur_SWS_interPeriod_2(k,:) = dur_SWS_interPeriod_2{k}; data_dur_SWS_interPeriod_2(isnan(data_dur_SWS_interPeriod_2)==1)=0;
    data_dur_WAKE_interPeriod_2(k,:) = dur_WAKE_interPeriod_2{k}; data_dur_WAKE_interPeriod_2(isnan(data_dur_WAKE_interPeriod_2)==1)=0;
    data_dur_totSleep_interPeriod_2(k,:) = dur_totSleep_interPeriod_2{k}; data_dur_totSleep_interPeriod_2(isnan(data_dur_totSleep_interPeriod_2)==1)=0;
    
    
    data_num_REM_interPeriod_2(k,:) = num_REM_interPeriod_2{k};data_num_REM_interPeriod_2(isnan(data_num_REM_interPeriod_2)==1)=0;
    data_num_SWS_interPeriod_2(k,:) = num_SWS_interPeriod_2{k}; data_num_SWS_interPeriod_2(isnan(data_num_SWS_interPeriod_2)==1)=0;
    data_num_WAKE_interPeriod_2(k,:) = num_WAKE_interPeriod_2{k}; data_num_WAKE_interPeriod_2(isnan(data_num_WAKE_interPeriod_2)==1)=0;
    data_num_totSleep_interPeriod_2(k,:) = num_totSleep_interPeriod_2{k}; data_num_totSleep_interPeriod_2(isnan(data_num_totSleep_interPeriod_2)==1)=0;
    
    data_perc_REM_interPeriod_2(k,:) = perc_REM_interPeriod_2{k}; data_perc_REM_interPeriod_2(isnan(data_perc_REM_interPeriod_2)==1)=0;
    data_perc_SWS_interPeriod_2(k,:) = perc_SWS_interPeriod_2{k}; data_perc_SWS_interPeriod_2(isnan(data_perc_SWS_interPeriod_2)==1)=0;
    data_perc_WAKE_interPeriod_2(k,:) = perc_WAKE_interPeriod_2{k}; data_perc_WAKE_interPeriod_2(isnan(data_perc_WAKE_interPeriod_2)==1)=0;
    data_perc_totSleep_interPeriod_2(k,:) = perc_totSleep_interPeriod_2{k}; data_perc_totSleep_interPeriod_2(isnan(data_perc_totSleep_interPeriod_2)==1)=0;
    
    %%FIN DE LA SESSION
    data_dur_REM_end_2(k,:) = dur_REM_end_2{k}; data_dur_REM_end_2(isnan(data_dur_REM_end_2)==1)=0;
    data_dur_SWS_end_2(k,:) = dur_SWS_end_2{k}; data_dur_SWS_end_2(isnan(data_dur_SWS_end_2)==1)=0;
    data_dur_WAKE_end_2(k,:) = dur_WAKE_end_2{k}; data_dur_WAKE_end_2(isnan(data_dur_WAKE_end_2)==1)=0;
    data_dur_totSleep_end_2(k,:) = dur_totSleep_end_2{k}; data_dur_totSleep_end_2(isnan(data_dur_totSleep_end_2)==1)=0;
    
    
    data_num_REM_end_2(k,:) = num_REM_end_2{k};data_num_REM_end_2(isnan(data_num_REM_end_2)==1)=0;
    data_num_SWS_end_2(k,:) = num_SWS_end_2{k}; data_num_SWS_end_2(isnan(data_num_SWS_end_2)==1)=0;
    data_num_WAKE_end_2(k,:) = num_WAKE_end_2{k}; data_num_WAKE_end_2(isnan(data_num_WAKE_end_2)==1)=0;
    data_num_totSleep_end_2(k,:) = num_totSleep_end_2{k}; data_num_totSleep_end_2(isnan(data_num_totSleep_end_2)==1)=0;
    
    
    data_perc_REM_end_2(k,:) = perc_REM_end_2{k}; data_perc_REM_end_2(isnan(data_perc_REM_end_2)==1)=0;
    data_perc_SWS_end_2(k,:) = perc_SWS_end_2{k}; data_perc_SWS_end_2(isnan(data_perc_SWS_end_2)==1)=0;
    data_perc_WAKE_end_2(k,:) = perc_WAKE_end_2{k}; data_perc_WAKE_end_2(isnan(data_perc_WAKE_end_2)==1)=0;
    data_perc_totSleep_end_2(k,:) = perc_totSleep_end_2{k}; data_perc_totSleep_end_2(isnan(data_perc_totSleep_end_2)==1)=0;
    
end
%%
%probability
for k=1:length(all_trans_REM_short_WAKE_end_2)
    %     %%ALL SESSION
    %     data_REM_REM_2(k,:) = all_trans_REM_REM_2{k}; data_REM_REM_2(isnan(data_REM_REM_2)==1)=0;
    %     data_REM_SWS_2(k,:) = all_trans_REM_SWS_2{k}; data_REM_SWS_2(isnan(data_REM_SWS_2)==1)=0;
    %     data_REM_WAKE_2(k,:) = all_trans_REM_WAKE_2{k}; data_REM_WAKE_2(isnan(data_REM_WAKE_2)==1)=0;
    %
    %     data_SWS_SWS_2(k,:) = all_trans_SWS_SWS_2{k}; data_SWS_SWS_2(isnan(data_SWS_SWS_2)==1)=0;
    %     data_SWS_REM_2(k,:) = all_trans_SWS_REM_2{k}; data_SWS_REM_2(isnan(data_SWS_REM_2)==1)=0;
    %     data_SWS_WAKE_2(k,:) = all_trans_SWS_WAKE_2{k}; data_SWS_WAKE_2(isnan(data_SWS_WAKE_2)==1)=0;
    %
    %     data_WAKE_WAKE_2(k,:) = all_trans_WAKE_WAKE_2{k}; data_WAKE_WAKE_2(isnan(data_WAKE_WAKE_2)==1)=0;
    %     data_WAKE_REM_2(k,:) = all_trans_WAKE_REM_2{k}; data_WAKE_REM_2(isnan(data_WAKE_REM_2)==1)=0;
    %     data_WAKE_SWS_2(k,:) = all_trans_WAKE_SWS_2{k}; data_WAKE_SWS_2(isnan(data_WAKE_SWS_2)==1)=0;
    %
    %     %%3 PREMI7RES HEURES
    %         data_REM_REM_begin_2(k,:) = all_trans_REM_REM_begin_2{k}; data_REM_REM_begin_2(isnan(data_REM_REM_begin_2)==1)=0;
    %     data_REM_SWS_begin_2(k,:) = all_trans_REM_SWS_begin_2{k}; data_REM_SWS_begin_2(isnan(data_REM_SWS_begin_2)==1)=0;
    %     data_REM_WAKE_begin_2(k,:) = all_trans_REM_WAKE_begin_2{k}; data_REM_WAKE_begin_2(isnan(data_REM_WAKE_begin_2)==1)=0;
    %
    %     data_SWS_SWS_begin_2(k,:) = all_trans_SWS_SWS_begin_2{k}; data_SWS_SWS_begin_2(isnan(data_SWS_SWS_begin_2)==1)=0;
    %     data_SWS_REM_begin_2(k,:) = all_trans_SWS_REM_begin_2{k}; data_SWS_REM_begin_2(isnan(data_SWS_REM_begin_2)==1)=0;
    %     data_SWS_WAKE_begin_2(k,:) = all_trans_SWS_WAKE_begin_2{k}; data_SWS_WAKE_begin_2(isnan(data_SWS_WAKE_begin_2)==1)=0;
    %
    %     data_WAKE_WAKE_begin_2(k,:) = all_trans_WAKE_WAKE_begin_2{k}; data_WAKE_WAKE_begin_2(isnan(data_WAKE_WAKE_begin_2)==1)=0;
    %     data_WAKE_REM_begin_2(k,:) = all_trans_WAKE_REM_begin_2{k}; data_WAKE_REM_begin_2(isnan(data_WAKE_REM_begin_2)==1)=0;
    %     data_WAKE_SWS_begin_2(k,:) = all_trans_WAKE_SWS_begin_2{k}; data_WAKE_SWS_begin_2(isnan(data_WAKE_SWS_begin_2)==1)=0;
    %
    %     %%FIN DE LA SESSION
    %         data_REM_REM_end_2(k,:) = all_trans_REM_REM_end_2{k}; data_REM_REM_end_2(isnan(data_REM_REM_end_2)==1)=0;
    %     data_REM_SWS_end_2(k,:) = all_trans_REM_SWS_end_2{k}; data_REM_SWS_end_2(isnan(data_REM_SWS_end_2)==1)=0;
    %     data_REM_WAKE_end_2(k,:) = all_trans_REM_WAKE_end_2{k}; data_REM_WAKE_end_2(isnan(data_REM_WAKE_end_2)==1)=0;
    %
    %     data_SWS_SWS_end_2(k,:) = all_trans_SWS_SWS_end_2{k}; data_SWS_SWS_end_2(isnan(data_SWS_SWS_end_2)==1)=0;
    %     data_SWS_REM_end_2(k,:) = all_trans_SWS_REM_end_2{k}; data_SWS_REM_end_2(isnan(data_SWS_REM_end_2)==1)=0;
    %     data_SWS_WAKE_end_2(k,:) = all_trans_SWS_WAKE_end_2{k}; data_SWS_WAKE_end_2(isnan(data_SWS_WAKE_end_2)==1)=0;
    %
    %     data_WAKE_WAKE_end_2(k,:) = all_trans_WAKE_WAKE_end_2{k}; data_WAKE_WAKE_end_2(isnan(data_WAKE_WAKE_end_2)==1)=0;
    %     data_WAKE_REM_end_2(k,:) = all_trans_WAKE_REM_end_2{k}; data_WAKE_REM_end_2(isnan(data_WAKE_REM_end_2)==1)=0;
    %     data_WAKE_SWS_end_2(k,:) = all_trans_WAKE_SWS_end_2{k}; data_WAKE_SWS_end_2(isnan(data_WAKE_SWS_end_2)==1)=0;
    %
    data_REM_short_WAKE_end_2(k,:) = all_trans_REM_short_WAKE_end_2{k}; data_REM_short_WAKE_end_2(isnan(data_REM_short_WAKE_end_2)==1)=0;
    data_REM_short_SWS_end_2(k,:) = all_trans_REM_short_SWS_end_2{k}; data_REM_short_SWS_end_2(isnan(data_REM_short_SWS_end_2)==1)=0;
    
    data_REM_mid_WAKE_end_2(k,:) = all_trans_REM_mid_WAKE_end_2{k}; data_REM_mid_WAKE_end_2(isnan(data_REM_mid_WAKE_end_2)==1)=0;
    data_REM_mid_SWS_end_2(k,:) = all_trans_REM_mid_SWS_end_2{k}; data_REM_mid_SWS_end_2(isnan(data_REM_mid_SWS_end_2)==1)=0;
    
    data_REM_long_WAKE_end_2(k,:) = all_trans_REM_long_WAKE_end_2{k}; data_REM_long_WAKE_end_2(isnan(data_REM_long_WAKE_end_2)==1)=0;
    data_REM_long_SWS_end_2(k,:) = all_trans_REM_long_SWS_end_2{k}; data_REM_long_SWS_end_2(isnan(data_REM_long_SWS_end_2)==1)=0;
    
    data_REM_short_REM_end_2(k,:) = all_trans_REM_short_REM_end_2{k}; %data_REM_short_REM_end_2(isnan(data_REM_short_REM_end_2)==1)=0;
    data_REM_mid_REM_end_2(k,:) = all_trans_REM_mid_REM_end_2{k}; %data_REM_mid_REM_end_2(isnan(data_REM_mid_REM_end_2)==1)=0;
    data_REM_long_REM_end_2(k,:) = all_trans_REM_long_REM_end_2{k}; %data_REM_long_REM_end_2(isnan(data_REM_long_REM_end_2)==1)=0;
    
end





%% GET DATA - 3rd group
for j=1:length(Dir_3.path)
    cd(Dir_3.path{j}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_3{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_3{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_3{j} = intervalSet(0,time_end);
    same_epoch_begin_3{j} = intervalSet(time_st,time_mid_end_first_period);
    same_epoch_end_3{j} = intervalSet(time_mid_end_snd_period,time_end);
    same_epoch_interPeriod_3{j} = intervalSet(time_mid_end_first_period,time_mid_end_snd_period);
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_3{j}.Wake,same_epoch_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_3{j}),and(stages_3{j}.REMEpoch,same_epoch_3{j}),'wake',tempbin,time_st,time_end);
    dur_WAKE_3{j}=dur_moyenne_ep_WAKE;
    num_WAKE_3{j}=num_moyen_ep_WAKE;
    perc_WAKE_3{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_3{j}.Wake,same_epoch_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_3{j}),and(stages_3{j}.REMEpoch,same_epoch_3{j}),'sws',tempbin,time_st,time_end);
    dur_SWS_3{j}=dur_moyenne_ep_SWS;
    num_SWS_3{j}=num_moyen_ep_SWS;
    perc_SWS_3{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_3{j}.Wake,same_epoch_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_3{j}),and(stages_3{j}.REMEpoch,same_epoch_3{j}),'rem',tempbin,time_st,time_end);
    dur_REM_3{j}=dur_moyenne_ep_REM;
    num_REM_3{j}=num_moyen_ep_REM;
    perc_REM_3{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_3{j}.Wake,same_epoch_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_3{j}),and(stages_3{j}.REMEpoch,same_epoch_3{j}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_3{j}=dur_moyenne_ep_totSleep;
    num_totSleep_3{j}=num_moyen_ep_totSleep;
    perc_totSleep_3{j}=perc_moyen_totSleep;
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_3{j}.Wake,same_epoch_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_3{j}),and(stages_3{j}.REMEpoch,same_epoch_3{j}),tempbin,time_end);
    all_trans_REM_REM_3{j} = trans_REM_to_REM;
    all_trans_REM_SWS_3{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_3{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_3{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_3{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_3{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_3{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_3{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_3{j} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES 2
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_begin_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_begin_3{j}),and(stages_3{j}.REMEpoch,same_epoch_begin_3{j}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_3{j}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_3{j}=num_moyen_ep_WAKE;
    perc_WAKE_begin_3{j}=perc_moyen_WAKE;
    [dur_WAKE_begin_3_bis{j}, durT_WAKE_begin_3(j)]=DurationEpoch(and(stages_3{j}.Wake,same_epoch_begin_3{j}),'min');

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_begin_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_begin_3{j}),and(stages_3{j}.REMEpoch,same_epoch_begin_3{j}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_3{j}=dur_moyenne_ep_SWS;
    num_SWS_begin_3{j}=num_moyen_ep_SWS;
    perc_SWS_begin_3{j}=perc_moyen_SWS;
    [dur_SWS_begin_3_bis{j}, durT_SWS_begin_3(j)]=DurationEpoch(and(stages_3{j}.SWSEpoch,same_epoch_begin_3{j}),'min');

    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_begin_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_begin_3{j}),and(stages_3{j}.REMEpoch,same_epoch_begin_3{j}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_3{j}=dur_moyenne_ep_REM;
    num_REM_begin_3{j}=num_moyen_ep_REM;
    perc_REM_begin_3{j}=perc_moyen_REM;
    [dur_REM_begin_3_bis{j}, durT_REM_begin_3(j)]=DurationEpoch(and(stages_3{j}.REMEpoch,same_epoch_begin_3{j}),'min');
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_begin_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_begin_3{j}),and(stages_3{j}.REMEpoch,same_epoch_begin_3{j}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_3{j}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_3{j}=num_moyen_ep_totSleep;
    perc_totSleep_begin_3{j}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_3{j}.Wake,same_epoch_begin_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_begin_3{j}),and(stages_3{j}.REMEpoch,same_epoch_begin_3{j}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_3{j} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_3{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_3{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_3{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_3{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_3{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_3{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_3{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_3{j} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_interPeriod_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_interPeriod_3{j}),and(stages_3{j}.REMEpoch,same_epoch_interPeriod_3{j}),'wake',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_WAKE_interPeriod_3{j}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_3{j}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_3{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_interPeriod_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_interPeriod_3{j}),and(stages_3{j}.REMEpoch,same_epoch_interPeriod_3{j}),'sws',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_SWS_interPeriod_3{j}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_3{j}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_3{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_interPeriod_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_interPeriod_3{j}),and(stages_3{j}.REMEpoch,same_epoch_interPeriod_3{j}),'rem',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_REM_interPeriod_3{j}=dur_moyenne_ep_REM;
    num_REM_interPeriod_3{j}=num_moyen_ep_REM;
    perc_REM_interPeriod_3{j}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_interPeriod_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_interPeriod_3{j}),and(stages_3{j}.REMEpoch,same_epoch_interPeriod_3{j}),'sleep',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_totSleep_interPeriod_3{j}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_3{j}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_3{j}=perc_moyen_totSleep;
    
    
    %%3H POST 2 JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_end_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_end_3{j}),and(stages_3{j}.REMEpoch,same_epoch_end_3{j}),'wake',tempbin,time_mid_end_snd_period,time_end);
    dur_WAKE_end_3{j}=dur_moyenne_ep_WAKE;
    num_WAKE_end_3{j}=num_moyen_ep_WAKE;
    perc_WAKE_end_3{j}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_end_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_end_3{j}),and(stages_3{j}.REMEpoch,same_epoch_end_3{j}),'sws',tempbin,time_mid_end_snd_period,time_end);
    dur_SWS_end_3{j}=dur_moyenne_ep_SWS;
    num_SWS_end_3{j}=num_moyen_ep_SWS;
    perc_SWS_end_3{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_end_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_end_3{j}),and(stages_3{j}.REMEpoch,same_epoch_end_3{j}),'rem',tempbin,time_mid_end_snd_period,time_end);
    dur_REM_end_3{j}=dur_moyenne_ep_REM;
    num_REM_end_3{j}=num_moyen_ep_REM;
    perc_REM_end_3{j}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_3{j}.Wake,same_epoch_end_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_end_3{j}),and(stages_3{j}.REMEpoch,same_epoch_end_3{j}),'sleep',tempbin,time_mid_end_snd_period,time_end);
    dur_totSleep_end_3{j}=dur_moyenne_ep_totSleep;
    num_totSleep_end_3{j}=num_moyen_ep_totSleep;
    perc_totSleep_end_3{j}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_3{j}.Wake,same_epoch_end_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_end_3{j}),and(stages_3{j}.REMEpoch,same_epoch_end_3{j}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_REM_end_3{j} = trans_REM_to_REM;
    all_trans_REM_SWS_end_3{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_3{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_3{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_3{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_3{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_3{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_3{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_3{j} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_WAKE_3_bis{j}, durT_WAKE_3(j)]=DurationEpoch(and(stages_3{j}.Wake,same_epoch_end_3{j}),'s');
    [dur_SWS_3_bis{j}, durT_SWS_3(j)]=DurationEpoch(and(stages_3{j}.SWSEpoch,same_epoch_end_3{j}),'s');
    
    
    [dur_REM_3_bis{j}, durT_REM_3(j)]=DurationEpoch(and(stages_3{j}.REMEpoch,same_epoch_end_3{j}),'s');
    
    idx_short_rem_3_1{j} = find(dur_REM_3_bis{j}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_3_1{j} = subset(and(stages_3{j}.REMEpoch,same_epoch_end_3{j}), idx_short_rem_3_1{j});
    [dur_rem_short_3_1{j}, durT_rem_short_3(j)] = DurationEpoch(short_REMEpoch_3_1{j},'s');
    perc_rem_short_3_1(j) = durT_rem_short_3(j) / durT_REM_3(j) * 100;
    dur_moyenne_rem_short_3_1(j) = nanmean(dur_rem_short_3_1{j});
    num_moyen_rem_short_3_1(j) = length(dur_rem_short_3_1{j});
    
    idx_short_rem_3_2{j} = find(dur_REM_3_bis{j}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_3_2{j} = subset(and(stages_3{j}.REMEpoch,same_epoch_end_3{j}), idx_short_rem_3_2{j});
    [dur_rem_short_3_2{j}, durT_rem_short_3(j)] = DurationEpoch(short_REMEpoch_3_2{j},'s');
    perc_rem_short_3_2(j) = durT_rem_short_3(j) / durT_REM_3(j) * 100;
    dur_moyenne_rem_short_3_2(j) = nanmean(dur_rem_short_3_2{j});
    num_moyen_rem_short_3_2(j) = length(dur_rem_short_3_2{j});
    
    idx_short_rem_3_3{j} = find(dur_REM_3_bis{j}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_3_3{j} = subset(and(stages_3{j}.REMEpoch,same_epoch_end_3{j}), idx_short_rem_3_3{j});
    [dur_rem_short_3_3{j}, durT_rem_short_3(j)] = DurationEpoch(short_REMEpoch_3_3{j},'s');
    perc_rem_short_3_3(j) = durT_rem_short_3(j) / durT_REM_3(j) * 100;
    dur_moyenne_rem_short_3_3(j) = nanmean(dur_rem_short_3_3{j});
    num_moyen_rem_short_3_3(j) = length(dur_rem_short_3_3{j});
    
    idx_long_rem_3{j} = find(dur_REM_3_bis{j}>lim_long_rem); %long bout
    long_REMEpoch_3{j} = subset(and(stages_3{j}.REMEpoch,same_epoch_end_3{j}), idx_long_rem_3{j});
    [dur_rem_long_3{j}, durT_rem_long_3(j)] = DurationEpoch(long_REMEpoch_3{j},'s');
    perc_rem_long_3(j) = durT_rem_long_3(j) / durT_REM_3(j) * 100;
    dur_moyenne_rem_long_3(j) = nanmean(dur_rem_long_3{j});
    num_moyen_rem_long_3(j) = length(dur_rem_long_3{j});
    
    idx_mid_rem_3{j} = find(dur_REM_3_bis{j}>lim_short_rem_1 & dur_REM_3_bis{j}<lim_long_rem); % middle bouts
    mid_REMEpoch_3{j} = subset(and(stages_3{j}.REMEpoch,same_epoch_end_3{j}), idx_mid_rem_3{j});
    [dur_rem_mid_3{j}, durT_rem_mid_3(j)] = DurationEpoch(mid_REMEpoch_3{j},'s');
    perc_rem_mid_3(j) = durT_rem_mid_3(j) / durT_REM_3(j) * 100;
    dur_moyenne_rem_mid_3(j) = nanmean(dur_rem_mid_3{j});
    num_moyen_rem_mid_3(j) = length(dur_rem_mid_3{j});
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_3{j}.Wake,same_epoch_end_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_end_3{j}),and(short_REMEpoch_3_1{j},same_epoch_end_3{j}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_short_SWS_end_3{j} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_3{j} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_3{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_3{j}.Wake,same_epoch_end_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_end_3{j}),and(mid_REMEpoch_3{j},same_epoch_end_3{j}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_mid_SWS_end_3{j} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_3{j} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_3{j} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_3{j}.Wake,same_epoch_end_3{j}),and(stages_3{j}.SWSEpoch,same_epoch_end_3{j}),and(long_REMEpoch_3{j},same_epoch_end_3{j}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_long_SWS_end_3{j} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_3{j} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_3{j} = trans_REM_to_REM;
    
end

%% compute average - 3rd group
%%percentage/duration/number
for j=1:length(dur_REM_3)
    %%ALL SESSION
    data_dur_REM_3(j,:) = dur_REM_3{j}; data_dur_REM_3(isnan(data_dur_REM_3)==1)=0;
    data_dur_SWS_3(j,:) = dur_SWS_3{j}; data_dur_SWS_3(isnan(data_dur_SWS_3)==1)=0;
    data_dur_WAKE_3(j,:) = dur_WAKE_3{j}; data_dur_WAKE_3(isnan(data_dur_WAKE_3)==1)=0;
    data_dur_totSleep_3(j,:) = dur_totSleep_3{j}; data_dur_totSleep_3(isnan(data_dur_totSleep_3)==1)=0;
    
    data_num_REM_3(j,:) = num_REM_3{j};data_num_REM_3(isnan(data_num_REM_3)==1)=0;
    data_num_SWS_3(j,:) = num_SWS_3{j}; data_num_SWS_3(isnan(data_num_SWS_3)==1)=0;
    data_num_WAKE_3(j,:) = num_WAKE_3{j}; data_num_WAKE_3(isnan(data_num_WAKE_3)==1)=0;
    data_num_totSleep_3(j,:) = num_totSleep_3{j}; data_num_totSleep_3(isnan(data_num_totSleep_3)==1)=0;
    
    data_perc_REM_3(j,:) = perc_REM_3{j}; data_perc_REM_3(isnan(data_perc_REM_3)==1)=0;
    data_perc_SWS_3(j,:) = perc_SWS_3{j}; data_perc_SWS_3(isnan(data_perc_SWS_3)==1)=0;
    data_perc_WAKE_3(j,:) = perc_WAKE_3{j}; data_perc_WAKE_3(isnan(data_perc_WAKE_3)==1)=0;
    data_perc_totSleep_3(j,:) = perc_totSleep_3{j}; data_perc_totSleep_3(isnan(data_perc_totSleep_3)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_3(j,:) = dur_REM_begin_3{j}; data_dur_REM_begin_3(isnan(data_dur_REM_begin_3)==1)=0;
    data_dur_SWS_begin_3(j,:) = dur_SWS_begin_3{j}; data_dur_SWS_begin_3(isnan(data_dur_SWS_begin_3)==1)=0;
    data_dur_WAKE_begin_3(j,:) = dur_WAKE_begin_3{j}; data_dur_WAKE_begin_3(isnan(data_dur_WAKE_begin_3)==1)=0;
    data_dur_totSleep_begin_3(j,:) = dur_totSleep_begin_3{j}; data_dur_totSleep_begin_3(isnan(data_dur_totSleep_begin_3)==1)=0;
    
    
    data_num_REM_begin_3(j,:) = num_REM_begin_3{j};data_num_REM_begin_3(isnan(data_num_REM_begin_3)==1)=0;
    data_num_SWS_begin_3(j,:) = num_SWS_begin_3{j}; data_num_SWS_begin_3(isnan(data_num_SWS_begin_3)==1)=0;
    data_num_WAKE_begin_3(j,:) = num_WAKE_begin_3{j}; data_num_WAKE_begin_3(isnan(data_num_WAKE_begin_3)==1)=0;
    data_num_totSleep_begin_3(j,:) = num_totSleep_begin_3{j}; data_num_totSleep_begin_3(isnan(data_num_totSleep_begin_3)==1)=0;
    
    data_perc_REM_begin_3(j,:) = perc_REM_begin_3{j}; data_perc_REM_begin_3(isnan(data_perc_REM_begin_3)==1)=0;
    data_perc_SWS_begin_3(j,:) = perc_SWS_begin_3{j}; data_perc_SWS_begin_3(isnan(data_perc_SWS_begin_3)==1)=0;
    data_perc_WAKE_begin_3(j,:) = perc_WAKE_begin_3{j}; data_perc_WAKE_begin_3(isnan(data_perc_WAKE_begin_3)==1)=0;
    data_perc_totSleep_begin_3(j,:) = perc_totSleep_begin_3{j}; data_perc_totSleep_begin_3(isnan(data_perc_totSleep_begin_3)==1)=0;
    
    data_durT_REM_begin_3(j,:) = durT_REM_begin_3(j); data_durT_REM_begin_3(isnan(data_durT_REM_begin_3)==1)=0;
    data_durT_SWS_begin_3(j,:) = durT_SWS_begin_3(j); data_durT_SWS_begin_3(isnan(data_durT_SWS_begin_3)==1)=0;
    data_durT_WAKE_begin_3(j,:) = durT_WAKE_begin_3(j); data_durT_WAKE_begin_3(isnan(data_durT_WAKE_begin_3)==1)=0;
    
    %%second period
    data_dur_REM_interPeriod_3(j,:) = dur_REM_interPeriod_3{j}; data_dur_REM_interPeriod_3(isnan(data_dur_REM_interPeriod_3)==1)=0;
    data_dur_SWS_interPeriod_3(j,:) = dur_SWS_interPeriod_3{j}; data_dur_SWS_interPeriod_3(isnan(data_dur_SWS_interPeriod_3)==1)=0;
    data_dur_WAKE_interPeriod_3(j,:) = dur_WAKE_interPeriod_3{j}; data_dur_WAKE_interPeriod_3(isnan(data_dur_WAKE_interPeriod_3)==1)=0;
    data_dur_totSleep_interPeriod_3(j,:) = dur_totSleep_interPeriod_3{j}; data_dur_totSleep_interPeriod_3(isnan(data_dur_totSleep_interPeriod_3)==1)=0;
    
    data_num_REM_interPeriod_3(j,:) = num_REM_interPeriod_3{j};data_num_REM_interPeriod_3(isnan(data_num_REM_interPeriod_3)==1)=0;
    data_num_SWS_interPeriod_3(j,:) = num_SWS_interPeriod_3{j}; data_num_SWS_interPeriod_3(isnan(data_num_SWS_interPeriod_3)==1)=0;
    data_num_WAKE_interPeriod_3(j,:) = num_WAKE_interPeriod_3{j}; data_num_WAKE_interPeriod_3(isnan(data_num_WAKE_interPeriod_3)==1)=0;
    data_num_totSleep_interPeriod_3(j,:) = num_totSleep_interPeriod_3{j}; data_num_totSleep_interPeriod_3(isnan(data_num_totSleep_interPeriod_3)==1)=0;
    
    data_perc_REM_interPeriod_3(j,:) = perc_REM_interPeriod_3{j}; data_perc_REM_interPeriod_3(isnan(data_perc_REM_interPeriod_3)==1)=0;
    data_perc_SWS_interPeriod_3(j,:) = perc_SWS_interPeriod_3{j}; data_perc_SWS_interPeriod_3(isnan(data_perc_SWS_interPeriod_3)==1)=0;
    data_perc_WAKE_interPeriod_3(j,:) = perc_WAKE_interPeriod_3{j}; data_perc_WAKE_interPeriod_3(isnan(data_perc_WAKE_interPeriod_3)==1)=0;
    data_perc_totSleep_interPeriod_3(j,:) = perc_totSleep_interPeriod_3{j}; data_perc_totSleep_interPeriod_3(isnan(data_perc_totSleep_interPeriod_3)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_3(j,:) = dur_REM_end_3{j}; data_dur_REM_end_3(isnan(data_dur_REM_end_3)==1)=0;
    data_dur_SWS_end_3(j,:) = dur_SWS_end_3{j}; data_dur_SWS_end_3(isnan(data_dur_SWS_end_3)==1)=0;
    data_dur_WAKE_end_3(j,:) = dur_WAKE_end_3{j}; data_dur_WAKE_end_3(isnan(data_dur_WAKE_end_3)==1)=0;
    data_dur_totSleep_end_3(j,:) = dur_totSleep_end_3{j}; data_dur_totSleep_end_3(isnan(data_dur_totSleep_end_3)==1)=0;
    
    
    data_num_REM_end_3(j,:) = num_REM_end_3{j};data_num_REM_end_3(isnan(data_num_REM_end_3)==1)=0;
    data_num_SWS_end_3(j,:) = num_SWS_end_3{j}; data_num_SWS_end_3(isnan(data_num_SWS_end_3)==1)=0;
    data_num_WAKE_end_3(j,:) = num_WAKE_end_3{j}; data_num_WAKE_end_3(isnan(data_num_WAKE_end_3)==1)=0;
    data_num_totSleep_end_3(j,:) = num_totSleep_end_3{j}; data_num_totSleep_end_3(isnan(data_num_totSleep_end_3)==1)=0;
    
    
    data_perc_REM_end_3(j,:) = perc_REM_end_3{j}; data_perc_REM_end_3(isnan(data_perc_REM_end_3)==1)=0;
    data_perc_SWS_end_3(j,:) = perc_SWS_end_3{j}; data_perc_SWS_end_3(isnan(data_perc_SWS_end_3)==1)=0;
    data_perc_WAKE_end_3(j,:) = perc_WAKE_end_3{j}; data_perc_WAKE_end_3(isnan(data_perc_WAKE_end_3)==1)=0;
    data_perc_totSleep_end_3(j,:) = perc_totSleep_end_3{j}; data_perc_totSleep_end_3(isnan(data_perc_totSleep_end_3)==1)=0;
    
end

for j=1:length(all_trans_REM_REM_3)
    data_REM_short_WAKE_end_3(j,:) = all_trans_REM_short_WAKE_end_3{j}; data_REM_short_WAKE_end_3(isnan(data_REM_short_WAKE_end_3)==1)=0;
    data_REM_short_SWS_end_3(j,:) = all_trans_REM_short_SWS_end_3{j}; data_REM_short_SWS_end_3(isnan(data_REM_short_SWS_end_3)==1)=0;
        data_REM_short_REM_end_3(j,:) = all_trans_REM_short_REM_end_3{j}; data_REM_short_REM_end_3(isnan(data_REM_short_REM_end_3)==1)=0;

    data_REM_mid_WAKE_end_3(j,:) = all_trans_REM_mid_WAKE_end_3{j}; data_REM_mid_WAKE_end_3(isnan(data_REM_mid_WAKE_end_3)==1)=0;
    data_REM_mid_SWS_end_3(j,:) = all_trans_REM_mid_SWS_end_3{j}; data_REM_mid_SWS_end_3(isnan(data_REM_mid_SWS_end_3)==1)=0;
    
    data_REM_long_WAKE_end_3(j,:) = all_trans_REM_long_WAKE_end_3{j}; data_REM_long_WAKE_end_3(isnan(data_REM_long_WAKE_end_3)==1)=0;
    data_REM_long_SWS_end_3(j,:) = all_trans_REM_long_SWS_end_3{j}; data_REM_long_SWS_end_3(isnan(data_REM_long_SWS_end_3)==1)=0;
    
    data_REM_mid_REM_end_3(j,:) = all_trans_REM_mid_REM_end_3{j}; data_REM_mid_REM_end_3(isnan(data_REM_mid_REM_end_3)==1)=0;
    data_REM_long_REM_end_3(j,:) = all_trans_REM_long_REM_end_3{j}; data_REM_long_REM_end_3(isnan(data_REM_long_REM_end_3)==1)=0;
    
end





%% GET DATA - 4th group
for m=1:length(Dir_4.path)
    cd(Dir_4.path{m}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_4{m} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_4{m} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_4{m} = intervalSet(0,time_end);
    same_epoch_begin_4{m} = intervalSet(time_st,time_mid_end_first_period);
    same_epoch_end_4{m} = intervalSet(time_mid_end_snd_period,time_end);
    same_epoch_interPeriod_4{m} = intervalSet(time_mid_end_first_period,time_mid_end_snd_period);
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_4{m}.Wake,same_epoch_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_4{m}),and(stages_4{m}.REMEpoch,same_epoch_4{m}),'wake',tempbin,time_st,time_end);
    dur_WAKE_4{m}=dur_moyenne_ep_WAKE;
    num_WAKE_4{m}=num_moyen_ep_WAKE;
    perc_WAKE_4{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_4{m}.Wake,same_epoch_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_4{m}),and(stages_4{m}.REMEpoch,same_epoch_4{m}),'sws',tempbin,time_st,time_end);
    dur_SWS_4{m}=dur_moyenne_ep_SWS;
    num_SWS_4{m}=num_moyen_ep_SWS;
    perc_SWS_4{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_4{m}.Wake,same_epoch_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_4{m}),and(stages_4{m}.REMEpoch,same_epoch_4{m}),'rem',tempbin,time_st,time_end);
    dur_REM_4{m}=dur_moyenne_ep_REM;
    num_REM_4{m}=num_moyen_ep_REM;
    perc_REM_4{m}=perc_moyen_REM;
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_4{m}.Wake,same_epoch_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_4{m}),and(stages_4{m}.REMEpoch,same_epoch_4{m}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_4{m}=dur_moyenne_ep_totSleep;
    num_totSleep_4{m}=num_moyen_ep_totSleep;
    perc_totSleep_4{m}=perc_moyen_totSleep;
    
    
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_4{m}.Wake,same_epoch_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_4{m}),and(stages_4{m}.REMEpoch,same_epoch_4{m}),tempbin,time_end);
    all_trans_REM_REM_4{m} = trans_REM_to_REM;
    all_trans_REM_SWS_4{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_4{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_4{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_4{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_4{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_4{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_4{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_4{m} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES 2
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_begin_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_begin_4{m}),and(stages_4{m}.REMEpoch,same_epoch_begin_4{m}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_4{m}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_4{m}=num_moyen_ep_WAKE;
    perc_WAKE_begin_4{m}=perc_moyen_WAKE;
    [dur_WAKE_begin_4_bis{m}, durT_WAKE_begin_4(m)]=DurationEpoch(and(stages_4{m}.Wake,same_epoch_begin_4{m}),'min');

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_begin_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_begin_4{m}),and(stages_4{m}.REMEpoch,same_epoch_begin_4{m}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_4{m}=dur_moyenne_ep_SWS;
    num_SWS_begin_4{m}=num_moyen_ep_SWS;
    perc_SWS_begin_4{m}=perc_moyen_SWS;
    [dur_SWS_begin_4_bis{m}, durT_SWS_begin_4(m)]=DurationEpoch(and(stages_4{m}.SWSEpoch,same_epoch_begin_4{m}),'min');

    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_begin_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_begin_4{m}),and(stages_4{m}.REMEpoch,same_epoch_begin_4{m}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_4{m}=dur_moyenne_ep_REM;
    num_REM_begin_4{m}=num_moyen_ep_REM;
    perc_REM_begin_4{m}=perc_moyen_REM;
    [dur_REM_begin_4_bis{m}, durT_REM_begin_4(m)]=DurationEpoch(and(stages_4{m}.REMEpoch,same_epoch_begin_4{m}),'min');
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_begin_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_begin_4{m}),and(stages_4{m}.REMEpoch,same_epoch_begin_4{m}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_4{m}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_4{m}=num_moyen_ep_totSleep;
    perc_totSleep_begin_4{m}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_4{m}.Wake,same_epoch_begin_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_begin_4{m}),and(stages_4{m}.REMEpoch,same_epoch_begin_4{m}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_4{m} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_4{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_4{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_4{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_4{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_4{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_4{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_4{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_4{m} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_interPeriod_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_interPeriod_4{m}),and(stages_4{m}.REMEpoch,same_epoch_interPeriod_4{m}),'wake',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_WAKE_interPeriod_4{m}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_4{m}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_4{m}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_interPeriod_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_interPeriod_4{m}),and(stages_4{m}.REMEpoch,same_epoch_interPeriod_4{m}),'sws',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_SWS_interPeriod_4{m}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_4{m}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_4{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_interPeriod_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_interPeriod_4{m}),and(stages_4{m}.REMEpoch,same_epoch_interPeriod_4{m}),'rem',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_REM_interPeriod_4{m}=dur_moyenne_ep_REM;
    num_REM_interPeriod_4{m}=num_moyen_ep_REM;
    perc_REM_interPeriod_4{m}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_interPeriod_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_interPeriod_4{m}),and(stages_4{m}.REMEpoch,same_epoch_interPeriod_4{m}),'sleep',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_totSleep_interPeriod_4{m}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_4{m}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_4{m}=perc_moyen_totSleep;
    
    
    %%3H POST 2 JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_end_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_end_4{m}),and(stages_4{m}.REMEpoch,same_epoch_end_4{m}),'wake',tempbin,time_mid_end_snd_period,time_end);
    dur_WAKE_end_4{m}=dur_moyenne_ep_WAKE;
    num_WAKE_end_4{m}=num_moyen_ep_WAKE;
    perc_WAKE_end_4{m}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_end_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_end_4{m}),and(stages_4{m}.REMEpoch,same_epoch_end_4{m}),'sws',tempbin,time_mid_end_snd_period,time_end);
    dur_SWS_end_4{m}=dur_moyenne_ep_SWS;
    num_SWS_end_4{m}=num_moyen_ep_SWS;
    perc_SWS_end_4{m}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_end_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_end_4{m}),and(stages_4{m}.REMEpoch,same_epoch_end_4{m}),'rem',tempbin,time_mid_end_snd_period,time_end);
    dur_REM_end_4{m}=dur_moyenne_ep_REM;
    num_REM_end_4{m}=num_moyen_ep_REM;
    perc_REM_end_4{m}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_4{m}.Wake,same_epoch_end_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_end_4{m}),and(stages_4{m}.REMEpoch,same_epoch_end_4{m}),'sleep',tempbin,time_mid_end_snd_period,time_end);
    dur_totSleep_end_4{m}=dur_moyenne_ep_totSleep;
    num_totSleep_end_4{m}=num_moyen_ep_totSleep;
    perc_totSleep_end_4{m}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_4{m}.Wake,same_epoch_end_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_end_4{m}),and(stages_4{m}.REMEpoch,same_epoch_end_4{m}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_REM_end_4{m} = trans_REM_to_REM;
    all_trans_REM_SWS_end_4{m} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_4{m} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_4{m} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_4{m} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_4{m} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_4{m} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_4{m} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_4{m} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_WAKE_4_bis{m}, durT_WAKE_4(m)]=DurationEpoch(and(stages_4{m}.Wake,same_epoch_end_4{m}),'s');
    [dur_SWS_4_bis{m}, durT_SWS_4(m)]=DurationEpoch(and(stages_4{m}.SWSEpoch,same_epoch_end_4{m}),'s');
    
    [dur_REM_4_bis{m}, durT_REM_4(m)]=DurationEpoch(and(stages_4{m}.REMEpoch,same_epoch_end_4{m}),'s');
    
    idx_short_rem_4_1{m} = find(dur_REM_4_bis{m}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_4_1{m} = subset(and(stages_4{m}.REMEpoch,same_epoch_end_4{m}), idx_short_rem_4_1{m});
    [dur_rem_short_4_1{m}, durT_rem_short_4(m)] = DurationEpoch(short_REMEpoch_4_1{m},'s');
    perc_rem_short_4_1(m) = durT_rem_short_4(m) / durT_REM_4(m) * 100;
    dur_moyenne_rem_short_4_1(m) = nanmean(dur_rem_short_4_1{m});
    num_moyen_rem_short_4_1(m) = length(dur_rem_short_4_1{m});
    
    idx_short_rem_4_2{m} = find(dur_REM_4_bis{m}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_4_2{m} = subset(and(stages_4{m}.REMEpoch,same_epoch_end_4{m}), idx_short_rem_4_2{m});
    [dur_rem_short_4_2{m}, durT_rem_short_4(m)] = DurationEpoch(short_REMEpoch_4_2{m},'s');
    perc_rem_short_4_2(m) = durT_rem_short_4(m) / durT_REM_4(m) * 100;
    dur_moyenne_rem_short_4_2(m) = nanmean(dur_rem_short_4_2{m});
    num_moyen_rem_short_4_2(m) = length(dur_rem_short_4_2{m});
    
    idx_short_rem_4_3{m} = find(dur_REM_4_bis{m}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_4_3{m} = subset(and(stages_4{m}.REMEpoch,same_epoch_end_4{m}), idx_short_rem_4_3{m});
    [dur_rem_short_4_3{m}, durT_rem_short_4(m)] = DurationEpoch(short_REMEpoch_4_3{m},'s');
    perc_rem_short_4_3(m) = durT_rem_short_4(m) / durT_REM_4(m) * 100;
    dur_moyenne_rem_short_4_3(m) = nanmean(dur_rem_short_4_3{m});
    num_moyen_rem_short_4_3(m) = length(dur_rem_short_4_3{m});
    
    idx_long_rem_4{m} = find(dur_REM_4_bis{m}>lim_long_rem); %long bout
    long_REMEpoch_4{m} = subset(and(stages_4{m}.REMEpoch,same_epoch_end_4{m}), idx_long_rem_4{m});
    [dur_rem_long_4{m}, durT_rem_long_4(m)] = DurationEpoch(long_REMEpoch_4{m},'s');
    perc_rem_long_4(m) = durT_rem_long_4(m) / durT_REM_4(m) * 100;
    dur_moyenne_rem_long_4(m) = nanmean(dur_rem_long_4{m});
    num_moyen_rem_long_4(m) = length(dur_rem_long_4{m});
    
    idx_mid_rem_4{m} = find(dur_REM_4_bis{m}>lim_short_rem_1 & dur_REM_4_bis{m}<lim_long_rem); % middle bouts
    mid_REMEpoch_4{m} = subset(and(stages_4{m}.REMEpoch,same_epoch_end_4{m}), idx_mid_rem_4{m});
    [dur_rem_mid_4{m}, durT_rem_mid_4(m)] = DurationEpoch(mid_REMEpoch_4{m},'s');
    perc_rem_mid_4(m) = durT_rem_mid_4(m) / durT_REM_4(m) * 100;
    dur_moyenne_rem_mid_4(m) = nanmean(dur_rem_mid_4{m});
    num_moyen_rem_mid_4(m) = length(dur_rem_mid_4{m});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_4{m}.Wake,same_epoch_end_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_end_4{m}),and(short_REMEpoch_4_1{m},same_epoch_end_4{m}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_short_SWS_end_4{m} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_4{m} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_4{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_4{m}.Wake,same_epoch_end_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_end_4{m}),and(mid_REMEpoch_4{m},same_epoch_end_4{m}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_mid_SWS_end_4{m} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_4{m} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_4{m} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_4{m}.Wake,same_epoch_end_4{m}),and(stages_4{m}.SWSEpoch,same_epoch_end_4{m}),and(long_REMEpoch_4{m},same_epoch_end_4{m}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_long_SWS_end_4{m} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_4{m} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_4{m} = trans_REM_to_REM;
    
    
end

%% compute average - 4th group
%%percentage/duration/number
for m=1:length(dur_REM_4)
    %%ALL SESSION
    data_dur_REM_4(m,:) = dur_REM_4{m}; data_dur_REM_4(isnan(data_dur_REM_4)==1)=0;
    data_dur_SWS_4(m,:) = dur_SWS_4{m}; data_dur_SWS_4(isnan(data_dur_SWS_4)==1)=0;
    data_dur_WAKE_4(m,:) = dur_WAKE_4{m}; data_dur_WAKE_4(isnan(data_dur_WAKE_4)==1)=0;
    data_dur_totSleep_4(m,:) = dur_totSleep_4{m}; data_dur_totSleep_4(isnan(data_dur_totSleep_4)==1)=0;
    
    data_num_REM_4(m,:) = num_REM_4{m};data_num_REM_4(isnan(data_num_REM_4)==1)=0;
    data_num_SWS_4(m,:) = num_SWS_4{m}; data_num_SWS_4(isnan(data_num_SWS_4)==1)=0;
    data_num_WAKE_4(m,:) = num_WAKE_4{m}; data_num_WAKE_4(isnan(data_num_WAKE_4)==1)=0;
    data_num_totSleep_4(m,:) = num_totSleep_4{m}; data_num_totSleep_4(isnan(data_num_totSleep_4)==1)=0;
    
    data_perc_REM_4(m,:) = perc_REM_4{m}; data_perc_REM_4(isnan(data_perc_REM_4)==1)=0;
    data_perc_SWS_4(m,:) = perc_SWS_4{m}; data_perc_SWS_4(isnan(data_perc_SWS_4)==1)=0;
    data_perc_WAKE_4(m,:) = perc_WAKE_4{m}; data_perc_WAKE_4(isnan(data_perc_WAKE_4)==1)=0;
    data_perc_totSleep_4(m,:) = perc_totSleep_4{m}; data_perc_totSleep_4(isnan(data_perc_totSleep_4)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_4(m,:) = dur_REM_begin_4{m}; data_dur_REM_begin_4(isnan(data_dur_REM_begin_4)==1)=0;
    data_dur_SWS_begin_4(m,:) = dur_SWS_begin_4{m}; data_dur_SWS_begin_4(isnan(data_dur_SWS_begin_4)==1)=0;
    data_dur_WAKE_begin_4(m,:) = dur_WAKE_begin_4{m}; data_dur_WAKE_begin_4(isnan(data_dur_WAKE_begin_4)==1)=0;
    data_dur_totSleep_begin_4(m,:) = dur_totSleep_begin_4{m}; data_dur_totSleep_begin_4(isnan(data_dur_totSleep_begin_4)==1)=0;
   
    data_num_REM_begin_4(m,:) = num_REM_begin_4{m};data_num_REM_begin_4(isnan(data_num_REM_begin_4)==1)=0;
    data_num_SWS_begin_4(m,:) = num_SWS_begin_4{m}; data_num_SWS_begin_4(isnan(data_num_SWS_begin_4)==1)=0;
    data_num_WAKE_begin_4(m,:) = num_WAKE_begin_4{m}; data_num_WAKE_begin_4(isnan(data_num_WAKE_begin_4)==1)=0;
    data_num_totSleep_begin_4(m,:) = num_totSleep_begin_4{m}; data_num_totSleep_begin_4(isnan(data_num_totSleep_begin_4)==1)=0;
    
    data_perc_REM_begin_4(m,:) = perc_REM_begin_4{m}; data_perc_REM_begin_4(isnan(data_perc_REM_begin_4)==1)=0;
    data_perc_SWS_begin_4(m,:) = perc_SWS_begin_4{m}; data_perc_SWS_begin_4(isnan(data_perc_SWS_begin_4)==1)=0;
    data_perc_WAKE_begin_4(m,:) = perc_WAKE_begin_4{m}; data_perc_WAKE_begin_4(isnan(data_perc_WAKE_begin_4)==1)=0;
    data_perc_totSleep_begin_4(m,:) = perc_totSleep_begin_4{m}; data_perc_totSleep_begin_4(isnan(data_perc_totSleep_begin_4)==1)=0;
    
    data_durT_REM_begin_4(m,:) = durT_REM_begin_4(m); data_durT_REM_begin_4(isnan(data_durT_REM_begin_4)==1)=0;
    data_durT_SWS_begin_4(m,:) = durT_SWS_begin_4(m); data_durT_SWS_begin_4(isnan(data_durT_SWS_begin_4)==1)=0;
    data_durT_WAKE_begin_4(m,:) = durT_WAKE_begin_4(m); data_durT_WAKE_begin_4(isnan(data_durT_WAKE_begin_4)==1)=0;
    
    %%second phase
    data_dur_REM_interPeriod_4(m,:) = dur_REM_interPeriod_4{m}; data_dur_REM_interPeriod_4(isnan(data_dur_REM_interPeriod_4)==1)=0;
    data_dur_SWS_interPeriod_4(m,:) = dur_SWS_interPeriod_4{m}; data_dur_SWS_interPeriod_4(isnan(data_dur_SWS_interPeriod_4)==1)=0;
    data_dur_WAKE_interPeriod_4(m,:) = dur_WAKE_interPeriod_4{m}; data_dur_WAKE_interPeriod_4(isnan(data_dur_WAKE_interPeriod_4)==1)=0;
    data_dur_totSleep_interPeriod_4(m,:) = dur_totSleep_interPeriod_4{m}; data_dur_totSleep_interPeriod_4(isnan(data_dur_totSleep_interPeriod_4)==1)=0;
    
    data_num_REM_interPeriod_4(m,:) = num_REM_interPeriod_4{m};data_num_REM_interPeriod_4(isnan(data_num_REM_interPeriod_4)==1)=0;
    data_num_SWS_interPeriod_4(m,:) = num_SWS_interPeriod_4{m}; data_num_SWS_interPeriod_4(isnan(data_num_SWS_interPeriod_4)==1)=0;
    data_num_WAKE_interPeriod_4(m,:) = num_WAKE_interPeriod_4{m}; data_num_WAKE_interPeriod_4(isnan(data_num_WAKE_interPeriod_4)==1)=0;
    data_num_totSleep_interPeriod_4(m,:) = num_totSleep_interPeriod_4{m}; data_num_totSleep_interPeriod_4(isnan(data_num_totSleep_interPeriod_4)==1)=0;
    
    data_perc_REM_interPeriod_4(m,:) = perc_REM_interPeriod_4{m}; data_perc_REM_interPeriod_4(isnan(data_perc_REM_interPeriod_4)==1)=0;
    data_perc_SWS_interPeriod_4(m,:) = perc_SWS_interPeriod_4{m}; data_perc_SWS_interPeriod_4(isnan(data_perc_SWS_interPeriod_4)==1)=0;
    data_perc_WAKE_interPeriod_4(m,:) = perc_WAKE_interPeriod_4{m}; data_perc_WAKE_interPeriod_4(isnan(data_perc_WAKE_interPeriod_4)==1)=0;
    data_perc_totSleep_interPeriod_4(m,:) = perc_totSleep_interPeriod_4{m}; data_perc_totSleep_interPeriod_4(isnan(data_perc_totSleep_interPeriod_4)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_4(m,:) = dur_REM_end_4{m}; data_dur_REM_end_4(isnan(data_dur_REM_end_4)==1)=0;
    data_dur_SWS_end_4(m,:) = dur_SWS_end_4{m}; data_dur_SWS_end_4(isnan(data_dur_SWS_end_4)==1)=0;
    data_dur_WAKE_end_4(m,:) = dur_WAKE_end_4{m}; data_dur_WAKE_end_4(isnan(data_dur_WAKE_end_4)==1)=0;
    data_dur_totSleep_end_4(m,:) = dur_totSleep_end_4{m}; data_dur_totSleep_end_4(isnan(data_dur_totSleep_end_4)==1)=0;
    
    
    data_num_REM_end_4(m,:) = num_REM_end_4{m};data_num_REM_end_4(isnan(data_num_REM_end_4)==1)=0;
    data_num_SWS_end_4(m,:) = num_SWS_end_4{m}; data_num_SWS_end_4(isnan(data_num_SWS_end_4)==1)=0;
    data_num_WAKE_end_4(m,:) = num_WAKE_end_4{m}; data_num_WAKE_end_4(isnan(data_num_WAKE_end_4)==1)=0;
    data_num_totSleep_end_4(m,:) = num_totSleep_end_4{m}; data_num_totSleep_end_4(isnan(data_num_totSleep_end_4)==1)=0;
    
    
    data_perc_REM_end_4(m,:) = perc_REM_end_4{m}; data_perc_REM_end_4(isnan(data_perc_REM_end_4)==1)=0;
    data_perc_SWS_end_4(m,:) = perc_SWS_end_4{m}; data_perc_SWS_end_4(isnan(data_perc_SWS_end_4)==1)=0;
    data_perc_WAKE_end_4(m,:) = perc_WAKE_end_4{m}; data_perc_WAKE_end_4(isnan(data_perc_WAKE_end_4)==1)=0;
    data_perc_totSleep_end_4(m,:) = perc_totSleep_end_4{m}; data_perc_totSleep_end_4(isnan(data_perc_totSleep_end_4)==1)=0;
    
end
%%probability
for m=1:length(all_trans_REM_REM_4)
% %     %%ALL SESSION
% %     data_REM_REM_4(m,:) = all_trans_REM_REM_4{m}; data_REM_REM_4(isnan(data_REM_REM_4)==1)=0;
% %     data_REM_SWS_4(m,:) = all_trans_REM_SWS_4{m}; data_REM_SWS_4(isnan(data_REM_SWS_4)==1)=0;
% %     data_REM_WAKE_4(m,:) = all_trans_REM_WAKE_4{m}; data_REM_WAKE_4(isnan(data_REM_WAKE_4)==1)=0;
% %
% %     data_SWS_SWS_4(m,:) = all_trans_SWS_SWS_4{m}; data_SWS_SWS_4(isnan(data_SWS_SWS_4)==1)=0;
% %     data_SWS_REM_4(m,:) = all_trans_SWS_REM_4{m}; data_SWS_REM_4(isnan(data_SWS_REM_4)==1)=0;
% %     data_SWS_WAKE_4(m,:) = all_trans_SWS_WAKE_4{m}; data_SWS_WAKE_4(isnan(data_SWS_WAKE_4)==1)=0;
% %
% %     data_WAKE_WAKE_4(m,:) = all_trans_WAKE_WAKE_4{m}; data_WAKE_WAKE_4(isnan(data_WAKE_WAKE_4)==1)=0;
% %     data_WAKE_REM_4(m,:) = all_trans_WAKE_REM_4{m}; data_WAKE_REM_4(isnan(data_WAKE_REM_4)==1)=0;
% %     data_WAKE_SWS_4(m,:) = all_trans_WAKE_SWS_4{m}; data_WAKE_SWS_4(isnan(data_WAKE_SWS_4)==1)=0;
% %
% %     %%3 PREMI7RES HEURES
% %         data_REM_REM_begin_4(m,:) = all_trans_REM_REM_begin_4{m}; data_REM_REM_begin_4(isnan(data_REM_REM_begin_4)==1)=0;
% %     data_REM_SWS_begin_4(m,:) = all_trans_REM_SWS_begin_4{m}; data_REM_SWS_begin_4(isnan(data_REM_SWS_begin_4)==1)=0;
% %     data_REM_WAKE_begin_4(m,:) = all_trans_REM_WAKE_begin_4{m}; data_REM_WAKE_begin_4(isnan(data_REM_WAKE_begin_4)==1)=0;
% %
% %     data_SWS_SWS_begin_4(m,:) = all_trans_SWS_SWS_begin_4{m}; data_SWS_SWS_begin_4(isnan(data_SWS_SWS_begin_4)==1)=0;
% %     data_SWS_REM_begin_4(m,:) = all_trans_SWS_REM_begin_4{m}; data_SWS_REM_begin_4(isnan(data_SWS_REM_begin_4)==1)=0;
% %     data_SWS_WAKE_begin_4(m,:) = all_trans_SWS_WAKE_begin_4{m}; data_SWS_WAKE_begin_4(isnan(data_SWS_WAKE_begin_4)==1)=0;
% %
% %     data_WAKE_WAKE_begin_4(m,:) = all_trans_WAKE_WAKE_begin_4{m}; data_WAKE_WAKE_begin_4(isnan(data_WAKE_WAKE_begin_4)==1)=0;
% %     data_WAKE_REM_begin_4(m,:) = all_trans_WAKE_REM_begin_4{m}; data_WAKE_REM_begin_4(isnan(data_WAKE_REM_begin_4)==1)=0;
% %     data_WAKE_SWS_begin_4(m,:) = all_trans_WAKE_SWS_begin_4{m}; data_WAKE_SWS_begin_4(isnan(data_WAKE_SWS_begin_4)==1)=0;
% %
% %     %%FIN DE LA SESSION
% %         data_REM_REM_end_4(m,:) = all_trans_REM_REM_end_4{m}; data_REM_REM_end_4(isnan(data_REM_REM_end_4)==1)=0;
% %     data_REM_SWS_end_4(m,:) = all_trans_REM_SWS_end_4{m}; data_REM_SWS_end_4(isnan(data_REM_SWS_end_4)==1)=0;
% %     data_REM_WAKE_end_4(m,:) = all_trans_REM_WAKE_end_4{m}; data_REM_WAKE_end_4(isnan(data_REM_WAKE_end_4)==1)=0;
% %
% %     data_SWS_SWS_end_4(m,:) = all_trans_SWS_SWS_end_4{m}; data_SWS_SWS_end_4(isnan(data_SWS_SWS_end_4)==1)=0;
% %     data_SWS_REM_end_4(m,:) = all_trans_SWS_REM_end_4{m}; data_SWS_REM_end_4(isnan(data_SWS_REM_end_4)==1)=0;
% %     data_SWS_WAKE_end_4(m,:) = all_trans_SWS_WAKE_end_4{m}; data_SWS_WAKE_end_4(isnan(data_SWS_WAKE_end_4)==1)=0;
% %
% %     data_WAKE_WAKE_end_4(m,:) = all_trans_WAKE_WAKE_end_4{m}; data_WAKE_WAKE_end_4(isnan(data_WAKE_WAKE_end_4)==1)=0;
% %     data_WAKE_REM_end_4(m,:) = all_trans_WAKE_REM_end_4{m}; data_WAKE_REM_end_4(isnan(data_WAKE_REM_end_4)==1)=0;
% %     data_WAKE_SWS_end_4(m,:) = all_trans_WAKE_SWS_end_4{m}; data_WAKE_SWS_end_4(isnan(data_WAKE_SWS_end_4)==1)=0;
data_REM_short_WAKE_end_4(m,:) = all_trans_REM_short_WAKE_end_4{m}; data_REM_short_WAKE_end_4(isnan(data_REM_short_WAKE_end_4)==1)=0;
data_REM_short_SWS_end_4(m,:) = all_trans_REM_short_SWS_end_4{m}; data_REM_short_SWS_end_4(isnan(data_REM_short_SWS_end_4)==1)=0;

data_REM_mid_WAKE_end_4(m,:) = all_trans_REM_mid_WAKE_end_4{m}; data_REM_mid_WAKE_end_4(isnan(data_REM_mid_WAKE_end_4)==1)=0;
data_REM_mid_SWS_end_4(m,:) = all_trans_REM_mid_SWS_end_4{m}; data_REM_mid_SWS_end_4(isnan(data_REM_mid_SWS_end_4)==1)=0;

data_REM_long_WAKE_end_4(m,:) = all_trans_REM_long_WAKE_end_4{m}; data_REM_long_WAKE_end_4(isnan(data_REM_long_WAKE_end_4)==1)=0;
data_REM_long_SWS_end_4(m,:) = all_trans_REM_long_SWS_end_4{m}; data_REM_long_SWS_end_4(isnan(data_REM_long_SWS_end_4)==1)=0;


data_REM_short_REM_end_4(m,:) = all_trans_REM_short_REM_end_4{m}; data_REM_short_REM_end_4(isnan(data_REM_short_REM_end_4)==1)=0;
data_REM_mid_REM_end_4(m,:) = all_trans_REM_mid_REM_end_4{m}; data_REM_mid_REM_end_4(isnan(data_REM_mid_REM_end_4)==1)=0;
data_REM_long_REM_end_4(m,:) = all_trans_REM_long_REM_end_4{m}; data_REM_long_REM_end_4(isnan(data_REM_long_REM_end_4)==1)=0;


end

%% GET DATA - 5th group
for n=1:length(Dir_5.path)
    cd(Dir_5.path{n}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_5{n} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_5{n} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Sleep');
    else
    end
    same_epoch_5{n} = intervalSet(0,time_end);
    same_epoch_begin_5{n} = intervalSet(time_st,time_mid_end_first_period);
    same_epoch_end_5{n} = intervalSet(time_mid_end_snd_period,time_end);
    same_epoch_interPeriod_5{n} = intervalSet(time_mid_end_first_period,time_mid_end_snd_period);
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts - overtime
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_5{n}.Wake,same_epoch_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_5{n}),and(stages_5{n}.REMEpoch,same_epoch_5{n}),'wake',tempbin,time_st,time_end);
    dur_WAKE_5{n}=dur_moyenne_ep_WAKE;
    num_WAKE_5{n}=num_moyen_ep_WAKE;
    perc_WAKE_5{n}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_5{n}.Wake,same_epoch_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_5{n}),and(stages_5{n}.REMEpoch,same_epoch_5{n}),'sws',tempbin,time_st,time_end);
    dur_SWS_5{n}=dur_moyenne_ep_SWS;
    num_SWS_5{n}=num_moyen_ep_SWS;
    perc_SWS_5{n}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_5{n}.Wake,same_epoch_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_5{n}),and(stages_5{n}.REMEpoch,same_epoch_5{n}),'rem',tempbin,time_st,time_end);
    dur_REM_5{n}=dur_moyenne_ep_REM;
    num_REM_5{n}=num_moyen_ep_REM;
    perc_REM_5{n}=perc_moyen_REM;
    
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_5{n}.Wake,same_epoch_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_5{n}),and(stages_5{n}.REMEpoch,same_epoch_5{n}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_5{n}=dur_moyenne_ep_totSleep;
    num_totSleep_5{n}=num_moyen_ep_totSleep;
    perc_totSleep_5{n}=perc_moyen_totSleep;
    
    
    
    %%Compute transition probabilities - overtime
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_5{n}.Wake,same_epoch_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_5{n}),and(stages_5{n}.REMEpoch,same_epoch_5{n}),tempbin,time_end);
    all_trans_REM_REM_5{n} = trans_REM_to_REM;
    all_trans_REM_SWS_5{n} = trans_REM_to_SWS;
    all_trans_REM_WAKE_5{n} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_5{n} = trans_SWS_to_REM;
    all_trans_SWS_SWS_5{n} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_5{n} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_5{n} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_5{n} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_5{n} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES 2
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_begin_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_begin_5{n}),and(stages_5{n}.REMEpoch,same_epoch_begin_5{n}),'wake',tempbin,time_st,time_mid_end_first_period);
    dur_WAKE_begin_5{n}=dur_moyenne_ep_WAKE;
    num_WAKE_begin_5{n}=num_moyen_ep_WAKE;
    perc_WAKE_begin_5{n}=perc_moyen_WAKE;
    [dur_WAKE_begin_5_bis{n}, durT_WAKE_begin_5(n)]=DurationEpoch(and(stages_5{n}.Wake,same_epoch_begin_5{n}),'min');

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_begin_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_begin_5{n}),and(stages_5{n}.REMEpoch,same_epoch_begin_5{n}),'sws',tempbin,time_st,time_mid_end_first_period);
    dur_SWS_begin_5{n}=dur_moyenne_ep_SWS;
    num_SWS_begin_5{n}=num_moyen_ep_SWS;
    perc_SWS_begin_5{n}=perc_moyen_SWS;
    [dur_SWS_begin_5_bis{n}, durT_SWS_begin_5(n)]=DurationEpoch(and(stages_5{n}.SWSEpoch,same_epoch_begin_5{n}),'min');

    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_begin_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_begin_5{n}),and(stages_5{n}.REMEpoch,same_epoch_begin_5{n}),'rem',tempbin,time_st,time_mid_end_first_period);
    dur_REM_begin_5{n}=dur_moyenne_ep_REM;
    num_REM_begin_5{n}=num_moyen_ep_REM;
    perc_REM_begin_5{n}=perc_moyen_REM;
    [dur_REM_begin_5_bis{n}, durT_REM_begin_5(n)]=DurationEpoch(and(stages_5{n}.REMEpoch,same_epoch_begin_5{n}),'min');
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_begin_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_begin_5{n}),and(stages_5{n}.REMEpoch,same_epoch_begin_5{n}),'sleep',tempbin,time_st,time_mid_end_first_period);
    dur_totSleep_begin_5{n}=dur_moyenne_ep_totSleep;
    num_totSleep_begin_5{n}=num_moyen_ep_totSleep;
    perc_totSleep_begin_5{n}=perc_moyen_totSleep;
    
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_5{n}.Wake,same_epoch_begin_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_begin_5{n}),and(stages_5{n}.REMEpoch,same_epoch_begin_5{n}),tempbin,time_st,time_mid_end_first_period);
    all_trans_REM_REM_begin_5{n} = trans_REM_to_REM;
    all_trans_REM_SWS_begin_5{n} = trans_REM_to_SWS;
    all_trans_REM_WAKE_begin_5{n} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_begin_5{n} = trans_SWS_to_REM;
    all_trans_SWS_SWS_begin_5{n} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_begin_5{n} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_begin_5{n} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_begin_5{n} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_begin_5{n} = trans_WAKE_to_WAKE;
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_interPeriod_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_interPeriod_5{n}),and(stages_5{n}.REMEpoch,same_epoch_interPeriod_5{n}),'wake',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_WAKE_interPeriod_5{n}=dur_moyenne_ep_WAKE;
    num_WAKE_interPeriod_5{n}=num_moyen_ep_WAKE;
    perc_WAKE_interPeriod_5{n}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_interPeriod_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_interPeriod_5{n}),and(stages_5{n}.REMEpoch,same_epoch_interPeriod_5{n}),'sws',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_SWS_interPeriod_5{n}=dur_moyenne_ep_SWS;
    num_SWS_interPeriod_5{n}=num_moyen_ep_SWS;
    perc_SWS_interPeriod_5{n}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_interPeriod_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_interPeriod_5{n}),and(stages_5{n}.REMEpoch,same_epoch_interPeriod_5{n}),'rem',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_REM_interPeriod_5{n}=dur_moyenne_ep_REM;
    num_REM_interPeriod_5{n}=num_moyen_ep_REM;
    perc_REM_interPeriod_5{n}=perc_moyen_REM;
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_interPeriod_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_interPeriod_5{n}),and(stages_5{n}.REMEpoch,same_epoch_interPeriod_5{n}),'sleep',tempbin,time_mid_end_first_period,time_mid_end_snd_period);
    dur_totSleep_interPeriod_5{n}=dur_moyenne_ep_totSleep;
    num_totSleep_interPeriod_5{n}=num_moyen_ep_totSleep;
    perc_totSleep_interPeriod_5{n}=perc_moyen_totSleep;
    
    
    %%3H POST 2 JUSQU'A LA FIN
    %%Compute percentage, mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_end_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_end_5{n}),and(stages_5{n}.REMEpoch,same_epoch_end_5{n}),'wake',tempbin,time_mid_end_snd_period,time_end);
    dur_WAKE_end_5{n}=dur_moyenne_ep_WAKE;
    num_WAKE_end_5{n}=num_moyen_ep_WAKE;
    perc_WAKE_end_5{n}=perc_moyen_WAKE;
    
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_end_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_end_5{n}),and(stages_5{n}.REMEpoch,same_epoch_end_5{n}),'sws',tempbin,time_mid_end_snd_period,time_end);
    dur_SWS_end_5{n}=dur_moyenne_ep_SWS;
    num_SWS_end_5{n}=num_moyen_ep_SWS;
    perc_SWS_end_5{n}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_end_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_end_5{n}),and(stages_5{n}.REMEpoch,same_epoch_end_5{n}),'rem',tempbin,time_mid_end_snd_period,time_end);
    dur_REM_end_5{n}=dur_moyenne_ep_REM;
    num_REM_end_5{n}=num_moyen_ep_REM;
    perc_REM_end_5{n}=perc_moyen_REM;
    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_5{n}.Wake,same_epoch_end_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_end_5{n}),and(stages_5{n}.REMEpoch,same_epoch_end_5{n}),'sleep',tempbin,time_mid_end_snd_period,time_end);
    dur_totSleep_end_5{n}=dur_moyenne_ep_totSleep;
    num_totSleep_end_5{n}=num_moyen_ep_totSleep;
    perc_totSleep_end_5{n}=perc_moyen_totSleep;
    
    %%Compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_5{n}.Wake,same_epoch_end_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_end_5{n}),and(stages_5{n}.REMEpoch,same_epoch_end_5{n}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_REM_end_5{n} = trans_REM_to_REM;
    all_trans_REM_SWS_end_5{n} = trans_REM_to_SWS;
    all_trans_REM_WAKE_end_5{n} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_end_5{n} = trans_SWS_to_REM;
    all_trans_SWS_SWS_end_5{n} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_end_5{n} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_end_5{n} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_end_5{n} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_end_5{n} = trans_WAKE_to_WAKE;
    
    
    %%Short versus long REM bouts
    [dur_WAKE_5_bis{n}, durT_WAKE_5(n)]=DurationEpoch(and(stages_5{n}.Wake,same_epoch_end_5{n}),'s');
    [dur_SWS_5_bis{n}, durT_SWS_5(n)]=DurationEpoch(and(stages_5{n}.SWSEpoch,same_epoch_end_5{n}),'s');
    
    [dur_REM_5_bis{n}, durT_REM_5(n)]=DurationEpoch(and(stages_5{n}.REMEpoch,same_epoch_end_5{n}),'s');
    
    idx_short_rem_5_1{n} = find(dur_REM_5_bis{n}<lim_short_rem_1); %short bouts < 10s
    short_REMEpoch_5_1{n} = subset(and(stages_5{n}.REMEpoch,same_epoch_end_5{n}), idx_short_rem_5_1{n});
    [dur_rem_short_5_1{n}, durT_rem_short_5(n)] = DurationEpoch(short_REMEpoch_5_1{n},'s');
    perc_rem_short_5_1(n) = durT_rem_short_5(n) / durT_REM_5(n) * 100;
    dur_moyenne_rem_short_5_1(n) = nanmean(dur_rem_short_5_1{n});
    num_moyen_rem_short_5_1(n) = length(dur_rem_short_5_1{n});
    
    idx_short_rem_5_2{n} = find(dur_REM_5_bis{n}<lim_short_rem_2); %short bouts < 15s
    short_REMEpoch_5_2{n} = subset(and(stages_5{n}.REMEpoch,same_epoch_end_5{n}), idx_short_rem_5_2{n});
    [dur_rem_short_5_2{n}, durT_rem_short_5(n)] = DurationEpoch(short_REMEpoch_5_2{n},'s');
    perc_rem_short_5_2(n) = durT_rem_short_5(n) / durT_REM_5(n) * 100;
    dur_moyenne_rem_short_5_2(n) = nanmean(dur_rem_short_5_2{n});
    num_moyen_rem_short_5_2(n) = length(dur_rem_short_5_2{n});
    
    idx_short_rem_5_3{n} = find(dur_REM_5_bis{n}<lim_short_rem_3);  %short bouts < 20s
    short_REMEpoch_5_3{n} = subset(and(stages_5{n}.REMEpoch,same_epoch_end_5{n}), idx_short_rem_5_3{n});
    [dur_rem_short_5_3{n}, durT_rem_short_5(n)] = DurationEpoch(short_REMEpoch_5_3{n},'s');
    perc_rem_short_5_3(n) = durT_rem_short_5(n) / durT_REM_5(n) * 100;
    dur_moyenne_rem_short_5_3(n) = nanmean(dur_rem_short_5_3{n});
    num_moyen_rem_short_5_3(n) = length(dur_rem_short_5_3{n});
    
    idx_long_rem_5{n} = find(dur_REM_5_bis{n}>lim_long_rem); %long bout
    long_REMEpoch_5{n} = subset(and(stages_5{n}.REMEpoch,same_epoch_end_5{n}), idx_long_rem_5{n});
    [dur_rem_long_5{n}, durT_rem_long_5(n)] = DurationEpoch(long_REMEpoch_5{n},'s');
    perc_rem_long_5(n) = durT_rem_long_5(n) / durT_REM_5(n) * 100;
    dur_moyenne_rem_long_5(n) = nanmean(dur_rem_long_5{n});
    num_moyen_rem_long_5(n) = length(dur_rem_long_5{n});
    
    idx_mid_rem_5{n} = find(dur_REM_5_bis{n}>lim_short_rem_1 & dur_REM_5_bis{n}<lim_long_rem); % middle bouts
    mid_REMEpoch_5{n} = subset(and(stages_5{n}.REMEpoch,same_epoch_end_5{n}), idx_mid_rem_5{n});
    [dur_rem_mid_5{n}, durT_rem_mid_5(n)] = DurationEpoch(mid_REMEpoch_5{n},'s');
    perc_rem_mid_5(n) = durT_rem_mid_5(n) / durT_REM_5(n) * 100;
    dur_moyenne_rem_mid_5(n) = nanmean(dur_rem_mid_5{n});
    num_moyen_rem_mid_5(n) = length(dur_rem_mid_5{n});
    
    
    %%Compute transition probabilities from short REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_5{n}.Wake,same_epoch_end_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_end_5{n}),and(short_REMEpoch_5_1{n},same_epoch_end_5{n}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_short_SWS_end_5{n} = trans_REM_to_SWS;
    all_trans_REM_short_WAKE_end_5{n} = trans_REM_to_WAKE;
    all_trans_REM_short_REM_end_5{n} = trans_REM_to_REM;
    
    %%Compute transition probabilities from mid REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_5{n}.Wake,same_epoch_end_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_end_5{n}),and(mid_REMEpoch_5{n},same_epoch_end_5{n}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_mid_SWS_end_5{n} = trans_REM_to_SWS;
    all_trans_REM_mid_WAKE_end_5{n} = trans_REM_to_WAKE;
    all_trans_REM_mid_REM_end_5{n} = trans_REM_to_REM;
    
    %%Compute transition probabilities from long REM
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_5{n}.Wake,same_epoch_end_5{n}),and(stages_5{n}.SWSEpoch,same_epoch_end_5{n}),and(long_REMEpoch_5{n},same_epoch_end_5{n}),tempbin,time_mid_end_snd_period,time_end);
    all_trans_REM_long_SWS_end_5{n} = trans_REM_to_SWS;
    all_trans_REM_long_WAKE_end_5{n} = trans_REM_to_WAKE;
    all_trans_REM_long_REM_end_5{n} = trans_REM_to_REM;
    
    
end

%% compute average - 5th group
%%percentage/duration/number
for n=1:length(dur_REM_5)
    %%ALL SESSION
    data_dur_REM_5(n,:) = dur_REM_5{n}; data_dur_REM_5(isnan(data_dur_REM_5)==1)=0;
    data_dur_SWS_5(n,:) = dur_SWS_5{n}; data_dur_SWS_5(isnan(data_dur_SWS_5)==1)=0;
    data_dur_WAKE_5(n,:) = dur_WAKE_5{n}; data_dur_WAKE_5(isnan(data_dur_WAKE_5)==1)=0;
    data_dur_totSleep_5(n,:) = dur_totSleep_5{n}; data_dur_totSleep_5(isnan(data_dur_totSleep_5)==1)=0;
    
    data_num_REM_5(n,:) = num_REM_5{n};data_num_REM_5(isnan(data_num_REM_5)==1)=0;
    data_num_SWS_5(n,:) = num_SWS_5{n}; data_num_SWS_5(isnan(data_num_SWS_5)==1)=0;
    data_num_WAKE_5(n,:) = num_WAKE_5{n}; data_num_WAKE_5(isnan(data_num_WAKE_5)==1)=0;
    data_num_totSleep_5(n,:) = num_totSleep_5{n}; data_num_totSleep_5(isnan(data_num_totSleep_5)==1)=0;
    
    data_perc_REM_5(n,:) = perc_REM_5{n}; data_perc_REM_5(isnan(data_perc_REM_5)==1)=0;
    data_perc_SWS_5(n,:) = perc_SWS_5{n}; data_perc_SWS_5(isnan(data_perc_SWS_5)==1)=0;
    data_perc_WAKE_5(n,:) = perc_WAKE_5{n}; data_perc_WAKE_5(isnan(data_perc_WAKE_5)==1)=0;
    data_perc_totSleep_5(n,:) = perc_totSleep_5{n}; data_perc_totSleep_5(isnan(data_perc_totSleep_5)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_begin_5(n,:) = dur_REM_begin_5{n}; data_dur_REM_begin_5(isnan(data_dur_REM_begin_5)==1)=0;
    data_dur_SWS_begin_5(n,:) = dur_SWS_begin_5{n}; data_dur_SWS_begin_5(isnan(data_dur_SWS_begin_5)==1)=0;
    data_dur_WAKE_begin_5(n,:) = dur_WAKE_begin_5{n}; data_dur_WAKE_begin_5(isnan(data_dur_WAKE_begin_5)==1)=0;
    data_dur_totSleep_begin_5(n,:) = dur_totSleep_begin_5{n}; data_dur_totSleep_begin_5(isnan(data_dur_totSleep_begin_5)==1)=0;
    
    
    data_num_REM_begin_5(n,:) = num_REM_begin_5{n};data_num_REM_begin_5(isnan(data_num_REM_begin_5)==1)=0;
    data_num_SWS_begin_5(n,:) = num_SWS_begin_5{n}; data_num_SWS_begin_5(isnan(data_num_SWS_begin_5)==1)=0;
    data_num_WAKE_begin_5(n,:) = num_WAKE_begin_5{n}; data_num_WAKE_begin_5(isnan(data_num_WAKE_begin_5)==1)=0;
    data_num_totSleep_begin_5(n,:) = num_totSleep_begin_5{n}; data_num_totSleep_begin_5(isnan(data_num_totSleep_begin_5)==1)=0;
    
    data_perc_REM_begin_5(n,:) = perc_REM_begin_5{n}; data_perc_REM_begin_5(isnan(data_perc_REM_begin_5)==1)=0;
    data_perc_SWS_begin_5(n,:) = perc_SWS_begin_5{n}; data_perc_SWS_begin_5(isnan(data_perc_SWS_begin_5)==1)=0;
    data_perc_WAKE_begin_5(n,:) = perc_WAKE_begin_5{n}; data_perc_WAKE_begin_5(isnan(data_perc_WAKE_begin_5)==1)=0;
    data_perc_totSleep_begin_5(n,:) = perc_totSleep_begin_5{n}; data_perc_totSleep_begin_5(isnan(data_perc_totSleep_begin_5)==1)=0;
    
    data_durT_REM_begin_5(n,:) = durT_REM_begin_5(n); data_durT_REM_begin_5(isnan(data_durT_REM_begin_5)==1)=0;
    data_durT_SWS_begin_5(n,:) = durT_SWS_begin_5(n); data_durT_SWS_begin_5(isnan(data_durT_SWS_begin_5)==1)=0;
    data_durT_WAKE_begin_5(n,:) = durT_WAKE_begin_5(n); data_durT_WAKE_begin_5(isnan(data_durT_WAKE_begin_5)==1)=0;
    
    %%second phase
    data_dur_REM_interPeriod_5(n,:) = dur_REM_interPeriod_5{n}; data_dur_REM_interPeriod_5(isnan(data_dur_REM_interPeriod_5)==1)=0;
    data_dur_SWS_interPeriod_5(n,:) = dur_SWS_interPeriod_5{n}; data_dur_SWS_interPeriod_5(isnan(data_dur_SWS_interPeriod_5)==1)=0;
    data_dur_WAKE_interPeriod_5(n,:) = dur_WAKE_interPeriod_5{n}; data_dur_WAKE_interPeriod_5(isnan(data_dur_WAKE_interPeriod_5)==1)=0;
    data_dur_totSleep_interPeriod_5(n,:) = dur_totSleep_interPeriod_5{n}; data_dur_totSleep_interPeriod_5(isnan(data_dur_totSleep_interPeriod_5)==1)=0;
    
    
    data_num_REM_interPeriod_5(n,:) = num_REM_interPeriod_5{n};data_num_REM_interPeriod_5(isnan(data_num_REM_interPeriod_5)==1)=0;
    data_num_SWS_interPeriod_5(n,:) = num_SWS_interPeriod_5{n}; data_num_SWS_interPeriod_5(isnan(data_num_SWS_interPeriod_5)==1)=0;
    data_num_WAKE_interPeriod_5(n,:) = num_WAKE_interPeriod_5{n}; data_num_WAKE_interPeriod_5(isnan(data_num_WAKE_interPeriod_5)==1)=0;
    data_num_totSleep_interPeriod_5(n,:) = num_totSleep_interPeriod_5{n}; data_num_totSleep_interPeriod_5(isnan(data_num_totSleep_interPeriod_5)==1)=0;
    
    data_perc_REM_interPeriod_5(n,:) = perc_REM_interPeriod_5{n}; data_perc_REM_interPeriod_5(isnan(data_perc_REM_interPeriod_5)==1)=0;
    data_perc_SWS_interPeriod_5(n,:) = perc_SWS_interPeriod_5{n}; data_perc_SWS_interPeriod_5(isnan(data_perc_SWS_interPeriod_5)==1)=0;
    data_perc_WAKE_interPeriod_5(n,:) = perc_WAKE_interPeriod_5{n}; data_perc_WAKE_interPeriod_5(isnan(data_perc_WAKE_interPeriod_5)==1)=0;
    data_perc_totSleep_interPeriod_5(n,:) = perc_totSleep_interPeriod_5{n}; data_perc_totSleep_interPeriod_5(isnan(data_perc_totSleep_interPeriod_5)==1)=0;
    
    
    
    %%FIN DE LA SESSION
    data_dur_REM_end_5(n,:) = dur_REM_end_5{n}; data_dur_REM_end_5(isnan(data_dur_REM_end_5)==1)=0;
    data_dur_SWS_end_5(n,:) = dur_SWS_end_5{n}; data_dur_SWS_end_5(isnan(data_dur_SWS_end_5)==1)=0;
    data_dur_WAKE_end_5(n,:) = dur_WAKE_end_5{n}; data_dur_WAKE_end_5(isnan(data_dur_WAKE_end_5)==1)=0;
    data_dur_totSleep_end_5(n,:) = dur_totSleep_end_5{n}; data_dur_totSleep_end_5(isnan(data_dur_totSleep_end_5)==1)=0;
    
    
    data_num_REM_end_5(n,:) = num_REM_end_5{n};data_num_REM_end_5(isnan(data_num_REM_end_5)==1)=0;
    data_num_SWS_end_5(n,:) = num_SWS_end_5{n}; data_num_SWS_end_5(isnan(data_num_SWS_end_5)==1)=0;
    data_num_WAKE_end_5(n,:) = num_WAKE_end_5{n}; data_num_WAKE_end_5(isnan(data_num_WAKE_end_5)==1)=0;
    data_num_totSleep_end_5(n,:) = num_totSleep_end_5{n}; data_num_totSleep_end_5(isnan(data_num_totSleep_end_5)==1)=0;
    
    
    data_perc_REM_end_5(n,:) = perc_REM_end_5{n}; data_perc_REM_end_5(isnan(data_perc_REM_end_5)==1)=0;
    data_perc_SWS_end_5(n,:) = perc_SWS_end_5{n}; data_perc_SWS_end_5(isnan(data_perc_SWS_end_5)==1)=0;
    data_perc_WAKE_end_5(n,:) = perc_WAKE_end_5{n}; data_perc_WAKE_end_5(isnan(data_perc_WAKE_end_5)==1)=0;
    data_perc_totSleep_end_5(n,:) = perc_totSleep_end_5{n}; data_perc_totSleep_end_5(isnan(data_perc_totSleep_end_5)==1)=0;
    
end
%%probability
for m=1:length(all_trans_REM_REM_5)
% %     %%ALL SESSION
% %     data_REM_REM_5(n,:) = all_trans_REM_REM_5{n}; data_REM_REM_5(isnan(data_REM_REM_5)==1)=0;
% %     data_REM_SWS_5(n,:) = all_trans_REM_SWS_5{n}; data_REM_SWS_5(isnan(data_REM_SWS_5)==1)=0;
% %     data_REM_WAKE_5(n,:) = all_trans_REM_WAKE_5{n}; data_REM_WAKE_5(isnan(data_REM_WAKE_5)==1)=0;
% %
% %     data_SWS_SWS_5(n,:) = all_trans_SWS_SWS_5{n}; data_SWS_SWS_5(isnan(data_SWS_SWS_5)==1)=0;
% %     data_SWS_REM_5(n,:) = all_trans_SWS_REM_5{n}; data_SWS_REM_5(isnan(data_SWS_REM_5)==1)=0;
% %     data_SWS_WAKE_5(n,:) = all_trans_SWS_WAKE_5{n}; data_SWS_WAKE_5(isnan(data_SWS_WAKE_5)==1)=0;
% %
% %     data_WAKE_WAKE_5(n,:) = all_trans_WAKE_WAKE_5{n}; data_WAKE_WAKE_5(isnan(data_WAKE_WAKE_5)==1)=0;
% %     data_WAKE_REM_5(n,:) = all_trans_WAKE_REM_5{n}; data_WAKE_REM_5(isnan(data_WAKE_REM_5)==1)=0;
% %     data_WAKE_SWS_5(n,:) = all_trans_WAKE_SWS_5{n}; data_WAKE_SWS_5(isnan(data_WAKE_SWS_5)==1)=0;
% %
% %     %%3 PREMI7RES HEURES
% %         data_REM_REM_begin_5(n,:) = all_trans_REM_REM_begin_5{n}; data_REM_REM_begin_5(isnan(data_REM_REM_begin_5)==1)=0;
% %     data_REM_SWS_begin_5(n,:) = all_trans_REM_SWS_begin_5{n}; data_REM_SWS_begin_5(isnan(data_REM_SWS_begin_5)==1)=0;
% %     data_REM_WAKE_begin_5(n,:) = all_trans_REM_WAKE_begin_5{n}; data_REM_WAKE_begin_5(isnan(data_REM_WAKE_begin_5)==1)=0;
% %
% %     data_SWS_SWS_begin_5(n,:) = all_trans_SWS_SWS_begin_5{n}; data_SWS_SWS_begin_5(isnan(data_SWS_SWS_begin_5)==1)=0;
% %     data_SWS_REM_begin_5(n,:) = all_trans_SWS_REM_begin_5{n}; data_SWS_REM_begin_5(isnan(data_SWS_REM_begin_5)==1)=0;
% %     data_SWS_WAKE_begin_5(n,:) = all_trans_SWS_WAKE_begin_5{n}; data_SWS_WAKE_begin_5(isnan(data_SWS_WAKE_begin_5)==1)=0;
% %
% %     data_WAKE_WAKE_begin_5(n,:) = all_trans_WAKE_WAKE_begin_5{n}; data_WAKE_WAKE_begin_5(isnan(data_WAKE_WAKE_begin_5)==1)=0;
% %     data_WAKE_REM_begin_5(n,:) = all_trans_WAKE_REM_begin_5{n}; data_WAKE_REM_begin_5(isnan(data_WAKE_REM_begin_5)==1)=0;
% %     data_WAKE_SWS_begin_5(n,:) = all_trans_WAKE_SWS_begin_5{n}; data_WAKE_SWS_begin_5(isnan(data_WAKE_SWS_begin_5)==1)=0;
% %
% %     %%FIN DE LA SESSION
% %         data_REM_REM_end_5(n,:) = all_trans_REM_REM_end_5{n}; data_REM_REM_end_5(isnan(data_REM_REM_end_5)==1)=0;
% %     data_REM_SWS_end_5(n,:) = all_trans_REM_SWS_end_5{n}; data_REM_SWS_end_5(isnan(data_REM_SWS_end_5)==1)=0;
% %     data_REM_WAKE_end_5(n,:) = all_trans_REM_WAKE_end_5{n}; data_REM_WAKE_end_5(isnan(data_REM_WAKE_end_5)==1)=0;
% %
% %     data_SWS_SWS_end_5(n,:) = all_trans_SWS_SWS_end_5{n}; data_SWS_SWS_end_5(isnan(data_SWS_SWS_end_5)==1)=0;
% %     data_SWS_REM_end_5(n,:) = all_trans_SWS_REM_end_5{n}; data_SWS_REM_end_5(isnan(data_SWS_REM_end_5)==1)=0;
% %     data_SWS_WAKE_end_5(n,:) = all_trans_SWS_WAKE_end_5{n}; data_SWS_WAKE_end_5(isnan(data_SWS_WAKE_end_5)==1)=0;
% %
% %     data_WAKE_WAKE_end_5(n,:) = all_trans_WAKE_WAKE_end_5{n}; data_WAKE_WAKE_end_5(isnan(data_WAKE_WAKE_end_5)==1)=0;
% %     data_WAKE_REM_end_5(n,:) = all_trans_WAKE_REM_end_5{n}; data_WAKE_REM_end_5(isnan(data_WAKE_REM_end_5)==1)=0;
% %     data_WAKE_SWS_end_5(n,:) = all_trans_WAKE_SWS_end_5{n}; data_WAKE_SWS_end_5(isnan(data_WAKE_SWS_end_5)==1)=0;
data_REM_short_WAKE_end_5(n,:) = all_trans_REM_short_WAKE_end_5{n}; data_REM_short_WAKE_end_5(isnan(data_REM_short_WAKE_end_5)==1)=0;
data_REM_short_SWS_end_5(n,:) = all_trans_REM_short_SWS_end_5{n}; data_REM_short_SWS_end_5(isnan(data_REM_short_SWS_end_5)==1)=0;

data_REM_mid_WAKE_end_5(n,:) = all_trans_REM_mid_WAKE_end_5{n}; data_REM_mid_WAKE_end_5(isnan(data_REM_mid_WAKE_end_5)==1)=0;
data_REM_mid_SWS_end_5(n,:) = all_trans_REM_mid_SWS_end_5{n}; data_REM_mid_SWS_end_5(isnan(data_REM_mid_SWS_end_5)==1)=0;

data_REM_long_WAKE_end_5(n,:) = all_trans_REM_long_WAKE_end_5{n}; data_REM_long_WAKE_end_5(isnan(data_REM_long_WAKE_end_5)==1)=0;
data_REM_long_SWS_end_5(n,:) = all_trans_REM_long_SWS_end_5{n}; data_REM_long_SWS_end_5(isnan(data_REM_long_SWS_end_5)==1)=0;


data_REM_short_REM_end_5(n,:) = all_trans_REM_short_REM_end_5{n}; data_REM_short_REM_end_5(isnan(data_REM_short_REM_end_5)==1)=0;
data_REM_mid_REM_end_5(n,:) = all_trans_REM_mid_REM_end_5{n}; data_REM_mid_REM_end_5(isnan(data_REM_mid_REM_end_5)==1)=0;
data_REM_long_REM_end_5(n,:) = all_trans_REM_long_REM_end_5{n}; data_REM_long_REM_end_5(isnan(data_REM_long_REM_end_5)==1)=0;


end

