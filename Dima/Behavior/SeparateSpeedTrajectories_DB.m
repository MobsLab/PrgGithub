%%% SeparateSpeedTrajectories_DB

%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Behavior/';
fig_post = 'SpeedSeparation_DB';
% Before Vtsd correction == 1
old = 0;
sav = 1;

% Numbers of mice to run analysis on
Mice_to_analyze = [797 798 828 861 882 905 977];

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

clrs = {'ko', 'ro', 'go','co'; 'k','r', 'g', 'c'};


maze = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.78; 0.35 0.78; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];


%% Get data

for i = 1:length(Dir.path)
    a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources', 'CleanAlignedXtsd','CleanAlignedYtsd',...
        'CleanVtsd', 'SessionEpoch');
end

%% Process data
TowardsShockPre = cell(1,length(Dir.path));
AwayFromShockPre = cell(1,length(Dir.path));
TowardsShockPost = cell(1,length(Dir.path));
AwayFromShockPost = cell(1,length(Dir.path));
VtsdPre = cell(1,length(Dir.path));
VtsdPost = cell(1,length(Dir.path));

for i = 1:length(Dir.path)
    % Get PreTestEpoch
    PreEpoch = or(a{i}.SessionEpoch.TestPre1,a{i}.SessionEpoch.TestPre2);
    PreEpoch = or(PreEpoch,a{i}.SessionEpoch.TestPre3);
    PreEpoch = or(PreEpoch,a{i}.SessionEpoch.TestPre4);
    
    HabXPre = Restrict(a{i}.CleanAlignedXtsd,PreEpoch);
    HabYPre = Restrict(a{i}.CleanAlignedYtsd,PreEpoch);
    VtsdPre{i} = Restrict(a{i}.CleanVtsd,PreEpoch);
    TrajPre = [Data(HabXPre) Data(HabYPre)];
    [TowardsShockPre{i},AwayFromShockPre{i}] = SeparateTrajectoriesTowardsShock(TrajPre);
    
    % Get PostTestEpoch
    PostEpoch = or(a{i}.SessionEpoch.TestPost1,a{i}.SessionEpoch.TestPost2);
    PostEpoch = or(PostEpoch,a{i}.SessionEpoch.TestPost3);
    PostEpoch = or(PostEpoch,a{i}.SessionEpoch.TestPost4);
    
    HabXPost = Restrict(a{i}.CleanAlignedXtsd,PostEpoch);
    HabYPost = Restrict(a{i}.CleanAlignedYtsd,PostEpoch);
    VtsdPost{i} = Restrict(a{i}.CleanVtsd,PostEpoch);
    TrajPost = [Data(HabXPost) Data(HabYPost)];
    [TowardsShockPost{i},AwayFromShockPost{i}] = SeparateTrajectoriesTowardsShock(TrajPost);
    
end

%% Process average
TowardsShockPreAll = TowardsShockPre{1};
AwayFromShockPreAll = AwayFromShockPre{1};
TowardsShockPostAll = TowardsShockPost{1};
AwayFromShockPostAll = AwayFromShockPost{1};
VtsdPreAll = Data(VtsdPre{1});
VtsdPostAll = Data(VtsdPost{1});

for i = 2:length(Dir.path)
    TowardsShockPreAll = [TowardsShockPreAll; TowardsShockPre{i}];
    AwayFromShockPreAll = [AwayFromShockPreAll; AwayFromShockPre{i}];
    TowardsShockPostAll = [TowardsShockPostAll; TowardsShockPost{i}];
    AwayFromShockPostAll = [AwayFromShockPostAll; AwayFromShockPost{i}];
    
    VtsdPreAll = [VtsdPreAll; Data(VtsdPre{i})];
    VtsdPostAll = [VtsdPostAll; Data(VtsdPost{i})];
    
end


%% Plot mouse by mouse
for i = 1:length(Dir.path)
    
    figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.8]);
    
    % Pre - Towards
    subplot(2,2,1)
    hold on
    
    x = TowardsShockPre{i}(:,1);  % X data
    y = TowardsShockPre{i}(:,2);  % Y data
    z = Data(VtsdPre{i});
    
    % Plot data:
    surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
        'FaceColor', 'none', ...    % Don't bother filling faces with color
        'EdgeColor', 'interp', ...  % Use interpolated color for edges
        'LineWidth', 2);            % Make a thicker line
    
    
    set(gca,'XTick',[],'FontWeight','bold');
    set(gca,'LineWidth',1.2);
    xlabel('Position X (cm)')
    ylabel('Position Y (cm)')
    title('Speed towards SZ during Pre-tests')
    
    hcb = colorbar;
    set(get(hcb,'label'),'string','Speed (cm/s)');
    
    caxis([0 18])
    hold on
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    hold off
    %     xlim([5 55])
    %     ylim([0 40])
    %
    
    % Pre - Away
    subplot(2,2,2)
    hold on
    
    x = AwayFromShockPre{i}(:,1);  % X data
    y = AwayFromShockPre{i}(:,2);  % Y data
    z = Data(VtsdPre{i});
    
    % Plot data:
    surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
        'FaceColor', 'none', ...    % Don't bother filling faces with color
        'EdgeColor', 'interp', ...  % Use interpolated color for edges
        'LineWidth', 2);            % Make a thicker line
    
    
    set(gca,'FontWeight','bold');
    set(gca,'LineWidth',1.2);
    xlabel('Position X (cm)')
    ylabel('Position Y (cm)')
    title('Speed away from SZ during Pre-tests')
    
    hcb = colorbar;
    set(get(hcb,'label'),'string','Speed (cm/s)');
    
    caxis([0 18])
    hold on
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    hold off
    %     xlim([5 55])
    %     ylim([0 40])
    %
    % Post - Towards
    subplot(2,2,3)
    hold on
    
    x = TowardsShockPost{i}(:,1);  % X data
    y = TowardsShockPost{i}(:,2);  % Y data
    z = Data(VtsdPost{i});
    
    % Plot data:
    surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
        'FaceColor', 'none', ...    % Don't bother filling faces with color
        'EdgeColor', 'interp', ...  % Use interpolated color for edges
        'LineWidth', 2);            % Make a thicker line
    
    
    set(gca,'FontWeight','bold');
    set(gca,'LineWidth',1.2);
    xlabel('Position X (cm)')
    ylabel('Position Y (cm)')
    title('Speed towards SZ during Post-tests')
    
    hcb = colorbar;
    set(get(hcb,'label'),'string','Speed (cm/s)');
    
    caxis([0 18])
    hold on
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    hold off
    %     xlim([5 55])
    %     ylim([0 40])
    
    % Post - Away
    subplot(2,2,4)
    hold on
    
    x = AwayFromShockPost{i}(:,1);  % X data
    y = AwayFromShockPost{i}(:,2);  % Y data
    z = Data(VtsdPost{i});
    
    % Plot data:
    surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
        'FaceColor', 'none', ...    % Don't bother filling faces with color
        'EdgeColor', 'interp', ...  % Use interpolated color for edges
        'LineWidth', 2);            % Make a thicker line
    
    
    set(gca,'FontWeight','bold');
    set(gca,'LineWidth',1.2);
    xlabel('Position X (cm)')
    ylabel('Position Y (cm)')
    title('Speed away from SZ during Post-tests')
    
    hcb = colorbar;
    set(get(hcb,'label'),'string','Speed (cm/s)');
    
    caxis([0 18])
    hold on
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    hold off
    %     xlim([5 55])
    %     ylim([0 40])
    
end

%% Plot Average


fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.8]);
SpeedTowardsPre = axes('position', [0.07 0.54 0.365 0.41]);
SpeedAwayPre = axes('position', [0.55 0.54 0.365 0.41]);
SpeedTowardsPost = axes('position', [0.07 0.05 0.365 0.41]);
SpeedAwayPost = axes('position', [0.55 0.05 0.41 0.41]);

% Pre - Towards
axes(SpeedTowardsPre)
hold on

x = TowardsShockPreAll(:,1);  % X data
y = TowardsShockPreAll(:,2);  % Y data
z = VtsdPreAll;

% Plot data:
surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
    'FaceColor', 'none', ...    % Don't bother filling faces with color
    'EdgeColor', 'interp', ...  % Use interpolated color for edges
    'LineWidth', 2);            % Make a thicker line


set(gca,'XTick',[],'YTick',[],'FontWeight','bold','FontSize',18);
set(gca,'LineWidth',1.5);
colormap jet
% xlabel('Position X (cm)')
% ylabel('Position Y (cm)')
set(gca,'XtickLabel',{},'YtickLabel',{});
title('Pre-tests: towards ShockZone')
% 
% hcb = colorbar;
% set(get(hcb,'label'),'string','Speed (cm/s)');

caxis([0 18])
xlim([0 1])
ylim([0 1])
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
hold off


% Pre - Away
axes(SpeedAwayPre)
hold on

x = AwayFromShockPreAll(:,1);  % X data
y = AwayFromShockPreAll(:,2);  % Y data
z = VtsdPreAll;

% Plot data:
surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
    'FaceColor', 'none', ...    % Don't bother filling faces with color
    'EdgeColor', 'interp', ...  % Use interpolated color for edges
    'LineWidth', 2);            % Make a thicker line


set(gca,'XTick',[],'YTick',[],'FontWeight','bold','FontSize',18);
set(gca,'LineWidth',1.5);
colormap jet
% xlabel('Position X (cm)')
% ylabel('Position Y (cm)')
set(gca,'XtickLabel',{},'YtickLabel',{});
title('Pre-tests: away from ShockZone')
% 
% hcb = colorbar;
% set(get(hcb,'label'),'string','Speed (cm/s)');

caxis([0 18])
xlim([0 1])
ylim([0 1])
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
hold off

% Post - Towards
axes(SpeedTowardsPost)
hold on

x = TowardsShockPostAll(:,1);  % X data
y = TowardsShockPostAll(:,2);  % Y data
z = VtsdPostAll;

% Plot data:
surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
    'FaceColor', 'none', ...    % Don't bother filling faces with color
    'EdgeColor', 'interp', ...  % Use interpolated color for edges
    'LineWidth', 2);            % Make a thicker line


set(gca,'XTick',[],'YTick',[],'FontWeight','bold','FontSize',18);
set(gca,'LineWidth',1.5);
colormap jet
% xlabel('Position X (cm)')
% ylabel('Position Y (cm)')
set(gca,'XtickLabel',{},'YtickLabel',{});
title('Post-tests: towards ShockZone')
% 
% hcb = colorbar;
% set(get(hcb,'label'),'string','Speed (cm/s)');

caxis([0 18])
xlim([0 1])
ylim([0 1])
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
hold off

% Post - Away
axes(SpeedAwayPost)
hold on

x = AwayFromShockPostAll(:,1);  % X data
y = AwayFromShockPostAll(:,2);  % Y data
z = VtsdPostAll;

% Plot data:
surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
    'FaceColor', 'none', ...    % Don't bother filling faces with color
    'EdgeColor', 'interp', ...  % Use interpolated color for edges
    'LineWidth', 2);            % Make a thicker line

colormap
set(gca,'XTick',[],'YTick',[],'FontWeight','bold','FontSize',18);
set(gca,'LineWidth',1.5);
colormap jet
% xlabel('Position X (cm)')
% ylabel('Position Y (cm)')
set(gca,'XtickLabel',{},'YtickLabel',{});
title('Post-tests: away from ShockZone')

hcb = colorbar;
set(get(hcb,'label'),'string','Speed (cm/s)');

caxis([0 18])
xlim([0 1])
ylim([0 1])
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
hold off

% Save
if sav
    saveas(gcf, [dir_out fig_post '.fig']);
    saveFigure(gcf,fig_post,dir_out);
end