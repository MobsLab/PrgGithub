%% dir
DirCtrl = PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirCtrl = RestrictPathForExperiment(DirCtrl, 'nMice', [1075 1111 1112 1180 1181]);

DirOpto = PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [675 733 1074 1136 1076 1137]);% 648 1109

%% parameters
state = 'rem'; % to select in which state stimulations occured
TimeWindow = -60:1:60; % time window around stimulations
MinDurBeforeStim = 5; % minimal duration of bouts before stim onset (in sec)

%% get data
number=1;
for i=1:length(DirCtrl.path)
    cd(DirCtrl.path{i}{1});
    %%load subtages and rename variables
    substage_ctrl{i} = load('SleepSubstages');
    N1{i} = substage_ctrl{i}.Epoch{1};
    N2{i} = substage_ctrl{i}.Epoch{2};
    N3{i} = substage_ctrl{i}.Epoch{3};
    REMEpoch{i} = substage_ctrl{i}.Epoch{4};
    Wake{i} = substage_ctrl{i}.Epoch{5};
    SWSEpoch{i} = substage_ctrl{i}.Epoch{7};
    
    %%compute hypnogramme
    SleepSubStage{i} = PlotSleepSubStage_MC(N1{i},N2{i},N3{i},REMEpoch{i},Wake{i},SWSEpoch{i},1); %close
    
    %%find stimulations
    %%with minimum duraton of the state before the stim onset
%     StimWithLongBout_ctrl{i} = FindOptoStimWithLongBout_SubStages_MC(N1{i},N2{i},N3{i},REMEpoch{i},Wake{i},state, MinDurBeforeStim);
    %%all stimulations in the given state
    [Stim{i}, StimREM{i}, StimN1{i}, StimN2{i}, StimN3{i}, StimWake{i}, Stimts{i}] = FindOptoStim_SubStages_MC(N1{i},N2{i},N3{i},REMEpoch{i},Wake{i});

    %%compute percentage of each substage around the stimulations
    [hREM,rgREM,vecREM] = HistoSleepStagesTransitionsMathildeKB_MC(SleepSubStage{i}, ts(StimREM{i}),TimeWindow,0); %close
 
    %%store data for all mice
    H_REM{i}=hREM;
    perc_Wake(:,i)=H_REM{i}(:,1);
    perc_REM(:,i)=H_REM{i}(:,2);
    perc_N1(:,i)=H_REM{i}(:,3);
    perc_N2(:,i)=H_REM{i}(:,4);
    perc_N3(:,i)=H_REM{i}(:,5);
end

%%
numberOpto=1;
for j=1:length(DirOpto.path)
    cd(DirOpto.path{j}{1});
    %%load substage and rename variables
    substage_opto{j} = load('SleepSubstages');
    N1{j} = substage_opto{j}.Epoch{1};
    N2{j}=substage_opto{j}.Epoch{2};
    N3{j}=substage_opto{j}.Epoch{3};
    REMEpoch{j}=substage_opto{j}.Epoch{4};
    Wake{j}=substage_opto{j}.Epoch{5};
    SWSEpoch{j}=substage_opto{j}.Epoch{7};
    
    %%compute hypnogramme
    SleepSubStage{j}=PlotSleepSubStage_MC(N1{j},N2{j},N3{j},REMEpoch{j},Wake{j},SWSEpoch{j},1); %close
    
    %%find stimulations
    %%with minimum duraton of the state before the stim onset
%     StimWithLongBout_opto{j} = FindOptoStimWithLongBout_SubStages_MC(N1{j},N2{j},N3{j},REMEpoch{j},Wake{j},state, MinDurBeforeStim);
    %%all stimulations in the given state
    [Stim{j}, StimREM{j}, StimN1{j}, StimN2{j}, StimN3{j}, StimWake{j}, Stimts{j}] = FindOptoStim_SubStages_MC(N1{j},N2{j},N3{j},REMEpoch{j},Wake{j});
    
    %%compute percentage of each substage around the stimulations
    [hREM,rgREM,vecREM]=HistoSleepStagesTransitionsMathildeKB_MC(SleepSubStage{j},ts(StimREM{j}),TimeWindow,1); %close
    
    %%store data for all mice
    H_REMopto{j}=hREM;
    perc_WakeOpto(:,j)=H_REMopto{j}(:,1);
    perc_REMopto(:,j)=H_REMopto{j}(:,2);
    perc_N1opto(:,j)=H_REMopto{j}(:,3);
    perc_N2opto(:,j)=H_REMopto{j}(:,4);
    perc_N3opto(:,j)=H_REMopto{j}(:,5);
end

% %%
% figure
% plot(perc_N1(:,imouse))
% hold on
% plot(perc_N2(:,imouse))
% plot(perc_N3(:,imouse))
% plot(perc_REM(:,imouse))
% plot(perc_Wake(:,imouse))
% legend({'N1','N2','N3','REM','WAKE'})
% 
% %%
% imouse=imouse+1;
% figure
% plot(perc_N1opto(:,imouse))
% hold on
% plot(perc_N2opto(:,imouse))
% plot(perc_N3opto(:,imouse))
% plot(perc_REMopto(:,imouse))
% plot(perc_WakeOpto(:,imouse))
% legend({'N1','N2','N3','REM','WAKE'})


%% calculate SEM
% SEMperc_REM=nanstd(perc_REM')/sqrt(size(perc_REM(~isnan(perc_REM')),1));
% 
% 
% SEMperc_REM=nanstd(perc_REM')/sqrt(length(perc_REM(~isnan(perc_REM'))));
% 
% 
% 
% SEMperc_Wake=nanstd(perc_Wake')/sqrt(length(perc_Wake(~isnan(perc_Wake'))));
% 
% SEMperc_N1=nanstd(perc_N1')/sqrt(length(perc_N1(~isnan(perc_N1'))));
% SEMperc_N2=nanstd(perc_N2')/sqrt(length(perc_N2(~isnan(perc_N2'))));
% SEMperc_N3=nanstd(perc_N3')/sqrt(length(perc_N3(~isnan(perc_N3'))));
% 
% 
% SEMperc_REMopto=nanstd(perc_REMopto')/sqrt(length(perc_REMopto(~isnan(perc_REMopto'))));
% SEMperc_WakeOpto=nanstd(perc_WakeOpto')/sqrt(length(perc_WakeOpto(~isnan(perc_WakeOpto'))));
% 
% SEMperc_N1opto=nanstd(perc_N1opto')/sqrt(length(perc_N1opto(~isnan(perc_N1opto'))));
% SEMperc_N2opto=nanstd(perc_N2opto')/sqrt(length(perc_N2opto(~isnan(perc_N2opto'))));
% SEMperc_N3opto=nanstd(perc_N3opto')/sqrt(length(perc_N3opto(~isnan(perc_N3opto'))));

SEMperc_REM=nanstd(perc_REM');
SEMperc_Wake=nanstd(perc_Wake');

SEMperc_N1=nanstd(perc_N1');
SEMperc_N2=nanstd(perc_N2');
SEMperc_N3=nanstd(perc_N3');


SEMperc_REMopto=nanstd(perc_REMopto');
SEMperc_WakeOpto=nanstd(perc_WakeOpto');

SEMperc_N1opto=nanstd(perc_N1opto');
SEMperc_N2opto=nanstd(perc_N2opto');
SEMperc_N3opto=nanstd(perc_N3opto');

%%
figure,subplot(151),
shadedErrorBar(TimeWindow,perc_REMopto',{@nanmean,@stdError},'r',1), hold on
shadedErrorBar(TimeWindow,perc_REM',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('percentage (%)')
xlabel('Time (s)')
title('REM')

subplot(152),shadedErrorBar(TimeWindow,perc_N1opto',{@nanmean,@stdError},'b',1), hold on,
shadedErrorBar(TimeWindow,perc_N1',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('percentage (%)')
xlabel('Time (s)')
title('N1')

subplot(153),shadedErrorBar(TimeWindow,perc_N2opto',{@nanmean,@stdError},'b',1), hold on,
shadedErrorBar(TimeWindow,perc_N2',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('percentage (%)')
xlabel('Time (s)')
title('N2')

subplot(154),shadedErrorBar(TimeWindow,perc_N3opto',{@nanmean,@stdError},'b',1), hold on,
shadedErrorBar(TimeWindow,perc_N3',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('percentage (%)')
xlabel('Time (s)')
title('N3')

subplot(155),
shadedErrorBar(TimeWindow,perc_WakeOpto',{@nanmean,@stdError},'k',1), hold on,
shadedErrorBar(TimeWindow,perc_Wake',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('percentage (%)')
xlabel('Time (s)')
title('Wake')

suptitle('states percentage before and during opto stim during *REM SLEEP*')


%% figure
%%traces for each mice
figure,
subplot(3,5,1),
plot(TimeWindow,perc_REMopto,'color',[1 0 0]), hold on
plot(TimeWindow,perc_REM,'color',[.6 .6 .6])
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('REM')
makepretty

subplot(3,5,2),
plot(TimeWindow,perc_N1opto,'color',[0 0 1]), hold on,
plot(TimeWindow,perc_N1,'color',[.6 .6 .6])
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('N1')
makepretty

subplot(3,5,3),
plot(TimeWindow,perc_N2opto,'color',[0 0 1]), hold on,
plot(TimeWindow,perc_N2,'color',[.6 .6 .6])
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('N2')
makepretty

subplot(3,5,4),
plot(TimeWindow,perc_N3opto,'color',[0 0 1]), hold on,
plot(TimeWindow,perc_N3,'color',[.6 .6 .6])
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('N3')
makepretty

subplot(3,5,5),
plot(TimeWindow,perc_WakeOpto,'color',[0 0 0]), hold on,
plot(TimeWindow,perc_Wake,'color',[.6 .6 .6])
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('Wake')
makepretty


%%%%%%

%%average
subplot(3,5,6),
s1=shadedErrorBar(TimeWindow,perc_REMopto',{@nanmean,@stdError},'r',1), hold on
s2=shadedErrorBar(TimeWindow,perc_REM',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('REM')
makepretty

subplot(3,5,7),shadedErrorBar(TimeWindow,perc_N1opto',{@nanmean,@stdError},'b',1), hold on,
shadedErrorBar(TimeWindow,perc_N1',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('N1')
makepretty

subplot(3,5,8),shadedErrorBar(TimeWindow,perc_N2opto',{@nanmean,@stdError},'b',1), hold on,
shadedErrorBar(TimeWindow,perc_N2',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('N2')
makepretty

subplot(3,5,9),shadedErrorBar(TimeWindow,perc_N3opto',{@nanmean,@stdError},'b',1), hold on,
shadedErrorBar(TimeWindow,perc_N3',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('N3')
makepretty

subplot(3,5,10),
shadedErrorBar(TimeWindow,perc_WakeOpto',{@nanmean,@stdError},'k',1), hold on,
shadedErrorBar(TimeWindow,perc_Wake',{@nanmean,@stdError},':k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-60 60])
ylabel('Percentage (%)')
xlabel('Time (s)')
title('Wake')
makepretty


%%%%%
%%mean box plot
%%colors
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

col_pre_opto = [.3 .3 .3];
col_post_opto = [.3 .3 .3];

st_bef = 30;
en_bef = 60;

st_dur = 61;%61
en_dur = 90;%90

subplot(3,5,11)
MakeSpreadAndBoxPlot2_SB({nanmean(perc_REM(st_bef:en_bef,:)) nanmean(perc_REMopto(st_bef:en_bef,:)) nanmean(perc_REM(st_dur:en_dur,:)) nanmean(perc_REMopto(st_dur:en_dur,:))},...
    {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:4],{},'paired',0,'optiontest','ranksum');
xticks([1.5 3.5]); xticklabels({'Before','During'})
ylabel('Percentage (%)')

subplot(3,5,12)
MakeSpreadAndBoxPlot2_SB({nanmean(perc_N1(st_bef:en_bef,:)) nanmean(perc_N1opto(st_bef:en_bef,:)) nanmean(perc_N1(st_dur:en_dur,:)) nanmean(perc_N1opto(st_dur:en_dur,:))},...
    {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:4],{},'paired',0,'optiontest','ranksum');
xticks([1.5 3.5]); xticklabels({'Before','During'})
ylabel('Percentage (%)')

subplot(3,5,13)
MakeSpreadAndBoxPlot2_SB({nanmean(perc_N2(st_bef:en_bef,:)) nanmean(perc_N2opto(st_bef:en_bef,:)) nanmean(perc_N2(st_dur:en_dur,:)) nanmean(perc_N2opto(st_dur:en_dur,:))},...
    {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:4],{},'paired',0,'optiontest','ranksum');
xticks([1.5 3.5]); xticklabels({'Before','During'})
ylabel('Percentage (%)')

subplot(3,5,14)
MakeSpreadAndBoxPlot2_SB({nanmean(perc_N3(st_bef:en_bef,:)) nanmean(perc_N3opto(st_bef:en_bef,:)) nanmean(perc_N3(st_dur:en_dur,:)) nanmean(perc_N3opto(st_dur:en_dur,:))},...
    {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:4],{},'paired',0,'optiontest','ranksum');
xticks([1.5 3.5]); xticklabels({'Before','During'})
ylabel('Percentage (%)')

subplot(3,5,15)
MakeSpreadAndBoxPlot2_SB({nanmean(perc_Wake(st_bef:en_bef,:)) nanmean(perc_WakeOpto(st_bef:en_bef,:)) nanmean(perc_Wake(st_dur:en_dur,:)) nanmean(perc_WakeOpto(st_dur:en_dur,:))},...
    {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:4],{},'paired',0,'optiontest','ranksum');
xticks([1.5 3.5]); xticklabels({'Before','During'})
ylabel('Percentage (%)')





%%
% %% figures
% col_pre_basal = [0.8 0.8 0.8];
% col_post_basal = [0.8 0.8 0.8];
% 
% % col_pre_opto = [0 .6 1];
% % col_post_opto = [0 .6 1];
% col_pre_opto = [.3 .3 .3];
% col_post_opto = [.3 .3 .3];
% 
% st_bef = 30;
% en_bef = 60;
% 
% st_dur = 62;
% en_dur = 90;
% 
% figure
% subplot(151)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_REM(st_bef:en_bef,:)) nanmean(perc_REMopto(st_bef:en_bef,:)) nanmean(perc_REM(st_dur:en_dur,:)) nanmean(perc_REMopto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
% title('REM')
% 
% subplot(152)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_N1(st_bef:en_bef,:)) nanmean(perc_N1opto(st_bef:en_bef,:)) nanmean(perc_N1(st_dur:en_dur,:)) nanmean(perc_N1opto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
% title('N1')
% 
% subplot(153)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_N2(st_bef:en_bef,:)) nanmean(perc_N2opto(st_bef:en_bef,:)) nanmean(perc_N2(st_dur:en_dur,:)) nanmean(perc_N2opto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
% title('N2')
% 
% subplot(154)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_N3(st_bef:en_bef,:)) nanmean(perc_N3opto(st_bef:en_bef,:)) nanmean(perc_N3(st_dur:en_dur,:)) nanmean(perc_N3opto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
% title('N3')
% 
% subplot(155)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_Wake(st_bef:en_bef,:)) nanmean(perc_WakeOpto(st_bef:en_bef,:)) nanmean(perc_Wake(st_dur:en_dur,:)) nanmean(perc_WakeOpto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
% title('Wake')
% 
% 
% 
% %%
% 
% figure,subplot(2,5,1),
% s1=shadedErrorBar(TimeWindow,nanmean(perc_REMopto,2),SEMperc_REMopto,'r',1), hold on
% s2=shadedErrorBar(TimeWindow,nanmean(perc_REM,2),SEMperc_REM,':k',1)
% line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
% ylim([0 100])
% xlim([-60 60])
% ylabel('percentage (%)')
% xlabel('Time (s)')
% title('REM')
% makepretty
% 
% subplot(2,5,2),shadedErrorBar(TimeWindow,nanmean(perc_N1opto,2),SEMperc_N1opto,'b',1), hold on,
% shadedErrorBar(TimeWindow,nanmean(perc_N1,2),SEMperc_N1,':k',1)
% line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
% ylim([0 100])
% xlim([-60 60])
% ylabel('percentage (%)')
% xlabel('Time (s)')
% title('N1')
% makepretty
% 
% subplot(2,5,3),shadedErrorBar(TimeWindow,nanmean(perc_N2opto,2),SEMperc_N2opto,'b',1), hold on,
% shadedErrorBar(TimeWindow,nanmean(perc_N2,2),SEMperc_N2,':k',1)
% line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
% ylim([0 100])
% xlim([-60 60])
% ylabel('percentage (%)')
% xlabel('Time (s)')
% title('N2')
% makepretty
% 
% subplot(2,5,4),shadedErrorBar(TimeWindow,nanmean(perc_N3opto,2),SEMperc_N3opto,'b',1), hold on,
% shadedErrorBar(TimeWindow,nanmean(perc_N3,2),SEMperc_N3,':k',1)
% line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
% ylim([0 100])
% xlim([-60 60])
% ylabel('percentage (%)')
% xlabel('Time (s)')
% title('N3')
% makepretty
% 
% subplot(2,5,5),
% shadedErrorBar(TimeWindow,nanmean(perc_WakeOpto,2),SEMperc_WakeOpto,'k',1), hold on,
% shadedErrorBar(TimeWindow,nanmean(perc_Wake,2),SEMperc_Wake,':k',1)
% line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
% ylim([0 100])
% xlim([-60 60])
% ylabel('percentage (%)')
% xlabel('Time (s)')
% title('Wake')
% makepretty
% 
% % suptitle('states percentage before and during opto stim during *REM SLEEP*')
% 
% 
% %%%
% col_pre_basal = [0.8 0.8 0.8];
% col_post_basal = [0.8 0.8 0.8];
% 
% % col_pre_opto = [0 .6 1];
% % col_post_opto = [0 .6 1];
% col_pre_opto = [.3 .3 .3];
% col_post_opto = [.3 .3 .3];
% 
% st_bef = 30;
% en_bef = 60;
% 
% st_dur = 61;
% en_dur = 90;
% 
% % figure
% subplot(2,5,6)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_REM(st_bef:en_bef,:)) nanmean(perc_REMopto(st_bef:en_bef,:)) nanmean(perc_REM(st_dur:en_dur,:)) nanmean(perc_REMopto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
% 
% subplot(2,5,7)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_N1(st_bef:en_bef,:)) nanmean(perc_N1opto(st_bef:en_bef,:)) nanmean(perc_N1(st_dur:en_dur,:)) nanmean(perc_N1opto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
% 
% subplot(2,5,8)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_N2(st_bef:en_bef,:)) nanmean(perc_N2opto(st_bef:en_bef,:)) nanmean(perc_N2(st_dur:en_dur,:)) nanmean(perc_N2opto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
% 
% subplot(2,5,9)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_N3(st_bef:en_bef,:)) nanmean(perc_N3opto(st_bef:en_bef,:)) nanmean(perc_N3(st_dur:en_dur,:)) nanmean(perc_N3opto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
% 
% subplot(2,5,10)
% MakeSpreadAndBoxPlot_SB({nanmean(perc_Wake(st_bef:en_bef,:)) nanmean(perc_WakeOpto(st_bef:en_bef,:)) nanmean(perc_Wake(st_dur:en_dur,:)) nanmean(perc_WakeOpto(st_dur:en_dur,:))},...
%     {col_pre_basal col_pre_opto col_post_basal col_post_opto},[1:2,4:5],{},1,0);
% xticks([1.5 4.5]); xticklabels({'Before','During'})
% ylabel('Percentage (%)')
