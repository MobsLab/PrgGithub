function AO = Hyper5Datasets(A)
  
  A = registerResource(A, 'IsOldRat', 'numeric', {1,1}, ...
		       'isOldRat', ...
		       'logical: whether it was an old rat');
  A = registerResource(A, 'IsNovel', 'numeric', {1,1}, ...
		       'isNovel', ...
		       'logical: whether it was a novel maze');
   A = registerResource(A, 'RewardSite', 'numeric', {1,1}, ...
		       'rewardSite', ...
		       ['1 if the high reward site was the door, ', ...
		    '0 if it was the curtain']);
   A = registerResource(A, 'FirstMaze', 'numeric', {1,1}, ...
			'firstMaze', ...
			['1 if the first maze was the big one', ...
		    '0 if it was the small one']);
   
 
  
  
		       
  hyper5summary;
  
  
  
  dset = current_dataset(A);
  ix = 0;
  for i = 1:length(S)
    if strcmp(dset, S(i).data_dir)
      ix = i;
      break;
    end % if strcmp(dset,
  end % for i = 1:length(S)

  
  isOldRat = logical(S(ix).isold);
  isNovel = logical(S(ix).isnovel);
  rewardSite = logical(S(ix).isdoor_reward);
  firstMaze = logical(S(ix).bigfirst);
  
  
  A = saveAllResources(A);
  AO = A;
    
  