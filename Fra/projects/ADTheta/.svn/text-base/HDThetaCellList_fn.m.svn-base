function AO = HDThetaCellList_fn(A)
  
  parentDir = '/home/fpbatta/Data/Angelo';
  

  
  A = registerResource(A, 'HDThetaCellList', 'cell', {[], 1}, 'cellnames', ...
		       'full list of good  HD cells');
  
  dset= current_dataset(A);
  dset = dset(1:(end-3));
  allcells = List2Cell('good_cells.list');
  
  ix = strmatch(dset, allcells);
  cellnames = allcells(ix);
  A = saveAllResources(A);
  
  AO = A;
  
  