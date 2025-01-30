function ReactRateSim2()
  
  n_cells = 100000;
  

  fig_dir = '/home/fpbatta/DIRAC/posterSFN04/';

  
  %variances = [0.2 0.5 0.7 0.9 1.0 1.1 1.3 2 4 8];
  variances = [0.5 0.7 0.8 0.9 0.95 1 1.05 1.1 1.2 1.4 1.6 2];

  % now let's consider the case in which  rates in sleep are not
  % independent, the rate in sleep 2 being a noisy function of rate in
  % maze, as the variance in maze changes, but with var_S2 constantly at 1
  
  EV0 = [0. 0.1]; % how much of the variance in sleep2 is explained by maze
  EVr0 = [0. 0.02];
  str = {'independent case', '"reactivation" case'}
  nfig = 1;
  for n = 1:2
    for i = 1:length(variances)
      for j = 1:length(variances)
	
	
	var_0 = 1;
	var_M = 1;
	var_S = 1;
	var_S1 = variances(i);
	var_S2 = variances(j);
	ev0 = EV0(n);
	evr0 = EVr0(n);
	
	x_0 = randn(n_cells, 1) * sqrt(var_0); 
	x_S = randn(n_cells, 1) * sqrt(var_S); 
	
	x_M =  randn(n_cells, 1) * sqrt(var_M);  
	
	x_S1 = sqrt(var_S1 *evr0/var_M) * x_M + sqrt(var_S1 *(1-evr0)) * randn(n_cells, 1);
	x_S2 = sqrt(var_S2 *ev0/var_M) * x_M + sqrt(var_S2 *(1-ev0)) * randn(n_cells, 1);
	logFrate_M = x_0 + x_M;
	logFrate_S1 = x_0 + x_S + x_S1;
	logFrate_S2 = x_0 + x_S + x_S2;
	
	
	X_MS1 =  logFrate_M - logFrate_S1;
	X_MS2 = logFrate_M - logFrate_S2;
	X_S2S1 = logFrate_S2 - logFrate_S1;
	
	[a, b, r, p] = regression_line(X_MS1, X_S2S1);
	cc_corr(j,i) = r; % the correlation 
	slope_corr(j,i) = b; 
	[EV(j,i), EVr(j,i)] = ReactEV(logFrate_S1, logFrate_S2, logFrate_M);
      end
    end
    
    figure(nfig);
    nfig = nfig + 1;
    surf(variances, variances, EV)
    axis([0 2 0 2 0 1])
    xlabel('var(S1)')
    ylabel('var(S2)')
    zlabel('EV')
    title(sprintf('%s EV ', str{n}));
    print('-djpeg', sprintf('EV%d.jpg', n));
    
    
    figure(nfig);
    nfig = nfig + 1;
    surf(variances, variances, EVr)
    axis([0 2 0 2 0 1])
    xlabel('var(S1)')
    ylabel('var(S2)')
    zlabel('EVr')
    title(sprintf('%s EVr ', str{n}));
    print('-djpeg', sprintf('EV%dr.jpg', n));
    
    
    figure(nfig);
    nfig = nfig + 1;
    surf(variances, variances, EV - EVr)
    axis([0 2 0 2 0 1])
    xlabel('var(S1)')
    ylabel('var(S2)')
    zlabel('EV - EVr')
    title(sprintf('%s EV - EVr', str{n}));
    print('-djpeg', sprintf('EVdiff%d.jpg', n));

    figure(nfig);
    nfig = nfig + 1;
    surf(variances, variances, cc_corr)
    axis([0 2 0 2 0 1])
    xlabel('var(S1)')
    ylabel('var(S2)')
    zlabel('X-X corr')
    title(sprintf('%s X-X corr ', str{n}));
    print('-djpeg', sprintf('XXCorr%d.jpg', n));

    keyboard
     
     
     
  end
  
  
  
  
  
    
