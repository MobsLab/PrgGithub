function AO = HippoCellList_fn(A)
  
   

  
  
  
  
  
  A = registerResource(A, 'HippoCellList', 'cell', {[], 1}, 'cellnames', ['the' ...
		    ' full list of hippocampal cells recorded']);
  

  load gl_DIRAC_RawAnalysis0629_full.mat gl_cn
  cn = gl_cn;
  load gl_DIRAC_RawAnalysis0629_empty.mat gl_cn
  cn = [cn ; gl_cn];
  
  dset = current_dataset(A);
  [g, idx] = grep(cn, dset);
  
  cn = cn(idx);
  
  for i = 1:length(cn)
    j = findstr(cn, dset) + length(dset);
    cellnames{i} = cn{i}(j:end);
  end
  
  
  
  
  
  
  
  
  
  A =  saveAllResources(A);

  
  AO = A;
  
  
  