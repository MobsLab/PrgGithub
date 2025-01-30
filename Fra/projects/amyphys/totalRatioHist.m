global FIGURE_DIR 


hm = getenv('HOME');
A = Analysis([hm filesep 'Data/amyphys']);
FIGURE_DIR = [hm filesep 'Data/amyphys/figuresPaper'];


datasets = List2Cell('datasets_2way.list');

[A, tp] = getResource(A, 'TotalPval', datasets);
A = getResource(A, 'TotalRatio', datasets);


tps1 = find(tp < 0.05);

[hi, x] = hist(totalRatio, linspace(0, 15, 60));
fig.x = x;
fig.n = hi';
fig.figureType = 'hist';
fig.figureName = 'totalRatioHist';
fig.xLim = [0 15];
fig.xLabel = '(response rate)/(baseline rate)';
fig.yLabel = 'Cell Count';
makeFigure({fig});













