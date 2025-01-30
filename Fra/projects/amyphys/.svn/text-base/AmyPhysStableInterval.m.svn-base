function AO = AmyPhysStableInterval(A)
  
  
  
  parentDir = parent_dir(A);
  rawDataDir = [parentDir filesep 'RawData'];
  
  A = getResource(A, 'AmygdalaCellList');
  
  A = registerResource(A, 'StableInterval', 'cell', ...
		       {'AmygdalaCellList', 1}, 'stableInterval', ...
		       ['an intervalSet object for each cell', ...
		        ' indicating the range of time when cell ',...
		        ' was deemed stable by experimenter']);
  
  cd(rawDataDir);
  
  stableInterval = cell(0,1);
  for i = 1:length(cellnames)
    limitsFname = [cellnames{i}(1:end-4) '_limits.txt'];
    a = load(limitsFname);
    stableInterval{i} = intervalSet(a(1)*10000, a(2)*10000);
  end
  stableInterval = stableInterval(:);
  
  

  
  cd(parentDir);
  A =  saveAllResources(A);

  AO = A;