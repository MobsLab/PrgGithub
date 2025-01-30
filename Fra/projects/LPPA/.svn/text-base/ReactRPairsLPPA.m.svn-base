function A = ReactRPairsLPPA(A) 

startSleep2 = 1200;
durSleep2 = 600;
firingThresh = 3;
Qbin = 20 * 10; % the time bin for the Qmatrix (in 1/10000 sec)
A = getResource(A, 'CellNames');
A = getResource(A, 'SpikeData');
A = getResource(A, 'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};
%sleep1Epoch = intervalSet(End(sleep1Epoch)-600*10000, End(sleep1Epoch));

A = getResource(A, 'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};
sleep2Epoch = intervalSet(Start(sleep2Epoch)+startSleep2*10000, Start(sleep2Epoch)+(startSleep2+durSleep2)*10000);
A = getResource(A, 'MazeEpoch');
mazeEpoch = mazeEpoch{1};
A = getResource(A, 'Sleep1DeltaEpochs');
sleep1DeltaEpochs = sleep1DeltaEpochs{1};
sleep1DeltaEpochs = intersect(sleep1DeltaEpochs, sleep1Epoch);
A = getResource(A, 'Sleep2DeltaEpochs');
sleep2DeltaEpochs = sleep2DeltaEpochs{1};
sleep2DeltaEpochs = intersect(sleep2DeltaEpochs, sleep2Epoch);

A = getResource(A, 'FRateSleep1');

A = registerResource(A, 'PairEV', 'numeric', {1,1}, ...
    'EV', ...
    ['cell pair correlation explained variance']);

A = registerResource(A, 'PairEVr', 'numeric', {1,1}, ...
    'EVr', ...
    ['cell pair correlation explained variance']);

A = registerResource(A, 'PairEVDelta', 'numeric', {1,1}, ...
    'EVDelta', ...
    ['cell pair correlation explained variance during delta']);

A = registerResource(A, 'PairEVDeltar', 'numeric', {1,1}, ...
    'EVDeltar', ...
    ['cell pair correlation explained variance during delta']);

A = registerResource(A, 'CellPairI', 'numeric', {[], 1}, ...
    'cell_I', ...
    ['the index of the first cell in the pair, according' ...
    ' to the order used in ReactR variables']);
A = registerResource(A, 'CellPairJ', 'numeric', {[], 1}, ...
    'cell_J', ...
    ['the index of the second cell in the pair, according' ...
    ' to the order used in RP variables']);

A = registerResource(A, 'RPairCS1', 'numeric', {[],1}, ...
    'RpairC_s1', ...
    ['cell pair correlation during sleep1 for all' ...
    ' viable cell pairs']);
A = registerResource(A, 'RPairCS2', 'numeric', {[],1}, ...
    'RpairC_s2', ...
    ['cell pair correlation during sleep2 for all' ...
    ' viable cell pairs']);
A = registerResource(A, 'RPairCS1', 'numeric', {[],1}, ...
    'RpairC_ds1', ...
    ['cell pair correlation during sleep1 for all' ...
    ' viable cell pairs during delta']);
A = registerResource(A, 'RPairCS2', 'numeric', {[],1}, ...
    'RpairC_ds2', ...
    ['cell pair correlation during sleep2 for all' ...
    ' viable cell pairs during delta']);

A = registerResource(A, 'RPairCMaze', 'numeric', {[],1}, ...
    'RpairC_m', ...
    ['cell pair correlation during sleep2 for all' ...
    ' viable cell pairs']);

nCells = length(cellnames);

%cellSet = 1:nCells;
cellSet = find(fRateSleep1 < firingThresh);
S_s1 = tsdArray(nCells,1);
S_s2 = tsdArray(nCells,1);
S_m = tsdArray(nCells,1);
S_ds1 = tsdArray(nCells,1);
S_ds2 = tsdArray(nCells,1);


for i = 1:length(S)
    S_s1{i} = Restrict(S{i}, sleep1Epoch);
    S_m{i} = Restrict(S{i}, mazeEpoch);
    S_s2{i} = Restrict(S{i}, sleep2Epoch);
    S_ds1{i} = Restrict(S{i}, sleep1DeltaEpochs);
    S_ds2{i} = Restrict(S{i}, sleep2DeltaEpochs);
end


sfx = { '_s1', '_m', '_s2', '_ds1', '_ds2'};

[X, Y] = meshgrid(cellSet, cellSet);

idx = find((~findOnSameTrodeMatrixKK(cellnames(cellSet))) & (X > Y) );
cell_I = X(idx);
cell_J = Y(idx);
for i = 1:5
    sf = sfx{i};
    eval(['S_epoch = S' sf ';']);
    Q = MakeQfromS(S_epoch, Qbin);
    Q = tsd(Range(Q, 'ts'), full(Data(Q)));
    warning off
    cQ = corrcoef(Data(Q));
    warning on
    RpairC = full(cQ(idx));
    eval(['RpairC' sf ' = RpairC;']);
    clear Q cQ RpairC
end

% now compute the explained variance: ReactEV computes the partial
% correlation coefficients, taking care of NaNs  that arise from
% correlations from empty spike trains
%  keyboard
[EV EVr] = ReactEV(RpairC_s1, RpairC_s2, RpairC_m);
[EVDelta EVDeltar] = ReactEV(RpairC_ds1, RpairC_ds2, RpairC_m);

A = saveAllResources(A);