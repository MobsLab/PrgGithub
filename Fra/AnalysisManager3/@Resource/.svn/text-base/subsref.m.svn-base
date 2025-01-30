function B = subsref(A, S)
% B = subsref(A, S) overload of the . operator
%
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html

  
  if ~strcmp(S.type, '.');
    error('subscripting only defined for field referencing');
  end
  
  fn = fieldnames(A);
  
  if ~ismember(S.subs, fn);
    error('unknown field');
  end
  
  % B = getfield(A, S.subs);
  eval(['B = A.' S.subs ';']);
  
   