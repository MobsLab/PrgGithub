function A = contrastVectors(A)

%  trnsform pValMat and contMat of each cells into column vectors for each day
%  Display Raster Plots of significantly conditions modulated cells

showDetails = 0;

dset = current_dataset(A);

A = getResource(A,'RatesContraste',dset);
A = getResource(A,'CellNames',dset);

A = registerResource(A, 'ContCE', 'cell', {4, 1}, ...
    'contCE','contrast for the Correct/Error condition');
A = registerResource(A, 'ContLR', 'cell', {4, 1}, ...
    'contLR','contrast for the Go Left/Go Right condition');
A = registerResource(A, 'ContLPos', 'cell', {4, 1}, ...
    'contLPos','contrast for the Light on Left/Light on Right condition');
A = registerResource(A, 'ContLD', 'cell', {4, 1}, ...
    'contLD','contrast for the Go Light/Go Dark condition');

A = registerResource(A, 'PValCE', 'cell', {4, 1}, ...
    'pValCE','contrast for the Correct/Error condition');
A = registerResource(A, 'PValLR', 'cell', {4, 1}, ...
    'pValLR','contrast for the Go Left/Go Right condition');
A = registerResource(A, 'PValLPos', 'cell', {4, 1}, ...
    'pValLPos','contrast for the Light on Left/Light on Right condition');
A = registerResource(A, 'PValLD', 'cell', {4, 1}, ...
    'pValLD','contrast for the Go Light/Go Dark condition');

nbRules = size(ratesContraste,1);

%we define one empty vector for each task, not regarding day current task.

contCE = cell(4,1);
contLR = cell(4,1);
contLPos = cell(4,1);
contLD = cell(4,1);
pValCE = cell(4,1);
pValLR = cell(4,1);
pValLPos = cell(4,1);
pValLD = cell(4,1);

for i=1:4

	contCE{i} = [];
	contLR{i} = [];
	contLPos{i} = [];
	contLD{i} = [];
	pValCE{i} = [];
	pValLR{i} = [];
	pValLPos{i} = [];
	pValLD{i} = [];

end


for i=1:nbRules
	
	rules = ratesContraste{i,1};
	pValArray = ratesContraste{i,2};
	contArray = ratesContraste{i,3};
	
	nbCells = length(pValArray);
	
	for j=1:nbCells

		contCE{rules} = [contCE{rules} ; contArray{j}(:,1)];
		contLR{rules} = [contLR{rules} ; contArray{j}(:,2)];
		contLPos{rules} = [contLPos{rules} ; contArray{j}(:,3)];
		contLD{rules} = [contLD{rules} ; contArray{j}(:,4)];
	
		pValCE{rules} = [pValCE{rules} ; pValArray{j}(:,1)];
		pValLR{rules} = [pValLR{rules} ; pValArray{j}(:,2)];
		pValLPos{rules} = [pValLPos{rules} ; pValArray{j}(:,3)];
		pValLD{rules} = [pValLD{rules} ; pValArray{j}(:,4)]; 

	end
	

end

A = saveAllResources(A);