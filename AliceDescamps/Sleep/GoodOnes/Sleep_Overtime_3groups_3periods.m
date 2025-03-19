%% To plot the figure you need to load data : 
Get_Data_4group_3periods.m

%%
txt_size = 15;

col_ctrl = [.7 .7 .7];
col_SD = [1 .2 0];
col_SD_mCherry_cno = [0 .4 .4];

isparam=0;
iscorr=1;

figure ('color',[1 1 1]), hold on

subplot(4,8,[1,2]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'LineWidth',2,'color',col_ctrl)
plot(nanmean(data_perc_WAKE_SD,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD,1), stdError(data_perc_WAKE_SD),'linestyle','-','LineWidth',2,'color',col_SD)
plot(nanmean(data_perc_WAKE_SD_mCherry_cno),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_SD_mCherry_cno,'color',col_SD_mCherry_cno), hold on
errorbar(nanmean(data_perc_WAKE_SD_mCherry_cno), stdError(data_perc_WAKE_SD_mCherry_cno),'LineWidth',2,'color',col_SD_mCherry_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'})
ylabel('Wake percentage')
makepretty
ylim([0 100])
% xlabel('Time after stress (h)')

subplot(4,8,[4,5]) % wake num overtime
plot(nanmean(data_num_WAKE_ctrl),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_WAKE_ctrl), stdError(data_num_WAKE_ctrl),'LineWidth',2,'color',col_ctrl)
plot(nanmean(data_num_WAKE_SD,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_WAKE_SD,1), stdError(data_num_WAKE_SD),'linestyle','-','LineWidth',2,'color',col_SD)
plot(nanmean(data_num_WAKE_SD_mCherry_cno),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_SD_mCherry_cno,'color',col_SD_mCherry_cno), hold on
errorbar(nanmean(data_num_WAKE_SD_mCherry_cno), stdError(data_num_WAKE_SD_mCherry_cno),'LineWidth',2,'color',col_SD_mCherry_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
ylabel('Wake bouts number')
makepretty
% xlabel('Time after stress (h)')

subplot(4,8,[7,8]) % wake duration overtime
plot(nanmean(data_dur_WAKE_ctrl),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_WAKE_ctrl), stdError(data_dur_WAKE_ctrl),'LineWidth',2,'color',col_ctrl)
plot(nanmean(data_dur_WAKE_SD,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_WAKE_SD,1), stdError(data_dur_WAKE_SD),'linestyle','-','LineWidth',2,'color',col_SD)
plot(nanmean(data_dur_WAKE_SD_mCherry_cno),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_SD_mCherry_cno,'color',col_SD_mCherry_cno), hold on
errorbar(nanmean(data_dur_WAKE_SD_mCherry_cno), stdError(data_dur_WAKE_SD_mCherry_cno),'LineWidth',2,'color',col_SD_mCherry_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('Wake bouts duration')
% xlabel('Time after stress (h)')


subplot(4,8,[9,10]), hold on % SWS percentage overtime
plot(nanmean(data_perc_SWS_ctrl),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_SWS_ctrl), stdError(data_perc_SWS_ctrl),'LineWidth',2,'color',col_ctrl)
plot(nanmean(data_perc_SWS_SD,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_SWS_SD,1), stdError(data_perc_SWS_SD),'linestyle','-','LineWidth',2,'color',col_SD)
plot(nanmean(data_perc_SWS_SD_mCherry_cno),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_SD_mCherry_cno,'color',col_SD_mCherry_cno), hold on
errorbar(nanmean(data_perc_SWS_SD_mCherry_cno), stdError(data_perc_SWS_SD_mCherry_cno),'LineWidth',2,'color',col_SD_mCherry_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
ylim([0 100])
makepretty
ylabel('NREM percentage')
% xlabel('Time after stress (h)')

subplot(4,8,[12,13]), hold on % SWS number overtime
plot(nanmean(data_num_SWS_ctrl),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_SWS_ctrl), stdError(data_num_SWS_ctrl),'LineWidth',2,'color',col_ctrl)
plot(nanmean(data_num_SWS_SD,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_SWS_SD,1), stdError(data_num_SWS_SD),'linestyle','-','LineWidth',2,'color',col_SD)
plot(nanmean(data_num_SWS_SD_mCherry_cno),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_SD_mCherry_cno,'color',col_SD_mCherry_cno), hold on
errorbar(nanmean(data_num_SWS_SD_mCherry_cno), stdError(data_num_SWS_SD_mCherry_cno),'LineWidth',2,'color',col_SD_mCherry_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('NREM bouts number')
% xlabel('Time after stress (h)')

subplot(4,8,[15,16]), hold on % SWS duration overtime
plot(nanmean(data_dur_SWS_ctrl),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_SWS_ctrl), stdError(data_dur_SWS_ctrl),'LineWidth',2,'color',col_ctrl)
plot(nanmean(data_dur_SWS_SD,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_SWS_SD,1), stdError(data_dur_SWS_SD),'linestyle','-','LineWidth',2,'color',col_SD)
plot(nanmean(data_dur_SWS_SD_mCherry_cno),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_SD_mCherry_cno,'color',col_SD_mCherry_cno), hold on
errorbar(nanmean(data_dur_SWS_SD_mCherry_cno), stdError(data_dur_SWS_SD_mCherry_cno),'LineWidth',2,'color',col_SD_mCherry_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('NREM bouts duration')
% xlabel('Time after stress (h)')


subplot(4,8,[17,18]) %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'LineWidth',2,'color',col_ctrl)
plot(nanmean(data_perc_REM_SD,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD,1), stdError(data_perc_REM_SD),'linestyle','-','LineWidth',2,'color',col_SD)
plot(nanmean(data_perc_REM_SD_mCherry_cno),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_SD_mCherry_cno,'color',col_SD_mCherry_cno), hold on
errorbar(nanmean(data_perc_REM_SD_mCherry_cno), stdError(data_perc_REM_SD_mCherry_cno),'LineWidth',2,'color',col_SD_mCherry_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM percentage')
xlabel('Time after stress (h)')

subplot(4,8,[20,21]) %REM number overtime
plot(nanmean(data_num_REM_ctrl),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_REM_ctrl), stdError(data_num_REM_ctrl),'LineWidth',2,'color',col_ctrl)
plot(nanmean(data_num_REM_SD,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_REM_SD,1), stdError(data_num_REM_SD),'linestyle','-','LineWidth',2,'color',col_SD)
plot(nanmean(data_num_REM_SD_mCherry_cno),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_SD_mCherry_cno,'color',col_SD_mCherry_cno), hold on
errorbar(nanmean(data_num_REM_SD_mCherry_cno), stdError(data_num_REM_SD_mCherry_cno),'LineWidth',2,'color',col_SD_mCherry_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM bouts number')
xlabel('Time after stress (h)')

subplot(4,8,[23,24]) % REM bouts duration ovetime
plot(nanmean(data_dur_REM_ctrl),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_REM_ctrl), stdError(data_dur_REM_ctrl),'LineWidth',2,'color',col_ctrl)
plot(nanmean(data_dur_REM_SD,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD,1), stdError(data_dur_REM_SD),'linestyle','-','LineWidth',2,'color',col_SD)
plot(nanmean(data_dur_REM_SD_mCherry_cno),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_SD_mCherry_cno,'color',col_SD_mCherry_cno), hold on
errorbar(nanmean(data_dur_REM_SD_mCherry_cno), stdError(data_dur_REM_SD_mCherry_cno),'LineWidth',2,'color',col_SD_mCherry_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM bouts duration')
xlabel('Time after stress (h)')


