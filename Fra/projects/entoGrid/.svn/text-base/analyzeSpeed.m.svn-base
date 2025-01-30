

load Vconf
N = ([0.5 0.5 ; (sqrt(3)/2) (-sqrt(3)/2)]);
M = inv(N);
G = M * [x ;y];
G = (G' + 20) / 40 * 2 * pi;

Q = [cos(G(:,1)) sin(G(:,1))  cos(G(:,2)) sin(G(:,2))];
S = Vconf' * Q;
T = [ atan2(S(:,2), S(:,1)) atan2(S(:,4), S(:,3))];
dT = diff(T);
dT(dT > 5) = dT(dT>5) - 2 * pi;
dT(dT < -5) = dT(dT< -5) + 2 * pi;
T1 = cumsum(dT);
T2 = N * T1';
dT2 = N * dT';
dT2 = dT2';


dx = diff(xx);
dx = dx';
dy = diff(yy);
dy = dy';

figure(1), plot(dx, dT2(:,1), '.')
figure(2), plot(dy, dT2(:,2), '.')
corrcoef( dT2(:,1), dx)
corrcoef( dT2(:,2), dy)

display 'regressions'

b = regress(dT2(:,1), dx)
b = regress(dT2(:,2), dy)
