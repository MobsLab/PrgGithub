function AO = DIRACCellList_fn(A)
  
  

  
  
  
  
  
  A = registerResource(A, 'HippoCellList', 'cell', {[], []}, 'cellnames', ['the' ...
		    ' full list of hippocampal cells recorded']);
  

  load /home/fpbatta/Data/DIRAC/gl_DIRAC_RawAnalysis0629_full.mat gl_cn
  cn = gl_cn;
  load /home/fpbatta/Data/DIRAC/gl_DIRAC_RawAnalysis0629_empty.mat gl_cn
  cn = [cn ; gl_cn];
  
  dset = current_dataset(A);
  [g, idx] = grep(cn, dset);
  
  cn = cn(idx);
  
  for i = 1:length(cn)
    j = findstr(cn{i}, dset) + length(dset) + 1;
    cellnames{i,1} = cn{i}(j:end);
  end
  
  

  
  
  
  
  
  
  A =  saveAllResources(A);

  
  AO = A;
  
  
  