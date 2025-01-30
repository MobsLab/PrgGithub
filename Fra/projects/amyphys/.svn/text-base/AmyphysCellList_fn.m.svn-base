function AO = AmyphysCellList_fn(A)
  
  parentDir = '/home/fpbatta/Data/amyphys';
  rawDataDir = [parentDir filesep 'RawData'];

  
  A = registerResource(A, 'AmygdalaCellList', 'cell', {[], 1}, 'cellnames', ...
		       'full list of amygdalar cells');
  
  dset = current_dataset(A);
  
  
  cd(rawDataDir);
  allFiles = GetListOfFiles('*');
  cd(parentDir);  
  
  [st, mat, tok] = regexp(allFiles, '(.*)_ch.*[^s]\.txt', ...
			  'start', 'match', 'tokens');
  
  d = 1;
  for i = 1:length(mat)
    if ~isempty(mat{i})
      cn{d} = allFiles{i};
      d = d+1;
    end
  end
  
  [mat] = regexp(cn, ['^' dset '_ch'], 'match');
  
  cellnames = {};
  d = 1;
  for i = 1:length(mat)
    if ~isempty(mat{i})
      cellnames{d}  = cn{i};
      d = d+1;
    end
    
  end  
  cellnames = cellnames(:);
  
  
  
  A = saveAllResources(A);
  
  AO = A;
  
  