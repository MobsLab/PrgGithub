function AO = saveResource(A, resourceValue, dataset, resourceName)
% A = saveResource(resourceName, resourceValue) save resource in the output
% file
%
% the function saves the resource in the output file, concatenating the
% values for each dataset, and makes a check with the dimensions 
% INPUTS: 
% A: the Analysis context object
% resourceValue: the value of the resource for the current dataset 
% dataset: the dataset to save
% resourceName: the name of the resource to be saved
% OUTPUTS: 
% AO: the output (modified) version of the Analysis context object  
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html

  res = A.resources{resourceName};
  
  t = res.type;
  
  switch t
   case 'cell'
    if ~iscell(resourceValue)
      resourceValue = { resourceValue};
    end
   case 'tsdArray'
    if ~isa(resourceValue, 'tsdArray')
      resourceValue = tsdArray(resourceValue);
    end
  end
  
    
  
  
  checkDimensions(A, size(resourceValue), dataset, resourceName);

  if ~has_key(A.resources, resourceName)
    error(['resource ' resourceName ' unknown in this context']);
  end
  
  res = A.resources{resourceName};
  pb = res.providedBy;
  
  switch pb.op{1}
      case 'resourcefile'
          
          
          % if resource hasn't been saved previously, initialized data structures
          if ~has_key(A.saveRes, resourceName)
              switch res.type
                  case 'numeric'
                      A.saveRes{resourceName} = [];
                  case 'cell'
                      A.saveRes{resourceName} = {};
                  case 'tsdArray'
                      A.saveRes{resourceName} = tsdArray;
                  case 'dictArray'
                      A.saveRes{resourceName} = {};
              end
          end

          if ~has_key(A.saveResIdx, resourceName)
              A.saveResIdx{resourceName} = [];
          end

          l = size(resourceValue, 1);

          ds_idx = A.datasets{dataset};
          A.saveResIdx{resourceName} = [A.saveResIdx{resourceName} ;
              ds_idx * ones(l, 1)];
          A.saveRes{resourceName} = [A.saveRes{resourceName} ;
              resourceValue];
      case 'mfile'
          nowDir = pwd;
          cd(current_dir(A));
          outFile = pb.args{1};
          [p,n,e] = fileparts(outFile);
          outFile = n;
%            display(pwd)
          eval([res.varName ' = resourceValue;']);

%  		keyboard;
	
          if exist([outFile '.mat'], 'file')
              save(outFile, res.varName, '-append');
          else
              save(outFile, res.varName);
          end
          cd(nowDir);
      otherwise
          error('unrecognized providedBy operation');
  end
          
  
  
  pb.dataset{1} = [pb.dataset{1} {dataset}];
  
  A.resources{resourceName} = setProvidedBy(res, pb);
  
  AO = A;	    
  
  
  
  
  
    
      