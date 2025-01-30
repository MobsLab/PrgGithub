function AO = ReactRatePyrCRAM(A)
  
  to_plot = 0;
  

  A = getResource(A, 'HippoSpikeData');
  A = getResource(A, 'Maze_Epoch');
  Maze = Maze{1};
  
  
  
  A = getResource(A, 'Sleep1_10min_Epoch');  
  Sleep1 = Sleep1{1};
  
  A = getResource(A, 'Sleep2_10min_Epoch');    
  Sleep2 = Sleep2{1};
  
   
  A = getResource(A, 'HippoCellList');
  
  A = getResource(A, 'RunsAll');
  runs_all = runs_all{1};
  
  A = getResource(A, 'MazeStill');
  maze_still = maze_still{1};
 
  A = getResource(A, 'Reward1');
  reward1 = reward1{1};
  
  A = getResource(A, 'Reward2');
  reward2 = reward2{1};
  
  A = getResource(A, 'Reward');
  reward = reward{1};
  

  
  
  dim_by_cell = {'HippoCellList', 1};
  

  A = registerResource(A, 'IsPyramid', 'numeric', dim_by_cell, ...
		       'pyr', ...
		       ['boolean: whether is a pyramidal (with a firing rate',...
		    'of at least 0.5 Hz cell or not']);
  
  
  A = registerResource(A, 'ReactPyrGlobalSlope', 'numeric', {1,1}, ...
		       'react_global_slope', ...
		       ['slope of the log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactPyrGlobalIntercept', 'numeric', {1,1}, ...
		       'react_global_intercept', ...
		       ['intercept of the log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactPyrGlobalR', 'numeric', {1,1}, ...
		       'react_global_r', ...
		       ['r-value of the log rate ratio regression'], 1);

  A = registerResource(A, 'ReactPyrGlobalPval', 'numeric', {1,1}, ...
		       'react_global_pval', ...
		       ['pval of the log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactPyrBinnedSlope', 'tsdArray', {1,1}, ...
		       'react_binned_slope', ...
		       ['slope for the log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  A = registerResource(A, 'ReactPyrBinnedR', 'tsdArray', {1,1}, ...
		       'react_binned_r', ...
		       ['r for the log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  
  A = registerResource(A, 'ReactPyrBinnedPval', 'tsdArray', {1,1}, ...
		       'react_binned_pval', ...
		       ['pval for the log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
 

  A = registerResource(A, 'ReactPyrGlobalSlopeRev', 'numeric', {1,1}, ...
		       'react_global_slope_rev', ...
		       ['slope of the reverse log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactPyrGlobalInterceptRev', 'numeric', {1,1}, ...
		       'react_global_intercept_rev', ...
		       ['intercept of the reverse log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactPyrGlobalRRev', 'numeric', {1,1}, ...
		       'react_global_r_rev', ...
		       ['r-value of the reverse log rate ratio regression'], 1);

  A = registerResource(A, 'ReactPyrGlobalPvalRev', 'numeric', {1,1}, ...
		       'react_global_pval_rev', ...
		       ['pval of the reverse log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactPyrBinnedSlopeRev', 'tsdArray', {1,1}, ...
		       'react_binned_slope_rev', ...
		       ['slope for the reverse log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  A = registerResource(A, 'ReactPyrBinnedRRev', 'tsdArray', {1,1}, ...
		       'react_binned_r_rev', ...
		       ['r for the reverse log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  
  A = registerResource(A, 'ReactPyrBinnedPvalRev', 'tsdArray', {1,1}, ...
		       'react_binned_pval_rev', ...
		       ['pval for the reverse log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  
  A = registerResource(A, 'ReactPyrEV', 'numeric', {1,1}, ...
		       'EV', ...
		       ['EV for the maze-sleep2|sleep1 regression']);
  
  A = registerResource(A, 'ReactPyrEVr', 'numeric', {1,1}, ...
		       'EVr', ...
		       ['reverse EV for the maze-sleep2|sleep1 regression']);
  

  

  

  frate_maze = (mapArray(S, 'AO = rate(TSA, %1);', Maze));
  frate_maze_run = (mapArray(S, 'AO = rate(TSA, %1);', runs_all));
  frate_maze_still = (mapArray(S, 'AO = rate(TSA, %1);', maze_still));
  frate_maze_reward = (mapArray(S, 'AO = rate(TSA, %1);', reward));
  frate_sleep1 = (mapArray(S, 'AO = rate(TSA, %1);', Sleep1));
  frate_sleep2 = (mapArray(S, 'AO = rate(TSA, %1);', Sleep2));
   Sleep2_binning = regular_interval(FirstTime(Sleep2), ...
				    LastTime(Sleep2)+4800000, ...
				    600000, 200000);
  Sleep1_binning = regular_interval(FirstTime(Sleep1)-480000, ...
				    LastTime(Sleep1), ...
				    600000, 200000);
  frate_binned_s2 = map(S, 'TSO = intervalRate(TSA, %1);', Sleep2_binning);
  frate_binned_s1 = map(S, 'TSO = intervalRate(TSA, %1);', Sleep1_binning);

% $$$   frate_binned_s2 = map(frate_binned_s2, ...
% $$$ 			'TSO = realign(TSA, ''ZeroFirst'', 1);');
  
  
  f_ok = max([frate_maze frate_sleep1 frate_sleep2], [], 2) > ...
      0.5;
  pyr = (f_ok);
  
 
  
  binned_all = (Data(merge(frate_binned_s2)))';
  
  warning off
  X_MS1 = log10((frate_maze) ./ (frate_sleep1));
  X_MS2 = log10((frate_maze) ./ (frate_sleep2));
  X_S2S1 = log10((frate_sleep2) ./ (frate_sleep1));
  X_MSR = log10((frate_maze_run) ./ (frate_maze_reward));
  X_S2binned = log10( (binned_all) ./ ...
		      repmat((frate_sleep1), 1, size(binned_all, 2)));

  binned_all = (Data(merge(frate_binned_s1)))';

  X_S1binned = log10( (binned_all) ./ ...
		      repmat((frate_sleep2), 1, size(binned_all, 2)));
  warning on
  
  X_MS1 = X_MS1(pyr);
  X_MS2 = X_MS2(pyr);
  X_S2S1 = X_S2S1(pyr);
  X_MSR = X_MSR(pyr);
  X_S2binned = X_S2binned(pyr,:);
  X_S1binned = X_S1binned(pyr,:);  
  frate_maze = frate_maze(pyr);
  frate_sleep1 = frate_sleep1(pyr);
  frate_sleep2 = frate_sleep2(pyr);
  
  
  [EV, EVr] = ReactEV(log10(frate_sleep1), log10(frate_sleep2), log10(frate_maze));
  
  [react_global_intercept, react_global_slope, react_global_r, react_global_pval] = regression_line(X_MS1, X_S2S1);
  [react_global_intercept_rev, react_global_slope_rev, react_global_r_rev, react_global_pval_rev] = regression_line(X_MS2, -X_S2S1);
  
  
  for i = 1:size(X_S2binned, 2)
    [react_binned_intercept(i), react_binned_slope(i), react_binned_r(i), react_binned_pval(i)] = regression_line(X_MS1, X_S2binned(:,i));
  end
  
  for i = 1:size(X_S1binned, 2)
    [react_binned_intercept_rev(i), react_binned_slope_rev(i), react_binned_r_rev(i), react_binned_pval_rev(i)] = regression_line(X_MS2, X_S1binned(:,i));
  end
  
  react_binned_slope = tsd(Range(frate_binned_s2{2}), react_binned_slope);
  react_binned_r = tsd(Range(frate_binned_s2{2}), react_binned_r);  
  react_binned_pval = tsd(Range(frate_binned_s2{2}), react_binned_pval);    
  
  react_binned_slope_rev = tsd(Range(frate_binned_s1{2}), react_binned_slope_rev);
  react_binned_r_rev = tsd(Range(frate_binned_s1{2}), react_binned_r_rev);  
  react_binned_pval_rev = tsd(Range(frate_binned_s1{2}), react_binned_pval_rev);    
  
  
  
   if to_plot 
    figure(1)
    clf, hold on 
    
    subplot(2,1,1)
    plot(X_MS1, X_S2S1, '.', 'MarkerSize', 20);
    subplot(2,1,2)
    plot(X_MS2, -X_S2S1, 'r.', 'MarkerSize', 20);
    
    figure(2), clf, hold on
    
    subplot(2,1,1);
    plot(Range(react_binned_slope, 'min'), Data(react_binned_slope))
    xlabel('time (min)'); ylabel('alpha');
    
    subplot(2,1,2);    
    plot(Range(react_binned_r, 'min'), Data(react_binned_r))
    xlabel('time (min)'); ylabel('R value');
   
    figure(3), clf, hold on
    
    subplot(2,1,1);
    plot(Range(react_binned_slope_rev, 'min'), Data(react_binned_slope_rev))
    xlabel('time (min)'); ylabel('alpha');
    
    subplot(2,1,2);    
    plot(Range(react_binned_r_rev, 'min'), Data(react_binned_r_rev))
    xlabel('time (min)'); ylabel('R value');
    keyboard
   end
   
   

   A = saveAllResources(A);
   
   
   
   AO = A;
   