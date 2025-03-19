%% dir
DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [675 733 1137 1136 648 1076]);%1109
DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [648 675 733 1076 1136 1137]);%   %1109 1074
% 
% 
% % DirCtrl=PathForExperiments_Opto_MC('Septum_Sham_20Hz');
% % DirOpto=PathForExperiments_Opto_MC('Septum_Stim_20Hz');
% 
% % DirCtrl=PathForExperiments_Opto_MC('SST_Sham_20Hz');
% % DirOpto=PathForExperiments_Opto_MC('SST_Stim_20Hz');
% 
% DirCtrl=PathForExperiments_Opto_MC('sham_wake');
% DirOpto=PathForExperiments_Opto_MC('stim_wake');


%% parameters
state = 'rem'; % to select in which state stimulations occured
TimeWindow = -60:1:60; % time window around stimulations
MinDurBeforeStim = 5; % minimal duration of bouts before stim onset (in sec)

%% get data
number=1;
for i=1:length(DirCtrl.path)
    cd(DirCtrl.path{i}{1});
    if exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    else
        a{i} = load('SleepScoring_Accelero.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    end
%     a{i}.REMEpochWiNoise = mergeCloseIntervals(a{i}.REMEpochWiNoise,1E4);
%     a{i}.SWSEpochWiNoise = a{i}.SWSEpochWiNoise - a{i}.REMEpochWiNoise;
%     a{i}.WakeWiNoise = a{i}.WakeWiNoise - a{i}.REMEpochWiNoise;
    
    SleepStages{i} = PlotSleepStage(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise,0); %close
    
    
%     [Stim{i}, StimREM{i}, StimSWS{i}, StimWake{i}, Stimts{i}] = FindOptoStim_MC(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise); % all stims
%     [h{i},rg{i},vec{i}]=HistoSleepStagesTransitionsMathilde_MC(SleepStages{i}, ts(StimREM{i}(1:length(StimREM{i})/2)), TimeWindow, 1); close % states percentage around stimulations
    %     [h{i},rg{i},vec{i}]=HistoSleepStagesTransitionsMathilde_MC(SleepStages{i}, ts(StimREM{i}(length(StimREM{i})/2:end)), TimeWindow, 1); close % states percentage around stimulations
    %     check{i}=StimREM{i}(1:length(StimREM{i})/2);
    
%         [Stim{i}, StimREM{i}, StimSWS{i}, StimWake{i}, Stimts{i}] = FindOptoStim_MC(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise); % all stims
%         [h{i},rg{i},vec{i}]=HistoSleepStagesTransitionsMathilde_MC(SleepStages{i}, ts(StimREM{i}), TimeWindow, 1); close % states percentage around stimulations
    
        StimWithLongBout_ctrl{i} = FindOptoStimWithLongBout_MC(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise,state, MinDurBeforeStim);
        [h{i},rg{i},vec{i}] = HistoSleepStagesTransitionsMathilde_MC(SleepStages{i}, ts(StimWithLongBout_ctrl{i}), TimeWindow, 0); %close
    
    perc_aroundStim_ctrl{i} = h{i};
    perc_eveil_ctrl(:,i) = perc_aroundStim_ctrl{i}(:,1);
    perc_REM_ctrl(:,i) = perc_aroundStim_ctrl{i}(:,2);
    perc_SWS_ctrl(:,i) = perc_aroundStim_ctrl{i}(:,3);
end



%% opto mice
for j=1:length(DirOpto.path)
    cd(DirOpto.path{j}{1});
    b{j} = load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
%     b{j}.REMEpochWiNoise = mergeCloseIntervals(b{j}.REMEpochWiNoise,1E4);
%     b{j}.SWSEpochWiNoise = b{j}.SWSEpochWiNoise - b{j}.REMEpochWiNoise;
%     b{j}.WakeWiNoise = b{j}.WakeWiNoise - b{j}.REMEpochWiNoise;

    SleepStages_opto{j} = PlotSleepStage(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise,0); %close
    
%     [Stim_opto{j}, StimREM_opto{j}, StimSWS_opto{j}, StimWake_opto{j}, Stimts_opto{j}] = FindOptoStim_MC(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise);
%     [h{j},rg{j},vec{j}]=HistoSleepStagesTransitionsMathilde_MC(SleepStages_opto{j}, ts(StimREM_opto{j}(1:length(StimREM_opto{j})/2)), TimeWindow, 1); %close
%     [h{j},rg{j},vec{j}]=HistoSleepStagesTransitionsMathilde_MC(SleepStages_opto{j}, ts(StimREM_opto{j}(length(StimREM_opto{j})/2:end)), TimeWindow, 1); %close
% check_opto{j}=StimREM_opto{j}(1:length(StimREM_opto{j})/2);


%     [Stim_opto{j}, StimREM_opto{j}, StimSWS_opto{j}, StimWake_opto{j}, Stimts_opto{j}] = FindOptoStim_MC(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise);
%     [h{j},rg{j},vec{j}]=HistoSleepStagesTransitionsMathilde_MC(SleepStages_opto{j}, ts(StimREM_opto{j}), TimeWindow, 1); %close

    StimWithLongBout_opto{j} = FindOptoStimWithLongBout_MC(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise,state, MinDurBeforeStim);
    [h{j},rg{j},vec{j}] = HistoSleepStagesTransitionsMathilde_MC(SleepStages_opto{j}, ts(StimWithLongBout_opto{j}), TimeWindow, 0); %close

    perc_aroundStim_opto{j} = h{j};    
    perc_eveil_opto(:,j) = perc_aroundStim_opto{j}(:,1);
    perc_REM_opto(:,j) = perc_aroundStim_opto{j}(:,2);
    perc_SWS_opto(:,j) = perc_aroundStim_opto{j}(:,3);
end

%%
% calculate SEM
SEMperc_REM = nanstd(perc_REM_ctrl')/sqrt(size(perc_REM_ctrl,2));
SEMperc_SWS = nanstd(perc_SWS_ctrl')/sqrt(size(perc_SWS_ctrl,2));
SEMperc_eveil = nanstd(perc_eveil_ctrl')/sqrt(size(perc_eveil_ctrl,2));
SEMperc_REM_opto = nanstd(perc_REM_opto')/sqrt(size(perc_REM_opto,2)); 
SEMperc_SWS_opto = nanstd(perc_SWS_opto')/sqrt(size(perc_SWS_opto,2)); 
SEMperc_eveil_opto = nanstd(perc_eveil_opto')/sqrt(size(perc_eveil_opto,2));

%% figure

idxonset = find(TimeWindow==0);%10
idxduring = find(TimeWindow==30);
idxbefore = find(TimeWindow==-30);


figure, 

subplot(231),
shadedErrorBar(TimeWindow,nanmean(perc_REM_opto,2),SEMperc_REM_opto,'r',1), hold on,
shadedErrorBar(TimeWindow,nanmean(perc_REM_ctrl,2),SEMperc_REM,':k',1)
line([0 0],[0 100],'color','k','linestyle',':')
ylim([0 100]); ylabel('Percentage of REM (%)')
xlim([-10 60]); xlabel('Time (s)')
makepretty
% ax1 =gca;
% ax2 = axes('Position',[.245 .73 .1 .2]);
% box on

subplot(234),
MakeSpreadAndBoxPlot2_SB({nanmean(perc_REM_ctrl(idxonset:idxduring,:)) nanmean(perc_REM_opto(idxonset:idxduring,:))},{[.8 .8 .8], [1 0 0]},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
ylim([0 100])
xticks([1:2]); xticklabels({'mCherry','ChR2'}); xtickangle(45)
makepretty
[h,p]=ttest2(nanmean(perc_REM_ctrl(idxonset:idxduring,:)), nanmean(perc_REM_opto(idxonset:idxduring,:)));
title(['p=', num2str(p)])

box off

subplot(132),
shadedErrorBar(TimeWindow,nanmean(perc_SWS_opto,2),SEMperc_SWS_opto,'b',1), hold on,
shadedErrorBar(TimeWindow,nanmean(perc_SWS_ctrl,2),SEMperc_SWS,':k',1)
line([0 0],[0 100],'color','k','linestyle',':')

ylim([0 100]); ylabel('Percentage of NREM (%)')
xlim([-10 60]); xlabel('Time (s)')
makepretty
ax1 =gca;

ax2 = axes('Position',[.5235 .73 .1 .2]);
box on
MakeSpreadAndBoxPlot2_SB({nanmean(perc_SWS_ctrl(idxonset:idxduring,:)) nanmean(perc_SWS_opto(idxonset:idxduring,:))},{[.8 .8 .8], [0 0 1]},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
ylim([0 100])
xticks([1:2]); xticklabels({'mCherry','ChR2'}); xtickangle(45)
makepretty
[h,p]=ttest2(nanmean(perc_SWS_ctrl(idxonset:idxduring,:)), nanmean(perc_SWS_opto(idxonset:idxduring,:)));
title(['p=', num2str(p)])

box off

subplot(133),
ax1 =gca;

ax2 = axes('Position',[.81 .73 .1 .2]);
box on
% PlotErrorBarN_KJ({nanmean(perc_eveil_ctrl(idxonset:idxduring,:)) nanmean(perc_eveil_opto(idxonset:idxduring,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
MakeSpreadAndBoxPlot2_SB({nanmean(perc_eveil_ctrl(idxonset:idxduring,:)) nanmean(perc_eveil_opto(idxonset:idxduring,:))},{[.8 .8 .8], [.2 .2 .2]},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');

ylim([0 100])
xticks([1:2]); xticklabels({'mCherry','ChR2'}); xtickangle(45)
makepretty
[h,p]=ttest2(nanmean(perc_eveil_ctrl(idxonset:idxduring,:)), nanmean(perc_eveil_opto(idxonset:idxduring,:)));
title(['p=', num2str(p)])

box off

figure
figureidxonset = find(TimeWindow==10);
idxduring = find(TimeWindow==30);
idxbefore = find(TimeWindow==-20);

col_off = [.8 .8 .8];
col_on = [.4 .8 1];


subplot(333),

PlotErrorBarN_KJ({nanmean(perc_REM_ctrl(idxonset:idxduring,:)) nanmean(perc_REM_opto(idxonset:idxduring,:))},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{[.8 .8 .8], [.4 .8 1]});
ylim([0 100])
xticks([1:2]); xticklabels({'mCherry','ChR2'}); xtickangle(45)
makepretty
[h,p]=ttest2(nanmean(perc_REM_ctrl(idxonset:idxduring,:)), nanmean(perc_REM_opto(idxonset:idxduring,:)));
title(['p=', num2str(p)])
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
box off

subplot(332),

PlotErrorBarN_KJ({nanmean(perc_SWS_ctrl(idxonset:idxduring,:)) nanmean(perc_SWS_opto(idxonset:idxduring,:))},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{[.8 .8 .8], [.4 .8 1]});
ylim([0 100])
xticks([1:2]); xticklabels({'mCherry','ChR2'}); xtickangle(45)
makepretty
% [p,h]=ranksum(nanmean(perc_SWS_ctrl(idxonset:idxduring,:)), nanmean(perc_SWS_opto(idxonset:idxduring,:)));

[h,p]=ttest2(nanmean(perc_SWS_ctrl(idxonset:idxduring,:)), nanmean(perc_SWS_opto(idxonset:idxduring,:)));
title(['p=', num2str(p)])
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end


subplot(331),
PlotErrorBarN_KJ({nanmean(perc_eveil_ctrl(idxonset:idxduring,:)) nanmean(perc_eveil_opto(idxonset:idxduring,:))},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2],'barcolors',{[.8 .8 .8], [.4 .8 1]});
    
ylim([0 100])
xticks([1:2]); xticklabels({'mCherry','ChR2'}); xtickangle(45)
makepretty
% [p,h]=ranksum(nanmean(perc_eveil_ctrl(idxonset:idxduring,:)), nanmean(perc_eveil_opto(idxonset:idxduring,:)));
[h,p]=ttest2(nanmean(perc_eveil_ctrl(idxonset:idxduring,:)), nanmean(perc_eveil_opto(idxonset:idxduring,:)));
title(['p=', num2str(p)])
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end

