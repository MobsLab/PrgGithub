%% input dir : inhi DREADD in PFC
%baseline sleep
%%input dir BASELINE (get basal directories from all experiments)
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);

DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');

DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);

%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
%cno
DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');


%% inpur dir : manip crh
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');

%%
%variables pour souris saline
for k=1:length(DirBasal.path)
    cd(DirBasal.path{k}{1});
        if exist('SleepScoring_OBGamma.mat')
    c{k}=load('SleepScoring_OBGamma.mat','SWSEpoch','REMEpoch','Wake');
    elseif exist('SleepScoring_Accelero.mat')
    c{k}=load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch','Wake');
    else
        end
if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
    [tpsFirstREM, tpsFirstSWS]= FindFirstREMAfterInjection_MC(c{k}.SWSEpoch,c{k}.REMEpoch,c{k}.Wake);
    firstSWS_basal(k) = tpsFirstSWS; firstSWS_basal(firstSWS_basal==0)=NaN;
    firstREM_basal(k) = tpsFirstREM; firstREM_basal(firstREM_basal==0)=NaN;
else
end
end

%variables pour souris saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i}=load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch','Wake');
    [tpsFirstREM, tpsFirstSWS]= FindFirstREMAfterInjection_MC(a{i}.SWSEpoch,a{i}.REMEpoch,a{i}.Wake);
    firstSWSsal(i) = tpsFirstSWS;
    firstREMsal(i) = tpsFirstREM;
end

%variables pour souris CNO
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    b{j}=load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch','Wake');
    [tpsFirstREM, tpsFirstSWS]= FindFirstREMAfterInjection_MC(b{j}.SWSEpoch,b{j}.REMEpoch,b{j}.Wake);
    firstSWSCNO(j) = tpsFirstSWS;
    firstREMCNO(j) = tpsFirstREM;
end

%% plot : bar plot
% latency to first NREM episode
figure, subplot(121),PlotErrorBarN_KJ({firstSWS_basal./1e4 firstSWSsal./1e4 firstSWSCNO./1e4},'newfig',0,'paired',0);
xticks([1:3])
xticklabels({'Baseline','Saline','CNO'})
ylabel('latency to first NREM (s)')
% ylim([0 3.5e4])
title('NREM')
makepretty

% latency to first REM episode
subplot(122),PlotErrorBarN_KJ({firstREM_basal./1e4 firstREMsal./1e4 firstREMCNO./1e4},'newfig',0,'paired',0);
xticks([1:3])
xticklabels({'Baseline','Saline','CNO'})
ylabel('latency to first REM (s)')
% ylim([0 3.5e4])
title('REM')
makepretty

%% plot : violin plot
% latency to first NREM episode
figure, subplot(121),m=MakeViolinPlot_MC({firstSWS_basal./1e4 firstSWSsal./1e4 firstSWSCNO./1e4},{[1 1 1],[1 0 0],[1 0 0]},[1:3],{},0);
xticks([1:3])
xticklabels({'Baseline','Saline','CNO'})
ylabel('NREM sleep latency (hour)')
% ylim([0 2.5])
makepretty
m{2}.violinAlpha=0.5;

% latency to first REM episode
subplot(122),m=MakeViolinPlot_MC({firstREM_basal./1e4 firstREMsal./1e4 firstREMCNO./1e4},{[1 1 1],[1 0 0],[1 0 0]},[1:3],{},0);

xticklabels({'Baseline','Saline','CNO'})
ylabel('REM sleep latency (hour)')
% ylim([0 2.5])
makepretty
m{2}.violinAlpha=0.5;


%% BOXPLOT
col_basal = [0.8 0.8 0.8];
col_sal = [1 0.6 0.6];
col_cno = [1 0 0];

figure
subplot(121),MakeBoxPlot_MC({firstSWS_basal./1e4 firstSWSsal./1e4 firstSWSCNO./1e4},{col_basal, col_sal, col_cno},[1:3],{},1);
xticks([1:3])
xticklabels({'Baseline','Saline','CNO'})
ylabel('NREM sleep latency (hour)')
makepretty


subplot(122),MakeBoxPlot_MC({firstREM_basal./1e4 firstREMsal./1e4 firstREMCNO./1e4},{col_basal, col_sal, col_cno},[1:3],{},1);
xticks([1:3])
xticklabels({'Baseline','Saline','CNO'})
ylabel('NREM sleep latency (hour)')
makepretty
