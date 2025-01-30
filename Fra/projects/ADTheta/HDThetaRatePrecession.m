function A = HDThetaRatePrecession(A)

do_fig = true;
A = getResource(A, 'Spike2Cycle');
A = getResource(A, 'NSpike2Cycle');
A = getResource(A, 'HDThetaCellList');
A = getResource(A, 'CellThetaPhaseMean');
A = registerResource(A, 'Spikes2Rate', 'cell', {'HDThetaCellList', 1},  ...
    'spikes2Rate', ...
    ['theta phase of spikes divided by number of spikes in a two theta cycle period']);

A = registerResource(A, 'RatePrecPval', 'numeric', {'HDThetaCellList', 1},  ...
    'ratePrecPval', ...
    ['p-value of the effect of rate on theta phase']);

A = registerResource(A, 'RatePrecMdir',  'numeric', {'HDThetaCellList', 20},...
    'mdir', ...
    ['average phase as a function of firing rate']);

A = registerResource(A, 'RatePrecCs', 'numeric', {'HDThetaCellList', 20},...
'cs', ...
['confidence interval as a function of firing rate']);


spikes2rate = {};
ncycles = [];
mdir = NaN * zeros(1,20);
cs = zeros(1,20);
nsr = zeros(1,20);

for ns = 1:20
    ix = find(nSpike2Cycle{1} == ns);
    sp = zeros(0,1);
    for i = ix
        sp = [sp; Data(spike2Cycle{1}{i})];
    end 
    ncycles = length(ix);
    spikes2rate{ns} = sp(:,1);
    
    if length(ix) > 5
        [mdir(ns), dd, delta, pval] = CircularMean(sp(:,1));
        cs(ns) = asin(1.96 * delta / size(sp,1));
    end
    nsr(ns) = size(sp,1);
    
end


do_fig = false;

if do_fig
    
    figure(80)
    errorbar(1:20, mdir, cs);
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
    fig.e{1} = cs * 180 /pi;
    fig.style{1} = 'ko';
    fig.x{2} = [0 21];
    fig.n{2} = [cp cp] * 180/pi;
    fig.e{2} = [];
    fig.style{2} = 'k--';
    
    fig.xLim = [0 20];
    cn = cellnames{1};
    cn = strrep(cn, '/', '_');

    fig.figureType = 'errorbar';
    fig.figureName = [cn '_prec'];
    fig_st = [fig_st { fig }];
    makeFigure(fig_st);
    
end


ix = find(nsr > 2);
[ratePrecPval, chisq, df] = CircularAnova(spikes2rate(ix));


spikes2Rate{1} = spikes2rate;



A = saveAllResources(A);

