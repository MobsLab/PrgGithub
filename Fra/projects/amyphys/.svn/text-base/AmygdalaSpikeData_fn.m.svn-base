function AO = AmygdalaSpikeData_fn(A)
  
  
  
  parentDir = parent_dir(A);
  rawDataDir = [parentDir filesep 'RawData'];
  
  A = getResource(A, 'AmygdalaCellList');
  
  A = registerResource(A, 'AmygdalaSpikeData', 'tsdArray', ...
		       {'AmygdalaCellList', 1}, 'S', ...
		       ['all spike trains']);
  
  cd(rawDataDir);
  
  for i = 1:length(cellnames)
    S{i} = ReadCedASCIISpikeTrain(cellnames{i});
  end
  S = S(:);
  S = tsdArray(S);
  
  cd(parentDir);
  A =  saveAllResources(A);

  AO = A;