function fig_st = Hyper5ReactHistByType()
  
  warning off MATLAB:divideByZero

  do_pyramids_only = 0;
  
  enum({ 'ROW_M1Familiar', ...
	 'ROW_M1SPWFamiliar', ...
	 'ROW_M1NoSPWFamiliar', ...
	 'ROW_M1Novel', ...
	 'ROW_M1SPWNovel', ...
	 'ROW_M1NoSPWNovel', ...
	 'ROW_M2Familiar', ...
	 'ROW_M2SPWFamiliar', ...
	 'ROW_M2NoSPWFamiliar', ...
	 'ROW_M2Novel', ...
	 'ROW_M2SPWNovel', ...
	 'ROW_M2NoSPWNovel'});
  
  enum({ 'COL_XXcorr', ...
	 'COL_XXrcorr', ...
	 'COL_EV', ...
	 'COL_EVr', ...
	 'COL_varMaze', ...
	 'COL_varSleep1', ...
	 'COL_varSleep2'} );
  
  
  fig_st = {};
  
  labelsRow{ ROW_M1Familiar } = 'S1/M1/S2 familiar';
  labelsRow{ ROW_M1SPWFamiliar } = 'S1/M1/S2 familiar, SPW';
  labelsRow{ ROW_M1NoSPWFamiliar } = 'S1/M1/S2 familiar, no SPW';  
  labelsRow{ ROW_M1Novel } = 'S1/M1/S2 novel';
  labelsRow{ ROW_M1SPWNovel } = 'S1/M1/S2 novel, SPW';
  labelsRow{ ROW_M1NoSPWNovel } = 'S1/M1/S2 novel, no SPW';  
  
  labelsRow{ ROW_M2Familiar } = 'S2/M2/S3 familiar';
  labelsRow{ ROW_M2SPWFamiliar } = 'S2/M2/S3 familiar, SPW';
  labelsRow{ ROW_M2NoSPWFamiliar } = 'S2/M2/S3 familiar, no SPW';  
  labelsRow{ ROW_M2Novel } = 'S2/M2/S3 novel';
  labelsRow{ ROW_M2SPWNovel } = 'S2/M2/S3 novel, SPW';
  labelsRow{ ROW_M2NoSPWNovel } = 'S2/M2/S3 novel, no SPW';  
  
  labelsColumn{ COL_XXcorr } = '$r^2(X_{MS1},  X_{S2S1})$';
  labelsColumn{ COL_XXrcorr } = '$r^2(X_{MS2},  X_{S1S2})$';
  labelsColumn{ COL_EV } = '$EV$';
  labelsColumn{ COL_EVr } = '$EV_r$';
  labelsColumn{ COL_varMaze } =  '$var(\log(f_{maze}))$';
  labelsColumn{ COL_varSleep1 } =  '$var(\log(f_{S1}))$';
  labelsColumn{ COL_varSleep2 } = '$var(\log(f_{S2}))$';

  caption = ['values in parentheses are 95 \% confidence values.  EV ', ...
	     'stands for squared partial correlation coefficients ', ...
	     '$r_{MS2|S1}$. EVr is the partial correlation coefficient', ...
	     '$r_{MS1|S1}$. '];

  tab_name = '/home/fpbatta/Data/DIRAC/posterSFN04/Hyper5Table1';

  A = Analysis('/home/fpbatta/Data/Hyper5/');
  dsets = List2Cell('/home/fpbatta/Data/Hyper5/dirs_Hyper5.list');

  [A, isNovel] = getResource(A, 'IsNovel', dsets);
  
  dsets_novel = dsets(find(isNovel));
  dsets_familiar = dsets(find(~isNovel));  
  
  
  [A, fr_maze1] = getResource(A, 'FRateMaze', dsets_familiar);
  [A, fr_maze2] = getResource(A, 'FRateMaze2', dsets_familiar);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_familiar);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_familiar);  
  [A, fr_s2_2] = getResource(A, 'FRateSleep2_2', dsets_familiar);      
  [A, fr_s3] = getResource(A, 'FRateSleep3', dsets_familiar);  

  [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets_familiar);  
  [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets_familiar);  
  [A, fr_s_s2_2] = getResource(A, 'FRateSPWSleep2_2', dsets_familiar);  
  [A, fr_s_s3] = getResource(A, 'FRateSPWSleep3', dsets_familiar);  
  
  [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets_familiar);  
  [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets_familiar);  
  [A, fr_n_s2_2] = getResource(A, 'FRateNoSPWSleep2_2', dsets_familiar);  
  [A, fr_n_s3] = getResource(A, 'FRateNoSPWSleep3', dsets_familiar);  
  
  if do_pyramids_only
    pyr = max([fr_maze1 fr_s1 fr_s2], [], 2) > 0.5;
    fr_maze1 = fr_maze1(pyr);
    fr_maze2 = fr_maze2(pyr);
    fr_s1 = fr_s1(pyr);
    fr_s2 = fr_s2(pyr);
    fr_s2_2 = fr_s2_2(pyr);
    fr_s3 = fr_s3(pyr);
    fr_s_s1 = fr_s_s1(pyr);
    fr_s_s2 = fr_s_s2(pyr);
    fr_s_s2_2 = fr_s_s2_2(pyr);
    fr_s_s3 = fr_s_s3(pyr);
    fr_n_s1 = fr_n_s1(pyr);
    fr_n_s2 = fr_n_s2(pyr);
    fr_n_s2_2 = fr_n_s2_2(pyr);
    fr_n_s3 = fr_n_s3(pyr);
  end
  
  
  
  
  % Hyper 5 S1/M1/S2
    
    f_maze = fr_maze1;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 

    [XXcstring, XXcrstring, ...
     EVh5total1f, EVh5rtotal1f, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M1Familiar,COL_XXcorr} = XXcstring;
    data{ROW_M1Familiar,COL_XXrcorr} = XXcrstring;    
    data{ROW_M1Familiar,COL_EV} = EVstring;    
    data{ROW_M1Familiar,COL_EVr} = EVrstring;    
    data{ROW_M1Familiar,COL_varMaze} = varMaze;
    data{ROW_M1Familiar,COL_varSleep1} = varSleep1;
    data{ROW_M1Familiar,COL_varSleep2} = varSleep2;
  
  
    f_maze = fr_maze1;
    f_s1 = fr_s_s1;
    f_s2 = fr_s_s2; 
    
    [XXcstring, XXcrstring, ...
     EVh5spw1f, EVh5rspw1f, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M1SPWFamiliar,COL_XXcorr} = XXcstring;
    data{ROW_M1SPWFamiliar,COL_XXrcorr} = XXcrstring;    
    data{ROW_M1SPWFamiliar,COL_EV} = EVstring;    
    data{ROW_M1SPWFamiliar,COL_EVr} = EVrstring;    
    data{ROW_M1SPWFamiliar,COL_varMaze} = varMaze;
    data{ROW_M1SPWFamiliar,COL_varSleep1} = varSleep1;
    data{ROW_M1SPWFamiliar,COL_varSleep2} = varSleep2;
    
    f_maze = fr_maze1;
    f_s1 = fr_n_s1;
    f_s2 = fr_n_s2; 
    
    [XXcstring, XXcrstring, ...
     EVh5nospw1f, EVh5rnospw1f, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M1NoSPWFamiliar,COL_XXcorr} = XXcstring;
    data{ROW_M1NoSPWFamiliar,COL_XXrcorr} = XXcrstring;    
    data{ROW_M1NoSPWFamiliar,COL_EV} = EVstring;    
    data{ROW_M1NoSPWFamiliar,COL_EVr} = EVrstring;    
    data{ROW_M1NoSPWFamiliar,COL_varMaze} = varMaze;
    data{ROW_M1NoSPWFamiliar,COL_varSleep1} = varSleep1;
    data{ROW_M1NoSPWFamiliar,COL_varSleep2} = varSleep2;
    
  
  % Hyper 5 S2/M2/S3
    
    f_maze = fr_maze2;
    f_s1 = fr_s2_2;
    f_s2 = fr_s3; 

    [XXcstring, XXcrstring, ...
     EVh5total2f, EVh5rtotal2f, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M2Familiar,COL_XXcorr} = XXcstring;
    data{ROW_M2Familiar,COL_XXrcorr} = XXcrstring;    
    data{ROW_M2Familiar,COL_EV} = EVstring;    
    data{ROW_M2Familiar,COL_EVr} = EVrstring;    
    data{ROW_M2Familiar,COL_varMaze} = varMaze;
    data{ROW_M2Familiar,COL_varSleep1} = varSleep1;
    data{ROW_M2Familiar,COL_varSleep2} = varSleep2;
  
  
    f_maze = fr_maze2;
    f_s1 = fr_s_s2_2;
    f_s2 = fr_s_s3; 
    
    [XXcstring, XXcrstring, ...
     EVh5spw2f, EVh5rspw2f, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M2SPWFamiliar,COL_XXcorr} = XXcstring;
    data{ROW_M2SPWFamiliar,COL_XXrcorr} = XXcrstring;    
    data{ROW_M2SPWFamiliar,COL_EV} = EVstring;    
    data{ROW_M2SPWFamiliar,COL_EVr} = EVrstring;    
    data{ROW_M2SPWFamiliar,COL_varMaze} = varMaze;
    data{ROW_M2SPWFamiliar,COL_varSleep1} = varSleep1;
    data{ROW_M2SPWFamiliar,COL_varSleep2} = varSleep2;
    
    f_maze = fr_maze2;
    f_s1 = fr_n_s2_2;
    f_s2 = fr_n_s3; 
    
    [XXcstring, XXcrstring, ...
     EVh5nospw2f, EVh5rnospw2f, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M2NoSPWFamiliar,COL_XXcorr} = XXcstring;
    data{ROW_M2NoSPWFamiliar,COL_XXrcorr} = XXcrstring;    
    data{ROW_M2NoSPWFamiliar,COL_EV} = EVstring;    
    data{ROW_M2NoSPWFamiliar,COL_EVr} = EVrstring;    
    data{ROW_M2NoSPWFamiliar,COL_varMaze} = varMaze;
    data{ROW_M2NoSPWFamiliar,COL_varSleep1} = varSleep1;
    data{ROW_M2NoSPWFamiliar,COL_varSleep2} = varSleep2;
    
  
  %%%%%%%%%%%%%%%%%%%%%%%% NOVEL datasets
    
    
    [A, fr_maze1] = getResource(A, 'FRateMaze', dsets_novel);
  [A, fr_maze2] = getResource(A, 'FRateMaze2', dsets_novel);
  [A, fr_s1] = getResource(A, 'FRateSleep1', dsets_novel);  
  [A, fr_s2] = getResource(A, 'FRateSleep2', dsets_novel);  
  [A, fr_s2_2] = getResource(A, 'FRateSleep2_2', dsets_novel);      
  [A, fr_s3] = getResource(A, 'FRateSleep3', dsets_novel);  

  [A, fr_s_s1] = getResource(A, 'FRateSPWSleep1', dsets_novel);  
  [A, fr_s_s2] = getResource(A, 'FRateSPWSleep2', dsets_novel);  
  [A, fr_s_s2_2] = getResource(A, 'FRateSPWSleep2_2', dsets_novel);  
  [A, fr_s_s3] = getResource(A, 'FRateSPWSleep3', dsets_novel);  
  
  [A, fr_n_s1] = getResource(A, 'FRateNoSPWSleep1', dsets_novel);  
  [A, fr_n_s2] = getResource(A, 'FRateNoSPWSleep2', dsets_novel);  
  [A, fr_n_s2_2] = getResource(A, 'FRateNoSPWSleep2_2', dsets_novel);  
  [A, fr_n_s3] = getResource(A, 'FRateNoSPWSleep3', dsets_novel);  
  
  if do_pyramids_only
    pyr = max([fr_maze1 fr_s1 fr_s2], [], 2) > 0.5;
    fr_maze1 = fr_maze1(pyr);
    fr_maze2 = fr_maze2(pyr);
    fr_s1 = fr_s1(pyr);
    fr_s2 = fr_s2(pyr);
    fr_s2_2 = fr_s2_2(pyr);
    fr_s3 = fr_s3(pyr);
    fr_s_s1 = fr_s_s1(pyr);
    fr_s_s2 = fr_s_s2(pyr);
    fr_s_s2_2 = fr_s_s2_2(pyr);
    fr_s_s3 = fr_s_s3(pyr);
    fr_n_s1 = fr_n_s1(pyr);
    fr_n_s2 = fr_n_s2(pyr);
    fr_n_s2_2 = fr_n_s2_2(pyr);
    fr_n_s3 = fr_n_s3(pyr);
  end
  
  
  
  
  % Hyper 5 S1/M1/S2
    
    f_maze = fr_maze1;
    f_s1 = fr_s1;
    f_s2 = fr_s2; 

    [XXcstring, XXcrstring, ...
     EVh5total1n, EVh5rtotal1n, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M1Novel,COL_XXcorr} = XXcstring;
    data{ROW_M1Novel,COL_XXrcorr} = XXcrstring;    
    data{ROW_M1Novel,COL_EV} = EVstring;    
    data{ROW_M1Novel,COL_EVr} = EVrstring;    
    data{ROW_M1Novel,COL_varMaze} = varMaze;
    data{ROW_M1Novel,COL_varSleep1} = varSleep1;
    data{ROW_M1Novel,COL_varSleep2} = varSleep2;
  
  
    f_maze = fr_maze1;
    f_s1 = fr_s_s1;
    f_s2 = fr_s_s2; 
    
    [XXcstring, XXcrstring, ...
     EVh5spw1n, EVh5rspw1n, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M1SPWNovel,COL_XXcorr} = XXcstring;
    data{ROW_M1SPWNovel,COL_XXrcorr} = XXcrstring;    
    data{ROW_M1SPWNovel,COL_EV} = EVstring;    
    data{ROW_M1SPWNovel,COL_EVr} = EVrstring;    
    data{ROW_M1SPWNovel,COL_varMaze} = varMaze;
    data{ROW_M1SPWNovel,COL_varSleep1} = varSleep1;
    data{ROW_M1SPWNovel,COL_varSleep2} = varSleep2;
    
    f_maze = fr_maze1;
    f_s1 = fr_n_s1;
    f_s2 = fr_n_s2; 
    
    [XXcstring, XXcrstring, ...
     EVh5nospw1n, EVh5rnospw1n, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M1NoSPWNovel,COL_XXcorr} = XXcstring;
    data{ROW_M1NoSPWNovel,COL_XXrcorr} = XXcrstring;    
    data{ROW_M1NoSPWNovel,COL_EV} = EVstring;    
    data{ROW_M1NoSPWNovel,COL_EVr} = EVrstring;    
    data{ROW_M1NoSPWNovel,COL_varMaze} = varMaze;
    data{ROW_M1NoSPWNovel,COL_varSleep1} = varSleep1;
    data{ROW_M1NoSPWNovel,COL_varSleep2} = varSleep2;
    
  
  % Hyper 5 S2/M2/S3
    
    f_maze = fr_maze2;
    f_s1 = fr_s2_2;
    f_s2 = fr_s3; 

    [XXcstring, XXcrstring, ...
     EVh5total2n, EVh5rtotal2n, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M2Novel,COL_XXcorr} = XXcstring;
    data{ROW_M2Novel,COL_XXrcorr} = XXcrstring;    
    data{ROW_M2Novel,COL_EV} = EVstring;    
    data{ROW_M2Novel,COL_EVr} = EVrstring;    
    data{ROW_M2Novel,COL_varMaze} = varMaze;
    data{ROW_M2Novel,COL_varSleep1} = varSleep1;
    data{ROW_M2Novel,COL_varSleep2} = varSleep2;
  
  
    f_maze = fr_maze2;
    f_s1 = fr_s_s2_2;
    f_s2 = fr_s_s3; 
    
    [XXcstring, XXcrstring, ...
     EVh5spw2n, EVh5rspw2n, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M2SPWNovel,COL_XXcorr} = XXcstring;
    data{ROW_M2SPWNovel,COL_XXrcorr} = XXcrstring;    
    data{ROW_M2SPWNovel,COL_EV} = EVstring;    
    data{ROW_M2SPWNovel,COL_EVr} = EVrstring;    
    data{ROW_M2SPWNovel,COL_varMaze} = varMaze;
    data{ROW_M2SPWNovel,COL_varSleep1} = varSleep1;
    data{ROW_M2SPWNovel,COL_varSleep2} = varSleep2;
    
    f_maze = fr_maze2;
    f_s1 = fr_n_s2_2;
    f_s2 = fr_n_s3; 
    
    [XXcstring, XXcrstring, ...
     EVh5nospw2n, EVh5rnospw2n, ...
     EVstring, EVrstring, ...
     varMaze, varSleep1, varSleep2] = makeRow(f_maze, f_s1, f_s2);
    
    data{ROW_M2NoSPWNovel,COL_XXcorr} = XXcstring;
    data{ROW_M2NoSPWNovel,COL_XXrcorr} = XXcrstring;    
    data{ROW_M2NoSPWNovel,COL_EV} = EVstring;    
    data{ROW_M2NoSPWNovel,COL_EVr} = EVrstring;    
    data{ROW_M2NoSPWNovel,COL_varMaze} = varMaze;
    data{ROW_M2NoSPWNovel,COL_varSleep1} = varSleep1;
    data{ROW_M2NoSPWNovel,COL_varSleep2} = varSleep2;
    
  
  
   makeTable(data, labelsRow, labelsColumn, 'fname', tab_name, ...
	   'landscape', 0, 'caption', caption);

  
   
   fig = [];
   
   fig.x = 1:4;
   fig.xTickLabel = {'M1 fam.', 'M1 nov.', 'M2 fam.', 'M2 nov.' };
   fig.n=  [EVh5total1f, EVh5rtotal1f;
	    EVh5total1n, EVh5rtotal1n;
	    EVh5total2f, EVh5rtotal2f;
	    EVh5total2n, EVh5rtotal2n];
   
   fig.figureName = 'Hyper5NovelHist';  
   fig.figureType = 'hist';
   fig.yLabel = 'EV (black) EVr (white)';
  
   fig_st = [fig_st { fig } ] ;

  
function [XXcstring, XXcrstring, EV, EVr, EVstring, EVrstring, varMaze, varSleep1, varSleep2] = ...
	  makeRow(fr_maze, fr_s1, fr_s2)
  
  warning off
  X_MS1 = log10(fr_maze ./ fr_s1);
  X_MS2 = log10(fr_maze./ fr_s2);    
  X_S2S1 = log10(fr_s2 ./ fr_s1);
  
  
  [EV, EVr, EV_int, EVr_int] = ...
	ReactEV(log(fr_s1), log(fr_s2), log(fr_maze));

  warning on
  EVstring = formatCI(EV, EV_int(1), EV_int(2));
  EVrstring = formatCI(EVr, EVr_int(1), EVr_int(2));  
  
  [r, clo, chi] = nancorrcoef(X_MS1, X_S2S1);
  XXcstring = formatCI(r(1,2), clo(1,2), chi(1,2));
  [r, clo, chi] = nancorrcoef(X_MS2, - X_S2S1);
  XXcrstring = formatCI(r(1,2), clo(1,2), chi(1,2));

  varMaze =  var(log10(fr_maze(fr_maze > 0)));
  varSleep1 = var(log10(fr_s1(fr_s1 > 0)));
  varSleep2 = var(log10(fr_s2(fr_s2 > 0))); 
  