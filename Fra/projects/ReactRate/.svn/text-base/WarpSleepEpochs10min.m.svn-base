function AO = WarpSleepEpochs10min(A)
  
  

  
  
  
  A = getResource(A, 'CortSpikeData');
  
  
  A = registerResource(A, 'GlobRate', 'numeric', {'CortCellList', 1}, ...
		       'frate', ['global firing Rate']);
  
  
  
  
  
  
  frate = map_array(S, 'AO = rate(TSA);');
  
  A = saveResource(A, frate, current_dataset(A), 'GlobRate');
  
  AO = A;
  
  
  