function [ t, ampl ] = pickDetector( s, inibPeriod, threshold )
%PICKDETECTOR Detect picks
%   Detect local picks. The size of the local window is given by
%   inibPeriod.
%
%   by antoine.delhomme@espci.fr
%

% Prepare some variables
%   _t_         will contain time index of picks
%   _ampl_      will contain amplitude of picks
%   _timer_     timer that counts the period of inhibition
%   _threshold_ threshold a pick has to exceed
t = [];
ampl = [];
timer = 0;

if nargin <3
    threshold = mean(s) + sqrt(var(s));
end

% Perform each point at a time
for index = 2:(length(s)-1);
    timer = timer -1;
    
    % To be a pick, a point has to exceed its neighbors and the threshold
    if s(index) > s(index +1) ...
            && s(index) > s(index-1) ...
            && s(index) > threshold
        if timer < 0
            t = [t, index];
            ampl = [ampl, s(index)];
            % The timer is trigger
            timer = inibPeriod;
        elseif s(index) > ampl(end)
            ampl(end) = s(index);
            t(end) = index;
            % The timer is trigger
            timer = inibPeriod;
        end
    end
end



end

