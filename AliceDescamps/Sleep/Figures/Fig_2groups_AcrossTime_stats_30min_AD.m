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
xlim([0 17])
ylim([0 100])
xticks([2 4 6 8 10 12 14 16]); xticklabels({'1','2','3','4','5','6','7','8'})
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
    [p_9,h_9, stats] = ranksum(data_perc_WAKE_1(:,9), data_perc_WAKE_2(:,9));
    [p_10,h_10, stats] = ranksum(data_perc_WAKE_1(:,10), data_perc_WAKE_2(:,10));
    [p_11,h_11, stats] = ranksum(data_perc_WAKE_1(:,11), data_perc_WAKE_2(:,11));
    [p_12,h_12, stats] = ranksum(data_perc_WAKE_1(:,12), data_perc_WAKE_2(:,12));
    [p_13,h_13, stats] = ranksum(data_perc_WAKE_1(:,13), data_perc_WAKE_2(:,13));
    [p_14,h_14, stats] = ranksum(data_perc_WAKE_1(:,14), data_perc_WAKE_2(:,14));
    [p_15,h_15, stats] = ranksum(data_perc_WAKE_1(:,15), data_perc_WAKE_2(:,15));
    [p_16,h_16, stats] = ranksum(data_perc_WAKE_1(:,16), data_perc_WAKE_2(:,16));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_WAKE_1(:,1), data_perc_WAKE_2(:,1));
    [h_2,p_2] = ttest2(data_perc_WAKE_1(:,2), data_perc_WAKE_2(:,2));
    [h_3,p_3] = ttest2(data_perc_WAKE_1(:,3), data_perc_WAKE_2(:,3));
    [h_4,p_4] = ttest2(data_perc_WAKE_1(:,4), data_perc_WAKE_2(:,4));
    [h_5,p_5] = ttest2(data_perc_WAKE_1(:,5), data_perc_WAKE_2(:,5));
    [h_6,p_6] = ttest2(data_perc_WAKE_1(:,6), data_perc_WAKE_2(:,6));
    [h_7,p_7] = ttest2(data_perc_WAKE_1(:,7), data_perc_WAKE_2(:,7));
    [h_8,p_8] = ttest2(data_perc_WAKE_1(:,8), data_perc_WAKE_2(:,8));
    [h_9,p_9] = ttest2(data_perc_WAKE_1(:,9), data_perc_WAKE_2(:,9));
    [h_10,p_10] = ttest2(data_perc_WAKE_1(:,10), data_perc_WAKE_2(:,10));
    [h_11,p_11] = ttest2(data_perc_WAKE_1(:,11), data_perc_WAKE_2(:,11));
    [h_12,p_12] = ttest2(data_perc_WAKE_1(:,12), data_perc_WAKE_2(:,12));
    [h_13,p_13] = ttest2(data_perc_WAKE_1(:,13), data_perc_WAKE_2(:,13));
    [h_14,p_14] = ttest2(data_perc_WAKE_1(:,14), data_perc_WAKE_2(:,14));
    [h_15,p_15] = ttest2(data_perc_WAKE_1(:,15), data_perc_WAKE_2(:,15));
    [h_16,p_16] = ttest2(data_perc_WAKE_1(:,16), data_perc_WAKE_2(:,16));
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
    if p_9<0.05; sigstar_MC({[8.8 9.2]},p_9,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_10<0.05; sigstar_MC({[9.8 10.2]},p_10,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_11<0.05; sigstar_MC({[10.8 11.2]},p_11,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_12<0.05; sigstar_MC({[11.8 12.2]},p_12,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_13<0.05; sigstar_MC({[12.8 13.2]},p_13,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_14<0.05; sigstar_MC({[13.8 14.2]},p_14,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_15<0.05; sigstar_MC({[14.8 15.2]},p_15,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_16<0.05; sigstar_MC({[15.8 16.2]},p_16,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8 p_9 p_10 p_11 p_12 p_13 p_14 p_15 p_16];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(9)<0.05; sigstar_MC({[8.8 9.2]},adj_p(9),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(10)<0.05; sigstar_MC({[9.8 10.2]},adj_p(10),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(11)<0.05; sigstar_MC({[10.8 11.2]},adj_p(11),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(12)<0.05; sigstar_MC({[11.8 12.2]},adj_p(12),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(13)<0.05; sigstar_MC({[12.8 13.2]},adj_p(13),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(14)<0.05; sigstar_MC({[13.8 14.2]},adj_p(14),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(15)<0.05; sigstar_MC({[14.8 15.2]},adj_p(15),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(16)<0.05; sigstar_MC({[15.8 16.2]},adj_p(16),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end

%%PANEL E
subplot(4,7,[10,11],'align'), hold on
plot(nanmean(data_perc_SWS_1),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_SWS_1), stdError(data_perc_SWS_1),'color',col_1)
plot(nanmean(data_perc_SWS_2),'linestyle','-','marker','o','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_SWS_2), stdError(data_perc_SWS_2),'linestyle','-','color',col_2)
xlim([0 17])
ylim([0 100])
xticks([2 4 6 8 10 12 14 16]); xticklabels({'1','2','3','4','5','6','7','8'}) 
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
    [p_9,h_9, stats] = ranksum(data_perc_SWS_1(:,9), data_perc_SWS_2(:,9));
    [p_10,h_10, stats] = ranksum(data_perc_SWS_1(:,10), data_perc_SWS_2(:,10));
    [p_11,h_11, stats] = ranksum(data_perc_SWS_1(:,11), data_perc_SWS_2(:,11));
    [p_12,h_12, stats] = ranksum(data_perc_SWS_1(:,12), data_perc_SWS_2(:,12));
    [p_13,h_13, stats] = ranksum(data_perc_SWS_1(:,13), data_perc_SWS_2(:,13));
    [p_14,h_14, stats] = ranksum(data_perc_SWS_1(:,14), data_perc_SWS_2(:,14));
    [p_15,h_15, stats] = ranksum(data_perc_SWS_1(:,15), data_perc_SWS_2(:,15));
    [p_16,h_16, stats] = ranksum(data_perc_SWS_1(:,16), data_perc_SWS_2(:,16));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_SWS_1(:,1), data_perc_SWS_2(:,1));
    [h_2,p_2] = ttest2(data_perc_SWS_1(:,2), data_perc_SWS_2(:,2));
    [h_3,p_3] = ttest2(data_perc_SWS_1(:,3), data_perc_SWS_2(:,3));
    [h_4,p_4] = ttest2(data_perc_SWS_1(:,4), data_perc_SWS_2(:,4));
    [h_5,p_5] = ttest2(data_perc_SWS_1(:,5), data_perc_SWS_2(:,5));
    [h_6,p_6] = ttest2(data_perc_SWS_1(:,6), data_perc_SWS_2(:,6));
    [h_7,p_7] = ttest2(data_perc_SWS_1(:,7), data_perc_SWS_2(:,7));
    [h_8,p_8] = ttest2(data_perc_SWS_1(:,8), data_perc_SWS_2(:,8));
    [h_9,p_9] = ttest2(data_perc_SWS_1(:,9), data_perc_SWS_2(:,9));
    [h_10,p_10] = ttest2(data_perc_SWS_1(:,10), data_perc_SWS_2(:,10));
    [h_11,p_11] = ttest2(data_perc_SWS_1(:,11), data_perc_SWS_2(:,11));
    [h_12,p_12] = ttest2(data_perc_SWS_1(:,12), data_perc_SWS_2(:,12));
    [h_13,p_13] = ttest2(data_perc_SWS_1(:,13), data_perc_SWS_2(:,13));
    [h_14,p_14] = ttest2(data_perc_SWS_1(:,14), data_perc_SWS_2(:,14));
    [h_15,p_15] = ttest2(data_perc_SWS_1(:,15), data_perc_SWS_2(:,15));
    [h_16,p_16] = ttest2(data_perc_SWS_1(:,16), data_perc_SWS_2(:,16));
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
    if p_9<0.05; sigstar_MC({[8.8 9.2]},p_9,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_10<0.05; sigstar_MC({[9.8 10.2]},p_10,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_11<0.05; sigstar_MC({[10.8 11.2]},p_11,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_12<0.05; sigstar_MC({[11.8 12.2]},p_12,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_13<0.05; sigstar_MC({[12.8 13.2]},p_13,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_14<0.05; sigstar_MC({[13.8 14.2]},p_14,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_15<0.05; sigstar_MC({[14.8 15.2]},p_15,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_16<0.05; sigstar_MC({[15.8 16.2]},p_16,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8 p_9 p_10 p_11 p_12 p_13 p_14 p_15 p_16];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(9)<0.05; sigstar_MC({[8.8 9.2]},adj_p(9),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(10)<0.05; sigstar_MC({[9.8 10.2]},adj_p(10),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(11)<0.05; sigstar_MC({[10.8 11.2]},adj_p(11),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(12)<0.05; sigstar_MC({[11.8 12.2]},adj_p(12),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(13)<0.05; sigstar_MC({[12.8 13.2]},adj_p(13),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(14)<0.05; sigstar_MC({[13.8 14.2]},adj_p(14),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(15)<0.05; sigstar_MC({[14.8 15.2]},adj_p(15),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(16)<0.05; sigstar_MC({[15.8 16.2]},adj_p(16),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end

%%PANEL F
subplot(4,7,[12,13],'align') %REM percentage overtime
plot(nanmean(data_perc_REM_1),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_REM_1), stdError(data_perc_REM_1),'color',col_1)
plot(nanmean(data_perc_REM_2),'linestyle','-','marker','o','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_REM_2), stdError(data_perc_REM_2),'linestyle','-','color',col_2)
xlim([0 17])
ylim([0 20])

xticks([2 4 6 8 10 12 14 16]); xticklabels({'1','2','3','4','5','6','7','8'}) 
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
    [p_9,h_9, stats] = ranksum(data_perc_REM_1(:,9), data_perc_REM_2(:,9));
    [p_10,h_10, stats] = ranksum(data_perc_REM_1(:,10), data_perc_REM_2(:,10));
    [p_11,h_11, stats] = ranksum(data_perc_REM_1(:,11), data_perc_REM_2(:,11));
    [p_12,h_12, stats] = ranksum(data_perc_REM_1(:,12), data_perc_REM_2(:,12));
    [p_13,h_13, stats] = ranksum(data_perc_REM_1(:,13), data_perc_REM_2(:,13));
    [p_14,h_14, stats] = ranksum(data_perc_REM_1(:,14), data_perc_REM_2(:,14));
    [p_15,h_15, stats] = ranksum(data_perc_REM_1(:,15), data_perc_REM_2(:,15));
    [p_16,h_16, stats] = ranksum(data_perc_REM_1(:,16), data_perc_REM_2(:,16));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_REM_1(:,1), data_perc_REM_2(:,1));
    [h_2,p_2] = ttest2(data_perc_REM_1(:,2), data_perc_REM_2(:,2));
    [h_3,p_3] = ttest2(data_perc_REM_1(:,3), data_perc_REM_2(:,3));
    [h_4,p_4] = ttest2(data_perc_REM_1(:,4), data_perc_REM_2(:,4));
    [h_5,p_5] = ttest2(data_perc_REM_1(:,5), data_perc_REM_2(:,5));
    [h_6,p_6] = ttest2(data_perc_REM_1(:,6), data_perc_REM_2(:,6));
    [h_7,p_7] = ttest2(data_perc_REM_1(:,7), data_perc_REM_2(:,7));
    [h_8,p_8] = ttest2(data_perc_REM_1(:,8), data_perc_REM_2(:,8));
    [h_9,p_9] = ttest2(data_perc_REM_1(:,9), data_perc_REM_2(:,9));
    [h_10,p_10] = ttest2(data_perc_REM_1(:,10), data_perc_REM_2(:,10));
    [h_11,p_11] = ttest2(data_perc_REM_1(:,11), data_perc_REM_2(:,11));
    [h_12,p_12] = ttest2(data_perc_REM_1(:,12), data_perc_REM_2(:,12));
    [h_13,p_13] = ttest2(data_perc_REM_1(:,13), data_perc_REM_2(:,13));
    [h_14,p_14] = ttest2(data_perc_REM_1(:,14), data_perc_REM_2(:,14));
    [h_15,p_15] = ttest2(data_perc_REM_1(:,15), data_perc_REM_2(:,15));
    [h_16,p_16] = ttest2(data_perc_REM_1(:,16), data_perc_REM_2(:,16));
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
    if p_9<0.05; sigstar_MC({[8.8 9.2]},p_9,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_10<0.05; sigstar_MC({[9.8 10.2]},p_10,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_11<0.05; sigstar_MC({[10.8 11.2]},p_11,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_12<0.05; sigstar_MC({[11.8 12.2]},p_12,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_13<0.05; sigstar_MC({[12.8 13.2]},p_13,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_14<0.05; sigstar_MC({[13.8 14.2]},p_14,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_15<0.05; sigstar_MC({[14.8 15.2]},p_15,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_16<0.05; sigstar_MC({[15.8 16.2]},p_16,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8 p_9 p_10 p_11 p_12 p_13 p_14 p_15 p_16];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(9)<0.05; sigstar_MC({[8.8 9.2]},adj_p(9),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(10)<0.05; sigstar_MC({[9.8 10.2]},adj_p(10),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(11)<0.05; sigstar_MC({[10.8 11.2]},adj_p(11),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(12)<0.05; sigstar_MC({[11.8 12.2]},adj_p(12),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(13)<0.05; sigstar_MC({[12.8 13.2]},adj_p(13),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(14)<0.05; sigstar_MC({[13.8 14.2]},adj_p(14),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(15)<0.05; sigstar_MC({[14.8 15.2]},adj_p(15),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(16)<0.05; sigstar_MC({[15.8 16.2]},adj_p(16),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


%%PANEL G
subplot(4,7,[15,16],'align') %REM num overtime
plot(nanmean(data_num_REM_1),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_REM_1), stdError(data_num_REM_1),'color',col_1)
plot(nanmean(data_num_REM_2),'linestyle','-','marker','o','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_num_REM_2), stdError(data_num_REM_2),'linestyle','-','color',col_2)
xlim([0 17])
ylim([0 10])
xticks([2 4 6 8 10 12 14 16]); xticklabels({'1','2','3','4','5','6','7','8'}) 
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
    [p_9,h_9, stats] = ranksum(data_num_REM_1(:,9), data_num_REM_2(:,9));
    [p_10,h_10, stats] = ranksum(data_num_REM_1(:,10), data_num_REM_2(:,10));
    [p_11,h_11, stats] = ranksum(data_num_REM_1(:,11), data_num_REM_2(:,11));
    [p_12,h_12, stats] = ranksum(data_num_REM_1(:,12), data_num_REM_2(:,12));
    [p_13,h_13, stats] = ranksum(data_num_REM_1(:,13), data_num_REM_2(:,13));
    [p_14,h_14, stats] = ranksum(data_num_REM_1(:,14), data_num_REM_2(:,14));
    [p_15,h_15, stats] = ranksum(data_num_REM_1(:,15), data_num_REM_2(:,15));
    [p_16,h_16, stats] = ranksum(data_num_REM_1(:,16), data_num_REM_2(:,16));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_REM_1(:,1), data_num_REM_2(:,1));
    [h_2,p_2] = ttest2(data_num_REM_1(:,2), data_num_REM_2(:,2));
    [h_3,p_3] = ttest2(data_num_REM_1(:,3), data_num_REM_2(:,3));
    [h_4,p_4] = ttest2(data_num_REM_1(:,4), data_num_REM_2(:,4));
    [h_5,p_5] = ttest2(data_num_REM_1(:,5), data_num_REM_2(:,5));
    [h_6,p_6] = ttest2(data_num_REM_1(:,6), data_num_REM_2(:,6));
    [h_7,p_7] = ttest2(data_num_REM_1(:,7), data_num_REM_2(:,7));
    [h_8,p_8] = ttest2(data_num_REM_1(:,8), data_num_REM_2(:,8));
    [h_9,p_9] = ttest2(data_num_REM_1(:,9), data_num_REM_2(:,9));
    [h_10,p_10] = ttest2(data_num_REM_1(:,10), data_num_REM_2(:,10));
    [h_11,p_11] = ttest2(data_num_REM_1(:,11), data_num_REM_2(:,11));
    [h_12,p_12] = ttest2(data_num_REM_1(:,12), data_num_REM_2(:,12));
    [h_13,p_13] = ttest2(data_num_REM_1(:,13), data_num_REM_2(:,13));
    [h_14,p_14] = ttest2(data_num_REM_1(:,14), data_num_REM_2(:,14));
    [h_15,p_15] = ttest2(data_num_REM_1(:,15), data_num_REM_2(:,15));
    [h_16,p_16] = ttest2(data_num_REM_1(:,16), data_num_REM_2(:,16));
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
    if p_9<0.05; sigstar_MC({[8.8 9.2]},p_9,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_10<0.05; sigstar_MC({[9.8 10.2]},p_10,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_11<0.05; sigstar_MC({[10.8 11.2]},p_11,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_12<0.05; sigstar_MC({[11.8 12.2]},p_12,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_13<0.05; sigstar_MC({[12.8 13.2]},p_13,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_14<0.05; sigstar_MC({[13.8 14.2]},p_14,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_15<0.05; sigstar_MC({[14.8 15.2]},p_15,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_16<0.05; sigstar_MC({[15.8 16.2]},p_16,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8 p_9 p_10 p_11 p_12 p_13 p_14 p_15 p_16];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(9)<0.05; sigstar_MC({[8.8 9.2]},adj_p(9),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(10)<0.05; sigstar_MC({[9.8 10.2]},adj_p(10),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(11)<0.05; sigstar_MC({[10.8 11.2]},adj_p(11),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(12)<0.05; sigstar_MC({[11.8 12.2]},adj_p(12),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(13)<0.05; sigstar_MC({[12.8 13.2]},adj_p(13),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(14)<0.05; sigstar_MC({[13.8 14.2]},adj_p(14),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(15)<0.05; sigstar_MC({[14.8 15.2]},adj_p(15),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(16)<0.05; sigstar_MC({[15.8 16.2]},adj_p(16),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end


%%PANEL H
subplot(4,7,[17,18],'align') %REM durentage overtime
plot(nanmean(data_dur_REM_1),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_REM_1), stdError(data_dur_REM_1),'color',col_1)
plot(nanmean(data_dur_REM_2),'linestyle','-','marker','o','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_REM_2), stdError(data_dur_REM_2),'linestyle','-','color',col_2)
xlim([0 17])
ylim([0 150])

xticks([2 4 6 8 10 12 14 16]); xticklabels({'1','2','3','4','5','6','7','8'}) 
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
    [p_9,h_9, stats] = ranksum(data_dur_REM_1(:,9), data_dur_REM_2(:,9));
    [p_10,h_10, stats] = ranksum(data_dur_REM_1(:,10), data_dur_REM_2(:,10));
    [p_11,h_11, stats] = ranksum(data_dur_REM_1(:,11), data_dur_REM_2(:,11));
    [p_12,h_12, stats] = ranksum(data_dur_REM_1(:,12), data_dur_REM_2(:,12));
    [p_13,h_13, stats] = ranksum(data_dur_REM_1(:,13), data_dur_REM_2(:,13));
    [p_14,h_14, stats] = ranksum(data_dur_REM_1(:,14), data_dur_REM_2(:,14));
    [p_15,h_15, stats] = ranksum(data_dur_REM_1(:,15), data_dur_REM_2(:,15));
    [p_16,h_16, stats] = ranksum(data_dur_REM_1(:,16), data_dur_REM_2(:,16));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_REM_1(:,1), data_dur_REM_2(:,1));
    [h_2,p_2] = ttest2(data_dur_REM_1(:,2), data_dur_REM_2(:,2));
    [h_3,p_3] = ttest2(data_dur_REM_1(:,3), data_dur_REM_2(:,3));
    [h_4,p_4] = ttest2(data_dur_REM_1(:,4), data_dur_REM_2(:,4));
    [h_5,p_5] = ttest2(data_dur_REM_1(:,5), data_dur_REM_2(:,5));
    [h_6,p_6] = ttest2(data_dur_REM_1(:,6), data_dur_REM_2(:,6));
    [h_7,p_7] = ttest2(data_dur_REM_1(:,7), data_dur_REM_2(:,7));
    [h_8,p_8] = ttest2(data_dur_REM_1(:,8), data_dur_REM_2(:,8));
    [h_9,p_9] = ttest2(data_dur_REM_1(:,9), data_dur_REM_2(:,9));
    [h_10,p_10] = ttest2(data_dur_REM_1(:,10), data_dur_REM_2(:,10));
    [h_11,p_11] = ttest2(data_dur_REM_1(:,11), data_dur_REM_2(:,11));
    [h_12,p_12] = ttest2(data_dur_REM_1(:,12), data_dur_REM_2(:,12));
    [h_13,p_13] = ttest2(data_dur_REM_1(:,13), data_dur_REM_2(:,13));
    [h_14,p_14] = ttest2(data_dur_REM_1(:,14), data_dur_REM_2(:,14));
    [h_15,p_15] = ttest2(data_dur_REM_1(:,15), data_dur_REM_2(:,15));
    [h_16,p_16] = ttest2(data_dur_REM_1(:,16), data_dur_REM_2(:,16));
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
    if p_9<0.05; sigstar_MC({[8.8 9.2]},p_9,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_10<0.05; sigstar_MC({[9.8 10.2]},p_10,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_11<0.05; sigstar_MC({[10.8 11.2]},p_11,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_12<0.05; sigstar_MC({[11.8 12.2]},p_12,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_13<0.05; sigstar_MC({[12.8 13.2]},p_13,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_14<0.05; sigstar_MC({[13.8 14.2]},p_14,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_15<0.05; sigstar_MC({[14.8 15.2]},p_15,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if p_16<0.05; sigstar_MC({[15.8 16.2]},p_16,0,'LineWigth',16,'StarSize',24,'plotbar',0);end
elseif iscorr ==1
    %%comparaisons multiples corrigées
    p_values = [p_1 p_2 p_3 p_4 p_5 p_6 p_7 p_8 p_9 p_10 p_11 p_12 p_13 p_14 p_15 p_16];
    [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[0.8 1.2]},adj_p(1),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(2)<0.05; sigstar_MC({[1.8 2.2]},adj_p(2),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(3)<0.05; sigstar_MC({[2.8 3.2]},adj_p(3),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(4)<0.05; sigstar_MC({[3.8 4.2]},adj_p(4),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(5)<0.05; sigstar_MC({[4.8 5.2]},adj_p(5),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(6)<0.05; sigstar_MC({[5.8 6.2]},adj_p(6),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(7)<0.05; sigstar_MC({[6.8 7.2]},adj_p(7),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(8)<0.05; sigstar_MC({[7.8 8.2]},adj_p(8),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(9)<0.05; sigstar_MC({[8.8 9.2]},adj_p(9),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(10)<0.05; sigstar_MC({[9.8 10.2]},adj_p(10),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(11)<0.05; sigstar_MC({[10.8 11.2]},adj_p(11),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(12)<0.05; sigstar_MC({[11.8 12.2]},adj_p(12),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(13)<0.05; sigstar_MC({[12.8 13.2]},adj_p(13),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(14)<0.05; sigstar_MC({[13.8 14.2]},adj_p(14),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(15)<0.05; sigstar_MC({[14.8 15.2]},adj_p(15),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
    if adj_p(16)<0.05; sigstar_MC({[15.8 16.2]},adj_p(16),0,'LineWigth',16,'StarSize',24,'plotbar',0);end
else
end

