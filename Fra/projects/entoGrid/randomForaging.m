function [xRat, yRat] = randomForaging(nSteps, cageSize)


speed = 0.05;
ns = 0;

xInit = cageSize/2;
yInit = cageSize/2;
xRat = [];
yRat = [];
while ns < nSteps 
    xEnd = rand*cageSize;
    yEnd = rand*cageSize;
    d = sqrt(sum([(xInit-xEnd) (yInit-yEnd)]).^2);
    nt = d/speed;
    tt = linspace(-pi/2, pi/2, nt);
    st = sin(tt);
    st = (st+1)/2;
    xt = xInit + st * (xEnd-xInit);
    yt = yInit + st * (yEnd-yInit);
    xRat  = [xRat xt];
    yRat = [yRat yt];
    
    ns = ns + length(xt);
    xInit = xEnd;
    yInit = yEnd;
end

xRat = xRat(1:nSteps);
yRat = yRat(1:nSteps);



