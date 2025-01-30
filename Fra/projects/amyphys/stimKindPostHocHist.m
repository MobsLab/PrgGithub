load stimKindpostHocResults
global FIGURE_DIR 

sign_thresh = 0.05;

hm = getenv('HOME');
A = Analysis([hm filesep 'Data/amyphys']);
FIGURE_DIR = [hm filesep 'Data/amyphys/figuresPaper'];



fig.figureType = 'hist';
fig.figureName = 'stimKindPostHoc'
M = [monkeyp2, monkeyn2
        humanp2, humann2
        objectp2, objectn2];
    M = M * 100 / 196;
fig.x = 1:3;
fig.n = M;
fig.xTick = 1:3;
fig.xTickLabel = {'Monkey', 'Human', 'Object'};
fig.yLim = [0 35];
fig.yTick = 0:10:60
fig.yLabel = '% Cells';
makeFigure({ fig } ) ;

