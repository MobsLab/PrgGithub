%% To plot the figure you need to load data : 
Get_sleep_data_post_SDS_MC
Get_EPM_data_post_SDS_MC

%% FIGURE 1 : effect of social defeat (behav and sleep)
col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];

isparam = 0; %%use parametric test
iscorr = 1; %%show corrected pvalues

figure, hold on
%%PANEL B
subplot(4,7,[4],'align') %example locomotion in EPM control mouse
for izone = 1:3
hold on, plot(Data(Restrict(behav_basal{3}.Xtsd,behav_basal{3}.ZoneEpoch{izone})),Data(Restrict(behav_basal{3}.Ytsd,behav_basal{3}.ZoneEpoch{izone})), 'color',[0 0 0]);
end
ylim([18 91])
xlim([6 81])
axis off

%%PANEL B
subplot(4,7,[5],'align')  %example locomotion in EPM SDS mouse
for izone = 1:3
hold on, plot(Data(Restrict(behav_SD{6}.Xtsd,behav_SD{6}.ZoneEpoch{izone})),Data(Restrict(behav_SD{6}.Ytsd,behav_SD{6}.ZoneEpoch{izone})), 'color',col_SD);
end
ylim([18 91])
xlim([6 81])
axis off

%%PANEL C
subplot(4,7,[6],'align') %quantif in open arm
MakeSpreadAndBoxPlot2_MC({occup_open_basal.*100,occup_open_SD.*100},...
        {col_ctrl,col_SD},[1:2],{},'paired',0,'showsigstar','none')
xticks([1.5 4.5 7.5]); xticklabels ({'Ctrl', 'SDS'});
makepretty
ylabel('Time % spent in open arm')
[p_sal_cno_open,h,stats]=ranksum(occup_open_basal.*100,occup_open_SD.*100);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end


%% PANEL D
subplot(4,7,[8,9],'align') % wake percentage overtime
plot(nanmean(data_perc_WAKE_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_WAKE_ctrl), stdError(data_perc_WAKE_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_WAKE_SD), stdError(data_perc_WAKE_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 120])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'})
makepretty
ylabel('Wake percentage')
xlabel('Time after stress (h)')
%%stats wake perc overtime
if isparam ==0
    [p_1,h_1,stats] = ranksum(data_perc_WAKE_ctrl(:,1), data_perc_WAKE_SD(:,1));
    [p_2,h_2, stats] = ranksum(data_perc_WAKE_ctrl(:,2), data_perc_WAKE_SD(:,2));
    [p_3,h_3, stats] = ranksum(data_perc_WAKE_ctrl(:,3), data_perc_WAKE_SD(:,3));
    [p_4,h_4, stats] = ranksum(data_perc_WAKE_ctrl(:,4), data_perc_WAKE_SD(:,4));
    [p_5,h_5, stats] = ranksum(data_perc_WAKE_ctrl(:,5), data_perc_WAKE_SD(:,5));
    [p_6,h_6, stats] = ranksum(data_perc_WAKE_ctrl(:,6), data_perc_WAKE_SD(:,6));
    [p_7,h_7, stats] = ranksum(data_perc_WAKE_ctrl(:,7), data_perc_WAKE_SD(:,7));
    [p_8,h_8, stats] = ranksum(data_perc_WAKE_ctrl(:,8), data_perc_WAKE_SD(:,8));
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

%%PANEL E
subplot(4,7,[10,11],'align'), hold on
plot(nanmean(data_perc_SWS_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_SWS_ctrl), stdError(data_perc_SWS_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_SWS_SD), stdError(data_perc_SWS_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 80])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('NREM percentage')
xlabel('Time after stress (h)')

%%stats all SWS perc overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_perc_SWS_ctrl(:,1), data_perc_SWS_SD(:,1));
    [p_2,h_2, stats] = ranksum(data_perc_SWS_ctrl(:,2), data_perc_SWS_SD(:,2));
    [p_3,h_3, stats] = ranksum(data_perc_SWS_ctrl(:,3), data_perc_SWS_SD(:,3));
    [p_4,h_4, stats] = ranksum(data_perc_SWS_ctrl(:,4), data_perc_SWS_SD(:,4));
    [p_5,h_5, stats] = ranksum(data_perc_SWS_ctrl(:,5), data_perc_SWS_SD(:,5));
    [p_6,h_6, stats] = ranksum(data_perc_SWS_ctrl(:,6), data_perc_SWS_SD(:,6));
    [p_7,h_7, stats] = ranksum(data_perc_SWS_ctrl(:,7), data_perc_SWS_SD(:,7));
    [p_8,h_8, stats] = ranksum(data_perc_SWS_ctrl(:,8), data_perc_SWS_SD(:,8));
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

%%PANEL F
subplot(4,7,[12,13],'align') %REM percentage overtime
plot(nanmean(data_perc_REM_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_perc_REM_ctrl), stdError(data_perc_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_perc_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_perc_REM_SD), stdError(data_perc_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 15])

xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('REM percentage')
xlabel('Time after stress (h)')

%%stats all REM perc overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_perc_REM_ctrl(:,1), data_perc_REM_SD(:,1));
    [p_2,h_2, stats] = ranksum(data_perc_REM_ctrl(:,2), data_perc_REM_SD(:,2));
    [p_3,h_3, stats] = ranksum(data_perc_REM_ctrl(:,3), data_perc_REM_SD(:,3));
    [p_4,h_4, stats] = ranksum(data_perc_REM_ctrl(:,4), data_perc_REM_SD(:,4));
    [p_5,h_5, stats] = ranksum(data_perc_REM_ctrl(:,5), data_perc_REM_SD(:,5));
    [p_6,h_6, stats] = ranksum(data_perc_REM_ctrl(:,6), data_perc_REM_SD(:,6));
    [p_7,h_7, stats] = ranksum(data_perc_REM_ctrl(:,7), data_perc_REM_SD(:,7));
    [p_8,h_8, stats] = ranksum(data_perc_REM_ctrl(:,8), data_perc_REM_SD(:,8));
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


%%PANEL G
subplot(4,7,[15,16],'align') %REM numentage overtime
plot(nanmean(data_num_REM_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_num_REM_ctrl), stdError(data_num_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 10])
xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('REM bouts number')
xlabel('Time after stress (h)')

%%stats REM num overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_num_REM_ctrl(:,1), data_num_REM_SD(:,1));
    [p_2,h_2, stats] = ranksum(data_num_REM_ctrl(:,2), data_num_REM_SD(:,2));
    [p_3,h_3, stats] = ranksum(data_num_REM_ctrl(:,3), data_num_REM_SD(:,3));
    [p_4,h_4, stats] = ranksum(data_num_REM_ctrl(:,4), data_num_REM_SD(:,4));
    [p_5,h_5, stats] = ranksum(data_num_REM_ctrl(:,5), data_num_REM_SD(:,5));
    [p_6,h_6, stats] = ranksum(data_num_REM_ctrl(:,6), data_num_REM_SD(:,6));
    [p_7,h_7, stats] = ranksum(data_num_REM_ctrl(:,7), data_num_REM_SD(:,7));
    [p_8,h_8, stats] = ranksum(data_num_REM_ctrl(:,8), data_num_REM_SD(:,8));
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


%%PANEL H
subplot(4,7,[17,18],'align') %REM durentage overtime
plot(nanmean(data_dur_REM_ctrl),'linestyle','-','marker','o','markersize',8,'markerfacecolor',col_ctrl,'color',col_ctrl), hold on
errorbar(nanmean(data_dur_REM_ctrl), stdError(data_dur_REM_ctrl),'color',col_ctrl)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'markersize',8,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'linestyle','-','color',col_SD)
xlim([0 8.5])
ylim([0 120])

xticks([2 4 6 8]); xticklabels({'2','4','6','8'}) 
makepretty
ylabel('REM bouts duration (s)')
xlabel('Time after stress (h)')

%%stats REM dur overtime
if isparam ==0
    [p_1,h_1, stats] = ranksum(data_dur_REM_ctrl(:,1), data_dur_REM_SD(:,1));
    [p_2,h_2, stats] = ranksum(data_dur_REM_ctrl(:,2), data_dur_REM_SD(:,2));
    [p_3,h_3, stats] = ranksum(data_dur_REM_ctrl(:,3), data_dur_REM_SD(:,3));
    [p_4,h_4, stats] = ranksum(data_dur_REM_ctrl(:,4), data_dur_REM_SD(:,4));
    [p_5,h_5, stats] = ranksum(data_dur_REM_ctrl(:,5), data_dur_REM_SD(:,5));
    [p_6,h_6, stats] = ranksum(data_dur_REM_ctrl(:,6), data_dur_REM_SD(:,6));
    [p_7,h_7, stats] = ranksum(data_dur_REM_ctrl(:,7), data_dur_REM_SD(:,7));
    [p_8,h_8, stats] = ranksum(data_dur_REM_ctrl(:,8), data_dur_REM_SD(:,8));
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
