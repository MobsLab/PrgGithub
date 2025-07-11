function A = ratesContrast(A)

% copuute the preference index of cells for 4 stages:
%  pretrial (3s) - early_trial (1st half of trial) - last_trial (2nd half) - post trialoutcome (3s)
%  Register a cell array ratesContraste:
%  ratesContraste{cellNb}{1}:p-values mat ; --{2}:contraste index mat. Mat = (epochs x conditions)


dset = current_dataset(A);

A = getResource(A,'SpikeData',dset);

A = getResource(A,'StartTrial',dset);
startTrial = startTrial{1};

A = getResource(A,'TrialOutcome',dset);
trialOutcome = trialOutcome{1};

A = getResource(A,'CorrectError',dset);
correctError = correctError{1};

A = getResource(A,'LightRecord',dset);
lightRecord = lightRecord{1};

A = getResource(A,'TrialRules',dset);
trialRules = Data(trialRules{1});

A = getResource(A,'GoodCells',dset);
goodCells = goodCells{1};

A = registerResource(A, 'RatesContraste', 'cell', {[], 3}, ...
    'ratesContraste', ...
    'contraste{rules number,2}:array of p-values mat ; --,3}:array of contraste index mat. Mat = (epochs x conditions)');




%if any shift, we have to separate the trials between the different strategies
rules = unique(trialRules);
nbRules = length(rules)

%this array contains for each rules in the order of columns:
% 1 - the rules nb (see trialRules definition for more info)
% 2 - array of pVal mat (each element are for one cell)
% 3 - the same for contrast mat.

ratesContraste = cell(nbRules,3);

nbE = 4; % #epochs
nbC = 4; % #conditions

st = Range(startTrial);
to = Range(trialOutcome);
ce = Data(correctError);
side = Data(trialOutcome);
light = Data(lightRecord);

cellsIx = find(goodCells);
nbCells = length(cellsIx);

for i=1:nbRules
	
	stRules = st(trialRules == rules(i));
	toRules = to(trialRules == rules(i));

	preTrialEpoch = intervalSet(stRules - 3000,stRules);
	earlyTrialEpoch = intervalSet(stRules,(toRules+stRules)/2);
	lateTrialEpoch = intervalSet((toRules+stRules)/2,toRules);
	postOutcomeEpoch = intervalSet(toRules,toRules+3000);
	
	
	Condition = cell(nbC,1);
	% Diff in activity for the correct/error condition
	Condition{1} = ce(trialRules == rules(i)); 
	% for the "rat went left"/"rt went right" cond
	Condition{2} = side(trialRules == rules(i)); 
	% for the "light was on the right"/"light on the left" cond
	Condition{3} = light(trialRules == rules(i)); 
	% for the "rat went to lit arm/rat went to the dark arm" cond
	Condition{4} = ~xor(side(trialRules == rules(i)),light(trialRules == rules(i))); 
	
	rates = cell(nbE,1);
	ratesContraste{i,2} = cell(nbCells,1);
	ratesContraste{i,3} = cell(nbCells,1);

	for ix=1:nbCells
	
		pValMat = ones(nbE,nbC);
		contMat = zeros(nbE,nbC);
	
		rates{1} = Data(intervalRate(S{cellsIx(ix)},preTrialEpoch));
		rates{2} = Data(intervalRate(S{cellsIx(ix)},earlyTrialEpoch));
		rates{3} = Data(intervalRate(S{cellsIx(ix)},lateTrialEpoch));
		rates{4} = Data(intervalRate(S{cellsIx(ix)},postOutcomeEpoch));
	
		for e=1:nbE
			for c=1:nbC
				grp1 = rates{e}(Condition{c} == 1);
				grp2 = rates{e}(Condition{c} == 0);
				if (length(grp1)>1 && length(grp2)>1)
		
					[dummy1 p dummy2] = ttest2(grp1,grp2);
					pValMat(e,c) = p;
					if length(grp1)>0
						mGrp1 = mean(grp1);
					else
						mGrp1 = 0;
					end;
					if length(grp2)>0
						mGrp2 = mean(grp2);
					else
						mGrp2 = 0;
					end;
					if (mGrp1 || mGrp2) contMat(e,c) = (mGrp1-mGrp2)/(mGrp1+mGrp2);end;
				end;
			end
		end

		ratesContraste{i,1} = rules(i);
		ratesContraste{i,2}{ix} = pValMat;
		ratesContraste{i,3}{ix} = contMat;
		
	end;

end;

A = saveAllResources(A);