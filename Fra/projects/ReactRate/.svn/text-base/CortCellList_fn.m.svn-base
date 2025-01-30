function AO = CortCellList_fn(A)
  
  

  
  
  
  A = getResource(A, 'CortCellNames');
  
  
  A = registerResource(A, 'CortCellList', 'cell', {[], 1}, 'cellnames', ['the' ...
		    ' full list of cortical cells']);
  
  A = saveResource(A, cellnames, current_dataset(A), 'CortCellList');
  
  AO = A;
  
  
  