%% To plot the figure you need to load data : 
Get_sleep_data_post_SDS_MC

%% FIGURE

figure, hold on
subplot(4,6,[1,2]) % WAKE percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
    xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('Wake percentage')
makepretty

if isparam==0
    %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2),nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2),nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2),nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
elseif isparam==1 % %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2),nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2),nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_ctrl,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD,2), nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2),nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_WAKE_end_ctrl,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_WAKE_end_SD,2), nanmean(data_perc_WAKE_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_WAKE_end_SD_mCherry_cno,2), nanmean(data_perc_WAKE_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,6,[7,8]) % SLEEP percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_totSleep_begin_ctrl,2), nanmean(data_perc_totSleep_begin_SD,2), nanmean(data_perc_totSleep_begin_SD_mCherry_cno,2), nanmean(data_perc_totSleep_begin_SD_dreadd_cno,2),...
    nanmean(data_perc_totSleep_interPeriod_ctrl,2), nanmean(data_perc_totSleep_interPeriod_SD,2), nanmean(data_perc_totSleep_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_totSleep_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_totSleep_end_ctrl,2), nanmean(data_perc_totSleep_end_SD,2), nanmean(data_perc_totSleep_end_SD_mCherry_cno,2), nanmean(data_perc_totSleep_end_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SLEEP percentage')
makepretty

if isparam==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_totSleep_begin_ctrl,2), nanmean(data_perc_totSleep_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_totSleep_begin_ctrl,2),nanmean(data_perc_totSleep_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_totSleep_begin_SD,2), nanmean(data_perc_totSleep_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_totSleep_begin_ctrl,2), nanmean(data_perc_totSleep_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_totSleep_begin_SD,2), nanmean(data_perc_totSleep_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_totSleep_begin_SD_mCherry_cno,2), nanmean(data_perc_totSleep_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_totSleep_interPeriod_ctrl,2), nanmean(data_perc_totSleep_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_totSleep_interPeriod_ctrl,2),nanmean(data_perc_totSleep_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_totSleep_interPeriod_SD,2), nanmean(data_perc_totSleep_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_totSleep_interPeriod_ctrl,2), nanmean(data_perc_totSleep_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_totSleep_interPeriod_SD,2), nanmean(data_perc_totSleep_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_totSleep_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_totSleep_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_totSleep_end_ctrl,2), nanmean(data_perc_totSleep_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_totSleep_end_ctrl,2),nanmean(data_perc_totSleep_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_totSleep_end_SD,2), nanmean(data_perc_totSleep_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_totSleep_end_ctrl,2), nanmean(data_perc_totSleep_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_totSleep_end_SD,2), nanmean(data_perc_totSleep_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_totSleep_end_SD_mCherry_cno,2), nanmean(data_perc_totSleep_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %%version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_totSleep_begin_ctrl,2), nanmean(data_perc_totSleep_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_totSleep_begin_ctrl,2),nanmean(data_perc_totSleep_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_totSleep_begin_SD,2), nanmean(data_perc_totSleep_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_totSleep_begin_ctrl,2), nanmean(data_perc_totSleep_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_totSleep_begin_SD,2), nanmean(data_perc_totSleep_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_totSleep_begin_SD_mCherry_cno,2), nanmean(data_perc_totSleep_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_totSleep_interPeriod_ctrl,2), nanmean(data_perc_totSleep_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_totSleep_interPeriod_ctrl,2),nanmean(data_perc_totSleep_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_totSleep_interPeriod_SD,2), nanmean(data_perc_totSleep_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_totSleep_interPeriod_ctrl,2), nanmean(data_perc_totSleep_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_totSleep_interPeriod_SD,2), nanmean(data_perc_totSleep_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_totSleep_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_totSleep_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_totSleep_end_ctrl,2), nanmean(data_perc_totSleep_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_totSleep_end_ctrl,2),nanmean(data_perc_totSleep_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_totSleep_end_SD,2), nanmean(data_perc_totSleep_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_totSleep_end_ctrl,2), nanmean(data_perc_totSleep_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_totSleep_end_SD,2), nanmean(data_perc_totSleep_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_totSleep_end_SD_mCherry_cno,2), nanmean(data_perc_totSleep_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end


subplot(4,6,[13,14]) % SWS percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SWS percentage')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2),nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_ctrl,2),nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_end_ctrl,2),nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2),nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_ctrl,2),nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_ctrl,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_SD,2), nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_end_ctrl,2),nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_SWS_end_ctrl,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_SWS_end_SD,2), nanmean(data_perc_SWS_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_SWS_end_SD_mCherry_cno,2), nanmean(data_perc_SWS_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[19,20]) % REM percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('REM percentage')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_begin_ctrl,2),nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2),nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_end_ctrl,2),nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_begin_ctrl,2),nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2),nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_interPeriod_ctrl,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD,2), nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_perc_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_end_ctrl,2),nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_perc_REM_end_ctrl,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_perc_REM_end_SD,2), nanmean(data_perc_REM_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_perc_REM_end_SD_mCherry_cno,2), nanmean(data_perc_REM_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[3,4]) % WAKE numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2),...
    nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('Wake num')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_begin_ctrl,2),nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_begin_SD_mCherry_cno,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_ctrl,2),nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_end_ctrl,2),nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_WAKE_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_begin_ctrl,2),nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_WAKE_begin_ctrl,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_begin_SD,2), nanmean(data_num_WAKE_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_begin_SD_mCherry_cno,2), nanmean(data_num_WAKE_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_ctrl,2),nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_ctrl,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_SD,2), nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_num_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_end_ctrl,2),nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_WAKE_end_ctrl,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_WAKE_end_SD,2), nanmean(data_num_WAKE_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_WAKE_end_SD_mCherry_cno,2), nanmean(data_num_WAKE_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[9,10]) % SLEEP numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_totSleep_begin_ctrl,2), nanmean(data_num_totSleep_begin_SD,2), nanmean(data_num_totSleep_begin_SD_mCherry_cno,2), nanmean(data_num_totSleep_begin_SD_dreadd_cno,2),...
    nanmean(data_num_totSleep_interPeriod_ctrl,2), nanmean(data_num_totSleep_interPeriod_SD,2), nanmean(data_num_totSleep_interPeriod_SD_mCherry_cno,2), nanmean(data_num_totSleep_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_num_totSleep_end_ctrl,2), nanmean(data_num_totSleep_end_SD,2), nanmean(data_num_totSleep_end_SD_mCherry_cno,2), nanmean(data_num_totSleep_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SLEEP num')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_totSleep_begin_ctrl,2), nanmean(data_num_totSleep_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_totSleep_begin_ctrl,2),nanmean(data_num_totSleep_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_totSleep_begin_SD,2), nanmean(data_num_totSleep_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_totSleep_begin_ctrl,2), nanmean(data_num_totSleep_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_totSleep_begin_SD,2), nanmean(data_num_totSleep_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_totSleep_begin_SD_mCherry_cno,2), nanmean(data_num_totSleep_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_totSleep_interPeriod_ctrl,2), nanmean(data_num_totSleep_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_totSleep_interPeriod_ctrl,2),nanmean(data_num_totSleep_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_totSleep_interPeriod_SD,2), nanmean(data_num_totSleep_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_totSleep_interPeriod_ctrl,2), nanmean(data_num_totSleep_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_totSleep_interPeriod_SD,2), nanmean(data_num_totSleep_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_totSleep_interPeriod_SD_mCherry_cno,2), nanmean(data_num_totSleep_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_totSleep_end_ctrl,2), nanmean(data_num_totSleep_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_totSleep_end_ctrl,2),nanmean(data_num_totSleep_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_totSleep_end_SD,2), nanmean(data_num_totSleep_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_totSleep_end_ctrl,2), nanmean(data_num_totSleep_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_totSleep_end_SD,2), nanmean(data_num_totSleep_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_totSleep_end_SD_mCherry_cno,2), nanmean(data_num_totSleep_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_totSleep_begin_ctrl,2), nanmean(data_num_totSleep_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_totSleep_begin_ctrl,2),nanmean(data_num_totSleep_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_totSleep_begin_SD,2), nanmean(data_num_totSleep_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_totSleep_begin_ctrl,2), nanmean(data_num_totSleep_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_totSleep_begin_SD,2), nanmean(data_num_totSleep_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_totSleep_begin_SD_mCherry_cno,2), nanmean(data_num_totSleep_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_totSleep_interPeriod_ctrl,2), nanmean(data_num_totSleep_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_totSleep_interPeriod_ctrl,2),nanmean(data_num_totSleep_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_totSleep_interPeriod_SD,2), nanmean(data_num_totSleep_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_totSleep_interPeriod_ctrl,2), nanmean(data_num_totSleep_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_totSleep_interPeriod_SD,2), nanmean(data_num_totSleep_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_totSleep_interPeriod_SD_mCherry_cno,2), nanmean(data_num_totSleep_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_totSleep_end_ctrl,2), nanmean(data_num_totSleep_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_totSleep_end_ctrl,2),nanmean(data_num_totSleep_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_totSleep_end_SD,2), nanmean(data_num_totSleep_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_totSleep_end_ctrl,2), nanmean(data_num_totSleep_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_totSleep_end_SD,2), nanmean(data_num_totSleep_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_totSleep_end_SD_mCherry_cno,2), nanmean(data_num_totSleep_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[15,16]) % SWS numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2),...
    nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SWS num')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_begin_ctrl,2),nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_begin_SD_mCherry_cno,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_ctrl,2),nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_end_ctrl,2),nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_SWS_end_SD_mCherry_cno,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_begin_ctrl,2),nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_begin_SD_mCherry_cno,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_interPeriod_ctrl,2),nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SWS_interPeriod_ctrl,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_interPeriod_SD,2), nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_num_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_end_ctrl,2),nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_SWS_end_ctrl,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_SWS_end_SD,2), nanmean(data_num_SWS_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_SWS_end_SD_mCherry_cno,2), nanmean(data_num_SWS_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[21,22]) % REM numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2),...
    nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('REM num')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_begin_ctrl,2),nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_ctrl,2),nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_end_ctrl,2),nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_begin_ctrl,2),nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_interPeriod_ctrl,2),nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_REM_interPeriod_ctrl,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_REM_interPeriod_SD,2), nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_num_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_end_ctrl,2),nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_num_REM_end_ctrl,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_num_REM_end_SD,2), nanmean(data_num_REM_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_num_REM_end_SD_mCherry_cno,2), nanmean(data_num_REM_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[5,6]) % WAKE durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2),...
    nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('Wake dur')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_ctrl,2),nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_ctrl,2),nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_end_ctrl,2),nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_WAKE_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_begin_ctrl,2),nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_WAKE_begin_ctrl,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_begin_SD,2), nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_begin_SD_mCherry_cno,2), nanmean(data_dur_WAKE_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_ctrl,2),nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_ctrl,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_SD,2), nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_WAKE_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_end_ctrl,2),nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_WAKE_end_ctrl,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_WAKE_end_SD,2), nanmean(data_dur_WAKE_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_WAKE_end_SD_mCherry_cno,2), nanmean(data_dur_WAKE_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[11,12]) % SLEEP durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_totSleep_begin_ctrl,2), nanmean(data_dur_totSleep_begin_SD,2), nanmean(data_dur_totSleep_begin_SD_mCherry_cno,2), nanmean(data_dur_totSleep_begin_SD_dreadd_cno,2),...
    nanmean(data_dur_totSleep_interPeriod_ctrl,2), nanmean(data_dur_totSleep_interPeriod_SD,2), nanmean(data_dur_totSleep_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_totSleep_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_totSleep_end_ctrl,2), nanmean(data_dur_totSleep_end_SD,2), nanmean(data_dur_totSleep_end_SD_mCherry_cno,2), nanmean(data_dur_totSleep_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SLEEP dur')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_totSleep_begin_ctrl,2), nanmean(data_dur_totSleep_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_totSleep_begin_ctrl,2),nanmean(data_dur_totSleep_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_totSleep_begin_SD,2), nanmean(data_dur_totSleep_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_totSleep_begin_ctrl,2), nanmean(data_dur_totSleep_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_totSleep_begin_SD,2), nanmean(data_dur_totSleep_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_totSleep_begin_SD_mCherry_cno,2), nanmean(data_dur_totSleep_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_totSleep_interPeriod_ctrl,2), nanmean(data_dur_totSleep_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_totSleep_interPeriod_ctrl,2),nanmean(data_dur_totSleep_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_totSleep_interPeriod_SD,2), nanmean(data_dur_totSleep_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_totSleep_interPeriod_ctrl,2), nanmean(data_dur_totSleep_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_totSleep_interPeriod_SD,2), nanmean(data_dur_totSleep_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_totSleep_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_totSleep_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_totSleep_end_ctrl,2), nanmean(data_dur_totSleep_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_totSleep_end_ctrl,2),nanmean(data_dur_totSleep_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_totSleep_end_SD,2), nanmean(data_dur_totSleep_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_totSleep_end_ctrl,2), nanmean(data_dur_totSleep_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_totSleep_end_SD,2), nanmean(data_dur_totSleep_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_totSleep_end_SD_mCherry_cno,2), nanmean(data_dur_totSleep_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_totSleep_begin_ctrl,2), nanmean(data_dur_totSleep_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_totSleep_begin_ctrl,2),nanmean(data_dur_totSleep_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_totSleep_begin_SD,2), nanmean(data_dur_totSleep_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_totSleep_begin_ctrl,2), nanmean(data_dur_totSleep_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_totSleep_begin_SD,2), nanmean(data_dur_totSleep_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_totSleep_begin_SD_mCherry_cno,2), nanmean(data_dur_totSleep_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_totSleep_interPeriod_ctrl,2), nanmean(data_dur_totSleep_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_totSleep_interPeriod_ctrl,2),nanmean(data_dur_totSleep_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_totSleep_interPeriod_SD,2), nanmean(data_dur_totSleep_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_totSleep_interPeriod_ctrl,2), nanmean(data_dur_totSleep_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_totSleep_interPeriod_SD,2), nanmean(data_dur_totSleep_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_totSleep_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_totSleep_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_totSleep_end_ctrl,2), nanmean(data_dur_totSleep_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_totSleep_end_ctrl,2),nanmean(data_dur_totSleep_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_totSleep_end_SD,2), nanmean(data_dur_totSleep_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_totSleep_end_ctrl,2), nanmean(data_dur_totSleep_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_totSleep_end_SD,2), nanmean(data_dur_totSleep_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_totSleep_end_SD_mCherry_cno,2), nanmean(data_dur_totSleep_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[17,18]) % SWS durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2),...
    nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('SWS dur')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_begin_ctrl,2),nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_begin_SD_mCherry_cno,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_ctrl,2),nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_end_ctrl,2),nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_SWS_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_begin_ctrl,2),nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_begin_SD_mCherry_cno,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_ctrl,2),nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_ctrl,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_SD,2), nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_SWS_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_end_ctrl,2),nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_SWS_end_ctrl,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_SWS_end_SD,2), nanmean(data_dur_SWS_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_SWS_end_SD_mCherry_cno,2), nanmean(data_dur_SWS_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,6,[23,24]) % REM durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2),...
    nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2)},...
        {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno,col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4,6:9,11:14],{},'paired',0,'showsigstar','none');
xticks([2.5 7.5 12.5]); xticklabels({'10-11h30','11h30-13h30','13h30-18h'}); xtickangle(0)
ylabel('REM dur')
makepretty

if isparam ==0 %%version ranksum
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_begin_ctrl,2),nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2),nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [p_ctrl_vs_SD, h] = ranksum(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2));
    [p_ctrl_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_end_ctrl,2),nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno, h] = ranksum(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno, h] = ranksum(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno, h] = ranksum(nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
elseif isparam ==1 %version ttest
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_begin_ctrl,2),nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[1 2]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[1 4]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[2 4]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[1 3]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[2 3]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2),nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_interPeriod_ctrl,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD,2), nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_interPeriod_SD_mCherry_cno,2), nanmean(data_dur_REM_interPeriod_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[6 7]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[6 9]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[7 9]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[6 8]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    
    [h,p_ctrl_vs_SD] = ttest2(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD,2));
    [h,p_ctrl_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_end_ctrl,2),nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [h,p_SD_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    [h,p_ctrl_vs_mCherrry_cno] = ttest2(nanmean(data_dur_REM_end_ctrl,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [h,p_SD_vs_mCherry_cno] = ttest2(nanmean(data_dur_REM_end_SD,2), nanmean(data_dur_REM_end_SD_mCherry_cno,2));
    [h,p_mCherry_cno_vs_dreadd_cno] = ttest2(nanmean(data_dur_REM_end_SD_mCherry_cno,2), nanmean(data_dur_REM_end_SD_dreadd_cno,2));
    if p_ctrl_vs_SD<0.05; sigstar_MC({[11 12]},p_ctrl_vs_SD,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_dreadd_cno<0.05; sigstar_MC({[11 14]},p_ctrl_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_dreadd_cno<0.05; sigstar_MC({[12 14]},p_SD_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
    if p_ctrl_vs_mCherrry_cno<0.05; sigstar_MC({[11 13]},p_ctrl_vs_mCherrry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_SD_vs_mCherry_cno<0.05; sigstar_MC({[7 8]},p_SD_vs_mCherry_cno,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno<0.05; sigstar_MC({[13 14]},p_mCherry_cno_vs_dreadd_cno,0,'LineWigth',16,'StarSize',24);end
else
end


