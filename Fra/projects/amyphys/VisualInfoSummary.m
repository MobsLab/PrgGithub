function VisualInfoSummary(A)


plot_means = 0;
fig_st = {};
hm = getenv('HOME');
parent_dir = [ hm '/Data/amyphys'];
datasets = List2Cell([ parent_dir filesep 'datasets_amyphys.list' ] );
A = Analysis(parent_dir);

[A, ac] = getResource(A, 'AnatomyData', datasets);

lgroup = strmatch('l', ac,'exact');
blgroup = strmatch( 'bl', ac, 'exact');
bgroup = strmatch( 'b', ac, 'exact');
sigroup = strmatch( 'si', ac, 'exact');

[A, ii] = getResource(A, 'IdInfo', datasets);
[A, si] = getResource(A, 'StimInfo', datasets);
[A, mi] = getResource(A, 'MonkeyInfo', datasets);
[A, ei] = getResource(A, 'ExprInfo', datasets);

% the lateral group
if plot_means
    [fig] = makeGroupFigure('LateralInfoTimeCourse', ii, si, mi, ei, lgroup);
    fig_st = [fig_st, {fig}];
    % the basal group

    [fig] = makeGroupFigure('BasalInfoTimeCourse', ii, si, mi, ei, bgroup);
    fig_st = [fig_st, {fig}];
    % the bl group

    [fig] = makeGroupFigure('BlInfoTimeCourse', ii, si, mi, ei, blgroup);
    fig_st = [fig_st, {fig}];
    % the si group

    [fig] = makeGroupFigure('SiInfoTimeCourse', ii, si, mi, ei, sigroup);
    fig_st = [fig_st, {fig}];
else
    [fig] = makeAllFigure('LateralInfoAllTimeCourse', ii, si, mi, ei, lgroup);
    fig_st = [fig_st, {fig}];
    % the basal group

    [fig] = makeAllFigure('BasalInfoAllTimeCourse', ii, si, mi, ei, bgroup);
    fig_st = [fig_st, {fig}];
    % the bl group

    [fig] = makeAllFigure('BlInfoAllTimeCourse', ii, si, mi, ei, blgroup);
    fig_st = [fig_st, {fig}];
    % the si group

    [fig] = makeAllFigure('SiInfoAllTimeCourse', ii, si, mi, ei, sigroup);
    fig_st = [fig_st, {fig}];
end

global FIGURE_DIR
FIGURE_DIR = parent_dir;
makeFigure(fig_st);

function [fig] = makeGroupFigure(title, ii, si, mi, ei, group)

    ii_l = makeGroupAverages(ii, group);
    mi_l = makeGroupAverages(mi, group);
    ei_l = makeGroupAverages(ei, group);
    si_l = makeGroupAverages(si, group);

    fig= [];
    fig.title = title;
    fig.figureType = 'plot';
    fig.x{1} = (-200:100:1200);
    fig.figureName = title; 
    fig.n{1} = ii_l;
    fig.style{1} = 'b-';

    fig.x{2} = fig.x{1};
    fig.n{2} = si_l;
    fig.style{2} = 'r-';

    fig.x{3} = fig.x{1};
    fig.n{3} = mi_l;
    fig.style{3} = 'g-';

    fig.x{4} = fig.x{1};
    fig.n{4} = ei_l;
    fig.style{4} = 'm-';

    fig.yLim = [-0.2 1.6];
    
    fig.legend = {'Id', 'Stim', 'Monkey', 'Expr'};

    

    

function [fig] = makeAllFigure(title, ii, si, mi, ei, group)

    ii_l = makeGroupTotals(ii, group);
  

    fig= [];
    fig.title = title;
    fig.figureType = 'plot';
    fig.x{1} = (-200:100:1200);
    fig.figureName = title; 
    fig.n{1} = ii_l;
   

function mean_ii = makeGroupAverages(ii, group)
ii_l = zeros(0, 15);


for i = group'
    if ~isempty(ii)
        ii_l = [ii_l; (ii{i})'];
    end
end

mean_ii = nanmean(ii_l);

bs = mean(mean_ii(1:3));
mean_ii = (mean_ii - bs) * 10;


        
function ii_l = makeGroupTotals(ii, group)
ii_l = zeros(0, 15);


for i = group'
    if ~isempty(ii)
        ii_l = [ii_l; (ii{i})'];
    end
end



                  
        
 