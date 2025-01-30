function getVal = getVal(pairCovObj,val)

nbExp = size(pairCovObj);
getVal = zeros(nbExp,1);

for i=1:nbExp

	eval(['getVal(i) = pairCovObj{i}.' val ';']);

end