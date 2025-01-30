function A = HDRatePrecFigs(A)  

cs = 1;

A= getResource(A, 'RatePrecMdir');
A= getResource(A, 'RatePrecCs');
A = getResource(A, 'CellThetaPhaseMean');
A = getResource(A, 'HDThetaCellList');

cs;

csa = cs;

figure(80)
    errorbar(1:20, mdir, csa);
    gg = ginput(1);
    mx = gg(2);
    mdir(mdir < mx) = mdir(mdir < mx) + 2 * pi;

    cp = cellThetaPhaseMean;
    if cp < mx
        cp = cp + 2 * pi;
    end

    global FIGURE_DIR ;
    FIGURE_DIR = '/home/fpbatta/Data/Angelo/HtmlStuff/figures';
    fig_st = {};
    fig = [];
    fig.x{1} = 1:20;
    fig.n{1} = mdir * 180 / pi;
    fig.e{1} = csa * 180 /pi;
    fig.style{1} = 'ko';
    fig.x{2} = [0 21];
    fig.n{2} = [cp cp] * 180/pi;
    fig.e{2} = [];
    fig.style{2} = 'k--';
    
    fig.xLim = [0 21];
    cn = cellnames{1};
    cn = strrep(cn, '/', '_');
    cn = cn(1:end-4);
    fig.figureType = 'errorbar';
    fig.figureName = [cn '_prec'];
    fig_st = [fig_st { fig }];
    makeFigure(fig_st);