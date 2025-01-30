dataDir = '/media/sdb6/Data';
cd(dataDir)

A = Analysis(pwd)

A = getResource(A,'Sleep1Epoch','Rat18/181014');
sleep1Epoch = sleep1Epoch{1};

A = getResource(A,'Sleep2Epoch','Rat18/181014');
sleep2Epoch = sleep2Epoch{1};


A = getResource(A,'MazeEpoch','Rat18/181014');
mazeEpoch = mazeEpoch{1};

A = getResource(A,'SpikeData','Rat18/181014');
nbCells = length(S);


distM = FindInfoAssembly(S,mazeEpoch);
distM = distM - diag(diag(distM));
distS = zeros(nbCells);
sleepEpoch = {sleep1Epoch;sleep2Epoch};


distSM = {[];[]};

for sleepIx=1:2

	binEpoch = regular_interval(Start(sleepEpoch{sleepIx}),Stop(sleepEpoch{sleepIx}),10000);
	time = length(Start(binEpoch))
	for t=1:length(Start(binEpoch))
		
		display(t)
		distS = FindInfoAssembly(S,subset(binEpoch,t));
		distS = distS - diag(diag(distS));
		distSM{sleepIx} = [distSM{sleepIx} sum(sum(sqrt(distS.^2+distM.^2)))];

	end

end


figure(1),clf
hold on
imagesc(log(Data(sleep1Specgram{6})'))
plot([1:length(distSM{1})],distsM{1},'Color','r')
hold off


figure(2),clf
hold on
imagesc(log(Data(sleep2Specgram{6})'))
plot([1:length(distSM{2})],distsM{2},'Color','r')
hold off