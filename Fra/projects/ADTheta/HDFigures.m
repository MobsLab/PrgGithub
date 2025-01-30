function HDFigures

close all

hm = getenv('HOME');
parent_dir = [ hm '/Data/Angelo'];
A = Analysis(parent_dir);
datasets = List2Cell([ parent_dir filesep 'datasets_eeg.list' ] );


global FIGURE_DIR ;
FIGURE_DIR = '/home/fpbatta/Data/Angelo/figures';
global N_FIGURE
N_FIGURE = 1;


fig_st = {};

fig = [];





%%%%%%%%%%%%%%%%%%% the theta example

load([parent_dir filesep datasets{1} filesep 'eeg0.mat']);

er = Restrict(eeg, intervalSet(26528000, 26548000));

fig.x{1} = Range(er, 's');
fig.n{1} = detrend(Data(er));
fig.figureType = 'plot';
fig.figureName = 'theta_example';
fig.xLim = ([26528000, 26548000]/10000);
fig.noXTick = 1;
fig.noYTick = 1;

fig_st = [fig_st { fig } ];


%%%%%%%%%%%%%%%%%%%% the theta power spectrum 

load theta_spectrum
fig = [];
fig.x{1} = f;
fig.n{1} = S;
fig.figureType = 'plot';
fig.figureName = 'theta_spectrum';
fig.xLim = [0 20];
fig.yLim = [0 0.1];

fig_st = [fig_st { fig } ];



%%%%%%%%%%%%%%%%%%%% exampel of angular receptive field

A= getResource(A, 'CellHD', datasets{4});

d = Data(cellHD{1});

d(d < 0) = d(d< 0) + 2 *pi;

[hy, hx] = hist(d, 20);

fig = [];

fig.x{1} = hx * 180 / (pi); 
fig.n{1} = hy;
fig.xLim = [0 360];
fig.xTick = 0:60:360;
fig.xLabel = 'Head direction (degrees)';
fig.yLabel = 'count';

fig.figureType = 'plot'; 
fig.figureName = 'HDExample';

fig_st = [fig_st { fig } ];

%%%%%%%%%%%%%%%%% histogram of firing rates 

A = getResource(A, 'CellRate', datasets);

[hy, hx] = hist(cellRate, 20);

fig = [];

fig.x = hx;
fig.n = hy';
fig.xLim = [0 60];
fig.yLim = [ 0 6];
fig.figureType = 'hist';
fig.figureName = 'rate_distrib';
fig_st = [fig_st { fig } ];


%%%%%%%%%%%%%%% histogram of log p-values for theta 



A = getResource(A, 'CellThetaPhasePval', datasets);

[hy, hx] = hist(-log10(cellThetaPhasePval), 80);

fig = [];
fig.x = hx;
fig.n = hy';
fig.yLim = [0 4];
fig.yTick = [0 1 2 3 4];
fig.figureType = 'hist';
fig.figureName = 'pval_distrib';
fig_st = [fig_st { fig } ];


%%%%%%%%%%%%%%% histogram of preferred theta phases



A = getResource(A, 'CellThetaPhaseMean', datasets);
cp = cellThetaPhaseMean;
cp(cp < 0) = cp(cp < 0) + 2 * pi;
l = linspace(0,  2* pi , 20);

[hy, hx] = hist(cp, l);


fig = [];
fig.x = hx * 180 / pi;
fig.n = hy';
fig.xLim = [0 360];
fig.yLim = [0 4];
fig.yTick = [0 1 2 3 4];
fig.xTick = 0:60:360;

fig.figureType = 'hist';
fig.xLabel = 'Theta Phase (degrees)';
fig.yLabel = 'count';
fig.figureName = 'prefphase_distrib';
fig_st = [fig_st { fig } ];


%%%%% example of theta modulation 

A= getResource(A, 'CellThetaPhase', datasets{4});
d = Data(cellThetaPhase{1});
d = d(:,1);

l = linspace(0,  2* pi , 20);
        
y = histc(d, l);

fig = [];

fig.x = l * 180 / (pi); 
fig.n = y;
fig.xLim = [0 360];
fig.yLim = [0 1800];
fig.xTick = 0:60:360;
fig.xLabel = 'Theta Phase (degrees)';
fig.yLabel = 'count';

fig.figureType = 'hist'; 
fig.figureName = 'ThetaExample';
fig_st = [fig_st { fig } ];

%%%%%%%%%% another example of theta modulation 

A= getResource(A, 'CellThetaPhase', datasets{1});
d = Data(cellThetaPhase{1});
d = d(:,1);

l = linspace(0,  2* pi , 20);
        
y = histc(d, l);

fig = [];

fig.x = l * 180 / (pi); 
fig.n = y;
fig.xLim = [0 360];
fig.yLim = [0 1800];
fig.xTick = 0:60:360;
fig.xLabel = 'Theta Phase (degrees)';
fig.yLabel = 'count';

fig.figureType = 'hist'; 
fig.figureName = 'ThetaExample2';

fig_st = [fig_st { fig } ];



makeFigure(fig_st);
