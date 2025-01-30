function  A= HDThetaPositionMeasures(A)


do_fig = false;
vThresh = 1e-5;

A = getResource(A, 'PosX');
posX = posX{1};

A = getResource(A, 'PosY');
posY = posY{1};

A = getResource(A, 'PosAlpha');
posAlpha = posAlpha{1};

A = registerResource(A, 'HeadAngVel', 'tsdArray', {1,1}, ...
    'headAngVel', ...
    ['the head angular velocity']);

A = registerResource(A, 'RatVel', 'tsdArray', {1,1}, ...
    'ratVel', ...
    ['the rat linear velocity (modulus)']);

A = registerResource(A, 'MoveCCW', 'cell', {1,1}, ...
    'moveCCW', ...
    ['intervalSet of times when rat was moving CCW']);

A = registerResource(A, 'MoveCW', 'cell', {1,1}, ...
    'moveCW', ...
    ['intervalSet of times when rat was moving CW']);




pa = tsd(Range(posAlpha, 'ts'), continuousAngle(Data(posAlpha)));

warning off 
pa = smooth(pa, 10000);
warning on
headAngVel = timeDeriv(pa);
moveCCW = thresholdIntervals(headAngVel, vThresh, 'Direction', 'Above');
moveCW = thresholdIntervals(headAngVel,- vThresh, 'Direction', 'Below');

warning off
vx = timeDeriv(posX, 'PreSmooth', 10000);
vy = timeDeriv(posY, 'PreSmooth', 10000);
warning on
t = Range(vx, 'ts');
ratVel = tsd(t, sqrt((Data(vx)).^2 + (Data(vy)).^2));

if do_fig 
    clf
    plot(Range(headAngVel, 's'), Data(headAngVel));
    hold on 
    a = Restrict(headAngVel, moveCCW);
    plot(Range(a, 's'), Data(a), 'r.');
     a = Restrict(headAngVel, moveCW);
    plot(Range(a, 's'), Data(a), 'g.');
   keyboard
end


A = saveAllResources(A);