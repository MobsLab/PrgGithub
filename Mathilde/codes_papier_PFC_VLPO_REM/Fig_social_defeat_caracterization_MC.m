%% input dir : sleep post SD
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');

DirSocialDefeat_sleepPost_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_sleepPost_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_sleepPost_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_sleepPost_mCherry_saline = MergePathForExperiment(DirSocialDefeat_sleepPost_mCherry_saline1,DirSocialDefeat_sleepPost_BM_saline1);
DirSocialDefeat_sleepPost_classic = MergePathForExperiment(DirSocialDefeat_sleepPost_classic1,DirSocialDefeat_sleepPost_mCherry_saline);


%% input dir : EMP post SD
% Dir_EPM_sal = PathForExperiments_EPM_MC('EPM_10h_behav_dreadd_exci_saline');
% Dir_EPM_cno = PathForExperiments_EPM_MC('EPM_10h_behav_dreadd_exci_cno');
Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_ctrl');
Dir_EPM_sal = RestrictPathForExperiment(Dir_EPM_1,'nMice',[1449,1450,1451])
Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
Dir_EPM_cno = RestrictPathForExperiment(Dir_EPM_2,'nMice',[1429,1430,1431,1432]);
Dir_EPM_2 = RestrictPathForExperiment(Dir_EPM_2,'nMice',[1466 1467 1468 1470]);

Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_Post_SD');
Dir_EPM_cno = RestrictPathForExperiment(Dir_EPM_3,'nMice',[1429,1430,1431,1432]);


%% parameters
tempbin = 3600/2;
time_end=3*1e8;
time_st = 0;
time_mid = 3*3600*1e4;

min_sws_time = 3*1e4*60;
binH = 2;

lim_short = 20;
lim_long = 40;

nb_attacks = [2 4 8 5 2 6 8 9 9 10 13];

%% GET DATA - ctrl group (mCherry saline injection 10h)
for i=1:length(Dir_ctrl.path)
    cd(Dir_ctrl.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_ctrl{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_ctrl{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
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
    
    idx_short_rem_ctrl{i} = find(dur_REM_ctrl_bis{i}<lim_short);
    short_REMEpoch_ctrl{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}), idx_short_rem_ctrl{i});
    [dur_rem_short_ctrl{i}, durT_rem_short_ctrl(i)] = DurationEpoch(short_REMEpoch_ctrl{i},'s');
    perc_rem_short_ctrl(i) = durT_rem_short_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_short_ctrl(i) = nanmean(dur_rem_short_ctrl{i});
    num_moyen_rem_short_ctrl(i) = length(dur_rem_short_ctrl{i});
    
    idx_long_rem_ctrl{i} = find(dur_REM_ctrl_bis{i}>lim_long);
    long_REMEpoch_ctrl{i} = subset(and(stages_ctrl{i}.REMEpoch,same_epoch_3_end_ctrl{i}), idx_long_rem_ctrl{i});
    [dur_rem_long_ctrl{i}, durT_rem_long_ctrl(i)] = DurationEpoch(long_REMEpoch_ctrl{i},'s');
    perc_rem_long_ctrl(i) = durT_rem_long_ctrl(i) / durT_REM_ctrl(i) * 100;
    dur_moyenne_rem_long_ctrl(i) = nanmean(dur_rem_long_ctrl{i});
    num_moyen_rem_long_ctrl(i) = length(dur_rem_long_ctrl{i});
    
    idx_mid_rem_ctrl{i} = find(dur_REM_ctrl_bis{i}>lim_short & dur_REM_ctrl_bis{i}<lim_long);
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
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
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
    
    idx_short_rem_SD{k} = find(dur_REM_SD_bis{k}<lim_short);
    short_REMEpoch_SD{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_short_rem_SD{k});
    [dur_rem_short_SD{k}, durT_rem_short_SD(k)] = DurationEpoch(short_REMEpoch_SD{k},'s');
    perc_rem_short_SD(k) = durT_rem_short_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_short_SD(k) = nanmean(dur_rem_short_SD{k});
    num_moyen_rem_short_SD(k) = length(dur_rem_short_SD{k});
    
    idx_long_rem_SD{k} = find(dur_REM_SD_bis{k}>lim_long);
    long_REMEpoch_SD{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_long_rem_SD{k});
    [dur_rem_long_SD{k}, durT_rem_long_SD(k)] = DurationEpoch(long_REMEpoch_SD{k},'s');
    perc_rem_long_SD(k) = durT_rem_long_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_long_SD(k) = nanmean(dur_rem_long_SD{k});
    num_moyen_rem_long_SD(k) = length(dur_rem_long_SD{k});
    
  
    idx_mid_rem_SD{k} = find(dur_REM_SD_bis{k}>lim_short & dur_REM_SD_bis{k}<lim_long);
    mid_REMEpoch_SD{k} = subset(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}), idx_mid_rem_SD{k});
    [dur_rem_mid_SD{k}, durT_rem_mid_SD(k)] = DurationEpoch(mid_REMEpoch_SD{k},'s');
    perc_rem_mid_SD(k) = durT_rem_mid_SD(k) / durT_REM_SD(k) * 100;
    dur_moyenne_rem_mid_SD(k) = nanmean(dur_rem_mid_SD{k});
    num_moyen_rem_mid_SD(k) = length(dur_rem_mid_SD{k});
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
%%probability
for k=1:length(all_trans_REM_REM_SD)
    %%ALL SESSION
    data_REM_REM_SD(k,:) = all_trans_REM_REM_SD{k}; data_REM_REM_SD(isnan(data_REM_REM_SD)==1)=0;
    data_REM_SWS_SD(k,:) = all_trans_REM_SWS_SD{k}; data_REM_SWS_SD(isnan(data_REM_SWS_SD)==1)=0;
    data_REM_WAKE_SD(k,:) = all_trans_REM_WAKE_SD{k}; data_REM_WAKE_SD(isnan(data_REM_WAKE_SD)==1)=0;
    
    data_SWS_SWS_SD(k,:) = all_trans_SWS_SWS_SD{k}; data_SWS_SWS_SD(isnan(data_SWS_SWS_SD)==1)=0;
    data_SWS_REM_SD(k,:) = all_trans_SWS_REM_SD{k}; data_SWS_REM_SD(isnan(data_SWS_REM_SD)==1)=0;
    data_SWS_WAKE_SD(k,:) = all_trans_SWS_WAKE_SD{k}; data_SWS_WAKE_SD(isnan(data_SWS_WAKE_SD)==1)=0;
    
    data_WAKE_WAKE_SD(k,:) = all_trans_WAKE_WAKE_SD{k}; data_WAKE_WAKE_SD(isnan(data_WAKE_WAKE_SD)==1)=0;
    data_WAKE_REM_SD(k,:) = all_trans_WAKE_REM_SD{k}; data_WAKE_REM_SD(isnan(data_WAKE_REM_SD)==1)=0;
    data_WAKE_SWS_SD(k,:) = all_trans_WAKE_SWS_SD{k}; data_WAKE_SWS_SD(isnan(data_WAKE_SWS_SD)==1)=0;
    
    %%3 PREMI7RES HEURES
        data_REM_REM_1_3h_SD(k,:) = all_trans_REM_REM_1_3h_SD{k}; data_REM_REM_1_3h_SD(isnan(data_REM_REM_1_3h_SD)==1)=0;
    data_REM_SWS_1_3h_SD(k,:) = all_trans_REM_SWS_1_3h_SD{k}; data_REM_SWS_1_3h_SD(isnan(data_REM_SWS_1_3h_SD)==1)=0;
    data_REM_WAKE_1_3h_SD(k,:) = all_trans_REM_WAKE_1_3h_SD{k}; data_REM_WAKE_1_3h_SD(isnan(data_REM_WAKE_1_3h_SD)==1)=0;
    
    data_SWS_SWS_1_3h_SD(k,:) = all_trans_SWS_SWS_1_3h_SD{k}; data_SWS_SWS_1_3h_SD(isnan(data_SWS_SWS_1_3h_SD)==1)=0;
    data_SWS_REM_1_3h_SD(k,:) = all_trans_SWS_REM_1_3h_SD{k}; data_SWS_REM_1_3h_SD(isnan(data_SWS_REM_1_3h_SD)==1)=0;
    data_SWS_WAKE_1_3h_SD(k,:) = all_trans_SWS_WAKE_1_3h_SD{k}; data_SWS_WAKE_1_3h_SD(isnan(data_SWS_WAKE_1_3h_SD)==1)=0;
    
    data_WAKE_WAKE_1_3h_SD(k,:) = all_trans_WAKE_WAKE_1_3h_SD{k}; data_WAKE_WAKE_1_3h_SD(isnan(data_WAKE_WAKE_1_3h_SD)==1)=0;
    data_WAKE_REM_1_3h_SD(k,:) = all_trans_WAKE_REM_1_3h_SD{k}; data_WAKE_REM_1_3h_SD(isnan(data_WAKE_REM_1_3h_SD)==1)=0;
    data_WAKE_SWS_1_3h_SD(k,:) = all_trans_WAKE_SWS_1_3h_SD{k}; data_WAKE_SWS_1_3h_SD(isnan(data_WAKE_SWS_1_3h_SD)==1)=0;
    
    %%FIN DE LA SESSION
        data_REM_REM_3_end_SD(k,:) = all_trans_REM_REM_3_end_SD{k}; data_REM_REM_3_end_SD(isnan(data_REM_REM_3_end_SD)==1)=0;
    data_REM_SWS_3_end_SD(k,:) = all_trans_REM_SWS_3_end_SD{k}; data_REM_SWS_3_end_SD(isnan(data_REM_SWS_3_end_SD)==1)=0;
    data_REM_WAKE_3_end_SD(k,:) = all_trans_REM_WAKE_3_end_SD{k}; data_REM_WAKE_3_end_SD(isnan(data_REM_WAKE_3_end_SD)==1)=0;
    
    data_SWS_SWS_3_end_SD(k,:) = all_trans_SWS_SWS_3_end_SD{k}; data_SWS_SWS_3_end_SD(isnan(data_SWS_SWS_3_end_SD)==1)=0;
    data_SWS_REM_3_end_SD(k,:) = all_trans_SWS_REM_3_end_SD{k}; data_SWS_REM_3_end_SD(isnan(data_SWS_REM_3_end_SD)==1)=0;
    data_SWS_WAKE_3_end_SD(k,:) = all_trans_SWS_WAKE_3_end_SD{k}; data_SWS_WAKE_3_end_SD(isnan(data_SWS_WAKE_3_end_SD)==1)=0;
    
    data_WAKE_WAKE_3_end_SD(k,:) = all_trans_WAKE_WAKE_3_end_SD{k}; data_WAKE_WAKE_3_end_SD(isnan(data_WAKE_WAKE_3_end_SD)==1)=0;
    data_WAKE_REM_3_end_SD(k,:) = all_trans_WAKE_REM_3_end_SD{k}; data_WAKE_REM_3_end_SD(isnan(data_WAKE_REM_3_end_SD)==1)=0;
    data_WAKE_SWS_3_end_SD(k,:) = all_trans_WAKE_SWS_3_end_SD{k}; data_WAKE_SWS_3_end_SD(isnan(data_WAKE_SWS_3_end_SD)==1)=0;
    
end



%% EPM

%% EPM Baseline
for i = 1:length(Dir_EPM_1.path)
    cd(Dir_EPM_1.path{i}{1})
    behav_basal{i} = load ('behavResources.mat');
    %proportion (occupancy)
    occup_open_basal(i) = behav_basal{i}.Occup_redefined(1);
end


%% EPM post Social Defeat dangerous
for j = 1:length(Dir_EPM_3.path)
    cd(Dir_EPM_3.path{j}{1})
    behav_SD{j} = load ('behavResources.mat');
    %proportion (occupancy)
    occup_open_SD(j) = behav_SD{j}.Occup_redefined(1);
end

%% FIGURE
txt_size = 15;

col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];


figure, hold on
subplot(4,6,[7,8]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('Wake percentage')


subplot(4,6,[9,10]), hold on % SWS percentage overtime
plot(nanmean(data_perc_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_SWS_ctrl), stdError(data_perc_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('NREM percentage')


subplot(4,6,[11,12]) %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('REM percentage')






subplot(4,6,[13,14]) % REM bouts number
plot(nanmean(data_num_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_REM_ctrl), stdError(data_num_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('REM bouts number')



subplot(4,6,[15,16]) % REM bouts mean duraion overtime
plot(nanmean(data_dur_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_REM_ctrl), stdError(data_dur_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
ylabel('REM mean duration (s)')



subplot(4,7,[6],'align')
PlotErrorBarN_MC({occup_open_basal.*100,occup_open_SD.*100},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2],'barcolors',{col_ctrl,col_SD});
xticks([1.5 4.5 7.5]); xticklabels ({'Ctrl', 'SDS'});
makepretty
ylabel('Time % spent in open arm')
[h,p_sal_cno_open]=ttest2(occup_open_basal.*100,occup_open_SD.*100);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end


subplot(4,7,[4],'align')
for izone = 1:3
hold on, plot(Data(Restrict(behav_basal{3}.Xtsd,behav_basal{3}.ZoneEpoch{izone})),Data(Restrict(behav_basal{3}.Ytsd,behav_basal{3}.ZoneEpoch{izone})), 'color',[0 0 0]);
end
ylim([18 91])
xlim([6 81])
axis off

subplot(4,7,[5],'align')
for izone = 1:3
hold on, plot(Data(Restrict(behav_SD{6}.Xtsd,behav_SD{6}.ZoneEpoch{izone})),Data(Restrict(behav_SD{6}.Ytsd,behav_SD{6}.ZoneEpoch{izone})), 'color',col_SD);
end
ylim([18 91])
xlim([6 81])
axis off


%%

figure, hold on,


 hold on,
for i=1:length(Dir_ctrl.path)
    plot(data_dur_REM_ctrl(i,:),'k')
end

for i=1:length(DirSocialDefeat_sleepPost_classic.path)
    plot(data_dur_REM_SD(i,:),'r')
end



%%


% mean_dur_rem_sd = [mean(data_dur_REM_SD(1,:))...
%     mean(data_dur_REM_SD(2,:))...
%     mean(data_dur_REM_SD(3,:))...
%     mean(data_dur_REM_SD(4,:))...
%     mean(data_dur_REM_SD(5,:))...
%     mean(data_dur_REM_SD(6,:))...
%     mean(data_dur_REM_SD(7,:))...
%     mean(data_dur_REM_SD(8,:))...
%     mean(data_dur_REM_SD(9,:))...
%     mean(data_dur_REM_SD(10,:))...
%     mean(data_dur_REM_SD(11,:))...
%     mean(data_dur_REM_SD(12,:))];

timebin = 4:8;
% mean_dur_rem_sd = [mean(data_perc_REM_SD(1,timebin))...
%     mean(data_perc_REM_SD(2,timebin))...
%     mean(data_perc_REM_SD(3,timebin))...
%     mean(data_perc_REM_SD(4,timebin))...
%     mean(data_perc_REM_SD(5,timebin))...
%     mean(data_perc_REM_SD(6,timebin))...
%     mean(data_perc_REM_SD(7,timebin))...
%     mean(data_perc_REM_SD(8,timebin))...
%     mean(data_perc_REM_SD(9,timebin))...
%     mean(data_perc_REM_SD(10,timebin))...
%     mean(data_perc_REM_SD(11,timebin))...
%     mean(data_perc_REM_SD(12,timebin))];


mean_dur_rem_sd = [mean(data_perc_REM_SD(1,timebin))...
    mean(data_perc_REM_SD(2,timebin))...
    mean(data_perc_REM_SD(3,timebin))...
    mean(data_perc_REM_SD(4,timebin))...
    mean(data_perc_REM_SD(5,timebin))...
    mean(data_perc_REM_SD(6,timebin))...
    mean(data_perc_REM_SD(7,timebin))...
    mean(data_perc_REM_SD(8,timebin))...
    mean(data_perc_REM_SD(9,timebin))...
    mean(data_perc_REM_SD(10,timebin))...
    mean(data_perc_REM_SD(11,timebin))];

figure,plot(nb_attacks, mean_dur_rem_sd,'ko')

[r,p]=corrcoef(nb_attacks, mean_dur_rem_sd)
[r,p]=corrcoef(nb_attacks,  cell2mat(num_REM_3_end_SD))

%%


[p_1,h_1] = ranksum(data_perc_WAKE_ctrl(:,1), data_perc_WAKE_SD(:,1));
[p_2,h_2] = ranksum(data_perc_WAKE_ctrl(:,2), data_perc_WAKE_SD(:,2));
[p_3,h_3] = ranksum(data_perc_WAKE_ctrl(:,3), data_perc_WAKE_SD(:,3));
[p_4,h_4] = ranksum(data_perc_WAKE_ctrl(:,4), data_perc_WAKE_SD(:,4));
[p_5,h_5] = ranksum(data_perc_WAKE_ctrl(:,5), data_perc_WAKE_SD(:,5));
[p_6,h_6] = ranksum(data_perc_WAKE_ctrl(:,6), data_perc_WAKE_SD(:,6));
[p_7,h_7] = ranksum(data_perc_WAKE_ctrl(:,7), data_perc_WAKE_SD(:,7));
[p_8,h_8] = ranksum(data_perc_WAKE_ctrl(:,8), data_perc_WAKE_SD(:,8));

p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];


[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);



%%
% alpha = 0.05;
% [corrected_p, h] = bonf_holm(p_values, alpha);
% [h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(pvals,q,method,report);


%%


figure, hold on,


 hold on,
for i=1:length(Dir_ctrl.path)
    plot(data_perc_WAKE_ctrl(i,:),'color',col_ctrl)
end

for i=1:length(DirSocialDefeat_sleepPost_classic.path)
    plot(data_perc_WAKE_SD(i,:),'color',col_SD)
end
makepretty

