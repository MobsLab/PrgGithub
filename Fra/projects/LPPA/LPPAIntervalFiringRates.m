function A = LPPAIntervalFiringRates(A)


A = getResource(A, 'CellNames');
A = getResource(A, 'SpikeData');

A= getResource(A, 'TrialOutcome');
trialOutcome = trialOutcome{1};

A = getResource(A, 'StartTrial');
startTrial = startTrial{1};

nbTrials = length(startTrial);
nbCells = length(S);

 A = registerResource(A, 'PreStartRate', 'cell', {'CellNames', 1}, ...
		       'preStartRate', ...
		       ['spike rates in the 2.5 s before start trial']);
 preStartRate  = cell(length(S), 1);

 A = registerResource(A, 'EarlyTrialRate', 'cell', {'CellNames', 1}, ...
		       'earlyTrialRate', ...
		       ['spike rates in the 2.5 s after start trial']);
earlyTrialRate = cell(length(S), 1);
  
 A = registerResource(A, 'LateTrialRate', 'cell', {'CellNames', 1}, ...
		       'lateTrialRate', ...
		       ['spike rates in the 2.5 s after start trial']);
lateTrialRate = cell(length(S), 1);


 A = registerResource(A, 'VectorPreStartRate', 'cell', {1, 1}, ...
		       'vectorPreStartRate', ...
		       ['spike rates in the 2.5 s before start trial']);
 vectorPreStartRate  = zeros(nbCells, nbTrials);

 A = registerResource(A, 'VectorEarlyTrialRate', 'cell', {1, 1}, ...
		       'vectorEarlyTrialRate', ...
		       ['spike rates in the 2.5 s after start trial']);
vectorEarlyTrialRate = zeros(nbCells, nbTrials);
  
 A = registerResource(A, 'VectorLateTrialRate', 'cell', {1, 1}, ...
		       'vectorLateTrialRate', ...
		       ['spike rates in the 2.5 s after start trial']);
vectorLateTrialRate = zeros(nbCells, nbTrials);




  % computing

 preStartInterval = intervalSet(Range(startTrial) - 25000, Range(startTrial) );
 earlyTrialInterval = intervalSet(Range(startTrial), Range(startTrial) +  min(25000, Range(trialOutcome) - Range(startTrial)) );
 lateTrialInterval = intervalSet(Range(trialOutcome) - 25000, Range(trialOutcome)) ;
 
 
  for i = 1:length(S)
     

%Pour les ANOVA	
      preStartRate{i} = intervalRate(S{i}, preStartInterval);
      earlyTrialRate{i} = intervalRate(S{i}, earlyTrialInterval);
      lateTrialRate{i} = intervalRate(S{i}, lateTrialInterval);


%Pour les vecteurs de pop
      vectorPreStartRate(i,:) = (Data(intervalRate(S{i}, preStartInterval)))';
      vectorEarlyTrialRate(i,:) = (Data(intervalRate(S{i}, earlyTrialInterval)))';
      vectorLateTrialRate(i,:) = (Data(intervalRate(S{i}, lateTrialInterval)))';
        
  end


vectorPreStartRate = {vectorPreStartRate};
vectorEarlyTrialRate = {vectorEarlyTrialRate};
vectorLateTrialRate = {vectorLateTrialRate};


  %%% this is the end
  A = saveAllResources(A);
