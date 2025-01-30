function AmyphysFigures2

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
[A, tr] = getResource(A, 'TonicRatio', datasets);
[A, tp] = getResource(A, 'TonicPval', datasets);
[A, pr] = getResource(A, 'PhasicRatio', datasets);
[A, pp] = getResource(A, 'PhasicPval', datasets);
[A, or] = getResource(A, 'OffPhasicRatio', datasets);
[A, op] = getResource(A, 'OffPhasicPval', datasets);
[A, fr] = getResource(A, 'FixFastPhasicRatio', datasets);
[A, fp] = getResource(A, 'FixFastPhasicPval', datasets);
[A, ac] = getResource(A, 'AnatomyData', datasets);
[A, dpl]= getResource(A, 'DensityPeakLatency', datasets);


burst = 1./ (1 + 1 ./ burst);

goodCells = find(~doub);


% scattergram of firing rate vs. phasic change 
fig_st = {};
fig = [];

fig.x{1} = bs_rate(goodCells);
fig.n{1} = pr(goodCells);
fig.style{1} = 'k.';

fig.x{2} = [0 50];
fig.n{2} = [1 1];
fig.style{2} = 'k--';

fig.lineProperties{1} = {'MarkerSize', 20};
fig.lineProperties{2} = {};
fig.xLabel = 'baseline firing rate (Hz)'
fig.yLabel = 'phasic change';


fig.figureType = 'plot';
fig.figureName = 'AmyphysRatePhasicScatter';
[xy, clo, chi] = nancorrcoef(fig.x{1}, fig.n{1}, 0.05, 'bootstrap')
xy = xy(1,2);
clo = clo(1,2);
chi = chi(1,2);

log_string = sprintf('rate vs. phasic correlation = %g (%g, %g)', xy, clo, chi);
logger(log_string);

fig_st = [fig_st { fig } ] ;

check_figure(fig_st, 1);

% scattergram of firing rate vs. tonic change 
fig_st = {};
fig = [];

fig.x{1} = bs_rate(goodCells);
fig.n{1} = tr(goodCells);
fig.style{1} = 'k.';

fig.x{2} = [0 50];
fig.n{2} = [1 1];
fig.style{2} = 'k--';

fig.lineProperties{1} = {'MarkerSize', 20};
fig.lineProperties{2} = {};

fig.xLabel = 'baseline firing rate (Hz)'
fig.yLabel = 'tonic change';


fig.figureType = 'plot';
fig.figureName = 'AmyphysRateTonicScatter';
[xy, clo, chi] = nancorrcoef(fig.x{1}, fig.n{1}, 0.05, 'bootstrap')
xy = xy(1,2);
clo = clo(1,2);
chi = chi(1,2);

log_string = sprintf('rate vs. tonic correlation = %g (%g, %g)', xy, clo, chi);
logger(log_string);

fig_st = [fig_st { fig } ] ;

check_figure(fig_st, 2);


% scattergram of  burstiness vs. phasic change 
fig_st = {};
fig = [];

fig.x{1} = burst(goodCells);
fig.n{1} = pr(goodCells);
fig.style{1} = 'k.';

fig.x{2} = [0 1];
fig.n{2} = [1 1];
fig.style{2} = 'k--';

fig.lineProperties{1} = {'MarkerSize', 20};
fig.lineProperties{2} = {};

fig.xLabel = 'burstiness'
fig.yLabel = 'phasic change';


fig.figureType = 'plot';
fig.figureName = 'AmyphysBurstPhasicScatter';
[xy, clo, chi] = nancorrcoef(fig.x{1}, fig.n{1}, 0.05, 'bootstrap')
xy = xy(1,2);
clo = clo(1,2);
chi = chi(1,2);

log_string = sprintf('burstiness vs. phasic correlation = %g (%g, %g)', xy, clo, chi);
logger(log_string);

fig_st = [fig_st { fig } ] ;

check_figure(fig_st, 3);

% scattergram of burstiness vs. tonic change 
fig_st = {};
fig = [];

fig.x{1} = burst(goodCells);
fig.n{1} = tr(goodCells);
fig.style{1} = 'k.';

fig.x{2} = [0 1];
fig.n{2} = [1 1];
fig.style{2} = 'k--';


fig.lineProperties{1} = {'MarkerSize', 20};
fig.lineProperties{2} = {};

fig.xLabel = 'burstiness'
fig.yLabel = 'tonic change';


fig.figureType = 'plot';
fig.figureName = 'AmyphysBurstTonicScatter';
[xy, clo, chi] = nancorrcoef(fig.x{1}, fig.n{1}, 0.05, 'bootstrap')
xy = xy(1,2);
clo = clo(1,2);
chi = chi(1,2);

log_string = sprintf('burstiness vs. tonic correlation = %g (%g, %g)', xy, clo, chi);
logger(log_string);

fig_st = [fig_st { fig } ] ;

check_figure(fig_st, 4);


% histogram of phasic change

fig_st = {};
fig = [];
bins= linspace(0, 35, 20);

hb = hist(pr(goodCells), bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysPhasicHist';
fig.xLabel = 'Phasic Change';
fig_st = [fig_st { fig } ];


check_figure(fig_st, 5)

% histogram of tonic change

fig_st = {};
fig = [];
bins= linspace(0, 20, 20);

hb = hist(tr(goodCells), bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysTonicHist';
fig.xLabel = 'Tonic Change';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 6);


% histogram of log phasic change

fig_st = {};
fig = [];

lpr = log10(pr(goodCells));
lpr = lpr(isfinite(lpr));

bins= linspace(plotExtremeMin(min(lpr)), plotExtremeMax(max(lpr)), 20);

hb = hist(lpr, bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysLogPhasicHist';
fig.xLabel = 'Log Phasic Change';
fig_st = [fig_st { fig } ];


check_figure(fig_st, 7)

% histogram of tonic change

fig_st = {};
fig = [];

ltr = log10(tr(goodCells));
ltr = ltr(isfinite(ltr));
bins= linspace(plotExtremeMin(min(ltr)), plotExtremeMax(max(ltr)), 20);


hb = hist(ltr, bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysLogTonicHist';
fig.xLabel = 'Log Tonic Change';

fig_st = [fig_st { fig } ];


check_figure(fig_st, 8);

% histogram of latencies

M = max(dpl);

xhi = plotExtremeMax(M);

fig_st = {};
fig = [];
bins= linspace(0, xhi, 20);

hb = hist(dpl(goodCells), bins);

fig = [];
fig.x = bins;
fig.n = hb';
fig.figureType = 'hist';
fig.figureName = 'AmyphysLatencyHist';

fig_st = [fig_st { fig } ];

ml = mean(dpl(goodCells));
sl = std(dpl(goodCells));

log_string = sprintf('mean latency = %g =/- %g', ml, sl);
logger(log_string);


check_figure(fig_st, 9);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function x = plotExtremeMax(M)


    if M < 0;
        x = - plotExtremeMin(-M);
        return
    end
    
    xx = [1 2 5 8];
    
    om = floor(log10(M));
    
    if M > 8 * 10^om
        om = om +1;
    end
    
    i = 1;
    while M > xx(i) * 10 ^ om
        i = i+1;
    end
    
    x = xx(i) * 10 ^ om;
    
    
function x = plotExtremeMin(M)

    if M < 0
        x = - plotExtremeMax(-M);
        return
    end

    xx = [1 2 5 8];
    
    om = floor(log10(M));
    
    
    i = 4;
    while M < xx(i) * 10 ^ om
        i = i-1;
    end
    
    x = xx(i) * 10 ^ om;
    
    
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
  
