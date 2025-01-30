function infoDist = FindInfoAssembly(S,Epoch)

nbCells = length(S);

binSpk = [];
Hsingle = zeros(nbCells,1);
infoDist = zeros(nbCells);

for i=1:nbCells

	binSpk = [binSpk binnedFiringRate(S{i},Epoch,100,0)];
%  	Hsingle(i) = singleEntropy(binSpk(:,i));

end
%  
%  Hjoint = jointEntropy(binSpk);
%  infoDist = crutchfield(Hsingle,Hjoint);

%  map = relaxation(infoDist);



