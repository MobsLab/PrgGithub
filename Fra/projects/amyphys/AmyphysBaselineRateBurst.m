function AO = AmyphysBaselineRateBurst(A)
  
  burstThresh = 10; % in ms
  
  A = getResource(A, 'BaselinePeriod');
  baselinePeriod = baselinePeriod{1};
  
  A = getResource(A, 'StableInterval');

  
  A = getResource(A, 'AmygdalaCellList');
  A = getResource(A, 'AmygdalaSpikeData');
  dim_by_cell = {'AmygdalaCellList', 1};

  A = registerResource(A, 'FRateBaseline', 'numeric', dim_by_cell, ...
		       'frateBaseline', ...
		       ['firing rate in the baseline period for the times', ...
		    [' for the times in which cell was consedred', ...
		     ' stable']]);
  
  
  A = registerResource(A, 'FRateGlobal', 'numeric', dim_by_cell, ...
		       'frateGlobal', ...
		       ['firing rate ', ...
		    [' for the times in which cell was consedred', ...
		     ' stable']]);
  
  A = registerResource(A, 'BurstinessGlobal', 'numeric', dim_by_cell, ...
		       'burstinessGlobal', ...
		       ['burstiness ratio in global firing']);
  
  A = registerResource(A, 'BurstinessBaseline', 'numeric', dim_by_cell, ...
		       'burstinessBaseline', ...
		       ['burstiness ratio during baseline periods']);
  

  
  
  
  frateBaseline = zeros(length(S), 1);
  frateGlobal = zeros(length(S), 1);
  burstinessBaseline = zeros(length(S), 1);
  burstinessGlobal = zeros(length(S), 1);
  
  
  for i = 1:length(S)
    ib = intersect(stableInterval{i}, baselinePeriod);
    frateBaseline(i) = rate(S{i}, ib);
    frateGlobal(i) = rate(S{i}, stableInterval{i});
    Sglobal = Restrict(S{i}, stableInterval{i});

    % compute the number of spikes which takes place within a burst
    
    t = Range(Sglobal, 'ms');
    ix = find(diff(t)<burstThresh)+1;
    if ~isempty(ix)
      ix1 = [ix(1)-1; ix(find(diff(ix) > 1)+1)-1];
      ix = sort([ix;ix1]);
    end

    s_burst = ts(t(ix));
    ix = setdiff(1:length(t), ix);
    s_nonburst = ts(t(ix));
    burstinessGlobal(i) = length(s_burst) / length(s_nonburst);
   
    
    Sbaseline = Restrict(S{i}, ib);
    t = Range(Sbaseline, 'ms');
    
    ix = find(diff(t)<burstThresh)+1;
    if ~isempty(ix)
      ix1 = [ix(1)-1; ix(find(diff(ix) > 1)+1)-1];
      ix = sort([ix;ix1]);
    end

    s_burst = ts(t(ix));
    ix = setdiff(1:length(t), ix);
    s_nonburst = ts(t(ix));
   
    
    
    burstinessBaseline(i) = length(s_burst) / length(s_nonburst);
  
  end
  
  A = saveAllResources(A);
  
  AO = A;
  
  
  
  

  
  
  