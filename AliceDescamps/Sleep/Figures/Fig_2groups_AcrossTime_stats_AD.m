%% To plot the figure you need to load data : 
Get_Data_5groups_AD.m

%% FIGURE 2 groups across time stat
txt_size = 15;
isparam=0;
iscorr=1;

%classic
% col_1 = [.7 .7 .7];
% col_2 = [1 .4 0];
col_1 = [.2 .2 .2];
col_2 = [1 0 0];

%classic
% col_1 = [.7 .7 .7];
% col_2 = [0 .8 .4];

%classic
% col_1 = [.7 .7 .7];
% col_2 = [.2 .2 .2];
% col_2 = [.2 0 1];


%homo inhib
% col_1 = [.7 .7 .7];
% col_2 = [.6 0 .6];


figure('color',[1 1 1]), hold on
% suptitle ('xxxxxxxxxxxxx')
suptitle ('Effect of Social defeat');
% suptitle ('Effect of CNO');

subplot(4,7,[8,9],'align') % wake percentage overtime
plot(nanmean(data_perc_WAKE_1),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_WAKE_1), stdError(data_perc_WAKE_1),'color',col_1)
plot(nanmean(data_perc_WAKE_2),'linestyle','-','marker','o','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_WAKE_2), stdError(data_perc_WAKE_2),'linestyle','-','color',col_2)
xlim([0 8.5])
ylim([0 100])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('Wake percentage')
xlabel('Time after stress (h)')
%%stats wake perc overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_perc_WAKE_1(:,1), data_perc_WAKE_2(:,1));
    [p_2,h_2, stats] = ranksum(data_perc_WAKE_1(:,2), data_perc_WAKE_2(:,2));
    [p_3,h_3, stats] = ranksum(data_perc_WAKE_1(:,3), data_perc_WAKE_2(:,3));
    [p_4,h_4, stats] = ranksum(data_perc_WAKE_1(:,4), data_perc_WAKE_2(:,4));
    [p_5,h_5, stats] = ranksum(data_perc_WAKE_1(:,5), data_perc_WAKE_2(:,5));
    [p_6,h_6, stats] = ranksum(data_perc_WAKE_1(:,6), data_perc_WAKE_2(:,6));
    [p_7,h_7, stats] = ranksum(data_perc_WAKE_1(:,7), data_perc_WAKE_2(:,7));
    [p_8,h_8, stats] = ranksum(data_perc_WAKE_1(:,8), data_perc_WAKE_2(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_WAKE_1(:,1), data_perc_WAKE_2(:,1));
    [h_2,p_2] = ttest2(data_perc_WAKE_1(:,2), data_perc_WAKE_2(:,2));
    [h_3,p_3] = ttest2(data_perc_WAKE_1(:,3), data_perc_WAKE_2(:,3));
    [h_4,p_4] = ttest2(data_perc_WAKE_1(:,4), data_perc_WAKE_2(:,4));
    [h_5,p_5] = ttest2(data_perc_WAKE_1(:,5), data_perc_WAKE_2(:,5));
    [h_6,p_6] = ttest2(data_perc_WAKE_1(:,6), data_perc_WAKE_2(:,6));
    [h_7,p_7] = ttest2(data_perc_WAKE_1(:,7), data_perc_WAKE_2(:,7));
    [h_8,p_8] = ttest2(data_perc_WAKE_1(:,8), data_perc_WAKE_2(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end

%%PANEL E
subplot(4,7,[10,11],'align'), hold on
plot(nanmean(data_perc_SWS_1),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_SWS_1), stdError(data_perc_SWS_1),'color',col_1)
plot(nanmean(data_perc_SWS_2),'linestyle','-','marker','o','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_SWS_2), stdError(data_perc_SWS_2),'linestyle','-','color',col_2)
xlim([0 8.5])
ylim([0 100])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('NREM percentage')
xlabel('Time after stress (h)')

%%stats all SWS perc overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_perc_SWS_1(:,1), data_perc_SWS_2(:,1));
    [p_2,h_2, stats] = ranksum(data_perc_SWS_1(:,2), data_perc_SWS_2(:,2));
    [p_3,h_3, stats] = ranksum(data_perc_SWS_1(:,3), data_perc_SWS_2(:,3));
    [p_4,h_4, stats] = ranksum(data_perc_SWS_1(:,4), data_perc_SWS_2(:,4));
    [p_5,h_5, stats] = ranksum(data_perc_SWS_1(:,5), data_perc_SWS_2(:,5));
    [p_6,h_6, stats] = ranksum(data_perc_SWS_1(:,6), data_perc_SWS_2(:,6));
    [p_7,h_7, stats] = ranksum(data_perc_SWS_1(:,7), data_perc_SWS_2(:,7));
    [p_8,h_8, stats] = ranksum(data_perc_SWS_1(:,8), data_perc_SWS_2(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_SWS_1(:,1), data_perc_SWS_2(:,1));
    [h_2,p_2] = ttest2(data_perc_SWS_1(:,2), data_perc_SWS_2(:,2));
    [h_3,p_3] = ttest2(data_perc_SWS_1(:,3), data_perc_SWS_2(:,3));
    [h_4,p_4] = ttest2(data_perc_SWS_1(:,4), data_perc_SWS_2(:,4));
    [h_5,p_5] = ttest2(data_perc_SWS_1(:,5), data_perc_SWS_2(:,5));
    [h_6,p_6] = ttest2(data_perc_SWS_1(:,6), data_perc_SWS_2(:,6));
    [h_7,p_7] = ttest2(data_perc_SWS_1(:,7), data_perc_SWS_2(:,7));
    [h_8,p_8] = ttest2(data_perc_SWS_1(:,8), data_perc_SWS_2(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end

%%PANEL F
subplot(4,7,[12,13],'align') %REM percentage overtime
plot(nanmean(data_perc_REM_1),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_REM_1), stdError(data_perc_REM_1),'color',col_1)
plot(nanmean(data_perc_REM_2),'linestyle','-','marker','o','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_REM_2), stdError(data_perc_REM_2),'linestyle','-','color',col_2)
xlim([0 8.5])
ylim([0 15])

xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('REM percentage')
xlabel('Time after stress (h)')

%%stats all REM perc overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_perc_REM_1(:,1), data_perc_REM_2(:,1));
    [p_2,h_2, stats] = ranksum(data_perc_REM_1(:,2), data_perc_REM_2(:,2));
    [p_3,h_3, stats] = ranksum(data_perc_REM_1(:,3), data_perc_REM_2(:,3));
    [p_4,h_4, stats] = ranksum(data_perc_REM_1(:,4), data_perc_REM_2(:,4));
    [p_5,h_5, stats] = ranksum(data_perc_REM_1(:,5), data_perc_REM_2(:,5));
    [p_6,h_6, stats] = ranksum(data_perc_REM_1(:,6), data_perc_REM_2(:,6));
    [p_7,h_7, stats] = ranksum(data_perc_REM_1(:,7), data_perc_REM_2(:,7));
    [p_8,h_8, stats] = ranksum(data_perc_REM_1(:,8), data_perc_REM_2(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_REM_1(:,1), data_perc_REM_2(:,1));
    [h_2,p_2] = ttest2(data_perc_REM_1(:,2), data_perc_REM_2(:,2));
    [h_3,p_3] = ttest2(data_perc_REM_1(:,3), data_perc_REM_2(:,3));
    [h_4,p_4] = ttest2(data_perc_REM_1(:,4), data_perc_REM_2(:,4));
    [h_5,p_5] = ttest2(data_perc_REM_1(:,5), data_perc_REM_2(:,5));
    [h_6,p_6] = ttest2(data_perc_REM_1(:,6), data_perc_REM_2(:,6));
    [h_7,p_7] = ttest2(data_perc_REM_1(:,7), data_perc_REM_2(:,7));
    [h_8,p_8] = ttest2(data_perc_REM_1(:,8), data_perc_REM_2(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


%%PANEL G
subplot(4,7,[15,16],'align') %REM num overtime
plot(nanmean(data_num_REM_1),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_REM_1), stdError(data_num_REM_1),'color',col_1)
plot(nanmean(data_num_REM_2),'linestyle','-','marker','o','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_num_REM_2), stdError(data_num_REM_2),'linestyle','-','color',col_2)
xlim([0 8.5])
ylim([0 10])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('REM bouts number')
xlabel('Time after stress (h)')

%%stats REM num overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_num_REM_1(:,1), data_num_REM_2(:,1));
    [p_2,h_2, stats] = ranksum(data_num_REM_1(:,2), data_num_REM_2(:,2));
    [p_3,h_3, stats] = ranksum(data_num_REM_1(:,3), data_num_REM_2(:,3));
    [p_4,h_4, stats] = ranksum(data_num_REM_1(:,4), data_num_REM_2(:,4));
    [p_5,h_5, stats] = ranksum(data_num_REM_1(:,5), data_num_REM_2(:,5));
    [p_6,h_6, stats] = ranksum(data_num_REM_1(:,6), data_num_REM_2(:,6));
    [p_7,h_7, stats] = ranksum(data_num_REM_1(:,7), data_num_REM_2(:,7));
    [p_8,h_8, stats] = ranksum(data_num_REM_1(:,8), data_num_REM_2(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_REM_1(:,1), data_num_REM_2(:,1));
    [h_2,p_2] = ttest2(data_num_REM_1(:,2), data_num_REM_2(:,2));
    [h_3,p_3] = ttest2(data_num_REM_1(:,3), data_num_REM_2(:,3));
    [h_4,p_4] = ttest2(data_num_REM_1(:,4), data_num_REM_2(:,4));
    [h_5,p_5] = ttest2(data_num_REM_1(:,5), data_num_REM_2(:,5));
    [h_6,p_6] = ttest2(data_num_REM_1(:,6), data_num_REM_2(:,6));
    [h_7,p_7] = ttest2(data_num_REM_1(:,7), data_num_REM_2(:,7));
    [h_8,p_8] = ttest2(data_num_REM_1(:,8), data_num_REM_2(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


%%PANEL H
subplot(4,7,[17,18],'align') %REM durentage overtime
plot(nanmean(data_dur_REM_1),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_REM_1), stdError(data_dur_REM_1),'color',col_1)
plot(nanmean(data_dur_REM_2),'linestyle','-','marker','o','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_REM_2), stdError(data_dur_REM_2),'linestyle','-','color',col_2)
xlim([0 8.5])
ylim([0 150])

xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('REM bouts duration (s)')
xlabel('Time after stress (h)')

%%stats REM dur overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_dur_REM_1(:,1), data_dur_REM_2(:,1));
    [p_2,h_2, stats] = ranksum(data_dur_REM_1(:,2), data_dur_REM_2(:,2));
    [p_3,h_3, stats] = ranksum(data_dur_REM_1(:,3), data_dur_REM_2(:,3));
    [p_4,h_4, stats] = ranksum(data_dur_REM_1(:,4), data_dur_REM_2(:,4));
    [p_5,h_5, stats] = ranksum(data_dur_REM_1(:,5), data_dur_REM_2(:,5));
    [p_6,h_6, stats] = ranksum(data_dur_REM_1(:,6), data_dur_REM_2(:,6));
    [p_7,h_7, stats] = ranksum(data_dur_REM_1(:,7), data_dur_REM_2(:,7));
    [p_8,h_8, stats] = ranksum(data_dur_REM_1(:,8), data_dur_REM_2(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_REM_1(:,1), data_dur_REM_2(:,1));
    [h_2,p_2] = ttest2(data_dur_REM_1(:,2), data_dur_REM_2(:,2));
    [h_3,p_3] = ttest2(data_dur_REM_1(:,3), data_dur_REM_2(:,3));
    [h_4,p_4] = ttest2(data_dur_REM_1(:,4), data_dur_REM_2(:,4));
    [h_5,p_5] = ttest2(data_dur_REM_1(:,5), data_dur_REM_2(:,5));
    [h_6,p_6] = ttest2(data_dur_REM_1(:,6), data_dur_REM_2(:,6));
    [h_7,p_7] = ttest2(data_dur_REM_1(:,7), data_dur_REM_2(:,7));
    [h_8,p_8] = ttest2(data_dur_REM_1(:,8), data_dur_REM_2(:,8));
else
end
if iscorr ==0
    %%comparaisons multiples non corrigées
    if p_1<0.05; sigstar_MC({[0.8 1.2]},p_1,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_2<0.05; sigstar_MC({[1.8 2.2]},p_2,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_3<0.05; sigstar_MC({[2.8 3.2]},p_3,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_4<0.05; sigstar_MC({[3.8 4.2]},p_4,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_5<0.05; sigstar_MC({[4.8 5.2]},p_5,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_6<0.05; sigstar_MC({[5.8 6.2]},p_6,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_7<0.05; sigstar_MC({[6.8 7.2]},p_7,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_8<0.05; sigstar_MC({[7.8 8.2]},p_8,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end
