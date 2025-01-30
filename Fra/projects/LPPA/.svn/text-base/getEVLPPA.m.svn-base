A = Analysis(pwd);
dsets = List2Cell('datasets_complete.list');
dsets = dsets(2:end);
do_get = true;
if do_get
    [A, EV3] = getResource(A, 'PairEV', dsets);
    [A, EVr3] = getResource(A, 'PairEVr', dsets);
    [A, EVDelta3] = getResource(A, 'PairEVDelta', dsets);
    [A, EVDeltar3] = getResource(A, 'PairEVDeltar', dsets);
end

do_fig = true;
if(do_fig)
    fig_st = {};
    fig = [];
    fig.x = (1:3)';
    fig.n = [mean(EV1-EVr1) ; mean(EV2-EVr2); mean(EV3-EVr3)];
    fig.e = [sem(EV1-EVr1) ; sem(EV2-EVr2) ; sem(EV3-EVr3)];

    fig.xTickLabel = {'0-10 min', '10-20 min', '20-30 min'};
    fig.figureType = 'histerror';
    fig.figureName = 'EVTimecourse'
    makeFigure({ fig });
end