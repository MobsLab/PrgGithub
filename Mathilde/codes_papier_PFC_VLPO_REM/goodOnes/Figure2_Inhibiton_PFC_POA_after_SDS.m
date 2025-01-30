

%% To plot the figure you need to load data : 
Get_sleep_data_post_SDS_MC


%% FIGURE 2
txt_size = 15;

col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];
col_mCherry_cno = [1 .2 0];
col_dreadd_cno = [0 .4 .4];

% col_dreadd_cno = [0 .6 .4]; %PFC inhib (light green)

isparam=0;
iscorr=1;



figure
subplot(4,7,[15],'align') %WAKE percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('Wake percentage')
makepretty
ylim([0 150])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2),nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2),nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    

    

subplot(4,7,[16],'align') %NREM percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('NREM percentage')
makepretty
ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2),nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2),nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,7,[17],'align') %REM percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM percentage')
makepretty
ylim([0 10])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_ctrl,2),nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_begin_ctrl,2),nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,7,[18],'align') %REM num phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM bouts number')
makepretty
ylim([0 8])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_ctrl,2),nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_begin_ctrl,2),nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,7,[19],'align') %REM dur phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM bouts duration (s)')
makepretty
ylim([0 125])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_ctrl,2),nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_begin_ctrl,2),nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    







subplot(4,7,[22],'align') %WAKE percentage phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('Wake percentage')
makepretty
ylim([0 50])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2),nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2),nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end






subplot(4,7,[23],'align') %NREM percentage phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('NREM percentage')
makepretty
ylim([0 80])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_ctrl,2),nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_end_ctrl,2),nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end




subplot(4,7,[24],'align') %REM percentage phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM percentage')
makepretty
ylim([0 15])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_ctrl,2),nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_end_ctrl,2),nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,7,[25],'align') %REM num phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM bouts number')
makepretty
ylim([0 60])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_ctrl,2),nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_end_ctrl,2),nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,7,[26],'align') %REM dur phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM bouts duration (s)')
makepretty
ylim([0 110])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_ctrl,2),nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_end_ctrl,2),nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


%%
figure
subplot(4,7,[15,16],'align') %WAKE percentage
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9],{},'paired',0,'showsigstar','none')
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('Wake percentage')
makepretty
ylim([0 130])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2),nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2),nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2),nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2),nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    %phase2
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,7,[17,18],'align') %NREM percentage
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9],{},'paired',0,'showsigstar','none')
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('NREM percentage')
makepretty

if isparam==0 %%version ranksum
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2),nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_ctrl,2),nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2),nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_end_ctrl,2),nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
else
end
%%add corrections for multiples comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    %phase2
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,7,[19,20],'align') %REM percentage
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9],{},'paired',0,'showsigstar','none')
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('REM percentage')
makepretty

if isparam==0 %%version ranksum
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_ctrl,2),nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_ctrl,2),nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_begin_ctrl,2),nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_end_ctrl,2),nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
   %phase2
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end
else
end





subplot(4,7,[22,23],'align') %REM bouts number
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2),...
    nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9],{},'paired',0,'showsigstar','none')
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('REM bouts number')
makepretty

if isparam==0 %%version ranksum
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_ctrl,2),nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_ctrl,2),nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_begin_ctrl,2),nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_end_ctrl,2),nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',12);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    %phase2
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,7,[24,25],'align') % REM bouts mean duration
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9],{},'paired',0,'showsigstar','none')
xticks([2.5 7.5 12.5]); xticklabels({'1-3h','4-8h'}); xtickangle(0)
ylabel('REM bouts durations (s)')
makepretty

if isparam==0 %%version ranksum
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_ctrl,2),nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    %phase2
    [p_ctrl_vs_SD_2, h_2] = ranksum(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_ctrl,2),nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_begin_ctrl,2),nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    %phase2
    [h_2,p_ctrl_vs_SD_2] = ttest2(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2));
    [h_2,p_ctrl_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_end_ctrl,2),nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [h_2,p_SD_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [h_2,p_ctrl_vs_mCherrry_cno_2] = ttest2(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [h_2,p_SD_vs_mCherry_cno_2] = ttest2(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
else
end
%%add correction for multiple comparisons
if iscorr==0
    %phase1
    if p_ctrl_vs_SD_1<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_1<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_1<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_1<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_1<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno_1,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_1<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_1,0,'LineWigth',16,'StarSize',24);end
    %phase2
    if p_ctrl_vs_SD_2<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_ctrl_vs_SD_1 p_ctrl_vs_dreadd_cno_1 p_SD_vs_dreadd_cno_1 p_ctrl_vs_mCherrry_cno_1 p_SD_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1...
        p_ctrl_vs_SD_2 p_ctrl_vs_dreadd_cno_2 p_SD_vs_dreadd_cno_2 p_ctrl_vs_mCherrry_cno_2 p_SD_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',12);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    %phase2
    if adj_p(7)<0.05; sigstar_MC({[6 7]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[6 9]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[7 9]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[6 8]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
    if adj_p(11)<0.05; sigstar_MC({[7 8]},adj_p(11),0,'LineWigth',16,'StarSize',24);end
    if adj_p(12)<0.05; sigstar_MC({[8 9]},adj_p(12),0,'LineWigth',16,'StarSize',24);end 
else
end

