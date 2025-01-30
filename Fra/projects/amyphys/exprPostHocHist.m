load stimKindpostHocResults
global FIGURE_DIR 

sign_thresh = 0.05;

hm = getenv('HOME');
A = Analysis([hm filesep 'Data/amyphys']);
FIGURE_DIR = [hm filesep 'Data/amyphys/figuresPaper'];



fig.figureType = 'hist';
fig.figureName = 'exprPostHoc'
M = [19, 2
        5 6
        3, 13];
    M = M * 100 / 196;
fig.x = 1:3;
fig.n = M;
fig.xTick = 1:3;
fig.xTickLabel = {'Threat', 'Neutral', 'Lipsmack'};
fig.yLim = [0 15];
fig.yTick = 0:10:60
fig.yLabel = '% Cells';
makeFigure({ fig } ) ;

