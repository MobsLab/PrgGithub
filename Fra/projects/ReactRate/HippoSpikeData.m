function AO = HippoSpikeData(A)
  
  

  
  
  
  A = getResource(A, 'HippoCellList');
  
  
  A = registerResource(A, 'HippoSpikeData_fn', 'tsdArray', {'HippoCellList', 1}, ...
		       'S', ['all the spike trains']);
  
  
  cd(current_dir(A));
  S = LoadSpikes(cellnames);
  cd(parent_dir(A));
  
  
  A =  saveAllResources(A);

  AO = A;
  
  
  