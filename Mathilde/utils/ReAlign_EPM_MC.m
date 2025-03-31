% You should redefine EPM zones before realigning it
% edit RedefineLargerEPMZones_MC.m

load('behavResources.mat')

%%
figure
imagesc(double(ref)), colormap jet, hold on
plot(Data(Ytsd)*Ratio_IMAonREAL,Data(Xtsd)*Ratio_IMAonREAL,'color',[0.8 0.8 0.8])

%%
A = regionprops(Zone_redefined{1},'Centroid');
clim;
plot(A.Centroid(1),A.Centroid(2),'r.','MarkerSize',50)
plot(A.Centroid(1),A.Centroid(2),'w*','MarkerSize',10)

% %room cervelet
% plot(A.Centroid(1)+60,A.Centroid(2)-60,'r.','MarkerSize',50)
% plot(A.Centroid(1)+60,A.Centroid(2)+60,'r.','MarkerSize',50)

% %room cervelet 2
% plot(A.Centroid(1)-60,A.Centroid(2)+60,'r.','MarkerSize',50)
% plot(A.Centroid(1)-60,A.Centroid(2)-60,'r.','MarkerSize',50)


%%room animalerie
plot(A.Centroid(1)+60,A.Centroid(2),'r.','MarkerSize',50)
plot(A.Centroid(1),A.Centroid(2)-60,'r.','MarkerSize',50)


%%
[x,y]  = ginput(3);

%point centre
%point ferme
%point ouvert

%%
XYOutput(1,:) = y;
XYOutput(2,:) = x;

Coord1 = [x(2)-x(1),y(2)-y(1)];
Coord2 = [x(3)-x(1),y(3)-y(1)];

TranssMat = [Coord1',Coord2'];

XInit = Data(Ytsd).*Ratio_IMAonREAL-x(1);
YInit = Data(Xtsd).*Ratio_IMAonREAL-y(1);

A = ((pinv(TranssMat)*[XInit,YInit]')');

AlignedXtsd = tsd(Range(Xtsd),A(:,1));
AlignedYtsd = tsd(Range(Ytsd),A(:,2));


figure, plot(Data(AlignedXtsd), Data(AlignedYtsd))

%%
save('behavResources.mat','AlignedXtsd','AlignedYtsd','-append')

%%


% 
% theta_1=-5;
% xdata_tsd_ctrl = tsd(Range(AlignedYtsd),Data(AlignedXtsd)*cosd(theta_1)-Data(AlignedYtsd)*sind(theta_1));
% ydata_tsd_ctrl= tsd(Range(AlignedYtsd),Data(AlignedYtsd)*cosd(theta_1)+Data(AlignedXtsd)*sind(theta_1));
% figure, plot(Data(xdata_tsd_ctrl), Data(ydata_tsd_ctrl))


