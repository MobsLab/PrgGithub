function AO = AmyphysParseTrials(A)

  
  A = getResource(A, 'BehaviorFlags');
  behavFlags = behavFlags{1};
  
  A = registerResource(A, 'BaselinePeriod', 'cell', {1,1}, ...
		       'baselinePeriod', ...
		       ['intervalSet of the inter-trial intervals', ...
		    'to consider for baseline calculations']);

  A = registerResource(A, 'TrialPeriod', 'cell', {1,1}, ...
		       'trialPeriod', ...
		       ['intervalSet of the trial intervals']);
  
  
  A = registerResource(A, 'TrialOutcome', 'tsdArray', {1, 1}, ...
		       'trialOutcome', ...
		       ['trial type: 1 is successful  (rewarded)', ...
		    '2 is successful (unrewarded)', ...
		    '3 is image delivered', ...
		    '4 is fixation interrupted', ...
		    '5 is fixation not achieved']);
  
  
  A = registerResource(A, 'FixSpotOn', 'tsdArray', {1, 1}, ...
		       'fixSpotOn', ...
		       ['For each trial, the times at which fixation spot', ...
		    'appeared, NaN, if fixation spot was not delivered']);
  
  A = registerResource(A, 'FixationStart', 'tsdArray', {1,1}, ...
		       'fixationStart', ...
		       ['Start of monkey fixation, NaN if no fixation']);
  
  A = registerResource(A, 'FixSpotOff', 'tsdArray', {1, 1}, ...
		       'fixSpotOff', ...
		       ['End of fixation spot']);
  
  A = registerResource(A, 'ImageOn', 'tsdArray', {1, 1}, ...
		       'imageOn', ...
		       ['Start of the image, NaN if no image']);
  
  A = registerResource(A, 'ImageOff', 'tsdArray', {1, 1}, ...
		       'imageOff',...
		       ['End of the image, NaN if no image']);
  
  A = registerResource(A, 'Reward', 'tsdArray', {1, 1}, ...
		       'reward',...
		       ['RewardTime, NaN if no image']);
  
  
  load([parent_dir(A) filesep 'AmyphysLookupTables']);
  
  baselineStart = Range(find(behavFlags, ...
	['Td == ' num2str(BehaviorLookup{'EndPostTrial'})])) +1000;
  
  baselineEnd = Range(find(behavFlags, ...
	['Td == ' num2str(BehaviorLookup{'FixSpotOn'})]));
  
  baselinePeriod = intervalSet(baselineStart, baselineEnd, '-fixit');
  
  
  trialStart = find(behavFlags, ...
 	['Td == ' num2str(BehaviorLookup{'StartITI'})]);
  trialStart = Range(Restrict(trialStart, baselineEnd, 'align', 'prev'));
  
  trialEnd = find(behavFlags, ...
	['Td == ' num2str(BehaviorLookup{'EndPostTrial'})]);

  trialEnd = Range(Restrict(trialEnd, trialStart, 'align', 'next'));
  trialPeriod = intervalSet(trialStart, trialEnd, '-fixit');
  
  flagsPerTrial = intervalSplit(behavFlags, trialPeriod);
  trialStart = Start(trialPeriod);
  
  fixSpotOn = zeros(length(flagsPerTrial), 1);
  fixationStart = zeros(length(flagsPerTrial), 1);
  fixSpotOff = zeros(length(flagsPerTrial), 1);
  imageOn = zeros(length(flagsPerTrial), 1);
  imageOff = zeros(length(flagsPerTrial), 1);
  reward = zeros(length(flagsPerTrial), 1);
  trialOutcome = zeros(length(flagsPerTrial), 1);
  
  for i = 1:length(flagsPerTrial)
    f = Range(find(flagsPerTrial{i}, ...
	['Td == ' num2str(BehaviorLookup{'FixSpotOn'})]));
    if ~isempty(f)
      fixSpotOn(i) = f(1);
    else
      fixSpotOn(i) = NaN;
    end
    
    f = Range(find(flagsPerTrial{i}, ...
	['Td == ' num2str(BehaviorLookup{'StartFixating'})]));
    
    if ~isempty(f)
      fixationStart(i) = f(1);
    else
      fixationStart(i) = NaN;
    end
    
    
    f = Range(find(flagsPerTrial{i}, ...
	['Td == ' num2str(BehaviorLookup{'FixSpotOff'})]));
    if ~isempty(f)
      fixSpotOff(i) = f(1);
    else 
      fixSpotOff(i) = NaN;
    end
    
    f = Range(find(flagsPerTrial{i}, ...
	['Td == ' num2str(BehaviorLookup{'CueOn'})]));
    if ~isempty(f)
      imageOn(i) = f(1);
    else
      imageOn(i) = NaN;
    end
    
    f = Range(find(flagsPerTrial{i}, ...
	['Td == ' num2str(BehaviorLookup{'CueOff'})]));
    if ~isempty(f)
      imageOff(i) = f(1);
    else
      imageOff(i) = NaN;
    end
    
    f = Range(find(flagsPerTrial{i}, ...
	['Td == ' num2str(BehaviorLookup{'Reward'})]));

    
    if ~isempty(f)
      reward(i) = f(end);
    else
      reward(i) = NaN;
    end
    
    if ~isnan(reward(i)) & ~isnan(imageOn(i))
      trialOutcome(i) = 1;
    elseif imageOff(i) - imageOn(i) > 14800
      trialOutcome(i) = 2;
    elseif ~isnan(imageOn(i))
      trialOutcome(i) = 3;
    elseif ~isnan(fixationStart(i))
      trialOutcome(i) = 4;
    else
      trialOutcome(i) = 5;
    end
    
  end
  
  fixSpotOn =  ts(fixSpotOn) ;
  fixationStart =  ts(fixationStart);
  fixSpotOff =  ts(fixSpotOff);
  imageOn =  ts(imageOn);
  imageOff =  ts(imageOff);
  reward = ts(reward);
  trialOutcome = tsd(trialStart, trialOutcome);
%  keyboard;
  A = saveAllResources(A);
  AO = A;
  
  