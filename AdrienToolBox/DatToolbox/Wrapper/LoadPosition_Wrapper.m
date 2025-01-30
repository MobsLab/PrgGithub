function [X,Y,V,GoodRanges,ep] = LoadPosition_Wrapper(fbasename)

% USAGE:
% [X,Y,V,GoodRanges,ep] = LoadPosition_Wrapper(fbasename)

[whl,t,GoodRanges,ep] = LoadPosition(fbasename);
X = nanmean([whl(:,1),whl(:,3)]')';
Y = nanmean([whl(:,2),whl(:,4)]')';

dx = diff(X);
dy = diff(Y);
dt = 1/median(diff(t));
v = [sqrt(dx.^2+dy.^2);0];

gw = gausswin(30);
gw = gw/sum(gw(:));
warning off
goodEp = intervalSet(GoodRanges(:,1),GoodRanges(:,2));
goodEp = mergeCloseIntervals(goodEp,1);
warning on

v(isnan(v))=0;
V = convn(v,gw,'same');
V = V/dt;

X = tsd(t*10000,X);
Y = tsd(t*10000,Y);

GoodRanges = intervalSet(10000*GoodRanges(:,1),10000*GoodRanges(:,2));