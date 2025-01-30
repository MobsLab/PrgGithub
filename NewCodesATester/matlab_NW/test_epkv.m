
clear
close all

X1 = rand(3000,1);
X2 = rand(3000,1);
sigma = X1;

Y = X1.^2+X2.^6 + sigma.*randn(3000,1);

bins1 = 10;
bins2 = 15;
bandwidth1 = .1;
bandwidth2 = .09;
alpha = .01;
resamples = 100;


[output, h] = NWbootstrap_epkv_3D(X1, X2, Y, bins1, bins2, bandwidth1, bandwidth2, alpha, resamples);

%uncomment this line to plot the data as a scatter on top of the fitted
%3D surface:

%plot3(X1,X2,Y,'o')


[output2D, h2d] = NWbootstrap_epkv(X1, Y, bins1, bandwidth1, alpha, resamples);











