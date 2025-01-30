function fig_st = DIRACGlobalPyrIntFigs()
  
  
  dsets = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1.list');
  
  
  A = Analysis('/home/fpbatta/Data/DIRAC/');

  [A, X_MS1t] = getResource(A, 'X_MS1', dsets);
  [A, X_MS2t] = getResource(A, 'X_MS2', dsets);  
  [A, X_S2S1t] = getResource(A, 'X_S2S1', dsets);  

  
  [A, isInt] = getResource(A, 'IsInterneuron', dsets);  

  [A, fr_maze] = getResource(A, 'FRateMaze', dsets);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
  
  ok1 = fr_maze > 0.7 | fr_s1 > 0.7 | fr_s2 > 0.7;
  ok2 = fr_maze < 20 & fr_maze < 20 & fr_maze < 20;
  
  pyr = find(~isInt & ok1 & ok2);
  int = find(isInt);
  
  
  
  
  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% do the pyramids   
  
  X_MS1 = X_MS1t(pyr);
  X_MS2 = X_MS2t(pyr);
  X_S2S1 = X_S2S1t(pyr);
  

  fig_direct.x{1} = X_MS1;
  fig_direct.n{1} = X_S2S1;
  x = [-3:3];
  [a, b, r, p] = regression_line(X_MS1, X_S2S1);
  fig_direct.x{2} = x;
  fig_direct.n{2} = a + b * x;

  [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
  
  [EV, EVr EV_int EVr_int] = ReactEV(log(fr_s1(pyr)), log(fr_s2(pyr)), ...
				     log(fr_maze(pyr)));
  
  
  
  
  log_string = sprintf(['pyramidal cells global rate react, direct \n', ...
		    '']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      b, a, r(1,2), clo(1,2), chi(1,2))];
  log_string = [log_string sprintf(...
      'EV = %g (%g,%g), EVr = %g (%g,%g)', ...
      EV, EV_int(1), EV_int(2), EVr, EVr_int(1), EVr_int(2))];
		
  
  logger(log_string);
  
  
  
  
  fig_direct.xLabel = 'X_{MS1}';
  fig_direct.yLabel = 'X_{S2S1}';
  fig_direct.figureName = 'DIRACPyrGlobalReactDirect';  
  
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
  fig_inverse.figureName = 'DIRACPyrGlobalReactInverse';  
  
  [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
  
		
  log_string = sprintf(['pyramidal cells global rate react, inverse\n', ...
		    '']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      br, ar, r(1,2), clo(1,2), chi(1,2))];
		
		
 
  logger(log_string);
  fig_st = {fig_direct, fig_inverse};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% do the interneurons   
  
  X_MS1 = X_MS1t(int);
  X_MS2 = X_MS2t(int);
  X_S2S1 = X_S2S1t(int);


  fig_direct.x{1} = X_MS1;
  fig_direct.n{1} = X_S2S1;
  x = [-3:3];
  [a, b, r, p] = regression_line(X_MS1, X_S2S1);
  fig_direct.x{2} = x;
  fig_direct.n{2} = a + b * x;

  [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
  
  log_string = sprintf(['interneuronal cells global rate react, direct \n', ...
		    '']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      b, a, r(1,2), clo(1,2), chi(1,2))];
  
  logger(log_string);
  
  
  
  
  fig_direct.xLabel = 'X_{MS1}';
  fig_direct.yLabel = 'X_{S2S1}';
  fig_direct.figureName = 'DIRACPyrGlobalReactDirect';  
  
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
  fig_inverse.figureName = 'DIRACPyrGlobalReactInverse';  
  
  [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
  
		
  log_string = sprintf(['interneuronal cells global rate react, inverse\n', ...
		    '']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      br, ar, r(1,2), clo(1,2), chi(1,2))];
		
		
 
  logger(log_string);
  
		
		


  
  fig_st = [fig_st {fig_direct, fig_inverse}];
				
		

		

  