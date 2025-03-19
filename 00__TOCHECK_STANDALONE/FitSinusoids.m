function [yf,yf2]=FitSinusoids(x,y,x2,plo)

try
    plo;
catch
    plo=0;
end

yu = max(y);
yl = min(y);
yr = (yu-yl);                               % Range of ?y?
yz = y-yu+(yr/2);
zx = x(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
per = 2*mean(diff(zx));                     % Estimate period
ym = mean(y);                               % Estimate offset
fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);    % Function to fit
fcn = @(b) sum((fit(b,x) - y).^2);                              % Least-Squares cost function
s = fminsearch(fcn, [yr;  per;  -1;  ym]);                       % Minimise Least-Squares
xp = linspace(min(x),max(x),length(x)/10);
yf=fit(s,xp);
try
    x2;    
    yf2=fit(s,x2);
catch
    yf2=fit(s,xp);
end

if plo
figure('color',[1 1 1]), hold on
plot(x,y,'b')
plot(xp,yf, 'r')
end



