function [H,occ,x,y] = hsvOccMap(X,Y,ep)

%Adrien Peyrache, 2012

slope = 4;
offSet = 0.0;
smW = 10;

[occ, x, y] = hist2d(Data(Restrict(X,ep)), Data(Restrict(Y,ep)), 100,100);

occH = gausssmooth(occ,smW);

H = zeros(length(x),length(x),3);

%pure empirical definition that works best
occH = (occH-min(occH(:)))/(max(occH(:))-min(occH(:)));
occH = tanh(slope*(occH-offSet))-tanh(-slope*offSet);
occH = occH/max(occH(:));

H(:,:,3) = occH;
H(:,:,2) = 1;
