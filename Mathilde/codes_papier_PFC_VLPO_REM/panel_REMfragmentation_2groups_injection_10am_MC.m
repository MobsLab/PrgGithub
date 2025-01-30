%% input dir

% %%DIR MCHERRY SAL/CNO (basal sleep)
% Dir_sal=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
% Dir_cno = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_CNOInjection_10am');


% %%DIR NO DREADDS SAL/CNO (basal sleep)
% Dir_sal=PathForExperiments_DREADD_MC('noDREADD_SalineInjection_10am');
% Dir_cno = PathForExperiments_DREADD_MC('noDREADD_CNOInjection_10am');


%%DIR SOCIAL DEFEAT
% % DirControl1 = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
% % DirControl2 = PathForExperiments_DREADD_MC('noDREADD_SalineInjection_10am');
% % Dir_sal = MergePathForExperiment(DirControl1, DirControl2);
% Dir_sal = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
% 
% Dir_cno = PathForExperimentsSD_MC('SleepPostSD');
% Dir_cno = RestrictPathForExperiment(Dir_cno, 'nMice', [1148 1149 1150 1217 1218 1219 1220]);




% % %%%%%%%%%%%%%%%
% %%DIR SOCIAL DEFEAT
% Dir_sal = PathForExperimentsSD_MC('SleepPostSD');
% Dir_sal = RestrictPathForExperiment(Dir_sal, 'nMice', [1148 1149 1150 1217 1218 1219 1220]);
% 
% % Dir_cno = PathForExperimentsSD_MC('SleepPostSD_safe');
% Dir_cno = PathForExperimentsSD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');


%%



%%


% Dir_sal = PathForExperimentsSD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');

% Dir_cno_1 = PathForExperimentsSD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');
% Dir_cno_2 = PathForExperimentsSD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
% Dir_cno = MergePathForExperiment(Dir_cno_1, Dir_cno_2);

%%
% Dir_sal=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
% Dir_sal = PathForExperimentsSD_MC('SleepPostSD');
% 
% Dir_cno = PathForExperimentsSD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');


% Dir_sal = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_9am_SleepPostEPM');
% Dir_cno = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_9am_SleepPostEPM');


% Dir_sal=PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_SalineInjection_10am');
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_CNOInjection_10am');
% % Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_BaselineSleep');


%%
% Dir_sal=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_SalineInjection_10am');

% Dir_sal = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_SalineInjection_10am');
% Dir_cno = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_CNOInjection_10am');


Dir_sal = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_9am_SleepPostEPM');
Dir_cno = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_9am_SleepPostEPM');

%% parameters

tempbin = 3600;

time_st=0;
time_end=3.05*1e8;

%% GET DATA
%%saline group
for j=1:length(Dir_sal.path)
    cd(Dir_sal.path{j}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_basal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_basal{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','tsdMovement');
    else
    end
    
    %     vec_tps_recording_basal{j} = Range(stages_basal{j}.tsdMovement); %get vector to keep track of the reocrding time
    %     VecTimeDay_basal{j} = GetTimeOfTheDay_MC(vec_tps_recording_basal{j});
    %
    %     idx_injection_time_basal{j} = find(VecTimeDay_basal{j}>t_inj,1,'first'); %get index for the injection time
    %     idx_same_st_basal{j} = find(VecTimeDay_basal{j}>t_start,1,'first'); % get index to get same beg and end of the time period to analyze
    %     idx_same_en_basal{j} = find(ceil(VecTimeDay_basal{j})==t_end,1,'last');
    %
    %     injection_time_basal{j} = vec_tps_recording_basal{j}(idx_injection_time_basal{j}); %get the corresponding values
    %     same_st_basal{j} = vec_tps_recording_basal{j}(idx_same_st_basal{j});
    %     same_en_basal{j} = vec_tps_recording_basal{j}(idx_same_en_basal{j});
    %
    %     same_epoch_basal{j} =  intervalSet(same_st_basal{j}, same_en_basal{j});
    
    same_epoch_basal{j} = intervalSet(0,time_end);
    
    %%compute percentage mean duration and number of bouts        
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'wake',tempbin,time_st,time_end);
    dur_WAKE_basal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_basal{j}=num_moyen_ep_WAKE;
    perc_WAKE_basal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'sws',tempbin,time_st,time_end);
    dur_SWS_basal{j}=dur_moyenne_ep_SWS;
    num_SWS_basal{j}=num_moyen_ep_SWS;
    perc_SWS_basal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'rem',tempbin,time_st,time_end);
    dur_REM_basal{j}=dur_moyenne_ep_REM;
    num_REM_basal{j}=num_moyen_ep_REM;
    perc_REM_basal{j}=perc_moyen_REM;
    
    [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_MC(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'rem',tempbin,0,time_end);
    dur_TOT_REM_basal{j}=dur_TOT_moyenne_ep;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_basal{j}.Wake,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),tempbin,time_end);
    all_trans_REM_REM_basal{j} = trans_REM_to_REM;
    all_trans_REM_SWS_basal{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_basal{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_basal{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_basal{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_basal{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_basal{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_basal{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_basal{j} = trans_WAKE_to_WAKE;
end
%%
%%percentage/duration/number
for imouse=1:length(dur_REM_basal)
    data_dur_TOT_REM_basal(imouse,:) = dur_TOT_REM_basal{imouse}; data_dur_TOT_REM_basal(isnan(data_dur_TOT_REM_basal)==1)=0;
    
    data_dur_REM_basal(imouse,:) = dur_REM_basal{imouse}; data_dur_REM_basal(isnan(data_dur_REM_basal)==1)=0;
    data_dur_SWS_basal(imouse,:) = dur_SWS_basal{imouse}; data_dur_SWS_basal(isnan(data_dur_SWS_basal)==1)=0;
    data_dur_WAKE_basal(imouse,:) = dur_WAKE_basal{imouse}; data_dur_WAKE_basal(isnan(data_dur_WAKE_basal)==1)=0;
    
    data_num_REM_basal(imouse,:) = num_REM_basal{imouse};data_num_REM_basal(isnan(data_num_REM_basal)==1)=0;
    data_num_SWS_basal(imouse,:) = num_SWS_basal{imouse}; data_num_SWS_basal(isnan(data_num_SWS_basal)==1)=0;
    data_num_WAKE_basal(imouse,:) = num_WAKE_basal{imouse}; data_num_WAKE_basal(isnan(data_num_WAKE_basal)==1)=0;
    
    data_perc_REM_basal(imouse,:) = perc_REM_basal{imouse}; data_perc_REM_basal(isnan(data_perc_REM_basal)==1)=0;
    data_perc_SWS_basal(imouse,:) = perc_SWS_basal{imouse}; data_perc_SWS_basal(isnan(data_perc_SWS_basal)==1)=0;
    data_perc_WAKE_basal(imouse,:) = perc_WAKE_basal{imouse}; data_perc_WAKE_basal(isnan(data_perc_WAKE_basal)==1)=0;
end

%%probability
for imouse=1:length(all_trans_REM_REM_basal)
    data_REM_REM_basal(imouse,:) = all_trans_REM_REM_basal{imouse}; data_REM_REM_basal(isnan(data_REM_REM_basal)==1)=0;
    data_REM_SWS_basal(imouse,:) = all_trans_REM_SWS_basal{imouse}; data_REM_SWS_basal(isnan(data_REM_SWS_basal)==1)=0;
    data_REM_WAKE_basal(imouse,:) = all_trans_REM_WAKE_basal{imouse}; data_REM_WAKE_basal(isnan(data_REM_WAKE_basal)==1)=0;
    
    data_SWS_SWS_basal(imouse,:) = all_trans_SWS_SWS_basal{imouse}; data_SWS_SWS_basal(isnan(data_SWS_SWS_basal)==1)=0;
    data_SWS_REM_basal(imouse,:) = all_trans_SWS_REM_basal{imouse}; data_SWS_REM_basal(isnan(data_SWS_REM_basal)==1)=0;
    data_SWS_WAKE_basal(imouse,:) = all_trans_SWS_WAKE_basal{imouse}; data_SWS_WAKE_basal(isnan(data_SWS_WAKE_basal)==1)=0;
    
    data_WAKE_WAKE_basal(imouse,:) = all_trans_WAKE_WAKE_basal{imouse}; data_WAKE_WAKE_basal(isnan(data_WAKE_WAKE_basal)==1)=0;
    data_WAKE_REM_basal(imouse,:) = all_trans_WAKE_REM_basal{imouse}; data_WAKE_REM_basal(isnan(data_WAKE_REM_basal)==1)=0;
    data_WAKE_SWS_basal(imouse,:) = all_trans_WAKE_SWS_basal{imouse}; data_WAKE_SWS_basal(isnan(data_WAKE_SWS_basal)==1)=0;
    
end

%% Chemogenetic activation CRH neurons in VLPO
for k=1:length(Dir_cno.path)
    cd(Dir_cno.path{k}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD{k} = load('SleepScoring_Accelero', 'REMEpoch','SWSEpoch','Wake','REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD{k} = load('SleepScoring_OBGamma', 'REMEpoch','SWSEpoch','Wake','REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise','tsdMovement');
    else
    end
%     stages_SD{k}.Wake=stages_SD{k}.WakeWiNoise;
%     stages_SD{k}.SWSEpoch=stages_SD{k}.SWSEpochWiNoise;
%     stages_SD{k}.REMEpoch=stages_SD{k}.REMEpochWiNoise;
    
    
    %     vec_tps_recording_SD{k} = Range(stages_SD{k}.tsdMovement); %get vector to keep track of the reocrding time
    %     VecTimeDay_SD{k} = GetTimeOfTheDay_MC(vec_tps_recording_SD{k});
    %
    %     idx_injection_time_SD{k} = find(VecTimeDay_SD{k}>t_inj,1,'first'); %get index for the injection time
    %     idx_same_st_SD{k} = find(VecTimeDay_SD{k}>t_start,1,'first'); % get index to get same beg and end of the time period to analyze
    %     idx_same_en_SD{k} = find(ceil(VecTimeDay_SD{k})==t_end,1,'last');
    %
    %     injection_time_SD{k} = vec_tps_recording_SD{k}(idx_injection_time_SD{k}); %get the corresponding values
    %     same_st_SD{k} = vec_tps_recording_SD{k}(idx_same_st_SD{k});
    %     same_en_SD{k} = vec_tps_recording_SD{k}(idx_same_en_SD{k});
    %
    %     same_epoch_SD{k} =  intervalSet(same_st_SD{k}, same_en_SD{k});
    
    
    same_epoch_SD{k} =  intervalSet(0, time_end);
    
    
    %%compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE,perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'wake',tempbin,time_st,time_end);
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
    
    [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_MC(and(stages_SD{k}.Wake,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'rem',tempbin,0,time_end);
    dur_TOT_REM_SD{k}=dur_TOT_moyenne_ep;
    
    %%compute transition probabilities
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
end

%%


%%percentage/duration/number of bouts
for imouse=1:length(Dir_cno.path)
    data_dur_TOT_REM_SD(imouse,:) = dur_TOT_REM_SD{imouse}; data_dur_TOT_REM_SD(isnan(data_dur_TOT_REM_SD)==1)=0;
    
    data_dur_REM_SD(imouse,:) = dur_REM_SD{imouse}; data_dur_REM_SD(isnan(data_dur_REM_SD)==1)=0;
    data_dur_SWS_SD(imouse,:) = dur_SWS_SD{imouse}; data_dur_SWS_SD(isnan(data_dur_SWS_SD)==1)=0;
    data_dur_WAKE_SD(imouse,:) = dur_WAKE_SD{imouse}; data_dur_WAKE_SD(isnan(data_dur_WAKE_SD)==1)=0;
    
    data_num_REM_SD(imouse,:) = num_REM_SD{imouse}; data_num_REM_SD(isnan(data_num_REM_SD)==1)=0;
    data_num_SWS_SD(imouse,:) = num_SWS_SD{imouse}; data_num_SWS_SD(isnan(data_num_SWS_SD)==1)=0;
    data_num_WAKE_SD(imouse,:) = num_WAKE_SD{imouse}; data_num_WAKE_SD(isnan(data_num_WAKE_SD)==1)=0;
    
    data_perc_REM_SD(imouse,:) = perc_REM_SD{imouse}; data_perc_REM_SD(isnan(data_perc_REM_SD)==1)=0;
    data_perc_SWS_SD(imouse,:) = perc_SWS_SD{imouse}; data_perc_SWS_SD(isnan(data_perc_SWS_SD)==1)=0;
    data_perc_WAKE_SD(imouse,:) = perc_WAKE_SD{imouse}; data_perc_WAKE_SD(isnan(data_perc_WAKE_SD)==1)=0;
end

%%transition probabilities
for imouse=1:length(Dir_cno.path)
    data_REM_REM_SD(imouse,:) = all_trans_REM_REM_SD{imouse}; data_REM_REM_SD(isnan(data_REM_REM_SD)==1)=0;
    data_REM_SWS_SD(imouse,:) = all_trans_REM_SWS_SD{imouse}; data_REM_SWS_SD(isnan(data_REM_SWS_SD)==1)=0;
    data_REM_WAKE_SD(imouse,:) = all_trans_REM_WAKE_SD{imouse}; data_REM_WAKE_SD(isnan(data_REM_WAKE_SD)==1)=0;
    
    data_SWS_SWS_SD(imouse,:) = all_trans_SWS_SWS_SD{imouse}; data_SWS_SWS_SD(isnan(data_SWS_SWS_SD)==1)=0;
    data_SWS_REM_SD(imouse,:) = all_trans_SWS_REM_SD{imouse}; data_SWS_REM_SD(isnan(data_SWS_REM_SD)==1)=0;
    data_SWS_WAKE_SD(imouse,:) = all_trans_SWS_WAKE_SD{imouse}; data_SWS_WAKE_SD(isnan(data_SWS_WAKE_SD)==1)=0;
    
    data_WAKE_WAKE_SD(imouse,:) = all_trans_WAKE_WAKE_SD{imouse}; data_WAKE_WAKE_SD(isnan(data_WAKE_WAKE_SD)==1)=0;
    data_WAKE_REM_SD(imouse,:) = all_trans_WAKE_REM_SD{imouse}; data_WAKE_REM_SD(isnan(data_WAKE_REM_SD)==1)=0;
    data_WAKE_SWS_SD(imouse,:) = all_trans_WAKE_SWS_SD{imouse}; data_WAKE_SWS_SD(isnan(data_WAKE_SWS_SD)==1)=0;
end


%% FIGURE (comparaison 2 groupes)
col_sal = [.8 .8 .8];
col_cno = [1 .4 .2];
% col_cno = [1 0 0];


figure
subplot(4,6,[1,2]), hold on % wake percentage overtime
plot(nanmean(data_perc_WAKE_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_perc_WAKE_basal), stdError(data_perc_WAKE_basal),'color',col_sal)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'color',col_cno)
xlim([0 9])
makepretty
ylabel('Wake percentage')
title('Wake')

subplot(4,6,[3,4]), hold on %NREM percentage overtime
plot(nanmean(data_perc_SWS_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_perc_SWS_basal), stdError(data_perc_SWS_basal),'color',col_sal)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'color',col_cno)
xlim([0 9])
makepretty
ylabel('NREM percentage')
title('NREM sleep')

subplot(4,6,[5,6]), hold on %REM percentage overtime
plot(nanmean(data_perc_REM_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_perc_REM_basal), stdError(data_perc_REM_basal),'color',col_sal)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'color',col_cno)
xlim([0 9])
makepretty
ylabel('REM percentage')
title('REM sleep')


subplot(4,6,[7,8]) % wake percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_WAKE_basal(:,1:3),2), nanmean(data_perc_WAKE_SD(:,1:3),2),...
    nanmean(data_perc_WAKE_basal(:,4:8),2), nanmean(data_perc_WAKE_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('WAKE percentage')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2),nanmean(data_perc_WAKE_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2),nanmean(data_perc_WAKE_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_SWS_basal(:,1:3),2), nanmean(data_perc_SWS_SD(:,1:3),2),...
    nanmean(data_perc_SWS_basal(:,4:8),2), nanmean(data_perc_SWS_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-8'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_REM_basal(:,1:3),2), nanmean(data_perc_REM_SD(:,1:3),2),...
    nanmean(data_perc_REM_basal(:,4:8),2), nanmean(data_perc_REM_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-8'}); xtickangle(0)
ylabel('REM percentage')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[13,14]), hold on % REM bouts number ovetime
plot(nanmean(data_num_REM_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_num_REM_basal), stdError(data_num_REM_basal),'color',col_sal)
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'color',col_cno)
xlim([0 9])
makepretty
ylabel('REM bouts number')


subplot(4,6,[15,16]), hold on % REM bouts mean duraion overtime
plot(nanmean(data_dur_REM_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_dur_REM_basal), stdError(data_dur_REM_basal),'color',col_sal)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'color',col_cno)
xlim([0 9])
makepretty
ylabel('REM bouts mean duration (s)')


subplot(4,6,[17]) % FI REM (5-8h)
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_basal(:,4:8),2)./nanmean(data_dur_REM_basal(:,4:8),2),...
    nanmean(data_num_REM_SD(:,4:8),2)./nanmean(data_dur_REM_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
makepretty
xticks([1:2]);xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM fragmentation index')

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_num_REM_basal(:,4:8),2)./nanmean(data_dur_REM_basal(:,4:8),2), nanmean(data_num_REM_SD(:,4:8),2)./nanmean(data_dur_REM_SD(:,4:8),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

subplot(4,6,[19,20]) % REM bouts number quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_basal(:,1:3),2), nanmean(data_num_REM_SD(:,1:3),2),...
    nanmean(data_num_REM_basal(:,4:8),2), nanmean(data_num_REM_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM bouts number')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_num_REM_basal(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_num_REM_basal(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[21,22]) % REM bouts mean duraion quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_dur_REM_basal(:,1:3),2), nanmean(data_dur_REM_SD(:,1:3),2),...
    nanmean(data_dur_REM_basal(:,4:8),2), nanmean(data_dur_REM_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'1-4','5-9'}); xtickangle(0)
ylabel('REM bouts mean duration (s)')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_dur_REM_basal(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_dur_REM_basal(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[23]) %proba stay rem (4:8h)
PlotErrorBarN_KJ({...
    1-(nanmean(data_REM_SWS_basal(:,4:8),2)+nanmean(data_REM_WAKE_basal(:,4:8),2)),...
    1-(nanmean(data_REM_SWS_SD(:,4:8),2)+nanmean(data_REM_WAKE_SD(:,4:8),2))},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1:2]); xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM stay probability')
makepretty

timebin=4:8;
[p_basal_SD,h]=ranksum(1-(nanmean(data_REM_SWS_basal(:,timebin),2)+nanmean(data_REM_WAKE_basal(:,timebin),2)), 1-(nanmean(data_REM_SWS_SD(:,timebin),2)+nanmean(data_REM_WAKE_SD(:,timebin),2)));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
ylabel('REM stay probability')
makepretty
ylim([.9 1])


subplot(4,6,[24]) %proba initiate rem (5-9h)
PlotErrorBarN_KJ({...
    nanmean(data_SWS_REM_basal(:,4:8),2)+nanmean(data_WAKE_REM_basal(:,4:8),2),...
    nanmean(data_SWS_REM_SD(:,4:8),2)+nanmean(data_WAKE_REM_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{col_sal,col_cno});
xticks([1:2]); xticklabels({'Control','SDS+sal','SDS+cno'}); xtickangle(0)
ylabel('REM initiation probability')
makepretty

timebin=4:8;
[p_basal_SD,h]=ranksum(nanmean(data_SWS_REM_basal(:,timebin),2)+nanmean(data_WAKE_REM_basal(:,timebin),2), nanmean(data_SWS_REM_SD(:,timebin),2)+nanmean(data_WAKE_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end



