function AO = ReactRateSpindles(A)
%  AO = ReactRateSpindle(A) computes firing rates during spindle
%  episodes, for datasets that had at least 60 s of spindles in each
%  sleep episode
  
  sp_shift = 200000;
  to_plot = 0;
  
  A = getResource(A, 'CortSpikeData');
  dim_by_cell = {'CortCellNames', 1};

  
  A = getResource(A, 'Sleep1_10min_Epoch');  
  Sleep1 = Sleep1{1};
  
  Sleep1_tot = intervalSet(0, End(Sleep1)); % get all of Sleep1, not just
                                            % 10 min
  
  
  
  A = getResource(A, 'Sleep2_10min_Epoch');    
  Sleep2 = Sleep2{1};
  
  Sleep2_tot = intervalSet(Start(Sleep2), 1e20); % get all of Sleep2
  
  

  A = getResource(A, 'IntSpindle');
  I_spindle = I_spindle{1};
  
  I_spindle_s1 = intersect(I_spindle, Sleep1_tot);
  I_spindle_s2 = intersect(I_spindle, Sleep2_tot);
  
  
  
  
  A = registerResource(A, 'FRateSpindleSleep1', 'numeric', dim_by_cell, ...
		       'frate_spindle_sleep1', ...
		       ['firing rate in sleep1 period in spindle periods.', ...
		    ' For datasets in which there was less than 60s of' ...
		     ' spindle, returns NaNs'], 1);

  A = registerResource(A, 'FRateSpindleSleep2', 'numeric', dim_by_cell, ...
		       'frate_spindle_sleep2', ...
		       ['firing rate in sleep2 period in spindle periods.', ...
		   'For datasets in which there was less than 60s of', ...
		    ' spindle, return NaNs' ], 1);

  A = registerResource(A, 'FRateNoSpindleSleep1', 'numeric', dim_by_cell, ...
		       'frate_no_spindle_sleep1', ...
		       ['firing rate in sleep1 period in control periods.', ...
		    'taken 10 s after each spindle episode', ...
		    ' For datasets in which there was less than 60s of', ...
		     ' spindle, returns NaNs'], 1);

  A = registerResource(A, 'FRateNoSpindleSleep2', 'numeric', dim_by_cell, ...
		       'frate_no_spindle_sleep2', ...
		       ['firing rate in sleep2 period in control periods.', ...
		    'taken 10 s after each episode', ...
		   'For datasets in which there was less than 60s of', ...
		    ' spindle, return NaNs' ], 1);

  
  
  if(tot_length(I_spindle_s1, 's') <  60)
    frate_spindle_sleep1 = NaN * zeros(length(S), 1); % don't bother make
                                                      % a rate
                                                      % measurement if
                                                      % there is less
                                                      % than 60 s of
                                                      % spindles
    frate_no_spindle_sleep1 = NaN * zeros(length(S), 1);						      
  else
    frate_spindle_sleep1 =  (mapArray(S, 'AO = rate(TSA, %1);', ...
				      I_spindle_s1));
    I_no_spindle_s1 = shift(I_spindle_s1, sp_shift);
    disp('sleep1');
    tot_length(intersect(I_spindle_s1, I_no_spindle_s1)) / ...
	tot_length(I_spindle_s1)
    
    
    frate_no_spindle_sleep1 =  (mapArray(S, 'AO = rate(TSA, %1);', ...
				      I_no_spindle_s1));
    
    
    
  end
  
  if(tot_length(I_spindle_s2, 's') <  60)
    frate_spindle_sleep2 = NaN * zeros(length(S), 1); % don't bother make
                                                      % a rate
                                                      % measurement if
                                                      % there is less
                                                      % than 60 s of
                                                      % spindles
    frate_no_spindle_sleep2 = NaN * zeros(length(S), 1);						      
  else  
    frate_spindle_sleep2 =  (mapArray(S, 'AO = rate(TSA, %1);', ...
				      I_spindle_s2)); 
    
    I_no_spindle_s2 = shift(I_spindle_s2, sp_shift);
    disp('sleep2');
    tot_length(intersect(I_spindle_s2, I_no_spindle_s2)) /...
	tot_length(I_spindle_s2)
    
    frate_no_spindle_sleep2 =  (mapArray(S, 'AO = rate(TSA, %1);', ...
				      I_no_spindle_s2));


	
	
	
  end
    
	


       
   
   
   A = saveAllResources(A);
   
   
   
   AO = A;
   