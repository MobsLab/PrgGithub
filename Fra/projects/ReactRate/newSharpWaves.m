function AO = newSharpWaves(A)
  
  

  
  do_s2 = 1;  
  
  do_s1 = 0;
  

  if do_s1
    A = getResource(A, 'OldSharpWavesS_S1');
    A = getResource(A, 'OldSharpWavesE_S1');
    A = getResource(A, 'OldSharpWavesM_S1');
  end
  


  if do_s2
    A = getResource(A, 'OldSharpWavesS_S2');
    A = getResource(A, 'OldSharpWavesE_S2');
    A = getResource(A, 'OldSharpWavesM_S2');  
  end
  
  
  if do_s1
    A = registerResource(A, 'SPW_s1', 'cell', {1, 1}, ...
			 'spw_s1', ['intervalSet containing ALL the sharp' ...
		    ' waves before maze']);
    
    A = registerResource(A, 'SPW_M_s1', 'tsdArray', {1, 1}, ...
			 'M_s1', ['tsdArray containing ALL the sharp' ...
		    ' waves peaks before maze']);
    
  end
  
  
   if do_s2
     A = registerResource(A, 'SPW_s2', 'cell', {1, 1}, ...
			  'spw_s2', ['intervalSet containing ALL the sharp' ...
		    ' waves after maze']);
     
     A = registerResource(A, 'SPW_M_s2', 'tsdArray', {1, 1}, ...
			  'M_s2', ['tsdArray containing ALL the sharp' ...
		    ' waves peaks after maze']);
   
   end
  
  if do_s1 
    spw_s1 = intervalSet(S_s1.t, E_s1.t);
    spw_s1 = { spw_s1 };
    M_s1 = ts(M_s1.t);
    M_s1 = tsdArray({ M_s1 });
    A = saveResource(A, spw_s1, current_dataset(A), 'SPW_s1');
    A = saveResource(A, M_s1, current_dataset(A), 'SPW_M_s1');  
 end
  
  if do_s2
    spw_s2 = intervalSet(S_s2.t, E_s2.t);
    spw_s2 = { spw_s2 };  
    M_s2 = ts(M_s2.t);
    M_s2 = tsdArray({ M_s2 });  
    A = saveResource(A, spw_s2, current_dataset(A), 'SPW_s2');
    A = saveResource(A, M_s2, current_dataset(A), 'SPW_M_s2');    
  end
  
  
  AO = A;
  
  
  