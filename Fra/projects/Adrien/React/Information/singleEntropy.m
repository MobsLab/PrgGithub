function singleEntropy = singleEntropy(X)

p1 = length(find(X == 1))/length(X);

singleEntropy = -plog(p1) - plog(1-p1);

function y = plog(x)

if x==0
	y = 0;
else
	y = x*log2(x);
end;	
