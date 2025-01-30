function fig_st = Hyper5RatePairCompareFigs()
  
  
  do_large_dsets_only = 1;
  do_non_spw = 0;
  do_spw = 0;
  do_pyramids_only = 1;
  dsets = List2Cell('/home/fpbatta/Data/Hyper5/dirs_Hyper5.list');
  A = Analysis('/home/fpbatta/Data/Hyper5/');

  [A, isOld] = getResource(A, 'IsOldRat', dsets);
  [A, isNovel] = getResource(A, 'IsNovel', dsets);

% $$$   dsets = dsets(find(isNovel));  
% $$$   figure_name = 'Hyper5OldRatePairCompare';
  
  warning off MATLAB:divideByZero
  warning off
  
  
  [A, cn] = getResource(A, 'HippoCellList', dsets);
  cn = cellnames_idx;
  


  
  if do_spw 
    [A, PairEV] = getResource(A, 'PairEVSPW', dsets);
    [A, PairEVr] = getResource(A, 'PairEVrSPW', dsets);  
    
    [A, frate_maze] = getResource(A, 'FRateMaze', dsets);    
    [A, frate_spw_sleep1] = getResource(A, 'FRateSPWSleep1', dsets); 
    [A, frate_spw_sleep2] = getResource(A, 'FRateSPWSleep2', dsets);     
    for i = 1:length(dsets)
      ix = find(frate_maze_idx == i);
      x_MS1 = log10(frate_maze(ix) ./ frate_spw_sleep1(ix));
      x_MS2 = log10(frate_maze(ix) ./ frate_spw_sleep2(ix));
      
      x_S2S1 = log10(frate_spw_sleep2(ix) ./ frate_spw_sleep1(ix));
      [a, b, r(i), pval] = regression_line(x_MS1, x_S2S1);
      [a, b, r_rev(i), pval] = regression_line(x_MS2, - x_S2S1);
      [EV(i), EVr(i)] = ReactEV(frate_spw_sleep1(ix), ...
				      frate_spw_sleep2(ix), ...
				      frate_maze(ix));
    end % for i = 1:length(dsets)
       
    EV = EV';  
    EVr = EVr';  	
    
    
  elseif do_non_spw
    
    [A, PairEV] = getResource(A, 'PairEVNoSPW', dsets);
    [A, PairEVr] = getResource(A, 'PairEVrNoSPW', dsets);  

    [A, frate_maze] = getResource(A, 'FRateMaze', dsets);    
    [A, frate_no_spw_sleep1] = getResource(A, 'FRateNoSPWSleep1', dsets); 
    [A, frate_no_spw_sleep2] = getResource(A, 'FRateNoSPWSleep2', dsets);     
    for i = 1:length(dsets)
      ix = find(frate_maze_idx == i);
      x_MS1 = log10(frate_maze(ix) ./ frate_no_spw_sleep1(ix));
      x_MS2 = log10(frate_maze(ix) ./ frate_no_spw_sleep2(ix));
      
      x_S2S1 = log10(frate_no_spw_sleep2(ix) ./ frate_no_spw_sleep1(ix));
      [a, b, r(i), pval] = regression_line(x_MS1, x_S2S1);
      [a, b, r_rev(i), pval] = regression_line(x_MS2, - x_S2S1);
      [EV(i), EVr(i)] = ReactEV(frate_no_spw_sleep1(ix), ...
				      frate_no_spw_sleep2(ix), ...
				      frate_maze(ix));
    end % for i = 1:length(dsets)
       
    EV = EV';  
    EVr = EVr';  	
    
    
  else
    
    [A, r] = getResource(A, 'ReactGlobalR', dsets);
    [A, r_rev] = getResource(A, 'ReactGlobalRRev', dsets);

    
    if do_pyramids_only
      [A, PairEV] = getResource(A, 'PairPyrEV', dsets);
      [A, PairEVr] = getResource(A, 'PairPyrEVr', dsets);  
      [A, PairEV2] = getResource(A, 'PairPyrEV2', dsets);
      [A, PairEVr2] = getResource(A, 'PairPyrEVr2', dsets);  
    else
      [A, PairEV] = getResource(A, 'PairEV', dsets);
      [A, PairEVr] = getResource(A, 'PairEVr', dsets);  
      [A, PairEV2] = getResource(A, 'PairEV2', dsets);
      [A, PairEVr2] = getResource(A, 'PairEVr2', dsets);  
    end % if do_pyramids_only
    
    [A, frate_maze] = getResource(A, 'FRateMaze', dsets);
    [A, frate_maze2] = getResource(A, 'FRateMaze2', dsets);    
    
    [A, frate_sleep1] = getResource(A, 'FRateSleep1', dsets);
    [A, frate_sleep2] = getResource(A, 'FRateSleep2', dsets);
    [A, frate_sleep2_2] = getResource(A, 'FRateSleep2_2', dsets);
    [A, frate_sleep3] = getResource(A, 'FRateSleep3', dsets);
    
    if do_pyramids_only
      pyr= max([frate_maze frate_sleep1 frate_sleep2], [], 2) > ...
	   0.5;
% $$$       frate_maze = frate_maze(pyr);
% $$$       frate_maze2 = frate_maze2(pyr);      
% $$$       frate_sleep1 = frate_sleep1(pyr);
% $$$       frate_sleep2 = frate_sleep2(pyr);
% $$$       frate_sleep2_2 = frate_sleep2_2(pyr);
% $$$       frate_sleep3 = frate_sleep3(pyr);      
    end
    
      
    warning off 

    [EV, EVr] = ReactEV(frate_sleep1, frate_sleep2, frate_maze);
    [EV2, EVr2] = ReactEV(frate_sleep2_2, frate_sleep3, frate_maze2);
    for i = 1:length(dsets)
      if do_pyramids_only
	ix = find(pyr & frate_maze_idx == i);
      else
	ix = find(frate_maze_idx == i);
      end % if do_pyramids_only
      
      [EV(i,1), EVr(i,1)] = ReactEV(log10(frate_sleep1(ix)), ...
				      log10(frate_sleep2(ix)), ...
				      log10(frate_maze(ix)));
      [EV2(i,1), EVr2(i,1)] = ReactEV(log10(frate_sleep2_2(ix)), ...
				      log10(frate_sleep3(ix)), ...
				      log10(frate_maze2(ix)));
      
    end % for i = 1:length(dsets)
      
  end
  
  

  keyboard
  
  
% $$$   fig.x{1} = EV-EVr;
% $$$   fig.n{1} = PairEV-PairEVr;
  fig.x{1} = EV;
  fig.n{1} = PairEV;
  fig.style{1} = 'ko';
  fig.lineProperties{1} = {'MarkerSize', 5};
 
  fig.x{2} = EV2;
  fig.n{2} = PairEV2;
  fig.style{2} = 'k.';
  fig.lineProperties{2} = {'MarkerSize', 20};
 
  
  fig.figureType = 'plot';

  fig.axesProperties = {'DataAspectRatio', [1 1 1]};
  
  fig.xLabel = 'Rate reactivation EV';
  fig.yLabel = 'Cell pair corr. EV';
  
  
  if do_spw 
    fig.figureName = 'Hyper5SPWRatePairCompare';
  else
    fig.figureName = figure_name;
  end % if do_spw 
  
  warning off MATLAB:divideByZero
  [r_1, clo_1, chi_1] = ...
      nancorrcoef(EV, PairEV, 'bootstrap');
  [r_2, clo_2, chi_2] = ...
      nancorrcoef(EV2, PairEV2, 'bootstrap');
  warning on MATLAB:divideByZero

  
  log_string = sprintf('S1/M1/S2 : correlation between rate and pair EV = %g (%g,%g)\n', ...
		       (r_1(1,2))^2, (clo_1(1,2))^2, (chi_1(1,2))^2);
  
  logger(log_string);
  
  log_string = sprintf('S2/M2/S3: correlation between rate and pair EV = %g (%g,%g)\n', ...
		       (r_2(1,2))^2, (clo_2(1,2))^2, (chi_2(1,2))^2);
  
  logger(log_string);
  
  
  
  
  fig_st = { fig };
  
  warning on MATLAB:divideByZero
  warning on 