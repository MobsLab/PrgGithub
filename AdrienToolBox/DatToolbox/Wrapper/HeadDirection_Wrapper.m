function [ang,GoodRanges] = HeadDirectionWhl(fbasename)

% USAGE
%     [ang,GoodRanges] = HeadDirectionWhl(fbasename)
%     
% Adrien Peyrache 2011
  
[whl,t] = LoadPosition(fbasename);
t = t*10000;
dx = whl(:,1)-whl(:,3);
dy = whl(:,2)-whl(:,4);

ep = ~(isnan(dx) | isnan(dy));

tg = t;
tg(~ep) = -1;
GoodRanges = thresholdIntervals(tsd(t,tg),0);

ang = mod(atan2(dy(ep),dx(ep)),2*pi);
ang = tsd(t(ep),ang);


