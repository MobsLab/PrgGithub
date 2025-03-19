function [signal_norm, duration, y_value3] = signalEpochNormalize(tsa, nb_points, with_duration)
%   
% INPUTS:  
% tsa: tsd object
% nb_points: number of sample point of the output signal
% OUTPUT:
% signal_norm: input signal interpolated in a specified number of points
% duration: duration of the input tsd, in ms
%
% Author : Karim El Kanbi

try
    with_duration;
catch
    with_duration=0;
end

rg = Range(tsa,'ms');
duration = rg(end)-rg(1);

signal = Data(tsa);
x = linspace(0, 1, length(signal));
new_points = linspace(0, 1, nb_points);

signal_norm = interp1(x,signal,new_points,'spline');
signal_norm = signal_norm';
if with_duration==1
    signal_norm = [signal_norm;duration];
end

y_value3 = nan; %for function on Epochs

end



