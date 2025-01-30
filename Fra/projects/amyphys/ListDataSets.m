function ListDataSets()
  
  parentDir = '/home/fpbatta/Data/amyphys';
  rawDataDir = [parentDir filesep 'RawData'];
  
  outFname = [parentDir filesep 'datasets_amyphys.list'];
  
  cd(rawDataDir);
  
  allFiles = GetListOfFiles('*');
  
  12
  [st, mat, tok] = regexp(allFiles, '(.*)_ch.*[0-9]\.txt', ...
			  'start', 'match', 'tokens');
  

  
  d  = 1;
  for i = 1:length(tok)
    if ~isempty(tok{i});
      dset{d} = tok{i}{1}{1};
      d = d+1;
    end
    
  end
  
  dset=sort(unique(dset));
  
  FILE = fopen(outFname, 'w');
  
  for i = 1:length(dset)
    fprintf(FILE, '%s\n', dset{i});
  end
  
  cd(parentDir);