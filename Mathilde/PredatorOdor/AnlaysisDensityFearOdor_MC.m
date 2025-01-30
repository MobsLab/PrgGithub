
function [nn,xx,yy]=AnlaysisDensityFearOdor(Folder)

cd(Folder)
load('behavResources.mat')
test=ref;
test(mask==1)=0;
if not(exist('x_corner'))
figure, imagesc(test)
hold on
plot(Ratio_IMAonREAL*Data(Ytsd),Ratio_IMAonREAL*Data(Xtsd),'color','k')
title('cliquer sur haut gauche, haut droite, bas droite, bas gauche, puis enfin entrer')
[x_corner,y_corner]=ginput;
save('behavResources.mat','x_corner','y_corner','-append')
end
close all
xtemp = Ratio_IMAonREAL*Data(Ytsd);
ytemp = Ratio_IMAonREAL*Data(Xtsd);

% list=xtemp<min(x(1),x(4));
% xtemp(list)=mean([min(x(1),x(4)) max(x(2),x(3))]);
% ytemp(list)=mean([min(y(1),y(4)),max(y(2),y(3))]);
%
% list=ytemp<min(y(1),y(4));
% ytemp(list)=mean([min(y(1),y(4)),max(y(2),y(3))]);
% xtemp(list)=mean([min(x(1),x(4)) max(x(2),x(3))]);
%
% list=xtemp>max(x(2),x(3));
% xtemp(list)=mean([min(x(1),x(4)) max(x(2),x(3))]);
% ytemp(list)=mean([min(y(1),y(4)),max(y(2),y(3))]);
%
% list=ytemp>max(y(2),y(3));
% ytemp(list)=mean([min(y(1),y(4)),max(y(2),y(3))]);
% xtemp(list)=mean([min(x(1),x(4)) max(x(2),x(3))]);


xval=rescale(xtemp,min(x_corner(1),x_corner(4)),max(x_corner(2),x_corner(3)));
yval=rescale(ytemp,min(y_corner(1),y_corner(4)),max(y_corner(2),y_corner(3)));
xval=rescale(xval,0,1);
yval=rescale(yval,0,1);
[nn,xx,yy]=hist2(xval,yval,[0 0.02 1],[0 0.02 1]);

% figure,
% % subplot(1,3,1), hold on, imagesc(test), plot(Ratio_IMAonREAL*Data(Ytsd),Ratio_IMAonREAL*Data(Xtsd),'color','k')
% % subplot(1,3,2),imagesc(xx,yy,nn)
% % subplot(1,3,3),
% imagesc(xx,yy,SmoothDec(nn,1));


end
