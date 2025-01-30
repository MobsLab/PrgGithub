function A = LPPAReactRate(A)


binStart = [0, 600, 1200];
binDur = 600;

A = getResource(A, 'CellNames');
A = getResource(A, 'SpikeData');
A = getResource(A, 'FRateMaze');
A = getResource(A, 'FRateSleep1');



A = getResource(A, 'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};




A = registerResource(A, 'ReactSlopeBinned', 'numeric', {1, []}, ...
    'reactSlope', ...
    ['slope of the log rate ratio regression in 10 minutes bins'], 1);

A = registerResource(A, 'ReactInterceptBinned', 'numeric', {1, []}, ...
    'reactIntercept', ...
    ['intercept of the log rate ratio regression in 10 minutes bins'], 1);

A = registerResource(A, 'ReactRBinned', 'numeric', {1, []}, ...
    'reactR', ...
    ['r-value of the log rate ratio regression in 10 minutes bins'], 1);

A = registerResource(A, 'ReactlPvalBinned', 'numeric', {1, []}, ...
    'reactPval', ...
    ['pval of the log rate ratio regression in 10 minutes bins'], 1);


A = registerResource(A, 'ReactSlopeRevBinned', 'numeric', {1, []}, ...
    'reactSlopeRev', ...
    ['slope of the reverse log rate ratio regression in 10 minutes bins'], 1);

A = registerResource(A, 'ReactInterceptRevBinned', 'numeric', {1, []}, ...
    'reactInterceptRev', ...
    ['intercept of the reverse log rate ratio regression in 10 minutes bins'], 1);

A = registerResource(A, 'ReactRRevBinned', 'numeric', {1, []}, ...
    'reactRRev', ...
    ['r-value of the reverse log rate ratio regression in 10 minutes bins'], 1);

A = registerResource(A, 'ReactPvalRevBinned', 'numeric', {1, []}, ...
    'reactPvalRev', ...
    ['pval of the reverse log rate ratio regression in 10 minutes bins'], 1);

 
reactSlope = zeros(size(binStart));
reactIntercept = zeros(size(binStart));
reactR = zeros(size(binStart));
reactPval = zeros(size(binStart));
reactSlopeRev = zeros(size(binStart));
reactInterceptRev = zeros(size(binStart));
reactRRev = zeros(size(binStart));
reactPvalRev = zeros(size(binStart));


for iB = 1:length(binStart)
    se = intervalSet(Start(sleep2Epoch)+binStart(iB)*10000, Start(sleep2Epoch)+(binStart(iB)+binDur)*10000);
    fRateSleep2 = zeros(size(fRateSleep1));
    for iX = 1:length(S)
        fRateSleep2(iX) = length(Restrict(S{iX}, se)) / tot_length(se, 's');
    end
    
   
    
    goodCells = find(fRateSleep1 > 0 & fRateSleep2 > 0 & fRateMaze > 0);

    warning off
    X_MS1 = log10((fRateMaze) ./ (fRateSleep1));
    X_MS2 = log10((fRateMaze) ./ (fRateSleep2));
    X_S2S1 = log10((fRateSleep2) ./ (fRateSleep1));
    warning on

    [reactIntercept(iB), reactSlope(iB), reactR(iB), reactPval(iB)] = ...
        regression_line(X_MS1(goodCells), X_S2S1(goodCells));
    [reactInterceptRev(iB), reactSlopeRev(iB), reactRRev(iB), reactPvalRev(iB)] = ...
        regression_line(X_MS2(goodCells), -X_S2S1(goodCells));
end

A = saveAllResources(A);


