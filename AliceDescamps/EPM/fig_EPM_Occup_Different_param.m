%% Figure comparing occupancy with different properties of EPM

%%Get DATA from EPM_Analysis_corrected_AD_MC.m

figure,
%proportion (occupancy after different SD)
subplot (231),
PlotErrorBarN_MC({occup_open_basal, occup_open_SDsafe, occup_open_SD,occup_close_basal ,occup_close_SDsafe,occup_close_SD,occup_center_basal ,occup_center_SDsafe,occup_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
xticks([2 6 10]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Occupancy');
legend('Control','CD1-CD1','CD1-C57');
makepretty

% [p_basal_SDdanger_open,h]=ranksum(occup_open_basal,occup_open_SD);
[h,p_basal_SDdanger_open]=ttest2(occup_open_basal, occup_open_SD);
if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24,'legend',0);end
% [p_basal_SDsafe_open,h]=ranksum(occup_open_basal,occup_open_SDsafe);
[h,p_basal_SDsafe_open]=ttest2(occup_open_basal, occup_open_SDsafe);
if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24,'legend',0);end
% [p_SDdanger_SDsafe_open,h]=ranksum(occup_open_SDsafe,occup_open_SD);
[h,p_SDdanger_SDsafe_open]=ttest2(occup_open_SDsafe, occup_open_SD);
if p_SDdanger_SDsafe_open<0.05; sigstar_DB({[2 3]},p_SDdanger_SDsafe_open,0,'LineWigth',16,'StarSize',24,'legend',0);end

% [p_basal_SDdanger_close,h]=ranksum(occup_close_basal,occup_close_SD);
[h,p_basal_SDdanger_close]=ttest2(occup_close_basal, occup_close_SD);
if p_basal_SDdanger_close<0.05; sigstar_DB({[5 7]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24,'legend',0);end
% [p_basal_SDsafe_close,h]=ranksum(occup_close_basal,occup_close_SDsafe);
[h,p_basal_SDsafe_close]=ttest2(occup_close_basal, occup_close_SDsafe);
if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24,'legend',0);end
% [p_SDdanger_SDsafe_close,h]=ranksum(occup_close_SDsafe,occup_close_SD);
[h,p_SDdanger_SDsafe_close]=ttest2(occup_close_SDsafe, occup_close_SD);
if p_SDdanger_SDsafe_close<0.05; sigstar_DB({[6 7]},p_SDdanger_SDsafe_close,0,'LineWigth',16,'StarSize',24,'legend',0);end

% [p_basal_SDdanger_center,h]=ranksum(occup_center_basal,occup_center_SD);
[h,p_basal_SDdanger_center]=ttest2(occup_center_basal, occup_center_SD);
if p_basal_SDdanger_center<0.05; sigstar_DB({[9 11]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24,'legend',0);end
% [p_basal_SDsafe_center,h]=ranksum(occup_center_basal,occup_center_SDsafe);
[h,p_basal_SDsafe_center]=ttest2(occup_center_basal, occup_center_SDsafe);
if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24,'legend',0);end
% [p_SDdanger_SDsafe_center,h]=ranksum(occup_center_SDsafe,occup_center_SD);
[h,p_SDdanger_SDsafe_center]=ttest2(occup_center_SDsafe, occup_center_SD);
if p_SDdanger_SDsafe_center<0.05; sigstar_DB({[10 11]},p_SDdanger_SDsafe_center,0,'LineWigth',16,'StarSize',24,'legend',0);end

figure,
%proportion (occupancy with different time of day)
subplot (232),
PlotErrorBarN_MC({occup_open_basal,occup_open_SD,occup_close_basal,occup_close_SD,occup_center_basal,occup_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Occupancy - time of the day');
legend('14h-15h','17h-18h');
makepretty

% [p_sal_cno_open,h]=ranksum(occup_open_basal,occup_open_SD);
[h,p_sal_cno_open]=ttest2(occup_open_basal,occup_open_SD);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_close,h]=ranksum(occup_close_basal,occup_close_SD);
[h,p_sal_cno_close]=ttest2(occup_close_basal, occup_close_SD);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_center,h]=ranksum(occup_center_basal,occup_center_SD);
[h,p_sal_cno_center]=ttest2(occup_center_basal, occup_center_SD);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end


%proportion (occupancy if plugged or not)
subplot (233),
PlotErrorBarN_MC({occup_open_basal,occup_open_SD,occup_close_basal,occup_close_SD,occup_center_basal,occup_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Occupancy - plugged or not');
legend('Plugged','Not plugged');
makepretty

% [p_sal_cno_open,h]=ranksum(occup_open_basal,occup_open_SD);
[h,p_sal_cno_open]=ttest2(occup_open_basal,occup_open_SD);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_close,h]=ranksum(occup_close_basal,occup_close_SD);
[h,p_sal_cno_close]=ttest2(occup_close_basal, occup_close_SD);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_center,h]=ranksum(occup_center_basal,occup_center_SD);
[h,p_sal_cno_center]=ttest2(occup_center_basal, occup_center_SD);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end


%proportion (occupancy when SDsafe was in different rooms)
subplot (234),
PlotErrorBarN_MC({occup_open_basal,occup_open_SD,occup_close_basal,occup_close_SD,occup_center_basal,occup_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Occupancy - SDsafe room');
legend('Cervelet','Animalerie');
makepretty

% [p_sal_cno_open,h]=ranksum(occup_open_basal,occup_open_SD);
[h,p_sal_cno_open]=ttest2(occup_open_basal,occup_open_SD);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_close,h]=ranksum(occup_close_basal,occup_close_SD);
[h,p_sal_cno_close]=ttest2(occup_close_basal, occup_close_SD);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_center,h]=ranksum(occup_center_basal,occup_center_SD);
[h,p_sal_cno_center]=ttest2(occup_center_basal, occup_center_SD);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end


%proportion (occupancy with SDsafe and different CD1)
subplot (235),
PlotErrorBarN_MC({occup_open_basal,occup_open_SD,occup_close_basal,occup_close_SD,occup_center_basal,occup_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Occupancy - CD1 mouse');
legend('1460','1462');
makepretty

% [p_sal_cno_open,h]=ranksum(occup_open_basal,occup_open_SD);
[h,p_sal_cno_open]=ttest2(occup_open_basal,occup_open_SD);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_close,h]=ranksum(occup_close_basal,occup_close_SD);
[h,p_sal_cno_close]=ttest2(occup_close_basal, occup_close_SD);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_center,h]=ranksum(occup_center_basal,occup_center_SD);
[h,p_sal_cno_center]=ttest2(occup_center_basal, occup_center_SD);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end


%proportion (occupancy with different type of SD)
subplot (236),
PlotErrorBarN_MC({occup_open_basal,occup_open_SD,occup_close_basal,occup_close_SD,occup_center_basal,occup_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Occupancy - type of SD');
legend('CD1-CD1','CD1-C57');
makepretty

% [p_sal_cno_open,h]=ranksum(occup_open_basal,occup_open_SD);
[h,p_sal_cno_open]=ttest2(occup_open_basal,occup_open_SD);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_close,h]=ranksum(occup_close_basal,occup_close_SD);
[h,p_sal_cno_close]=ttest2(occup_close_basal, occup_close_SD);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_center,h]=ranksum(occup_center_basal,occup_center_SD);
[h,p_sal_cno_center]=ttest2(occup_center_basal, occup_center_SD);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end