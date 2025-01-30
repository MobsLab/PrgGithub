function fig_st = DIRACReactCVHistFigs()
  
  
  
  warning off MATLAB:divideByZero
  do_rich_poor = 1;
  do_rich_poor_run = 1;  
  do_pyr_int = 0; %%% LEAVE AT 0
  do_rich_poor_spw = 1;
  do_run_rew = 1;
  do_CRAM = 1;
  do_Hyper5 = 1;
  do_global_spw = 1;
  do_pyramids_only = 1;


  fig_st = {};
  
  A = Analysis('/home/fpbatta/Data/DIRAC/');
  tab_name = '/home/fpbatta/Data/DIRAC/posterSFN04/reactCVTable1';
  dsets = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1.list');
  
  dsets_empty = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_empty.list');
  dsets_full = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_full.list');

 
  
    enum({ 'ROW_richTotal', ...
	 'ROW_richSpw', ...
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
  
  labelsRow{ ROW_richTotal}  = 'rich track, total firing';
  labelsRow{ ROW_richSpw } = 'rich track, SPW';
  labelsRow{ ROW_richNoSpw } = 'rich track, no SPW';
  labelsRow{ ROW_poorTotal } = 'poor track, total firing';
  labelsRow{ ROW_poorSpw } = 'poor track, SPW';
  labelsRow{ ROW_poorNoSpw } =  'poor track, no SPW' ;
  labelsRow{ ROW_cramTotal } = 'circular track, total firing';
  labelsRow{ ROW_richRun } = 'rich track, run activity';
  labelsRow{ ROW_richReward } = 'rich track, run activity';  
  labelsRow{ ROW_poorRun } = 'poor track, run activity';
  labelsRow{ ROW_poorReward } = 'poor track, run activity';  
  labelsRow{ ROW_hyper5_1Total } = 'T-maze S1/M1/S2 total firing';
  labelsRow{ ROW_hyper5_1Spw } = 'T-maze S1/M1/S2 SPW';
  labelsRow{ ROW_hyper5_1NoSpw } = 'T-maze S1/M1/S2 No SPW';
  labelsRow{ ROW_hyper5_2Total } = 'T-maze S2/M2/S3 total firing';
  labelsRow{ ROW_hyper5_2Spw } = 'T-maze S2/M2/S3 SPW';
  labelsRow{ ROW_hyper5_2NoSpw } = 'T-maze S2/M2/S3 No SPW';
  
  
  labelsColumn{ COL_XXcorr } = '$r^2(X_{MS1},  X_{S2S1})$';
  labelsColumn{ COL_XXrcorr } = '$r^2(X_{MS2},  X_{S1S2})$';
  labelsColumn{ COL_EV } = '$EV$';
  labelsColumn{ COL_EVr } = '$EV_r$';
  labelsColumn{ COL_varMaze } =  '$var(\log(f_{maze}))$';
  labelsColumn{ COL_varSleep1 } =  '$var(\log(f_{S1}))$';
  labelsColumn{ COL_varSleep2 } = '$var(\log(f_{S2}))$';
	
  caption = ['values in parentheses are 95 \% confidence values.  EV ', ...
	     'stands for squared partial correlation coefficients ', ...
	     '$r_{(M|S1'')(S2|S1)}$. EVr in is the pariial correlation coefficient', ...
	     '$r_{(M|S2'')(S1|S2)}$. S1'' stands for the presleep1 period, S2'' ',...
	     '  for the postsleep2 period' ];
  
  
  
  data = cell(6,4);
  
  

  if do_global_spw

    [A, fr_maze] = getResource(A, 'FRateMaze', dsets);
    [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets);  
    [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets);  
    [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets);  
    [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets);  

    [A, fr_s_pres1] = getResource(A, 'FRateSPWPreSleep1', dsets);
    [A, fr_s_posts2] = getResource(A, 'FRateSPWPostSleep2', dsets);
    [A, fr_n_pres1] = getResource(A, 'FRateNoSPWPreSleep1', dsets);
    [A, fr_n_posts2] = getResource(A, 'FRateNoSPWPostSleep2', dsets);
    
    if do_pyramids_only

      [A, isPyr] = getResource(A, 'IsPyramid', dsets);  
      pyr = find(isPyr);
      fr_s_s1 = fr_s_s1(pyr);
      fr_s_s2 = fr_s_s2(pyr);	
      fr_n_s1 = fr_n_s1(pyr);
      fr_n_s2 = fr_n_s2(pyr);	
      fr_maze = fr_maze(pyr);
      
      fr_s_pres1 = fr_s_pres1(pyr);
      fr_s_posts2 = fr_s_posts2(pyr);
      fr_n_pres1 = fr_n_pres1(pyr);
      fr_n_posts2 = fr_n_posts2(pyr);
      
      
    end
    
    %poor spw
    
    f_maze = fr_maze;
    f_s1 = fr_s_s1;
    f_s2 = fr_s_s2; 
    f_s1p = fr_s_pres1;
    f_s2p = fr_s_posts2;
    
    
    [XXspw, XXrspw, XXcstring, XXcrstring, ...
     EVpoor_spw, EVrpoor_spw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
 
    
    
    % poor no spw 
    
    
    f_maze = fr_maze;
    f_s1 = fr_n_s1;
    f_s2 = fr_n_s2; 
    f_s1p = fr_n_pres1;
    f_s2p = fr_n_posts2;
    
    
    [XXnospw, XXrnospw, XXcstring, XXcrstring, ...
     EVpoor_nospw, EVrpoor_nospw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
  
    
  end % if do_global_spw

  if do_rich_poor
    
    
    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_empty);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_empty);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_empty);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_empty);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_empty);
    [A, fr_pres1] = getResource(A, 'FRatePreSleep1', dsets_empty);
    [A, fr_posts2] = getResource(A, 'FRatePostSleep2', dsets_empty);
    
    if do_pyramids_only
      [A, pyr] = getResource(A, 'IsPyramid', dsets_empty);
      pyr = find(pyr);
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
      
      fr_pres1 = fr_pres1(pyr);
      fr_posts2 = fr_posts2(pyr);
      
    end
    
    
    
    
    
    
    
    % poor track total
    
    f_maze = fr_maze;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 
    f_s1p = fr_pres1;
    f_s2p = fr_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVpoor, EVrpoor, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_poorTotal,COL_XXcorr} = XXcstring;
    data{ROW_poorTotal,COL_XXrcorr} = XXcrstring;    
    data{ROW_poorTotal,COL_EV} = EVstring;    
    data{ROW_poorTotal,COL_EVr} = EVrstring;    
    data{ROW_poorTotal,COL_varMaze} = varMaze;
    data{ROW_poorTotal,COL_varSleep1} = varSleep1;
    data{ROW_poorTotal,COL_varSleep2} = varSleep2;

    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_full);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_full);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_full);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_full);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_full);
    [A, fr_pres1] = getResource(A, 'FRatePreSleep1', dsets_full);
    [A, fr_posts2] = getResource(A, 'FRatePostSleep2', dsets_full);

    if do_pyramids_only
      [A, pyr] = getResource(A, 'IsPyramid', dsets_full);
      pyr = find(pyr);
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
      fr_pres1 = fr_pres1(pyr);
      fr_posts2 = fr_posts2(pyr);

    end
    
    % rich track total
    
    f_maze = fr_maze;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 
    f_s1p = fr_pres1;
    f_s2p = fr_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVrich, EVrrich, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_richTotal,COL_XXcorr} = XXcstring;
    data{ROW_richTotal,COL_XXrcorr} = XXcrstring;    
    data{ROW_richTotal,COL_EV} = EVstring;    
    data{ROW_richTotal,COL_EVr} = EVrstring;    
    data{ROW_richTotal,COL_varMaze} = varMaze;
    data{ROW_richTotal,COL_varSleep1} = varSleep1;
    data{ROW_richTotal,COL_varSleep2} = varSleep2;

    

    
    fig.x = 1:2;
    fig.xTickLabel = {'rich', 'poor'};
    fig.n=  [EVrich EVrrich;
	     EVpoor EVrpoor];
    
    
    
    fig.figureName = 'DIRACCVRichPoorHist';  
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
    fig.figureName = 'DIRACCVPyrIntHist';  
    fig.figureType = 'hist';
    fig_st = [fig_st { fig } ] ;

  end
  
  
  
  if do_rich_poor_spw

    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_empty);
    [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets_empty);  
    [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets_empty);  
    [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets_empty);  
    [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets_empty);  

    [A, fr_s_pres1] = getResource(A, 'FRateSPWPreSleep1', dsets_empty);
    [A, fr_s_posts2] = getResource(A, 'FRateSPWPostSleep2', dsets_empty);
    [A, fr_n_pres1] = getResource(A, 'FRateNoSPWPreSleep1', dsets_empty);
    [A, fr_n_posts2] = getResource(A, 'FRateNoSPWPostSleep2', dsets_empty);
    
    if do_pyramids_only

      [A, isPyr] = getResource(A, 'IsPyramid', dsets_empty);  
      pyr = find(isPyr);
      fr_s_s1 = fr_s_s1(pyr);
      fr_s_s2 = fr_s_s2(pyr);	
      fr_n_s1 = fr_n_s1(pyr);
      fr_n_s2 = fr_n_s2(pyr);	
      fr_maze = fr_maze(pyr);
      
      fr_s_pres1 = fr_s_pres1(pyr);
      fr_s_posts2 = fr_s_posts2(pyr);
      fr_n_pres1 = fr_n_pres1(pyr);
      fr_n_posts2 = fr_n_posts2(pyr);
      
      
    end
    
    %poor spw
    
    f_maze = fr_maze;
    f_s1 = fr_s_s1;
    f_s2 = fr_s_s2; 
    f_s1p = fr_s_pres1;
    f_s2p = fr_s_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVpoor_spw, EVrpoor_spw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_poorSpw,COL_XXcorr} = XXcstring;
    data{ROW_poorSpw,COL_XXrcorr} = XXcrstring;    
    data{ROW_poorSpw,COL_EV} = EVstring;    
    data{ROW_poorSpw,COL_EVr} = EVrstring;    
    data{ROW_poorSpw,COL_varMaze} = varMaze;
    data{ROW_poorSpw,COL_varSleep1} = varSleep1;
    data{ROW_poorSpw,COL_varSleep2} = varSleep2;
    
    
    % poor no spw 
    
    
    f_maze = fr_maze;
    f_s1 = fr_n_s1;
    f_s2 = fr_n_s2; 
    f_s1p = fr_n_pres1;
    f_s2p = fr_n_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVpoor_nospw, EVrpoor_nospw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_poorNoSpw,COL_XXcorr} = XXcstring;
    data{ROW_poorNoSpw,COL_XXrcorr} = XXcrstring;    
    data{ROW_poorNoSpw,COL_EV} = EVstring;    
    data{ROW_poorNoSpw,COL_EVr} = EVrstring;    
    data{ROW_poorNoSpw,COL_varMaze} = varMaze;
    data{ROW_poorNoSpw,COL_varSleep1} = varSleep1;
    data{ROW_poorNoSpw,COL_varSleep2} = varSleep2;

    

     
 
    
    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_full);
    [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets_full);  
    [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets_full);  
    [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets_full);  
    [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets_full);  

    [A, fr_s_pres1] = getResource(A, 'FRateSPWPreSleep1', dsets_full);
    [A, fr_s_posts2] = getResource(A, 'FRateSPWPostSleep2', dsets_full);
    [A, fr_n_pres1] = getResource(A, 'FRateNoSPWPreSleep1', dsets_full);
    [A, fr_n_posts2] = getResource(A, 'FRateNoSPWPostSleep2', dsets_full);

    if do_pyramids_only

      [A, isPyr] = getResource(A, 'IsPyramid', dsets_full);  
      pyr = find(isPyr);
      fr_s_s1 = fr_s_s1(pyr);
      fr_s_s2 = fr_s_s2(pyr);	
      fr_n_s1 = fr_n_s1(pyr);
      fr_n_s2 = fr_n_s2(pyr);	
      fr_maze = fr_maze(pyr);
      
      fr_s_pres1 = fr_s_pres1(pyr);
      fr_s_posts2 = fr_s_posts2(pyr);
      fr_n_pres1 = fr_n_pres1(pyr);
      fr_n_posts2 = fr_n_posts2(pyr);

    end
    
    % rich spw 
    
    f_maze = fr_maze;
    f_s1 = fr_s_s1;
    f_s2 = fr_s_s2; 
    f_s1p = fr_s_pres1;
    f_s2p = fr_s_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVrich_spw, EVrrich_spw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_richSpw,COL_XXcorr} = XXcstring;
    data{ROW_richSpw,COL_XXrcorr} = XXcrstring;    
    data{ROW_richSpw,COL_EV} = EVstring;    
    data{ROW_richSpw,COL_EVr} = EVrstring;    
    data{ROW_richSpw,COL_varMaze} = varMaze;
    data{ROW_richSpw,COL_varSleep1} = varSleep1;
    data{ROW_richSpw,COL_varSleep2} = varSleep2;

    
    
    
    %rich no spw
    
    f_maze = fr_maze;
    f_s1 = fr_n_s1;
    f_s2 = fr_n_s2; 
    f_s1p = fr_n_pres1;
    f_s2p = fr_n_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVrich_nospw, EVrrich_nospw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_richNoSpw,COL_XXcorr} = XXcstring;
    data{ROW_richNoSpw,COL_XXrcorr} = XXcrstring;    
    data{ROW_richNoSpw,COL_EV} = EVstring;    
    data{ROW_richNoSpw,COL_EVr} = EVrstring;    
    data{ROW_richNoSpw,COL_varMaze} = varMaze;
    data{ROW_richNoSpw,COL_varSleep1} = varSleep1;
    data{ROW_richNoSpw,COL_varSleep2} = varSleep2;
    
    
    fig = [];
    
    
    fig.x = 1:4;
    fig.xTickLabel = {'rich SPW', 'rich noSPW', 'poor SPW', 'poor noSPW'};
    fig.n=  [EVrich_spw EVrrich_spw;
	     EVrich_nospw EVrrich_nospw;
	     EVpoor_spw EVrpoor_spw;
	     EVpoor_nospw EVrpoor_nospw;	     
	    ];
    
    
    fig.figureName = 'DIRACCVRichPoorSpwHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black) EVr (white)';
    
    
    fig_st = [fig_st { fig } ] ;
    
  end % if do_rich_poor_spw
  
  
  
  
  % run/reward rich/poor
  
  if do_rich_poor_run
    
    
    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_empty);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_empty);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_empty);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_empty);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_empty);
    [A, fr_pres1] = getResource(A, 'FRatePreSleep1', dsets_empty);
    [A, fr_posts2] = getResource(A, 'FRatePostSleep2', dsets_empty);


    
    if do_pyramids_only
      [A, pyr] = getResource(A, 'IsPyramid', dsets_empty);
      pyr = find(pyr);
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
      fr_pres1 = fr_pres1(pyr);
      fr_posts2 = fr_posts2(pyr);
      
    end

  
    % poor run 
    
    f_maze = fr_run;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 
    f_s1p = fr_pres1;
    f_s2p = fr_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVpoorRun, EVrpoorRun, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_poorRun,COL_XXcorr} = XXcstring;
    data{ROW_poorRun,COL_XXrcorr} = XXcrstring;    
    data{ROW_poorRun,COL_EV} = EVstring;    
    data{ROW_poorRun,COL_EVr} = EVrstring;    
    data{ROW_poorRun,COL_varMaze} = varMaze;
    data{ROW_poorRun,COL_varSleep1} = varSleep1;
    data{ROW_poorRun,COL_varSleep2} = varSleep2;

    
    % poor reward
    
    f_maze = fr_rew;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 
    f_s1p = fr_pres1;
    f_s2p = fr_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVpoorReward, EVrpoorReward, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_poorReward,COL_XXcorr} = XXcstring;
    data{ROW_poorReward,COL_XXrcorr} = XXcrstring;    
    data{ROW_poorReward,COL_EV} = EVstring;    
    data{ROW_poorReward,COL_EVr} = EVrstring;    
    data{ROW_poorReward,COL_varMaze} = varMaze;
    data{ROW_poorReward,COL_varSleep1} = varSleep1;
    data{ROW_poorReward,COL_varSleep2} = varSleep2;

    
    % rich track
    
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets_full);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_full);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_full);  
    [A, fr_run] = getResource(A, 'FRateMazeRun', dsets_full);
    [A, fr_rew] = getResource(A, 'FRateMazeReward', dsets_full);
    [A, fr_pres1] = getResource(A, 'FRatePreSleep1', dsets_full);
    [A, fr_posts2] = getResource(A, 'FRatePostSleep2', dsets_full);


    
    if do_pyramids_only
      [A, pyr] = getResource(A, 'IsPyramid', dsets_full);
      pyr = find(pyr);
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_run = fr_run(pyr);
      fr_rew = fr_rew(pyr);
      fr_pres1 = fr_pres1(pyr);
      fr_posts2 = fr_posts2(pyr);
      
    end

  
    % rich run 
    
    f_maze = fr_run;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 
    f_s1p = fr_s_pres1;
    f_s2p = fr_s_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVrichRun, EVrrichRun, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_richRun,COL_XXcorr} = XXcstring;
    data{ROW_richRun,COL_XXrcorr} = XXcrstring;    
    data{ROW_richRun,COL_EV} = EVstring;    
    data{ROW_richRun,COL_EVr} = EVrstring;    
    data{ROW_richRun,COL_varMaze} = varMaze;
    data{ROW_richRun,COL_varSleep1} = varSleep1;
    data{ROW_richRun,COL_varSleep2} = varSleep2;

    
    % rich reward
    
    f_maze = fr_rew;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 
    f_s1p = fr_s_pres1;
    f_s2p = fr_s_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVrichReward, EVrrichReward, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_richReward,COL_XXcorr} = XXcstring;
    data{ROW_richReward,COL_XXrcorr} = XXcrstring;    
    data{ROW_richReward,COL_EV} = EVstring;    
    data{ROW_richReward,COL_EVr} = EVrstring;    
    data{ROW_richReward,COL_varMaze} = varMaze;
    data{ROW_richReward,COL_varSleep1} = varSleep1;
    data{ROW_richReward,COL_varSleep2} = varSleep2;

    
    fig.x = 1:4;
    fig.xTickLabel = {'rich run', 'rich reward', 'poor run', 'poor reward'};
    fig.n=  [EVrichRun EVrrichRun;
	     EVrichReward EVrrichReward
	     EVpoorRun EVrpoorRun;
	     EVpoorReward EVrpoorReward];
    
    fig.figureName = 'DIRACCVRichPoorRunHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black)  EVr (white)';
    
    
    
    
    fig_st = [fig_st { fig } ] ;
  end % if do_rich_poor_run
    
  
  if do_CRAM
    
    A = Analysis('/home/fpbatta/Data/CRAM');
    dsets = List2Cell('/home/fpbatta/Data/CRAM/dirs_CRAM.list');
    [A, fr_maze] = getResource(A, 'FRateMaze', dsets);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
    [A, fr_pres1] = getResource(A, 'FRatePreSleep1', dsets);
    [A, fr_posts2] = getResource(A, 'FRatePostSleep2', dsets);
    
    if do_pyramids_only
      pyr = max([fr_maze fr_s1 fr_s2], [], 2) > 0.5;
      fr_maze = fr_maze(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_pres1 = fr_pres1(pyr);
      fr_posts2 = fr_posts2(pyr);
      
    end

    f_maze = fr_maze;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 
    f_s1p = fr_pres1;
    f_s2p = fr_posts2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVcram, EVrcram, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_cramTotal,COL_XXcorr} = XXcstring;
    data{ROW_cramTotal,COL_XXrcorr} = XXcrstring;    
    data{ROW_cramTotal,COL_EV} = EVstring;    
    data{ROW_cramTotal,COL_EVr} = EVrstring;    
    data{ROW_cramTotal,COL_varMaze} = varMaze;
    data{ROW_cramTotal,COL_varSleep1} = varSleep1;
    data{ROW_cramTotal,COL_varSleep2} = varSleep2;
	
    fig.x = 1:2;
    fig.xTickLabel = {'rich', 'poor'};
    fig.n=  [EVcram EVrcram;
	    ]';
    
    fig.figureName = 'CRAMCVGlobalHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black)  EVr (white)';
    fig_st = [fig_st { fig } ] ;

  end % if do_CRAM
    
  
  if do_Hyper5
    
    A = Analysis('/home/fpbatta/Data/Hyper5/');
    dsets = List2Cell('/home/fpbatta/Data/Hyper5/dirs_Hyper5.list');
    
    [A, fr_maze1] = getResource(A, 'FRateMaze', dsets);
    [A, fr_maze2] = getResource(A, 'FRateMaze2', dsets);
    [A, fr_s1] = getResource(A, 'FRateSleep1', dsets);  
    [A, fr_s2] = getResource(A, 'FRateSleep2', dsets);  
    [A, fr_s2_2] = getResource(A, 'FRateSleep2_2', dsets);  
    [A, fr_s3] = getResource(A, 'FRateSleep3', dsets);  

    [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets);  
    [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets);  
    [A, fr_s_s2_2] = getResource(A, 'FRateSPWSleep2_2', dsets);      
    [A, fr_s_s3] = getResource(A, 'FRateSPWSleep3', dsets);  
    
    [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets);  
    [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets);  
    [A, fr_n_s2_2] = getResource(A, 'FRateNoSPWSleep2_2', dsets);  
    [A, fr_n_s3] = getResource(A, 'FRateNoSPWSleep3', dsets);    
    
    [A, fr_pres1] = getResource(A, 'FRatePreSleep1', dsets);
    [A, fr_posts3] = getResource(A, 'FRatePostSleep3', dsets);

    [A, fr_s_pres1] = getResource(A, 'FRateSPWPreSleep1', dsets);
    [A, fr_s_posts3] = getResource(A, 'FRateSPWPostSleep3', dsets);

    [A, fr_n_pres1] = getResource(A, 'FRateNoSPWPreSleep1', dsets);
    [A, fr_n_posts3] = getResource(A, 'FRateNoSPWPostSleep3', dsets);

    
    % add pre/post sleep rates
    
    if do_pyramids_only
      pyr = max([fr_maze1 fr_s1 fr_s2], [], 2) > 0.5;
      fr_maze1 = fr_maze1(pyr);
      fr_maze2 = fr_maze2(pyr);
      fr_s1 = fr_s1(pyr);
      fr_s2 = fr_s2(pyr);
      fr_s2_2 = fr_s2_2(pyr);
      fr_s3 = fr_s3(pyr);
      fr_pres1 = fr_pres1(pyr);
      fr_posts3 = fr_posts3(pyr);
      
      fr_s_s1 = fr_s_s1(pyr);
      fr_s_s2 = fr_s_s2(pyr);
      fr_s_s2_2 = fr_s_s2_2(pyr);
      fr_s_s3 = fr_s_s3(pyr);
      fr_s_pres1 = fr_s_pres1(pyr);
      fr_s_posts3 = fr_s_posts3(pyr);

      fr_n_s1 = fr_n_s1(pyr);
      fr_n_s2 = fr_n_s2(pyr);
      fr_n_s2_2 = fr_n_s2_2(pyr);
      fr_n_s3 = fr_n_s3(pyr);
      fr_n_pres1 = fr_n_pres1(pyr);
      fr_n_posts3 = fr_n_posts3(pyr);
    end    
    
    % Hyper 5 S1/M1/S2
    
      
    % total 
    f_maze = fr_maze1;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 
    f_s1p = fr_pres1;
    f_s2p = fr_s2_2;
    
    
    [XX, XXr, XXcstring, XXcrstring, ...
     EVh5total, EVrh5total, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_hyper5_1Total,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_1Total,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_1Total,COL_EV} = EVstring;    
    data{ROW_hyper5_1Total,COL_EVr} = EVrstring;    
    data{ROW_hyper5_1Total,COL_varMaze} = varMaze;
    data{ROW_hyper5_1Total,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_1Total,COL_varSleep2} = varSleep2;

    
    % spw 
    f_maze = fr_maze1;
    f_s1 = fr_s_s1;
    f_s2 = fr_s_s2; 
    f_s1p = fr_s_pres1;
    f_s2p = fr_s_s2_2;
    
    
    [XXh5spw, XXrh5spw, XXcstring, XXcrstring, ...
     EVh5spw, EVrh5spw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_hyper5_1Spw,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_1Spw,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_1Spw,COL_EV} = EVstring;    
    data{ROW_hyper5_1Spw,COL_EVr} = EVrstring;    
    data{ROW_hyper5_1Spw,COL_varMaze} = varMaze;
    data{ROW_hyper5_1Spw,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_1Spw,COL_varSleep2} = varSleep2;

    % no spw 
    
    f_maze = fr_maze1;
    f_s1 = fr_n_s1;
    f_s2 = fr_n_s2; 
    f_s1p = fr_n_pres1;
    f_s2p = fr_n_s2_2;
    
    
    [XXh5nospw, XXrh5nospw, XXcstring, XXcrstring, ...
     EVh5nospw, EVrh5nospw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
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
    fig.n=  [EVh5total, EVrh5total;
	     EVh5spw, EVrh5spw;
	     EVh5nospw, EVrh5nospw ];
    
    fig.figureName = 'Hyper5_1CVHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black) EVr (white)';
    
    
    fig_st = [fig_st { fig } ] ;
    
    
    % Hyper 5 S2/M2/S3
    
      
    % total 
    f_maze = fr_maze2;
    f_s1 = fr_s2_2;
    f_s2 = fr_s3; 
    f_s1p = fr_s2;
    f_s2p = fr_posts3;
    
    
    [XXh52, XXr, XXcstring, XXcrstring, ...
     EVh52total, EVrh52total, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_hyper5_2Total,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_2Total,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_2Total,COL_EV} = EVstring;    
    data{ROW_hyper5_2Total,COL_EVr} = EVrstring;    
    data{ROW_hyper5_2Total,COL_varMaze} = varMaze;
    data{ROW_hyper5_2Total,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_2Total,COL_varSleep2} = varSleep2;

    
    % spw 
    f_maze = fr_maze2;
    f_s1 = fr_s_s2_2;
    f_s2 = fr_s_s3; 
    f_s1p = fr_s_s2;
    f_s2p = fr_s_posts3;
    
    
    [XXh52spw, XXrh52spw, XXcstring, XXcrstring, ...
     EVh52spw, EVrh52spw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
    data{ROW_hyper5_2Spw,COL_XXcorr} = XXcstring;
    data{ROW_hyper5_2Spw,COL_XXrcorr} = XXcrstring;    
    data{ROW_hyper5_2Spw,COL_EV} = EVstring;    
    data{ROW_hyper5_2Spw,COL_EVr} = EVrstring;    
    data{ROW_hyper5_2Spw,COL_varMaze} = varMaze;
    data{ROW_hyper5_2Spw,COL_varSleep1} = varSleep1;
    data{ROW_hyper5_2Spw,COL_varSleep2} = varSleep2;

    % no spw 
    
    f_maze = fr_maze2;
    f_s1 = fr_n_s2_2;
    f_s2 = fr_n_s3; 
    f_s1p = fr_n_s2;
    f_s2p = fr_n_posts3;
    
    
    [XXh52nospw, XXrh52nospw, XXcstring, XXcrstring, ...
     EVh52nospw, EVrh52nospw, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2, ...
					      f_s1p, f_s2p);
    
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
    fig.n=  [EVh5total, EVrh5total;
	     EVh5spw, EVrh5spw;
	     EVh5nospw, EVrh5nospw ];
    
    fig.figureName = 'Hyper5_2CVHist';  
    fig.figureType = 'hist';
    fig.yLabel = 'EV (black) EVr (white)';
    
    
    fig_st = [fig_st { fig } ] ;
    
  end % if do_Hyper5
 
  makeTable(data, labelsRow, labelsColumn, 'fname', tab_name, ...
	    'landscape', 0, 'caption', caption);
  
  
 
  fig = [];
  
  fig.x = 1:6;
  fig.n = [XXspw, XXrspw;
	   XXnospw, XXrnospw;
	   XXh5spw, XXrh5spw;
	   XXh5nospw, XXrh5nospw;
	   XXh52spw, XXrh52spw;
	   XXh52nospw, XXrh52nospw];
  fig.figureName = 'Spw_Hist';  
  fig.figureType = 'hist';
  fig.yLabel = 'corr. (black) rev. corr. (white)';
      
  fig.xTickLabel = {'SPW', 'No SPW', 'SPW', 'No SPW', 'SPW', 'No SPW' };
   
  fig_st = [fig_st { fig } ] ;

  
function [XX, XXr, XXcstring, XXcrstring, EV, EVr, EVstring, EVrstring, varMaze, varSleep1, varSleep2] = ...
	  makeRow(fr_maze, fr_s1, fr_s2, fr_s1p, fr_s2p)
  
  warning off
  X_MS1p = log10(fr_maze ./ fr_s1p);
  X_MS2p = log10(fr_maze./ fr_s2p);    
  X_S2S1 = log10(fr_s2 ./ fr_s1);

  
  [EV, EV_int] = ...
      ReactEVDualSemiPartial(log(fr_maze), log(fr_s2), log(fr_s1p), ...
			     log(fr_s1));
  
  EVstring = formatCI(EV, EV_int(1), EV_int(2));

  
  [EVr, EVr_int] = ...
      ReactEVDualSemiPartial(log(fr_maze), log(fr_s1), log(fr_s2p), ...
			     log(fr_s2));
  
  EVrstring = formatCI(EVr, EVr_int(1), EVr_int(2));
  
  
  [r, clo, chi] = nancorrcoef(X_MS1p, X_S2S1);
  XXcstring = formatCI(r(1,2), clo(1,2), chi(1,2));
  
  XX = r(1,2);
  [r, clo, chi] = nancorrcoef(X_MS2p, - X_S2S1);
  XXcrstring = formatCI(r(1,2), clo(1,2), chi(1,2));
  XXr = r(1,2);
  varMaze =  var(log10(fr_maze(fr_maze > 0)));
  varSleep1 = var(log10(fr_s1p(fr_s1p > 0)));
  varSleep2 = var(log10(fr_s2p(fr_s2p > 0))); 