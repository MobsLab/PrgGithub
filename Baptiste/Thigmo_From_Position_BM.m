
% AlignedPosition is a tsd with 1st colum X data between 0-1 and 2nd column
% Y data between 0-1

function [Thigmo_score, OccupMap] = Thigmo_From_Position_BM(AlignedPosition)

sizeMap=50;
Position = Data(AlignedPosition);

Position(or(Position<0 , Position>1)) = NaN;
OccupMap = hist2d([Position(:,1) ;0; 0; 1; 1] , [Position(:,2);0;1;0;1] , sizeMap , sizeMap);

OccupMap = OccupMap/sum(OccupMap(:));
OccupMap = OccupMap';

Thigmo_score = (nansum(nansum(OccupMap(2:5,[2:18 35:50]))) +...
    nansum(nansum(OccupMap(6:50,[2:4 48:50]))) +...
    nansum(nansum(OccupMap(6:43,[16:18 35:37]))) +...
    nansum(nansum(OccupMap(48:50,5:47))) +...
    nansum(nansum(OccupMap(44:46,19:34))));

end
