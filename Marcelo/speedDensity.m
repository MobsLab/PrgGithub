function [average posX posY] = speedDensity(x,y,speed)

X=x;
Y=y;
Speed=speed;
% X=X(1:end-1);
% Y=Y(1:end-1);


binnum=135;
binsx = linspace(min(X)-4,max(X)+4,binnum);
binsy = linspace(min(Y)-4,max(Y)+4,binnum);

[average, stdev, centers, population, out_of_range] = binXYZonXY( binsx, binsy, X, Y, Speed, 0, 0 );

average(isnan(average)) = 0;
average = SmoothDec(average/15,[3,3]);

posY = centers.y(:,1);
posX = centers.x(:,1);

% figure
% imagesc(posX,posY,average)
% set(gca, 'XTickLabel', []);
% set(gca, 'YTickLabel', []);
% colormap jet

end