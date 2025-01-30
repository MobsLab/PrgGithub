function cellsMayBeInPatterns = FindPattern(pairCovObj)
%  
%  NGDF = FindPatter(pairCovObj) returns a array
%  NGDF: Array of
%  	1 - NeuroxidenceStat (by G. Pipa)
%  	2 - data in GDF format
% 	3 - cellsMayBeInPatterns (vector of cells  number)
%
%  Adrien Peyrache 2006

NeuroXidenceStat = 0;
dataGDF = 0;


% Parameters

minSleepCorrDifference = 0.01;
minMCorr = 0.1;
pairsMayBeInPatterns = [];
nbPairs = length(pairCovObj.cellPair);

for i=1:nbPairs

	if pairCovObj.CMVect(i) > minMCorr
	
		if pairCovObj.CS2Vect(i) - pairCovObj.CS1Vect(i) > minSleepCorrDifference
			pairsMayBeInPatterns = [pairsMayBeInPatterns i];
		end
	end

end

cellsHighCovFq = zeros(pairCovObj.nbCells,1);



for i=1:length(pairsMayBeInPatterns)

	cells = pairCovObj.cellPair{pairsMayBeInPatterns(i)};
	cellsHighCovFq(cells(1)) = cellsHighCovFq(cells(1)) + 1;
	cellsHighCovFq(cells(2)) = cellsHighCovFq(cells(2)) + 1;

end

cellsMayBeInPatterns = find(cellsHighCovFq > 1);
cellsHighCovFq = cellsHighCovFq(cellsMayBeInPatterns);

nbCorrPairs = length(pairsMayBeInPatterns);
removedPairs = 0;

if nbCorrPairs
	
	load(['~/Data/LPPA/' pairCovObj.dset 'AdrienData.mat']);
	load(['~/Data/LPPA/' pairCovObj.dset 'AdrienData2.mat']);


%	trialInterval = intervalSet(Range(startTrial)-10000 , Range(trialOutcome) + 10000);
%	NGDF{1} = Fra2GDF(S,cellsMayBeInPatterns,trialInterval);
%  	NGDF{2} = NeuroX(NGDF{s1},length(cellsMayBeInPatterns))
	
end