function A = PairCov(A)

%  this function computes Cell Pairs covariance 
%  
%  Register:
%    	         CS1: correlation coefficients of the cell pairs for the S1 epoch
%                CS2: id for S2 epoch
%                 CM: id for maze epoch
%            CS1Vect: correlation coefficients of the cell pairs for the S1 epoch in vector format
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


A = getResource(A,'FiringS1');
firingS1 = firingS1{1};
A = getResource(A,'FiringS2');
firingS2 = firingS2{1};
A = getResource(A,'FiringM');
firingM = firingM{1};
A = getResource(A,'SpikeData');
A = getResource(A,'ExcludedCells');
excludedCells = excludedCells{1};

%  dim_by_cell = {'CellNames', []};

%  A = registerResource(A,'CS1','numeric',{1,1}, ...
%      'cS1', 'matirx of correlation coefficient for sleep1');	
%  
%  A = registerResource(A,'CS2','numeric',{1,1}, ...
%      'cS2', 'matirx of correlation coefficient for sleep1');	

A = registerResource(A,'CM','numeric',{1,1}, ...
    'cM', 'matirx of correlation coefficient for sleep1');	

%  A = registerResource(A,'CS1Vect','numeric',{1,1}, ...
%      'cS1Vect', 'matrix of correlation coefficient for sleep1');	
%  
%  A = registerResource(A,'CS2Vect','numeric',{1,1}, ...
%      'cS2Vect', 'matrix of correlation coefficient for sleep1');	
%  
%  A = registerResource(A,'CMVect','numeric',{1,1}, ...
%      'cMVect', 'matrix of correlation coefficient for sleep1');	
%  
%  A = registerResource(A,'CellPair','cell',{[],1}, ...
%      'cellPair', 'array of cells pairs corresponding to values of the C__Vect. Warning : cells index are not the same as S!');	
%  
%  A = registerResource(A,'RMS1','numeric',{1,1}, ...
%      'rMS1', 'correlation coefficient of the distribution of cS1 values vs cM ones');	
%  
%  A = registerResource(A,'RMS2','numeric',{1,1}, ...
%      'rMS2', 'correlation coefficient of the distribution of cS2 values vs cM ones');
%  
%  A = registerResource(A,'RS2S1','numeric',{1,1}, ...
%      'rS2S1', 'correlation coefficient of the distribution of cS2 values vs cS1 ones (preactivation control)');
%  
%  A = registerResource(A,'PMS1','numeric',{1,1}, ...
%      'pMS1', 'linear regression of the distribution of cS1 values vs cM ones');	
%  
%  A = registerResource(A,'PMS2','numeric',{1,1}, ...
%      'pMS2', 'linear regression of the distribution of cS2 values vs cM ones');
%  
%  A = registerResource(A,'PS2S1','numeric',{1,1}, ...
%      'pS2S1', 'linear regression of the distribution of cS2 values vs cS1 ones (preactivation control)');
%  
%  A = registerResource(A,'EV','numeric',{1,1}, ...
%      'eV', 'explained variance');


nbCells = length(S) - length(excludedCells);

cS1 = corrcoef(zTransform(firingS1));
cS2 = corrcoef(zTransform(firingS2));
cM = corrcoef(zTransform(firingM));

cS1Vect = zeros(nbCells*(nbCells-1)/2,1);
cS2Vect = zeros(nbCells*(nbCells-1)/2,1);
cMVect = zeros(nbCells*(nbCells-1)/2,1);
cellPair = cell(nbCells*(nbCells-1)/2,1,1);
ix = 1;

for i=1:nbCells

	for j=i+1:nbCells

		cS1Vect(ix) = cS1(i,j);
		cS2Vect(ix) = cS2(i,j);
		cMVect(ix) = cM(i,j);
		cellPair{ix} = [i j];
		ix = ix + 1;

	end

end

%Corr Coef conputation...

cMS1 = corrcoef(cMVect,cS1Vect);
cMS2 = corrcoef(cMVect,cS2Vect);
cS2S1 = corrcoef(cS2Vect,cS1Vect);

rMS1 = cMS1(1,2);
rMS2 = cMS2(1,2);
rS2S1 = cS2S1(1,2);

% ...or linear regression to have the slope of the distribution
pMS1 = {polyfit(cMVect,cS1Vect,1)};
pMS2 = {polyfit(cMVect,cS2Vect,1)};
pS2S1 = {polyfit(cS2Vect,cS1Vect,1)};

eV = {((rMS2-rMS1*rS2S1)/sqrt((1-rMS1^2)*(1-rS2S1^2)))^2};

cS1 = {cS1};
cS2 = {cS2};
cM = {cM};
cS1Vect = {cS1Vect};
cS2Vect = {cS2Vect};
cMVect = {cMVect};
rMS1 = {cMS1};
rMS2 = {rMS2};
rS2S1 = {rS2S1};

A = saveAllResources(A);