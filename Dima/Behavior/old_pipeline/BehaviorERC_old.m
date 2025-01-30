%BehaviorERC - Plot basic behavior comparisons of ERC experiment avergaed across mice.
%
% Plot occupance in the shock zone in the PreTests vs PostTests
% Plot number of entries in the shock zone in the PreTests vs PostTests
% Plot time to enter in the shock zone in the PreTests vs PostTests
% Plot average speed in the shock zone in the PreTests vs PostTests
% 
% 
%  OUTPUT
%
%    Figure
%
%       See
%   
%       QuickCheckBehaviorERC, PathForExperimentERC_Dima
% 
%       2018 by Dmitri Bryzgalov

%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Behavior/';
fig_post = 'AllMiceBasicBehaviorImmediatePostTests';
% Before Vtsd correction == 1
old = 0;
sav = 0;

% Numbers of mice to run analysis on
Mice_to_analyze = [797 798 828 861];

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

suf = {'TestPre'; 'TestPost'};

clrs = {'ko', 'ro', 'go','co'; 'k','r', 'g', 'c'};

% Axes
fh = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
Occupancy_Axes = axes('position', [0.07 0.55 0.41 0.41]);
NumEntr_Axes = axes('position', [0.55 0.55 0.41 0.41]);
First_Axes = axes('position', [0.07 0.05 0.41 0.41]);
Speed_Axes = axes('position', [0.55 0.05 0.41 0.41]);

%% Get data

for i = 1:length(Dir.path)
    % PreTests
    a = load([Dir.path{i}{1} suf{1} '/behavResources.mat'],...
        'Occup', 'PosMat', 'Vtsd', 'ZoneIndices');
    Pre_Vtsd{i} = a.Vtsd;
    PreTest_PosMat{i} = a.PosMat;
    PreTest_occup(i,1:7) = a.Occup;
    PreTest_ZoneIndices{i} = a.ZoneIndices;
    % PostTests
    b = load([Dir.path{i}{1} suf{2} '/' '/behavResources.mat'],...
    'Occup', 'PosMat', 'Vtsd', 'ZoneIndices');
    Post_Vtsd{i} = b.Vtsd;
    PostTest_PosMat{i} = b.PosMat;
    PostTest_occup(i,1:7) = b.Occup;
    PostTest_ZoneIndices{i} = b.ZoneIndices;
end

%% Calculate average occupancy
% Mean and STD across 4 Pre- and PostTests
PreTest_occup = PreTest_occup*100;
PostTest_occup = PostTest_occup*100;

Pre_Occup_mean = mean(PreTest_occup,1);
Pre_Occup_std = std(PreTest_occup,1);
Post_Occup_mean = mean(PostTest_occup,1);
Post_Occup_std = std(PostTest_occup,1);
% Wilcoxon signed rank task between Pre and PostTest
p_pre_post = signrank(PreTest_occup(:,1),PostTest_occup(:,1));
% Prepare arrays for plotting
point_pre_post = [PreTest_occup(:,1) PostTest_occup(:,1)];

%% Prepare the 'first enter to shock zone' array
for u = 1:length(Dir.path)
    if isempty(PreTest_ZoneIndices{u}{1})
        Pre_FirstTime(u) = 240;
    else
        Pre_FirstZoneIndices(u) = PreTest_ZoneIndices{u}{1}(1);
        Pre_FirstTime(u) = PreTest_PosMat{u}(Pre_FirstZoneIndices(u),1);
    end
    
    if isempty(PostTest_ZoneIndices{u}{1})
        Post_FirstTime(u) = 240;
    else
        Post_FirstZoneIndices(u) = PostTest_ZoneIndices{u}{1}(1);
        Post_FirstTime(u) = PostTest_PosMat{u}(Post_FirstZoneIndices(u),1);
    end
    
    Pre_Post_FirstTime(u, 1:2) = [Pre_FirstTime(u) Post_FirstTime(u)];
end
    
Pre_Post_FirstTime_mean = mean(Pre_Post_FirstTime,1);
Pre_Post_FirstTime_std = std(Pre_Post_FirstTime,1);
p_FirstTime_pre_post = signrank(Pre_Post_FirstTime(:,1),Pre_Post_FirstTime(:,2));

%% Calculate number of entries into the shock zone
% Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
for m = 1:length(Dir.path)
    if isempty(PreTest_ZoneIndices{m}{1})
        Pre_entnum(m) = 0;
    else
        Pre_entnum(m)=length(find(diff(PreTest_ZoneIndices{m}{1})>1))+1;
    end
    
    if isempty(PostTest_ZoneIndices{m}{1})
        Post_entnum(m)=0;
    else
        Post_entnum(m)=length(find(diff(PostTest_ZoneIndices{m}{1})>1))+1;
    end
    
end
Pre_Post_entnum = [Pre_entnum; Post_entnum]';
Pre_Post_entnum_mean = mean(Pre_Post_entnum,1);
Pre_Post_entnum_std = std(Pre_Post_entnum,1);
p_entnum_pre_post = signrank(Pre_entnum, Post_entnum);%Save it

%% Calculate speed in the shock zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
% - UPD 18/07/2018 - Could do length(Start(ZoneEpoch))
for r=1:length(Dir.path)
        % PreTest ShockZone speed
        if isempty(PreTest_ZoneIndices{r}{1})
            VZmean_pre(r) = 0;
        else
            if old
                Vtemp_pre{r} = tsd(Range(Pre_Vtsd{r}),(Data(Pre_Vtsd{r})./([diff(PreTest_PosMat{r}(:,1));-1])));
            else
                Vtemp_pre{r}=Data(Pre_Vtsd{r});
            end
            VZone_pre{r}=Vtemp_pre{r}(PreTest_ZoneIndices{r}{1}(1:end-1),1);
            VZmean_pre(r)=mean(VZone_pre{r},1);
        end
        
        % PostTest ShockZone speed
        if isempty(PostTest_ZoneIndices{r}{1})
            VZmean_post(r) = 0;
        else
            if old
                Vtemp_post{r} = tsd(Range(Post_Vtsd{r}),(Data(Post_Vtsd{r})./([diff(PostTest_PosMat{r}(:,1));-1])));
            else
                Vtemp_post{r}=Data(Post_Vtsd{r});
            end
           VZone_post{r}=Vtemp_post{r}(PostTest_ZoneIndices{r}{1}(1:end-1),1);
           VZmean_post(r)=mean(VZone_post{r},1);
        end
        
end

Pre_Post_VZmean = [VZmean_pre; VZmean_post]';
Pre_Post_VZmean_mean = mean(Pre_Post_VZmean,1);
Pre_Post_VZmean_std = std(Pre_Post_VZmean,1);
p_VZmean_pre_post = signrank(VZmean_pre, VZmean_post);

%% Plot

% Occupancy
axes(Occupancy_Axes);
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([PreTest_occup(:,1) PostTest_occup(:,1)], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
ylabel('% time');
title('Percentage of the ShockZone occupancy', 'FontSize', 14);

axes(NumEntr_Axes);
[p_nent,h_nent, her_nent] = PlotErrorBarN_DB(Pre_Post_entnum, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(h_nent, 'LineWidth', 3);
set(her_nent, 'LineWidth', 3);
ylabel('Number of entries');
title('# of entries to the ShockZone', 'FontSize', 14);

axes(First_Axes);
[p_first,h_first, her_first] =PlotErrorBarN_DB(Pre_Post_FirstTime, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(h_first, 'LineWidth', 3);
set(her_first, 'LineWidth', 3);
ylabel('Time (s)');
title('First time to enter the ShockZone', 'FontSize', 14);

axes(Speed_Axes);
[p_speed,h_speed, her_speed] = PlotErrorBarN_DB(Pre_Post_VZmean, 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
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