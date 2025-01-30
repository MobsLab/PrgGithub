function AO = CRAMPrePostSleepRates(A)
  
    A = getResource(A, 'HippoSpikeData');
    A = getResource(A, 'PreSleep1_10min_Epoch');  
    PreSleep1 = PreSleep1{1};
  
    A = getResource(A, 'PostSleep2_10min_Epoch');    
    PostSleep2 = PostSleep2{1};

    dim_by_cell = {'HippoCellList', 1};

   A = registerResource(A, 'FRatePreSleep1', 'numeric', dim_by_cell, ...
		       'frate_pre_sleep1', ...
		       ['firing rate in pre-sleep1 period'], 1);
  

   A = registerResource(A, 'FRatePostSleep2', 'numeric', dim_by_cell, ...
			'frate_post_sleep2', ...
			['firing rate in post-sleep2 period'], 1);
   

   

   frate_pre_sleep1 = (mapArray(S, 'AO = rate(TSA, %1);', PreSleep1));
   frate_post_sleep2 = (mapArray(S, 'AO = rate(TSA, %1);', PostSleep2));

   
 

   A = saveAllResources(A);
   
   
   
   AO = A;
