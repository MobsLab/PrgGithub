function binnedFiringRate = binnedFiringRate(expSet,binSize,nonZero,shuffle)

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


load(['~/Data/LPPA/' expSet 'AdrienData.mat']);
load(['~/Data/LPPA/' expSet 'AdrienData2.mat']);

nbCells = length(S)
covTime = 10000 * 60 * 30;
excludedCells = [];
PairCovObject.dset = expSet

%Whole sleep

S1Epoch = sleep1Epoch;
S2Epoch = sleep2Epoch;
MEpoch = mazeEpoch; 

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
	
	for i=1:nbCells
	
		Mmax = max(Data(intervalRate(S{i},Mbin)));
		S1max = max(Data(intervalRate(S{i},S1bin)));
		S2max = max(Data(intervalRate(S{i},S2bin)));
	
		if (Mmax == 0) || (S1max == 0) || (S2max == 0)
			excludedCells = [i excludedCells]
		end;
		
	end

end

nbCells = nbCells - length(excludedCells)
PairCovObject.nbCells = nbCells;
PairCovObject.excludedCells = excludedCells;


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

PairCovObject.firingS1 = zeros(length(Start(S1bin)),nbCells);
PairCovObject.firingS2 = zeros(length(Start(S2bin)),nbCells);
PairCovObject.firingM = zeros(length(Start(Mbin)),nbCells);

nbExcluded = 0;

for i=1:length(S) %we take all th cells...

	if ~ length(excludedCells(excludedCells == i))  %...but remove the excluded ones

		PairCovObject.firingS1(:,i - nbExcluded) = Data(intervalRate(S{i},S1bin));
		PairCovObject.firingS2(:,i - nbExcluded) = Data(intervalRate(S{i},S2bin));
		PairCovObject.firingM(:,i - nbExcluded) = Data(intervalRate(S{i},Mbin));
	
		if shuffle
			
			rndPermVect = randperm(length(PairCovObject.firingS1(:,i - nbExcluded)));
			PairCovObject.firingS1(:,i - nbExcluded) = PairCovObject.firingS1(rndPermVect,i - nbExcluded);

			rndPermVect = randperm(length(PairCovObject.firingS2(:,i - nbExcluded)));
			PairCovObject.firingS2(:,i - nbExcluded) = PairCovObject.firingS2(rndPermVect,i - nbExcluded);
			
			rndPermVect = randperm(length(PairCovObject.firingM(:,i - nbExcluded)));
			PairCovObject.firingM(:,i - nbExcluded) = PairCovObject.firingM(rndPermVect,i - nbExcluded);

		end


	else 
		nbExcluded = nbExcluded + 1;		
	end

end

binnedFiringRate = PairCovObject;