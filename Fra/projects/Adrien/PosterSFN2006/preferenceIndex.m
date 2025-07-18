%  function A = preferenceIndex(A)

% cumoute the preference index of cells for 3 stages:
%  pretrial (5s) - trial - post trialoutcome(5s)


dataDir = '/media/sdc6/Data';
cd(dataDir);
dset = 'Rat18/181014';

A = Analysis(pwd);

A = getResource(A,'SpikeData',dset);
nbCells = length(S);

A = getResource(A,'StartTrial',dset);
startTrial = startTrial{1};

A = getResource(A,'TrialOutcome',dset);
trialOutcome = trialOutcome{1};

A = getResource(A,'correctError',dset);
correctError = correctError{1};

A = getResource(A,'lightRecord',dset);
lightRecord = lightRecord{1};


preTrialEpoch = intervalSet(Range(startTrial) - 3000,Range(startTrial));
earlyTrialEpoch = intervalSet(Range(startTrial),(Range(trialOutcome)+Range(startTrial))/2);
lateTrialEpoch = intervalSet((Range(trialOutcome)+Range(startTrial))/2,Range(trialOutcome));
postOutcomeEpoch = intervalSet(Range(trialOutcome),Range(trialOutcome)+3000);

%  preTrialRate = zeros(nbCells,1);
%  trialRate = zeros(nbCells,1);
%  postOutcomeRate = zeros(nbCells,1);

rates = cell(4,1);
nbE = 4;

Condition = cell(3,1)
Condition{1} = Data(correctError); % 0 for right, 1 for left
Condition{2} = Data(trialOutcome);
Condition{3} = Data(lightRecord);
nbC = 3;

contraste = cell(nbCells,1);

for i=1:nbCells

	rates{1} = Data(intervalRate(S{i},preTrialEpoch));
	rates{2} = Data(intervalRate(S{i},earlyTrialEpoch));
	rates{3} = Data(intervalRate(S{i},lateTrialEpoch));
	rates{4} = Data(intervalRate(S{i},postOutcomeEpoch));

	for ix=1:nbE
		for c=1:nbC
			grp1 = rates{ix}(Condition{c} == 1);
			grp2 = rates{ix}(Condition{c} == 0);
			[h p c] = ttest2(grp1,grp2);
			pValMat(ix,c) = p;
			contMat(ix,c) = (mean(grp1)-mean(grp2))/(mean(grp1)+mean(grp2));
		end
	end

	Contraste{i}{1} = pValMat;
	Contraste{i}{2} = contMat;

end;

