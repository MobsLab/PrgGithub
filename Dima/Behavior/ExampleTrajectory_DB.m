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
fig_post = 'ExampleTrajectory';
% Before Vtsd correction == 1
old = 0;
sav = 1;
safe = 0; % Do you want to plot statistics for safe

% Numbers of mice to run analysis on
Mice_to_analyze = 994;

% Get directories
Dir = PathForExperimentsERC('SubPAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

clrs = {'ko', 'ro', 'go','co'; 'k','r', 'g', 'c'};

% Number of tests
numtest=4;

% Axes
fh = figure('units', 'normalized', 'outerposition', [0 0 0.9 0.9]);
PreTest_Axes = axes('position', [0.07 0.07 0.28 0.38]);
Cond_Axes = axes('position', [0.38 0.07 0.28 0.38]);
PostTest_Axes = axes('position', [0.69 0.07 0.28 0.38]);

PreTestTraj_Axes = axes('position', [0.07 0.54 0.28 0.38]);
CondTraj_Axes = axes('position', [0.38 0.54 0.28 0.38]);
PostTestTraj_Axes = axes('position', [0.69 0.54 0.28 0.38]);

% fh = figure('units', 'normalized', 'outerposition', [0 0 0.9 0.65]);
% PreTestTraj_Axes = axes('position', [0.07 0.55 0.28 0.41]);
% CondTraj_Axes = axes('position', [0.38 0.55 0.28 0.41]);
% PostTestTraj_Axes = axes('position', [0.69 0.55 0.28 0.41]);
% PreTestBar_Axes = axes('position', [0.07 0.05 0.28 0.41]);
% CondBar_Axes = axes('position', [0.38 0.05 0.28 0.41]);
% PostTestBar_Axes = axes('position', [0.69 0.05 0.28 0.41]);

maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];

%% Get data

a = load([Dir.path{1}{1} '/behavResources.mat'], 'behavResources');

%% Find indices of PreTests and PostTest session in the structure
id_Pre = zeros(1,numtest);
id_Cond = cell(1,numtest);
id_Post = cell(1,numtest);

id_Pre = zeros(1,length(a.behavResources));
id_Cond = zeros(1,length(a.behavResources));
id_Post = zeros(1,length(a.behavResources));
for k=1:length(a.behavResources)
    if ~isempty(strfind(a.behavResources(k).SessionName,'TestPre'))
        id_Pre(k) = 1;
    end
    if ~isempty(strfind(a.behavResources(k).SessionName,'Cond'))
        id_Cond(k) = 1;
    end
    if ~isempty(strfind(a.behavResources(k).SessionName,'TestPost'))
        id_Post(k) = 1;
    end
end
id_Pre=find(id_Pre);
id_Cond=find(id_Cond);
id_Post=find(id_Post);

%% Calculate average occupancy
% Calculate occupancy de novo
for k=1:length(id_Pre)
    for t=1:length(a.behavResources(id_Pre(k)).Zone)
        Pre_Occup(k,t)=size(a.behavResources(id_Pre(k)).ZoneIndices{t},1)./...
            size(Data(a.behavResources(id_Pre(k)).Xtsd),1);
    end
end
for k=1:length(id_Cond)
    for t=1:length(a.behavResources(id_Cond(k)).Zone)
        Cond_Occup(k,t)=size(a.behavResources(id_Cond(k)).ZoneIndices{t},1)./...
            size(Data(a.behavResources(id_Cond(k)).Xtsd),1);
    end
end
for k=1:length(id_Post)
    for t=1:length(a.behavResources(id_Post(k)).Zone)
        Post_Occup(k,t)=size(a.behavResources(id_Post(k)).ZoneIndices{t},1)./...
            size(Data(a.behavResources(id_Post(k)).Xtsd),1);
    end
end
Pre_Occup_Shock = squeeze(Pre_Occup(:,1));
Cond_Occup_Shock = squeeze(Cond_Occup(:,1));
Post_Occup_Shock = squeeze(Post_Occup(:,1));

Pre_Occup_Safe = squeeze(Pre_Occup(:,2));
Cond_Occup_Safe = squeeze(Cond_Occup(:,2));
Post_Occup_Safe = squeeze(Post_Occup(:,2));

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
% Trajectories
axes(PreTestTraj_Axes);
for i=1:length(id_Pre)
    plot(Data(a.behavResources(id_Pre(i)).AlignedXtsd),Data(a.behavResources(id_Pre(i)).AlignedYtsd),...
        'LineWidth',3);
    hold on
end
box off
set(gca,'XtickLabel',{},'YtickLabel',{});
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
title('PreTests','FontSize',18,'FontWeight','bold');
xlim([0 1])
ylim([0 1])
% set(gca, 'FontSize', 18, 'FontWeight',  'bold');

% Cond
axes(CondTraj_Axes);
for i=1:length(id_Cond)
    plot(Data(a.behavResources(id_Cond(i)).AlignedXtsd),Data(a.behavResources(id_Cond(i)).AlignedYtsd),...
        'LineWidth',3);
    hold on
    tempX = Data(a.behavResources(id_Cond(i)).AlignedXtsd);
    tempY = Data(a.behavResources(id_Cond(i)).AlignedYtsd);
    plot(tempX(a.behavResources(id_Cond(i)).PosMat(:,4)==1),tempY(a.behavResources(id_Cond(i)).PosMat(:,4)==1),...
        'p','Color','r','MarkerFaceColor','red','MarkerSize',16);
    clear tempX tempY
end
box off
set(gca,'XtickLabel',{},'YtickLabel',{});
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
title('Conditioning','FontSize',18,'FontWeight','bold');
xlim([0 1])
ylim([0 1])
% set(gca, 'FontSize', 18, 'FontWeight',  'bold');

% PostTests
axes(PostTestTraj_Axes);
for i=1:length(id_Post)
    plot(Data(a.behavResources(id_Post(i)).AlignedXtsd),Data(a.behavResources(id_Post(i)).AlignedYtsd),...
        'LineWidth',3);
    hold on
end
box off
set(gca,'XtickLabel',{},'YtickLabel',{});
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
title('PostTests','FontSize',18,'FontWeight','bold');
xlim([0 1])
ylim([0 1])
% set(gca, 'FontSize', 18, 'FontWeight',  'bold');

axes(PreTest_Axes)
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Pre_Occup_Shock_mean*100 Pre_Occup_Safe_mean*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [1 1 1];
% set(gca,'Xtick',[1:2],'XtickLabel',{'PreTest', 'PostTest'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 5,'Xtick',[1:2],'XTickLabel',{'Shock','Safe'});
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
% % text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
% title('Percentage of the ShockZone occupancy', 'FontSize', 14);
ylabel('% time spent','FontSize',18,'FontWeight','bold')
ylim([0 80])

axes(Cond_Axes)
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Cond_Occup_Shock_mean*100 Cond_Occup_Safe_mean*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [1 1 1];
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 5,'Xtick',[1:2],'XTickLabel',{'Shock','Safe'},'YTickLabel',{});
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
% text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
% title('Percentage of the ShockZone occupancy', 'FontSize', 14);
ylim([0 80])

axes(PostTest_Axes)
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Post_Occup_Shock_mean*100 Post_Occup_Safe_mean*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [1 1 1];
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 5,'Xtick',[1:2],'XTickLabel',{'Shock','Safe'},'YTickLabel',{});
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
% text(1.85,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',13);
% title('Percentage of the ShockZone occupancy', 'FontSize', 14);
ylim([0 80])


%% Save it
if sav
    saveas(gcf, [dir_out fig_post '_' Dir.name{1} '.fig']);
    saveFigure(gcf,[fig_post '_' Dir.name{1}],dir_out);
end

%% Write to xls file
% T = table(Pre_Occup_mean, Post_Occup_mean, Pre_entnum_mean, Post_entnum_mean,Pre_FirstTime_mean,Post_FirstTime_mean,...
%     Pre_VZmean_mean, Post_VZmean_mean);
%
% filenme = [dir_out 'finalxls.xlsx'];
% writetable(T, filenme, 'Sheet',1,'Range','A1');

%% Clear variables
clear
