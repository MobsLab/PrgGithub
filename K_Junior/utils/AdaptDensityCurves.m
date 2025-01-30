%%AdaptDensityCurves
% 14.03.2018 KJ
%
%
% [x_density, y_density] = AdaptDensityCurves(x_curve, y_curve)
%
%   see 
%       
%


function [x_density, y_density] = AdaptDensityCurves(x_curve, y_curve, smoothing)

    %% CHECK INPUTS

    if nargin < 2
      error('Incorrect number of parameters.');
    elseif nargin<3
        smoothing = 2;
    end
    
    
    %% Smoothing to remove wake
    y_curve = Smooth(y_curve,smoothing);
    
    %% Beginning and end of sleep
    start_sleep = x_curve(find(y_curve > max(y_curve)/8,1));
    end_sleep = x_curve(find(y_curve < max(y_curve)/8,1,'last'));
    idx = x_curve<start_sleep;
    
    x_density = x_curve;
    y_density = y_curve;
    y_density(idx)=0;
    
    
    
    
end


