function AO = HippoSpikeD(A)
  
  

  
  

  
  
  A = registerResource(A, 'PosXS', 'tsdArray', {1, 1}, ...
                'XS', ['X coordinate of the smoothed position']);
  A = registerResource(A, 'PosYS', 'tsdArray', {1, 1}, ...
                'YS', ['Y coordinate of the smoothed position']);
 A = registerResource(A, 'PosPhi', 'tsdArray', {1, 1}, ...
                'phi', ['linearized coordinate (along the track) smoothed position']);
  
            
  
  cd(current_dir(A));
  warning off
  load DIRACPosFile0627.mat
  warning on 
  cd(parent_dir(A));
  
  
  XS = tsd(XS.t, XS.data);
  YS = tsd(YS.t, YS.data);
  phi = tsd(phi.t, phi.data);
  
  
  A =  saveAllResources(A);

  AO = A;
  
  
  