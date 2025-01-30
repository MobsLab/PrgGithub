function swsPairCov = PairCovSPW(expSet,minRipplesEpoch)

load(['~/Data/LPPA/Rat' expSet 'AdrienData.mat']);
load(['~/Data/LPPA/Rat' expSet 'AdrienData2.mat']);

%Parameters
Fs = 2083;
nbCells = length(S);

%Ripples event finding

S1Epoch = GetRipplesInterval(EEGhc,sleep1Epoch);
S1Epoch = regular_interval(Start(S1Epoch),Stop(S1Epoch),1000);
S2Epoch = GetRipplesInterval(EEGhc,sleep2Epoch);
S2Epoch = regular_interval(Start(S2Epoch),Stop(S2Epoch),1000);
MEpoch = intervalSet(Start(mazeEpoch),Stop(mazeEpoch));
MEpoch = regular_interval(Start(MEpoch),Stop(MEpoch),1000);

swsPairCov.firingS1 = zeros(length(Start(S1Epoch)),nbCells);
swsPairCov.firingS2 = zeros(length(Start(S2Epoch)),nbCells);
swsPairCov.firingM = zeros(length(Start(MEpoch)),nbCells);


for i=1:nbCells

	swsPairCov.firingS1(:,i) = Data(intervalRate(S{i},S1Epoch));
	swsPairCov.firingS2(:,i) = Data(intervalRate(S{i},S2Epoch));
	swsPairCov.firingM(:,i) = Data(intervalRate(S{i},MEpoch));

end

CS1 = corrcoef(swsPairCov.firingS1);
CS2 = corrcoef(swsPairCov.firingS2);
CM = corrcoef(swsPairCov.firingM);

swsPairCov.CS1vect = zeros(nbCells*(nbCells-1)/2,1);
swsPairCov.CS2vect = zeros(nbCells*(nbCells-1)/2,1);
swsPairCov.CMvect = zeros(nbCells*(nbCells-1)/2,1);

for i=1:nbCells

	for j=i+1:nbCells

		swsPairCov.CS1Vect((i-1)*(nbCells-i)+(j-1)) = CS1(i,j);
		swsPairCov.CS2Vect((i-1)*(nbCells-i)+(j-1)) = CS2(i,j);
		swsPairCov.CMVect((i-1)*(nbCells-i)+(j-1)) = CM(i,j);

	end

end

%  
%  figure(1),clf
%  scatter(CMVect,CS2Vect)
%  figure(2),clf
%  scatter(CMVect,CS1Vect)

%Corr Coef conputation...

CMS1 = corrcoef(swsPairCov.CMVect,swsPairCov.CS1Vect);
CMS2 = corrcoef(swsPairCov.CMVect,swsPairCov.CS2Vect);
CS2S1 = corrcoef(swsPairCov.CS2Vect,swsPairCov.CS1Vect);
swsPairCov.rMS1 = CMS1(1,2);
swsPairCov.rMS2 = CMS2(1,2);
swsPairCov.rS2S1 = CS2S1(1,2);

% ...or linear regression to have the slope of the distribution
swsPairCov.pMS1 = polyfit(swsPairCov.CMVect,swsPairCov.CS1Vect,1)
swsPairCov.pMS2 = polyfit(swsPairCov.CMVect,swsPairCov.CS2Vect,1)
swsPairCov.pS2S1 = polyfit(swsPairCov.CS2Vect,swsPairCov.CS1Vect,1)


swsPairCov.EV = ((swsPairCov.rMS2-swsPairCov.rMS1*swsPairCov.rS2S1)/sqrt((1-swsPairCov.rMS1^2)*(1-swsPairCov.rS2S1^2)))^2;
