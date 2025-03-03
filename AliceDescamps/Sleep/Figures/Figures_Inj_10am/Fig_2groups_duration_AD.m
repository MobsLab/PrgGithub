%% To plot the figure you need to load data : 
Get_Data_5groups_AD.m

%% FIGURE 3 groups
txt_size = 15;
isparam=0;
iscorr=1;


%homo inhib
col_1 = [.7 .7 .7];
col_2 = [.6 0 .6];

% legend = {'1','2'};
% legend = {'Sal mCherry (n=4)','SD + Sal mCherry (n=4)'};
legend = {'Sal DREADD- (n=8)','CNO DREADD- (n=8)'};
% legend = {'CNO mCherry (n=6)','SD + CNO mCherry (n=6)'};


figure('color',[1 1 1])
% suptitle ('xxxxxxxxxxxxx')
% suptitle ('Effect of Social defeat');
suptitle ('Inhibition of CRH neurons');

subplot(4,6,[4],'align') %WAKE duration phase1
hold on, title('0-1h30')
subplot(4,6,[5],'align') %WAKE duration phase2
hold on, title('1h30-3h30')
subplot(4,6,[6],'align') %WAKE duration phase3
hold on, title('3h30-8h')



subplot(4,6,[1,2]) % wake duration overtime
plot(nanmean(data_dur_WAKE_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_WAKE_1), stdError(data_dur_WAKE_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_WAKE_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_WAKE_2,1), stdError(data_dur_WAKE_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'})
ylabel('Wake duration')
makepretty
ylim([0 100])

if isparam ==0
    [p_1,h_1, stats] = ranksum(data_dur_WAKE_1(:,1), data_dur_WAKE_2(:,1));
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

subplot(4,6,[7,8]), hold on % SWS duration overtime
plot(nanmean(data_dur_SWS_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_SWS_1), stdError(data_dur_SWS_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_SWS_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_SWS_2,1), stdError(data_dur_SWS_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
ylim([0 100])
makepretty
ylabel('NREM duration')

%%stats all SWS perc overtime
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

subplot(4,6,[13,14]) %REM duration overtime
plot(nanmean(data_dur_REM_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_REM_1), stdError(data_dur_REM_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_REM_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_REM_2,1), stdError(data_dur_REM_2),'linestyle','-','LineWidth',2,'color',col_2)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM duration')
xlabel('Time after stress (h)')


%%stats all REM perc overtime
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




subplot(4,6,[4],'align') %WAKE duration phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_WAKE_begin_1,2), nanmean(data_dur_WAKE_begin_2,2)},...
    {col_1,col_2},[1:2],legend,'paired',1,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('Wake duration')
% makepretty
ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_WAKE_begin_1,2), nanmean(data_dur_WAKE_begin_2,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_WAKE_begin_1,2), nanmean(data_dur_WAKE_begin_2,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,6,[5],'align') %WAKE duration phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_WAKE_interPeriod_1,2), nanmean(data_dur_WAKE_interPeriod_2,2)},...
    {col_1,col_2},[1:2],legend,'paired',1,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('Wake duration')
% makepretty
% ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_WAKE_interPeriod_1,2), nanmean(data_dur_WAKE_interPeriod_2,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_WAKE_interPeriod_1,2), nanmean(data_dur_WAKE_interPeriod_2,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
else
end
    
    
subplot(4,6,[6],'align') %WAKE duration phase3
MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_WAKE_end_1,2), nanmean(data_dur_WAKE_end_2,2)},...
    {col_1,col_2},[1:2],legend,'paired',1,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('Wake duration')
% makepretty
% ylim([0 50])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_WAKE_end_1,2), nanmean(data_dur_WAKE_end_2,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_WAKE_end_1,2), nanmean(data_dur_WAKE_end_2,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
else
end
    

    


subplot(4,6,[10],'align') %NREM duration phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2)},...
    {col_1,col_2},[1:2],legend,'paired',1,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('NREM duration')
% makepretty
% ylim([0 100])
if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,6,[11],'align') %NREM duration phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_2,2)},...
    {col_1,col_2},[1:2],legend,'paired',1,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('NREM duration')
% makepretty
% ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_2,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_2,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
else
end




subplot(4,6,[12],'align') %NREM duration phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_2,2)},...
    {col_1,col_2},[1:2],legend,'paired',1,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('NREM duration')
% makepretty
% ylim([0 80])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_2,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_2,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
else
end
    
    
    
subplot(4,6,[16],'align') %REM duration phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2)},...
    {col_1,col_2},[1:2],legend,'paired',1,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('REM duration')
% makepretty
% ylim([0 10])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
else
end
    
subplot(4,6,[17],'align') %REM duration phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_2,2)},...
    {col_1,col_2},[1:2],legend,'paired',1,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('REM duration')
% makepretty
% ylim([0 10])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_2,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_2,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,6,[18],'align') %REM duration phase3
MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_2,2)},...
    {col_1,col_2},[1:2],legend,'paired',1,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('REM duration')
% makepretty
% ylim([0 15])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_2,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_2,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
else
end
    
