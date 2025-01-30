%% To plot the figure you need to load data : 
Get_Data_5groups_AD.m

%% FIGURE 5 groups
txt_size = 15;
isparam=0;
iscorr=1;

%classic
% col_1 = [.7 .7 .7];
% col_2 = [.5 .5 .5];
% col_3 = [1 .4 0];
% col_4 = [1 .2 0];
% col_5 = [0 .4 .4];

%classic
col_1 = [.7 .7 .7];
col_2 = [1 .4 0];
col_3 = [0 .4 .6];
col_4 = [1 .2 0];
col_5 = [0 .2 .6];

% legend = {'1','2','3','4','5'};
legend = {'Sal mCherry (n=11)','SD1 + Sal mCherry (n=3)','SD2 + Sal mCherry (n=4)','SD1 + CNO mCherry (n=6)','SD2 + CNO mCherry (n=2)'};


figure('color',[1 1 1])
% suptitle ('xxxxxxxxxxxxx')
suptitle ('Comparison 1st/2nd SD in Sal/CNO conditions for mCherry mice')

subplot(4,7,[1],'align') %WAKE percentage phase1
hold on, title('0-2h30')
subplot(4,7,[8],'align') %WAKE percentage phase2
hold on, title('2h30-5h')
subplot(4,7,[15],'align') %WAKE percentage phase3
hold on, title('5h-8h')


subplot(4,7,[1],'align') %WAKE percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_3,2), nanmean(data_perc_WAKE_begin_4,2), nanmean(data_perc_WAKE_begin_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('Wake percentage')
% makepretty
ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_3,2), nanmean(data_perc_WAKE_begin_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_3,2), nanmean(data_perc_WAKE_begin_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_4,2), nanmean(data_perc_WAKE_begin_5,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_perc_WAKE_begin_1,2), nanmean(data_perc_WAKE_begin_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_perc_WAKE_begin_2,2), nanmean(data_perc_WAKE_begin_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_WAKE_begin_3,2), nanmean(data_perc_WAKE_begin_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_perc_WAKE_begin_3,2), nanmean(data_perc_WAKE_begin_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_perc_WAKE_begin_4,2), nanmean(data_perc_WAKE_begin_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    

    

subplot(4,7,[2],'align') %NREM percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_3,2), nanmean(data_perc_SWS_begin_4,2), nanmean(data_perc_SWS_begin_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none')
set(gca,'xticklabels',[])
ylabel('NREM percentage')
% makepretty
ylim([0 100])
if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_3,2), nanmean(data_perc_SWS_begin_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_3,2), nanmean(data_perc_SWS_begin_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_4,2), nanmean(data_perc_SWS_begin_5,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_perc_SWS_begin_1,2), nanmean(data_perc_SWS_begin_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_perc_SWS_begin_2,2), nanmean(data_perc_SWS_begin_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_SWS_begin_3,2), nanmean(data_perc_SWS_begin_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_perc_SWS_begin_3,2), nanmean(data_perc_SWS_begin_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_perc_SWS_begin_4,2), nanmean(data_perc_SWS_begin_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    
subplot(4,7,[3],'align') %SWS num phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_3,2), nanmean(data_num_SWS_begin_4,2), nanmean(data_num_SWS_begin_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('NREM bouts number')
% makepretty
if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_begin_3,2), nanmean(data_num_SWS_begin_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_begin_3,2), nanmean(data_num_SWS_begin_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_begin_4,2), nanmean(data_num_SWS_begin_5,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_num_SWS_begin_1,2), nanmean(data_num_SWS_begin_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_num_SWS_begin_2,2), nanmean(data_num_SWS_begin_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_num_SWS_begin_3,2), nanmean(data_num_SWS_begin_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_num_SWS_begin_3,2), nanmean(data_num_SWS_begin_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_num_SWS_begin_4,2), nanmean(data_num_SWS_begin_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,7,[4],'align') %SWS dur phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_3,2), nanmean(data_dur_SWS_begin_4,2), nanmean(data_dur_SWS_begin_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('NREM bouts duration (s)')
% makepretty
if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_3,2), nanmean(data_dur_SWS_begin_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_3,2), nanmean(data_dur_SWS_begin_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_4,2), nanmean(data_dur_SWS_begin_5,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_dur_SWS_begin_1,2), nanmean(data_dur_SWS_begin_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_dur_SWS_begin_2,2), nanmean(data_dur_SWS_begin_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_dur_SWS_begin_3,2), nanmean(data_dur_SWS_begin_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_dur_SWS_begin_3,2), nanmean(data_dur_SWS_begin_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_dur_SWS_begin_4,2), nanmean(data_dur_SWS_begin_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,7,[5],'align') %REM percentage phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_3,2), nanmean(data_perc_REM_begin_4,2), nanmean(data_perc_REM_begin_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('REM percentage')
% makepretty
ylim([0 10])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_begin_3,2), nanmean(data_perc_REM_begin_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_begin_3,2), nanmean(data_perc_REM_begin_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_begin_4,2), nanmean(data_perc_REM_begin_5,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_perc_REM_begin_1,2), nanmean(data_perc_REM_begin_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_perc_REM_begin_2,2), nanmean(data_perc_REM_begin_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_REM_begin_3,2), nanmean(data_perc_REM_begin_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_perc_REM_begin_3,2), nanmean(data_perc_REM_begin_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_perc_REM_begin_4,2), nanmean(data_perc_REM_begin_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,7,[6],'align') %REM num phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_3,2), nanmean(data_num_REM_begin_4,2), nanmean(data_num_REM_begin_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('REM bouts number')
% makepretty
ylim([0 8])

if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_begin_3,2), nanmean(data_num_REM_begin_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_begin_3,2), nanmean(data_num_REM_begin_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_begin_4,2), nanmean(data_num_REM_begin_5,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_num_REM_begin_1,2), nanmean(data_num_REM_begin_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_num_REM_begin_2,2), nanmean(data_num_REM_begin_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_num_REM_begin_3,2), nanmean(data_num_REM_begin_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_num_REM_begin_3,2), nanmean(data_num_REM_begin_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_num_REM_begin_4,2), nanmean(data_num_REM_begin_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,7,[7],'align') %REM dur phase1
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_3,2), nanmean(data_dur_REM_begin_4,2), nanmean(data_dur_REM_begin_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('REM bouts duration (s)')
% makepretty
ylim([0 125])
if isparam==0 %%version ranksum (non param)
    %phase1
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_begin_3,2), nanmean(data_dur_REM_begin_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_begin_3,2), nanmean(data_dur_REM_begin_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_begin_4,2), nanmean(data_dur_REM_begin_5,2));
elseif isparam==1 %%version ttest
    %phase1
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_dur_REM_begin_1,2), nanmean(data_dur_REM_begin_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_dur_REM_begin_2,2), nanmean(data_dur_REM_begin_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_dur_REM_begin_3,2), nanmean(data_dur_REM_begin_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_dur_REM_begin_3,2), nanmean(data_dur_REM_begin_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_dur_REM_begin_4,2), nanmean(data_dur_REM_begin_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase1
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    










subplot(4,7,[8],'align') %WAKE percentage phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_WAKE_interPeriod_1,2), nanmean(data_perc_WAKE_interPeriod_2,2), nanmean(data_perc_WAKE_interPeriod_3,2), nanmean(data_perc_WAKE_interPeriod_4,2), nanmean(data_perc_WAKE_interPeriod_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('Wake percentage')
% makepretty
ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_1,2), nanmean(data_perc_WAKE_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_1,2), nanmean(data_perc_WAKE_interPeriod_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_1,2), nanmean(data_perc_WAKE_interPeriod_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_1,2), nanmean(data_perc_WAKE_interPeriod_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_2,2), nanmean(data_perc_WAKE_interPeriod_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_2,2), nanmean(data_perc_WAKE_interPeriod_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_2,2), nanmean(data_perc_WAKE_interPeriod_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_3,2), nanmean(data_perc_WAKE_interPeriod_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_3,2), nanmean(data_perc_WAKE_interPeriod_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_interPeriod_4,2), nanmean(data_perc_WAKE_interPeriod_5,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_WAKE_interPeriod_1,2), nanmean(data_perc_WAKE_interPeriod_2,2));
    [h_1,p_1_vs_3_] = ttest2(nanmean(data_perc_WAKE_interPeriod_1,2), nanmean(data_perc_WAKE_interPeriod_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_WAKE_interPeriod_1,2), nanmean(data_perc_WAKE_interPeriod_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_perc_WAKE_interPeriod_1,2), nanmean(data_perc_WAKE_interPeriod_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_WAKE_interPeriod_2,2), nanmean(data_perc_WAKE_interPeriod_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_WAKE_interPeriod_2,2), nanmean(data_perc_WAKE_interPeriod_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_perc_WAKE_interPeriod_2,2), nanmean(data_perc_WAKE_interPeriod_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_WAKE_interPeriod_3,2), nanmean(data_perc_WAKE_interPeriod_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_perc_WAKE_interPeriod_3,2), nanmean(data_perc_WAKE_interPeriod_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_perc_WAKE_interPeriod_4,2), nanmean(data_perc_WAKE_interPeriod_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    

    

subplot(4,7,[9],'align') %NREM percentage phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_SWS_interPeriod_1,2), nanmean(data_perc_SWS_interPeriod_2,2), nanmean(data_perc_SWS_interPeriod_3,2), nanmean(data_perc_SWS_interPeriod_4,2), nanmean(data_perc_SWS_interPeriod_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('NREM percentage')
% makepretty
ylim([0 100])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_1,2), nanmean(data_perc_SWS_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_1,2), nanmean(data_perc_SWS_interPeriod_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_1,2), nanmean(data_perc_SWS_interPeriod_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_1,2), nanmean(data_perc_SWS_interPeriod_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_2,2), nanmean(data_perc_SWS_interPeriod_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_2,2), nanmean(data_perc_SWS_interPeriod_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_2,2), nanmean(data_perc_SWS_interPeriod_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_3,2), nanmean(data_perc_SWS_interPeriod_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_3,2), nanmean(data_perc_SWS_interPeriod_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_interPeriod_4,2), nanmean(data_perc_SWS_interPeriod_5,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_SWS_interPeriod_1,2), nanmean(data_perc_SWS_interPeriod_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_SWS_interPeriod_1,2), nanmean(data_perc_SWS_interPeriod_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_SWS_interPeriod_1,2), nanmean(data_perc_SWS_interPeriod_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_perc_SWS_interPeriod_1,2), nanmean(data_perc_SWS_interPeriod_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_SWS_interPeriod_2,2), nanmean(data_perc_SWS_interPeriod_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_SWS_interPeriod_2,2), nanmean(data_perc_SWS_interPeriod_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_perc_SWS_interPeriod_2,2), nanmean(data_perc_SWS_interPeriod_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_SWS_interPeriod_3,2), nanmean(data_perc_SWS_interPeriod_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_perc_SWS_interPeriod_3,2), nanmean(data_perc_SWS_interPeriod_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_perc_SWS_interPeriod_4,2), nanmean(data_perc_SWS_interPeriod_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    
    


subplot(4,7,[10],'align') %SWS num phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_SWS_interPeriod_1,2), nanmean(data_num_SWS_interPeriod_2,2), nanmean(data_num_SWS_interPeriod_3,2), nanmean(data_num_SWS_interPeriod_4,2), nanmean(data_num_SWS_interPeriod_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('NREM bouts number')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_1,2), nanmean(data_num_SWS_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_1,2), nanmean(data_num_SWS_interPeriod_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_1,2), nanmean(data_num_SWS_interPeriod_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_1,2), nanmean(data_num_SWS_interPeriod_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_2,2), nanmean(data_num_SWS_interPeriod_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_2,2), nanmean(data_num_SWS_interPeriod_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_2,2), nanmean(data_num_SWS_interPeriod_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_3,2), nanmean(data_num_SWS_interPeriod_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_3,2), nanmean(data_num_SWS_interPeriod_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_interPeriod_4,2), nanmean(data_num_SWS_interPeriod_5,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_num_SWS_interPeriod_1,2), nanmean(data_num_SWS_interPeriod_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_num_SWS_interPeriod_1,2), nanmean(data_num_SWS_interPeriod_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_num_SWS_interPeriod_1,2), nanmean(data_num_SWS_interPeriod_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_num_SWS_interPeriod_1,2), nanmean(data_num_SWS_interPeriod_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_num_SWS_interPeriod_2,2), nanmean(data_num_SWS_interPeriod_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_num_SWS_interPeriod_2,2), nanmean(data_num_SWS_interPeriod_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_num_SWS_interPeriod_2,2), nanmean(data_num_SWS_interPeriod_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_num_SWS_interPeriod_3,2), nanmean(data_num_SWS_interPeriod_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_num_SWS_interPeriod_3,2), nanmean(data_num_SWS_interPeriod_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_num_SWS_interPeriod_4,2), nanmean(data_num_SWS_interPeriod_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    
    


subplot(4,7,[11],'align') %SWS dur phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_3,2), nanmean(data_dur_SWS_interPeriod_4,2), nanmean(data_dur_SWS_interPeriod_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('NREM bouts duration (s)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_3,2), nanmean(data_dur_SWS_interPeriod_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_3,2), nanmean(data_dur_SWS_interPeriod_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_interPeriod_4,2), nanmean(data_dur_SWS_interPeriod_5,2));
elseif isparam==1 %version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_dur_SWS_interPeriod_1,2), nanmean(data_dur_SWS_interPeriod_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_dur_SWS_interPeriod_2,2), nanmean(data_dur_SWS_interPeriod_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_dur_SWS_interPeriod_3,2), nanmean(data_dur_SWS_interPeriod_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_dur_SWS_interPeriod_3,2), nanmean(data_dur_SWS_interPeriod_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_dur_SWS_interPeriod_4,2), nanmean(data_dur_SWS_interPeriod_5,2));
else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase1
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    
    

subplot(4,7,[12],'align') %REM percentage phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_perc_REM_interPeriod_1,2), nanmean(data_perc_REM_interPeriod_2,2), nanmean(data_perc_REM_interPeriod_3,2), nanmean(data_perc_REM_interPeriod_4,2), nanmean(data_perc_REM_interPeriod_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('REM percentage')
% makepretty
ylim([0 10])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_1,2), nanmean(data_perc_REM_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_1,2), nanmean(data_perc_REM_interPeriod_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_1,2), nanmean(data_perc_REM_interPeriod_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_1,2), nanmean(data_perc_REM_interPeriod_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_2,2), nanmean(data_perc_REM_interPeriod_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_2,2), nanmean(data_perc_REM_interPeriod_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_2,2), nanmean(data_perc_REM_interPeriod_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_3,2), nanmean(data_perc_REM_interPeriod_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_3,2), nanmean(data_perc_REM_interPeriod_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_interPeriod_4,2), nanmean(data_perc_REM_interPeriod_5,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_REM_interPeriod_1,2), nanmean(data_perc_REM_interPeriod_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_REM_interPeriod_1,2), nanmean(data_perc_REM_interPeriod_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_REM_interPeriod_1,2), nanmean(data_perc_REM_interPeriod_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_perc_REM_interPeriod_1,2), nanmean(data_perc_REM_interPeriod_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_REM_interPeriod_2,2), nanmean(data_perc_REM_interPeriod_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_REM_interPeriod_2,2), nanmean(data_perc_REM_interPeriod_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_perc_REM_interPeriod_2,2), nanmean(data_perc_REM_interPeriod_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_REM_interPeriod_3,2), nanmean(data_perc_REM_interPeriod_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_perc_REM_interPeriod_3,2), nanmean(data_perc_REM_interPeriod_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_perc_REM_interPeriod_4,2), nanmean(data_perc_REM_interPeriod_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,7,[13],'align') %REM num phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_num_REM_interPeriod_1,2), nanmean(data_num_REM_interPeriod_2,2), nanmean(data_num_REM_interPeriod_3,2), nanmean(data_num_REM_interPeriod_4,2), nanmean(data_num_REM_interPeriod_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('REM bouts number')
% makepretty
% ylim([0 70])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_1,2), nanmean(data_num_REM_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_1,2), nanmean(data_num_REM_interPeriod_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_1,2), nanmean(data_num_REM_interPeriod_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_1,2), nanmean(data_num_REM_interPeriod_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_2,2), nanmean(data_num_REM_interPeriod_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_2,2), nanmean(data_num_REM_interPeriod_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_2,2), nanmean(data_num_REM_interPeriod_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_3,2), nanmean(data_num_REM_interPeriod_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_3,2), nanmean(data_num_REM_interPeriod_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_interPeriod_4,2), nanmean(data_num_REM_interPeriod_5,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_num_REM_interPeriod_1,2), nanmean(data_num_REM_interPeriod_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_num_REM_interPeriod_1,2), nanmean(data_num_REM_interPeriod_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_num_REM_interPeriod_1,2), nanmean(data_num_REM_interPeriod_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_num_REM_interPeriod_1,2), nanmean(data_num_REM_interPeriod_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_num_REM_interPeriod_2,2), nanmean(data_num_REM_interPeriod_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_num_REM_interPeriod_2,2), nanmean(data_num_REM_interPeriod_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_num_REM_interPeriod_2,2), nanmean(data_num_REM_interPeriod_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_num_REM_interPeriod_3,2), nanmean(data_num_REM_interPeriod_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_num_REM_interPeriod_3,2), nanmean(data_num_REM_interPeriod_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_num_REM_interPeriod_4,2), nanmean(data_num_REM_interPeriod_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,7,[14],'align') %REM dur phase2
MakeSpreadAndBoxPlot2_MC({...
    nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_3,2), nanmean(data_dur_REM_interPeriod_4,2), nanmean(data_dur_REM_interPeriod_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
set(gca,'xticklabels',[])
ylabel('REM bouts duration (s)')
% makepretty
ylim([0 200])

if isparam==0 %%version ranksum (non param)
    %phase2
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_3,2), nanmean(data_dur_REM_interPeriod_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_3,2), nanmean(data_dur_REM_interPeriod_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_interPeriod_4,2), nanmean(data_dur_REM_interPeriod_5,2));
elseif isparam==1 %%version ttest
    %phase2
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_dur_REM_interPeriod_1,2), nanmean(data_dur_REM_interPeriod_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_dur_REM_interPeriod_2,2), nanmean(data_dur_REM_interPeriod_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_dur_REM_interPeriod_3,2), nanmean(data_dur_REM_interPeriod_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_dur_REM_interPeriod_3,2), nanmean(data_dur_REM_interPeriod_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_dur_REM_interPeriod_4,2), nanmean(data_dur_REM_interPeriod_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase2
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase2
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    






subplot(4,7,[15],'align') %WAKE percentage phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_WAKE_end_1,2), nanmean(data_perc_WAKE_end_2,2), nanmean(data_perc_WAKE_end_3,2), nanmean(data_perc_WAKE_end_4,2), nanmean(data_perc_WAKE_end_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('Wake percentage')
% makepretty
ylim([0 50])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_1,2), nanmean(data_perc_WAKE_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_1,2), nanmean(data_perc_WAKE_end_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_1,2), nanmean(data_perc_WAKE_end_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_1,2), nanmean(data_perc_WAKE_end_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_2,2), nanmean(data_perc_WAKE_end_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_2,2), nanmean(data_perc_WAKE_end_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_2,2), nanmean(data_perc_WAKE_end_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_3,2), nanmean(data_perc_WAKE_end_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_3,2), nanmean(data_perc_WAKE_end_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_perc_WAKE_end_4,2), nanmean(data_perc_WAKE_end_5,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_WAKE_end_1,2), nanmean(data_perc_WAKE_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_WAKE_end_1,2), nanmean(data_perc_WAKE_end_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_WAKE_end_1,2), nanmean(data_perc_WAKE_end_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_perc_WAKE_end_1,2), nanmean(data_perc_WAKE_end_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_WAKE_end_2,2), nanmean(data_perc_WAKE_end_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_WAKE_end_2,2), nanmean(data_perc_WAKE_end_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_perc_WAKE_end_2,2), nanmean(data_perc_WAKE_end_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_WAKE_end_3,2), nanmean(data_perc_WAKE_end_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_perc_WAKE_end_3,2), nanmean(data_perc_WAKE_end_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_perc_WAKE_end_4,2), nanmean(data_perc_WAKE_end_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    





subplot(4,7,[16],'align') %NREM percentage phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_SWS_end_1,2), nanmean(data_perc_SWS_end_2,2), nanmean(data_perc_SWS_end_3,2), nanmean(data_perc_SWS_end_4,2), nanmean(data_perc_SWS_end_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('NREM percentage')
% makepretty
ylim([0 80])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_SWS_end_1,2), nanmean(data_perc_SWS_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_SWS_end_1,2), nanmean(data_perc_SWS_end_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_end_1,2), nanmean(data_perc_SWS_end_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_end_1,2), nanmean(data_perc_SWS_end_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_SWS_end_2,2), nanmean(data_perc_SWS_end_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_end_2,2), nanmean(data_perc_SWS_end_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_end_2,2), nanmean(data_perc_SWS_end_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_SWS_end_3,2), nanmean(data_perc_SWS_end_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_end_3,2), nanmean(data_perc_SWS_end_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_perc_SWS_end_4,2), nanmean(data_perc_SWS_end_5,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_SWS_end_1,2), nanmean(data_perc_SWS_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_SWS_end_1,2), nanmean(data_perc_SWS_end_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_SWS_end_1,2), nanmean(data_perc_SWS_end_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_perc_SWS_end_1,2), nanmean(data_perc_SWS_end_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_SWS_end_2,2), nanmean(data_perc_SWS_end_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_SWS_end_2,2), nanmean(data_perc_SWS_end_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_perc_SWS_end_2,2), nanmean(data_perc_SWS_end_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_SWS_end_3,2), nanmean(data_perc_SWS_end_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_perc_SWS_end_3,2), nanmean(data_perc_SWS_end_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_perc_SWS_end_4,2), nanmean(data_perc_SWS_end_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,7,[17],'align') %SWS num phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_num_SWS_end_1,2), nanmean(data_num_SWS_end_2,2), nanmean(data_num_SWS_end_3,2), nanmean(data_num_SWS_end_4,2), nanmean(data_num_SWS_end_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('NREM bouts number')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_num_SWS_end_1,2), nanmean(data_num_SWS_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_num_SWS_end_1,2), nanmean(data_num_SWS_end_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_end_1,2), nanmean(data_num_SWS_end_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_end_1,2), nanmean(data_num_SWS_end_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_num_SWS_end_2,2), nanmean(data_num_SWS_end_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_end_2,2), nanmean(data_num_SWS_end_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_end_2,2), nanmean(data_num_SWS_end_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_num_SWS_end_3,2), nanmean(data_num_SWS_end_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_end_3,2), nanmean(data_num_SWS_end_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_num_SWS_end_4,2), nanmean(data_num_SWS_end_5,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_num_SWS_end_1,2), nanmean(data_num_SWS_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_num_SWS_end_1,2), nanmean(data_num_SWS_end_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_num_SWS_end_1,2), nanmean(data_num_SWS_end_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_num_SWS_end_1,2), nanmean(data_num_SWS_end_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_num_SWS_end_2,2), nanmean(data_num_SWS_end_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_num_SWS_end_2,2), nanmean(data_num_SWS_end_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_num_SWS_end_2,2), nanmean(data_num_SWS_end_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_num_SWS_end_3,2), nanmean(data_num_SWS_end_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_num_SWS_end_3,2), nanmean(data_num_SWS_end_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_num_SWS_end_4,2), nanmean(data_num_SWS_end_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,7,[18],'align') %SWS dur phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_3,2), nanmean(data_dur_SWS_end_4,2), nanmean(data_dur_SWS_end_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('NREM bouts duration (s)')
% makepretty

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_dur_SWS_end_3,2), nanmean(data_dur_SWS_end_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_end_3,2), nanmean(data_dur_SWS_end_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_dur_SWS_end_4,2), nanmean(data_dur_SWS_end_5,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_dur_SWS_end_1,2), nanmean(data_dur_SWS_end_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_dur_SWS_end_2,2), nanmean(data_dur_SWS_end_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_dur_SWS_end_3,2), nanmean(data_dur_SWS_end_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_dur_SWS_end_3,2), nanmean(data_dur_SWS_end_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_dur_SWS_end_4,2), nanmean(data_dur_SWS_end_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,7,[19],'align') %REM percentage phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_REM_end_1,2), nanmean(data_perc_REM_end_2,2), nanmean(data_perc_REM_end_3,2), nanmean(data_perc_REM_end_4,2), nanmean(data_perc_REM_end_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('REM percentage')
% makepretty
ylim([0 15])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_perc_REM_end_1,2), nanmean(data_perc_REM_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_perc_REM_end_1,2), nanmean(data_perc_REM_end_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_end_1,2), nanmean(data_perc_REM_end_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_end_1,2), nanmean(data_perc_REM_end_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_perc_REM_end_2,2), nanmean(data_perc_REM_end_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_end_2,2), nanmean(data_perc_REM_end_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_end_2,2), nanmean(data_perc_REM_end_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_perc_REM_end_3,2), nanmean(data_perc_REM_end_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_end_3,2), nanmean(data_perc_REM_end_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_perc_REM_end_4,2), nanmean(data_perc_REM_end_5,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_perc_REM_end_1,2), nanmean(data_perc_REM_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_perc_REM_end_1,2), nanmean(data_perc_REM_end_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_perc_REM_end_1,2), nanmean(data_perc_REM_end_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_perc_REM_end_1,2), nanmean(data_perc_REM_end_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_perc_REM_end_2,2), nanmean(data_perc_REM_end_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_perc_REM_end_2,2), nanmean(data_perc_REM_end_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_perc_REM_end_2,2), nanmean(data_perc_REM_end_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_perc_REM_end_3,2), nanmean(data_perc_REM_end_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_perc_REM_end_3,2), nanmean(data_perc_REM_end_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_perc_REM_end_4,2), nanmean(data_perc_REM_end_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_2, crit_p_2, adj_ci_cvrg_2, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    

subplot(4,7,[20],'align') %REM num phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_num_REM_end_1,2), nanmean(data_num_REM_end_2,2), nanmean(data_num_REM_end_3,2), nanmean(data_num_REM_end_4,2), nanmean(data_num_REM_end_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('REM bouts number')
% makepretty
ylim([0 60])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_num_REM_end_1,2), nanmean(data_num_REM_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_num_REM_end_1,2), nanmean(data_num_REM_end_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_end_1,2), nanmean(data_num_REM_end_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_end_1,2), nanmean(data_num_REM_end_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_num_REM_end_2,2), nanmean(data_num_REM_end_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_end_2,2), nanmean(data_num_REM_end_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_end_2,2), nanmean(data_num_REM_end_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_num_REM_end_3,2), nanmean(data_num_REM_end_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_end_3,2), nanmean(data_num_REM_end_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_num_REM_end_4,2), nanmean(data_num_REM_end_5,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_num_REM_end_1,2), nanmean(data_num_REM_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_num_REM_end_1,2), nanmean(data_num_REM_end_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_num_REM_end_1,2), nanmean(data_num_REM_end_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_num_REM_end_1,2), nanmean(data_num_REM_end_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_num_REM_end_2,2), nanmean(data_num_REM_end_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_num_REM_end_2,2), nanmean(data_num_REM_end_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_num_REM_end_2,2), nanmean(data_num_REM_end_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_num_REM_end_3,2), nanmean(data_num_REM_end_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_num_REM_end_3,2), nanmean(data_num_REM_end_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_num_REM_end_4,2), nanmean(data_num_REM_end_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    


subplot(4,7,[21],'align') %REM dur phase3

MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_3,2), nanmean(data_dur_REM_end_4,2), nanmean(data_dur_REM_end_5,2)},...
    {col_1,col_2,col_3,col_4,col_5},[1:5],legend,'paired',0,'showsigstar','none') 
% set(gca,'xticklabels',[])
ylabel('REM bouts duration (s)')
% makepretty
ylim([0 110])

if isparam==0 %%version ranksum (non param)
    %phase3
    [p_1_vs_2_1, h_1] = ranksum(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_2,2));
    [p_1_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_3,2));
    [p_1_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_4,2));
    [p_1_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_5,2));
    [p_2_vs_3_1, h_1] = ranksum(nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_3,2));
    [p_2_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_4,2));
    [p_2_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_5,2));
    [p_3_vs_4_1, h_1] = ranksum(nanmean(data_dur_REM_end_3,2), nanmean(data_dur_REM_end_4,2));
    [p_3_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_end_3,2), nanmean(data_dur_REM_end_5,2));
    [p_4_vs_5_1, h_1] = ranksum(nanmean(data_dur_REM_end_4,2), nanmean(data_dur_REM_end_5,2));
elseif isparam==1 %%version ttest
    %phase3
    [h_1,p_1_vs_2_1] = ttest2(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_2,2));
    [h_1,p_1_vs_3_1] = ttest2(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_3,2));
    [h_1,p_1_vs_4_1] = ttest2(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_4,2));
    [h_1,p_1_vs_5_1] = ttest2(nanmean(data_dur_REM_end_1,2), nanmean(data_dur_REM_end_5,2));
    [h_1,p_2_vs_3_1] = ttest2(nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_3,2));
    [h_1,p_2_vs_4_1] = ttest2(nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_4,2));
    [h_1,p_2_vs_5_1] = ttest2(nanmean(data_dur_REM_end_2,2), nanmean(data_dur_REM_end_5,2));
    [h_1,p_3_vs_4_1] = ttest2(nanmean(data_dur_REM_end_3,2), nanmean(data_dur_REM_end_4,2));
    [h_1,p_3_vs_5_1] = ttest2(nanmean(data_dur_REM_end_3,2), nanmean(data_dur_REM_end_5,2));
    [h_1,p_4_vs_5_1] = ttest2(nanmean(data_dur_REM_end_4,2), nanmean(data_dur_REM_end_5,2));
    else
end
%%add corrections for multiple comparisons
if iscorr==0
    %phase3
    if p_1_vs_2_2<0.05; sigstar_MC({[1 2]},p_1_vs_2_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_3_2<0.05; sigstar_MC({[1 3]},p_1_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_4_2<0.05; sigstar_MC({[1 4]},p_1_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_1_vs_5_2<0.05; sigstar_MC({[1 5]},p_1_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_3_2<0.05; sigstar_MC({[2 3]},p_2_vs_3_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_4_2<0.05; sigstar_MC({[2 4]},p_2_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_2_vs_5_2<0.05; sigstar_MC({[2 5]},p_2_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_4_2<0.05; sigstar_MC({[3 4]},p_3_vs_4_2,0,'LineWigth',16,'StarSize',24);end
    if p_3_vs_5_2<0.05; sigstar_MC({[3 5]},p_3_vs_5_2,0,'LineWigth',16,'StarSize',24);end
    if p_4_vs_5_2<0.05; sigstar_MC({[4 5]},p_4_vs_5_2,0,'LineWigth',16,'StarSize',24);end
elseif iscorr==1
    p_values = [p_1_vs_2_1 p_1_vs_3_1 p_1_vs_4_1 p_1_vs_5_1 p_2_vs_3_1 p_2_vs_4_1 p_2_vs_5_1 p_3_vs_4_1 p_3_vs_5_1 p_4_vs_5_1];
    [h_1, crit_p_1, adj_ci_cvrg_1, adj_p] = fdr_bh(p_values);
    %phase3
    if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
    if adj_p(2)<0.05; sigstar_MC({[1 3]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
    if adj_p(3)<0.05; sigstar_MC({[1 4]},adj_p(3),0,'LineWigth',16,'StarSize',24);end
    if adj_p(4)<0.05; sigstar_MC({[1 5]},adj_p(4),0,'LineWigth',16,'StarSize',24);end
    if adj_p(5)<0.05; sigstar_MC({[2 3]},adj_p(5),0,'LineWigth',16,'StarSize',24);end
    if adj_p(6)<0.05; sigstar_MC({[2 4]},adj_p(6),0,'LineWigth',16,'StarSize',24);end
    if adj_p(7)<0.05; sigstar_MC({[2 5]},adj_p(7),0,'LineWigth',16,'StarSize',24);end
    if adj_p(8)<0.05; sigstar_MC({[3 4]},adj_p(8),0,'LineWigth',16,'StarSize',24);end
    if adj_p(9)<0.05; sigstar_MC({[3 5]},adj_p(9),0,'LineWigth',16,'StarSize',24);end
    if adj_p(10)<0.05; sigstar_MC({[4 5]},adj_p(10),0,'LineWigth',16,'StarSize',24);end
else
end
    