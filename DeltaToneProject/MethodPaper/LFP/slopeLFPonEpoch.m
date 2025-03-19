function [slopeLfp, peakamp, troughamp] = slopeLFPonEpoch(tsa, measure)
%   
% INPUTS:  
% tsa: tsd object
%
% OUTPUT:
% slopeLfp:    slope between peak and trough
% peakamp:     peak amplitude
% troughamp:   trough amplitude
%
% 
%   e.g. [slope, peak, trough] = slopeLFPonEpoch(tsa)  
% 
% Author : Karim El Kanbi
%
% see   
%   EndDownVertexLFPLayer functionOnEpochs
%




% check inputs
if nargin < 2
  error('Incorrect number of parameters.');
end

%default output
slopeLfp = 0;
peakamp = 0;
troughamp = 0;


%% FUNCTION
x_data = Range(tsa);
y_data = Data(tsa);

%trough
x_center = (x_data(1)+x_data(end)) /2;
y_rest = y_data(x_data>x_center-500 & x_data<x_center+500);
x_rest = x_data(x_data>x_center-500 & x_data<x_center+500);

[troughamp, idx] = min(y_rest);
x_trough = x_rest(idx);

%peak
y_rest = y_data(x_data>x_trough-800 & x_data<x_trough);
x_rest = x_data(x_data>x_trough-800 & x_data<x_trough);

[peakamp, idx] = max(y_rest);
x_peak = x_rest(idx);

%slope
slopeLfp = (troughamp - peakamp) / (x_trough - x_peak);



end