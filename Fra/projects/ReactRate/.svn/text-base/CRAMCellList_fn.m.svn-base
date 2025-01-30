function AO = CRAMCellList_fn(A)
  
   

  
  
  
  
  
  A = registerResource(A, 'HippoCellList', 'cell', {[], 1}, 'cellnames', ['the', ...
		    ' list of hippocampal cells recorded and deemed', ...
		     ' suitable for reactivation analysis']);
  

 
  cellnames = List2Cell([current_dir(A) filesep 'cells_react.list']);
  
  
  
  
  
  
  
  
  A =  saveAllResources(A);

  
  AO = A;
  
  
  