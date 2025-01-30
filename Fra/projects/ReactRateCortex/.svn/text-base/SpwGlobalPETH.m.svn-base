function AO = SpwGlobalPETH(A)
  
  to_plot = 1;
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
  
  
  
  S_s2 = map(S, 'TSO = Restrict(TSA, %1);', Sleep2);
  spw_s2= intersect(Sleep2, spw_s2);
  
  if ~isempty(Start(spw_s2))
    C_s2 = cellArray(S_s2);
    
    for i = 1:length(C_s2)
      C_s2{i} = Data(C_s2{i});
    end
    
    % C_s2 = C_s2(end);
    

    
    [C, O] = intervalShuffleClosest_c(C_s2, Start(spw_s2) - 100000, ...
			  Start(spw_s2) + 100000);

    Otot = [];
    for i = 1:length(C_s2)
      C_s2{i} = ts(C_s2{i});
      Otot = cat(1, Otot, O{i});
    end
    S_s2 = tsdArray(C_s2);
    
    for i = 1:length(C)
      C{i} = ts(C{i});
    end
    
    S_s2_shuffle = tsdArray(C);
    
    T_s2 = oneSeries(S_s2);
    T_s2_shuffle = oneSeries(S_s2_shuffle);
    
    Cr = CrossCorr(ts(Start(spw_s2)), T_s2, 2000,200);
    Cr_shuffle = CrossCorr(ts(Start(spw_s2)), T_s2_shuffle, 2000, 200);    
    
     
      
  else
    ;
  end
  
  


  if to_plot & exist('Cr')
    figure(1)
    clf
    plot(Range(Cr, 's'), Data(Cr))
    hold on 
    plot(Range(Cr_shuffle, 's'), Data(Cr_shuffle), 'r')

    
    figure(2)
    clf
    is = regular_interval(Start(Sleep2), End(Sleep2), 2000);
    ir = intervalRate(T_s2, is);
    ir_shuffle = intervalRate(T_s2_shuffle, is);
    
    
    plot(Range(ir, 's'), Data(ir));
    hold on 
    plot(Range(ir_shuffle, 's'), Data(ir_shuffle), 'r');
    plot(Start(spw_s2, 's'), ones(size(Start(spw_s2))), 'o');

    figure(3)
    clf
    bins = -100000:2000:100000;
    hb = hist(Otot-100000, bins);
    plot(bins, hb);
    
     
    keyboard    
  end
  
  
  
  
  
  
  


  
  
  AO = A;
  
  
  