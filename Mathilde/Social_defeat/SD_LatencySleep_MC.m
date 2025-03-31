%% input dir : social defeat
% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');

% % DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% 
% DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
% DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
% DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
% DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);
% 

%%%%dir baseline sleep

%% input dir
%%1
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
DirMyBasal=RestrictPathForExperiment(Dir_ctrl,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);


%%3
DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_mCherry_saline = MergePathForExperiment(DirSocialDefeat_mCherry_saline1,DirSocialDefeat_BM_saline1);
DirSocialDefeat = MergePathForExperiment(DirSocialDefeat_classic1,DirSocialDefeat_mCherry_saline);




% %% input dir basal sleep
% DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
% DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
% DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
% DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
% DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
% DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
% DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);
% DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% 
% DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);



%% get data
%variables pour souris saline
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    
    
        if exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_Accelero.mat')
        a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end

if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
    
    

[tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,15,60);
firstSWS_basal(i) = tpsFirstSWS; firstSWS_basal(firstSWS_basal==0)=NaN;
    firstREM_basal(i) = tpsFirstREM; firstREM_basal(firstREM_basal==0)=NaN;
    clear tpsFirstREM tpsFirstSWS
%     
    
%     [latencyToSleep, latencyToFistREM]= FindLatencySleep2_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
%     firstSWS_basal(i) = latencyToSleep; firstSWS_basal(firstSWS_basal==0)=NaN;
%     firstREM_basal(i) = latencyToFistREM; firstREM_basal(firstREM_basal==0)=NaN;
%     clear latencyToSleep latencyToFistREM
    else
    end
    
end


%variables pour souris CNO
for j=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{j}{1});
    b{j}=load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
[tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,15,60);
    firstSWS_SD(j) = tpsFirstSWS;
    firstREM_SD(j) = tpsFirstREM;
    clear tpsFirstREM tpsFirstSWS
    
%     
%         [latencyToSleep, latencyToFistREM]= FindLatencySleep2_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch);
%     firstSWS_SD(j) = latencyToSleep; 
%     firstREM_SD(j) = latencyToFistREM;
%     clear latencyToSleep latencyToFistREM
end


%% plot
% latency to first NREM episode
figure, subplot(121),PlotErrorBarN_KJ({firstSWS_basal./1e4 firstSWS_SD./1e4},'newfig',0,'paired',0);
xticks([1 2])
xticklabels({'Baseline','SD'})
ylabel('NREM sleep latency (hour)')
% ylim([0 2.5])
makepretty

% latency to first REM episode
subplot(122),PlotErrorBarN_KJ({firstREM_basal./1e4 firstREM_SD./1e4},'newfig',0,'paired',0);
xticks([1 2])
xticklabels({'Baseline','SD'})
ylabel('REM sleep latency (hour)')
% ylim([0 2.5])
makepretty


%% plot
% latency to first NREM episode
figure, subplot(121),m=MakeViolinPlot_MC({firstSWS_basal./1e4 firstSWS_SD./1e4},{[1 1 1],[1 0 0]},[1:2],{'NREM','REM'},0);
xticks([1 2])
xticklabels({'Baseline','SD'})
ylabel('NREM sleep latency (hour)')
ylim([0 2.5])
makepretty

% latency to first REM episode
subplot(122),MakeViolinPlot_MC({firstREM_basal./1e4 firstREM_SD./1e4},{[1 1 1],[1 0 0]},[1:2],{'NREM','REM'},0);
xticks([1 2])
xticklabels({'Baseline','SD'})
ylabel('REM sleep latency (hour)')
ylim([0 2.5])
makepretty


