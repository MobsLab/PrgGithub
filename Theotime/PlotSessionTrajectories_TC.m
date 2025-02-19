function PlotSessionTrajectories_TC(mice, varargin)
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
addRequired(p, 'mice', @(x) (isnumeric(x) && isvector(x)) || (ischar(x) && strcmp(x, 'all')));
addOptional(p,'stimPost',false,@(x) islogical(x));
addOptional(p,'gradual',false,@(x) islogical(x));
addOptional(p,'sub',false,@(x) islogical(x));

parse(p,mice,varargin{:});
mice = p.Results.mice;
stimPost = p.Results.stimPost;
gradual = p.Results.gradual;
sub = p.Results.sub;

%% Mazes
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.43; 0.35 0.43; 0.35 0; 0 0];
numtest = 4;

%% Get data
if sub
    Dir = PathForExperimentsERC("SubPAG");
else
    Dir = PathForExperimentsERC("UMazePAG");
end

Dir = RestrictPathForExperiment(Dir,'nMice', mice);

a = cell(length(Dir.path),1);
to_skip = [];
for imouse = 1:length(Dir.path)
    if strcmp(Dir.name{imouse}, 'Mouse905')
        a{imouse} = load([Dir.path{imouse}{1} '/behavResources_backup.mat'], 'behavResources');
    else
        a{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'], 'behavResources');
    end
    %%% Check if CleanAlignedXtsd exists
    if ~isfield(a{imouse}.behavResources, "CleanAlignedXtsd") && isfield(a{imouse}.behavResources, "AlignedXtsd")
        warning(strcat("No CleanAligned Xtsd found for ", Dir.name{imouse}, "! Using AlignedXtsd..."))        
        for j = 1:numel(a{imouse}.behavResources)
            a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).AlignedXtsd;
            a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).AlignedYtsd;
        end

    elseif ~isfield(a{imouse}.behavResources, "CleanAlignedXtsd") && ~isfield(a{imouse}.behavResources, "AlignedXtsd")
        % warning(strcat("No Clean nor Aligned Xtsd found for ", Dir.name{imouse}, "! Using Xtsd..."))
        warning(strcat("No Clean nor Aligned Xtsd found for ", Dir.name{imouse}, "! using Xtsd but should skip."))
        to_skip = [to_skip, Dir.name{imouse}];
        for j = 1:numel(a{imouse}.behavResources)
            a{imouse}.behavResources(j).CleanAlignedXtsd = a{imouse}.behavResources(j).Xtsd;
            a{imouse}.behavResources(j).CleanAlignedYtsd = a{imouse}.behavResources(j).Ytsd;
        end
    end
end

%% Find necessary tests
id_Pre = cell(1,length(a));
id_Cond = cell(1,length(a));
id_Post = cell(1,length(a));

for i=1:length(a)
    if ismember(Dir.name{i}, to_skip)
        continue
    end
    id_Pre{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPre');
    id_Cond{i} = FindSessionID_ERC(a{i}.behavResources, 'Cond');
    id_Post{i} = FindSessionID_ERC(a{i}.behavResources, 'TestPost');
    if length(id_Pre{i})~=numtest
        warning(strcat('There are not ', ' ',  num2str(numtest), ' ', ' pre tests but rather ',' ', num2str(length(id_Pre{i})), ' ', ' in ', ' ', Dir.name{i}, '. Plotting those instead.'))
    end

    if length(id_Cond{i})~=numtest
        warning(strcat('There are not', num2str(numtest), 'Cond tests but rather', num2str(length(id_Cond{i})), 'in', Dir.name{i}, '. Plotting those instead.'))
    end

    if length(id_Post{i})~=numtest
        warning(strcat('There are not', num2str(numtest), 'post tests but rather', num2str(length(id_Post{i})), 'in', Dir.name{i}, '. Plotting those instead.'))
    end

end


%% Plot
fh = figure('units', 'normalized', 'outerposition', [0 0 0.85 0.5]);
% tabs = arrayfun(@(x) uitab('Title', Dir.name{x}), 1:length(Dir.path));
valid_indices = find(~ismember(Dir.name, to_skip));
tabs = arrayfun(@(x) uitab('Title', Dir.name{x}), valid_indices);
for itab = 1:length(tabs)
    curtab = tabs(itab);
    itab = valid_indices(itab);
    % PreTests
    ax(1) = axes('Parent', curtab, 'position', [0.03 0.07 0.3 0.85]);
    axes(ax(1));
    hold on
    for itest = 1:length(id_Pre{itab})
        plot(Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Pre{itab}(itest)).CleanAlignedYtsd),...
            'LineWidth',3, 'Color', [0.2 0.2 0.2]);
    end
    set(gca,'XtickLabel',{},'YtickLabel',{});
    hold on
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    title('PreTests','FontSize',18,'FontWeight','bold');
    xlim([0 1])
    ylim([0 1])
    hold off
    makepretty
    % Cond
    ax(2) = axes('Parent', curtab, 'position', [0.36 0.07 0.3 0.85]);
    axes(ax(2));
    hold on
    if gradual
        colors = linspace(0.2, 0.8, numtest); % Generate shades of grey
    else 
        colors = 0.2*ones(1, numtest);
    end
    for itest = length(id_Cond{itab}):-1:1
        plot(Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedYtsd),...
            'LineWidth',3, 'Color', [colors(itest) colors(itest) colors(itest)]);
        tempX = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedXtsd);
        tempY = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedYtsd);
        plot(tempX(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),tempY(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),...
            'p','Color','r','MarkerFaceColor','red','MarkerSize',16);
        clear tempX tempY
    end
    set(gca,'XtickLabel',{},'YtickLabel',{});
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    title('Conditioning','FontSize',18,'FontWeight','bold');
    xlim([0 1])
    ylim([0 1])
    hold off
    makepretty
    % PostTest
    ax(3) = axes('Parent', curtab, 'position', [0.69 0.07 0.3 0.85]);
    axes(ax(3));
    hold on
    for itest = length(id_Post{itab}):-1:1
        %%% Same as for Cond, we plot with gradual colors
        plot(Data(a{itab}.behavResources(id_Post{itab}(itest)).CleanAlignedXtsd),Data(a{itab}.behavResources(id_Post{itab}(itest)).CleanAlignedYtsd),...
            'LineWidth',3, 'Color', [colors(itest) colors(itest) colors(itest)]);

        if stimPost
            tempX = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedXtsd);
            tempY = Data(a{itab}.behavResources(id_Cond{itab}(itest)).CleanAlignedYtsd);
            plot(tempX(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),tempY(a{itab}.behavResources(id_Cond{itab}(itest)).PosMat(:,4)==1),...
                'p','Color','r','MarkerFaceColor','red','MarkerSize',16);
            clear tempX tempY
        end
    end
    set(gca,'XtickLabel',{},'YtickLabel',{});
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    title('PostTests','FontSize',18,'FontWeight','bold');
    xlim([0 1])
    ylim([0 1])
    hold off
    makepretty
end

end
