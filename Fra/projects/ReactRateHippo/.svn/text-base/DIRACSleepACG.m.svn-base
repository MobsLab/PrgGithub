function AO = DIRACSleepACG(A)
  
  Qbin = 60000 * 10; % the time bin for the Qmatrix (in 1/10000 sec)

  
  A = registerResource(A, 'Sleep1ACG', 'numeric', {[], 1}, ...
		       'ACG_s1', ...
		       ['the autocorrelogram of the sleep population ', ...
		    'activity taken in 1 min bins in sleep 1']);
  
   A = registerResource(A, 'Sleep2ACG', 'cell', {1, 1}, ...
		       'ACG_s2', ...
		       ['the autocorrelogram of the sleep population ', ...
		    'activity taken in 1 min bins in sleep 2']);
  
 
  

  A = getResource(A, 'HippoCellList');
  A = getResource(A, 'HippoSpikeData');

  A = getResource(A, 'Sleep1_10min_Epoch');  
  Sleep1 = Sleep1{1};
  A = getResource(A, 'Sleep2_10min_Epoch');    
  Sleep2 = Sleep2{1};
  A = getResource(A, 'PreSleep1_10min_Epoch');
  PreSleep1 = PreSleep1{1};
  A = getResource(A, 'PostSleep2_10min_Epoch');
  PostSleep2 = PostSleep2{1};
  
  Sleep1_all = intervalSet(Start(PreSleep1), End(Sleep1));
  Sleep2_all = intervalSet(Start(Sleep2), End(PostSleep2));
 
  
  
  for i = 1:length(S)
    S_s1{i} = Restrict(S{i}, Sleep1_all);
    S_s2{i} = Restrict(S{i}, Sleep2_all);
  end
  
 sfx = { '_s1', '_s2' };
  
 for i = 1:2
   sf = sfx{i};
   
   eval(['S_epoch = S' sf ';']);
       Q = MakeQfromS(S_epoch, Qbin);

    Q = tsd(Range(Q, 'ts'), full(Data(Q)));
        warning off
    cQ = corrcoef((Data(Q))');
    warning on
    ACG = DiagMean(cQ);
    ACG = ACG(:);
    ACG = {ACG};
    eval(['ACG' sf ' = ACG;']);
    
    
 end
 
 A = saveAllResources(A);
 
 AO = A;