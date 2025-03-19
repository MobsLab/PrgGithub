%% input dir
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');
%%
%% input dir basal sleep
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



%% get the data
%%for baseline recordings
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    
        
        if exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_Accelero.mat')
        a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end

if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
    
    
%     if exist('SleepScoring_Accelero.mat')
%         a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        TOTsleep_basal{i} = or(a{i}.SWSEpoch,a{i}.REMEpoch);
        %%get total duration for each stage
        [durTOTsleep,durTTOTsleep]=DurationEpoch(TOTsleep_basal{i});
        
        totDur_TOTsleep_basal(i) = (durTTOTsleep/1e4)/3600; %%total duration in sec (and convertion in hour)
        totDur_TOTsleep_basal(totDur_TOTsleep_basal==0)=NaN;
        
        [durSWS,durTSWS]=DurationEpoch(a{i}.SWSEpoch);
        totDur_SWS_basal(i) = (durTSWS/1e4)/3600;  totDur_SWS_basal(totDur_SWS_basal==0)=NaN;
        
        [durREM,durTREM]=DurationEpoch(a{i}.REMEpoch);
        totDur_REM_basal(i) = (durTREM/1e4)/3600; totDur_REM_basal(totDur_REM_basal==0)=NaN;
        
        [durWAKE,durTWAKE]=DurationEpoch(a{i}.Wake);
        totDur_WAKE_basal(i) = (durTWAKE/1e4)/3600; totDur_WAKE_basal(totDur_WAKE_basal==0)=NaN;
    end
end

%%for social defeat
for j=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{j}{1});
    b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    TOTsleep_SD{j} = or(b{j}.SWSEpoch,b{j}.REMEpoch);
    
    %%get total duration for each stage
    [durTOTsleep,durTTOTsleep]=DurationEpoch(TOTsleep_SD{j});
    totDur_TOTsleep_SD(j) = (durTTOTsleep/1e4)/3600; %%total duration in sec (and convertion in hour)
    
    [durSWS,durTSWS]=DurationEpoch(b{j}.SWSEpoch);
    totDur_SWS_SD(j) = (durTSWS/1e4)/3600;
    
    [durREM,durTREM]=DurationEpoch(b{j}.REMEpoch);
    totDur_REM_SD(j) = (durTREM/1e4)/3600;
    
    [durWAKE,durTWAKE]=DurationEpoch(b{j}.Wake);
    totDur_WAKE_SD(j) = (durTWAKE/1e4)/3600;
end

%% figure
figure,
subplot(121), PlotErrorBarN_KJ({totDur_WAKE_basal totDur_WAKE_SD totDur_TOTsleep_basal totDur_TOTsleep_SD},'newfig',0,'paired',0)
xticks([1.5 3.5]); xticklabels({'Wake','Total sleep'})
makepretty
ylabel('Duration (hour)')
subplot(122), PlotErrorBarN_KJ({totDur_SWS_basal totDur_SWS_SD, totDur_REM_basal totDur_REM_SD},'newfig',0,'paired',0)
xticks([1.5 3.5]); xticklabels({'NREM','REM'})
makepretty
ylabel('Duration (hour)')


%%


data_totalDuration_TOTsleep_basal=totDur_TOTsleep_basal';
data_totalDuration_TOTsleep_SD=totDur_TOTsleep_SD';


data_totalDuration_Wake_basal=totDur_WAKE_basal';
data_totalDuration_Wake_SD=totDur_WAKE_SD';

miceNum_totalDuration_Wake_basal=[1:76]';

%% figure
figure,
subplot(121), MakeViolinPlot_MC({totDur_WAKE_basal totDur_WAKE_SD totDur_TOTsleep_basal totDur_TOTsleep_SD},...
    {[1 1 1],[1 0 0], [1 1 1],[1 0 0]},[1,2,4,5],{},0)
xticks([1.5 4.5]); xticklabels({'Wake','Total sleep'})
ylim([0 13])
makepretty
ylabel('Duration (hour)')
subplot(122), MakeViolinPlot_MC({totDur_SWS_basal totDur_SWS_SD, totDur_REM_basal totDur_REM_SD},...
    {[1 1 1],[1 0 0], [1 1 1],[1 0 0]},[1,2,4,5],{},0)
xticks([1.5 4.5]); xticklabels({'NREM','REM'})
ylim([0 13])
makepretty
ylabel('Duration (hour)')

% subplot(122),MakeViolinPlot_MC({firstREM_basal./1e4 firstREM_SD./1e4},{[0.2 0.2 0.2],[1 0 0]},[1:2],{'NREM','REM'},1);
