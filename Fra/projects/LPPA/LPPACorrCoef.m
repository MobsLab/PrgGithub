%  function A = LPPACorrCoef(A)

dsets=('Rat18/1017');
 
 
 A = getResource(A,'VectorLateTrialRate',dsets);
 A = getResource(A,'VectorEarlyTrialRate',dsets);
 A = getResource(A,'VectorPreStartRate',dsets);
 
 
 ps = vectorPreStartRate{1};
 et = vectorEarlyTrialRate{1};
 lt = vectorLateTrialRate{1};
 
 figure(1)
 popVect = [ps;et;lt];

 imagesc(corrcoef(popVect));
 colorbar 

 figure(2)
 imagesc(corrcoef(ps));
 colorbar

 figure(3)
 imagesc(corrcoef(et));
 colorbar

 figure(4)
 imagesc(corrcoef(lt));
 colorbar