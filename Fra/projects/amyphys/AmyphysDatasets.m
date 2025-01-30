function AO = AmyphysDatasets(A)
  
  A = registerResource(A, 'Experiment', 'cell', {1,1}, ...
		       'experiment', ...
		       ['which experiment was run in the session']);
  A = registerResource(A, 'StimLookup', 'cell', {1,1}, ...
		       'stimLookup',  ...
		       ['the lookup table for the behavioral stimuli', ...
		        '(a dictarray)']);
  A = registerResource(A, 'BehaviorLookup', 'cell', {1,1}, ...
		       'behaviorLookup', ...
		       ['the lookup table for cortex flags (dictArray)']);
  A = registerResource(A, 'StimSet', 'cell', {1,1}, ...
      'stimSet', ... 
      ['the stimulus set used']);
  A = registerResource(A, 'MonkeySubject', 'numeric', {1,1}, ...
      'monkeySubject', ...
      ['a code for the monkey subject, 0 = sirloin, 1 = shrieker']);
  parentDir = parent_dir(A);
  load([parentDir filesep 'AmyphysLookupTables'])
  
  
  dset = current_dataset(A);
  
  
  behaviorLookup = BehaviorLookup;
  if ~isempty(regexp(dset, '^slap')) | ~isempty(regexp(dset, 'amyphys')) % data from shrieker bring label "amyphys" and they shuold be amyphys
    experiment = 'amyphys';
    stimLookup = 'Amyphys_StimLookup';
    stimSet = ['amy' dset(10:14)];
  elseif ~isempty(regexp(dset, 'phys1'))
    experiment = 'phys1';
    stimLookup = 'Phys1_StimLookup';
    stimSet = 'phys1';
  elseif ~isempty(regexp(dset, 'phys2'))
    experiment = 'phys2';
    stimSet = 'phys2';
    stimLookup = 'Phys2_StimLookup';
  elseif ~isempty(regexp(dset, 'face'))
    experiment = 'face';
    stimLookup = Face_StimLookup;
    stimSet = 'face';
  elseif ~isempty(regexp(dset, 'd&m'))
    experiment = 'd&m';
    stimSet = 'd&m';
    stimLookup = DandM_StimLookup;
  else
    error('unrecognized experiment')
  end
  
  dset
  if ~isempty(regexp(dset, '^04\d\d05'))
      monkeySubject = 1
  else
      monkeySubject = 0
  end
  
  
  
  A = saveAllResources(A);
  AO = A;
  
  
  