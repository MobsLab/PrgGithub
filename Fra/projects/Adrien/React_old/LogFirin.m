 

nbCells = length(S);

sleep1aEpoch = intervalSet(Start(sleep1Epoch),Stop(sleep1Epoch)/2);
sleep1bEpoch = intervalSet(Stop(sleep1Epoch)/2,Stop(sleep1Epoch));

XMS1 = zeros(nbCells,1);
XMS2 = zeros(nbCells,1);
XM = zeros(nbCells,1);
XMS1 = zeros(nbCells,1);
XMS2 = zeros(nbCells,1);
XS2S1 = zeros(nbCells,1);
XS1S2 = zeros(nbCells,1);

for i=1:length(S)

	XS1(i) = log(Data(intervalRate(S{i},sleep1Epoch)));
	XS2(i) = log(Data(intervalRate(S{i},sleep2Epoch)));
	XM(i) = log(Data(intervalRate(S{i},mazeEpoch)));
	XS2S1(i) = log(Data(intervalRate(S{i},sleep2Epoch))/Data(intervalRate(S{i},sleep1aEpoch))); 
	XS1S2(i) = log(Data(intervalRate(S{i},sleep1aEpoch))/Data(intervalRate(S{i},sleep2Epoch))); 
	XMS1(i)  = log(Data(intervalRate(S{i},mazeEpoch))/Data(intervalRate(S{i},sleep1bEpoch)));
	XMS2(i)  = log(Data(intervalRate(S{i},mazeEpoch))/Data(intervalRate(S{i},sleep2Epoch)));


end


figure(1)
scatter(XMS1,XS2S1)
title('XS2S1 % XMS1')
figure(2)
scatter(XMS2,XS1S2)
title('XMS2 % XS1S2')
figure(3)
scatter(XS2,XM)
title('XS2 % XM')

figure(4)
hist(XM,10)
title('Histogram log firing rates')

corrcoef(XMS1,XS2S1)


