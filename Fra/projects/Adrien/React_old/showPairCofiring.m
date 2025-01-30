function showPairCofiring = showPaircofiring(PairCovObj,pairsCorr)

%Parameters
binSize = 50;
nbPairs = length(pairsCorr);

load(['~/Data/LPPA/' pairCovObj.dset 'AdrienData.mat']);
load(['~/Data/LPPA/' pairCovObj.dset 'AdrienData2.mat']);

Mbin = regular_interval(Start(MEpoch),Stop(MEpoch),binSize);

for i=1:nbPairs

	cells = pairCovObj.cellPair{pairsCorr(i)};
		
	TT1 = cellnames{cells(1)};
	TT2 = cellnames{cells(2)};
		
	if TT1(3) ~= TT2(3)

		if Data(intervalRate(S{i},Mbin))

			

		end
	end
end