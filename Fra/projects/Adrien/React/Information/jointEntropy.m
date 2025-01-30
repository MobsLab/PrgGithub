function jointEntropy = jointEntropy(XY)

nbCells = size(XY,2);
jointEntropy = ones(nbCells);
nbSamples = size(XY,1);

for i=1:nbCells

	for j=i+1:nbCells
		

		p11 = 0;
		p10 = 0;
		p01 = 0;
		p00 = 0;
		X = XY(:,i);
		Y = XY(:,j);
		normFact = length(X);		
		
		p11 = length(find(X.*Y))/normFact;
		P10 = length(find((X == 1).*(Y == 0)))/normFact;
		P01 = length(find((X == 0).*(Y == 1)))/normFact;
		P00 = length(find((X == 0).*(Y == 0)))/normFact;
		jointEntropy(i,j) = -plog(p11) - plog(p10) - plog(p01) - plog(p00);
		jointEntropy(j,i) = jointEntropy(i,j);
		

	end

end

function y = plog(x)

if x==0
	y = 0;
else
	y = x*log2(x);
end;	

