function makeGridWaves()


load InitConf

cageSize = 50;
nSteps = 5000;
N = length(Vi);

Vq = reshape(Vi, cageSize, cageSize);

Vin = zeros(N, nSteps, 'single');



[xRat, yRat] = randomWalk(nSteps*10+500, cageSize);
xRat = ceil(xRat(251:end-250));
yRat = ceil(yRat(251:end-250));
xRat = xRat(1:10:end);
yRat = yRat(1:10:end);

xRat = [];
yRat = [];
for i  = 1:13
    m =ceil(i * 8 / 13);
    xx = -(m-1):(m-1);
    yy = i * ones(size(xx));
    xRat = [xRat, xx];
    yRat = [yRat, yy];
end

for i = 12:-1:1
    m =ceil((13-i) * 8 / 13);
    xx = -(m-1):(m-1);
    yy =13+ i * ones(size(xx));
    xRat = [xRat, xx];
    yRat = [yRat, yy];
end

xRat = [xRat, -8];
yRat = [yRat, 13];

xRat = xRat + 16;
yRat = yRat +5;
    

nSteps = length(xRat);
Vin = zeros(N, nSteps, 'single');

for i = 1:nSteps
    Vz = Vq([yRat(i):end 1:(yRat(i)-1)], [xRat(i):end 1:(xRat(i)-1)]);
    Vin(:,i) = Vz(:);
end


[x, y] = meshgrid(1:cageSize, 1:cageSize);
x = x(:);
y = y(:);

save gridWaves Vin x y xRat yRat
    