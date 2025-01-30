%% Objectives of this code (part II report)

%%% Shift during freezing safe along normalized time and frequency for all mice
%%% Parameters that influence OB frequency: ripples, shocks, shock zone entries (not in the report)

% Two methods of defining the threshold
%%% 1: Shock vs Safe freezing
%%% 2: Dynamic range of the safe freezing 

% Comparison of the temporal occurence of thresholds ==> method 2 selected
%%% Frequencies at threshold
%%% Behavior (nb of sk zone entries/min) before and after the threshold

%% Paths
SaveFigsTo = '/home/gruffalo/Link to Dropbox/Kteam/PrgMatlab/Ella/Analysis_Figures/New_freq_measurement';

%% Part II: Analysis of the model 
% and justify the one selected to analyse the shift and implement the model 

% Mouse_ALL_pre=[688 739 777 779 849 893 1170 1171 9184 1189 9205 1391 1392 1393 1394]; 
%to, after removing mice that have not learned (1393 spends 25% of her time
%in the shock zone in post cond) or that have freezed less than 40s (779,1170, 9205)
Mouse_ALL=[688 739 777 849 893 1171 9184 1189 1391 1392 1394];

%% Extract data for selected mice

Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [ALL_TSD_DATA.(Session_type{sess}) , EpochALL.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_ALL,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition', 'instfreq');
end

% Compute OB frequency and ripples during freezing shock
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5});
    if isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.Spect.Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}) == 0
        ALL.Spect.Ind_Ripples.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}); 
    end
end

% Compute OB frequency and ripples during freezing safe
for mousenum=1:length(Mouse_ALL)
    ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}) == 0
        ALL.Spect.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
    end
end

%% A

%% 1/ Normalize in time and frequency the freezing safe for all mice

Time_interpolation = linspace(0, 1, 2000);
for mousenum=1:length(Mouse_ALL)
    ALL.Spect.NormRunMean.SafeFz.(ALL_Mouse_names{mousenum}) = (ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}) - min(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))/(max(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})) - min(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})));
    ALL.Spect.NormTime.SafeFz.(ALL_Mouse_names{mousenum}) = (0:length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))-1)/(length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))-1);
    ALL.Spect.NormFreqInterp.SafeFz.(ALL_Mouse_names{mousenum}) = interp1(ALL.Spect.NormTime.SafeFz.(ALL_Mouse_names{mousenum}), ALL.Spect.NormRunMean.SafeFz.(ALL_Mouse_names{mousenum}), Time_interpolation);
    Norminterpdata(mousenum,:) = ALL.Spect.NormFreqInterp.SafeFz.(ALL_Mouse_names{mousenum});
end

for mousenum=1:length(Mouse_ALL)
    Max_OB_Safe(mousenum) = max(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    Min_OB_Safe(mousenum) = min(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    Max_OB_Shock(mousenum) = max(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}));
    Min_OB_Shock(mousenum) = min(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}));
    DR(mousenum) = Max_OB_Safe(mousenum)-Min_OB_Safe(mousenum);
    Shift(mousenum) = (Min_OB_Safe(mousenum)+0.7*DR(mousenum)) - (Min_OB_Safe(mousenum)+0.3*DR(mousenum));
end
mean(Shift)


figure;
for mousenum=1:length(Mouse_ALL)
    plot(ALL.Spect.NormTime.SafeFz.(ALL_Mouse_names{mousenum}),ALL.Spect.NormRunMean.SafeFz.(ALL_Mouse_names{mousenum}), '.'), hold on
end

Conf_Inter=nanstd(Norminterpdata)/sqrt(size(Norminterpdata,1));

figure;
shadedEB = shadedErrorBar(Time_interpolation, ...
    nanmean(Norminterpdata), Conf_Inter, 'k', 0);
makepretty
set(shadedEB.edge,'LineWidth',2)
shadedEB.mainLine.LineWidth = 2;
shadedEB.mainLine.Color = [.1,.3,.5];
shadedEB.patch.FaceColor = [.4,.6,.8];
shadedEB.edge(1).Color = [.4,.6,.8];
shadedEB.edge(2).Color = [.4,.6,.8];
xlabel('Normalized Time freezing', 'FontSize', 25);
ylabel('Normalized Frequency', 'FontSize', 25);
xlim([0 1])
ylim([0 1])
set(gca, 'FontSize', 14, 'YTick',[0:0.2:1])
saveas(gcf, fullfile(SaveFigsTo, '02_A_shift_fzsafe_final'), 'png');

%% 2/ Parameters that influence OB frequency

% Ripples
% What Baptiste tried : Plot Rip Raw 
% PlotRipRaw
% [M,T] = PlotRipRaw(LFP, events, durations, cleaning, PlotFigure,NewFig)
% INPUT
% events : in seconds
% durations in ms
% OUTPUT
% M :   time, mean, std, stdError
% T :   matrix

figure
for mouse=1:11
    try
        subplot(4,3,mouse)
        [M,T] = PlotRipRaw(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,6} , Range(ALL_TSD_DATA.Cond.ripples.ts{mouse, 6})/1e4, 1000, 0, 0, 0);
        T(T==0)=NaN;
        plot(nanmean(T))
    end
end

Conf_Inter_Ripples=nanstd(RipRaw)/sqrt(size(RipRaw,2));

figure
raw=1;
for mousenum=[1 2 3 4 6 8 9 10 11] % Indices of mouse that have ripples
    clear M T
    [M,T] = PlotRipRaw(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6} , Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum, 6})/1e4, 1000, 0, 0, 0);
    T(T==0)=NaN;
    RipRaw(raw,:) = nanmean(T);
    raw=raw+1;
end
shadedEB = shadedErrorBar(1:size(RipRaw,2), ...
    nanmean(RipRaw), Conf_Inter_Ripples, 'k', 0); hold on;
shadedEB.mainLine.LineWidth = 4;
shadedEB.mainLine.Color = [[0.8 0 0]*0.8];
shadedEB.patch.FaceColor = [0.8 0.7 0.7];
shadedEB.edge(1).Color = [0.8 0.7 0.7];
shadedEB.edge(2).Color = [0.8 0.7 0.7];
raw=1;
for mousenum=[1 2 3 4 6 8 9 10 11] % Indices of mouse that have ripples
    plot(RipRaw(raw,:), 'Color', [.1,.1,.1]), hold on
    raw=raw+1;
end
makepretty
xlim([0 12])
ylim([3.4 5.1])
line([6 6], ylim, 'Color', 'k', 'Linewidth', 2, 'Linestyle','--')
xlabel('Time before and after a ripple (ms)');
ylabel('OB Frequency on the safe side (Hz)', 'FontSize', 22);
set(gca,'FontSize', 12, 'XTick',[1:5:11],'XTicklabels',[-500:500:500], 'YTick',[3:0.2:6])
saveas(gcf, fullfile(SaveFigsTo, '02_B_freq_ripple_final_small'), 'png');

%% Below code was done by baptiste (cf Ella_Master_Report_BM.m)

[OutPutData , Epoch1 , NameEpoch1] = MeanValuesPhysiologicalParameters_BM(Mouse_ALL,'cond','respi_freq_bm');

% after shock
% figure
bin=40; % divide by 5 to have wanted epoch in seconds
for mouse=1:11
    clear St D ind ind_pre ind_post D_pre D_post
    St = Start(Epoch1{mouse,2});
    D = Data(OutPutData.respi_freq_bm.tsd{mouse,6});
    for s=1:length(St)
        ind = max(find(Range(OutPutData.respi_freq_bm.tsd{mouse,6})<St(s)));
        if ind<bin
            ind_pre = 1:ind; % 4s of freezing safe before eyelidshock
        else
            ind_pre = ind-bin:ind; % 4s of freezing safe before eyelidshock
        end
        ind_post = ind:ind+bin; % 4s of freezing safe after eyelidshock
        D_pre(s,1:length(D(ind_pre))) = D(ind_pre);
        D_post(s,1:length(D(ind_post))) = D(ind_post);
    end
    D_pre(D_pre==0)=NaN; D_post(D_post==0)=NaN;
    
%     subplot(4,3,mouse)
%     MakeSpreadAndBoxPlot3_ECSB({nanmedian(D_pre') nanmedian(D_post')},{[0.8 0 0]*0.7,[0.8 0.2 0.2]},[1 2],{'Pre','Post'},'showpoints',0,'paired',1);
%     xlim([0.5 2.5])

    Mean_Bef_sk(mouse) = nanmedian(nanmedian(D_pre'));
    Mean_Aft_sk(mouse) = nanmedian(nanmedian(D_post'));
end

load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat', 'BlockedEpoch')

% after entries shock
% figure
bin = 40;
for mouse=1:11
    Mouse_names{mouse}=['M' num2str(Mouse_ALL(mouse))];
    
    clear St D ind ind_pre ind_post D_pre D_post
    St = Start(and(Epoch1{mouse,7} , (Epoch1{mouse,1}-BlockedEpoch.Cond.(Mouse_names{mouse}))));
    D = Data(OutPutData.respi_freq_bm.tsd{mouse,6});
    for s=1:length(St)
        ind = max(find(Range(OutPutData.respi_freq_bm.tsd{mouse,6})<St(s)));
        if ind<bin
            ind_pre = 1:ind; % 4s of freezing safe before eyelidshock
        else
            ind_pre = ind-bin:ind; % 4s of freezing safe before eyelidshock
        end
        if ind+bin>length(D)
            ind_post = ind:length(D); % 4s of freezing safe after eyelidshock
        else
            ind_post = ind:ind+bin; % 4s of freezing safe after eyelidshock
        end
        D_pre(s,1:length(D(ind_pre))) = D(ind_pre);
        D_post(s,1:length(D(ind_post))) = D(ind_post);
    end
    D_pre(D_pre==0)=NaN; D_post(D_post==0)=NaN;
    
%     subplot(4,3,mouse)
%     MakeSpreadAndBoxPlot3_SB({nanmedian(D_pre') nanmedian(D_post')},{[0.8 0 0]*0.7,[0.8 0.2 0.2]},[1 2],{'Pre','Post'},'showpoints',0,'paired',1);
    
    Mean_Bef(mouse) = nanmedian(nanmedian(D_pre'));
    Mean_Aft(mouse) = nanmedian(nanmedian(D_post'));
end

figure
subplot(1,2,1)
[pval_sk stats_sk] = MakeSpreadAndBoxPlot3_ECSB({Mean_Bef_sk Mean_Aft_sk},{[0.8 0 0]*0.7,[0.8 0.2 0.2]},[1 2],{'Pre shock','Post shock'},'showpoints',0,'paired',1);
xlim([0.5 2.5])
ylim([3.8 5.6])
ylabel('Mean OB frequency during safe-side freezing (Hz)', 'FontSize', 14);
% title('pval=0.898')
set(gca,'linewidth',1.5, 'FontSize', 12, 'Ytick', [3.8:0.4:5.6])
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_02_thresholds_percent_time_large'), 'png');

subplot(1,2,2)
[pval_entrysk,stat_entry_sk]=MakeSpreadAndBoxPlot3_ECSB({Mean_Bef Mean_Aft},{[0.8 0 0]*0.7,[0.8 0.2 0.2]},[1 2],{'Pre entry shock','Post entry shock'},'showpoints',0,'paired',1);
xlim([0.5 2.5])
ylim([3.8 5.6])
% title('pval=0.175')
% ylabel('', 'FontSize', 25);
set(gca,'linewidth',1.5, 'FontSize', 12, 'Ytick', [3.8:0.4:5.6], 'Xtick', [1.5], 'Xticklabel', {'Pre/Post entry shock'})
saveas(gcf, fullfile(SaveFigsTo, '02_C_after_sk_entry_4s_final'), 'png');

%% B : 2 definitions of the threshold of OB frequency shift

%% Illustration of the two methods

% According to freezing shock

% Add significativity in difference (Fshock > Fsafe)
for mousenum=1:length(Mouse_ALL)
    for i=1:length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))
        [ALL_h_Fsk_Fsafe(mousenum,i),ALL_p_Fsk_Fsafe(mousenum,i)] = ttest2(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}), ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(i), 'Tail','right', 'Alpha', 0.02); 
        % Alpha can be changed to increase the threshold of significativity
    end
    for j=1:length(ALL_h_Fsk_Fsafe(mousenum,:))
        if j>length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))
            ALL_h_Fsk_Fsafe(mousenum,j)=NaN; 
        end
    end
    for j=1:length(ALL_p_Fsk_Fsafe(mousenum,:))
        if j>length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))
            ALL_p_Fsk_Fsafe(mousenum,j)=NaN; 
        end
    end
end

% Figure for all mice
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(4,3,mousenum)
    
    clear All_Time
    ALL_Time.SafeFz = (1:length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    ALL_Time.ShockFz = (1:length(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    clear ALL_h_mouse ind_Nan ALL_h_Fsk_Fsafe_mouse
    ALL_h_mouse=ALL_h_Fsk_Fsafe(mousenum,:);
    ind_Nan=isnan(ALL_h_Fsk_Fsafe(mousenum,:));
    ALL_h_Fsk_Fsafe_mouse=ALL_h_mouse(~ind_Nan);
    
    plot(ALL_Time.ShockFz, ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}),'Color',[0.8 0 0]), hold on
    plot(ALL_Time.SafeFz, ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',[.1,.3,.5]), hold on
    try; plot(ALL_Time.SafeFz(logical(ALL_h_Fsk_Fsafe_mouse)), max(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))+1, '*k'); end
    ylim([2 8])
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'OB frequencies during shock and safe side freezing', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_fz_shock_safe_diff'), 'png');

% For example mouse, M777 (3) with threshold
figure
for mousenum=3
    clear All_Time
    ALL_Time.SafeFz = (1:length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    ALL_Time.ShockFz = (1:length(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    clear ALL_h_mouse ind_Nan ALL_h_Fsk_Fsafe_mouse
    ALL_h_mouse=ALL_h_Fsk_Fsafe(mousenum,:);
    ind_Nan=isnan(ALL_h_Fsk_Fsafe(mousenum,:));
    ALL_h_Fsk_Fsafe_mouse=ALL_h_mouse(~ind_Nan);
    
    plot(ALL_Time.ShockFz, ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}),'Color',[0.8 0 0]), hold on
    plot(ALL_Time.SafeFz, ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',[.1,.3,.5]), hold on
    plot(ALL_Time.SafeFz(logical(ALL_h_Fsk_Fsafe_mouse)), max(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))+1, '*k')
    ylim([2 6])
    makepretty
    
    ylabel('Frequency (Hz)', 'FontSize', 18);
    xlabel('Time freezing (s)', 'FontSize', 22);
    leg=legend({'Shock', 'Safe', 'Significative timepoints'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
%     leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2.5 6.5])
    set(gca, 'FontSize', 14)
end
saveas(gcf, fullfile(SaveFigsTo, '01_01_B_Signals_spectro_final'), 'png');

%% 1/ According to freezing shock 

% Extract thresholds of fz time : first index for which the difference between
% freezing shock and safe is significative (alpha=0.02) and stable during
% at least 20 seconds of freezing concatenated epoch
timesig=100;
for mousenum=1:length(Mouse_ALL)
    clear indj 
    indj=1;
    for j=1:length(ALL_h_Fsk_Fsafe(mousenum,:))-timesig
        if sum(ALL_h_Fsk_Fsafe(mousenum,j:j+timesig)) == timesig+1
            All_sigstable_tpointFz_SkSf(mousenum,indj) = j;
            indj = indj+1;
        else
            All_sigstable_tpointFz_SkSf(mousenum,indj) = 0;
        end
    end
    Threshold_tpointFz_SkSf(mousenum) = All_sigstable_tpointFz_SkSf(mousenum,1);
    Threshold_tpointFz_SkSf(Threshold_tpointFz_SkSf == 0) = NaN;
    Percent_tFz_SkSf(mousenum) = 100*All_sigstable_tpointFz_SkSf(mousenum,1)/length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
end

% Extract thresholds of global time according to Fz Shock/Safe comparison
for mousenum=1:length(Mouse_ALL)
    try % for NaN values
    Threshold_GT_SkSf(mousenum) = ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum})(Threshold_tpointFz_SkSf(mousenum));
    Percent_GT_SkSf(mousenum) = 100*Threshold_GT_SkSf(mousenum)/max(Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}));
%     Percent_GT_SkSf(Percent_GT_SkSf==0)=100
    end
end

% For example mouse, M777 (3) with threshold
figure
for mousenum=8
    clear All_Time
    ALL_Time.SafeFz = (1:length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    ALL_Time.ShockFz = (1:length(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    clear ALL_h_mouse ind_Nan ALL_h_Fsk_Fsafe_mouse
    ALL_h_mouse=ALL_h_Fsk_Fsafe(mousenum,:);
    ind_Nan=isnan(ALL_h_Fsk_Fsafe(mousenum,:));
    ALL_h_Fsk_Fsafe_mouse=ALL_h_mouse(~ind_Nan);
    
    pp1 = plot(ALL_Time.ShockFz, ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}),'Color',[0.8 0.2 0.2]); hold on;
    pp2 = plot(ALL_Time.SafeFz, ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',[.4,.6,.8]); hold on;
    pp3 = plot(ALL_Time.SafeFz(logical(ALL_h_Fsk_Fsafe_mouse)), max(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))+1, '.', 'Color', [0.6 0.2 0.2]); hold on;
    pp4 = line([Threshold_tpointFz_SkSf(mousenum)*0.2 Threshold_tpointFz_SkSf(mousenum)*0.2], [3.5 6.5], 'Color', [0.6 0.2 0.2], 'Linewidth', 2, 'Linestyle','--');
    makepretty
    
    ylabel('Frequency (Hz)', 'FontSize', 18);
    xlabel('Time freezing (s)', 'FontSize', 18);
    leg=legend([pp1,pp2,pp3(1),pp4],{'Shock', 'Safe', 'Timepoints below threshold, Shock/Safe method', 'Threshold on Shock/Safe'}, 'FontSize', 12, 'Location', 'southwest');
    leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2.5 6.5])
    set(gca, 'FontSize', 14, 'Ytick', [3:1:6])
end
saveas(gcf, fullfile(SaveFigsTo, '02_D_ex_threshold_shock_safe_final'), 'png');

%% 2/ According to freezing safe alone

% Thresholds on freezing safe
for mousenum=1:length(Mouse_ALL)
    clear Spect_RunMeanFq_mouse 
    Spect_RunMeanFq_mouse = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    All_sig_tpointFz_Safe.(ALL_Mouse_names{mousenum}) = find(Spect_RunMeanFq_mouse<(((max(Spect_RunMeanFq_mouse)-min(Spect_RunMeanFq_mouse))/2)+min(Spect_RunMeanFq_mouse)));
    Threshold_tpointFz_Safe(mousenum) = All_sig_tpointFz_Safe.(ALL_Mouse_names{mousenum})(1); % index at which the mice started learning
    Percent_tFz_Safe(mousenum) = 100*Threshold_tpointFz_Safe(mousenum)/length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
end

% Extract thresholds of global time according to Fz Shock/Safe comparison
for mousenum=1:length(Mouse_ALL)
    try % for NaN values
    Threshold_GT_Safe(mousenum) = ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum})(Threshold_tpointFz_Safe(mousenum));
    Percent_GT_Safe(mousenum) = 100*Threshold_GT_Safe(mousenum)/max(Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}));
    end
end

% Represent the OB mean frequency with the shift
figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    plot(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})), hold on
    plot(All_sig_tpointFz_Safe.(ALL_Mouse_names{mousenum}), max(Spect_RunMeanFq_mouse)+1 , '.k')
    ylim([0 8])
    hold on
    line([Threshold_tpointFz_Safe(mousenum) Threshold_tpointFz_Safe(mousenum)],ylim)
end
suptitle('100 100')

% For example mouse, M777 (3) with threshold
figure
for mousenum=3
    clear All_Time Spect_RunMeanFq_mouse
    ALL_Time.SafeFz = (1:length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    Spect_RunMeanFq_mouse = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    
    p1 = plot(ALL_Time.SafeFz, ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',[.4,.6,.8]); hold on
    p2 = plot(All_sig_tpointFz_Safe.(ALL_Mouse_names{mousenum})*0.2, max(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))+1 , '.','Color',[.4,.6,.8]*0.5);
    hold on
    p3 = line([Threshold_tpointFz_Safe(mousenum)*0.2 Threshold_tpointFz_Safe(mousenum)*0.2], [3.5 6.5],'Color',[.4,.6,.8]*0.5, 'Linewidth', 2, 'Linestyle','--');
    makepretty
    
    ylabel('Frequency (Hz)', 'FontSize', 18);
    xlabel('Time freezing (s)', 'FontSize', 18);
    leg=legend([p1,p2(1),p3],{'Safe', 'Timepoints below threshold, Safe dynamic range method', 'Threshold on Safe'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2.5 6.5])
    set(gca, 'FontSize', 14, 'Ytick', [3:1:6])
end
saveas(gcf, fullfile(SaveFigsTo, '02_E_ex_threshold_safe_final'), 'png');

% Example mice for the poster
figure
for mousenum=8
    clear All_Time Spect_RunMeanFq_mouse
    ALL_Time.SafeFz = (1:length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    Spect_RunMeanFq_mouse = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    
    p1 = plot(ALL_Time.SafeFz, ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',[.4,.6,.8]); hold on
    p2 = plot(All_sig_tpointFz_Safe.(ALL_Mouse_names{mousenum})*0.2, max(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))+1 , '.','Color',[.4,.6,.8]*0.5);
    hold on
    p3 = line([Threshold_tpointFz_Safe(mousenum)*0.2 Threshold_tpointFz_Safe(mousenum)*0.2], [2 6],'Color',[.4,.6,.8]*0.5, 'Linewidth', 2, 'Linestyle','--');
    makepretty
    
    ylabel('Frequency (Hz)', 'FontSize', 18);
    xlabel('Time freezing (s)', 'FontSize', 18);
    leg=legend([p1,p3],{'Safe breathing rate', 'Threshold'}, 'FontSize', 12, 'Location', 'northeast');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2 6])
    set(gca, 'FontSize', 14, 'Ytick', [3:1:6])
end
saveas(gcf, fullfile(SaveFigsTo, '02_E_ex_threshold_safe_poster'), 'png');


%% Compare the timepoints of thresholds with the two methods 

% Percentages
figure
subplot(1,2,1)
[pval_tfz , stats_out_tfz]= MakeSpreadAndBoxPlot3_ECSB({Percent_GT_SkSf(Percent_GT_SkSf>0) Percent_GT_Safe(:,[1,2,3,4,5,6,7,8,9,11])},{[0.8 0.2 0.2] [.4,.6,.8]},...
    [1 2],{'Shock/Safe','Safe'},'paired',0,'showpoints',1);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
% ylabel('Values of the 25th percentile of OB frequencies (Hz)', 'FontSize', 25);
ylabel('% of conditioning session time at threshold ', 'FontSize', 22);
xlim([0.5 2.5])
ylim([0 100])
set(gca,'FontSize', 12,'linewidth',1.5)

subplot(1,2,2)
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Percent_tFz_SkSf(Percent_tFz_SkSf>0) Percent_tFz_Safe(Percent_tFz_Safe>1)},{[0.8 0.2 0.2] [.4,.6,.8]},...
    [1 2],{'Shock/Safe','Safe'},'paired',0,'showpoints',1);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 100])
ylabel('% of safe freezing time at threshold', 'FontSize', 22);
set(gca,'FontSize', 12,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, '02_S2_thresholds_percent_time_large'), 'png');

% Absolute time
figure
subplot(1,2,1) % exclude mice for which no significative difference was found
[pval_tfz , stats_out_tfz]= MakeSpreadAndBoxPlot3_ECSB({Threshold_GT_SkSf(Threshold_GT_SkSf>0)/1e4/60 Threshold_GT_Safe(:,[1,2,3,4,5,6,7,8,9,11])/1e4/60},{[0.8 0.2 0.2] [.4,.6,.8]},...
    [1 2],{'Shock/Safe','Safe'},'paired',0,'showpoints',1);
%Wilcoxon Signed Rank Test because n=15 and paired data
ylabel('Conditioning session time at threshold (min)', 'FontSize', 22);
xlim([0.5 2.5])
ylim([0 75])
set(gca,'FontSize', 12,'linewidth',1.5)

subplot(1,2,2) % exclude mousenum 10 because no threshold detection was done
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Threshold_tpointFz_SkSf(Threshold_tpointFz_SkSf>0)*0.2/60 Threshold_tpointFz_Safe(Threshold_tpointFz_Safe>1)*0.2/60},{[0.8 0.2 0.2] [.4,.6,.8]},...
    [1 2],{'Shock/Safe','Safe'},'paired',0,'showpoints',1);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 4.3])
ylabel('Safe freezing time at threshold (min)', 'FontSize', 22);
set(gca,'FontSize', 12,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, '02_F_thresholds_absolute_time_large'), 'png');

%% Frequency values at threshold on freezing safe

for mousenum=[1,2,3,4,5,6,7,8,9,11]
    Threshold_freq_value_Safe(mousenum) = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(Threshold_tpointFz_Safe(mousenum));
end 

figure
clf
Vals = {Threshold_freq_value_Safe(Threshold_freq_value_Safe>0)'};
XPos = 1;

for k = 1
    X = Vals{k};
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',[.4,.6,.8],'lineColor',[.4,.6,.8],'medianColor',[.4,.6,.8],'boxWidth',0.4,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 10;
    a.handles.medianLines.XData=a.handles.medianLines.XData+[-.1 .1];
    alpha(.7)


    handlesplot=plotSpread(X,'distributionColors','k','xValues',XPos(k),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',22)
    handlesplot=plotSpread(X,'distributionColors','w','xValues',XPos(k),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',18)
    
end

xlim([0 2])
ylabel('Frequency values at threshold (Hz)','FontSize',12)
set(gca,'FontSize',12,'XTick',XPos,'XTickLabel',{'Threshold Safe'},'Ytick', [3.6:0.4:5.6],'linewidth',1.5)
box off
saveas(gcf, fullfile(SaveFigsTo, '02_G_freq_at_threshold'), 'png');


%% Compare the behavior of mice before and after the threshold

% To have the Blocked Epochs
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat', 'BlockedEpoch')

% Shock entry
for mousenum=1:length(Mouse_ALL)
    ALL.ShockFz_notBlocked.(ALL_Mouse_names{mousenum}) = EpochALL.Cond{mousenum,5}-BlockedEpoch.Cond.(ALL_Mouse_names{mousenum}); %timepoints of fz in shock zone without being blocked
    ALL.ShockActive_notBlocked.(ALL_Mouse_names{mousenum}) = EpochALL.Cond{mousenum,7}-BlockedEpoch.Cond.(ALL_Mouse_names{mousenum}); %timepoints active in shock zone without being blocked
    ALL.ShockEpoch_notBlocked.(ALL_Mouse_names{mousenum}) = or(ALL.ShockFz_notBlocked.(ALL_Mouse_names{mousenum}), ALL.ShockActive_notBlocked.(ALL_Mouse_names{mousenum})); % timepoints active or fz in shock zone not considering blocked epochs
end

for mousenum=1:length(Mouse_ALL)
    ALL.SafeFz_notBlocked.(ALL_Mouse_names{mousenum}) = EpochALL.Cond{mousenum,6}-BlockedEpoch.Cond.(ALL_Mouse_names{mousenum});
    ALL.SafeActive_notBlocked.(ALL_Mouse_names{mousenum}) = EpochALL.Cond{mousenum,8}-BlockedEpoch.Cond.(ALL_Mouse_names{mousenum});
    ALL.SafeEpoch_notBlocked.(ALL_Mouse_names{mousenum}) = or(ALL.SafeFz_notBlocked.(ALL_Mouse_names{mousenum}), ALL.SafeActive_notBlocked.(ALL_Mouse_names{mousenum})); 
end

for mousenum=1:length(Mouse_ALL)
    ALL.sk_entries.(ALL_Mouse_names{mousenum}) = Start(ALL.ShockEpoch_notBlocked.(ALL_Mouse_names{mousenum})); % ind of shock zone entries 
    ALL.safe_entries.(ALL_Mouse_names{mousenum}) = Start(ALL.SafeEpoch_notBlocked.(ALL_Mouse_names{mousenum})); % ind of safe zone entries 
    ALL.N_sk_entries.(ALL_Mouse_names{mousenum}) = length(Start(ALL.ShockEpoch_notBlocked.(ALL_Mouse_names{mousenum}))); % number of shock zone entries 
    ALL.N_safe_entries.(ALL_Mouse_names{mousenum}) = length(Start(ALL.SafeEpoch_notBlocked.(ALL_Mouse_names{mousenum}))); % number of safe zone entries 
end

% Nb of shock zone entries on GT before and after GT threshold on safe
for mousenum=1:length(Mouse_ALL)
    ALL.sk_entries.GT_Threshold.SafeFz.Before.(ALL_Mouse_names{mousenum}) = ALL.sk_entries.(ALL_Mouse_names{mousenum})(ALL.sk_entries.(ALL_Mouse_names{mousenum}) < Threshold_GT_Safe(mousenum));
    ALL.N_sk_entries.GT_Threshold.SafeFz.Before.(ALL_Mouse_names{mousenum}) = length(ALL.sk_entries.GT_Threshold.SafeFz.Before.(ALL_Mouse_names{mousenum})); % number of shock zone entries 
    ALL.sk_entries.GT_Threshold.SafeFz.After.(ALL_Mouse_names{mousenum}) = ALL.sk_entries.(ALL_Mouse_names{mousenum})(ALL.sk_entries.(ALL_Mouse_names{mousenum}) > Threshold_GT_Safe(mousenum));
    ALL.N_sk_entries.GT_Threshold.SafeFz.After.(ALL_Mouse_names{mousenum}) = length(ALL.sk_entries.GT_Threshold.SafeFz.After.(ALL_Mouse_names{mousenum})); % number of shock zone entries 
    Norm_min_before(mousenum) = Threshold_GT_Safe(mousenum)/1e4/60;
    Norm_min_after(mousenum) = (max(Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}))-Threshold_GT_Safe(mousenum))/1e4/60;
    N_sk_entries.GT_Thr.Safe.Before(:,mousenum) = ALL.N_sk_entries.GT_Threshold.SafeFz.Before.(ALL_Mouse_names{mousenum})/Norm_min_before(mousenum);
    N_sk_entries.GT_Thr.Safe.After(:,mousenum) = ALL.N_sk_entries.GT_Threshold.SafeFz.After.(ALL_Mouse_names{mousenum})/Norm_min_after(mousenum);
end

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({N_sk_entries.GT_Thr.Safe.Before  N_sk_entries.GT_Thr.Safe.After},{[.4,.6,.8]*0.5 [.4,.6,.8]},...
    [1 2],{'Before threshold, Safe','After threshold, Safe'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Number of shock zone entries before and after threshold on Tfz safe', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'linewidth',1.5)
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_vs_Inst_fz_safe_skewness_final'), 'png');

% Nb of shock zone entries on Tfz before and after Tfz threshold on safe

% Align all the timepoints that correspond more or less to the shock zone entries with OB frequency during safe freezing  
for mousenum=1:length(Mouse_ALL)
    for i=1:length(ALL.sk_entries.(ALL_Mouse_names{mousenum}))
        ALL.sk_entries.TFzSafe_Threshold.SafeFz.(ALL_Mouse_names{mousenum})(i) = sum(ALL.sk_entries.(ALL_Mouse_names{mousenum})(i)>ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}));
    end
    ALL.sk_entries.TFzSafe_Threshold.SafeFz.(ALL_Mouse_names{mousenum})=unique(ALL.sk_entries.TFzSafe_Threshold.SafeFz.(ALL_Mouse_names{mousenum}));
end

% Compute nb of shock zone entries
for mousenum=1:length(Mouse_ALL)
    ALL.sk_entries.TFzSafe_Threshold.SafeFz.Before.(ALL_Mouse_names{mousenum}) = ALL.sk_entries.TFzSafe_Threshold.SafeFz.(ALL_Mouse_names{mousenum})(ALL.sk_entries.TFzSafe_Threshold.SafeFz.(ALL_Mouse_names{mousenum}) < Threshold_tpointFz_Safe(mousenum));
    ALL.N_sk_entries.TFzSafe_Threshold.SafeFz.Before.(ALL_Mouse_names{mousenum}) = length(ALL.sk_entries.TFzSafe_Threshold.SafeFz.Before.(ALL_Mouse_names{mousenum})); % number of shock zone entries 
    ALL.sk_entries.TFzSafe_Threshold.SafeFz.After.(ALL_Mouse_names{mousenum}) = ALL.sk_entries.TFzSafe_Threshold.SafeFz.(ALL_Mouse_names{mousenum})(ALL.sk_entries.TFzSafe_Threshold.SafeFz.(ALL_Mouse_names{mousenum}) > Threshold_tpointFz_Safe(mousenum));
    ALL.N_sk_entries.TFzSafe_Threshold.SafeFz.After.(ALL_Mouse_names{mousenum}) = length(ALL.sk_entries.TFzSafe_Threshold.SafeFz.After.(ALL_Mouse_names{mousenum})); % number of shock zone entries 
    Norm_min_before(mousenum) = Threshold_tpointFz_Safe(mousenum)*0.2/60;
    Norm_min_after(mousenum) = (length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))-Threshold_tpointFz_Safe(mousenum))*0.2/60;
    N_sk_entries.TFzSafe_Threshold.Safe.Before(:,mousenum) = ALL.N_sk_entries.TFzSafe_Threshold.SafeFz.Before.(ALL_Mouse_names{mousenum})/Norm_min_before(mousenum);
    N_sk_entries.TFzSafe_Threshold.Safe.After(:,mousenum) = ALL.N_sk_entries.TFzSafe_Threshold.SafeFz.After.(ALL_Mouse_names{mousenum})/Norm_min_after(mousenum);
end

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({N_sk_entries.TFzSafe_Threshold.Safe.Before(:,[1:9,11])...
    N_sk_entries.TFzSafe_Threshold.Safe.After(:,[1:9,11])},{[.1,.3,.7] [.4,.6,.8]},...
    [1 2],{'Before threshold','After threshold'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Density of shock zone entries (#/min)', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'FontSize', 12,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, '02_H_density_skentries'), 'png');

% Plot Sk zone entries

figure
for mousenum=1:length(Mouse_ALL)
    subplot(4,3,mousenum)
    plot(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})), hold on
    plot(All_sig_tpointFz_Safe.(ALL_Mouse_names{mousenum}), max(Spect_RunMeanFq_mouse)+1 , '.k')
    vline(ALL.sk_entries.TFzSafe_Threshold.SafeFz.(ALL_Mouse_names{mousenum}));
    ylim([0 8])
    hold on
    line([Threshold_tpointFz_Safe(mousenum) Threshold_tpointFz_Safe(mousenum)],ylim)
end


figure
for mousenum=3
    clear All_Time Spect_RunMeanFq_mouse
    ALL_Time.SafeFz = (1:length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    Spect_RunMeanFq_mouse = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    
    p1 = plot(ALL_Time.SafeFz, ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',[.4,.6,.8]); hold on
    p2 = plot(All_sig_tpointFz_Safe.(ALL_Mouse_names{mousenum})*0.2, max(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))+1 , '.','Color',[.4,.6,.8]*0.5);
    hold on
    p3 = line([Threshold_tpointFz_Safe(mousenum)*0.2 Threshold_tpointFz_Safe(mousenum)*0.2], [3.5 6.5],'Color',[.4,.6,.8]*0.5, 'Linewidth', 2, 'Linestyle','--');
    p4 = vline([ALL.sk_entries.TFzSafe_Threshold.SafeFz.(ALL_Mouse_names{mousenum})*0.2], 'r');
    makepretty
    
    ylabel('Frequency (Hz)', 'FontSize', 18);
    xlabel('Time freezing (s)', 'FontSize', 18);
    leg=legend([p4(1),p1,p2(1),p3],{'Shock zone entries', 'Safe', 'Timepoints below threshold, Safe dynamic range method', 'Time at threshold'}, 'FontSize', 12, 'Location', 'southwest');
%     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
%     title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2.5 6.5])
    set(gca, 'FontSize', 14, 'Ytick', [3:1:6])
end
saveas(gcf, fullfile(SaveFigsTo, '02_S3_ex_threshold_safe_final_sk_entries'), 'png');










