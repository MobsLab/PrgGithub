%% Get Data
clear all
SingleMiceFolder = '/home/vador/Documents/Marcelo/Results/SleepImportance/SingleMiceData';
cd(SingleMiceFolder)
D = dir;
D = D(~ismember({D.name}, {'.', '..'}));

for k = 1:numel(D)
    load(D(k).name);
%     MouseName(k) = MouseData.MouseName;
    OccupPre(:,k) = MouseData.OccupPreMean;
    OccupPreStd(:,k) = MouseData.OccupPreStd;
    OccupPosPAG(:,k) = MouseData.OccupPosPAGMean;
    OccupPosPAGStd(:,k) = MouseData.OccupPosPAGStd;
    OccupPAG(:,k) = MouseData.OccupPAGMean;
    OccupPAGStd(:,k) = MouseData.OccupPAGStd;
    NumEntPre(k) = MouseData.NumEntPreMean;
    NumEntPreStd(k) = MouseData.NumEntPreStd;
    NumEntPosPAG(k) = MouseData.NumEntPosPAGMean;
    NumEntPosPAGStd(k) = MouseData.NumEntPosPAGStd;
    NumCondPAG(k) = MouseData.NumCondPAG;
    FirstTimeShockPre(k) = MouseData.FirstTimeShockPreMean;
    FirstTimeShockPreStd(k) = MouseData.FirstTimeShockPreStd;
    FirstTimeShockPosPAG(k) = MouseData.FirstTimeShockPosPAGMean;
    FirstTimeShockPosPAGStd(k) = MouseData.FirstTimeShockPosPAGStd;
    SpeedShockPre(k) = MouseData.SpeedShockPreMean;
    SpeedShockPre(k) = MouseData.SpeedShockPreStd;
    SpeedSafePre(k) = MouseData.SpeedSafePreMean;
    SpeedSafePreStd(k) = MouseData.SpeedSafePreStd;
    SpeedShockPosPAG(k) = MouseData.SpeedShockPosPAGMean;
    SpeedShockPosPAGStd(k) = MouseData.SpeedShockPosPAGStd;
    SpeedSafePosPAG(k) = MouseData.SpeedSafePosPAGMean;
    SpeedSafePosPAGStd(k) = MouseData.SpeedSafePosPAGStd;
end

%% Plot

% Axes
fh = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
Occupancy_Axes = axes('position', [0.07 0.55 0.41 0.41]);
NumEntr_Axes = axes('position', [0.55 0.55 0.41 0.41]);
First_Axes = axes('position', [0.07 0.05 0.41 0.41]);
Speed_Axes = axes('position', [0.55 0.05 0.41 0.41]);

% Occupancy
axes(Occupancy_Axes);
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([OccupPre(1,:)'*100 OccupPosPAG(1,:)'*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',1);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [1 1 1];
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',3);
text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
ylabel('% time');
title('Percentage of the ShockZone occupancy', 'FontSize', 14);
ylim([0 35])

axes(NumEntr_Axes);
[p_nent,h_nent, her_nent] = PlotErrorBarN_DB([NumEntPre' NumEntPosPAG'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',1);
h_nent.FaceColor = 'flat';
h_nent.CData(2,:) = [1 1 1];
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(h_nent, 'LineWidth', 3);
set(her_nent, 'LineWidth', 3);
ylabel('Number of entries');
title('# of entries to the ShockZone', 'FontSize', 14);
ylim([0 8])

axes(First_Axes);
[p_first,h_first, her_first] = PlotErrorBarN_DB([FirstTimeShockPre' FirstTimeShockPosPAG'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',1);
h_first.FaceColor = 'flat';
h_first.CData(2,:) = [1 1 1];
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(h_first, 'LineWidth', 3);
set(her_first, 'LineWidth', 3);
ylabel('Time (s)');
title('First time to enter the ShockZone', 'FontSize', 14);

axes(Speed_Axes);
[p_speed,h_speed, her_speed] = PlotErrorBarN_DB([SpeedSafePre' SpeedSafePosPAG'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',1);
h_speed.FaceColor = 'flat';
h_speed.CData(2,:) = [1 1 1];
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(h_speed, 'LineWidth', 3);
set(her_speed, 'LineWidth', 3);
ylabel('Speed (cm/s)');
title('Average speed in the SafeZone', 'FontSize', 14);
ylim([0 8])