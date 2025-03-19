function [y_value, time_value] = extremumEpochs(tsa, intervals, do_maximum)
%   
% INPUTS:  
% tsa: tsd object
% intervals: intervalSet
% do_maximum: maximum if 1, minimum otherwise (default 1)
%
% OUTPUT:
% y_value: value of the extremum
% time_value: time of the extremum
%
% Author : Karim El Kanbi

%% check inputs
if nargin < 2
  error('Incorrect number of parameters.');
end
if nargin==2
   do_maximum = 1; 
end


nb_intervals = length(Start(intervals));
for i=1:nb_intervals
    intervals_cells{i} = subset(intervals,i);
end

[y_value, time_value] = cellfun(@(v)extremumInterval(tsa, v, do_maximum), intervals_cells);

end





function [y_value, time_value] = extremumInterval(tsa, interval, do_maximum)
%   
% INPUTS:  
% tsa: tsd object
% interval: intervalSet
% do_maximum: maximum if 1, minimum otherwise (default 1)
%
% OUTPUT:
% y_value: value of the extremum
% time_value: time of the extremum
%

if nargin < 2
  error('Incorrect number of parameters.');
end
if nargin==2
   do_maximum = 1; 
end

signal = Restrict(tsa, interval);
x_data = Range(signal);
y_data = Data(signal);

if do_maximum
    [y_value, idx] = max(y_data);
else
    [y_value, idx] = min(y_data);
end
time_value = x_data(idx);

end




