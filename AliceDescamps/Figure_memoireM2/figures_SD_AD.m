
%% FIGURE (comparaison 3 groupes)
col_basal = [.6 .6 .6];
col_SD = [.91 .53 .17];
col_SDsafe = [.31 .38 .61];

%%
figure
suptitle ('Architecture générale')

subplot(3,2,1), hold on % wake percentage overtime
plot(nanmean(data_perc_WAKE_basal),'linestyle','-','marker','o','markerfacecolor',col_basal,'color',col_basal), hold on
errorbar(nanmean(data_perc_WAKE_basal), stdError(data_perc_WAKE_basal),'color',col_basal)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'color',col_SD)
plot(nanmean(data_perc_WAKE_SDsafe),'linestyle','-','marker','o','markerfacecolor',col_SDsafe,'color',col_SDsafe)
errorbar(nanmean(data_perc_WAKE_SDsafe), stdError(data_perc_WAKE_SDsafe),'color',col_SDsafe)
xlim([0 8])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
xlabel('Heure')
ylabel('Quantité éveil (%)')
makepretty

subplot(3,2,3), hold on %NREM percentage overtime
plot(nanmean(data_perc_SWS_basal),'linestyle','-','marker','o','markerfacecolor',col_basal,'color',col_basal), hold on
errorbar(nanmean(data_perc_SWS_basal), stdError(data_perc_SWS_basal),'color',col_basal)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'color',col_SD)
plot(nanmean(data_perc_SWS_SDsafe),'linestyle','-','marker','o','markerfacecolor',col_SDsafe,'color',col_SDsafe)
errorbar(nanmean(data_perc_SWS_SDsafe), stdError(data_perc_SWS_SDsafe),'color',col_SDsafe)
xlim([0 8])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
xlabel('Heure')
ylabel('Quantité SL (%)')
makepretty

subplot(3,2,5), hold on %REM percentage overtime
plot(nanmean(data_perc_REM_basal),'linestyle','-','marker','o','markerfacecolor',col_basal,'color',col_basal), hold on
errorbar(nanmean(data_perc_REM_basal), stdError(data_perc_REM_basal),'color',col_basal)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'color',col_SD)
plot(nanmean(data_perc_REM_SDsafe),'linestyle','-','marker','o','markerfacecolor',col_SDsafe,'color',col_SDsafe)
errorbar(nanmean(data_perc_REM_SDsafe), stdError(data_perc_REM_SDsafe),'color',col_SDsafe)
xlim([0 8])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
xlabel('Heure')
ylabel('Quantité SP (%)')
makepretty


subplot(3,2,2) % wake percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_WAKE_basal(:,1:3),2), nanmean(data_perc_WAKE_SDsafe(:,1:3),2), nanmean(data_perc_WAKE_SD(:,1:3),2),...
    nanmean(data_perc_WAKE_basal(:,4:8),2), nanmean(data_perc_WAKE_SDsafe(:,4:8),2), nanmean(data_perc_WAKE_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Quantité éveil (%)')
xlabel('Temps après le stress (h)')
makepretty

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2),nanmean(data_perc_WAKE_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_WAKE_SD(:,timebin),2), nanmean(data_perc_WAKE_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2), nanmean(data_perc_WAKE_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2),nanmean(data_perc_WAKE_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_WAKE_SD(:,timebin),2), nanmean(data_perc_WAKE_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_WAKE_basal(:,timebin),2), nanmean(data_perc_WAKE_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

subplot(3,2,4) %NREM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_SWS_basal(:,1:3),2), nanmean(data_perc_SWS_SDsafe(:,1:3),2), nanmean(data_perc_SWS_SD(:,1:3),2),...
    nanmean(data_perc_SWS_basal(:,4:8),2), nanmean(data_perc_SWS_SDsafe(:,4:8),2), nanmean(data_perc_SWS_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Quantité SL (%)')
xlabel('Temps après le stress (h)')
makepretty

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_perc_SWS_basal(:,timebin),2),nanmean(data_perc_SWS_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_SWS_SD(:,timebin),2), nanmean(data_perc_SWS_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_SWS_basal(:,timebin),2), nanmean(data_perc_SWS_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_perc_SWS_basal(:,timebin),2),nanmean(data_perc_SWS_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_SWS_SD(:,timebin),2), nanmean(data_perc_SWS_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_SWS_basal(:,timebin),2), nanmean(data_perc_SWS_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


subplot(3,2,6) %REM percentage quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_perc_REM_basal(:,1:3),2), nanmean(data_perc_REM_SDsafe(:,1:3),2), nanmean(data_perc_REM_SD(:,1:3),2),...
    nanmean(data_perc_REM_basal(:,4:8),2), nanmean(data_perc_REM_SDsafe(:,4:8),2), nanmean(data_perc_REM_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Quantité SP (%)')
xlabel('Temps après le stress (h)')
makepretty

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_REM_SD(:,timebin),2), nanmean(data_perc_REM_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2), nanmean(data_perc_REM_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2),nanmean(data_perc_REM_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_perc_REM_SD(:,timebin),2), nanmean(data_perc_REM_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_perc_REM_basal(:,timebin),2), nanmean(data_perc_REM_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end






%%
figure
suptitle ('NREM +REM')

subplot(3,4,[1 2]) % NREM num quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_num_SWS_basal(:,1:3),2), nanmean(data_num_SWS_SDsafe(:,1:3),2), nanmean(data_num_SWS_SD(:,1:3),2),...
    nanmean(data_num_SWS_basal(:,4:8),2), nanmean(data_num_SWS_SDsafe(:,4:8),2), nanmean(data_num_SWS_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Nombre SL')
xlabel('Temps après le stress (h)')
makepretty

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_num_SWS_basal(:,timebin),2),nanmean(data_num_SWS_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_num_SWS_SD(:,timebin),2), nanmean(data_num_SWS_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_num_SWS_basal(:,timebin),2), nanmean(data_num_SWS_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_num_SWS_basal(:,timebin),2),nanmean(data_num_SWS_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_num_SWS_SD(:,timebin),2), nanmean(data_num_SWS_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_num_SWS_basal(:,timebin),2), nanmean(data_num_SWS_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


subplot(3,4,[3 4]) %NREM dur quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_dur_SWS_basal(:,1:3),2), nanmean(data_dur_SWS_SDsafe(:,1:3),2), nanmean(data_dur_SWS_SD(:,1:3),2),...
    nanmean(data_dur_SWS_basal(:,4:8),2), nanmean(data_dur_SWS_SDsafe(:,4:8),2), nanmean(data_dur_SWS_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Durée SL (s)')
xlabel('Temps après le stress (h)')
makepretty

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_dur_SWS_basal(:,timebin),2),nanmean(data_dur_SWS_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_dur_SWS_SD(:,timebin),2), nanmean(data_dur_SWS_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_dur_SWS_basal(:,timebin),2), nanmean(data_dur_SWS_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_dur_SWS_basal(:,timebin),2),nanmean(data_dur_SWS_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_dur_SWS_SD(:,timebin),2), nanmean(data_dur_SWS_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_dur_SWS_basal(:,timebin),2), nanmean(data_dur_SWS_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


subplot(3,4,[5 6]) % REM num quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_basal(:,1:3),2), nanmean(data_num_REM_SDsafe(:,1:3),2), nanmean(data_num_REM_SD(:,1:3),2),...
    nanmean(data_num_REM_basal(:,4:8),2), nanmean(data_num_REM_SDsafe(:,4:8),2), nanmean(data_num_REM_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Nombre SP')
makepretty
xlabel('Temps après le stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_num_REM_basal(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_num_REM_SD(:,timebin),2), nanmean(data_num_REM_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_num_REM_basal(:,timebin),2), nanmean(data_num_REM_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_num_REM_basal(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_num_REM_SD(:,timebin),2), nanmean(data_num_REM_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_num_REM_basal(:,timebin),2), nanmean(data_num_REM_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 7]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


subplot(3,4,[7 8]) % REM dur quantif barplot
PlotErrorBarN_KJ({...
    nanmean(data_dur_REM_basal(:,1:3),2), nanmean(data_dur_REM_SDsafe(:,1:3),2), nanmean(data_dur_REM_SD(:,1:3),2),...
    nanmean(data_dur_REM_basal(:,4:8),2), nanmean(data_dur_REM_SDsafe(:,4:8),2), nanmean(data_dur_REM_SD(:,4:8),2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:3,5:7],'barcolors',{col_basal,col_SDsafe,col_SD,col_basal,col_SDsafe,col_SD});
xticks([2 6]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('Durée SP (s)')
makepretty
xlabel('Temps après le stress (h)')

timebin=1:3;
[p_basal_SD,h] = ranksum(nanmean(data_dur_REM_basal(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_dur_REM_SD(:,timebin),2), nanmean(data_dur_REM_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_dur_REM_basal(:,timebin),2), nanmean(data_dur_REM_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[1 3]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[2 3]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[1 2]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_basal_SD,h] = ranksum(nanmean(data_dur_REM_basal(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
[p_SD_ctrlInhib,h] = ranksum(nanmean(data_dur_REM_SD(:,timebin),2), nanmean(data_dur_REM_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h] = ranksum(nanmean(data_dur_REM_basal(:,timebin),2), nanmean(data_dur_REM_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[5 7]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[6 7]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[5 6]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end


subplot(3,4,9) % new FI = 1 - proba stay rem (4-8h)
PlotErrorBarN_KJ({...
    NaN,(1-nanmean(data_REM_REM_basal(:,4:8),2))*100,...
    (1-nanmean(data_REM_REM_SDsafe(:,4:8),2))*100,...
    (1-nanmean(data_REM_REM_SD(:,4:8),2))*100, NaN},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:5],'barcolors',{col_basal,col_basal,col_SDsafe,col_SD,col_basal});
xticks([1:5]); xticklabels({'','','4-8','',''}); xtickangle(0)
xlabel('Temps après le stress (h)')

timebin=4:8;
[p_basal_SD,h]=ranksum(1-nanmean(data_REM_REM_basal(:,timebin),2),1-nanmean(data_REM_REM_SD(:,timebin),2));
[p_SD_ctrlInhib,h]=ranksum(1-nanmean(data_REM_REM_SD(:,timebin),2), 1-nanmean(data_REM_REM_SDsafe(:,timebin),2));
[p_basal_ctrlInhib,h]=ranksum(1-nanmean(data_REM_REM_basal(:,timebin),2),1-nanmean(data_REM_REM_SDsafe(:,timebin),2));

[h, crit_p,adj_ci_cvrg,adj_p]=fdr_bh([p_basal_SD,p_SD_ctrlInhib,p_basal_ctrlInhib], .05, 'pdep')
p_basal_SD=adj_p(1);
p_SD_ctrlInhib=adj_p(2);
p_basal_ctrlInhib =adj_p(3);

if p_basal_SD<0.05; sigstar_DB({[2 4]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_ctrlInhib<0.05; sigstar_DB({[3 4]},p_SD_ctrlInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_ctrlInhib<0.05; sigstar_DB({[2 3]},p_basal_ctrlInhib,0,'LineWigth',16,'StarSize',24);end

ylabel('Fragmentation SP')
makepretty
