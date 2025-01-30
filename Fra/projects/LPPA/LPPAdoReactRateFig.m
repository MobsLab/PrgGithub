fig_st = {};
fig = [];
fig.x = (1:3)';
fig.n = (mean(reactR.^2-reactRRev.^2))';
fig.e = (sem(reactR.^2-reactRRev.^2))';
fig.xTickLabel = {'0-10 min', '10-20 min', '20-30 min'};
fig.figureType = 'histerror';
fig.figureName = 'ReactRateTimecourse'
makeFigure({ fig });
