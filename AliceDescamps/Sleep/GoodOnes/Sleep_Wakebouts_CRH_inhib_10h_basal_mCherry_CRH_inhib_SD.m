%% input dir
%%1
Dir_1 = PathForExperiments_DREADD_AD('inhibDREADD_CRH_VLPO_SalineInjection_10am');

%%2
Dir_2 = PathForExperiments_DREADD_AD('inhibDREADD_CRH_VLPO_CNOInjection_10am');

%%3
Dir_3 = PathForExperiments_SleepPostSD_AD('SleepPostSD_mCherry_CRH_VLPO_CNOInjection_10am');

%%4
Dir_4 = PathForExperiments_SleepPostSD_AD('SleepPostSD_inhibDREADD_CRH_VLPO_CNOInjection_10am');

%% parameters
tempbin = 3600;
time_end=3*1e8;
time_st = 0;
time_mid = 3*3600*1e4;

min_sws_time = 3.5*1e4*60;
binH = 2;

%% GET DATA
%% control group
for j=1:length(Dir_1.path)
    cd(Dir_1.path{j}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_ctrl{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_ctrl{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    else
    end
    
    %     if exist('SleepScoring_OBGamma2.mat')
    %         stages_ctrl{j} = load('SleepScoring_OBGamma2', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    %     elseif exist('SleepScoring_Accelero.mat')
    %         stages_ctrl{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    %     else
    %     end
    
    
    same_epoch_ctrl{j} = intervalSet(0,time_end);
    same_epoch_1_3h_ctrl{j} = intervalSet(time_st,time_mid);
    same_epoch_3_end_ctrl{j} = intervalSet(time_mid,time_end);
    
    all_st_rem_ctrl{j} = Start(stages_ctrl{j}.REMEpoch);
    latency_rem_ctrl(j) = all_st_rem_ctrl{j}(1);
    
    all_st_sws_ctrl{j} = Start(stages_ctrl{j}.SWSEpoch);
    latency_sws_ctrl(j) = all_st_sws_ctrl{j}(find(all_st_sws_ctrl{j}>min_sws_time,1,'first'));
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{j}.Wake,same_epoch_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_ctrl{j}),'wake',tempbin,time_st,time_end);
    dur_WAKE_ctrl{j}=dur_moyenne_ep_WAKE;
    num_WAKE_ctrl{j}=num_moyen_ep_WAKE;
    perc_WAKE_ctrl{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{j}.Wake,same_epoch_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_ctrl{j}),'sws',tempbin,time_st,time_end);
    dur_SWS_ctrl{j}=dur_moyenne_ep_SWS;
    num_SWS_ctrl{j}=num_moyen_ep_SWS;
    perc_SWS_ctrl{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_ctrl{j}.Wake,same_epoch_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_ctrl{j}),'rem',tempbin,time_st,time_end);
    dur_REM_ctrl{j}=dur_moyenne_ep_REM;
    num_REM_ctrl{j}=num_moyen_ep_REM;
    perc_REM_ctrl{j}=perc_moyen_REM;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{j}.Wake,same_epoch_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_ctrl{j}),tempbin,time_st,time_end);
    all_trans_REM_REM_ctrl{j} = trans_REM_to_REM;
    all_trans_REM_SWS_ctrl{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_ctrl{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_ctrl{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_ctrl{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_ctrl{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_ctrl{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_ctrl{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_ctrl{j} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{j}.Wake,same_epoch_1_3h_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_1_3h_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_1_3h_ctrl{j}),'wake',tempbin,time_st,time_mid);
    dur_WAKE_1_3h_ctrl{j}=dur_moyenne_ep_WAKE;
    num_WAKE_1_3h_ctrl{j}=num_moyen_ep_WAKE;
    perc_WAKE_1_3h_ctrl{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{j}.Wake,same_epoch_1_3h_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_1_3h_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_1_3h_ctrl{j}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_ctrl{j}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_ctrl{j}=num_moyen_ep_SWS;
    perc_SWS_1_3h_ctrl{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{j}.Wake,same_epoch_1_3h_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_1_3h_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_1_3h_ctrl{j}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_ctrl{j}=dur_moyenne_ep_REM;
    num_REM_1_3h_ctrl{j}=num_moyen_ep_REM;
    perc_REM_1_3h_ctrl{j}=perc_moyen_REM;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{j}.Wake,same_epoch_1_3h_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_1_3h_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_1_3h_ctrl{j}),tempbin,time_st,time_mid);
    all_trans_REM_REM_1_3h_ctrl{j} = trans_REM_to_REM;
    all_trans_REM_SWS_1_3h_ctrl{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_1_3h_ctrl{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_1_3h_ctrl{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_1_3h_ctrl{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_1_3h_ctrl{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_1_3h_ctrl{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_1_3h_ctrl{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_1_3h_ctrl{j} = trans_WAKE_to_WAKE;
    
    
    %%3H POST SD JUSQU'A LA FIN
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{j}.Wake,same_epoch_3_end_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_3_end_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_3_end_ctrl{j}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_ctrl{j}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_ctrl{j}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_ctrl{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{j}.Wake,same_epoch_3_end_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_3_end_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_3_end_ctrl{j}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_ctrl{j}=dur_moyenne_ep_SWS;
    num_SWS_3_end_ctrl{j}=num_moyen_ep_SWS;
    perc_SWS_3_end_ctrl{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_ctrl{j}.Wake,same_epoch_3_end_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_3_end_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_3_end_ctrl{j}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_ctrl{j}=dur_moyenne_ep_REM;
    num_REM_3_end_ctrl{j}=num_moyen_ep_REM;
    perc_REM_3_end_ctrl{j}=perc_moyen_REM;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_ctrl{j}.Wake,same_epoch_3_end_ctrl{j}),and(stages_ctrl{j}.SWSEpoch,same_epoch_3_end_ctrl{j}),and(stages_ctrl{j}.REMEpoch,same_epoch_3_end_ctrl{j}),tempbin,time_mid,time_end);
    all_trans_REM_REM_3_end_ctrl{j} = trans_REM_to_REM;
    all_trans_REM_SWS_3_end_ctrl{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_3_end_ctrl{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_3_end_ctrl{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_3_end_ctrl{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_3_end_ctrl{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_3_end_ctrl{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_3_end_ctrl{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_3_end_ctrl{j} = trans_WAKE_to_WAKE;
    
    
    
    [dur_REM_ctrl_bis{j}, durT_REM_ctrl(j)]=DurationEpoch(and(stages_ctrl{j}.REMEpoch,same_epoch_3_end_ctrl{j}),'s');
    [n_dur_rem_ctrl(j,:),x_dur_rem_acc_kb_ctrl(j,:)] = hist(dur_REM_ctrl_bis{j},[1:binH:200]);
    
    
    
end
%% compute average
%%percentage/duration/number
for imouse=1:length(dur_REM_ctrl)
    %%ALL SESSION
    data_dur_REM_ctrl(imouse,:) = dur_REM_ctrl{imouse}; data_dur_REM_ctrl(isnan(data_dur_REM_ctrl)==1)=0;
    data_dur_SWS_ctrl(imouse,:) = dur_SWS_ctrl{imouse}; data_dur_SWS_ctrl(isnan(data_dur_SWS_ctrl)==1)=0;
    data_dur_WAKE_ctrl(imouse,:) = dur_WAKE_ctrl{imouse}; data_dur_WAKE_ctrl(isnan(data_dur_WAKE_ctrl)==1)=0;
    
    data_num_REM_ctrl(imouse,:) = num_REM_ctrl{imouse};data_num_REM_ctrl(isnan(data_num_REM_ctrl)==1)=0;
    data_num_SWS_ctrl(imouse,:) = num_SWS_ctrl{imouse}; data_num_SWS_ctrl(isnan(data_num_SWS_ctrl)==1)=0;
    data_num_WAKE_ctrl(imouse,:) = num_WAKE_ctrl{imouse}; data_num_WAKE_ctrl(isnan(data_num_WAKE_ctrl)==1)=0;
    
    data_perc_REM_ctrl(imouse,:) = perc_REM_ctrl{imouse}; data_perc_REM_ctrl(isnan(data_perc_REM_ctrl)==1)=0;
    data_perc_SWS_ctrl(imouse,:) = perc_SWS_ctrl{imouse}; data_perc_SWS_ctrl(isnan(data_perc_SWS_ctrl)==1)=0;
    data_perc_WAKE_ctrl(imouse,:) = perc_WAKE_ctrl{imouse}; data_perc_WAKE_ctrl(isnan(data_perc_WAKE_ctrl)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_ctrl(imouse,:) = dur_REM_1_3h_ctrl{imouse}; data_dur_REM_1_3h_ctrl(isnan(data_dur_REM_1_3h_ctrl)==1)=0;
    data_dur_SWS_1_3h_ctrl(imouse,:) = dur_SWS_1_3h_ctrl{imouse}; data_dur_SWS_1_3h_ctrl(isnan(data_dur_SWS_1_3h_ctrl)==1)=0;
    data_dur_WAKE_1_3h_ctrl(imouse,:) = dur_WAKE_1_3h_ctrl{imouse}; data_dur_WAKE_1_3h_ctrl(isnan(data_dur_WAKE_1_3h_ctrl)==1)=0;
    
    data_num_REM_1_3h_ctrl(imouse,:) = num_REM_1_3h_ctrl{imouse};data_num_REM_1_3h_ctrl(isnan(data_num_REM_1_3h_ctrl)==1)=0;
    data_num_SWS_1_3h_ctrl(imouse,:) = num_SWS_1_3h_ctrl{imouse}; data_num_SWS_1_3h_ctrl(isnan(data_num_SWS_1_3h_ctrl)==1)=0;
    data_num_WAKE_1_3h_ctrl(imouse,:) = num_WAKE_1_3h_ctrl{imouse}; data_num_WAKE_1_3h_ctrl(isnan(data_num_WAKE_1_3h_ctrl)==1)=0;
    
    data_perc_REM_1_3h_ctrl(imouse,:) = perc_REM_1_3h_ctrl{imouse}; data_perc_REM_1_3h_ctrl(isnan(data_perc_REM_1_3h_ctrl)==1)=0;
    data_perc_SWS_1_3h_ctrl(imouse,:) = perc_SWS_1_3h_ctrl{imouse}; data_perc_SWS_1_3h_ctrl(isnan(data_perc_SWS_1_3h_ctrl)==1)=0;
    data_perc_WAKE_1_3h_ctrl(imouse,:) = perc_WAKE_1_3h_ctrl{imouse}; data_perc_WAKE_1_3h_ctrl(isnan(data_perc_WAKE_1_3h_ctrl)==1)=0;
    
    %%FIN DE LA SESSION
    data_dur_REM_3_end_ctrl(imouse,:) = dur_REM_3_end_ctrl{imouse}; data_dur_REM_3_end_ctrl(isnan(data_dur_REM_3_end_ctrl)==1)=0;
    data_dur_SWS_3_end_ctrl(imouse,:) = dur_SWS_3_end_ctrl{imouse}; data_dur_SWS_3_end_ctrl(isnan(data_dur_SWS_3_end_ctrl)==1)=0;
    data_dur_WAKE_3_end_ctrl(imouse,:) = dur_WAKE_3_end_ctrl{imouse}; data_dur_WAKE_3_end_ctrl(isnan(data_dur_WAKE_3_end_ctrl)==1)=0;
    
    data_num_REM_3_end_ctrl(imouse,:) = num_REM_3_end_ctrl{imouse};data_num_REM_3_end_ctrl(isnan(data_num_REM_3_end_ctrl)==1)=0;
    data_num_SWS_3_end_ctrl(imouse,:) = num_SWS_3_end_ctrl{imouse}; data_num_SWS_3_end_ctrl(isnan(data_num_SWS_3_end_ctrl)==1)=0;
    data_num_WAKE_3_end_ctrl(imouse,:) = num_WAKE_3_end_ctrl{imouse}; data_num_WAKE_3_end_ctrl(isnan(data_num_WAKE_3_end_ctrl)==1)=0;
    
    data_perc_REM_3_end_ctrl(imouse,:) = perc_REM_3_end_ctrl{imouse}; data_perc_REM_3_end_ctrl(isnan(data_perc_REM_3_end_ctrl)==1)=0;
    data_perc_SWS_3_end_ctrl(imouse,:) = perc_SWS_3_end_ctrl{imouse}; data_perc_SWS_3_end_ctrl(isnan(data_perc_SWS_3_end_ctrl)==1)=0;
    data_perc_WAKE_3_end_ctrl(imouse,:) = perc_WAKE_3_end_ctrl{imouse}; data_perc_WAKE_3_end_ctrl(isnan(data_perc_WAKE_3_end_ctrl)==1)=0;
end
%%probability
for imouse=1:length(all_trans_REM_REM_ctrl)
    %%ALL SESSION
    data_REM_REM_ctrl(imouse,:) = all_trans_REM_REM_ctrl{imouse}; data_REM_REM_ctrl(isnan(data_REM_REM_ctrl)==1)=0;
    data_REM_SWS_ctrl(imouse,:) = all_trans_REM_SWS_ctrl{imouse}; data_REM_SWS_ctrl(isnan(data_REM_SWS_ctrl)==1)=0;
    data_REM_WAKE_ctrl(imouse,:) = all_trans_REM_WAKE_ctrl{imouse}; data_REM_WAKE_ctrl(isnan(data_REM_WAKE_ctrl)==1)=0;
    
    data_SWS_SWS_ctrl(imouse,:) = all_trans_SWS_SWS_ctrl{imouse}; data_SWS_SWS_ctrl(isnan(data_SWS_SWS_ctrl)==1)=0;
    data_SWS_REM_ctrl(imouse,:) = all_trans_SWS_REM_ctrl{imouse}; data_SWS_REM_ctrl(isnan(data_SWS_REM_ctrl)==1)=0;
    data_SWS_WAKE_ctrl(imouse,:) = all_trans_SWS_WAKE_ctrl{imouse}; data_SWS_WAKE_ctrl(isnan(data_SWS_WAKE_ctrl)==1)=0;
    
    data_WAKE_WAKE_ctrl(imouse,:) = all_trans_WAKE_WAKE_ctrl{imouse}; data_WAKE_WAKE_ctrl(isnan(data_WAKE_WAKE_ctrl)==1)=0;
    data_WAKE_REM_ctrl(imouse,:) = all_trans_WAKE_REM_ctrl{imouse}; data_WAKE_REM_ctrl(isnan(data_WAKE_REM_ctrl)==1)=0;
    data_WAKE_SWS_ctrl(imouse,:) = all_trans_WAKE_SWS_ctrl{imouse}; data_WAKE_SWS_ctrl(isnan(data_WAKE_SWS_ctrl)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_REM_REM_1_3h_ctrl(imouse,:) = all_trans_REM_REM_1_3h_ctrl{imouse}; data_REM_REM_1_3h_ctrl(isnan(data_REM_REM_1_3h_ctrl)==1)=0;
    data_REM_SWS_1_3h_ctrl(imouse,:) = all_trans_REM_SWS_1_3h_ctrl{imouse}; data_REM_SWS_1_3h_ctrl(isnan(data_REM_SWS_1_3h_ctrl)==1)=0;
    data_REM_WAKE_1_3h_ctrl(imouse,:) = all_trans_REM_WAKE_1_3h_ctrl{imouse}; data_REM_WAKE_1_3h_ctrl(isnan(data_REM_WAKE_1_3h_ctrl)==1)=0;
    
    data_SWS_SWS_1_3h_ctrl(imouse,:) = all_trans_SWS_SWS_1_3h_ctrl{imouse}; data_SWS_SWS_1_3h_ctrl(isnan(data_SWS_SWS_1_3h_ctrl)==1)=0;
    data_SWS_REM_1_3h_ctrl(imouse,:) = all_trans_SWS_REM_1_3h_ctrl{imouse}; data_SWS_REM_1_3h_ctrl(isnan(data_SWS_REM_1_3h_ctrl)==1)=0;
    data_SWS_WAKE_1_3h_ctrl(imouse,:) = all_trans_SWS_WAKE_1_3h_ctrl{imouse}; data_SWS_WAKE_1_3h_ctrl(isnan(data_SWS_WAKE_1_3h_ctrl)==1)=0;
    
    data_WAKE_WAKE_1_3h_ctrl(imouse,:) = all_trans_WAKE_WAKE_1_3h_ctrl{imouse}; data_WAKE_WAKE_1_3h_ctrl(isnan(data_WAKE_WAKE_1_3h_ctrl)==1)=0;
    data_WAKE_REM_1_3h_ctrl(imouse,:) = all_trans_WAKE_REM_1_3h_ctrl{imouse}; data_WAKE_REM_1_3h_ctrl(isnan(data_WAKE_REM_1_3h_ctrl)==1)=0;
    data_WAKE_SWS_1_3h_ctrl(imouse,:) = all_trans_WAKE_SWS_1_3h_ctrl{imouse}; data_WAKE_SWS_1_3h_ctrl(isnan(data_WAKE_SWS_1_3h_ctrl)==1)=0;
    
    %%FIN DE LA SESSION
    data_REM_REM_3_end_ctrl(imouse,:) = all_trans_REM_REM_3_end_ctrl{imouse}; data_REM_REM_3_end_ctrl(isnan(data_REM_REM_3_end_ctrl)==1)=0;
    data_REM_SWS_3_end_ctrl(imouse,:) = all_trans_REM_SWS_3_end_ctrl{imouse}; data_REM_SWS_3_end_ctrl(isnan(data_REM_SWS_3_end_ctrl)==1)=0;
    data_REM_WAKE_3_end_ctrl(imouse,:) = all_trans_REM_WAKE_3_end_ctrl{imouse}; data_REM_WAKE_3_end_ctrl(isnan(data_REM_WAKE_3_end_ctrl)==1)=0;
    
    data_SWS_SWS_3_end_ctrl(imouse,:) = all_trans_SWS_SWS_3_end_ctrl{imouse}; data_SWS_SWS_3_end_ctrl(isnan(data_SWS_SWS_3_end_ctrl)==1)=0;
    data_SWS_REM_3_end_ctrl(imouse,:) = all_trans_SWS_REM_3_end_ctrl{imouse}; data_SWS_REM_3_end_ctrl(isnan(data_SWS_REM_3_end_ctrl)==1)=0;
    data_SWS_WAKE_3_end_ctrl(imouse,:) = all_trans_SWS_WAKE_3_end_ctrl{imouse}; data_SWS_WAKE_3_end_ctrl(isnan(data_SWS_WAKE_3_end_ctrl)==1)=0;
    
    data_WAKE_WAKE_3_end_ctrl(imouse,:) = all_trans_WAKE_WAKE_3_end_ctrl{imouse}; data_WAKE_WAKE_3_end_ctrl(isnan(data_WAKE_WAKE_3_end_ctrl)==1)=0;
    data_WAKE_REM_3_end_ctrl(imouse,:) = all_trans_WAKE_REM_3_end_ctrl{imouse}; data_WAKE_REM_3_end_ctrl(isnan(data_WAKE_REM_3_end_ctrl)==1)=0;
    data_WAKE_SWS_3_end_ctrl(imouse,:) = all_trans_WAKE_SWS_3_end_ctrl{imouse}; data_WAKE_SWS_3_end_ctrl(isnan(data_WAKE_SWS_3_end_ctrl)==1)=0;
    
end

%% Sleep after cno 10h group
for n=1:length(Dir_2.path)
    cd(Dir_2.path{n}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_mCherry_cno{n} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tSD_mCherry_cnoMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_mCherry_cno{n} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tSD_mCherry_cnoMovement');
    else
    end
    
    
    %     if exist('SleepScoring_OBGamma2.mat')
    %         stages_SD_mCherry_cno{n} = load('SleepScoring_OBGamma2', 'REMEpoch', 'SWSEpoch', 'Wake','tSD_mCherry_cnoMovement');
    %     elseif exist('SleepScoring_Accelero.mat')
    %         stages_SD_mCherry_cno{n} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tSD_mCherry_cnoMovement');
    %     else
    %     end
    
    same_epoch_SD_mCherry_cno{n} = intervalSet(0,time_end);
    same_epoch_1_3h_SD_mCherry_cno{n} = intervalSet(time_st,time_mid);
    same_epoch_3_end_SD_mCherry_cno{n} = intervalSet(time_mid,time_end);
    
    
    all_st_rem_SD_mCherry_cno{n} = Start(stages_SD_mCherry_cno{n}.REMEpoch);
    latency_rem_SD_mCherry_cno(n) = all_st_rem_SD_mCherry_cno{n}(1);
    
    all_st_sws_SD_mCherry_cno{n} = Start(stages_SD_mCherry_cno{n}.SWSEpoch);
    latency_sws_SD_mCherry_cno(n) = all_st_sws_SD_mCherry_cno{n}(find(all_st_sws_SD_mCherry_cno{n}>min_sws_time,1,'first'));
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_SD_mCherry_cno{n}),'wake',tempbin,time_st,time_end);
    dur_WAKE_SD_mCherry_cno{n}=dur_moyenne_ep_WAKE;
    num_WAKE_SD_mCherry_cno{n}=num_moyen_ep_WAKE;
    perc_WAKE_SD_mCherry_cno{n}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_SD_mCherry_cno{n}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_mCherry_cno{n}=dur_moyenne_ep_SWS;
    num_SWS_SD_mCherry_cno{n}=num_moyen_ep_SWS;
    perc_SWS_SD_mCherry_cno{n}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_SD_mCherry_cno{n}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_mCherry_cno{n}=dur_moyenne_ep_REM;
    num_REM_SD_mCherry_cno{n}=num_moyen_ep_REM;
    perc_REM_SD_mCherry_cno{n}=perc_moyen_REM;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_SD_mCherry_cno{n}),tempbin,time_st,time_end);
    all_trans_REM_REM_SD_mCherry_cno{n} = trans_REM_to_REM;
    all_trans_REM_SWS_SD_mCherry_cno{n} = trans_REM_to_SWS;
    all_trans_REM_WAKE_SD_mCherry_cno{n} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_SD_mCherry_cno{n} = trans_SWS_to_REM;
    all_trans_SWS_SWS_SD_mCherry_cno{n} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_SD_mCherry_cno{n} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_SD_mCherry_cno{n} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_SD_mCherry_cno{n} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_SD_mCherry_cno{n} = trans_WAKE_to_WAKE;
    
    
    %%3 PREMI7RE HEUES APRES SD_mCherry_cno
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_1_3h_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{n}),'wake',tempbin,time_st,time_mid);
    dur_WAKE_1_3h_SD_mCherry_cno{n}=dur_moyenne_ep_WAKE;
    num_WAKE_1_3h_SD_mCherry_cno{n}=num_moyen_ep_WAKE;
    perc_WAKE_1_3h_SD_mCherry_cno{n}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, ~]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_1_3h_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{n}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_SD_mCherry_cno{n}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_SD_mCherry_cno{n}=num_moyen_ep_SWS;
    perc_SWS_1_3h_SD_mCherry_cno{n}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_1_3h_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{n}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_SD_mCherry_cno{n}=dur_moyenne_ep_REM;
    num_REM_1_3h_SD_mCherry_cno{n}=num_moyen_ep_REM;
    perc_REM_1_3h_SD_mCherry_cno{n}=perc_moyen_REM;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_1_3h_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_1_3h_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_1_3h_SD_mCherry_cno{n}),tempbin,time_st,time_mid);
    all_trans_REM_REM_1_3h_SD_mCherry_cno{n} = trans_REM_to_REM;
    all_trans_REM_SWS_1_3h_SD_mCherry_cno{n} = trans_REM_to_SWS;
    all_trans_REM_WAKE_1_3h_SD_mCherry_cno{n} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_1_3h_SD_mCherry_cno{n} = trans_SWS_to_REM;
    all_trans_SWS_SWS_1_3h_SD_mCherry_cno{n} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_1_3h_SD_mCherry_cno{n} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_1_3h_SD_mCherry_cno{n} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_1_3h_SD_mCherry_cno{n} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_1_3h_SD_mCherry_cno{n} = trans_WAKE_to_WAKE;
    
    %%3H POST SD_mCherry_cno JUSQU'A LA FIN
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_3_end_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{n}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_SD_mCherry_cno{n}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_SD_mCherry_cno{n}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_SD_mCherry_cno{n}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_3_end_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{n}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_SD_mCherry_cno{n}=dur_moyenne_ep_SWS;
    num_SWS_3_end_SD_mCherry_cno{n}=num_moyen_ep_SWS;
    perc_SWS_3_end_SD_mCherry_cno{n}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_3_end_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{n}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_SD_mCherry_cno{n}=dur_moyenne_ep_REM;
    num_REM_3_end_SD_mCherry_cno{n}=num_moyen_ep_REM;
    perc_REM_3_end_SD_mCherry_cno{n}=perc_moyen_REM;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_mCherry_cno{n}.Wake,same_epoch_3_end_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.SWSEpoch,same_epoch_3_end_SD_mCherry_cno{n}),and(stages_SD_mCherry_cno{n}.REMEpoch,same_epoch_3_end_SD_mCherry_cno{n}),tempbin,time_mid,time_end);
    all_trans_REM_REM_3_end_SD_mCherry_cno{n} = trans_REM_to_REM;
    all_trans_REM_SWS_3_end_SD_mCherry_cno{n} = trans_REM_to_SWS;
    all_trans_REM_WAKE_3_end_SD_mCherry_cno{n} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_3_end_SD_mCherry_cno{n} = trans_SWS_to_REM;
    all_trans_SWS_SWS_3_end_SD_mCherry_cno{n} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_3_end_SD_mCherry_cno{n} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_3_end_SD_mCherry_cno{n} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_3_end_SD_mCherry_cno{n} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_3_end_SD_mCherry_cno{n} = trans_WAKE_to_WAKE;
    
end
%% compute average
%%percentage/duration/number
for imouse=1:length(dur_REM_SD_mCherry_cno)
    %%ALL SESSION
    data_dur_REM_SD_mCherry_cno(imouse,:) = dur_REM_SD_mCherry_cno{imouse}; data_dur_REM_SD_mCherry_cno(isnan(data_dur_REM_SD_mCherry_cno)==1)=0;
    data_dur_SWS_SD_mCherry_cno(imouse,:) = dur_SWS_SD_mCherry_cno{imouse}; data_dur_SWS_SD_mCherry_cno(isnan(data_dur_SWS_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_SD_mCherry_cno(imouse,:) = dur_WAKE_SD_mCherry_cno{imouse}; data_dur_WAKE_SD_mCherry_cno(isnan(data_dur_WAKE_SD_mCherry_cno)==1)=0;
    
    data_num_REM_SD_mCherry_cno(imouse,:) = num_REM_SD_mCherry_cno{imouse};data_num_REM_SD_mCherry_cno(isnan(data_num_REM_SD_mCherry_cno)==1)=0;
    data_num_SWS_SD_mCherry_cno(imouse,:) = num_SWS_SD_mCherry_cno{imouse}; data_num_SWS_SD_mCherry_cno(isnan(data_num_SWS_SD_mCherry_cno)==1)=0;
    data_num_WAKE_SD_mCherry_cno(imouse,:) = num_WAKE_SD_mCherry_cno{imouse}; data_num_WAKE_SD_mCherry_cno(isnan(data_num_WAKE_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_SD_mCherry_cno(imouse,:) = perc_REM_SD_mCherry_cno{imouse}; data_perc_REM_SD_mCherry_cno(isnan(data_perc_REM_SD_mCherry_cno)==1)=0;
    data_perc_SWS_SD_mCherry_cno(imouse,:) = perc_SWS_SD_mCherry_cno{imouse}; data_perc_SWS_SD_mCherry_cno(isnan(data_perc_SWS_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_SD_mCherry_cno(imouse,:) = perc_WAKE_SD_mCherry_cno{imouse}; data_perc_WAKE_SD_mCherry_cno(isnan(data_perc_WAKE_SD_mCherry_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_dur_REM_1_3h_SD_mCherry_cno(imouse,:) = dur_REM_1_3h_SD_mCherry_cno{imouse}; data_dur_REM_1_3h_SD_mCherry_cno(isnan(data_dur_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_dur_SWS_1_3h_SD_mCherry_cno(imouse,:) = dur_SWS_1_3h_SD_mCherry_cno{imouse}; data_dur_SWS_1_3h_SD_mCherry_cno(isnan(data_dur_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_1_3h_SD_mCherry_cno(imouse,:) = dur_WAKE_1_3h_SD_mCherry_cno{imouse}; data_dur_WAKE_1_3h_SD_mCherry_cno(isnan(data_dur_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    
    data_num_REM_1_3h_SD_mCherry_cno(imouse,:) = num_REM_1_3h_SD_mCherry_cno{imouse};data_num_REM_1_3h_SD_mCherry_cno(isnan(data_num_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_num_SWS_1_3h_SD_mCherry_cno(imouse,:) = num_SWS_1_3h_SD_mCherry_cno{imouse}; data_num_SWS_1_3h_SD_mCherry_cno(isnan(data_num_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_num_WAKE_1_3h_SD_mCherry_cno(imouse,:) = num_WAKE_1_3h_SD_mCherry_cno{imouse}; data_num_WAKE_1_3h_SD_mCherry_cno(isnan(data_num_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_1_3h_SD_mCherry_cno(imouse,:) = perc_REM_1_3h_SD_mCherry_cno{imouse}; data_perc_REM_1_3h_SD_mCherry_cno(isnan(data_perc_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_perc_SWS_1_3h_SD_mCherry_cno(imouse,:) = perc_SWS_1_3h_SD_mCherry_cno{imouse}; data_perc_SWS_1_3h_SD_mCherry_cno(isnan(data_perc_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_1_3h_SD_mCherry_cno(imouse,:) = perc_WAKE_1_3h_SD_mCherry_cno{imouse}; data_perc_WAKE_1_3h_SD_mCherry_cno(isnan(data_perc_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    
    %%FIN DE LA SESSION
    data_dur_REM_3_end_SD_mCherry_cno(imouse,:) = dur_REM_3_end_SD_mCherry_cno{imouse}; data_dur_REM_3_end_SD_mCherry_cno(isnan(data_dur_REM_3_end_SD_mCherry_cno)==1)=0;
    data_dur_SWS_3_end_SD_mCherry_cno(imouse,:) = dur_SWS_3_end_SD_mCherry_cno{imouse}; data_dur_SWS_3_end_SD_mCherry_cno(isnan(data_dur_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_dur_WAKE_3_end_SD_mCherry_cno(imouse,:) = dur_WAKE_3_end_SD_mCherry_cno{imouse}; data_dur_WAKE_3_end_SD_mCherry_cno(isnan(data_dur_WAKE_3_end_SD_mCherry_cno)==1)=0;
    
    data_num_REM_3_end_SD_mCherry_cno(imouse,:) = num_REM_3_end_SD_mCherry_cno{imouse};data_num_REM_3_end_SD_mCherry_cno(isnan(data_num_REM_3_end_SD_mCherry_cno)==1)=0;
    data_num_SWS_3_end_SD_mCherry_cno(imouse,:) = num_SWS_3_end_SD_mCherry_cno{imouse}; data_num_SWS_3_end_SD_mCherry_cno(isnan(data_num_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_num_WAKE_3_end_SD_mCherry_cno(imouse,:) = num_WAKE_3_end_SD_mCherry_cno{imouse}; data_num_WAKE_3_end_SD_mCherry_cno(isnan(data_num_WAKE_3_end_SD_mCherry_cno)==1)=0;
    
    data_perc_REM_3_end_SD_mCherry_cno(imouse,:) = perc_REM_3_end_SD_mCherry_cno{imouse}; data_perc_REM_3_end_SD_mCherry_cno(isnan(data_perc_REM_3_end_SD_mCherry_cno)==1)=0;
    data_perc_SWS_3_end_SD_mCherry_cno(imouse,:) = perc_SWS_3_end_SD_mCherry_cno{imouse}; data_perc_SWS_3_end_SD_mCherry_cno(isnan(data_perc_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_perc_WAKE_3_end_SD_mCherry_cno(imouse,:) = perc_WAKE_3_end_SD_mCherry_cno{imouse}; data_perc_WAKE_3_end_SD_mCherry_cno(isnan(data_perc_WAKE_3_end_SD_mCherry_cno)==1)=0;
end
%%probability
for imouse=1:length(all_trans_REM_REM_SD_mCherry_cno)
    %%ALL SESSION
    data_REM_REM_SD_mCherry_cno(imouse,:) = all_trans_REM_REM_SD_mCherry_cno{imouse}; data_REM_REM_SD_mCherry_cno(isnan(data_REM_REM_SD_mCherry_cno)==1)=0;
    data_REM_SWS_SD_mCherry_cno(imouse,:) = all_trans_REM_SWS_SD_mCherry_cno{imouse}; data_REM_SWS_SD_mCherry_cno(isnan(data_REM_SWS_SD_mCherry_cno)==1)=0;
    data_REM_WAKE_SD_mCherry_cno(imouse,:) = all_trans_REM_WAKE_SD_mCherry_cno{imouse}; data_REM_WAKE_SD_mCherry_cno(isnan(data_REM_WAKE_SD_mCherry_cno)==1)=0;
    
    data_SWS_SWS_SD_mCherry_cno(imouse,:) = all_trans_SWS_SWS_SD_mCherry_cno{imouse}; data_SWS_SWS_SD_mCherry_cno(isnan(data_SWS_SWS_SD_mCherry_cno)==1)=0;
    data_SWS_REM_SD_mCherry_cno(imouse,:) = all_trans_SWS_REM_SD_mCherry_cno{imouse}; data_SWS_REM_SD_mCherry_cno(isnan(data_SWS_REM_SD_mCherry_cno)==1)=0;
    data_SWS_WAKE_SD_mCherry_cno(imouse,:) = all_trans_SWS_WAKE_SD_mCherry_cno{imouse}; data_SWS_WAKE_SD_mCherry_cno(isnan(data_SWS_WAKE_SD_mCherry_cno)==1)=0;
    
    data_WAKE_WAKE_SD_mCherry_cno(imouse,:) = all_trans_WAKE_WAKE_SD_mCherry_cno{imouse}; data_WAKE_WAKE_SD_mCherry_cno(isnan(data_WAKE_WAKE_SD_mCherry_cno)==1)=0;
    data_WAKE_REM_SD_mCherry_cno(imouse,:) = all_trans_WAKE_REM_SD_mCherry_cno{imouse}; data_WAKE_REM_SD_mCherry_cno(isnan(data_WAKE_REM_SD_mCherry_cno)==1)=0;
    data_WAKE_SWS_SD_mCherry_cno(imouse,:) = all_trans_WAKE_SWS_SD_mCherry_cno{imouse}; data_WAKE_SWS_SD_mCherry_cno(isnan(data_WAKE_SWS_SD_mCherry_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_REM_REM_1_3h_SD_mCherry_cno(imouse,:) = all_trans_REM_REM_1_3h_SD_mCherry_cno{imouse}; data_REM_REM_1_3h_SD_mCherry_cno(isnan(data_REM_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_REM_SWS_1_3h_SD_mCherry_cno(imouse,:) = all_trans_REM_SWS_1_3h_SD_mCherry_cno{imouse}; data_REM_SWS_1_3h_SD_mCherry_cno(isnan(data_REM_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_REM_WAKE_1_3h_SD_mCherry_cno(imouse,:) = all_trans_REM_WAKE_1_3h_SD_mCherry_cno{imouse}; data_REM_WAKE_1_3h_SD_mCherry_cno(isnan(data_REM_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    
    data_SWS_SWS_1_3h_SD_mCherry_cno(imouse,:) = all_trans_SWS_SWS_1_3h_SD_mCherry_cno{imouse}; data_SWS_SWS_1_3h_SD_mCherry_cno(isnan(data_SWS_SWS_1_3h_SD_mCherry_cno)==1)=0;
    data_SWS_REM_1_3h_SD_mCherry_cno(imouse,:) = all_trans_SWS_REM_1_3h_SD_mCherry_cno{imouse}; data_SWS_REM_1_3h_SD_mCherry_cno(isnan(data_SWS_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_SWS_WAKE_1_3h_SD_mCherry_cno(imouse,:) = all_trans_SWS_WAKE_1_3h_SD_mCherry_cno{imouse}; data_SWS_WAKE_1_3h_SD_mCherry_cno(isnan(data_SWS_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    
    data_WAKE_WAKE_1_3h_SD_mCherry_cno(imouse,:) = all_trans_WAKE_WAKE_1_3h_SD_mCherry_cno{imouse}; data_WAKE_WAKE_1_3h_SD_mCherry_cno(isnan(data_WAKE_WAKE_1_3h_SD_mCherry_cno)==1)=0;
    data_WAKE_REM_1_3h_SD_mCherry_cno(imouse,:) = all_trans_WAKE_REM_1_3h_SD_mCherry_cno{imouse}; data_WAKE_REM_1_3h_SD_mCherry_cno(isnan(data_WAKE_REM_1_3h_SD_mCherry_cno)==1)=0;
    data_WAKE_SWS_1_3h_SD_mCherry_cno(imouse,:) = all_trans_WAKE_SWS_1_3h_SD_mCherry_cno{imouse}; data_WAKE_SWS_1_3h_SD_mCherry_cno(isnan(data_WAKE_SWS_1_3h_SD_mCherry_cno)==1)=0;
    
    %%FIN DE LA SESSION
    data_REM_REM_3_end_SD_mCherry_cno(imouse,:) = all_trans_REM_REM_3_end_SD_mCherry_cno{imouse}; data_REM_REM_3_end_SD_mCherry_cno(isnan(data_REM_REM_3_end_SD_mCherry_cno)==1)=0;
    data_REM_SWS_3_end_SD_mCherry_cno(imouse,:) = all_trans_REM_SWS_3_end_SD_mCherry_cno{imouse}; data_REM_SWS_3_end_SD_mCherry_cno(isnan(data_REM_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_REM_WAKE_3_end_SD_mCherry_cno(imouse,:) = all_trans_REM_WAKE_3_end_SD_mCherry_cno{imouse}; data_REM_WAKE_3_end_SD_mCherry_cno(isnan(data_REM_WAKE_3_end_SD_mCherry_cno)==1)=0;
    
    data_SWS_SWS_3_end_SD_mCherry_cno(imouse,:) = all_trans_SWS_SWS_3_end_SD_mCherry_cno{imouse}; data_SWS_SWS_3_end_SD_mCherry_cno(isnan(data_SWS_SWS_3_end_SD_mCherry_cno)==1)=0;
    data_SWS_REM_3_end_SD_mCherry_cno(imouse,:) = all_trans_SWS_REM_3_end_SD_mCherry_cno{imouse}; data_SWS_REM_3_end_SD_mCherry_cno(isnan(data_SWS_REM_3_end_SD_mCherry_cno)==1)=0;
    data_SWS_WAKE_3_end_SD_mCherry_cno(imouse,:) = all_trans_SWS_WAKE_3_end_SD_mCherry_cno{imouse}; data_SWS_WAKE_3_end_SD_mCherry_cno(isnan(data_SWS_WAKE_3_end_SD_mCherry_cno)==1)=0;
    
    data_WAKE_WAKE_3_end_SD_mCherry_cno(imouse,:) = all_trans_WAKE_WAKE_3_end_SD_mCherry_cno{imouse}; data_WAKE_WAKE_3_end_SD_mCherry_cno(isnan(data_WAKE_WAKE_3_end_SD_mCherry_cno)==1)=0;
    data_WAKE_REM_3_end_SD_mCherry_cno(imouse,:) = all_trans_WAKE_REM_3_end_SD_mCherry_cno{imouse}; data_WAKE_REM_3_end_SD_mCherry_cno(isnan(data_WAKE_REM_3_end_SD_mCherry_cno)==1)=0;
    data_WAKE_SWS_3_end_SD_mCherry_cno(imouse,:) = all_trans_WAKE_SWS_3_end_SD_mCherry_cno{imouse}; data_WAKE_SWS_3_end_SD_mCherry_cno(isnan(data_WAKE_SWS_3_end_SD_mCherry_cno)==1)=0;
end

%% Social defeat group
for k=1:length(Dir_3.path)
    cd(Dir_3.path{k}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    else
    end
    %
    %     if exist('SleepScoring_OBGamma2.mat')
    %         stages_SD{k} = load('SleepScoring_OBGamma2', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    %     elseif exist('SleepScoring_Accelero.mat')
    %         stages_SD{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    %     else
    %     end
    same_epoch_SD{k} = intervalSet(0,time_end);
    same_epoch_1_3h_SD{k} = intervalSet(time_st,time_mid);
    same_epoch_3_end_SD{k} = intervalSet(time_mid,time_end);
    
    all_st_rem_SD{k} = Start(stages_SD{k}.REMEpoch);
    latency_rem_SD(k) = all_st_rem_SD{k}(1);
    
    all_st_sws_SD{k} = Start(stages_SD{k}.SWSEpoch);
    latency_sws_SD(k) = all_st_sws_SD{k}(find(all_st_sws_SD{k}>min_sws_time,1,'first'));
    
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts
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
     
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),tempbin,time_st,time_end);
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
    
    %%compute transition probabilities
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
    %%Compute percentage mean duration and number of bouts
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
    
    %%compute transition probabilities
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
    
        
    [dur_REM_SD_bis{k}, durT_REM_SD(k)]=DurationEpoch(and(stages_SD{k}.REMEpoch,same_epoch_3_end_SD{k}),'s');
    [n_dur_rem_SD(k,:),x_dur_rem_SD(k,:)] = hist(dur_REM_SD_bis{k},[1:binH:200]);
    
    
    
end
%% compute average
%%percentage/duration/number
for imouse=1:length(dur_REM_SD)
    %%ALL SESSION
    data_dur_REM_SD(imouse,:) = dur_REM_SD{imouse}; 
    data_dur_SWS_SD(imouse,:) = dur_SWS_SD{imouse}; 
    data_dur_WAKE_SD(imouse,:) = dur_WAKE_SD{imouse};
    data_dur_REM_SD(isnan(data_dur_REM_SD)==1)=0;
    data_dur_SWS_SD(isnan(data_dur_SWS_SD)==1)=0;
    data_dur_WAKE_SD(isnan(data_dur_WAKE_SD)==1)=0;
    
    data_num_REM_SD(imouse,:) = num_REM_SD{imouse};
    data_num_SWS_SD(imouse,:) = num_SWS_SD{imouse}; 
    data_num_WAKE_SD(imouse,:) = num_WAKE_SD{imouse}; 
    data_num_REM_SD(isnan(data_num_REM_SD)==1)=0;
    data_num_SWS_SD(isnan(data_num_SWS_SD)==1)=0;
    data_num_WAKE_SD(isnan(data_num_WAKE_SD)==1)=0;
    
    data_perc_REM_SD(imouse,:) = perc_REM_SD{imouse}; 
    data_perc_SWS_SD(imouse,:) = perc_SWS_SD{imouse}; 
    data_perc_WAKE_SD(imouse,:) = perc_WAKE_SD{imouse}; 
    data_perc_REM_SD(isnan(data_perc_REM_SD)==1)=0;
    data_perc_SWS_SD(isnan(data_perc_SWS_SD)==1)=0;
    data_perc_WAKE_SD(isnan(data_perc_WAKE_SD)==1)=0;
    
    %3 PREMI7RES HEURES
    data_dur_REM_1_3h_SD(imouse,:) = dur_REM_1_3h_SD{imouse}; 
    data_dur_SWS_1_3h_SD(imouse,:) = dur_SWS_1_3h_SD{imouse}; 
    data_dur_WAKE_1_3h_SD(imouse,:) = dur_WAKE_1_3h_SD{imouse};
    data_dur_REM_1_3h_SD(isnan(data_dur_REM_1_3h_SD)==1)=0;
    data_dur_SWS_1_3h_SD(isnan(data_dur_SWS_1_3h_SD)==1)=0;
    data_dur_WAKE_1_3h_SD(isnan(data_dur_WAKE_1_3h_SD)==1)=0;
    
    data_num_REM_1_3h_SD(imouse,:) = num_REM_1_3h_SD{imouse};
    data_num_SWS_1_3h_SD(imouse,:) = num_SWS_1_3h_SD{imouse}; 
    data_num_WAKE_1_3h_SD(imouse,:) = num_WAKE_1_3h_SD{imouse};
    data_num_REM_1_3h_SD(isnan(data_num_REM_1_3h_SD)==1)=0;
    data_num_SWS_1_3h_SD(isnan(data_num_SWS_1_3h_SD)==1)=0;
    data_num_WAKE_1_3h_SD(isnan(data_num_WAKE_1_3h_SD)==1)=0;
    
    data_perc_REM_1_3h_SD(imouse,:) = perc_REM_1_3h_SD{imouse}; 
    data_perc_SWS_1_3h_SD(imouse,:) = perc_SWS_1_3h_SD{imouse}; 
    data_perc_WAKE_1_3h_SD(imouse,:) = perc_WAKE_1_3h_SD{imouse}; 
    data_perc_REM_1_3h_SD(isnan(data_perc_REM_1_3h_SD)==1)=0;
    data_perc_SWS_1_3h_SD(isnan(data_perc_SWS_1_3h_SD)==1)=0;
    data_perc_WAKE_1_3h_SD(isnan(data_perc_WAKE_1_3h_SD)==1)=0;
    
    %FIN DE LA SESSION
    data_dur_REM_3_end_SD(imouse,:) = dur_REM_3_end_SD{imouse}; 
    data_dur_SWS_3_end_SD(imouse,:) = dur_SWS_3_end_SD{imouse}; 
    data_dur_WAKE_3_end_SD(imouse,:) = dur_WAKE_3_end_SD{imouse};
    data_dur_REM_3_end_SD(isnan(data_dur_REM_3_end_SD)==1)=0;
    data_dur_SWS_3_end_SD(isnan(data_dur_SWS_3_end_SD)==1)=0;
    data_dur_WAKE_3_end_SD(isnan(data_dur_WAKE_3_end_SD)==1)=0;
    
    data_num_REM_3_end_SD(imouse,:) = num_REM_3_end_SD{imouse};
    data_num_SWS_3_end_SD(imouse,:) = num_SWS_3_end_SD{imouse}; 
    data_num_WAKE_3_end_SD(imouse,:) = num_WAKE_3_end_SD{imouse}; 
    data_num_REM_3_end_SD(isnan(data_num_REM_3_end_SD)==1)=0;
    data_num_SWS_3_end_SD(isnan(data_num_SWS_3_end_SD)==1)=0;
    data_num_WAKE_3_end_SD(isnan(data_num_WAKE_3_end_SD)==1)=0;
    
    data_perc_REM_3_end_SD(imouse,:) = perc_REM_3_end_SD{imouse}; 
    data_perc_SWS_3_end_SD(imouse,:) = perc_SWS_3_end_SD{imouse}; 
    data_perc_WAKE_3_end_SD(imouse,:) = perc_WAKE_3_end_SD{imouse}; 
    data_perc_REM_3_end_SD(isnan(data_perc_REM_3_end_SD)==1)=0;
    data_perc_SWS_3_end_SD(isnan(data_perc_SWS_3_end_SD)==1)=0;
    data_perc_WAKE_3_end_SD(isnan(data_perc_WAKE_3_end_SD)==1)=0;
end
%%probability
for imouse=1:length(all_trans_REM_REM_SD)
    %%ALL SESSION
    data_REM_REM_SD(imouse,:) = all_trans_REM_REM_SD{imouse}; data_REM_REM_SD(isnan(data_REM_REM_SD)==1)=0;
    data_REM_SWS_SD(imouse,:) = all_trans_REM_SWS_SD{imouse}; data_REM_SWS_SD(isnan(data_REM_SWS_SD)==1)=0;
    data_REM_WAKE_SD(imouse,:) = all_trans_REM_WAKE_SD{imouse}; data_REM_WAKE_SD(isnan(data_REM_WAKE_SD)==1)=0;
    
    data_SWS_SWS_SD(imouse,:) = all_trans_SWS_SWS_SD{imouse}; data_SWS_SWS_SD(isnan(data_SWS_SWS_SD)==1)=0;
    data_SWS_REM_SD(imouse,:) = all_trans_SWS_REM_SD{imouse}; data_SWS_REM_SD(isnan(data_SWS_REM_SD)==1)=0;
    data_SWS_WAKE_SD(imouse,:) = all_trans_SWS_WAKE_SD{imouse}; data_SWS_WAKE_SD(isnan(data_SWS_WAKE_SD)==1)=0;
    
    data_WAKE_WAKE_SD(imouse,:) = all_trans_WAKE_WAKE_SD{imouse}; data_WAKE_WAKE_SD(isnan(data_WAKE_WAKE_SD)==1)=0;
    data_WAKE_REM_SD(imouse,:) = all_trans_WAKE_REM_SD{imouse}; data_WAKE_REM_SD(isnan(data_WAKE_REM_SD)==1)=0;
    data_WAKE_SWS_SD(imouse,:) = all_trans_WAKE_SWS_SD{imouse}; data_WAKE_SWS_SD(isnan(data_WAKE_SWS_SD)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_REM_REM_1_3h_SD(imouse,:) = all_trans_REM_REM_1_3h_SD{imouse}; data_REM_REM_1_3h_SD(isnan(data_REM_REM_1_3h_SD)==1)=0;
    data_REM_SWS_1_3h_SD(imouse,:) = all_trans_REM_SWS_1_3h_SD{imouse}; data_REM_SWS_1_3h_SD(isnan(data_REM_SWS_1_3h_SD)==1)=0;
    data_REM_WAKE_1_3h_SD(imouse,:) = all_trans_REM_WAKE_1_3h_SD{imouse}; data_REM_WAKE_1_3h_SD(isnan(data_REM_WAKE_1_3h_SD)==1)=0;
    
    data_SWS_SWS_1_3h_SD(imouse,:) = all_trans_SWS_SWS_1_3h_SD{imouse}; data_SWS_SWS_1_3h_SD(isnan(data_SWS_SWS_1_3h_SD)==1)=0;
    data_SWS_REM_1_3h_SD(imouse,:) = all_trans_SWS_REM_1_3h_SD{imouse}; data_SWS_REM_1_3h_SD(isnan(data_SWS_REM_1_3h_SD)==1)=0;
    data_SWS_WAKE_1_3h_SD(imouse,:) = all_trans_SWS_WAKE_1_3h_SD{imouse}; data_SWS_WAKE_1_3h_SD(isnan(data_SWS_WAKE_1_3h_SD)==1)=0;
    
    data_WAKE_WAKE_1_3h_SD(imouse,:) = all_trans_WAKE_WAKE_1_3h_SD{imouse}; data_WAKE_WAKE_1_3h_SD(isnan(data_WAKE_WAKE_1_3h_SD)==1)=0;
    data_WAKE_REM_1_3h_SD(imouse,:) = all_trans_WAKE_REM_1_3h_SD{imouse}; data_WAKE_REM_1_3h_SD(isnan(data_WAKE_REM_1_3h_SD)==1)=0;
    data_WAKE_SWS_1_3h_SD(imouse,:) = all_trans_WAKE_SWS_1_3h_SD{imouse}; data_WAKE_SWS_1_3h_SD(isnan(data_WAKE_SWS_1_3h_SD)==1)=0;
    
    %%FIN DE LA SESSION
    data_REM_REM_3_end_SD(imouse,:) = all_trans_REM_REM_3_end_SD{imouse}; data_REM_REM_3_end_SD(isnan(data_REM_REM_3_end_SD)==1)=0;
    data_REM_SWS_3_end_SD(imouse,:) = all_trans_REM_SWS_3_end_SD{imouse}; data_REM_SWS_3_end_SD(isnan(data_REM_SWS_3_end_SD)==1)=0;
    data_REM_WAKE_3_end_SD(imouse,:) = all_trans_REM_WAKE_3_end_SD{imouse}; data_REM_WAKE_3_end_SD(isnan(data_REM_WAKE_3_end_SD)==1)=0;
    
    data_SWS_SWS_3_end_SD(imouse,:) = all_trans_SWS_SWS_3_end_SD{imouse}; data_SWS_SWS_3_end_SD(isnan(data_SWS_SWS_3_end_SD)==1)=0;
    data_SWS_REM_3_end_SD(imouse,:) = all_trans_SWS_REM_3_end_SD{imouse}; data_SWS_REM_3_end_SD(isnan(data_SWS_REM_3_end_SD)==1)=0;
    data_SWS_WAKE_3_end_SD(imouse,:) = all_trans_SWS_WAKE_3_end_SD{imouse}; data_SWS_WAKE_3_end_SD(isnan(data_SWS_WAKE_3_end_SD)==1)=0;
    
    data_WAKE_WAKE_3_end_SD(imouse,:) = all_trans_WAKE_WAKE_3_end_SD{imouse}; data_WAKE_WAKE_3_end_SD(isnan(data_WAKE_WAKE_3_end_SD)==1)=0;
    data_WAKE_REM_3_end_SD(imouse,:) = all_trans_WAKE_REM_3_end_SD{imouse}; data_WAKE_REM_3_end_SD(isnan(data_WAKE_REM_3_end_SD)==1)=0;
    data_WAKE_SWS_3_end_SD(imouse,:) = all_trans_WAKE_SWS_3_end_SD{imouse}; data_WAKE_SWS_3_end_SD(isnan(data_WAKE_SWS_3_end_SD)==1)=0;
    
end

%% SD + DREADD cno group (inhiition of CRH VLPO neurons)
for i=1:length(Dir_4.path)
    cd(Dir_4.path{i}{1});
    %     %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD_dreadd_cno{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tSD_dreadd_cnoMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD_dreadd_cno{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tSD_dreadd_cnoMovement');
    else
    end
    %         if exist('SleepScoring_OBGamma2.mat')
    %         stages_SD_dreadd_cno{i} = load('SleepScoring_OBGamma2', 'REMEpoch', 'SWSEpoch', 'Wake','tSD_dreadd_cnoMovement');
    %     elseif exist('SleepScoring_Accelero.mat')
    %         stages_SD_dreadd_cno{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tSD_dreadd_cnoMovement');
    %     else
    %         end
    
    same_epoch_SD_dreadd_cno{i} = intervalSet(0,time_end);
    same_epoch_1_3h_SD_dreadd_cno{i} = intervalSet(time_st,time_mid);
    same_epoch_3_end_SD_dreadd_cno{i} = intervalSet(time_mid,time_end);
    
    all_st_rem_SD_dreadd_cno{i} = Start(stages_SD_dreadd_cno{i}.REMEpoch);
    latency_rem_SD_dreadd_cno(i) = all_st_rem_SD_dreadd_cno{i}(1);
    
    all_st_sws_SD_dreadd_cno{i} = Start(stages_SD_dreadd_cno{i}.SWSEpoch);
    latency_sws_SD_dreadd_cno(i) = all_st_sws_SD_dreadd_cno{i}(find(all_st_sws_SD_dreadd_cno{i}>min_sws_time,1,'first'));
    
    %%ALL SESSION WITH TIMEBiNS 1H
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_SD_dreadd_cno{i}),'wake',tempbin,time_st,time_end);
    dur_WAKE_SD_dreadd_cno{i}=dur_moyenne_ep_WAKE;
    num_WAKE_SD_dreadd_cno{i}=num_moyen_ep_WAKE;
    perc_WAKE_SD_dreadd_cno{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_SD_dreadd_cno{i}),'sws',tempbin,time_st,time_end);
    dur_SWS_SD_dreadd_cno{i}=dur_moyenne_ep_SWS;
    num_SWS_SD_dreadd_cno{i}=num_moyen_ep_SWS;
    perc_SWS_SD_dreadd_cno{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_SD_dreadd_cno{i}),'rem',tempbin,time_st,time_end);
    dur_REM_SD_dreadd_cno{i}=dur_moyenne_ep_REM;
    num_REM_SD_dreadd_cno{i}=num_moyen_ep_REM;
    perc_REM_SD_dreadd_cno{i}=perc_moyen_REM;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_SD_dreadd_cno{i}),tempbin,time_st,time_end);
    all_trans_REM_REM_SD_dreadd_cno{i} = trans_REM_to_REM;
    all_trans_REM_SWS_SD_dreadd_cno{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_SD_dreadd_cno{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_SD_dreadd_cno{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_SD_dreadd_cno{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_SD_dreadd_cno{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_SD_dreadd_cno{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_SD_dreadd_cno{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_SD_dreadd_cno{i} = trans_WAKE_to_WAKE;
    
    %%3 PREMI7RE HEUES APRES SD_dreadd_cno
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_1_3h_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{i}),'wake',tempbin,time_st,time_mid);
    dur_WAKE_1_3h_SD_dreadd_cno{i}=dur_moyenne_ep_WAKE;
    num_WAKE_1_3h_SD_dreadd_cno{i}=num_moyen_ep_WAKE;
    perc_WAKE_1_3h_SD_dreadd_cno{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_1_3h_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{i}),'sws',tempbin,time_st,time_mid);
    dur_SWS_1_3h_SD_dreadd_cno{i}=dur_moyenne_ep_SWS;
    num_SWS_1_3h_SD_dreadd_cno{i}=num_moyen_ep_SWS;
    perc_SWS_1_3h_SD_dreadd_cno{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_1_3h_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{i}),'rem',tempbin,time_st,time_mid);
    dur_REM_1_3h_SD_dreadd_cno{i}=dur_moyenne_ep_REM;
    num_REM_1_3h_SD_dreadd_cno{i}=num_moyen_ep_REM;
    perc_REM_1_3h_SD_dreadd_cno{i}=perc_moyen_REM;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_1_3h_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_1_3h_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_1_3h_SD_dreadd_cno{i}),tempbin,time_st,time_mid);
    all_trans_REM_REM_1_3h_SD_dreadd_cno{i} = trans_REM_to_REM;
    all_trans_REM_SWS_1_3h_SD_dreadd_cno{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_1_3h_SD_dreadd_cno{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_1_3h_SD_dreadd_cno{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_1_3h_SD_dreadd_cno{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_1_3h_SD_dreadd_cno{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_1_3h_SD_dreadd_cno{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_1_3h_SD_dreadd_cno{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_1_3h_SD_dreadd_cno{i} = trans_WAKE_to_WAKE;
    
    %%3H POST SD_dreadd_cno JUSQU'A LA FIN
    %%Compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_3_end_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{i}),'wake',tempbin,time_mid,time_end);
    dur_WAKE_3_end_SD_dreadd_cno{i}=dur_moyenne_ep_WAKE;
    num_WAKE_3_end_SD_dreadd_cno{i}=num_moyen_ep_WAKE;
    perc_WAKE_3_end_SD_dreadd_cno{i}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_3_end_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{i}),'sws',tempbin,time_mid,time_end);
    dur_SWS_3_end_SD_dreadd_cno{i}=dur_moyenne_ep_SWS;
    num_SWS_3_end_SD_dreadd_cno{i}=num_moyen_ep_SWS;
    perc_SWS_3_end_SD_dreadd_cno{i}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_OverTimeWindows_version_2_groups_MC(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_3_end_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{i}),'rem',tempbin,time_mid,time_end);
    dur_REM_3_end_SD_dreadd_cno{i}=dur_moyenne_ep_REM;
    num_REM_3_end_SD_dreadd_cno{i}=num_moyen_ep_REM;
    perc_REM_3_end_SD_dreadd_cno{i}=perc_moyen_REM;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_OverTimeWindows_MC_version2_vf(and(stages_SD_dreadd_cno{i}.Wake,same_epoch_3_end_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.SWSEpoch,same_epoch_3_end_SD_dreadd_cno{i}),and(stages_SD_dreadd_cno{i}.REMEpoch,same_epoch_3_end_SD_dreadd_cno{i}),tempbin,time_mid,time_end);
    all_trans_REM_REM_3_end_SD_dreadd_cno{i} = trans_REM_to_REM;
    all_trans_REM_SWS_3_end_SD_dreadd_cno{i} = trans_REM_to_SWS;
    all_trans_REM_WAKE_3_end_SD_dreadd_cno{i} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_3_end_SD_dreadd_cno{i} = trans_SWS_to_REM;
    all_trans_SWS_SWS_3_end_SD_dreadd_cno{i} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_3_end_SD_dreadd_cno{i} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_3_end_SD_dreadd_cno{i} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_3_end_SD_dreadd_cno{i} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_3_end_SD_dreadd_cno{i} = trans_WAKE_to_WAKE;
end
%% compute average
%%percentage/duration/number
for imouse=1:length(dur_REM_SD_dreadd_cno)
    %%ALL SESSION
    data_dur_REM_SD_dreadd_cno(imouse,:) = dur_REM_SD_dreadd_cno{imouse}; 
    data_dur_SWS_SD_dreadd_cno(imouse,:) = dur_SWS_SD_dreadd_cno{imouse};
    data_dur_WAKE_SD_dreadd_cno(imouse,:) = dur_WAKE_SD_dreadd_cno{imouse}; 
    data_dur_REM_SD_dreadd_cno(isnan(data_dur_REM_SD_dreadd_cno)==1)=0;
    data_dur_SWS_SD_dreadd_cno(isnan(data_dur_SWS_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_SD_dreadd_cno(isnan(data_dur_WAKE_SD_dreadd_cno)==1)=0;

    
    data_num_REM_SD_dreadd_cno(imouse,:) = num_REM_SD_dreadd_cno{imouse};
    data_num_SWS_SD_dreadd_cno(imouse,:) = num_SWS_SD_dreadd_cno{imouse}; 
    data_num_WAKE_SD_dreadd_cno(imouse,:) = num_WAKE_SD_dreadd_cno{imouse}; 
    data_num_REM_SD_dreadd_cno(isnan(data_num_REM_SD_dreadd_cno)==1)=0;
    data_num_SWS_SD_dreadd_cno(isnan(data_num_SWS_SD_dreadd_cno)==1)=0;
    data_num_WAKE_SD_dreadd_cno(isnan(data_num_WAKE_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_SD_dreadd_cno(imouse,:) = perc_REM_SD_dreadd_cno{imouse}; 
    data_perc_SWS_SD_dreadd_cno(imouse,:) = perc_SWS_SD_dreadd_cno{imouse}; 
    data_perc_WAKE_SD_dreadd_cno(imouse,:) = perc_WAKE_SD_dreadd_cno{imouse}; 
    data_perc_REM_SD_dreadd_cno(isnan(data_perc_REM_SD_dreadd_cno)==1)=0;
    data_perc_SWS_SD_dreadd_cno(isnan(data_perc_SWS_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_SD_dreadd_cno(isnan(data_perc_WAKE_SD_dreadd_cno)==1)=0;
    
    %3 PREMI7RES HEURES
    data_dur_REM_1_3h_SD_dreadd_cno(imouse,:) = dur_REM_1_3h_SD_dreadd_cno{imouse}; 
    data_dur_SWS_1_3h_SD_dreadd_cno(imouse,:) = dur_SWS_1_3h_SD_dreadd_cno{imouse}; 
    data_dur_WAKE_1_3h_SD_dreadd_cno(imouse,:) = dur_WAKE_1_3h_SD_dreadd_cno{imouse}; 
    data_dur_REM_1_3h_SD_dreadd_cno(isnan(data_dur_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_dur_SWS_1_3h_SD_dreadd_cno(isnan(data_dur_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_1_3h_SD_dreadd_cno(isnan(data_dur_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    
    data_num_REM_1_3h_SD_dreadd_cno(imouse,:) = num_REM_1_3h_SD_dreadd_cno{imouse};
    data_num_SWS_1_3h_SD_dreadd_cno(imouse,:) = num_SWS_1_3h_SD_dreadd_cno{imouse}; 
    data_num_WAKE_1_3h_SD_dreadd_cno(imouse,:) = num_WAKE_1_3h_SD_dreadd_cno{imouse}; 
    data_num_REM_1_3h_SD_dreadd_cno(isnan(data_num_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_num_SWS_1_3h_SD_dreadd_cno(isnan(data_num_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_num_WAKE_1_3h_SD_dreadd_cno(isnan(data_num_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_1_3h_SD_dreadd_cno(imouse,:) = perc_REM_1_3h_SD_dreadd_cno{imouse}; 
    data_perc_SWS_1_3h_SD_dreadd_cno(imouse,:) = perc_SWS_1_3h_SD_dreadd_cno{imouse}; 
    data_perc_WAKE_1_3h_SD_dreadd_cno(imouse,:) = perc_WAKE_1_3h_SD_dreadd_cno{imouse}; 
    data_perc_REM_1_3h_SD_dreadd_cno(isnan(data_perc_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_perc_SWS_1_3h_SD_dreadd_cno(isnan(data_perc_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_1_3h_SD_dreadd_cno(isnan(data_perc_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    
    %FIN DE LA SESSION
    data_dur_REM_3_end_SD_dreadd_cno(imouse,:) = dur_REM_3_end_SD_dreadd_cno{imouse}; 
    data_dur_SWS_3_end_SD_dreadd_cno(imouse,:) = dur_SWS_3_end_SD_dreadd_cno{imouse}; 
    data_dur_WAKE_3_end_SD_dreadd_cno(imouse,:) = dur_WAKE_3_end_SD_dreadd_cno{imouse}; 
    data_dur_REM_3_end_SD_dreadd_cno(isnan(data_dur_REM_3_end_SD_dreadd_cno)==1)=0;
    data_dur_SWS_3_end_SD_dreadd_cno(isnan(data_dur_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_dur_WAKE_3_end_SD_dreadd_cno(isnan(data_dur_WAKE_3_end_SD_dreadd_cno)==1)=0;
    
    data_num_REM_3_end_SD_dreadd_cno(imouse,:) = num_REM_3_end_SD_dreadd_cno{imouse};
    data_num_SWS_3_end_SD_dreadd_cno(imouse,:) = num_SWS_3_end_SD_dreadd_cno{imouse}; 
    data_num_WAKE_3_end_SD_dreadd_cno(imouse,:) = num_WAKE_3_end_SD_dreadd_cno{imouse}; 
    data_num_REM_3_end_SD_dreadd_cno(isnan(data_num_REM_3_end_SD_dreadd_cno)==1)=0;
    data_num_SWS_3_end_SD_dreadd_cno(isnan(data_num_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_num_WAKE_3_end_SD_dreadd_cno(isnan(data_num_WAKE_3_end_SD_dreadd_cno)==1)=0;
    
    data_perc_REM_3_end_SD_dreadd_cno(imouse,:) = perc_REM_3_end_SD_dreadd_cno{imouse}; 
    data_perc_SWS_3_end_SD_dreadd_cno(imouse,:) = perc_SWS_3_end_SD_dreadd_cno{imouse}; 
    data_perc_WAKE_3_end_SD_dreadd_cno(imouse,:) = perc_WAKE_3_end_SD_dreadd_cno{imouse}; 
    data_perc_REM_3_end_SD_dreadd_cno(isnan(data_perc_REM_3_end_SD_dreadd_cno)==1)=0;
    data_perc_SWS_3_end_SD_dreadd_cno(isnan(data_perc_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_perc_WAKE_3_end_SD_dreadd_cno(isnan(data_perc_WAKE_3_end_SD_dreadd_cno)==1)=0;
end
%%probability
for imouse=1:length(all_trans_REM_REM_SD_dreadd_cno)
    %%ALL SESSION
    data_REM_REM_SD_dreadd_cno(imouse,:) = all_trans_REM_REM_SD_dreadd_cno{imouse}; data_REM_REM_SD_dreadd_cno(isnan(data_REM_REM_SD_dreadd_cno)==1)=0;
    data_REM_SWS_SD_dreadd_cno(imouse,:) = all_trans_REM_SWS_SD_dreadd_cno{imouse}; data_REM_SWS_SD_dreadd_cno(isnan(data_REM_SWS_SD_dreadd_cno)==1)=0;
    data_REM_WAKE_SD_dreadd_cno(imouse,:) = all_trans_REM_WAKE_SD_dreadd_cno{imouse}; data_REM_WAKE_SD_dreadd_cno(isnan(data_REM_WAKE_SD_dreadd_cno)==1)=0;
    
    data_SWS_SWS_SD_dreadd_cno(imouse,:) = all_trans_SWS_SWS_SD_dreadd_cno{imouse}; data_SWS_SWS_SD_dreadd_cno(isnan(data_SWS_SWS_SD_dreadd_cno)==1)=0;
    data_SWS_REM_SD_dreadd_cno(imouse,:) = all_trans_SWS_REM_SD_dreadd_cno{imouse}; data_SWS_REM_SD_dreadd_cno(isnan(data_SWS_REM_SD_dreadd_cno)==1)=0;
    data_SWS_WAKE_SD_dreadd_cno(imouse,:) = all_trans_SWS_WAKE_SD_dreadd_cno{imouse}; data_SWS_WAKE_SD_dreadd_cno(isnan(data_SWS_WAKE_SD_dreadd_cno)==1)=0;
    
    data_WAKE_WAKE_SD_dreadd_cno(imouse,:) = all_trans_WAKE_WAKE_SD_dreadd_cno{imouse}; data_WAKE_WAKE_SD_dreadd_cno(isnan(data_WAKE_WAKE_SD_dreadd_cno)==1)=0;
    data_WAKE_REM_SD_dreadd_cno(imouse,:) = all_trans_WAKE_REM_SD_dreadd_cno{imouse}; data_WAKE_REM_SD_dreadd_cno(isnan(data_WAKE_REM_SD_dreadd_cno)==1)=0;
    data_WAKE_SWS_SD_dreadd_cno(imouse,:) = all_trans_WAKE_SWS_SD_dreadd_cno{imouse}; data_WAKE_SWS_SD_dreadd_cno(isnan(data_WAKE_SWS_SD_dreadd_cno)==1)=0;
    
    %%3 PREMI7RES HEURES
    data_REM_REM_1_3h_SD_dreadd_cno(imouse,:) = all_trans_REM_REM_1_3h_SD_dreadd_cno{imouse}; data_REM_REM_1_3h_SD_dreadd_cno(isnan(data_REM_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_REM_SWS_1_3h_SD_dreadd_cno(imouse,:) = all_trans_REM_SWS_1_3h_SD_dreadd_cno{imouse}; data_REM_SWS_1_3h_SD_dreadd_cno(isnan(data_REM_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_REM_WAKE_1_3h_SD_dreadd_cno(imouse,:) = all_trans_REM_WAKE_1_3h_SD_dreadd_cno{imouse}; data_REM_WAKE_1_3h_SD_dreadd_cno(isnan(data_REM_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    
    data_SWS_SWS_1_3h_SD_dreadd_cno(imouse,:) = all_trans_SWS_SWS_1_3h_SD_dreadd_cno{imouse}; data_SWS_SWS_1_3h_SD_dreadd_cno(isnan(data_SWS_SWS_1_3h_SD_dreadd_cno)==1)=0;
    data_SWS_REM_1_3h_SD_dreadd_cno(imouse,:) = all_trans_SWS_REM_1_3h_SD_dreadd_cno{imouse}; data_SWS_REM_1_3h_SD_dreadd_cno(isnan(data_SWS_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_SWS_WAKE_1_3h_SD_dreadd_cno(imouse,:) = all_trans_SWS_WAKE_1_3h_SD_dreadd_cno{imouse}; data_SWS_WAKE_1_3h_SD_dreadd_cno(isnan(data_SWS_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    
    data_WAKE_WAKE_1_3h_SD_dreadd_cno(imouse,:) = all_trans_WAKE_WAKE_1_3h_SD_dreadd_cno{imouse}; data_WAKE_WAKE_1_3h_SD_dreadd_cno(isnan(data_WAKE_WAKE_1_3h_SD_dreadd_cno)==1)=0;
    data_WAKE_REM_1_3h_SD_dreadd_cno(imouse,:) = all_trans_WAKE_REM_1_3h_SD_dreadd_cno{imouse}; data_WAKE_REM_1_3h_SD_dreadd_cno(isnan(data_WAKE_REM_1_3h_SD_dreadd_cno)==1)=0;
    data_WAKE_SWS_1_3h_SD_dreadd_cno(imouse,:) = all_trans_WAKE_SWS_1_3h_SD_dreadd_cno{imouse}; data_WAKE_SWS_1_3h_SD_dreadd_cno(isnan(data_WAKE_SWS_1_3h_SD_dreadd_cno)==1)=0;
    
    %%FIN DE LA SESSION
    data_REM_REM_3_end_SD_dreadd_cno(imouse,:) = all_trans_REM_REM_3_end_SD_dreadd_cno{imouse}; data_REM_REM_3_end_SD_dreadd_cno(isnan(data_REM_REM_3_end_SD_dreadd_cno)==1)=0;
    data_REM_SWS_3_end_SD_dreadd_cno(imouse,:) = all_trans_REM_SWS_3_end_SD_dreadd_cno{imouse}; data_REM_SWS_3_end_SD_dreadd_cno(isnan(data_REM_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_REM_WAKE_3_end_SD_dreadd_cno(imouse,:) = all_trans_REM_WAKE_3_end_SD_dreadd_cno{imouse}; data_REM_WAKE_3_end_SD_dreadd_cno(isnan(data_REM_WAKE_3_end_SD_dreadd_cno)==1)=0;
    
    data_SWS_SWS_3_end_SD_dreadd_cno(imouse,:) = all_trans_SWS_SWS_3_end_SD_dreadd_cno{imouse}; data_SWS_SWS_3_end_SD_dreadd_cno(isnan(data_SWS_SWS_3_end_SD_dreadd_cno)==1)=0;
    data_SWS_REM_3_end_SD_dreadd_cno(imouse,:) = all_trans_SWS_REM_3_end_SD_dreadd_cno{imouse}; data_SWS_REM_3_end_SD_dreadd_cno(isnan(data_SWS_REM_3_end_SD_dreadd_cno)==1)=0;
    data_SWS_WAKE_3_end_SD_dreadd_cno(imouse,:) = all_trans_SWS_WAKE_3_end_SD_dreadd_cno{imouse}; data_SWS_WAKE_3_end_SD_dreadd_cno(isnan(data_SWS_WAKE_3_end_SD_dreadd_cno)==1)=0;
    
    data_WAKE_WAKE_3_end_SD_dreadd_cno(imouse,:) = all_trans_WAKE_WAKE_3_end_SD_dreadd_cno{imouse}; data_WAKE_WAKE_3_end_SD_dreadd_cno(isnan(data_WAKE_WAKE_3_end_SD_dreadd_cno)==1)=0;
    data_WAKE_REM_3_end_SD_dreadd_cno(imouse,:) = all_trans_WAKE_REM_3_end_SD_dreadd_cno{imouse}; data_WAKE_REM_3_end_SD_dreadd_cno(isnan(data_WAKE_REM_3_end_SD_dreadd_cno)==1)=0;
    data_WAKE_SWS_3_end_SD_dreadd_cno(imouse,:) = all_trans_WAKE_SWS_3_end_SD_dreadd_cno{imouse}; data_WAKE_SWS_3_end_SD_dreadd_cno(isnan(data_WAKE_SWS_3_end_SD_dreadd_cno)==1)=0;
end

%% FIGURE 3 :  mean over slot + ttest

%%
col_1 = [.2 .6 1]; %bleu clair %saline 10H sur DREADD-
col_2 = [.2 .2 .8]; %bleu foncé %CNO 10H sur DREADD-
col_3 = [1 .3 0]; %orange foncé %CNO après SD sur mCherry
col_4 = [0 .4 .4]; %émeraude clair %CNO après SD sur DREADD-


figure, hold on
subplot(4,6,[1,2]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_1)
plot(nanmean(data_perc_WAKE_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_perc_WAKE_SD_mCherry_cno), stdError(data_perc_WAKE_SD_mCherry_cno),'color',col_2)
plot(nanmean(data_perc_WAKE_SD,1),'linestyle','-','marker','^','markerfacecolor',col_3,'markersize',8,'color',col_3)
errorbar(nanmean(data_perc_WAKE_SD,1), stdError(data_perc_WAKE_SD),'linestyle','-','color',col_3)
plot(nanmean(data_perc_WAKE_SD_dreadd_cno),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_4,'color',col_4)
errorbar(nanmean(data_perc_WAKE_SD_dreadd_cno), stdError(data_perc_WAKE_SD_dreadd_cno),'color',col_4)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('Wake percentage')
xlabel('Time of the day (h)')

subplot(4,6,[7,8]) % WAKE percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_1,col_2,col_3,col_4,col_1,col_2,col_3,col_4});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
% ylabel('Wake percentage')
makepretty
xlabel('Time of the day (h)')

% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2),nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_WAKE_1_3h_SD,2), nanmean(data_perc_WAKE_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[1 2]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_DB({[1 3]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[3 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2),nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_WAKE_3_end_SD,2), nanmean(data_perc_WAKE_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[6 7]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_DB({[6 8]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[7 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[8 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[3,4]), hold on % SWS percentage overtime
plot(nanmean(data_perc_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_SWS_ctrl), stdError(data_perc_SWS_ctrl),'color',col_1)
plot(nanmean(data_perc_SWS_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_perc_SWS_SD_mCherry_cno), stdError(data_perc_SWS_SD_mCherry_cno),'color',col_2)
plot(nanmean(data_perc_SWS_SD,1),'linestyle','-','marker','^','markerfacecolor',col_3,'markersize',8,'color',col_3)
errorbar(nanmean(data_perc_SWS_SD,1), stdError(data_perc_SWS_SD),'linestyle','-','color',col_3)
plot(nanmean(data_perc_SWS_SD_dreadd_cno),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_4,'color',col_4)
errorbar(nanmean(data_perc_SWS_SD_dreadd_cno), stdError(data_perc_SWS_SD_dreadd_cno),'color',col_4)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('NREM percentage')
xlabel('Time of the day (h)')

subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_SWS_1_3h_ctrl,2),  nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_1,col_2,col_3,col_4,col_1,col_2,col_3,col_4});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
% title('NREM percentage')
makepretty
xlabel('Time of the day (h)')


% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2),nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_SWS_1_3h_SD,2), nanmean(data_perc_SWS_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[1 2]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_DB({[1 3]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[3 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2),nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_SWS_3_end_SD,2), nanmean(data_perc_SWS_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[6 7]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_DB({[6 8]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[7 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[8 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[5,6]) %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'color',col_1)
plot(nanmean(data_perc_REM_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_perc_REM_SD_mCherry_cno), stdError(data_perc_REM_SD_mCherry_cno),'color',col_2)
plot(nanmean(data_perc_REM_SD,1),'linestyle','-','marker','^','markerfacecolor',col_3,'markersize',8,'color',col_3)
errorbar(nanmean(data_perc_REM_SD,1), stdError(data_perc_REM_SD),'linestyle','-','color',col_3)
plot(nanmean(data_perc_REM_SD_dreadd_cno),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_4,'color',col_4)
errorbar(nanmean(data_perc_REM_SD_dreadd_cno), stdError(data_perc_REM_SD_dreadd_cno),'color',col_4)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('REM percentage')
xlabel('Time of the day (h)')


subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_1,col_2,col_3,col_4,col_1,col_2,col_3,col_4});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
% title('REM percentage')
makepretty
xlabel('Time of the day (h)')

% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2),nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_REM_1_3h_SD,2), nanmean(data_perc_REM_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[1 2]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_DB({[1 3]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[3 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2),nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_REM_3_end_SD_mCherry_cno,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_perc_REM_3_end_SD,2), nanmean(data_perc_REM_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[6 7]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_DB({[6 8]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[7 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[8 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[13,14]) % Wake bouts number ovetime
plot(nanmean(data_num_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_WAKE_ctrl), stdError(data_num_WAKE_ctrl),'color',col_1)
plot(nanmean(data_num_WAKE_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_num_WAKE_SD_mCherry_cno), stdError(data_num_WAKE_SD_mCherry_cno),'color',col_2)
plot(nanmean(data_num_WAKE_SD,1),'linestyle','-','marker','^','markerfacecolor',col_3,'markersize',8,'color',col_3)
errorbar(nanmean(data_num_WAKE_SD,1), stdError(data_num_WAKE_SD),'linestyle','-','color',col_3)
plot(nanmean(data_num_WAKE_SD_dreadd_cno),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_4,'color',col_4)
errorbar(nanmean(data_num_WAKE_SD_dreadd_cno), stdError(data_num_WAKE_SD_dreadd_cno),'color',col_4)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('Wake bouts number')
xlabel('Time of the day (h)')


subplot(4,6,[19,20]) % Wake bouts number quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_1,col_2,col_3,col_4,col_1,col_2,col_3,col_4});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
% title('Wake bouts number')
makepretty
xlabel('Time of the day (h)')

% [h,p_ctrl_vs_mCherry_cno] = ttest(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_num_WAKE_1_3h_ctrl,2), nanmean(data_num_WAKE_1_3h_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_1_3h_ctrl,2),nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_num_WAKE_1_3h_ctrl,2),nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_num_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_num_WAKE_1_3h_SD,2), nanmean(data_num_WAKE_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[1 2]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_DB({[1 3]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[3 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

%4-8h
% [h,p_ctrl_vs_mCherry_cno] = ttest(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_num_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[6 7]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_DB({[6 8]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[7 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[8 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[15,16]) % Wake bouts mean duraion overtime
plot(nanmean(data_dur_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_WAKE_ctrl), stdError(data_dur_WAKE_ctrl),'color',col_1)
plot(nanmean(data_dur_WAKE_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_dur_WAKE_SD_mCherry_cno), stdError(data_dur_WAKE_SD_mCherry_cno),'color',col_2)
plot(nanmean(data_dur_WAKE_SD,1),'linestyle','-','marker','^','markerfacecolor',col_3,'markersize',8,'color',col_3)
errorbar(nanmean(data_dur_WAKE_SD,1), stdError(data_dur_WAKE_SD),'linestyle','-','color',col_3)
plot(nanmean(data_dur_WAKE_SD_dreadd_cno),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_4,'color',col_4)
errorbar(nanmean(data_dur_WAKE_SD_dreadd_cno), stdError(data_dur_WAKE_SD_dreadd_cno),'color',col_4)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('Wake mean duration (s)')
xlabel('Time of the day (h)')



subplot(4,6,[21,22]) % Wake bouts mean duration quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2),...
    nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4,6:9],'barcolors',{col_1,col_2,col_3,col_4,col_1,col_2,col_3,col_4});
xticks([2.5 7.5]); xticklabels({'10-13h','13-18h'}); xtickangle(0)
% title('Wake mean duration (s)')
makepretty
xlabel('Time of the day (h)')

% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_dur_WAKE_1_3h_ctrl,2), nanmean(data_dur_WAKE_1_3h_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_ctrl,2),nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_dur_WAKE_1_3h_ctrl,2),nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_dur_WAKE_1_3h_SD_mCherry_cno,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_dur_WAKE_1_3h_SD,2), nanmean(data_dur_WAKE_1_3h_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[1 2]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_DB({[1 3]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[3 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end

% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_dur_WAKE_3_end_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_3_end_ctrl,2),nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_dur_WAKE_3_end_ctrl,2),nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[6 7]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_SD<0.05; sigstar_DB({[6 8]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[7 8]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[7 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[8 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[17]) % FI Wake (5-8h)
PlotErrorBarN_MC({...
    nanmean(data_num_WAKE_3_end_ctrl,2)./nanmean(data_dur_WAKE_3_end_ctrl,2),...
    nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2)./nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2),...
    nanmean(data_num_WAKE_3_end_SD,2)./nanmean(data_dur_WAKE_3_end_SD,2),...
    nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)./nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
title('Wake fragmentation index')
makepretty
set(gca,'xtick',[])
xticks([1:5]); xticklabels({}); xtickangle(0)
xlabel('Time of the day (h)')

% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2)./nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2)./nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2)./nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2)./nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2)./nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2)./nanmean(data_dur_WAKE_3_end_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2)./nanmean(data_dur_WAKE_3_end_ctrl,2), nanmean(data_num_WAKE_3_end_SD,2)./nanmean(data_dur_WAKE_3_end_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_ctrl,2)./nanmean(data_dur_WAKE_3_end_ctrl,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)./nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_num_WAKE_3_end_ctrl,2)./nanmean(data_dur_WAKE_3_end_ctrl,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)./nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2)./nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD,2)./nanmean(data_dur_WAKE_3_end_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2)./nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_3_end_SD,2)./nanmean(data_dur_WAKE_3_end_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2)./nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)./nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_num_WAKE_3_end_SD_mCherry_cno,2)./nanmean(data_dur_WAKE_3_end_SD_mCherry_cno,2),nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)./nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_3_end_SD,2)./nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)./nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_num_WAKE_3_end_SD,2)./nanmean(data_dur_WAKE_3_end_SD,2), nanmean(data_num_WAKE_3_end_SD_dreadd_cno,2)./nanmean(data_dur_WAKE_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[1 2]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_DB({[1 3]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[3 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[23]) %proba stay Wake_4-8h
PlotErrorBarN_MC({...
    1-(nanmean(data_WAKE_REM_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2)),...
    1-(nanmean(data_WAKE_REM_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2)),...
    1-(nanmean(data_WAKE_REM_3_end_SD,2)+nanmean(data_WAKE_SWS_3_end_SD,2)),...
    1-(nanmean(data_WAKE_REM_3_end_SD_dreadd_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_dreadd_cno,2))},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
ylim([.96 1])
xticks([1:5]); xticklabels({}); xtickangle(0)
title('Wake stay probability')
makepretty
set(gca,'xtick',[])
xlabel('Time of the day (h)')

% [h,p_ctrl_vs_mCherry_cno] = ttest2(1-(nanmean(data_WAKE_REM_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2)), 1-(nanmean(data_WAKE_REM_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2)));
[p_ctrl_vs_mCherry_cno,h] = ranksum(1-(nanmean(data_WAKE_REM_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2)), 1-(nanmean(data_WAKE_REM_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2)));
% [h,p_ctrl_vs_SD] = ttest2(1-(nanmean(data_WAKE_REM_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2)), 1-(nanmean(data_WAKE_REM_3_end_SD,2)+nanmean(data_WAKE_SWS_3_end_SD,2)));
[p_ctrl_vs_SD,h] = ranksum(1-(nanmean(data_WAKE_REM_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2)), 1-(nanmean(data_WAKE_REM_3_end_SD,2)+nanmean(data_WAKE_SWS_3_end_SD,2)));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(1-(nanmean(data_WAKE_REM_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2)),1-(nanmean(data_WAKE_REM_3_end_SD_dreadd_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_dreadd_cno,2)));
[p_ctrl_vs_dreadd_cno,h] = ranksum(1-(nanmean(data_WAKE_REM_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2)),1-(nanmean(data_WAKE_REM_3_end_SD_dreadd_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_dreadd_cno,2)));
% [h,p_mCherry_cno_vs_SD] = ttest2(1-(nanmean(data_WAKE_REM_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2)), 1-(nanmean(data_WAKE_REM_3_end_SD,2)+nanmean(data_WAKE_SWS_3_end_SD,2)));
[p_mCherry_cno_vs_SD,h] = ranksum(1-(nanmean(data_WAKE_REM_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2)), 1-(nanmean(data_WAKE_REM_3_end_SD,2)+nanmean(data_WAKE_SWS_3_end_SD,2)));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(1-(nanmean(data_WAKE_REM_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2)), 1-(nanmean(data_WAKE_REM_3_end_SD_dreadd_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_dreadd_cno,2)));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(1-(nanmean(data_WAKE_REM_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2)), 1-(nanmean(data_WAKE_REM_3_end_SD_dreadd_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_dreadd_cno,2)));
% [h,p_SD_vs_dreadd_cno] = ttest2(1-(nanmean(data_WAKE_REM_3_end_SD,2)+nanmean(data_WAKE_SWS_3_end_SD,2)), 1-(nanmean(data_WAKE_REM_3_end_SD_dreadd_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_dreadd_cno,2)));
[p_SD_vs_dreadd_cno,h] = ranksum(1-(nanmean(data_WAKE_REM_3_end_SD,2)+nanmean(data_WAKE_SWS_3_end_SD,2)), 1-(nanmean(data_WAKE_REM_3_end_SD_dreadd_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_dreadd_cno,2)));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[1 2]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_DB({[1 3]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);  end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[3 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end


subplot(4,6,[24]) %proba initiate Wake 4-8h
PlotErrorBarN_MC({...
    nanmean(data_REM_WAKE_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2),...
    nanmean(data_REM_WAKE_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2),...
    nanmean(data_REM_WAKE_3_end_SD,2)+nanmean(data_SWS_WAKE_3_end_SD,2),...
    nanmean(data_REM_WAKE_3_end_SD_dreadd_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_dreadd_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
xticks([1:5]); xticklabels({}); xtickangle(0)
title('Wake init. probability')
makepretty
set(gca,'xtick',[])
xlabel('Time of the day (h)')

% [h,p_ctrl_vs_mCherry_cno] = ttest2(nanmean(data_REM_WAKE_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2), nanmean(data_REM_WAKE_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2));
[p_ctrl_vs_mCherry_cno,h] = ranksum(nanmean(data_REM_WAKE_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2), nanmean(data_REM_WAKE_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2));
% [h,p_ctrl_vs_SD] = ttest2(nanmean(data_REM_WAKE_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2), nanmean(data_REM_WAKE_3_end_SD,2)+nanmean(data_SWS_WAKE_3_end_SD,2));
[p_ctrl_vs_SD,h] = ranksum(nanmean(data_REM_WAKE_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2), nanmean(data_REM_WAKE_3_end_SD,2)+nanmean(data_SWS_WAKE_3_end_SD,2));
% [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_REM_WAKE_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2),nanmean(data_REM_WAKE_3_end_SD_dreadd_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_dreadd_cno,2));
[p_ctrl_vs_dreadd_cno,h] = ranksum(nanmean(data_REM_WAKE_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2),nanmean(data_REM_WAKE_3_end_SD_dreadd_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_mCherry_cno_vs_SD] = ttest2(nanmean(data_REM_WAKE_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_REM_WAKE_3_end_SD,2)+nanmean(data_SWS_WAKE_3_end_SD,2));
[p_mCherry_cno_vs_SD,h] = ranksum(nanmean(data_REM_WAKE_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_REM_WAKE_3_end_SD,2)+nanmean(data_SWS_WAKE_3_end_SD,2));
% [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_REM_WAKE_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_REM_WAKE_3_end_SD_dreadd_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_dreadd_cno,2));
[p_mCherry_cno_vs_dreadd_cno,h] = ranksum(nanmean(data_REM_WAKE_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2), nanmean(data_REM_WAKE_3_end_SD_dreadd_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_dreadd_cno,2));
% [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_REM_WAKE_3_end_SD,2)+nanmean(data_SWS_WAKE_3_end_SD,2), nanmean(data_REM_WAKE_3_end_SD_dreadd_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_dreadd_cno,2));
[p_SD_vs_dreadd_cno,h] = ranksum(nanmean(data_REM_WAKE_3_end_SD,2)+nanmean(data_SWS_WAKE_3_end_SD,2), nanmean(data_REM_WAKE_3_end_SD_dreadd_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_dreadd_cno,2));

if p_ctrl_vs_mCherry_cno<0.05; sigstar_DB({[1 2]},p_ctrl_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_SD<0.05; sigstar_DB({[1 3]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24); end
if p_ctrl_vs_dreadd_cno<0.05; sigstar_DB({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_SD<0.05; sigstar_DB({[2 3]},p_mCherry_cno_vs_SD,0,'LineWigth',16,'StarSize',24);end
if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_DB({[2 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
if p_SD_vs_dreadd_cno<0.05; sigstar_DB({[3 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24); end
