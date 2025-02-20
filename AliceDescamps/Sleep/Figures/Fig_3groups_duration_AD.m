%% To plot the figure you need to load data : 
Get_Data_5groups_AD.m

%% FIGURE 3 groups
txt_size = 15;
isparam=0;
iscorr=1;

%classic
% col_1 = [.7 .7 .7];
% col_2 = [1 .4 0];
% col_3 = [0 .4 .6];

%classic
col_1 = [.2 .2 .2];
col_2 = [1 0 0];
col_3 = [0 .4 .4];

% legend = {'1','2','3'};
% legend = {'Sal mCherry (n=3)','SD + Sal mCherry (n=3)','CNO mCherry (n=4)','SD + CNO mCherry (n=4)','SD + CNO DREADD- (n=7)'};
% legend = {'Sal mCherry (n=11)','SD1 + Sal mCherry (n=3)','SD2 + Sal mCherry (n=4)'};
% legend = {'Sal mCherry (n=11)','SD + Sal mCherry homo (n=3)','SD + Sal DREADD+ hétéro (n=4)'};
% legend = {'CNO mCherry (n=6)','SD + CNO mCherry (n=6)','SD + CNO DREADD- (n=7)'};
legend = {'CNO mCherry (n=4)','SD + CNO mCherry (n=4)','SD + CNO DREADD- (n=7)'};


figure('color',[1 1 1])
% suptitle ('xxxxxxxxxxxxx')
% suptitle ('Comparison between SD1 and SD2 saline')
% suptitle ('Comparison between SD on homo or on hetero mice')
suptitle ('Effect of CRH inhibition after SD and CNO injection')


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
plot(nanmean(data_dur_WAKE_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_dur_WAKE_3), stdError(data_dur_WAKE_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'})
ylabel('Wake duration')
makepretty
% ylim([0 100])

% subplot(4,6,[6,7]), hold on % Total Sleep duration overtime
% % plot(nanmean(data_dur_totSleep_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
% % errorbar(nanmean(data_dur_totSleep_1), stdError(data_dur_totSleep_1),'LineWidth',2,'color',col_1)
% % plot(nanmean(data_dur_totSleep_2),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
% % errorbar(nanmean(data_dur_totSleep_2), stdError(data_dur_totSleep_2),'LineWidth',2,'color',col_2)
% plot(nanmean(data_dur_totSleep_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
% errorbar(nanmean(data_dur_totSleep_3), stdError(data_dur_totSleep_3),'LineWidth',2,'color',col_3)
% plot(nanmean(data_dur_totSleep_4),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_4,'color',col_4)
% errorbar(nanmean(data_dur_totSleep_4), stdError(data_dur_totSleep_4),'LineWidth',2,'color',col_4)
% plot(nanmean(data_dur_totSleep_5),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_5,'color',col_5)
% errorbar(nanmean(data_dur_totSleep_5), stdError(data_dur_totSleep_5),'LineWidth',2,'color',col_5)
% xlim([0 8.5])
% xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
% % ylim([0 100])
% makepretty
% ylabel('Sleep duration')

subplot(4,6,[7,8]), hold on % SWS duration overtime
plot(nanmean(data_dur_SWS_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_SWS_1), stdError(data_dur_SWS_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_SWS_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_SWS_2,1), stdError(data_dur_SWS_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_dur_SWS_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_dur_SWS_3), stdError(data_dur_SWS_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
% ylim([0 100])
makepretty
ylabel('NREM duration')

subplot(4,6,[13,14]) %REM duration overtime
plot(nanmean(data_dur_REM_1),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_1,'color',col_1), hold on
errorbar(nanmean(data_dur_REM_1), stdError(data_dur_REM_1),'LineWidth',2,'color',col_1)
plot(nanmean(data_dur_REM_2,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_2,'markersize',8,'color',col_2)
errorbar(nanmean(data_dur_REM_2,1), stdError(data_dur_REM_2),'linestyle','-','LineWidth',2,'color',col_2)
plot(nanmean(data_dur_REM_3),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_3,'color',col_3), hold on
errorbar(nanmean(data_dur_REM_3), stdError(data_dur_REM_3),'LineWidth',2,'color',col_3)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'1','3','5','7','9'}) 
makepretty
ylabel('REM duration')
xlabel('Time after stress (h)')




subplot(4,6,[4],'align') %WAKE duration phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_WAKE_begin_1,2), nanmean(data_dur_WAKE_begin_2,2), nanmean(data_dur_WAKE_begin_3,2)},...
    {col_1,col_2,col_3},[1:3],legend,'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('Wake duration')
% makepretty
% ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_WAKE_begin_1,2), nanmean(data_dur_WAKE_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_WAKE_begin_1,2), nanmean(data_dur_WAKE_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_WAKE_begin_2,2), nanmean(data_dur_WAKE_begin_3,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_WAKE_begin_1,2), nanmean(data_dur_WAKE_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_WAKE_begin_1,2), nanmean(data_dur_WAKE_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_WAKE_begin_2,2), nanmean(data_dur_WAKE_begin_3,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_2_vs_3_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 3]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,6,[5],'align') %WAKE duration phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_WAKE_interPeriod_1,2), nanmean(data_dur_WAKE_interPeriod_2,2), nanmean(data_dur_WAKE_interPeriod_3,2)},...
    {col_1,col_2,col_3},[1:3],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('Wake duration')
% makepretty
% ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_WAKE_interPeriod_1,2), nanmean(data_dur_WAKE_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_WAKE_interPeriod_1,2), nanmean(data_dur_WAKE_interPeriod_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_WAKE_interPeriod_2,2), nanmean(data_dur_WAKE_interPeriod_3,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_WAKE_interPeriod_1,2), nanmean(data_dur_WAKE_interPeriod_2,2));
    [h_1,p_1_vs_3_] = ttest2(nanmean(data_dur_WAKE_interPeriod_1,2), nanmean(data_dur_WAKE_interPeriod_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_WAKE_interPeriod_2,2), nanmean(data_dur_WAKE_interPeriod_3,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_2_vs_3_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 3]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
else
end
    
    
subplot(4,6,[6],'align') %WAKE duration phase3
MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_WAKE_end_1,2), nanmean(data_dur_WAKE_end_2,2), nanmean(data_dur_WAKE_end_3,2)},...
    {col_1,col_2,col_3},[1:3],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('Wake duration')
% makepretty
% ylim([0 50])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_WAKE_end_1,2), nanmean(data_dur_WAKE_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_WAKE_end_1,2), nanmean(data_dur_WAKE_end_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_WAKE_end_2,2), nanmean(data_dur_WAKE_end_3,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_WAKE_end_1,2), nanmean(data_dur_WAKE_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_WAKE_end_1,2), nanmean(data_dur_WAKE_end_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_WAKE_end_2,2), nanmean(data_dur_WAKE_end_3,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_2_vs_3_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 3]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
else
end
    

    


subplot(4,6,[10],'align') %NREM duration phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_3,2)},...
    {col_1,col_2,col_3},[1:3],legend,'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('NREM duration')
% makepretty
% ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_3,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_3,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_2_vs_3_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 3]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,6,[11],'align') %NREM duration phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_3,2)},...
    {col_1,col_2,col_3},[1:3],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('NREM duration')
% makepretty
% ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_3,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_3,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_2_vs_3_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 3]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
else
end




subplot(4,6,[12],'align') %NREM duration phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_3,2)},...
    {col_1,col_2,col_3},[1:3],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('NREM duration')
% makepretty
% ylim([0 80])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_3,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_3,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_2_vs_3_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 3]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
else
end
    
    
    
subplot(4,6,[16],'align') %REM duration phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_3,2)},...
    {col_1,col_2,col_3},[1:3],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('REM duration')
% makepretty
% ylim([0 10])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_3,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_3,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_2_vs_3_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 3]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
else
end
    
subplot(4,6,[17],'align') %REM duration phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_3,2)},...
    {col_1,col_2,col_3},[1:3],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('REM duration')
% makepretty
% ylim([0 10])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_3,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_3,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_2_vs_3_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 3]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,6,[18],'align') %REM duration phase3
MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_3,2)},...
    {col_1,col_2,col_3},[1:3],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('REM duration')
% makepretty
% ylim([0 15])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_3,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_3,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_2_vs_3_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 3]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
else
end
    
