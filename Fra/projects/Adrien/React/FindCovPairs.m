function A = FindCovPairs(A)
%  
%  
%  Adrien Peyrache 2006

NeuroXidenceStat = 0;
dataGDF = 0;

% Parameters

minSleepCorrDifference = 0.09;
minMCorr = -1;
absCheck = 'abs'; % = 'abs' for + and - variation, '' only for on of those


if minSleepCorrDifference > 0
	inequalityCheck = '>';
else
	inequalityCheck = '<';
end

%Declaration of Objects

nbPairs = length(pairCovObj.cellPair);
pairsCorr = [];

% Select  correlation pairs

for i=1:nbPairs

	if pairCovObj.CMVect(i) > minMCorr
	
		eval(['if (' absCheck '(pairCovObj.CS2Vect(i) - pairCovObj.CS1Vect(i)) ' inequalityCheck ' minSleepCorrDifference) pairsCorr = [pairsCorr i]; end']);
			
%  		eval('end')
	end

end


cellsCovFq = zeros(pairCovObj.nbCells,1);

for i=1:length(pairsCorr)

	cells = pairCovObj.cellPair{pairsCorr(i)};
	cellsCovFq(cells(1)) = cellsCovFq(cells(1)) + 1;
	cellsCovFq(cells(2)) = cellsCovFq(cells(2)) + 1;

end

nbGoodPairs = showPairXCorr(pairCovObj,pairsCorr);

%  showPairCofiring(pairCovobj,pairsCorr);