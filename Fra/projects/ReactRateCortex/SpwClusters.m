function AO = SpwClusters(A)
  
  
  
  
  
   A = getResource(A, 'SPW_s2');  
   spw_s2 = spw_s2{1};
   spw_s2 = ts(Start(spw_s2));
   
   
   
   C = compoundEvents([20000], [-1], [3], 1);
   Cu = compoundEvents([40000], [1], [2], 2);
   
   
   
   spw_c = find(C, spw_s2);
   spw_u = find(Cu, spw_s2);
   
   
   
   clf
   plot(Range(spw_s2,'s'), zeros(size(Data(spw_s2))),'o');
   
   hold on 
   plot(Range(spw_c, 's'), zeros(size(Data(spw_c))),'ro');

   plot(Range(spw_u, 's'), zeros(size(Data(spw_u))),'go');
   
   keyboard
   
   AO = A;