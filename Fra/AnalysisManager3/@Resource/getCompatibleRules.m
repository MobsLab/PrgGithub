function [rules, args] = getCompatibleRules(R, dataset)
% [rules, args] = getCompatibleRules(R, dataset) returns providedBy rules
% that are compatible with dataset
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html

  pb = R.providedBy;
  ds = pb.dataset;
  
  ix1 = [];
  ix2 = [];
  
  for i = 1:length(ds)
    if ~isempty(strmatch(dataset, ds{i}, 'exact'))
      ix1 = [ix1, i];
    end
    if ~isempty(strmatch('*', ds{i}, 'exact'))
      ix2 = [ix2, i];
    end
  end
  
      
 
  ix = sort([ix1, ix2]);
  
  rules = pb.op;
  rules = rules(ix);
  
  args = pb.args;
  args = args(ix);
  
  