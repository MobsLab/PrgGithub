function AO = SpikeData(A)
  
  

  
  
  
  A = getResource(A, 'CortCellList');
  
  
  A = registerResource(A, 'CortSpikeData', 'tsdArray', {'CortCellList', 1}, ...
		       'S', ['all the spike trains']);
  
  
  cd(current_dir(A));
  S = LoadSpikes(cellnames);
  cd(parent_dir(A));
  
  A = saveResource(A, S, current_dataset(A), 'CortSpikeData');
  
  AO = A;
  
  
  