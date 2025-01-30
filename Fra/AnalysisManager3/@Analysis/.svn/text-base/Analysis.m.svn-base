function O = Analysis(parent_dir)
% O = Analysis(parent_dir, resources, function) constructor for the
% analysis class 
%
% INPUTS:
% parent_dir: the parent directory for the dataset. In this directory the
% program expects to find the file Analysis_resources.mat that contains
% the resources cell array, which provides the context to the analysis
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html

  
    
    
   
  

  cd(parent_dir)
  
  O.ow = 1;
  
 
    
  
  O.parent_dir = parent_dir;
  
  load resources.mat resources
  
  O.resourceFile = fullfile(parent_dir, 'resources.mat');
  
  O.resources = resources; % the resources dictArray
  
  O.resourceDim = dictArray;
  
  
  O.existFile = '';
  
  O.datasets = dictArray;
  
  O.curr_dset = '';
  
  O.saveRes = dictArray;
  
  O.saveResIdx = dictArray;
  
  O.newResources = {};
  
  O.resourcesFromFunc = dictArray;
  
  O.func = '';

  
  O.outFile = '';
  
  O.logFile = '';
  
  O = class(O, 'Analysis');
