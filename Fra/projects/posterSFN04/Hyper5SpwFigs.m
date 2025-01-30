function fig_st = Hyper5SpwFigs()
  
  exp_dir = '/home/fpbatta/Data/Hyper5';
  dsets = List2Cell(['/home/fpbatta/Data/Hyper5', filesep, ...
		     'dirs_Hyper5.list']);
  
  
  A = Analysis('/home/fpbatta/Data/Hyper5');

  do_pyramids_only = 1;
  
 
  cellclass = 'all';
 
  if do_pyramids_only 
    cellclass = 'pyramidal';
  end
    

  
  
  
 
  [A, fr_maze] = getResource(A, 'FRateMaze', dsets);
  [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets);  
  [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets);  
  [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets);  
  [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets);  
 
  X_MS1_s = log10(fr_maze ./ fr_s_s1);
  X_MS2_s = log10(fr_maze ./ fr_s_s2);  
  X_S2S1_s = log10(fr_s_s2 ./ fr_s_s1);
  
  X_MS1_n = log10(fr_maze ./ fr_n_s1);
  X_MS2_n = log10(fr_maze ./ fr_n_s2);  
  X_S2S1_n = log10(fr_n_s2 ./ fr_n_s1);
  
  keyboard
  

  if do_pyramids_only
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
    
  
    ok1 = fr_maze > 0.7 | fr_s1 > 0.7 | fr_s2 > 0.7;
    ok2 = fr_maze < 20 & fr_maze < 20 & fr_maze < 20;
  
    pyr = find( ok1 & ok2);
    
    fr_maze = fr_maze(pyr);
    fr_s1 = fr_s1(pyr);
    fr_s2 = fr_s2(pyr);
    
    X_MS1_s = X_MS1_s(pyr);
    X_MS2_s = X_MS2_s(pyr);
    X_S2S1_s = X_S2S1_s(pyr);
    X_MS1_n = X_MS1_n(pyr);
    X_MS2_n = X_MS2_n(pyr);
    X_S2S1_n = X_S2S1_n(pyr);
  end

  
  
  
  
  
  
   
  fig_direct.x{1} = X_MS1_s;
  fig_direct.n{1} = X_S2S1_s;
  x = [-3:3];
  [a, b, r, p] = regression_line(X_MS1_s, X_S2S1_s);
  fig_direct.x{2} = x;
  fig_direct.n{2} = a + b * x;

  [r, clo, chi] = nancorrcoef(X_MS1_s, X_S2S1_s);
  
  log_string = sprintf(['sharp wave rate react, direct poor track, ' cellclass ' cells\n', ...
		    ' n']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      b, a, r(1,2), clo(1,2), chi(1,2))];
  
  logger(log_string);
  
  
  
  
  fig_direct.xLabel = 'X^{spw}_{MS1}';
  fig_direct.yLabel = 'X^{spw}_{S2S1}';
  fig_direct.figureName = 'Hyper5SpwReactDirect';  
  
  fig_direct.style{1} = 'k.';
  fig_direct.style{2} = 'k-';  
  fig_direct.figureType = 'plot';

  fig_direct.axesProperties = {'DataAspectRatio', [1 1 1]};
  
  
  fig_inverse = fig_direct;
  
  
  fig_inverse.x{1} = X_MS2_s;
  fig_inverse.n{1} = - X_S2S1_s;
  x = [-3:3];
  [ar, br, rr, pr] = regression_line(X_MS2_s, - X_S2S1_s);
    
  fig_inverse.x{2} = x;
  fig_inverse.n{2} = ar + br * x;
  fig_inverse.xLabel = 'X^{spw}_{MS2}';
  fig_inverse.yLabel = 'X^{spw}_{S1S2}';
  fig_direct.figureName = 'DIRACPoorSpwReactInverse';  
  
  [r, clo, chi] = nancorrcoef(X_MS2_s, - X_S2S1_s);
  
		
  log_string = sprintf(['sharp wave rate react, inverse poor track, ' cellclass ' cells\n', ...
		    '']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      br, ar, r(1,2), clo(1,2), chi(1,2))];
		
		
   %%%%%%%%%%%%%%%%%% no SPW  
   
  logger(log_string);
  
  fig_ndirect.x{1} = X_MS1_n;
  fig_ndirect.n{1} = X_S2S1_n;
  x = [-3:3];
  [a, b, r, p] = regression_line(X_MS1_n, X_S2S1_n);
  fig_ndirect.x{2} = x;
  fig_ndirect.n{2} = a + b * x;

  [r, clo, chi] = nancorrcoef(X_MS1_n, X_S2S1_n);
  
  log_string = sprintf(['no sharp wave rate react, direct poor track, ' cellclass ' cells\n', ...
		    ' n']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      b, a, r(1,2), clo(1,2), chi(1,2))];
  
  logger(log_string);
  
  
  
  fig_ndirect.xLabel = 'X^{nospw}_{MS1}';
  fig_ndirect.yLabel = 'X^{nospw}_{S2S1}';
  fig_ndirect.figureName = 'DIRACPoorNoSpwReactDirect';  
  
  fig_ndirect.style{1} = 'k.';
  fig_ndirect.style{2} = 'k-';  
  fig_ndirect.figureType = 'plot';

  fig_ndirect.axesProperties = {'DataAspectRatio', [1 1 1]};
  
  
  fig_ninverse = fig_ndirect;
  
  
  fig_ninverse.x{1} = X_MS2_n;
  fig_ninverse.n{1} = - X_S2S1_n;
  x = [-3:3];
  [ar, br, rr, pr] = regression_line(X_MS2_n, - X_S2S1_n);
    
  fig_ninverse.x{2} = x;
  fig_ninverse.n{2} = ar + br * x;
  fig_ninverse.xLabel = 'X^{nospw}_{MS2}';
  fig_ninverse.yLabel = 'X^{nospw}_{S1S2}';
  fig_ninverse.figureName = 'DIRACPoorNoSpwReactInverse';  
  
  [r, clo, chi] = nancorrcoef(X_MS2_n, - X_S2S1_n);
  
		
  log_string = sprintf(['no sharp wave rate react, inverse poor track, ' cellclass ' cells\n', ...
		    '']);
  log_string = [log_string sprintf(...
      'slope = %g, intesect = %g, correlation = %g (%g,%g)\n', ...
      br, ar, r(1,2), clo(1,2), chi(1,2))];
		
		
 
  logger(log_string);
  
  fig_st = {fig_direct, fig_inverse, fig_ndirect, fig_ninverse };

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
				
		

		
		
  [A, fr_maze] = getResource(A, 'FRateMaze', dsets);
  [A, fr_s1] = getResource(A, 'FRateSPWSleep1', dsets);  
  [A, fr_s2] = getResource(A, 'FRateSPWSleep2', dsets);  

  if do_pyramids_only
    fr_maze = fr_maze(pyr);
    fr_s1 = fr_s1(pyr);
    fr_s2 = fr_s2(pyr);
  end
  
  
  [EVpoor, EVrpoor, EVpoor_int, EVrpoor_int] = ...
      ReactEV(log(fr_s1), log(fr_s2), log(fr_maze));
  

  
  log_string = sprintf(['SPW : EV = %g (%g,%g), EVr = %g (%g,%g)\n'], ...
		       EVpoor, EVpoor_int(1), EVpoor_int(2), ...
		       EVrpoor, EVrpoor_int(1), EVrpoor_int(2));
  
  logger(log_string);
  

  
  %%% EV for the  no SPW 
  
  [A, fr_maze] = getResource(A, 'FRateMaze', dsets);
  [A, fr_s1] = getResource(A, 'FRateNoSPWSleep1', dsets);  
  [A, fr_s2] = getResource(A, 'FRateNoSPWSleep2', dsets);  

  if do_pyramids_only
    fr_maze = fr_maze(pyr);
    fr_s1 = fr_s1(pyr);
    fr_s2 = fr_s2(pyr);
  end
  
  
  [EVpoor, EVrpoor, EVpoor_int, EVrpoor_int] = ...
      ReactEV(log(fr_s1), log(fr_s2), log(fr_maze));

  log_string = sprintf(['No SPW : EV = %g (%g,%g), EVr = %g (%g,%g)\n'], ...
		       EVpoor, EVpoor_int(1), EVpoor_int(2), ...
		       EVrpoor, EVrpoor_int(1), EVrpoor_int(2));
  
  logger(log_string);
  
