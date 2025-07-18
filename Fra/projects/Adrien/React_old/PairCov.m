function pairCovResult = PairCov(pairCovObject)

%  this function computes Cell Pairs covariance 
%  INPUT: pairCovObject
%  		dset: dataset
%  	     nbCells: # of cells minus the excluded ones
%      excludedCells: vector containing the excluded cell in the case of nonZero option is set to 1
%           firingS1: matrix of binned firing rate (bins x cells) for the S1 epoch
%           firingS2: id for S2 epoch
%            firingM: id for maze epoch
%  
%  RETURN : a object with the same property as the one given in input and in addition
%  
%            CS1Vect: correlation coefficients of the cell pairs for the S1 epoch
%            CS2Vect: id for S2 epoch
%             CMVect: id for maze epoch
%           cellPair: array of [cell1 cell2], the 2 cells of the cell pair (size of the array is the same as corr coeff vectors)
%               rMS1: corr coef of CS1 versus CM  
%               rMS2: corr coef of CS2 versus CM  
%              rS2S1: corr coef of CS2 versus CS1 (for preactivation control)  
%               pMS1: polynomial coeeficient of the linea regression of S1 versus CM
%               pMS2: id for CS2 vs CM
%              pS2S1: id for CS2 vs CS1
%                 EV: explained variance 

%  Adrien Peyrache 2006

nbCells = pairCovObject.nbCells;

CS1 = corrcoef(pairCovObject.firingS1);
CS2 = corrcoef(pairCovObject.firingS2);
CM = corrcoef(pairCovObject.firingM);

pairCovObject.CS1Vect = zeros(nbCells*(nbCells-1)/2,1);
pairCovObject.CS2Vect = zeros(nbCells*(nbCells-1)/2,1);
pairCovObject.CMVect = zeros(nbCells*(nbCells-1)/2,1);
pairCovObject.cellPair = cell(nbCells*(nbCells-1)/2,1,1);
ix = 1;

for i=1:nbCells

	for j=i+1:nbCells

		pairCovObject.CS1Vect(ix) = CS1(i,j);
		pairCovObject.CS2Vect(ix) = CS2(i,j);
		pairCovObject.CMVect(ix) = CM(i,j);
		pairCovObject.cellPair{ix} = [i j];
		ix = ix + 1;

	end

end

%Corr Coef conputation...

CMS1 = corrcoef(pairCovObject.CMVect,pairCovObject.CS1Vect);
CMS2 = corrcoef(pairCovObject.CMVect,pairCovObject.CS2Vect);
CS2S1 = corrcoef(pairCovObject.CS2Vect,pairCovObject.CS1Vect);

pairCovObject.rMS1 = CMS1(1,2);
pairCovObject.rMS2 = CMS2(1,2);
pairCovObject.rS2S1 = CS2S1(1,2);

% ...or linear regression to have the slope of the distribution
pairCovObject.pMS1 = polyfit(pairCovObject.CMVect,pairCovObject.CS1Vect,1);
pairCovObject.pMS2 = polyfit(pairCovObject.CMVect,pairCovObject.CS2Vect,1);
pairCovObject.pS2S1 = polyfit(pairCovObject.CS2Vect,pairCovObject.CS1Vect,1);

pairCovObject.EV = ((pairCovObject.rMS2-pairCovObject.rMS1*pairCovObject.rS2S1)/sqrt((1-pairCovObject.rMS1^2)*(1-pairCovObject.rS2S1^2)))^2;

pairCovResult = pairCovObject;

