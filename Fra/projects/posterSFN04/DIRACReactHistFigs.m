function fig_st = DIRACReactHistFigs()
  
  
  do_rich_poor = 1;
  do_rich_poor_run = 1;  
  do_pyr_int = 0;
  do_rich_poor_spw = 1;
  do_run_rew = 1;
  do_CRAM = 1;
  
  do_pyramids_only = 1;

  fig_st = {};
  
  A = Analysis('/home/fpbatta/Data/DIRAC/');
  tab_name = '/home/fpbatta/Data/DIRAC/posterSFN04/reactTable1';
  
  dsets_empty = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_empty.list');
  dsets_full = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_full.list');

  
  enum({ 'ROW_richTotal', ...
	 'ROW richSpw', ...
	 'ROW_richNoSpw', ...
	 'ROW_richRun', ...
	 'ROW_richReward', ...
	 'ROW_poorTotal', ...
	 'ROW_poorSpw', ...
	 'ROW_poorNoSpw', ...
	 'ROW_poorRun', ...
	 'ROW_poorReward', ...
	 'ROW_cramTotal', ...
	 'ROW_hyper5_1Total', ...
	 'ROW_hyper5_1Spw', ...
	 'ROW_hyper5_1NoSpw', ...
         'ROW_hyper5_2Total', ...
         'ROW_hyper5_2Spw', ...
         'ROW_hyper5_2NoSpw' } ...
       );
  
  enum({ 'COL_XXcorr', ...
	 'COL_XXrcorr', ...
	 'COL_EV', ...
	 'COL_EVr', ...
	 'COL_varMaze', ...
	 'COL_varSleep1', ...
	 'COL_varSleep2'} );
  
  labelsRow{ROW_richTotal}  = 'rich track, total firing';
  labelsRow{ROW richSpw} = 'rich track, SPW';
  labelsRow{ROW_richNoSpw} = 'rich track, no SPW';
  labelsRow{ROW_poorTotal} = 'poor track, total firing';
  labelsRow{ROW_poorSpw} = 'poor track, SPW';
  labelsRow{ROW_poorNoSpw} =  'poor track, no SPW' }; % 6
  labelsRow{ROW_cramTotal} = 'circular track, total firing';
  
  labelsColumn{COL_XXcorr} = '$r^2(X_{MS1},  X_{S2S1})$';
  labelsColumn{COL_XXrcorr} = '$r^2(X_{MS2},  X_{S1S2})$';
  labelsColumn{COL_EV} = '$EV$';
  labelsColumn{COL_EVr} = '$EV_r$';
  labelsColumn{COL_varMaze} =  '$var(\log(f_{maze}))$';
  labelsColumn{COL_varSleep1} =  '$var(\log(f_{S1}))$';
  labelsColumn{COL_varSleep2} = '$var(\log(f_{S2}))$';
	
  caption = ['values in parentheses are 95 \% confidence values.  EV ', ...
	     'stands for squared partial correlation coefficients ', ...
	     '$r_{MS2|S1}$. EVr in is the pariial correlation coefficient', ...
	     '$r_{MS1|S1}$. '];
  
  
  
  data = cell(6,4);
  
  
  
  
  if do_rich_poor
    
    
    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_empty);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_empty);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_empty);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_empty);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_empty);
    [A, X_MS1] = getResource(A, 'X_MS1', dsets_empty);
    [A, X_MS2] = getResource(A, 'X_MS2', dsets_empty);
    [A, X_S2S1] = getResource(A, 'X_S2S1', dsets_empty);    
    
    
    
    if do_pyramids_only
      [A, pyr] = getResource(A, 'IsPyramid', dsets_empty);
      pyr = find(pyr);
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
      X_MS1 = X_MS1(pyr);
      X_MS2 = X_MS2(pyr);
      X_S2S1 = X_S2S1(pyr);
      
    end
    
    
    [EVpoor, EVrpoor, EVpoor_int, EVrpoor_int] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_maze));
    
    data{ROW_poorTotal,COL_EV} = formatCI(EVpoor, EVpoor_int(1), EVpoor_int(2));
    data{ROW_poorTotal,COL_EVr} = formatCI(EVrpoor, EVrpoor_int(1), EVrpoor_int(2));
    
    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_poorTotal,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_poorTotal,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    
    data{ROW_poorTotal,COL_varMaze} = var(log10(fr_maze(fr_maze > 0)));
    data{ROW_poorTotal,COL_varSleep1} = var(log10(fr_s1(fr_s1 > 0)));
    data{ROW_poorTotal,COL_varSleep2} = var(log10(fr_s2(fr_s2 > 0)));    
    
    
    
    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_full);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_full);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_full);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_full);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_full);
    [A, X_MS1] = getResource(A, 'X_MS1', dsets_full);
    [A, X_MS2] = getResource(A, 'X_MS2', dsets_full);
    [A, X_S2S1] = getResource(A, 'X_S2S1', dsets_full);    

    if do_pyramids_only
      [A, pyr] = getResource(A, 'IsPyramid', dsets_full);
      pyr = find(pyr);
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
      X_MS1 = X_MS1(pyr);
      X_MS2 = X_MS2(pyr);
      X_S2S1 = X_S2S1(pyr);

    end
    
    [EVrich, EVrrich, EVrich_int, EVrrich_int] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_maze));
    
    data{ROW_richTotal,COL_EV} = formatCI(EVrich, EVrich_int(1), EVrich_int(2));
    data{ROW_richTotal,COL_EVr} = formatCI(EVrrich, EVrrich_int(1), EVrrich_int(2));
 
    
    
    data{ROW_richTotal,COL_varMaze} = var(log10(fr_maze(fr_maze > 0)));
    data{ROW_richTotal,COL_varSleep1} = var(log10(fr_s1(fr_s1 > 0)));
    data{ROW_richTotal,COL_varSleep2} = var(log10(fr_s2(fr_s2 > 0)));    

    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_richTotal,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_richTotal,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));

    fig.x = 1:2;
    fig.xTickLabel = {'rich', 'poor'};
    fig.n=  [EVrich EVrrich;
	     EVpoor EVrpoor];
    
    fig.figureName = 'DIRACRichPoorHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black)  EVr (white)';
    
    
    
    
    fig_st = [fig_st { fig } ] ;
    
  end
  
  
  
  
  if do_pyr_int
    dsets = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1.list');
    
    

    [A, X_MS1t] = getResource(A, 'X_MS1', dsets);
    [A, X_MS2t] = getResource(A, 'X_MS2', dsets);  
    [A, X_S2S1t] = getResource(A, 'X_S2S1', dsets);  

    
    [A, isInt] = getResource(A, 'IsInterneuron', dsets);  

    [A, fr_maze] = getResource(A, 'FRateMaze', dsets);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
    [A, pyr] = getResource(A, 'IsPyramid', dsets);  

    
    int = find(isInt);
    pyr = find(pyr);
    
    
    [EVpyr, EVrpyr EV_int EVr_int] = ReactEV(log(fr_s1(pyr)), log(fr_s2(pyr)), ...
					    log(fr_maze(pyr)));
    [EVint, EVrint EV_int EVr_int] = ReactEV(log(fr_s1(int)), log(fr_s2(int)), ...
					    log(fr_maze(int)));

    
    
    fig = [];
    fig.x = 1:2;
    fig.xTickLabel = {'pyramids', 'interneurons'};
    
    
    fig.n = [EVpyr, EVrpyr;
	     EVint, EVrint];
    
    fig.yLabel = 'EV (black) EVr (white)';
    fig.figureName = 'DIRACPyrIntHist';  
    fig.figureType = 'hist';
    fig_st = [fig_st { fig } ] ;

  end
  
  
  
  if do_rich_poor_spw

    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_empty);
    [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets_empty);  
    [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets_empty);  
    [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets_empty);  
    [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets_empty);  

    if do_pyramids_only

      [A, isPyr] = getResource(A, 'IsPyramid', dsets_empty);  
      pyr = find(isPyr);
      fr_s_s1 = fr_s_s1(pyr);
      fr_s_s2 = fr_s_s2(pyr);	
      fr_n_s1 = fr_n_s1(pyr);
      fr_n_s2 = fr_n_s2(pyr);	
      fr_maze = fr_maze(pyr);
      
    end
    
    
    [EVpoor_spw, EVrpoor_spw, EVpoor_int_spw, EVrpoor_int_spw] = ...
	ReactEV(log(fr_s_s1), log(fr_s_s2), log(fr_maze));

    [EVpoor_nospw, EVrpoor_nospw, EVpoor_int_nospw, EVrpoor_int_nospw] = ...
	ReactEV(log(fr_n_s1), log(fr_n_s2), log(fr_maze));
    
    
    data{ROW_poorSpw,COL_EV} = formatCI(EVpoor_spw, EVpoor_int_spw(1), ...
			 EVpoor_int_spw(2));
    data{ROW_poorSpw,COL_EVr} = formatCI(EVrpoor_spw, EVrpoor_int_spw(1), ...
			 EVrpoor_int_spw(2));
    
    X_MS1 = log10(fr_maze ./ fr_s_s1);
    X_MS2 = log10(fr_maze ./ fr_s_s2);    
    X_S2S1 = log10(fr_s_s2 ./ fr_s_s1);
    
    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_poorSpw,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_poorSpw,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));

    data{ROW_poorSpw,COL_varMaze} = var(log10(fr_maze(fr_maze > 0)));
    data{ROW_poorSpw,COL_varSleep1} = var(log10(fr_s_s1(fr_s_s1 > 0)));
    data{ROW_poorSpw,COL_varSleep2} = var(log10(fr_s_s2(fr_s_s2 > 0)));    
     
    %%%%%%%%%%%
    
    X_MS1 = log10(fr_maze ./ fr_n_s1);
    X_MS2 = log10(fr_maze ./ fr_n_s2);    
    X_S2S1 = log10(fr_n_s2 ./ fr_n_s1);
    
    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_poorNoSpw,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_poorNoSpw,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    
    data{ROW_poorNoSpw,COL_EV} = formatCI(EVpoor_nospw, EVpoor_int_nospw(1), ...
			 EVpoor_int_nospw(2));
    data{ROW_poorNoSpw,COL_EVr} = formatCI(EVrpoor_nospw, EVrpoor_int_nospw(1), ...
			 EVrpoor_int_nospw(2));
    
    data{ROW_poorNoSpw,COL_varMaze} = var(log10(fr_maze(fr_maze > 0)));
    data{ROW_poorNoSpw,COL_varSleep1} = var(log10(fr_n_s1(fr_n_s1 > 0)));
    data{ROW_poorNoSpw,COL_varSleep2} = var(log10(fr_n_s2(fr_n_s2 > 0)));    
    
    
    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_full);
    [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets_full);  
    [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets_full);  
    [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets_full);  
    [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets_full);  

    if do_pyramids_only

      [A, isPyr] = getResource(A, 'IsPyramid', dsets_full);  
      pyr = find(isPyr);
      fr_s_s1 = fr_s_s1(pyr);
      fr_s_s2 = fr_s_s2(pyr);	
      fr_n_s1 = fr_n_s1(pyr);
      fr_n_s2 = fr_n_s2(pyr);	
      fr_maze = fr_maze(pyr);
      
    end
    
    
    [EVrich_spw, EVrrich_spw, EVrich_int_spw, EVrrich_int_spw] = ...
	ReactEV(log(fr_s_s1), log(fr_s_s2), log(fr_maze));

    [EVrich_nospw, EVrrich_nospw, EVrich_int_nospw, EVrrich_int_nospw] = ...
	ReactEV(log(fr_n_s1), log(fr_n_s2), log(fr_maze));
    
    data{ROW_richSpw,COL_EV} = formatCI(EVrich_spw, EVrich_int_spw(1), ...
			 EVrich_int_spw(2));
    data{ROW_richSpw,COL_EVr} = formatCI(EVrrich_spw, EVrrich_int_spw(1), ...
			 EVrrich_int_spw(2));
    
    X_MS1 = log10(fr_maze ./ fr_s_s1);
    X_MS2 = log10(fr_maze ./ fr_s_s2);    
    X_S2S1 = log10(fr_s_s2 ./ fr_s_s1);
    
    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_richSpw,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_richSpw,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));

    data{ROW_richSpw,COL_varMaze} = var(log10(fr_maze(fr_maze > 0)));
    data{ROW_richSpw,COL_varSleep1} = var(log10(fr_s_s1(fr_s_s1 > 0)));
    data{ROW_richSpw,COL_varSleep2} = var(log10(fr_s_s2(fr_s_s2 > 0)));    
     
    %%%%%%%%%%%
    
    X_MS1 = log10(fr_maze ./ fr_n_s1);
    X_MS2 = log10(fr_maze ./ fr_n_s2);    
    X_S2S1 = log10(fr_n_s2 ./ fr_n_s1);
    
    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_richNoSpw,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_richNoSpw,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    
    data{ROW_richNoSpw,COL_EV} = formatCI(EVrich_nospw, EVrich_int_nospw(1), ...
			 EVrich_int_nospw(2));
    data{ROW_richNoSpw,COL_EVr} = formatCI(EVrrich_nospw, EVrrich_int_nospw(1), ...
			 EVrrich_int_nospw(2));
    
    data{ROW_richNoSpw,COL_varMaze} = var(log10(fr_maze(fr_maze > 0)));
    data{ROW_richNoSpw,COL_varSleep1} = var(log10(fr_n_s1(fr_n_s1 > 0)));
    data{ROW_richNoSpw,COL_varSleep2} = var(log10(fr_n_s2(fr_n_s2 > 0)));    
    
    
    
    
    
    fig = [];
    
    
    fig.x = 1:4;
    fig.xTickLabel = {'rich SPW', 'rich noSPW', 'poor SPW', 'poor noSPW'};
    fig.n=  [EVrich_spw EVrrich_spw;
	     EVrich_nospw EVrrich_nospw;
	     EVpoor_spw EVrpoor_spw;
	     EVpoor_nospw EVrpoor_nospw;	     
	    ];
    
    fig.figureName = 'DIRACRichPoorSpwHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black) EVr (white)';
    
    
    fig_st = [fig_st { fig } ] ;
    
  end
  
  makeTable(data, labelsRow, labelsColumn, 'fname', tab_name, ...
	    'landscape', 0, 'caption', caption);
  
  
  if do_run_rew
    dsets = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1.list');
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets);

    if do_pyramids_only

      [A, isPyr] = getResource(A, 'IsPyramid', dsets);  
      pyr = find(isPyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
    end
    
      
      
      
      
    [EVrun, EVrrun, x, y] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_run));
    [EVrew, EVrrew, x, y] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_rew));
    
    
    fig = [];
    
    
    fig.x = 1:2;
    fig.xTickLabel = {'maze-run', 'maze-reward' };
    fig.n=  [EVrun EVrrun;
	     EVrew EVrrew
	    ];
    
    fig.figureName = 'DIRACRunRewardHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black) EVr (white)';
    
    
    fig_st = [fig_st { fig } ] ;
    
  end
  
  
  if do_rich_poor_run
    
    
    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_empty);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_empty);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_empty);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_empty);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_empty);
    [A, X_MS1] = getResource(A, 'X_MS1', dsets_empty);
    [A, X_MS2] = getResource(A, 'X_MS2', dsets_empty);
    [A, X_S2S1] = getResource(A, 'X_S2S1', dsets_empty);    
    
    
    
    if do_pyramids_only
      [A, pyr] = getResource(A, 'IsPyramid', dsets_empty);
      pyr = find(pyr);
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
      X_MS1 = X_MS1(pyr);
      X_MS2 = X_MS2(pyr);
      X_S2S1 = X_S2S1(pyr);
      
    end
    
    X_MS1 = log10(fr_run ./ fr_s1);
    X_MS2 = log10(fr_run ./ fr_s2);    
    
    [EVpoorRun, EVrpoorRun, EVpoorRun_int, EVrpoorRun_int] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_run));
    
    data{ROW_poorRun,COL_EV} = formatCI(EVpoorRun, EVpoorRun_int(1), ...
					EVpoorRun_int(2));
    data{ROW_poorRun,COL_EVr} = formatCI(EVrpoorRun, EVrpoorRun_int(1), ...
					 EVrpoorRun_int(2));
    
    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_poorRun,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_poorRun,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    
    data{ROW_poorRun,COL_varMaze} = var(log10(fr_run(fr_run > 0)));
    data{ROW_poorRun,COL_varSleep1} = var(log10(fr_s1(fr_s1 > 0)));
    data{ROW_poorRun,COL_varSleep2} = var(log10(fr_s2(fr_s2 > 0)));    
    
    
    %%%%%%%%%%%%%%%%%%%
    X_MS1 = log10(fr_rew ./ fr_s1);
    X_MS2 = log10(fr_rew ./ fr_s2);    

    [EVpoorReward, EVrpoorReward, EVpoorReward_int, EVrpoorReward_int] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_rew));
    
    data{ROW_poorReward,COL_EV} = ...
	formatCI(EVpoorReward, EVpoorReward_int(1), EVpoorReward_int(2));
    data{ROW_poorReward,COL_EVr} = ...
	formatCI(EVrpoorReward, EVrpoorReward_int(1), EVrpoorReward_int(2));
    
    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_poorReward,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_poorReward,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    
    data{ROW_poorReward,COL_varMaze} = var(log10(fr_rew(fr_rew > 0)));
    data{ROW_poorReward,COL_varSleep1} = var(log10(fr_s1(fr_s1 > 0)));
    data{ROW_poorReward,COL_varSleep2} = var(log10(fr_s2(fr_s2 > 0)));    
    %%%%%%%%%%%%%%%%%%
    
    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_full);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_full);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_full);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_full);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_full);
    [A, X_MS1] = getResource(A, 'X_MS1', dsets_full);
    [A, X_MS2] = getResource(A, 'X_MS2', dsets_full);
    [A, X_S2S1] = getResource(A, 'X_S2S1', dsets_full);    

    if do_pyramids_only
      [A, pyr] = getResource(A, 'IsPyramid', dsets_full);
      pyr = find(pyr);
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
      X_MS1 = X_MS1(pyr);
      X_MS2 = X_MS2(pyr);
      X_S2S1 = X_S2S1(pyr);

    end

    %%%%%%%%%%%%%%%%
    X_MS1 = log10(fr_run ./ fr_s1);
    X_MS2 = log10(fr_run ./ fr_s2);    

    [EVrichRun, EVrrichRun, EVrichRun_int, EVrrichRun_int] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_run));
    
    data{ROW_richRun,COL_EV} = ...
	formatCI(EVrichRun, EVrichRun_int(1), EVrichRun_int(2));
    data{ROW_richRun,COL_EVr} = ...
	formatCI(EVrrichRun, EVrrichRun_int(1), EVrrichRun_int(2));
 
    
    
    data{ROW_richRun,COL_varMaze} = var(log10(fr_run(fr_run > 0)));
    data{ROW_richRun,COL_varSleep1} = var(log10(fr_s1(fr_s1 > 0)));
    data{ROW_richRun,COL_varSleep2} = var(log10(fr_s2(fr_s2 > 0)));    

    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_richRun,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_richRun,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    %%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%
    X_MS1 = log10(fr_rew ./ fr_s1);
    X_MS2 = log10(fr_rew ./ fr_s2);    

    [EVrichReward, EVrrichReward, EVrichReward_int, EVrrichReward_int] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_rew));
    
    data{ROW_richReward,COL_EV} = ...
	formatCI(EVrichReward, EVrichReward_int(1), EVrichReward_int(2));
    data{ROW_richReward,COL_EVr} = ...
	formatCI(EVrrichReward, EVrrichReward_int(1), EVrrichReward_int(2));
 
    
    
    data{ROW_richReward,COL_varMaze} = var(log10(fr_maze(fr_rew > 0)));
    data{ROW_richReward,COL_varSleep1} = var(log10(fr_s1(fr_s1 > 0)));
    data{ROW_richReward,COL_varSleep2} = var(log10(fr_s2(fr_s2 > 0)));    

    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_richReward,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_richReward,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    %%%%%%%%%%%%%%%
    fig.x = 1:2;
    fig.xTickLabel = {'rich run', 'rich reward', 'poor run', 'poor reward'};
    fig.n=  [EVrichRun EVrrichRun;
	     EVrichReward EVrrichReward
	     EVpoorRun EVrpoorRun;
	     EVpoorReward EVrpoorReward];
    
    fig.figureName = 'DIRACRichPoorRunHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black)  EVr (white)';
    
    
    
    
    fig_st = [fig_st { fig } ] ;
    
  end
  
  
  
  
  if do_CRAM
    A = Analysis('/home/fpbatta/Data/CRAM');
    dsets = List2Cell('/home/fpbatta/Data/CRAM/dirs_CRAM.list');
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets);
    [A, X_MS1] = getResource(A, 'X_MS1', dsets);
    [A, X_MS2] = getResource(A, 'X_MS2', dsets);
    [A, X_S2S1] = getResource(A, 'X_S2S1', dsets);     
    
    if do_pyramids_only
      pyr = max([fr_maze fr_s1 fr_s2]) > 0.5;
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
      X_MS1 = X_MS1(pyr);
      X_MS2 = X_MS2(pyr);
      X_S2S1 = X_S2S1(pyr);
    end
    
    [EVcram, EVrcram, EVcram_int, EVrcram_int] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_maze));
    
    data{ROW_cramTotal,COL_EV} = formatCI(EVcram, EVcram_int(1), EVcram_int(2));
    data{ROW_cramTotal,COL_EVr} = formatCI(EVrcram, EVrcram_int(1), EVrcram_int(2));
    
    [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
    data{ROW_cramTotal,COL_XXcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
    data{ROW_cramTotal,COL_XXrcorr} = formatCI(r(1,2), clo(1,2), chi(1,2));
    
    data{ROW_cramTotal,COL_varMaze} = var(log10(fr_maze(fr_maze > 0)));
    data{ROW_cramTotal,COL_varSleep1} = var(log10(fr_s1(fr_s1 > 0)));
    data{ROW_cramTotal,COL_varSleep2} = var(log10(fr_s2(fr_s2 > 0)));    
    
    
    fig.x = 1;
    fig.xTickLabel = {'rich', 'poor'};
    fig.n=  [EVpoor EVrpoor];
    
    fig.figureName = 'CRAMGlobalHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black)  EVr (white)';
    fig_st = [fig_st { fig } ] ;
    
    
  end
  
  
  
  if do_Hyper5
    
    A = Analysis('/home/fpbatta/Data/Hyper5/');
    dsets = List2Cell('/home/fpbatta/Data/Hyper5/dirs_Hyper5.list');
    
    [A, fr_maze1] = getResource(A, 'FRateMaze', dsets);
    [A, fr_maze2] = getResource(A, 'FRateMaze2', dsets);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
    [A, fr_s3] = getResource(A, 'FRateSleep2', dsets);  

    [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets);  
    [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets);  
    [A, fr_s_s3] = getResource(A, 'FRateSPWSleep2', dsets);  
  
    [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets);  
    [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets);  
    [A, fr_n_s3] = getResource(A, 'FRateNoSPWSleep2', dsets);  
  
    
    
    % Hyper 5 S1/M1/S2
    
    f_maze = fr_maze1;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 

    [XXcstring, XXcrstring, ...
     EVh5total, EVh5rtotal, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_hyper5_1Total,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_1Total,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_1Total,COL_EV} = EVstring;    
    data{ROW_hyper5_1Total,COL_EVr} = EVrstring;    
    data{ROW_hyper5_1Total,COL_varMaze} = varMaze;
    data{ROW_hyper5_1Total,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_1Total,COL_varSleep2} = varSleep2;
    
    f_maze = fr_maze1;
    f_s1 = fr_s_s1;
    f_s2 = fr_s_s2; 
    
    [XXcstring, XXcrstring, ...
     EVh5spw, EVh5rspw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(fr_maze, fr_s1, fr_s2);
    
    data{ROW_hyper5_1Spw,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_1Spw,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_1Spw,COL_EV} = EVstring;    
    data{ROW_hyper5_1Spw,COL_EVr} = EVrstring;    
    data{ROW_hyper5_1Spw,COL_varMaze} = varMaze;
    data{ROW_hyper5_1Spw,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_1Spw,COL_varSleep2} = varSleep2;
    
    f_maze = fr_maze1;
    f_s1 = fr_n_s1;
    f_s2 = fr_n_s2; 
    
    [XXcstring, XXcrstring, ...
     EVh5nospw, EVh5rnospw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(fr_maze, fr_s1, fr_s2);
    
    data{ROW_hyper5_1NoSpw,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_1NoSpw,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_1NoSpw,COL_EV} = EVstring;    
    data{ROW_hyper5_1NoSpw,COL_EVr} = EVrstring;    
    data{ROW_hyper5_1NoSpw,COL_varMaze} = varMaze;
    data{ROW_hyper5_1NoSpw,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_1NoSpw,COL_varSleep2} = varSleep2;
    
    
    fig = [];
    
    
    fig.x = 1:3;
    fig.xTickLabel = {'total', 'SPW', 'No SPW' };
    fig.n=  [EVh5total, EVh5rtotal;
	     EVh5spw, EVh5rspw;
	     EVh5nospw, EVh5rnospw ];
    
    fig.figureName = 'Hyper5_1Hist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black) EVr (white)';
    
    
    fig_st = [fig_st { fig } ] ;
    
    
   % Hyper 5 S1/M1/S2
    
    f_maze = fr_maze2;
    f_s1 = fr_s2_2;
    f_s2 = fr_s3; 

    [XXcstring, XXcrstring, ...
     EVh5total, EVh5rtotal, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_hyper5_2Total,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_2Total,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_2Total,COL_EV} = EVstring;    
    data{ROW_hyper5_2Total,COL_EVr} = EVrstring;    
    data{ROW_hyper5_2Total,COL_varMaze} = varMaze;
    data{ROW_hyper5_2Total,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_2Total,COL_varSleep2} = varSleep2;
    
    f_maze = fr_maze2;
    f_s1 = fr_s_s2_2;
    f_s2 = fr_s_s3; 
    
    [XXcstring, XXcrstring, ...
     EVh5spw, EVh5rspw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(fr_maze, fr_s1, fr_s2);
    
    data{ROW_hyper5_2Spw,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_2Spw,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_2Spw,COL_EV} = EVstring;    
    data{ROW_hyper5_2Spw,COL_EVr} = EVrstring;    
    data{ROW_hyper5_2Spw,COL_varMaze} = varMaze;
    data{ROW_hyper5_2Spw,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_2Spw,COL_varSleep2} = varSleep2;
    
    f_maze = fr_maze2;
    f_s1 = fr_n_s2_2;
    f_s2 = fr_n_s3; 
    
    [XXcstring, XXcrstring, ...
     EVh5nospw, EVh5rnospw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(fr_maze, fr_s1, fr_s2);
    
    data{ROW_hyper5_2NoSpw,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_2NoSpw,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_2NoSpw,COL_EV} = EVstring;    
    data{ROW_hyper5_2NoSpw,COL_EVr} = EVrstring;    
    data{ROW_hyper5_2NoSpw,COL_varMaze} = varMaze;
    data{ROW_hyper5_2NoSpw,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_2NoSpw,COL_varSleep2} = varSleep2;
    
    
    fig = [];
    
    
    fig.x = 1:3;
    fig.xTickLabel = {'total', 'SPW', 'No SPW' };
    fig.n=  [EVh5total, EVh5rtotal;
	     EVh5spw, EVh5rspw;
	     EVh5nospw, EVh5rnospw ];
    
    fig.figureName = 'Hyper5_2Hist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black) EVr (white)';
    
    
    fig_st = [fig_st { fig } ] ;
    
    
    
 end % if do_Hyper5
 
    
    
    
    
    
    
    
    
    
    
    
    
    
function [XXcstring, XXcrstring, EV, EVr, EVstring, EVrstring, varMaze, varSleep1, varSleep2] = ...
	  makeRow(fr_maze, fr_s1, fr_s2)
  
  X_MS1 = log10(fr_maze ./ fr_s1);
  X_MS2 = log10(fr_maze./ fr_s2);    
  X_S2S1 = log10(fr_s2 ./ fr_s1);
  
  [EV, EVr, EV_int, EVr_int] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_maze));

  EVstring = formatCI(EV, EV_int(1), EV_int(2));
  EVrstring = formatCI(EVr, EVr_int(1), EVr_int(2));  
  
  [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
  XXcstring = formatCI(r(1,2), clo(1,2), chi(1,2));
  [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
  XXcstring = formatCI(r(1,2), clo(1,2), chi(1,2));

  varMaze =  var(log10(fr_maze(fr_maze > 0)));
  varSleep1 = var(log10(fr_s1(fr_s1 > 0)));
  varSleep2 = var(log10(fr_s2(fr_s2 > 0))); 
	  
  
 