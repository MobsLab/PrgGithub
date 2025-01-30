function AO = Hyper5ArmTimes(A)
  
  
  
  A = registerResource(A, 'OnArmBaseM1', 'cell', {1,1}, ...
		       'onArmBaseM1', ...
		       ['interval set with times spent on base arm in maze1']);
  
  A = registerResource(A, 'OnArmCurtainM1', 'cell', {1,1}, ...
		       'onArmCurtainM1', ...
		       ['interval set with times spent on curtain arm in maze1']);
  
  A = registerResource(A, 'OnArmDoorM1', 'cell', {1,1}, ...
		       'onArmDoorM1', ...
		       ['interval set with times spent on door arm in maze1']);
  
  A = registerResource(A, 'OnArmBaseM2', 'cell', {1,1}, ...
		       'onArmBaseM2', ...
		       ['interval set with times spent on base arm in maze1']);
  
  A = registerResource(A, 'OnArmCurtainM2', 'cell', {1,1}, ...
		       'onArmCurtainM2', ...
		       ['interval set with times spent on curtain arm in maze1']);
  
  A = registerResource(A, 'OnArmDoorM2', 'cell', {1,1}, ...
		       'onArmDoorM2', ...
		       ['interval set with times spent on door arm in maze1']);
  
  
  warning off
  load([current_dir(A) filesep 'lin_pos.mat']);
  warning on
  
  onArmBaseM1 = makeISet(v_b_tsd{2});
  onArmBaseM2 = makeISet(v_b_tsd{4});
  
  onArmDoorM1 = makeISet(v_c_tsd{2});
  onArmDoorM2 = makeISet(v_c_tsd{4});
  
  onArmCurtainM1 = makeISet(v_d_tsd{2});
  onArmCurtainM2 = makeISet(v_d_tsd{4});
  
  
  A = saveAllResources(A);

  AO = A;

  
function iset = makeISet(to)
  
  d = to.data;
  t = to.t;
  
  ix = find(isnan(d));
  dd = diff(ix);
  dd = dd(2:2:end);
  if ~all(dd == 1)
    error('something screwed up with arm indexing');
  end
  
  t = t(ix);
  st = t(1:2:end-1);
  en = t(2:2:end);
  
  st = st(:);
  en = en(:);
  
  iset = intervalSet(st,en);
  
  
    
  
  