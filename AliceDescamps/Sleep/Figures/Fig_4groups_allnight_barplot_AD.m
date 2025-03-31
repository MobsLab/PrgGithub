%% To plot the figure you need to load data : 
Get_Data_5groups_AD.m

%% FIGURE 4 groups
txt_size = 15;
isparam=0;
iscorr=1;

%classic
col_1 = [.7 .7 .7];
col_2 = [1 .4 0];
col_3 = [1 0 0];
col_4 = [0 .4 .4];


% legend = {'1','2','3','4'};
legend = {'Sal mCherry (n=11)','SD + Sal mCherry (n=3)','SD + CNO mCherry (n=6)','SD + CNO DREADD- (n=7)'};


figure('color',[1 1 1])
% suptitle ('xxxxxxxxxxxxx')
suptitle ('Effect of SD and inhibition of CRH neurons')

subplot(4,7,[1],'align') %WAKE percentage phase1
hold on, title('0-8h')


figure('color',[1 1 1])
subplot(4,7,[1],'align') %WAKE percentage phase1
PlotErrorBarN_MC({...
    nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_3,2), nanmean(data_perc_WAKE_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
set(gca,'xticklabels',[])
ylabel('Wake percentage')
% makepretty
ylim([0 100])
title('0-8h')

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_1,2),nanmean(data_perc_WAKE_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_3,2), nanmean(data_perc_WAKE_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_WAKE_begin_1,2),nanmean(data_perc_WAKE_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_4,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_WAKE_begin_3,2), nanmean(data_perc_WAKE_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
PlotErrorBarN_MC({...
    nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_3,2), nanmean(data_perc_SWS_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
set(gca,'xticklabels',[])
ylabel('NREM percentage')
% makepretty
ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_1,2),nanmean(data_perc_SWS_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_3,2), nanmean(data_perc_SWS_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_SWS_begin_1,2),nanmean(data_perc_SWS_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_4,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_SWS_begin_3,2), nanmean(data_perc_SWS_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
PlotErrorBarN_MC({...
    nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_3,2), nanmean(data_num_SWS_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
xticks([1 2 3 4]); xticklabels(legend); xtickangle(50)
ylabel('NREM bouts number')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_begin_1,2),nanmean(data_num_SWS_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_begin_3,2), nanmean(data_num_SWS_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_num_SWS_begin_1,2),nanmean(data_num_SWS_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_4,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_num_SWS_begin_3,2), nanmean(data_num_SWS_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
PlotErrorBarN_MC({...
    nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_3,2), nanmean(data_dur_SWS_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
xticks([1 2 3 4]); xticklabels(legend); xtickangle(50)
ylabel('NREM bouts duration (s)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2),nanmean(data_dur_SWS_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_3,2), nanmean(data_dur_SWS_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_dur_SWS_begin_1,2),nanmean(data_dur_SWS_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_4,2));
    [~,p_1_vs_3_1] = ttest2(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_dur_SWS_begin_3,2), nanmean(data_dur_SWS_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
PlotErrorBarN_MC({...
    nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_3,2), nanmean(data_perc_REM_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
set(gca,'xticklabels',[])
ylabel('REM percentage')
% makepretty
ylim([0 10])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_begin_1,2),nanmean(data_perc_REM_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_begin_3,2), nanmean(data_perc_REM_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_REM_begin_1,2),nanmean(data_perc_REM_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_4,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_REM_begin_3,2), nanmean(data_perc_REM_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
PlotErrorBarN_MC({...
    nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_3,2), nanmean(data_num_REM_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
xticks([1 2 3 4]); xticklabels(legend); xtickangle(50)
ylabel('REM bouts number')
% makepretty
ylim([0 8])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_begin_1,2),nanmean(data_num_REM_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_begin_3,2), nanmean(data_num_REM_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_num_REM_begin_1,2),nanmean(data_num_REM_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_4,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_num_REM_begin_3,2), nanmean(data_num_REM_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
PlotErrorBarN_MC({...
    nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_3,2), nanmean(data_dur_REM_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
xticks([1 2 3 4]); xticklabels(legend); xtickangle(50)
ylabel('REM bouts duration (s)')
% makepretty
ylim([0 125])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2),nanmean(data_dur_REM_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_begin_3,2), nanmean(data_dur_REM_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_dur_REM_begin_1,2),nanmean(data_dur_REM_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_4,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_dur_REM_begin_3,2), nanmean(data_dur_REM_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
PlotErrorBarN_MC({...
    nanmean(data_durT_WAKE_begin_1,2), nanmean(data_durT_WAKE_begin_2,2), nanmean(data_durT_WAKE_begin_3,2), nanmean(data_durT_WAKE_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
xticks([1 2 3 4]); xticklabels(legend); xtickangle(50)
ylabel('Wake duration (min per 8h)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_durT_WAKE_begin_1,2), nanmean(data_durT_WAKE_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_durT_WAKE_begin_1,2),nanmean(data_durT_WAKE_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_durT_WAKE_begin_2,2), nanmean(data_durT_WAKE_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_durT_WAKE_begin_1,2), nanmean(data_durT_WAKE_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_durT_WAKE_begin_2,2), nanmean(data_durT_WAKE_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_durT_WAKE_begin_3,2), nanmean(data_durT_WAKE_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_durT_WAKE_begin_1,2), nanmean(data_durT_WAKE_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_durT_WAKE_begin_1,2),nanmean(data_durT_WAKE_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_durT_WAKE_begin_2,2), nanmean(data_durT_WAKE_begin_4,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_durT_WAKE_begin_1,2), nanmean(data_durT_WAKE_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_durT_WAKE_begin_2,2), nanmean(data_durT_WAKE_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_durT_WAKE_begin_3,2), nanmean(data_durT_WAKE_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
PlotErrorBarN_MC({...
    nanmean(data_durT_SWS_begin_1,2), nanmean(data_durT_SWS_begin_2,2), nanmean(data_durT_SWS_begin_3,2), nanmean(data_durT_SWS_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
xticks([1 2 3 4]); xticklabels(legend); xtickangle(50)
ylabel('NREMs duration (min per 8h)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_durT_SWS_begin_1,2), nanmean(data_durT_SWS_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_durT_SWS_begin_1,2),nanmean(data_durT_SWS_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_durT_SWS_begin_2,2), nanmean(data_durT_SWS_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_durT_SWS_begin_1,2), nanmean(data_durT_SWS_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_durT_SWS_begin_2,2), nanmean(data_durT_SWS_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_durT_SWS_begin_3,2), nanmean(data_durT_SWS_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_durT_SWS_begin_1,2), nanmean(data_durT_SWS_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_durT_SWS_begin_1,2),nanmean(data_durT_SWS_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_durT_SWS_begin_2,2), nanmean(data_durT_SWS_begin_4,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_durT_SWS_begin_1,2), nanmean(data_durT_SWS_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_durT_SWS_begin_2,2), nanmean(data_durT_SWS_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_durT_SWS_begin_3,2), nanmean(data_durT_SWS_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
PlotErrorBarN_MC({...
    nanmean(data_durT_REM_begin_1,2), nanmean(data_durT_REM_begin_2,2), nanmean(data_durT_REM_begin_3,2), nanmean(data_durT_REM_begin_4,2)},...
    'newfig',0,'paired',0,'showsigstar','none','x_data',[1:4],'barcolors',{col_1,col_2,col_3,col_4});
xticks([1 2 3 4]); xticklabels(legend); xtickangle(50)
ylabel('REMs duration (min per 8h)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_durT_REM_begin_1,2), nanmean(data_durT_REM_begin_2,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_durT_REM_begin_1,2),nanmean(data_durT_REM_begin_4,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_durT_REM_begin_2,2), nanmean(data_durT_REM_begin_4,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_durT_REM_begin_1,2), nanmean(data_durT_REM_begin_3,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_durT_REM_begin_2,2), nanmean(data_durT_REM_begin_3,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_durT_REM_begin_3,2), nanmean(data_durT_REM_begin_4,2));
elseif isparam==1 %%version ttest
        %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_durT_REM_begin_1,2), nanmean(data_durT_REM_begin_2,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_durT_REM_begin_1,2),nanmean(data_durT_REM_begin_4,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_durT_REM_begin_2,2), nanmean(data_durT_REM_begin_4,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_durT_REM_begin_1,2), nanmean(data_durT_REM_begin_3,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_durT_REM_begin_2,2), nanmean(data_durT_REM_begin_3,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_durT_REM_begin_3,2), nanmean(data_durT_REM_begin_4,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_4_1 p_2_vs_4_1 p_1_vs_3_1 p_2_vs_3_1 p_3_vs_4_1];
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
    
