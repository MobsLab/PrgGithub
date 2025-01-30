function DistNear = DistancePointNearestSideRectangle(POI,RectangleCorners)

% POI : x and y coordinates of point
% RectangleCorners : x and y coordinates of four corners of rectangle

for corner = 1:4
    nextcorner = mod(corner+1,4);
    if nextcorner==0, nextcorner = 4; end
    Num = abs((RectangleCorners(corner,1) - RectangleCorners(nextcorner,1))*(POI(2) - RectangleCorners(nextcorner,2)) -...
        (RectangleCorners(corner,2) - RectangleCorners(nextcorner,2))*(POI(1) - RectangleCorners(nextcorner,1)));
    Denom = sqrt((RectangleCorners(corner,1) - RectangleCorners(nextcorner,1)).^2 + (RectangleCorners(corner,2) - RectangleCorners(nextcorner,2)).^2);
    
    Dist(corner) = Num ./Denom;
    
end

DistNear = min(Dist);