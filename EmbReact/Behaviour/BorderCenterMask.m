function [Border,Center] = BorderCenterMask(mask, AreaFact)

% This codes takes the mask or an area and gives as output the border and
% the center of the mask (border area = roughly mask area)
% AreaFact rovides the ratio between total border and total center area
% if its set to 2 the environment is cut in two ewual parts:  border and
% center


stats = regionprops(mask, 'Area');
tempmask=mask;
AimArea=stats.Area/AreaFact;
ActArea=stats.Area;
while AimArea<ActArea
    tempmask=imerode(tempmask,strel('disk',1));
    stats = regionprops(tempmask, 'Area');
    ActArea=stats.Area;
end
Border=uint8(tempmask); % Inside area
Center=uint8(mask-tempmask);% Outside area

end