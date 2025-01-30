%% To plot the figure you need to load data : 
Get_Data_5groups_AD.m

%% FIGURE 3 groups
txt_size = 15;
isparam=0;
iscorr=1;

%classic
% col_1 = [.7 .7 .7];
% col_2 = [.5 .5 .5];
% col_3 = [1 .4 0];

% %classic
% col_1 = [.2 .2 .2];
% col_2 = [1 0 0];
% col_3 = [0 .2 .6];

%classic
col_1 = [.7 .7 .7];
col_2 = [1 .4 0];
col_3 = [0 .4 .6];

figure('color',[1 1 1]), hold on
% suptitle ('xxxxxxxxxxxxx')
% suptitle ('Comparison between SD1 and SD2 saline')
suptitle ('Comparison between SD on homo or on hetero mice')

subplot(4,8,[1,2]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_WAKE_1), stdError(data_perc_WAKE_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_perc_WAKE_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_WAKE_2,1), stdError(data_perc_WAKE_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_perc_WAKE_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_perc_WAKE_3), stdError(data_perc_WAKE_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'})
ylabel('Wake percentage')
makepretty
ylim([0 100])
% xlabel('Time after stress (h)')

subplot(4,8,[4,5]) % wake num overtime
plot(nanmean(data_num_WAKE_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_WAKE_1), stdError(data_num_WAKE_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_num_WAKE_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_num_WAKE_2,1), stdError(data_num_WAKE_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_num_WAKE_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_num_WAKE_3), stdError(data_num_WAKE_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
ylabel('Wake bouts number')
makepretty
% xlabel('Time after stress (h)')

subplot(4,8,[7,8]) % wake duration overtime
plot(nanmean(data_dur_WAKE_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_WAKE_1), stdError(data_dur_WAKE_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_WAKE_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_WAKE_2,1), stdError(data_dur_WAKE_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_dur_WAKE_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_dur_WAKE_3), stdError(data_dur_WAKE_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('Wake bouts duration')
% xlabel('Time after stress (h)')


subplot(4,8,[9,10]), hold on % SWS percentage overtime
plot(nanmean(data_perc_SWS_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_SWS_1), stdError(data_perc_SWS_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_perc_SWS_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_SWS_2,1), stdError(data_perc_SWS_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_perc_SWS_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_perc_SWS_3), stdError(data_perc_SWS_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
ylim([0 100])
makepretty
ylabel('NREM percentage')
% xlabel('Time after stress (h)')

subplot(4,8,[12,13]), hold on % SWS number overtime
plot(nanmean(data_num_SWS_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_SWS_1), stdError(data_num_SWS_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_num_SWS_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_num_SWS_2,1), stdError(data_num_SWS_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_num_SWS_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_num_SWS_3), stdError(data_num_SWS_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('NREM bouts number')
% xlabel('Time after stress (h)')

subplot(4,8,[15,16]), hold on % SWS duration overtime
plot(nanmean(data_dur_SWS_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_SWS_1), stdError(data_dur_SWS_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_SWS_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_SWS_2,1), stdError(data_dur_SWS_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_dur_SWS_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_dur_SWS_3), stdError(data_dur_SWS_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('NREM bouts duration')
% xlabel('Time after stress (h)')


subplot(4,8,[17,18]) %REM percentage overtime
plot(nanmean(data_perc_REM_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_REM_1), stdError(data_perc_REM_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_perc_REM_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_REM_2,1), stdError(data_perc_REM_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_perc_REM_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_perc_REM_3), stdError(data_perc_REM_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM percentage')
xlabel('Time after stress (h)')

subplot(4,8,[20,21]) %REM number overtime
plot(nanmean(data_num_REM_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_REM_1), stdError(data_num_REM_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_num_REM_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_num_REM_2,1), stdError(data_num_REM_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_num_REM_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_num_REM_3), stdError(data_num_REM_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM bouts number')
xlabel('Time after stress (h)')

subplot(4,8,[23,24]) % REM bouts duration ovetime
plot(nanmean(data_dur_REM_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_REM_1), stdError(data_dur_REM_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_REM_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_REM_2,1), stdError(data_dur_REM_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_dur_REM_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_dur_REM_3), stdError(data_dur_REM_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM bouts duration')
xlabel('Time after stress (h)')


