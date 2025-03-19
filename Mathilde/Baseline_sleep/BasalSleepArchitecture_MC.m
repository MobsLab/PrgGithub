%% input dir
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);

DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep'); %%mostly KJ and BM mice

DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);

%% get the data

%% parameters
st_epoch_pre = 0.3*1E8;%st_epoch_pre = 0.35*1E8;
en_epoch_pre = 1.5*1E8;%en_epoch_pre = 1*1E8;
st_epoch_post = 1.8*1E8;
en_epoch_post = 2.6*1E8;

%%get data
for i=1:length(DirBasal.path)
    cd(DirBasal.path{i}{1});
    %%get sleep scoring
    if exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
%     elseif exist('SleepScoring_Accelero.mat')
%         a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    if exist('SleepScoring_OBGamma.mat') %%|| exist('SleepScoring_Accelero.mat')
        %%define specific time periods
        durtotal_basal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
%         %3h post injection
%         epoch_3hPostSD_LabBasal{i}=intervalSet(0,3*3600*1E4);
%         %end of the 3h post SD up to the end of the session
%         epoch_endPostSD_LabBasal{i}=intervalSet(End(epoch_3hPostSD_LabBasal{i}),durtotal_basal{i});
%         %total sleep
%         TotSleepEpoch{i} = or(a{i}.SWSEpoch, a{i}.REMEpoch);
        
        epoch_Pre{i} = intervalSet(st_epoch_pre, en_epoch_pre);
        epoch_Post{i} = intervalSet(st_epoch_post,en_epoch_post);


        %%percentage /total session
        SleepStagePerc_totSess{i} = ComputeSleepStagesPercentagesMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
        percWAKE_totSess(i) = SleepStagePerc_totSess{i}(1,1); percWAKE_totSess(percWAKE_totSess==0)=NaN;
        percSWS_totSess(i) = SleepStagePerc_totSess{i}(2,1); percSWS_totSess(percSWS_totSess==0)=NaN;
        percREM_totSess(i) = SleepStagePerc_totSess{i}(3,1); percREM_totSess(percREM_totSess==0)=NaN;
        %%percentage /total sleep
        SleepStagePerc_totSleep{i} = ComputeSleepStagesPercentagesWithoutWakeMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
        percREM_totSleep(i) = SleepStagePerc_totSleep{i}(3,1); percREM_totSleep(percREM_totSleep==0)=NaN;
        
        
        
        
        %%percentage 'pre sleep'
        SleepStagePerc_pre{i} = ComputeSleepStagesPercentagesMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
        percWAKE_pre(i) = SleepStagePerc_pre{i}(1,2); percWAKE_pre(percWAKE_pre==0)=NaN;
        percSWS_pre(i) = SleepStagePerc_pre{i}(2,2); percSWS_pre(percSWS_pre==0)=NaN;
        percREM_pre(i) = SleepStagePerc_pre{i}(3,2); percREM_pre(percREM_pre==0)=NaN;
        %%percentage /total sleep
        SleepStagePerc_totSleep_pre{i} = ComputeSleepStagesPercentagesWithoutWakeMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
        percREM_totSleep_pre(i) = SleepStagePerc_totSleep_pre{i}(3,2); percREM_totSleep_pre(percREM_totSleep_pre==0)=NaN;
        
        
        
        %%percentage 'post sleep'
        SleepStagePerc_post{i} = ComputeSleepStagesPercentagesMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
        percWAKE_post(i) = SleepStagePerc_post{i}(1,3); percWAKE_post(percWAKE_post==0)=NaN;
        percSWS_post(i) = SleepStagePerc_post{i}(2,3); percSWS_post(percSWS_post==0)=NaN;
        percREM_post(i) = SleepStagePerc_post{i}(3,3); percREM_post(percREM_post==0)=NaN;
        %%percentage /total sleep
        SleepStagePerc_totSleep_post{i} = ComputeSleepStagesPercentagesWithoutWakeMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
        percREM_totSleep_post(i) = SleepStagePerc_totSleep_post{i}(3,3); percREM_totSleep_post(percREM_totSleep_post==0)=NaN;        
        
        
        
        
        
        %%number of bouts 
        %%all sleep session
        NumWAKE_totSess(i) = length(length(a{i}.Wake)); NumWAKE_totSess(NumWAKE_totSess==0)=NaN;
        NumSWS_totSess(i) = length(length(a{i}.SWSEpoch)); NumSWS_totSess(NumSWS_totSess==0)=NaN;
        NumREM_totSess(i) = length(length(a{i}.REMEpoch)); NumREM_totSess(NumREM_totSess==0)=NaN;
        %%number of bouts 'pre sleep'
        NumWAKE_pre(i) = length(length(and(a{i}.Wake,epoch_Pre{i}))); NumWAKE_pre(NumWAKE_pre==0)=NaN;
        NumSWS_pre(i) = length(length(and(a{i}.SWSEpoch,epoch_Pre{i}))); NumSWS_pre(NumSWS_pre==0)=NaN;
        NumREM_pre(i) = length(length(and(a{i}.REMEpoch,epoch_Pre{i}))); NumREM_pre(NumREM_pre==0)=NaN;
        %%number of bouts 'post sleep'
        NumWAKE_post(i) = length(length(and(a{i}.Wake,epoch_Post{i}))); NumWAKE_post(NumWAKE_post==0)=NaN;
        NumSWS_post(i) = length(length(and(a{i}.SWSEpoch,epoch_Post{i}))); NumSWS_post(NumSWS_post==0)=NaN;
        NumREM_post(i) = length(length(and(a{i}.REMEpoch,epoch_Post{i}))); NumREM_post(NumREM_post==0)=NaN;
        
        %%mean duration of bouts all sleep session
        durWAKE_totSess(i) = mean(End(a{i}.Wake)-Start(a{i}.Wake))/1E4; durWAKE_totSess(durWAKE_totSess==0)=NaN;
        durSWS_totSess(i) = mean(End(a{i}.SWSEpoch)-Start(a{i}.SWSEpoch))/1E4; durSWS_totSess(durSWS_totSess==0)=NaN;
        durREM_totSess(i) = mean(End(a{i}.REMEpoch)-Start(a{i}.REMEpoch))/1E4; durREM_totSess(durREM_totSess==0)=NaN;
        %%mean duration of bouts 'pre sleep'
        durWAKE_pre(i) = mean(End(and(a{i}.Wake,epoch_Pre{i}))-Start(and(a{i}.Wake,epoch_Pre{i})))/1E4; durWAKE_pre(durWAKE_pre==0)=NaN;
        durSWS_pre(i) = mean(End(and(a{i}.SWSEpoch,epoch_Pre{i}))-Start(and(a{i}.SWSEpoch,epoch_Pre{i})))/1E4; durSWS_pre(durSWS_pre==0)=NaN;
        durREM_pre(i) = mean(End(and(a{i}.REMEpoch,epoch_Pre{i}))-Start(and(a{i}.REMEpoch,epoch_Pre{i})))/1E4;% durREM_pre(durREM_pre==0)=NaN;
        %%mean duration of bouts 'post sleep'
        durWAKE_post(i) = mean(End(and(a{i}.Wake,epoch_Post{i}))-Start(and(a{i}.Wake,epoch_Post{i})))/1E4; durWAKE_post(durWAKE_post==0)=NaN;
        durSWS_post(i) = mean(End(and(a{i}.SWSEpoch,epoch_Post{i}))-Start(and(a{i}.SWSEpoch,epoch_Post{i})))/1E4; durSWS_post(durSWS_post==0)=NaN;
        durREM_post(i) = mean(End(and(a{i}.REMEpoch,epoch_Post{i}))-Start(and(a{i}.REMEpoch,epoch_Post{i})))/1E4; durREM_post(durREM_post==0)=NaN;
        
        
        
        %%total duration of stages
        TOTsleep{i} = or(a{i}.SWSEpoch,a{i}.REMEpoch); %%define all sleep
        %%total duration for all sleep session
        [durTOTsleep,durTTOTsleep]=DurationEpoch(TOTsleep{i});
        totDur_TOTsleep(i) = (durTTOTsleep/1e4)/3600; totDur_TOTsleep(totDur_TOTsleep==0)=NaN; %%total duration in sec (and convertion in hour)
        [durSWS,durTSWS]=DurationEpoch(a{i}.SWSEpoch); totDur_SWS(i) = (durTSWS/1e4)/3600; totDur_SWS(totDur_SWS==0)=NaN;
        [durREM,durTREM]=DurationEpoch(a{i}.REMEpoch); totDur_REM(i) = (durTREM/1e4)/3600; totDur_REM(totDur_REM==0)=NaN;
        [durWAKE,durTWAKE]=DurationEpoch(a{i}.Wake); totDur_WAKE(i) = (durTWAKE/1e4)/3600; totDur_WAKE(totDur_WAKE==0)=NaN;
       %%total duration 'pre sleep'
        [durTOTsleep_pre,durTTOTsleep_pre]=DurationEpoch(and(TOTsleep{i},epoch_Pre{i}));
        totDur_TOTsleep_pre(i) = (durTTOTsleep_pre/1e4)/3600; totDur_TOTsleep_pre(totDur_TOTsleep_pre==0)=NaN; %%total duration in sec (and convertion in hour)
        [durSWS_pre,durTSWS_pre]=DurationEpoch(and(a{i}.SWSEpoch,epoch_Pre{i})); totDur_SWS_pre(i) = (durTSWS_pre/1e4)/3600; totDur_SWS_pre(totDur_SWS_pre==0)=NaN;
        [durREM_pre,durTREM_pre]=DurationEpoch(and(a{i}.REMEpoch,epoch_Pre{i})); totDur_REM_pre(i) = (durTREM_pre/1e4)/3600; totDur_REM_pre(totDur_REM_pre==0)=NaN;
        [durWAKE_pre,durTWAKE_pre]=DurationEpoch(and(a{i}.Wake,epoch_Pre{i})); totDur_WAKE_pre(i) = (durTWAKE_pre/1e4)/3600; totDur_WAKE_pre(totDur_WAKE_pre==0)=NaN;        
        %%total duration 'post sleep'
        [durTOTsleep_post,durTTOTsleep_post]=DurationEpoch(and(TOTsleep{i},epoch_Post{i}));
        totDur_TOTsleep_post(i) = (durTTOTsleep_pre/1e4)/3600; totDur_TOTsleep_post(totDur_TOTsleep_post==0)=NaN; %%total duration in sec (and convertion in hour)
        [durSWS_post,durTSWS_post]=DurationEpoch(and(a{i}.SWSEpoch,epoch_Post{i})); totDur_SWS_post(i) = (durTSWS_post/1e4)/3600; totDur_SWS_post(totDur_SWS_post==0)=NaN;
        [durREM_post,durTREM_post]=DurationEpoch(and(a{i}.REMEpoch,epoch_Post{i})); totDur_REM_post(i) = (durTREM_post/1e4)/3600; totDur_REM_post(totDur_REM_post==0)=NaN;
        [durWAKE_post,durTWAKE_post]=DurationEpoch(and(a{i}.Wake,epoch_Post{i})); totDur_WAKE_post(i) = (durTWAKE_post/1e4)/3600; totDur_WAKE_post(totDur_WAKE_post==0)=NaN; 
        
        
        
        %%latency
        [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_v2_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,1,1);
        firstSWS_basal(i) = (tpsFirstSWS/1e4)/3600; firstSWS_basal(firstSWS_basal==0)=NaN; firstSWS_basal(firstSWS_basal<0)=NaN;
        firstREM_basal(i) = (tpsFirstREM/1e4)/3600; firstREM_basal(firstREM_basal==0)=NaN; firstREM_basal(firstREM_basal<0)=NaN;
%         %%latency 'pre sleep'
%         [tpsFirstREM_pre, tpsFirstSWS_pre]= FindLatencySleep_v2_MC(and(a{i}.Wake,epoch_Pre{i}),and(a{i}.SWSEpoch,epoch_Pre{i}),and(a{i}.REMEpoch,epoch_Pre{i}),1,1);
%         firstSWS_pre(i) = (tpsFirstSWS/1e4)/3600; firstSWS_pre(firstSWS_pre==0)=NaN; firstSWS_pre(firstSWS_pre<0)=NaN;
%         firstREM_pre(i) = (tpsFirstREM/1e4)/3600; firstREM_pre(firstREM_pre==0)=NaN; firstREM_pre(firstREM_pre<0)=NaN;
        %%latency 'post sleep'
%         [tpsFirstREM_post, tpsFirstSWS_post]= FindLatencySleep_v2_MC(and(a{i}.Wake,epoch_Post{i}),and(a{i}.SWSEpoch,epoch_Post{i}),and(a{i}.REMEpoch,epoch_Post{i}),1,1);
%         firstSWS_post(i) = (tpsFirstSWS_post/1e4)/3600; firstSWS_post(firstSWS_post==0)=NaN; firstSWS_post(firstSWS_post<0)=NaN;
%         firstREM_post(i) = (tpsFirstREM_post/1e4)/3600; firstREM_post(firstREM_post==0)=NaN; firstREM_post(firstREM_post<0)=NaN;
    else
    end
end
%%

figure, 
subplot(331), PlotErrorBarN_KJ({percWAKE_totSess percSWS_totSess percREM_totSess},'newfig',0,'paired',0);
xticks([1:3]); xticklabels({'Wake','NREM','REM'})
ylabel('% (/ total session)')
ylim([0 105])
makepretty

subplot(332), PlotErrorBarN_KJ({percSWS_totSleep percREM_totSleep},'newfig',0,'paired',0);
xticks([1:2]); xticklabels({'NREM','REM'})
ylabel('% (/ total sleep)')
ylim([0 105])
makepretty

subplot(334), PlotErrorBarN_KJ({totDur_WAKE totDur_TOTsleep},'newfig',0,'paired',0);
xticks([1:2]); xticklabels({'Wake','Total sleep'})
ylabel('Total duration (hour)')
ylim([0 15])
makepretty

subplot(335), PlotErrorBarN_KJ({totDur_SWS totDur_REM},'newfig',0,'paired',0);
xticks([1:2]); xticklabels({'NREM','REM'})
ylabel('Total duration (hour)')
ylim([0 15])
makepretty

subplot(336), PlotErrorBarN_KJ({durWAKE_totSess durSWS_totSess durREM_totSess},'newfig',0,'paired',0);
xticks([1:3]); xticklabels({'Wake','NREM','REM'})
ylabel('Mean duration of bouts (s)')

subplot(337), PlotErrorBarN_KJ({NumWAKE_totSess NumSWS_totSess NumREM_totSess},'newfig',0,'paired',0);
xticks([1:3]); xticklabels({'Wake','NREM','REM'})
ylabel('Numbers of bouts')
ylim([0 1750])
makepretty

subplot(338), PlotErrorBarN_KJ({firstSWS_basal firstREM_basal},'newfig',0,'paired',0);
xticks([1:2]); xticklabels({'NREM','REM'})
ylabel('Latency (hour)')
% ylim([0 30000])
makepretty


%%

showPoint=0;
figure, 
subplot(331), v=MakeViolinPlot_MC({percWAKE_totSess percSWS_totSess percREM_totSess},{[0 0 0.8],[0.2 0.2 0.2],[1 0 0]},[1:3],{'Wake','NREM','REM'},showPoint);
ylabel('% (/ total session)')
ylim([0 85])
makepretty

subplot(332), MakeViolinPlot_MC({percREM_totSleep},{[1 0 0]},[],{'REM'},showPoint);
ylabel('% (/ total sleep)')
ylim([0 20])
makepretty

subplot(334), MakeViolinPlot_MC({totDur_WAKE totDur_TOTsleep},{[0 0 0.8],[0 0 0 ]},[1:2],{'Wake','Total sleep'},showPoint);
ylabel('Total duration (hour)')
ylim([0 15])
makepretty

subplot(335), MakeViolinPlot_MC({totDur_SWS totDur_REM},{[0.2 0.2 0.2],[1 0 0]},[1:2],{'NREM','REM'},showPoint);
ylabel('Total duration (hour)')
ylim([0 10.2])
makepretty

subplot(336), MakeViolinPlot_MC({durWAKE_totSess durSWS_totSess durREM_totSess},{[0 0 0.8],[0.2 0.2 0.2],[1 0 0]},[1:3],{'Wake','NREM','REM'},showPoint);
ylabel('Mean duration of bouts (s)')
makepretty

subplot(337), MakeViolinPlot_MC({NumWAKE_totSess NumSWS_totSess NumREM_totSess},{[0 0 0.8],[0.2 0.2 0.2],[1 0 0]},[1:3],{'Wake','NREM','REM'},showPoint);
ylabel('Numbers of bouts')
ylim([0 1505])
makepretty

subplot(338), MakeViolinPlot_MC({firstSWS_basal firstREM_basal},{[0.2 0.2 0.2],[1 0 0]},[1:2],{'NREM','REM'},showPoint);
ylabel('Latency (hour)')
ylim([0 5])
makepretty




%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%

showPoint=1;

figure, 
subplot(331), v=MakeViolinPlot_MC({percWAKE_pre percSWS_pre percREM_pre percWAKE_post percSWS_post percREM_post},...
    {[0 0 0.8],[0.2 0.2 0.2],[1 0 0],[0 0 0.8],[0.2 0.2 0.2],[1 0 0]},[1:3,5:7],{},showPoint);
v{1}.violinAlpha=0.3
v{2}.violinAlpha=0.3
v{3}.violinAlpha=0.3
xticks([2,5]); xticklabels({'PreSleep','PostSleep'})
ylabel('% (/ total session)')
makepretty

subplot(332), v=MakeViolinPlot_MC({percREM_totSleep_pre percREM_totSleep_post},{[1 0 0],[1 0 0]},[1,2],{},showPoint);
v{1}.violinAlpha=0.3
xticks([1,2]); xticklabels({'PreSleep','PostSleep'})
ylabel('% (/ total sleep)')
ylim([0 20])
makepretty

subplot(334), v=MakeViolinPlot_MC({totDur_WAKE_pre totDur_TOTsleep_pre totDur_WAKE_post totDur_TOTsleep_post},...
    {[0 0 0.8],[0 0 0 ],[0 0 0.8],[0 0 0 ]},[1:2,4:5],{},showPoint);
v{1}.violinAlpha=0.3
v{2}.violinAlpha=0.3
xticks([1.5, 4.5]); xticklabels({'PreSleep','PostSleep'})
ylabel('Total duration (hour)')
makepretty

subplot(335), v=MakeViolinPlot_MC({totDur_SWS_pre totDur_REM_pre totDur_SWS_post totDur_REM_post},...
    {[0.2 0.2 0.2],[1 0 0],[0.2 0.2 0.2],[1 0 0]},[1:2,4:5],{},showPoint);
v{1}.violinAlpha=0.3
v{2}.violinAlpha=0.3
xticks([1.5, 4.5]); xticklabels({'PreSleep','PostSleep'})
ylabel('Total duration (hour)')
makepretty




subplot(336), v=MakeViolinPlot_MC({durWAKE_pre durSWS_pre durREM_pre durWAKE_post durSWS_post durREM_post},...
    {[0 0 0.8],[0.2 0.2 0.2],[1 0 0],[0 0 0.8],[0.2 0.2 0.2],[1 0 0]},[1:3,5:7],{},showPoint);
v{1}.violinAlpha=0.3
v{2}.violinAlpha=0.3
v{3}.violinAlpha=0.3
xticks([2,5]); xticklabels({'PreSleep','PostSleep'})
ylabel('Mean duration of bouts (s)')
makepretty



subplot(337), v=MakeViolinPlot_MC({NumWAKE_pre NumSWS_pre NumREM_pre NumWAKE_post NumSWS_post NumREM_post},...
    {[0 0 0.8],[0.2 0.2 0.2],[1 0 0], [0 0 0.8],[0.2 0.2 0.2],[1 0 0]},[1:3,5:7],{},showPoint);
v{1}.violinAlpha=0.3
v{2}.violinAlpha=0.3
v{3}.violinAlpha=0.3
xticks([2,5]); xticklabels({'PreSleep','PostSleep'})
ylabel('Numbers of bouts')
makepretty

% 
% subplot(338), MakeViolinPlot_MC({firstSWS_basal firstREM_basal},{[0.2 0.2 0.2],[1 0 0]},[1:2],{'NREM','REM'},showPoint);
% ylabel('Latency (hour)')
% ylim([0 5])
% makepretty