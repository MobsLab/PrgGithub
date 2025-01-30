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
fig_post = 'AllMiceBasicBehaviorSmallShockZone_without';
% Before Vtsd correction == 1
old = 0;
sav = 0;
safe = 0; % Do you want to plot statistics for safe

% Numbers of mice to run analysis on
Mice_to_analyze = [797 798 828 861 905 906];

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

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
    a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources');
end

%% Find indices of PreTests and PostTest session in the structure
id_Pre = cell(1,length(a));
id_Cond = cell(1,length(a));
id_Post = cell(1,length(a));

for i=1:length(a)
    id_Pre{i} = zeros(1,length(a{i}.behavResources));
    id_Post{i} = zeros(1,length(a{i}.behavResources));
    for k=1:length(a{i}.behavResources)
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPre'))
            id_Pre{i}(k) = 1;
        end
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'Cond'))
            id_Cond{i}(k) = 1;
        end
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPost'))
            id_Post{i}(k) = 1;
        end
    end
    id_Pre{i}=find(id_Pre{i});
    id_Cond{i}=find(id_Cond{i});
    id_Post{i}=find(id_Post{i});
end

%% Calculate average occupancy
% Calculate occupancy de novo
for i=1:length(a)
    for k=1:length(id_Pre{i})
        for t=1:length(a{i}.behavResources(id_Pre{i}(k)).Zone)
            Pre_Occup(i,k,t)=size(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{t},1)./...
                size(Data(a{i}.behavResources(id_Pre{i}(k)).CleanXtsd),1);
        end
    end
    for k=1:length(id_Post{i})
        for t=1:length(a{i}.behavResources(id_Post{i}(k)).Zone)
            Post_Occup(i,k,t)=size(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{t},1)./...
                size(Data(a{i}.behavResources(id_Post{i}(k)).CleanXtsd),1);
        end
    end
end
Pre_Occup = squeeze(Pre_Occup(:,:,1));
Post_Occup = squeeze(Post_Occup(:,:,1));

Pre_Occup_mean = mean(Pre_Occup,2);
Pre_Occup_std = std(Pre_Occup,0,2);
Post_Occup_mean = mean(Post_Occup,2);
Post_Occup_std = std(Post_Occup,0,2);
% Wilcoxon signed rank task between Pre and PostTest
p_pre_post = signrank(Pre_Occup_mean, Post_Occup_mean);

%% Prepare the 'first enter to shock zone' array
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})
            Pre_FirstTime(i,k) = 240;
        else
            Pre_FirstZoneIndices{i}{k} = a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1}(1);
            Pre_FirstTime(i,k) = a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(Pre_FirstZoneIndices{i}{k}(1),1)-...
                a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(1,1);
        end
    end
    
    for k=1:length(id_Post{i})
        if isempty(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{1})
            Post_FirstTime(i,k) = 240;
        else
            Post_FirstZoneIndices{i}{k} = a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{1}(1);
            Post_FirstTime(i,k) = a{i}.behavResources(id_Post{i}(k)).CleanPosMat(Post_FirstZoneIndices{i}{k}(1),1)-...
                 a{i}.behavResources(id_Post{i}(k)).CleanPosMat(1,1);
        end
    end
end
    
Pre_FirstTime_mean = mean(Pre_FirstTime,2);
Pre_FirstTime_std = std(Pre_FirstTime,0,2);
Post_FirstTime_mean = mean(Post_FirstTime,2);
Post_FirstTime_std = std(Post_FirstTime,0,2);
% Wilcoxon test
p_FirstTime_pre_post = signrank(Pre_FirstTime_mean,Post_FirstTime_mean);

%% Calculate number of entries into the shock zone
% Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})
            Pre_entnum(i,k) = 0;
        else
            Pre_entnum(i,k)=length(find(diff(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})>1))+1;
        end
    end
    
    for k=1:length(id_Post{i})   
        if isempty(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{1})
            Post_entnum(i,k) = 0;
        else
            Post_entnum(i,k)=length(find(diff(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{1})>1))+1;
        end
    end
    
end
Pre_entnum_mean = mean(Pre_entnum,2);
Pre_entnum_std = std(Pre_entnum,0,2);
Post_entnum_mean = mean(Post_entnum,2);
Post_entnum_std = std(Post_entnum,0,2);
% Wilcoxon test
p_entnum_pre_post = signrank(Pre_entnum_mean, Post_entnum_mean);

%% Calculate speed in the safe zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
% - UPD 18/07/2018 - Could do length(Start(ZoneEpoch))
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        % PreTest SafeZone speed
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2})
            VZmean_pre(i,k) = 0;
        else
            if old
                Vtemp_pre{i}{k} = tsd(Range(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd),...
                    (Data(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd)./...
                    ([diff(a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(:,1));-1])));
            else
                Vtemp_pre{i}{k}=Data(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd);
            end
            VZone_pre{i}{k}=Vtemp_pre{i}{k}(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2}(1:end-1),1);
            VZmean_pre(i,k)=nanmean(VZone_pre{i}{k},1);
        end
    end
    
    % PostTest SafeZone speed
    for k=1:length(id_Post{i})
        % PreTest SafeZone speed
        if isempty(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{2})
            VZmean_post(i,k) = 0;
        else
            if old
                Vtemp_post{i}{k} = tsd(Range(a{i}.behavResources(id_Post{i}(k)).CleanVtsd),...
                    (Data(a{i}.behavResources(id_Post{i}(k)).CleanVtsd)./...
                    ([diff(a{i}.behavResources(id_Post{i}(k)).CleanPosMat(:,1));-1])));
            else
                Vtemp_post{i}{k}=Data(a{i}.behavResources(id_Post{i}(k)).CleanVtsd);
            end
            VZone_post{i}{k}=Vtemp_post{i}{k}(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{2}(1:end-1),1);
            VZmean_post(i,k)=nanmean(VZone_post{i}{k},1);
        end
    end
    
end

Pre_VZmean_mean = mean(VZmean_pre,2);
Pre_VZmean_std = std(VZmean_pre,0,2);
Post_VZmean_mean = mean(VZmean_post,2);
Post_VZmean_std = std(VZmean_post,0,2);
% Wilcoxon test
p_VZmean_pre_post = signrank(Pre_VZmean_mean, Post_VZmean_mean);

%% Plot

% Occupancy
axes(Occupancy_Axes);
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Pre_Occup_mean*100 Post_Occup_mean*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [1 1 1];
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 3);
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
% text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
ylabel('% time');
title('Percentage of the ShockZone occupancy', 'FontSize', 14);
ylim([0 80])

axes(NumEntr_Axes);
[p_nent,h_nent, her_nent] = PlotErrorBarN_DB([Pre_entnum_mean Post_entnum_mean], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_nent.FaceColor = 'flat';
h_nent.CData(2,:) = [1 1 1];
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 3);
set(h_nent, 'LineWidth', 3);
set(her_nent, 'LineWidth', 3);
ylabel('Number of entries');
title('# of entries to the ShockZone', 'FontSize', 14);
ylim([0 6])

axes(First_Axes);
[p_first,h_first, her_first] = PlotErrorBarN_DB([Pre_FirstTime_mean Post_FirstTime_mean], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_first.FaceColor = 'flat';
h_first.CData(2,:) = [1 1 1];
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 18, 'FontWeight', 'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 3);
set(h_first, 'LineWidth', 3);
set(her_first, 'LineWidth', 3);
ylabel('Time (s)');
title('First time to enter the ShockZone', 'FontSize', 14);

axes(Speed_Axes);
[p_speed,h_speed, her_speed] = PlotErrorBarN_DB([Pre_VZmean_mean Post_VZmean_mean], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_speed.FaceColor = 'flat';
h_speed.CData(2,:) = [1 1 1];
set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 3);
set(h_speed, 'LineWidth', 3);
set(her_speed, 'LineWidth', 3);
ylabel('Speed (cm/s)');
title('Average speed in the SafeZone', 'FontSize', 14);
ylim([0 4])

%% Save it
if sav
    saveas(gcf, [dir_out fig_post '.fig']);
    saveFigure(gcf,fig_post,dir_out);
end

%% Write to xls file
% T = table(Pre_Occup_mean, Post_Occup_mean, Pre_entnum_mean, Post_entnum_mean,Pre_FirstTime_mean,Post_FirstTime_mean,...
%     Pre_VZmean_mean, Post_VZmean_mean);
% 
% filenme = [dir_out 'finalxls.xlsx'];
% writetable(T, filenme, 'Sheet',1,'Range','A1');

%% Clear variables
% clear

%% Calculate average occupancy
% Calculate occupancy de novo
for i=1:length(a)
    for k=1:length(id_Pre{i})
        for t=1:length(a{i}.behavResources(id_Pre{i}(k)).Zone)
            Pre_Occup(i,k,t)=size(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{t},1)./...
                size(Data(a{i}.behavResources(id_Pre{i}(k)).CleanXtsd),1);
        end
    end
    for k=1:length(id_Cond{i})
        for t=1:length(a{i}.behavResources(id_Cond{i}(k)).Zone)
            Cond_Occup(i,k,t)=size(a{i}.behavResources(id_Cond{i}(k)).CleanZoneIndices{t},1)./...
                size(Data(a{i}.behavResources(id_Cond{i}(k)).CleanXtsd),1);
        end
    end
    for k=1:length(id_Post{i})
        for t=1:length(a{i}.behavResources(id_Post{i}(k)).Zone)
            Post_Occup(i,k,t)=size(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{t},1)./...
                size(Data(a{i}.behavResources(id_Post{i}(k)).CleanXtsd),1);
        end
    end
end
Pre_Occup_Shock = squeeze(Pre_Occup(:,:,1));
Cond_Occup_Shock = squeeze(Cond_Occup(:,:,1));
Post_Occup_Shock = squeeze(Post_Occup(:,:,1));

Pre_Occup_Safe = squeeze(Pre_Occup(:,:,2));
Cond_Occup_Safe = squeeze(Cond_Occup(:,:,2));
Post_Occup_Safe = squeeze(Post_Occup(:,:,2));

Pre_Occup_Shock_mean = mean(Pre_Occup_Shock,2);
Pre_Occup_Shock_std = std(Pre_Occup_Shock,0,2);
Cond_Occup_Shock_mean = mean(Cond_Occup_Shock,2);
Cond_Occup_Shock_std = std(Cond_Occup_Shock,0,2);
Post_Occup_Shock_mean = mean(Post_Occup_Shock,2);
Post_Occup_Shock_std = std(Post_Occup_Shock,0,2);

Pre_Occup_Safe_mean = mean(Pre_Occup_Safe,2);
Pre_Occup_Safe_std = std(Pre_Occup_Safe,0,2);
Cond_Occup_Safe_mean = mean(Cond_Occup_Safe,2);
Cond_Occup_Safe_std = std(Cond_Occup_Safe,0,2);
Post_Occup_Safe_mean = mean(Post_Occup_Safe,2);
Post_Occup_Safe_std = std(Post_Occup_Safe,0,2);

% Wilcoxon signed rank task between Pre and PostTest
p_pre_post = signrank(Pre_Occup_Shock_mean, Post_Occup_Shock_mean);

%% Plot
figure
subplot(131)
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Pre_Occup_Shock_mean*100 Pre_Occup_Safe_mean*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [1 1 1];
% set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 5);
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
% text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
ylabel('% time');
% title('Percentage of the ShockZone occupancy', 'FontSize', 14);
ylim([0 60])

subplot(132)
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Cond_Occup_Shock_mean*100 Cond_Occup_Safe_mean*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [1 1 1];
% set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 5);
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
% text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
ylabel('% time');
% title('Percentage of the ShockZone occupancy', 'FontSize', 14);
ylim([0 60])

subplot(133)
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Post_Occup_Shock_mean*100 Post_Occup_Safe_mean*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [1 1 1];
% set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 5);
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
% text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
ylabel('% time');
% title('Percentage of the ShockZone occupancy', 'FontSize', 14);
ylim([0 60])