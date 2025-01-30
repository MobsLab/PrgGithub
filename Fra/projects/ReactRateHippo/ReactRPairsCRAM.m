function AO = ReactRPairsCRAM(A)
% ReactRmatrices 
%
% computes the cell-pair correlation matrices R for sleep 1 sleep 2 and
% maze and the explained variance. The R matrices are "flattened" stored
% as column vectors (RpairC_s1, RpairC_s2, RpairC_m) corresponding to the
% correlation in cell pairs cell_I, cell_J. 
% This format is particularly convenient if data from several sessions
% are to be pooled together. 
% Inputs are the t files, and the start/end times for the epochs.
% outputs are the RpairC, cell_I, cell_J, and the EV.
% INPUTS
% filebase: stem for output fielnames  
% cell_list: name of a text file containing the names of the cells to use 
% epochs_start: vector containing the start times of sleep1, maze, sleep2
% epochs_end: vector containing the end times of sleep1, maze, sleep2
% restrict_times: cells array each element might be empty (and then
% no operation is performed) or it may contain a set of intervals, in that
% case the corresponding epoch will be restricted to the specified
% intervals. Useful to restrict maze time to actual runnign periods,
% sleep to spw periods, etc. 
  
  
  
  do_pyramids_only = 1;
  
  
  
  
  Qbin = 100 * 10; % the time bin for the Qmatrix (in 1/10000 sec)
  

  A = getResource(A, 'HippoCellList');
  A = getResource(A, 'HippoSpikeData');
  A = getResource(A, 'Maze_Epoch');
  Maze = Maze{1};
  

  A = getResource(A, 'FRateMaze');
  A = getResource(A, 'FRateSleep1');
  A = getResource(A, 'FRateSleep2');
  
  
  A = getResource(A, 'Sleep1_10min_Epoch');  
  Sleep1 = Sleep1{1};
  
  A = getResource(A, 'Sleep2_10min_Epoch');    
  Sleep2 = Sleep2{1};
  n_cells = length(S);
  
 
  if do_pyramids_only
    
    A = registerResource(A, 'PairPyrEV', 'numeric', {1,1}, ...
			 'EV', ...
			 ['cell pair correlation explained variance']);
    
    A = registerResource(A, 'PairPyrEVr', 'numeric', {1,1}, ...
			 'EVr', ...
			 ['cell pair correlation explained variance']);
    A = registerResource(A, 'CellPairPyrI', 'numeric', {[], 1}, ...
			 'cell_I', ...
			 ['the index of the first cell in the pair, according' ...
		    ' to the order used in ReactR variables']);
    
    A = registerResource(A, 'CellPairPyrJ', 'numeric', {[], 1}, ...
			 'cell_J', ...
			 ['the index of the second cell in the pair, according' ...
		    ' to the order used in RP variables']);
    A = registerResource(A, 'RPairPyrCS1', 'numeric', {[],1}, ...
			 'RpairC_s1', ...
			 ['cell pair correlation during sleep1 for all' ...
		    ' viable cell pairs']);
    A = registerResource(A, 'RPairPyrCS2', 'numeric', {[],1}, ...
			 'RpairC_s2', ...
			 ['cell pair correlation during sleep2 for all' ...
		    ' viable cell pairs']);
    A = registerResource(A, 'RPairPyrCMaze', 'numeric', {[],1}, ...
			 'RpairC_m', ...
			 ['cell pair correlation during sleep2 for all' ...
		    ' viable cell pairs']);
    
  else
    
    A = registerResource(A, 'PairEV', 'numeric', {1,1}, ...
			 'EV', ...
			 ['cell pair correlation explained variance']);
    
    A = registerResource(A, 'PairEVr', 'numeric', {1,1}, ...
			 'EVr', ...
			 ['cell pair correlation explained variance']);
    A = registerResource(A, 'CellPairI', 'numeric', {[], 1}, ...
			 'cell_I', ...
			 ['the index of the first cell in the pair, according' ...
		    ' to the order used in ReactR variables']);
    
    A = registerResource(A, 'CellPairJ', 'numeric', {[], 1}, ...
			 'cell_J', ...
			 ['the index of the second cell in the pair, according' ...
		    ' to the order used in RP variables']);
    A = registerResource(A, 'RPairCS1', 'numeric', {[],1}, ...
			 'RpairC_s1', ...
			 ['cell pair correlation during sleep1 for all' ...
		    ' viable cell pairs']);
    A = registerResource(A, 'RPairCS2', 'numeric', {[],1}, ...
			 'RpairC_s2', ...
			 ['cell pair correlation during sleep2 for all' ...
		    ' viable cell pairs']);
    A = registerResource(A, 'RPairCMaze', 'numeric', {[],1}, ...
			 'RpairC_m', ...
			 ['cell pair correlation during sleep2 for all' ...
		    ' viable cell pairs']);
    
  end

  

  if do_pyramids_only
  
    f_ok = max([frate_maze frate_sleep1 frate_sleep2], [], 2) > ...
	   0.5;
    pyr = find( f_ok);
    cellSet = pyr;
  else
    cellSet = 1:n_cells;
  end
  
  
 
  for i = 1:length(S)
    S_s1{i} = Restrict(S{i}, Sleep1);
    
    
    S_m{i} = Restrict(S{i}, Maze);

    S_s2{i} = Restrict(S{i}, Sleep2);

  end
  
    
  
  
  
  % start calculations, the R matrices are transformed in a column
  % vector, containing only the matrix' lower triangle, and only the
  % correlations between cells not recorded on the same electrode
  % findOnSameTrodeMatrix is a function that looks at the tfiles
  % filenames and determines if they came from te same trode or not,
  % returning an output of the appropriate format for this code. 
  % the function DEPENDS on your very own convention for filenames, so go
  % look in there...
  % the outputs of this calculation are RpairC_m, RpairC_s1, RpairC_s2, (the
  % R matrices flattened in a vector, and purged of same trode stuff, and
  % cell_I, cell_J, two vectors indicating to which cell pairs the
  % correlations in the RpairCs corresponded to, useful if later you want
  % to recalculate the EVs only on subsets of cells.
  
  % notice that with the "eval" tricks you don't have to rewrite the code
  % for s1, m, s2
  
  
  sfx = { '_s1', '_m', '_s2' };
  
  [X, Y] = meshgrid(cellSet, cellSet);
  
  idx = find((~findOnSameTrodeMatrix(cellnames(cellSet))) & (X > Y) );
  
  
  
  cell_I = X(idx);
  cell_J = Y(idx);
  
  
  for i = 1:3
    sf = sfx{i};
    
    eval(['S_epoch = S' sf ';']);
    Q = MakeQfromS(S_epoch, Qbin);

    Q = tsd(Range(Q, 'ts'), full(Data(Q)));
    

    
    
    
    warning off
    cQ = corrcoef(Data(Q));
    warning on
    RpairC = full(cQ(idx));
    
    
    eval(['RpairC' sf ' = RpairC;']);

     
    clear Q cQ RpairC

  end
    
 
 
  
  % now compute the explained variance: ReactEV computes the partial
  % correlation coefficients, taking care of NaNs  that arise from
  % correlations from empty spike trains
%  keyboard
  [EV EVr] = ReactEV(RpairC_s1, RpairC_s2, RpairC_m);
    
  
  
 
  
  A = saveAllResources(A);
  
  AO = A;
  