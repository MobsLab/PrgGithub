function AO = SleepBurstiness(A)
% AO = SleepBustiness(A)
  
  burstThresh = 5 * 10; % the ISI threshold for burstiness in ms * 10
  
  A = getResource(A, 'CortSpikeData');
  A = getResource(A, 'Sleep1_10min_Epoch');  
  Sleep1 = Sleep1{1};
  
  A = getResource(A, 'Sleep2_10min_Epoch');    
  Sleep2 = Sleep2{1};
  
  dim_by_cell = {'CortCellNames', 1};

  
  
  A = registerResource(A, 'FRateBurstSleep1', 'numeric', dim_by_cell, ...
		       'frate_burst_sleep1', ...
		       ['firing rate in sleep1 period, only for spikes', ...
		    ' that are part of a burst, intended as less than 5', ...
		    ' ms intervals'], 1);
  
  A = registerResource(A, 'FRateNoBurstSleep1', 'numeric', dim_by_cell, ...
		       'frate_no_burst_sleep1', ...
		       ['firing rate in sleep1 period, only for spikes', ...
		    ' that are NOT part of a burst, intended as less than 5', ...
		    ' ms intervals'], 1);
  
  
  A = registerResource(A, 'FRateBurstSleep2', 'numeric', dim_by_cell, ...
		       'frate_burst_sleep2', ...
		       ['firing rate in sleep2 period, only for spikes', ...
		    ' that are part of a burst, intended as less than 5', ...
		    ' ms intervals'], 1);
  
  A = registerResource(A, 'FRateNoBurstSleep2', 'numeric', dim_by_cell, ...
		       'frate_no_burst_sleep2', ...
		       ['firing rate in sleep2 period, only for spikes', ...
		    ' that are NOT part of a burst, intended as less than 5', ...
		    ' ms intervals'], 1);  
  
  A = registerResource(A, 'FRateBurstBinnedSleep2', 'tsdArray', dim_by_cell,...
		       'frate_burst_binned_s2', ...
		       ['burst firing rate in sleep2 period, binned as' ...
		    ' for ReactRate'], 1);
  
   A = registerResource(A, 'FRateNoBurstBinnedSleep2', 'tsdArray', dim_by_cell,...
		       'frate_no_burst_binned_s2', ...
		       ['burst firing rate in sleep2 period, binned as' ...
		    ' for ReactRate'],1);
  
 
  
  
  
  A = registerResource(A, 'BurstFractionSleep1', 'numeric', dim_by_cell, ...
		       'burst_fraction_sleep1', ...
		       ['the fraction of total spikes that are part of a', ...
		    ' burst, in sleep1'], 1);
  
  A = registerResource(A, 'BurstFractionSleep2', 'numeric', dim_by_cell, ...
		       'burst_fraction_sleep2', ...
		       ['the fraction of total spikes that are part of a', ...
		    ' burst, in sleep2'], 1);  
  
  
  
  frate_burst_sleep1 = zeros(length(S),1);
  frate_burst_sleep2 = zeros(length(S),1);
  frate_no_burst_sleep1 = zeros(length(S),1);
  frate_no_burst_sleep2 = zeros(length(S),1);
  burst_fraction_sleep1 = zeros(length(S),1);
  burst_fraction_sleep2 = zeros(length(S),1);  
  
  frate_burst_binned_s2 = tsdArray(length(S), 1);
  frate_no_burst_binned_s2 = tsdArray(length(S), 1);
  
  
  for i = 1:length(S)
    t = Range(S{i});
  
    ix = find(diff(t)<burstThresh)+1;
    if ~isempty(ix)
      ix1 = [ix(1)-1; ix(find(diff(ix) > 1)+1)-1];
      ix = sort([ix;ix1]);
    end
    
    s_burst = ts(t(ix));
    
    ix = setdiff(1:length(t), ix);
    s_nonburst = ts(t(ix));
    
    frate_burst_sleep1(i) = rate(s_burst, Sleep1);
    frate_burst_sleep2(i) = rate(s_burst, Sleep2);    
    frate_no_burst_sleep1(i) = rate(s_nonburst, Sleep1);
    frate_no_burst_sleep2(i) = rate(s_nonburst, Sleep2);    
    
    burst_fraction_sleep1(i) = length(Data(Restrict(s_burst, Sleep1))) / ...
	length(Data(Restrict(S{i}, Sleep1)));
    burst_fraction_sleep2(i) = length(Data(Restrict(s_burst, Sleep1))) / ...
	length(Data(Restrict(S{i}, Sleep2)));
    
    
    Sleep2_binning = regular_interval(FirstTime(Sleep2), ...
				    LastTime(Sleep2)+4800000, ...
				    600000, 200000);

    
    frate_burst_binned_s2{i} = intervalRate(s_burst, Sleep2_binning);
    frate_no_burst_binned_s2{i} = intervalRate(s_nonburst, Sleep2_binning);    
    
    
  end
  

  
  
   A = saveAllResources(A);
   AO = A;
     