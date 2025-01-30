function pathIntegratorNet()


latticeSpacing = 40; % unit is "centimeters"
connectionSpan = 6; % the spread of the conncetion matrix

N = 800;  % the number of cells 
nSteps =6000; % the number of random walk steps
cageSize = 50; % the size of the rat "cage"
G = 10;
fixAct = 2;
gamma = 0.5;
dT = 1;
tau = 50;
threshold = 0.2;
dirStrength = 0.3;
Tadapt = 500;
Kadapt = 0.5 ;
monitorStep = 10;
% set up the place on the grid of  each cell 



x = rand(1,N) - 0.5;
y = rand(1, N) * sqrt(3) / 2;

nd = N;

% first draw points in a equilateral triangle
while(nd)
    % points falling outside the triangle)
    ndix = find(y > sqrt(3) * (x+0.5) | y  > -sqrt(3) * (x - 0.5));
    nd = length(ndix);
    x(ndix) = rand(1,nd)- 0.5;   
    y(ndix) = rand(1,nd) * sqrt(3)/2;
   
end

 


y(floor(N/2):N) = -y(floor(N/2):N);
 x = x * latticeSpacing;
 y = y * latticeSpacing;
 plot(x, y, '.');
 axis equal

 
 % the preferred direction for each cell 
 phi = rand(1,N)*2*pi;
 % The versor for each cell
 
 dirCell = [cos(phi) ; sin(phi)];
 
 
 
 % now compute synaptic matrix
 
 % to keep into accoutn the periodic conditions we need to sum terms
 % corresponding to several Bravais vectors, in practice we get two on each
 % side 
 J = zeros(N, N);
 
 v1 = [1, 0] * latticeSpacing;
 v2 = [0.5, sqrt(3)/2] * latticeSpacing;

 
 [X, Y] = meshgrid(x,y);
 Y = Y';
 [Phi,phiY] = meshgrid(phi,phi);
 for i = -2:2
     for j = -2:2
         [XC, YC] = meshgrid(x+i*v1(1)+j*v2(1), ...
             y+i*v1(2)+j*v2(2));
         XC = XC';

         zeta = atan2(YC-Y, XC-X);

         D = sqrt((X-XC).^2 + (Y-YC).^2);
         J = J + (1 + gamma * cos(zeta-Phi)) .* exp(-D  /connectionSpan);
         %J = J + exp(-D * (1 )/connectionSpan);
%          if i == 0 & j == 0
%              keyboard
%          end
         
     end
 end

 for i = 1:N
     J(i,i) = 0;
 end
 
 
 % normalize J so that the rows sum on average to 1
 Jnorm = mean(sum(J,2));
 J = J / Jnorm;
 
 figure
 imagesc(J);
 %keyboard
 
 
 
 %%%%%%% extract the part that 
 
 [xRat, yRat] = randomWalk(nSteps, cageSize);
 %load xRat
 vRat = [diff(xRat) ; diff(yRat)];
xRat = xRat(2:end);
yRat = yRat(2:end);

 Vi = zeros(N,1);
 Vi = 3* exp(-sqrt((x).^2+(y).^2)/(latticeSpacing/4));
 Vi = Vi';


 % parameters to pass to the C routine 
 
 % nSteps = the number of steps 
 params.nSteps = nSteps-1; % -1 necessary as the speed vector will have one element less
 params.monitorStep = monitorStep
 
 
 % dT  = time step 
 params.dT = dT;
 % tau = the time constant 
 params.tau = tau;
 
 % G = is the threshold-linear gain
 params.G = G;
 % threshold = the threshold-linear threshold
 params.threshold = threshold;
 % fixAct = the fixed activity level 
 params. fixAct =fixAct;
 
 
 % Tadapt = the adaptation time constant 
 % Kadapt = the adaptation strength
 params.Tadapt = Tadapt;
 params.Kadapt = Kadapt;
 
 
 %%%%%%%%%%%%%%%%%%%%%%this is the part that needs to be reimplemented 
 
 dbstop error
 tic
 Vconf = pathIntegratorNetImpl(J, dirCell, Vi, dirStrength * vRat, params);
 toc
 
 %initialize the network in a state where only cells in the center of grid
 %cell are active
 
 keyboard
dx = dirCell(1,:);
dy = dirCell(2,:);

vr = vRat(:,1:monitorStep:end);
xx = xRat(1:monitorStep:end);
yy = yRat(1:monitorStep:end);

 np = 1;

 
 for i = tInit:tEnd
     plotColors(x, y, Vconf(:,i)), axis equal
     hold on, plot(-30 + 10*cos(0:0.1:2*pi), 20 + 10* sin(0:0.1:2*pi));
     plot([-30, -30+50*vr(1,i)], [20, 20+50*vr(2,i)])
     plotColors(-30+10*dx, -20+10*dy, Vconf(:,i));
     axis([-40 40 -30 30]);
     plot([20 40], [-10 -10 ]);
     plot([20 20], [-10 -30]);
     mi = max(i-50, tInit);
     plot(xx(mi:i)/5+20, yy(mi:i)/5-30);
     plot(xx(i)/5+20, yy(i)/5-30, 'r.');
     
     hold off
     M(np) = getframe;
     np = np+1;
 end
 

 keyboard
