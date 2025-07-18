function AO = run(A, func, datasets, fname, varargin)
% A = run(A, func, datasets, fname, overwrite)  run the analysis defined
% in function func
%  
% INPUTS:
% A: an Analysis context object  
% function: string containing the name of the function to be run 
% datasets: list of datasets on which run the analysis 
% fname: name for the output file. If it's not present the name will be
% function.mat 
% overwrite: if set to 'overwrite', all the registered resources will be
% overwritten 
% OPTIONS:
% 'Debug': if set to non-zero, the errors won't be caught, otherqwise
% everything will be caught and logged
% 'Overwrite': if set to non-zero (default), will overwrite existing
% values for resources 
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html  
  
  
  
  opt_varargin = varargin;
  
  defined_options = dictArray({ { 'DoDebug', {1, { 'numeric' } } } ,
		                { 'Overwrite', {1, { 'numeric' } } } } );
  getOpt;
  
  debug_an = DoDebug;
 
  
  if ~Overwrite 
      warning('"append" option (not overwrite) is still in an experimental stage, use with caution');
  end
  
  
  
  O = A;
  O.ow  = Overwrite;
  if nargin >= 4
    fn = fname;
  else
    fn = func;
  end
  
  
  O.func = func;
  O.outFile = fullfile(O.parent_dir, fn);
  
  
  existFile = '';
  if exist(O.outFile, 'file') | exist([O.outFile '.mat'], 'file')
    
    if exist(O.outFile, 'file')
        existFile = O.outFile;
    end
    if exist([O.outFile '.mat'], 'file')
        existFile = [O.outFile '.mat'];
    end
    O.existFile = existFile;
  end
  
  ds = dictArray;
  lengthOld = 0;
  
  
  % if not overwite and the file existed load the previos datsetse name in
  % dataset list 
  if O.existFile & (~O.ow)
      old = load(existFile, 'datasets');
      lengthOld = length(old.datasets);
      for i = 1:lengthOld
          ds{old.datasets{i}} = i;
      end
      
      % get rid of datasets that are already in the file 
      newDatasetsIdx = [];
      for i = 1:length(datasets)
          if ~ismember(datasets{i}, old.datasets)
              newDatasetsIdx = [newDatasetsIdx i];
          end
      end
      datasets = datasets(newDatasetsIdx);
  end

  for i = (1:length(datasets)) + lengthOld
    ds{datasets{i-lengthOld}} = i;
  end
  
  O.datasets = ds;
  
  
  O.logFile = [O.outFile '.log'];
  logFile_h = fopen(O.logFile, 'w');
    % run the analysis in all the specified datasets
  
  datasets_ok = {};
  datasets_err = {};
  kds = datasets;
  
  for i = 1:length(kds)
    O.curr_dset = kds{i};
    display(O.curr_dset);

    if ~debug_an
        try
            ok = 1;
            eval(['O = ' O.func '(O);']);
        catch
            ok = 0;
            lt = lasterr;
            display(lasterr);
        end
    else
        ok = 1;
        eval(['O = ' O.func '(O);']);
    end


    if ok
        fprintf(logFile_h, '%s OK \n\n', O.curr_dset);
        datasets_ok = [datasets_ok {O.curr_dset}];
    else
        fprintf(logFile_h, 'Problem in dataset %s: %s\n\n', ...
            O.curr_dset, lt);
        datasets_err = [datasets_err {O.curr_dset}];
    end


  %mem test
   whos O;
    
  end
  
  fclose(logFile_h);
  
  resourceLock = false;
  
  try 
       load resources resourceLock
       while resourceLock
           display('resources file is locked, waiting 10 s for lock to be released')
           display('if there is no other matlab process touching the file, please run the unlockResources function');
           pause(10);
           load resources resourceLock
       end
       
  catch
      ;
  end
  
  % lock the resources file
  
  resourceLock = true;
  save resources resourceLock -append
  
  % update resourceFile with newly acquired resources, for datasets for
  % which the analysis worked, take the original resource file and only
  % change the updated resources
   load resources resources 
  old_resources = resources;
  resources = O.resources;  
  funcs = keys(A.resourcesFromFunc);
  
  for f = funcs 
      rf = A.resourcesFromFile{f};
      for s = rf
          old_resources{s} = resources{s};
      end
  end
  
  resources = resources;
          
  

  save(O.resourceFile, 'resources');
  
  % save analysis output
  % the file will contain
  % 1. the resources that are stored in the file 
  % 2. all the indices to the quantities (as quantity_idx)
  % 3. the quantities' value
  % 4. the source of the used function, in the string function_source 
  
  resources = dictArray;
  
  for i = 1:length(O.newResources);
    resources{O.newResources{i} } = O.resources{O.newResources{i} };
  end
  

   
  
  if O.existFile
      save(O.outFile, 'resources', '-append');
  else
      save(O.outFile, 'resources');
  end
  O.existFile = true;
  
  ds = {};
  k = keys(O.datasets);
  for i = 1:length(keys(O.datasets))
    kk = k{i};
    ds{(O.datasets{kk}) } = k{i};
  end
  
  datasets = ds(:);
    
  k = keys(O.saveRes);
  
  
  
  for i = 1:length(k)
    eval([k{i} ' = O.saveRes{''' k{i} '''};']);
    eval([k{i} '_idx = O.saveResIdx{''' k{i} '''};']);    
    save(O.outFile, k{i}, [k{i} '_idx'], '-append');
  end

  save(O.outFile, 'datasets', '-append');
  
  
  func_fname = which(O.func);
  fid = fopen(func_fname, 'r');
  func_source =  fscanf(fid, '%c', inf);
  
  save(O.outFile, 'func_source', '-append');
  
  % release the lock 
  
  resourceLock = false;
  save resources resourceLock -append
  
  fprintf(1, 'Analysis %s performed correctly on %d datasets\n', ...
	  O.func, length(datasets_ok));
  if ~isempty(datasets_err)
    fprintf(1, 'Errors detected in %d datasets, see log file %s\n', ...
	    length(datasets_err), O.logFile);
  end
  
  AO = O;