%% To plot the figure you need to load data : 
Get_sleep_data_basal_conditions_MC


isparam=0;
iscorr=1;
ispaired=0;

col_saline = [.8 .8 .8]; %gray
col_cno = [0 .4 .4]; %dark green

col_cno = [.3 .3 .3]; 

% col_cno = [0 .6 .4]; %PFC inhib (light green)


%% FIGURE SUPPL 2
figure, hold on
subplot(4,7,[1]) 
MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_WAKE_end_saline,2), nanmean(data_perc_WAKE_end_cno,2)},...
    {col_saline,col_cno},[1:2],{},'paired',0,'showsigstar','none');
    xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('Wake percentage')
makepretty
if isparam==0 %%version ranksum
    [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_saline,2), nanmean(data_perc_WAKE_end_cno,2));
elseif isparam==1 % %%version ttest
    [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_perc_WAKE_end_saline,2), nanmean(data_perc_WAKE_end_cno,2));
else
end
if p_saline_vs_cno_2<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end



    
    


subplot(4,7,[2]) % SWS percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_SWS_end_saline,2), nanmean(data_perc_SWS_end_cno,2)},...
    {col_saline,col_cno},[1:2],{},'paired',0,'showsigstar','none'); 
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
if isparam==0 %%version ranksum
    [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_saline,2), nanmean(data_perc_SWS_end_cno,2));
elseif isparam==1 % %%version ttest
    [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_perc_SWS_end_saline,2), nanmean(data_perc_SWS_end_cno,2));
else
end
if p_saline_vs_cno_2<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end




subplot(4,7,[3]) % REM percentage quantif barplot
MakeSpreadAndBoxPlot2_MC({nanmean(data_perc_REM_end_saline,2), nanmean(data_perc_REM_end_cno,2)},...
    {col_saline,col_cno},[1:2],{},'paired',0,'showsigstar','none'); 
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('REM percentage')
makepretty
if isparam==0 %%version ranksum
    [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_saline,2), nanmean(data_perc_REM_end_cno,2));
elseif isparam==1 % %%version ttest
    [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_perc_REM_end_saline,2), nanmean(data_perc_REM_end_cno,2));
else
end
if p_saline_vs_cno_2<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end


subplot(4,7,[8]) 
MakeSpreadAndBoxPlot2_MC({nanmean(data_num_WAKE_end_saline,2), nanmean(data_num_WAKE_end_cno,2)},...
    {col_saline,col_cno},[1:2],{},'paired',0,'showsigstar','none'); 
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('Wake bouts number')
makepretty
if isparam==0 %%version ranksum
    [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_num_WAKE_end_saline,2), nanmean(data_num_WAKE_end_cno,2));
elseif isparam==1 % %%version ttest
    [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_num_WAKE_end_saline,2), nanmean(data_num_WAKE_end_cno,2));
else
end
if p_saline_vs_cno_2<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end




subplot(4,7,[9]) % SWS numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({nanmean(data_num_SWS_end_saline,2), nanmean(data_num_SWS_end_cno,2)},...
    {col_saline,col_cno},[1:2],{},'paired',0,'showsigstar','none'); 
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('NREM bouts number')
makepretty
if isparam==0 %%version ranksum
    [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_num_SWS_end_saline,2), nanmean(data_num_SWS_end_cno,2));
elseif isparam==1 % %%version ttest
    [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_num_SWS_end_saline,2), nanmean(data_num_SWS_end_cno,2));
else
end
if p_saline_vs_cno_2<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end




subplot(4,7,[10]) % REM numentage quantif barplot
MakeSpreadAndBoxPlot2_MC({nanmean(data_num_REM_end_saline,2), nanmean(data_num_REM_end_cno,2)},...
    {col_saline,col_cno},[1:2],{},'paired',0,'showsigstar','none'); 
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('REM bouts number')
makepretty
if isparam==0 %%version ranksum
    [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_saline,2), nanmean(data_num_REM_end_cno,2));
elseif isparam==1 % %%version ttest
    [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_num_REM_end_saline,2), nanmean(data_num_REM_end_cno,2));
else
end
if p_saline_vs_cno_2<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end




subplot(4,7,[15]) 
MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_WAKE_end_saline,2), nanmean(data_dur_WAKE_end_cno,2)},...
    {col_saline,col_cno},[1:2],{},'paired',0,'showsigstar','none'); 
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('Wake bouts duration (s)')
makepretty

if isparam==0 %%version ranksum
    [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_dur_WAKE_end_saline,2), nanmean(data_dur_WAKE_end_cno,2));
elseif isparam==1 % %%version ttest
    [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_dur_WAKE_end_saline,2), nanmean(data_dur_WAKE_end_cno,2));
else
end
if p_saline_vs_cno_2<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end




subplot(4,7,[16]) % SWS durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_SWS_end_saline,2), nanmean(data_dur_SWS_end_cno,2)},...
    {col_saline,col_cno},[1:2],{},'paired',0,'showsigstar','none'); 
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('NREM bouts duration (s)')
makepretty


if isparam==0 %%version ranksum
    [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_dur_SWS_end_saline,2), nanmean(data_dur_SWS_end_cno,2));
elseif isparam==1 % %%version ttest
    [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_dur_SWS_end_saline,2), nanmean(data_dur_SWS_end_cno,2));
else
end
if p_saline_vs_cno_2<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end




subplot(4,7,[17]) % REM durentage quantif barplot
MakeSpreadAndBoxPlot2_MC({nanmean(data_dur_REM_end_saline,2), nanmean(data_dur_REM_end_cno,2)},...
    {col_saline,col_cno},[1:2],{},'paired',0,'showsigstar','none'); 
xticks([1 2]); xticklabels({'SAL','CNO'}); xtickangle(0)
ylabel('REM bouts duration (s)')
makepretty

if isparam==0 %%version ranksum
    [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_saline,2), nanmean(data_dur_REM_end_cno,2));
elseif isparam==1 % %%version ttest
    [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_dur_REM_end_saline,2), nanmean(data_dur_REM_end_cno,2));
else
end
if p_saline_vs_cno_2<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end








% 
% 
% 
% 
% %% FIGURE ALL STATS PERC NUM DUR
% figure, hold on
% subplot(4,6,[1,2]) % WAKE percentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_perc_WAKE_begin_saline,2), nanmean(data_perc_WAKE_begin_cno,2),...
%     nanmean(data_perc_WAKE_end_saline,2), nanmean(data_perc_WAKE_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('Wake percentage')
% makepretty
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_perc_WAKE_begin_saline,2), nanmean(data_perc_WAKE_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_perc_WAKE_end_saline,2), nanmean(data_perc_WAKE_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_perc_WAKE_begin_saline,2), nanmean(data_perc_WAKE_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_perc_WAKE_end_saline,2), nanmean(data_perc_WAKE_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% subplot(4,6,[7,8]) % SLEEP percentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_perc_totSleep_begin_saline,2), nanmean(data_perc_totSleep_begin_cno,2),...
%     nanmean(data_perc_totSleep_end_saline,2), nanmean(data_perc_totSleep_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('SLEEP percentage')
% makepretty
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_perc_totSleep_begin_saline,2), nanmean(data_perc_totSleep_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_perc_totSleep_end_saline,2), nanmean(data_perc_totSleep_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_perc_totSleep_begin_saline,2), nanmean(data_perc_totSleep_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_perc_totSleep_end_saline,2), nanmean(data_perc_totSleep_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% subplot(4,6,[13,14]) % SWS percentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_perc_SWS_begin_saline,2), nanmean(data_perc_SWS_begin_cno,2),...
%     nanmean(data_perc_SWS_end_saline,2), nanmean(data_perc_SWS_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('SWS percentage')
% makepretty
% 
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_perc_SWS_begin_saline,2), nanmean(data_perc_SWS_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_perc_SWS_end_saline,2), nanmean(data_perc_SWS_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_perc_SWS_begin_saline,2), nanmean(data_perc_SWS_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_perc_SWS_end_saline,2), nanmean(data_perc_SWS_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% 
% subplot(4,6,[19,20]) % REM percentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_perc_REM_begin_saline,2), nanmean(data_perc_REM_begin_cno,2),...
%     nanmean(data_perc_REM_end_saline,2), nanmean(data_perc_REM_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('REM percentage')
% makepretty
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_perc_REM_begin_saline,2), nanmean(data_perc_REM_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_perc_REM_end_saline,2), nanmean(data_perc_REM_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_perc_REM_begin_saline,2), nanmean(data_perc_REM_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_perc_REM_end_saline,2), nanmean(data_perc_REM_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% subplot(4,6,[3,4]) % WAKE numentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_num_WAKE_begin_saline,2), nanmean(data_num_WAKE_begin_cno,2),...
%     nanmean(data_num_WAKE_end_saline,2), nanmean(data_num_WAKE_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('Wake num')
% makepretty
% 
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_num_WAKE_begin_saline,2), nanmean(data_num_WAKE_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_num_WAKE_end_saline,2), nanmean(data_num_WAKE_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_num_WAKE_begin_saline,2), nanmean(data_num_WAKE_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_num_WAKE_end_saline,2), nanmean(data_num_WAKE_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% subplot(4,6,[9,10]) % SLEEP numentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_num_totSleep_begin_saline,2), nanmean(data_num_totSleep_begin_cno,2),...
%     nanmean(data_num_totSleep_end_saline,2), nanmean(data_num_totSleep_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('SLEEP num')
% makepretty
% 
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_num_totSleep_begin_saline,2), nanmean(data_num_totSleep_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_num_totSleep_end_saline,2), nanmean(data_num_totSleep_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_num_totSleep_begin_saline,2), nanmean(data_num_totSleep_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_num_totSleep_end_saline,2), nanmean(data_num_totSleep_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% 
% subplot(4,6,[15,16]) % SWS numentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_num_SWS_begin_saline,2), nanmean(data_num_SWS_begin_cno,2),...
%     nanmean(data_num_SWS_end_saline,2), nanmean(data_num_SWS_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('SWS num')
% makepretty
% 
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_num_SWS_begin_saline,2), nanmean(data_num_SWS_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_num_SWS_end_saline,2), nanmean(data_num_SWS_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_num_SWS_begin_saline,2), nanmean(data_num_SWS_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_num_SWS_end_saline,2), nanmean(data_num_SWS_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% 
% subplot(4,6,[21,22]) % REM numentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_num_REM_begin_saline,2), nanmean(data_num_REM_begin_cno,2),...
%     nanmean(data_num_REM_end_saline,2), nanmean(data_num_REM_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('REM num')
% makepretty
% 
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_num_REM_begin_saline,2), nanmean(data_num_REM_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_num_REM_end_saline,2), nanmean(data_num_REM_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_num_REM_begin_saline,2), nanmean(data_num_REM_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_num_REM_end_saline,2), nanmean(data_num_REM_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% 
% subplot(4,6,[5,6]) % WAKE durentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_dur_WAKE_begin_saline,2), nanmean(data_dur_WAKE_begin_cno,2),...
%     nanmean(data_dur_WAKE_end_saline,2), nanmean(data_dur_WAKE_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('Wake dur')
% makepretty
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_dur_WAKE_begin_saline,2), nanmean(data_dur_WAKE_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_dur_WAKE_end_saline,2), nanmean(data_dur_WAKE_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_dur_WAKE_begin_saline,2), nanmean(data_dur_WAKE_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_dur_WAKE_end_saline,2), nanmean(data_dur_WAKE_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% 
% subplot(4,6,[11,12]) % SLEEP durentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_dur_totSleep_begin_saline,2), nanmean(data_dur_totSleep_begin_cno,2),...
%     nanmean(data_dur_totSleep_end_saline,2), nanmean(data_dur_totSleep_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('SLEEP dur')
% makepretty
% 
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_dur_totSleep_begin_saline,2), nanmean(data_dur_totSleep_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_dur_totSleep_end_saline,2), nanmean(data_dur_totSleep_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_dur_totSleep_begin_saline,2), nanmean(data_dur_totSleep_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_dur_totSleep_end_saline,2), nanmean(data_dur_totSleep_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% 
% 
% subplot(4,6,[17,18]) % SWS durentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_dur_SWS_begin_saline,2), nanmean(data_dur_SWS_begin_cno,2),...
%     nanmean(data_dur_SWS_end_saline,2), nanmean(data_dur_SWS_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('SWS dur')
% makepretty
% 
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_dur_SWS_begin_saline,2), nanmean(data_dur_SWS_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_dur_SWS_end_saline,2), nanmean(data_dur_SWS_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_dur_SWS_begin_saline,2), nanmean(data_dur_SWS_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_dur_SWS_end_saline,2), nanmean(data_dur_SWS_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% 
% 
% subplot(4,6,[23,24]) % REM durentage quantif barplot
% MakeSpreadAndBoxPlot2_MC({...
%     nanmean(data_dur_REM_begin_saline,2), nanmean(data_dur_REM_begin_cno,2),...
%     nanmean(data_dur_REM_end_saline,2), nanmean(data_dur_REM_end_cno,2)},...
%     'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_saline,col_cno,col_saline,col_cno});
% xticks([1.5 4.5]); xticklabels({'pre','post'}); xtickangle(0)
% ylabel('REM dur')
% makepretty
% 
% 
% if isparam==0 %%version ranksum
%     [p_saline_vs_cno_1, h_1] = ranksum(nanmean(data_dur_REM_begin_saline,2), nanmean(data_dur_REM_begin_cno,2));
%     [p_saline_vs_cno_2, h_2] = ranksum(nanmean(data_dur_REM_end_saline,2), nanmean(data_dur_REM_end_cno,2));
% elseif isparam==1 % %%version ttest
%     [h_1,p_saline_vs_cno_1] = ttest(nanmean(data_dur_REM_begin_saline,2), nanmean(data_dur_REM_begin_cno,2));
%     [h_2,p_saline_vs_cno_2] = ttest(nanmean(data_dur_REM_end_saline,2), nanmean(data_dur_REM_end_cno,2));
% else
% end
% 
% if iscorr==0
%     if p_saline_vs_cno_1<0.05; sigstar_MC({[1 2]},p_saline_vs_cno_1,0,'LineWigth',16,'StarSize',24);end
%     if p_saline_vs_cno_2<0.05; sigstar_MC({[4 5]},p_saline_vs_cno_2,0,'LineWigth',16,'StarSize',24);end
% elseif iscorr==1
%     p_values = [p_saline_vs_cno_1 p_saline_vs_cno_2];
%     [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p_values);
%     if adj_p(1)<0.05; sigstar_MC({[1 2]},adj_p(1),0,'LineWigth',16,'StarSize',24);end
%     if adj_p(2)<0.05; sigstar_MC({[4 5]},adj_p(2),0,'LineWigth',16,'StarSize',24);end
% else
% end
% 
% 
% 
% 
