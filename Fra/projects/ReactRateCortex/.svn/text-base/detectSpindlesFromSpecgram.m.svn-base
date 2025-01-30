function AO = detectSpindlesFromSpecgram(A)
  
 
  
  to_plot = 0;
  
  A = registerResource(A, 'IntSpindle', 'cell', {1, 1}, ...
		       'I_spindle', ...
		       ['intervalSet corresponding to the time spent in', ...
		        ' spindle oscillations']);
  
  
  
  cd(current_dir(A));

  warning off
  if exist('mt_SQ_specgram.mat') == 2
    load mt_SQ_specgram.mat ;
  elseif exist('old_analysis/mt_SQ_specgram.mat') == 2
    load old_analysis/mt_SQ_specgram.mat 
  else
    error('couldn''t find specgram file');
  end
  
  warning on 
  
  cd(parent_dir(A));

  SQ_specgram_fast_s1 = tsd(tix_s1*10000, sp_s1');
  SQ_specgram_fast_s2 = tsd(tix_s2*10000, sp_s2');  
  SQ_specgram_slow_s1 = tsd(tix_slow_s1*10000, sp_slow_s1');
  SQ_specgram_slow_s2 = tsd(tix_slow_s2*10000, sp_slow_s2');  
  

  
  ix = find(F_s1 < 30);
  ix_spindles = find(F_s1 > 7 & F_s1 < 20);

  sp_spindles_s1 = sp_s1(ix_spindles,:);
  spindles_power_s1 = (sum(sp_spindles_s1 .* sp_spindles_s1, 1));
  sp_pow_std_s1 = median(spindles_power_s1);
  spindles_power_s1 = tsd(tix_s1*10000, spindles_power_s1');
  sp_s1_plot = 15 + Data(spindles_power_s1) * 15 / ...
      percentile(Data(spindles_power_s1), 99.5); 
  
  s = thresholdHysteresis(spindles_power_s1, ...
			  10 * sp_pow_std_s1, 1 * sp_pow_std_s1, ...
			  'Crossing', 'Rising', ...
			  'Order', 'Before');
  e = thresholdHysteresis(spindles_power_s1, ...
			  10 * sp_pow_std_s1, 1 * sp_pow_std_s1, ...
			  'Crossing', 'Falling', ...
			  'Order', 'After');
  I_spindle_s1 = intervalSet(s,e, '-fixit');
  
  
  sp_spindles_s2 = sp_s2(ix_spindles,:);
  spindles_power_s2 = (sum(sp_spindles_s2 .* sp_spindles_s2, 1));
  sp_pow_std_s2 = median(spindles_power_s2);
  spindles_power_s2 = tsd(tix_s2*10000, spindles_power_s2');
  sp_s2_plot = 15 + Data(spindles_power_s2) * 15 / ...
      percentile(Data(spindles_power_s2), 99.5); 
  s = thresholdHysteresis(spindles_power_s2, ...
			  10 * sp_pow_std_s2, 1 * sp_pow_std_s2, ...
			  'Crossing', 'Rising', ...
			  'Order', 'Before');
  e = thresholdHysteresis(spindles_power_s2, ...
			  10 * sp_pow_std_s2, 1 * sp_pow_std_s2, ...
			  'Crossing', 'Falling', ...
			  'Order', 'After');
  I_spindle_s2 = intervalSet(s,e, '-fixit');
  
  
  I_spindle = union(I_spindle_s1,  I_spindle_s2);
  
  
  if to_plot
    
    figure(1)
    clf

    imagesc(tix_s1, F_s1(ix), log(abs(sp_s1(ix,:))))
    title([current_dir(A) ' sleep 1'], 'interpreter', 'none')
    axis xy
    hold on 
    plot(Range(spindles_power_s1, 's'), sp_s1_plot);
    plot(Start(I_spindle_s1, 's'), ...
	 10 * ones(size(Start(I_spindle_s1))), 'go')
    plot(End(I_spindle_s1, 's'), ...
	 10 * ones(size(Start(I_spindle_s1))), 'ro')
    disp('sleep 1:')
    tot_length(I_spindle_s1, 's')
    
    
    
    set(gcf, 'position', [ 7 560 1268 420])
    
    figure(2)
    clf

    imagesc(tix_s2, F_s2(ix), log(abs(sp_s2(ix,:))))
    title([current_dir(A) ' sleep 2'], 'interpreter', 'none')
    axis xy
    hold on 
    plot(Range(spindles_power_s2, 's'), sp_s2_plot);
    plot(Start(I_spindle_s2, 's'), ...
	 10 * ones(size(Start(I_spindle_s2))), 'go')
    plot(End(I_spindle_s2, 's'), ...
	 10 * ones(size(Start(I_spindle_s2))), 'ro')
    disp('sleep 2:')
    tot_length(I_spindle_s2, 's')
    
    
    set(gcf, 'position', [ 7 61 1268 420]);
    
    keyboard

  end
  
  
  A = saveAllResources(A);

  
  AO = A;
  

  
