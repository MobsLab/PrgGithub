
%% FIGURE (comparaison 2 groupes)
col_sal = [.6 .6 .6];
col_cno = [1 0 0];

%%
figure
suptitle ('Architecture générale')

subplot(3,2,1), hold on % wake percentage overtime
plot(nanmean(data_perc_WAKE_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_perc_WAKE_basal), stdError(data_perc_WAKE_basal),'color',col_sal)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'color',col_cno)
xlim([0 9])
xticks([1 3 5 7 9]); xticklabels({'9','11','13','15','17'})
makepretty
xlabel('Heure')
ylabel('Quantité (%)')

subplot(3,2,3), hold on %NREM percentage overtime
plot(nanmean(data_perc_SWS_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_perc_SWS_basal), stdError(data_perc_SWS_basal),'color',col_sal)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'color',col_cno)
xlim([0 9])
xticks([1 3 5 7 9]); xticklabels({'9','11','13','15','17'})
makepretty
xlabel('Heure')
ylabel('Quantité (%)')

subplot(3,2,5), hold on %REM percentage overtime
plot(nanmean(data_perc_REM_basal),'linestyle','-','marker','o','markerfacecolor',col_sal,'color',col_sal)
errorbar(nanmean(data_perc_REM_basal), stdError(data_perc_REM_basal),'color',col_sal)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_cno,'color',col_cno)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'color',col_cno)
xlim([0 9])
xticks([1 3 5 7 9]); xticklabels({'9','11','13','15','17'})
makepretty
xlabel('Heure')
ylabel('Quantité (%)')


subplot(3,2,2) % wake percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_WAKE_basal(:,1:4),2), nanmean(data_perc_WAKE_SD(:,1:4),2),...
    nanmean(data_perc_WAKE_basal(:,5:9),2), nanmean(data_perc_WAKE_SD(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'Pré','Post'}); xtickangle(0)
makepretty
xlabel('Période')
ylabel('Quantité (%)')

timebin=1:4;
[h,p_basal_SD] = ttest(nanmean(data_perc_WAKE_basal(:,timebin),2),nanmean(data_perc_WAKE_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[h,p_basal_SD] = ttest(nanmean(data_perc_WAKE_basal(:,timebin),2),nanmean(data_perc_WAKE_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(3,2,4) %NREM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_SWS_basal(:,1:4),2), nanmean(data_perc_SWS_SD(:,1:4),2),...
    nanmean(data_perc_SWS_basal(:,5:9),2), nanmean(data_perc_SWS_SD(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'Pré','Post'}); xtickangle(0)
makepretty
xlabel('Période')
ylabel('Quantité (%)')

timebin=1:4;
[p_basal_SD,h] = signrank(nanmean(data_perc_SWS_basal(:,timebin),2),nanmean(data_perc_SWS_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[h,p_basal_SD] = ttest(nanmean(data_perc_SWS_basal(:,timebin),2),nanmean(data_perc_SWS_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(3,2,6) %REM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_REM_basal(:,1:4),2), nanmean(data_perc_REM_SD(:,1:4),2),...
    nanmean(data_perc_REM_basal(:,5:9),2), nanmean(data_perc_REM_SD(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'Pré','Post'}); xtickangle(0)
makepretty
xlabel('Période')
ylabel('Quantité (%)')

timebin=1:4;
[h,p_basal_SD] = ttest(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[h,p_basal_SD] = ttest(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


%%
figure
suptitle ('NREM + REM')

subplot(3,2,1) % NREM num quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_num_SWS_basal(:,1:4),2), nanmean(data_num_SWS_SD(:,1:4),2),...
    nanmean(data_num_SWS_basal(:,5:9),2), nanmean(data_num_SWS_SD(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'Pré','Post'}); xtickangle(0)
makepretty
xlabel('Période')
ylabel('Nombre SL')

timebin=1:4;
[h,p_basal_SD] = ttest(nanmean(data_num_SWS_basal(:,timebin),2),nanmean(data_num_SWS_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[h,p_basal_SD] = ttest(nanmean(data_num_SWS_basal(:,timebin),2),nanmean(data_num_SWS_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(3,2,2) %NREM dur quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_dur_SWS_basal(:,1:4),2), nanmean(data_dur_SWS_SD(:,1:4),2),...
    nanmean(data_dur_SWS_basal(:,5:9),2), nanmean(data_dur_SWS_SD(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'Pré','Post'}); xtickangle(0)
makepretty
xlabel('Période')
ylabel('Durée SL (s)')

timebin=1:4;
[h,p_basal_SD] = ttest(nanmean(data_dur_SWS_basal(:,timebin),2),nanmean(data_dur_SWS_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
[h, p_basal_SD] = ttest(nanmean(data_dur_SWS_basal(:,timebin),2),nanmean(data_dur_SWS_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(3,2,3) % REM bouts number quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_basal(:,1:4),2), nanmean(data_num_REM_SD(:,1:4),2),...
    nanmean(data_num_REM_basal(:,5:9),2), nanmean(data_num_REM_SD(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'Pré','Post'}); xtickangle(0)
ylabel('Nombre SP')
makepretty
xlabel('Période')

timebin=1:4;
% [p_basal_SD,h] = signrank(nanmean(data_num_REM_basal(:,timebin),2),nanmean(data_num_SWS_SD(:,timebin),2));
[h,p_basal_SD] = ttest(nanmean(data_num_REM_basal(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
% [p_basal_SD,h] = signrank(nanmean(data_num_SWS_basal(:,timebin),2),nanmean(data_num_SWS_SD(:,timebin),2));
[h,p_basal_SD] = ttest(nanmean(data_num_REM_basal(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end


subplot(3,2,4) % REM bouts mean duraion quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_dur_REM_basal(:,1:4),2), nanmean(data_dur_REM_SD(:,1:4),2),...
    nanmean(data_dur_REM_basal(:,5:9),2), nanmean(data_dur_REM_SD(:,5:9),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_sal,col_cno,col_sal,col_cno});
xticks([1.5 4.5]); xticklabels({'Pré','Post'}); xtickangle(0)
ylabel('Durée SP (s)')
makepretty
xlabel('Période')

timebin=1:4;
% [p_basal_SD,h] = signrank(nanmean(data_dur_REM_basal(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
[h,p_basal_SD] = ttest(nanmean(data_dur_REM_basal(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

timebin=5:9;
% [p_basal_SD,h] = signrank(nanmean(data_dur_REM_basal(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
[h, p_basal_SD] = ttest(nanmean(data_dur_REM_basal(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end

