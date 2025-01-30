global FIGURE_DIR 


hm = getenv('HOME');
A = Analysis([hm filesep 'Data/amyphys']);
FIGURE_DIR = [hm filesep 'Data/amyphys/figuresPaper'];


datasets = List2Cell('datasets_2way.list');


[A, ato] = getResource(A, 'AnovasStimKind4Total', datasets);

for i = 1:length(ato)
    L = ato{i};
    atop(i) = L{'StimKind'};
end



atop(atop==0) = 1e-16;
[hi, x] = hist(-log10(atop), linspace(0, 20, 60));
fig.x = x;
fig.n = hi';
fig.figureType = 'hist';
fig.figureName = 'stimKindHist';
fig.xLim = [0 20];
fig.xLabel = 'Category selectivity p-value';
fig.xTick = [0 4 8 12 16 20];
fig.xTickLabel = {'1', '10^{-4}', '10^{-8}', '10^{-12}', '10^{-16}', '10^{-20}'}
fig.yLabel = 'Cell Count';
makeFigure({fig});
plot([q q], [0 35], 'k--', 'linewidth', 2)












