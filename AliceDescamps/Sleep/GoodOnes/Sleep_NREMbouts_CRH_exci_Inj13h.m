%% input dir
%% input dir
%%1
Dir_1=PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
%%2
Dir_2=PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');



%% parameters
tempbin = 3600;
time_end=3.5*1e8;
time_st = 0;
time_mid = 4.5*3600*1e4;

min_sws_time = 3.5*1e4*60;
binH = 2;

%% GET DATA
%% Saline group
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

%% CNO group
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


%% FIGURE :  mean over slot + ttest
col_1 = [.7 .7 .7]; %gris
col_2 = [0 .8 .4]; %vert clair 

figure, hold on
subplot(4,6,[1,2]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_1)
plot(nanmean(data_perc_WAKE_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_perc_WAKE_SD_mCherry_cno), stdError(data_perc_WAKE_SD_mCherry_cno),'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9]); xticklabels({'9','11','13','15','17'})
makepretty
title('Wake percentage')
xlabel('Time of the day (h)')

subplot(4,6,[7,8]) % WAKE percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2),...
    nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_1,col_2,col_1,col_2});
xticks([1.5 4.5]); xticklabels({'9-13h','13-18h'}); xtickangle(0)
% ylabel('Wake percentage')
makepretty
xlabel('Time of the day (h)')
set(gca,'fontsize',18,'fontname','FreeSans')

%Stat wake percentage
[h,p_sal_vs_cno_wake_1_3h] = ttest(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_wake_1_3h] = ttest2(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
% [p_sal_vs_cno_wake_1_3h,h] = signrank(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));
% [p_sal_vs_cno_wake_1_3h,h] = ranksum(nanmean(data_perc_WAKE_1_3h_ctrl,2), nanmean(data_perc_WAKE_1_3h_SD_mCherry_cno,2));

[h,p_sal_vs_cno_wake_3_end] = ttest(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_wake_3_end] = ttest2(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_wake_3_end,h] = signrank(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_wake_3_end,h] = ranksum(nanmean(data_perc_WAKE_3_end_ctrl,2), nanmean(data_perc_WAKE_3_end_SD_mCherry_cno,2));

if p_sal_vs_cno_wake_1_3h<0.05; sigstar_DB({[1 2]},p_sal_vs_cno_wake_1_3h,0,'LineWigth',16,'StarSize',24); end
if p_sal_vs_cno_wake_3_end<0.05; sigstar_DB({[4 5]},p_sal_vs_cno_wake_3_end,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[3,4]), hold on % SWS percentage overtime
plot(nanmean(data_perc_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_SWS_ctrl), stdError(data_perc_SWS_ctrl),'color',col_1)
plot(nanmean(data_perc_SWS_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_perc_SWS_SD_mCherry_cno), stdError(data_perc_SWS_SD_mCherry_cno),'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9]); xticklabels({'9','11','13','15','17'})
makepretty
title('NREM percentage')
xlabel('Time of the day (h)')

subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_SWS_1_3h_ctrl,2),  nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2),...
    nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_1,col_2,col_1,col_2});
xticks([1.5 4.5]); xticklabels({'9-13h','13-18h'}); xtickangle(0)
% ylabel('NREM percentage')
makepretty
xlabel('Time of the day (h)')

%Stat NREM percentage
[h,p_sal_vs_cno_SWS_1_3h] = ttest(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_SWS_1_3h] = ttest2(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
% [p_sal_vs_cno_SWS_1_3h,h] = signrank(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));
% [p_sal_vs_cno_SWS_1_3h,h] = ranksum(nanmean(data_perc_SWS_1_3h_ctrl,2), nanmean(data_perc_SWS_1_3h_SD_mCherry_cno,2));

[h,p_sal_vs_cno_SWS_3_end] = ttest(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_SWS_3_end] = ttest2(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_SWS_3_end,h] = signrank(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_SWS_3_end,h] = ranksum(nanmean(data_perc_SWS_3_end_ctrl,2), nanmean(data_perc_SWS_3_end_SD_mCherry_cno,2));

if p_sal_vs_cno_SWS_1_3h<0.05; sigstar_DB({[1 2]},p_sal_vs_cno_SWS_1_3h,0,'LineWigth',16,'StarSize',24); end
if p_sal_vs_cno_SWS_3_end<0.05; sigstar_DB({[4 5]},p_sal_vs_cno_SWS_3_end,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[5,6]) %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'color',col_1)
plot(nanmean(data_perc_REM_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_perc_REM_SD_mCherry_cno), stdError(data_perc_REM_SD_mCherry_cno),'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9]); xticklabels({'9','11','13','15','17'})
makepretty
title('REM percentage')
xlabel('Time of the day (h)')

subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2),...
    nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_1,col_2,col_1,col_2});
xticks([1.5 4.5]); xticklabels({'9-13h','13-18h'}); xtickangle(0)
% ylabel('REM percentage')
makepretty
xlabel('Time of the day (h)')

%Stat REM percentage
% [h,p_sal_vs_cno_REM_1_3h] = ttest(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_REM_1_3h] = ttest2(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
[p_sal_vs_cno_REM_1_3h,h] = signrank(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));
% [p_sal_vs_cno_REM_1_3h,h] = ranksum(nanmean(data_perc_REM_1_3h_ctrl,2), nanmean(data_perc_REM_1_3h_SD_mCherry_cno,2));

% [h,p_sal_vs_cno_REM_3_end] = ttest(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_REM_3_end] = ttest2(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
[p_sal_vs_cno_REM_3_end,h] = signrank(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_REM_3_end,h] = ranksum(nanmean(data_perc_REM_3_end_ctrl,2), nanmean(data_perc_REM_3_end_SD_mCherry_cno,2));

if p_sal_vs_cno_REM_1_3h<0.05; sigstar_DB({[1 2]},p_sal_vs_cno_REM_1_3h,0,'LineWigth',16,'StarSize',24); end
if p_sal_vs_cno_REM_3_end<0.05; sigstar_DB({[4 5]},p_sal_vs_cno_REM_3_end,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[13,14]) % NREM bouts number overtime
plot(nanmean(data_num_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_SWS_ctrl), stdError(data_num_SWS_ctrl),'color',col_1)
plot(nanmean(data_num_SWS_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_num_SWS_SD_mCherry_cno), stdError(data_num_SWS_SD_mCherry_cno),'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9]); xticklabels({'9','11','13','15','17'})
makepretty
title('NREM bouts number')
xlabel('Time of the day (h)')

subplot(4,6,[19,20]) % NREM bouts number quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2),...
    nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_1,col_2,col_1,col_2});
xticks([1.5 4.5]); xticklabels({'9-13h','13-18h'}); xtickangle(0)
% ylabel('NREM bouts number')
makepretty
xlabel('Time of the day (h)')

%Stat NREM number
% [h,p_sal_vs_cno_NREM_number_1_3h] = ttest(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_NREM_number_1_3h] = ttest2(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
[p_sal_vs_cno_NREM_number_1_3h,h] = signrank(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));
% [p_sal_vs_cno_NREM_number_1_3h,h] = ranksum(nanmean(data_num_SWS_1_3h_ctrl,2), nanmean(data_num_SWS_1_3h_SD_mCherry_cno,2));

% [h,p_sal_vs_cno_NREM_number_3_end] = ttest(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_NREM_number_3_end] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
[p_sal_vs_cno_NREM_number_3_end,h] = signrank(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_NREM_number_3_end,h] = ranksum(nanmean(data_num_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2));

if p_sal_vs_cno_NREM_number_1_3h<0.05; sigstar_DB({[1 2]},p_sal_vs_cno_NREM_number_1_3h,0,'LineWigth',16,'StarSize',24); end
if p_sal_vs_cno_NREM_number_3_end<0.05; sigstar_DB({[4 5]},p_sal_vs_cno_NREM_number_3_end,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[15,16]) % NREM bouts mean duraion overtime
plot(nanmean(data_dur_SWS_ctrl),'linestyle','-','marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_SWS_ctrl), stdError(data_dur_SWS_ctrl),'color',col_1)
plot(nanmean(data_dur_SWS_SD_mCherry_cno),'linestyle','-','marker','^','markersize',8,'markerfacecolor',col_2,'color',col_2), hold on
errorbar(nanmean(data_dur_SWS_SD_mCherry_cno), stdError(data_dur_SWS_SD_mCherry_cno),'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9]); xticklabels({'9','11','13','15','17'})
makepretty
title('NREM mean duration (s)')
xlabel('Time of the day (h)')

subplot(4,6,[21,22]) % NREM bouts mean duration quantif barplot
PlotErrorBarN_MC({...
    nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2),...
    nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_1,col_2,col_1,col_2});
xticks([1.5 4.5]); xticklabels({'9-13h','13-18h'}); xtickangle(0)
% ylabel('NREM mean duration (s)')
makepretty
xlabel('Time of the day (h)')

%Stat NREM duration
[h,p_sal_vs_cno_NREM_dur_1_3h] = ttest(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_NREM_dur_1_3h] = ttest2(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
% [p_sal_vs_cno_NREM_dur_1_3h,h] = signrank(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));
% [p_sal_vs_cno_NREM_dur_1_3h,h] = ranksum(nanmean(data_dur_SWS_1_3h_ctrl,2), nanmean(data_dur_SWS_1_3h_SD_mCherry_cno,2));

[h,p_sal_vs_cno_NREM_dur_3_end] = ttest(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_NREM_dur_3_end] = ttest2(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_NREM_dur_3_end,h] = signrank(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_NREM_dur_3_end,h] = ranksum(nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));

if p_sal_vs_cno_NREM_dur_1_3h<0.05; sigstar_DB({[1 2]},p_sal_vs_cno_NREM_dur_1_3h,0,'LineWigth',16,'StarSize',24); end
if p_sal_vs_cno_NREM_dur_3_end<0.05; sigstar_DB({[4 5]},p_sal_vs_cno_NREM_dur_3_end,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[17]) % FI NREM (5-8h)
PlotErrorBarN_MC({...
    nanmean(data_num_SWS_3_end_ctrl,2)./nanmean(data_dur_SWS_3_end_ctrl,2),...
    nanmean(data_num_SWS_3_end_SD_mCherry_cno,2)./nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_1,col_2});
title('NREM fragmentation index')
xticks([1.5]); xticklabels({'13-18h'}); xtickangle(0)
makepretty
xlabel('Time of the day (h)')
set(gca,'xtick',[])
xticks([1:5]); xticklabels({}); xtickangle(0)

%Stat NREM FI
% [h,p_sal_vs_cno_NREM_FI_3_end] = ttest(nanmean(data_num_SWS_3_end_ctrl,2)./nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2)./nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_NREM_FI_3_end] = ttest2(nanmean(data_num_SWS_3_end_ctrl,2)./nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2)./nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
[p_sal_vs_cno_NREM_FI_3_end,h] = signrank(nanmean(data_num_SWS_3_end_ctrl,2)./nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2)./nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_NREM_FI_3_end,h] = ranksum(nanmean(data_num_SWS_3_end_ctrl,2)./nanmean(data_dur_SWS_3_end_ctrl,2), nanmean(data_num_SWS_3_end_SD_mCherry_cno,2)./nanmean(data_dur_SWS_3_end_SD_mCherry_cno,2));

if p_sal_vs_cno_NREM_FI_3_end<0.05; sigstar_DB({[1 2]},p_sal_vs_cno_NREM_FI_3_end,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[23]) %proba stay NREM_4-8h
PlotErrorBarN_MC({...
    1-(nanmean(data_SWS_REM_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2)),...
    1-(nanmean(data_SWS_REM_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2))},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_1,col_2});
ylim([.96 1])
xlabel('Time of the day (h)')
title('NREM stay probability')
xticks([1.5]); xticklabels({'13-18h'}); xtickangle(0)
makepretty
set(gca,'xtick',[])

%Stat NREM proba stay
% [h,p_sal_vs_cno_NREM_proba_stay_3_end] = ttest(1-(nanmean(data_SWS_REM_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2)), 1-(nanmean(data_SWS_REM_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2)));
% [h,p_sal_vs_cno_NREM_proba_stay_3_end] = ttest2(1-(nanmean(data_SWS_REM_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2)),1-(nanmean(data_SWS_REM_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2)));
[p_sal_vs_cno_NREM_proba_stay_3_end,h] = signrank(1-(nanmean(data_SWS_REM_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2)), 1-(nanmean(data_SWS_REM_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2)));
% [p_sal_vs_cno_NREM_proba_stay_3_end,h] = ranksum(1-(nanmean(data_SWS_REM_3_end_ctrl,2)+nanmean(data_SWS_WAKE_3_end_ctrl,2)), 1-(nanmean(data_SWS_REM_3_end_SD_mCherry_cno,2)+nanmean(data_SWS_WAKE_3_end_SD_mCherry_cno,2)));

if p_sal_vs_cno_NREM_proba_stay_3_end<0.05; sigstar_DB({[1 2]},p_sal_vs_cno_NREM_proba_stay_3_end,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[24]) %proba initiate NREM 4-8h
PlotErrorBarN_MC({...
    nanmean(data_REM_SWS_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2),...
    nanmean(data_REM_SWS_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_1,col_2});
xticks([1.5]); xticklabels({'13-18h'}); xtickangle(0)
xlabel('Time of the day (h)')
title('NREM init. probability')
makepretty
set(gca,'xtick',[])

%Stat NREM proba initiate
% [h,p_sal_vs_cno_NREM_proba_init_3_end] = ttest(nanmean(data_REM_SWS_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2), nanmean(data_REM_SWS_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2));
% [h,p_sal_vs_cno_NREM_proba_init_3_end] = ttest2(nanmean(data_REM_SWS_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2), nanmean(data_REM_SWS_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2));
[p_sal_vs_cno_NREM_proba_init_3_end,h] = signrank(nanmean(data_REM_SWS_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2), nanmean(data_REM_SWS_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2));
% [p_sal_vs_cno_NREM_proba_init_3_end,h] = ranksum(nanmean(data_REM_SWS_3_end_ctrl,2)+nanmean(data_WAKE_SWS_3_end_ctrl,2), nanmean(data_REM_SWS_3_end_SD_mCherry_cno,2)+nanmean(data_WAKE_SWS_3_end_SD_mCherry_cno,2));

if p_sal_vs_cno_NREM_proba_init_3_end<0.05; sigstar_DB({[1 2]},p_sal_vs_cno_NREM_proba_init_3_end,0,'LineWigth',16,'StarSize',24);end
