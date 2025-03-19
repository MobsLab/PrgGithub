%%CompareDecreaseDensity
% 10.03.2018 KJ
%
% Compare the decrease of density curves (down, delta...) 
%
% rate = CompareDecreaseDensity(density1, density2, times)
%
%   see 
%       
%


function [rate,difference] = CompareDecreaseDensity(density1, density2, times)

    idx_1 = density1 > max(density1)/8;
    idx_2 = density2 > max(density2)/8;
        
    [p1,~] = polyfit(times(idx_1), density1(idx_1), 1);
    [p2,~] = polyfit(times(idx_2), density2(idx_2), 1);
    
    rate = (p1-p2)/abs(p1);
    difference = p1-p2;
    
end