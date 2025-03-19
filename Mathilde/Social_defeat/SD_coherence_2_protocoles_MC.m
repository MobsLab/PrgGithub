%%
DirSocialDefeat_stressCD1cage_1 = PathForExperimentsSD_MC('SensoryExposureCD1cage');
DirSocialDefeat_stressCD1cage_1 = RestrictPathForExperiment(DirSocialDefeat_stressCD1cage_1, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy
DirSocialDefeat_stressCD1cage_2 = PathForExperimentsSD_MC('SensoryExposureCD1cage_retroCre');
DirSocialDefeat_stressCD1cage = MergePathForExperiment(DirSocialDefeat_stressCD1cage_1, DirSocialDefeat_stressCD1cage_2);

DirSocialDefeat_stressC57cage_1 = PathForExperimentsSD_MC('SensoryExposureC57cage');
DirSocialDefeat_stressC57cage_2 = PathForExperimentsSD_MC('SensoryExposureC57cage_retroCre');
DirSocialDefeat_stressC57cage = MergePathForExperiment(DirSocialDefeat_stressC57cage_1, DirSocialDefeat_stressC57cage_2);

DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
DirSocialDefeat_sleepPost = RestrictPathForExperiment(DirSocialDefeat, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy

%%%%%%
DirSocialDefeat_stressCD1cage_protocole_safe = PathForExperimentsSD_MC('SensoryExposureCD1cage_PART1');
DirSocialDefeat_stressC57cage_protocole_safe = PathForExperimentsSD_MC('SensoryExposureCD1cage_PART2');
DirSocialDefeat_sleepPost_protocole_safe = PathForExperimentsSD_MC('SleepPostSD_safe');

%%%%%


%% load data from sleep session post SD - protocole safe (AFTER STRESS)
for i=1:length(DirSocialDefeat_sleepPost_protocole_safe.path)
    cd(DirSocialDefeat_sleepPost_protocole_safe.path{i}{1});
    stages_C57_sleepPost_protocole_safe{i} = load('SleepScoring_OBGamma.mat', 'REMEpoch', 'SWSEpoch', 'Wake', 'ThetaEpoch');
    durTotalSleep_protocole_safe{i} = max([max(End(stages_C57_sleepPost_protocole_safe{i}.Wake)),max(End(stages_C57_sleepPost_protocole_safe{i}.SWSEpoch))]);
        
    begin_sws_protocole_safe{i} = Start(stages_C57_sleepPost_protocole_safe{i}.SWSEpoch);
    begin_rem_protocole_safe{i} = Start(stages_C57_sleepPost_protocole_safe{i}.REMEpoch);
    sleep_latency_protocole_safe{i} = min([begin_sws_protocole_safe{i}(1), begin_rem_protocole_safe{i}(1)]);
    TimeBeforeSleep_protocole_safe{i} = intervalSet(0, sleep_latency_protocole_safe{i});
    SleepyEpoch_protocole_safe{i} =  intervalSet(sleep_latency_protocole_safe{i},durTotalSleep_protocole_safe{i});
    
    sleepyEpoch_1_2_protocole_safe{i} = intervalSet(0,2*3600*1e4);
    sleepyEpoch_3_4_protocole_safe{i} = intervalSet(3*3600*1e4, 4*3600*1e4);
    sleepyEpoch_5_8_protocole_safe{i} = intervalSet(5*3600*1e4, durTotalSleep_protocole_safe{i});
   
    res_protocole_safe = pwd;
    nam_PFC_protocole_safe{i} = 'PFCx_deep';
    eval(['tempchPFCx_deep=load([res,''/ChannelsToAnalyse/',nam_PFC_protocole_safe{i},'''],''channel'');'])
    chPFCx_deep_protocole_safe{i} = tempchPFCx_deep.channel;
    eval(['load(''',res_protocole_safe,'','/LFPData/LFP',num2str(chPFCx_deep_protocole_safe{i}),'.mat'');'])
    LFP_PFC_protocole_safe{i} = LFP;
    
    nam_OB_protocole_safe{i} = 'Bulb_deep';
    eval(['tempchBulb_deep=load([res,''/ChannelsToAnalyse/',nam_OB_protocole_safe{i},'''],''channel'');'])
    chBulb_deep_protocole_safe{i} = tempchBulb_deep.channel;
    eval(['load(''',res_protocole_safe,'','/LFPData/LFP',num2str(chBulb_deep_protocole_safe{i}),'.mat'');'])
    LFP_OB_protocole_safe{i} = LFP;
    
    nam_HPC_protocole_safe{i} = 'dHPC_deep';
    eval(['tempchdHPC_deep=load([res,''/ChannelsToAnalyse/',nam_HPC_protocole_safe{i},'''],''channel'');'])
    chdHPC_deep_protocole_safe{i} = tempchdHPC_deep.channel;
    eval(['load(''',res_protocole_safe,'','/LFPData/LFP',num2str(chdHPC_deep_protocole_safe{i}),'.mat'');'])
    LFP_HPC_protocole_safe{i} = LFP;
    
    [C_PFC_OB_protocole_safe_wake,C_PFC_OB_protocole_safe_sws,C_PFC_OB_protocole_safe_rem,f_protocole_safe] = GetCoherence_MC(stages_C57_sleepPost_protocole_safe{i}.Wake,stages_C57_sleepPost_protocole_safe{i}.SWSEpoch,stages_C57_sleepPost_protocole_safe{i}.REMEpoch,LFP_PFC_protocole_safe{i},LFP_OB_protocole_safe{i},sleepyEpoch_1_2_protocole_safe{i});
    coh_PFC_OB_protocole_safe_wake_1_2{i} = C_PFC_OB_protocole_safe_wake;
    coh_PFC_OB_protocole_safe_sws_1_2{i} = C_PFC_OB_protocole_safe_sws;
    coh_PFC_OB_protocole_safe_rem_1_2{i} = C_PFC_OB_protocole_safe_rem;
    
    [C_PFC_OB_protocole_safe_wake,C_PFC_OB_protocole_safe_sws,C_PFC_OB_protocole_safe_rem,f] = GetCoherence_MC(stages_C57_sleepPost_protocole_safe{i}.Wake,stages_C57_sleepPost_protocole_safe{i}.SWSEpoch,stages_C57_sleepPost_protocole_safe{i}.REMEpoch,LFP_PFC_protocole_safe{i},LFP_OB_protocole_safe{i},sleepyEpoch_3_4_protocole_safe{i});
    coh_PFC_OB_protocole_safe_wake_3_4{i} = C_PFC_OB_protocole_safe_wake;
    coh_PFC_OB_protocole_safe_sws_3_4{i} = C_PFC_OB_protocole_safe_sws;
    coh_PFC_OB_protocole_safe_rem_3_4{i} = C_PFC_OB_protocole_safe_rem;
    
    [C_PFC_OB_protocole_safe_wake,C_PFC_OB_protocole_safe_sws,C_PFC_OB_protocole_safe_rem,f_protocole_safe] = GetCoherence_MC(stages_C57_sleepPost_protocole_safe{i}.Wake,stages_C57_sleepPost_protocole_safe{i}.SWSEpoch,stages_C57_sleepPost_protocole_safe{i}.REMEpoch,LFP_PFC_protocole_safe{i},LFP_OB_protocole_safe{i},sleepyEpoch_5_8_protocole_safe{i});
    coh_PFC_OB_protocole_safe_wake_5_8{i} = C_PFC_OB_protocole_safe_wake;
    coh_PFC_OB_protocole_safe_sws_5_8{i} = C_PFC_OB_protocole_safe_sws;
    coh_PFC_OB_protocole_safe_rem_5_8{i} = C_PFC_OB_protocole_safe_rem;
    
    
    [C_PFC_HPC_protocole_safe_wake,C_PFC_HPC_protocole_safe_sws,C_PFC_HPC_protocole_safe_rem,f_protocole_safe] = GetCoherence_MC(stages_C57_sleepPost_protocole_safe{i}.Wake,stages_C57_sleepPost_protocole_safe{i}.SWSEpoch,stages_C57_sleepPost_protocole_safe{i}.REMEpoch,LFP_PFC_protocole_safe{i},LFP_HPC_protocole_safe{i},sleepyEpoch_1_2_protocole_safe{i});
    coh_PFC_HPC_protocole_safe_wake_1_2{i} = C_PFC_HPC_protocole_safe_wake;
    coh_PFC_HPC_protocole_safe_sws_1_2{i} = C_PFC_HPC_protocole_safe_sws;
    coh_PFC_HPC_protocole_safe_rem_1_2{i} = C_PFC_HPC_protocole_safe_rem;
    
    [C_PFC_HPC_protocole_safe_wake,C_PFC_HPC_protocole_safe_sws,C_PFC_HPC_protocole_safe_rem,f] = GetCoherence_MC(stages_C57_sleepPost_protocole_safe{i}.Wake,stages_C57_sleepPost_protocole_safe{i}.SWSEpoch,stages_C57_sleepPost_protocole_safe{i}.REMEpoch,LFP_PFC_protocole_safe{i},LFP_HPC_protocole_safe{i},sleepyEpoch_3_4_protocole_safe{i});
    coh_PFC_HPC_protocole_safe_wake_3_4{i} = C_PFC_HPC_protocole_safe_wake;
    coh_PFC_HPC_protocole_safe_sws_3_4{i} = C_PFC_HPC_protocole_safe_sws;
    coh_PFC_HPC_protocole_safe_rem_3_4{i} = C_PFC_HPC_protocole_safe_rem;
    
    [C_PFC_HPC_protocole_safe_wake,C_PFC_HPC_protocole_safe_sws,C_PFC_HPC_protocole_safe_rem,f_protocole_safe] = GetCoherence_MC(stages_C57_sleepPost_protocole_safe{i}.Wake,stages_C57_sleepPost_protocole_safe{i}.SWSEpoch,stages_C57_sleepPost_protocole_safe{i}.REMEpoch,LFP_PFC_protocole_safe{i},LFP_HPC_protocole_safe{i},sleepyEpoch_5_8_protocole_safe{i});
    coh_PFC_HPC_protocole_safe_wake_5_8{i} = C_PFC_HPC_protocole_safe_wake;
    coh_PFC_HPC_protocole_safe_sws_5_8{i} = C_PFC_HPC_protocole_safe_sws;
    coh_PFC_HPC_protocole_safe_rem_5_8{i} = C_PFC_HPC_protocole_safe_rem;
    
    
    
    
end

%% load data from sleep session post SD (DURING STRESS)
for k=1:length(DirSocialDefeat_sleepPost.path)
    cd(DirSocialDefeat_sleepPost.path{k}{1});
    stages_C57_sleepPost{k} = load('SleepScoring_OBGamma.mat', 'REMEpoch', 'SWSEpoch', 'Wake', 'ThetaEpoch');
    durTotalSleep{k} = max([max(End(stages_C57_sleepPost{k}.Wake)),max(End(stages_C57_sleepPost{k}.SWSEpoch))]);
    
    begin_sws{k} = Start(stages_C57_sleepPost{k}.SWSEpoch);
    begin_rem{k} = Start(stages_C57_sleepPost{k}.REMEpoch);
    sleep_latency{k} = min([begin_sws{k}(1), begin_rem{k}(1)]);
    TimeBeforeSleep{k} = intervalSet(0, sleep_latency{k});
    SleepyEpoch{k} =  intervalSet(sleep_latency{k},durTotalSleep{k});
    
    sleepyEpoch_1_2{k} = intervalSet(0,2*3600*1e4);
    sleepyEpoch_3_4{k} = intervalSet(3*3600*1e4, 4*3600*1e4);
    sleepyEpoch_5_8{k} = intervalSet(5*3600*1e4, durTotalSleep{k});
   
    res = pwd;
    nam_PFC{k} = 'PFCx_deep';
    eval(['tempchPFCx_deep=load([res,''/ChannelsToAnalyse/',nam_PFC{k},'''],''channel'');'])
    chPFCx_deep{k} = tempchPFCx_deep.channel;
    eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCx_deep{k}),'.mat'');'])
    LFP_PFC{k} = LFP;
    
    nam_OB{k} = 'Bulb_deep';
    eval(['tempchBulb_deep=load([res,''/ChannelsToAnalyse/',nam_OB{k},'''],''channel'');'])
    chBulb_deep{k} = tempchBulb_deep.channel;
    eval(['load(''',res,'','/LFPData/LFP',num2str(chBulb_deep{k}),'.mat'');'])
    LFP_OB{k} = LFP;
    
    nam_HPC{k} = 'dHPC_deep';
    eval(['tempchdHPC_deep=load([res,''/ChannelsToAnalyse/',nam_HPC{k},'''],''channel'');'])
    chdHPC_deep{k} = tempchdHPC_deep.channel;
    eval(['load(''',res,'','/LFPData/LFP',num2str(chdHPC_deep{k}),'.mat'');'])
    LFP_HPC{k} = LFP;
    
    [C_PFC_OB_wake,C_PFC_OB_sws,C_PFC_OB_rem,f] = GetCoherence_MC(stages_C57_sleepPost{k}.Wake,stages_C57_sleepPost{k}.SWSEpoch,stages_C57_sleepPost{k}.REMEpoch,LFP_PFC{k},LFP_OB{k},sleepyEpoch_1_2{k});
    coh_PFC_OB_wake_1_2{k} = C_PFC_OB_wake;
    coh_PFC_OB_sws_1_2{k} = C_PFC_OB_sws;
    coh_PFC_OB_rem_1_2{k} = C_PFC_OB_rem;
    
    [C_PFC_OB_wake,C_PFC_OB_sws,C_PFC_OB_rem,f] = GetCoherence_MC(stages_C57_sleepPost{k}.Wake,stages_C57_sleepPost{k}.SWSEpoch,stages_C57_sleepPost{k}.REMEpoch,LFP_PFC{k},LFP_OB{k},sleepyEpoch_3_4{k});
    coh_PFC_OB_wake_3_4{k} = C_PFC_OB_wake;
    coh_PFC_OB_sws_3_4{k} = C_PFC_OB_sws;
    coh_PFC_OB_rem_3_4{k} = C_PFC_OB_rem;
    
    [C_PFC_OB_wake,C_PFC_OB_sws,C_PFC_OB_rem,f] = GetCoherence_MC(stages_C57_sleepPost{k}.Wake,stages_C57_sleepPost{k}.SWSEpoch,stages_C57_sleepPost{k}.REMEpoch,LFP_PFC{k},LFP_OB{k},sleepyEpoch_5_8{k});
    coh_PFC_OB_wake_5_8{k} = C_PFC_OB_wake;
    coh_PFC_OB_sws_5_8{k} = C_PFC_OB_sws;
    coh_PFC_OB_rem_5_8{k} = C_PFC_OB_rem;
    
    
    [C_PFC_HPC_wake,C_PFC_HPC_sws,C_PFC_HPC_rem,f] = GetCoherence_MC(stages_C57_sleepPost{k}.Wake,stages_C57_sleepPost{k}.SWSEpoch,stages_C57_sleepPost{k}.REMEpoch,LFP_PFC{k},LFP_HPC{k},sleepyEpoch_1_2{k});
    coh_PFC_HPC_wake_1_2{k} = C_PFC_HPC_wake;
    coh_PFC_HPC_sws_1_2{k} = C_PFC_HPC_sws;
    coh_PFC_HPC_rem_1_2{k} = C_PFC_HPC_rem;
    
    [C_PFC_HPC_wake,C_PFC_HPC_sws,C_PFC_HPC_rem,f] = GetCoherence_MC(stages_C57_sleepPost{k}.Wake,stages_C57_sleepPost{k}.SWSEpoch,stages_C57_sleepPost{k}.REMEpoch,LFP_PFC{k},LFP_HPC{k},sleepyEpoch_3_4{k});
    coh_PFC_HPC_wake_3_4{k} = C_PFC_HPC_wake;
    coh_PFC_HPC_sws_3_4{k} = C_PFC_HPC_sws;
    coh_PFC_HPC_rem_3_4{k} = C_PFC_HPC_rem;
    
    [C_PFC_HPC_wake,C_PFC_HPC_sws,C_PFC_HPC_rem,f] = GetCoherence_MC(stages_C57_sleepPost{k}.Wake,stages_C57_sleepPost{k}.SWSEpoch,stages_C57_sleepPost{k}.REMEpoch,LFP_PFC{k},LFP_HPC{k},sleepyEpoch_5_8{k});
    coh_PFC_HPC_wake_5_8{k} = C_PFC_HPC_wake;
    coh_PFC_HPC_sws_5_8{k} = C_PFC_HPC_sws;
    coh_PFC_HPC_rem_5_8{k} = C_PFC_HPC_rem;
end
%%

%% average protocole safe
for kk=1:length(coh_PFC_HPC_protocole_safe_wake_1_2)
    %avearge coherence PFC-HPC
    Av_coh_PFC_HPC_protocole_safe_wake_1_2(kk,:)=nanmean(coh_PFC_HPC_protocole_safe_wake_1_2{kk}(:,:),1);
    Av_coh_PFC_HPC_protocole_safe_sws_1_2(kk,:)=nanmean(coh_PFC_HPC_protocole_safe_sws_1_2{kk}(:,:),1);
    Av_coh_PFC_HPC_protocole_safe_rem_1_2(kk,:)=nanmean(coh_PFC_HPC_protocole_safe_rem_1_2{kk}(:,:),1);
    
    Av_coh_PFC_HPC_protocole_safe_wake_3_4(kk,:)=nanmean(coh_PFC_HPC_protocole_safe_wake_3_4{kk}(:,:),1);
    Av_coh_PFC_HPC_protocole_safe_sws_3_4(kk,:)=nanmean(coh_PFC_HPC_protocole_safe_sws_3_4{kk}(:,:),1);
    Av_coh_PFC_HPC_protocole_safe_rem_3_4(kk,:)=nanmean(coh_PFC_HPC_protocole_safe_rem_3_4{kk}(:,:),1);
    
    Av_coh_PFC_HPC_protocole_safe_wake_5_8(kk,:)=nanmean(coh_PFC_HPC_protocole_safe_wake_5_8{kk}(:,:),1);
    Av_coh_PFC_HPC_protocole_safe_sws_5_8(kk,:)=nanmean(coh_PFC_HPC_protocole_safe_sws_5_8{kk}(:,:),1);
    Av_coh_PFC_HPC_protocole_safe_rem_5_8(kk,:)=nanmean(coh_PFC_HPC_protocole_safe_rem_5_8{kk}(:,:),1);
   
    %avearge coherence PFC-OB
    Av_coh_PFC_OB_protocole_safe_wake_1_2(kk,:)=nanmean(coh_PFC_OB_protocole_safe_wake_1_2{kk}(:,:),1);
    Av_coh_PFC_OB_protocole_safe_sws_1_2(kk,:)=nanmean(coh_PFC_OB_protocole_safe_sws_1_2{kk}(:,:),1);
    Av_coh_PFC_OB_protocole_safe_rem_1_2(kk,:)=nanmean(coh_PFC_OB_protocole_safe_rem_1_2{kk}(:,:),1);
    
    Av_coh_PFC_OB_protocole_safe_wake_3_4(kk,:)=nanmean(coh_PFC_OB_protocole_safe_wake_3_4{kk}(:,:),1);
    Av_coh_PFC_OB_protocole_safe_sws_3_4(kk,:)=nanmean(coh_PFC_OB_protocole_safe_sws_3_4{kk}(:,:),1);
    Av_coh_PFC_OB_protocole_safe_rem_3_4(kk,:)=nanmean(coh_PFC_OB_protocole_safe_rem_3_4{kk}(:,:),1);
    
    Av_coh_PFC_OB_protocole_safe_wake_5_8(kk,:)=nanmean(coh_PFC_OB_protocole_safe_wake_5_8{kk}(:,:),1);
    Av_coh_PFC_OB_protocole_safe_sws_5_8(kk,:)=nanmean(coh_PFC_OB_protocole_safe_sws_5_8{kk}(:,:),1);
    Av_coh_PFC_OB_protocole_safe_rem_5_8(kk,:)=nanmean(coh_PFC_OB_protocole_safe_rem_5_8{kk}(:,:),1);
end
%% average 
for kk=1:length(coh_PFC_HPC_wake_1_2)
    %avearge coherence PFC-HPC
    Av_coh_PFC_HPC_wake_1_2(kk,:)=nanmean(coh_PFC_HPC_wake_1_2{kk}(:,:),1);
    Av_coh_PFC_HPC_sws_1_2(kk,:)=nanmean(coh_PFC_HPC_sws_1_2{kk}(:,:),1);
    Av_coh_PFC_HPC_rem_1_2(kk,:)=nanmean(coh_PFC_HPC_rem_1_2{kk}(:,:),1);
    
    Av_coh_PFC_HPC_wake_3_4(kk,:)=nanmean(coh_PFC_HPC_wake_3_4{kk}(:,:),1);
    Av_coh_PFC_HPC_sws_3_4(kk,:)=nanmean(coh_PFC_HPC_sws_3_4{kk}(:,:),1);
    Av_coh_PFC_HPC_rem_3_4(kk,:)=nanmean(coh_PFC_HPC_rem_3_4{kk}(:,:),1);
    
    Av_coh_PFC_HPC_wake_5_8(kk,:)=nanmean(coh_PFC_HPC_wake_5_8{kk}(:,:),1);
    Av_coh_PFC_HPC_sws_5_8(kk,:)=nanmean(coh_PFC_HPC_sws_5_8{kk}(:,:),1);
    Av_coh_PFC_HPC_rem_5_8(kk,:)=nanmean(coh_PFC_HPC_rem_5_8{kk}(:,:),1);
   
    %avearge coherence PFC-OB
    Av_coh_PFC_OB_wake_1_2(kk,:)=nanmean(coh_PFC_OB_wake_1_2{kk}(:,:),1);
    Av_coh_PFC_OB_sws_1_2(kk,:)=nanmean(coh_PFC_OB_sws_1_2{kk}(:,:),1);
    Av_coh_PFC_OB_rem_1_2(kk,:)=nanmean(coh_PFC_OB_rem_1_2{kk}(:,:),1);
    
    Av_coh_PFC_OB_wake_3_4(kk,:)=nanmean(coh_PFC_OB_wake_3_4{kk}(:,:),1);
    Av_coh_PFC_OB_sws_3_4(kk,:)=nanmean(coh_PFC_OB_sws_3_4{kk}(:,:),1);
    Av_coh_PFC_OB_rem_3_4(kk,:)=nanmean(coh_PFC_OB_rem_3_4{kk}(:,:),1);
    
    Av_coh_PFC_OB_wake_5_8(kk,:)=nanmean(coh_PFC_OB_wake_5_8{kk}(:,:),1);
    Av_coh_PFC_OB_sws_5_8(kk,:)=nanmean(coh_PFC_OB_sws_5_8{kk}(:,:),1);
    Av_coh_PFC_OB_rem_5_8(kk,:)=nanmean(coh_PFC_OB_rem_5_8{kk}(:,:),1);
end


%% FIGURE
%% coherence PFC_HPC
figure
subplot(3,8,3), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_protocole_safe_wake_1_2), stdError(Av_coh_PFC_HPC_protocole_safe_wake_1_2), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_wake_1_2), stdError(Av_coh_PFC_HPC_wake_1_2), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('WAKE 1-2h (mean)')

subplot(3,8,4), hold on
plot(f, Av_coh_PFC_HPC_protocole_safe_wake_1_2', 'b')
plot(f, Av_coh_PFC_HPC_wake_1_2', 'r')
xlim([0 8])
title('WAKE 1-2h')

subplot(3,8,11), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_protocole_safe_wake_3_4), stdError(Av_coh_PFC_HPC_protocole_safe_wake_3_4), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_wake_3_4), stdError(Av_coh_PFC_HPC_wake_3_4), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('WAKE 3-4h (mean)')

subplot(3,8,12), hold on
plot(f, Av_coh_PFC_HPC_protocole_safe_wake_3_4', 'b')
plot(f, Av_coh_PFC_HPC_wake_3_4', 'r')
xlim([0 8])
title('WAKE 3-4h')

subplot(3,8,19), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_protocole_safe_wake_5_8), stdError(Av_coh_PFC_HPC_protocole_safe_wake_5_8), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_wake_5_8), stdError(Av_coh_PFC_HPC_wake_5_8), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('WAKE 5-8h (mean)')

subplot(3,8,20), hold on
plot(f, Av_coh_PFC_HPC_protocole_safe_wake_5_8', 'b')
plot(f, Av_coh_PFC_HPC_wake_5_8', 'r')
xlim([0 8])
title('WAKE 5-8h')

subplot(3,8,5), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_protocole_safe_sws_1_2), stdError(Av_coh_PFC_HPC_protocole_safe_sws_1_2), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_sws_1_2), stdError(Av_coh_PFC_HPC_sws_1_2), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('NREM 1-2h (mean)')

subplot(3,8,6), hold on
plot(f, Av_coh_PFC_HPC_protocole_safe_sws_1_2', 'b')
plot(f, Av_coh_PFC_HPC_sws_1_2', 'r')
xlim([0 8])
title('NREM 1-2h')

subplot(3,8,13), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_protocole_safe_sws_3_4), stdError(Av_coh_PFC_HPC_protocole_safe_sws_3_4), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_sws_3_4), stdError(Av_coh_PFC_HPC_sws_3_4), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('NREM 3-4h (mean)')

subplot(3,8,14), hold on
plot(f, Av_coh_PFC_HPC_protocole_safe_sws_3_4', 'b')
plot(f, Av_coh_PFC_HPC_sws_3_4', 'r')
xlim([0 8])
title('NREM 3-4h')

subplot(3,8,21), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_protocole_safe_sws_5_8), stdError(Av_coh_PFC_HPC_protocole_safe_sws_5_8), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_sws_5_8), stdError(Av_coh_PFC_HPC_sws_5_8), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('NREM 5-8h (mean)')

subplot(3,8,22), hold on
plot(f, Av_coh_PFC_HPC_protocole_safe_sws_5_8', 'b')
plot(f, Av_coh_PFC_HPC_sws_5_8', 'r')
xlim([0 8])
title('NREM 5-8h')

subplot(3,8,7), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_protocole_safe_rem_1_2), stdError(Av_coh_PFC_HPC_protocole_safe_rem_1_2), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_rem_1_2), stdError(Av_coh_PFC_HPC_rem_1_2), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('REM 1-2h (mean)')

subplot(3,8,8), hold on
plot(f, Av_coh_PFC_HPC_protocole_safe_rem_1_2', 'b')
plot(f, Av_coh_PFC_HPC_rem_1_2', 'r')
xlim([0 8])
title('REM 1-2h')

subplot(3,8,15), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_protocole_safe_rem_3_4), stdError(Av_coh_PFC_HPC_protocole_safe_rem_3_4), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_rem_3_4), stdError(Av_coh_PFC_HPC_rem_3_4), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('REM 3-4h (mean)')

subplot(3,8,16), hold on
plot(f, Av_coh_PFC_HPC_protocole_safe_rem_3_4', 'b')
plot(f, Av_coh_PFC_HPC_rem_3_4', 'r')
xlim([0 8])
title('REM 3-4h')

subplot(3,8,23), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_protocole_safe_rem_5_8), stdError(Av_coh_PFC_HPC_protocole_safe_rem_5_8), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_HPC_rem_5_8), stdError(Av_coh_PFC_HPC_rem_5_8), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('REM 5-8h (mean)')

subplot(3,8,24),hold on
plot(f, Av_coh_PFC_HPC_protocole_safe_rem_5_8', 'b')
plot(f, Av_coh_PFC_HPC_rem_5_8', 'r')
xlim([0 8])
title('REM 5-8h')



%% coherence PFC_OB
figure
subplot(3,8,3), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_wake_1_2), stdError(Av_coh_PFC_OB_protocole_safe_wake_1_2), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_wake_1_2), stdError(Av_coh_PFC_OB_wake_1_2), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('WAKE 1-2h (mean)')

subplot(3,8,4), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_wake_1_2', 'b')
plot(f, Av_coh_PFC_OB_wake_1_2', 'r')
xlim([0 8])
title('WAKE 1-2h')

subplot(3,8,11), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_wake_3_4), stdError(Av_coh_PFC_OB_protocole_safe_wake_3_4), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_wake_3_4), stdError(Av_coh_PFC_OB_wake_3_4), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('WAKE 3-4h (mean)')

subplot(3,8,12), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_wake_3_4', 'b')
plot(f, Av_coh_PFC_OB_wake_3_4', 'r')
xlim([0 8])
title('WAKE 3-4h')

subplot(3,8,19), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_wake_5_8), stdError(Av_coh_PFC_OB_protocole_safe_wake_5_8), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_wake_5_8), stdError(Av_coh_PFC_OB_wake_5_8), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('WAKE 5-8h (mean)')

subplot(3,8,20), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_wake_5_8', 'b')
plot(f, Av_coh_PFC_OB_wake_5_8', 'r')
xlim([0 8])
title('WAKE 5-8h')

subplot(3,8,5), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_sws_1_2), stdError(Av_coh_PFC_OB_protocole_safe_sws_1_2), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_sws_1_2), stdError(Av_coh_PFC_OB_sws_1_2), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('NREM 1-2h (mean)')

subplot(3,8,6), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_sws_1_2', 'b')
plot(f, Av_coh_PFC_OB_sws_1_2', 'r')
xlim([0 8])
title('NREM 1-2h')

subplot(3,8,13), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_sws_3_4), stdError(Av_coh_PFC_OB_protocole_safe_sws_3_4), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_sws_3_4), stdError(Av_coh_PFC_OB_sws_3_4), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('NREM 3-4h (mean)')

subplot(3,8,14), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_sws_3_4', 'b')
plot(f, Av_coh_PFC_OB_sws_3_4', 'r')
xlim([0 8])
title('NREM 3-4h')

subplot(3,8,21), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_sws_5_8), stdError(Av_coh_PFC_OB_protocole_safe_sws_5_8), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_sws_5_8), stdError(Av_coh_PFC_OB_sws_5_8), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('NREM 5-8h (mean)')

subplot(3,8,22), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_sws_5_8', 'b')
plot(f, Av_coh_PFC_OB_sws_5_8', 'r')
xlim([0 8])
title('NREM 5-8h')

subplot(3,8,7), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_rem_1_2), stdError(Av_coh_PFC_OB_protocole_safe_rem_1_2), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_rem_1_2), stdError(Av_coh_PFC_OB_rem_1_2), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('REM 1-2h (mean)')

subplot(3,8,8), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_rem_1_2', 'b')
plot(f, Av_coh_PFC_OB_rem_1_2', 'r')
xlim([0 8])
title('REM 1-2h')

subplot(3,8,15), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_rem_3_4), stdError(Av_coh_PFC_OB_protocole_safe_rem_3_4), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_rem_3_4), stdError(Av_coh_PFC_OB_rem_3_4), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('REM 3-4h (mean)')

subplot(3,8,16), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_rem_3_4', 'b')
plot(f, Av_coh_PFC_OB_rem_3_4', 'r')
xlim([0 8])
title('REM 3-4h')

subplot(3,8,23), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_rem_5_8), stdError(Av_coh_PFC_OB_protocole_safe_rem_5_8), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_rem_5_8), stdError(Av_coh_PFC_OB_rem_5_8), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('REM 5-8h (mean)')

subplot(3,8,24),hold on
plot(f, Av_coh_PFC_OB_protocole_safe_rem_5_8', 'b')
plot(f, Av_coh_PFC_OB_rem_5_8', 'r')
xlim([0 8])
title('REM 5-8h')

%%




%coherence PFC_OB
figure
subplot(3,8,3), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_wake_1_2), stdError(Av_coh_PFC_OB_protocole_safe_wake_1_2), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_wake_1_2), stdError(Av_coh_PFC_OB_wake_1_2), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('WAKE 1-2h (mean)')

subplot(3,8,4), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_wake_1_2', 'b')
plot(f, Av_coh_PFC_OB_wake_1_2', 'r')
xlim([0 8])
title('WAKE 1-2h')


subplot(3,8,11), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_wake_3_4), stdError(Av_coh_PFC_OB_protocole_safe_wake_3_4), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_wake_3_4), stdError(Av_coh_PFC_OB_wake_3_4), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('WAKE 3-4h (mean)')

subplot(3,8,12), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_wake_3_4', 'b')
plot(f, Av_coh_PFC_OB_wake_3_4', 'r')
xlim([0 8])
title('WAKE 3-4h')

subplot(3,8,19), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_wake_5_8), stdError(Av_coh_PFC_OB_protocole_safe_wake_5_8), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_wake_5_8), stdError(Av_coh_PFC_OB_wake_5_8), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('WAKE 5-8h (mean)')

subplot(3,8,20), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_wake_5_8', 'b')
plot(f, Av_coh_PFC_OB_wake_5_8', 'r')
xlim([0 8])
title('WAKE 5-8h')


subplot(3,8,5), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_sws_1_2), stdError(Av_coh_PFC_OB_protocole_safe_sws_1_2), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_sws_1_2), stdError(Av_coh_PFC_OB_sws_1_2), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('NREM 1-2h (mean)')


subplot(3,8,6), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_sws_1_2', 'b')
plot(f, Av_coh_PFC_OB_sws_1_2', 'r')
xlim([0 8])
title('NREM 1-2h')


subplot(3,8,13), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_sws_3_4), stdError(Av_coh_PFC_OB_protocole_safe_sws_3_4), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_sws_3_4), stdError(Av_coh_PFC_OB_sws_3_4), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('NREM 3-4h (mean)')


subplot(3,8,14), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_sws_3_4', 'b')
plot(f, Av_coh_PFC_OB_sws_3_4', 'r')
xlim([0 8])
title('NREM 3-4h')


subplot(3,8,21), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_sws_5_8), stdError(Av_coh_PFC_OB_protocole_safe_sws_5_8), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_sws_5_8), stdError(Av_coh_PFC_OB_sws_5_8), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('NREM 5-8h (mean)')


subplot(3,8,22), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_sws_5_8', 'b')
plot(f, Av_coh_PFC_OB_sws_5_8', 'r')
xlim([0 8])
title('NREM 5-8h')


subplot(3,8,7), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_rem_1_2), stdError(Av_coh_PFC_OB_protocole_safe_rem_1_2), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_rem_1_2), stdError(Av_coh_PFC_OB_rem_1_2), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('REM 1-2h (mean)')


subplot(3,8,8), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_rem_1_2', 'b')
plot(f, Av_coh_PFC_OB_rem_1_2', 'r')
xlim([0 8])
title('REM 1-2h')


subplot(3,8,15), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_rem_3_4), stdError(Av_coh_PFC_OB_protocole_safe_rem_3_4), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_rem_3_4), stdError(Av_coh_PFC_OB_rem_3_4), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('REM 3-4h (mean)')

subplot(3,8,16), hold on
plot(f, Av_coh_PFC_OB_protocole_safe_rem_3_4', 'b')
plot(f, Av_coh_PFC_OB_rem_3_4', 'r')
xlim([0 8])
title('REM 3-4h')


subplot(3,8,23), hold on
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_protocole_safe_rem_5_8), stdError(Av_coh_PFC_OB_protocole_safe_rem_5_8), 'b', 1); ylabel('Power (a.u)'); % makepretty
shadedErrorBar(f, nanmean(Av_coh_PFC_OB_rem_5_8), stdError(Av_coh_PFC_OB_rem_5_8), 'r', 1); ylabel('Power (a.u)'); % makepretty
xlim([0 8])
title('REM 5-8h (mean)')

subplot(3,8,24),hold on
plot(f, Av_coh_PFC_OB_protocole_safe_rem_5_8', 'b')
plot(f, Av_coh_PFC_OB_rem_5_8', 'r')
xlim([0 8])
title('REM 5-8h')

