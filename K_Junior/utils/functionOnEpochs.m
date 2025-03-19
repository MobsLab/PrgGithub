function [y_value1, y_value2, y_value3] = functionOnEpochs(tsa, intervals, func, varargin)
%   
% INPUTS:  
% tsa: tsd object
% intervals: intervalSet
% func: function to apply on data
%
% OUTPUT:
% y_value1: output number 1
% y_value1: output number 2
% y_value3: output number 3
%
% Author : Karim El Kanbi
%
% EXAMPLE :
%       func_max = @(a) measureOnSignal(a,'maximum');
%       [deep.maxima, ~, ~] = functionOnEpochs(LFPdeep, Down, func_max);
%


%% check inputs
if nargin < 3
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'uniformoutput'
            uniform = varargin{i+1};
            if uniform~=0 && uniform ~=1
                error('Incorrect value for property ''UniformOutput''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

if ~exist('uniform', 'var')
    uniform = 1;
end


%% intervals to cells & cellfun
nb_intervals = length(Start(intervals));
for i=1:nb_intervals
    intervals_cells{i} = subset(intervals,i);
end

[y_value1, y_value2, y_value3] = cellfun(@(v)functionOnInterval(tsa, v, func), intervals_cells, 'UniformOutput',uniform);

end





function [y_value1, y_value2, y_value3] = functionOnInterval(tsa, interval, func)
%   
% INPUTS:  
% tsa: tsd object
% interval: intervalSet
% func: function to apply on data
%
% OUTPUT:
% y_value1: output number 1
% y_value1: output number 2
% y_value3: output number 3
%

if nargin < 3
  error('Incorrect number of parameters.');
end


[y_value1, y_value2, y_value3] = func(Restrict(tsa, interval));


end



