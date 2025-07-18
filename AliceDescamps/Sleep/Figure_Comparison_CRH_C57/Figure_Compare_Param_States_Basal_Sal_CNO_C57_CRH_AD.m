%% To plot the figure you need to load data : 
Get_sleep_data_Sal_CNO_basal_C57_CRH_AD

%%
txt_size = 15;

% C57/CRH SD
col_C57_Sal = [.8 0 .1];
col_C57_cno = [.6 0 .6];
col_mCherry_cno = [0 .6 .4];
col_dreadd_cno = [.2 .4 .2];

isparam=0;
iscorr=1;


figure
subplot(2,5,[1],'align') %WAKE percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_begin_C57_Sal,2), nanmean(data_perc_WAKE_begin_C57_cno,2), nanmean(data_perc_WAKE_begin_CRH_Sal,2), nanmean(data_perc_WAKE_begin_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('Wake percentage')
makepretty
ylim([0 150])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_C57_Sal_vs_C57_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_C57_Sal,2), nanmean(data_perc_WAKE_begin_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_C57_Sal,2),nanmean(data_perc_WAKE_begin_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_C57_cno,2), nanmean(data_perc_WAKE_begin_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_C57_Sal,2), nanmean(data_perc_WAKE_begin_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_C57_cno,2), nanmean(data_perc_WAKE_begin_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_CRH_Sal,2), nanmean(data_perc_WAKE_begin_CRH_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_C57_Sal_vs_C57_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_C57_Sal,2), nanmean(data_perc_WAKE_begin_C57_cno,2));
    [h_1,p_C57_Sal_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_C57_Sal,2),nanmean(data_perc_WAKE_begin_CRH_cno,2));
    [h_1,p_C57_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_C57_cno,2), nanmean(data_perc_WAKE_begin_CRH_cno,2));
    [h_1,p_C57_Sal_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_C57_Sal,2), nanmean(data_perc_WAKE_begin_CRH_Sal,2));
    [h_1,p_C57_cno_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_C57_cno,2), nanmean(data_perc_WAKE_begin_CRH_Sal,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_WAKE_begin_CRH_Sal,2), nanmean(data_perc_WAKE_begin_CRH_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[1 2]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_1 p_C57_Sal_vs_dreadd_cno_1 p_C57_cno_vs_dreadd_cno_1 p_C57_Sal_vs_mCherrry_cno_1 p_C57_cno_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    

    

subplot(2,5,[2],'align') %NREM percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_begin_C57_Sal,2), nanmean(data_perc_SWS_begin_C57_cno,2), nanmean(data_perc_SWS_begin_CRH_Sal,2), nanmean(data_perc_SWS_begin_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('NREM percentage')
makepretty
ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_C57_Sal_vs_C57_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_C57_Sal,2), nanmean(data_perc_SWS_begin_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_C57_Sal,2),nanmean(data_perc_SWS_begin_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_C57_cno,2), nanmean(data_perc_SWS_begin_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_C57_Sal,2), nanmean(data_perc_SWS_begin_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_C57_cno,2), nanmean(data_perc_SWS_begin_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_CRH_Sal,2), nanmean(data_perc_SWS_begin_CRH_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_C57_Sal_vs_C57_cno_1] = ttest2(nanmean(data_perc_SWS_begin_C57_Sal,2), nanmean(data_perc_SWS_begin_C57_cno,2));
    [h_1,p_C57_Sal_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_begin_C57_Sal,2),nanmean(data_perc_SWS_begin_CRH_cno,2));
    [h_1,p_C57_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_begin_C57_cno,2), nanmean(data_perc_SWS_begin_CRH_cno,2));
    [h_1,p_C57_Sal_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_SWS_begin_C57_Sal,2), nanmean(data_perc_SWS_begin_CRH_Sal,2));
    [h_1,p_C57_cno_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_SWS_begin_C57_cno,2), nanmean(data_perc_SWS_begin_CRH_Sal,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_SWS_begin_CRH_Sal,2), nanmean(data_perc_SWS_begin_CRH_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[1 2]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_1 p_C57_Sal_vs_dreadd_cno_1 p_C57_cno_vs_dreadd_cno_1 p_C57_Sal_vs_mCherrry_cno_1 p_C57_cno_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(2,5,[3],'align') %REM percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_begin_C57_Sal,2), nanmean(data_perc_REM_begin_C57_cno,2), nanmean(data_perc_REM_begin_CRH_Sal,2), nanmean(data_perc_REM_begin_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM percentage')
makepretty
ylim([0 10])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_C57_Sal_vs_C57_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_C57_Sal,2), nanmean(data_perc_REM_begin_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_C57_Sal,2),nanmean(data_perc_REM_begin_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_C57_cno,2), nanmean(data_perc_REM_begin_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_C57_Sal,2), nanmean(data_perc_REM_begin_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_C57_cno,2), nanmean(data_perc_REM_begin_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_CRH_Sal,2), nanmean(data_perc_REM_begin_CRH_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_C57_Sal_vs_C57_cno_1] = ttest2(nanmean(data_perc_REM_begin_C57_Sal,2), nanmean(data_perc_REM_begin_C57_cno,2));
    [h_1,p_C57_Sal_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_begin_C57_Sal,2),nanmean(data_perc_REM_begin_CRH_cno,2));
    [h_1,p_C57_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_begin_C57_cno,2), nanmean(data_perc_REM_begin_CRH_cno,2));
    [h_1,p_C57_Sal_vs_mCherrry_cno_1] = ttest2(nanmean(data_perc_REM_begin_C57_Sal,2), nanmean(data_perc_REM_begin_CRH_Sal,2));
    [h_1,p_C57_cno_vs_mCherry_cno_1] = ttest2(nanmean(data_perc_REM_begin_C57_cno,2), nanmean(data_perc_REM_begin_CRH_Sal,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_perc_REM_begin_CRH_Sal,2), nanmean(data_perc_REM_begin_CRH_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[1 2]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_1 p_C57_Sal_vs_dreadd_cno_1 p_C57_cno_vs_dreadd_cno_1 p_C57_Sal_vs_mCherrry_cno_1 p_C57_cno_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(2,5,[4],'align') %REM num phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_begin_C57_Sal,2), nanmean(data_num_REM_begin_C57_cno,2), nanmean(data_num_REM_begin_CRH_Sal,2), nanmean(data_num_REM_begin_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM bouts number')
makepretty
ylim([0 8])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_C57_Sal_vs_C57_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_C57_Sal,2), nanmean(data_num_REM_begin_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_C57_Sal,2),nanmean(data_num_REM_begin_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_C57_cno,2), nanmean(data_num_REM_begin_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_C57_Sal,2), nanmean(data_num_REM_begin_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_C57_cno,2), nanmean(data_num_REM_begin_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_CRH_Sal,2), nanmean(data_num_REM_begin_CRH_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_C57_Sal_vs_C57_cno_1] = ttest2(nanmean(data_num_REM_begin_C57_Sal,2), nanmean(data_num_REM_begin_C57_cno,2));
    [h_1,p_C57_Sal_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_begin_C57_Sal,2),nanmean(data_num_REM_begin_CRH_cno,2));
    [h_1,p_C57_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_begin_C57_cno,2), nanmean(data_num_REM_begin_CRH_cno,2));
    [h_1,p_C57_Sal_vs_mCherrry_cno_1] = ttest2(nanmean(data_num_REM_begin_C57_Sal,2), nanmean(data_num_REM_begin_CRH_Sal,2));
    [h_1,p_C57_cno_vs_mCherry_cno_1] = ttest2(nanmean(data_num_REM_begin_C57_cno,2), nanmean(data_num_REM_begin_CRH_Sal,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_REM_begin_CRH_Sal,2), nanmean(data_num_REM_begin_CRH_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[1 2]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_1 p_C57_Sal_vs_dreadd_cno_1 p_C57_cno_vs_dreadd_cno_1 p_C57_Sal_vs_mCherrry_cno_1 p_C57_cno_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(2,5,[5],'align') %REM dur phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_begin_C57_Sal,2), nanmean(data_dur_REM_begin_C57_cno,2), nanmean(data_dur_REM_begin_CRH_Sal,2), nanmean(data_dur_REM_begin_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM bouts duration (s)')
makepretty
ylim([0 125])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_C57_Sal_vs_C57_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_C57_Sal,2), nanmean(data_dur_REM_begin_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_C57_Sal,2),nanmean(data_dur_REM_begin_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_C57_cno,2), nanmean(data_dur_REM_begin_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_C57_Sal,2), nanmean(data_dur_REM_begin_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_C57_cno,2), nanmean(data_dur_REM_begin_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_CRH_Sal,2), nanmean(data_dur_REM_begin_CRH_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_C57_Sal_vs_C57_cno_1] = ttest2(nanmean(data_dur_REM_begin_C57_Sal,2), nanmean(data_dur_REM_begin_C57_cno,2));
    [h_1,p_C57_Sal_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_begin_C57_Sal,2),nanmean(data_dur_REM_begin_CRH_cno,2));
    [h_1,p_C57_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_begin_C57_cno,2), nanmean(data_dur_REM_begin_CRH_cno,2));
    [h_1,p_C57_Sal_vs_mCherrry_cno_1] = ttest2(nanmean(data_dur_REM_begin_C57_Sal,2), nanmean(data_dur_REM_begin_CRH_Sal,2));
    [h_1,p_C57_cno_vs_mCherry_cno_1] = ttest2(nanmean(data_dur_REM_begin_C57_cno,2), nanmean(data_dur_REM_begin_CRH_Sal,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_REM_begin_CRH_Sal,2), nanmean(data_dur_REM_begin_CRH_cno,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[1 2]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[1 4]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[2 4]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[1 3]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[2 3]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[3 4]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_1 p_C57_Sal_vs_dreadd_cno_1 p_C57_cno_vs_dreadd_cno_1 p_C57_Sal_vs_mCherrry_cno_1 p_C57_cno_vs_mCherry_cno_1 p_mCherry_cno_vs_dreadd_cno_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    







subplot(2,5,[6],'align') %WAKE percentage phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_WAKE_end_C57_Sal,2), nanmean(data_perc_WAKE_end_C57_cno,2), nanmean(data_perc_WAKE_end_CRH_Sal,2), nanmean(data_perc_WAKE_end_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('Wake percentage')
makepretty
ylim([0 50])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_C57_Sal_vs_C57_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_C57_Sal,2), nanmean(data_perc_WAKE_end_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_C57_Sal,2),nanmean(data_perc_WAKE_end_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_C57_cno,2), nanmean(data_perc_WAKE_end_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_C57_Sal,2), nanmean(data_perc_WAKE_end_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_C57_cno,2), nanmean(data_perc_WAKE_end_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_CRH_Sal,2), nanmean(data_perc_WAKE_end_CRH_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_C57_Sal_vs_C57_cno_2] = ttest2(nanmean(data_perc_WAKE_end_C57_Sal,2), nanmean(data_perc_WAKE_end_C57_cno,2));
    [h_2,p_C57_Sal_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_end_C57_Sal,2),nanmean(data_perc_WAKE_end_CRH_cno,2));
    [h_2,p_C57_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_end_C57_cno,2), nanmean(data_perc_WAKE_end_CRH_cno,2));
    [h_2,p_C57_Sal_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_WAKE_end_C57_Sal,2), nanmean(data_perc_WAKE_end_CRH_Sal,2));
    [h_2,p_C57_cno_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_WAKE_end_C57_cno,2), nanmean(data_perc_WAKE_end_CRH_Sal,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_WAKE_end_CRH_Sal,2), nanmean(data_perc_WAKE_end_CRH_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[6 7]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_2 p_C57_Sal_vs_dreadd_cno_2 p_C57_cno_vs_dreadd_cno_2 p_C57_Sal_vs_mCherrry_cno_2 p_C57_cno_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
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






subplot(2,5,[7],'align') %NREM percentage phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_SWS_end_C57_Sal,2), nanmean(data_perc_SWS_end_C57_cno,2), nanmean(data_perc_SWS_end_CRH_Sal,2), nanmean(data_perc_SWS_end_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('NREM percentage')
makepretty
ylim([0 80])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_C57_Sal_vs_C57_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_C57_Sal,2), nanmean(data_perc_SWS_end_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_C57_Sal,2),nanmean(data_perc_SWS_end_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_C57_cno,2), nanmean(data_perc_SWS_end_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_C57_Sal,2), nanmean(data_perc_SWS_end_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_C57_cno,2), nanmean(data_perc_SWS_end_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_CRH_Sal,2), nanmean(data_perc_SWS_end_CRH_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_C57_Sal_vs_C57_cno_2] = ttest2(nanmean(data_perc_SWS_end_C57_Sal,2), nanmean(data_perc_SWS_end_C57_cno,2));
    [h_2,p_C57_Sal_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_end_C57_Sal,2),nanmean(data_perc_SWS_end_CRH_cno,2));
    [h_2,p_C57_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_end_C57_cno,2), nanmean(data_perc_SWS_end_CRH_cno,2));
    [h_2,p_C57_Sal_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_SWS_end_C57_Sal,2), nanmean(data_perc_SWS_end_CRH_Sal,2));
    [h_2,p_C57_cno_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_SWS_end_C57_cno,2), nanmean(data_perc_SWS_end_CRH_Sal,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_SWS_end_CRH_Sal,2), nanmean(data_perc_SWS_end_CRH_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[6 7]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_2 p_C57_Sal_vs_dreadd_cno_2 p_C57_cno_vs_dreadd_cno_2 p_C57_Sal_vs_mCherrry_cno_2 p_C57_cno_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
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




subplot(2,5,[8],'align') %REM percentage phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_REM_end_C57_Sal,2), nanmean(data_perc_REM_end_C57_cno,2), nanmean(data_perc_REM_end_CRH_Sal,2), nanmean(data_perc_REM_end_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM percentage')
makepretty
ylim([0 15])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_C57_Sal_vs_C57_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_C57_Sal,2), nanmean(data_perc_REM_end_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_C57_Sal,2),nanmean(data_perc_REM_end_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_C57_cno,2), nanmean(data_perc_REM_end_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_C57_Sal,2), nanmean(data_perc_REM_end_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_C57_cno,2), nanmean(data_perc_REM_end_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_CRH_Sal,2), nanmean(data_perc_REM_end_CRH_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_C57_Sal_vs_C57_cno_2] = ttest2(nanmean(data_perc_REM_end_C57_Sal,2), nanmean(data_perc_REM_end_C57_cno,2));
    [h_2,p_C57_Sal_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_end_C57_Sal,2),nanmean(data_perc_REM_end_CRH_cno,2));
    [h_2,p_C57_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_end_C57_cno,2), nanmean(data_perc_REM_end_CRH_cno,2));
    [h_2,p_C57_Sal_vs_mCherrry_cno_2] = ttest2(nanmean(data_perc_REM_end_C57_Sal,2), nanmean(data_perc_REM_end_CRH_Sal,2));
    [h_2,p_C57_cno_vs_mCherry_cno_2] = ttest2(nanmean(data_perc_REM_end_C57_cno,2), nanmean(data_perc_REM_end_CRH_Sal,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_perc_REM_end_CRH_Sal,2), nanmean(data_perc_REM_end_CRH_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[6 7]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_2 p_C57_Sal_vs_dreadd_cno_2 p_C57_cno_vs_dreadd_cno_2 p_C57_Sal_vs_mCherrry_cno_2 p_C57_cno_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
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



subplot(2,5,[9],'align') %REM num phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_num_REM_end_C57_Sal,2), nanmean(data_num_REM_end_C57_cno,2), nanmean(data_num_REM_end_CRH_Sal,2), nanmean(data_num_REM_end_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM bouts number')
makepretty
ylim([0 60])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_C57_Sal_vs_C57_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_C57_Sal,2), nanmean(data_num_REM_end_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_C57_Sal,2),nanmean(data_num_REM_end_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_C57_cno,2), nanmean(data_num_REM_end_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_C57_Sal,2), nanmean(data_num_REM_end_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_C57_cno,2), nanmean(data_num_REM_end_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_CRH_Sal,2), nanmean(data_num_REM_end_CRH_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_C57_Sal_vs_C57_cno_2] = ttest2(nanmean(data_num_REM_end_C57_Sal,2), nanmean(data_num_REM_end_C57_cno,2));
    [h_2,p_C57_Sal_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_end_C57_Sal,2),nanmean(data_num_REM_end_CRH_cno,2));
    [h_2,p_C57_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_end_C57_cno,2), nanmean(data_num_REM_end_CRH_cno,2));
    [h_2,p_C57_Sal_vs_mCherrry_cno_2] = ttest2(nanmean(data_num_REM_end_C57_Sal,2), nanmean(data_num_REM_end_CRH_Sal,2));
    [h_2,p_C57_cno_vs_mCherry_cno_2] = ttest2(nanmean(data_num_REM_end_C57_cno,2), nanmean(data_num_REM_end_CRH_Sal,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_num_REM_end_CRH_Sal,2), nanmean(data_num_REM_end_CRH_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[6 7]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_2 p_C57_Sal_vs_dreadd_cno_2 p_C57_cno_vs_dreadd_cno_2 p_C57_Sal_vs_mCherrry_cno_2 p_C57_cno_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);else sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',12);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end


subplot(2,5,[10],'align') %REM dur phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_REM_end_C57_Sal,2), nanmean(data_dur_REM_end_C57_cno,2), nanmean(data_dur_REM_end_CRH_Sal,2), nanmean(data_dur_REM_end_CRH_cno,2)},...
    {col_C57_Sal,col_C57_cno,col_mCherry_cno,col_dreadd_cno},[1:4],{},'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM bouts duration (s)')
makepretty
ylim([0 110])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_C57_Sal_vs_C57_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_C57_Sal,2), nanmean(data_dur_REM_end_C57_cno,2));
    [p_C57_Sal_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_C57_Sal,2),nanmean(data_dur_REM_end_CRH_cno,2));
    [p_C57_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_C57_cno,2), nanmean(data_dur_REM_end_CRH_cno,2));
    [p_C57_Sal_vs_mCherrry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_C57_Sal,2), nanmean(data_dur_REM_end_CRH_Sal,2));
    [p_C57_cno_vs_mCherry_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_C57_cno,2), nanmean(data_dur_REM_end_CRH_Sal,2));
    [p_mCherry_cno_vs_dreadd_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_CRH_Sal,2), nanmean(data_dur_REM_end_CRH_cno,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_2,p_C57_Sal_vs_C57_cno_2] = ttest2(nanmean(data_dur_REM_end_C57_Sal,2), nanmean(data_dur_REM_end_C57_cno,2));
    [h_2,p_C57_Sal_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_end_C57_Sal,2),nanmean(data_dur_REM_end_CRH_cno,2));
    [h_2,p_C57_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_end_C57_cno,2), nanmean(data_dur_REM_end_CRH_cno,2));
    [h_2,p_C57_Sal_vs_mCherrry_cno_2] = ttest2(nanmean(data_dur_REM_end_C57_Sal,2), nanmean(data_dur_REM_end_CRH_Sal,2));
    [h_2,p_C57_cno_vs_mCherry_cno_2] = ttest2(nanmean(data_dur_REM_end_C57_cno,2), nanmean(data_dur_REM_end_CRH_Sal,2));
    [h_2,p_mCherry_cno_vs_dreadd_cno_2] = ttest2(nanmean(data_dur_REM_end_CRH_Sal,2), nanmean(data_dur_REM_end_CRH_cno,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_C57_Sal_vs_C57_cno_2<0.05; sigstar_MC({[6 7]},p_C57_Sal_vs_C57_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_dreadd_cno_2<0.05; sigstar_MC({[6 9]},p_C57_Sal_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[7 9]},p_C57_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_Sal_vs_mCherrry_cno_2<0.05; sigstar_MC({[6 8]},p_C57_Sal_vs_mCherrry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_C57_cno_vs_mCherry_cno_2<0.05; sigstar_MC({[7 8]},p_C57_cno_vs_mCherry_cno_2,0,'LineWigth',16,'StarSize',24);end
    if p_mCherry_cno_vs_dreadd_cno_2<0.05; sigstar_MC({[8 9]},p_mCherry_cno_vs_dreadd_cno_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_C57_Sal_vs_C57_cno_2 p_C57_Sal_vs_dreadd_cno_2 p_C57_cno_vs_dreadd_cno_2 p_C57_Sal_vs_mCherrry_cno_2 p_C57_cno_vs_mCherry_cno_2 p_mCherry_cno_vs_dreadd_cno_2];
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

% C57/CRH basal
% col_C57_Sal = [.7 .7 .7];
% col_C57_cno = [.2 .2 .2];
% col_mCherry_cno = [1 .4 0];
% col_dreadd_cno = [1 .2 0];

% C57/CRH SD
col_C57_Sal = [.8 0 .1];
col_C57_cno = [.6 0 .6];
col_mCherry_cno = [0 .6 .4];
col_dreadd_cno = [.2 .4 .2];


figure, hold on
subplot(3,6,[1,2]) % wake percentage overtime
plot(nanmean(data_perc_WAKE_C57_Sal),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_C57_Sal,'color',col_C57_Sal), hold on
errorbar(nanmean(data_perc_WAKE_C57_Sal), stdError(data_perc_WAKE_C57_Sal),'LineWidth',2,'color',col_C57_Sal)
plot(nanmean(data_perc_WAKE_C57_cno,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_C57_cno,'markersize',8,'color',col_C57_cno)
errorbar(nanmean(data_perc_WAKE_C57_cno,1), stdError(data_perc_WAKE_C57_cno),'linestyle','-','LineWidth',2,'color',col_C57_cno)
plot(nanmean(data_perc_WAKE_CRH_Sal),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_perc_WAKE_CRH_Sal), stdError(data_perc_WAKE_CRH_Sal),'LineWidth',2,'color',col_mCherry_cno)
plot(nanmean(data_perc_WAKE_CRH_cno),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_perc_WAKE_CRH_cno), stdError(data_perc_WAKE_CRH_cno),'LineWidth',2,'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
ylim([0 100])
makepretty
title('Wake percentage')
xlabel('Time of the day (h)')

subplot(3,6,[3,4]) % wake num overtime
plot(nanmean(data_num_WAKE_C57_Sal),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_C57_Sal,'color',col_C57_Sal), hold on
errorbar(nanmean(data_num_WAKE_C57_Sal), stdError(data_num_WAKE_C57_Sal),'LineWidth',2,'color',col_C57_Sal)
plot(nanmean(data_num_WAKE_C57_cno,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_C57_cno,'markersize',8,'color',col_C57_cno)
errorbar(nanmean(data_num_WAKE_C57_cno,1), stdError(data_num_WAKE_C57_cno),'linestyle','-','LineWidth',2,'color',col_C57_cno)
plot(nanmean(data_num_WAKE_CRH_Sal),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_num_WAKE_CRH_Sal), stdError(data_num_WAKE_CRH_Sal),'LineWidth',2,'color',col_mCherry_cno)
plot(nanmean(data_num_WAKE_CRH_cno),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_num_WAKE_CRH_cno), stdError(data_num_WAKE_CRH_cno),'LineWidth',2,'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('Wake bouts number')
xlabel('Time of the day (h)')

subplot(3,6,[5,6]) % wake duration overtime
plot(nanmean(data_dur_WAKE_C57_Sal),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_C57_Sal,'color',col_C57_Sal), hold on
errorbar(nanmean(data_dur_WAKE_C57_Sal), stdError(data_dur_WAKE_C57_Sal),'LineWidth',2,'color',col_C57_Sal)
plot(nanmean(data_dur_WAKE_C57_cno,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_C57_cno,'markersize',8,'color',col_C57_cno)
errorbar(nanmean(data_dur_WAKE_C57_cno,1), stdError(data_dur_WAKE_C57_cno),'linestyle','-','LineWidth',2,'color',col_C57_cno)
plot(nanmean(data_dur_WAKE_CRH_Sal),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_dur_WAKE_CRH_Sal), stdError(data_dur_WAKE_CRH_Sal),'LineWidth',2,'color',col_mCherry_cno)
plot(nanmean(data_dur_WAKE_CRH_cno),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_dur_WAKE_CRH_cno), stdError(data_dur_WAKE_CRH_cno),'LineWidth',2,'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('Wake bouts duration')
xlabel('Time of the day (h)')


subplot(3,6,[7,8]), hold on % SWS percentage overtime
plot(nanmean(data_perc_SWS_C57_Sal),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_C57_Sal,'color',col_C57_Sal), hold on
errorbar(nanmean(data_perc_SWS_C57_Sal), stdError(data_perc_SWS_C57_Sal),'LineWidth',2,'color',col_C57_Sal)
plot(nanmean(data_perc_SWS_C57_cno,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_C57_cno,'markersize',8,'color',col_C57_cno)
errorbar(nanmean(data_perc_SWS_C57_cno,1), stdError(data_perc_SWS_C57_cno),'linestyle','-','LineWidth',2,'color',col_C57_cno)
plot(nanmean(data_perc_SWS_CRH_Sal),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_perc_SWS_CRH_Sal), stdError(data_perc_SWS_CRH_Sal),'LineWidth',2,'color',col_mCherry_cno)
plot(nanmean(data_perc_SWS_CRH_cno),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_perc_SWS_CRH_cno), stdError(data_perc_SWS_CRH_cno),'LineWidth',2,'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
ylim([0 100])
makepretty
title('NREM percentage')
xlabel('Time of the day (h)')

subplot(3,6,[9,10]), hold on % SWS number overtime
plot(nanmean(data_num_SWS_C57_Sal),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_C57_Sal,'color',col_C57_Sal), hold on
errorbar(nanmean(data_num_SWS_C57_Sal), stdError(data_num_SWS_C57_Sal),'LineWidth',2,'color',col_C57_Sal)
plot(nanmean(data_num_SWS_C57_cno,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_C57_cno,'markersize',8,'color',col_C57_cno)
errorbar(nanmean(data_num_SWS_C57_cno,1), stdError(data_num_SWS_C57_cno),'linestyle','-','LineWidth',2,'color',col_C57_cno)
plot(nanmean(data_num_SWS_CRH_Sal),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_num_SWS_CRH_Sal), stdError(data_num_SWS_CRH_Sal),'LineWidth',2,'color',col_mCherry_cno)
plot(nanmean(data_num_SWS_CRH_cno),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_num_SWS_CRH_cno), stdError(data_num_SWS_CRH_cno),'LineWidth',2,'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('NREM bouts number')
xlabel('Time of the day (h)')

subplot(3,6,[11,12]), hold on % SWS duration overtime
plot(nanmean(data_dur_SWS_C57_Sal),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_C57_Sal,'color',col_C57_Sal), hold on
errorbar(nanmean(data_dur_SWS_C57_Sal), stdError(data_dur_SWS_C57_Sal),'LineWidth',2,'color',col_C57_Sal)
plot(nanmean(data_dur_SWS_C57_cno,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_C57_cno,'markersize',8,'color',col_C57_cno)
errorbar(nanmean(data_dur_SWS_C57_cno,1), stdError(data_dur_SWS_C57_cno),'linestyle','-','LineWidth',2,'color',col_C57_cno)
plot(nanmean(data_dur_SWS_CRH_Sal),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_dur_SWS_CRH_Sal), stdError(data_dur_SWS_CRH_Sal),'LineWidth',2,'color',col_mCherry_cno)
plot(nanmean(data_dur_SWS_CRH_cno),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_dur_SWS_CRH_cno), stdError(data_dur_SWS_CRH_cno),'LineWidth',2,'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('NREM bouts duration')
xlabel('Time of the day (h)')


subplot(3,6,[13,14]) %REM percentage overtime
plot(nanmean(data_perc_REM_C57_Sal),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_C57_Sal,'color',col_C57_Sal), hold on
errorbar(nanmean(data_perc_REM_C57_Sal), stdError(data_perc_REM_C57_Sal),'LineWidth',2,'color',col_C57_Sal)
plot(nanmean(data_perc_REM_C57_cno,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_C57_cno,'markersize',8,'color',col_C57_cno)
errorbar(nanmean(data_perc_REM_C57_cno,1), stdError(data_perc_REM_C57_cno),'linestyle','-','LineWidth',2,'color',col_C57_cno)
plot(nanmean(data_perc_REM_CRH_Sal),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_perc_REM_CRH_Sal), stdError(data_perc_REM_CRH_Sal),'LineWidth',2,'color',col_mCherry_cno)
plot(nanmean(data_perc_REM_CRH_cno),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_perc_REM_CRH_cno), stdError(data_perc_REM_CRH_cno),'LineWidth',2,'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('REM percentage')
xlabel('Time of the day (h)')

subplot(3,6,[15,16]) %REM number overtime
plot(nanmean(data_num_REM_C57_Sal),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_C57_Sal,'color',col_C57_Sal), hold on
errorbar(nanmean(data_num_REM_C57_Sal), stdError(data_num_REM_C57_Sal),'LineWidth',2,'color',col_C57_Sal)
plot(nanmean(data_num_REM_C57_cno,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_C57_cno,'markersize',8,'color',col_C57_cno)
errorbar(nanmean(data_num_REM_C57_cno,1), stdError(data_num_REM_C57_cno),'linestyle','-','LineWidth',2,'color',col_C57_cno)
plot(nanmean(data_num_REM_CRH_Sal),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_num_REM_CRH_Sal), stdError(data_num_REM_CRH_Sal),'LineWidth',2,'color',col_mCherry_cno)
plot(nanmean(data_num_REM_CRH_cno),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_num_REM_CRH_cno), stdError(data_num_REM_CRH_cno),'LineWidth',2,'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('REM bouts number')
xlabel('Time of the day (h)')

subplot(3,6,[17,18]) % REM bouts duration ovetime
plot(nanmean(data_dur_REM_C57_Sal),'linestyle','-','LineWidth',2,'marker','square','markersize',8,'markerfacecolor',col_C57_Sal,'color',col_C57_Sal), hold on
errorbar(nanmean(data_dur_REM_C57_Sal), stdError(data_dur_REM_C57_Sal),'LineWidth',2,'color',col_C57_Sal)
plot(nanmean(data_dur_REM_C57_cno,1),'linestyle','-','LineWidth',2,'marker','^','markerfacecolor',col_C57_cno,'markersize',8,'color',col_C57_cno)
errorbar(nanmean(data_dur_REM_C57_cno,1), stdError(data_dur_REM_C57_cno),'linestyle','-','LineWidth',2,'color',col_C57_cno)
plot(nanmean(data_dur_REM_CRH_Sal),'linestyle','-','LineWidth',2,'marker','^','markersize',8,'markerfacecolor',col_mCherry_cno,'color',col_mCherry_cno), hold on
errorbar(nanmean(data_dur_REM_CRH_Sal), stdError(data_dur_REM_CRH_Sal),'LineWidth',2,'color',col_mCherry_cno)
plot(nanmean(data_dur_REM_CRH_cno),'linestyle','-','LineWidth',2,'marker','o','markersize',8,'markerfacecolor',col_dreadd_cno,'color',col_dreadd_cno)
errorbar(nanmean(data_dur_REM_CRH_cno), stdError(data_dur_REM_CRH_cno),'LineWidth',2,'color',col_dreadd_cno)
xlim([0 8.5])
xticks([1 3 5 7 9]); xticklabels({'10','12','14','16','18'})
makepretty
title('REM bouts duration')
xlabel('Time of the day (h)')


