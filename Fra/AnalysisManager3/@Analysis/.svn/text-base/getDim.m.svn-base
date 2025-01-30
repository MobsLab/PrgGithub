function d = getDim(A, dataset, resourceName)
% d = getDim(A, resourceName) get dimensions of resource for dataset   
  
  
  
  
  
% copyright (c) 2004 Francesco P. Battaglia 
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html
  
  
  
  
  
  % see if it is cached 
    


    
    if has_key(A.resourceDim, resourceName)
      rd = A.resourceDim{resourceName};
      if(has_key(rd, dataset))
	d = rd{dataset};
	return
      end
      
    else
      rd = dictArray;
    end
    
      
    
  
  
  res = A.resources{resourceName};
  
  dim = res.dimensions;
  
  for i = 1:length(dim)
    if isempty(dim{i}) % dimension has to be determined directly from data
      if ~has_key(A.saveResIdx, resourceName)
	[A, dummy] = getResource(A, resourceName, dataset, 1);
      end
      
      ds_ix = A.datasets{dataset};
      ix = find(A.saveResIdx{resourceName} == ds_ix);
      if isempty(ix)
	[A, dummy] = getResource(A, resourceName, dataset, 1);
	ix = find(A.saveResIdx{resourceName} == ds_ix);
      end
      if strcmp(res.type, 'numeric')
	sz = size(SelectAlongFirstDimension(A.saveRes{resourceName}, ...
					    ix));
      else
	kk = A.saveRes{resourceName};
	sz = size(kk(ix));
      end
      
      d(i) = sz(i);
    elseif isa(dim{i}, 'numeric') % dimension is explicitly set
      d(i) = dim{i};
    elseif isa(dim{i}, 'char'); % go check 
      dq = getDim(A, dataset, dim{i});
      d(i) = dq(1);
    end
  end
  
  rd{dataset} = d;
  A.resourceDim{resourceName} = rd; % cache result