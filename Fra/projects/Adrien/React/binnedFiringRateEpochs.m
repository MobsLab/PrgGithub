function A = binnedFiringRateEpochs(A)

%  this function bins firing rate
%  expSet : char of the type 'XX/YY' (example 20/1014 : rat nb 20 and day 10/14)
%  binSize : in 10^-4 sec
%  nonZero : set to 1 if non firing cells over one the 3 epochs (S1,Maze,S2) has to be excluded (may generates null corr coef). 0 otherwise
%  suffle : set to 1 to shuffle the binned firing rates  by randomly permutes the firing rates vectors
%  
%  RETURNS a obj :
%  
%            nbCells: # of cells minus the excluded ones
%      excludedCells: vector containing the excluded cell in the case of nonZero option is set to 1
%           firingS1: matrix of binned firing rate (bins x cells) for the S1 epoch
%           firingS2: id for S2 epoch
%            firingM: id for maze epoch
%  
%  Adrien Peyrache 2006        


%Parameters

binSize = 1000;
nonZero = 1;
shuffle = 0;


A = getResource(A,'SpikeData');
A = getResource(A,'Sleep1Epoch');
A = getResource(A,'Sleep2Epoch');
A = getResource(A,'MazeEpoch');
A = getResource(A,'GoodCells');
goodCells = goodCells{1};

%  dim_by_cell = {'CellNames', []};

A = registerResource(A, 'FiringS1', 'numeric', {1,1}, ...
    'firingS1', 'binned firing rate during sleep1 Epoch');

A = registerResource(A, 'FiringS2', 'numeric', {1,1}, ...
    'firingS2', 'binned firing rate during sleep2 Epoch');

A = registerResource(A, 'FiringM', 'numeric', {1,1}, ...
    'firingM', 'binned firing rate during sleep1 Epoch');

A = registerResource(A, 'ExcludedCells', 'numeric', {1,1}, ...
    'excludedCells', 'binned firing rate during sleep1 Epoch');

cellsIx = find(goodCells);
nbCells = length(cellsIx);
excludedCells = [];



S1Epoch = sleep1Epoch{1};
S2Epoch = sleep2Epoch{1};
MEpoch = mazeEpoch{1}; 

st = Start(S1Epoch);
sp = Stop(S1Epoch);
S1bin = regular_interval(st(1),sp(1),binSize);
for i=2:length(st)
	S1bin = cat(S1bin,regular_interval(st(i),sp(i),binSize));
end

st = Start(S2Epoch);
sp = Stop(S2Epoch);
S2bin = regular_interval(st(1),sp(1),binSize);
for i=2:length(st)
	S2bin = cat(S2bin,regular_interval(st(i),sp(i),binSize));
end

Mbin = regular_interval(Start(MEpoch),Stop(MEpoch),binSize);

if nonZero
	
	for ix=1:nbCells
	
		Mmax = max(Data(intervalRate(S{cellsIx(ix)},Mbin)));
		S1max = max(Data(intervalRate(S{cellsIx(ix)},S1bin)));
		S2max = max(Data(intervalRate(S{cellsIx(ix)},S2bin)));
	
		if (Mmax == 0) || (S1max == 0) || (S2max == 0) || (goodCells(i) == 0)
			excludedCells = [i excludedCells];
		end;
		
	end

end

nbCells = nbCells - length(excludedCells)

st = Start(S1Epoch);
sp = Stop(S1Epoch);
S1bin = regular_interval(st(1),sp(1),1000);
for i=2:length(st)
	S1bin = cat(S1bin,regular_interval(st(i),sp(i),1000));
end

st = Start(S2Epoch);
sp = Stop(S2Epoch);
S2bin = regular_interval(st(1),sp(1),1000);
for i=2:length(st)
	S2bin = cat(S2bin,regular_interval(st(i),sp(i),1000));
end

Mbin = regular_interval(Start(MEpoch),Stop(MEpoch),1000);

firingS1 = zeros(length(Start(S1bin)),nbCells);
firingS2 = zeros(length(Start(S2bin)),nbCells);
firingM = zeros(length(Start(Mbin)),nbCells);

nbExcluded = 0;

for ix=1:nbCells %we take all th cells...

	if ~ length(excludedCells(excludedCells == i))  %...but remove the excluded ones

		firingS1(:,i - nbExcluded) = Data(intervalRate(S{cellsIx(ix)},S1bin));
		firingS2(:,i - nbExcluded) = Data(intervalRate(S{cellsIx(ix)},S2bin));
		firingM(:,i - nbExcluded) = Data(intervalRate(S{cellsIx(ix)},Mbin));
	
		if shuffle
			
			rndPermVect = randperm(length(PairCovObject.firingS1(:,i - nbExcluded)));
			firingS1(:,i - nbExcluded) = firingS1(rndPermVect,i - nbExcluded);

			rndPermVect = randperm(length(PairCovObject.firingS2(:,i - nbExcluded)));
			firingS2(:,i - nbExcluded) = PairCovObject.firingS2(rndPermVect,i - nbExcluded);
			
			rndPermVect = randperm(length(firingM(:,i - nbExcluded)));
			firingM(:,i - nbExcluded) = firingM(rndPermVect,i - nbExcluded);

		end


	else 
		nbExcluded = nbExcluded + 1;		
	end

end

firingS1 = {firingS1};
firingS2 = {firingS2};
firingM = {firingM};
excludedCells = {excludedCells};

A = saveAllResources(A);