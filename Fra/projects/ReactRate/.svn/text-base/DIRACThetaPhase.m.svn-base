function AO = DIRACThetaPhase(A)
  
  

  
  

  
  
  A = registerResource(A, 'ThetaNorm', 'tsdArray', {1, 1}, ...
                'thetaNorm', ['filtered and normalized theta, so that each peak/trough is normalized to -1/1, resampled at ~200Hz']);
  A = registerResource(A, 'ThetaPhase', 'tsdArray', {1, 1}, ...
                'thetaPhase', ['phase of theta in [0, 2*pi] radians, 0 corresponds to peak'] );
             
  
  cd(current_dir(A));
  warning off
  load ThetaPhase.mat
  warning on 
  cd(parent_dir(A));
  
  
  thetaNorm = tsd(Ctheta_norm.t, Ctheta_norm.data);
  thetaPhase = tsd(ThetaPhase.t, ThetaPhase.data);
  
  
  
  A =  saveAllResources(A);

  AO = A;
  
  
  