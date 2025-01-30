function AO = showPopSpecgram(A)
  
 
  
 
  

  
  
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
  

  
  ix = find(F_s1 < 30);
  ix_spindles = find(F_s1 > 5 & F_s1 < 12);
  
  
  
  figure(1)
  clf

  imagesc(tix_s1, F_s1(ix), log(abs(sp_s1(ix,:))))
  title([current_dir(A) ' sleep 1'])
  axis xy
  set(gcf, 'position', [232  648  1339  420])
  
  figure(2)
  clf

  imagesc(tix_s2, F_s2(ix), log(abs(sp_s2(ix,:))))
  title([current_dir(A) ' sleep 2'])
  axis xy
  set(gcf, 'position', [229  133  1343  420]);
  
  keyboard

  
  
  
 
  
  AO = A;
  

  
