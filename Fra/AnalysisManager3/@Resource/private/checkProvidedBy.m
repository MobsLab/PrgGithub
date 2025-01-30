function i = checkProvidedBy(pb)
% i = checkProvidedBy(pb) checks providedby structure
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html
  
  i = 1;
  fn = fieldnames(pb);
  
  if length(fn) ~= 3
    i = 0;
    return
  end
  
  if isempty(strmatch('dataset', fn))
    i = 0;
    return
  end
  
  if isempty(strmatch('op', fn))
    i = 0;
    return
  end
  
  if isempty(strmatch('args', fn))
    i = 0;
    return
  end
  
 
    
  