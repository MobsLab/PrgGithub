function AO = ReactRateByDelta(A)
%  AO = ReactRateByDelta(A) computes delta power in intervals aligned
%  with ReactBinnedR
  
  to_plot = 0;
  
  A = getResource(A, 'CortSpikeData');
  dim_by_cell = {'CortCellNames', 1};

  
  A = getResource(A, 'Sleep1_10min_Epoch');  
  Sleep1 = Sleep1{1};
  
  A = getResource(A, 'Sleep2_10min_Epoch');    
  Sleep2 = Sleep2{1};

  
  A = getResource(A, 'SQSpecgramSlowS2');
%  SQ_specgram_slow_s2 = SQ_specgram_slow_s2{1};
  A = getResource(A, 'SQSpecgramSlowS1');  
  A = getResource(A, 'ReactBinnedR');
  A = getResource(A, 'IntDelta');
  I_delta = I_delta{1};
  
  react_binned_r = react_binned_r{1};
  
  A = getResource(A, 'FrequencySlow');
  
  
  A = registerResource(A, 'FRateDeltaSleep1', 'numeric', dim_by_cell, ...
		       'frate_delta_sleep1', ...
		       ['firing rate in sleep1 period in delta periods'], 1);

  A = registerResource(A, 'FRateDeltaSleep2', 'numeric', dim_by_cell, ...
		       'frate_delta_sleep2', ...
		       ['firing rate in sleep2 period in delta periods'], 1);

  A = registerResource(A, 'FRateNoDeltaSleep1', 'numeric', dim_by_cell, ...
		       'frate_no_delta_sleep1', ...
		       ['firing rate in sleep1 period in non-delta periods'], 1);

  A = registerResource(A, 'FRateNoDeltaSleep2', 'numeric', dim_by_cell, ...
		       'frate_no_delta_sleep2', ...
		       ['firing rate in sleep2 period in non-delta periods'], 1);

  
  
  A = registerResource(A, 'DeltaPowerS1', 'tsdArray', {1,1}, ...
		       'delta_power_s1', ...
		       ['the SQ power in the "delta" range (0.8-4Hz), in sleep1']);
  A = registerResource(A, 'DeltaPowerS2', 'tsdArray', {1,1}, ...
		       'delta_power_s2', ...
		       ['the power in the "delta" range (0.8-4Hz), in' ...
		    ' sleep2']);
  A = registerResource(A, 'DeltaPowerNormS1', 'tsdArray', {1,1}, ...
		       'delta_power_norm_s1', ...
		       ['the SQ power in the delta range (0.8-4Hz) in' ...
		    ' sleep1, normalized by total power ']);
  A = registerResource(A, 'DeltaPowerNormS2', 'tsdArray', {1,1}, ...
		       'delta_power_norm_s2', ...
		       ['the SQ power in the delta range (0.8-4Hz) in' ...
		    ' sleep2, normalized by total power ']);
 
  
  A = registerResource(A, 'DeltaBinnedS2', 'tsdArray', {1, 1}, ...
		       'delta_binned_s2', ...
		       ['delta power for s2 binned with the same binning', ...
		    ' as ReactBinnedR']);
  
  
   A = registerResource(A, 'DeltaNormBinnedS2', 'tsdArray', {1, 1}, ...
		       'delta_norm_binned_s2', ...
		       ['delta normalized power for s2 binned with the same binning', ...
		    ' as ReactBinnedR']);
  

  I_delta_s1 = intersect(Sleep1, I_delta);
  I_delta_s2 = intersect(Sleep2, I_delta);
   
  I_no_delta_s1 = diff(Sleep1, I_delta);
  I_no_delta_s2 = diff(Sleep2, I_delta);
  
  
  
  ix = find(freq_slow > 0.8 & freq_slow < 4);
  
  d = Data(SQ_specgram_slow_s1);
  delta_power_s1 =  tsd(Range(SQ_specgram_slow_s1), sum((abs(d(:,ix)).^2),2));
  delta_power_norm_s1 = tsd(Range(SQ_specgram_slow_s1), ...
		sum((abs(d(:,ix)).^2),2) ./sum(abs(d.^2),2));	    
  
  
  
  d = Data(SQ_specgram_slow_s2);
  delta_power_s2 =  tsd(Range(SQ_specgram_slow_s2), sum((abs(d(:,ix)).^2), 2));   delta_power_norm_s2 = tsd(Range(SQ_specgram_slow_s2), ...
		sum((abs(d(:,ix)).^2),2) ./sum(abs(d.^2),2));	    
 
  
  delta_binned_s2 = intervalMean(delta_power_s2,...
				 toIntervalSet(react_binned_r));
  
  
  delta_norm_binned_s2 = intervalMean(delta_power_norm_s2, ...
				      toIntervalSet(react_binned_r));				      

  frate_delta_sleep1 =  (mapArray(S, 'AO = rate(TSA, %1);', I_delta_s1));
  frate_delta_sleep2 =  (mapArray(S, 'AO = rate(TSA, %1);', I_delta_s2));  

  frate_no_delta_sleep1 =  (mapArray(S, 'AO = rate(TSA, %1);', I_no_delta_s1));
  frate_no_delta_sleep2 =  (mapArray(S, 'AO = rate(TSA, %1);', I_no_delta_s2));  

       
   
   
   A = saveAllResources(A);
   
   
   
   AO = A;
   