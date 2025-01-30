function AO = DIRACEpochs10min(A)
  
  

  

  warning off
  load([current_dir(A) filesep 'DIRACPosFile0627'], 'epoch_start', 'epoch_end');
  warning on 
  
  A = registerResource(A, 'Sleep1_10min_Epoch', 'cell', {1, 1}, ...
		       'Sleep1', ...
		       ['10 minutes of sleep ending 3 mins before beginning', ...
		    ' of maze epoch']);
  
  A = registerResource(A, 'Sleep2_10min_Epoch', 'cell', {1, 1}, ...
		       'Sleep2', ...
		       ['10 minutes of sleep ending 3 mins before beginning', ...
		    ' of maze epoch']);

  A = registerResource(A, 'Maze_Epoch', 'cell', {1, 1}, ...
		       'Maze', ...
		       ['Maze epoch']);

  
  epoch_start = epoch_start(1);
  epoch_end = epoch_end(1);
  
  M = intervalSet(epoch_start, epoch_end);
  S1 = intervalSet(epoch_start-7200000, epoch_start-1200000);
  S2 = intervalSet(epoch_end+1200000, epoch_end+7200000);

  
  Maze{1} = M;
  Sleep1{1} = S1;
  Sleep2{1} = S2;

  
  A = saveAllResources(A);
      
  
  AO = A;
  
  
  