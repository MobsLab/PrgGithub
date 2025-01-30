function AO = WarpEpochs10min(A)
  
  

  
  
  
  A = getResource(A, 'EpochLimits');
  
  
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

  
  
  M = intervalSet(epoch_limits(1), epoch_limits(2));
  S1 = intervalSet(epoch_limits(1)-7200000, epoch_limits(1)-1200000);
  S2 = intervalSet(epoch_limits(2)+1200000, epoch_limits(2)+7200000);

  
  Maze{1} = M;
  Sleep1{1} = S1;
  Sleep2{1} = S2;

  
  A = saveResource(A, Sleep1, current_dataset(A), 'Sleep1_10min_Epoch');
  A = saveResource(A, Sleep2, current_dataset(A), 'Sleep2_10min_Epoch'); ...
  A = saveResource(A, Maze, current_dataset(A), 'Maze_Epoch');        
      
  
  AO = A;
  
  
  