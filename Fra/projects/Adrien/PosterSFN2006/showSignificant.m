function A = contrastVectors(A)

%  Display Raster Plots of significantly conditions modulated cells

showDetails = 0;


A = getResource(A,'RatesContraste',datasets{dset})
A = getResource(A,'CellNames',datasets{dset})

A = registerResource(A, 'ContCE', 'numeric', {1, 1}, ...
    'contCE','contrast for the Correct/Error condition');
A = registerResource(A, 'ContLR', 'numeric', {1, 1}, ...
    'contLR','contrast for the Go Left/Go Right condition');
A = registerResource(A, 'ContLPos', 'numeric', {1, 1}, ...
    'contCE','contrast for the Light on Left/Light on Right condition');
A = registerResource(A, 'ContLD', 'numeric', {1, 1}, ...
    'contCE','contrast for the Go Light/Go Dark condition');

A = registerResource(A, 'PValCE', 'numeric', {1, 1}, ...
    'PValCE','contrast for the Correct/Error condition');
A = registerResource(A, 'PValLR', 'numeric', {1, 1}, ...
    'PValLR','contrast for the Go Left/Go Right condition');
A = registerResource(A, 'PValLPos', 'numeric', {1, 1}, ...
    'PValCE','contrast for the Light on Left/Light on Right condition');
A = registerResource(A, 'PValLD', 'numeric', {1, 1}, ...
    'PValCE','contrast for the Go Light/Go Dark condition');



if showdetails
	condition = cell(3,1);
	condition{1} = 'Correct/Error'; % 0 for right, 1 for left
	condition{2} = 'Right/Left';
	condition{3} = 'Light left/Light right';
	condition{4} = 'Go Light/Go Dark';	

	epoch = cell(4,1);
	epoch{1} = 'preTrialEpoch';
	epoch{2} = 'earlyTrialEpoch';
	epoch{3} = 'lateTrialEpoch';
	epoch{4} = 'postOutcomeEpoch';
end

nbCells = length(ratesContraste);
contCE = [];
contLR = [];
contLPos = [];
contLD = [];
pValCE = [];
pValLR = [];
pValLPos = [];
pValLD = [];


for i=1:nbCells

	pValMat = ratesContraste{i}{1};
	contMat = ratesContraste{i}{2};

	contCE = [contCE;contMat(:,1)];
	contLR = [contCE;contMat(:,2)];
	contLPos = [contCE;contMat(:,3)];
	contLD = [contCE;contMat(:,3)];

	pValCE = [pValCE;pValMat(:,1)];
	pValLR = [pValRL;pValMat(:,2)];
	pValLPos = [pValLD;pValMat(:,3)];
	pValLD = [pValLD;pValMat(:,4)]; 

	if showDetails
	
		ix = find(pValMat < 0.05); %returns a vector of indices!
		ix(ix == 0) = [];
		
		if length(ix)
				
			%finding matrix elements from vector of indices
			c = floor((ix-1)/4)+1;
			e = mod(ix,4);
			e(e == 0) = 4;
			fprintf(['Cells : ' num2str(cellnames{i}) ' has the following significant contrast:\n']);
	
			for j=1:length(ix)
				cond = condition{c(j)};
				epoc = epoch{e(j)};
				cont = contMat(e(j),c(j));
				p = pValMat(e(j),c(j));
				fprintf(['      ' cond ' on interval ' epoc ' with a contrast of ' num2str(cont) ' (p = ' num2str(p) ')\n']);
			end
	
			pause(5)
		
		end

	end

end


A = saveAllResources(A);