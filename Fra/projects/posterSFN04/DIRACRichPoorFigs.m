function fig_st = DIRACRichPoorFigs()
  
  
  dsets_empty = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_empty.list');
  dsets_full = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_full.list');
  
  
  A = Analysis('/home/fpbatta/Data/DIRAC/');

  do_pyramids_only = 1;
  
 
  cellclass = 'all';
 
  if do_pyramids_only 
    cellclass = 'pyramidal';
  end
    

  pyr_firing_thresh = 0.5;
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% do the poor tarck  
  
  [A, X_MS1] = getResource(A, 'X_MS1', dsets_empty);
  [A, X_MS2] = getResource(A, 'X_MS2', dsets_empty);  
  [A, X_S2S1] = getResource(A, 'X_S2S1', dsets_empty);  
  [A, fr_maze] = getResource(A, 'FRateMaze', dsets_empty);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_empty);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_empty);  
  

  if do_pyramids_only
    [A, isInt] = getResource(A, 'IsInterneuron', dsets_empty);  
    
  
    ok1 = fr_maze > pyr_firing_thresh | fr_s1 > pyr_firing_thresh | ...
	  fr_s2 > pyr_firing_thresh;
    ok2 = fr_maze < 20 & fr_maze < 20 & fr_maze < 20;
  
    pyr = find(~isInt & ok1 & ok2);
    pyr_empty = pyr;
    
    fr_maze = fr_maze(pyr);
    fr_s1 = fr_s1(pyr);
    fr_s2 = fr_s2(pyr);
    
    X_MS1 = X_MS1(pyr);
    X_MS2 = X_MS2(pyr);
    X_S2S1 = X_S2S1(pyr);
  end

   
  fig_direct.x{1} = X_MS1;
  fig_direct.n{1} = X_S2S1;
  x = [-3:3];
  [a, b, r, p] = regression_line(X_MS1, X_S2S1);
  fig_direct.x{2} = x;
  fig_direct.n{2} = a + b * x;

  [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
  
  log_string = sprintf(['global rate react, direct poor track, ' cellclass ' cells\n', ...
		    ' n']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      b, a, r(1,2), clo(1,2), chi(1,2))];
  
  logger(log_string);
  
  
  
  
  fig_direct.xLabel = 'X_{MS1}';
  fig_direct.yLabel = 'X_{S2S1}';
  fig_direct.figureName = 'DIRACPoorGlobalReactDirect';  
  
  fig_direct.style{1} = 'k.';
  fig_direct.style{2} = 'k-';  
  fig_direct.figureType = 'plot';

  fig_direct.axesProperties = {'DataAspectRatio', [1 1 1]};
  
  
  fig_inverse = fig_direct;
  
  
  fig_inverse.x{1} = X_MS2;
  fig_inverse.n{1} = - X_S2S1;
  x = [-3:3];
  [ar, br, rr, pr] = regression_line(X_MS2, - X_S2S1);
    
  fig_inverse.x{2} = x;
  fig_inverse.n{2} = ar + br * x;
  fig_inverse.xLabel = 'X_{MS2}';
  fig_inverse.yLabel = 'X_{S1S2}';
  fig_direct.figureName = 'DIRACPoorGlobalReactInverse';  
  
  [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
  
		
  log_string = sprintf(['global rate react, inverse poor track, ' cellclass ' cells\n', ...
		    ' n']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      br, ar, r(1,2), clo(1,2), chi(1,2))];
		
		
 
  logger(log_string);
  

  
  fig_st = {fig_direct, fig_inverse};
		
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% do the rich tarck  
  
  [A, X_MS1] = getResource(A, 'X_MS1', dsets_full);
  [A, X_MS2] = getResource(A, 'X_MS2', dsets_full);  
  [A, X_S2S1] = getResource(A, 'X_S2S1', dsets_full);  
  [A, fr_maze] = getResource(A, 'FRateMaze', dsets_full);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_full);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_full);  
    
  
  if do_pyramids_only
    [A, isInt] = getResource(A, 'IsInterneuron', dsets_full);  
    
  
    ok1 = fr_maze > pyr_firing_thresh | fr_s1 > pyr_firing_thresh | ...
	  fr_s2 > pyr_firing_thresh;
    ok2 = fr_maze < 20 & fr_maze < 20 & fr_maze < 20;
  
    pyr = find(~isInt & ok1 & ok2);
    pyr_full = pyr;
    
    fr_maze = fr_maze(pyr);
    fr_s1 = fr_s1(pyr);
    fr_s2 = fr_s2(pyr);
    
    X_MS1 = X_MS1(pyr);
    X_MS2 = X_MS2(pyr);
    X_S2S1 = X_S2S1(pyr);
  end
  
  fig_direct.x{1} = X_MS1;
  fig_direct.n{1} = X_S2S1;
  x = [-3:3];
  [a, b, r, p] = regression_line(X_MS1, X_S2S1);
  fig_direct.x{2} = x;
  fig_direct.n{2} = a + b * x;

  [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
  
  log_string = sprintf(['global rate react, direct rich track, ' cellclass 'cells\n', ...
		    '']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      b, a, r(1,2), clo(1,2), chi(1,2))];
  
  logger(log_string);
  
  
  
  
  fig_direct.xLabel = 'X_{MS1}';
  fig_direct.yLabel = 'X_{S2S1}';
  fig_direct.figureName = 'DIRACRichGlobalReactDirect';  
  
  fig_direct.style{1} = 'k.';
  fig_direct.style{2} = 'k-';  
  fig_direct.figureType = 'plot';

  fig_direct.axesProperties = {'DataAspectRatio', [1 1 1]};
  
  
  fig_inverse = fig_direct;
  
  
  fig_inverse.x{1} = X_MS2;
  fig_inverse.n{1} = - X_S2S1;
  x = [-3:3];
  [ar, br, rr, pr] = regression_line(X_MS2, - X_S2S1);
    
  fig_inverse.x{2} = x;
  fig_inverse.n{2} = ar + br * x;
  fig_inverse.xLabel = 'X_{MS2}';
  fig_inverse.yLabel = 'X_{S1S2}';
  fig_direct.figureName = 'DIRACRichGlobalReactInverse';  
  
  [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
  
		
  log_string = sprintf(['global rate react, inverse rich track, ' cellclass ' cells\n', ...
		    '']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      br, ar, r(1,2), clo(1,2), chi(1,2))];
		
		
 
  logger(log_string);
  

  
  fig_st = [fig_st {fig_direct, fig_inverse}];
				
		

		
		
  [A, fr_maze] = getResource(A, 'FRateMaze', dsets_empty);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_empty);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_empty);  
  [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_empty);
  [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_empty);

  if do_pyramids_only
    pyr = pyr_empty;
    fr_maze = fr_maze(pyr);
    fr_s1 = fr_s1(pyr);
    fr_s2 = fr_s2(pyr);
    fr_run = fr_run(pyr);
    fr_rew = fr_rew(pyr);
  end
  
  
  [EVpoor, EVrpoor, EVpoor_int, EVrpoor_int] = ...
      ReactEV(log(fr_s1), log(fr_s2), log(fr_maze));

  var_s1 = var(log(fr_s1(fr_s1 > 0)));
  var_s2 = var(log(fr_s2(fr_s2 > 0)));
  var_maze = var(log(fr_maze(fr_maze > 0)));
  log_string = sprintf('poor : var(S1) = %g, var(S2) = %g, var(maze) = %g\n', ...
		       var_s1, var_s2, var_maze);
  logger(log_string);

  
  [A, fr_maze] = getResource(A, 'FRateMaze', dsets_full);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_full);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_full);  
  [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_full);
  [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_full);

  if do_pyramids_only
    pyr = pyr_full;
    fr_maze = fr_maze(pyr);
    fr_s1 = fr_s1(pyr);
    fr_s2 = fr_s2(pyr);
    fr_run = fr_run(pyr);
    fr_rew = fr_rew(pyr);
  end
  
  [EVrich, EVrrich, EVrich_int, EVrrich_int] = ...
      ReactEV(log(fr_s1), log(fr_s2), log(fr_maze));
  
  var_s1 = var(log(fr_s1(fr_s1 > 0)));
  var_s2 = var(log(fr_s2(fr_s2 > 0)));
  var_maze = var(log(fr_maze(fr_maze > 0)));
  log_string = sprintf('rich : var(S1) = %g, var(S2) = %g, var(maze) = %g\n', ...
		       var_s1, var_s2, var_maze);
  logger(log_string);
  
  
  log_string = sprintf(['rich: EV = %g (%g,%g), EVr = %g (%g,%g)\n',...
		    'poor: EV = %g (%g,%g), EVr = %g (%g,%g)\n'], ...
		       EVrich, EVrich_int(1), EVrich_int(2),...
		       EVrrich, EVrrich_int(1), EVrrich_int(2),...
		       EVpoor, EVpoor_int(1), EVpoor_int(2), ...
		       EVrpoor, EVrpoor_int(1), EVrpoor_int(2));
  
  logger(log_string);
  
  
  [EVrew, EVrrr, EVrew_int, EVrrr_int] = ...
      ReactEV(log(fr_rew), log(fr_s2), log(fr_run));
  [EVrrew, EVrrr, EVrrew_int, EVrrr_int] = ...
      ReactEV(log(fr_rew), log(fr_s1), log(fr_run));

  
  
  
  log_string = sprintf('reward: EV = %g (%g,%g), EVr = %g (%g,%g)\n',...
		       EVrew, EVrew_int(1), EVrew_int(2),...
		       EVrrew, EVrrew_int(1), EVrrew_int(2));
  
  logger(log_string);
  