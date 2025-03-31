function [Zone, ZoneLabels] = DefineZones_Offline_DB(ref, mask)

load('/media/nas5/ProjetERC2/Mouse-905/20190404/Retracking/TestPost/TestPost1/behavResources.mat');
savefolder = '/media/nas5/ProjetERC2/Mouse-905/20190404/Retracking/TestPost/TestPost1';
figtemp=figure();
imagesc(ref), colormap redblue, hold on
% added farshock and farnoshock zones (SL - 23/07/2019)
Zone = [];
title('Shock'); [x1,y1,Shock,x2,y2]=roipoly; Zone{1}=uint8(Shock);plot(x2,y2,'linewidth',2)
title('NoShock');[x1,y1,NoShock,x2,y2]=roipoly(); Zone{2}=uint8(NoShock);plot(x2,y2,'linewidth',2)
title('Centre');[x1,y1,Centre,x2,y2]=roipoly(); Zone{3}=uint8(Centre);plot(x2,y2,'linewidth',2)
title('CentreShock');[x1,y1,CentreShock,x2,y2]=roipoly(); Zone{4}=uint8(CentreShock);plot(x2,y2,'linewidth',2)
title('CentreNoShock');[x1,y1,CentreNoShock,x2,y2]=roipoly(); Zone{5}=uint8(CentreNoShock);plot(x2,y2,'linewidth',2)
title('FarShock');[x1,y1,FarShock,x2,y2]=roipoly(); Zone{8}=uint8(FarShock);plot(x2,y2,'linewidth',2)
title('FarNoShock');[x1,y1,FarNoShock,x2,y2]=roipoly(); Zone{9}=uint8(FarNoShock);plot(x2,y2,'linewidth',2)
stats = regionprops(mask, 'Area');
tempmask=mask;
AimArea=stats.Area/2;
ActArea=stats.Area;
while AimArea<ActArea
    tempmask=imerode(tempmask,strel('disk',1));
    stats = regionprops(tempmask, 'Area');
    ActArea=stats.Area;
end
Zone{6}=uint8(tempmask); % I]
Zone{7}=uint8(mask-tempmask);% Outside area
ZoneLabels={'Shock','NoShock','Centre','CentreShock','CentreNoShock','Inside','Outside','FarShock','FarNoShock'};

close(figtemp)

save([savefolder, filesep,'/behavResources.mat'],'Zone','ZoneLabels','-append');

end
