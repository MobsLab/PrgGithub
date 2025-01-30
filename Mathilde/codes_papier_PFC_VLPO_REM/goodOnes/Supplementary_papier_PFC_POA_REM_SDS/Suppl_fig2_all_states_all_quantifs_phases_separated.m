%% bar plot all states 4 groups and 3 periods
col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];
col_mCherry_cno = [1 .2 0];
col_dreadd_cno = [0 .4 .4];

isparam=0;
iscorr=1;


figure, hold on
subplot(4,9,[1]) % WAKE percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 1'}); xtickangle(0)
% ylabel('Wake percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2),nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2),nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[10]) % WAKE percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 2'}); xtickangle(0)
% ylabel('Wake percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2),nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2),nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[19]) % WAKE percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 3'}); xtickangle(0)
% ylabel('Wake percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2),nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2),nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end








subplot(4,9,[2]) % SWS percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 1'}); xtickangle(0)
% ylabel('NREM percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2),nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2),nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[11]) % SWS percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 2'}); xtickangle(0)
% ylabel('NREM percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_ctrl,2),nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_ctrl,2),nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[20]) % SWS percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 3'}); xtickangle(0)
% ylabel('NREM percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_end_ctrl,2),nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_end_ctrl,2),nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,9,[3]) % REM percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 1'}); xtickangle(0)
% ylabel('REM percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_begin_ctrl,2),nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_begin_ctrl,2),nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[12]) % REM percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 2'}); xtickangle(0)
% ylabel('REM percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2),nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2),nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[21]) % REM percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 3'}); xtickangle(0)
% ylabel('REM percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_end_ctrl,2),nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_end_ctrl,2),nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end








subplot(4,9,[4]) % WAKE numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 1'}); xtickangle(0)
% ylabel('Wake bouts number')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_begin_ctrl,2),nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_begin_SD_mCherry_cno,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_begin_ctrl,2),nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_begin_SD_mCherry_cno,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[13]) % WAKE numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 2'}); xtickangle(0)
% ylabel('Wake bouts number')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_ctrl,2),nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_ctrl,2),nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[22]) % WAKE numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 3'}); xtickangle(0)
% ylabel('Wake bouts number')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_end_ctrl,2),nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_end_ctrl,2),nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end









subplot(4,9,[5]) % SWS numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 1'}); xtickangle(0)
% ylabel('NREM bouts number')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_begin_ctrl,2),nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_begin_SD_mCherry_cno,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_begin_ctrl,2),nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_begin_SD_mCherry_cno,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[14]) % SWS numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 2'}); xtickangle(0)
% ylabel('NREM bouts number')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_ctrl,2),nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_interPeriod_ctrl,2),nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[23]) % SWS numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 3'}); xtickangle(0)
% ylabel('NREM bouts number')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_end_ctrl,2),nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_end_SD_mCherry_cno,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_end_ctrl,2),nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_end_SD_mCherry_cno,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end








subplot(4,9,[6]) % REM numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 1'}); xtickangle(0)
% ylabel('REM bouts number')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_begin_ctrl,2),nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_begin_ctrl,2),nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[15]) % REM numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 2'}); xtickangle(0)
% ylabel('REM bouts number')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_ctrl,2),nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_interPeriod_ctrl,2),nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[24]) % REM numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 3'}); xtickangle(0)
% ylabel('REM bouts number')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_end_ctrl,2),nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_end_ctrl,2),nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end








subplot(4,9,[7]) % WAKE durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 1'}); xtickangle(0)
% ylabel('Wake bouts duration (s)')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_ctrl,2),nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_begin_ctrl,2),nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[16]) % WAKE durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 2'}); xtickangle(0)
% ylabel('Wake bouts duration (s)')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_ctrl,2),nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_ctrl,2),nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[25]) % WAKE durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 3'}); xtickangle(0)
% ylabel('Wake bouts duration (s)')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_end_ctrl,2),nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_end_ctrl,2),nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end








subplot(4,9,[8]) % SWS durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 1'}); xtickangle(0)
% ylabel('NREM bouts duration (s)')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_begin_ctrl,2),nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_begin_SD_mCherry_cno,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_begin_ctrl,2),nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_begin_SD_mCherry_cno,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[17]) % SWS durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 2'}); xtickangle(0)
% ylabel('NREM bouts duration (s)')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_ctrl,2),nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_ctrl,2),nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[26]) % SWS durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 3'}); xtickangle(0)
% ylabel('NREM bouts duration (s)')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_end_ctrl,2),nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_end_ctrl,2),nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end








subplot(4,9,[9]) % REM durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 1'}); xtickangle(0)
% ylabel('REM bouts duration (s)')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_begin_ctrl,2),nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_begin_ctrl,2),nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[18]) % REM durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 2'}); xtickangle(0)
% ylabel('REM bouts duration (s)')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2),nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2),nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,9,[27]) % REM durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none');
xticks([2.5]); xticklabels({'Phase 3'}); xtickangle(0)
% ylabel('REM bouts duration (s)')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_end_ctrl,2),nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_end_ctrl,2),nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
else
end
if iscorr==0
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_ctrl_vs_SD p_ctrl_vs_dreadd_cno p_SD_vs_dreadd_cno p_ctrl_vs_mCherrry_cno p_SD_vs_mCherry_cno p_mCherry_cno_vs_dreadd_cno];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end

