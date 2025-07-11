%% dir
% DirCtrl=PathForExperiments_Opto_TG('PFC_Control_20Hz');
% DirOpto=PathForExperiments_Opto_TG('PFC_Stim_20Hz');
% DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [648 675 733 1074 1076 1109 1137]);

% DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [648 675 733 1109 1076 1136 1137]);
%%

DirCtrl=PathForExperiments_Opto_TG('Septum_Sham_20Hz');
DirOpto=PathForExperiments_Opto_TG('Septum_Stim_20Hz');

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
    a{i}.REMEpochWiNoise = mergeCloseIntervals(a{i}.REMEpochWiNoise,1E4);
    a{i}.SWSEpochWiNoise = a{i}.SWSEpochWiNoise - a{i}.REMEpochWiNoise;
    a{i}.WakeWiNoise = a{i}.WakeWiNoise - a{i}.REMEpochWiNoise;

    SleepStages{i} = PlotSleepStage(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise,0); close

%     [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC; % all stims
%     [h,rg,vec]=HistoSleepStagesTransitionsMathilde_MC(SleepStages{i}, ts(StimREM), TimeWindow, 1); close % states percentage around stimulations
%     
    StimWithLongBout_ctrl{i} = FindOptoStimWithLongBout_MC(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise,state, MinDurBeforeStim);
    [h,rg,vec] = HistoSleepStagesTransitionsMathilde_MC(SleepStages{i}, ts(StimWithLongBout_ctrl{i}), TimeWindow, 1); close
    
    perc_aroundStim_ctrl{i} = h;
    perc_eveil_ctrl(:,i) = perc_aroundStim_ctrl{i}(:,1);
    perc_REM_ctrl(:,i) = perc_aroundStim_ctrl{i}(:,2);
    perc_SWS_ctrl(:,i) = perc_aroundStim_ctrl{i}(:,3);
end
% opto mice
for j=1:length(DirOpto.path)
    cd(DirOpto.path{j}{1});
    b{j} = load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
    b{j}.REMEpochWiNoise = mergeCloseIntervals(b{j}.REMEpochWiNoise,1E4);
    b{j}.SWSEpochWiNoise = b{j}.SWSEpochWiNoise - b{j}.REMEpochWiNoise;
    b{j}.WakeWiNoise = b{j}.WakeWiNoise - b{j}.REMEpochWiNoise;

    SleepStages_opto{j} = PlotSleepStage(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise,0); close
    
%     [Stim_opto, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
%     [h,rg,vec]=HistoSleepStagesTransitionsMathilde_MC(SleepStages_opto{j}, ts(StimREM), TimeWindow, 1); close

    StimWithLongBout_opto{j} = FindOptoStimWithLongBout_MC(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise,state, MinDurBeforeStim);
    [h,rg,vec] = HistoSleepStagesTransitionsMathilde_MC(SleepStages_opto{j}, ts(StimWithLongBout_opto{j}), TimeWindow, 1); close

    perc_aroundStim_opto{j} = h;    
    perc_eveil_opto(:,j) = perc_aroundStim_opto{j}(:,1);
    perc_REM_opto(:,j) = perc_aroundStim_opto{j}(:,2);
    perc_SWS_opto(:,j) = perc_aroundStim_opto{j}(:,3);
end

% calculate SEM
SEMperc_REM = nanstd(perc_REM_ctrl')/sqrt(size(perc_REM_ctrl,2));
SEMperc_SWS = nanstd(perc_SWS_ctrl')/sqrt(size(perc_SWS_ctrl,2));
SEMperc_eveil = nanstd(perc_eveil_ctrl')/sqrt(size(perc_eveil_ctrl,2));
SEMperc_REM_opto = nanstd(perc_REM_opto')/sqrt(size(perc_REM_opto,2)); 
SEMperc_SWS_opto = nanstd(perc_SWS_opto')/sqrt(size(perc_SWS_opto,2)); 
SEMperc_eveil_opto = nanstd(perc_eveil_opto')/sqrt(size(perc_eveil_opto,2));

%% figure

idxonset = find(TimeWindow==17);
idxduring = find(TimeWindow==30);
idxbefore = find(TimeWindow==-20);

figure, subplot(131),shadedErrorBar(TimeWindow,nanmean(perc_REM_opto,2),SEMperc_REM_opto,'g',1), hold on,
shadedErrorBar(TimeWindow,nanmean(perc_REM_ctrl,2),SEMperc_REM,'k',1)
line([0 0],[0 100],'color','k','linestyle',':')
ylim([0 100]); ylabel('Percentage of REM (%)')
xlim([-10 60]); xlabel('Time (s)')
makepretty
ax1 =gca;
ax2 = axes('Position',[.245 .73 .1 .2]);
box on
PlotErrorBarN_KJ({nanmean(perc_REM_ctrl(idxonset:idxduring,:)) nanmean(perc_REM_opto(idxonset:idxduring,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
makepretty
box off

subplot(132),shadedErrorBar(TimeWindow,nanmean(perc_SWS_opto,2),SEMperc_SWS_opto,'r',1), hold on,
shadedErrorBar(TimeWindow,nanmean(perc_SWS_ctrl,2),SEMperc_SWS,'k',1)
line([0 0],[0 100],'color','k','linestyle',':')

ylim([0 100]); ylabel('Percentage of NREM (%)')
xlim([-10 60]); xlabel('Time (s)')
makepretty
ax1 =gca;

ax2 = axes('Position',[.5235 .13 .1 .2]);
box on
PlotErrorBarN_KJ({nanmean(perc_SWS_ctrl(idxonset:idxduring,:)) nanmean(perc_SWS_opto(idxonset:idxduring,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
makepretty
box off

subplot(133),shadedErrorBar(TimeWindow,nanmean(perc_eveil_opto,2),SEMperc_eveil_opto,'b',1), hold on,
shadedErrorBar(TimeWindow,nanmean(perc_eveil_ctrl,2),SEMperc_eveil,'k',1)
line([0 0],[0 100],'color','k','linestyle',':')
ylim([0 100]); ylabel('Percentage of wakefulness (%)')
xlim([-10 60]); xlabel('Time (s)')
makepretty
ax1 =gca;

ax2 = axes('Position',[.7635 .73 .1 .2]);
box on
PlotErrorBarN_KJ({nanmean(perc_eveil_ctrl(idxonset:idxduring,:)) nanmean(perc_eveil_opto(idxonset:idxduring,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2]); xticklabels({'Ctrl','ChR2'})
makepretty
box off

