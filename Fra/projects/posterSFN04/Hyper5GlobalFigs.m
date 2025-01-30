function fig_st = Hyper5GlobalFigs()
  
  exp_dir = '/home/fpbatta/Data/Hyper5/';
  load( [exp_dir filesep  'ReactRateHyper5']);
  
  
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
  
  
  
  
  fig_direct.xLabel = 'X_{MS1}';
  fig_direct.yLabel = 'X_{S2S1}';
  fig_direct.figureName = 'Hyper5GlobalReactDirect';  
  
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
  fig_inverse.figureName = 'Hyper5GlobalReactInverse';  
  
  [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
  
  log_string = ...
      ['global rate react, inverse, all cells',  newline, ...
       'slope = ' num2str(br), ' intercept = ', num2str(ar), newline, ...
       'correlation = ', num2str(r(1,2)), ' (', num2str(clo(1,2)), ',', ...
      num2str(chi(1,2)), ')'];
  
  logger(log_string);
  

%%%%%%%%%%%%%%%%%%%%%%55


 fig_direct2.x{1} = X_M2S2;
  fig_direct2.n{1} = X_S3S2;
  x = [-3:3];
  [a, b, r, p] = regression_line(X_M2S2, X_S3S2);
  fig_direct2.x{2} = x;
  fig_direct2.n{2} = a + b * x;

  [r, clo, chi] = nancorrcoef(X_M2S2, X_S3S2);
  
  log_string = ...
      ['global rate react, direct2, all cells',  newline, ...
       'slope = ' num2str(b), ' intercept = ', num2str(a), newline, ...
       'correlation = ', num2str(r(1,2)), ' (', num2str(clo(1,2)), ',', ...
      num2str(chi(1,2)), ')'];
  
  logger(log_string);
  
  
  
  
  fig_direct2.xLabel = 'X_{M2S2}';
  fig_direct2.yLabel = 'X_{S3S2}';
  fig_direct2.figureName = 'Hyper5GlobalReactDirect2';  
  
  fig_direct2.style{1} = 'k.';
  fig_direct2.style{2} = 'k-';  
  fig_direct2.figureType = 'plot';

  fig_direct2.axesProperties = {'DataAspectRatio', [1 1 1]};
  
  
  fig_inverse2 = fig_direct2;
  
  
  fig_inverse2.x{1} = X_M2S3;
  fig_inverse2.n{1} = - X_S3S2;
  x = [-3:3];
  [ar, br, rr, pr] = regression_line(X_M2S3, - X_S3S2);
    
  fig_inverse2.x{2} = x;
  fig_inverse2.n{2} = ar + br * x;
  fig_inverse2.xLabel = 'X_{M2S3}';
  fig_inverse2.yLabel = 'X_{S2S3}';
  fig_inverse2.figureName = 'Hyper5GlobalReactInverse2';  
  
  [r, clo, chi] = nancorrcoef(X_M2S3, - X_S3S2);
  
  log_string = ...
      ['global rate react, inverse2, all cells',  newline, ...
       'slope = ' num2str(br), ' intercept = ', num2str(ar), newline, ...
       'correlation = ', num2str(r(1,2)), ' (', num2str(clo(1,2)), ',', ...
      num2str(chi(1,2)), ')'];
  
  logger(log_string);
  
  fig_st = {fig_direct, fig_inverse, fig_direct2, fig_inverse2};
  
  