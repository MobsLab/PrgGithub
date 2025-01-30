function AO = globalBinnedFRateSleep2(A)
  
  
% $$$   A = getResource(A, 'CortSpikeData');
% $$$   A = getResource(A, 'Sleep2_10min_Epoch');    
% $$$   Sleep2 = Sleep2{1};
% $$$ 
  
  A = getResource(A, 'FRateBinnedS2');
  
  A = registerResource(A, 'GlobalBinnedFRateSleep2', 'tsdArray', {1,1}, ...
		       'global_binned_frate_sleep2', ...
		       ['population firing rate in sleep2 binned in 1 min periods,', ...
		       ' at 20 s shifts'], 1);
  
  
% $$$   Sleep2_binning = regular_interval(FirstTime(Sleep2), ...
% $$$ 				    LastTime(Sleep2)+4800000, ...
% $$$ 				    600000, 200000);
% $$$   frate_binned_s2 = map(S, 'TSO = intervalRate(TSA, %1);', Sleep2_binning);

  fr = merge(frate_binned_s2);
  
  
  
  global_binned_frate_sleep2 = tsd(Range(frate_binned_s2{1}), mean(Data(fr), ...
						  2));
  
  A = saveAllResources(A);
  
  AO = A;
  
  