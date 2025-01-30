function fig_st = CRAMRatePairCompareFigs()
  
  
  
  
  dsets = List2Cell('/home/fpbatta/Data/CRAM/dirs_CRAM.list');
  A = Analysis('/home/fpbatta/Data/CRAM/');

  
  
  [A, EV] = getResource(A, 'ReactEV', dsets);
  [A, EVr] = getResource(A, 'ReactEVr', dsets);  

  [A, PyrEV] = getResource(A, 'ReactPyrEV', dsets);
  [A, PyrEVr] = getResource(A, 'ReactPyrEVr', dsets);  

  
  [A, r] = getResource(A, 'ReactGlobalR', dsets);
  [A, r_rev] = getResource(A, 'ReactGlobalRRev', dsets);
  
  [A, XX] = getResource(A, 'SMReactCVXX', dsets);

  
  [A, PairEV] = getResource(A, 'PairEV', dsets);
  [A, PairEVr] = getResource(A, 'PairEVr', dsets);  
  
  [A, PairPyrEV] = getResource(A, 'PairPyrEV', dsets);
  [A, PairPyrEVr] = getResource(A, 'PairPyrEVr', dsets);  
  
% $$$   fig.x{1} = EV-EVr;
% $$$   fig.n{1} = PairEV-PairEVr;
  R = XX;
  
  fig.x{1} = R(7:end);
  fig.n{1} = PairEV(7:end);
  fig.style{1} = 'k.';
  
  [a, b, r, p] = regression_line(R(7:end), PairEV(7:end));
  
  xx = -0.1:0.1:0.9;
  
  fig.x{2} = xx;
  fig.n{2} = a + b * xx;
  fig.style{2} = 'k-';
  fig.lineProperties{1} = {'MarkerSize', 20};
  fig.lineProperties{2} = [];
  fig.figureType = 'plot';

  fig.axesProperties = {'DataAspectRatio', [1 1 1]};

  fig.figureName = 'CRAMRatePairCompare';
  
  [r2_large, clo_large, chi_large] = nancorrcoef(R(7:end), PairEV(7:end), 'bootstrap');
  [r2_small, clo_small, chi_small] = nancorrcoef(R(1:6), PairEV(1:6), 'bootstrap');
   [r2_tot, clo_tot, chi_tot] = nancorrcoef(R, PairEV, 'fisher');
  
  
  log_string = sprintf('large track: correlation between rate and pair EV = %g (%g,%g)\n', ...
		       r2_large(1,2), clo_large(1,2), chi_large(1,2));
  
  log_string = [log_string sprintf('small track: correlation between rate and pair EV = %g (%g,%g)\n', ...
		       r2_small(1,2), clo_small(1,2), chi_small(1,2))];
  logger(log_string);
  
  log_string = [log_string sprintf('all tracks: correlation between rate and pair EV = %g (%g,%g)\n', ...
				   r2_tot(1,2), clo_tot(1,2), chi_tot(1,2))];
  logger(log_string);
  
  
  
  
  fig_st = { fig };