function A = firingRates(A)

A = getResource(A,'SpikeData');

A = getResource(A,'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};
A = getResource(A,'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};
A = getResource(A,'MazeEpoch');
mazeEpoch = mazeEpoch{1};


