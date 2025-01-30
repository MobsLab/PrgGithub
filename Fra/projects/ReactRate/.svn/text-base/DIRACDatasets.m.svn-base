function AO = DIRACDatasets(A)
  
  
  A = getResource(A, 'HippoCellList');
  

  
  A = registerResource(A, 'IsRichTrack', 'numeric', {1,1}, ...
		       'isRichTrack', ...
		       'logical: whether it was on the rich track');
  A = registerResource(A, 'RatNumber', 'numeric', {1,1}, ...
		       'ratNumber', ...
		       'whether it was rat 1 (7450) or 2 (7451)');
  
  A = registerResource(A, 'CellNumber', 'numeric', {1,1}, ...
		       'cellNumber', ...
		       'how many cells there were');
  

  
  dsets_empty = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_empty.list');
  dsets_full = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_full.list');
  dsets_7450 = List2Cell('/home/fpbatta/Data/DIRAC/dirs_7450.list');
  dsets_7451 = List2Cell('/home/fpbatta/Data/DIRAC/dirs_7451.list');  
  
  
  cellNumber = length(cellnames);
  ds = current_dataset(A);
  
  if ismember(ds, dsets_full)
    isRichTrack = 1;
  elseif ismember(ds, dsets_empty)
    isRichTrack = 0;
  else
    error('can''t find whetrher it was rich or poor');
  end
  
  if ismember(ds, dsets_7450)
    ratNumber = 1;
  elseif ismember(ds, dsets_7451)
    ratNumber = 2;
  end
  
 isRichTrack = logical(isRichTrack);
 
  A = saveAllResources(A);
  
  
  AO = A;