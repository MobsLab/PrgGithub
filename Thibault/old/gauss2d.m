function mat = gauss2d(gsize, sigma, center)
	% gsize = size(mat);
	[R,C] = ndgrid(1:gsize(1), 1:gsize(2));
	mat = gaussC(R,C, sigma, center);
end


function val = gaussC(x,y,sigma,center)
	xc = center(1);
	yc = center(2);
	exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma);
	amplitude = 1/(sigma*sqrt(2*pi));
	val = amplitude*exp(-exponent);
end 
