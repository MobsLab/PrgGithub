function ep = LoadEpochFromDatSeg(ix)

datSegments = load('DatSegments.txt');
datSegments = 10000*datSegments/1250;
datSegments = intervalSet([0;cumsum(datSegments(1:end-1))]',[cumsum(datSegments)-1]);    

ep = subset(datSegments,ix);