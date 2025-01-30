function A = AmyphysIdExprSparseness(A)


A = getResource(A, 'RateId');
A = getResource(A, 'RateThreat');
A = getResource(A, 'RateNeutral');
A = getResource(A, 'RateLipsmack');

A = registerResource(A , 'SparsenessId', 'numeric', {'AmygdalaCellList', 1}, ...
    'sparsenessId', ...
    ['sparseness for id stimuli']);

A = registerResource(A , 'SparsenessExpr', 'numeric', {'AmygdalaCellList', 1}, ...
    'sparsenessExpr', ...
    ['sparseness for expr stimuli']);

sparsenessId = zeros(length(rateThreat), 1);
sparsenessExpr = zeros(length(rateThreat), 1);
for i = 1:length(rateThreat)
    rE = [rateThreat(i) rateNeutral(i) rateLipsmack(i)];
    rI = rateId{i};
    sparsenessExpr(i) = sparseness(rE);
    sparsenessId(i) = sparseness(rI);
end

A = saveAllResources(A);

function a = sparseness(v)

a= (mean(v)).^2 / mean(v.^2);

