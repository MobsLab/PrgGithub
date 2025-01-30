function A = LPPAReactRate(A)

A = getResource(A, 'FRateMaze');
A = getResource(A, 'FRateSleep2');
A = getResource(A, 'FRateDeltaSleep1');
A = getResource(A, 'FRateDeltaSleep2');

dim_by_cell = {'CellNames', 1};


A = registerResource(A, 'XDelta_S2S1', 'numeric', dim_by_cell, ...
    'XDelta_S2S1', ...
    ['log ration of firing rate during sleep2', ...
    ' and 1'], 1);

A = registerResource(A, 'X_MS1', 'numeric', dim_by_cell, ...
    'XDelta_MS1', ...
    ['log ration of firing rate during maze', ...
    ' and sleep 1'], 1);

A = registerResource(A, 'X_MS2', 'numeric', dim_by_cell, ...
    'XDelta_MS2', ...
    ['log ration of firing rate during maze', ...
    ' and sleep 2'], 1);

A = registerResource(A, 'ReactGlobalSlopeDelta', 'numeric', {1,1}, ...
    'reactGlobalSlopeDelta', ...
    ['slope of the log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalInterceptDelta', 'numeric', {1,1}, ...
    'reactGlobalInterceptDelta', ...
    ['intercept of the log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalRDelta', 'numeric', {1,1}, ...
    'reactGlobalRDelta', ...
    ['r-value of the log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalPvalDelta', 'numeric', {1,1}, ...
    'reactGlobalPvalDelta', ...
    ['pval of the log rate ratio regression'], 1);


A = registerResource(A, 'ReactGlobalSlopeRevDelta', 'numeric', {1,1}, ...
    'reactGlobalSlopeRevDelta', ...
    ['slope of the reverse log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalInterceptRevDelta', 'numeric', {1,1}, ...
    'reactGlobalInterceptRevDelta', ...
    ['intercept of the reverse log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalRRevDelta', 'numeric', {1,1}, ...
    'reactGlobalRRevDelta', ...
    ['r-value of the reverse log rate ratio regression'], 1);

A = registerResource(A, 'ReactGlobalPvalRevDelta', 'numeric', {1,1}, ...
    'reactGlobalPvalRevDelta', ...
    ['pval of the reverse log rate ratio regression'], 1);

 
warning off
  XDelta_MS1 = log10((fRateMaze) ./ (fRateDeltaSleep1));
  XDelta_MS2 = log10((fRateMaze) ./ (fRateDeltaSleep2));
  XDelta_S2S1 = log10((fRateDeltaSleep2) ./ (fRateDeltaSleep1));
warning on 

[reactGlobalInterceptDelta, reactGlobalSlopeDelta, reactGlobalRDelta, reactGlobalPvalDelta] = ...
    regression_line(XDelta_MS1, XDelta_S2S1);
[reactGlobalInterceptRevDelta, reactGlobalSlopeRevDelta, reactGlobalRRevDelta, reactGlobalPvalRevDelta] = ...
    regression_line(XDelta_MS2, -XDelta_S2S1);

figure(1), clf
plot(XDelta_MS1, XDelta_S2S1, '.');
hold on 
xl = get(gca, 'xlim');
plot(xl, reactGlobalSlopeDelta * xl + reactGlobalInterceptDelta, 'k--');
axis equal

figure(2), clf
plot(XDelta_MS2, -XDelta_S2S1, '.');
hold on 
xl = get(gca, 'xlim');
plot(xl, reactGlobalSlopeRevDelta * xl + reactGlobalInterceptRevDelta, 'k--');
axis equal 

reactGlobalRDelta
reactGlobalRRevDelta
keyboard

A = saveAllResources(A);


