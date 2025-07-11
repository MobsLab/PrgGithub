%% To plot the figure you need to load data : 
Get_sleep_data_post_SDS_MC


%% FIGURE : quantification ovetime w/ all stages (perc, num, mean dur)
col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];

isparam = 0; %%use parametric test
iscorr = 1; %%show corrected pvalues

figure, hold on
subplot(4,7,[1,2],'align') % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('Wake percentage')
%%stats wake perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_WAKE_ctrl(:,1), data_perc_WAKE_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_WAKE_ctrl(:,2), data_perc_WAKE_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_WAKE_ctrl(:,3), data_perc_WAKE_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_WAKE_ctrl(:,4), data_perc_WAKE_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_WAKE_ctrl(:,5), data_perc_WAKE_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_WAKE_ctrl(:,6), data_perc_WAKE_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_WAKE_ctrl(:,7), data_perc_WAKE_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_WAKE_ctrl(:,8), data_perc_WAKE_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_WAKE_ctrl(:,1), data_perc_WAKE_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_WAKE_ctrl(:,2), data_perc_WAKE_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_WAKE_ctrl(:,3), data_perc_WAKE_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_WAKE_ctrl(:,4), data_perc_WAKE_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_WAKE_ctrl(:,5), data_perc_WAKE_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_WAKE_ctrl(:,6), data_perc_WAKE_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_WAKE_ctrl(:,7), data_perc_WAKE_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_WAKE_ctrl(:,8), data_perc_WAKE_SD(:,8));
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


subplot(4,7,[8,9],'align'), hold on % Sleep percentage overtime
plot(nanmean(data_perc_totSleep_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_totSleep_ctrl), stdError(data_perc_totSleep_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_totSleep_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_totSleep_SD), stdError(data_perc_totSleep_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('Sleep percentage')
%%stats all sleep perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_totSleep_ctrl(:,1), data_perc_totSleep_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_totSleep_ctrl(:,2), data_perc_totSleep_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_totSleep_ctrl(:,3), data_perc_totSleep_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_totSleep_ctrl(:,4), data_perc_totSleep_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_totSleep_ctrl(:,5), data_perc_totSleep_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_totSleep_ctrl(:,6), data_perc_totSleep_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_totSleep_ctrl(:,7), data_perc_totSleep_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_totSleep_ctrl(:,8), data_perc_totSleep_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_totSleep_ctrl(:,1), data_perc_totSleep_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_totSleep_ctrl(:,2), data_perc_totSleep_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_totSleep_ctrl(:,3), data_perc_totSleep_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_totSleep_ctrl(:,4), data_perc_totSleep_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_totSleep_ctrl(:,5), data_perc_totSleep_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_totSleep_ctrl(:,6), data_perc_totSleep_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_totSleep_ctrl(:,7), data_perc_totSleep_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_totSleep_ctrl(:,8), data_perc_totSleep_SD(:,8));
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


subplot(4,7,[15,16],'align'), hold on
plot(nanmean(data_perc_SWS_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_SWS_ctrl), stdError(data_perc_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('NREM percentage')
%%stats all SWS perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_SWS_ctrl(:,1), data_perc_SWS_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_SWS_ctrl(:,2), data_perc_SWS_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_SWS_ctrl(:,3), data_perc_SWS_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_SWS_ctrl(:,4), data_perc_SWS_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_SWS_ctrl(:,5), data_perc_SWS_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_SWS_ctrl(:,6), data_perc_SWS_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_SWS_ctrl(:,7), data_perc_SWS_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_SWS_ctrl(:,8), data_perc_SWS_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_SWS_ctrl(:,1), data_perc_SWS_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_SWS_ctrl(:,2), data_perc_SWS_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_SWS_ctrl(:,3), data_perc_SWS_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_SWS_ctrl(:,4), data_perc_SWS_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_SWS_ctrl(:,5), data_perc_SWS_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_SWS_ctrl(:,6), data_perc_SWS_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_SWS_ctrl(:,7), data_perc_SWS_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_SWS_ctrl(:,8), data_perc_SWS_SD(:,8));
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


subplot(4,7,[22,23],'align') %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('REM percentage')
%%stats all REM perc overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_perc_REM_ctrl(:,1), data_perc_REM_SD(:,1));
    [p_2,h_2] = ranksum(data_perc_REM_ctrl(:,2), data_perc_REM_SD(:,2));
    [p_3,h_3] = ranksum(data_perc_REM_ctrl(:,3), data_perc_REM_SD(:,3));
    [p_4,h_4] = ranksum(data_perc_REM_ctrl(:,4), data_perc_REM_SD(:,4));
    [p_5,h_5] = ranksum(data_perc_REM_ctrl(:,5), data_perc_REM_SD(:,5));
    [p_6,h_6] = ranksum(data_perc_REM_ctrl(:,6), data_perc_REM_SD(:,6));
    [p_7,h_7] = ranksum(data_perc_REM_ctrl(:,7), data_perc_REM_SD(:,7));
    [p_8,h_8] = ranksum(data_perc_REM_ctrl(:,8), data_perc_REM_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_REM_ctrl(:,1), data_perc_REM_SD(:,1));
    [h_2,p_2] = ttest2(data_perc_REM_ctrl(:,2), data_perc_REM_SD(:,2));
    [h_3,p_3] = ttest2(data_perc_REM_ctrl(:,3), data_perc_REM_SD(:,3));
    [h_4,p_4] = ttest2(data_perc_REM_ctrl(:,4), data_perc_REM_SD(:,4));
    [h_5,p_5] = ttest2(data_perc_REM_ctrl(:,5), data_perc_REM_SD(:,5));
    [h_6,p_6] = ttest2(data_perc_REM_ctrl(:,6), data_perc_REM_SD(:,6));
    [h_7,p_7] = ttest2(data_perc_REM_ctrl(:,7), data_perc_REM_SD(:,7));
    [h_8,p_8] = ttest2(data_perc_REM_ctrl(:,8), data_perc_REM_SD(:,8));
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


subplot(4,7,[3,4],'align') % wake numentage overtime
plot(nanmean(data_num_WAKE_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_WAKE_ctrl), stdError(data_num_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_num_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_WAKE_SD), stdError(data_num_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('Wake bouts number')
%%stats wake num overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_num_WAKE_ctrl(:,1), data_num_WAKE_SD(:,1));
    [p_2,h_2] = ranksum(data_num_WAKE_ctrl(:,2), data_num_WAKE_SD(:,2));
    [p_3,h_3] = ranksum(data_num_WAKE_ctrl(:,3), data_num_WAKE_SD(:,3));
    [p_4,h_4] = ranksum(data_num_WAKE_ctrl(:,4), data_num_WAKE_SD(:,4));
    [p_5,h_5] = ranksum(data_num_WAKE_ctrl(:,5), data_num_WAKE_SD(:,5));
    [p_6,h_6] = ranksum(data_num_WAKE_ctrl(:,6), data_num_WAKE_SD(:,6));
    [p_7,h_7] = ranksum(data_num_WAKE_ctrl(:,7), data_num_WAKE_SD(:,7));
    [p_8,h_8] = ranksum(data_num_WAKE_ctrl(:,8), data_num_WAKE_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_WAKE_ctrl(:,1), data_num_WAKE_SD(:,1));
    [h_2,p_2] = ttest2(data_num_WAKE_ctrl(:,2), data_num_WAKE_SD(:,2));
    [h_3,p_3] = ttest2(data_num_WAKE_ctrl(:,3), data_num_WAKE_SD(:,3));
    [h_4,p_4] = ttest2(data_num_WAKE_ctrl(:,4), data_num_WAKE_SD(:,4));
    [h_5,p_5] = ttest2(data_num_WAKE_ctrl(:,5), data_num_WAKE_SD(:,5));
    [h_6,p_6] = ttest2(data_num_WAKE_ctrl(:,6), data_num_WAKE_SD(:,6));
    [h_7,p_7] = ttest2(data_num_WAKE_ctrl(:,7), data_num_WAKE_SD(:,7));
    [h_8,p_8] = ttest2(data_num_WAKE_ctrl(:,8), data_num_WAKE_SD(:,8));
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


subplot(4,7,[10,11],'align'), hold on % Sleep numentage overtime
plot(nanmean(data_num_totSleep_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_totSleep_ctrl), stdError(data_num_totSleep_ctrl),'color',col_ctrl)
plot(nanmean(data_num_totSleep_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_totSleep_SD), stdError(data_num_totSleep_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('Sleep bouts number')
%%stats SLEEP num overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_num_totSleep_ctrl(:,1), data_num_totSleep_SD(:,1));
    [p_2,h_2] = ranksum(data_num_totSleep_ctrl(:,2), data_num_totSleep_SD(:,2));
    [p_3,h_3] = ranksum(data_num_totSleep_ctrl(:,3), data_num_totSleep_SD(:,3));
    [p_4,h_4] = ranksum(data_num_totSleep_ctrl(:,4), data_num_totSleep_SD(:,4));
    [p_5,h_5] = ranksum(data_num_totSleep_ctrl(:,5), data_num_totSleep_SD(:,5));
    [p_6,h_6] = ranksum(data_num_totSleep_ctrl(:,6), data_num_totSleep_SD(:,6));
    [p_7,h_7] = ranksum(data_num_totSleep_ctrl(:,7), data_num_totSleep_SD(:,7));
    [p_8,h_8] = ranksum(data_num_totSleep_ctrl(:,8), data_num_totSleep_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_totSleep_ctrl(:,1), data_num_totSleep_SD(:,1));
    [h_2,p_2] = ttest2(data_num_totSleep_ctrl(:,2), data_num_totSleep_SD(:,2));
    [h_3,p_3] = ttest2(data_num_totSleep_ctrl(:,3), data_num_totSleep_SD(:,3));
    [h_4,p_4] = ttest2(data_num_totSleep_ctrl(:,4), data_num_totSleep_SD(:,4));
    [h_5,p_5] = ttest2(data_num_totSleep_ctrl(:,5), data_num_totSleep_SD(:,5));
    [h_6,p_6] = ttest2(data_num_totSleep_ctrl(:,6), data_num_totSleep_SD(:,6));
    [h_7,p_7] = ttest2(data_num_totSleep_ctrl(:,7), data_num_totSleep_SD(:,7));
    [h_8,p_8] = ttest2(data_num_totSleep_ctrl(:,8), data_num_totSleep_SD(:,8));
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


subplot(4,7,[17,18],'align'), hold on
plot(nanmean(data_num_SWS_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_SWS_ctrl), stdError(data_num_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_num_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_SWS_SD), stdError(data_num_SWS_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('NREM bouts number')
%%stats SWS num overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_num_SWS_ctrl(:,1), data_num_SWS_SD(:,1));
    [p_2,h_2] = ranksum(data_num_SWS_ctrl(:,2), data_num_SWS_SD(:,2));
    [p_3,h_3] = ranksum(data_num_SWS_ctrl(:,3), data_num_SWS_SD(:,3));
    [p_4,h_4] = ranksum(data_num_SWS_ctrl(:,4), data_num_SWS_SD(:,4));
    [p_5,h_5] = ranksum(data_num_SWS_ctrl(:,5), data_num_SWS_SD(:,5));
    [p_6,h_6] = ranksum(data_num_SWS_ctrl(:,6), data_num_SWS_SD(:,6));
    [p_7,h_7] = ranksum(data_num_SWS_ctrl(:,7), data_num_SWS_SD(:,7));
    [p_8,h_8] = ranksum(data_num_SWS_ctrl(:,8), data_num_SWS_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_SWS_ctrl(:,1), data_num_SWS_SD(:,1));
    [h_2,p_2] = ttest2(data_num_SWS_ctrl(:,2), data_num_SWS_SD(:,2));
    [h_3,p_3] = ttest2(data_num_SWS_ctrl(:,3), data_num_SWS_SD(:,3));
    [h_4,p_4] = ttest2(data_num_SWS_ctrl(:,4), data_num_SWS_SD(:,4));
    [h_5,p_5] = ttest2(data_num_SWS_ctrl(:,5), data_num_SWS_SD(:,5));
    [h_6,p_6] = ttest2(data_num_SWS_ctrl(:,6), data_num_SWS_SD(:,6));
    [h_7,p_7] = ttest2(data_num_SWS_ctrl(:,7), data_num_SWS_SD(:,7));
    [h_8,p_8] = ttest2(data_num_SWS_ctrl(:,8), data_num_SWS_SD(:,8));
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


subplot(4,7,[24,25],'align') %REM numentage overtime
plot(nanmean(data_num_REM_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_REM_ctrl), stdError(data_num_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('REM bouts number')
%%stats REM num overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_num_REM_ctrl(:,1), data_num_REM_SD(:,1));
    [p_2,h_2] = ranksum(data_num_REM_ctrl(:,2), data_num_REM_SD(:,2));
    [p_3,h_3] = ranksum(data_num_REM_ctrl(:,3), data_num_REM_SD(:,3));
    [p_4,h_4] = ranksum(data_num_REM_ctrl(:,4), data_num_REM_SD(:,4));
    [p_5,h_5] = ranksum(data_num_REM_ctrl(:,5), data_num_REM_SD(:,5));
    [p_6,h_6] = ranksum(data_num_REM_ctrl(:,6), data_num_REM_SD(:,6));
    [p_7,h_7] = ranksum(data_num_REM_ctrl(:,7), data_num_REM_SD(:,7));
    [p_8,h_8] = ranksum(data_num_REM_ctrl(:,8), data_num_REM_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_REM_ctrl(:,1), data_num_REM_SD(:,1));
    [h_2,p_2] = ttest2(data_num_REM_ctrl(:,2), data_num_REM_SD(:,2));
    [h_3,p_3] = ttest2(data_num_REM_ctrl(:,3), data_num_REM_SD(:,3));
    [h_4,p_4] = ttest2(data_num_REM_ctrl(:,4), data_num_REM_SD(:,4));
    [h_5,p_5] = ttest2(data_num_REM_ctrl(:,5), data_num_REM_SD(:,5));
    [h_6,p_6] = ttest2(data_num_REM_ctrl(:,6), data_num_REM_SD(:,6));
    [h_7,p_7] = ttest2(data_num_REM_ctrl(:,7), data_num_REM_SD(:,7));
    [h_8,p_8] = ttest2(data_num_REM_ctrl(:,8), data_num_REM_SD(:,8));
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


subplot(4,7,[5,6],'align') % wake durentage overtime
plot(nanmean(data_dur_WAKE_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_WAKE_ctrl), stdError(data_dur_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_WAKE_SD), stdError(data_dur_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('Wake bouts duration (s)')
%%stats wake dur overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_dur_WAKE_ctrl(:,1), data_dur_WAKE_SD(:,1));
    [p_2,h_2] = ranksum(data_dur_WAKE_ctrl(:,2), data_dur_WAKE_SD(:,2));
    [p_3,h_3] = ranksum(data_dur_WAKE_ctrl(:,3), data_dur_WAKE_SD(:,3));
    [p_4,h_4] = ranksum(data_dur_WAKE_ctrl(:,4), data_dur_WAKE_SD(:,4));
    [p_5,h_5] = ranksum(data_dur_WAKE_ctrl(:,5), data_dur_WAKE_SD(:,5));
    [p_6,h_6] = ranksum(data_dur_WAKE_ctrl(:,6), data_dur_WAKE_SD(:,6));
    [p_7,h_7] = ranksum(data_dur_WAKE_ctrl(:,7), data_dur_WAKE_SD(:,7));
    [p_8,h_8] = ranksum(data_dur_WAKE_ctrl(:,8), data_dur_WAKE_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_WAKE_ctrl(:,1), data_dur_WAKE_SD(:,1));
    [h_2,p_2] = ttest2(data_dur_WAKE_ctrl(:,2), data_dur_WAKE_SD(:,2));
    [h_3,p_3] = ttest2(data_dur_WAKE_ctrl(:,3), data_dur_WAKE_SD(:,3));
    [h_4,p_4] = ttest2(data_dur_WAKE_ctrl(:,4), data_dur_WAKE_SD(:,4));
    [h_5,p_5] = ttest2(data_dur_WAKE_ctrl(:,5), data_dur_WAKE_SD(:,5));
    [h_6,p_6] = ttest2(data_dur_WAKE_ctrl(:,6), data_dur_WAKE_SD(:,6));
    [h_7,p_7] = ttest2(data_dur_WAKE_ctrl(:,7), data_dur_WAKE_SD(:,7));
    [h_8,p_8] = ttest2(data_dur_WAKE_ctrl(:,8), data_dur_WAKE_SD(:,8));
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


subplot(4,7,[12,13],'align'), hold on % Sleep durentage overtime
plot(nanmean(data_dur_totSleep_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_totSleep_ctrl), stdError(data_dur_totSleep_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_totSleep_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_totSleep_SD), stdError(data_dur_totSleep_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('Sleep bouts duration (s)')
%%stats SLEEP dur overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_dur_totSleep_ctrl(:,1), data_dur_totSleep_SD(:,1));
    [p_2,h_2] = ranksum(data_dur_totSleep_ctrl(:,2), data_dur_totSleep_SD(:,2));
    [p_3,h_3] = ranksum(data_dur_totSleep_ctrl(:,3), data_dur_totSleep_SD(:,3));
    [p_4,h_4] = ranksum(data_dur_totSleep_ctrl(:,4), data_dur_totSleep_SD(:,4));
    [p_5,h_5] = ranksum(data_dur_totSleep_ctrl(:,5), data_dur_totSleep_SD(:,5));
    [p_6,h_6] = ranksum(data_dur_totSleep_ctrl(:,6), data_dur_totSleep_SD(:,6));
    [p_7,h_7] = ranksum(data_dur_totSleep_ctrl(:,7), data_dur_totSleep_SD(:,7));
    [p_8,h_8] = ranksum(data_dur_totSleep_ctrl(:,8), data_dur_totSleep_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_totSleep_ctrl(:,1), data_dur_totSleep_SD(:,1));
    [h_2,p_2] = ttest2(data_dur_totSleep_ctrl(:,2), data_dur_totSleep_SD(:,2));
    [h_3,p_3] = ttest2(data_dur_totSleep_ctrl(:,3), data_dur_totSleep_SD(:,3));
    [h_4,p_4] = ttest2(data_dur_totSleep_ctrl(:,4), data_dur_totSleep_SD(:,4));
    [h_5,p_5] = ttest2(data_dur_totSleep_ctrl(:,5), data_dur_totSleep_SD(:,5));
    [h_6,p_6] = ttest2(data_dur_totSleep_ctrl(:,6), data_dur_totSleep_SD(:,6));
    [h_7,p_7] = ttest2(data_dur_totSleep_ctrl(:,7), data_dur_totSleep_SD(:,7));
    [h_8,p_8] = ttest2(data_dur_totSleep_ctrl(:,8), data_dur_totSleep_SD(:,8));
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


subplot(4,7,[19,20],'align'), hold on
plot(nanmean(data_dur_SWS_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_SWS_ctrl), stdError(data_dur_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_SWS_SD), stdError(data_dur_SWS_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('NREM bouts duration (s)')
%%stats SWS dur overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_dur_SWS_ctrl(:,1), data_dur_SWS_SD(:,1));
    [p_2,h_2] = ranksum(data_dur_SWS_ctrl(:,2), data_dur_SWS_SD(:,2));
    [p_3,h_3] = ranksum(data_dur_SWS_ctrl(:,3), data_dur_SWS_SD(:,3));
    [p_4,h_4] = ranksum(data_dur_SWS_ctrl(:,4), data_dur_SWS_SD(:,4));
    [p_5,h_5] = ranksum(data_dur_SWS_ctrl(:,5), data_dur_SWS_SD(:,5));
    [p_6,h_6] = ranksum(data_dur_SWS_ctrl(:,6), data_dur_SWS_SD(:,6));
    [p_7,h_7] = ranksum(data_dur_SWS_ctrl(:,7), data_dur_SWS_SD(:,7));
    [p_8,h_8] = ranksum(data_dur_SWS_ctrl(:,8), data_dur_SWS_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_SWS_ctrl(:,1), data_dur_SWS_SD(:,1));
    [h_2,p_2] = ttest2(data_dur_SWS_ctrl(:,2), data_dur_SWS_SD(:,2));
    [h_3,p_3] = ttest2(data_dur_SWS_ctrl(:,3), data_dur_SWS_SD(:,3));
    [h_4,p_4] = ttest2(data_dur_SWS_ctrl(:,4), data_dur_SWS_SD(:,4));
    [h_5,p_5] = ttest2(data_dur_SWS_ctrl(:,5), data_dur_SWS_SD(:,5));
    [h_6,p_6] = ttest2(data_dur_SWS_ctrl(:,6), data_dur_SWS_SD(:,6));
    [h_7,p_7] = ttest2(data_dur_SWS_ctrl(:,7), data_dur_SWS_SD(:,7));
    [h_8,p_8] = ttest2(data_dur_SWS_ctrl(:,8), data_dur_SWS_SD(:,8));
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


subplot(4,7,[26,27],'align') %REM durentage overtime
plot(nanmean(data_dur_REM_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_REM_ctrl), stdError(data_dur_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('REM bouts duration (s)')
%%stats REM dur overtime
if isparam ==0
    [p_1,h_1] = ranksum(data_dur_REM_ctrl(:,1), data_dur_REM_SD(:,1));
    [p_2,h_2] = ranksum(data_dur_REM_ctrl(:,2), data_dur_REM_SD(:,2));
    [p_3,h_3] = ranksum(data_dur_REM_ctrl(:,3), data_dur_REM_SD(:,3));
    [p_4,h_4] = ranksum(data_dur_REM_ctrl(:,4), data_dur_REM_SD(:,4));
    [p_5,h_5] = ranksum(data_dur_REM_ctrl(:,5), data_dur_REM_SD(:,5));
    [p_6,h_6] = ranksum(data_dur_REM_ctrl(:,6), data_dur_REM_SD(:,6));
    [p_7,h_7] = ranksum(data_dur_REM_ctrl(:,7), data_dur_REM_SD(:,7));
    [p_8,h_8] = ranksum(data_dur_REM_ctrl(:,8), data_dur_REM_SD(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_REM_ctrl(:,1), data_dur_REM_SD(:,1));
    [h_2,p_2] = ttest2(data_dur_REM_ctrl(:,2), data_dur_REM_SD(:,2));
    [h_3,p_3] = ttest2(data_dur_REM_ctrl(:,3), data_dur_REM_SD(:,3));
    [h_4,p_4] = ttest2(data_dur_REM_ctrl(:,4), data_dur_REM_SD(:,4));
    [h_5,p_5] = ttest2(data_dur_REM_ctrl(:,5), data_dur_REM_SD(:,5));
    [h_6,p_6] = ttest2(data_dur_REM_ctrl(:,6), data_dur_REM_SD(:,6));
    [h_7,p_7] = ttest2(data_dur_REM_ctrl(:,7), data_dur_REM_SD(:,7));
    [h_8,p_8] = ttest2(data_dur_REM_ctrl(:,8), data_dur_REM_SD(:,8));
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











