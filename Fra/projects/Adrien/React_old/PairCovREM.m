function remPairCov = PairCovSPW(expSet)

load(['~/Data/LPPA/Rat' expSet 'AdrienData.mat']);
load(['~/Data/LPPA/Rat' expSet 'AdrienData2.mat']);

%Parameters
Fs = 2083;
nbCells = length(S);

%Ripples event finding

S1Epoch = diff(rem1Epoch,GetRipplesInterval(EEGhc,rem1Epoch));
S1Epoch = regular_interval(Start(S1Epoch),Stop(S1Epoch),1000);
S2Epoch = diff(rem2Epoch,GetRipplesInterval(EEGhc,rem2Epoch));
S2Epoch = regular_interval(Start(S2Epoch),Stop(S2Epoch),1000);
MEpoch = intervalSet(Start(mazeEpoch),Stop(mazeEpoch));
MEpoch = regular_interval(Start(MEpoch),Stop(MEpoch),1000);

remPairCov.firingS1 = zeros(length(Start(regular_interval(Start(S1Epoch),Stop(S1Epoch),1000))),nbCells);
remPairCov.firingS2 = zeros(length(Start(regular_interval(Start(S2Epoch),Stop(S2Epoch),1000))),nbCells);
remPairCov.firingM = zeros(length(Start(regular_interval(Start(MEpoch),Stop(MEpoch),1000))),nbCells);


for i=1:nbCells

	remPairCov.firingS1(:,i) = Data(intervalRate(S{i},regular_interval(Start(S1Epoch),Stop(S1Epoch),1000)));
	remPairCov.firingS2(:,i) = Data(intervalRate(S{i},regular_interval(Start(S2Epoch),Stop(S2Epoch),1000)));
	remPairCov.firingM(:,i) = Data(intervalRate(S{i},regular_interval(Start(MEpoch),Stop(MEpoch),1000)));

end

CS1 = corrcoef(remPairCov.firingS1);
CS2 = corrcoef(remPairCov.firingS2);
CM = corrcoef(remPairCov.firingM);

remPairCov.CS1Vect = zeros(nbCells*(nbCells-1)/2,1);
remPairCov.CS2Vect = zeros(nbCells*(nbCells-1)/2,1);
remPairCov.CMVect = zeros(nbCells*(nbCells-1)/2,1);

for i=1:nbCells

	for j=i+1:nbCells

		remPairCov.CS1Vect((i-1)*(nbCells-i)+(j-1)) = CS1(i,j);
		remPairCov.CS2Vect((i-1)*(nbCells-i)+(j-1)) = CS2(i,j);
		remPairCov.CMVect((i-1)*(nbCells-i)+(j-1)) = CM(i,j);

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

CMS1 = corrcoef(remPairCov.CMVect,remPairCov.CS1Vect);
CMS2 = corrcoef(remPairCov.CMVect,remPairCov.CS2Vect);
CS2S1 = corrcoef(CS2Vect,CS1Vect);
remPairCov.rMS1 = CMS1(1,2);
remPairCov.rMS2 = CMS2(1,2);
remPairCov.rS2S1 = CS2S1(1,2);

% ...or linear regression to have the slope of the distribution
remPairCov.pMS1 = polyfit(remPairCov.CMVect,remPairCov.CS1Vect,1)
remPairCov.pMS2 = polyfit(remPairCov.CMVect,remPairCov.CS2Vect,1)
remPairCov.pS2S1 = polyfit(remPairCov.CS2Vect,remPairCov.CS1Vect,1)

remPairCov.EV = ((remPairCov.rMS2-remPairCov.rMS1*remPairCov.rS2S1)/sqrt((1-remPairCov.rMS1^2)*(1-remPairCov.rS2S1^2)))^2;
