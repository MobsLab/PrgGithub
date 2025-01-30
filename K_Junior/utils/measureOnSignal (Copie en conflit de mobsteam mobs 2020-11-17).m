function [y_value1, y_value2, y_value3] = measureOnSignal(tsa, measure)
%   
% INPUTS:  
% tsa: tsd object
% measure: measure to apply
%
% OUTPUT:
% y_value1: output number 1
% y_value1: output number 2
% y_value3: output number 3
%
% 
%   e.g. [minimum_value, timestamp] = measureOnSignal(EEG, 'minimum')    
% 
% Author : Karim El Kanbi
%
%




% check inputs
if nargin < 2
  error('Incorrect number of parameters.');
end

%default output
y_value1 = 0;
y_value2 = 0;
y_value3 = 0;


%% FUNCTION

%min
if strcmpi(measure, 'minimum')
    x_data = Range(tsa);
    y_data = Data(tsa);
    
    [y_value1, idx] = min(y_data);
    y_value2 = x_data(idx);

%max
elseif strcmpi(measure, 'maximum')
    x_data = Range(tsa);
    y_data = Data(tsa);
    
    [y_value1, idx] = max(y_data);
    y_value2 = x_data(idx);
    
    
%median
elseif strcmpi(measure, 'median')
    y_value1 = median(Data(tsa));
%mean
elseif strcmpi(measure, 'mean')
    y_value1 = mean(Data(tsa));
%std
elseif strcmpi(measure, 'std')
    y_value1 = std(Data(tsa));
%mean_std
elseif strcmpi(measure, 'mean_std')
    y_value1 = mean(Data(tsa));
    y_value2 = std(Data(tsa));
    
%border_point
elseif strcmpi(measure, 'border_point')
    y_data = Data(tsa);
    y_value1 = y_data(1);
    y_value2 = y_data(end);
    
%peak to peak amplitude
elseif strcmpi(measure, 'amplitude_p2p')
    x_data = Range(tsa);
    y_data = Data(tsa);
    
    [min_y, idx_min] = min(y_data);
    [max_y, idx_max] = max(y_data);
    
    y_value1 = max_y - min_y;
    y_value2 = x_data(idx_min);
    y_value3 = x_data(idx_max);
    
end

end