function makeRombicVideo()

load Vconf

np = 1;
tVideoInit =10;
tVideoEnd = 600;
vRat = [diff(xRat) ; diff(yRat)];

vr = vRat(:,1:monitorStep:end);

xx = xRat(1:monitorStep:end);
yy = yRat(1:monitorStep:end);

tInit = tVideoInit;
tEnd = tVideoEnd;
%video generation

d = x.^2+y.^2;
[ds, ix] = sort(d); % recover index of cell in the center of diamond
ix = ix(1:4);
Vq = Vconf(ix,:);
Vq = max(Vq, [], 1);
Vq = Vq ./ mean(Vconf,1);
d = x.^2+(y-8).^2;
[ds, ix] = sort(d); % recover index of cell in the center of diamond
ix = ix(1:4);
Vq1 = Vconf(ix,:);
Vq1 = max(Vq1, [], 1);
Vq1 = Vq1 ./ mean(Vconf,1);
figure(1)

plot(Vq)
hold on 
plot(Vq1, 'r');

figure(2)

xf = [];
yf = [];
xf1 = [];
yf1 = [];
for i = tInit:tEnd


    plotColors(x-20, y, Vconf(:,i), 10), axis equal % activation as a function of position on the grid
    hold on;
    axis([-40 40 -40 40]);
    plot(30 + 10*cos(0:0.1:2*pi), 30 + 10* sin(0:0.1:2*pi)); % Rat inst. speed     
    plot([30, 30+50*vr(1,i)], [30, 30+50*vr(2,i)])
   
    if Vq(i)> 2.5
        xf = [xf, xx(i)];
        yf = [yf, yy(i)];        
    end
     if Vq1(i)> 2.5
        xf1 = [xf1, xx(i)];
        yf1= [yf1, yy(i)];        
    end
    
    % rat position
    plot([0 40], [0 0 ]);
    plot([0 0], [0 -40]);
    mi = max(i-50, tInit);
    plot(xf/2.5+0, yf/2.5-40, 'c.');
    plot(xf1/2.5+0, yf1/2.5-40, 'm.');
    plot(xx(mi:i)/2.5+0, yy(mi:i)/2.5-40);
    plot(xx(i)/2.5+0, yy(i)/2.5-40, 'r.');
    text(-35, 35, num2str(i));
    hold off
    M(np) = getframe;
    clf
    np = np+1;
end

movie2avi(M, 'Packet.avi', 'FPS', 6, 'COMPRESSION', 'None');