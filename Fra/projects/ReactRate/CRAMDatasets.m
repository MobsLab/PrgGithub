function AO = CRAMDatasets(A)
  
  
  A = getResource(A, 'HippoCellList');
  

  

  
  A = registerResource(A, 'CellNumber', 'numeric', {1,1}, ...
		       'cellNumber', ...
		       'how many cells there were');
  

  

  
  cellNumber = length(cellnames);

 
  A = saveAllResources(A);
  
  
  AO = A;