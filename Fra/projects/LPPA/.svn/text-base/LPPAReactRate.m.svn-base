function A = LPPAReactRate(A)

A = getResource(A, 'FRateMaze');
A = getResource(A, 'FRateSleep1');
A = getResource(A, 'FRateSleep2');
A = getResource(A, 'FRateDeltaSleep1');
A = getResource(A, 'FRateDeltaSleep2');

dim_by_cell = {'CellNames', 1};


A = registerResource(A, 'X_S2S1', 'numeric', dim_by_cell, ...
    'X_S2S1', ...
    ['log ration of firing rate during sleep2', ...
    ' and 1'], 1);

A = registerResource(A, 'X_MS1', 'numeric', dim_by_cell, ...
    'X_MS1', ...
    ['log ration of firing rate during maze', ...
    ' and sleep 1'], 1);

A = registerResource(A, 'X_MS2', 'numeric', dim_by_cell, ...
    'X_MS2', ...
    ['log ration of firing rate during maze', ...
    ' and sleep 2'], 1);

A = registerResource(A, 'ReactGlobalSlope', 'numeric', {1,1}, ...
    'reactGlobalSlope', ...
    ['slope of the log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalIntercept', 'numeric', {1,1}, ...
    'reactGlobalIntercept', ...
    ['intercept of the log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalR', 'numeric', {1,1}, ...
    'reactGlobalR', ...
    ['r-value of the log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalPval', 'numeric', {1,1}, ...
    'reactGlobalPval', ...
    ['pval of the log rate ratio regression'], 1);


A = registerResource(A, 'ReactGlobalSlopeRev', 'numeric', {1,1}, ...
    'reactGlobalSlopeRev', ...
    ['slope of the reverse log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalInterceptRev', 'numeric', {1,1}, ...
    'reactGlobalInterceptRev', ...
    ['intercept of the reverse log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalRRev', 'numeric', {1,1}, ...
    'reactGlobalRRev', ...
    ['r-value of the reverse log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalPvalRev', 'numeric', {1,1}, ...
    'reactGlobalPvalRev', ...
    ['pval of the reverse log rate ratio regression'], 1);

 
warning off
  X_MS1 = log10((fRateMaze) ./ (fRateSleep1));
  X_MS2 = log10((fRateMaze) ./ (fRateSleep2));
  X_S2S1 = log10((fRateSleep2) ./ (fRateSleep1));
warning on 

[reactGlobalIntercept, reactGlobalSlope, reactGlobalR, reactGlobalPval] = ...
    regression_line(X_MS1, X_S2S1);
[reactGlobalInterceptRev, reactGlobalSlopeRev, reactGlobalRRev, reactGlobalPvalRev] = ...
    regression_line(X_MS2, -X_S2S1);

figure(1), clf
plot(X_MS1, X_S2S1, '.');
hold on 
xl = get(gca, 'xlim');
plot(xl, reactGlobalSlope * xl + reactGlobalIntercept, 'k--');
axis equal

figure(2), clf
plot(X_MS2, -X_S2S1, '.');
hold on 
xl = get(gca, 'xlim');
plot(xl, reactGlobalSlopeRev * xl + reactGlobalInterceptRev, 'k--');
axis equal 

reactGlobalR
reactGlobalRRev
keyboard

A = saveAllResources(A);


