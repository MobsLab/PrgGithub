function AO = ReactRateDIRAC(A)
  
  to_plot = 0;
  

  A = getResource(A, 'HippoSpikeData');
  A = getResource(A, 'Maze_Epoch');
  Maze = Maze{1};
  
  
  
  A = getResource(A, 'Sleep1_10min_Epoch');  
  Sleep1 = Sleep1{1};
  
  A = getResource(A, 'Sleep2_10min_Epoch');    
  Sleep2 = Sleep2{1};
  
  A = getResource(A, 'SPW_s1');
  spw_s1 = spw_s1{1};
  
  A = getResource(A, 'SPW_s2');  
  spw_s2 = spw_s2{1};
  
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
  

  
  A = registerResource(A, 'FRateMaze', 'numeric', dim_by_cell, ...
		       'frate_maze', ...
		       ['firing rate in maze period'], 1);
  
  A = registerResource(A, 'FRateMazeRun', 'numeric', dim_by_cell, ...
		       'frate_maze_run', ...
		       ['firing rate in maze period', ...
		   'while actually running'], 1);
  
  A = registerResource(A, 'FRateMazeStill', 'numeric', dim_by_cell, ...
		       'frate_maze_still', ...
		       ['firing rate in maze period', ...
		   'while not running'], 1);
  
  A = registerResource(A, 'FRateMazeReward', 'numeric', dim_by_cell, ...
		       'frate_maze_reward', ...
		       ['firing rate in maze period', ...
		   'while at reward sites '], 1);
  
   A = registerResource(A, 'FRateSleep1', 'numeric', dim_by_cell, ...
		       'frate_sleep1', ...
		       ['firing rate in sleep1 period'], 1);
  

  A = registerResource(A, 'FRateSleep2', 'numeric', dim_by_cell, ...
		       'frate_sleep2', ...
		       ['firing rate in sleep2 period'], 1);

  A = registerResource(A, 'FRateSPWSleep1', 'numeric', dim_by_cell, ...
		       'frate_spw_sleep1', ...
		       ['firing rate in sleep1 period',...
		   ' during sharp waves'], 1);
  
  A = registerResource(A, 'FRateSPWSleep2', 'numeric', dim_by_cell, ...
		       'frate_spw_sleep2', ...
		       ['firing rate in sleep2 period',...
		   ' during sharp waves'], 1);

  A = registerResource(A, 'FRateNoSPWSleep1', 'numeric', dim_by_cell, ...
		       'frate_no_spw_sleep1', ...
		       ['firing rate in sleep1 period',...
		   ' during inter sharp waves times'], 1);
  
  A = registerResource(A, 'FRateNoSPWSleep2', 'numeric', dim_by_cell, ...
		       'frate_no_spw_sleep2', ...
		       ['firing rate in sleep2 period',...
		   ' during inter sharp waves times'], 1);
  
  
  A = registerResource(A, 'FRateBinnedS1', 'tsdArray', dim_by_cell, ...
		       'frate_binned_s1', ...
		       ['firing rate in sleep1 binned in 1 min periods,', ...
		       ' at 20 s shifts'], 1);

  
  A = registerResource(A, 'FRateBinnedS2', 'tsdArray', dim_by_cell, ...
		       'frate_binned_s2', ...
		       ['firing rate in sleep2 binned in 1 min periods,', ...
		       ' at 20 s shifts'], 1);
  
  
  A = registerResource(A, 'X_S2S1', 'numeric', dim_by_cell, ...
		       'X_S2S1', ...
		       ['log ration of firing rate during sleep2', ...
		    ' and 1'], 1);
  
  A = registerResource(A, 'X_MS1', 'numeric', dim_by_cell, ...
		       'X_MS1', ...
		       ['log ration of firing rate during maze', ...
		    ' and sleep 1'], 1);
  
  A = registerResource(A, 'X_MS2', 'numeric', dim_by_cell, ...
		       'X_MS2', ...
		       ['log ration of firing rate during maze', ...
		    ' and sleep 2'], 1);
  
  A = registerResource(A, 'X_MSR', 'numeric', dim_by_cell, ...
		       'X_MSR', ...
		       ['log ration of firing rate during maze', ...
		    ' while sleeping over while still'], 1);
  
  A = registerResource(A, 'ReactGlobalSlope', 'numeric', {1,1}, ...
		       'react_global_slope', ...
		       ['slope of the log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactGlobalIntercept', 'numeric', {1,1}, ...
		       'react_global_intercept', ...
		       ['intercept of the log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactGlobalR', 'numeric', {1,1}, ...
		       'react_global_r', ...
		       ['r-value of the log rate ratio regression'], 1);

  A = registerResource(A, 'ReactGlobalPval', 'numeric', {1,1}, ...
		       'react_global_pval', ...
		       ['pval of the log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactBinnedSlope', 'tsdArray', {1,1}, ...
		       'react_binned_slope', ...
		       ['slope for the log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  A = registerResource(A, 'ReactBinnedR', 'tsdArray', {1,1}, ...
		       'react_binned_r', ...
		       ['r for the log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  
  A = registerResource(A, 'ReactBinnedPval', 'tsdArray', {1,1}, ...
		       'react_binned_pval', ...
		       ['pval for the log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
 

  A = registerResource(A, 'ReactGlobalSlopeRev', 'numeric', {1,1}, ...
		       'react_global_slope_rev', ...
		       ['slope of the reverse log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactGlobalInterceptRev', 'numeric', {1,1}, ...
		       'react_global_intercept_rev', ...
		       ['intercept of the reverse log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactGlobalRRev', 'numeric', {1,1}, ...
		       'react_global_r_rev', ...
		       ['r-value of the reverse log rate ratio regression'], 1);

  A = registerResource(A, 'ReactGlobalPvalRev', 'numeric', {1,1}, ...
		       'react_global_pval_rev', ...
		       ['pval of the reverse log rate ratio regression'], 1);
		   
  A = registerResource(A, 'ReactBinnedSlopeRev', 'tsdArray', {1,1}, ...
		       'react_binned_slope_rev', ...
		       ['slope for the reverse log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  A = registerResource(A, 'ReactBinnedRRev', 'tsdArray', {1,1}, ...
		       'react_binned_r_rev', ...
		       ['r for the reverse log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  
  A = registerResource(A, 'ReactBinnedPvalRev', 'tsdArray', {1,1}, ...
		       'react_binned_pval_rev', ...
		       ['pval for the reverse log rate ratio for the ', ...
		    'firing rate in  sleep2'], 1);
  
  A = registerResource(A, 'ReactEV', 'numeric', {1,1}, ...
		       'EV', ...
		       ['EV for the maze-sleep2|sleep1 regression']);
  
  A = registerResource(A, 'ReactEVr', 'numeric', {1,1}, ...
		       'EVr', ...
		       ['reverse EV for the maze-sleep2|sleep1 regression']);


 
  
  spw_s1= intersect(Sleep1, spw_s1);
  no_spw_s1 = Sleep1 - spw_s1;
  
  spw_s2= intersect(Sleep2, spw_s2);
  no_spw_s2 = Sleep2 - spw_s2;

  frate_maze = (mapArray(S, 'AO = rate(TSA, %1);', Maze));
  frate_maze_run = (mapArray(S, 'AO = rate(TSA, %1);', runs_all));
  frate_maze_still = (mapArray(S, 'AO = rate(TSA, %1);', maze_still));
  frate_maze_reward = (mapArray(S, 'AO = rate(TSA, %1);', reward));
  frate_sleep1 = (mapArray(S, 'AO = rate(TSA, %1);', Sleep1));
  frate_sleep2 = (mapArray(S, 'AO = rate(TSA, %1);', Sleep2));
  frate_spw_sleep1 = (mapArray(S, 'AO = rate(TSA, %1);', spw_s1));
  frate_no_spw_sleep1 = (mapArray(S, 'AO = rate(TSA, %1);', no_spw_s1));  
  frate_spw_sleep2 = (mapArray(S, 'AO = rate(TSA, %1);', spw_s2));    
  frate_no_spw_sleep2 = (mapArray(S, 'AO = rate(TSA, %1);', no_spw_s2));
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
  
  
  frate_cells_ok = max([frate_maze frate_sleep1 frate_sleep2], [], 2) > ...
      0.5;
  
  [EV, EVr] = ReactEV(log10(frate_sleep1), log10(frate_sleep2), log10(frate_maze));

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
   