function A = globalSleepReactivation(A)


binSizeSleep = 1000;
binSizeMaze = 1000;

A = getResource(A,'SpikeData');

A = getResource(A,'CellNames');
A = getResource(A,'MazeEpoch');
mazeEpoch = mazeEpoch{1};
A = getResource(A,'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};
A = getResource(A,'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};

A = registerResource(A, 'scoreMS1PCA', 'numeric', {[],1}, ...
    'scoreMS1PCA', ...
    'PC (from maze epoch) score during sleep1');

A = registerResource(A, 'scoreMS2PCA', 'numeric', {[],1}, ...
    'scoreMS2PCA', ...
    'PC (from maze epoch) score during sleep2');

A = registerResource(A, 'CorrMS1', 'numeric', {[],1}, ...
    'corrMS1', ...
    'corrMS sleep1/maze similitude of covriance');

A = registerResource(A, 'CorrMS2', 'numeric', {[],1}, ...
    'corrMS2', ...
    'spwTrigCorrMS sleep2/maze correlation of PC');

A = registerResource(A, 'scoreMS1PCAnorm', 'numeric', {[],1}, ...
    'scoreMS1PCAnorm', ...
    'PC (from maze epoch) score during sleep1');

A = registerResource(A, 'scoreMS2PCAnorm', 'numeric', {[],1}, ...
    'scoreMS2PCAnorm', ...
    'PC (from maze epoch) score during sleep2');

A = registerResource(A, 'CorrMS1norm', 'numeric', {[],1}, ...
    'corrMS1norm', ...
    'corrMS sleep1/maze similitude of covriance');

A = registerResource(A, 'CorrMS2norm', 'numeric', {[],1}, ...
    'corrMS2norm', ...
    'spwTrigCorrMS sleep2/maze correlation of PC');

A = registerResource(A, 'CM', 'numeric', {[],1}, ...
    'cM', ...
    'z-Log correlation matrix of maze f rates w/ coef of cells from same TT = 0');



binSpk = MakeQfromS(S,binSizeSleep);
cM = spkLogcorrcoef(S,binSizeMaze,mazeEpoch,cellnames);


% PCA-like analysis on the 3 first components
[PCACoef, PCAvar, PCAexp] = pcacov(cM);
nbPC = size(PCACoef,1);

% Compute zscore of log firing rates during sleep1/2

zFiringS1 = Data(Restrict(binSpk,sleep1Epoch));
zFiringS1 = full(zscore(log(zFiringS1 + 10^-6)))';
zFiringS2 = Data(Restrict(binSpk,sleep2Epoch));
zFiringS2 = full(zscore(log(zFiringS2 + 10^-6)))';	

nbBins1 = size(zFiringS1,2);
nbBins2 = size(zFiringS2,2);

corrMS1 = zeros(nbBins1,1);
corrMS2 = zeros(nbBins2,1);
corrMS1norm = zeros(nbBins1,1);
corrMS2norm = zeros(nbBins2,1);


% Raw React 

for i = 1:nbBins1;

	popVect = zFiringS1(:,i);
	norm = (popVect'*popVect);
	corrMS1(i) = popVect'*(cM)*popVect;
	if (norm ~= 0) corrMS1norm(i) = popVect'*(cM)*popVect/norm;end;

end;

for i = 1:nbBins2;

	popVect = zFiringS2(:,i);
	norm = (popVect'*popVect);
	corrMS2(i) = popVect'*(cM)*popVect;
	if (norm ~= 0) corrMS2norm(i) = popVect'*(cM)*popVect/norm;end;

end;

% PCA react

normVect = sqrt(sum(zFiringS1.*zFiringS1));
scoreMS1PCA = PCACoef'*zFiringS1;
scoreMS1PCAnorm = PCACoef'*zFiringS1./(ones(nbPC,1)*normVect); %element by element division by norm of popVect
normVect = sqrt(sum(zFiringS2.*zFiringS2));
scoreMS2PCA = PCACoef'*zFiringS2; 
scoreMS2PCAnorm = PCACoef'*zFiringS2./(ones(nbPC,1)*normVect); 

corrMS1 = {tsd(Range(Restrict(binSpk,sleep1Epoch)),corrMS1)};
corrMS2 = {tsd(Range(Restrict(binSpk,sleep2Epoch)),corrMS2)};
corrMS1norm = {tsd(Range(Restrict(binSpk,sleep1Epoch)),corrMS1norm)};
corrMS2norm = {tsd(Range(Restrict(binSpk,sleep2Epoch)),corrMS2norm)};

scoreMS1PCA = {tsd(Range(Restrict(binSpk,sleep1Epoch)),scoreMS1PCA')};
scoreMS2PCA = {tsd(Range(Restrict(binSpk,sleep2Epoch)),scoreMS2PCA')};
scoreMS1PCAnorm = {tsd(Range(Restrict(binSpk,sleep1Epoch)),scoreMS1PCAnorm')};
scoreMS2PCAnorm = {tsd(Range(Restrict(binSpk,sleep2Epoch)),scoreMS2PCAnorm')};

cM = {cM};

A = saveAllResources(A);




