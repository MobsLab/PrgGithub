function A = basicFiringStats(A)


A = getResource(A, 'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};
A = getResource(A, 'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};
A = getResource(A, 'MazeEpoch');
mazeEpoch = mazeEpoch{1};
A = getResource(A, 'Sleep1DeltaEpochs');
sleep1DeltaEpochs = sleep1DeltaEpochs{1};
A = getResource(A, 'Sleep2DeltaEpochs');
sleep2DeltaEpochs = sleep2DeltaEpochs{1};
A = getResource(A, 'CellNames');
A = getResource(A, 'SpikeData');


A = registerResource(A, 'FRateMaze', 'numeric', {'CellNames', 1}, ...
    'fRateMaze', ...
    ['average firing rate for maze epoch']);
A = registerResource(A, 'FRateSleep1', 'numeric', {'CellNames', 1}, ...
    'fRateSleep1', ...
    ['average firing rate for sleep 1 epoch']);
A = registerResource(A, 'FRateSleep2', 'numeric', {'CellNames', 1}, ...
    'fRateSleep2', ...
    ['average firing rate for sleep 2 epoch']);
A = registerResource(A, 'FRateDeltaSleep1', 'numeric', {'CellNames', 1}, ...
    'fRateDeltaSleep1', ...
    ['average firing rate for sleep 1 epoch during delta']);
A = registerResource(A, 'FRateDeltaSleep2', 'numeric', {'CellNames', 1}, ...
    'fRateDeltaSleep2', ...
    ['average firing rate for sleep 2 epoch during delta']);

fRateMaze = zeros(size(cellnames));
fRateSleep1= zeros(size(cellnames));
fRateSleep2 = zeros(size(cellnames));
fRateDeltaSleep1 = zeros(size(cellnames));
fRateDeltaSleep2 = zeros(size(cellnames));

epochs = {mazeEpoch, sleep1Epoch, sleep2Epoch, sleep1DeltaEpochs, sleep2DeltaEpochs};
rates = {'fRateMaze', 'fRateSleep1', 'fRateSleep2', 'fRateDeltaSleep1', 'fRateDeltaSleep2'};

for i = 1:length(S)
    for iE = 1:length(epochs)
        rate = length(Restrict(S{i}, epochs{iE})) / tot_length(epochs{iE}, 's');
        eval([rates{iE} '(i) = rate;']);
    end
end


A = saveAllResources(A);