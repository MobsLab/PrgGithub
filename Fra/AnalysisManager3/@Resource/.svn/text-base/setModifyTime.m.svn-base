function RO = setModifyTime(R, time)
% R = setModifyTime(R, time) set the last modified time in the resource  
% 
% INPUTS:
% R: a Resource object
% time: a time, as numeral or datestr string, if omitted it will be set
% to current time
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html  
  
  
  if nargin == 1 
    time = datestr(now, 0);
  end
  
  if ~ischar(time)
    time = datestr(time, 0);
  end
  
  R.modifyTime = time;
  
  RO = R;