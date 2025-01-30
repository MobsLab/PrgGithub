%% To plot the figure you need to load data : 
Get_sleep_data_Sal_basal_C57_CRH_AD


%% FIGURE 2
txt_size = 15;


% C57/CRH saline
col_sal_C57 = [.7 .7 .7];
col_sal_CRH = [1 .4 0];

isparam=0;
iscorr=1;

figure ('color',[1 1 1]), hold on
subplot(3,6,[1,2]) % wake percentage overtime
p1 = plotSpread(data_perc_WAKE_sal_C57,'distributionColors',col_sal_C57,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_perc_WAKE_sal_C57), stdError(data_perc_WAKE_sal_C57),'LineWidth',2,'color',col_sal_C57);
p2 = plotSpread(data_perc_WAKE_sal_CRH,'distributionColors',col_sal_CRH,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_perc_WAKE_sal_CRH), stdError(data_perc_WAKE_sal_CRH),'LineWidth',2,'color',col_sal_CRH);
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
ylim([0 100])
makepretty
set(p1{1},'MarkerSize',10);
set(p2{1},'MarkerSize',10);
title('Wake percentage')
xlabel('Time of the day (h)')
ylabel('%')

%%stats wake perc overtime
if isparam ==0
    [p_1,h_1,stats] = ranksum(data_perc_WAKE_sal_C57(:,1), data_perc_WAKE_sal_CRH(:,1));
    [p_2,h_2, stats] = ranksum(data_perc_WAKE_sal_C57(:,2), data_perc_WAKE_sal_CRH(:,2));
    [p_3,h_3, stats] = ranksum(data_perc_WAKE_sal_C57(:,3), data_perc_WAKE_sal_CRH(:,3));
    [p_4,h_4, stats] = ranksum(data_perc_WAKE_sal_C57(:,4), data_perc_WAKE_sal_CRH(:,4));
    [p_5,h_5, stats] = ranksum(data_perc_WAKE_sal_C57(:,5), data_perc_WAKE_sal_CRH(:,5));
    [p_6,h_6, stats] = ranksum(data_perc_WAKE_sal_C57(:,6), data_perc_WAKE_sal_CRH(:,6));
    [p_7,h_7, stats] = ranksum(data_perc_WAKE_sal_C57(:,7), data_perc_WAKE_sal_CRH(:,7));
    [p_8,h_8, stats] = ranksum(data_perc_WAKE_sal_C57(:,8), data_perc_WAKE_sal_CRH(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_WAKE_sal_C57(:,1), data_perc_WAKE_sal_CRH(:,1));
    [h_2,p_2] = ttest2(data_perc_WAKE_sal_C57(:,2), data_perc_WAKE_sal_CRH(:,2));
    [h_3,p_3] = ttest2(data_perc_WAKE_sal_C57(:,3), data_perc_WAKE_sal_CRH(:,3));
    [h_4,p_4] = ttest2(data_perc_WAKE_sal_C57(:,4), data_perc_WAKE_sal_CRH(:,4));
    [h_5,p_5] = ttest2(data_perc_WAKE_sal_C57(:,5), data_perc_WAKE_sal_CRH(:,5));
    [h_6,p_6] = ttest2(data_perc_WAKE_sal_C57(:,6), data_perc_WAKE_sal_CRH(:,6));
    [h_7,p_7] = ttest2(data_perc_WAKE_sal_C57(:,7), data_perc_WAKE_sal_CRH(:,7));
    [h_8,p_8] = ttest2(data_perc_WAKE_sal_C57(:,8), data_perc_WAKE_sal_CRH(:,8));
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

subplot(3,6,[3,4]) % wake num overtime
p1 = plotSpread(data_num_WAKE_sal_C57,'distributionColors',col_sal_C57,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_num_WAKE_sal_C57), stdError(data_num_WAKE_sal_C57),'LineWidth',2,'color',col_sal_C57);
p2 = plotSpread(data_num_WAKE_sal_CRH,'distributionColors',col_sal_CRH,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_num_WAKE_sal_CRH), stdError(data_num_WAKE_sal_CRH),'LineWidth',2,'color',col_sal_CRH);
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
set(p1{1},'MarkerSize',10);
set(p2{1},'MarkerSize',10);
title('Wake bouts number')
xlabel('Time of the day (h)')
ylabel('#')

%%stats wake num overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_num_WAKE_sal_C57(:,1), data_num_WAKE_sal_CRH(:,1));
    [p_2,h_2, stats] = ranksum(data_num_WAKE_sal_C57(:,2), data_num_WAKE_sal_CRH(:,2));
    [p_3,h_3, stats] = ranksum(data_num_WAKE_sal_C57(:,3), data_num_WAKE_sal_CRH(:,3));
    [p_4,h_4, stats] = ranksum(data_num_WAKE_sal_C57(:,4), data_num_WAKE_sal_CRH(:,4));
    [p_5,h_5, stats] = ranksum(data_num_WAKE_sal_C57(:,5), data_num_WAKE_sal_CRH(:,5));
    [p_6,h_6, stats] = ranksum(data_num_WAKE_sal_C57(:,6), data_num_WAKE_sal_CRH(:,6));
    [p_7,h_7, stats] = ranksum(data_num_WAKE_sal_C57(:,7), data_num_WAKE_sal_CRH(:,7));
    [p_8,h_8, stats] = ranksum(data_num_WAKE_sal_C57(:,8), data_num_WAKE_sal_CRH(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_WAKE_sal_C57(:,1), data_num_WAKE_sal_CRH(:,1));
    [h_2,p_2] = ttest2(data_num_WAKE_sal_C57(:,2), data_num_WAKE_sal_CRH(:,2));
    [h_3,p_3] = ttest2(data_num_WAKE_sal_C57(:,3), data_num_WAKE_sal_CRH(:,3));
    [h_4,p_4] = ttest2(data_num_WAKE_sal_C57(:,4), data_num_WAKE_sal_CRH(:,4));
    [h_5,p_5] = ttest2(data_num_WAKE_sal_C57(:,5), data_num_WAKE_sal_CRH(:,5));
    [h_6,p_6] = ttest2(data_num_WAKE_sal_C57(:,6), data_num_WAKE_sal_CRH(:,6));
    [h_7,p_7] = ttest2(data_num_WAKE_sal_C57(:,7), data_num_WAKE_sal_CRH(:,7));
    [h_8,p_8] = ttest2(data_num_WAKE_sal_C57(:,8), data_num_WAKE_sal_CRH(:,8));
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

subplot(3,6,[5,6]) % wake duration overtime
p1 = plotSpread(data_dur_WAKE_sal_C57,'distributionColors',col_sal_C57,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_dur_WAKE_sal_C57), stdError(data_dur_WAKE_sal_C57),'LineWidth',2,'color',col_sal_C57);
p2 = plotSpread(data_dur_WAKE_sal_CRH,'distributionColors',col_sal_CRH,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_dur_WAKE_sal_CRH), stdError(data_dur_WAKE_sal_CRH),'LineWidth',2,'color',col_sal_CRH);
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
set(p1{1},'MarkerSize',10);
set(p2{1},'MarkerSize',10);
title('Wake bouts duration')
xlabel('Time of the day (h)')
ylabel('Dur')

%%stats wake dur overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_dur_WAKE_sal_C57(:,1), data_dur_WAKE_sal_CRH(:,1));
    [p_2,h_2, stats] = ranksum(data_dur_WAKE_sal_C57(:,2), data_dur_WAKE_sal_CRH(:,2));
    [p_3,h_3, stats] = ranksum(data_dur_WAKE_sal_C57(:,3), data_dur_WAKE_sal_CRH(:,3));
    [p_4,h_4, stats] = ranksum(data_dur_WAKE_sal_C57(:,4), data_dur_WAKE_sal_CRH(:,4));
    [p_5,h_5, stats] = ranksum(data_dur_WAKE_sal_C57(:,5), data_dur_WAKE_sal_CRH(:,5));
    [p_6,h_6, stats] = ranksum(data_dur_WAKE_sal_C57(:,6), data_dur_WAKE_sal_CRH(:,6));
    [p_7,h_7, stats] = ranksum(data_dur_WAKE_sal_C57(:,7), data_dur_WAKE_sal_CRH(:,7));
    [p_8,h_8, stats] = ranksum(data_dur_WAKE_sal_C57(:,8), data_dur_WAKE_sal_CRH(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_WAKE_sal_C57(:,1), data_dur_WAKE_sal_CRH(:,1));
    [h_2,p_2] = ttest2(data_dur_WAKE_sal_C57(:,2), data_dur_WAKE_sal_CRH(:,2));
    [h_3,p_3] = ttest2(data_dur_WAKE_sal_C57(:,3), data_dur_WAKE_sal_CRH(:,3));
    [h_4,p_4] = ttest2(data_dur_WAKE_sal_C57(:,4), data_dur_WAKE_sal_CRH(:,4));
    [h_5,p_5] = ttest2(data_dur_WAKE_sal_C57(:,5), data_dur_WAKE_sal_CRH(:,5));
    [h_6,p_6] = ttest2(data_dur_WAKE_sal_C57(:,6), data_dur_WAKE_sal_CRH(:,6));
    [h_7,p_7] = ttest2(data_dur_WAKE_sal_C57(:,7), data_dur_WAKE_sal_CRH(:,7));
    [h_8,p_8] = ttest2(data_dur_WAKE_sal_C57(:,8), data_dur_WAKE_sal_CRH(:,8));
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

subplot(3,6,[7,8]), hold on % SWS percentage overtime
p1 = plotSpread(data_perc_SWS_sal_C57,'distributionColors',col_sal_C57,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_perc_SWS_sal_C57), stdError(data_perc_SWS_sal_C57),'LineWidth',2,'color',col_sal_C57);
p2 = plotSpread(data_perc_SWS_sal_CRH,'distributionColors',col_sal_CRH,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_perc_SWS_sal_CRH), stdError(data_perc_SWS_sal_CRH),'LineWidth',2,'color',col_sal_CRH);
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
ylim([0 100])
makepretty
set(p1{1},'MarkerSize',10);
set(p2{1},'MarkerSize',10);
title('NREM percentage')
xlabel('Time of the day (h)')
ylabel('%')

%%stats all SWS perc overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_perc_SWS_sal_C57(:,1), data_perc_SWS_sal_CRH(:,1));
    [p_2,h_2, stats] = ranksum(data_perc_SWS_sal_C57(:,2), data_perc_SWS_sal_CRH(:,2));
    [p_3,h_3, stats] = ranksum(data_perc_SWS_sal_C57(:,3), data_perc_SWS_sal_CRH(:,3));
    [p_4,h_4, stats] = ranksum(data_perc_SWS_sal_C57(:,4), data_perc_SWS_sal_CRH(:,4));
    [p_5,h_5, stats] = ranksum(data_perc_SWS_sal_C57(:,5), data_perc_SWS_sal_CRH(:,5));
    [p_6,h_6, stats] = ranksum(data_perc_SWS_sal_C57(:,6), data_perc_SWS_sal_CRH(:,6));
    [p_7,h_7, stats] = ranksum(data_perc_SWS_sal_C57(:,7), data_perc_SWS_sal_CRH(:,7));
    [p_8,h_8, stats] = ranksum(data_perc_SWS_sal_C57(:,8), data_perc_SWS_sal_CRH(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_SWS_sal_C57(:,1), data_perc_SWS_sal_CRH(:,1));
    [h_2,p_2] = ttest2(data_perc_SWS_sal_C57(:,2), data_perc_SWS_sal_CRH(:,2));
    [h_3,p_3] = ttest2(data_perc_SWS_sal_C57(:,3), data_perc_SWS_sal_CRH(:,3));
    [h_4,p_4] = ttest2(data_perc_SWS_sal_C57(:,4), data_perc_SWS_sal_CRH(:,4));
    [h_5,p_5] = ttest2(data_perc_SWS_sal_C57(:,5), data_perc_SWS_sal_CRH(:,5));
    [h_6,p_6] = ttest2(data_perc_SWS_sal_C57(:,6), data_perc_SWS_sal_CRH(:,6));
    [h_7,p_7] = ttest2(data_perc_SWS_sal_C57(:,7), data_perc_SWS_sal_CRH(:,7));
    [h_8,p_8] = ttest2(data_perc_SWS_sal_C57(:,8), data_perc_SWS_sal_CRH(:,8));
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

subplot(3,6,[9,10]), hold on % SWS number overtime
p1 = plotSpread(data_num_SWS_sal_C57,'distributionColors',col_sal_C57,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_num_SWS_sal_C57), stdError(data_num_SWS_sal_C57),'LineWidth',2,'color',col_sal_C57);
p2 = plotSpread(data_num_SWS_sal_CRH,'distributionColors',col_sal_CRH,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_num_SWS_sal_CRH), stdError(data_num_SWS_sal_CRH),'LineWidth',2,'color',col_sal_CRH);
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
set(p1{1},'MarkerSize',10);
set(p2{1},'MarkerSize',10);
title('NREM bouts number')
xlabel('Time of the day (h)')
ylabel('#')

%%stats SWS num overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_num_SWS_sal_C57(:,1), data_num_SWS_sal_CRH(:,1));
    [p_2,h_2, stats] = ranksum(data_num_SWS_sal_C57(:,2), data_num_SWS_sal_CRH(:,2));
    [p_3,h_3, stats] = ranksum(data_num_SWS_sal_C57(:,3), data_num_SWS_sal_CRH(:,3));
    [p_4,h_4, stats] = ranksum(data_num_SWS_sal_C57(:,4), data_num_SWS_sal_CRH(:,4));
    [p_5,h_5, stats] = ranksum(data_num_SWS_sal_C57(:,5), data_num_SWS_sal_CRH(:,5));
    [p_6,h_6, stats] = ranksum(data_num_SWS_sal_C57(:,6), data_num_SWS_sal_CRH(:,6));
    [p_7,h_7, stats] = ranksum(data_num_SWS_sal_C57(:,7), data_num_SWS_sal_CRH(:,7));
    [p_8,h_8, stats] = ranksum(data_num_SWS_sal_C57(:,8), data_num_SWS_sal_CRH(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_SWS_sal_C57(:,1), data_num_SWS_sal_CRH(:,1));
    [h_2,p_2] = ttest2(data_num_SWS_sal_C57(:,2), data_num_SWS_sal_CRH(:,2));
    [h_3,p_3] = ttest2(data_num_SWS_sal_C57(:,3), data_num_SWS_sal_CRH(:,3));
    [h_4,p_4] = ttest2(data_num_SWS_sal_C57(:,4), data_num_SWS_sal_CRH(:,4));
    [h_5,p_5] = ttest2(data_num_SWS_sal_C57(:,5), data_num_SWS_sal_CRH(:,5));
    [h_6,p_6] = ttest2(data_num_SWS_sal_C57(:,6), data_num_SWS_sal_CRH(:,6));
    [h_7,p_7] = ttest2(data_num_SWS_sal_C57(:,7), data_num_SWS_sal_CRH(:,7));
    [h_8,p_8] = ttest2(data_num_SWS_sal_C57(:,8), data_num_SWS_sal_CRH(:,8));
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

subplot(3,6,[11,12]), hold on % SWS duration overtime
p1 = plotSpread(data_dur_SWS_sal_C57,'distributionColors',col_sal_C57,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_dur_SWS_sal_C57), stdError(data_dur_SWS_sal_C57),'LineWidth',2,'color',col_sal_C57);
p2 = plotSpread(data_dur_SWS_sal_CRH,'distributionColors',col_sal_CRH,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_dur_SWS_sal_CRH), stdError(data_dur_SWS_sal_CRH),'LineWidth',2,'color',col_sal_CRH);
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
set(p1{1},'MarkerSize',10);
set(p2{1},'MarkerSize',10);
title('NREM bouts duration')
xlabel('Time of the day (h)')
ylabel('Dur')

%%stats SWS dur overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_dur_SWS_sal_C57(:,1), data_dur_SWS_sal_CRH(:,1));
    [p_2,h_2, stats] = ranksum(data_dur_SWS_sal_C57(:,2), data_dur_SWS_sal_CRH(:,2));
    [p_3,h_3, stats] = ranksum(data_dur_SWS_sal_C57(:,3), data_dur_SWS_sal_CRH(:,3));
    [p_4,h_4, stats] = ranksum(data_dur_SWS_sal_C57(:,4), data_dur_SWS_sal_CRH(:,4));
    [p_5,h_5, stats] = ranksum(data_dur_SWS_sal_C57(:,5), data_dur_SWS_sal_CRH(:,5));
    [p_6,h_6, stats] = ranksum(data_dur_SWS_sal_C57(:,6), data_dur_SWS_sal_CRH(:,6));
    [p_7,h_7, stats] = ranksum(data_dur_SWS_sal_C57(:,7), data_dur_SWS_sal_CRH(:,7));
    [p_8,h_8, stats] = ranksum(data_dur_SWS_sal_C57(:,8), data_dur_SWS_sal_CRH(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_SWS_sal_C57(:,1), data_dur_SWS_sal_CRH(:,1));
    [h_2,p_2] = ttest2(data_dur_SWS_sal_C57(:,2), data_dur_SWS_sal_CRH(:,2));
    [h_3,p_3] = ttest2(data_dur_SWS_sal_C57(:,3), data_dur_SWS_sal_CRH(:,3));
    [h_4,p_4] = ttest2(data_dur_SWS_sal_C57(:,4), data_dur_SWS_sal_CRH(:,4));
    [h_5,p_5] = ttest2(data_dur_SWS_sal_C57(:,5), data_dur_SWS_sal_CRH(:,5));
    [h_6,p_6] = ttest2(data_dur_SWS_sal_C57(:,6), data_dur_SWS_sal_CRH(:,6));
    [h_7,p_7] = ttest2(data_dur_SWS_sal_C57(:,7), data_dur_SWS_sal_CRH(:,7));
    [h_8,p_8] = ttest2(data_dur_SWS_sal_C57(:,8), data_dur_SWS_sal_CRH(:,8));
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

subplot(3,6,[13,14]) %REM percentage overtime
p1 = plotSpread(data_perc_REM_sal_C57,'distributionColors',col_sal_C57,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_perc_REM_sal_C57), stdError(data_perc_REM_sal_C57),'LineWidth',2,'color',col_sal_C57);
p2 = plotSpread(data_perc_REM_sal_CRH,'distributionColors',col_sal_CRH,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_perc_REM_sal_CRH), stdError(data_perc_REM_sal_CRH),'LineWidth',2,'color',col_sal_CRH);
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
set(p1{1},'MarkerSize',10);
set(p2{1},'MarkerSize',10);
title('REM percentage')
xlabel('Time of the day (h)')
ylabel('%')

%%stats all REM perc overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_perc_REM_sal_C57(:,1), data_perc_REM_sal_CRH(:,1));
    [p_2,h_2, stats] = ranksum(data_perc_REM_sal_C57(:,2), data_perc_REM_sal_CRH(:,2));
    [p_3,h_3, stats] = ranksum(data_perc_REM_sal_C57(:,3), data_perc_REM_sal_CRH(:,3));
    [p_4,h_4, stats] = ranksum(data_perc_REM_sal_C57(:,4), data_perc_REM_sal_CRH(:,4));
    [p_5,h_5, stats] = ranksum(data_perc_REM_sal_C57(:,5), data_perc_REM_sal_CRH(:,5));
    [p_6,h_6, stats] = ranksum(data_perc_REM_sal_C57(:,6), data_perc_REM_sal_CRH(:,6));
    [p_7,h_7, stats] = ranksum(data_perc_REM_sal_C57(:,7), data_perc_REM_sal_CRH(:,7));
    [p_8,h_8, stats] = ranksum(data_perc_REM_sal_C57(:,8), data_perc_REM_sal_CRH(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_perc_REM_sal_C57(:,1), data_perc_REM_sal_CRH(:,1));
    [h_2,p_2] = ttest2(data_perc_REM_sal_C57(:,2), data_perc_REM_sal_CRH(:,2));
    [h_3,p_3] = ttest2(data_perc_REM_sal_C57(:,3), data_perc_REM_sal_CRH(:,3));
    [h_4,p_4] = ttest2(data_perc_REM_sal_C57(:,4), data_perc_REM_sal_CRH(:,4));
    [h_5,p_5] = ttest2(data_perc_REM_sal_C57(:,5), data_perc_REM_sal_CRH(:,5));
    [h_6,p_6] = ttest2(data_perc_REM_sal_C57(:,6), data_perc_REM_sal_CRH(:,6));
    [h_7,p_7] = ttest2(data_perc_REM_sal_C57(:,7), data_perc_REM_sal_CRH(:,7));
    [h_8,p_8] = ttest2(data_perc_REM_sal_C57(:,8), data_perc_REM_sal_CRH(:,8));
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

subplot(3,6,[15,16]) %REM number overtime
p1 = plotSpread(data_num_REM_sal_C57,'distributionColors',col_sal_C57,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_num_REM_sal_C57), stdError(data_num_REM_sal_C57),'LineWidth',2,'color',col_sal_C57);
p2 = plotSpread(data_num_REM_sal_CRH,'distributionColors',col_sal_CRH,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_num_REM_sal_CRH), stdError(data_num_REM_sal_CRH),'LineWidth',2,'color',col_sal_CRH);
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
set(p1{1},'MarkerSize',10);
set(p2{1},'MarkerSize',10);
title('REM bouts number')
xlabel('Time of the day (h)')
ylabel('#')

%%stats REM num overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_num_REM_sal_C57(:,1), data_num_REM_sal_CRH(:,1));
    [p_2,h_2, stats] = ranksum(data_num_REM_sal_C57(:,2), data_num_REM_sal_CRH(:,2));
    [p_3,h_3, stats] = ranksum(data_num_REM_sal_C57(:,3), data_num_REM_sal_CRH(:,3));
    [p_4,h_4, stats] = ranksum(data_num_REM_sal_C57(:,4), data_num_REM_sal_CRH(:,4));
    [p_5,h_5, stats] = ranksum(data_num_REM_sal_C57(:,5), data_num_REM_sal_CRH(:,5));
    [p_6,h_6, stats] = ranksum(data_num_REM_sal_C57(:,6), data_num_REM_sal_CRH(:,6));
    [p_7,h_7, stats] = ranksum(data_num_REM_sal_C57(:,7), data_num_REM_sal_CRH(:,7));
    [p_8,h_8, stats] = ranksum(data_num_REM_sal_C57(:,8), data_num_REM_sal_CRH(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_num_REM_sal_C57(:,1), data_num_REM_sal_CRH(:,1));
    [h_2,p_2] = ttest2(data_num_REM_sal_C57(:,2), data_num_REM_sal_CRH(:,2));
    [h_3,p_3] = ttest2(data_num_REM_sal_C57(:,3), data_num_REM_sal_CRH(:,3));
    [h_4,p_4] = ttest2(data_num_REM_sal_C57(:,4), data_num_REM_sal_CRH(:,4));
    [h_5,p_5] = ttest2(data_num_REM_sal_C57(:,5), data_num_REM_sal_CRH(:,5));
    [h_6,p_6] = ttest2(data_num_REM_sal_C57(:,6), data_num_REM_sal_CRH(:,6));
    [h_7,p_7] = ttest2(data_num_REM_sal_C57(:,7), data_num_REM_sal_CRH(:,7));
    [h_8,p_8] = ttest2(data_num_REM_sal_C57(:,8), data_num_REM_sal_CRH(:,8));
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

subplot(3,6,[17,18]) % REM bouts duration ovetime
p1 = plotSpread(data_dur_REM_sal_C57,'distributionColors',col_sal_C57,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_dur_REM_sal_C57), stdError(data_dur_REM_sal_C57),'LineWidth',2,'color',col_sal_C57);
p2 = plotSpread(data_dur_REM_sal_CRH,'distributionColors',col_sal_CRH,'spreadWidth',2.5), hold on;
errorbar(nanmean(data_dur_REM_sal_CRH), stdError(data_dur_REM_sal_CRH),'LineWidth',2,'color',col_sal_CRH);
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
set(p1{1},'MarkerSize',10);
set(p2{1},'MarkerSize',10);
title('REM bouts duration')
xlabel('Time of the day (h)')
ylabel('Dur')

%%stats REM dur overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_dur_REM_sal_C57(:,1), data_dur_REM_sal_CRH(:,1));
    [p_2,h_2, stats] = ranksum(data_dur_REM_sal_C57(:,2), data_dur_REM_sal_CRH(:,2));
    [p_3,h_3, stats] = ranksum(data_dur_REM_sal_C57(:,3), data_dur_REM_sal_CRH(:,3));
    [p_4,h_4, stats] = ranksum(data_dur_REM_sal_C57(:,4), data_dur_REM_sal_CRH(:,4));
    [p_5,h_5, stats] = ranksum(data_dur_REM_sal_C57(:,5), data_dur_REM_sal_CRH(:,5));
    [p_6,h_6, stats] = ranksum(data_dur_REM_sal_C57(:,6), data_dur_REM_sal_CRH(:,6));
    [p_7,h_7, stats] = ranksum(data_dur_REM_sal_C57(:,7), data_dur_REM_sal_CRH(:,7));
    [p_8,h_8, stats] = ranksum(data_dur_REM_sal_C57(:,8), data_dur_REM_sal_CRH(:,8));
elseif isparam ==1
    [h_1,p_1] = ttest2(data_dur_REM_sal_C57(:,1), data_dur_REM_sal_CRH(:,1));
    [h_2,p_2] = ttest2(data_dur_REM_sal_C57(:,2), data_dur_REM_sal_CRH(:,2));
    [h_3,p_3] = ttest2(data_dur_REM_sal_C57(:,3), data_dur_REM_sal_CRH(:,3));
    [h_4,p_4] = ttest2(data_dur_REM_sal_C57(:,4), data_dur_REM_sal_CRH(:,4));
    [h_5,p_5] = ttest2(data_dur_REM_sal_C57(:,5), data_dur_REM_sal_CRH(:,5));
    [h_6,p_6] = ttest2(data_dur_REM_sal_C57(:,6), data_dur_REM_sal_CRH(:,6));
    [h_7,p_7] = ttest2(data_dur_REM_sal_C57(:,7), data_dur_REM_sal_CRH(:,7));
    [h_8,p_8] = ttest2(data_dur_REM_sal_C57(:,8), data_dur_REM_sal_CRH(:,8));
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
