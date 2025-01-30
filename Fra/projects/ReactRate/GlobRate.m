function AO = GlobRate(A)
  
  

  
  
  
  A = getResource(A, 'OldSharpWavesS_S1');
  A = getResource(A, 'OldSharpWavesS_S2');
  A = getResource(A, 'OldSharpWavesE_S1');
  A = getResource(A, 'OldSharpWavesE_S2');
  A = getResource(A, 'OldSharpWavesM_S1');
  A = getResource(A, 'OldSharpWavesM_S2');  
  
  
  A = registerResource(A, 'SPW_s1', 'cell', {1, 1}, ...
		       'spw_s1', ['intervalSet containing ALL the sharp' ...
		    ' waves before maze']);
  A = registerResource(A, 'SPW_s2', 'cell', {1, 1}, ...
		       'spw_s2', ['intervalSet containing ALL the sharp' ...
		    ' waves after maze']);
   A = registerResource(A, 'SPW_M_s1', 'tsdArray', {1, 1}, ...
		       'M_s1', ['tsdArray containing ALL the sharp' ...
		    ' waves peaks before maze']);
   A = registerResource(A, 'SPW_M_s2', 'tsdArray', {1, 1}, ...
		       'M_s2', ['tsdArray containing ALL the sharp' ...
		    ' waves peaks after maze']);

  
  spw_s1 = intervalSet(S_s1.t, E_s1.t);
  spw_s2 = intervalSet(S_s2.t, E_s2.t);
  spw_s1 = { spw_s1 };
  spw_s2 = { spw_s2 };  
	     
  
  M_s1 = ts(M_s1.t);
  M_S2 = ts(M_s2.t);
  M_s1 = tsdArray({ M_s1 });
  M_s2 = tsdArray({ M_s2 });  
  
 
  A = saveResource(A, frate, current_dataset(A), 'GlobRate');
  
  AO = A;
  
  
  