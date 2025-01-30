function A = AmyphysIdExprSparseness(A)


A = getResource(A, 'RateId');
A = getResource(A, 'RateThreat');
A = getResource(A, 'RateNeutral');
A = getResource(A, 'RateLipsmack');
A = getResource(A, 'FRateBaseline');
A = registerResource(A , 'SparsenessSubId', 'numeric', {'AmygdalaCellList', 1}, ...
    'sparsenessSubId', ...
    ['sparseness for id stimuli']);

A = registerResource(A , 'SparsenessSubExpr', 'numeric', {'AmygdalaCellList', 1}, ...
    'sparsenessSubExpr', ...
    ['sparseness for expr stimuli']);

sparsenessSubId = zeros(length(rateThreat), 1);
sparsenessSubExpr = zeros(length(rateThreat), 1);
for i = 1:length(rateThreat)
    rE = [rateThreat(i) rateNeutral(i) rateLipsmack(i)];
    rE = rE-frateBaseline(i);
    rE(rE < 0) = 0;
    rI = rateId{i};
    rI = rI-frateBaseline(i);
    rI(rI < 0) = 0;
    sparsenessSubExpr(i) = sparseness(rE);
    sparsenessSubId(i) = sparseness(rI);
end

A = saveAllResources(A);

function a = sparseness(v)

a= (mean(v)).^2 / mean(v.^2);

