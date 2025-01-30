function AO = DIRACInterneurons2(A)
  
  
  A = getResource(A, 'HippoCellList');
 
  
  
  A = registerResource(A, 'Interneurons', 'numeric', {'HippoCellList', 1}, ...
		       'isInterneuron', ...
		       ['boolean, whether the cell is a putative interneuron']);
  
  warning off
  load('/home/fpbatta/Data/DIRAC/gl_DIRAC_RawAnalysis0629_empty.mat', 'gl_cn');
  warning on

  cn_empty = gl_cn;
  
  warning off
  load('/home/fpbatta/Data/DIRAC/gl_DIRAC_RawAnalysis0629_full.mat', 'gl_cn');
  warning on
 
  cn_full = gl_cn;
  
  
  cn = [cn_empty ; cn_full];
  
  
  load /home/fpbatta/Data/DIRAC/inter_empty;
  
  int_empty = inter;
  
  load /home/fpbatta/Data/DIRAC/inter_full;
  
  int_full = inter;
  
  interneurons = [int_empty; int_full];
  
  
  
  %%%%%%%%%%%%%%%%%%%%
  
  dset = current_dataset(A);
  
  [g, idx]  = grep(cn, dset);
  
  isInterneuron = interneurons(idx);
  
  
  A =  saveAllResources(A);

  AO = A;
  
  
  