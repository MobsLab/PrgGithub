%% input dir : DO NOT CHANGE THIS

%%DIR SOCIAL DEFEAT (ctrl/safe/stressful)
Dir1 = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');

Dir2 = PathForExperimentsSD_MC('SleepPostSD');
Dir2 = RestrictPathForExperiment(Dir2, 'nMice', [1148 1149 1150 1217 1218 1219 1220]);

Dir3 = PathForExperimentsSD_MC('SleepPostSD_safe');

%% parameters

tempbin = 3600;

time_st=0;
time_end=3*1e8;

%% GET DATA
%%control group (mice not stressed / only saline injection)
for j=1:length(Dir1.path)
    cd(Dir1.path{j}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_basal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'WakeWiNoise','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_basal{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'WakeWiNoise','tsdMovement');
    else
    end
    
    same_epoch_basal{j} = intervalSet(0,time_end);
    
    stages_basal{j}.WakeWiNoise = mergeCloseIntervals(stages_basal{j}.WakeWiNoise,0.5*1e4);

    %%compute mean duration, number of bouts and percentage
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_basal{j}.WakeWiNoise,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'wake',tempbin,time_end);
    dur_WAKE_basal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_basal{j}=num_moyen_ep_WAKE;
    perc_WAKE_basal{j}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_basal{j}.WakeWiNoise,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'sws',tempbin,time_end);
    dur_SWS_basal{j}=dur_moyenne_ep_SWS;
    num_SWS_basal{j}=num_moyen_ep_SWS;
    perc_SWS_basal{j}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_basal{j}.WakeWiNoise,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'rem',tempbin,time_end);
    dur_REM_basal{j}=dur_moyenne_ep_REM;
    num_REM_basal{j}=num_moyen_ep_REM;
    perc_REM_basal{j}=perc_moyen_REM;
    
    [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_MC(and(stages_basal{j}.WakeWiNoise,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),'wake',tempbin,time_st,time_end);
    dur_TOT_REM_basal{j}=dur_TOT_moyenne_ep;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_basal{j}.WakeWiNoise,same_epoch_basal{j}),and(stages_basal{j}.SWSEpoch,same_epoch_basal{j}),and(stages_basal{j}.REMEpoch,same_epoch_basal{j}),tempbin,time_end);
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
    data_REM_REM_basal(imouse,:) = all_trans_REM_REM_basal{imouse}; %data_REM_REM_basal(isnan(data_REM_REM_basal)==1)=0;
    data_REM_SWS_basal(imouse,:) = all_trans_REM_SWS_basal{imouse}; data_REM_SWS_basal(isnan(data_REM_SWS_basal)==1)=0;
    data_REM_WAKE_basal(imouse,:) = all_trans_REM_WAKE_basal{imouse}; data_REM_WAKE_basal(isnan(data_REM_WAKE_basal)==1)=0;
    
    data_SWS_SWS_basal(imouse,:) = all_trans_SWS_SWS_basal{imouse}; data_SWS_SWS_basal(isnan(data_SWS_SWS_basal)==1)=0;
    data_SWS_REM_basal(imouse,:) = all_trans_SWS_REM_basal{imouse}; data_SWS_REM_basal(isnan(data_SWS_REM_basal)==1)=0;
    data_SWS_WAKE_basal(imouse,:) = all_trans_SWS_WAKE_basal{imouse}; data_SWS_WAKE_basal(isnan(data_SWS_WAKE_basal)==1)=0;
    
    data_WAKE_WAKE_basal(imouse,:) = all_trans_WAKE_WAKE_basal{imouse}; data_WAKE_WAKE_basal(isnan(data_WAKE_WAKE_basal)==1)=0;
    data_WAKE_REM_basal(imouse,:) = all_trans_WAKE_REM_basal{imouse}; data_WAKE_REM_basal(isnan(data_WAKE_REM_basal)==1)=0;
    data_WAKE_SWS_basal(imouse,:) = all_trans_WAKE_SWS_basal{imouse}; data_WAKE_SWS_basal(isnan(data_WAKE_SWS_basal)==1)=0;
    
end

%%
%%social defeat in dangerous environment
for k=1:length(Dir2.path)
    cd(Dir2.path{k}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'WakeWiNoise','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'WakeWiNoise','tsdMovement');
    else
    end
    
    same_epoch_SD{k} =  intervalSet(0, time_end);
    
    stages_SD{k}.WakeWiNoise = mergeCloseIntervals(stages_SD{k}.WakeWiNoise,0.5*1e4);
    
    %%compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE,perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.WakeWiNoise,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'wake',tempbin,time_end);
    dur_WAKE_SD{k}=dur_moyenne_ep_WAKE;
    num_WAKE_SD{k}=num_moyen_ep_WAKE;
    perc_WAKE_SD{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.WakeWiNoise,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'sws',tempbin,time_end);
    dur_SWS_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_SD{k}=num_moyen_ep_SWS;
    perc_SWS_SD{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.WakeWiNoise,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'rem',tempbin,time_end);
    dur_REM_SD{k}=dur_moyenne_ep_REM;
    num_REM_SD{k}=num_moyen_ep_REM;
    perc_REM_SD{k}=perc_moyen_REM;
    
    [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_MC(and(stages_SD{k}.WakeWiNoise,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),'wake',tempbin,time_st,time_end);
    dur_TOT_REM_SD{k}=dur_TOT_moyenne_ep;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_SD{k}.WakeWiNoise,same_epoch_SD{k}),and(stages_SD{k}.SWSEpoch,same_epoch_SD{k}),and(stages_SD{k}.REMEpoch,same_epoch_SD{k}),tempbin,time_end);
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

%%percentage/duration/number of bouts
for imouse=1:length(Dir2.path)
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
for imouse=1:length(Dir2.path)
    data_REM_REM_SD(imouse,:) = all_trans_REM_REM_SD{imouse}; %data_REM_REM_SD(isnan(data_REM_REM_SD)==1)=0;
    data_REM_SWS_SD(imouse,:) = all_trans_REM_SWS_SD{imouse}; data_REM_SWS_SD(isnan(data_REM_SWS_SD)==1)=0;
    data_REM_WAKE_SD(imouse,:) = all_trans_REM_WAKE_SD{imouse}; data_REM_WAKE_SD(isnan(data_REM_WAKE_SD)==1)=0;
    
    data_SWS_SWS_SD(imouse,:) = all_trans_SWS_SWS_SD{imouse}; data_SWS_SWS_SD(isnan(data_SWS_SWS_SD)==1)=0;
    data_SWS_REM_SD(imouse,:) = all_trans_SWS_REM_SD{imouse}; data_SWS_REM_SD(isnan(data_SWS_REM_SD)==1)=0;
    data_SWS_WAKE_SD(imouse,:) = all_trans_SWS_WAKE_SD{imouse}; data_SWS_WAKE_SD(isnan(data_SWS_WAKE_SD)==1)=0;
    
    data_WAKE_WAKE_SD(imouse,:) = all_trans_WAKE_WAKE_SD{imouse}; data_WAKE_WAKE_SD(isnan(data_WAKE_WAKE_SD)==1)=0;
    data_WAKE_REM_SD(imouse,:) = all_trans_WAKE_REM_SD{imouse}; data_WAKE_REM_SD(isnan(data_WAKE_REM_SD)==1)=0;
    data_WAKE_SWS_SD(imouse,:) = all_trans_WAKE_SWS_SD{imouse}; data_WAKE_SWS_SD(isnan(data_WAKE_SWS_SD)==1)=0;
end

%% 
%%social defeat in safe environnement
for k=1:length(Dir3.path)
    cd(Dir3.path{k}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SDsafe{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'WakeWiNoise','tsdMovement');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SDsafe{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'WakeWiNoise','tsdMovement');
    else
    end
    
    same_epoch_SDsafe{k} =  intervalSet(0, time_end);
    
    stages_SDsafe{k}.WakeWiNoise = mergeCloseIntervals(stages_SDsafe{k}.WakeWiNoise,0.5*1e4);

    %%compute percentage mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE,perc_moyen_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SDsafe{k}.WakeWiNoise,same_epoch_SDsafe{k}),and(stages_SDsafe{k}.SWSEpoch,same_epoch_SDsafe{k}),and(stages_SDsafe{k}.REMEpoch,same_epoch_SDsafe{k}),'wake',tempbin,time_end);
    dur_WAKE_SDsafe{k}=dur_moyenne_ep_WAKE;
    num_WAKE_SDsafe{k}=num_moyen_ep_WAKE;
    perc_WAKE_SDsafe{k}=perc_moyen_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS,perc_moyen_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SDsafe{k}.WakeWiNoise,same_epoch_SDsafe{k}),and(stages_SDsafe{k}.SWSEpoch,same_epoch_SDsafe{k}),and(stages_SDsafe{k}.REMEpoch,same_epoch_SDsafe{k}),'sws',tempbin,time_end);
    dur_SWS_SDsafe{k}=dur_moyenne_ep_SWS;
    num_SWS_SDsafe{k}=num_moyen_ep_SWS;
    perc_SWS_SDsafe{k}=perc_moyen_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM,perc_moyen_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SDsafe{k}.WakeWiNoise,same_epoch_SDsafe{k}),and(stages_SDsafe{k}.SWSEpoch,same_epoch_SDsafe{k}),and(stages_SDsafe{k}.REMEpoch,same_epoch_SDsafe{k}),'rem',tempbin,time_end);
    dur_REM_SDsafe{k}=dur_moyenne_ep_REM;
    num_REM_SDsafe{k}=num_moyen_ep_REM;
    perc_REM_SDsafe{k}=perc_moyen_REM;
    
    [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_MC(and(stages_SDsafe{k}.WakeWiNoise,same_epoch_SDsafe{k}),and(stages_SDsafe{k}.SWSEpoch,same_epoch_SDsafe{k}),and(stages_SD{k}.REMEpoch,same_epoch_SDsafe{k}),'wake',tempbin,time_st,time_end);
    dur_TOT_REM_SDsafe{k}=dur_TOT_moyenne_ep;

    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_SDsafe{k}.WakeWiNoise,same_epoch_SDsafe{k}),and(stages_SDsafe{k}.SWSEpoch,same_epoch_SDsafe{k}),and(stages_SDsafe{k}.REMEpoch,same_epoch_SDsafe{k}),tempbin,time_end);
    all_trans_REM_REM_SDsafe{k} = trans_REM_to_REM;
    all_trans_REM_SWS_SDsafe{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_SDsafe{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_SDsafe{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_SDsafe{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_SDsafe{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_SDsafe{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_SDsafe{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_SDsafe{k} = trans_WAKE_to_WAKE;
end

%%percentage/duration/number of bouts
for imouse=1:length(Dir3.path)
    data_dur_TOT_REM_SDsafe(imouse,:) = dur_TOT_REM_SDsafe{imouse}; data_dur_TOT_REM_SDsafe(isnan(data_dur_TOT_REM_SDsafe)==1)=0;
    
    data_dur_REM_SDsafe(imouse,:) = dur_REM_SDsafe{imouse}; data_dur_REM_SDsafe(isnan(data_dur_REM_SDsafe)==1)=0;
    data_dur_SWS_SDsafe(imouse,:) = dur_SWS_SDsafe{imouse}; data_dur_SWS_SDsafe(isnan(data_dur_SWS_SDsafe)==1)=0;
    data_dur_WAKE_SDsafe(imouse,:) = dur_WAKE_SDsafe{imouse}; data_dur_WAKE_SDsafe(isnan(data_dur_WAKE_SDsafe)==1)=0;
    
    data_num_REM_SDsafe(imouse,:) = num_REM_SDsafe{imouse}; data_num_REM_SDsafe(isnan(data_num_REM_SDsafe)==1)=0;
    data_num_SWS_SDsafe(imouse,:) = num_SWS_SD{imouse}; data_num_SWS_SDsafe(isnan(data_num_SWS_SDsafe)==1)=0;
    data_num_WAKE_SDsafe(imouse,:) = num_WAKE_SD{imouse}; data_num_WAKE_SDsafe(isnan(data_num_WAKE_SDsafe)==1)=0;
    
    data_perc_REM_SDsafe(imouse,:) = perc_REM_SDsafe{imouse}; data_perc_REM_SDsafe(isnan(data_perc_REM_SDsafe)==1)=0;
    data_perc_SWS_SDsafe(imouse,:) = perc_SWS_SDsafe{imouse}; data_perc_SWS_SDsafe(isnan(data_perc_SWS_SDsafe)==1)=0;
    data_perc_WAKE_SDsafe(imouse,:) = perc_WAKE_SDsafe{imouse}; data_perc_WAKE_SDsafe(isnan(data_perc_WAKE_SDsafe)==1)=0;
end

%%transition probabilities
for imouse=1:length(Dir3.path)
    data_REM_REM_SDsafe(imouse,:) = all_trans_REM_REM_SDsafe{imouse}; %data_REM_REM_SDsafe(isnan(data_REM_REM_SDsafe)==1)=0;
    data_REM_SWS_SDsafe(imouse,:) = all_trans_REM_SWS_SDsafe{imouse}; data_REM_SWS_SDsafe(isnan(data_REM_SWS_SDsafe)==1)=0;
    data_REM_WAKE_SDsafe(imouse,:) = all_trans_REM_WAKE_SDsafe{imouse}; data_REM_WAKE_SDsafe(isnan(data_REM_WAKE_SDsafe)==1)=0;
    
    data_SWS_SWS_SDsafe(imouse,:) = all_trans_SWS_SWS_SDsafe{imouse}; data_SWS_SWS_SDsafe(isnan(data_SWS_SWS_SDsafe)==1)=0;
    data_SWS_REM_SDsafe(imouse,:) = all_trans_SWS_REM_SDsafe{imouse}; data_SWS_REM_SDsafe(isnan(data_SWS_REM_SDsafe)==1)=0;
    data_SWS_WAKE_SDsafe(imouse,:) = all_trans_SWS_WAKE_SDsafe{imouse}; data_SWS_WAKE_SDsafe(isnan(data_SWS_WAKE_SDsafe)==1)=0;
    
    data_WAKE_WAKE_SDsafe(imouse,:) = all_trans_WAKE_WAKE_SDsafe{imouse}; data_WAKE_WAKE_SDsafe(isnan(data_WAKE_WAKE_SDsafe)==1)=0;
    data_WAKE_REM_SDsafe(imouse,:) = all_trans_WAKE_REM_SDsafe{imouse}; data_WAKE_REM_SDsafe(isnan(data_WAKE_REM_SDsafe)==1)=0;
    data_WAKE_SWS_SDsafe(imouse,:) = all_trans_WAKE_SWS_SDsafe{imouse}; data_WAKE_SWS_SDsafe(isnan(data_WAKE_SWS_SDsafe)==1)=0;
end



%% FIGURE
col_basal = [.6 .6 .6];
col_SD = [.91 .53 .17];
col_SDsafe = [.31 .38 .61];
%%
figure
suptitle('Eveil')

subplot(4,6,[1,2]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_basal),'linestyle','-','marker','o','markerfacecolor',col_basal,'color',col_basal), hold on
errorbar(nanmean(data_perc_WAKE_basal), stdError(data_perc_WAKE_basal),'color',col_basal)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'color',col_SD)
plot(nanmean(data_perc_WAKE_SDsafe),'linestyle','-','marker','o','markerfacecolor',col_SDsafe,'color',col_SDsafe)
errorbar(nanmean(data_perc_WAKE_SDsafe), stdError(data_perc_WAKE_SDsafe),'color',col_SDsafe)
xlim([0 8])
makepretty
title('Eveil')

subplot(4,6,[3,4]) %NREM percentage overtime
plot(nanmean(data_perc_SWS_basal),'linestyle','-','marker','o','markerfacecolor',col_basal,'color',col_basal), hold on
errorbar(nanmean(data_perc_SWS_basal), stdError(data_perc_SWS_basal),'color',col_basal)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'color',col_SD)
plot(nanmean(data_perc_SWS_SDsafe),'linestyle','-','marker','o','markerfacecolor',col_SDsafe,'color',col_SDsafe)
errorbar(nanmean(data_perc_SWS_SDsafe), stdError(data_perc_SWS_SDsafe),'color',col_SDsafe)
xlim([0 8])
makepretty
title('Sommeil lent')

subplot(4,6,[5,6]) %REM percentage overtime
plot(nanmean(data_perc_REM_basal),'linestyle','-','marker','o','markerfacecolor',col_basal,'color',col_basal), hold on
errorbar(nanmean(data_perc_REM_basal), stdError(data_perc_REM_basal),'color',col_basal)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'color',col_SD)
plot(nanmean(data_perc_REM_SDsafe),'linestyle','-','marker','o','markerfacecolor',col_SDsafe,'color',col_SDsafe)
errorbar(nanmean(data_perc_REM_SDsafe), stdError(data_perc_REM_SDsafe),'color',col_SDsafe)
xlim([0 8])
makepretty
title('Sommeil paradoxal')


subplot(4,6,[7,8]) % wake percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_WAKE_basal(:,1:3),2), nanmean(data_perc_WAKE_SDsafe(:,1:3),2), nanmean(data_perc_WAKE_SD(:,1:3),2),...
    nanmean(data_perc_WAKE_basal(:,4:8),2), nanmean(data_perc_WAKE_SDsafe(:,4:8),2), nanmean(data_perc_WAKE_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Quantité d éveil (%)')
makepretty
xlabel('Temps après le stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2),nanmean(data_perc_WAKE_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_WAKE_SD(:,timebin),2), nanmean(data_perc_WAKE_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2), nanmean(data_perc_WAKE_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2),nanmean(data_perc_WAKE_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_WAKE_SD(:,timebin),2), nanmean(data_perc_WAKE_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2), nanmean(data_perc_WAKE_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_SWS_basal(:,1:3),2), nanmean(data_perc_SWS_SDsafe(:,1:3),2), nanmean(data_perc_SWS_SD(:,1:3),2),...
    nanmean(data_perc_SWS_basal(:,4:8),2), nanmean(data_perc_SWS_SDsafe(:,4:8),2), nanmean(data_perc_SWS_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Quantité de sommeil lent (%)')
makepretty
xlabel('Temps après le stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_perc_SWS_basal(:,timebin),2),nanmean(data_perc_SWS_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_SWS_SD(:,timebin),2), nanmean(data_perc_SWS_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_SWS_basal(:,timebin),2), nanmean(data_perc_SWS_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_perc_SWS_basal(:,timebin),2),nanmean(data_perc_SWS_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_SWS_SD(:,timebin),2), nanmean(data_perc_SWS_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_SWS_basal(:,timebin),2), nanmean(data_perc_SWS_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_REM_basal(:,1:3),2), nanmean(data_perc_REM_SDsafe(:,1:3),2), nanmean(data_perc_REM_SD(:,1:3),2),...
    nanmean(data_perc_REM_basal(:,4:8),2), nanmean(data_perc_REM_SDsafe(:,4:8),2), nanmean(data_perc_REM_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Quantité de sommeil paradoxal (%)')
makepretty
xlabel('Temps après le stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_REM_SD(:,timebin),2), nanmean(data_perc_REM_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2), nanmean(data_perc_REM_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_REM_SD(:,timebin),2), nanmean(data_perc_REM_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2), nanmean(data_perc_REM_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[13,14]) % wake bouts number ovetime
plot(nanmean(data_num_WAKE_basal),'linestyle','-','marker','o','markerfacecolor',col_basal,'color',col_basal), hold on
errorbar(nanmean(data_num_WAKE_basal), stdError(data_num_WAKE_basal),'color',col_basal)
plot(nanmean(data_num_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_num_WAKE_SD), stdError(data_num_WAKE_SD),'color',col_SD)
plot(nanmean(data_num_WAKE_SDsafe),'linestyle','-','marker','o','markerfacecolor',col_SDsafe,'color',col_SDsafe)
errorbar(nanmean(data_num_WAKE_SDsafe), stdError(data_num_WAKE_SDsafe),'color',col_SDsafe)
xlim([0 8])
makepretty
title('Eveil')

subplot(4,6,[15,16]) % wake bouts mean duraion overtime
plot(nanmean(data_dur_WAKE_basal),'linestyle','-','marker','o','markerfacecolor',col_basal,'color',col_basal), hold on
errorbar(nanmean(data_dur_WAKE_basal), stdError(data_dur_WAKE_basal),'color',col_basal)
plot(nanmean(data_dur_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_dur_WAKE_SD), stdError(data_dur_WAKE_SD),'color',col_SD)
plot(nanmean(data_dur_WAKE_SDsafe),'linestyle','-','marker','o','markerfacecolor',col_SDsafe,'color',col_SDsafe)
errorbar(nanmean(data_dur_WAKE_SDsafe), stdError(data_dur_WAKE_SDsafe),'color',col_SDsafe)
xlim([0 8])
makepretty
title('Eveil')


subplot(4,6,[19,20]) % wake bouts number quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_num_WAKE_basal(:,1:3),2), nanmean(data_num_WAKE_SDsafe(:,1:3),2), nanmean(data_num_WAKE_SD(:,1:3),2),...
    nanmean(data_num_WAKE_basal(:,4:8),2), nanmean(data_num_WAKE_SDsafe(:,4:8),2), nanmean(data_num_WAKE_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Nombre d épisodes')
makepretty
xlabel('Temps après le stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_num_WAKE_basal(:,timebin),2),nanmean(data_num_WAKE_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_num_WAKE_SD(:,timebin),2), nanmean(data_num_WAKE_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_num_WAKE_basal(:,timebin),2), nanmean(data_num_WAKE_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_num_WAKE_basal(:,timebin),2),nanmean(data_num_WAKE_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_num_WAKE_SD(:,timebin),2), nanmean(data_num_WAKE_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_num_WAKE_basal(:,timebin),2), nanmean(data_num_WAKE_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[21,22]) % NREM bouts mean duration quantif barplot

PlotErrorBarN_KJ({...
    nanmean(data_dur_WAKE_basal(:,1:3),2), nanmean(data_dur_WAKE_SDsafe(:,1:3),2), nanmean(data_dur_WAKE_SD(:,1:3),2),...
    nanmean(data_dur_WAKE_basal(:,4:8),2), nanmean(data_dur_WAKE_SDsafe(:,4:8),2), nanmean(data_dur_WAKE_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Durée moyenne d un épisode (s)')
makepretty
xlabel('Temps après le stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_dur_WAKE_basal(:,timebin),2),nanmean(data_dur_WAKE_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_dur_WAKE_SD(:,timebin),2), nanmean(data_dur_WAKE_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_dur_WAKE_basal(:,timebin),2), nanmean(data_dur_WAKE_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_dur_WAKE_basal(:,timebin),2),nanmean(data_dur_WAKE_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_dur_WAKE_SD(:,timebin),2), nanmean(data_dur_WAKE_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_dur_WAKE_basal(:,timebin),2), nanmean(data_dur_WAKE_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[17,23]) % new FI = 1 - proba stay nrem (4-8h)
PlotErrorBarN_KJ({...
    (1-nanmean(data_WAKE_WAKE_basal(:,4:8),2))*100,...
    (1-nanmean(data_WAKE_WAKE_SDsafe(:,4:8),2))*100,...
    (1-nanmean(data_WAKE_WAKE_SD(:,4:8),2))*100},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3],'barcolors',{col_basal,col_SDsafe,col_SD});
xticks([1:3]); xticklabels({'','4-8',''}); xtickangle(0)
xlabel('Temps après le stress (h)')

timebin=4:8;
[p_basal_SD,h]=ranksum(1-nanmean(data_WAKE_WAKE_basal(:,timebin),2),1-nanmean(data_WAKE_WAKE_SD(:,timebin),2));
[p_SD_ctrlInhib,h]=ranksum(1-nanmean(data_WAKE_WAKE_SD(:,timebin),2), 1-nanmean(data_WAKE_WAKE_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h]=ranksum(1-nanmean(data_WAKE_WAKE_basal(:,timebin),2),1-nanmean(data_WAKE_WAKE_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

ylabel('Indice de fragmentation')
makepretty
