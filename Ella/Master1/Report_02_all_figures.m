%% Objectives of this code (part II report)

%Take a look at the test pre and post session to assess the learning of mice

%%% Shift during freezing safe along normalized time and frequency for all mice
%%% Parameters that influence OB frequency: ripples, shocks, shock zone entries (not in the report)

% Two methods of defining the threshold
%%% 1: Shock vs Safe freezing
%%% 2: Dynamic range of the safe freezing 

% Comparison of the temporal occurence of thresholds ==> method 2 selected
%%% Behavior (nb of sk zone entries/min) before and after the threshold

%% Paths
SaveFigsTo = '/home/gruffalo/Link to Dropbox/Kteam/PrgMatlab/Ella/Analysis_Figures/New_freq_measurement';

%% Selected mice

%from
%Mouse_gr1=[688 739 777 779 849 893] % group1: saline mice, long protocol, SB
%Mouse_gr5=[1170 1171 9184 1189 9205 1391 1392 1393 1394] % group 5: saline short BM first Maze

%to
Mouse_ALL_Test=[688 739 777 779 849 893 1170 1171 9184 1189 9205 1391 1392 1393 1394]; 


%% Part II: Analysis of the model 
% and justify the one selected to analyse the shift and implement the model 

%% Extract data for all mice
Session_type={'TestPre', 'Cond', 'TestPost'};
for sess=1:length(Session_type) % generate all data required for analyses
    [ALL_TSD_DATA.(Session_type{sess}) , EpochALL.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_ALL_Test,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition', 'instfreq');
end

%% Take a look at the test pre and post session to assess the learning of mice

% Pre 
for mousenum=1:length(Mouse_ALL_Test);
    Mouse_names_Test{mousenum}=['M' num2str(Mouse_ALL_Test(mousenum))];
    Percent_Time.TestPre.Shock.(Mouse_names_Test{mousenum}) = 100*(sum(DurationEpoch(EpochALL.TestPre{mousenum,5}))+ sum(DurationEpoch(EpochALL.TestPre{mousenum,7})))/sum(DurationEpoch(EpochALL.TestPre{mousenum,1}));
    Percent_Time.TestPre.Safe.(Mouse_names_Test{mousenum}) = 100*(sum(DurationEpoch(EpochALL.TestPre{mousenum,6}))+ sum(DurationEpoch(EpochALL.TestPre{mousenum,8})))/sum(DurationEpoch(EpochALL.TestPre{mousenum,1}));
    Percent_Time.TestPre.comparison(mousenum,1) = Percent_Time.TestPre.Shock.(Mouse_names_Test{mousenum});
    Percent_Time.TestPre.comparison(mousenum,2) = Percent_Time.TestPre.Safe.(Mouse_names_Test{mousenum});
end

% Post
for mousenum=1:length(Mouse_ALL_Test);
    Mouse_names_Test{mousenum}=['M' num2str(Mouse_ALL_Test(mousenum))];
    Percent_Time.TestPost.Shock.(Mouse_names_Test{mousenum}) = 100*(sum(DurationEpoch(EpochALL.TestPost{mousenum,5}))+ sum(DurationEpoch(EpochALL.TestPost{mousenum,7})))/sum(DurationEpoch(EpochALL.TestPost{mousenum,1}));
    Percent_Time.TestPost.Safe.(Mouse_names_Test{mousenum}) = 100*(sum(DurationEpoch(EpochALL.TestPost{mousenum,6}))+ sum(DurationEpoch(EpochALL.TestPost{mousenum,8})))/sum(DurationEpoch(EpochALL.TestPost{mousenum,1}));
    Percent_Time.TestPost.comparison(mousenum,1) = Percent_Time.TestPost.Shock.(Mouse_names_Test{mousenum});
    Percent_Time.TestPost.comparison(mousenum,2) = Percent_Time.TestPost.Safe.(Mouse_names_Test{mousenum});
end

% Compare time spent in Safe/Shock during pre 
figure
[Timepre_pval , Timepre_stats_out]= MakeSpreadAndBoxPlot3_SB({Percent_Time.TestPre.comparison(:,1) Percent_Time.TestPre.comparison(:,2)},...
    {[1 0 0],[0 0 1]},[1 2],{'Shock','Safe'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
makepretty
title('% time in Shock and Safe zone during Pre Cond session', 'FontSize', 25);

% Compare time spent in Safe/Shock during post 
figure
[Timepost_pval , Timepost_stats_out]= MakeSpreadAndBoxPlot3_SB({Percent_Time.TestPost.comparison(:,1) Percent_Time.TestPost.comparison(:,2)},...
    {[1 0 0],[0 0 1]},[1 2],{'Shock','Safe'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
makepretty
title('% time in Shock and Safe zone during Post Cond session', 'FontSize', 25);

% Compare time spent in Shock during pre/post 
figure
[Timesk_pval , Timesk_stats_out]= MakeSpreadAndBoxPlot3_SB({Percent_Time.TestPre.comparison(:,1) Percent_Time.TestPost.comparison(:,1)},...
    {[1 0 0],[0 0 1]},[1 2],{'Shock Pre','Shock Post'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
makepretty
title('% time in Shock zone during Pre and Post Cond session', 'FontSize', 25);

% Time freezing
for mousenum=1:length(Mouse_ALL_Test);
    Mouse_names_Test{mousenum}=['M' num2str(Mouse_ALL_Test(mousenum))];
    A(mousenum) = sum(DurationEpoch(EpochALL.Cond{mousenum,6}))/1e4;
end

% Which mice we should exclude and based on what criterion? 

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
saveas(gcf, fullfile(SaveFigsTo, 'ALL_02_shift_fzsafe_large'), 'png');

%% 2/ Parameters that influence OB frequency

%[m,s,tps]=mETAverage(e,t,v,binsize,nbBins)
% Input:
% e       : times of events
% t       : time of the values  - in 1/10000 sec (assumed to be sorted)
% v       : values
% binsize : size of the bin in ms
% nbBins  : number of bins
% 
% Output:
% m   : mean
% S   : standard error
% tps : times
% aligns all the events at the middle of the bins and computes the mean
% values before and after each event

% Look at the correlation between OB frequency and ripples across time
% Code does not work except if OB freq is restricted to the first 1000
% timepoints

% Align all the timepoints that correspond more or less to the ripples with a frequency  
for mousenum=[1 2 3 4 6 8 9 10 11]
    for i=1:length(ALL.Spect.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum})) 
        ALL_Ind_Match_SafeFz.(ALL_Mouse_names{mousenum})(i) = sum(ALL.Spect.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum})(i)>ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}));
    end
    ALL_Ind_Match_SafeFz.(ALL_Mouse_names{mousenum}) = ALL_Ind_Match_SafeFz.(ALL_Mouse_names{mousenum})(ALL_Ind_Match_SafeFz.(ALL_Mouse_names{mousenum}) < 999);
    %Ind Match adapted to fit whithin the first 1000 timepoints of freezing safe
end

% Compute the density of ripples
for mousenum=[1 2 3 4 6 8 9 10 11]
    for i=1:20:(floor(max(ALL_Ind_Match_SafeFz.(ALL_Mouse_names{mousenum}))./20)*20)+1   
        ALL_N_RipplesFzsafe.(ALL_Mouse_names{mousenum})(i) = sum(i<= ALL_Ind_Match_SafeFz.(ALL_Mouse_names{mousenum}) & ALL_Ind_Match_SafeFz.(ALL_Mouse_names{mousenum}) <= i+20)/4;
        ALL_N_RipplesFzsafe.(ALL_Mouse_names{mousenum})(i+1:i+20)=NaN;
        ALL_Normalized_RipplesFzsafe.(ALL_Mouse_names{mousenum}) = ALL_N_RipplesFzsafe.(ALL_Mouse_names{mousenum})/nanmean(ALL_N_RipplesFzsafe.(ALL_Mouse_names{mousenum}));
        ALL_Norm_noNaN_RipplesFzSafe.(ALL_Mouse_names{mousenum})= ALL_Normalized_RipplesFzsafe.(ALL_Mouse_names{mousenum})(~isnan((ALL_Normalized_RipplesFzsafe.(ALL_Mouse_names{mousenum}))));
    end
end

% Compute the mean OB frequency during 4s timebins (same bin as the ripples density)
% clear ALL_OB_Mean_Freq_20X ALL_BinMean_Freq_FzSafe
for mousenum=[1 2 3 4 6 8 9 10 11]
    clear i ind
    ALL_OB_Mean_Freq_20X.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(1:(floor(length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))./20)*20));
    for i=1:20:length(ALL_OB_Mean_Freq_20X.(ALL_Mouse_names{mousenum}))
        try
            ALL_BinMean_Freq_FzSafe.(ALL_Mouse_names{mousenum})(i) = nanmean(ALL_OB_Mean_Freq_20X.(ALL_Mouse_names{mousenum})(i:i+20));
        end
        ind=ALL_BinMean_Freq_FzSafe.(ALL_Mouse_names{mousenum})==0;
        ALL_BinMean_Freq_FzSafe.(ALL_Mouse_names{mousenum})(ind)=NaN;
        ALL_BinMean_Freq_FzSafe.(ALL_Mouse_names{mousenum}) = ALL_BinMean_Freq_FzSafe.(ALL_Mouse_names{mousenum})(~isnan((ALL_BinMean_Freq_FzSafe.(ALL_Mouse_names{mousenum}))));
    end
end

fig=figure;
for mousenum=[1 2 3 4 6 8 9 10 11]
    mouse=ALL_Mouse_names(mousenum);
    clear ALL_Corr_mouse ALL_Ripples_corr_mouse ALL_Freq_corr_mouse ALL_Time_Binned_mouse
    ALL_Freq_corr_mouse = ALL_BinMean_Freq_FzSafe.(ALL_Mouse_names{mousenum});
    ALL_Ripples_corr_mouse = ALL_Norm_noNaN_RipplesFzSafe.(ALL_Mouse_names{mousenum});
%     if length(ALL_BinMean_Freq_FzSafe.(ALL_Mouse_names{mousenum})) ~= length(ALL_Norm_noNaN_RipplesFzSafe.(ALL_Mouse_names{mousenum}))
%         ALL_Ripples_corr_mouse(end) = [];
%     end
    ALL_Time_Binned_mouse = length(ALL_OB_Mean_Freq_20X.(ALL_Mouse_names{mousenum}));
    
    subplot(3,3,mousenum)
    sz = 50;
    c = (1:20:ALL_Time_Binned_mouse)*0.2;
    scatter(ALL_Freq_corr_mouse, ALL_Ripples_corr_mouse, sz, c, 'filled');
    colorbar
    axis square
%     heatmap(ALL_Corr_mouse);
    title(mouse)
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Ripples normalized density', 'FontSize', 25);
xlabel(han,'OB mean frequency', 'FontSize', 25);
title(han,'Correlation between OB frequency during safe freezing and ripples density', 'FontSize', 30);

% Ripples

for mousenum=1:length(Mouse_ALL)
    ALL.Ind_nan.Ind_OB.(ALL_Mouse_names{mousenum}) = isnan(ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}));
    ALL.Ind_nan.RunMeanFq.(ALL_Mouse_names{mousenum}) = isnan(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    ALL.Ind_nonan.Ind_OB.(ALL_Mouse_names{mousenum}) = ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum})(~ALL.Ind_nan.Ind_OB.(ALL_Mouse_names{mousenum}));
    ALL.Ind_nonan.RunMeanFq.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(~ALL.Ind_nan.RunMeanFq.(ALL_Mouse_names{mousenum}));
end 

binsize=20;
nbBins=50;
clear row
row=1;
for mousenum=[1 2 3 4 6 8 9 10 11] % Indices of mouse that have ripples
    [ALL.Spect.mETAverage.Ripples.(ALL_Mouse_names{mousenum}),~,~]=mETAverage(ALL.Spect.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum}),...
        ALL.Ind_nonan.Ind_OB.(ALL_Mouse_names{mousenum}),ALL.Ind_nonan.RunMeanFq.(ALL_Mouse_names{mousenum}),binsize,nbBins);
    Data_mETAverage.Ripples(row,:) = ALL.Spect.mETAverage.Ripples.(ALL_Mouse_names{mousenum})';
    row=row+1;
end 

figure;
row=1;
for mousenum=[1 2 3 4 6 8 9 10 11] % Indices of mouse that have ripples
    subplot(4,3,row)
    plot(1:51,Data_mETAverage.Ripples(row,:))
    row=row+1;
end 

Conf_Inter_Ripples=nanstd(Data_mETAverage.Ripples)/sqrt(size(Data_mETAverage.Ripples,1));

figure;
shadedEB = shadedErrorBar(1:nbBins+1, ...
    nanmean(Data_mETAverage.Ripples), Conf_Inter_Ripples, 'k', 0);
makepretty
set(shadedEB.edge,'LineWidth',2)
shadedEB.mainLine.LineWidth = 2;
shadedEB.mainLine.Color = [.1,.3,.5];
shadedEB.patch.FaceColor = [.4,.6,.8];
shadedEB.edge(1).Color = [.4,.6,.8];
shadedEB.edge(2).Color = [.4,.6,.8];
xlabel('Normalized Time freezing', 'FontSize', 25);
ylabel('Normalized Frequency', 'FontSize', 25);
xlim([-1 53])
ylim([3.8 4.8])
line([26 26], [3 5], 'Color', [.7,.7,.7],'LineWidth',2)
saveas(gcf, fullfile(SaveFigsTo, 'ALL_02_shift_fzsafe_large'), 'png');

% To have the Blocked Epochs
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat', 'BlockedEpoch')

% Shock

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

% What Baptiste tried : mET without runmean and Plot Rip Raw 

for mouse=1:11
    try
        subplot(4,3,mouse)
        [M,T] = PlotRipRaw(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,6} , Range(ALL_TSD_DATA.Cond.ripples.ts{mouse, 6})/1e4, 1000, 0, 0, 0);
        T(T==0)=NaN;
        plot(nanmean(T))
    end
end

for mouse=1:11
    try
        [m,s,tps] = mETAverage(Range(ALL_TSD_DATA.Cond.ripples.ts{mouse, 6}),Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,6}),Data(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,6}),20,100)
        subplot(4,3,mouse)
        plot(linspace(1,101,101),runmean_BM(m,3))
%         plot(linspace(1,51,51),m)
    end
end

%% B : 2 definitions of the threshold of OB frequency shift

%% 1/ According to freezing shock 

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

% Extract thresholds of fz time : first index for which the difference between
% freezing shock and safe is significative (alpha=0.02) and stable during
% at least 20 seconds of freezing concatenated epoch
timesig=200;
for mousenum=1:length(Mouse_ALL)
    clear indj 
    indj=1;
    for j=1:length(ALL_h_Fsk_Fsafe(mousenum,:))-timesig
        if sum(ALL_h_Fsk_Fsafe(mousenum,j:j+timesig)) == timesig+1
            All_sigstable_tpointFz_SkSf(mousenum,indj) = j;
            indj = indj+1;
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

fig=figure;
colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
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
    
    plot(ALL_Time.ShockFz, ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot(ALL_Time.SafeFz, ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(2,:)), hold on
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

%% 2/ According to freezing safe alone

% Thresholds on freezing safe
for mousenum=1:length(Mouse_ALL)
    clear Spect_RunMeanFq_mouse 
    Spect_RunMeanFq_mouse = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    All_sig_tpointFz_Safe.(ALL_Mouse_names{mousenum}) = find(Spect_RunMeanFq_mouse<((0.9*(max(Spect_RunMeanFq_mouse)-min(Spect_RunMeanFq_mouse))/2)+min(Spect_RunMeanFq_mouse)));
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

%% Compare the timepoints of thresholds with the two methods 

% Percentages
figure
subplot(1,2,1)
[pval_tfz , stats_out_tfz]= MakeSpreadAndBoxPlot3_ECSB({Percent_GT_SkSf(Percent_GT_SkSf>0) Percent_GT_Safe},{[0.8 0.2 0.2] [.4,.6,.8]},...
    [1 2],{'Threshold on Shock/Safe','Threshold on Safe'},'paired',0,'showpoints',1);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
% ylabel('Values of the 25th percentile of OB frequencies (Hz)', 'FontSize', 25);
ylabel('% of conditioning session time at which the threshold occurs', 'FontSize', 22);
xlim([0.5 2.5])
ylim([0 100])
set(gca,'FontSize', 20,'linewidth',1.5)

subplot(1,2,2)
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Percent_tFz_SkSf(Percent_tFz_SkSf>0) Percent_tFz_Safe(Percent_tFz_Safe>1)},{[0.8 0.2 0.2] [.4,.6,.8]},...
    [1 2],{'Threshold on Shock/Safe','Threshold on Safe'},'paired',0,'showpoints',1);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 100])
ylabel('% of safe freezing time at which the threshold occurs', 'FontSize', 22);
set(gca,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, 'ALL_02_thresholds_percent_time_large'), 'png');

% Absolute time
figure
subplot(1,2,1) % exclude mice for which no significative difference was found
[pval_tfz , stats_out_tfz]= MakeSpreadAndBoxPlot3_ECSB({Threshold_GT_SkSf(Threshold_GT_SkSf>0)/1e4/60 Threshold_GT_Safe/1e4/60},{[0.8 0.2 0.2] [.4,.6,.8]},...
    [1 2],{'Threshold on Shock/Safe','Threshold on Safe'},'paired',0,'showpoints',1);
%Wilcoxon Signed Rank Test because n=15 and paired data
ylabel('Conditioning session time at which the threshold occurs (min)', 'FontSize', 22);
xlim([0.5 2.5])
ylim([0 75])
set(gca,'FontSize', 20,'linewidth',1.5)

subplot(1,2,2) % exclude mousenum 10 because no threshold detection was done
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Threshold_tpointFz_SkSf(Threshold_tpointFz_SkSf>0)*0.2/60 Threshold_tpointFz_Safe(Threshold_tpointFz_Safe>1)*0.2/60},{[0.8 0.2 0.2] [.4,.6,.8]},...
    [1 2],{'Threshold on Shock/Safe','Threshold on Safe'},'paired',0,'showpoints',1);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 4.3])
ylabel('Safe freezing time at which the threshold occurs (min)', 'FontSize', 22);
set(gca,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, 'ALL_02_thresholds_absolute_time_large'), 'png');


%% Compare the behavior of mice before and after the threshold

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
    [1 2],{'Before thresholdod, Safe','After threshold, Safe'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Density of shock zone entries on safe time freezing (#/min)', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, 'ALL_02_density_skentries'), 'png');













