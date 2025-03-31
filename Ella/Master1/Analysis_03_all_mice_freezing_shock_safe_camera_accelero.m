%% Objectives of this code

% Compare the OB frequency for all mice (groups 1 + 5) during freezing
% shock and safe in conditioning sessions, to make sure the shift in
% frequency is present and reliable

% Freezing safe and shock along the absolute time in conditioning 
% Freezing safe along the absolute time of the experiment spent in safe
%%% side (interpolaiton without the time spent in shock side)

% Threshold on the difference between shock and safe side freezing

% Freezing camera epochs and comparison to the accelerometer on the time
%%% freezing and the time in conditioning, comparison of the indexes
% Specificity of the camera and accelerometer 
% Correlation between the frequencies obtained with restricted values of camera and accelerometer


%% Paths
SaveFigsTo = '/home/gruffalo/Link to Dropbox/Kteam/PrgMatlab/Ella/Analysis_Figures/New_freq_measurement';

%% Selected mice

%from
%Mouse_gr1=[688 739 777 779 849 893] % group1: saline mice, long protocol, SB
%Mouse_gr5=[1170 1171 9184 1189 9205 1391 1392 1393 1394] % group 5: saline short BM first Maze
% Mouse_C = [688 739 777 849 1171 1189 1393 1394];
%to
Mouse_ALL=[688 739 777 779 849 893 1170 1171 9184 1189 9205 1391 1392 1393 1394]; 

%% Extract data for all mice during shock and safe side freezing
Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [ALL_TSD_DATA.(Session_type{sess}) , EpochALL.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_ALL,lower(Session_type{sess}), 'respi_freq_BM','ripples','linearposition','instfreq');
end

% Compute OB frequency and ripples during freezing shock
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5});
    if isnan(ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1))
        ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(end))
        ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL_RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),30);
    ALL_Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}) == 0
        ALL_Ind_Ripples.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}); 
    end
end

% Compute OB frequency and ripples during freezing safe
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if isnan(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1))
        ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(end))
        ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),30);
    ALL_Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}) == 0
        ALL_Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
    end
end

%% Freezing along the absolute time of the experiment

%OB frequencies during freezing episodes across the global time of the trial
for mousenum=1:length(Mouse_ALL)
    ALL_Time_spent_maze.(ALL_Mouse_names{mousenum}) = min(Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1})):ceil(min(diff(ALL_Ind_OB.SafeFz.(ALL_Mouse_names{mousenum})))):max(Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}));
    ALL_Time_spent_maze.(ALL_Mouse_names{mousenum}) = (ALL_Time_spent_maze.(ALL_Mouse_names{mousenum}))/600000;
    ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = interp1((ALL_Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}))/600000, runmean_BM(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),30), ALL_Time_spent_maze.(ALL_Mouse_names{mousenum}));
    ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = interp1((ALL_Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}))/600000, runmean_BM(ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),30), ALL_Time_spent_maze.(ALL_Mouse_names{mousenum}));
    ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
end

% Plot the OB mean frequency during freezing across absolute time of the conditioning session
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)
    plot(ALL_Time_spent_maze.(ALL_Mouse_names{mousenum}), runmean_BM(ALL_Global_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),30),'Color',[1 0.4 0]), hold on
    plot(ALL_Time_spent_maze.(ALL_Mouse_names{mousenum}), runmean_BM(ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),30),'Color',[0 0.4 .7]), hold on
%     plot((ALL_Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}))/600000, 6.5, '.k')
%     plot(ALL_Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}), max(runmean_BM(ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),30))+0.5, '.k')
%     ylim([min(ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))-0.8 max(ALL_Global_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))+0.8])
    ylim([2 10])
    title(mouse, 'FontSize', 15)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Absolute time of conditioning session (min)', 'FontSize', 25);
title(han,'ALL OB frequency during absolute time freezing', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_fz_safe_abstime_cond'), 'png');

%% Freezing safe along the absolute time of the experiment spent in safe side
% I thought it would be clearer but it is not that useful, mice spend the
% vast majority of their time in safe arm
GetEmbReactMiceFolderList_BM

% Extract zone (shock and safe) epochs
for mousenum=1:length(Mouse_ALL)
    ALL_ZoneEpoch.(ALL_Mouse_names{mousenum}) = ConcatenateDataFromFolders_SB(CondSess.(ALL_Mouse_names{mousenum}),'Epoch','epochname','zoneepoch');
    ALL_ZoneEpoch.Shock.(ALL_Mouse_names{mousenum}) = ALL_ZoneEpoch.(ALL_Mouse_names{mousenum}){1};
    ALL_ZoneEpoch.Safe.(ALL_Mouse_names{mousenum}) = or(ALL_ZoneEpoch.(ALL_Mouse_names{mousenum}){2}, ALL_ZoneEpoch.(ALL_Mouse_names{mousenum}){5});
end

%OB frequencies during freezing episodes across the global time of the trial
for mousenum=1:length(Mouse_ALL)
    ALL_Time_spent_maze.Safe.(ALL_Mouse_names{mousenum}) = Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}, ALL_ZoneEpoch.Safe.(ALL_Mouse_names{mousenum}));
    ALL_Time_spent_maze.Shock.(ALL_Mouse_names{mousenum}) = Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}, ALL_ZoneEpoch.Shock.(ALL_Mouse_names{mousenum}));
    
    ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = interp1(ALL_Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}), runmean_BM(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),30), Range(ALL_Time_spent_maze.Safe.(ALL_Mouse_names{mousenum})));
    ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = interp1(ALL_Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}), runmean_BM(ALL_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),30), Range(ALL_Time_spent_maze.Shock.(ALL_Mouse_names{mousenum})));
    ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
end

% Plot the OB mean frequency during freezing across absolute time of the
% conditioning session without moments spent in shock arm
fig=figure;
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)
    plot(runmean_BM(ALL_Zone_Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),30),'Color',[1 0.4 0]), hold on
    plot(runmean_BM(ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),30),'Color',[0 0.4 .7]), hold on
%     ylim([min(ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))-0.8 max(ALL_Zone_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))+0.8])
    ylim([2 6])
    title(mouse, 'FontSize', 15)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Absolute time of conditioning session (min)', 'FontSize', 25);
title(han,'ALL OB frequency during absolute time freezing', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_fz_safe_abstime_cond'), 'png');

%% Freezing safe and shock concatenated epochs

% Plot freezing shock and safe for each mouse
fig=figure;
colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)
    
    clear All_Time
    ALL_Time.SafeFz = (1:length(ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2/60; % compute time spent freezing in seconds
    ALL_Time.ShockFz = (1:length(ALL_RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})))*0.2/60; % compute time spent freezing in seconds

    plot(ALL_Time.ShockFz, ALL_RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot(ALL_Time.SafeFz, ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(2,:)), hold on
    ylim([2 7])
    title(mouse)
%     legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (min)', 'FontSize', 25);
title(han,'OB frequencies during shock and safe side freezing', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_fz_shock_safe'), 'png');

%% When does the OB frequency on safe side become different from the one on shock side?

% Add significativity in difference (Fshock > Fsafe)
for mousenum=1:length(Mouse_ALL)
    for i=1:length(ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))
        [ALL_h_Fsk_Fsafe(mousenum,i),ALL_p_Fsk_Fsafe(mousenum,i)] = ttest2(ALL_RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}), ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})(i), 'Tail','right', 'Alpha', 0.001);
        % Alpha can be changed to increase the threshold of significativity
    end
    for j=1:length(ALL_h_Fsk_Fsafe(mousenum,:))
        if j>length(ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))
            ALL_h_Fsk_Fsafe(mousenum,j)=NaN; 
        end
    end
    for j=1:length(ALL_p_Fsk_Fsafe(mousenum,:))
        if j>length(ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}))
            ALL_p_Fsk_Fsafe(mousenum,j)=NaN; 
        end
    end
end

fig=figure;
colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)
    
    clear All_Time
    ALL_Time.SafeFz = (1:length(ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    ALL_Time.ShockFz = (1:length(ALL_RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum})))*0.2; % compute time spent freezing in seconds
    clear ALL_h_mouse ind_Nan ALL_h_Fsk_Fsafe_mouse
    ALL_h_mouse=ALL_h_Fsk_Fsafe(mousenum,:);
    ind_Nan=isnan(ALL_h_Fsk_Fsafe(mousenum,:));
    ALL_h_Fsk_Fsafe_mouse=ALL_h_mouse(~ind_Nan);
    
    plot(ALL_Time.ShockFz, ALL_RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot(ALL_Time.SafeFz, ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(2,:)), hold on
    try; plot(ALL_Time.SafeFz(logical(ALL_h_Fsk_Fsafe_mouse)), max(ALL_RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}))+1, '*k'); end
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

%% Freezing camera

GetEmbReactMiceFolderList_BM

% Extract zone (shock and safe) epochs
for mousenum=1:length(Mouse_ALL)
    ALL_ZoneEpoch.(ALL_Mouse_names{mousenum}) = ConcatenateDataFromFolders_SB(CondSess.(ALL_Mouse_names{mousenum}),'Epoch','epochname','zoneepoch');
    ALL_ZoneEpoch.Shock.(ALL_Mouse_names{mousenum}) = ALL_ZoneEpoch.(ALL_Mouse_names{mousenum}){1};
    ALL_ZoneEpoch.Safe.(ALL_Mouse_names{mousenum}) = or(ALL_ZoneEpoch.(ALL_Mouse_names{mousenum}){2}, ALL_ZoneEpoch.(ALL_Mouse_names{mousenum}){5});
end

% Extract Fz camera epochs and deduce the Fz Camera shock and safe epochs
for mousenum=1:length(Mouse_ALL)
    ALL_Freeze_Camera.(ALL_Mouse_names{mousenum}) = ConcatenateDataFromFolders_SB(CondSess.(ALL_Mouse_names{mousenum}),'epoch','epochname','freeze_epoch_camera');
    ALL_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum}) = and(ALL_Freeze_Camera.(ALL_Mouse_names{mousenum}), ALL_ZoneEpoch.Shock.(ALL_Mouse_names{mousenum}));
    ALL_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}) = and(ALL_Freeze_Camera.(ALL_Mouse_names{mousenum}), ALL_ZoneEpoch.Safe.(ALL_Mouse_names{mousenum}));
end

% Restrict the TSD data (frequency, ripples) to these epochs
for mousenum=1:length(Mouse_ALL)
    % Define the restricted object before applying data and range to it
    ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum}) = Data(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})));
    if isnan(ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})(1))
        ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})), 1)) = ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})(end))
        ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}) = Data(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})));
    if isnan(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})(1))
        ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})), 1)) = ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})(end))
        ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})(find(~isnan(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end

    ALL_RunMeanFreq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum}),30);
    ALL_RunMeanFreq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}),30);

    ALL_Ind_OB_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum}) = Range(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})));
    ALL_Ind_OB_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}) = Range(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})));

%     if isempty(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum,1},ALL_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum}))) == 0
%         ALL_Ind_RipplesFzCameraEpoch.Shock.(ALL_Mouse_names{mousenum}) = Range(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum,1},ALL_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum}))); 
%     end
% 
%     if isempty(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum,1},ALL_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}))) == 0
%         ALL_Ind_RipplesFzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}) = Range(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum,1},ALL_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}))); 
%     end
end  

% Plot OB frequency during freezing camera on shock and safe side
fig=figure;
colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)

    plot(runmean_BM(ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum}),ceil(1/100*length(ALL_Freq_FzCameraEpoch.Shock.(ALL_Mouse_names{mousenum})))),'Color',colors(3,:)), hold on
    plot(runmean_BM(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}),ceil(1/100*length(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})))),'Color',colors(2,:)), hold on
    ylim([2 10])
    title(mouse)
%     legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'OB frequencies during camera shock and safe side freezing', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_camerafz_shock_safe'), 'png');

% Compare freezing camera to freezing accelerometer on safe side across all
% timepoints of freezing
fig=figure;
colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)

    plot(runmean_BM(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}), ceil(1/100*length(ALL_Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})))),'Color',colors(3,:)), hold on
    plot(runmean_BM(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}),ceil(1/100*length(ALL_Freq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})))),'Color',colors(2,:)), hold on
    ylim([2 10])
    title(mouse)
%     legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Timepoints of freezing', 'FontSize', 25);
title(han,'OB frequencies during accelerometer (orange) and camera (green) safe side freezing', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_accelero_camerafz_safe_tfreezing'), 'png');

% Compare freezing camera to freezing accelerometer on safe side across all
% timepoints of conditioning session
fig=figure;
colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)

    plot(ALL_Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}), ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot(ALL_Ind_OB_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}), ALL_RunMeanFreq_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}),'Color',colors(1,:)), hold on
    ylim([2 10])
    title(mouse)
%     legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Timepoints of conditioning session', 'FontSize', 25);
title(han,'OB frequencies during accelerometer (orange) and camera (green) safe side freezing', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_accelero_camerafz_safe'), 'png');

% Compare indices of freezing camera to freezing accelerometer on safe side 
fig=figure;
colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)

    plot(ALL_Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}), 4, '.r'), hold on
    plot(ALL_Ind_OB_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum}), 5,'.g'), hold on
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
    AA = ALL_Ind_OB_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum});
    BB = ALL_Ind_OB.SafeFz.(ALL_Mouse_names{mousenum});
    CC(mousenum) = sum(ismembertol(AA, BB))== length(BB);
end

% Compare freezing camera to freezing accelerometer on safe side across restricted epochs
for mousenum=1:length(Mouse_ALL)
    ALL_Restrict_CamtoAccFz.Safe.(ALL_Mouse_names{mousenum}) = Restrict(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1},ALL_FzCameraEpoch.Safe.(ALL_Mouse_names{mousenum})),ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
end

fig=figure;
colors = [0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .7; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(5,3,mousenum)

    plot(ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(3,:)), hold on
    plot(runmean_BM(Data(ALL_Restrict_CamtoAccFz.Safe.(ALL_Mouse_names{mousenum})),30),'Color',colors(1,:)), hold on
    ylim([2 10])
    title(mouse)
%     legend({'Shock', 'Safe'})
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Timepoints freezing restricted to accelerometer', 'FontSize', 25);
title(han,'OB frequencies during accelerometer (orange) and camera (green) safe side freezing', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_accelero_camerafz_safe_restricted'), 'png');

% Correlation between freezing camera and freezing accelerometer on safe side

figure % for a mouse
plot(ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), runmean_BM(Data(ALL_Restrict_CamtoAccFz.Safe.(ALL_Mouse_names{mousenum})),30),  '.k')
axis square
line([2 9],[2 9],'LineStyle','--','Color','r','LineWidth',2)
xlim([2 9]), ylim([2 9])
ylabel('Camera freezing frequencies restricted to accelerometer timepoints')
xlabel('Accelerometer freezing frequecies')
title('M688')
    
fig=figure; % for all mouse
for mousenum=1:8
    mouse=ALL_Mouse_names(mousenum);
    subplot(2,4,mousenum)
    plot(ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), runmean_BM(Data(ALL_Restrict_CamtoAccFz.Safe.(ALL_Mouse_names{mousenum})),30),  '.k')
    axis square
    line([2 9],[2 9],'LineStyle','--','Color','r','LineWidth',2)
    xlim([2 9]), ylim([2 9])
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Camera freezing frequencies restricted to accelerometer timepoints', 'FontSize', 18);
xlabel(han,'Accelerometer freezing frequecies', 'FontSize', 25);
title(han,'Correlation between freezing camera and freezing accelerometer on safe side', 'FontSize', 30);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_corr_camerafz_shock_safe_01'), 'png');

fig=figure; % for all mouse
for mousenum=8:15
    mouse=ALL_Mouse_names(mousenum);
    subplot(2,4,mousenum-7)
    plot(ALL_RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), runmean_BM(Data(ALL_Restrict_CamtoAccFz.Safe.(ALL_Mouse_names{mousenum})),30),  '.k')
    axis square
    line([2 9],[2 9],'LineStyle','--','Color','r','LineWidth',2)
    xlim([2 9]), ylim([2 9])
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Camera freezing frequencies restricted to accelerometer timepoints', 'FontSize', 18);
xlabel(han,'Accelerometer freezing frequecies', 'FontSize', 25);
title(han,'Correlation between freezing camera and freezing accelerometer on safe side', 'FontSize', 30);
% saveas(gcf, fullfile(SaveFigsTo, 'ALL_OBfreq_corr_camerafz_shock_safe_02'), 'png');







