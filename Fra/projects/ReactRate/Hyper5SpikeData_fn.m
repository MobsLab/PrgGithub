function AO = Hyper5SpikeData_fn(A)
  
  A = registerResource(A, 'HippoCellList', 'cell', {[], 1}, 'cellnames', ['the' ...
		    ' full list of hippocampal cells recorded']);
  
  A = registerResource(A, 'HippoSpikeData', 'tsdArray', {'HippoCellList', 1}, ...
		       'S', ['all the spike trains']);
 
  cd(current_dir(A));
  
  ts1 =  sort(GetListOfFiles('tfiles/tet_*/tsleep1*.t'));
  if isempty(ts1)
    ts1 =  sort(GetListOfFiles('tfiles/tet_*/sleep1*.t'));
  end
  
  Ss1 = LoadSpikes(sort(ts1')); 
  cellnames = ts1';
  
  
  tm1 =  sort(GetListOfFiles('tfiles/tet_*/tmaze1*.t'));
  if isempty(tm1)
    tm1 =  sort(GetListOfFiles('tfiles/tet_*/maze1*.t'));
  end
  Sm1 = LoadSpikes(tm1');
  
  ts2 =  sort(GetListOfFiles('tfiles/tet_*/tsleep2*.t'));
  if isempty(ts2)
    ts2 =  sort(GetListOfFiles('tfiles/tet_*/sleep2*.t'));
  end
  Ss2 = LoadSpikes(ts2');  
  
  tm2 =  sort(GetListOfFiles('tfiles/tet_*/tmaze2*.t'));
  if isempty(tm2)
    tm2 =  sort(GetListOfFiles('tfiles/tet_*/maze2*.t'));
  end
  Sm2 = LoadSpikes(tm2');  

  ts3 =  sort(GetListOfFiles('tfiles/tet_*/tsleep3*.t'));
  if isempty(ts3)
    ts3 =  sort(GetListOfFiles('tfiles/tet_*/sleep3*.t'));
  end
  Ss3 = LoadSpikes(ts3');  
  
  cd(parent_dir(A));
  
  
  
  for i = 1:length(Ss1)
    S{i} = vertcat(Ss1{i}, Sm1{i}, Ss2{i}, Sm2{i}, Ss3{i});
  end
  
  S = tsdArray(S');
  
  A = saveAllResources(A);
  
  AO = A;