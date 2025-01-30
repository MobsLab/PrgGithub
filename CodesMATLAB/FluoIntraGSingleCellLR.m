function [R,R2]=FluoIntraGSingleCellLR()

M1=double(imread('Mask1.tif'));
M2=double(imread('Mask2.tif'));
I=double(imread('Im.tif'));
I2=double(imread('Im2.tif'));

M1=(255-M1)>0;
M2=(255-M2)>0;

% figure;
% imagesc(M1),colormap gray, axis image
% figure;
% imagesc(M2),colormap gray, axis image

% MD=(M1-M2)>0;
% D=I.*((M1-M2)>0);

% figure;
% imagesc(MD),colormap gray, axis image
% figure;
% imagesc(D,[0 255]),colormap gray, axis image

% figure;
% imagesc(I.*((M1-M2)>0)),colormap gray, axis image

Ft=sum(sum(I.*((M1)>0)));
Fo=sum(sum(I.*((M1-M2)>0)));

Ft2=sum(sum(I2.*((M1)>0)));
Fo2=sum(sum(I2.*((M1-M2)>0)));

R=(1-Fo/Ft)*100;
R2=(1-Fo2/Ft2)*100;
