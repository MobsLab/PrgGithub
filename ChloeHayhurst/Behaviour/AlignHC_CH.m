function AlignHC_CH(Xtsd,Ytsd)

% This function is made to align the homecage, and tranforms the X and Y
% tsd data to make it so that they are comprised between respectively 0 and
% 1.6 and 0 and 1.
figure
plot(Data(Xtsd),Data(Ytsd))

h = imrect(gca, [mean(Data(Xtsd)), mean(Data(Ytsd)), 0.4, 0.6]);
wait(h);

rectPos = getPosition(h);

center(1)=rectPos(1) + rectPos(3) / 2;
center(2) = rectPos(2) + rectPos(4) / 2;

corners = [rectPos(1), rectPos(2);  % Coin inférieur gauche
    rectPos(1) + rectPos(3), rectPos(2);  % Coin inférieur droit
    rectPos(1), rectPos(2) + rectPos(4);  % Coin supérieur gauche
    rectPos(1) + rectPos(3), rectPos(2) + rectPos(4)];  % Coin supérieur droit

rotationMatrix = @(angleRad) [cos(angleRad), -sin(angleRad); sin(angleRad), cos(angleRad)];

angle = input('Entrez l"angle de rotation (en degrés) : ');

angleRad = deg2rad(angle);

rotatedCorners = zeros(size(corners));
for i = 1:size(corners, 1)
    translatedCorner = corners(i, :) - center;
    
    rotatedCorner = (rotationMatrix(angleRad) * translatedCorner')';
    
    rotatedCorners(i, :) = rotatedCorner + center;
end

plot(Data(Xtsd), Data(Ytsd));
hold on;

fill(rotatedCorners(:, 1), rotatedCorners(:, 2), 'r', 'FaceAlpha', 0.3);

%     RotateData(rotatedCorners, Xtsd, Ytsd);
[AlignedXtsd,AlignedYtsd] = affineTransform(Xtsd, Ytsd, rotatedCorners);

end