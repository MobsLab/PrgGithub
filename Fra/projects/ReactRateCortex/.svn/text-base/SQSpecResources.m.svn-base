function AO = SQSpecResources(A)
  
 
  
  A = registerResource(A, 'FrequencyFast', 'numeric', {[], 1}, ...
		      'freq_fast', ...
		      ['frequency values in Hz for the "fast"', ...
		    ' specgram']);
  
  A = registerResource(A, 'FrequencySlow', 'numeric', {[], 1}, ...
		      'freq_slow', ...
		      ['frequency values in Hz for the "slow"', ...
		    ' specgram']);
  
  A = registerResource(A, 'IntDelta', 'cell', {1, 1}, ...
		       'I_delta', ...
		       ['intervalSet corresponding to time spent in', ...
		    ' delta/slow oscillations']);
  

  A = registerResource(A, 'IntGamma', 'cell', {1, 1}, ...
		       'I_gamma', ...
		       ['intervalSet corresponding to time spent in', ...
		    ' gamma oscillations']);
  

  
  
  cd(current_dir(A));

  warning off
  if exist('mt_SQ_specgram.mat') == 2
    load mt_SQ_specgram;
  elseif exist('old_analysis/mt_SQ_specgram.mat') == 2
    load old_analysis/mt_SQ_specgram
  else
    error('couldn''t find specgram file');
  end
  
  warning on 
  
  cd(parent_dir(A));

  SQ_specgram_fast_s1 = tsd(tix_s1*10000, sp_s1');
  SQ_specgram_fast_s2 = tsd(tix_s2*10000, sp_s2');  
  SQ_specgram_slow_s1 = tsd(tix_slow_s1*10000, sp_slow_s1');
  SQ_specgram_slow_s2 = tsd(tix_slow_s2*10000, sp_slow_s2');  
  
  freq_fast = F_s1;
  freq_slow = F_slow_s1;
  
  
  I_delta_s1 = intervalSet(S_delta_s1.t, E_delta_s1.t);
  I_delta_s2 = intervalSet(S_delta_s2.t, E_delta_s2.t);  
  
  I_delta = cat(I_delta_s1, I_delta_s2);
  
  I_gamma_s1 = intervalSet(S_gamma_s1.t, E_gamma_s1.t);
  I_gamma_s2 = intervalSet(S_gamma_s2.t, E_gamma_s2.t);  
  
  I_gamma = cat(I_gamma_s1, I_gamma_s2);
  

  
  
  cd(current_dir(A));
  
  save SQspecgram SQ_specgram_fast_s1 SQ_specgram_fast_s2 SQ_specgram_slow_s1 ...
      SQ_specgram_slow_s1 SQ_specgram_slow_s2 freq_fast freq_slow I_delta I_gamma
  
  cd(parent_dir(A));
  
  
  
  A = saveAllResources(A);
  
  
  AO = A;
  

  
