%%CenterFiringRateCurve
% 14.03.2018 KJ
%
%
% curve = CenterFiringRateCurve(x_curve, y_curve)
%
%   see 
%       
%


function y_centered = CenterFiringRateCurve(x_curve, y_curve, normalise)

    %% CHECK INPUTS

    if nargin < 2
      error('Incorrect number of parameters.');
    elseif nargin < 3
        normalise=1;
    end
        
    %to renormalize
    norm_factor = mean(y_curve(1:10));
    
    %center
    [~, id] = min(y_curve);
    trough = x_curve(id);
    
    if trough>0 %move to left
        new_x = x_curve - trough;
        new_y = y_curve;
        new_y(new_x<x_curve(1))=[];
        new_y = [new_y ; ones(sum(new_x<x_curve(1)),1)*y_curve(end)];
        
    else %move to left
        new_x = x_curve - trough;
        new_y = y_curve;
        new_y(new_x>x_curve(end))=[];
        new_y = [ones(sum(new_x>x_curve(end)),1)*y_curve(1) ; new_y ];
    end
    
    %to renormalize
    if normalise
        norm_factor = mean(y_curve(1:10));
        new_y = new_y / norm_factor;
    
    end
    
    y_centered = new_y;
        
end