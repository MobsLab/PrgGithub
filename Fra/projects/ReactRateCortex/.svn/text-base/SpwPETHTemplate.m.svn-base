function AO = SpwPETHTemplate(A)
  

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
  
  load /home/fpbatta/Data/WarpRat/templateSpwPETH.mat
  
  A = registerResource(A, 'SPWTempOverlapS1', 'tsdArray', {1,1}, ...
		       'T_s1', ...
		       ['overlap between firing rate around each SPW', ...
		    ' and the template PETH, for sleep1']);
  
  A = registerResource(A, 'SPWCTempOverlapS1', 'tsdArray', {1,1}, ...
		       'Tc_s1', ...
		       ['overlap between firing rate around each SPW', ...
		    ' and the template clustered PETH, for sleep1']);
  
   A = registerResource(A, 'SPWUTempOverlapS1', 'tsdArray', {1,1}, ...
		       'Tu_s1', ...
		       ['overlap between firing rate around each SPW', ...
		    ' and the template isolated PETH, for sleep1']);
  
  A = registerResource(A, 'SPWTempOverlapS2', 'tsdArray', {1,1}, ...
		       'T_s2', ...
		       ['overlap between firing rate around each SPW', ...
		    ' and the template PETH, for sleep2']);
  
  A = registerResource(A, 'SPWCTempOverlapS2', 'tsdArray', {1,1}, ...
		       'Tc_s2', ...
		       ['overlap between firing rate around each SPW', ...
		    ' and the template clustered PETH, for sleep2']);
  
   A = registerResource(A, 'SPWUTempOverlapS2', 'tsdArray', {1,1}, ...
		       'Tu_s2', ...
		       ['overlap between firing rate around each SPW', ...
		    ' and the template isolated PETH, for sleep2']);
  
 
  binsize = 200;
  nbins = 100;
  n_shuffle = 20;
  
  
  
  
  

  



  spw_s1 = ts(Start(intersect(spw_s1, Sleep1)));
  spw_s2 = ts(Start(intersect(spw_s2, Sleep2)));
  
  S_s1 = map(S, 'TSO = Restrict(TSA, %1);', Sleep1);
  S_s1 = oneSeries(S_s1);
  
  S_s2 = map(S, 'TSO = Restrict(TSA, %1);', Sleep2);
  S_s2 = oneSeries(S_s2);
  
  C = compoundEvents([20000], [-1], [3], 1);
  Cu = compoundEvents([40000], [1], [2], 2);

  
  spw_c_s1 = find(C, spw_s1);
  spw_u_s1 = find(Cu, spw_s1);
  
  
  spw_c_s2 = find(C, spw_s2);
  spw_u_s2 = find(Cu, spw_s2);
   
  
  d_spw_s1 = Data(spw_s1);
  t_s1 = [];
  tc_s1 = [];
  tu_s1 = [];

  
  for i = 1:length(spw_s1)

    
    peth = CrossCorr(ts(d_spw_s1(i)), S_s1, binsize, nbins, ...
			   'timeUnits', 'ms', ...
			   'errors', 'none');
    warning off
    
    cc = corrcoef(Data(peth), templateSpwPETH);
    t_s1(i) = cc(1,2);
    cc = corrcoef(Data(peth), templateClustSpwPETH);
    tc_s1(i) = cc(1,2);
    cc = corrcoef(Data(peth), templateIsolSpwPETH);
    tu_s1(i) = cc(1,2);
    warning on;
  end
  
  T_s1 = tsd(Range(spw_s1), t_s1);
  Tc_s1 = tsd(Range(spw_s1), tc_s1);
  Tu_s1 = tsd(Range(spw_s1), tu_s1);  
  
  
  d_spw_s2 = Data(spw_s2);
  t_s2 = [];
  tc_s2 = [];
  tu_s2 = [];
  for i = 1:length(spw_s2)
    peth = CrossCorr(ts(d_spw_s2(i)), S_s2, binsize, nbins, ...
			   'timeUnits', 'ms', ...
			   'errors', 'none');
    warning off
    cc = corrcoef(Data(peth), templateSpwPETH);
    t_s2(i) = cc(1,2);
    cc = corrcoef(Data(peth), templateClustSpwPETH);
    tc_s2(i) = cc(1,2);
    cc = corrcoef(Data(peth), templateIsolSpwPETH);
    tu_s2(i) = cc(1,2);
    warning on
  end
  
  T_s2 = tsd(Range(spw_s2), t_s2);
  Tc_s2 = tsd(Range(spw_s2), tc_s2);
  Tu_s2 = tsd(Range(spw_s2), tu_s2);  
  
  

  if to_plot    
    clf

    plot(Range(T_s2, 's'), Data(T_s2), '-o');
    hold on
    plot(Range(Tc_s2, 's'), Data(Tc_s2), 'r-o');
    plot(Range(Tu_s2, 's'), Data(Tu_s2), 'g-o');    
    
    
    
    
    keyboard
    
  end
  
      
  
 

  
  


  
  
  

  
  
  
  
  
  
  A = saveAllResources(A);

  
  
  AO = A;
  
  
  