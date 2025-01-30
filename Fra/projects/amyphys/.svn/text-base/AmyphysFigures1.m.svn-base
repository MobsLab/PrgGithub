function AmyphysFigures1


do_figures = [1:100];
dontdo_figures = [];



hm = getenv('HOME');
parent_dir = [hm '/Data/amyphys'];
cd(parent_dir);

datasets = List2Cell([ parent_dir filesep 'datasets_amyphys.list' ] );


A = Analysis(parent_dir);

% prepare logs and figure directory 

global FIGURE_DIR;

if isempty(FIGURE_DIR)
    hm = getenv('HOME');
    FIGURE_DIR = [ hm filesep 'Data/amyphys/figures'];
end


logfile = ([FIGURE_DIR filesep 'analysis_logfile_' date_tag '.txt' ...
              ]);

createLogs(logfile);


% get resources 

[A, cn] = getResource(A, 'AmygdalaCellList', datasets);
[A, bs_rate] = getResource(A, 'FRateBaseline', datasets);
[A, ac] = getResource(A, 'AnatomyData', datasets);
[A, doub] = getResource(A, 'IsDouble', datasets);
[A, burst] = getResource(A, 'BurstinessBaseline', datasets);

burst = 1./ (1 + 1 ./ burst);

goodCells = find(~doub);


lgroup = intersect(strmatch('l', ac,'exact'), goodCells);
blgroup = intersect(strmatch( 'bl', ac, 'exact'), goodCells);
bgroup = intersect(strmatch( 'b', ac, 'exact'), goodCells);
sigroup = intersect(strmatch( 'si', ac, 'exact'), goodCells);

log_string = (['total number of cells: ' num2str(length(goodCells))]);
logger(log_string);

log_string = (['l: ' num2str(length(lgroup))]);
logger(log_string);

log_string = (['b: ' num2str(length(bgroup))]);
logger(log_string);

log_string = (['bl: ' num2str(length(blgroup))]);
logger(log_string);


display(['si: ' num2str(length(sigroup))]);
logger(log_string);

% Global Firing Rate 

fig_st = {};

bins= linspace(0, 45, 20);

hb = hist(bs_rate(goodCells), bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysGlobalBsFrateHist';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 1)

%  firing rate in the basal


fig_st = {};

bins= linspace(0, 45, 20);

hb = hist(bs_rate(bgroup), bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysBasalBsFrateHist';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 2)


%  firing rate in the lateral


fig_st = {};

bins= linspace(0, 45, 20);

hb = hist(bs_rate(lgroup), bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysLateralBsFrateHist';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 3)


%  firing rate in the si


fig_st = {};

bins= linspace(0, 45, 20);

hb = hist(bs_rate(sigroup), bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysSiBsFrateHist';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 4)



%  firing rate in the bl group 


fig_st = {};

bins= linspace(0, 45, 20);

hb = hist(bs_rate(blgroup), bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysBLBsFrateHist';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 5)


% Histogram of average firing rates per groups 

n(1) = mean(bs_rate(goodCells));
e(1) = std(bs_rate(goodCells));
log_string = sprintf('global baseline f.r. = %g +/- %g', n(1), e(1));
logger(log_string);


n(1) = mean(bs_rate(bgroup));
e(1) =std(bs_rate(bgroup));
log_string = sprintf('basal baseline f.r. = %g +/- %g', n(1), e(1));
logger(log_string);

n(2) = mean(bs_rate(lgroup));
e(2) =std(bs_rate(lgroup));
log_string = sprintf('lateral baseline f.r. = %g +/- %g', n(2), e(2));
logger(log_string);


n(3) = mean(bs_rate(sigroup));
e(3) =std(bs_rate(sigroup));
log_string = sprintf('si baseline f.r. = %g +/- %g', n(3), e(3));
logger(log_string);

n(4) = mean(bs_rate(blgroup));
e(4) =std(bs_rate(blgroup));
log_string = sprintf('bl baseline f.r. = %g +/- %g', n(4), e(4));
logger(log_string);

fig_st = {};

bins= linspace(0, 45, 20);

hb = hist(bs_rate(blgroup), bins);

fig = [];
fig.x = (1:4)';
fig.n = n';
fig.e = e';
fig.xTickLabel  = {'basal', 'lateral', 'sigroup', 'blgroup'};

%keyboard
fig.figureType = 'histerror';
fig.figureName = 'AmyphysPerNucleusBsRateHist';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 6);



%%% baseline burstiness (allcells) 
fig_st = {};

bins= linspace(0, 1, 20);

hb = hist(burst(goodCells), bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysGlobalBurstHist';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 7);


% Histogram of average burstiness per groups 
n(1) = mean(burst(goodCells));
e(1) =std(burst(goodCells));
log_string = sprintf('global baseline burstiness= %g +/- %g', n(1), e(1));
logger(log_string);


n(1) = mean(burst(bgroup));
e(1) =std(burst(bgroup));
log_string = sprintf('basal baseline burstiness= %g +/- %g', n(1), e(1));
logger(log_string);

n(2) = mean(burst(lgroup));
e(2) =std(burst(lgroup));
log_string = sprintf('lateral baseline burstiness= %g +/- %g', n(2), e(2));
logger(log_string);


n(3) = mean(burst(sigroup));
e(3) =std(burst(sigroup));
log_string = sprintf('si baseline burstiness = %g +/- %g', n(3), e(3));
logger(log_string);

n(4) = mean(burst(blgroup));
e(4) =std(burst(blgroup));
log_string = sprintf('bl baseline burstiness = %g +/- %g', n(4), e(4));
logger(log_string);

fig_st = {};


fig = [];
fig.x = (1:4)';
fig.n = n';
fig.e = e';
fig.xTickLabel  = {'basal', 'lateral', 'sigroup', 'blgroup'};

%keyboard
fig.figureType = 'histerror';
fig.figureName = 'AmyphysPerNucleusBurstHist';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 8);


%%%%%% 

% f.r. vs. burstiness scattergram 

fig = [];
fig.x{1} = bs_rate(goodCells);
fig.n{1} = burst(goodCells);
fig.style{1} = 'k.';
fig.lineProperties{1} = {'MarkerSize', 20};
fig.xLabel = 'baseline firing rate (Hz)'
fig.yLabel = 'burstiness';

fig.figureType = 'plot';
fig.figureName = 'AmyphysRateBurstScatter';
fig_st = [fig_st { fig } ] ;

[xy, clo, chi] = nancorrcoef(bs_rate(goodCells), burst(goodCells), 0.05, 'bootstrap')
keyboard

check_figure(fig_st, 9);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function h = date_tag()
  
  c = clock;
  h = [datestr(clock, 29) '_' datestr(clock, 13)];
  h(find(h == ':')) = '-';
  
    
function check_figure(fh, nf);
  
  global N_FIGURE
  df = evalin('caller', 'do_figures');
  
  if ismember(nf, df)
    N_FIGURE = nf;
    makeFigure(fh);
  end
  