%%% Check how many spikes in SWS, REM, Wake

nmouse = 797;

AllSpikes = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/AllSpikes/SpikeData.mat');
OverallFR = GetFiringRate(AllSpikes.S);

DirPreSleep = PathForExperimentsERC_Dima('PreSleep');
DirPreSleep = RestrictPathForExperiment(DirPreSleep, 'nMice', nmouse);

DirHab = PathForExperimentsERC_Dima('Hab');
DirHab = RestrictPathForExperiment(DirHab, 'nMice', nmouse);

DirTestPre = PathForExperimentsERC_Dima('TestPrePooled');
DirTestPre = RestrictPathForExperiment(DirTestPre, 'nMice', nmouse);

DirCond = PathForExperimentsERC_Dima('CondPooled');
DirCond = RestrictPathForExperiment(DirCond, 'nMice', nmouse);

DirTestPost = PathForExperimentsERC_Dima('TestPostPooled');
DirTestPost = RestrictPathForExperiment(DirTestPost, 'nMice', nmouse);

DirPostSleep = PathForExperimentsERC_Dima('PostSleep');
DirPostSleep = RestrictPathForExperiment(DirPostSleep, 'nMice', nmouse);

%% PreSleep
cd(DirPreSleep.path{1}{1});
SpikePreSleep = load('SpikeData.mat');
load ('SleepScoring_OBGamma.mat', 'Wake', 'SWSEpoch', 'REMEpoch');
PreSleepFR = GetFiringRate(SpikePreSleep.S);
PreSleepFRMean = mean(PreSleepFR);
for i=1:length(SpikePreSleep.S)
    PreSleepWakeFR(i) = GetFiringRate({Restrict(SpikePreSleep.S{i}, Wake)});
    PreSleepSWSFR(i) = GetFiringRate({Restrict(SpikePreSleep.S{i}, SWSEpoch)});
    PreSleepREMFR(i) = GetFiringRate({Restrict(SpikePreSleep.S{i}, REMEpoch)});
end
PreSleepWakeFRMean = nanmean(PreSleepWakeFR);
PreSleepSWSFRMean = nanmean(PreSleepSWSFR);
PreSleepREMFRMean = nanmean(PreSleepREMFR);

%% Hab
cd(DirHab.path{1}{1});
SpikeHab = load('SpikeData.mat');
PreHabFR = GetFiringRate(SpikeHab.S);
PreHabFRMean = nanmean(PreHabFR);

%% TestPre
cd(DirTestPre.path{1}{1});
SpikeTestPre = load('SpikeData.mat');
PreTestPreFR = GetFiringRate(SpikeTestPre.S);
PreTestPreFRMean = nanmean(PreTestPreFR);

%% Cond
cd(DirCond.path{1}{1});
SpikeCond = load('SpikeData.mat');
PreCondFR = GetFiringRate(SpikeCond.S);
PreCondFRMean = nanmean(PreCondFR);

%% PostSleep
cd(DirPostSleep.path{1}{1});
SpikePostSleep = load('SpikeData.mat');
load ('SleepScoring_OBGamma.mat', 'Wake', 'SWSEpoch', 'REMEpoch');
PostSleepFR = GetFiringRate(SpikePostSleep.S);
PostSleepFRMean = mean(PostSleepFR);
for i=1:length(SpikePostSleep.S)
    PostSleepWakeFR(i) = GetFiringRate({Restrict(SpikePostSleep.S{i}, Wake)});
    PostSleepSWSFR(i) = GetFiringRate({Restrict(SpikePostSleep.S{i}, SWSEpoch)});
    PostSleepREMFR(i) = GetFiringRate({Restrict(SpikePostSleep.S{i}, REMEpoch)});
end
PostSleepWakeFRMean = nanmean(PostSleepWakeFR);
PostSleepSWSFRMean = nanmean(PostSleepSWSFR);
PostSleepREMFRMean = nanmean(PostSleepREMFR);

%% TestPost
cd(DirTestPost.path{1}{1});
SpikeTestPost = load('SpikeData.mat');
PreTestPostFR = GetFiringRate(SpikeTestPost.S);
PreTestPostFRMean = nanmean(PreTestPostFR);

figure('units', 'normalized', 'outerposition', [0 1 1 1]);
bar([PreSleepFRMean PreSleepWakeFRMean PreSleepSWSFRMean PreSleepREMFRMean PreHabFRMean PreTestPreFRMean PreCondFRMean...
    PreTestPostFRMean PostSleepFRMean PostSleepWakeFRMean PostSleepSWSFRMean PostSleepREMFRMean]);
set(gca,'Xtick',[1:12],'XtickLabel',{'PreSleepTotal', 'PreSleepWake', 'PreSleepSWS','PreSleepREM', 'Hab', 'PreTest',...
    'Conditioning', 'PostTest', 'PostSleepTotal', 'PostSleepWake', 'PostSleepSWS','PostSleepREM'});