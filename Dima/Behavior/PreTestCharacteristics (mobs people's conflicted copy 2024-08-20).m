%%% PreTestCharacterictics

%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Behavior/';
fig_post = 'PreTestSmallZone';
% Before Vtsd correction == 1
old = 0;
sav = 0;

% % Numbers of mice to run analysis on
% Mice_to_analyze = [711 712 714 742 753];
% 
% % Get directories
% Dir = PathForExperimentsERC_Dima('TestPrePooled');
% Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

Dir = PathForExperimentsPAGTest_Dima('TestPre');
Dir785 = RestrictPathForExperiment(Dir, 'Group', 'Posterior'); % Get rid of misses
Dir785 = RestrictPathForExperiment(Dir785, 'nMice', 785 ); % Get rid of misses
Dir = RestrictPathForExperiment(Dir, 'nMice', [786 787 788]); % Get rid of misses
Dir = MergePathForExperiment(Dir785, Dir);

% Axes
fh = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
Occupancy_Axes = axes('position', [0.07 0.55 0.41 0.41]);
NumEntr_Axes = axes('position', [0.55 0.55 0.41 0.41]);
First_Axes = axes('position', [0.07 0.05 0.41 0.41]);
Speed_Axes = axes('position', [0.55 0.05 0.41 0.41]);

%% Get data

for i = 1:length(Dir.path)
    % PreTests
    a = load([Dir.path{i}{1} '/behavResources.mat'],...
        'Occup', 'PosMat', 'Vtsd', 'ZoneIndices');
    Pre_Vtsd{i} = a.Vtsd;
    PreTest_PosMat{i} = a.PosMat;
    PreTest_occup(i,1:7) = a.Occup;
    PreTest_ZoneIndices{i} = a.ZoneIndices;
end

%% Calculate average occupancy
% Mean and STD across 4 Pre- and PostTests
PreTest_occup = PreTest_occup*100;

Pre_Occup_mean = mean(PreTest_occup,1);
Pre_Occup_std = std(PreTest_occup,1);
% Wilcoxon signed rank task between Pre and PostTest
p_pre = signrank(PreTest_occup(:,1),PreTest_occup(:,2));
% Prepare arrays for plotting
point_pre = [PreTest_occup(:,1) PreTest_occup(:,2)];

%% Prepare the 'first enter to shock zone' array
for u = 1:length(Dir.path)
    if isempty(PreTest_ZoneIndices{u}{1})
        Shock_FirstTime(u) = 240;
    else
        Shock_FirstZoneIndices(u) = PreTest_ZoneIndices{u}{1}(1);
        Shock_FirstTime(u) = PreTest_PosMat{u}(Shock_FirstZoneIndices(u),1);
    end
    
    if isempty(PreTest_ZoneIndices{u}{2})
        Safe_FirstTime(u) = 240;
    else
        Safe_FirstZoneIndices(u) = PreTest_ZoneIndices{u}{2}(1);
        Safe_FirstTime(u) = PreTest_PosMat{u}(Safe_FirstZoneIndices(u),1);
    end
    
    Shock_Safe_FirstTime(u, 1:2) = [Shock_FirstTime(u) Safe_FirstTime(u)];
end
    
Shock_Safe_FirstTime_mean = mean(Shock_Safe_FirstTime,1);
Shock_Safe_FirstTime_std = std(Shock_Safe_FirstTime,1);
p_FirstTime_shock_safe = signrank(Shock_Safe_FirstTime(:,1),Shock_Safe_FirstTime(:,2));

%% Calculate number of entries into the shock zone
% Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
for m = 1:length(Dir.path)
    if isempty(PreTest_ZoneIndices{m}{1})
        Shock_entnum(m) = 0;
    else
        Shock_entnum(m)=length(find(diff(PreTest_ZoneIndices{m}{1})>1))+1;
    end
    
    if isempty(PreTest_ZoneIndices{m}{2})
        Safe_entnum(m)=0;
    else
        Safe_entnum(m)=length(find(diff(PreTest_ZoneIndices{m}{2})>1))+1;
    end
    
end
Shock_Safe_entnum = [Shock_entnum; Safe_entnum]';
Shock_Safe_entnum_mean = mean(Shock_Safe_entnum,1);
Shock_Safe_entnum_std = std(Shock_Safe_entnum,1);
p_entnum_Shock_Safe = signrank(Shock_entnum, Safe_entnum);%Save it

%% Calculate speed in the shock zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
% - UPD 18/07/2018 - Could do length(Start(ZoneEpoch))
for r=1:length(Dir.path)
        % PreTest ShockZone speed
        if isempty(PreTest_ZoneIndices{r}{1})
            VZmean_shock(r) = 0;
        else
            if old
                Vtemp_shock{r} = tsd(Range(Pre_Vtsd{r}),(Data(Pre_Vtsd{r})./([diff(PreTest_PosMat{r}(:,1));-1])));
            else
                Vtemp_shock{r}=Data(Pre_Vtsd{r});
            end
            VZone_shock{r}=Vtemp_shock{r}(PreTest_ZoneIndices{r}{1}(1:end-1),1);
            VZmean_shock(r)=mean(VZone_shock{r},1);
        end
        
        % PostTest ShockZone speed
        if isempty(PreTest_ZoneIndices{r}{2})
            VZmean_safe(r) = 0;
        else
            if old
                Vtemp_safe{r} = tsd(Range(Pre_Vtsd{r}),(Data(Pre_Vtsd{r})./([diff(PreTest_PosMat{r}(:,1));-1])));
            else
                Vtemp_safe{r}=Data(Pre_Vtsd{r});
            end
           VZone_safe{r}=Vtemp_safe{r}(PreTest_ZoneIndices{r}{2}(1:end-1),1);
           VZmean_safe(r)=mean(VZone_safe{r},1);
        end
        
end

Shock_Safe_VZmean = [VZmean_shock; VZmean_safe]';
Shock_Safe_VZmean_mean = mean(Shock_Safe_VZmean,1);
Shock_Safe_VZmean_std = std(Shock_Safe_VZmean,1);
p_VZmean_shock_safe = signrank(VZmean_shock, VZmean_safe);

%% Plot

% Occupancy
axes(Occupancy_Axes);
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([PreTest_occup(:,1) PreTest_occup(:,2)], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'ShockZone', 'SafeZone'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h_occ.FaceColor = 'flat';
h_occ.CData(1,:) = [1 0 0];
h_occ.CData(2,:) = [0 0 1];
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
ylabel('% time');
title('Percentage of the ShockZone occupancy', 'FontSize', 14);

axes(NumEntr_Axes);
[p_nent,h_nent, her_nent] = PlotErrorBarN_DB(Shock_Safe_entnum, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'ShockZone', 'SafeZone'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h_nent.FaceColor = 'flat';
h_nent.CData(1,:) = [1 0 0];
h_nent.CData(2,:) = [0 0 1];
set(h_nent, 'LineWidth', 3);
set(her_nent, 'LineWidth', 3);
ylabel('Number of entries');
title('# of entries to the ShockZone', 'FontSize', 14);

axes(First_Axes);
[p_first,h_first, her_first] =PlotErrorBarN_DB(Shock_Safe_FirstTime, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'ShockZone', 'SafeZone'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h_first.FaceColor = 'flat';
h_first.CData(1,:) = [1 0 0];
h_first.CData(2,:) = [0 0 1];
set(h_first, 'LineWidth', 3);
set(her_first, 'LineWidth', 3);
ylabel('Time (s)');
title('First time to enter the ShockZone', 'FontSize', 14);

axes(Speed_Axes);
[p_speed,h_speed, her_speed] = PlotErrorBarN_DB(Shock_Safe_VZmean, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'ShockZone', 'SafeZone'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h_speed.FaceColor = 'flat';
h_speed.CData(1,:) = [1 0 0];
h_speed.CData(2,:) = [0 0 1];
set(h_speed, 'LineWidth', 3);
set(her_speed, 'LineWidth', 3);
ylabel('Speed (cm/s)');
title('Average speed in the SafeZone', 'FontSize', 14);

%% Save it
if sav
    saveas(gcf, [dir_out fig_post '.fig']);
    saveFigure(gcf,fig_post,dir_out);
end

%% Clear variables
clear