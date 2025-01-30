function fig_st = DIRACRatePairCompareFigs()
  
  
  do_large_dsets_only = 1;
  do_non_spw = 0;
  do_spw = 0;
  
  dsets_empty = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_empty.list');
  dsets_full = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_full.list');
  A = Analysis('/home/fpbatta/Data/DIRAC/');

  
  warning off MATLAB:divideByZero
  warning off
  
  
  [A, cn_empty] = getResource(A, 'HippoCellList', dsets_empty);
  cn_empty = cellnames_idx;
  

  [A, PyrEV] = getResource(A, 'ReactPyrEV', dsets_empty);
  [A, PyrEVr] = getResource(A, 'ReactPyrEVr', dsets_empty);  

  
  if do_spw 
    [A, PairEV_empty] = getResource(A, 'PairEVSPW', dsets_empty);
    [A, PairEVr_empty] = getResource(A, 'PairEVrSPW', dsets_empty);  
    
    [A, PairPyrEV] = getResource(A, 'PairPyrEV', dsets_empty);
    [A, PairPyrEVr] = getResource(A, 'PairPyrEVr', dsets_empty);  

    [A, frate_maze_empty] = getResource(A, 'FRateMaze', dsets_empty);    
    [A, frate_spw_sleep1_empty] = getResource(A, 'FRateSPWSleep1', dsets_empty); 
    [A, frate_spw_sleep2_empty] = getResource(A, 'FRateSPWSleep2', dsets_empty);     
    for i = 1:length(dsets_empty)
      ix = find(frate_maze_idx == i);
      x_MS1 = log10(frate_maze_empty(ix) ./ frate_spw_sleep1_empty(ix));
      x_MS2 = log10(frate_maze_empty(ix) ./ frate_spw_sleep2_empty(ix));
      
      x_S2S1 = log10(frate_spw_sleep2_empty(ix) ./ frate_spw_sleep1_empty(ix));
      [a, b, r_empty(i), pval] = regression_line(x_MS1, x_S2S1);
      [a, b, r_rev_empty(i), pval] = regression_line(x_MS2, - x_S2S1);
      [EV_empty(i), EVr_empty(i)] = ReactEV(frate_spw_sleep1_empty(ix), ...
				      frate_spw_sleep2_empty(ix), ...
				      frate_maze_empty(ix));
    end % for i = 1:length(dsets_empty)
       
    EV_empty = EV_empty';  
    EVr_empty = EVr_empty';  	
    
    
  elseif do_non_spw
    
    [A, PairEV_empty] = getResource(A, 'PairEVNoSPW', dsets_empty);
    [A, PairEVr_empty] = getResource(A, 'PairEVrNoSPW', dsets_empty);  
    
    [A, PairPyrEV_empty] = getResource(A, 'PairPyrEV', dsets_empty);
    [A, PairPyrEVr_empty] = getResource(A, 'PairPyrEVr', dsets_empty);  

    [A, frate_maze_empty] = getResource(A, 'FRateMaze', dsets_empty);    
    [A, frate_no_spw_sleep1_empty] = getResource(A, 'FRateNoSPWSleep1', dsets_empty); 
    [A, frate_no_spw_sleep2_empty] = getResource(A, 'FRateNoSPWSleep2', dsets_empty);     
    for i = 1:length(dsets_empty)
      ix = find(frate_maze_idx == i);
      x_MS1 = log10(frate_maze_empty(ix) ./ frate_no_spw_sleep1_empty(ix));
      x_MS2 = log10(frate_maze_empty(ix) ./ frate_no_spw_sleep2_empty(ix));
      
      x_S2S1 = log10(frate_no_spw_sleep2_empty(ix) ./ frate_no_spw_sleep1_empty(ix));
      [a, b, r_empty(i), pval] = regression_line(x_MS1, x_S2S1);
      [a, b, r_rev_empty(i), pval] = regression_line(x_MS2, - x_S2S1);
      [EV_empty(i), EVr_empty(i)] = ReactEV(frate_no_spw_sleep1_empty(ix), ...
				      frate_no_spw_sleep2_empty(ix), ...
				      frate_maze_empty(ix));
    end % for i = 1:length(dsets_empty)
       
    EV_empty = EV_empty';  
    EVr_empty = EVr_empty';  	
    
    
  else
    
    [A, r_empty] = getResource(A, 'ReactGlobalR', dsets_empty);
    [A, r_rev_empty] = getResource(A, 'ReactGlobalRRev', dsets_empty);

    [A, PairEV_empty] = getResource(A, 'PairEV', dsets_empty);
    [A, PairEVr_empty] = getResource(A, 'PairEVr', dsets_empty);  
    
    [A, PairPyrEV_empty] = getResource(A, 'PairPyrEV', dsets_empty);
    [A, PairPyrEVr_empty] = getResource(A, 'PairPyrEVr', dsets_empty);  
  
    [A, EV_empty] = getResource(A, 'ReactEV', dsets_empty);
    [A, EVr_empty] = getResource(A, 'ReactEVr', dsets_empty);  
    [A, XX_empty] = getResource(A, 'SMReactCVXX', dsets_empty);
  end
  
  [A, cn_full] = getResource(A, 'HippoCellList', dsets_full);
  cn_full = cellnames_idx;
  

  [A, PyrEV] = getResource(A, 'ReactPyrEV', dsets_full);
  [A, PyrEVr] = getResource(A, 'ReactPyrEVr', dsets_full);  

  
  [A, r_full] = getResource(A, 'ReactGlobalR', dsets_full);
  [A, r_rev_full] = getResource(A, 'ReactGlobalRRev', dsets_full);
  
  
  

  
  if do_spw
    [A, PairPyrEV_full] = getResource(A, 'PairEVSPW', dsets_full);
    [A, PairPyrEVr_full] = getResource(A, 'PairEVrSPW', dsets_full);  

    [A, frate_spw_sleep1_full] = getResource(A, 'FRateSPWSleep1', dsets_full); 
    [A, frate_spw_sleep2_full] = getResource(A, 'FRateSPWSleep2', dsets_full);     
    [A, frate_maze_full] = getResource(A, 'FRateMaze', dsets_full);    
    
    for i = 1:length(dsets_full)
      ix = find(frate_maze_idx == i);
      x_MS1 = log10(frate_maze_full(ix) ./ frate_spw_sleep1_full(ix));
      x_MS2 = log10(frate_maze_full(ix) ./ frate_spw_sleep2_full(ix));
      
      x_S2S1 = log10(frate_spw_sleep2_full(ix) ./ frate_spw_sleep1_full(ix));
      [a, b, r_full(i), pval] = regression_line(x_MS1, x_S2S1);
      [a, b, r_rev_full(i), pval] = regression_line(x_MS2, - x_S2S1);
      [EV_full(i), EVr_full(i)] = ReactEV(frate_spw_sleep1_full(ix), ...
				      frate_spw_sleep2_full(ix), ...
				      frate_maze_full(ix));
      
    end % for i = 1:length(dsets_full)
    EV_full = EV_full';  
    EVr_full = EVr_full';  	

  elseif do_non_spw
    
    [A, PairEV_full] = getResource(A, 'PairEVNoSPW', dsets_full);
    [A, PairEVr_full] = getResource(A, 'PairEVrNoSPW', dsets_full);  
    
    [A, PairPyrEV_full] = getResource(A, 'PairPyrEV', dsets_full);
    [A, PairPyrEVr_full] = getResource(A, 'PairPyrEVr', dsets_full);  

    [A, frate_maze_full] = getResource(A, 'FRateMaze', dsets_full);    
    [A, frate_no_spw_sleep1_full] = getResource(A, 'FRateNoSPWSleep1', dsets_full); 
    [A, frate_no_spw_sleep2_full] = getResource(A, 'FRateNoSPWSleep2', dsets_full);     
    for i = 1:length(dsets_full)
      ix = find(frate_maze_idx == i);
      x_MS1 = log10(frate_maze_full(ix) ./ frate_no_spw_sleep1_full(ix));
      x_MS2 = log10(frate_maze_full(ix) ./ frate_no_spw_sleep2_full(ix));
      
      x_S2S1 = log10(frate_no_spw_sleep2_full(ix) ./ frate_no_spw_sleep1_full(ix));
      [a, b, r_full(i), pval] = regression_line(x_MS1, x_S2S1);
      [a, b, r_rev_full(i), pval] = regression_line(x_MS2, - x_S2S1);
      [EV_full(i), EVr_full(i)] = ReactEV(frate_no_spw_sleep1_full(ix), ...
				      frate_no_spw_sleep2_full(ix), ...
				      frate_maze_full(ix));
    end % for i = 1:length(dsets_full)
       
    EV_full = EV_full';  
    EVr_full = EVr_full';  	
  else
    [A, PairPyrEV_full] = getResource(A, 'PairPyrEV', dsets_full);
    [A, PairPyrEVr_full] = getResource(A, 'PairPyrEVr', dsets_full);  
    [A, EV_full] = getResource(A, 'ReactEV', dsets_full);
    [A, EVr_full] = getResource(A, 'ReactEVr', dsets_full);  
    [A, PairEV_full] = getResource(A, 'PairEV', dsets_full);
    [A, PairEVr_full] = getResource(A, 'PairEVr', dsets_full);  
    [A, XX_full] = getResource(A, 'SMReactCVXX', dsets_full);
    
  end % if do_spw

  
  if do_large_dsets_only 
    for i = 1:length(cn_full)
      nc_full(i) = sum(cn_full == i);
    end
    ix_full = find(nc_full > 15);

    for i = 1:length(cn_empty)
      nc_empty(i) = sum(cn_empty == i);
    end
    ix_empty = find(nc_empty > 15);
    PairEV_empty = PairEV_empty(ix_empty);
    EV_empty = EV_empty(ix_empty);
    PairEV_full = PairEV_full(ix_full);
    EV_full = EV_full(ix_full);
    XX_full = XX_full(ix_full);
    XX_empty = XX_empty(ix_empty);
  end
  
  
%  keyboard
  
  rateR_empty = XX_empty;
  rateR_full = XX_full;
  
  
  
  [a, b, r, p] = regression_line(rateR_empty, PairEV_empty);
  
% $$$   fig.x{1} = EV-EVr;
% $$$   fig.n{1} = PairEV-PairEVr;
  fig.x{1} = rateR_empty;
  fig.n{1} = PairEV_empty;
  xx = 0:0.1:0.9;
  fig.x{2} = xx;
  fig.n{2} = a + b * xx;
  fig.style{2} = 'k-';
  
  fig.style{1} = 'k.';
  fig.lineProperties{1} = {'MarkerSize', 20};
  fig.lineProperties{2} = [];

fig.figureType = 'plot';

 % fig.axesProperties = {'DataAspectRatio', [1 1 1]};
  
  fig.xLabel = 'Rate reactivation EV';
  fig.yLabel = 'Cell pair corr. EV';
  fig.xLim = [0 0.9];
  fig.yLim = [0 0.4];
  
  if do_spw 
    fig.figureName = 'DIRACPoorSPWRatePairCompare';
  else
    fig.figureName = 'DIRACPoorRatePairCompare';
  end % if do_spw 

  fig_st = { fig };
  
  
  fig.x{1} = rateR_full;
  fig.n{1} = PairEV_full;
   if do_spw 
    fig.figureName = 'DIRACRichSPWRatePairCompare';
  else
    fig.figureName = 'DIRACRichRatePairCompare';
  end % if do_spw 
  fig_st = [fig_st { fig }];
 

  warning off MATLAB:divideByZero
  [r_empty, clo_empty, chi_empty] = ...
      nancorrcoef(rateR_empty, PairEV_empty, 'bootstrap');
  [r_full, clo_full, chi_full] = ...
      nancorrcoef(rateR_full, PairEV_full, 'bootstrap');
  warning on MATLAB:divideByZero

  
  log_string = sprintf('empty track: correlation between rate and pair EV = %g (%g,%g)\n', ...
		       (r_empty(1,2))^2, (clo_empty(1,2))^2, (chi_empty(1,2))^2);
  
  logger(log_string);
  
  log_string = sprintf('full track: correlation between rate and pair EV = %g (%g,%g)\n', ...
		       (r_full(1,2))^2, (clo_full(1,2))^2, (chi_full(1,2))^2);
  
  logger(log_string);
  
  
  
  
 
  
  warning on MATLAB:divideByZero
  warning on 