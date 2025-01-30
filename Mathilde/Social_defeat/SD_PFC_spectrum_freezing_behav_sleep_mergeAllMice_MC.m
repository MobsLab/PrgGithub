%%GOOD
%% input dir
% Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');

%%SENSORY EXPO CD1
Dir_SensoryExposCD1cage1 = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO');
Dir_SensoryExposCD1cage2 = PathForExperiments_SD_MC('SensoryExposureCD1cage');
Dir_SensoryExposCD1cage2 = RestrictPathForExperiment(Dir_SensoryExposCD1cage2, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy
Dir_SensoryExposCD1cage4 = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_CNOInjection');
Dir_SensoryExposCD1cage5 = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
Dir_SensoryExposCD1cage6 = PathForExperiments_SD_MC('SensoryExposureCD1cage_noDREADD_BM_mice_CNOInjection');
Dir_SensoryExposCD1cage7 = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_PFC_CNOInjection');
Dir_SensoryExposCD1cage7 = RestrictPathForExperiment(Dir_SensoryExposCD1cage7,'nMice',[1196 1197 1237 1238]);%1238
Dir_SensoryExposCD1cage_a = MergePathForExperiment(Dir_SensoryExposCD1cage1, Dir_SensoryExposCD1cage2);
Dir_SensoryExposCD1cage_b = MergePathForExperiment(Dir_SensoryExposCD1cage4, Dir_SensoryExposCD1cage5);
Dir_SensoryExposCD1cage_c = MergePathForExperiment(Dir_SensoryExposCD1cage6, Dir_SensoryExposCD1cage7);
Dir_SensoryExposCD1cage_A = MergePathForExperiment(Dir_SensoryExposCD1cage_a, Dir_SensoryExposCD1cage_b);
Dir_SensoryExposCD1cage = MergePathForExperiment(Dir_SensoryExposCD1cage_A, Dir_SensoryExposCD1cage_c);



%%SENSORY EXPO C57
Dir_SensoryExposC57cage1 = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO');
Dir_SensoryExposC57cage2 = PathForExperiments_SD_MC('SensoryExposureC57cage');
Dir_SensoryExposC57cage2 = RestrictPathForExperiment(Dir_SensoryExposC57cage2, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy
Dir_SensoryExposC57cage4 = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_CNOInjection');
Dir_SensoryExposC57cage5 = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
Dir_SensoryExposC57cage6 = PathForExperiments_SD_MC('SensoryExposureC57cage_noDREADD_BM_mice_CNOInjection');
Dir_SensoryExposC57cage7 = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_PFC_CNOInjection');
Dir_SensoryExposC57cage7 = RestrictPathForExperiment(Dir_SensoryExposC57cage7,'nMice',[1196 1197 1237 1238]);%1238
Dir_SensoryExposC57cage_a = MergePathForExperiment(Dir_SensoryExposC57cage1, Dir_SensoryExposC57cage2);
Dir_SensoryExposC57cage_b = MergePathForExperiment(Dir_SensoryExposC57cage4, Dir_SensoryExposC57cage5);
Dir_SensoryExposC57cage_c = MergePathForExperiment(Dir_SensoryExposC57cage6, Dir_SensoryExposC57cage7);
Dir_SensoryExposC57cage_A = MergePathForExperiment(Dir_SensoryExposC57cage_a, Dir_SensoryExposC57cage_b);
Dir_SensoryExposC57cage = MergePathForExperiment(Dir_SensoryExposC57cage_A, Dir_SensoryExposC57cage_c);



%%SLEEP POST SD
Dir_SleepPostSD1 = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_CNOInjection');
Dir_SleepPostSD2 = PathForExperiments_SD_MC('SleepPostSD');
Dir_SleepPostSD2 = RestrictPathForExperiment(Dir_SleepPostSD2, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy
Dir_SleepPostSD4 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');
Dir_SleepPostSD5 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
Dir_SleepPostSD6 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
Dir_SleepPostSD7 = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_PFC_CNOInjection');
Dir_SleepPostSD7 = RestrictPathForExperiment(Dir_SleepPostSD7,'nMice',[1196 1197 1237 1238]);%1238
Dir_SleepPostSD_a = MergePathForExperiment(Dir_SleepPostSD1, Dir_SleepPostSD2);
Dir_SleepPostSD_b = MergePathForExperiment(Dir_SleepPostSD4, Dir_SleepPostSD5);
Dir_SleepPostSD_c = MergePathForExperiment(Dir_SleepPostSD6, Dir_SleepPostSD7);
Dir_SleepPostSD_A = MergePathForExperiment(Dir_SleepPostSD_a, Dir_SleepPostSD_b);
Dir_SleepPostSD = MergePathForExperiment(Dir_SleepPostSD_A, Dir_SleepPostSD_c);

%%


%% param spectro
%spectro = 'Bulb_deep_Low_Spectrum.mat' 'PFCx_deep_Low_Spectrum' 'dHPC_deep_Low_Spectrum'
spectro = 'Bulb_deep_Low_Spectrum.mat';

%% LOAD DATA
%% PROTOCOLE DURING STRESS / DANGEROUS
%%load data from 1st sensory expo in CD1 cage (PROTOCOLE DURING STRESS / DANGEROUS)
for i=1:length(Dir_SensoryExposCD1cage.path)
    cd(Dir_SensoryExposCD1cage.path{i}{1});
    behav_C57_stressCD1cage{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    %%freezing
    [dur_fz,durT_fz]=DurationEpoch(behav_C57_stressCD1cage{i}.FreezeAccEpoch,'min');
    freezing_mean_duration_stressCD1cage(i) = nanmean(dur_fz);
    num_fz_stressCD1cage(i) = length(dur_fz);
    freezing_total_duration_stressCD1cage(i) = durT_fz;
    perc_fz_stressCD1cage(i) = (freezing_total_duration_stressCD1cage(i)./1200)*100;
    %%spectro
    if exist(spectro)==2
        load(spectro);
        sp_OBlow_CD1cage{i} = load(spectro);
        spectre_stressCD1cage = tsd(Spectro{2}*1E4,Spectro{1});
        freq_stressCD1cage = Spectro{3};
        sp_stressCD1cage{i}  = spectre_stressCD1cage;
        frq_sstressCD1cage{i}  = freq_stressCD1cage;
    else
    end
end
%%make mean (PROTOCOLE DURING STRESS / DANGEROUS)
for i=1:length(Dir_SensoryExposCD1cage.path)
    if isempty(Start(behav_C57_stressCD1cage{i}.FreezeAccEpoch))==0
        if length(sp_stressCD1cage{i})==0
        else
            sp_stressCD1cage_FZ_mean(i,:)=nanmean(10*(Data(Restrict(sp_stressCD1cage{i},behav_C57_stressCD1cage{i}.FreezeAccEpoch))),1);
            sp_stressCD1cage_FZ_median(i,:)=nanmedian(10*(Data(Restrict(sp_stressCD1cage{i},behav_C57_stressCD1cage{i}.FreezeAccEpoch))),1);
            sp_stressCD1cage_mean(i,:)=nanmean(10*(Data(sp_stressCD1cage{i})),1); %sp_stressCD1cage_mean(sp_stressCD1cage_mean==0)=NaN;
        end
    else
    end
end
for i=1:length(Dir_SensoryExposCD1cage.path)
    if isempty(Start(behav_C57_stressCD1cage{i}.FreezeAccEpoch))==0
                if length(sp_stressCD1cage{i})==0
        else
        sp_stressCD1cage_FZ_mean_norm(i,:)= sp_stressCD1cage_FZ_mean(i,:)./nanmean(sp_stressCD1cage_FZ_mean(i,:)); %sp_stressCD1cage_FZ_mean_norm(sp_stressCD1cage_FZ_mean_norm==0)=NaN;
            sp_stressCD1cage_FZ_mean_norm_bis{i}= sp_stressCD1cage_FZ_mean(i,:)./nanmean(sp_stressCD1cage_FZ_mean(i,:)); %sp_stressCD1cage_FZ_mean_norm_bis(sp_stressCD1cage_FZ_mean_norm_bis==0)=NaN;
                end
    
%             sp_stressCD1cage_FZ_mean_2_norm(i,:)= sp_stressCD1cage_FZ_mean(i,:)./max_peakValue_stressCD1cage(i); %sp_stressCD1cage_FZ_mean_2_norm(sp_stressCD1cage_FZ_mean_2_norm==0)=NaN;

    end
end

%% load data from 2nd sensory expo in C57 cage (PROTOCOLE DURING STRESS / DANGEROUS)
for j=1:length(Dir_SensoryExposC57cage.path)
    cd(Dir_SensoryExposC57cage.path{j}{1});
    behav_C57_stressC57cage{j} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    %%freezing
    [dur_fz,durT_fz]=DurationEpoch(behav_C57_stressC57cage{j}.FreezeAccEpoch,'min');
    freezing_mean_duration_stressC57cage(j) = nanmean(dur_fz);
    num_fz_stressC57cage(j) = length(dur_fz);
    freezing_total_duration_stressC57cage(j) = durT_fz;
    perc_fz_stressC57cage(j) = (freezing_total_duration_stressC57cage(j)./1200)*100;
    %%spectro
    if exist(spectro)==2
        load(spectro);
        spectre_stressC57cage = tsd(Spectro{2}*1E4,Spectro{1});
        freq_stressC57cage = Spectro{3};
        sp_stressC57cage{j}  = spectre_stressC57cage;
        frq_stressC57cage{j}  = freq_stressC57cage;
    else
    end
end
%%make mean (PROTOCOLE DURING STRESS / DANGEROUS)
for j=1:length(Dir_SensoryExposC57cage.path)
    if isempty(Start(behav_C57_stressC57cage{j}.FreezeAccEpoch))==0
        if length(sp_stressC57cage{j})==0
        else
            sp_stressC57cage_FZ_mean(j,:)=nanmean(10*(Data(Restrict(sp_stressC57cage{j},behav_C57_stressC57cage{j}.FreezeAccEpoch))),1);
            sp_stressC57cage_FZ_median(j,:)=nanmedian(10*(Data(Restrict(sp_stressC57cage{j},behav_C57_stressC57cage{j}.FreezeAccEpoch))),1);
            sp_stressC57cage_mean(j,:)=nanmean(10*(Data(sp_stressC57cage{j})),1); sp_stressC57cage_mean(sp_stressC57cage_mean==0)=NaN;
        end
    else
    end
end
for j=1:length(Dir_SensoryExposC57cage.path)
    if isempty(Start(behav_C57_stressC57cage{j}.FreezeAccEpoch))==0
        sp_stressC57cage_FZ_mean_norm(j,:)= sp_stressC57cage_FZ_mean(j,:)./nanmean(sp_stressC57cage_FZ_mean(j,:)); sp_stressC57cage_FZ_mean_norm(sp_stressC57cage_FZ_mean_norm==0)=NaN;
        sp_stressC57cage_FZ_mean_norm_bis{j}= sp_stressC57cage_FZ_mean(j,:)./nanmean(sp_stressC57cage_FZ_mean(j,:)); sp_stressC57cage_FZ_mean_norm(sp_stressC57cage_FZ_mean_norm==0)=NaN;

    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for j=1:length(Dir_SensoryExposC57cage.path)
%     if isempty(Start(behav_C57_stressC57cage{j}.FreezeAccEpoch))==0
%         
%         idx_2hz_stressC57cage_FZ_mean_norm{j} = find(floor(frq_stressC57cage{j})==2);
%         power_2hz_stressC57cage_FZ_mean_norm(j,:) = sp_stressC57cage_FZ_mean_norm_bis{j}(idx_2hz_stressC57cage_FZ_mean_norm{j}); power_2hz_stressC57cage_FZ_mean_norm(power_2hz_stressC57cage_FZ_mean_norm==0)=NaN;
%        end
% end

%% load data from sleep session (PROTOCOLE DURING STRESS / DANGEROUS) 
for k=1:length(Dir_SleepPostSD.path)
    cd(Dir_SleepPostSD.path{k}{1});

% for k=1:length(Dir_ctrl.path)
%     cd(Dir_ctrl.path{k}{1});
    if exist('SleepScoring_OBGamma.mat')
    stages_C57_sleepPost{k} = load('SleepScoring_OBGamma.mat', 'REMEpoch', 'SWSEpoch', 'Wake','Info','ThetaEpoch');
    info_mov_thrsh{k}=load('SleepScoring_Accelero.mat', 'Info');
    durTotalSleep{k} = max([max(End(stages_C57_sleepPost{k}.Wake)),max(End(stages_C57_sleepPost{k}.SWSEpoch))]);
    behav_C57_sleepPost{k} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','Vtsd','mask','ref','FreezeAccEpoch','MovAcctsd');
    
    begin_sws{k} = Start(stages_C57_sleepPost{k}.SWSEpoch);
    begin_rem{k} = Start(stages_C57_sleepPost{k}.REMEpoch);
    sleep_latency{k} = min([begin_sws{k}(1), begin_rem{k}(1)]);
    TimeBeforeSleep{k} = intervalSet(0, sleep_latency{k});
    SleepyEpoch{k} =  intervalSet(sleep_latency{k},durTotalSleep{k});
    
    sleepyEpoch_1_2{k} = intervalSet(0,2*3600*1e4);
    sleepyEpoch_3_4{k} = intervalSet(3*3600*1e4, 4*3600*1e4);
    sleepyEpoch_5_8{k} = intervalSet(5*3600*1e4, durTotalSleep{k});
    
    [dur_before_sleep,durT_before_sleep]=DurationEpoch(TimeBeforeSleep{k},'min');
    duration_period_pre_sleep{k}=durT_before_sleep;
    
    mov_quantity_sleepPost_wake(k) = mean(Data(Restrict(behav_C57_sleepPost{k}.MovAcctsd,and(stages_C57_sleepPost{k}.Wake,SleepyEpoch{k}))));
    speed_sleepPost_wake(k) = mean(Data(Restrict(behav_C57_sleepPost{k}.Vtsd,and(stages_C57_sleepPost{k}.Wake,SleepyEpoch{k}))));
    TotDist_wake(k) = sum(sqrt(diff(Data(Restrict(behav_C57_sleepPost{k}.Xtsd,and(stages_C57_sleepPost{k}.Wake,SleepyEpoch{k})))).^2+...
        diff(Data(Restrict(behav_C57_sleepPost{k}.Ytsd,and(stages_C57_sleepPost{k}.Wake,SleepyEpoch{k})))).^2));
    
    %%freezing
    [dur_fz,durT_fz]=DurationEpoch(behav_C57_sleepPost{k}.FreezeAccEpoch,'min');
    freezing_mean_duration_sleepPost(k) = nanmean(dur_fz);
    num_fz_sleepPost(k) = length(dur_fz);
    freezing_total_duration_sleepPost(k) = durT_fz;
    perc_fz_sleepPost(k) = (freezing_total_duration_sleepPost(k)./duration_period_pre_sleep{k})*100;
    
    %%threshold on speed to get period of high/low activity
    thresh{k} = mean(Data(behav_C57_sleepPost{k}.MovAcctsd))+std(Data(behav_C57_sleepPost{k}.MovAcctsd));
    highMov{k} = thresholdIntervals(behav_C57_sleepPost{k}.MovAcctsd, thresh{k}, 'Direction', 'Above');
    lowMov{k} = thresholdIntervals(behav_C57_sleepPost{k}.MovAcctsd, thresh{k}, 'Direction', 'Below');
    
    %%spectro sleep
    if exist(spectro)==2
        load(spectro);
        spectre_sleepPost = tsd(Spectro{2}*1E4,Spectro{1});
        freq_sleepPost = Spectro{3};
        sp_sleepPost{k}  = spectre_sleepPost;
        frq_sleepPost{k}  = freq_sleepPost;
    else
    end
    else
    end
end
%% make mean (PROTOCOLE DURING STRESS / DANGEROUS)
for k=1:length(Dir_SleepPostSD.path)
    if isempty(sp_sleepPost{k})==0
        sp_sleepPost_FZ_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(behav_C57_sleepPost{k}.FreezeAccEpoch, TimeBeforeSleep{k})))),1);
        sp_sleepPost_FZ_median(k,:)=nanmedian(10*(Data(Restrict(sp_sleepPost{k}, and(behav_C57_sleepPost{k}.FreezeAccEpoch, TimeBeforeSleep{k})))),1);    
        sp_sleepPost_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, TimeBeforeSleep{k}))),1); sp_sleepPost_mean(sp_sleepPost_mean==0)=NaN;
    else
    end
end
for k=1:length(Dir_SleepPostSD.path)
    if isempty(sp_sleepPost{k})==0     
        sp_sleepPost_FZ_mean_norm(k,:)= sp_sleepPost_FZ_mean(k,:)./nanmean(sp_sleepPost_FZ_mean(k,:)); sp_sleepPost_FZ_mean(sp_sleepPost_FZ_mean==0)=NaN;
    end
end
%%make mean for sleep (PROTOCOLE DURING STRESS / DANGEROUS)
for k=1:length(Dir_SleepPostSD.path)
    if isempty(sp_sleepPost{k})==0
        sp_sleepPost_WAKE_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, SleepyEpoch{k})))),1);
        sp_sleepPost_SWS_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.SWSEpoch, SleepyEpoch{k})))),1);
        sp_sleepPost_REM_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.REMEpoch, SleepyEpoch{k})))),1);
        
        
        
        sp_sleepPost_WAKE_1_2_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, sleepyEpoch_1_2{k})))),1);
        sp_sleepPost_SWS_1_2_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.SWSEpoch, sleepyEpoch_1_2{k})))),1);
        sp_sleepPost_REM_1_2_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.REMEpoch, sleepyEpoch_1_2{k})))),1);
    
        
        sp_sleepPost_WAKE_3_4_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, sleepyEpoch_3_4{k})))),1);
        sp_sleepPost_SWS_3_4_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.SWSEpoch, sleepyEpoch_3_4{k})))),1);
        sp_sleepPost_REM_3_4_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.REMEpoch, sleepyEpoch_3_4{k})))),1);    
    
    
        
        sp_sleepPost_WAKE_5_8_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, sleepyEpoch_5_8{k})))),1);
        sp_sleepPost_SWS_5_8_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.SWSEpoch, sleepyEpoch_5_8{k})))),1);
        sp_sleepPost_REM_5_8_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.REMEpoch, sleepyEpoch_5_8{k})))),1);
        
        
        sp_sleepPost_WAKE_theta_1_2_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, and(sleepyEpoch_1_2{k},stages_C57_sleepPost{k}.ThetaEpoch))))),1);
        sp_sleepPost_WAKE_theta_3_4_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, and(sleepyEpoch_3_4{k},stages_C57_sleepPost{k}.ThetaEpoch))))),1);
        sp_sleepPost_WAKE_theta_5_8_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, and(sleepyEpoch_5_8{k},stages_C57_sleepPost{k}.ThetaEpoch))))),1);
        
        
        sp_sleepPost_WAKE_lowMov_1_2_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, and(sleepyEpoch_1_2{k},lowMov{k}))))),1);
        sp_sleepPost_WAKE_lowMov_3_4_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, and(sleepyEpoch_3_4{k},lowMov{k}))))),1);
        sp_sleepPost_WAKE_lowMov_5_8_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(stages_C57_sleepPost{k}.Wake, and(sleepyEpoch_5_8{k},lowMov{k}))))),1);
        
        
    else
    end
end
for k=1:length(Dir_SleepPostSD.path)
    if isempty(sp_sleepPost{k})==0
        sp_sleepPost_WAKE_mean_norm(k,:)= sp_sleepPost_WAKE_mean(k,:)./nanmean(sp_sleepPost_WAKE_mean(k,:)); sp_sleepPost_WAKE_mean(sp_sleepPost_WAKE_mean==0)=NaN;
        sp_sleepPost_SWS_mean_norm(k,:)= sp_sleepPost_SWS_mean(k,:)./nanmean(sp_sleepPost_SWS_mean(k,:)); sp_sleepPost_SWS_mean(sp_sleepPost_SWS_mean==0)=NaN;
        sp_sleepPost_REM_mean_norm(k,:)= sp_sleepPost_REM_mean(k,:)./nanmean(sp_sleepPost_REM_mean(k,:)); sp_sleepPost_REM_mean(sp_sleepPost_REM_mean==0)=NaN;
        
        
        sp_sleepPost_WAKE_1_2_mean_norm(k,:)= sp_sleepPost_WAKE_1_2_mean(k,:)./nanmean(sp_sleepPost_WAKE_1_2_mean(k,:)); sp_sleepPost_WAKE_1_2_mean(sp_sleepPost_WAKE_1_2_mean==0)=NaN;
        sp_sleepPost_SWS_1_2_mean_norm(k,:)= sp_sleepPost_SWS_1_2_mean(k,:)./nanmean(sp_sleepPost_SWS_1_2_mean(k,:)); sp_sleepPost_SWS_1_2_mean(sp_sleepPost_SWS_1_2_mean==0)=NaN;
        sp_sleepPost_REM_1_2_mean_norm(k,:)= sp_sleepPost_REM_1_2_mean(k,:)./nanmean(sp_sleepPost_REM_1_2_mean(k,:)); sp_sleepPost_REM_1_2_mean(sp_sleepPost_REM_1_2_mean==0)=NaN;
        
        
                
        sp_sleepPost_WAKE_3_4_mean_norm(k,:)= sp_sleepPost_WAKE_3_4_mean(k,:)./nanmean(sp_sleepPost_WAKE_3_4_mean(k,:)); sp_sleepPost_WAKE_3_4_mean(sp_sleepPost_WAKE_3_4_mean==0)=NaN;
        sp_sleepPost_SWS_3_4_mean_norm(k,:)= sp_sleepPost_SWS_3_4_mean(k,:)./nanmean(sp_sleepPost_SWS_3_4_mean(k,:)); sp_sleepPost_SWS_3_4_mean(sp_sleepPost_SWS_3_4_mean==0)=NaN;
        sp_sleepPost_REM_3_4_mean_norm(k,:)= sp_sleepPost_REM_3_4_mean(k,:)./nanmean(sp_sleepPost_REM_3_4_mean(k,:)); sp_sleepPost_REM_3_4_mean(sp_sleepPost_REM_3_4_mean==0)=NaN;
        
        
        sp_sleepPost_WAKE_5_8_mean_norm(k,:)= sp_sleepPost_WAKE_5_8_mean(k,:)./nanmean(sp_sleepPost_WAKE_5_8_mean(k,:)); sp_sleepPost_WAKE_5_8_mean(sp_sleepPost_WAKE_5_8_mean==0)=NaN;
        sp_sleepPost_SWS_5_8_mean_norm(k,:)= sp_sleepPost_SWS_5_8_mean(k,:)./nanmean(sp_sleepPost_SWS_5_8_mean(k,:)); sp_sleepPost_SWS_5_8_mean(sp_sleepPost_SWS_5_8_mean==0)=NaN;
        sp_sleepPost_REM_5_8_mean_norm(k,:)= sp_sleepPost_REM_5_8_mean(k,:)./nanmean(sp_sleepPost_REM_5_8_mean(k,:)); sp_sleepPost_REM_5_8_mean(sp_sleepPost_REM_5_8_mean==0)=NaN;
        
        
        sp_sleepPost_WAKE_theta_1_2_mean_norm(k,:)= sp_sleepPost_WAKE_theta_1_2_mean(k,:)./nanmean(sp_sleepPost_WAKE_theta_1_2_mean(k,:)); sp_sleepPost_WAKE_theta_1_2_mean(sp_sleepPost_WAKE_theta_1_2_mean==0)=NaN;
        sp_sleepPost_WAKE_theta_3_4_mean_norm(k,:)= sp_sleepPost_WAKE_theta_3_4_mean(k,:)./nanmean(sp_sleepPost_WAKE_theta_3_4_mean(k,:)); sp_sleepPost_WAKE_theta_3_4_mean(sp_sleepPost_WAKE_theta_3_4_mean==0)=NaN;
        sp_sleepPost_WAKE_theta_5_8_mean_norm(k,:)= sp_sleepPost_WAKE_theta_5_8_mean(k,:)./nanmean(sp_sleepPost_WAKE_theta_5_8_mean(k,:)); sp_sleepPost_WAKE_theta_5_8_mean(sp_sleepPost_WAKE_theta_5_8_mean==0)=NaN;
        
        
        sp_sleepPost_WAKE_lowMov_1_2_mean_norm(k,:)=sp_sleepPost_WAKE_lowMov_1_2_mean(k,:)./nanmean(sp_sleepPost_WAKE_lowMov_1_2_mean(k,:)); sp_sleepPost_WAKE_lowMov_1_2_mean(sp_sleepPost_WAKE_lowMov_1_2_mean==0)=NaN;
        sp_sleepPost_WAKE_lowMov_3_4_mean_norm(k,:)=sp_sleepPost_WAKE_lowMov_3_4_mean(k,:)./nanmean(sp_sleepPost_WAKE_lowMov_3_4_mean(k,:)); sp_sleepPost_WAKE_lowMov_3_4_mean(sp_sleepPost_WAKE_lowMov_3_4_mean==0)=NaN;
        sp_sleepPost_WAKE_lowMov_5_8_mean_norm(k,:)=sp_sleepPost_WAKE_lowMov_5_8_mean(k,:)./nanmean(sp_sleepPost_WAKE_lowMov_5_8_mean(k,:)); sp_sleepPost_WAKE_lowMov_5_8_mean(sp_sleepPost_WAKE_lowMov_5_8_mean==0)=NaN;
        
    end
end



%%
sp_stressC57cage_FZ_SEM = nanstd(sp_stressC57cage_FZ_mean)/sqrt(size(sp_stressC57cage_FZ_mean,1));
sp_stressCD1cage_FZ_SEM = nanstd(sp_stressCD1cage_FZ_mean)/sqrt(size(sp_stressCD1cage_FZ_mean,1));

sp_stressC57cage_FZ_SEM_norm = nanstd(sp_stressC57cage_FZ_mean_norm)/sqrt(size(sp_stressC57cage_FZ_mean_norm,1));
sp_stressCD1cage_FZ_SEM_norm = nanstd(sp_stressCD1cage_FZ_mean_norm)/sqrt(size(sp_stressCD1cage_FZ_mean_norm,1));

sp_stressC57cage_FZ_med_SEM = nanstd(sp_stressC57cage_FZ_median)/sqrt(size(sp_stressC57cage_FZ_median,1));
sp_stressCD1cage_FZ_med_SEM = nanstd(sp_stressCD1cage_FZ_median)/sqrt(size(sp_stressCD1cage_FZ_median,1));

sp_stressC57cage_SEM = nanstd(sp_stressC57cage_mean)/sqrt(size(sp_stressC57cage_mean,1));
sp_stressCD1cage_SEM = nanstd(sp_stressCD1cage_mean)/sqrt(size(sp_stressCD1cage_mean,1));


sp_sleepPost_FZ_SEM = nanstd(sp_sleepPost_FZ_mean)/sqrt(size(sp_sleepPost_FZ_mean,1));
sp_sleepPost_SEM = nanstd(sp_sleepPost_mean)/sqrt(size(sp_sleepPost_mean,1));
sp_sleepPost_FZ_med_SEM = nanstd(sp_sleepPost_FZ_median)/sqrt(size(sp_sleepPost_FZ_median,1));

sp_sleepPost_FZ_SEM_norm = nanstd(sp_sleepPost_FZ_mean_norm)/sqrt(size(sp_sleepPost_FZ_mean_norm,1));

sp_sleepPost_WAKE_SEM_norm = nanstd(sp_sleepPost_WAKE_mean_norm)/sqrt(size(sp_sleepPost_WAKE_mean_norm,1));
sp_sleepPost_SWS_SEM_norm = nanstd(sp_sleepPost_SWS_mean_norm)/sqrt(size(sp_sleepPost_SWS_mean_norm,1));
sp_sleepPost_REM_SEM_norm = nanstd(sp_sleepPost_REM_mean_norm)/sqrt(size(sp_sleepPost_REM_mean_norm,1));

sp_sleepPost_WAKE_1_2_SEM_norm = nanstd(sp_sleepPost_WAKE_1_2_mean_norm)/sqrt(size(sp_sleepPost_WAKE_1_2_mean_norm,1));
sp_sleepPost_SWS_1_2_SEM_norm = nanstd(sp_sleepPost_SWS_1_2_mean_norm)/sqrt(size(sp_sleepPost_SWS_1_2_mean_norm,1));
sp_sleepPost_REM_1_2_SEM_norm = nanstd(sp_sleepPost_REM_1_2_mean_norm)/sqrt(size(sp_sleepPost_REM_1_2_mean_norm,1));

sp_sleepPost_WAKE_3_4_SEM_norm = nanstd(sp_sleepPost_WAKE_3_4_mean_norm)/sqrt(size(sp_sleepPost_WAKE_3_4_mean_norm,1));
sp_sleepPost_SWS_3_4_SEM_norm = nanstd(sp_sleepPost_SWS_3_4_mean_norm)/sqrt(size(sp_sleepPost_SWS_3_4_mean_norm,1));
sp_sleepPost_REM_3_4_SEM_norm = nanstd(sp_sleepPost_REM_3_4_mean_norm)/sqrt(size(sp_sleepPost_REM_3_4_mean_norm,1));


sp_sleepPost_WAKE_5_8_SEM_norm = nanstd(sp_sleepPost_WAKE_5_8_mean_norm)/sqrt(size(sp_sleepPost_WAKE_5_8_mean_norm,1));
sp_sleepPost_SWS_5_8_SEM_norm = nanstd(sp_sleepPost_SWS_5_8_mean_norm)/sqrt(size(sp_sleepPost_SWS_5_8_mean_norm,1));
sp_sleepPost_REM_5_8_SEM_norm = nanstd(sp_sleepPost_REM_5_8_mean_norm)/sqrt(size(sp_sleepPost_REM_5_8_mean_norm,1));


sp_sleepPost_WAKE_theta_1_2_SEM_norm = nanstd(sp_sleepPost_WAKE_theta_1_2_mean_norm)/sqrt(size(sp_sleepPost_WAKE_theta_1_2_mean_norm,1));
sp_sleepPost_WAKE_theta_3_4_SEM_norm = nanstd(sp_sleepPost_WAKE_theta_3_4_mean_norm)/sqrt(size(sp_sleepPost_WAKE_theta_3_4_mean_norm,1));
sp_sleepPost_WAKE_theta_5_8_SEM_norm = nanstd(sp_sleepPost_WAKE_theta_5_8_mean_norm)/sqrt(size(sp_sleepPost_WAKE_theta_5_8_mean_norm,1));


sp_sleepPost_WAKE_lowMov_1_2_SEM_norm = nanstd(sp_sleepPost_WAKE_lowMov_1_2_mean_norm)/sqrt(size(sp_sleepPost_WAKE_lowMov_1_2_mean_norm,1));
sp_sleepPost_WAKE_lowMov_3_4_SEM_norm = nanstd(sp_sleepPost_WAKE_lowMov_3_4_mean_norm)/sqrt(size(sp_sleepPost_WAKE_lowMov_3_4_mean_norm,1));
sp_sleepPost_WAKE_lowMov_5_8_SEM_norm = nanstd(sp_sleepPost_WAKE_lowMov_5_8_mean_norm)/sqrt(size(sp_sleepPost_WAKE_lowMov_5_8_mean_norm,1));



%% FIGURES


figure, subplot(121), hold on
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressCD1cage_FZ_mean_norm),5), sp_stressCD1cage_FZ_SEM_norm, 'r', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressC57cage_FZ_mean_norm),5), sp_stressC57cage_FZ_SEM_norm, 'b', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{2}, runmean(nanmean(sp_sleepPost_FZ_mean_norm),5), sp_sleepPost_FZ_SEM_norm, 'k', 1); ylabel('Normalized power (a.u)'); %makepretty
xlim([0 8])
ylim([0 10])
makepretty
xlabel('Frequency (Hz)')
% title('SD+dreadd+CNO')


subplot(122),
hold on
plot(frq_stressC57cage{1}, runmean((sp_stressCD1cage_FZ_mean_norm'),5), 'r'); ylabel('Normalized power (a.u)'); %makepretty
plot(frq_stressC57cage{1}, runmean((sp_stressC57cage_FZ_mean_norm'),5), 'b'); ylabel('Normalized power (a.u)'); %makepretty
plot(frq_sleepPost{2}, runmean((sp_sleepPost_FZ_mean_norm'),5), 'k'); ylabel('Normalized power (a.u)'); %makepretty
xlim([0 8])
ylim([0 10])
makepretty

%%

figure
subplot(3,6,1), hold on
shadedErrorBar(frq_sleepPost{2}, nanmean(sp_sleepPost_WAKE_1_2_mean_norm), sp_sleepPost_WAKE_1_2_SEM_norm, 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 1-2h')

subplot(3,6,2), hold on
plot(frq_sleepPost{2}, sp_sleepPost_WAKE_1_2_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 1-2h')

subplot(3,6,7), hold on
shadedErrorBar(frq_sleepPost{2}, nanmean(sp_sleepPost_WAKE_3_4_mean_norm), sp_sleepPost_WAKE_3_4_SEM_norm, 'r', 1); ylabel('Power (a.u)');% makepretty
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 3-4h')

subplot(3,6,8), hold on
plot(frq_sleepPost{2}, sp_sleepPost_WAKE_3_4_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 3-4h')

subplot(3,6,13), hold on
shadedErrorBar(frq_sleepPost{2}, nanmean(sp_sleepPost_WAKE_5_8_mean_norm), sp_sleepPost_WAKE_5_8_SEM_norm, 'r', 1); ylabel('Power (a.u)');% makepretty
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 5-8h')

subplot(3,6,14), hold on
plot(frq_sleepPost{2}, sp_sleepPost_WAKE_5_8_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 5-8h')




subplot(3,6,3), hold on
shadedErrorBar(frq_sleepPost{2}, nanmean(sp_sleepPost_SWS_1_2_mean_norm), sp_sleepPost_SWS_1_2_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 1-2h')

subplot(3,6,4), hold on
plot(frq_sleepPost{2}, sp_sleepPost_SWS_1_2_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 1-2h')

subplot(3,6,9), hold on
shadedErrorBar(frq_sleepPost{2}, nanmean(sp_sleepPost_SWS_3_4_mean_norm), sp_sleepPost_SWS_3_4_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 3-4h')

subplot(3,6,10), hold on
plot(frq_sleepPost{2}, sp_sleepPost_SWS_3_4_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 3-4h')

subplot(3,6,15), hold on
shadedErrorBar(frq_sleepPost{2}, nanmean(sp_sleepPost_SWS_5_8_mean_norm), sp_sleepPost_SWS_5_8_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 5-8h')

subplot(3,6,16), hold on
plot(frq_sleepPost{2}, sp_sleepPost_SWS_5_8_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 5-8h')





subplot(3,6,5), hold on
shadedErrorBar(frq_sleepPost{2}, nanmean(sp_sleepPost_REM_1_2_mean_norm), sp_sleepPost_REM_1_2_SEM_norm, 'r', 1); ylabel('Power (a.u)');% makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('REM 1-2h')

subplot(3,6,6), hold on
plot(frq_sleepPost{2}, sp_sleepPost_REM_1_2_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('REM 1-2h')

subplot(3,6,11), hold on
shadedErrorBar(frq_sleepPost{2}, nanmean(sp_sleepPost_REM_3_4_mean_norm), sp_sleepPost_REM_3_4_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('REM 3-4h')

subplot(3,6,12), hold on
plot(frq_sleepPost{2}, sp_sleepPost_REM_3_4_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('REM 3-4h')

subplot(3,6,17), hold on
shadedErrorBar(frq_sleepPost{2}, nanmean(sp_sleepPost_REM_5_8_mean_norm), sp_sleepPost_REM_5_8_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('REM 5-8h')

subplot(3,6,18),hold on
plot(frq_sleepPost{2}, sp_sleepPost_REM_5_8_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('REM 5-8h')


%% identifier la souris qui a recu du cno avant le protocole de defaite sociale

figure, subplot(131), hold on
for i=1:length(Dir_SensoryExposCD1cage.path)
    if isempty(Start(behav_C57_stressCD1cage{i}.FreezeAccEpoch))==0
        if i==31
            plot(frq_stressC57cage{1}, runmean((sp_stressCD1cage_FZ_mean_norm(i,:)'),5), 'k'); ylabel('Normalized power (a.u)'); %makepretty
        else
            plot(frq_stressC57cage{1}, runmean((sp_stressCD1cage_FZ_mean_norm(i,:)'),5), 'r'); ylabel('Normalized power (a.u)'); %makepretty
        end
    end
end





subplot(132), hold on

for i=1:length(Dir_SensoryExposC57cage.path)
    if isempty(Start(behav_C57_stressC57cage{i}.FreezeAccEpoch))==0
        if i==31
            plot(frq_stressC57cage{1}, runmean((sp_stressC57cage_FZ_mean_norm(i,:)'),5), 'k'); ylabel('Normalized power (a.u)'); %makepretty
        else
            plot(frq_stressC57cage{1}, runmean((sp_stressC57cage_FZ_mean_norm(i,:)'),5), 'r'); ylabel('Normalized power (a.u)'); %makepretty
        end
    end
end




subplot(133), hold on

for i=1:length(Dir_SleepPostSD.path)
    %     if isempty(Start(behav_C57_sleepPost{i}.FreezeAccEpoch))==0
    
    if isempty(sp_sleepPost{i})==0
        if i==31
            plot(frq_stressC57cage{1}, runmean((sp_sleepPost_FZ_mean_norm(i,:)'),5), 'k'); ylabel('Normalized power (a.u)'); %makepretty
        else
            plot(frq_stressC57cage{1}, runmean((sp_sleepPost_FZ_mean_norm(i,:)'),5), 'r'); ylabel('Normalized power (a.u)'); %makepretty
        end
    end
end
