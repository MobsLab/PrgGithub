function AO = DIRACPrePostSleepRates(A)
  
    A = getResource(A, 'HippoSpikeData');
    A = getResource(A, 'PreSleep1_10min_Epoch');  
    PreSleep1 = PreSleep1{1};
  
    A = getResource(A, 'PostSleep2_10min_Epoch');    
    PostSleep2 = PostSleep2{1};
    A = getResource(A, 'SPW_s1');
    spw_s1 = spw_s1{1};
  
    A = getResource(A, 'SPW_s2');  
    spw_s2 = spw_s2{1};

    dim_by_cell = {'HippoCellList', 1};

   A = registerResource(A, 'FRatePreSleep1', 'numeric', dim_by_cell, ...
		       'frate_pre_sleep1', ...
		       ['firing rate in pre-sleep1 period'], 1);
  

   A = registerResource(A, 'FRatePostSleep2', 'numeric', dim_by_cell, ...
			'frate_post_sleep2', ...
			['firing rate in post-sleep2 period'], 1);
   
   A = registerResource(A, 'FRateSPWPreSleep1', 'numeric', dim_by_cell, ...
			'frate_spw_pre_sleep1', ...
			['firing rate in sleep1 period',...
		    ' during sharp waves'], 1);
   
   A = registerResource(A, 'FRateSPWPostSleep2', 'numeric', dim_by_cell, ...
			'frate_spw_post_sleep2', ...
			['firing rate in sleep1 period',...
		    ' during sharp waves'], 1);

   A = registerResource(A, 'FRateNoSPWPreSleep1', 'numeric', dim_by_cell, ...
			'frate_no_spw_pre_sleep1', ...
			['firing rate in sleep1 period',...
		    ' during inter sharp waves times'], 1);
   
   A = registerResource(A, 'FRateNoSPWPostSleep2', 'numeric', dim_by_cell, ...
			'frate_no_spw_post_sleep2', ...
			['firing rate in sleep2 period',...
		    ' during inter sharp waves times'], 1);
   

   frate_pre_sleep1 = (mapArray(S, 'AO = rate(TSA, %1);', PreSleep1));
   frate_post_sleep2 = (mapArray(S, 'AO = rate(TSA, %1);', PostSleep2));

   
   spw_s1= intersect(PreSleep1, spw_s1);
   no_spw_s1 = PreSleep1 - spw_s1;
   
   spw_s2= intersect(PostSleep2, spw_s2);
   no_spw_s2 = PostSleep2 - spw_s2;

   frate_spw_pre_sleep1 = (mapArray(S, 'AO = rate(TSA, %1);', spw_s1));
   frate_no_spw_pre_sleep1 = (mapArray(S, 'AO = rate(TSA, %1);', no_spw_s1));  
   frate_spw_post_sleep2 = (mapArray(S, 'AO = rate(TSA, %1);', spw_s2));    
   frate_no_spw_post_sleep2 = (mapArray(S, 'AO = rate(TSA, %1);', no_spw_s2));

   A = saveAllResources(A);
   
   
   
   AO = A;
