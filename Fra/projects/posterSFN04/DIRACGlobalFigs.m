function fig_st = DIRACGlobalFigs()
  
  A = Analysis('/home/fpbatta/Data/DIRAC/');
  dsets = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1.list');
  [A, fr_maze] = getResource(A, 'FRateMaze', dsets);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
  [A, fr_pres1] = getResource(A, 'FRatePreSleep1', dsets);  
  [A, fr_posts2] = getResource(A, 'FRatePostSleep2', dsets);  

% $$$   
% $$$   [A, int] = getResource(A, 'IsInterneuron', dsets);
% $$$   pyr = find(~int);
  [A, pyr] = getResource(A, 'IsPyramid', dsets);
  pyr = find(pyr);
  
  fr_maze = fr_maze(pyr);
  fr_s1 = fr_s1(pyr);
  fr_s2 = fr_s2(pyr);
  fr_pres1 = fr_pres1(pyr);
  fr_posts2 = fr_posts2(pyr);
  
  
  X_MS1 = log10(fr_maze ./ fr_pres1);
  X_S2S1 = log10(fr_s2 ./ fr_s1);
  X_MS2 = log10(fr_maze ./ fr_posts2);
  
  
  
  fig_direct.x{1} = X_MS1;
  fig_direct.n{1} = X_S2S1;
  x = [-3:3];
  [a, b, r, p] = regression_line(X_MS1, X_S2S1);
  fig_direct.x{2} = x;
  fig_direct.n{2} = a + b * x;

  [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
  
  log_string = ...
      ['global rate react, direct, all cells',  newline, ...
       'slope = ' num2str(b), ' intercept = ', num2str(a), newline, ...
       'correlation = ', num2str(r(1,2)), ' (', num2str(clo(1,2)), ',', ...
      num2str(chi(1,2)), ')'];
  
  logger(log_string);
  
  
  
  
  fig_direct.xLabel = 'R_{MS1}';
  fig_direct.yLabel = 'R_{S2S1}';
  fig_direct.figureName = 'DIRACGlobalCVReactDirect';  
  
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
  fig_inverse.xLabel = 'R_{MS2}';
  fig_inverse.yLabel = 'R_{S1S2}';
  fig_inverse.figureName = 'DIRACGlobalCVReactInverse';  
  
  [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
  
  log_string = ...
      ['global rate react, inverse, all cells',  newline, ...
       'slope = ' num2str(br), ' intercept = ', num2str(ar), newline, ...
       'correlation = ', num2str(r(1,2)), ' (', num2str(clo(1,2)), ',', ...
      num2str(chi(1,2)), ')'];
  
  logger(log_string);
  

  
  fig_st = {fig_direct, fig_inverse};
  
  