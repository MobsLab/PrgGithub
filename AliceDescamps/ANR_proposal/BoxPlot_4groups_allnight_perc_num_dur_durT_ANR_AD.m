%% To plot the figure you need to load data : 
GetData_4groups_allnight_ANR_AD.m


%% FIGURE 2
txt_size = 15;

col_ctrl = [.7 .7 .7];
col_SD = [1 .4 0];
col_mCherry_cno = [1 .2 0];
col_dreadd_cno = [0 .4 .4];

legend = {'Sal','SD + Sal mCherry','SD + CNO mCherry','SD + CNO DREADD-'};

isparam=0;
iscorr=1;



figure('color',[1 1 1])
subplot(4,7,[1],'align') %WAKE percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_begin_ctrl,2), nanmean(data_perc_WAKE_begin_SD,2), nanmean(data_perc_WAKE_begin_SD_mCherry_cno,2), nanmean(data_perc_WAKE_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('Wake percentage')
% makepretty
ylim([0 100])
title('0-8h')

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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    

    

subplot(4,7,[2],'align') %NREM percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_begin_ctrl,2), nanmean(data_perc_SWS_begin_SD,2), nanmean(data_perc_SWS_begin_SD_mCherry_cno,2), nanmean(data_perc_SWS_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('NREM percentage')
% makepretty
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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,7,[3],'align') %SWS num phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
% set(gca,'xticklabels',[])
ylabel('NREM bouts number')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_SWS_begin_ctrl,2),nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_num_SWS_begin_SD_mCherry_cno,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_num_SWS_begin_ctrl,2),nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_num_SWS_begin_ctrl,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_num_SWS_begin_SD,2), nanmean(data_num_SWS_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_num_SWS_begin_SD_mCherry_cno,2), nanmean(data_num_SWS_begin_SD_dreadd_cno,2));
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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,7,[4],'align') %SWS dur phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
% set(gca,'xticklabels',[])
ylabel('NREM bouts duration (s)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_ctrl,2),nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_SD_mCherry_cno,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_SWS_begin_ctrl,2),nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_dur_SWS_begin_ctrl,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_dur_SWS_begin_SD,2), nanmean(data_dur_SWS_begin_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_dur_SWS_begin_SD_mCherry_cno,2), nanmean(data_dur_SWS_begin_SD_dreadd_cno,2));
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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end

subplot(4,7,[5],'align') %REM percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_begin_ctrl,2), nanmean(data_perc_REM_begin_SD,2), nanmean(data_perc_REM_begin_SD_mCherry_cno,2), nanmean(data_perc_REM_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('REM percentage')
% makepretty
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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end



subplot(4,7,[6],'align') %REM num phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_begin_ctrl,2), nanmean(data_num_REM_begin_SD,2), nanmean(data_num_REM_begin_SD_mCherry_cno,2), nanmean(data_num_REM_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
% set(gca,'xticklabels',[])
ylabel('REM bouts number')
% makepretty
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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,7,[7],'align') %REM dur phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_begin_ctrl,2), nanmean(data_dur_REM_begin_SD,2), nanmean(data_dur_REM_begin_SD_mCherry_cno,2), nanmean(data_dur_REM_begin_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
% set(gca,'xticklabels',[])
ylabel('REM bouts duration (s)')
% makepretty
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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end











subplot(4,7,[8],'align') %WAKE durT phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_durT_WAKE_ctrl,2), nanmean(data_durT_WAKE_SD,2), nanmean(data_durT_WAKE_SD_mCherry_cno,2), nanmean(data_durT_WAKE_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
% set(gca,'xticklabels',[])
ylabel('Wake duration (min per 8h)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_durT_WAKE_ctrl,2), nanmean(data_durT_WAKE_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_durT_WAKE_ctrl,2),nanmean(data_durT_WAKE_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_durT_WAKE_SD,2), nanmean(data_durT_WAKE_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_durT_WAKE_ctrl,2), nanmean(data_durT_WAKE_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_durT_WAKE_SD,2), nanmean(data_durT_WAKE_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_durT_WAKE_SD_mCherry_cno,2), nanmean(data_durT_WAKE_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_durT_WAKE_ctrl,2), nanmean(data_durT_WAKE_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_durT_WAKE_ctrl,2),nanmean(data_durT_WAKE_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_durT_WAKE_SD,2), nanmean(data_durT_WAKE_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_durT_WAKE_ctrl,2), nanmean(data_durT_WAKE_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_durT_WAKE_SD,2), nanmean(data_durT_WAKE_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_durT_WAKE_SD_mCherry_cno,2), nanmean(data_durT_WAKE_SD_dreadd_cno,2));
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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    



subplot(4,7,[9],'align') %NREM durT phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_durT_SWS_ctrl,2), nanmean(data_durT_SWS_SD,2), nanmean(data_durT_SWS_SD_mCherry_cno,2), nanmean(data_durT_SWS_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
% set(gca,'xticklabels',[])
ylabel('NREMs duration (min per 8h)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_durT_SWS_ctrl,2), nanmean(data_durT_SWS_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_durT_SWS_ctrl,2),nanmean(data_durT_SWS_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_durT_SWS_SD,2), nanmean(data_durT_SWS_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_durT_SWS_ctrl,2), nanmean(data_durT_SWS_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_durT_SWS_SD,2), nanmean(data_durT_SWS_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_durT_SWS_SD_mCherry_cno,2), nanmean(data_durT_SWS_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_durT_SWS_ctrl,2), nanmean(data_durT_SWS_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_durT_SWS_ctrl,2),nanmean(data_durT_SWS_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_durT_SWS_SD,2), nanmean(data_durT_SWS_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_durT_SWS_ctrl,2), nanmean(data_durT_SWS_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_durT_SWS_SD,2), nanmean(data_durT_SWS_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_durT_SWS_SD_mCherry_cno,2), nanmean(data_durT_SWS_SD_dreadd_cno,2));
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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,7,[12],'align') %REM durT phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_durT_REM_ctrl,2), nanmean(data_durT_REM_SD,2), nanmean(data_durT_REM_SD_mCherry_cno,2), nanmean(data_durT_REM_SD_dreadd_cno,2)},...
    {col_ctrl,col_SD,col_mCherry_cno,col_dreadd_cno},[1:4],legend,'paired',0,'showsigstar','none')
% set(gca,'xticklabels',[])
ylabel('REMs duration (min per 8h)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_ctrl_vs_SD_1, h_1] = ranksum(nanmean(data_durT_REM_ctrl,2), nanmean(data_durT_REM_SD,2));
    [p_ctrl_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_durT_REM_ctrl,2),nanmean(data_durT_REM_SD_dreadd_cno,2));
    [p_SD_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_durT_REM_SD,2), nanmean(data_durT_REM_SD_dreadd_cno,2));
    [p_ctrl_vs_mCherrry_cno_1, h_1] = ranksum(nanmean(data_durT_REM_ctrl,2), nanmean(data_durT_REM_SD_mCherry_cno,2));
    [p_SD_vs_mCherry_cno_1, h_1] = ranksum(nanmean(data_durT_REM_SD,2), nanmean(data_durT_REM_SD_mCherry_cno,2));
    [p_mCherry_cno_vs_dreadd_cno_1, h_1] = ranksum(nanmean(data_durT_REM_SD_mCherry_cno,2), nanmean(data_durT_REM_SD_dreadd_cno,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_ctrl_vs_SD_1] = ttest2(nanmean(data_durT_REM_ctrl,2), nanmean(data_durT_REM_SD,2));
    [h_1,p_ctrl_vs_dreadd_cno_1] = ttest2(nanmean(data_durT_REM_ctrl,2),nanmean(data_durT_REM_SD_dreadd_cno,2));
    [h_1,p_SD_vs_dreadd_cno_1] = ttest2(nanmean(data_durT_REM_SD,2), nanmean(data_durT_REM_SD_dreadd_cno,2));
    [h_1,p_ctrl_vs_mCherrry_cno_1] = ttest2(nanmean(data_durT_REM_ctrl,2), nanmean(data_durT_REM_SD_mCherry_cno,2));
    [h_1,p_SD_vs_mCherry_cno_1] = ttest2(nanmean(data_durT_REM_SD,2), nanmean(data_durT_REM_SD_mCherry_cno,2));
    [h_1,p_mCherry_cno_vs_dreadd_cno_1] = ttest2(nanmean(data_durT_REM_SD_mCherry_cno,2), nanmean(data_durT_REM_SD_dreadd_cno,2));
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
    if adj_p(2)<0.05; sigstar_MC({[1 4]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[2 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 3]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[3 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
else
end
    
