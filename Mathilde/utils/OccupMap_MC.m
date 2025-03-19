function [nn,xx,yy]=OccupMap_MC(x_tsd, y_tsd, Ratio_IMAonREAL, mask)
%%
mask_conv = im2double(mask);
y1 = find(mean(mask_conv));
x1 = find(mean(mask_conv));


x_corner = [min(x1); max(x1); max(x1); min(x1)];
y_corner = [min(y1); min(y1); max(y1); max(y1)];

ytemp = Ratio_IMAonREAL*y_tsd;
xtemp = Ratio_IMAonREAL*x_tsd;

xval=rescale(xtemp,min(x_corner(1),x_corner(4)),max(x_corner(2),x_corner(3)));
yval=rescale(ytemp,min(y_corner(1),y_corner(4)),max(y_corner(2),y_corner(3)));

xval=rescale(xval,0,1);
yval=rescale(yval,0,1);

[nn,xx,yy]=hist2(xval,yval,[0 0.02 1],[0 0.02 1]);

% figure,imagesc(nn)
% caxis([0 100])
