
%% input dir
%%1
Dir_ctrl= PathForExperiments_DREADD_AD ('mCherry_CRH_VLPO_SalineInjection_10am');

%%2
DirSocialDefeat_classic = PathForExperiments_SleepPostSD_AD('SleepPostSD_mCherry_CRH_VLPO_SalineInjection_10am');

%%3
DirSocialDefeat_totSleepPost_mCherry_cno = PathForExperiments_SleepPostSD_AD('SleepPostSD_mCherry_CRH_VLPO_CNOInjection_10am');

%%4
DirSocialDefeat_totSleepPost_dreadd_cno =PathForExperiments_SleepPostSD_AD('SleepPostSD_inhibDREADD_CRH_VLPO_CNOInjection_10am');
%%
%% parameters

tempbin = 3600; %bin size to plot variables overtime

time_st = 0*3600*1e4; %begining of the sleep session
time_end=3*1e8;  %end of the sleep session

time_mid_end_first_period = 8*3600*1e4; %1.5         %2 first hours (insomnia)
time_mid_begin_snd_period = 8.1*3600*1e4;%3.3           %2 last hours(late phase of the night)

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
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, dur_tot_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_all_sess_ctrl{i}),'wake',tempbin,time_st,time_end);
    dur_WAKE_ctrl{i}=dur_moyenne_ep_WAKE;
    num_WAKE_ctrl{i}=num_moyen_ep_WAKE;
    perc_WAKE_ctrl{i}=perc_moyen_WAKE;
    [dur_WAKE_ctrl_bis{i}, durT_WAKE_ctrl(i)]=DurationEpoch(and(stages_ctrl{i}.Wake,same_epoch_begin_ctrl{i}),'min');
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS,dur_tot_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_all_sess_ctrl{i}),'sws',tempbin,time_st,time_end);
    dur_SWS_ctrl{i}=dur_moyenne_ep_SWS;
    num_SWS_ctrl{i}=num_moyen_ep_SWS;
    perc_SWS_ctrl{i}=perc_moyen_SWS;
    [dur_SWS_ctrl_bis{i}, durT_SWS_ctrl(i)]=DurationEpoch(and(stages_ctrl{i}.SWSEpoch,same_epoch_begin_ctrl{i}),'min');
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, dur_tot_REM,rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_all_sess_ctrl{i}),'rem',tempbin,time_st,time_end);
    dur_REM_ctrl{i}=dur_moyenne_ep_REM;
    num_REM_ctrl{i}=num_moyen_ep_REM;
    perc_REM_ctrl{i}=perc_moyen_REM;
    [dur_REM_ctrl_bis{i}, durT_REM_ctrl(i)]=DurationEpoch(and(stages_ctrl{i}.REMEpoch,same_epoch_begin_ctrl{i}),'min');

    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep,dur_tot_Sleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{i}.Wake,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.SWSEpoch,same_epoch_all_sess_ctrl{i}),and(stages_ctrl{i}.REMEpoch,same_epoch_all_sess_ctrl{i}),'sleep',tempbin,time_st,time_end);
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
    
    data_durT_REM_ctrl(i,:) = durT_REM_ctrl(i); data_durT_REM_ctrl(isnan(data_durT_REM_ctrl)==1)=0;
    data_durT_SWS_ctrl(i,:) = durT_SWS_ctrl(i); data_durT_SWS_ctrl(isnan(data_durT_SWS_ctrl)==1)=0;
    data_durT_WAKE_ctrl(i,:) = durT_WAKE_ctrl(i); data_durT_WAKE_ctrl(isnan(data_durT_WAKE_ctrl)==1)=0;

    %%8 PREMI7RES HEURES
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
    [dur_WAKE_SD_bis{k}, durT_WAKE_SD(k)]=DurationEpoch(and(stages_SD{k}.Wake,same_epoch_begin_SD{k}),'min');

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_SD{k}=num_moyen_ep_SWS;
    perc_SWS_SD{k}=perc_moyen_SWS;
    [dur_SWS_SD_bis{k}, durT_SWS_SD(k)]=DurationEpoch(and(stages_SD{k}.SWSEpoch,same_epoch_begin_SD{k}),'min');

    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'rem',tempbin,time_st,time_end);
    dur_REM_SD{k}=dur_moyenne_ep_REM;
    num_REM_SD{k}=num_moyen_ep_REM;
    perc_REM_SD{k}=perc_moyen_REM;
    [dur_REM_SD_bis{k}, durT_REM_SD(k)]=DurationEpoch(and(stages_SD{k}.REMEpoch,same_epoch_begin_SD{k}),'min');

    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_SD{k}=dur_moyenne_ep_totSleep;
    num_totSleep_SD{k}=num_moyen_ep_totSleep;
    perc_totSleep_SD{k}=perc_moyen_totSleep;
    
    
    
    
    %%8 PREMIERE HEURES APRES SD
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
    
    
end

%% compute average - SD group (mCherry saline injection 10h)
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
    
    data_durT_REM_SD(k,:) = durT_REM_SD(k); data_durT_REM_SD(isnan(data_durT_REM_SD)==1)=0;
    data_durT_SWS_SD(k,:) = durT_SWS_SD(k); data_durT_SWS_SD(isnan(data_durT_SWS_SD)==1)=0;
    data_durT_WAKE_SD(k,:) = durT_WAKE_SD(k); data_durT_WAKE_SD(isnan(data_durT_WAKE_SD)==1)=0;
    
    %8 PREMI7RES HEURES
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
    [dur_WAKE_SD_mCherry_cno_bis{j}, durT_WAKE_SD_mCherry_cno(j)]=DurationEpoch(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_begin_SD_mCherry_cno{j}),'min');
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_SD_mCherry_cno{j}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_mCherry_cno{j}=dur_moyenne_ep_SWS;
    num_SWS_SD_mCherry_cno{j}=num_moyen_ep_SWS;
    perc_SWS_SD_mCherry_cno{j}=perc_moyen_SWS;
    [dur_SWS_SD_mCherry_cno_bis{j}, durT_SWS_SD_mCherry_cno(j)]=DurationEpoch(and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_begin_SD_mCherry_cno{j}),'min');

    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_SD_mCherry_cno{j}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_mCherry_cno{j}=dur_moyenne_ep_REM;
    num_REM_SD_mCherry_cno{j}=num_moyen_ep_REM;
    perc_REM_SD_mCherry_cno{j}=perc_moyen_REM;
    [dur_REM_SD_mCherry_cno_bis{j}, durT_REM_SD_mCherry_cno(j)]=DurationEpoch(and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_begin_SD_mCherry_cno{j}),'min');

    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{j}.Wake,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.SWSEpoch,same_epoch_SD_mCherry_cno{j}),and(stages_SD_mCherry_cno{j}.REMEpoch,same_epoch_SD_mCherry_cno{j}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_SD_mCherry_cno{j}=dur_moyenne_ep_totSleep;
    num_totSleep_SD_mCherry_cno{j}=num_moyen_ep_totSleep;
    perc_totSleep_SD_mCherry_cno{j}=perc_moyen_totSleep;
    
   
    
    %%8 PREMI7RE HEUES APRES SD
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
    
    data_durT_REM_SD_mCherry_cno(j,:) = durT_REM_SD_mCherry_cno(j); data_durT_REM_SD_mCherry_cno(isnan(data_durT_REM_SD_mCherry_cno)==1)=0;
    data_durT_SWS_SD_mCherry_cno(j,:) = durT_SWS_SD_mCherry_cno(j); data_durT_SWS_SD_mCherry_cno(isnan(data_durT_SWS_SD_mCherry_cno)==1)=0;
    data_durT_WAKE_SD_mCherry_cno(j,:) = durT_WAKE_SD_mCherry_cno(j); data_durT_WAKE_SD_mCherry_cno(isnan(data_durT_WAKE_SD_mCherry_cno)==1)=0;
    
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
    [dur_WAKE_SD_dreadd_cno_bis{m}, durT_WAKE_SD_dreadd_cno(m)]=DurationEpoch(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_begin_SD_dreadd_cno{m}),'min');

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_SD_dreadd_cno{m}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_dreadd_cno{m}=dur_moyenne_ep_SWS;
    num_SWS_SD_dreadd_cno{m}=num_moyen_ep_SWS;
    perc_SWS_SD_dreadd_cno{m}=perc_moyen_SWS;
    [dur_SWS_SD_dreadd_cno_bis{m}, durT_SWS_SD_dreadd_cno(m)]=DurationEpoch(and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_begin_SD_dreadd_cno{m}),'min');

    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_SD_dreadd_cno{m}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_dreadd_cno{m}=dur_moyenne_ep_REM;
    num_REM_SD_dreadd_cno{m}=num_moyen_ep_REM;
    perc_REM_SD_dreadd_cno{m}=perc_moyen_REM;
    [dur_REM_SD_dreadd_cno_bis{m}, durT_REM_SD_dreadd_cno(m)]=DurationEpoch(and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_begin_SD_dreadd_cno{m}),'min');

    
    
    [dur_moyenne_ep_totSleep, num_moyen_ep_totSleep,perc_moyen_totSleep, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{m}.Wake,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.SWSEpoch,same_epoch_SD_dreadd_cno{m}),and(stages_SD_dreadd_cno{m}.REMEpoch,same_epoch_SD_dreadd_cno{m}),'sleep',tempbin,time_st,time_end);
    dur_totSleep_SD_dreadd_cno{m}=dur_moyenne_ep_totSleep;
    num_totSleep_SD_dreadd_cno{m}=num_moyen_ep_totSleep;
    perc_totSleep_SD_dreadd_cno{m}=perc_moyen_totSleep;
    
    
    
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
    
    data_durT_REM_SD_dreadd_cno(m,:) = durT_REM_SD_dreadd_cno(m); data_durT_REM_SD_dreadd_cno(isnan(data_durT_REM_SD_dreadd_cno)==1)=0;
    data_durT_SWS_SD_dreadd_cno(m,:) = durT_SWS_SD_dreadd_cno(m); data_durT_SWS_SD_dreadd_cno(isnan(data_durT_SWS_SD_dreadd_cno)==1)=0;
    data_durT_WAKE_SD_dreadd_cno(m,:) = durT_WAKE_SD_dreadd_cno(m); data_durT_WAKE_SD_dreadd_cno(isnan(data_durT_WAKE_SD_dreadd_cno)==1)=0;
    
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
    
end

