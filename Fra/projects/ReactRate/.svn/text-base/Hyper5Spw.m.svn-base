function AO = Hyper5Spw(A)
  
  A = getResource(A, 'Sleep1_All_Epoch');
  A = getResource(A, 'Sleep2_All_Epoch');
  A = getResource(A, 'Sleep3_All_Epoch');
  Sleep1_all = Sleep1_all{1};
  Sleep2_all = Sleep2_all{1};
  Sleep3_all = Sleep3_all{1};
  
  
  
  A = registerResource(A, 'SPW_s1', 'cell', {1, 1}, ...
		       'spw_s1', ['intervalSet containing ALL the sharp' ...
		    ' waves before maze']);
  
  A = registerResource(A, 'SPW_s2', 'cell', {1, 1}, ...
		       'spw_s2', ['intervalSet containing ALL the sharp' ...
		    ' waves after maze 1']);
  
  A = registerResource(A, 'SPW_s3', 'cell', {1, 1}, ...
		       'spw_s3', ['intervalSet containing ALL the sharp' ...
		    ' waves after maze 2']);
  
 
  
  
  rips = load([current_dir(A) filesep 'riptimes.ascii']);
  
  spw = intervalSet(rips(:,1), rips(:,2));
  

  
  spw_s1 = intersect(spw, Sleep1_all);
  spw_s2 = intersect(spw, Sleep2_all);
  spw_s3 = intersect(spw, Sleep3_all);


  spw_s1 = { spw_s1 };
  spw_s2 = { spw_s2 };  
  spw_s3 = { spw_s3 };

  
  
  A = saveAllResources(A);
    
  AO = A;
  
  
  