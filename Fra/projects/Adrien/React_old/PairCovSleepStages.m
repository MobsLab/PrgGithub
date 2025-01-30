function PairCovResult = PairCov(expSet)

load(['~/Data/LPPA/Rat' expSet 'AdrienData.mat']);
load(['~/Data/LPPA/Rat' expSet 'AdrienData2.mat']);

PairCovResult = {3};
nbCells = length(S)
covTime = 10000 * 60 * 30;
excludedCells = [];

%3 stages : whole sleep/sws/rem

S1Epoch = {3};
S2Epoch = {3};
MEpoch = {3};


%Whole sleep

S1Epoch{1} = sleep1Epoch;
S2Epoch{1} = sleep2Epoch;
MEpoch{1} = mazeEpoch; 

%spw epochs

spwEpoch1 = GetRipplesInterval(EEGhc,sleep1Epoch);
spwEpoch2 = GetRipplesInterval(EEGhc,sleep2Epoch);

%sws

S1Epoch{2} = spwEpoch1;
S2Epoch{2} = spwEpoch2;
MEpoch{2} = mazeEpoch;

%rem

S1Epoch{3} = diff(sleep1Epoch,spwEpoch1);
S2Epoch{3} = diff(sleep2Epoch,spwEpoch2);
MEpoch{3} = mazeEpoch;

for stages=1:3	
	
	st = Start(S1Epoch{stages});
	sp = Stop(S1Epoch{stages});
	S1bin = regular_interval(st(1),sp(1),1000);
	for i=2:length(st)
		S1bin = cat(S1bin,regular_interval(st(i),sp(i),1000));
	end
	
	st = Start(S2Epoch{stages});
	sp = Stop(S2Epoch{stages});
	S2bin = regular_interval(st(1),sp(1),1000);
	for i=2:length(st)
		S2bin = cat(S2bin,regular_interval(st(i),sp(i),1000));
	end

	Mbin = regular_interval(Start(MEpoch{stages}),Stop(MEpoch{stages}),1000);

	for i=1:nbCells
	
		if length(find(excludedCells == i)) == 0
	
			if (max(Data(intervalRate(S{i},S1bin))) == 0)
				excludedCells = [i excludedCells];
			end
			if  max(Data(intervalRate(S{i},S2bin))) == 0
				excludedCells = [i excludedCells];		
			end
			if max(Data(intervalRate(S{i},Mbin))) == 0
				excludedCells = [i excludedCells];
			end

		end
		
	end

end

nbCells = nbCells - length(excludedCells)
PairCovObject.nbCells = nbCells;
PairCovObject.nbExcluded = length(excludedCells);

for stages=1:3	
	
	st = Start(S1Epoch{stages});
	sp = Stop(S1Epoch{stages});
	S1bin = regular_interval(st(1),sp(1),1000);
	for i=2:length(st)
		S1bin = cat(S1bin,regular_interval(st(i),sp(i),1000));
	end
	
	st = Start(S2Epoch{stages});
	sp = Stop(S2Epoch{stages});
	S2bin = regular_interval(st(1),sp(1),1000);
	for i=2:length(st)
		S2bin = cat(S2bin,regular_interval(st(i),sp(i),1000));
	end

	Mbin = regular_interval(Start(MEpoch{stages}),Stop(MEpoch{stages}),1000);

	PairCovObject.firingS1 = zeros(length(Start(S1bin)),nbCells);
	PairCovObject.firingS2 = zeros(length(Start(S2bin)),nbCells);
	PairCovObject.firingM = zeros(length(Start(Mbin)),nbCells);

	nbExcluded = 0;

	for i=1:length(S) %we take all th cells...
	
		if length(find(excludedCells == i)) == 0  %...but remove the excluded ones

			PairCovObject.firingS1(:,i - nbExcluded) = Data(intervalRate(S{i},S1bin));
			PairCovObject.firingS2(:,i - nbExcluded) = Data(intervalRate(S{i},S2bin));
			PairCovObject.firingM(:,i - nbExcluded) = Data(intervalRate(S{i},Mbin));
		else 
			nbExcluded = nbExcluded + 1;		
		end

	end
	
	CS1 = corrcoef(PairCovObject.firingS1);
	CS2 = corrcoef(PairCovObject.firingS2);
	CM = corrcoef(PairCovObject.firingM);
	
	PairCovObject.CS1Vect = zeros(nbCells*(nbCells-1)/2,1);
	PairCovObject.CS2Vect = zeros(nbCells*(nbCells-1)/2,1);
	PairCovObject.CMVect = zeros(nbCells*(nbCells-1)/2,1);
	
	ix = 1;

	for i=1:nbCells
	
		for j=i+1:nbCells
	
			PairCovObject.CS1Vect(ix) = CS1(i,j);
			PairCovObject.CS2Vect(ix) = CS2(i,j);
			PairCovObject.CMVect(ix) = CM(i,j);
			ix = ix + 1;

		end
	
	end
	%  
	%  figure(1),clf
	%  scatter(CS2Vect,CMVect)
	%  axis([-0.2 0.5 -0.2 0.5])
	%  figure(2),clf
	%  scatter(CMVect,CS1Vect)
	%  axis([-0.2 0.5 -0.2 0.5])
	%  figure(3),clf
	%  scatter(CS2Vect,CS1Vect)
	%  axis([-0.2 0.5 -0.2 0.5])
	%  
	
	%Corr Coef conputation...
	
	CMS1 = corrcoef(PairCovObject.CMVect,PairCovObject.CS1Vect);
	CMS2 = corrcoef(PairCovObject.CMVect,PairCovObject.CS2Vect);
	CS2S1 = corrcoef(PairCovObject.CS2Vect,PairCovObject.CS1Vect);
	PairCovObject.rMS1 = CMS1(1,2);
	PairCovObject.rMS2 = CMS2(1,2);
	PairCovObject.rS2S1 = CS2S1(1,2);
	
	% ...or linear regression to have the slope of the distribution
	PairCovObject.pMS1 = polyfit(PairCovObject.CMVect,PairCovObject.CS1Vect,1);
	PairCovObject.pMS2 = polyfit(PairCovObject.CMVect,PairCovObject.CS2Vect,1);
	PairCovObject.pS2S1 = polyfit(PairCovObject.CS2Vect,PairCovObject.CS1Vect,1);
	
	PairCovObject.EV = ((PairCovObject.rMS2-PairCovObject.rMS1*PairCovObject.rS2S1)/sqrt((1-PairCovObject.rMS1^2)*(1-PairCovObject.rS2S1^2)))^2;

	PairCovObject
	PairCovResult{stages} = PairCovObject;

end