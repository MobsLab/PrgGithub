%% To plot the figure you need to load data : 
Get_Data_5groups_inj_1pm_AD.m

%% FIGURE 2 groups
txt_size = 15;
isparam=0;
iscorr=1;

%homo
% col_1 = [.7 .7 .7];
% col_2 = [0 .8 .4];
%hétéro
col_1 = [.4 .4 .4];
col_2 = [0 .6 .2];


figure('color',[1 1 1]), hold on
% suptitle ('xxxxxxxxxxxxx')
% suptitle ('Comparison between SD1 and SD2 saline')
suptitle ('Activation of CRH neurons')

subplot(4,8,[1,2]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_WAKE_1), stdError(data_perc_WAKE_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_perc_WAKE_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_WAKE_2,1), stdError(data_perc_WAKE_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'})
ylabel('Wake percentage')
makepretty
ylim([0 100])
% xlabel('Time after stress (h)')

%%stats wake perc overtime
if isparam ==0
    [p_1,h_1,stats] = ranksum(data_perc_WAKE_1(:,1), data_perc_WAKE_2(:,1));
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


subplot(4,8,[4,5]) % wake num overtime
plot(nanmean(data_num_WAKE_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_WAKE_1), stdError(data_num_WAKE_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_num_WAKE_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_num_WAKE_2,1), stdError(data_num_WAKE_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9 11]); xticklabels({'1','3','5','7','9'}) 
ylabel('Wake bouts number')
makepretty
% xlabel('Time after stress (h)')

%%stats wake num overtime
if isparam ==0
    [p_1,h_1,stats] = ranksum(data_num_WAKE_1(:,1), data_num_WAKE_2(:,1));
    [p_2,h_2, stats] = ranksum(data_num_WAKE_1(:,2), data_num_WAKE_2(:,2));
    [p_3,h_3, stats] = ranksum(data_num_WAKE_1(:,3), data_num_WAKE_2(:,3));
    [p_4,h_4, stats] = ranksum(data_num_WAKE_1(:,4), data_num_WAKE_2(:,4));
    [p_5,h_5, stats] = ranksum(data_num_WAKE_1(:,5), data_num_WAKE_2(:,5));
    [p_6,h_6, stats] = ranksum(data_num_WAKE_1(:,6), data_num_WAKE_2(:,6));
    [p_7,h_7, stats] = ranksum(data_num_WAKE_1(:,7), data_num_WAKE_2(:,7));
    [p_8,h_8, stats] = ranksum(data_num_WAKE_1(:,8), data_num_WAKE_2(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_WAKE_1(:,1), data_num_WAKE_2(:,1));
    [h_2,p_2] = ttest2(data_num_WAKE_1(:,2), data_num_WAKE_2(:,2));
    [h_3,p_3] = ttest2(data_num_WAKE_1(:,3), data_num_WAKE_2(:,3));
    [h_4,p_4] = ttest2(data_num_WAKE_1(:,4), data_num_WAKE_2(:,4));
    [h_5,p_5] = ttest2(data_num_WAKE_1(:,5), data_num_WAKE_2(:,5));
    [h_6,p_6] = ttest2(data_num_WAKE_1(:,6), data_num_WAKE_2(:,6));
    [h_7,p_7] = ttest2(data_num_WAKE_1(:,7), data_num_WAKE_2(:,7));
    [h_8,p_8] = ttest2(data_num_WAKE_1(:,8), data_num_WAKE_2(:,8));
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

subplot(4,8,[7,8]) % wake duration overtime
plot(nanmean(data_dur_WAKE_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_WAKE_1), stdError(data_dur_WAKE_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_WAKE_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_WAKE_2,1), stdError(data_dur_WAKE_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9 11]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('Wake bouts duration')
% xlabel('Time after stress (h)')

%%stats wake dur overtime
if isparam ==0
    [p_1,h_1,stats] = ranksum(data_dur_WAKE_1(:,1), data_dur_WAKE_2(:,1));
    [p_2,h_2, stats] = ranksum(data_dur_WAKE_1(:,2), data_dur_WAKE_2(:,2));
    [p_3,h_3, stats] = ranksum(data_dur_WAKE_1(:,3), data_dur_WAKE_2(:,3));
    [p_4,h_4, stats] = ranksum(data_dur_WAKE_1(:,4), data_dur_WAKE_2(:,4));
    [p_5,h_5, stats] = ranksum(data_dur_WAKE_1(:,5), data_dur_WAKE_2(:,5));
    [p_6,h_6, stats] = ranksum(data_dur_WAKE_1(:,6), data_dur_WAKE_2(:,6));
    [p_7,h_7, stats] = ranksum(data_dur_WAKE_1(:,7), data_dur_WAKE_2(:,7));
    [p_8,h_8, stats] = ranksum(data_dur_WAKE_1(:,8), data_dur_WAKE_2(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_WAKE_1(:,1), data_dur_WAKE_2(:,1));
    [h_2,p_2] = ttest2(data_dur_WAKE_1(:,2), data_dur_WAKE_2(:,2));
    [h_3,p_3] = ttest2(data_dur_WAKE_1(:,3), data_dur_WAKE_2(:,3));
    [h_4,p_4] = ttest2(data_dur_WAKE_1(:,4), data_dur_WAKE_2(:,4));
    [h_5,p_5] = ttest2(data_dur_WAKE_1(:,5), data_dur_WAKE_2(:,5));
    [h_6,p_6] = ttest2(data_dur_WAKE_1(:,6), data_dur_WAKE_2(:,6));
    [h_7,p_7] = ttest2(data_dur_WAKE_1(:,7), data_dur_WAKE_2(:,7));
    [h_8,p_8] = ttest2(data_dur_WAKE_1(:,8), data_dur_WAKE_2(:,8));
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


subplot(4,8,[9,10]), hold on % SWS percentage overtime
plot(nanmean(data_perc_SWS_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_SWS_1), stdError(data_perc_SWS_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_perc_SWS_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_SWS_2,1), stdError(data_perc_SWS_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9 11]); xticklabels({'1','3','5','7','9'}) 
ylim([0 100])
makepretty
ylabel('NREM percentage')
% xlabel('Time after stress (h)')

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

subplot(4,8,[12,13]), hold on % SWS number overtime
plot(nanmean(data_num_SWS_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_SWS_1), stdError(data_num_SWS_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_num_SWS_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_num_SWS_2,1), stdError(data_num_SWS_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9 11]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('NREM bouts number')
% xlabel('Time after stress (h)')

%%stats all SWS num overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_num_SWS_1(:,1), data_num_SWS_2(:,1));
    [p_2,h_2, stats] = ranksum(data_num_SWS_1(:,2), data_num_SWS_2(:,2));
    [p_3,h_3, stats] = ranksum(data_num_SWS_1(:,3), data_num_SWS_2(:,3));
    [p_4,h_4, stats] = ranksum(data_num_SWS_1(:,4), data_num_SWS_2(:,4));
    [p_5,h_5, stats] = ranksum(data_num_SWS_1(:,5), data_num_SWS_2(:,5));
    [p_6,h_6, stats] = ranksum(data_num_SWS_1(:,6), data_num_SWS_2(:,6));
    [p_7,h_7, stats] = ranksum(data_num_SWS_1(:,7), data_num_SWS_2(:,7));
    [p_8,h_8, stats] = ranksum(data_num_SWS_1(:,8), data_num_SWS_2(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_SWS_1(:,1), data_num_SWS_2(:,1));
    [h_2,p_2] = ttest2(data_num_SWS_1(:,2), data_num_SWS_2(:,2));
    [h_3,p_3] = ttest2(data_num_SWS_1(:,3), data_num_SWS_2(:,3));
    [h_4,p_4] = ttest2(data_num_SWS_1(:,4), data_num_SWS_2(:,4));
    [h_5,p_5] = ttest2(data_num_SWS_1(:,5), data_num_SWS_2(:,5));
    [h_6,p_6] = ttest2(data_num_SWS_1(:,6), data_num_SWS_2(:,6));
    [h_7,p_7] = ttest2(data_num_SWS_1(:,7), data_num_SWS_2(:,7));
    [h_8,p_8] = ttest2(data_num_SWS_1(:,8), data_num_SWS_2(:,8));
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

subplot(4,8,[15,16]), hold on % SWS duration overtime
plot(nanmean(data_dur_SWS_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_SWS_1), stdError(data_dur_SWS_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_SWS_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_SWS_2,1), stdError(data_dur_SWS_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9 11]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('NREM bouts duration')
% xlabel('Time after stress (h)')

%%stats all SWS dur overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_dur_SWS_1(:,1), data_dur_SWS_2(:,1));
    [p_2,h_2, stats] = ranksum(data_dur_SWS_1(:,2), data_dur_SWS_2(:,2));
    [p_3,h_3, stats] = ranksum(data_dur_SWS_1(:,3), data_dur_SWS_2(:,3));
    [p_4,h_4, stats] = ranksum(data_dur_SWS_1(:,4), data_dur_SWS_2(:,4));
    [p_5,h_5, stats] = ranksum(data_dur_SWS_1(:,5), data_dur_SWS_2(:,5));
    [p_6,h_6, stats] = ranksum(data_dur_SWS_1(:,6), data_dur_SWS_2(:,6));
    [p_7,h_7, stats] = ranksum(data_dur_SWS_1(:,7), data_dur_SWS_2(:,7));
    [p_8,h_8, stats] = ranksum(data_dur_SWS_1(:,8), data_dur_SWS_2(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_SWS_1(:,1), data_dur_SWS_2(:,1));
    [h_2,p_2] = ttest2(data_dur_SWS_1(:,2), data_dur_SWS_2(:,2));
    [h_3,p_3] = ttest2(data_dur_SWS_1(:,3), data_dur_SWS_2(:,3));
    [h_4,p_4] = ttest2(data_dur_SWS_1(:,4), data_dur_SWS_2(:,4));
    [h_5,p_5] = ttest2(data_dur_SWS_1(:,5), data_dur_SWS_2(:,5));
    [h_6,p_6] = ttest2(data_dur_SWS_1(:,6), data_dur_SWS_2(:,6));
    [h_7,p_7] = ttest2(data_dur_SWS_1(:,7), data_dur_SWS_2(:,7));
    [h_8,p_8] = ttest2(data_dur_SWS_1(:,8), data_dur_SWS_2(:,8));
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


subplot(4,8,[17,18]) %REM percentage overtime
plot(nanmean(data_perc_REM_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_perc_REM_1), stdError(data_perc_REM_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_perc_REM_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_perc_REM_2,1), stdError(data_perc_REM_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9 11]); xticklabels({'1','3','5','7','9'}) 
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

subplot(4,8,[20,21]) %REM number overtime
plot(nanmean(data_num_REM_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_num_REM_1), stdError(data_num_REM_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_num_REM_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_num_REM_2,1), stdError(data_num_REM_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9 11]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM bouts number')
xlabel('Time after stress (h)')

%%stats all REM num overtime
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

subplot(4,8,[23,24]) % REM bouts duration ovetime
plot(nanmean(data_dur_REM_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_REM_1), stdError(data_dur_REM_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_REM_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_REM_2,1), stdError(data_dur_REM_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 9.5])
xticks([1 3 5 7 9 11]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM bouts duration')
xlabel('Time after stress (h)')

%%stats all REM dur overtime
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

