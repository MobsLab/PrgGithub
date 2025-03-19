%% Objectives of this code

% Visualise the data (OB frequency, ripples, entries in shock zone) during
% the first 100 timepoints of freezing safe in conditioning sessions 
% for mice we selected based on the first analysis 

% OB frequency during freezing safe interpolated along all the conditioning session
% OB frequency during freezing safe concatenated epochs
% Ripples aligned to OB frequency, cumulative curve of ripples 
% Threshold of shift in OB frequency and time passed below threshold determined for each mouse 
% Hypothesis of learning : proportional to absolute or relative time spent 
% in maze (1), freezing (2) or to number of ripples (3)
% OB mean frequency during freezing safe before and after a ripple
% Number of shock zone entries and entries aligned to fz safe (moments when
% the mouse runs back to safe zone after a shock and freezes)


%% Selected canonical mice
clear all

%from
%Mouse_gr1=[688 739 777 779 849 893] % group1: saline mice, long protocol, SB
%Mouse_gr5=[1170 1171 9184 1189 9205 1391 1392 1393 1394] % group 5: saline short BM first Maze

%to : mice with an OB frequency during freezing safe in conditionning sessions that show a canonical behaviour 
%mice that have a sufficient time of freezing safe and ripples
Mouse_C1000=[688 739 777 849 1171 1189 1393 1394]; % C1000 stands for Canonical 1000 timepoints of freezing safe

%% Extract data for all mice
Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [C1000_TSD_DATA.(Session_type{sess}) , EpochC.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_C1000,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition', 'instfreq');
end

%% Freezing safe along the absolute time of the experiment

% Compute OB frequency and ripples during freezing safe
for mousenum=1:length(Mouse_C1000)
    C1000_Mouse_names{mousenum}=['M' num2str(Mouse_C1000(mousenum))];
    C_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}) = Data(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}) = Data(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if length(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})) > 1000
        C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}) = C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(1:1000);
    end
    if isnan(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(1))
        C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(1:find(~isnan(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})), 1)) = C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(find(~isnan(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})), 1));
    end
    if isnan(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(end))
        C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(find(~isnan(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})), 1, 'last'):end) = C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(find(~isnan(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})), 1, 'last'));
    end
    C_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum}) = Range(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum}) = Range(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if length(C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum})) > 1000
        C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum}) = C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum})(1:1000);
    end
    C1000_Ind_Ripples_SafeFz.(C1000_Mouse_names{mousenum}) = Range(C1000_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
end

%% OB frequencies during freezing episodes across the global time of the trial
for mousenum=1:length(Mouse_C1000)
    C1000_Time_spent_maze.(C1000_Mouse_names{mousenum}) = min(Range(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1})):ceil(min(diff(C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum})))):max(Range(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}));
    C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}) = interp1(C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum}), runmean_BM(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}),30), C1000_Time_spent_maze.(C1000_Mouse_names{mousenum}));
    C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(1:find(~isnan(C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})), 1)) = C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(find(~isnan(C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})), 1));
    C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(find(~isnan(C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})), 1, 'last'):end) = C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(find(~isnan(C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})), 1, 'last'));
end

% Plot the OB mean frequency during freezing across absolute time of the conditionning session
figure;
colors = [0 0.6 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 1 0.4 0; 1 0.2 0;0 0.6 .4; 1 0.4 0];
for mousenum=1:length(Mouse_C1000)
    mouse=C1000_Mouse_names(mousenum);
    subplot(2,4,mousenum)
    plot(C1000_Time_spent_maze.(C1000_Mouse_names{mousenum}), runmean_BM(C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}),30),'Color',colors(mousenum,:)), hold on
    plot(C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum}), max(runmean_BM(C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}),30))+0.5, '.k')
    ylim([min(C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}))-0.8 max(C1000_Global_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}))+0.8])
    title(mouse)
    xlabel('Absolute time freezing')
    ylabel('Frequency (Hz)')
    makepretty
end
suptitle('C1000 OB frequency during absolute time freezing')

%% Freezing safe concatenated epoch

% Plot OB frequency during concatenated freezing time
figure
for mousenum=1:length(Mouse_C1000)
    plot(runmean_BM(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}),30)), hold on
end
grid
xlabel('1000 first timepoints of freezing safe')
ylabel('Frequency (Hz)')
legend(fields(C1000_Freq_Respi_SafeFz), 'Location', 'best')
title('OB frequency during 1000 first timepoints of freezing safe')

% Align all the timepoints that correspond more or less to the ripples with a frequency  
C1000_names_ripples=fields(C1000_Ind_Ripples_SafeFz);
for mousenum=1:length(C1000_names_ripples)
    for i=1:length(C1000_Ind_Ripples_SafeFz.(C1000_names_ripples{mousenum})) 
        C1000_Ind_Match_SafeFz.(C1000_names_ripples{mousenum})(i) = sum(C1000_Ind_Ripples_SafeFz.(C1000_names_ripples{mousenum})(i)>C1000_Ind_OB_SafeFz.(C1000_names_ripples{mousenum}));
    end
    C1000_Ind_Match_SafeFz.(C1000_names_ripples{mousenum}) = C1000_Ind_Match_SafeFz.(C1000_names_ripples{mousenum})(C1000_Ind_Match_SafeFz.(C1000_names_ripples{mousenum}) < 999);
    %Ind Match adapted to fit whithin the first 1000 timepoints of freezing safe
end

% Cumulative curve ripples 
figure
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples(mousenum);
    subplot(2,4,mousenum)
    grid
    yyaxis left
    plot(runmean_BM(C1000_Freq_Respi_SafeFz.(C1000_names_ripples{mousenum}),30))
    title(mouse)
    xlabel('Timepoints of freezing')
    makepretty
    yyaxis right
    grid
    cdfplot(C1000_Ind_Match_SafeFz.(C1000_names_ripples{mousenum}));
    ylabel([])
    title(mouse)
    makepretty
end
suptitle('C1000 OB frequency and cumulative curve of ripples')

% Compute the density of ripples
% clear C1000_N_RipplesFzsafe C1000_Normalized_RipplesFzsafe C1000_Norm_noNaN_RipplesFzSafe
for mousenum=1:length(C1000_names_ripples)
    for i=1:20:(floor(max(C1000_Ind_Match_SafeFz.(C1000_Mouse_names{mousenum}))./20)*20)+1   
        C1000_N_RipplesFzsafe.(C1000_Mouse_names{mousenum})(i) = sum(i<= C1000_Ind_Match_SafeFz.(C1000_Mouse_names{mousenum}) & C1000_Ind_Match_SafeFz.(C1000_Mouse_names{mousenum}) <= i+20)/4;
        C1000_N_RipplesFzsafe.(C1000_Mouse_names{mousenum})(i+1:i+20)=NaN;
        C1000_Normalized_RipplesFzsafe.(C1000_Mouse_names{mousenum}) = C1000_N_RipplesFzsafe.(C1000_Mouse_names{mousenum})/nanmean(C1000_N_RipplesFzsafe.(C1000_Mouse_names{mousenum}));
        C1000_Norm_noNaN_RipplesFzSafe.(C1000_Mouse_names{mousenum})= C1000_Normalized_RipplesFzsafe.(C1000_Mouse_names{mousenum})(~isnan((C1000_Normalized_RipplesFzsafe.(C1000_Mouse_names{mousenum}))));
    end
end

% Compute OB mean frequency
for mousenum=1:length(Mouse_C1000)
    C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}) = runmean_BM(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}),30);
end

figure
for mousenum=1:length(Mouse_C1000)
    mouse=C1000_names_ripples(mousenum);
    subplot(2,4,mousenum)
    grid
    plot(C1000_N_RipplesFzsafe.(C1000_Mouse_names{mousenum}),'o')
    xlim([-10 length(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))])
    title(mouse)
    xlabel('1000 first timepoints of freezing safe')
    ylabel('Density of ripples')
end
suptitle('Ripples density during 1000 first timepoints of freezing safe')
%plot(X(~isnan(Y)),Y(~isnan(Y)))

%% Look at the correlation between OB frequency and ripples across time

% Compute the mean OB frequency during 4s timebins (same bin as the ripples density)
% clear C1000_OB_Mean_Freq_20X C1000_BinMean_Freq_FzSafe
for mousenum=1:length(C1000_names_ripples)
    clear i ind
    C1000_OB_Mean_Freq_20X.(C1000_Mouse_names{mousenum}) = C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum})(1:(floor(length(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))./20)*20));
    for i=1:20:length(C1000_OB_Mean_Freq_20X.(C1000_Mouse_names{mousenum}))
%         if i==max(i)
%             C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum})(i) = nanmean(C1000_OB_Mean_Freq_20X.(C1000_Mouse_names{mousenum})(i:end));
%         else
        try
            C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum})(i) = nanmean(C1000_OB_Mean_Freq_20X.(C1000_Mouse_names{mousenum})(i:i+20));
        end % Compute the mean OB frequency during 4s timebins 
        ind=C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum})==0;
        C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum})(ind)=NaN;
        C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum}) = C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum})(~isnan((C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum}))));
    end
end

fig=figure;
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples(mousenum);
    clear C1000_Corr_mouse C1000_Ripples_corr_mouse C1000_Freq_corr_mouse C1000_Time_Binned_mouse
    C1000_Freq_corr_mouse = C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum});
    C1000_Ripples_corr_mouse = C1000_Norm_noNaN_RipplesFzSafe.(C1000_Mouse_names{mousenum})(1:length(C1000_Norm_noNaN_RipplesFzSafe.(C1000_Mouse_names{mousenum}))-1);
    if length(C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum})) ~= length(C1000_Ripples_corr_mouse)
        C1000_Ripples_corr_mouse(end) = [];
    end
    C1000_Time_Binned_mouse = (length(C1000_Ripples_corr_mouse)*20)-19;
    
    subplot(2,4,mousenum)
    sz = 49;
    c = (1:20:C1000_Time_Binned_mouse)*0.2;
    scatter(C1000_Freq_corr_mouse, C1000_Ripples_corr_mouse, sz, c, 'filled');
    colorbar
    axis square
%     heatmap(C1000_Corr_mouse);
    title(mouse)
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Ripples normalized density', 'FontSize', 25);
xlabel(han,'OB mean frequency', 'FontSize', 25);
title(han,'Correlation between OB frequency during safe freezing and ripples density', 'FontSize', 30);

% The shift in frequency can be observed but the shift in ripples density
% is quite weak for the majority of mice

% Look at the correlation between OB mean frequency and shifted density of ripples
fig=figure;
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples(mousenum);
    clear C1000_Corr_mouse C1000_Ripples_corr_mouse C1000_ShiftedRipples_corr_mouse C1000_Freq_corr_mouse C1000_Time_Binned_mouse c
    C1000_Freq_corr_mouse = C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum});
    C1000_Ripples_corr_mouse = C1000_Norm_noNaN_RipplesFzSafe.(C1000_Mouse_names{mousenum});
    if length(C1000_BinMean_Freq_FzSafe.(C1000_Mouse_names{mousenum})) ~= length(C1000_Norm_noNaN_RipplesFzSafe.(C1000_Mouse_names{mousenum}));
        C1000_Ripples_corr_mouse(end) = [];
    end
    C1000_ShiftedRipples_corr_mouse = circshift(C1000_Ripples_corr_mouse, 1);
    C1000_Time_Binned_mouse = (length(C1000_ShiftedRipples_corr_mouse)*20)-19;
%     C1000_Time_Binned_mouse = length(C1000_OB_Mean_Freq_20X.(C1000_Mouse_names{mousenum}));
    
    subplot(2,4,mousenum)
    sz = 50;
    c = (1:20:C1000_Time_Binned_mouse)*0.2;
    scatter(C1000_Freq_corr_mouse, C1000_ShiftedRipples_corr_mouse, sz, c, 'filled');
    colorbar
    axis square
%     heatmap(C1000_Corr_mouse);
    title(mouse)
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Ripples normalized density', 'FontSize', 25);
xlabel(han,'OB mean frequency', 'FontSize', 25);
title(han,'Correlation between OB frequency during safe freezing and shifted ripples density', 'FontSize', 25);
% There is no difference 

%% Explain the shift of the OB frequency for all mice
for mousenum=1:length(Mouse_C1000)
    C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}) = runmean_BM(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}),30);
    %figure; plot(smoothdata(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mouse}))
    C1000_Ind_learn_range.(C1000_Mouse_names{mousenum}) = find(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum})<(((max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))-min(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum})))/2)+min(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))));
    C1000_Ind_shift.(C1000_Mouse_names{mousenum}) = C1000_Ind_learn_range.(C1000_Mouse_names{mousenum})(1); % index at which the mice started learning
end %try to define min, max and DR for each mice (failed to do a field with a substraction)

% Represent the OB mean frequency with the shift
figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_C1000)
    mouse=C1000_names_ripples(mousenum);
    subplot(2,4,mousenum)
    plot(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}),'Color',colors(mousenum,:)), hold on
    plot(C1000_Ind_learn_range.(C1000_Mouse_names{mousenum}), max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))+1 , '.k')
    ylim([0 8])
    hold on
    line([C1000_Ind_shift.(C1000_Mouse_names{mousenum}) C1000_Ind_shift.(C1000_Mouse_names{mousenum})],ylim)
    title(mouse)
    xlabel('Timepoints of freezing')
    ylabel('Frequency (Hz)')
    makepretty
end
suptitle('C1000 OB frequency, low threshold and time spent below threshold (black)')

% Add the ripples
figure
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples(mousenum);
    subplot(2,4,mousenum)
    grid
    yyaxis left
    plot(runmean_BM(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}),30)), hold on
    plot(C1000_Ind_learn_range.(C1000_Mouse_names{mousenum}), max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))+0.5 , '.k'), hold on
    ylim([min(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))-0.8 max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))+0.8]), hold on
    line([C1000_Ind_shift.(C1000_Mouse_names{mousenum}) C1000_Ind_shift.(C1000_Mouse_names{mousenum})],ylim, 'Color', [0 0.6 .4])
    xlabel('Timepoints of freezing')
    title(mouse)
    makepretty
    yyaxis right
    grid
    plot(C1000_Ind_Match_SafeFz.(C1000_Mouse_names{mousenum}) , max(runmean_BM(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}),30))+0.5 , '*')
    ylabel([])
    title(mouse)
    makepretty
end
suptitle('C1000 OB frequency (blue), low threshold (green), time spent below threshold (black), and cumulative curve of ripples (orange)')

% Add the cumulative curve of ripples
figure
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples(mousenum);
    subplot(2,4,mousenum)
    grid
    yyaxis left
    plot(runmean_BM(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}),30)), hold on
    plot(C1000_Ind_learn_range.(C1000_Mouse_names{mousenum}), max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))+0.5 , '.k'), hold on
    ylim([min(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))-0.8 max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))+0.8]), hold on
    line([C1000_Ind_shift.(C1000_Mouse_names{mousenum}) C1000_Ind_shift.(C1000_Mouse_names{mousenum})],ylim, 'Color', [0 0.6 .4])
    xlabel('Timepoints of freezing')
    title(mouse)
    makepretty
    yyaxis right
    grid
    cdfplot(C1000_Ind_Match_SafeFz.(C1000_Mouse_names{mousenum}));
    ylabel([])
    title(mouse)
    makepretty
end
suptitle('C1000 OB frequency (blue), low threshold (green), time spent below threshold (black), and cumulative curve of ripples (orange)')

% Add the ripples density
figure
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples(mousenum);
    subplot(2,4,mousenum)
    grid
    yyaxis left
    plot(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum})), hold on
    plot(C1000_Ind_learn_range.(C1000_Mouse_names{mousenum}), max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))+0.5 ,'.', 'Color', [0.8 0.8 .8]), hold on
    ylim([min(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))-0.8 max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))+0.8]), hold on
    line([C1000_Ind_shift.(C1000_Mouse_names{mousenum}) C1000_Ind_shift.(C1000_Mouse_names{mousenum})],ylim, 'Color', [0 0.4 .7], 'LineWidth', 0.5), hold on
%     vline(C1000_Ind_EntryFsk_Match.(C1000_Mouse_names{mousenum}), '--r')
    xlabel('Timepoints of freezing')
    xlim([-10 length(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))])
    title(mouse)
    makepretty
    yyaxis right
    grid
    clear X_Normalized_RipplesFzSafe Y_Normalized_RipplesFzSafe
    X_Normalized_RipplesFzSafe=1:length(C1000_Normalized_RipplesFzsafe.(C1000_Mouse_names{mousenum}));
    X_Normalized_RipplesFzSafe=X_Normalized_RipplesFzSafe(~isnan((C1000_Normalized_RipplesFzsafe.(C1000_Mouse_names{mousenum}))));
    Y_Normalized_RipplesFzSafe=C1000_Normalized_RipplesFzsafe.(C1000_Mouse_names{mousenum})(~isnan((C1000_Normalized_RipplesFzsafe.(C1000_Mouse_names{mousenum}))));
    plot(X_Normalized_RipplesFzSafe, Y_Normalized_RipplesFzSafe, 'r-x')
    ylim([min(C1000_Normalized_RipplesFzsafe.(C1000_Mouse_names{mousenum}))-0.4 max(C1000_Normalized_RipplesFzsafe.(C1000_Mouse_names{mousenum}))+0.4]), hold on
    ylabel([])
    title(mouse)
    makepretty
end
suptitle('C1000 OB frequency (blue), low threshold (blue line), time spent below threshold (grey), normalized density of ripples and shocks (orange)')

%% Learning process hypothesis

% Hyp : learning is proportional to the time spent in the maze
for mousenum=1:length(Mouse_C1000)
    C1000_Mouse_names{mousenum}=['M' num2str(Mouse_C1000(mousenum))];
    C1000_Total_time_spent_maze.(C1000_Mouse_names{mousenum}) = max(Range(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1})); %takes the last value of time at which a frequency was recorded, ok?
    C1000_Time_shift.(C1000_Mouse_names{mousenum}) = C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum})(C1000_Ind_shift.(C1000_Mouse_names{mousenum})); % time at which the mice started learning
    C1000_Absolute_time_to_learn.(C1000_Mouse_names{mousenum}) = C1000_Time_shift.(C1000_Mouse_names{mousenum})
    C1000_Relative_time_to_learn.(C1000_Mouse_names{mousenum}) = (C1000_Time_shift.(C1000_Mouse_names{mousenum})/C1000_Total_time_spent_maze.(C1000_Mouse_names{mousenum}))*100
end

figure
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples
    subplot(1,2,1)
    plot(mousenum, C1000_Absolute_time_to_learn.(C1000_Mouse_names{mousenum}), '*'), hold on
    xlim([0.5 8.5])
    xticks(1:8)
    xticklabels(C1000_Mouse_names{mousenum})
    title('Absolute time to learn')
    subplot(1,2,2)
    plot(mousenum, C1000_Relative_time_to_learn.(C1000_Mouse_names{mousenum}), '*'), hold on
    xlim([0.5 8.5])
    xticks(1:8)
    xticklabels(C1000_Mouse_names{mousenum})
    title('Relative time to learn')
end
suptitle('Is learning explained by the total time spent in the maze?')

% Hyp : learning is proportional to the time spent freezing
for mousenum=1:length(Mouse_C1000)
    C1000_Mouse_names{mousenum}=['M' num2str(Mouse_C1000(mousenum))];
    C1000_Delta_Time.(C1000_Mouse_names{mousenum}) = min(diff(C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum})));
    C1000_Absolute_tfreezing_to_learn.(C1000_Mouse_names{mousenum}) = C1000_Ind_shift.(C1000_Mouse_names{mousenum})*C1000_Delta_Time.(C1000_Mouse_names{mousenum})
    C1000_Relative_tfreezing_to_learn.(C1000_Mouse_names{mousenum}) = C1000_Ind_shift.(C1000_Mouse_names{mousenum})/length(Range(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6}))
    % The raw data is used to compute the relative time freezing as we only studied the first 1000 timepoints
end

figure
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples
    subplot(1,2,1)
    plot(mousenum, C1000_Absolute_tfreezing_to_learn.(C1000_Mouse_names{mousenum}), '*'), hold on
    xlim([0.5 8.5])
    xticks(1:8)
    xticklabels(C1000_Mouse_names{mousenum})
    title('Absolute time to learn')
    subplot(1,2,2)
    plot(mousenum, C1000_Relative_tfreezing_to_learn.(C1000_Mouse_names{mousenum}), '*'), hold on
    xlim([0.5 8.5])
    xticks(1:8)
    xticklabels(C1000_Mouse_names{mousenum})
    title('Relative time to learn')
end
suptitle('Is learning explained by the total time spent freezing in the safe side?')

% Hyp : learning is proportional to the number of ripples 
for mousenum=1:length(C1000_names_ripples)
    C1000_Nabs_ripples_before_shift.(C1000_Mouse_names{mousenum}) = sum(C1000_Ind_Ripples_SafeFz.(C1000_Mouse_names{mousenum})<=C1000_Time_shift.(C1000_Mouse_names{mousenum}))
    C1000_Nrelative_ripples_before_shift.(C1000_Mouse_names{mousenum}) = sum(C1000_Ind_Ripples_SafeFz.(C1000_Mouse_names{mousenum})<=C1000_Time_shift.(C1000_Mouse_names{mousenum}))/length(C1000_Ind_Ripples_SafeFz.(C1000_Mouse_names{mousenum}))
end

% Stock all data and plot distributions to test the hypothesis

C1000_Learning_times = {cell2mat(struct2cell(C1000_Absolute_time_to_learn)), cell2mat(struct2cell(C1000_Relative_time_to_learn)), cell2mat(struct2cell(C1000_Absolute_tfreezing_to_learn)), cell2mat(struct2cell(C1000_Relative_tfreezing_to_learn))};


% Better to do distributions than boxplots, but here is an example of code
% colors_bp = {[0 0.6 .4]; [0 0.4 .4]; [1 0.4 0]; [1 0.2 0]};
% legends={'Absolute time to learn','Relative time to learn','Absolute time freezing to learn','Relative time freezing to learn'};
% for i=1:4
%     subplot(1,4,i)
%     boxplot(C1000_Learning_times{i})
%     xlabel(legends{i});
% end

%% Influence of ripples on OB frequency

for mousenum=1:length(C1000_names_ripples)
    Ind_nan.(C1000_Mouse_names{mousenum}) = isnan(C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum}));
    C1000_Ind_OB_Nonan.(C1000_Mouse_names{mousenum}) = C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum})(~Ind_nan.(C1000_Mouse_names{mousenum}));
    C1000_FRespi_Nonan.(C1000_Mouse_names{mousenum}) = C1000_Freq_Respi_SafeFz.(C1000_Mouse_names{mousenum})(~Ind_nan.(C1000_Mouse_names{mousenum}));
end 

binsize=20;
nbBins=50;
for mousenum=1:length(C1000_names_ripples)
    [C1000_Mean_Fr_Ripplesaligned.(C1000_Mouse_names{mousenum}),~,~]=mETAverage(C1000_Ind_Ripples_SafeFz.(C1000_Mouse_names{mousenum}),C1000_Ind_OB_Nonan.(C1000_Mouse_names{mousenum}),C1000_FRespi_Nonan.(C1000_Mouse_names{mousenum}),binsize,nbBins);
end 

figure
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples(mousenum);
    subplot(2,4,mousenum)
    plot(runmean_BM(C1000_Mean_Fr_Ripplesaligned.(C1000_Mouse_names{mousenum}),5)), vline(nbBins/2+1,'--r')
    title(mouse)
end %the result is not that coherent
suptitle('Average frequency 500ms before and after each ripple in the first 1000 timepoints of freezing')

%% Number of entries in the shock zone can reflect learning

% To have the Blocked Epochs
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat', 'BlockedEpoch')

% Compute number of shock/safe zone entries
names_C1000=fields(C1000_OB_Mean_Freq);
for mousenum=1:length(names_C1000)
    C1000_ShockFz_notBlocked.(C1000_Mouse_names{mousenum}) = EpochC.Cond{mousenum,5}-BlockedEpoch.Cond.(C1000_Mouse_names{mousenum}); %timepoints of fz in shock zone without being blocked
    C1000_ShockActive_notBlocked.(C1000_Mouse_names{mousenum}) = EpochC.Cond{mousenum,7}-BlockedEpoch.Cond.(C1000_Mouse_names{mousenum}); %timepoints active in shock zone without being blocked
    C1000_ShockEpoch_notBlocked.(C1000_Mouse_names{mousenum}) = or(C1000_ShockFz_notBlocked.(C1000_Mouse_names{mousenum}), C1000_ShockActive_notBlocked.(C1000_Mouse_names{mousenum})); % timepoints active or fz in shock zone not considering blocked epochs
end

for mousenum=1:length(names_C1000)
    C1000_SafeFz_notBlocked.(C1000_Mouse_names{mousenum}) = EpochC.Cond{mousenum,6}-BlockedEpoch.Cond.(C1000_Mouse_names{mousenum});
    C1000_SafeActive_notBlocked.(C1000_Mouse_names{mousenum}) = EpochC.Cond{mousenum,8}-BlockedEpoch.Cond.(C1000_Mouse_names{mousenum});
    C1000_SafeEpoch_notBlocked.(C1000_Mouse_names{mousenum}) = or(C1000_SafeFz_notBlocked.(C1000_Mouse_names{mousenum}), C1000_SafeActive_notBlocked.(C1000_Mouse_names{mousenum})); 
end

for mousenum=1:length(names_C1000)
    C1000_sk_entries.(C1000_Mouse_names{mousenum}) = Start(C1000_ShockEpoch_notBlocked.(C1000_Mouse_names{mousenum})); % ind of shock zone entries 
    C1000_safe_entries.(C1000_Mouse_names{mousenum}) = Start(C1000_SafeEpoch_notBlocked.(C1000_Mouse_names{mousenum})); % ind of safe zone entries 
    C1000_N_sk_entries.(C1000_Mouse_names{mousenum}) = length(Start(C1000_ShockEpoch_notBlocked.(C1000_Mouse_names{mousenum}))); % number of shock zone entries 
    C1000_N_safe_entries.(C1000_Mouse_names{mousenum}) = length(Start(C1000_SafeEpoch_notBlocked.(C1000_Mouse_names{mousenum}))); % number of safe zone entries 
end

% Plot f_OB  during all the conditionning with the sk zone entries
figure
for mousenum=1:length(names_C1000)
    mouse=names_C1000(mousenum);
    subplot(2,4,mousenum)
    plot(Range(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}), runmean_BM(Data(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}),30))
    hold on
    vline(C1000_sk_entries.(C1000_Mouse_names{mousenum}), '--r')
    ylim([0 12])
    title(mouse)
    makepretty
end
suptitle('f OB during all the conditionning with the sk zone entries')

% Align all the timepoints that correspond more or less to the shock zone entries with OB frequency during safe freezing  
for mousenum=1:length(names_C1000)
    for i=1:length(C1000_sk_entries.(C1000_Mouse_names{mousenum}))
        C1000_Ind_Entrysk_Match.(C1000_Mouse_names{mousenum})(i) = sum(C1000_sk_entries.(C1000_Mouse_names{mousenum})(i)>C1000_Ind_OB_SafeFz.(C1000_Mouse_names{mousenum}));
    end
    C1000_Ind_Entrysk_Match.(C1000_Mouse_names{mousenum})=unique(C1000_Ind_Entrysk_Match.(C1000_Mouse_names{mousenum}));
end

% Plot Fz safe with ripples and shock indices 
figure
for mousenum=1:length(C1000_names_ripples)
    mouse=C1000_names_ripples(mousenum);
    subplot(2,4,mousenum)
    grid
    yyaxis left
    plot(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum})), hold on
    plot(C1000_Ind_learn_range.(C1000_Mouse_names{mousenum}), max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))+0.5 ,'.', 'Color', [0.8 0.8 .8]), hold on
    ylim([min(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))-0.8 max(C1000_OB_Mean_Freq.(C1000_Mouse_names{mousenum}))+0.8]), hold on
    line([C1000_Ind_shift.(C1000_Mouse_names{mousenum}) C1000_Ind_shift.(C1000_Mouse_names{mousenum})],ylim, 'Color', [0 0.4 .7], 'LineWidth', 0.5), hold on
    vline(C1000_Ind_Entrysk_Match.(C1000_Mouse_names{mousenum}), '--r')
    xlabel('Timepoints of freezing')
    title(mouse)
    makepretty
    yyaxis right
    grid
    cdfplot(C1000_Ind_Match_SafeFz.(C1000_Mouse_names{mousenum}));
    ylabel([])
    title(mouse)
    
end
suptitle('C1000 OB frequency (blue), low threshold (blue line), time spent below threshold (grey), cumulative curve of ripples and shocks (orange)')


%% Linear position (not used for the analysis)

figure
plot(Range(C1000_TSD_DATA.Cond.linearposition.tsd{1,1}), Data(C1000_TSD_DATA.Cond.linearposition.tsd{1,1}))
hold on
plot(Range(C1000_TSD_DATA.Cond.linearposition.tsd{1,3}), Data(C1000_TSD_DATA.Cond.linearposition.tsd{1,3}))
plot(Range(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{1,6}), runmean_BM(Data(C1000_TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30))
figure
plot(Data(Restrict(C1000_TSD_DATA.Cond.linearposition.tsd{1,5},BlockedEpoch.Cond.M688)))










