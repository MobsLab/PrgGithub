function makeRombicVideo()

%load Vconf

%%%%%%%%%
load gridWaves
Vconf = Vin;
monitorStep = 1;
vRat = zeros(size(xRat));
tVideoInit = 1;
tVideoEnd = length(xRat);
%%%%%%%%%%%%

np = 1;
tVideoInit =1;
tVideoEnd = 50;
vRat = [diff(xRat) ; diff(yRat)];

vr = vRat(:,1:monitorStep:end);

xx = xRat(1:monitorStep:end);
yy = yRat(1:monitorStep:end);

tInit = tVideoInit;
tEnd = tVideoEnd;
%video generation


figure(2)


for i = tInit:1:tEnd


    plotColors(x, y, Vconf(:,i), 10), axis equal % activation as a function of position on the grid
    hold on;
    axis([-20 30 -20 20]);
    set(gca,'xtick', [], 'ytick', []);
    text(25, 10, num2str(i));
    hold off
    M(np) = getframe;
    clf
    np = np+1;
end

movie2avi(M, 'Packet.avi', 'FPS', 6, 'COMPRESSION', 'None');