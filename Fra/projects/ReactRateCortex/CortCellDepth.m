function AO = CortCellDepth(A)
  
 
  
  A = getResource(A, 'CortCellNames');
  
  
  dim_by_cell = {'CortCellNames', 1};
  

  A = registerResource(A, 'CortCellDepth', 'numeric', dim_by_cell, ...
		       'cell_depth', ...
		       ['putative depth for all cortical cells']);
  
  
  cd(current_dir(A));
  
  
  ! perl /home/fpbatta/perl/warp_depth.pl cell_info.list cort_cells.list cort_depth.list
  cell_depth = load('cort_depth.list');
  
  cd(parent_dir(A));
  
  
  
  A = saveAllResources(A);
  
  
  AO = A;
  

  
