function SoftImg = SoftImg(Img)

sizeGauss = 20;

gauss = zeros(sizeGauss,sizeGauss);

for i=1:sizeGauss
	for j =1:sizeGauss
		gauss(i,j) = sqrt(i^2+j^2);
	end
end


gauss = exp(-gauss.*gauss/(sizeGauss));

SoftImg = conv2(Img,gauss);