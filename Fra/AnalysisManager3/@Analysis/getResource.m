function [AO, O] = getResource(A, resourceName, dataset, rt)
% O = getResource(A, resourceName, [dataset, retain]) get the resource in the function's
% namespace
%
% INPUTS:
% A: the Analysis context object  
% resourceName: the name of the resource  
% dataset: the dataset on which to operate, if not present operate on A.curr_dset  
% retain: if present and set to non-zero, the resource is saved for
% recording on outfile. 
%   
% OUTPUTS: 
% AO: the output version of the Analysis context object (matlab passes
% arguments by copy only)
% O: if a second  output argument is present, the resource will be assigned to
% that arguments, otherwise it will be assigned the name coresponding to
% resource field varname in the caller's workspace
% O_idx: if a third argument is present, an vector indicating to which
% index each row in the output corresponds to. If the output argument is
% not present, and dataset is a cell array, the index vector will be
% dumped into the caller workspace with the name 'var_idx', if the
% variable name was 'var'.  
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html
  
  
  if nargin > 2
    ds = dataset;
  else
    
    ds = A.curr_dset;
  end
  
  
  if nargin > 3
    retain = rt;
  else
    retain = 0;
  end
  
  if nargout > 2
    error('Call with one or two input arguments');
  end
  
  
  if iscell(ds)
    [A, out] = getResource(A, resourceName, ds{1}, retain);
    out_idx = ones(size(out, 1), 1);
    for i = 2:length(ds)
      [A, o] = getResource(A, resourceName, ds{i}, retain);
      out = [out ; o];
      out_idx = [out_idx; i *ones(size(o,1), 1)];
    end
    
    res = A.resources{resourceName};

    if nargout >= 2
      O = out;
    else
      assignin('caller', res.varName, out);
    end
    
    if nargout >= 3 
      O_idx = out_idx;
    else
      assignin('caller', [res.varName '_idx'], out_idx);
    end
    
    AO = A;
      
    
    
    return
  end
  
  
  
  
  % check if resource is available in the present context
  
    if ~has_key(A.resources, resourceName)
      error(['resource ' resourceName ' not present in the current context!']);
    end
    
    res = A.resources{resourceName};
    
  
  % first of all, get resources needed by this one
    
    for i = 1:length(res.requires)
      getResource(A, res.requires{i});
    end
    
    
  % get all the providedby rules
  
  
  [rules, args] = getCompatibleRules(res, ds);
  
  if isempty(rules)
    error(['there is no rule to retrieve resource ' resourceName , ...
	   ' for dataset ', ds]);
  end
  
  

  done = 0;
  for i = 1:length(rules)
      switch rules{i}
          case 'mfile'
              mfile = args{i};
              [p,mfile,e] = fileparts(mfile);
              if ~strcmp(mfile((end-1):end), '.mat')
                  mfile = [mfile '.mat'];
              end

              mfile_name = fullfile(pwd, ds, mfile);
              display(mfile_name)
              if exist(mfile_name) == 2
                  w = who('-file', mfile_name);
                  if ismember(res.varName, w)
                      warning off
                      load(mfile_name, res.varName)
                      warning on
                      eval([ 'R = ', res.varName ';']);
                      done = 1;
                      break
                  end
              end

          case 'resourcefile'
              if strcmp(args{1}, A.outFile)
                  % it's in current workspace
                  if (~has_key(A.saveRes, resourceName)) | ...
                          (~has_key(A.saveRes, resourceName))
                      error(['Resource ' resourceName ' is not present in current', ...
                          ' workspace']);
                  end
                  ds_idx = A.datasets{ds};
                  ix = find((A.saveResIdx{resourceName}) == ds_idx);
                  if isempty(ix)
                      ix = zeros(0,1);
                  end

                  R = SelectAlongFirstDimension(A.saveRes{resourceName}, ix);
                  done = 1;
                  break;
              else
                  % retrieve from file
                  resfile_name = args{1};

                  if exist(resfile_name) ~= 2
                      [p, n, e] = fileparts(resfile_name);
                      resfile_name = [n e];
    end
    
    
	if exist(resfile_name) == 2 | exist([resfile_name '.mat']) == 2
	  load(resfile_name, 'datasets', resourceName, ...
	       [resourceName '_idx']);
	  if isempty(strmatch(ds, datasets, 'exact'))
	    warning(['Couldn''t find resource ' resourceName 'in file ', ...
		     resfile_name ]);
	    break
	  end
	  ds_idx = strmatch(ds, datasets, 'exact');
	  eval(['r_ix = ' resourceName '_idx;']);
	  ix = find(r_ix == ds_idx);
	  if isempty(ix)
	    ix = zeros(0,1);
	  end
	
	  if strcmp(res.type, 'numeric') | strcmp(res.type, 'cell')
	    eval(['R = SelectAlongFirstDimension(' resourceName ', ix);' ...
		 ]);
	  else
	    eval(['R = ',  resourceName, '(ix);']);
	  end
	    
	  if isempty(keys(A.datasets))
	    for i = 1:length(datasets)
	      A.datasets{datasets{i}} = i;
	    end
	  end
	  
	  done = 1;
	  break;
	end
      end
      
      
      
     case 'run'
      curr_dir = pwd;
      try
	cd(ds);
	eval(['R = ' args{i} ';']);
	cd(curr_dir);
      catch
	cd(curr_dir);
	error(['Problem in retrieving resource ' resourceName, ...
	       ': ', lasterr]);

      end
      done = 1;
      break
      
     case 'list'
      listfile = args{i};
      listfile_name = fullfile(pwd, ds, listfile);
      if exist(listfile_name) == 2
	R = List2Cell(listfile_name);
	done = 1;
	break;
      end
      
    end
  end
  
  
  if ~done
    error(['Could not retrieve resource ' resourceName]);
  end
  
  % check dimensionality against what expected from resource database
  
%    checkDimensions(A, size(R), ds, resourceName);
  
  if retain
    A = saveResource(A, R, ds, resourceName);
  end
  
  AO = A;
    
  if nargout >= 2
    O = R;
  else
    assignin('caller', res.varName, R);
  end
  
  
      
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  