function SpwPETHReact()
  
  
  epsilon = 1e-5;
  

  
  load ReactRate
  
  X_MS2 = log10(FRateMaze ./ FRateSleep2);
  
  redo_matrix = 0;
  if redo_matrix
    
    load SpwPETH  
    P1 = merge(SpwPETH_s1);
    d1 = Data(P1);
    sz = size(d1, 2);
    m1 = d1(:,1:2:sz);
    
    
    
    P2 = merge(SpwPETH_s2);
    d2 = Data(P2);
    sz = size(d2, 2);
    m2 = d2(:,1:2:sz);
  else
    load SpwPETHReact
  end
  
  m2 = m2';
  m1 = m1';
  
  qm2 = (m2+epsilon) ./ repmat(FRateSleep1+epsilon, 1, size(m2,2));
  RR_s2 = Qpearson_c(log10(qm2), X_MS1);
  
  qm1 = (m1+epsilon) ./ repmat(FRateSleep2+epsilon, 1, size(m1,2));
  RR_s1 = Qpearson_c(log10(qm1), X_MS2);
  
  
  figure(1), clf
  
  subplot(3,1,1);
  plot(-10:.2:10, RR_s2);
  
  subplot(3,1,2);
  plot(-10:.2:10, RR_s1);
  
  subplot(3,1,3);
  plot(-10:.2:10, RR_s2-RR_s1);
  
  
  
  
  
  keyboard