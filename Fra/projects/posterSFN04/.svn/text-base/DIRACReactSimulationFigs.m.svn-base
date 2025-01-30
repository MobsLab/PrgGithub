function DIRACReactSimulationFigs()
  
  n_cells = 10000;
  
  var_S1 = 1;
  var_S2 = 1;
  var_M = 1;
  
  % let's simulated rates as log-normal distributed, with variances as
  % above, let's assume that rates in the three epochs are statistically independent
  
  % note that very similar variances in sleep and maze are the situation
  % we found in cortex 
  
  logFrate_S1 = randn(n_cells, 1) * sqrt(var_S1);
  logFrate_S2 = randn(n_cells, 1) * sqrt(var_S2);
  logFrate_M = randn(n_cells, 1) * sqrt(var_M);  
  
  
  X_MS1 =  logFrate_M - logFrate_S1;
  X_MS2 = logFrate_M - logFrate_S2;
  X_S2S1 = logFrate_S2 - logFrate_S1;
  

  variances = [0.2 0.5 0.7 0.9 1.0 1.1 1.3 2 4 8];
  
  for i = 1:length(variances)
    var_M = variances(i);
    logFrate_M = randn(n_cells, 1) * var_M;  
  
    X_MS1 =  logFrate_M - logFrate_S1;
    X_MS2 = logFrate_M - logFrate_S2;
    X_S2S1 = logFrate_S2 - logFrate_S1;
 
    [a, b, r, p] = regression_line(X_MS1, X_S2S1);
    cc(i) = r; % the correlation 
    slope(i) = b; 
  end
  
  
  figure(3)
  
  plot(variances, slope)
  hold on
  plot(variances, cc, 'r')
  legend({'slope', 'correlation'});
  xlabel('variances')
  
  
  keyboard
  
  
  
  % now let's consider the case in which  rates in sleep are not
  % independent, the rate in sleep 2 being a noisy function of rate in
  % maze, as the variance in maze changes, but with var_S2 constantly at 1
  
  EV = 0.1; % how much of the variance in sleep2 is explained by maze
  
  for i = 1:length(variances)
    var_M = variances(i);
    logFrate_M = randn(n_cells, 1) * sqrt(var_M);  
    logFrate_S1 = randn(n_cells, 1) * sqrt(var_S1);
    logFrate_S2 = sqrt(EV/var_M) * logFrate_M + sqrt(1-EV/var_S2) * randn(n_cells, 1) * var_S2;

    X_MS1 =  logFrate_M - logFrate_S1;
    X_MS2 = logFrate_M - logFrate_S2;
    X_S2S1 = logFrate_S2 - logFrate_S1;
 
    [a, b, r, p] = regression_line(X_MS1, X_S2S1);
    cc_corr(i) = r; % the correlation 
    slope_corr(i) = b; 
  end
  
  
    
  figure(3)
  clf
  plot(variances, slope)
  hold on
  plot(variances, cc, 'r')
  plot(variances, slope_corr, 'g')
  plot(variances, cc_corr, 'm')
  
  
  legend({'slope', 'correlation', 'slope (corr)', 'correaltion (corr)'});
  xlabel('variances')
  
  % so the effect is here that when the variance of maze is small the
  % effect of statistical dependence between maze and sleep 2 on the
  % correlation is also small
  
  keyboard
  
  
  % now let's how the correlation changes as a fucntion of EV, at 
  % var_M = 1
  
  EVs = [0 0.001 0.01 0.1 0.2 0.4];
  var_M = 1;
  
   for i = 1:length(EVs)
     EV = EVs(i);
     logFrate_M = randn(n_cells, 1) * sqrt(var_M);  
    logFrate_S1 = randn(n_cells, 1) * sqrt(var_S1);
    logFrate_S2 = sqrt(EV/var_M) * logFrate_M + sqrt(1-EV/var_S2) * randn(n_cells, 1) * var_S2;

    X_MS1 =  logFrate_M - logFrate_S1;
    X_MS2 = logFrate_M - logFrate_S2;
    X_S2S1 = logFrate_S2 - logFrate_S1;
 
    [a, b, r, p] = regression_line(X_MS1, X_S2S1);
    cc_EV(i) = r; % the correlation 
    slope_EV(i) = b; 
  end
  
  figure(4)
  
  plot(EVs, slope_EV)
  hold on 
  plot(EVs, cc_EV, 'r')
  legend({'slope', 'correlation'})
  xlabel('EV')