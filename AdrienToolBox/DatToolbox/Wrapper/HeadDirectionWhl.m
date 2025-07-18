function [ang,GoodRanges] = HeadDirectionWhl(fbasename)

% USAGE
%     [ang,GoodRanges] = HeadDirectionWhl(fbasename)
%     
% Adrien Peyrache 2011
  
whl = LoadPosition(fbasename);

dx = whl(:,1)-whl(:,3);
dy = whl(:,2)-whl(:,4);

ep = ~(isnan(dx) || isnan(dy));

tg = t;
tg(~ep) = -1;
GoodRanges = thresholdIntervals(tsd(t,tg),0);

ang = atan2(dy(ep),dx(ep));


