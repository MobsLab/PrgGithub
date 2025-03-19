function [x,y,t]=SpeedThreshold(x, y, t, lowSpeedThreshold, highSpeedThreshold);

p.lowSpeedThreshold=lowSpeedThreshold;
p.highSpeedThreshold=highSpeedThreshold;

if p.lowSpeedThreshold > 0 || p.highSpeedThreshold > 0
    disp('Applying speed threshold');
    % Calculate the speed of the rat, sample by sample
    speed = speed2D(x,y,t);

    if p.lowSpeedThreshold > 0 && p.highSpeedThreshold > 0
        ind = find(speed < p.lowSpeedThreshold | speed > p.highSpeedThreshold);
    elseif p.lowSpeedThreshold > 0 && p.highSpeedThreshold == 0
        ind = find(speed < p.lowSpeedThreshold );
    else
        ind = find(speed > p.highSpeedThreshold );
    end

%     % Remove the segments that have to high or to low speed
%     x(ind) = [];
%     y(ind) = [];
    
    
    % Remove the segments that have to high or to low speed
    x(ind) = NaN;
    y(ind) = NaN;
% %         if p.doHeadDirectionAnalysis
%             posx2(ind) = NaN;
%             posy2(ind) = NaN;
%         end
end
    
% Calculate the Speed of the rat in each position sample
%
% Version 1.0
% 3. Mar. 2008
% (c) Raymond Skjerpeng, CBM, NTNU, 2008.
function v = speed2D(x,y,t)

N = length(x);
M = length(t);

if N < M
    x = x(1:N);
    y = y(1:N);
    t = t(1:N);
end
if N > M
    x = x(1:M);
    y = y(1:M);
    t = t(1:M);
end

v = zeros(min([N,M]),1,'single');

for ii = 2:min([N,M])-1
    v(ii) = sqrt((x(ii+1)-x(ii-1))^2+(y(ii+1)-y(ii-1))^2)/(t(ii+1)-t(ii-1));
end
v(1) = v(2);
v(end) = v(end-1);
