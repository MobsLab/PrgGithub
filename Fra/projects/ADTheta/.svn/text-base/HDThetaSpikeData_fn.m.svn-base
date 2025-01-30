function AO = AmygdalaSpikeData_fn(A)
  
  
  
  parentDir = parent_dir(A);
  
  A = getResource(A, 'HDThetaCellList');
  
  A = registerResource(A, 'HDThetaSpikeData', 'tsdArray', ...
		       {'HDThetaCellList', 1}, 'S', ...
		       ['all spike trains']);
  
  S = {};
  
  for i = 1:length(cellnames)
    [dummy, cn] = strtok(cellnames{i}, '/');
    cn = [current_dataset(A), cn];
    load(cn);
    S{i} = t;
  end
  S = S(:);
  S = tsdArray(S);
  
  cd(parentDir);
  A =  saveAllResources(A);

  AO = A;