% UniqueValues: Given a matrix containing group labels, returns a vector containing 
%         a list of unique group labels, in the sequence found, and a 
%         vector of corresponding frequencies of each group.  
%         Optionally sorts the indices into ascending sequence.
%
%         Note: it might be necessary to truncate ('de-fuzz') real numbers to 
%         some arbitrary number of decimal positions (see TRUNCATE) before 
%         finding unique values.
%
%     Syntax: [uValues,freqs,indices] = UniqueValues(values,sortFlag)
%
%         values -      matrix of a set of labels.
%         sortFlag -    optional boolean flag indicating that list of labels, and 
%                         corresponding freqsuencies, are to be so sorted 
%                         [default = false].
%         -----------------------------------------------------------------------
%         uValues -     column vector of unique labels.
%         freqs -       corresponding absolute freqsuencies.
%         indices -     indices of the first observation having each value.
%

function [uValues,freqs,indices] = uniquef(values,sortFlag)
  if (nargin < 2) sortFlag = []; end;
  
  [uValues,freqs,indices] = UniqueValues(values,sortFlag);
  
  return;
