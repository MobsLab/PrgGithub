% %% input dir
% %%procotocole défaite sociale dreadd inhibiteurs PFC-VLPO
% % DirSocialDefeat_stressCD1cage = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO');
% % DirSocialDefeat_stressC57cage = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO');
% % DirSocialDefeat_sleepPost = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_CNOInjection');
% 
% % DirSocialDefeat_stressCD1cage_1 = PathForExperiments_SD_MC('SensoryExposureCD1cage');
% % DirSocialDefeat_stressCD1cage_1 = RestrictPathForExperiment(DirSocialDefeat_stressCD1cage_1, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy
% % DirSocialDefeat_stressCD1cage_2 = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO');
% % DirSocialDefeat_stressCD1cage = MergePathForExperiment(DirSocialDefeat_stressCD1cage_1, DirSocialDefeat_stressCD1cage_2);
% % 
% % DirSocialDefeat_stressC57cage_1 = PathForExperiments_SD_MC('SensoryExposureC57cage');
% % DirSocialDefeat_stressC57cage_2 = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO');
% % DirSocialDefeat_stressC57cage = MergePathForExperiment(DirSocialDefeat_stressC57cage_1, DirSocialDefeat_stressC57cage_2);
% 
% 
% DirSocialDefeat_stressCD1cage = PathForExperiments_SD_MC('SensoryExposureCD1cage');
% DirSocialDefeat_stressC57cage = PathForExperiments_SD_MC('SensoryExposureC57cage');
% DirSocialDefeat_sleepPost = PathForExperiments_SD_MC('SleepPostSD');
% % DirSocialDefeat_sleepPost = RestrictPathForExperiment(DirSocialDefeat, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy 
% 
% 
% 
% %%procotocole défaite sociale mCherry PFC-VLPO + saline
% % DirSocialDefeat_stressCD1cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_CNOInjection');
% % DirSocialDefeat_stressC57cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_CNOInjection');
% % DirSocialDefeat_sleepPost_protocole_safe = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');
% 
% % DirSocialDefeat_stressCD1cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
% % DirSocialDefeat_stressC57cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
% % DirSocialDefeat_sleepPost_protocole_safe = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
% 
% % 
% % DirSocialDefeat_stressCD1cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureCD1cage_PART1');
% % DirSocialDefeat_stressC57cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureCD1cage_PART2');
% % DirSocialDefeat_sleepPost_protocole_safe = PathForExperiments_SD_MC('SleepPostSD_safe');
% 
% 
% % DirSocialDefeat_stressCD1cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureCD1cage_noDREADD_BM_mice_CNOInjection');
% % DirSocialDefeat_stressC57cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureC57cage_noDREADD_BM_mice_CNOInjection');
% % DirSocialDefeat_sleepPost_protocole_safe = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
% 
% 
% 
% % DirSocialDefeat_stressCD1cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureCD1cage_noDREADD_BM_mice_SalineInjection');
% % DirSocialDefeat_stressC57cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureC57cage_noDREADD_BM_mice_SalineInjection');
% % DirSocialDefeat_sleepPost_protocole_safe = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
% 
% DirSocialDefeat_stressCD1cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_PFC_CNOInjection');
% DirSocialDefeat_stressCD1cage_protocole_safe = RestrictPathForExperiment(DirSocialDefeat_stressCD1cage_protocole_safe,'nMice',[1196 1237 1238]);%1238
% 
% DirSocialDefeat_stressC57cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_PFC_CNOInjection');
% DirSocialDefeat_stressC57cage_protocole_safe = RestrictPathForExperiment(DirSocialDefeat_stressC57cage_protocole_safe,'nMice',[1196 1237 1238]);%1238
% 
% DirSocialDefeat_sleepPost_protocole_safe = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_PFC_CNOInjection');
% DirSocialDefeat_sleepPost_protocole_safe = RestrictPathForExperiment(DirSocialDefeat_sleepPost_protocole_safe,'nMice',[1196 1237 1238]);%1238

%% input dir
%%CD1
DirSocialDefeat_stressCD1cage_retro_cre = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO');

DirSocialDefeat_stressCD1cage_classic = PathForExperiments_SD_MC('SensoryExposureCD1cage');
DirSocialDefeat_stressCD1cage_classic = RestrictPathForExperiment(DirSocialDefeat_stressCD1cage_classic, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy

DirSocialDefeat_stressCD1cage_mCherry_cno = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_CNOInjection');

DirSocialDefeat_stressCD1cage_mCherry_sal = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_SalineInjection');

DirSocialDefeat_stressCD1cage_BM_cno = PathForExperiments_SD_MC('SensoryExposureCD1cage_noDREADD_BM_mice_CNOInjection');

DirSocialDefeat_stressCD1cage_BM_sal = PathForExperiments_SD_MC('SensoryExposureCD1cage_noDREADD_BM_mice_SalineInjection');

DirSocialDefeat_stressCD1cage_dreadd_pfc = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_PFC_CNOInjection');
DirSocialDefeat_stressCD1cage_dreadd_pfc = RestrictPathForExperiment(DirSocialDefeat_stressCD1cage_dreadd_pfc,'nMice',[1196 1237 1238]);%1238

merge_stressCD1cage_A = MergePathForExperiment(DirSocialDefeat_stressCD1cage_retro_cre, DirSocialDefeat_stressCD1cage_classic);
merge_stressCD1cage_B = MergePathForExperiment(DirSocialDefeat_stressCD1cage_mCherry_cno, DirSocialDefeat_stressCD1cage_mCherry_sal);
merge_stressCD1cage_C = MergePathForExperiment(DirSocialDefeat_stressCD1cage_BM_cno, DirSocialDefeat_stressCD1cage_BM_sal);

merge_stressCD1cage_D = MergePathForExperiment(merge_stressCD1cage_C, DirSocialDefeat_stressCD1cage_dreadd_pfc);

merge_stressCD1cage_E = MergePathForExperiment(merge_stressCD1cage_A, merge_stressCD1cage_B);

DirSocialDefeat_stressCD1cage = MergePathForExperiment(merge_stressCD1cage_D, merge_stressCD1cage_E);



%%c57
DirSocialDefeat_stressC57cage_retro_cre = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO');

DirSocialDefeat_stressC57cage_classic = PathForExperiments_SD_MC('SensoryExposureC57cage');
DirSocialDefeat_stressC57cage_classic = RestrictPathForExperiment(DirSocialDefeat_stressC57cage_classic, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy

DirSocialDefeat_stressC57cage_mCherry_cno = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_CNOInjection');

DirSocialDefeat_stressC57cage_mCherry_sal = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_SalineInjection');

DirSocialDefeat_stressC57cage_BM_cno = PathForExperiments_SD_MC('SensoryExposureC57cage_noDREADD_BM_mice_CNOInjection');

DirSocialDefeat_stressC57cage_BM_sal = PathForExperiments_SD_MC('SensoryExposureC57cage_noDREADD_BM_mice_SalineInjection');

DirSocialDefeat_stressC57cage_dreadd_pfc = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_PFC_CNOInjection');
DirSocialDefeat_stressC57cage_dreadd_pfc = RestrictPathForExperiment(DirSocialDefeat_stressC57cage_dreadd_pfc,'nMice',[1196 1237 1238]);%1238

merge_stressC57cage_A = MergePathForExperiment(DirSocialDefeat_stressC57cage_retro_cre, DirSocialDefeat_stressC57cage_classic);
merge_stressC57cage_B = MergePathForExperiment(DirSocialDefeat_stressC57cage_mCherry_cno, DirSocialDefeat_stressC57cage_mCherry_sal);
merge_stressC57cage_C = MergePathForExperiment(DirSocialDefeat_stressC57cage_BM_cno, DirSocialDefeat_stressC57cage_BM_sal);

merge_stressC57cage_D = MergePathForExperiment(merge_stressC57cage_C, DirSocialDefeat_stressC57cage_dreadd_pfc);

merge_stressC57cage_E = MergePathForExperiment(merge_stressC57cage_A, merge_stressC57cage_B);

DirSocialDefeat_stressC57cage = MergePathForExperiment(merge_stressC57cage_D, merge_stressC57cage_E);



%%sleep post
DirSocialDefeat_SleepPostSD_retro_cre = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_CNOInjection');

DirSocialDefeat_SleepPostSD_classic = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_SleepPostSD_classic = RestrictPathForExperiment(DirSocialDefeat_SleepPostSD_classic, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy

DirSocialDefeat_SleepPostSD_mCherry_cno = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');

DirSocialDefeat_SleepPostSD_mCherry_sal = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');

DirSocialDefeat_SleepPostSD_BM_cno = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');

DirSocialDefeat_SleepPostSD_BM_sal = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');

DirSocialDefeat_SleepPostSD_dreadd_pfc = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_PFC_CNOInjection');
DirSocialDefeat_SleepPostSD_dreadd_pfc = RestrictPathForExperiment(DirSocialDefeat_SleepPostSD_dreadd_pfc,'nMice',[1196 1237 1238]);%1238

merge_SleepPostSD_A = MergePathForExperiment(DirSocialDefeat_SleepPostSD_retro_cre, DirSocialDefeat_SleepPostSD_classic);
merge_SleepPostSD_B = MergePathForExperiment(DirSocialDefeat_SleepPostSD_mCherry_cno, DirSocialDefeat_SleepPostSD_mCherry_sal);
merge_SleepPostSD_C = MergePathForExperiment(DirSocialDefeat_SleepPostSD_BM_cno, DirSocialDefeat_SleepPostSD_BM_sal);

merge_SleepPostSD_D = MergePathForExperiment(merge_SleepPostSD_C, DirSocialDefeat_SleepPostSD_dreadd_pfc);

merge_SleepPostSD_E = MergePathForExperiment(merge_SleepPostSD_A, merge_SleepPostSD_B);

DirSocialDefeat_sleepPost = MergePathForExperiment(merge_SleepPostSD_D, merge_SleepPostSD_E);


DirSocialDefeat_stressCD1cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureCD1cage_PART1');
DirSocialDefeat_stressC57cage_protocole_safe = PathForExperiments_SD_MC('SensoryExposureCD1cage_PART2');
DirSocialDefeat_sleepPost_protocole_safe = PathForExperiments_SD_MC('SleepPostSD_safe');

%% param spectro
%spectro = 'Bulb_deep_Low_Spectrum.mat' 'PFCx_deep_Low_Spectrum' 'dHPC_deep_Low_Spectrum'
spectro = 'PFCx_deep_Low_Spectrum.mat';

%% LOAD DATA
%% PROTOCOLE DURING STRESS / DANGEROUS
%%load data from 1st sensory expo in CD1 cage (PROTOCOLE DURING STRESS / DANGEROUS)
for i=1:length(DirSocialDefeat_stressCD1cage.path)
    cd(DirSocialDefeat_stressCD1cage.path{i}{1});
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
for i=1:length(DirSocialDefeat_stressCD1cage.path)
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
for i=1:length(DirSocialDefeat_stressCD1cage.path)
    if isempty(Start(behav_C57_stressCD1cage{i}.FreezeAccEpoch))==0
        sp_stressCD1cage_FZ_mean_norm(i,:)= sp_stressCD1cage_FZ_mean(i,:)./nanmean(sp_stressCD1cage_FZ_mean(i,:)); sp_stressCD1cage_FZ_mean_norm(sp_stressCD1cage_FZ_mean_norm==0)=NaN;
            sp_stressCD1cage_FZ_mean_norm_bis{i}= sp_stressCD1cage_FZ_mean(i,:)./nanmean(sp_stressCD1cage_FZ_mean(i,:)); %sp_stressCD1cage_FZ_mean_norm_bis(sp_stressCD1cage_FZ_mean_norm_bis==0)=NaN;

    
%             sp_stressCD1cage_FZ_mean_2_norm(i,:)= sp_stressCD1cage_FZ_mean(i,:)./max_peakValue_stressCD1cage(i); %sp_stressCD1cage_FZ_mean_2_norm(sp_stressCD1cage_FZ_mean_2_norm==0)=NaN;

    end
end

%% load data from 2nd sensory expo in C57 cage (PROTOCOLE DURING STRESS / DANGEROUS)
for j=1:length(DirSocialDefeat_stressC57cage.path)
    cd(DirSocialDefeat_stressC57cage.path{j}{1});
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
for j=1:length(DirSocialDefeat_stressC57cage.path)
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
for j=1:length(DirSocialDefeat_stressC57cage.path)
    if isempty(Start(behav_C57_stressC57cage{j}.FreezeAccEpoch))==0
        sp_stressC57cage_FZ_mean_norm(j,:)= sp_stressC57cage_FZ_mean(j,:)./nanmean(sp_stressC57cage_FZ_mean(j,:)); sp_stressC57cage_FZ_mean_norm(sp_stressC57cage_FZ_mean_norm==0)=NaN;
        sp_stressC57cage_FZ_mean_norm_bis{j}= sp_stressC57cage_FZ_mean(j,:)./nanmean(sp_stressC57cage_FZ_mean(j,:)); sp_stressC57cage_FZ_mean_norm(sp_stressC57cage_FZ_mean_norm==0)=NaN;

    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:length(DirSocialDefeat_stressC57cage.path)
    if isempty(Start(behav_C57_stressC57cage{j}.FreezeAccEpoch))==0
        idx_2hz_stressC57cage_FZ_mean_norm{j} = find(floor(frq_stressC57cage{j})==2);
        power_2hz_stressC57cage_FZ_mean_norm(j,:) = sp_stressC57cage_FZ_mean_norm_bis{j}(idx_2hz_stressC57cage_FZ_mean_norm{j}); power_2hz_stressC57cage_FZ_mean_norm(power_2hz_stressC57cage_FZ_mean_norm==0)=NaN;
       end
end

%% load data from sleep session (PROTOCOLE DURING STRESS / DANGEROUS)
for k=1:length(DirSocialDefeat_sleepPost.path)
    cd(DirSocialDefeat_sleepPost.path{k}{1});
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
end
%%make mean (PROTOCOLE DURING STRESS / DANGEROUS)
for k=1:length(DirSocialDefeat_sleepPost.path)
    if isempty(sp_sleepPost{k})==0
        sp_sleepPost_FZ_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, and(behav_C57_sleepPost{k}.FreezeAccEpoch, TimeBeforeSleep{k})))),1);
        sp_sleepPost_FZ_median(k,:)=nanmedian(10*(Data(Restrict(sp_sleepPost{k}, and(behav_C57_sleepPost{k}.FreezeAccEpoch, TimeBeforeSleep{k})))),1);    
        sp_sleepPost_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost{k}, TimeBeforeSleep{k}))),1); sp_sleepPost_mean(sp_sleepPost_mean==0)=NaN;
    else
    end
end
for k=1:length(DirSocialDefeat_sleepPost.path)
    if isempty(sp_sleepPost{k})==0     
        sp_sleepPost_FZ_mean_norm(k,:)= sp_sleepPost_FZ_mean(k,:)./nanmean(sp_sleepPost_FZ_mean(k,:)); sp_sleepPost_FZ_mean(sp_sleepPost_FZ_mean==0)=NaN;
    end
end
%%make mean for sleep (PROTOCOLE DURING STRESS / DANGEROUS)
for k=1:length(DirSocialDefeat_sleepPost.path)
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
for k=1:length(DirSocialDefeat_sleepPost.path)
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









%% PROTOCOLE AFTER STRESS / SAFE
%%load data from 1st sensory expo in CD1 cage - Protocole_safe (PROTOCOLE AFTER STRESS / SAFE)
for i=1:length(DirSocialDefeat_stressCD1cage_protocole_safe.path)
    cd(DirSocialDefeat_stressCD1cage_protocole_safe.path{i}{1});
    behav_C57_stressCD1cage_protocole_safe{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    %%freezing
    [dur_fz_protocole_safe,durT_fz_protocole_safe]=DurationEpoch(behav_C57_stressCD1cage_protocole_safe{i}.FreezeAccEpoch,'min');
    freezing_mean_duration_stressCD1cage_protocole_safe(i) = nanmean(dur_fz_protocole_safe);
    num_fz_stressCD1cage_protocole_safe(i) = length(dur_fz_protocole_safe);
    freezing_total_duration_stressCD1cage_protocole_safe(i) = durT_fz_protocole_safe;
    perc_fz_stressCD1cage_protocole_safe(i) = (freezing_total_duration_stressCD1cage_protocole_safe(i)./1200)*100;
    %%spectro
 if exist(spectro)==2
        load(spectro);
        sp_OBlow_CD1cage_protocole_safe{i} = load(spectro);
        spectre_stressCD1cage_protocole_safe = tsd(Spectro{2}*1E4,Spectro{1});
        freq_stressCD1cage_protocole_safe = Spectro{3};
        sp_stressCD1cage_protocole_safe{i}  = spectre_stressCD1cage_protocole_safe;
        frq_sstressCD1cage_protocole_safe{i}  = freq_stressCD1cage_protocole_safe;
    else
 end
end

%% make mean (PROTOCOLE AFTER STRESS / SAFE)
for i=1:length(DirSocialDefeat_stressCD1cage_protocole_safe.path)
%         if isempty(Start(behav_C57_stressCD1cage_protocole_safe{i}.FreezeAccEpoch))==0
            sp_stressCD1cage_FZ_protocole_safe_mean(i,:)=nanmean(10*(Data(Restrict(sp_stressCD1cage_protocole_safe{i},behav_C57_stressCD1cage_protocole_safe{i}.FreezeAccEpoch))),1);
            sp_stressCD1cage_FZ_protocole_safe_median(i,:)=nanmedian(10*(Data(Restrict(sp_stressCD1cage_protocole_safe{i},behav_C57_stressCD1cage_protocole_safe{i}.FreezeAccEpoch))),1);
            sp_stressCD1cage_protocole_safe_mean(i,:)=nanmean(10*(Data(sp_stressCD1cage_protocole_safe{i})),1); %sp_stressCD1cage_mean(sp_stressCD1cage_mean==0)=NaN;

%     else
%     end
end
%%
for i=1:length(DirSocialDefeat_stressCD1cage_protocole_safe.path)
%         if isempty(Start(behav_C57_stressCD1cage_protocole_safe{i}.FreezeAccEpoch))==0
            sp_stressCD1cage_FZ_protocole_safe_mean_norm(i,:)= sp_stressCD1cage_FZ_protocole_safe_mean(i,:)./nanmean(sp_stressCD1cage_FZ_protocole_safe_mean(i,:)); sp_stressCD1cage_FZ_protocole_safe_mean_norm(sp_stressCD1cage_FZ_protocole_safe_mean_norm==0)=NaN;
%         end

end

%% load data from 2nd sensory expo in CD1 cage  (PROTOCOLE AFTER STRESS / SAFE)
for j=1:length(DirSocialDefeat_stressC57cage_protocole_safe.path)
    cd(DirSocialDefeat_stressC57cage_protocole_safe.path{j}{1});
    behav_C57_stressC57cage_protocole_safe{j} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    %%freezing
    [dur_fz_protocole_safe,durT_fz_protocole_safe]=DurationEpoch(behav_C57_stressC57cage_protocole_safe{j}.FreezeAccEpoch,'min');
    freezing_mean_duration_stressC57cage_protocole_safe(j) = nanmean(dur_fz_protocole_safe);
    num_fz_stressC57cage_protocole_safe(j) = length(dur_fz_protocole_safe);
    freezing_total_duration_stressC57cage_protocole_safe(j) = durT_fz_protocole_safe;
    perc_fz_stressC57cage_protocole_safe(j) = (freezing_total_duration_stressC57cage_protocole_safe(j)./1200)*100;
    %%spectro
    if exist(spectro)==2
        load(spectro);
        spectre_stressC57cage_protocole_safe = tsd(Spectro{2}*1E4,Spectro{1});
        freq_stressC57cage_protocole_safe = Spectro{3};
        sp_stressC57cage_protocole_safe{j}  = spectre_stressC57cage_protocole_safe;
        frq_stressC57cage_protocole_safe{j}  = freq_stressC57cage_protocole_safe;
    else
    end
end

%%make mean (PROTOCOLE AFTER STRESS / SAFE)
for j=1:length(DirSocialDefeat_stressC57cage_protocole_safe.path)
        
%         if isempty(Start(behav_C57_stressC57cage_protocole_safe{j}.FreezeAccEpoch))==0
            
            sp_stressC57cage_FZ_protocole_safe_mean(j,:)=nanmean(10*(Data(Restrict(sp_stressC57cage_protocole_safe{j},behav_C57_stressC57cage_protocole_safe{j}.FreezeAccEpoch))),1);
            sp_stressC57cage_FZ_protocole_safe_median(j,:)=nanmedian(10*(Data(Restrict(sp_stressC57cage_protocole_safe{j},behav_C57_stressC57cage_protocole_safe{j}.FreezeAccEpoch))),1);
            sp_stressC57cage_protocole_safe_mean(j,:)=nanmean(10*(Data(sp_stressC57cage_protocole_safe{j})),1); sp_stressC57cage_protocole_safe_mean(sp_stressC57cage_protocole_safe_mean==0)=NaN;

%     else
%     end
end

for j=1:length(DirSocialDefeat_stressC57cage_protocole_safe.path)
%         if isempty(Start(behav_C57_stressC57cage_protocole_safe{j}.FreezeAccEpoch))==0
            sp_stressC57cage_FZ_protocole_safe_mean_norm(j,:)= sp_stressC57cage_FZ_protocole_safe_mean(j,:)./nanmean(sp_stressC57cage_FZ_protocole_safe_mean(j,:)); sp_stressC57cage_FZ_protocole_safe_mean_norm(sp_stressC57cage_FZ_protocole_safe_mean_norm==0)=NaN;
            sp_stressC57cage_FZ_protocole_safe_mean_norm_bis{j}= sp_stressC57cage_FZ_protocole_safe_mean(j,:)./nanmean(sp_stressC57cage_FZ_protocole_safe_mean(j,:)); sp_stressC57cage_FZ_protocole_safe_mean_norm(sp_stressC57cage_FZ_protocole_safe_mean_norm==0)=NaN;
%         end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:length(DirSocialDefeat_stressC57cage_protocole_safe.path)
        if isempty(Start(behav_C57_stressC57cage_protocole_safe{j}.FreezeAccEpoch))==0
            idx_2hz_stressC57cage_FZ_protocole_safe_mean_norm{j} = find(floor(frq_stressC57cage_protocole_safe{j})==2);
            power_2hz_stressC57cage_FZ_protocole_safe_mean_norm(j,:) = sp_stressC57cage_FZ_protocole_safe_mean_norm_bis{j}(idx_2hz_stressC57cage_FZ_protocole_safe_mean_norm{j}); power_2hz_stressC57cage_FZ_protocole_safe_mean_norm(power_2hz_stressC57cage_FZ_protocole_safe_mean_norm==0)=NaN;
        end
end


%% Load data from sleep session (PROTOCOLE AFTER STRESS / SAFE)
for k=1:length(DirSocialDefeat_sleepPost_protocole_safe.path)
    cd(DirSocialDefeat_sleepPost_protocole_safe.path{k}{1});
    if exist('SleepScoring_OBGamma.mat')==1
        stages_C57_sleepPost_protocole_safe{k} = load('SleepScoring_OBGamma.mat', 'REMEpoch', 'SWSEpoch', 'Wake','ThetaEpoch','Info', 'WakeWiNoise');
    else
        stages_C57_sleepPost_protocole_safe{k} = load('SleepScoring_Accelero.mat', 'REMEpoch', 'SWSEpoch', 'Wake','ThetaEpoch','Info', 'WakeWiNoise');
    end
    
    info_mov_thrsh_procole_safe{k}=load('SleepScoring_Accelero.mat', 'Info');
    durTotalSleep_protocole_safe{k} = max([max(End(stages_C57_sleepPost_protocole_safe{k}.Wake)),max(End(stages_C57_sleepPost_protocole_safe{k}.SWSEpoch))]);
    stages_C57_sleepPost_protocole_safe{k}.Wake = stages_C57_sleepPost_protocole_safe{k}.WakeWiNoise;
    behav_C57_sleepPost_protocole_safe{k} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','Vtsd','mask','ref','FreezeAccEpoch','MovAcctsd');
    
    begin_sws_protocole_safe{k} = Start(stages_C57_sleepPost_protocole_safe{k}.SWSEpoch);
    begin_rem_protocole_safe{k} = Start(stages_C57_sleepPost_protocole_safe{k}.REMEpoch);
    sleep_latency_protocole_safe{k} = min([begin_sws_protocole_safe{k}(1), begin_rem_protocole_safe{k}(1)]);
    TimeBeforeSleep_protocole_safe{k} = intervalSet(0, sleep_latency_protocole_safe{k});
    SleepyEpoch_protocole_safe{k} =  intervalSet(sleep_latency_protocole_safe{k},durTotalSleep_protocole_safe{k});
    
    sleepyEpoch_1_2_protocole_safe{k} = intervalSet(0,2*3600*1e4);
    sleepyEpoch_3_4_protocole_safe{k} = intervalSet(3*3600*1e4, 4*3600*1e4);
    sleepyEpoch_5_8_protocole_safe{k} = intervalSet(5*3600*1e4, durTotalSleep_protocole_safe{k});
    
    [dur_before_sleep_protocole_safe,durT_before_sleep_protocole_safe]=DurationEpoch(TimeBeforeSleep_protocole_safe{k},'min');
    duration_period_pre_sleep_protocole_safe{k}=durT_before_sleep_protocole_safe;
     
    mov_quantity_sleepPost_protocole_safe_wake(k) = mean(Data(Restrict(behav_C57_sleepPost_protocole_safe{k}.MovAcctsd,and(stages_C57_sleepPost_protocole_safe{k}.Wake,SleepyEpoch_protocole_safe{k}))));
    speed_sleepPost_protocole_safe_wake(k) = mean(Data(Restrict(behav_C57_sleepPost_protocole_safe{k}.Vtsd,and(stages_C57_sleepPost_protocole_safe{k}.Wake,SleepyEpoch_protocole_safe{k}))));
    TotDist_protocole_safe_wake(k) = sum(sqrt(diff(Data(Restrict(behav_C57_sleepPost_protocole_safe{k}.Xtsd,and(stages_C57_sleepPost_protocole_safe{k}.Wake,SleepyEpoch_protocole_safe{k})))).^2+...
        diff(Data(Restrict(behav_C57_sleepPost_protocole_safe{k}.Ytsd,and(stages_C57_sleepPost_protocole_safe{k}.Wake,SleepyEpoch_protocole_safe{k})))).^2));
        
    [dur_fz_protocole_safe,durT_fz_protocole_safe]=DurationEpoch(behav_C57_sleepPost_protocole_safe{k}.FreezeAccEpoch,'min');
    freezing_mean_duration_sleepPost_protocole_safe(k) = nanmean(dur_fz_protocole_safe);
    num_fz_sleepPost_protocole_safe(k) = length(dur_fz_protocole_safe);
    freezing_total_duration_sleepPost_protocole_safe(k) = durT_fz_protocole_safe;
    perc_fz_sleepPost_protocole_safe(k) = (freezing_total_duration_sleepPost_protocole_safe(k)./duration_period_pre_sleep_protocole_safe{k})*100;
    
    %threshold on speed to get period of high/low activity
    thresh_protocole_safe{k} = mean(Data(behav_C57_sleepPost_protocole_safe{k}.MovAcctsd))+std(Data(behav_C57_sleepPost_protocole_safe{k}.MovAcctsd));
    highMov_protocole_safe{k} = thresholdIntervals(behav_C57_sleepPost_protocole_safe{k}.MovAcctsd, thresh_protocole_safe{k}, 'Direction', 'Above');
    lowMov_protocole_safe{k} = thresholdIntervals(behav_C57_sleepPost_protocole_safe{k}.MovAcctsd, thresh_protocole_safe{k}, 'Direction', 'Below');
    
    if exist(spectro)==2
        load(spectro);
        spectre_sleepPost_protocole_safe{k} = tsd(Spectro{2}*1E4,Spectro{1});
        freq_sleepPost_protocole_safe = Spectro{3};
        sp_sleepPost_protocole_safe{k}  = spectre_sleepPost_protocole_safe{k};
        frq_sleepPost_protocole_safe{k}  = freq_sleepPost_protocole_safe;
    else
    end
end

%%make mean (PROTOCOLE AFTER STRESS / SAFE)
for k=1:length(DirSocialDefeat_sleepPost_protocole_safe.path)
    if isempty(sp_sleepPost_protocole_safe{k})==0
        sp_sleepPost_FZ_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(behav_C57_sleepPost_protocole_safe{k}.FreezeAccEpoch, TimeBeforeSleep_protocole_safe{k})))),1);
        sp_sleepPost_FZ_protocole_safe_median(k,:)=nanmedian(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(behav_C57_sleepPost_protocole_safe{k}.FreezeAccEpoch, TimeBeforeSleep_protocole_safe{k})))),1);    
        sp_sleepPost_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, TimeBeforeSleep_protocole_safe{k}))),1); sp_sleepPost_protocole_safe_mean(sp_sleepPost_protocole_safe_mean==0)=NaN;
    else
    end
end
for k=1:length(DirSocialDefeat_sleepPost_protocole_safe.path)
    if isempty(sp_sleepPost_protocole_safe{k})==0     
        sp_sleepPost_FZ_protocole_safe_mean_norm(k,:)= sp_sleepPost_FZ_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_FZ_protocole_safe_mean(k,:)); sp_sleepPost_FZ_protocole_safe_mean(sp_sleepPost_FZ_protocole_safe_mean==0)=NaN;
    end
end

%%make mean for sleep (PROTOCOLE AFTER STRESS / SAFE)
for k=1:length(DirSocialDefeat_sleepPost_protocole_safe.path)
    if isempty(sp_sleepPost_protocole_safe{k})==0
        sp_sleepPost_WAKE_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, SleepyEpoch_protocole_safe{k})))),1);
        sp_sleepPost_SWS_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.SWSEpoch, SleepyEpoch_protocole_safe{k})))),1);
        sp_sleepPost_REM_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.REMEpoch, SleepyEpoch_protocole_safe{k})))),1);
        
        sp_sleepPost_WAKE_1_2_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, sleepyEpoch_1_2_protocole_safe{k})))),1);
        sp_sleepPost_SWS_1_2_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.SWSEpoch, sleepyEpoch_1_2_protocole_safe{k})))),1);
        sp_sleepPost_REM_1_2_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.REMEpoch, sleepyEpoch_1_2_protocole_safe{k})))),1);
    
        sp_sleepPost_WAKE_3_4_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, sleepyEpoch_3_4_protocole_safe{k})))),1);
        sp_sleepPost_SWS_3_4_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.SWSEpoch, sleepyEpoch_3_4_protocole_safe{k})))),1);
        sp_sleepPost_REM_3_4_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.REMEpoch, sleepyEpoch_3_4_protocole_safe{k})))),1);
        
        sp_sleepPost_WAKE_5_8_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, sleepyEpoch_5_8_protocole_safe{k})))),1);
        sp_sleepPost_SWS_5_8_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.SWSEpoch, sleepyEpoch_5_8_protocole_safe{k})))),1);
        sp_sleepPost_REM_5_8_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.REMEpoch, sleepyEpoch_5_8_protocole_safe{k})))),1);  
        
        sp_sleepPost_WAKE_theta_1_2_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, and(sleepyEpoch_1_2_protocole_safe{k},stages_C57_sleepPost_protocole_safe{k}.ThetaEpoch))))),1);
        sp_sleepPost_WAKE_theta_3_4_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, and(sleepyEpoch_3_4_protocole_safe{k},stages_C57_sleepPost_protocole_safe{k}.ThetaEpoch))))),1);
        sp_sleepPost_WAKE_theta_5_8_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, and(sleepyEpoch_5_8_protocole_safe{k},stages_C57_sleepPost_protocole_safe{k}.ThetaEpoch))))),1);
        
        sp_sleepPost_WAKE_lowMov_1_2_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, and(sleepyEpoch_1_2_protocole_safe{k},lowMov_protocole_safe{k}))))),1);
        sp_sleepPost_WAKE_lowMov_3_4_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, and(sleepyEpoch_3_4_protocole_safe{k},lowMov_protocole_safe{k}))))),1);
        sp_sleepPost_WAKE_lowMov_5_8_protocole_safe_mean(k,:)=nanmean(10*(Data(Restrict(sp_sleepPost_protocole_safe{k}, and(stages_C57_sleepPost_protocole_safe{k}.Wake, and(sleepyEpoch_5_8_protocole_safe{k},lowMov_protocole_safe{k}))))),1);
else
    end
end
for k=1:length(DirSocialDefeat_sleepPost_protocole_safe.path)
    if isempty(sp_sleepPost_protocole_safe{k})==0     
        sp_sleepPost_WAKE_protocole_safe_mean_norm(k,:)= sp_sleepPost_WAKE_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_protocole_safe_mean(sp_sleepPost_WAKE_protocole_safe_mean==0)=NaN;
        sp_sleepPost_SWS_protocole_safe_mean_norm(k,:)= sp_sleepPost_SWS_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_SWS_protocole_safe_mean(k,:)); sp_sleepPost_SWS_protocole_safe_mean(sp_sleepPost_SWS_protocole_safe_mean==0)=NaN;
        sp_sleepPost_REM_protocole_safe_mean_norm(k,:)= sp_sleepPost_REM_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_REM_protocole_safe_mean(k,:)); sp_sleepPost_REM_protocole_safe_mean(sp_sleepPost_REM_protocole_safe_mean==0)=NaN;
        
        sp_sleepPost_WAKE_1_2_protocole_safe_mean_norm(k,:)= sp_sleepPost_WAKE_1_2_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_1_2_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_1_2_protocole_safe_mean(sp_sleepPost_WAKE_1_2_protocole_safe_mean==0)=NaN;
        sp_sleepPost_SWS_1_2_protocole_safe_mean_norm(k,:)= sp_sleepPost_SWS_1_2_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_SWS_1_2_protocole_safe_mean(k,:)); sp_sleepPost_SWS_1_2_protocole_safe_mean(sp_sleepPost_SWS_1_2_protocole_safe_mean==0)=NaN;
        sp_sleepPost_REM_1_2_protocole_safe_mean_norm(k,:)= sp_sleepPost_REM_1_2_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_REM_1_2_protocole_safe_mean(k,:)); sp_sleepPost_REM_1_2_protocole_safe_mean(sp_sleepPost_REM_1_2_protocole_safe_mean==0)=NaN;
        
        sp_sleepPost_WAKE_3_4_protocole_safe_mean_norm(k,:)= sp_sleepPost_WAKE_3_4_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_3_4_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_3_4_protocole_safe_mean(sp_sleepPost_WAKE_3_4_protocole_safe_mean==0)=NaN;
        sp_sleepPost_SWS_3_4_protocole_safe_mean_norm(k,:)= sp_sleepPost_SWS_3_4_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_SWS_3_4_protocole_safe_mean(k,:)); sp_sleepPost_SWS_3_4_protocole_safe_mean(sp_sleepPost_SWS_3_4_protocole_safe_mean==0)=NaN;
        sp_sleepPost_REM_3_4_protocole_safe_mean_norm(k,:)= sp_sleepPost_REM_3_4_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_REM_3_4_protocole_safe_mean(k,:)); sp_sleepPost_REM_3_4_protocole_safe_mean(sp_sleepPost_REM_3_4_protocole_safe_mean==0)=NaN;
        
        sp_sleepPost_WAKE_5_8_protocole_safe_mean_norm(k,:)= sp_sleepPost_WAKE_5_8_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_5_8_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_5_8_protocole_safe_mean(sp_sleepPost_WAKE_5_8_protocole_safe_mean==0)=NaN;
        sp_sleepPost_SWS_5_8_protocole_safe_mean_norm(k,:)= sp_sleepPost_SWS_5_8_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_SWS_5_8_protocole_safe_mean(k,:)); sp_sleepPost_SWS_5_8_protocole_safe_mean(sp_sleepPost_SWS_5_8_protocole_safe_mean==0)=NaN;
        sp_sleepPost_REM_5_8_protocole_safe_mean_norm(k,:)= sp_sleepPost_REM_5_8_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_REM_5_8_protocole_safe_mean(k,:)); sp_sleepPost_REM_5_8_protocole_safe_mean(sp_sleepPost_REM_5_8_protocole_safe_mean==0)=NaN;
    
        sp_sleepPost_WAKE_theta_1_2_protocole_safe_mean_norm(k,:)= sp_sleepPost_WAKE_theta_1_2_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_theta_1_2_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_theta_1_2_protocole_safe_mean(sp_sleepPost_WAKE_theta_1_2_protocole_safe_mean==0)=NaN;
        sp_sleepPost_WAKE_theta_3_4_protocole_safe_mean_norm(k,:)= sp_sleepPost_WAKE_theta_3_4_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_theta_3_4_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_theta_3_4_protocole_safe_mean(sp_sleepPost_WAKE_theta_3_4_protocole_safe_mean==0)=NaN;
        sp_sleepPost_WAKE_theta_5_8_protocole_safe_mean_norm(k,:)= sp_sleepPost_WAKE_theta_5_8_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_theta_5_8_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_theta_5_8_protocole_safe_mean(sp_sleepPost_WAKE_theta_5_8_protocole_safe_mean==0)=NaN;
    
        sp_sleepPost_WAKE_lowMov_1_2_protocole_safe_mean_norm(k,:)=sp_sleepPost_WAKE_lowMov_1_2_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_lowMov_1_2_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_lowMov_1_2_protocole_safe_mean(sp_sleepPost_WAKE_lowMov_1_2_protocole_safe_mean==0)=NaN;
        sp_sleepPost_WAKE_lowMov_3_4_protocole_safe_mean_norm(k,:)=sp_sleepPost_WAKE_lowMov_3_4_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_lowMov_3_4_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_lowMov_3_4_protocole_safe_mean(sp_sleepPost_WAKE_lowMov_3_4_protocole_safe_mean==0)=NaN;
        sp_sleepPost_WAKE_lowMov_5_8_protocole_safe_mean_norm(k,:)=sp_sleepPost_WAKE_lowMov_5_8_protocole_safe_mean(k,:)./nanmean(sp_sleepPost_WAKE_lowMov_5_8_protocole_safe_mean(k,:)); sp_sleepPost_WAKE_lowMov_5_8_protocole_safe_mean(sp_sleepPost_WAKE_lowMov_5_8_protocole_safe_mean==0)=NaN;
    end
end



%% compute SEM
sp_stressC57cage_FZ_protocole_safe_SEM = nanstd(sp_stressC57cage_FZ_protocole_safe_mean)/sqrt(size(sp_stressC57cage_FZ_protocole_safe_mean,1));
sp_stressCD1cage_FZ_protocole_safe_SEM = nanstd(sp_stressCD1cage_FZ_protocole_safe_mean)/sqrt(size(sp_stressCD1cage_FZ_protocole_safe_mean,1));

sp_stressC57cage_FZ_protocole_safe_SEM_norm = nanstd(sp_stressC57cage_FZ_protocole_safe_mean_norm)/sqrt(size(sp_stressC57cage_FZ_protocole_safe_mean_norm,1));
sp_stressCD1cage_FZ_protocole_safe_SEM_norm = nanstd(sp_stressCD1cage_FZ_protocole_safe_mean_norm)/sqrt(size(sp_stressCD1cage_FZ_protocole_safe_mean_norm,1));

sp_stressC57cage_FZ_protocole_safe_med_SEM = nanstd(sp_stressC57cage_FZ_protocole_safe_median)/sqrt(size(sp_stressC57cage_FZ_protocole_safe_median,1));
sp_stressCD1cage_FZ_protocole_safe_med_SEM = nanstd(sp_stressCD1cage_FZ_protocole_safe_median)/sqrt(size(sp_stressCD1cage_FZ_protocole_safe_median,1));

sp_stressC57cage_protocole_safe_SEM = nanstd(sp_stressC57cage_protocole_safe_mean)/sqrt(size(sp_stressC57cage_protocole_safe_mean,1));
sp_stressCD1cage_protocole_safe_SEM = nanstd(sp_stressCD1cage_protocole_safe_mean)/sqrt(size(sp_stressCD1cage_protocole_safe_mean,1));


sp_sleepPost_FZ_protocole_safe_SEM = nanstd(sp_sleepPost_FZ_protocole_safe_mean)/sqrt(size(sp_sleepPost_FZ_protocole_safe_mean,1));
sp_sleepPost_protocole_safe_SEM = nanstd(sp_sleepPost_protocole_safe_mean)/sqrt(size(sp_sleepPost_protocole_safe_mean,1));
sp_sleepPost_FZ_protocole_safe_med_SEM = nanstd(sp_sleepPost_FZ_protocole_safe_median)/sqrt(size(sp_sleepPost_FZ_protocole_safe_median,1));

sp_sleepPost_FZ_protocole_safe_SEM_norm = nanstd(sp_sleepPost_FZ_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_FZ_protocole_safe_mean_norm,1));

sp_sleepPost_WAKE_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_protocole_safe_mean_norm,1));
sp_sleepPost_SWS_protocole_safe_SEM_norm = nanstd(sp_sleepPost_SWS_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_SWS_protocole_safe_mean_norm,1));
sp_sleepPost_REM_protocole_safe_SEM_norm = nanstd(sp_sleepPost_REM_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_REM_protocole_safe_mean_norm,1));

sp_sleepPost_WAKE_1_2_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_1_2_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_1_2_protocole_safe_mean_norm,1));
sp_sleepPost_SWS_1_2_protocole_safe_SEM_norm = nanstd(sp_sleepPost_SWS_1_2_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_SWS_1_2_protocole_safe_mean_norm,1));
sp_sleepPost_REM_1_2_protocole_safe_SEM_norm = nanstd(sp_sleepPost_REM_1_2_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_REM_1_2_protocole_safe_mean_norm,1));

sp_sleepPost_WAKE_3_4_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_3_4_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_3_4_protocole_safe_mean_norm,1));
sp_sleepPost_SWS_3_4_protocole_safe_SEM_norm = nanstd(sp_sleepPost_SWS_3_4_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_SWS_3_4_protocole_safe_mean_norm,1));
sp_sleepPost_REM_3_4_protocole_safe_SEM_norm = nanstd(sp_sleepPost_REM_3_4_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_REM_3_4_protocole_safe_mean_norm,1));

sp_sleepPost_WAKE_5_8_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_5_8_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_5_8_protocole_safe_mean_norm,1));
sp_sleepPost_SWS_5_8_protocole_safe_SEM_norm = nanstd(sp_sleepPost_SWS_5_8_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_SWS_5_8_protocole_safe_mean_norm,1));
sp_sleepPost_REM_5_8_protocole_safe_SEM_norm = nanstd(sp_sleepPost_REM_5_8_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_REM_5_8_protocole_safe_mean_norm,1));

sp_sleepPost_WAKE_theta_1_2_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_theta_1_2_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_theta_1_2_protocole_safe_mean_norm,1));
sp_sleepPost_WAKE_theta_3_4_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_theta_3_4_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_theta_3_4_protocole_safe_mean_norm,1));
sp_sleepPost_WAKE_theta_5_8_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_theta_5_8_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_theta_5_8_protocole_safe_mean_norm,1));

                                                              
sp_sleepPost_WAKE_lowMov_1_2_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_lowMov_1_2_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_lowMov_1_2_protocole_safe_mean_norm,1));
sp_sleepPost_WAKE_lowMov_3_4_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_lowMov_3_4_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_lowMov_3_4_protocole_safe_mean_norm,1));
sp_sleepPost_WAKE_lowMov_5_8_protocole_safe_SEM_norm = nanstd(sp_sleepPost_WAKE_lowMov_5_8_protocole_safe_mean_norm)/sqrt(size(sp_sleepPost_WAKE_lowMov_5_8_protocole_safe_mean_norm,1));


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


figure, hold on
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressCD1cage_FZ_mean_norm),5), sp_stressCD1cage_FZ_SEM_norm, 'r', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressC57cage_FZ_mean_norm),5), sp_stressC57cage_FZ_SEM_norm, 'b', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, runmean(nanmean(sp_sleepPost_FZ_mean_norm),5), sp_sleepPost_FZ_SEM_norm, 'k', 1); ylabel('Normalized power (a.u)'); %makepretty
xlim([0 8])
ylim([0 10])
makepretty
xlabel('Frequency (Hz)')
title('dreadd retro cre + CNO')
%%
% subplot(2,3,2)
% PlotErrorBarN_KJ({perc_fz_stressCD1cage./60 perc_fz_stressC57cage./60},'newfig',0,'paired',0,'showsigstar','none','barcolors',{}); ylabel('%'); makepretty
% 
% subplot(2,3,3)
% PlotErrorBarN_KJ({freezing_total_duration_stressCD1cage freezing_total_duration_stressC57cage},'newfig',0,'paired',0,'showsigstar','none','barcolors',{}); ylabel('Total duration (s)'); makepretty
% 
% subplot(2,3,5)
% PlotErrorBarN_KJ({freezing_mean_duration_stressCD1cage freezing_mean_duration_stressC57cage},'newfig',0,'paired',0,'showsigstar','none','barcolors',{}); ylabel('Mean duration (s)'); makepretty
% 
% subplot(2,3,6)
% PlotErrorBarN_KJ({num_fz_stressCD1cage num_fz_stressC57cage},'newfig',0,'paired',0,'showsigstar','none','barcolors',{}); ylabel('Mean duration (s)'); makepretty


%%


figure, hold on
shadedErrorBar(frq_stressC57cage{1}, nanmean(sp_stressCD1cage_FZ_protocole_safe_mean_norm), sp_stressCD1cage_FZ_protocole_safe_SEM_norm, 'r', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_stressC57cage{1}, nanmean(sp_stressC57cage_FZ_protocole_safe_mean_norm), sp_stressC57cage_FZ_protocole_safe_SEM_norm, 'b', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_FZ_protocole_safe_mean_norm), sp_sleepPost_FZ_protocole_safe_SEM_norm, 'k', 1); ylabel('Normalized power (a.u)'); %makepretty
xlim([0 8])
xlabel('Frequency (Hz)')
ylim([0 10])
makepretty
title('mCherry  + CNO')




figure, hold on
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressCD1cage_FZ_protocole_safe_mean_norm),5), sp_stressCD1cage_FZ_protocole_safe_SEM_norm, 'r', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressC57cage_FZ_protocole_safe_mean_norm),5), sp_stressC57cage_FZ_protocole_safe_SEM_norm, 'b', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, runmean(nanmean(sp_sleepPost_FZ_protocole_safe_mean_norm),5), sp_sleepPost_FZ_protocole_safe_SEM_norm, 'k', 1); ylabel('Normalized power (a.u)'); %makepretty
xlim([0 8])
xlabel('Frequency (Hz)')
ylim([0 10])
makepretty
title('mCherry  + CNO')





%% dangereux versus safe (pendant le protocole)
figure,
subplot(3,3,1), hold on
shadedErrorBar(frq_stressC57cage_protocole_safe{1}, nanmean(sp_stressCD1cage_FZ_protocole_safe_mean_norm), sp_stressCD1cage_FZ_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)'); %makepretty
shadedErrorBar(frq_stressC57cage{1}, nanmean(sp_stressCD1cage_FZ_mean_norm), sp_stressCD1cage_FZ_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8])
ylim([0 10])
makepretty
title('1st sensory expo (mean)')

subplot(3,3,2), hold on
plot(frq_stressC57cage_protocole_safe{1}, sp_stressCD1cage_FZ_protocole_safe_mean_norm, 'k')
plot(frq_stressC57cage{1}, sp_stressCD1cage_FZ_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
makepretty
title('all mice')
xlim([0 8])
ylim([0 10])

subplot(3,3,4), hold on
shadedErrorBar(frq_stressC57cage_protocole_safe{1}, nanmean(sp_stressC57cage_FZ_protocole_safe_mean_norm), sp_stressC57cage_FZ_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)'); %makepretty
shadedErrorBar(frq_stressC57cage{1}, nanmean(sp_stressC57cage_FZ_mean_norm), sp_stressC57cage_FZ_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8])
ylim([0 10])
makepretty
title('2nd sensory expo (mean)')

subplot(3,3,5), hold on
plot(frq_stressC57cage_protocole_safe{1}, sp_stressC57cage_FZ_protocole_safe_mean_norm, 'k')
plot(frq_stressC57cage{1}, sp_stressC57cage_FZ_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8])
ylim([0 10])
makepretty
title('all mice')

subplot(3,3,7), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_FZ_protocole_safe_mean_norm), sp_sleepPost_FZ_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_FZ_mean_norm), sp_sleepPost_FZ_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8])
ylim([0 10])
makepretty
title('Sleep session (mean) (no CD1)')

subplot(3,3,8), hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_FZ_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_FZ_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8])
ylim([0 10])
makepretty
title('all mice')



%% dangereux versus safe (pendant le sleep)
figure
subplot(3,6,1), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_WAKE_1_2_protocole_safe_mean_norm), sp_sleepPost_WAKE_1_2_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_WAKE_1_2_mean_norm), sp_sleepPost_WAKE_1_2_SEM_norm, 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 1-2h')

subplot(3,6,2), hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_WAKE_1_2_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_WAKE_1_2_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 1-2h')

subplot(3,6,7), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_WAKE_3_4_protocole_safe_mean_norm), sp_sleepPost_WAKE_3_4_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)');% makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_WAKE_3_4_mean_norm), sp_sleepPost_WAKE_3_4_SEM_norm, 'r', 1); ylabel('Power (a.u)');% makepretty
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 3-4h')

subplot(3,6,8), hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_WAKE_3_4_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_WAKE_3_4_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 3-4h')

subplot(3,6,13), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_WAKE_5_8_protocole_safe_mean_norm), sp_sleepPost_WAKE_5_8_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)');% makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_WAKE_5_8_mean_norm), sp_sleepPost_WAKE_5_8_SEM_norm, 'r', 1); ylabel('Power (a.u)');% makepretty
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 5-8h')

subplot(3,6,14), hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_WAKE_5_8_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_WAKE_5_8_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 10])
makepretty
title('WAKE 5-8h')




subplot(3,6,3), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_SWS_1_2_protocole_safe_mean_norm), sp_sleepPost_SWS_1_2_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_SWS_1_2_mean_norm), sp_sleepPost_SWS_1_2_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 1-2h')

subplot(3,6,4), hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_SWS_1_2_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_SWS_1_2_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 1-2h')

subplot(3,6,9), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_SWS_3_4_protocole_safe_mean_norm), sp_sleepPost_SWS_3_4_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_SWS_3_4_mean_norm), sp_sleepPost_SWS_3_4_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 3-4h')

subplot(3,6,10), hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_SWS_3_4_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_SWS_3_4_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 3-4h')

subplot(3,6,15), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_SWS_5_8_protocole_safe_mean_norm), sp_sleepPost_SWS_5_8_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_SWS_5_8_mean_norm), sp_sleepPost_SWS_5_8_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 5-8h')

subplot(3,6,16), hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_SWS_5_8_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_SWS_5_8_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('NREM 5-8h')





subplot(3,6,5), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_REM_1_2_protocole_safe_mean_norm), sp_sleepPost_REM_1_2_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)');% makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_REM_1_2_mean_norm), sp_sleepPost_REM_1_2_SEM_norm, 'r', 1); ylabel('Power (a.u)');% makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('REM 1-2h')

subplot(3,6,6), hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_REM_1_2_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_REM_1_2_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('REM 1-2h')

subplot(3,6,11), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_REM_3_4_protocole_safe_mean_norm), sp_sleepPost_REM_3_4_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_REM_3_4_mean_norm), sp_sleepPost_REM_3_4_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('REM 3-4h')

subplot(3,6,12), hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_REM_3_4_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_REM_3_4_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('REM 3-4h')

subplot(3,6,17), hold on
shadedErrorBar(frq_sleepPost_protocole_safe{1}, nanmean(sp_sleepPost_REM_5_8_protocole_safe_mean_norm), sp_sleepPost_REM_5_8_protocole_safe_SEM_norm, 'k', 1); ylabel('Power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, nanmean(sp_sleepPost_REM_5_8_mean_norm), sp_sleepPost_REM_5_8_SEM_norm, 'r', 1); ylabel('Power (a.u)'); %makepretty
xlim([0 8]); ylim([0 6])
makepretty
title('REM 5-8h')

subplot(3,6,18),hold on
plot(frq_sleepPost_protocole_safe{1}, sp_sleepPost_REM_5_8_protocole_safe_mean_norm, 'k')
plot(frq_sleepPost{1}, sp_sleepPost_REM_5_8_mean_norm, 'r')
hold on, line([4 4], ylim, 'color','k','linestyle',':')
xlim([0 8]); ylim([0 6])
makepretty
title('REM 5-8h')














%% FIGURES


figure, subplot(121), hold on
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressCD1cage_FZ_mean_norm),5), sp_stressCD1cage_FZ_SEM_norm, 'r', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressC57cage_FZ_mean_norm),5), sp_stressC57cage_FZ_SEM_norm, 'b', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, runmean(nanmean(sp_sleepPost_FZ_mean_norm),5), sp_sleepPost_FZ_SEM_norm, 'k', 1); ylabel('Normalized power (a.u)'); %makepretty
xlim([0 8])
ylim([0 10])
makepretty
xlabel('Frequency (Hz)')
title('SD classic')


subplot(122),
hold on
plot(frq_stressC57cage{1}, runmean((sp_stressCD1cage_FZ_mean_norm'),5), 'r'); ylabel('Normalized power (a.u)'); %makepretty
plot(frq_stressC57cage{1}, runmean((sp_stressC57cage_FZ_mean_norm'),5), 'b'); ylabel('Normalized power (a.u)'); %makepretty
plot(frq_sleepPost{1}, runmean((sp_sleepPost_FZ_mean_norm'),5), 'k'); ylabel('Normalized power (a.u)'); %makepretty
xlim([0 8])
ylim([0 10])
makepretty
%%


figure, subplot(121), hold on
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressCD1cage_FZ_protocole_safe_mean_norm),5), sp_stressCD1cage_FZ_protocole_safe_SEM_norm, 'r', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressC57cage_FZ_protocole_safe_mean_norm),5), sp_stressC57cage_FZ_protocole_safe_SEM_norm, 'b', 1); ylabel('Normalized power (a.u)'); %makepretty
shadedErrorBar(frq_sleepPost{1}, runmean(nanmean(sp_sleepPost_FZ_protocole_safe_mean_norm),5), sp_sleepPost_FZ_protocole_safe_SEM_norm, 'k', 1); ylabel('Normalized power (a.u)'); %makepretty
xlim([0 8])
xlabel('Frequency (Hz)')
ylim([0 10])
makepretty
title('SD safe')


subplot(122),
hold on
plot(frq_stressC57cage{1}, runmean((sp_stressCD1cage_FZ_protocole_safe_mean_norm'),5), 'r'); ylabel('Normalized power (a.u)'); %makepretty
plot(frq_stressC57cage{1}, runmean((sp_stressC57cage_FZ_protocole_safe_mean_norm'),5), 'b'); ylabel('Normalized power (a.u)'); %makepretty
plot(frq_sleepPost{1}, runmean((sp_sleepPost_FZ_protocole_safe_mean_norm'),5), 'k'); ylabel('Normalized power (a.u)'); %makepretty
xlim([0 8])
ylim([0 10])
makepretty



%%

% 
% figure, subplot(121), hold on
% shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressCD1cage_FZ_protocole_safe_mean_norm),5).* frq_stressC57cage{1}, sp_stressCD1cage_FZ_protocole_safe_SEM_norm, 'r', 1); ylabel('Normalized power (a.u)'); %makepretty
% shadedErrorBar(frq_stressC57cage{1}, runmean(nanmean(sp_stressC57cage_FZ_protocole_safe_mean_norm),5).* frq_stressC57cage{1}, sp_stressC57cage_FZ_protocole_safe_SEM_norm, 'b', 1); ylabel('Normalized power (a.u)'); %makepretty
% shadedErrorBar(frq_sleepPost{1}, runmean(nanmean(sp_sleepPost_FZ_protocole_safe_mean_norm),5).* frq_sleepPost{1}, sp_sleepPost_FZ_protocole_safe_SEM_norm, 'k', 1); ylabel('Normalized power (a.u)'); %makepretty
% xlim([0 8])
% xlabel('Frequency (Hz)')
% % ylim([0 10])
% makepretty
% title('SD+BM+CNO')
% 
% 
% subplot(122),
% hold on
% plot(frq_stressC57cage{1}, runmean((sp_stressCD1cage_FZ_protocole_safe_mean_norm'),5).* frq_stressC57cage{1}', 'r'); ylabel('Normalized power (a.u)'); %makepretty
% plot(frq_stressC57cage{1}, runmean((sp_stressC57cage_FZ_protocole_safe_mean_norm'),5).* frq_stressC57cage{1}', 'b'); ylabel('Normalized power (a.u)'); %makepretty
% plot(frq_sleepPost{1}, runmean((sp_sleepPost_FZ_protocole_safe_mean_norm'),5).* frq_stressC57cage{1}', 'k'); ylabel('Normalized power (a.u)'); %makepretty
% xlim([0 8])
% % ylim([0 10])
% makepretty


