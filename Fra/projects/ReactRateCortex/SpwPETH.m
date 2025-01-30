function AO = SpwPETH(A)
  

  to_plot = 0;
  
  epsilon = 1e-5;
  A = getResource(A, 'CortSpikeData');
  A = getResource(A, 'CortCellNames');
 
  A = getResource(A, 'Sleep1_10min_Epoch');  
  Sleep1 = Sleep1{1};
  
  A = getResource(A, 'Sleep2_10min_Epoch');    
  Sleep2 = Sleep2{1};

  A = getResource(A, 'SPW_s1');
  spw_s1 = spw_s1{1};
  
  A = getResource(A, 'SPW_s2');  
  spw_s2 = spw_s2{1};
  
  A = getResource(A, 'FRateSleep1');
  A = getResource(A, 'FRateSleep2');
  A = getResource(A, 'FRateMaze');
  A = getResource(A, 'X_MS1');
  A = getResource(A, 'X_S2S1');
  
  binsize = 200;
  nbins = 100;
  n_shuffle = 20;
  
  
  
  A = registerResource(A, 'SpwPETH_s1', 'tsdArray', {'CortCellNames', 1}, ...
		       'SpwPETH_s1', ...
		       ['PETH of all the cells triggered on occurrences of ',...
		        'sharp waves in sleep 1']);
  
  A = registerResource(A, 'SpwPETHShuffleC_s1', 'tsdArray', {'CortCellNames', 1}, ...
		       'SpwPETH_shuffle_s1', ...
		       ['PETH of all the cells triggered on occurrences of ',...
		        'sharp waves in sleep 1, with inter-cell shuffling', ...
		   ' the shuffling is to the n-th closest SPW']);
  
  A = registerResource(A, 'SpwPETH_s2', 'tsdArray', {'CortCellNames', 1}, ...
		       'SpwPETH_s2', ...
		       ['PETH of all the cells triggered on occurrences of ',...
		        'sharp waves in sleep 2']);
  
  A = registerResource(A, 'SpwPETHShuffleC_s2', 'tsdArray', {'CortCellNames', 1}, ...
		       'SpwPETH_shuffle_s2', ...
		       ['PETH of all the cells triggered on occurrences of ',...
		        'sharp waves in sleep 2, with inter-cell shuffling', ...
		   ' the shuffling is to the n-th closest SPW']);
  



  spw_s1 = ts(Start(intersect(spw_s1, Sleep1)));
  spw_s2 = ts(Start(intersect(spw_s2, Sleep2)));
  
  S_s1 = map(S, 'TSO = Restrict(TSA, %1);', Sleep1);
  S_s2 = map(S, 'TSO = Restrict(TSA, %1);', Sleep2);
  
  
  
  SpwPETH_s1 = CrossCorr(spw_s1, S_s1, binsize, nbins, ...
			 'timeUnits', 'ms', ...
			 'errors', 'sem');
  SpwPETH_s2 = CrossCorr(spw_s2, S_s2, binsize, nbins, ...
			 'timeUnits', 'ms', ...
			 'errors', 'sem');

  
  nb = size(Data(SpwPETH_s1{1}), 1);
  % do shuffled version for sleep 2 
  
  C_s2 = cellArray(S_s2);
  
  for i = 1:length(C_s2)
    C_s2{i} = Data(C_s2{i});
  end

  st_s2 = cell(length(C_s2), 1);
  sem_s2 = cell(length(C_s2), 1);
  
  for i = 1:length(st_s2)
    st_s2{i} = zeros(nb, 1);
    se_s2{i} = zeros(nb, 1);
  end
  
    
  for nsh = 1:n_shuffle
    C = intervalShuffleClosest_c(C_s2, Range(spw_s2) - 100000, ...
				 Range(spw_s2) + 100000);
    
    
    for i = 1:length(C)
      C{i} = ts(C{i});
    end
    
    S_s2_shuffle = tsdArray(C);
    
    
   S_s2_shuffle = tsdArray(C);
   ss_s2 = CrossCorr(spw_s2, S_s2_shuffle, binsize, nbins, ...
		     'timeUnits', 'ms', ...
		     'errors', 'sem');
    
   for i = 1:length(C)
     d = Data(ss_s2{i});
     st_s2{i}  = st_s2{i} + d(:,1);
     se_s2{i} = se_s2{i} + d(:,2).^2;
   end
   
  end
     
  for i=1:length(C)
    st_s2{i} = st_s2{i}/n_shuffle;
    se_s2{i} = sqrt(se_s2{i})/n_shuffle;
    st_s2{i} = tsd(Range(ss_s2{i}), [st_s2{i} se_s2{i}]);
  end
  SpwPETH_shuffle_s2 = tsdArray(st_s2);
  
  


  % do shuffled version for sleep 1
  
  C_s1 = cellArray(S_s1);
  
  for i = 1:length(C_s1)
    C_s1{i} = Data(C_s1{i});
  end

  st_s1 = cell(length(C_s1), 1);
  sem_s1 = cell(length(C_s1), 1);
  
  for i = 1:length(st_s1)
    st_s1{i} = zeros(nb, 1);
    se_s1{i} = zeros(nb, 1);
  end
  
    
  for nsh = 1:n_shuffle
    C = intervalShuffleClosest_c(C_s1, Range(spw_s1) - 100000, ...
				 Range(spw_s1) + 100000);
    
    
    for i = 1:length(C)
      C{i} = ts(C{i});
    end
    
    S_s1_shuffle = tsdArray(C);
    
    
   S_s1_shuffle = tsdArray(C);
   ss_s1 = CrossCorr(spw_s1, S_s1_shuffle, binsize, nbins, ...
		     'timeUnits', 'ms', ...
		     'errors', 'sem');
    
   for i = 1:length(C)
     d = Data(ss_s1{i});
     st_s1{i}  = st_s1{i} + d(:,1);
     se_s1{i} = se_s1{i} + d(:,2).^2;
   end
   
  end
     
  for i=1:length(C)
    st_s1{i} = st_s1{i}/n_shuffle;
    se_s1{i} = sqrt(se_s1{i})/n_shuffle;
    st_s1{i} = tsd(Range(ss_s1{i}), [st_s1{i} se_s1{i}]);
  end
  SpwPETH_shuffle_s1 = tsdArray(st_s1);
  
 

  if to_plot    
    clf
    subplot(2,1,1);
    Q = merge( SpwPETH_s1);
    q = Data(Q);
    nd = size(q, 2);
    q = mean(q(:,1:2:end),2);
    sq = sqrt(sum(q(:,2:2:end).^2, 2))/nd;
    errorbar(Range(Q, 's'), q, sq);
    
    hold on 
    
    Q = merge( SpwPETH_shuffle_s1);
    q = Data(Q);
    nd = size(q, 2);
    mq = mean(q(:,1:2:end),2);
    sq = sqrt(sum(q(:,2:2:end).^2, 2))/nd;
    errorbar(Range(Q, 's'), mq, sq, 'r');
    
    
    
    
    subplot(2,1,2);

    Q = merge( SpwPETH_s2);
    q = Data(Q);
    nd = size(q, 2);
    mq = mean(q(:,1:2:end),2);
    sq = sqrt(sum(q(:,2:2:end).^2, 2))/nd;
    errorbar(Range(Q, 's'), mq, sq);
    
    hold on 
    
    Q = merge( SpwPETH_shuffle_s2);
    q = Data(Q);
    nd = size(q, 2);
    
    mq = mean(q(:,1:2:end),2);
    sq = sqrt(sum(q(:,2:2:end).^2, 2))/nd;
    errorbar(Range(Q, 's'), mq, sq, 'r');
    
    
    
    keyboard
    
  end
  
      
  
 

  
  


  
  
  

  
  
  
  
  
  
  
  A = saveAllResources(A);

  
  
  AO = A;
  
  
  