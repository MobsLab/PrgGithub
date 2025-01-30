
% AlignedPosition is a tsd with 1st colum X data between 0-40 and 2nd column
% Y data between 0-20

function [Thigmo_score, OccupMap] = Thigmo_From_Position_HomeCage_BM(AlignedPosition)

sizeMap=50;
Position = Data(AlignedPosition);

Position(or(Position<0 , Position>40)) = NaN;
OccupMap = hist2d([Position(:,1) ;1; 1; 40; 40] , [Position(:,2);1;20;1;20] , sizeMap , sizeMap);

OccupMap = OccupMap/sum(OccupMap(:));
OccupMap = OccupMap';

Thigmo_score = nansum(nansum(OccupMap([1:10 41:50],:))) + nansum(nansum(OccupMap(11:40,[1:5 46:50])));

end