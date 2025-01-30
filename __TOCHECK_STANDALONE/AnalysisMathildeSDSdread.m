% AnalysisMathildeSDSdread

clear 

load('/Users/karimbenchenane/Dropbox/Mobs_member/MathildeChouvaeff/KB_data/all_data_workspace_SD_retro_cre.mat')

%%

figure('color',[1 1 1]), 

subplot(1,3,1), hold on, xlim([0 9]), ylabel('REM, percentage')

plot(nanmean(data_perc_REM_basal),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','k','color','k'), hold on
errorbar(nanmean(data_perc_REM_basal), stdError(data_perc_REM_basal),'color','k')

plot(nanmean(data_perc_REM_SD),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','r','color','r'), hold on
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'color','r')

plot(nanmean(data_perc_REM_SD_inhib),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','b','color','b'), hold on
errorbar(nanmean(data_perc_REM_SD_inhib), stdError(data_perc_REM_SD_inhib),'color','b')

plot(nanmean(data_perc_REM_SD_mCherry),'linestyle','-','linewidth',2,'marker','o','markerfacecolor',[0.7 0.7 0.7],'color',[0.7 0.7 0.7]), hold on
errorbar(nanmean(data_perc_REM_SD_mCherry), stdError(data_perc_REM_SD_mCherry),'color',[0.7 0.7 0.7])

subplot(1,3,2), hold on, xlim([0 9]), ylabel('REM, mean duration'),

plot(nanmean(data_dur_REM_basal),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','k','color','k'), hold on
errorbar(nanmean(data_dur_REM_basal), stdError(data_dur_REM_basal),'color','k')

plot(nanmean(data_dur_REM_SD),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','r','color','r'), hold on
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'color','r')

plot(nanmean(data_dur_REM_SD_inhib),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','b','color','b'), hold on
errorbar(nanmean(data_dur_REM_SD_inhib), stdError(data_dur_REM_SD_inhib),'color','b')

plot(nanmean(data_dur_REM_SD_mCherry),'linestyle','-','linewidth',2,'marker','o','markerfacecolor',[0.7 0.7 0.7],'color',[0.7 0.7 0.7]), hold on
errorbar(nanmean(data_dur_REM_SD_mCherry), stdError(data_dur_REM_SD_mCherry),'color',[0.7 0.7 0.7])

subplot(1,3,3), hold on, xlim([0 9]), ylabel('REM, number')

plot(nanmean(data_num_REM_basal),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','k','color','k'), hold on
errorbar(nanmean(data_num_REM_basal), stdError(data_dur_REM_basal),'color','k')

plot(nanmean(data_num_REM_SD),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','r','color','r'), hold on
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'color','r')

plot(nanmean(data_num_REM_SD_inhib),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','b','color','b'), hold on
errorbar(nanmean(data_num_REM_SD_inhib), stdError(data_num_REM_SD_inhib),'color','b')

plot(nanmean(data_num_REM_SD_mCherry),'linestyle','-','linewidth',2,'marker','o','markerfacecolor',[0.7 0.7 0.7],'color',[0.7 0.7 0.7]), hold on
errorbar(nanmean(data_num_REM_SD_mCherry), stdError(data_num_REM_SD_mCherry),'color',[0.7 0.7 0.7])


%%


figure('color',[1 1 1]), 

subplot(1,3,1), hold on, xlim([0 9]), ylabel('Percentage')

plot(nanmean(data_perc_WAKE_basal),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','k','color','k'), hold on
errorbar(nanmean(data_perc_WAKE_basal), stdError(data_perc_WAKE_basal),'color','k')

plot(nanmean(data_perc_WAKE_SD),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','r','color','r'), hold on
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'color','r')

plot(nanmean(data_perc_WAKE_SD_inhib),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','b','color','b'), hold on
errorbar(nanmean(data_perc_WAKE_SD_inhib), stdError(data_perc_WAKE_SD_inhib),'color','b')

plot(nanmean(data_perc_WAKE_SD_mCherry),'linestyle','-','linewidth',2,'marker','o','markerfacecolor',[0.7 0.7 0.7],'color',[0.7 0.7 0.7]), hold on
errorbar(nanmean(data_perc_WAKE_SD_mCherry), stdError(data_perc_WAKE_SD_mCherry),'color',[0.7 0.7 0.7])

subplot(1,3,2), hold on, xlim([0 9]), ylabel('SWS, Percentage'),

plot(nanmean(data_perc_SWS_basal),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','k','color','k'), hold on
errorbar(nanmean(data_perc_SWS_basal), stdError(data_perc_SWS_basal),'color','k')

plot(nanmean(data_perc_SWS_SD),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','r','color','r'), hold on
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'color','r')

plot(nanmean(data_perc_SWS_SD_inhib),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','b','color','b'), hold on
errorbar(nanmean(data_perc_SWS_SD_inhib), stdError(data_perc_SWS_SD_inhib),'color','b')

plot(nanmean(data_perc_SWS_SD_mCherry),'linestyle','-','linewidth',2,'marker','o','markerfacecolor',[0.7 0.7 0.7],'color',[0.7 0.7 0.7]), hold on
errorbar(nanmean(data_perc_SWS_SD_mCherry), stdError(data_perc_SWS_SD_mCherry),'color',[0.7 0.7 0.7])

subplot(1,3,3), hold on, xlim([0 9]), ylabel('REM, Percentage')

plot(nanmean(data_perc_REM_basal),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','k','color','k'), hold on
errorbar(nanmean(data_perc_REM_basal), stdError(data_perc_REM_basal),'color','k')

plot(nanmean(data_perc_REM_SD),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','r','color','r'), hold on
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'color','r')

plot(nanmean(data_perc_REM_SD_inhib),'linestyle','-','linewidth',2,'marker','o','markerfacecolor','b','color','b'), hold on
errorbar(nanmean(data_perc_REM_SD_inhib), stdError(data_perc_REM_SD_inhib),'color','b')

plot(nanmean(data_perc_REM_SD_mCherry),'linestyle','-','linewidth',2,'marker','o','markerfacecolor',[0.7 0.7 0.7],'color',[0.7 0.7 0.7]), hold on
errorbar(nanmean(data_perc_REM_SD_mCherry), stdError(data_perc_REM_SD_mCherry),'color',[0.7 0.7 0.7])




%%


figure('color',[1 1 1]), 
a=1;subplot(7,1,a), SleepStages=PlotSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);title('Basal'), xlim([0 3E4])
a=2;subplot(7,1,a), SleepStages=PlotSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])
a=3;subplot(7,1,a), SleepStages=PlotSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])
a=4;subplot(7,1,a), SleepStages=PlotSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])
a=5;subplot(7,1,a), SleepStages=PlotSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])
a=6;subplot(7,1,a), SleepStages=PlotSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])


figure('color',[1 1 1]), 
a=1;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);title('SD'), xlim([0 3E4])
a=2;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=3;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=4;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=5;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=6;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=7;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])


figure('color',[1 1 1]), 
a=1;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);title('SD DREAD CNO'), xlim([0 3E4])
a=2;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=3;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=4;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=5;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=6;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=7;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])


figure('color',[1 1 1])
a=1;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0); title('SD mCherry CNO'), xlim([0 3E4])
a=2;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=3;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=4;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=5;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=6;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=7;subplot(7,1,a), SleepStages=PlotSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])

%%



figure('color',[1 1 1]), 
a=1;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);title('Basal'), xlim([0 3E4])
a=2;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])
a=3;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])
a=4;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])
a=5;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])
a=6;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_basal{1,a}.Wake,stages_basal{1,a}.SWSEpoch,stages_basal{1,a}.REMEpoch,0);xlim([0 3E4])


figure('color',[1 1 1]), 
a=1;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);title('SD'), xlim([0 3E4])
a=2;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=3;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=4;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=5;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=6;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])
a=7;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD{1,a}.Wake,stages_SD{1,a}.SWSEpoch,stages_SD{1,a}.REMEpoch,0);xlim([0 3E4])


figure('color',[1 1 1]), 
a=1;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);title('SD DREAD CNO'), xlim([0 3E4])
a=2;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=3;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=4;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=5;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=6;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])
a=7;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_inhib{1,a}.Wake,stages_SD_inhib{1,a}.SWSEpoch,stages_SD_inhib{1,a}.REMEpoch,0);xlim([0 3E4])


figure('color',[1 1 1])
a=1;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0); title('SD mCherry CNO'), xlim([0 3E4])
a=2;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=3;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=4;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=5;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=6;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])
a=7;subplot(7,1,a), SleepStages=PlotCleanSleepStage(stages_SD_mCherry{1,a}.Wake,stages_SD_mCherry{1,a}.SWSEpoch,stages_SD_mCherry{1,a}.REMEpoch,0);xlim([0 3E4])



%%


figure, 
subplot(1,4,1), hold on
for i=1:6
    stairs(cumsum(DurationEpoch(stages_basal{1,i}.REMEpoch)/1E3),'k','linewidth',2)
end
line([0 80],[0 3E4],'color','k'), line([0 50],[0 3E4],'color','k')
subplot(1,4,2), hold on
for i=1:7
    stairs(cumsum(DurationEpoch(stages_SD{1,i}.REMEpoch)/1E3),'r','linewidth',2)
end
line([0 80],[0 3E4],'color','k'), line([0 50],[0 3E4],'color','k')
subplot(1,4,3), hold on
for i=1:7
    stairs(cumsum(DurationEpoch(stages_SD_inhib{1,i}.REMEpoch)/1E3),'b','linewidth',2)
end
line([0 80],[0 3E4],'color','k'), line([0 50],[0 3E4],'color','k')
subplot(1,4,4), hold on
for i=1:7
    stairs(cumsum(DurationEpoch(stages_SD_mCherry{1,i}.REMEpoch)/1E3),'color',[0.7 0.7 0.7],'linewidth',2)
end
line([0 80],[0 3E4],'color','k'), line([0 45],[0 3E4],'color','k')



figure,
subplot(2,4,1), hold on
for i=1:6
    stairs(cumsum(DurationEpoch(stages_basal{1,i}.REMEpoch)/1E3),'k','linewidth',2)
end
line([0 80],[0 3E4],'color','k'), line([0 50],[0 3E4],'color','k'), title('basal')
subplot(2,4,2), hold on
for i=1:7
    stairs(cumsum(DurationEpoch(stages_SD{1,i}.REMEpoch)/1E3),'r','linewidth',2)
end
line([0 80],[0 3E4],'color','k'), line([0 50],[0 3E4],'color','k'), title('SD')
subplot(2,4,3), hold on
for i=1:7
    stairs(cumsum(DurationEpoch(stages_SD_inhib{1,i}.REMEpoch)/1E3),'b','linewidth',2)
end
line([0 80],[0 3E4],'color','k'), line([0 50],[0 3E4],'color','k'), title('SD Dread CNO')

subplot(2,4,4), hold on
for i=1:7
    stairs(cumsum(DurationEpoch(stages_SD_mCherry{1,i}.REMEpoch)/1E3),'color',[0.7 0.7 0.7],'linewidth',2)
end
line([0 80],[0 3E4],'color','k'), line([0 45],[0 3E4],'color','k'), title('SD mCherry CNO')

%%
subplot(2,4,5), hold on
for i=1:7
    try
        stairs(cumsum(DurationEpoch(stages_mCherry_saline{1,i}.REMEpoch)/1E3),'color',[0.7 0.7 0.7],'linewidth',2)
    end
end
line([0 80],[0 3E4],'color','k'), line([0 45],[0 3E4],'color','k'), title('SD mCherry Saline')

subplot(2,4,6), hold on
for i=1:7
    try
    stairs(cumsum(DurationEpoch(stages_BM_CNO{1,i}.REMEpoch)/1E3),'color',[0.7 0.7 0.7],'linewidth',2)
    end
end
line([0 80],[0 3E4],'color','k'), line([0 45],[0 3E4],'color','k'), title('SD BM CNO')

subplot(2,4,7), hold on
for i=1:7
    try
    stairs(cumsum(DurationEpoch(stages_safe{1,i}.REMEpoch)/1E3),'color',[1 0.8 0.7],'linewidth',2)
    end
end
line([0 80],[0 3E4],'color','k'), line([0 45],[0 3E4],'color','k'), title('SD safe')



%%

clear DurSC quantwake

 cho=1;ti='Basal';
% cho=2;ti='SD';
% cho=3;ti='DREAD';
% cho=4;ti='mCherry';

figure('color',[1 1 1]), numfig=gcf;
for i=1:7
    try
    limREM=5;
    
    switch cho
    case 1
    SWS=stages_basal{1,i}.SWSEpoch;
    Wake=stages_basal{1,i}.Wake;
    REM=stages_basal{1,i}.REMEpoch;
    case 2
    SWS=stages_SD{1,i}.SWSEpoch;
    Wake=stages_SD{1,i}.Wake;
    REM=stages_SD{1,i}.REMEpoch;
    case 3
    SWS=stages_SD_inhib{1,i}.SWSEpoch;
    Wake=stages_SD_inhib{1,i}.Wake;
    REM=stages_SD_inhib{1,i}.REMEpoch;
    case 4
    SWS=stages_SD_mCherry{1,i}.SWSEpoch;
    Wake=stages_SD_mCherry{1,i}.Wake;
    REM=stages_SD_mCherry{1,i}.REMEpoch;
    end

    stini=Start(REM);
    SleepStagesTemp=PlotSleepStage(Wake,SWS,REM,2);
    [Wake,TotalNoiseEpoch,Dur]=CleanWakeNoise(SleepStagesTemp,Wake);
%     [REM, Wake, idbad]=CleanREMEpoch(SleepStages,REM,Wake);
%     [SWS,REM,Wake]=CleanSWSREM(SleepStages,SWS,REM,Wake);
    
%--------------------------------------------------------------------
 REM=mergeCloseIntervals(REM,limREM*1E4);SWS=SWS-REM;Wake=Wake-REM;
%--------------------------------------------------------------------

    %[SleepCycle,SleepCycle2,SleepCycle3]=FindSleepCycles_KB(stages_basal{1,i}.Wake,stages_basal{1,i}.SWSEpoch,stages_basal{1,i}.REMEpoch,1);
    figure(numfig)
     subplot(7,2,2*i-1),
%    subplot(1,2,1),
    SleepStages=PlotSleepStage(Wake,SWS,REM,0);ylim([-1 4]),title(ti)
    %subplot(2,2,3),SleepStages2=PlotCleanSleepStage(Wake,SWS,REM,0);ylim([-1 4])
    %PlotDoSleepCycle2(Wake,SWS,REM,1,1,[2 5],SleepStages);
    
    st=Start(REM);
    %st=End(REM);

    dur=DurationEpoch(REM)/1E3;
    [BE,id]=sort(dur);
     subplot(7,2,2*i), 
%    subplot(1,2,2)
    hold on, title(['Number of REM episodes: ',num2str(length(st)), ', before cleaning:',num2str(length(stini))])
    for j=1:length(Start(REM))
        
         Epoch=intervalSet(st(id(j))-50E4,st(id(j))+200E4);
% Epoch=intervalSet(st(id(j))-10E4,st(id(j))+750E4);
 %       Epoch=intervalSet(st(id(j))-150E4,st(id(j))+750E4);

        EpochR=and(Epoch,REM);
        plot(Range(Restrict(SleepStages,Epoch),'s')-st(id(j))/1E4,Data(Restrict(SleepStages,Epoch))+j/10,'color',[0.7 0.7 0.7])
        plot(Range(Restrict(SleepStages,EpochR),'s')-st(id(j))/1E4,Data(Restrict(SleepStages,EpochR))+j/10,'r.')
    end
    yl=ylim;
    ylim([2.5 yl(2)])
    SleepCycle{i}=PlotDoSleepCycle2(Wake,SWS,REM,0,1,[2 5],SleepStages);subplot(4,1,1:3), title(ti)
    DurSC(i)=mean(DurationEpoch(SleepCycle{i},'s')/60);
    quantwake(i)=sum(DurationEpoch(and(Wake,intervalSet(0,4500E4))))/1E4;
    quantwake2(i,1)=sum(DurationEpoch(and(Wake,intervalSet(0,2000E4))))/1E4;
    quantwake2(i,2)=sum(DurationEpoch(and(Wake,intervalSet(0,4000E4))))/1E4;
    quantwake2(i,3)=sum(DurationEpoch(and(Wake,intervalSet(2000E4,4000E4))))/1E4;
    end
end


%%

% SleepStages=PlotSleepStage(stages_basal{1,i}.Wake,stages_basal{1,i}.SWSEpoch,stages_basal{1,i}.REMEpoch,1);
% j=0;
% j=j+1; xlim([st(j)/1E4-50, st(j)/1E4+150]), line([st(j) st(j)]/1E4,[-1.5 4.5])

    figure, 
    subplot(2,2,1), plot(quantwake/1E4,DurSC,'ko','markerfacecolor','k','markersize',10)
    subplot(2,2,2), plot(quantwake2(:,1)/1E4,DurSC,'ko','markerfacecolor','k','markersize',10)
    subplot(2,2,3), plot(quantwake2(:,2)/1E4,DurSC,'ko','markerfacecolor','k','markersize',10)
    subplot(2,2,4), plot(quantwake2(:,3)/1E4,DurSC,'ko','markerfacecolor','k','markersize',10)

if 0
    


    PlotErrorBar4(DurSC_basal,DurSC_SD,DurSC_dread,DurSC_mCherry)
    PlotErrorBar4(quantwake_basal,quantwake_SD,quantwake_Dread,quantwake_mCherry)
    
    figure, plot(quantwake_basal/1E4,DurSC_basal,'ko','markerfacecolor','k')
    hold on, plot(quantwake_mCherry/1E4,DurSC_mCherry,'o','color',[0.7 0.7 0.7],'markerfacecolor',[0.7 0.7 0.7])
    hold on, plot(quantwake_SD/1E4,DurSC_SD,'ro')
    xlim([0 0.5])

end

