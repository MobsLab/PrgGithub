function AO = ReactRateSpwClusteredPETH(A)
  
  to_plot = 0;
  epsilon = 1e-5;
  n_shuffle = 20;
  
  
  %%%%%%%%%%%%%%%%%%%
  
  A = getResource(A, 'CortSpikeData');
  
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
  
  binsize = 200 * 10; % binning for the Qmatrix
  
  
  A = registerResource(A, 'ReactR200ClustSpwPETHS2', 'tsdArray', {1, 1}, ...
		       'reactR_clust_spw_peth_s2', ...
		       ['PETH of the react R time series centered on the', ...
		    ' clustered SPW occurrences, in sleep 2']);

  A = registerResource(A, 'ReactR200ClustSpwPETHShuffleCS2', 'tsdArray', {1, 1}, ...
		       'reactR_clust_spw_peth_shuffle_s2', ...
		       ['PETH of the react R time series centered on the', ...
		    ' clustered SPW occurrences, in sleep 2, with inter-cell shuffling', ...
		    ' the shuffling is to the n-th closest SPW']);
  
  
  A = registerResource(A, 'ReactR200IsolSpwPETHS2', 'tsdArray', {1, 1}, ...
		       'reactR_isol_spw_peth_s2', ...
		       ['PETH of the react R time series centered on the', ...
		    ' isolated SPW occurrences, in sleep 2']);

  A = registerResource(A, 'ReactR200IsolSpwPETHShuffleCS2', 'tsdArray', {1, 1}, ...
		       'reactR_isol_spw_peth_shuffle_s2', ...
		       ['PETH of the react R time series centered on the', ...
		    ' isolated SPW occurrences, in sleep 2, with inter-cell shuffling', ...
		    ' the shuffling is to the n-th closest SPW']);
  
  

  
  
  A = registerResource(A, 'ReactR200ClustSpwPETHS1', 'tsdArray', {1, 1}, ...
		       'reactR_clust_spw_peth_s1', ...
		       ['PETH of the react R time series centered on the', ...
		    ' clustered SPW occurrences, in sleep 1']);

  A = registerResource(A, 'ReactR200ClustSpwPETHShuffleCS1', 'tsdArray', {1, 1}, ...
		       'reactR_clust_spw_peth_shuffle_s1', ...
		       ['PETH of the react R time series centered on the', ...
		    ' clustered SPW occurrences, in sleep 1, with inter-cell shuffling', ...
		    ' the shuffling is to the n-th closest SPW']);
  
  
  A = registerResource(A, 'ReactR200IsolSpwPETHS1', 'tsdArray', {1, 1}, ...
		       'reactR_isol_spw_peth_s1', ...
		       ['PETH of the react R time series centered on the', ...
		    ' isolated SPW occurrences, in sleep 1']);

  A = registerResource(A, 'ReactR200IsolSpwPETHShuffleCS1', 'tsdArray', {1, 1}, ...
		       'reactR_isol_spw_peth_shuffle_s1', ...
		       ['PETH of the react R time series centered on the', ...
		    ' isolated SPW occurrences, in sleep 1, with inter-cell shuffling', ...
		    ' the shuffling is to the n-th closest SPW']);
  
  
  
  spw_s1 = ts(Start(intersect(spw_s1, Sleep1)));
  spw_s2 = ts(Start(intersect(spw_s2, Sleep2)));

  
  C = compoundEvents([20000], [-1], [3], 1);
  Cu = compoundEvents([40000], [1], [2], 2);

  
  spw_c_s1 = find(C, spw_s1);
  spw_u_s1 = find(Cu, spw_s1);
  
  
  spw_c_s2 = find(C, spw_s2);
  spw_u_s2 = find(Cu, spw_s2);
 
  
  % make the react R for Sleep 2
  
  Q_s2 = MakeQfromS(S, binsize, 'T_start', Start(Sleep2), 'T_end', ...
		    End(Sleep2));
  
  
  
  q_s2 = (full(Data(Q_s2)))';
  
  q_s2 = (q_s2+ epsilon) ./ repmat(frate_sleep1 + epsilon, 1, size(q_s2, 2)) ;
  
  reactR_s2 = Qpearson_c(log10(q_s2), X_MS1);
  
  reactR_s2 = tsd(Range(Q_s2), reactR_s2);
  
  reactR_clust_spw_peth_s2 = triggeredMeanData(reactR_s2, ...
					 Data(spw_c_s2), ...
					 100000, 'errors', 'sem');
  
  reactR_isol_spw_peth_s2 = triggeredMeanData(reactR_s2, ...
					 Data(spw_u_s2), ...
					 100000, 'errors', 'sem');
  
  clear q* Q*
  
  % make the shuffled react T for sleep 2
  
  S_s2 = map(S, 'TSO = Restrict(TSA, %1);', Sleep2);
  
  if ~isempty(Data(spw_s2))
    C_s2 = cellArray(S_s2);
    
    for i = 1:length(C_s2)
      C_s2{i} = Data(C_s2{i});
    end

    % clustered 
    for nsh = 1:n_shuffle
      C = intervalShuffleClosest_c(C_s2, Data(spw_c_s2) - 100000, ...
			    Data(spw_c_s2) + 100000);
    
    
      for i = 1:length(C)
	C{i} = ts(C{i});
      end
    
      S_s2 = tsdArray(C);
    
    
      Q_s2 = MakeQfromS(S_s2, binsize, 'T_start', Start(Sleep2), 'T_end', ...
			End(Sleep2));
    
    
    
      q_s2 = (full(Data(Q_s2)))';
    
      q_s2 = (q_s2+ epsilon) ./ repmat(frate_sleep1 + epsilon, 1, size(q_s2, 2)) ;
    
      reactR_shuffle_s2 = Qpearson_c(log10(q_s2), X_MS1);
    
      reactR_shuffle_s2 = tsd(Range(Q_s2), reactR_shuffle_s2);
    
    
      rr_s2 = triggeredMeanData(reactR_shuffle_s2, ...
				Data(spw_c_s2), ...
				100000, 'errors', ...
				'sem');
      d = Data(rr_s2);
      if ~exist('rm_s2')
	rm_s2 = d(:,1);
	rs_s2 = d(:,2).^2;
      else
	rm_s2 = rm_s2 + d(:,1);
	rs_s2 = rs_s2 + d(:,2).^2;
      end
      
	
	
	

      
    end
    reactR_clust_spw_peth_shuffle_s2 = tsd(Range(rr_s2), ...
				     [rm_s2/n_shuffle, sqrt(rs_s2)/n_shuffle]);
    % isolated 
    for nsh = 1:n_shuffle
      C = intervalShuffleClosest_c(C_s2, Data(spw_u_s2) - 100000, ...
			    Data(spw_u_s2) + 100000);
    
    
      for i = 1:length(C)
	C{i} = ts(C{i});
      end
    
      S_s2 = tsdArray(C);
    
    
      Q_s2 = MakeQfromS(S_s2, binsize, 'T_start', Start(Sleep2), 'T_end', ...
			End(Sleep2));
    
    
    
      q_s2 = (full(Data(Q_s2)))';
    
      q_s2 = (q_s2+ epsilon) ./ repmat(frate_sleep1 + epsilon, 1, size(q_s2, 2)) ;
    
      reactR_shuffle_s2 = Qpearson_c(log10(q_s2), X_MS1);
    
      reactR_shuffle_s2 = tsd(Range(Q_s2), reactR_shuffle_s2);
    
    
      rr_s2 = triggeredMeanData(reactR_shuffle_s2, ...
				Data(spw_u_s2), ...
				100000, 'errors', ...
				'sem');
      d = Data(rr_s2);
      if ~exist('rm_s2')
	rm_s2 = d(:,1);
	rs_s2 = d(:,2).^2;
      else
	rm_s2 = rm_s2 + d(:,1);
	rs_s2 = rs_s2 + d(:,2).^2;
      end
      
	
	
	

      
    end
    reactR_isol_spw_peth_shuffle_s2 = tsd(Range(rr_s2), ...
				     [rm_s2/n_shuffle, sqrt(rs_s2)/n_shuffle]);
    
      
  else
    reactR_clust_spw_peth_shuffle_s2 = reactR_clust_spw_peth_s2;
    reactR_isol_spw_peth_shuffle_s2 = reactR_isol_spw_peth_s2;
  end
  
  
  % make the react R for Sleep 1 
  
  X_MS2 = log10(frate_maze ./ frate_sleep2);
  
  
  Q_s1 = MakeQfromS(S, binsize, 'T_start', Start(Sleep1), 'T_end', ...
		    End(Sleep1));
 
  
  q_s1 = (full(Data(Q_s1)))';
  
  q_s1 = (q_s1+epsilon) ./ repmat(frate_sleep2 + epsilon, 1, size(q_s1, 2));
 
  
  reactR_s1 = Qpearson_c(log10(q_s1), X_MS2);
  
  reactR_s1 = tsd(Range(Q_s1), reactR_s1);
 

  reactR_clust_spw_peth_s1 = triggeredMeanData(reactR_s1, ...
					 Data(spw_c_s1), ...
					 100000, 'errors', 'sem');
  
  reactR_isol_spw_peth_s1 = triggeredMeanData(reactR_s1, ...
					 Data(spw_u_s1), ...
					 100000, 'errors', 'sem');


  
   % make the shuffled react T for sleep 1
  
  S_s1 = map(S, 'TSO = Restrict(TSA, %1);', Sleep1);

  if ~isempty(Data(spw_s1))
    C_s1 = cellArray(S_s1);
    
    for i = 1:length(C_s1)
      C_s1{i} = Data(C_s1{i});
    end

    % clustered 
    for nsh = 1:n_shuffle
      C = intervalShuffleClosest_c(C_s1, Data(spw_c_s1) - 100000, ...
			    Data(spw_c_s1) + 100000);
    
    
      for i = 1:length(C)
	C{i} = ts(C{i});
      end
    
      S_s1 = tsdArray(C);
    
    
      Q_s1 = MakeQfromS(S_s1, binsize, 'T_start', Start(Sleep1), 'T_end', ...
			End(Sleep1));
    
    
    
      q_s1 = (full(Data(Q_s1)))';
    
      q_s1 = (q_s1+ epsilon) ./ repmat(frate_sleep1 + epsilon, 1, size(q_s1, 2)) ;
    
      reactR_shuffle_s1 = Qpearson_c(log10(q_s1), X_MS1);
    
      reactR_shuffle_s1 = tsd(Range(Q_s1), reactR_shuffle_s1);
    
    
      rr_s1 = triggeredMeanData(reactR_shuffle_s1, ...
				Data(spw_c_s1), ...
				100000, 'errors', ...
				'sem');
      d = Data(rr_s1);
      if ~exist('rm_s1')
	rm_s1 = d(:,1);
	rs_s1 = d(:,2).^2;
      else
	rm_s1 = rm_s1 + d(:,1);
	rs_s1 = rs_s1 + d(:,2).^2;
      end
      
	
	
	

      
    end
    reactR_clust_spw_peth_shuffle_s1 = tsd(Range(rr_s1), ...
				     [rm_s1/n_shuffle, sqrt(rs_s1)/n_shuffle]);
    % isolated 
    for nsh = 1:n_shuffle
      C = intervalShuffleClosest_c(C_s1, Data(spw_u_s1) - 100000, ...
			    Data(spw_u_s1) + 100000);
    
    
      for i = 1:length(C)
	C{i} = ts(C{i});
      end
    
      S_s1 = tsdArray(C);
    
    
      Q_s1 = MakeQfromS(S_s1, binsize, 'T_start', Start(Sleep1), 'T_end', ...
			End(Sleep1));
    
    
    
      q_s1 = (full(Data(Q_s1)))';
    
      q_s1 = (q_s1+ epsilon) ./ repmat(frate_sleep1 + epsilon, 1, size(q_s1, 2)) ;
    
      reactR_shuffle_s1 = Qpearson_c(log10(q_s1), X_MS1);
    
      reactR_shuffle_s1 = tsd(Range(Q_s1), reactR_shuffle_s1);
    
    
      rr_s1 = triggeredMeanData(reactR_shuffle_s1, ...
				Data(spw_u_s1), ...
				100000, 'errors', ...
				'sem');
      d = Data(rr_s1);
      if ~exist('rm_s1')
	rm_s1 = d(:,1);
	rs_s1 = d(:,2).^2;
      else
	rm_s1 = rm_s1 + d(:,1);
	rs_s1 = rs_s1 + d(:,2).^2;
      end
      
	
	
	

      
    end
    reactR_isol_spw_peth_shuffle_s1 = tsd(Range(rr_s1), ...
				     [rm_s1/n_shuffle, sqrt(rs_s1)/n_shuffle]);
    
      
  else
    reactR_clust_spw_peth_shuffle_s1 = reactR_clust_spw_peth_s1;
    reactR_isol_spw_peth_shuffle_s1 = reactR_isol_spw_peth_s1;
  end
  
  
  
  %%%%%%%% PLOTS

  if to_plot
    figure(1)
    clf 
    subplot(2,1,1)
    d = Data(reactR_clust_spw_peth_s2);
    errorbar(Range(reactR_clust_spw_peth_s2, 's'), d(:,1), d(:,2));
    hold on 
    d = Data(reactR_clust_spw_peth_shuffle_s2);
    errorbar(Range(reactR_clust_spw_peth_shuffle_s2, 's'), d(:,1), d(:,2), '--');
    
    d = Data(reactR_isol_spw_peth_s2);
    errorbar(Range(reactR_isol_spw_peth_s2, 's'), d(:,1), d(:,2), 'r');
    hold on 
    d = Data(reactR_isol_spw_peth_shuffle_s2);
    errorbar(Range(reactR_isol_spw_peth_shuffle_s2, 's'), d(:,1), d(:,2), 'r--');
    

    
    
    
    subplot(2,1,2)
    
    d = Data(reactR_clust_spw_peth_s1);
    errorbar(Range(reactR_clust_spw_peth_s1, 's'), d(:,1), d(:,2));
    hold on 
    d = Data(reactR_clust_spw_peth_shuffle_s1);
    errorbar(Range(reactR_clust_spw_peth_shuffle_s1, 's'), d(:,1), d(:,2), '--');
    
    d = Data(reactR_isol_spw_peth_s1);
    errorbar(Range(reactR_isol_spw_peth_s1, 's'), d(:,1), d(:,2), 'r');
    hold on 
    d = Data(reactR_isol_spw_peth_shuffle_s1);
    errorbar(Range(reactR_isol_spw_peth_shuffle_s1, 's'), d(:,1), d(:,2), 'r--');
    
    
    figure(2), clf
    plot(X_MS1, X_S2S1, '.')
    hold on 
    plot(X_MS2, -X_S2S1, 'r.');
    keyboard    
  end
  
  
  
  
  
  
  
  A = saveAllResources(A);

  
  
  AO = A;
  
  
  