function fh = PlotSessionTrajectories_TC(mice, varargin)
%
% This functions plot trajectories of a selected mouse in pretests,
% condiioning sessions and posttests as well as bar plots of shock-safe
%  zone occupancies
%
%  INPUT
%
%       mice             numbers of mice from PAG exp
%       varargin:
%       stimPost    force to plot the stim stars even for Post
%           condition
%       gradual     show gradual colors test after test
%       alpha       transparency of the stars
%       boxplot     show boxplot of occupation below
%       extended    use extended zones to compute boxplot (only safe
%           versus non-shock zone)
%       GlobalBoxPlot    if several mice, plot global boxplot of learning
%       numest          number of tests to plot
%
%
%  OUTPUT
%
%       Figure
%
%       See
%
%       BehaviorERC, ExampleTrajectory_DB
%
% Coded by Dima Bryzgalov, MOBS team, Paris, France
% 03/05/2021
% github.com/bryzgalovdm

%% Input parser
p = inputParser;
addRequired(p, 'mice', @(x) (isnumeric(x) && isvector(x)) || (ischar(x) && strcmp(x, 'all')) || isstruct(x));
addOptional(p,'stimPost',false,@(x) islogical(x));
addOptional(p,'gradual',false,@(x) islogical(x));
addOptional(p,'sub',false,@(x) islogical(x));
addOptional(p,'alpha',0.7,@(x) isnumeric(x));
addOptional(p, 'boxplot', false, @(x) islogical(x));
addOptional(p, 'extended', false, @(x) islogical(x));
addOptional(p, 'GlobalBoxPlot', false, @(x) islogical(x));
addOptional(p,'numtest',4,@(x) isnumeric(x));

parse(p,mice,varargin{:});
mice = p.Results.mice;
stimPost = p.Results.stimPost;
gradual = p.Results.gradual;
sub = p.Results.sub;
alpha = p.Results.alpha;
OccupancyBoxPlot = p.Results.boxplot;
extended = p.Results.extended;
GlobalBoxPlot = p.Results.GlobalBoxPlot;
numtest = p.Results.numtest;

if GlobalBoxPlot
    assert(OccupancyBoxPlot==true)
end

%% Mazes
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];

%% Get data
if ~isstruct(mice)
    if sub
        Dir = PathForExperimentsERC("SubPAG");
    else
        Dir = PathForExperimentsERC("UMazePAG");
    end
    Dir = RestrictPathForExperiment(Dir,'nMice', mice);
else
    Dir = mice;
end

a = cell(length(Dir.path),1);
to_skip = {};
for imouse = 1:length(Dir.path)
    if strcmp(Dir.name{imouse}, 'Mouse905')
        a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
    else
        a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
    end
    %%% Check if CleanAlignedXtsd exists
    if ~isfield(a{imouse}.behavResources, "CleanAlignedXtsd") && isfield(a{imouse}.behavResources, "AlignedXtsd")
        % warning(strcat("No CleanAligned Xtsd found for ", Dir.name{imouse}, "! Using AlignedXtsd..."))
        for j = 1:numel(a{imouse}.behavResources)
            a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).AlignedXtsd;
            a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).AlignedYtsd;
        end

    elseif ~isfield(a{imouse}.behavResources, "CleanAlignedXtsd") && ~isfield(a{imouse}.behavResources, "AlignedXtsd")
        % warning(strcat("No Clean nor Aligned Xtsd found for ", Dir.name{imouse}, "! Using Xtsd..."))
        warning(strcat("No Clean nor Aligned Xtsd found for ", Dir.name{imouse}, "! skipping."))
        to_skip{end+1} = Dir.name{imouse};
        for j = 1:numel(a{imouse}.behavResources)
            a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).Xtsd;
            a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).Ytsd;
        end
    else
        for j = 1:numel(a{imouse}.behavResources)
                if ~isfield(a{imouse}.behavResources(j), "CleanAlignedXtsd") | isempty(a{imouse}.behavResources(j).CleanAlignedXtsd)
                    a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).AlignedXtsd;
                    a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).AlignedYtsd; 
                else
                    a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).CleanAlignedXtsd;
                    a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).CleanAlignedYtsd;
                end
                if isempty(a{imouse}.behavResources(j).CleanAlignedXtsd)
                    not_found_tsd(j) = true;
                    
                else
                    not_found_tsd(j) = false;
                end
        end
        if all(not_found_tsd)
            warning(strcat("No Clean nor Aligned Xtsd found for ", Dir.name{imouse}, "! skipping."))
            to_skip{end+1} = Dir.name{imouse};
            for j = 1:numel(a{imouse}.behavResources)
                a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).Xtsd;
                a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).Ytsd;
            end
        end
    end
end

%% Find necessary tests
id_Pre = cell(1,length(a));
id_Cond = cell(1,length(a));
id_Post = cell(1,length(a));

for i=1:length(a)
    if ~isempty(to_skip)
        if ismember(Dir.name{i}, to_skip)
            continue
        end
    end
    id_Pre{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPre');
    id_Cond{i} = FindSessionID_ERC(a{i}.behavResources, 'Cond');
    id_Post{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPost');
    numtesttmp = min(numtest, length(id_Pre{i}));
    id_Pre{i} = id_Pre{i}(1:numtesttmp);
    numtesttmp = min(numtest, length(id_Cond{i}));
    id_Cond{i} = id_Cond{i}(1:numtesttmp);
    numtesttmp = min(numtest, length(id_Post{i}));
    id_Post{i} = id_Post{i}(1:numtesttmp);
end



%% Plot
fh = figure('units', 'normalized', 'outerposition', [0 0 0.85 0.5]);
% tabs = arrayfun(@(x) uitab('Title', Dir.name{x}), 1:length(Dir.path));
if ~isempty(to_skip)
    valid_indices = find(~ismember(Dir.name, to_skip));
else
    valid_indices = 1:length(Dir.name);
end
tabs = arrayfun(@(x) uitab('Title', Dir.name{x}), valid_indices);

% prepare occupancy means by creating empty arrays
GlobalPre_Occup_Shock_mean = [];
GlobalCond_Occup_Shock_mean = [];
GlobalPost_Occup_Shock_mean = [];
GlobalPre_Occup_Safe_mean = [];
GlobalCond_Occup_Safe_mean = [];
GlobalPost_Occup_Safe_mean = [];
for itab = 1:length(tabs)
    curtab = tabs(itab);
    if isempty(id_Post{itab})
        id_Post{itab} = id_Cond{itab};
        warning("Creating false post tests data (copying cond session...)")
    end
    sessions_same = true;
    if contains(Dir.manipe{itab}, 'PAG')
        star_color = 	[1 0 0]; %red
    elseif contains(Dir.manipe{itab}, 'MFB')
        star_color = 	[0 1 0]; %green
    elseif contains(Dir.manipe{itab}, 'Reversal')
        star_color = 	[1 1 0]; %yellow
        disp('REVERSAL!')
    elseif contains(Dir.manipe{itab}, 'Novel')
        star_color = [1 0 1]; % magenta
    else 
        star_color = [0 1 1]; %cyan
    end
    itab = valid_indices(itab);
    if OccupancyBoxPlot
        PreTest_Axes = axes('Parent', curtab, 'position', [0.07 0.07 0.28 0.38]);
        Cond_Axes = axes('Parent', curtab, 'position', [0.38 0.07 0.28 0.38]);
        PostTest_Axes = axes('Parent', curtab, 'position', [0.69 0.07 0.28 0.38]);

        PreTestTraj_Axes = axes('Parent', curtab, 'position', [0.07 0.54 0.28 0.38]);
        CondTraj_Axes = axes('Parent', curtab, 'position', [0.38 0.54 0.28 0.38]);
        PostTestTraj_Axes = axes('Parent', curtab, 'position', [0.69 0.54 0.28 0.38]);
    
    else
        PreTestTraj_Axes = axes('Parent', curtab, 'position', [0.03 0.07 0.3 0.85]);
        CondTraj_Axes = axes('Parent', curtab, 'position', [0.36 0.07 0.3 0.85]);
        PostTestTraj_Axes = axes('Parent', curtab, 'position', [0.69 0.07 0.3 0.85]);
    end

    %% PreTests
    axes(PreTestTraj_Axes);
    hold on
    for itest = 1:length(id_Pre{itab})
        plot(Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedYtsd),...
            'LineWidth',3, 'Color', [0.2 0.2 0.2]);
    end
    set(gca,'XtickLabel',{},'YtickLabel',{});
    hold on
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    title('PreTests');
    xlim([0 1])
    ylim([0 1])
    hold off
    makepretty_CH

    %% Cond
    axes(CondTraj_Axes);
    hold on
    if gradual
        colors = linspace(0.2, 0.8, length(id_Cond{itab})); % Generate shades of grey
        if length(id_Cond{itab}) ~= length(id_Post{itab})
            colorsPost = linspace(0.2, 0.8, length(id_Post{itab})); % Generate more shades of grey in case of reversal protocol/anormal number of tests
            sessions_same = false;
            warning('The number of tests in the conditioning and posttest sessions are different for %s. The colors will be different as well.', Dir.name{itab});
        end
    else
        colors = 0.2*ones(1, length(id_Cond{itab}));
        if length(id_Cond{itab}) ~= length(id_Post{itab})
            colorsPost = linspace(0.2, 0.8, length(id_Post{itab})); % Generate shades of grey
        end
    end
    for itest = length(id_Cond{itab}):-1:1
        plot(Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedYtsd),...
            'LineWidth',3, 'Color', [colors(itest) colors(itest) colors(itest)]);
    end

    for itest = length(id_Cond{itab}):-1:1
        tempX = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedXtsd);
        tempY = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedYtsd);
        scatter1 = scatter(tempX(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),...
            tempY(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),...
            330, 'p','MarkerEdgeColor', star_color ,'MarkerFaceColor', star_color);
        scatter1.MarkerFaceAlpha = alpha;
        scatter1.MarkerEdgeAlpha = alpha;
        clear tempX tempY
    end

    set(gca,'XtickLabel',{},'YtickLabel',{});
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    title('Conditioning');
    xlim([0 1])
    ylim([0 1])
    hold off
    makepretty_CH

    %% PostTest
    axes(PostTestTraj_Axes);
    hold on
    if ~sessions_same
        colors = colorsPost;
    end
    for itest = length(id_Post{itab}):-1:1
        %%% Same as for Cond, we plot with gradual colors
        plot(Data(a{itab}.behavResources(id_Post{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Post{itab}(itest)).CleanAlignedYtsd),...
            'LineWidth',3, 'Color', [colors(itest) colors(itest) colors(itest)]);
    end
    if stimPost
        for itest = length(id_Cond{itab}):-1:1
            tempX = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedXtsd);
            tempY = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedYtsd);
            scatter1 = scatter(tempX(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),...
            tempY(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),...
            330, 'p','MarkerEdgeColor', star_color ,'MarkerFaceColor', star_color);
            scatter1.MarkerFaceAlpha = alpha;
            scatter1.MarkerEdgeAlpha = alpha;
            clear tempX tempY
        end
    end

    set(gca,'XtickLabel',{},'YtickLabel',{});
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    title('PostTests');
    xlim([0 1])
    ylim([0 1])
    hold off
    makepretty_CH

    %% Occupancy boxplots 
    if OccupancyBoxPlot
        [Pre_Occup_Shock_mean, Pre_Occup_Shock_std, Cond_Occup_Shock_mean, ...
            Cond_Occup_Shock_std, Post_Occup_Shock_mean, Post_Occup_Shock_std, ...
            Pre_Occup_Safe_mean, Pre_Occup_Safe_std, Cond_Occup_Safe_mean, ...
            Cond_Occup_Safe_std, Post_Occup_Safe_mean, Post_Occup_Safe_std, ...
            p_pre_post] = GetShockZoneOcupancies(a{itab}, id_Pre{itab}, id_Cond{itab}, id_Post{itab}, 'extended', extended);
        %%% Store occupancy means for global boxplot
        if GlobalBoxPlot
            GlobalPre_Occup_Shock_mean = [GlobalPre_Occup_Shock_mean; mean(Pre_Occup_Shock_mean)];
            GlobalCond_Occup_Shock_mean = [GlobalCond_Occup_Shock_mean; mean(Cond_Occup_Shock_mean)];
            GlobalPost_Occup_Shock_mean = [GlobalPost_Occup_Shock_mean; mean(Post_Occup_Shock_mean)];
            GlobalPre_Occup_Safe_mean = [GlobalPre_Occup_Safe_mean; mean(Pre_Occup_Safe_mean)];
            GlobalCond_Occup_Safe_mean = [GlobalCond_Occup_Safe_mean; mean(Cond_Occup_Safe_mean)];
            GlobalPost_Occup_Safe_mean = [GlobalPost_Occup_Safe_mean; mean(Post_Occup_Safe_mean)];
        end

        if contains(Dir.manipe{itab}, 'PAG')
            Cols = {[1 .5 .5],[.5 .5 1]};
            max_pct = 70;
        elseif contains(Dir.manipe{itab}, 'MFB')
            Cols = {[.5 1 .5],[.5 .5 1]};
            max_pct = 110;
        else
            Cols = {[1 1 .5],[.5 .5 1]};
            max_pct = 80;
        end
        X = [1 2];
        Legends = {'Shock','Safe'};

        axes(PreTest_Axes)
        MakeSpreadAndBoxPlot3_SB({Pre_Occup_Shock_mean*100 Pre_Occup_Safe_mean*100},Cols,X,Legends,'showpoints',1,'paired',1,  'barcolors', [0 0 0], 'barwidth', 0.6);
        line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
        ylim([0 max_pct])
        ylabel('% time spent','FontSize',18,'FontWeight','bold')
        title('PreTests','FontSize',18,'FontWeight','bold');
        makepretty_CH
        xtickangle(0)

        % [p_occ,h_occ, her_occ] = PlotErrorBarN_DB([Pre_Occup_Shock_mean*100 Pre_Occup_Safe_mean*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
        % h_occ.FaceColor = 'flat';
        % h_occ.CData(2,:) = [1 1 1];
        % set(gca, 'LineWidth', 5,'Xtick',[1:2],'XTickLabel',{'Shock','Safe'});
        % set(h_occ, 'LineWidth', 3);
        % set(her_occ, 'LineWidth', 3);
        % line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
        % ylabel('% time spent','FontSize',18,'FontWeight','bold')
        % ylim([0 80])
        % makepretty

        axes(Cond_Axes)
        MakeSpreadAndBoxPlot3_SB({Cond_Occup_Shock_mean*100 Cond_Occup_Safe_mean*100},Cols,X,Legends,'showpoints',1,'paired',1,  'barcolors', [0 0 0], 'barwidth', 0.6);
        line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
        ylim([0 max_pct])
        ylabel('% time spent','FontSize',18,'FontWeight','bold')
        title('Conditioning','FontSize',18,'FontWeight','bold');
        makepretty_CH
        xtickangle(0)

        axes(PostTest_Axes)
        MakeSpreadAndBoxPlot3_SB({Post_Occup_Shock_mean*100 Post_Occup_Safe_mean*100},Cols,X,Legends,'showpoints',1,'paired',1,  'barcolors', [0 0 0], 'barwidth', 0.6);
        line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
        ylim([0 max_pct])
        ylabel('% time spent','FontSize',18,'FontWeight','bold')
        title('PostTests','FontSize',18,'FontWeight','bold');
        makepretty_CH
        xtickangle(0)
    end
end
if GlobalBoxPlot
    figure('units', 'normalized', 'outerposition', [0 0 0.85 0.5]);
    PreTest_Axes = axes('Parent', gcf, 'position', [0.03 0.07 0.3 0.85]);
    Cond_Axes = axes('Parent', gcf, 'position', [0.36 0.07 0.3 0.85]);
    PostTest_Axes = axes('Parent', gcf, 'position', [0.69 0.07 0.3 0.85]);


    axes(PreTest_Axes)
    % [p_occ,h_occ, her_occ] = MakeSpreadAndBoxPlot3_SB([GlobalPre_Occup_Shock_mean*100 GlobalPre_Occup_Safe_mean*100], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
    % set(h_occ, 'LineWidth', 3);
    % set(her_occ, 'LineWidth', 3);
    % h_occ.FaceColor = 'flat';
    % h_occ.CData(2,:) = [1 1 1];

    if contains(Dir.manipe{itab}, 'PAG')
        Cols = {[1 .5 .5],[.5 .5 1]};
        max_pct = 70;
    elseif contains(Dir.manipe{itab}, 'MFB')
        Cols = {[.5 1 .5],[.5 .5 1]};
        max_pct = 110;
    else
        Cols = {[1 1 .5],[.5 .5 1]};
        max_pct = 80;
    end

    X = [1 2];
    Legends = {'Shock','Safe'};
    [p_occ,h_occ] = MakeSpreadAndBoxPlot3_SB({GlobalPre_Occup_Shock_mean*100 GlobalPre_Occup_Safe_mean*100},Cols,X,Legends,'showpoints',1,'paired',1);
    line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
    ylabel('% time spent','FontSize',18,'FontWeight','bold')
    ylim([0 max_pct])
    title('PreTests','FontSize',18,'FontWeight','bold');
    makepretty_CH
    xtickangle(0)


    axes(Cond_Axes)
    [p_occ,h_occ] = MakeSpreadAndBoxPlot3_SB({GlobalCond_Occup_Shock_mean*100 GlobalCond_Occup_Safe_mean*100},Cols,X,Legends,'showpoints',1,'paired',1);
    line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
    ylabel('% time spent','FontSize',18,'FontWeight','bold')
    ylim([0 max_pct])
    title('Conditioning','FontSize',18,'FontWeight','bold');
    makepretty_CH
    xtickangle(0)


    axes(PostTest_Axes) 
    [p_occ,h_occ] = MakeSpreadAndBoxPlot3_SB({GlobalPost_Occup_Shock_mean*100 GlobalPost_Occup_Safe_mean*100},Cols,X,Legends,'showpoints',1,'paired',1);
    line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
    ylim([0 max_pct])
    ylabel('% time spent','FontSize',18,'FontWeight','bold')
    title('PostTests','FontSize',18,'FontWeight','bold');
    makepretty_CH
    xtickangle(0)
end

end
