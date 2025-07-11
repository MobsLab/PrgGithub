function AO = saveAllResources(A)
% A = saveAllResources(A) save all resources that were registered by
% caller
%  
% this function automatically saves all resources that were saved by
% caller. It's basically a trick to reduce the amount of code to be written in
% the computational routines
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html

  
  cf = callingFunction;
  
  all_res = A.resourcesFromFunc{cf};
  
  for i = 1:length(all_res)
    res = A.resources{all_res{i} };
    data = evalin('caller', [ res.varName ';']);
    A = saveResource(A, data, current_dataset(A), all_res{i});
  end
    
    
    
    
  AO = A;
    