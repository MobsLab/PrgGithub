%% Objectives of this code (part I of the report)

% Comparison between Peak and trough method and Spectrogram method
%%% Comparison (signals for all mice) and correlation (2D hist)
%%% Computed shift in frequency
%%% Variability of the measures
%%% IQ range and 25, 75th percentiles

% Comparison between Camera and Accelerometer freezing
%%% Sensitivity (% time fz, nb and duration of episodes)
%%% Specificity and ratio between the time spent freezing shock/safe side
%%% Comparison of raw signals
%%% Computed shifts 

%% Paths
SaveFigsTo = '/home/gruffalo/Link to Dropbox/Kteam/PrgMatlab/Ella/Analysis_Figures/New_freq_measurement';

%% Selected mice

%from
%Mouse_gr1=[688 739 777 779 849 893] % group1: saline mice, long protocol, SB
%Mouse_gr5=[1170 1171 9184 1189 9205 1391 1392 1393 1394] % group 5: saline short BM first Maze

%to
Mouse_ALL=[688 739 777 779 849 893 1170 1171 9184 1189 9205 1391 1392 1393 1394]; 

%% Part I : compare the ways of measuring the respiratory related frequency 
% and justify the one selected to analyse the shift and implement the model 

%% Extract data for all mice
Session_type={'Cond', 'TestPost'};
for sess=1:length(Session_type) % generate all data required for analyses
    [ALL_TSD_DATA.(Session_type{sess}) , EpochALL.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_ALL,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition', 'instfreq');
end

%% A/ Freeezing accelerometer

%% Frequency generated instantaneously with the signal 

% Compute OB frequency and ripples during freezing shock
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,5});
    if isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.Inst.Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,5});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}) == 0
        ALL.Inst.Ind_Ripples.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}); 
    end
end

% Compute OB frequency and ripples during freezing safe
for mousenum=1:length(Mouse_ALL)
    ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,6});
    if isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Inst.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,6});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}) == 0
        ALL.Inst.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
    end
end

% Plot INST freezing shock and safe for all mice
fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)
    plot((1:length(ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})))*0.2, ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot((1:length(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2, ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(1,:)), hold on
    title(mouse)
    legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Inst frequencies during shock and safe side freezing', 'FontSize', 30);

% Plot INST freezing shock and safe for example mice
Example_mice = [688, 1189]; % add 849
fig=figure;
Color = [0.9 0.9 0.9];
Colfact = [1,0.8];
for mousenum=1:length(Example_mice)
    Example_mice_names{mousenum} = ['M' num2str(Example_mice(mousenum))];
    subplot(2,1,mousenum)
    plot((1:length(ALL.Inst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2, ALL.Inst.RunMeanFq.ShockFz.(Example_mice_names{mousenum}),'Color',Color*Colfact(mousenum)), hold on
    plot((1:length(ALL.Inst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, ALL.Inst.RunMeanFq.SafeFz.(Example_mice_names{mousenum}),'Color',Color*Colfact(mousenum)), hold on
    title(Example_mice_names(mousenum));
    legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Inst frequencies during shock and safe side freezing', 'FontSize', 30);

%% Frequency generated with the spectrogram (respi_freq_BM)

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

% Plot SPECT freezing shock and safe for all mice
fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)
    plot((1:length(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})))*0.2, ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot((1:length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2, ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(1,:)), hold on
    title(mouse)
    legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Spect frequencies during shock and safe side freezing', 'FontSize', 30);

% Plot SPECT freezing shock and safe for example mice
Example_mice = [688, 1189];
fig=figure;
%     colors = rand([n 3]);
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Example_mice)
    Example_mice_names{mousenum} = ['M' num2str(Example_mice(mousenum))];
    subplot(2,1,mousenum)
    plot((1:length(ALL.Spect.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2, ALL.Spect.RunMeanFq.ShockFz.(Example_mice_names{mousenum}),'Color',colors(3,:)), hold on
    plot((1:length(ALL.Spect.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, ALL.Spect.RunMeanFq.SafeFz.(Example_mice_names{mousenum}),'Color',colors(1,:)), hold on
    title(Example_mice_names(mousenum));
    legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Spect frequencies during shock and safe side freezing', 'FontSize', 30);

%% 1/ Comparison 

% Compute restricted frequency from spectrogram to instantaneous
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL.RestSpect_toInst.Epoch.ShockFz.(ALL_Mouse_names{mousenum}) = Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5}, ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,5});
    ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = Data(ALL.RestSpect_toInst.Epoch.ShockFz.(ALL_Mouse_names{mousenum}));
    if isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1))
        ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(end))
        ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.RestSpect_toInst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.RestSpect_toInst.Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL.RestSpect_toInst.Epoch.ShockFz.(ALL_Mouse_names{mousenum}));
%     if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}) == 0
%         ALL.Spect.Ind_Ripples.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}); 
%     end
end

% Compute restricted frequency from spectrogram to instantaneous
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL.RestSpect_toInst.Epoch.SafeFz.(ALL_Mouse_names{mousenum}) = Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6}, ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,6});
    ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = Data(ALL.RestSpect_toInst.Epoch.SafeFz.(ALL_Mouse_names{mousenum}));
    if isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1))
        ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(end))
        ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.RestSpect_toInst.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL.RestSpect_toInst.Epoch.SafeFz.(ALL_Mouse_names{mousenum}));
%     if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}) == 0
%         ALL.Spect.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
%     end
end

% Compare the signals inst and spect for all mice
fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)
    plot((1:length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2, ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(2,:)), hold on
    plot((1:length(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2, ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(1,:)), hold on
    ylim([0.5 7])
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Timepoints freezing', 'FontSize', 25);
title(han,'Spect (blue) vs Inst (green) frequencies during safe side freezing', 'FontSize', 25);

% Compare the signals inst and spect for example mice
Example_mice = [688, 1189];
fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Example_mice)
    Example_mice_names{mousenum} = ['M' num2str(Example_mice(mousenum))];
    subplot(2,1,mousenum)
    plot((1:length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum}),'Color',colors(2,:)), hold on
    plot((1:length(ALL.Inst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, ALL.Inst.RunMeanFq.SafeFz.(Example_mice_names{mousenum}),'Color',colors(1,:)), hold on
    title(Example_mice_names(mousenum));
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Spect (blue) vs Inst (green) frequencies during safe side freezing', 'FontSize', 25);

%% 2/ Correlations

% Plot instantaneous data vs restricted spectrogram data

% For all mice
fig=figure;
for mousenum=1:8
    mouse=ALL_Mouse_names(mousenum);
    subplot(2,4,mousenum)
    square=[2.5 7.5];
    plot(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), '.k')
    axis square
    line(square,square,'LineStyle','--','Color','r','LineWidth',4)
    xlim(square), ylim(square)
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Instantaneous measured frequecies', 'FontSize', 25);
xlabel(han,'Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)', 'FontSize', 25);
title(han,'Correlation between Inst and Spect measured frequencies', 'FontSize', 30);

fig=figure;
for mousenum=8:15
    mouse=ALL_Mouse_names(mousenum);
    subplot(2,4,mousenum-7)
    square=[2.5 7.5];
    plot(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), '.k')
    axis square
    line(square,square,'LineStyle','--','Color','r','LineWidth',4)
    xlim(square), ylim(square)
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Instantaneous measured frequecies', 'FontSize', 25);
xlabel(han,'Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)', 'FontSize', 25);
title(han,'Correlation between Inst and Spect measured frequencies', 'FontSize', 30);

for mousenum=1:length(Mouse_ALL)
    ALL_HistInd_SafeFz_Freqband.(ALL_Mouse_names{mousenum}) = and(and(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})<7,ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})>1), and(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})<7,ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})>1));
end

% 2D Histogram
% For a given mouse
for mousenum=1
    mouse=ALL_Mouse_names(mousenum);
    % generate spectrogram data restricted to band 1-7Hz for a mouse
    ALL_ResFreq_SpectoInst_SafeFz_mouse = ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    ALL_HistInd_SafeFz_Freqband_mouse = ALL_HistInd_SafeFz_Freqband.(ALL_Mouse_names{mousenum});
    ALL_ResBandFreq_SpectoInst_SafeFz_mouse = ALL_ResFreq_SpectoInst_SafeFz_mouse(ALL_HistInd_SafeFz_Freqband_mouse);
    % generate instantaneous data restricted to band 1-7Hz for a mouse
    ALL_Inst_Freq_Respi_SafeFz_mouse = ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    ALL_Inst_BandFreq_Respi_SafeFz_mouse = ALL_Inst_Freq_Respi_SafeFz_mouse(ALL_HistInd_SafeFz_Freqband_mouse);
end

figure
H = hist2d([ALL_ResBandFreq_SpectoInst_SafeFz_mouse; [1 1 7 7]'],[ALL_Inst_BandFreq_Respi_SafeFz_mouse; [1 7 1 7]'],30,30);
imagesc(linspace(1,7,30) , linspace(1,7,30) , SmoothDec(H,.7)'), axis xy, axis square
line([0 7],[0 7],'LineStyle','--','Color','r','LineWidth',5)
colorbar
caxis
xlabel('Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)')
ylabel('Instantaneous measured frequecies (Hz)')
title(mouse)

% 2D Histogram for all mice
fig=figure;
for mousenum=1:8
    mouse=ALL_Mouse_names(mousenum);
    subplot(2,4,mousenum)
    
    % generate spectrogram data restricted to band 1-7Hz for a mouse
    ALL_ResFreq_SpectoInst_SafeFz_mouse = ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    ALL_HistInd_SafeFz_Freqband_mouse = ALL_HistInd_SafeFz_Freqband.(ALL_Mouse_names{mousenum});
    ALL_ResBandFreq_SpectoInst_SafeFz_mouse = ALL_ResFreq_SpectoInst_SafeFz_mouse(ALL_HistInd_SafeFz_Freqband_mouse);
    % generate instantaneous data restricted to band 1-7Hz for a mouse
    ALL_Inst_Freq_Respi_SafeFz_mouse = ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    ALL_Inst_BandFreq_Respi_SafeFz_mouse = ALL_Inst_Freq_Respi_SafeFz_mouse(ALL_HistInd_SafeFz_Freqband_mouse);
    
    H = hist2d([ALL_ResBandFreq_SpectoInst_SafeFz_mouse; [1 1 7 7]'],[ALL_Inst_BandFreq_Respi_SafeFz_mouse; [1 7 1 7]'],30,30);
    imagesc(linspace(1,7,30) , linspace(1,7,30) , SmoothDec(H,.7)'), axis xy, axis square
    line([0 7],[0 7],'LineStyle','--','Color','r','LineWidth',5);
    colorbar
    caxis
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Instantaneous measured frequecies', 'FontSize', 25);
xlabel(han,'Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)', 'FontSize', 25);
title(han,'', 'FontSize', 30);

fig=figure;
for mousenum=8:15
    mouse=ALL_Mouse_names(mousenum);
    subplot(2,4,mousenum-7)
    
    % generate spectrogram data restricted to band 1-7Hz for a mouse
    ALL_ResFreq_SpectoInst_SafeFz_mouse = ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    ALL_HistInd_SafeFz_Freqband_mouse = ALL_HistInd_SafeFz_Freqband.(ALL_Mouse_names{mousenum});
    ALL_ResBandFreq_SpectoInst_SafeFz_mouse = ALL_ResFreq_SpectoInst_SafeFz_mouse(ALL_HistInd_SafeFz_Freqband_mouse);
    % generate instantaneous data restricted to band 1-7Hz for a mouse
    ALL_Inst_Freq_Respi_SafeFz_mouse = ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum});
    ALL_Inst_BandFreq_Respi_SafeFz_mouse = ALL_Inst_Freq_Respi_SafeFz_mouse(ALL_HistInd_SafeFz_Freqband_mouse);
    
    H = hist2d([ALL_ResBandFreq_SpectoInst_SafeFz_mouse; [3 3 7 7]'],[ALL_Inst_BandFreq_Respi_SafeFz_mouse; [3 7 3 7]'],30,30);
    imagesc(linspace(3,7,30) , linspace(3,7,30) , H'), axis xy, axis square
%     imagesc(linspace(1,7,30) , linspace(1,7,30) , SmoothDec(H,.7)'), axis xy, axis square
    line([0 7],[0 7],'LineStyle','--','Color','r','LineWidth',5);
    colorbar
    caxis
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Instantaneous measured frequecies', 'FontSize', 25);
xlabel(han,'Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)', 'FontSize', 25);
title(han,'Spect frequencies during shock and safe side freezing (Hz)', 'FontSize', 30);


Example_mice = [1189];
figure;
Color = [0.8 0.5 0.3; 0.3 0.4 0.7];
% Colfact = [1,0.7];
for mousenum=1:length(Example_mice)
    Example_mice_names{mousenum} = ['M' num2str(Example_mice(mousenum))];
    makepretty
    plot((1:length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2, ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum}),':', 'Color',Color(1,:)*0.8, 'linewidth',2.5), hold on
    plot((1:length(ALL.Inst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2, ALL.Inst.RunMeanFq.ShockFz.(Example_mice_names{mousenum}), ':','Color',Color(2,:)*0.7, 'linewidth',2.5), hold on
    plot((1:length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum}),'Color',Color(1,:), 'linewidth',2), hold on
    plot((1:length(ALL.Inst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, ALL.Inst.RunMeanFq.SafeFz.(Example_mice_names{mousenum}),'Color',Color(2,:), 'linewidth',2), hold on

    skbox10 = [0, 0, ceil(time_shift*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2, ceil(time_shift*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2, 0];
    skbox90 = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2, 140, 140, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2];
    sfbox10 = [0, 0, ceil(time_shift*length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, ceil(time_shift*length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, 0];
    sfbox90 = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, (length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, (length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum})))*0.2];
    freqsfbox = [2, 5.5, 5.5, 2, 2];
    freqskbox = [5.5, 7, 7, 5.5, 5.5];
    patch(skbox10, freqskbox, Color(2,:)*0.7, 'FaceAlpha', 0.1)
    patch(skbox90, freqskbox, Color(2,:)*0.7, 'FaceAlpha', 0.1)
    patch(sfbox10, freqsfbox, Color(2,:), 'FaceAlpha', 0.2)
    patch(sfbox90, freqsfbox, Color(2,:), 'FaceAlpha', 0.2)
    
    ylabel('Frequency (Hz)', 'FontSize', 22);
    xlabel('Time freezing (s)', 'FontSize', 22);
    legend({'Shock, Spectrogram', 'Shock, Peak and Through', 'Safe, Spectrogram', 'Safe, Peak and Through'}, 'FontSize', 14, 'Location', 'southeast')
    legend boxoff
    title(Example_mice_names(mousenum), 'FontSize', 20);
    ylim([2 7])
end
saveas(gcf, fullfile(SaveFigsTo, 'EX_OBfreq_vs_Inst_fz_small_patch'), 'png');


%% Measure of the dispersion of the data

for mousenum=1:length(Mouse_ALL)
    Skewness_SafeFz(mousenum,1) = skewness(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    Skewness_SafeFz(mousenum,2) = skewness(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    Kurtosis_SafeFz(mousenum,1) = kurtosis(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    Kurtosis_SafeFz(mousenum,2) = kurtosis(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    mad_SafeFz(mousenum,1) = mad(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    mad_SafeFz(mousenum,2) = mad(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    perc1_SafeFz(mousenum,1) = percentile(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),25);
    perc2_SafeFz(mousenum,1) = percentile(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),75);
    perc1_SafeFz(mousenum,2) = percentile(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),25);
    perc2_SafeFz(mousenum,2) = percentile(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),75);
    iqr_SafeFz(mousenum,1) = iqr(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    iqr_SafeFz(mousenum,2) = iqr(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
end

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({iqr_SafeFz(:,1) iqr_SafeFz(:,2)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Peak and Through method','Spectrogram method'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Interquartile Range of OB frequencies, Safe', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_vs_Inst_fz_safe_skewness_final'), 'png');

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({perc2_SafeFz(:,1)-perc1_SafeFz(:,1) perc2_SafeFz(:,2)-perc1_SafeFz(:,2)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Peak and Through method','Spectrogram method'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Skewness of the distribution of OB frequencies, Safe', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_vs_Inst_fz_safe_skewness_final'), 'png');

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Skewness_SafeFz(:,1) Skewness_SafeFz(:,2)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Peak and Through method','Spectrogram method'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Skewness of the distribution of OB frequencies, Safe', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_vs_Inst_fz_safe_skewness_final'), 'png');

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({mad_SafeFz(:,1) mad_SafeFz(:,2)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Peak and Through method','Spectrogram method'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Skewness of the distribution of OB frequencies, Safe', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'linewidth',1.5)

figure
[pval_var , stats_out_var]= MakeSpreadAndBoxPlot3_ECSB({Kurtosis_SafeFz(:,1) Kurtosis_SafeFz(:,2)},{[0.3 0.4 0.7] [0.8 0.5 0.3]},...
    [1 2],{'Peak and Through method','Spectrogram method'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Kurtosis of the distribution of OB frequencies, Safe', 'FontSize', 25);
xlim([0.5 2.5])
ylim([1 13])
set(gca,'linewidth',1.5)
saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_vs_Inst_fz_safe_kurtosis_final'), 'png');

figure; 
nbins=25;
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(4,3,mousenum)
%     histogram(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),nbins) %looks like an inverse gaussian or a gamma distribution
    histogram(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),nbins) %looks like an inverse gaussian or a gamma distribution
    xlabel('OB frequency', 'FontSize', 25)
    ylabel('count', 'FontSize', 25)
    title(mouse)
end 
suptitle('Spect')


%% 3/ Variability of the measures and presence of the shift

% Variabilility
mousenum=1;
figure
plot((1:length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(Example_mice_names{mousenum}))-1), diff(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))
plot((1:length(ALL.Inst.RunMeanFq.SafeFz.(Example_mice_names{mousenum}))-1), diff(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))
hold on

for mousenum=1:length(Mouse_ALL)
plot(1, std(diff(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))), '*'), hold on
plot(2, std(diff(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))), '*')
end

min(diff(ALL.Inst.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum})))
min(diff(ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum})))


for mousenum=1:length(Mouse_ALL)
    ALL.Inst.RunMeanFq.GradVar.SafeFz.(ALL_Mouse_names{mousenum}) = diff(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    ALL.RestSpect_toInst.RunMeanFq.GradVar.SafeFz.(ALL_Mouse_names{mousenum}) = diff(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    ALL.Spect.RunMeanFq.GradVar.SafeFz.(ALL_Mouse_names{mousenum}) = diff(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    ALL.Inst.RunMeanFq.GradVar.SafeFz.std.(ALL_Mouse_names{mousenum}) = std(ALL.Inst.RunMeanFq.GradVar.SafeFz.(ALL_Mouse_names{mousenum}));
    std_SafeFz(mousenum,1) = std(ALL.Inst.RunMeanFq.GradVar.SafeFz.(ALL_Mouse_names{mousenum}));
    ALL.RestSpect_toInst.RunMeanFq.GradVar.SafeFz.std.(ALL_Mouse_names{mousenum}) = std(ALL.RestSpect_toInst.RunMeanFq.GradVar.SafeFz.(ALL_Mouse_names{mousenum}));
    std_SafeFz(mousenum,2) = std(ALL.RestSpect_toInst.RunMeanFq.GradVar.SafeFz.(ALL_Mouse_names{mousenum}));
    ALL.Spect.RunMeanFq.GradVar.SafeFz.std.(ALL_Mouse_names{mousenum}) = std(ALL.Spect.RunMeanFq.GradVar.SafeFz.(ALL_Mouse_names{mousenum}));
    std_SafeFz(mousenum,3) = std(ALL.Spect.RunMeanFq.GradVar.SafeFz.(ALL_Mouse_names{mousenum}));
end

figure
[pval , stats_out]= MakeSpreadAndBoxPlot3_SB({std_SafeFz(:,1) std_SafeFz(:,3)},{[1 0 0],[0 0 1]},[1 2],{'InstFreq','Spectro'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
makepretty
title('Std of the derivative of OB frequency (Hz)', 'FontSize', 25);
ylim([-0.1 0.6])

% Shift
time_shift=0.2;
for mousenum=1:length(Mouse_ALL)
    ALL.Inst.RunMeanFq.SafeFz.First.val.(ALL_Mouse_names{mousenum}) = ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(1:ceil(time_shift*length(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Inst.RunMeanFq.SafeFz.Last.val.(ALL_Mouse_names{mousenum}) = ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(ceil((1-time_shift)*length(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))):end);
    ALL.RestSpect_toInst.RunMeanFq.SafeFz.First.val.(ALL_Mouse_names{mousenum}) = ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(1:ceil(time_shift*length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.RestSpect_toInst.RunMeanFq.SafeFz.Last.val.(ALL_Mouse_names{mousenum}) = ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))):end);
    ALL.Spect.RunMeanFq.SafeFz.First.val.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(1:ceil(time_shift*length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Spect.RunMeanFq.SafeFz.Last.val.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(ceil((1-time_shift)*length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))):end);
    ALL.Inst.RunMeanFq.SafeFz.First.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Inst.RunMeanFq.SafeFz.First.val.(ALL_Mouse_names{mousenum}));
    ALL.Inst.RunMeanFq.SafeFz.Last.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Inst.RunMeanFq.SafeFz.Last.val.(ALL_Mouse_names{mousenum}));
    ALL.RestSpect_toInst.RunMeanFq.SafeFz.First.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.RestSpect_toInst.RunMeanFq.SafeFz.First.val.(ALL_Mouse_names{mousenum}));
    ALL.RestSpect_toInst.RunMeanFq.SafeFz.Last.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.RestSpect_toInst.RunMeanFq.SafeFz.Last.val.(ALL_Mouse_names{mousenum}));
    ALL.Spect.RunMeanFq.SafeFz.First.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Spect.RunMeanFq.SafeFz.First.val.(ALL_Mouse_names{mousenum}));
    ALL.Spect.RunMeanFq.SafeFz.Last.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Spect.RunMeanFq.SafeFz.Last.val.(ALL_Mouse_names{mousenum}));
    ALL.Inst.RunMeanFq.SafeFz.Delta_mean.(ALL_Mouse_names{mousenum}) = ALL.Inst.RunMeanFq.SafeFz.First.mean.(ALL_Mouse_names{mousenum}) - ALL.Inst.RunMeanFq.SafeFz.Last.mean.(ALL_Mouse_names{mousenum});
    Delta_mean_freq_safeFz(mousenum,1) = ALL.Inst.RunMeanFq.SafeFz.Delta_mean.(ALL_Mouse_names{mousenum})
    ALL.RestSpect_toInst.RunMeanFq.SafeFz.Delta_mean.(ALL_Mouse_names{mousenum}) = ALL.RestSpect_toInst.RunMeanFq.SafeFz.First.mean.(ALL_Mouse_names{mousenum}) - ALL.RestSpect_toInst.RunMeanFq.SafeFz.Last.mean.(ALL_Mouse_names{mousenum});
    Delta_mean_freq_safeFz(mousenum,2) = ALL.RestSpect_toInst.RunMeanFq.SafeFz.Delta_mean.(ALL_Mouse_names{mousenum})
    ALL.Spect.RunMeanFq.SafeFz.Delta_mean.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.SafeFz.First.mean.(ALL_Mouse_names{mousenum}) - ALL.Spect.RunMeanFq.SafeFz.Last.mean.(ALL_Mouse_names{mousenum});
    Delta_mean_freq_safeFz(mousenum,3) = ALL.Spect.RunMeanFq.SafeFz.Delta_mean.(ALL_Mouse_names{mousenum})
end

time_shift=0.05;
for mousenum=1:length(Mouse_ALL)
    ALL.Inst.RunMeanFq.SafeFz.First_clean.val.(ALL_Mouse_names{mousenum}) = ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(ceil(time_shift*length(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))):ceil((0.1+time_shift)*length(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Inst.RunMeanFq.SafeFz.Last_clean.val.(ALL_Mouse_names{mousenum}) = ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(ceil((0.9-time_shift)*length(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))):ceil((1-time_shift)*length(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Spect.RunMeanFq.SafeFz.First_clean.val.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(ceil(time_shift*length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))):ceil((0.1+time_shift)*length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Spect.RunMeanFq.SafeFz.Last_clean.val.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(ceil((0.9-time_shift)*length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))):ceil((1-time_shift)*length(ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Inst.RunMeanFq.SafeFz.First_clean.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Inst.RunMeanFq.SafeFz.First_clean.val.(ALL_Mouse_names{mousenum}));
    ALL.Inst.RunMeanFq.SafeFz.Last_clean.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Inst.RunMeanFq.SafeFz.Last_clean.val.(ALL_Mouse_names{mousenum}));
    ALL.Spect.RunMeanFq.SafeFz.First_clean.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Spect.RunMeanFq.SafeFz.First_clean.val.(ALL_Mouse_names{mousenum}));
    ALL.Spect.RunMeanFq.SafeFz.Last_clean.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Spect.RunMeanFq.SafeFz.Last_clean.val.(ALL_Mouse_names{mousenum}));
    ALL.Inst.RunMeanFq.SafeFz.Delta_mean_clean.(ALL_Mouse_names{mousenum}) = ALL.Inst.RunMeanFq.SafeFz.First_clean.mean.(ALL_Mouse_names{mousenum}) - ALL.Inst.RunMeanFq.SafeFz.Last_clean.mean.(ALL_Mouse_names{mousenum});
    Delta_mean_clean_freq_safeFz(mousenum,1) = ALL.Inst.RunMeanFq.SafeFz.Delta_mean_clean.(ALL_Mouse_names{mousenum});
    ALL.Spect.RunMeanFq.SafeFz.Delta_mean_clean.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.SafeFz.First_clean.mean.(ALL_Mouse_names{mousenum}) - ALL.Spect.RunMeanFq.SafeFz.Last_clean.mean.(ALL_Mouse_names{mousenum});
    Delta_mean_clean_freq_safeFz(mousenum,2) = ALL.Spect.RunMeanFq.SafeFz.Delta_mean_clean.(ALL_Mouse_names{mousenum});
end

for mousenum=1:length(Mouse_ALL)
    ALL.Inst.RunMeanFq.ShockFz.First_clean.val.(ALL_Mouse_names{mousenum}) = ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})(ceil(time_shift*length(ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))):ceil((0.1+time_shift)*length(ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.Inst.RunMeanFq.ShockFz.Last_clean.val.(ALL_Mouse_names{mousenum}) = ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})(ceil((0.9-time_shift)*length(ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))):ceil((1-time_shift)*length(ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.Spect.RunMeanFq.ShockFz.First_clean.val.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})(ceil(time_shift*length(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))):ceil((0.1+time_shift)*length(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.Spect.RunMeanFq.ShockFz.Last_clean.val.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})(ceil((0.9-time_shift)*length(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))):ceil((1-time_shift)*length(ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.Inst.RunMeanFq.ShockFz.First_clean.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Inst.RunMeanFq.ShockFz.First_clean.val.(ALL_Mouse_names{mousenum}));
    ALL.Inst.RunMeanFq.ShockFz.Last_clean.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Inst.RunMeanFq.ShockFz.Last_clean.val.(ALL_Mouse_names{mousenum}));
    ALL.Spect.RunMeanFq.ShockFz.First_clean.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Spect.RunMeanFq.ShockFz.First_clean.val.(ALL_Mouse_names{mousenum}));
    ALL.Spect.RunMeanFq.ShockFz.Last_clean.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Spect.RunMeanFq.ShockFz.Last_clean.val.(ALL_Mouse_names{mousenum}));
    ALL.Inst.RunMeanFq.ShockFz.Delta_mean_clean.(ALL_Mouse_names{mousenum}) = ALL.Inst.RunMeanFq.ShockFz.First_clean.mean.(ALL_Mouse_names{mousenum}) - ALL.Inst.RunMeanFq.ShockFz.Last_clean.mean.(ALL_Mouse_names{mousenum});
    Delta_mean_clean_freq_shockFz(mousenum,1) = ALL.Inst.RunMeanFq.ShockFz.Delta_mean_clean.(ALL_Mouse_names{mousenum});
    ALL.Spect.RunMeanFq.ShockFz.Delta_mean_clean.(ALL_Mouse_names{mousenum}) = ALL.Spect.RunMeanFq.ShockFz.First_clean.mean.(ALL_Mouse_names{mousenum}) - ALL.Spect.RunMeanFq.ShockFz.Last_clean.mean.(ALL_Mouse_names{mousenum});
    Delta_mean_clean_freq_shockFz(mousenum,2) = ALL.Spect.RunMeanFq.ShockFz.Delta_mean_clean.(ALL_Mouse_names{mousenum});
end


% Compare shift observed with INST against restrincted SPECT for each mouse 
figure
[pval , stats_out]= MakeSpreadAndBoxPlot3_SB({Delta_mean_freq_safeFz(:,1) Delta_mean_freq_safeFz(:,2)},{[1 0 0],[0 0 1]},[1 2],{'InstFreq','Rest Spectro'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
makepretty
title('Frequency shift from the 20% first to last period of freezing (Hz)', 'FontSize', 25);
ylim([-2 2.5])
% Compare shift observed with INST against SPECT for each mouse 
figure
[pval , stats_out]= MakeSpreadAndBoxPlot3_SB({Delta_mean_freq_safeFz(:,1) Delta_mean_freq_safeFz(:,3)},{[1 0 0],[0 0 1]},[1 2],{'InstFreq','Spectro'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
makepretty
title('Frequency shift from the 10% first to last period of freezing (Hz)', 'FontSize', 25);

% Compare shift values observed with INST and SPECT against no shift (0)

% Code for the figure below is adapted from the files
% ModulationIdex_4_10Hz_REM_wholeSpleep.m and ModIndexPlot.m
figure
clf
Vals = {Delta_mean_freq_safeFz(:,1); Delta_mean_freq_safeFz(:,3)};
XPos = [1,2];
ColFact = [1,0.8];
[p(1,:),h(1,:),statstemp(1,:)]=signrank(Delta_mean_freq_safeFz(:,1))
[p(2,:),h(2,:),statstemp(2,:)]=signrank(Delta_mean_freq_safeFz(:,3))

for k = 1:2
X = Vals{k};
a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',[0.9 0.9 0.9]*ColFact(k),'lineColor',[0.9 0.9 0.9]*ColFact(k),'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',22)
handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*ColFact(k),'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',12)

StarPos=max(abs(X))*1.2;
if p(k,:)<0.001
    text(k-0.06,StarPos,'***','FontSize',25)
elseif p(k,:)<0.01
    text(k-0.06,StarPos,'**','FontSize',25)
elseif p(k,:)<0.05
    text(k-0.06,StarPos,'*','FontSize',25)
end

makepretty
end

xlim([0 3])
line(xlim,[0 0],'linestyle','--','linewidth',1,'color',[0.6 0.6 0.6])
ylim([-1 3])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'Inst','Rest Spectro'},'linewidth',1.5,'YTick',[-2:1:2])
ylabel('Frequency shift from the 10% first to last period of freezing (Hz)')
box off

figure
clf
Vals = {Delta_mean_clean_freq_shockFz(:,1); Delta_mean_clean_freq_shockFz(:,2); Delta_mean_clean_freq_safeFz(:,1); Delta_mean_clean_freq_safeFz(:,2)};

XPos = [1,2,3,4];
Color = [0.3 0.4 0.7; 0.8 0.5 0.3;0.3 0.4 0.7; 0.8 0.5 0.3];
ColFact = [0.7, 0.8, 1, 1];
[p(1,:),h(1,:),statstemp(1,:)]=signrank(Delta_mean_clean_freq_shockFz(:,1))
[p(2,:),h(2,:),statstemp(2,:)]=signrank(Delta_mean_clean_freq_shockFz(:,2))
[p(3,:),h(3,:),statstemp(3,:)]=signrank(Delta_mean_clean_freq_safeFz(:,1))
[p(4,:),h(4,:),statstemp(4,:)]=signrank(Delta_mean_clean_freq_safeFz(:,2))

for k = 1:4
    X = Vals{k};
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Color(k,:)*ColFact(k),'lineColor',Color(k,:)*ColFact(k),'medianColor',Color(k,:)*ColFact(k),'boxWidth',0.4,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 10;
    a.handles.medianLines.XData=a.handles.medianLines.XData+[-.1 .1];
    alpha(.3)


    handlesplot=plotSpread(X,'distributionColors','k','xValues',XPos(k),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',22)
    handlesplot=plotSpread(X,'distributionColors','w','xValues',XPos(k),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',18)

    StarPos=max(abs(X))*1.2;
    if p(k,:)<0.001
        text(k-0.12,StarPos,'***','FontSize',25)
    elseif p(k,:)<0.01
        text(k-0.12,StarPos,'**','FontSize',25)
    elseif p(k,:)<0.05
        text(k-0.12,StarPos,'*','FontSize',25)
    end
end

xlim([0.5 4.5])
line(xlim,[0 0],'linestyle','--','linewidth',1,'color',[0.6 0.6 0.6])
ylim([-2.5 3.5])
set(gca,'FontSize',16,'XTick',[1 2 3 4],'XTickLabel',...
    {'Shock Peak and Trough', 'Shock Spectrogram', 'Safe Peak and Trough', 'Safe Spectrogram'},'linewidth',1.5,'YTick',[-2:1:2])
set(gca,'FontSize',18,'XTick',[1 2 3 4],'XTickLabel',...
    {'Shock, P&T', 'Shock, Spectro', 'Safe, P&T', 'Safe, Spectro'},'linewidth',1.5,'YTick',[-2:1:3])
ylabel('Shift in OB frequency (Hz)', 'FontSize', 25);
xtickangle(0)
% ylabel('Frequency shift from the 10% first to last period of freezing (Hz)')
box off
saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_Inst_vs0_fz_safe_shift_final'), 'png');


%% B/ Freezing camera vs accelerometer

GetEmbReactMiceFolderList_BM

% Extract zone (shock and safe) epochs
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL.ZoneEpoch.(ALL_Mouse_names{mousenum}) = ConcatenateDataFromFolders_SB(CondSess.(ALL_Mouse_names{mousenum}),'Epoch','epochname','zoneepoch');
    ALL.ZoneEpoch.Shock.(ALL_Mouse_names{mousenum}) = ALL.ZoneEpoch.(ALL_Mouse_names{mousenum}){1};
    ALL.ZoneEpoch.Safe.(ALL_Mouse_names{mousenum}) = or(ALL.ZoneEpoch.(ALL_Mouse_names{mousenum}){2}, ALL.ZoneEpoch.(ALL_Mouse_names{mousenum}){5});
end

% Extract Fz camera epochs and deduce the Fz Camera shock and safe epochs
for mousenum=1:length(Mouse_ALL)
    ALL.Fz_Camera.(ALL_Mouse_names{mousenum}) = ConcatenateDataFromFolders_SB(CondSess.(ALL_Mouse_names{mousenum}),'epoch','epochname','freeze_epoch_camera');
    ALL.Fz_Camera.Epoch.ShockFz.(ALL_Mouse_names{mousenum}) = and(ALL.Fz_Camera.(ALL_Mouse_names{mousenum}), ALL.ZoneEpoch.Shock.(ALL_Mouse_names{mousenum}));
    ALL.Fz_Camera.Epoch.SafeFz.(ALL_Mouse_names{mousenum}) = and(ALL.Fz_Camera.(ALL_Mouse_names{mousenum}), ALL.ZoneEpoch.Safe.(ALL_Mouse_names{mousenum}));
end

% Restrict the TSD data (frequency, ripples) to these epochs
for mousenum=1:length(Mouse_ALL)
    % Define the restricted object before applying data and range to it
    ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = Data(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL.Fz_Camera.Epoch.ShockFz.(ALL_Mouse_names{mousenum})));
    if isnan(ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = Data(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL.Fz_Camera.Epoch.SafeFz.(ALL_Mouse_names{mousenum})));
    if isnan(ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end

    ALL.Fz_Camera.Epoch.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Fz_Camera.Epoch.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),30);
    ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Fz_Camera.Epoch.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),30);

    ALL.Fz_Camera.Epoch.Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}) = Range(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL.Fz_Camera.Epoch.ShockFz.(ALL_Mouse_names{mousenum})));
    ALL.Fz_Camera.Epoch.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}) = Range(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL.Fz_Camera.Epoch.SafeFz.(ALL_Mouse_names{mousenum})));

%     if isempty(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum,1},ALL.Fz_Camera.Epoch.ShockFz.(ALL_Mouse_names{mousenum}))) == 0
%         ALL.Fz_Camera.Epoch.Ind_Ripples.ShockFz.(ALL_Mouse_names{mousenum}) = Range(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum,1},ALL.Fz_Camera.Epoch.ShockFz.(ALL_Mouse_names{mousenum}))); 
%     end
% 
%     if isempty(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum,1},ALL.Fz_Camera.Epoch.SafeFz.(ALL_Mouse_names{mousenum}))) == 0
%         ALL.Fz_Camera.Epoch.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum}) = Range(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum,1},ALL.Fz_Camera.Epoch.SafeFz.(ALL_Mouse_names{mousenum}))); 
%     end
end  

%% 1/ Sensitivity, Specitivity

%Interval sets can be studied using 
%Start/Stop to have the beginning/end of the time periods
%DurationEpoch to have the timepoints of the different periods
sum(DurationEpoch(EpochALL.Cond{1,1}));%durations of the fz episodes on the safe side

% Compute the time spent freezing with the two methods, the number of
% episodes and the mean duration of an episode of freezing

% Two 'ways' of extracting the time mice spent in maze
max(Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{1,1}))% max index of global time at which a frequency was recorded
sum(DurationEpoch(EpochALL.Cond{1,1}))% sum of the durations of conditioning epochs

for mousenum=1:length(Mouse_ALL)
    % % of conditioning session time spent freezing 
    ALL.Fz_Camera.Epoch.TimeFz.(ALL_Mouse_names{mousenum}) = 100*(sum(DurationEpoch(ALL.Fz_Camera.(ALL_Mouse_names{mousenum})))/sum(DurationEpoch(EpochALL.Cond{mousenum,1})));
    ALL.Spect.TimeFz.(ALL_Mouse_names{mousenum}) = 100*(sum(DurationEpoch(EpochALL.Cond{mousenum,3}))/sum(DurationEpoch(EpochALL.Cond{mousenum,1})));
    
    ALL.Fz_Camera.Epoch.TimeFz.SafeFz.(ALL_Mouse_names{mousenum}) = 100*(sum(DurationEpoch(ALL.Fz_Camera.Epoch.SafeFz.(ALL_Mouse_names{mousenum})))/sum(DurationEpoch(EpochALL.Cond{mousenum,1})));
    ALL.Spect.TimeFz.SafeFz.(ALL_Mouse_names{mousenum}) = 100*(sum(DurationEpoch(EpochALL.Cond{mousenum,6}))/sum(DurationEpoch(EpochALL.Cond{mousenum,1})));
    
    ALL.Fz_Camera.Epoch.TimeFz.ShockFz.(ALL_Mouse_names{mousenum}) = 100*(sum(DurationEpoch(ALL.Fz_Camera.Epoch.ShockFz.(ALL_Mouse_names{mousenum})))/sum(DurationEpoch(EpochALL.Cond{mousenum,1})));
    ALL.Spect.TimeFz.ShockFz.(ALL_Mouse_names{mousenum}) = 100*(sum(DurationEpoch(EpochALL.Cond{mousenum,5}))/sum(DurationEpoch(EpochALL.Cond{mousenum,1})));
    
    TimeFz.all(mousenum,1) = ALL.Fz_Camera.Epoch.TimeFz.(ALL_Mouse_names{mousenum});
    TimeFz.all(mousenum,2) = ALL.Spect.TimeFz.(ALL_Mouse_names{mousenum});
    TimeFz.shockoversafe(mousenum,1) = ALL.Fz_Camera.Epoch.TimeFz.ShockFz.(ALL_Mouse_names{mousenum})/ALL.Fz_Camera.Epoch.TimeFz.SafeFz.(ALL_Mouse_names{mousenum});
    TimeFz.shockoversafe(mousenum,2) = ALL.Spect.TimeFz.ShockFz.(ALL_Mouse_names{mousenum})/ALL.Spect.TimeFz.SafeFz.(ALL_Mouse_names{mousenum});

    % Number of episodes of freezing
%     ALL.Fz_Camera.Epoch.Nepisodes.SafeFz.(ALL_Mouse_names{mousenum}) = length(Start(ALL.Fz_Camera.Epoch.SafeFz.(ALL_Mouse_names{mousenum})));
%     ALL.Spect.Nepisodes.SafeFz.(ALL_Mouse_names{mousenum}) = length(Start(EpochALL.Cond{mousenum,6}));
    ALL.Fz_Camera.Epoch.Nepisodes.(ALL_Mouse_names{mousenum}) = length(Start(ALL.Fz_Camera.(ALL_Mouse_names{mousenum})));
    ALL.Spect.Nepisodes.(ALL_Mouse_names{mousenum}) = length(Start(EpochALL.Cond{mousenum,3}));
    Nepisodes(mousenum,1) = ALL.Fz_Camera.Epoch.Nepisodes.(ALL_Mouse_names{mousenum});
    Nepisodes(mousenum,2) = ALL.Spect.Nepisodes.(ALL_Mouse_names{mousenum});

    % Mean duration of a freezing episode
    ALL.Fz_Camera.Epoch.MeanTimeFz.SafeFz.(ALL_Mouse_names{mousenum}) = nanmean(DurationEpoch(ALL.Fz_Camera.Epoch.SafeFz.(ALL_Mouse_names{mousenum})));
    ALL.Spect.MeanTimeFz.SafeFz.(ALL_Mouse_names{mousenum}) = nanmean(DurationEpoch(EpochALL.Cond{mousenum,6}));
    MeanTimeFz(mousenum,1) = ALL.Fz_Camera.Epoch.MeanTimeFz.SafeFz.(ALL_Mouse_names{mousenum});
    MeanTimeFz(mousenum,2) = ALL.Spect.MeanTimeFz.SafeFz.(ALL_Mouse_names{mousenum});
end

figure
[pval_timefz , stats_out_timefz]= MakeSpreadAndBoxPlot3_ECSB({TimeFz.all(:,1) TimeFz.all(:,2)},{[0.2 0.6 .4] [0.7 0.4 0.6]},...
    [1 2],{'Freezing camera','Freezing accelerometer'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('% of time spent freezing during conditioning', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'linewidth',1.5,'YTick',[0:10:50])
saveas(gcf, fullfile(SaveFigsTo, 'ALL_Cam_vs_Acc_percenttime_fz'), 'png');

figure
[pval_ratio , stats_out_ratio]= MakeSpreadAndBoxPlot3_ECSB({TimeFz.shockoversafe(:,1) TimeFz.shockoversafe(:,2)},{[0.2 0.6 .4] [0.7 0.4 0.6]},...
    [1 2],{'Freezing camera','Freezing accelerometer'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Ratio of the time spent freezing on the shock over the safe side', 'FontSize', 20);
xlim([0.5 2.5])
ylim([0 1.3])
set(gca,'linewidth',1.5,'YTick',[0:0.5:1])
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_vs_Inst_fz_safe_variability'), 'png');

figure
[pval_nep , stats_out_nep]= MakeSpreadAndBoxPlot3_ECSB({Nepisodes(:,1) Nepisodes(:,2)},{[0.2 0.6 .4] [0.7 0.4 0.6]},...
    [1 2],{'Freezing camera','Freezing accelerometer'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Number of freezing episodes on the safe side', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'linewidth',1.5)
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_vs_Inst_fz_safe_variability'), 'png');

figure
[pval_nep , stats_out_nep]= MakeSpreadAndBoxPlot3_ECSB({Nepisodes(:,1) Nepisodes(:,2)},{[0.2 0.6 .4] [0.7 0.4 0.6]},...
    [1 2],{'Freezing camera','Freezing accelerometer'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Number of freezing episodes during conditioning', 'FontSize', 25);
xlim([0.5 2.5])
% ylim([-0.1 0.6])
set(gca,'linewidth',1.5, 'YTick',[0:100:450])
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_Cam_vs_Acc_numepisodes_fz'), 'png');

figure
[pval_meantimefz , stats_out_meantimefz]= MakeSpreadAndBoxPlot3_ECSB({MeanTimeFz(:,1)/10000 MeanTimeFz(:,2)/10000},{[0.2 0.6 .4] [0.7 0.4 0.6]},...
    [1 2],{'Freezing camera','Freezing accelerometer'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('Mean duration of the freezing episodes on the safe side (s)', 'FontSize', 25);
xlim([0.5 2.5])
ylim([1 9.5])
set(gca,'linewidth',1.5,'YTick',[0:2:10])
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_vs_Inst_fz_safe_variability'), 'png');

% Compare indices of freezing camera to freezing accelerometer on safe side 
fig=figure;
colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)

    plot(ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}), 4, '.r'), hold on
    plot(ALL.Fz_Camera.Epoch.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}), 5,'.g'), hold on
    ylim([3.7 5.3])
    title(mouse)
%     legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='off';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Timepoints of conditioning session', 'FontSize', 25);
title(han,'Timepoints of freezing according to accelerometer (red) and camera (green)', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_indices_accelero_camerafz_safe'), 'png');

% Check if freezing camera contains all the timepoints of freezing
% accelerometer
for mousenum=1:length(Mouse_ALL)
    clear AA BB
    AA = ALL.Fz_Camera.Epoch.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum});
    BB = ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum});
    SpeFzAcc(mousenum,1) = sum(ismember(AA, BB))/length(BB);
    SpeFzCam(mousenum,1) = sum(ismember(BB, AA))/length(AA);
end

for mousenum=1:length(Mouse_ALL)
    clear Ind_cam Ind_acc
    Ind_cam = Range(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL.Fz_Camera.(ALL_Mouse_names{mousenum})));
    Ind_acc = Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,3});
    SpeFzAccall(mousenum,1) = sum(ismember(Ind_acc, Ind_cam))/length(Ind_acc);
    SpeFzCamall(mousenum,1) = sum(ismember(Ind_cam, Ind_acc))/length(Ind_cam);
end

figure
[pval_timefz , stats_out_timefz]= MakeSpreadAndBoxPlot3_ECSB({SpeFzCamall(:,1)*100 SpeFzAccall(:,1)*100},{[0.2 0.6 .4] [0.7 0.4 0.6]},...
    [1 2],{'Camera in accelerometer','Accelerometer in camera'},'paired',1,'showpoints',0);
%Wilcoxon Signed Rank Test because n=15 and paired data
% ylabel('Standard deviation of the difference in OB frequency of adjacent points (Hz)', 'FontSize', 20);
ylabel('% of freezing according to a method included in the other', 'FontSize', 25);
xlim([0.5 2.5])
ylim([0 110])
set(gca,'linewidth',1.5,'YTick',[0:20:100])
saveas(gcf, fullfile(SaveFigsTo, 'ALL_Cam_vs_Acc_specificity_fz'), 'png');


figure
clf
Vals = {100*SpeFzAcc'};
XPos = 1;

for k = 1
    X = Vals{k};
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',[0.7 0.4 0.6],'lineColor',[0.7 0.4 0.6],'medianColor',[0.7 0.4 0.6],'boxWidth',0.4,'showOutliers',false);
%     a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
%     a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 10;
    a.handles.medianLines.XData=a.handles.medianLines.XData+[-.1 .1];
    alpha(.3)


    handlesplot=plotSpread(X,'distributionColors','k','xValues',XPos(k),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',22)
    handlesplot=plotSpread(X,'distributionColors','w','xValues',XPos(k),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',18)

end

xlim([0 2])
ylim([0 101])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'Freezing accelerometer contained in freezing camera'},'linewidth',1.5)
ylabel('Percent (%)')
box off
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_Inst_vs0_fz_safe_shift'), 'png');



%% 2/ Signals of some mice

% Camera shock and safe side freezing 
figure;
ExampleAC_mice = [1189];
for mousenum=1:length(ExampleAC_mice)
    mouse=ExampleAC_mice(mousenum);

    subplot(2,1,1)
    plot((1:length(ALL.Fz_Camera.Epoch.RunMeanFq.ShockFz.M1189))*0.2, ALL.Fz_Camera.Epoch.RunMeanFq.ShockFz.M1189,'Color',[0.8 0.4 0.6]), hold on
    plot((1:length(ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.M1189))*0.2, ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.M1189,'Color',[0.2 0.7 .4]), hold on    
    makepretty    
    title('Camera freezing', 'FontSize', 25)
    xlabel('Time freezing (s)', 'FontSize', 25);
    ylabel('Frequency (Hz)', 'FontSize', 25);
    ylim([2 8])
    legend({'Shock', 'Safe'}, 'FontSize', 18)
    legend boxoff

    subplot(2,1,2)
    plot((1:length(ALL.Spect.RunMeanFq.ShockFz.M1189))*0.2, ALL.Spect.RunMeanFq.ShockFz.M1189,'Color',[0.8 0.4 0.6]), hold on
    plot((1:length(ALL.Spect.RunMeanFq.SafeFz.M1189))*0.2, ALL.Spect.RunMeanFq.SafeFz.M1189,'Color',[0.2 0.7 .4]), hold on
    makepretty
    title('Accelerometer freezing', 'FontSize', 25)
    xlabel('Time freezing (s)', 'FontSize', 25);
    ylabel('Frequency (Hz)', 'FontSize', 25);
    ylim([2 8])
    legend({'Shock', 'Safe'}, 'FontSize', 18)
    legend boxoff
end
saveas(gcf, fullfile(SaveFigsTo, 'EX_Cam_vs_Acc_all_fz'), 'png');


%% 3/ Variability of the measures and presence of the shift

% Shift
time_shift=0.1;
for mousenum=1:length(Mouse_ALL)
    ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.First.val.(ALL_Mouse_names{mousenum}) = ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(1:ceil(time_shift*length(ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.Last.val.(ALL_Mouse_names{mousenum}) = ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(ceil((1-time_shift)*length(ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))):end);
    ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.First.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.First.val.(ALL_Mouse_names{mousenum}));
    ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.Last.mean.(ALL_Mouse_names{mousenum}) = nanmean(ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.Last.val.(ALL_Mouse_names{mousenum}));
    ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.Delta_mean.(ALL_Mouse_names{mousenum}) = ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.First.mean.(ALL_Mouse_names{mousenum}) - ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.Last.mean.(ALL_Mouse_names{mousenum});
    Deltamean_cam_accelero_safeFz(mousenum,1) = ALL.Fz_Camera.Epoch.RunMeanFq.SafeFz.Delta_mean.(ALL_Mouse_names{mousenum})
    Deltamean_cam_accelero_safeFz(mousenum,2) = ALL.Spect.RunMeanFq.SafeFz.Delta_mean.(ALL_Mouse_names{mousenum})
end

% Compare shift observed with camera against accelerometer 
figure
[pval , stats_out]= MakeSpreadAndBoxPlot3_ECSB({Deltamean_cam_accelero_safeFz(:,1) Deltamean_cam_accelero_safeFz(:,2)},...
{[0.2 0.6 .4] [0.7 0.4 0.6]},[1 2],{'Freezing camera','Freezing accelerometer'},'paired',1,'showpoints',0)
%Wilcoxon Signed Rank Test because n=15 and paired data
xlim([0.5 2.5])
ylabel('Shift in OB frequency (Hz)', 'FontSize', 25);
% ylabel('Frequency shift from the 10% first to last period of freezing (Hz)', 'FontSize', 25);
set(gca,'linewidth',1.5,'YTick',[-2:1:3])
saveas(gcf, fullfile(SaveFigsTo, 'ALL_Cam_vs_Acc_relshift_fz_safe'), 'png');


% Compare shift values observed with camera and acc against no shift (0)

% Code for the figure below is adapted from the files
% ModulationIdex_4_10Hz_REM_wholeSpleep.m and ModIndexPlot.m
figure
clf
Vals = {Deltamean_cam_accelero_safeFz(:,1); Deltamean_cam_accelero_safeFz(:,2)};
XPos = [1,2];
Color = [0.2 0.6 .4; 0.7 0.4 0.6];
[p(1,:),h(1,:),statstemp(1,:)]=signrank(Deltamean_cam_accelero_safeFz(:,1))
[p(2,:),h(2,:),statstemp(2,:)]=signrank(Deltamean_cam_accelero_safeFz(:,2))

for k = 1:2
    X = Vals{k};
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Color(k,:),'lineColor',Color(k,:),'medianColor',Color(k,:),'boxWidth',0.4,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 10;
    a.handles.medianLines.XData=a.handles.medianLines.XData+[-.1 .1];
    alpha(.3)


    handlesplot=plotSpread(X,'distributionColors','k','xValues',XPos(k),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',22)
    handlesplot=plotSpread(X,'distributionColors','w','xValues',XPos(k),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',18)

    StarPos=max(abs(X))*1.2;
    if p(k,:)<0.001
        text(k-0.06,StarPos,'***','FontSize',25)
    elseif p(k,:)<0.01
        text(k-0.06,StarPos,'**','FontSize',25)
    elseif p(k,:)<0.05
        text(k-0.06,StarPos,'*','FontSize',25)
    end
end

xlim([0.5 2.5])
line(xlim,[0 0],'linestyle','--','linewidth',1,'color',[0.6 0.6 0.6])
ylim([-2 3.5])
set(gca,'FontSize',20,'XTick',[1 2],'XTickLabel',{'Freezing camera','Freezing accelerometer'},'linewidth',1.5,'YTick',[-2:1:3])
ylabel('Shift in OB frequency (Hz)', 'FontSize', 25);
% ylabel('Frequency shift from the 10% first to last period of freezing (Hz)')
box off
saveas(gcf, fullfile(SaveFigsTo, 'ALL_Cam_vs_Acc_vs0_fz_safe_shift'), 'png');





