function A = HDThetaCellsHDtheta(A)

do_fig = true;

A = getResource(A, 'PosAlpha');
posAlpha = posAlpha{1};

A = getResource(A, 'ThetaEEG');
thetaEEG = thetaEEG{1};

A = getResource(A, 'MoveCW');
moveCW = moveCW{1};

A = getResource(A, 'MoveCCW');
moveCCW = moveCCW{1};

A = getResource(A, 'HDThetaSpikeData');
A = getResource(A, 'HDThetaCellList');
A = getResource(A, 'ControlInterval');
controlInterval = controlInterval{1};

A = getResource(A, 'FirstRotationInterval');
firstRotationInterval = firstRotationInterval{1};


A = getResource(A, 'NonRotationInterval');
nonRotationInterval = nonRotationInterval{1};

 
 
 
A = registerResource(A, 'CellThetaPhase', 'tsdArray', {'HDThetaCellList', 1}, ...
    'cellThetaPhase', ...
['theta phase corresponding to each spike of cell']);
A = registerResource(A, 'CellRate', 'numeric', {'HDThetaCellList', 1}, ...
    'cellRate', ...
['mean firing rate of cell']);
A = registerResource(A, 'CellThetaPhaseMean', 'numeric', {'HDThetaCellList', 1}, ...
    'cellThetaPhaseMean', ...
    ['mean theta phase at cell spikes']);
A = registerResource(A, 'CellThetaPhaseDelta', 'numeric', {'HDThetaCellList', 1}, ...
    'cellThetaPhaseDelta', ...
    ['sample angular dispersion of  theta phase at cell spikes']);
A = registerResource(A, 'CellThetaPhasePval', 'numeric', {'HDThetaCellList', 1}, ...
    'cellThetaPhasePval', ...
    ['P-value of mean direction of  of  theta phase at cell spikes']);


A = registerResource(A, 'CellHD', 'tsdArray', {'HDThetaCellList', 1}, ...
    'cellHD', ...
    ['head direction correponding to each spike of cell']);
A = registerResource(A, 'CellHDMean', 'numeric', {'HDThetaCellList', 1}, ...
    'cellHDMean', ...
    ['mean head direction at cell spikes']);
A = registerResource(A, 'CellHDDelta', 'numeric', {'HDThetaCellList', 1}, ...
    'cellHDDelta', ...
    ['sample angular dispersion of  head direction  at cell spikes']);
A = registerResource(A, 'CellHDPval', 'numeric', {'HDThetaCellList', 1}, ...
    'cellHDPval', ...
    ['P-value of mean direction of  head direction at cell spikes']);
A = registerResource(A, 'PeakHDMean', 'numeric', {'HDThetaCellList', 1}, ...
    'peakHDMean', ...
    ['mean head direction at cell spikes in the "peak" portion of theta cycle']);
A = registerResource(A, 'PeakHDDelta', 'numeric', {'HDThetaCellList', 1}, ...
    'peakHDDelta', ...
    ['sample angular dispersion of  head direction  at cell spikes in the peak portion of theta cycle']);
A = registerResource(A, 'TroughHDMean', 'numeric', {'HDThetaCellList', 1}, ...
    'troughHDMean', ...
    ['mean head direction at cell spikes in the trough portion of theta cycle']);
A = registerResource(A, 'TroughHDDelta', 'numeric', {'HDThetaCellList', 1}, ...
    'troughHDDelta', ...
    ['sample angular dispersion of  head direction  at cell spikes']);
A = registerResource(A, 'Spike2Cycle', 'cell', {'HDThetaCellList', 1}, ...
    'spike2Cycle', ...
    ['phases of spikes occurring in  2 theta cycle periods']);

A = registerResource(A, 'NSpike2Cycle', 'cell', {'HDThetaCellList', 1}, ...
    'nSpike2Cycle', ...
    ['number of spikes occurring in  2 theta cycle periods']);


% A = registerResource(A, 'HDMeanByPhase', 'numeric', {'HDThetaCellList', 1}, ...
%     'HDMeanByPhase', ...
%     ['mean head direction at cell spikes in the trough portion of theta cycle']);
% A = registerResource(A, 'HDDeltaByPhase', 'numeric', {'HDThetaCellList', 1}, ...
%     'HDDeltaByPhase', ...
%     ['sample angular dispersion of  head direction  at cell spikes']);
% 



cellHD = {};
for i = 1:length(S)
    S{i} = Restrict(S{i}, nonRotationInterval);
    %S{i} = Restrict(S{i}, firstRotationInterval);
    cellHD{i} = Restrict(posAlpha, S{i});
    cellHD{i} = tsd(Range(S{i}), Data(cellHD{i}));
end
cellHD = tsdArray(cellHD);
[cellThetaPhase, thpeaks] = ThetaPhase(S, thetaEEG, 0, 1e20);
tp = thpeaks(1:2:end);
t2p = intervalSet(tp(1:(end-1)), tp(2:end));





for i = 1:length(S)
    d = Data(cellThetaPhase{i});
    cellRate(i) = rate(S{i}, 'TimeUnits', 's');
    [cellThetaPhaseMean(i), Rmean, cellThetaPhaseDelta(i), cellThetaPhasePval(i)] = ...
        CircularMean(d(:,1));
    [cellHDMean(i), Rmean, cellHDDelta(i), cellHDPval(i)] = ...
        CircularMean(Data(cellHD{i}));
    spike2Cycle{i} = intervalSplit(cellThetaPhase{i}, t2p);
    nSpike2Cycle{i} = zeros(length(spike2Cycle), 1);
    for j = 1:length(spike2Cycle{i})
        nSpike2Cycle{i}(j) = length(spike2Cycle{i}{j});
    end
        
end

if do_fig
    global FIGURE_DIR ;
    FIGURE_DIR = '/home/fpbatta/Data/Angelo/HtmlStuff/figures';
    
    for i = 1:length(S)
        close all
        
        cn = cellnames{i}
        cn = strrep(cn, '/', '_');
        fig_st = {};
        
        
        fig = [];
       h1 = Restrict(cellHD{i}, moveCCW);
       h2 = Restrict(cellHD{i}, moveCW);
        t1 = Restrict(cellThetaPhase{i}, moveCCW);
        t2 = Restrict(cellThetaPhase{i}, moveCW);
        
        x = [(Data(h1)- cellHDMean(i)) ; - (Data(h2)-cellHDMean(i))];
        x = mod(x, 2*pi);
        x(find(x > pi)) = x(find(x > pi)) - 2*pi;
        y = [Data(t1); Data(t2)];
        
        X = x;
        Y = y;
        x1 = y(find(x < -pi/3));
        x2 = y(find(abs(x)<pi/3));
        x3 = y(find(x > pi/3));
        
        
        x = [x ; x];
        y = [y ; y+2*pi];
        y = y(:,1);
        
        nx = 20;
        ny = 20;
        lx = linspace(-pi, pi, nx+1);
        lx = lx(1:(end-1));
        
        ly = linspace(0, 4*pi, ny+1);
        ly = ly(1:(end-1));
        n = ndhist(([x y])', [nx;ny ], [-pi; 0 ], [pi ; 4*pi]);
        
        fig.x = lx;
        fig.y = ly;
        fig.n = n';
        
        fig.figureType = 'image';
        fig.figureName = [cn '_prec'];
        
        fig_st = [fig_st { fig } ];

        %%%%% phase precession as scatter plot
        
        fig= [];
        
        fig.n{1} = y;
        fig.x{1} = x;
        fig.style{1} = 'k.';
        fig.xLim = [-pi, pi];
        fig.yLim = [0, 4 * pi];
        
        
        fig.figureType = 'plot';
        fig.figureName = [cn '_prec_scatter'];
        
        fig_st = [fig_st { fig } ];

        
        
        
        
        
        
        
        fig = []; 
        
        l = linspace(0,  2* pi , 20);
        d = Data(cellThetaPhase{i});
        y = histc(d(:,1), l);
        fig.figureType = 'hist';
        fig.x = l;
        fig.n = y;
        fig.figureName = [cn '_thetahist'];
         fig_st = [fig_st { fig } ];
        
         
         fig = []; 
        l = linspace(-pi, pi , 20);
        y = histc(Data(cellHD{i}), l);
        fig.figureType = 'hist';
        fig.x = l;
        fig.n = y;
        fig.figureName = [cn '_hdhist'];
         fig_st = [fig_st { fig } ];

         
        fig = []; 
        fig.figureType = 'plot';
        l = linspace(0, 2*pi , 20);

        y = histc(x1, l);
        y = y/sum(y);
        fig.x{1} = l;
        fig.n{1} = y;
        fig.style{1} = 'g-';
        
        y = histc(x2, l);
        y = y/sum(y);
        fig.x{2} = l;
        fig.n{2} = y;
        fig.style{2} = 'k-';
        
        y = histc(x3, l);
        y = y/sum(y);
        fig.x{3} = l;
        fig.n{3} = y;
        fig.style{3} = 'r-';
        
         

        fig.figureName = [cn '_hdtheta'];
         fig_st = [fig_st { fig } ];

         %%%%%%%%%%%%%%%%%%%%%%%
        fig = []; 
        fig.figureType = 'plot';
        l = linspace(-pi, pi , 20);
        
        Y = Y(:,1);
        x1 = find(Y > (pi/2) & Y < (3*pi/2));
        x2 = setdiff(1:length(Y), x1);
        
        y = histc(X(x1),l);
         y= y/sum(y);
         fig.x{1} = l;
        fig.n{1} = y;
        fig.style{1} = 'g-';
        [troughHDMean(i), Rmean, troughHDDelta(i), pval] = ...
            CircularMean(X(x1));
        y = histc(X(x2),l);
         y= y/sum(y);
         fig.x{2} = l;
        fig.n{2} = y;
        fig.style{2} = 'r-';
        [peakHDMean(i), Rmean, peakHDDelta(i), pval] = ...
            CircularMean(X(x2));

        
        
        
        fig.figureName = [cn '_seltheta'];
         fig_st = [fig_st { fig } ];



         
         makeFigure(fig_st);
        fprintf('theta phase mean = %g\n', cellThetaPhaseMean(i));
        fprintf('theta phase delta = %g\n', cellThetaPhaseDelta(i));
        fprintf('theta phase pval = %g\n', cellThetaPhasePval(i));
        
        fprintf('HD delta = %g\n', cellHDDelta(i));
        fprintf('HD pval = %g\n', cellHDPval(i));
        
%        keyboard
        
    
    end
end






A = saveAllResources(A);
