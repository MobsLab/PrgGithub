function fig_st = DIRACTimeCourseFigs()
  
  fig_st = {};
  
  dsets = List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1.list');
  A = Analysis('/home/fpbatta/Data/DIRAC/');
  
  do_fig_tot = false;
  do_fig_split = true;
  
  
  if do_fig_tot
    
    [A, pyr] = getResource(A, 'IsPyramid', dsets);
    pyr = find(pyr);
    
    [A, frate_sleep1] = getResource(A, 'FRateSleep1', dsets);
    [A, frate_sleep2] = getResource(A, 'FRateSleep2', dsets);  
    [A, frate_presleep1] = getResource(A, 'FRatePreSleep1', dsets);
    [A, frate_postsleep2] = getResource(A, 'FRatePostSleep2', dsets);  
    
    [A, frate_binned_s1] = getResource(A, 'FRateBinnedS1', dsets);
    [A, frate_binned_s2] = getResource(A, 'FRateBinnedS2', dsets);  
    [A, frate_maze] = getResource(A, 'FRateMaze', dsets);
    
    frate_maze = frate_maze(pyr);
    frate_sleep1 = frate_sleep1(pyr);
    frate_sleep2 = frate_sleep2(pyr);
    
    
    
    fr_s1 = Data(frate_binned_s1{1});
    for i = 2:length(frate_binned_s1)
      fr_s1 = [fr_s1 Data(frate_binned_s1{i})];
    end
    fr_s1 = fr_s1(:,pyr);
    fr_s1 = fr_s1';
    
    fr_s2 = Data(frate_binned_s2{1});
    for i = 2:length(frate_binned_s2)
      fr_s2 = [fr_s2 Data(frate_binned_s2{i})];
    end
    fr_s2 = fr_s2(:,pyr);
    fr_s2 = fr_s2';
    
    for i = 1:size(fr_s2, 2);

      [EVb(i) EVrb(i) EV_int EVr_int, diff_int] = ...
	  ReactEV(log10(frate_sleep1), log10(fr_s2(:,i)), ...
		  log10(frate_maze));
      EVb_lo(i) = EV_int(1);
      EVb_hi(i) = EV_int(2);
      EVrb_lo(i) = EVr_int(1);
      EVrb_hi(i) = EVr_int(2);
      diff_lo(i) = diff_int(1);
      diff_hi(i) = diff_int(2);
      
    end
    
    keyboard
    t = Range(frate_binned_s2{1}, 's');
    t = t - t(1) +180;
    
    
    fig.x{1} = t;
    fig.n{1} = EVb-EVrb;
    fig.style{1} = 'k-';
    
    fig.x{2} = t;
    fig.n{2} = diff_lo;
    fig.style{2} = 'k--';
    
    fig.x{3} = t;
    fig.n{3} = diff_hi;
    fig.style{3} = 'k--';
    
    fig_st = { fig };
    
  end
  if do_fig_split
    
    dsets = { List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_empty.list'), ...
	      List2Cell('/home/fpbatta/Data/DIRAC/dirs_BD1_full.list') };
    sfx = { '_empty', '_full'};
    
    
    for ii = 1:2
 
      [A, pyr] = getResource(A, 'IsPyramid', dsets{ii});
      pyr = find(pyr);
 
      [A, frate_sleep1] = getResource(A, 'FRateSleep1', dsets{ii});
      [A, frate_sleep2] = getResource(A, 'FRateSleep2', dsets{ii});  
      
      [A, frate_binned_s1] = getResource(A, 'FRateBinnedS1', dsets{ii});
      [A, frate_binned_s2] = getResource(A, 'FRateBinnedS2', dsets{ii});  
      [A, frate_maze] = getResource(A, 'FRateMaze', dsets{ii});
      
      frate_maze = frate_maze(pyr);
      frate_sleep1 = frate_sleep1(pyr);
      frate_sleep2 = frate_sleep2(pyr);
      
      
      
      fr_s1 = Data(frate_binned_s1{1});
      for i = 2:length(frate_binned_s1)
          fr_s1 = [fr_s1 Data(frate_binned_s1{i})];
      end
      fr_s1 = fr_s1(:,pyr);
      fr_s1 = fr_s1';

      fr_s2 = Data(frate_binned_s2{1});
      for i = 2:length(frate_binned_s2)
          fr_s2 = [fr_s2 Data(frate_binned_s2{i})];
      end
      fr_s2 = fr_s2(:,pyr);
      fr_s2 = fr_s2';

      for i = 1:size(fr_s2, 2);

          [EVb(i) EVrb(i) EV_int EVr_int, diff_int] = ...
              ReactEV(log10(frate_sleep1), log10(fr_s2(:,i)), ...
              log10(frate_maze));
          EVb_lo(i) = EV_int(1);
          EVb_hi(i) = EV_int(2);
          EVrb_lo(i) = EVr_int(1);
          EVrb_hi(i) = EVr_int(2);
          diff_lo(i) = diff_int(1);
          diff_hi(i) = diff_int(2);

      end
      
      diff_val{ii} = EVb  - EVrb;
      diff_lo_val{ii} = diff_lo;
      diff_hi_val{ii} = diff_hi;
      
    end
    %%%%%%%%%%%%%%%%55
    
    
    t = Range(frate_binned_s2{1}, 's');
    t = t - t(1)+180;
    
    % empty
    
    fig_spl.x{1} = t;
    fig_spl.n{1} = diff_val{1};
    fig_spl.style{1} = 'b-';
    
    fig_spl.x{2} = t;
    fig_spl.n{2} = diff_lo_val{1};
    fig_spl.style{2} = 'b--';
    
    fig_spl.x{3} = t;
    fig_spl.n{3} = diff_hi_val{1};
    fig_spl.style{3} = 'b--';
    
    %full
    
    fig_spl.x{4} = t;
    fig_spl.n{4} = diff_val{2};
    fig_spl.style{4} = 'r-';
    
    fig_spl.x{5} = t;
    fig_spl.n{5} = diff_lo_val{2};
    fig_spl.style{5} = 'r--';
    
    fig_spl.x{6} = t;
    fig_spl.n{6} = diff_hi_val{2};
    fig_spl.style{6} = 'r--';
    
    
    
    fig_spl.figureType = 'plot';
    fig_spl.figureName = 'DIRACTimeCourseEmptyFull';
    
    fig_st = [ fig_st { fig_spl }];

    
  end
  
  
  
  
  