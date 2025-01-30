function duration = tsd_duration(tsa)
% INPUTS:  
% tsa: tsd object
% OUTPUT:
% duration: duration of the input tsd, in ms
%
% Author : Karim El Kanbi

rg = Range(tsa,'ms');
duration = rg(end)-rg(1);