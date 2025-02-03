function [rotatedCorners] = rotateRectangle(rectPos,Xtsd,Ytsd)

center(1)=rectPos(1) + rectPos(3) / 2;
center(2) = rectPos(2) + rectPos(4) / 2;


% Calcul des coins du rectangle
corners = [rectPos(1), rectPos(2);  % Coin inférieur gauche
           rectPos(1) + rectPos(3), rectPos(2);  % Coin inférieur droit
           rectPos(1), rectPos(2) + rectPos(4);  % Coin supérieur gauche
           rectPos(1) + rectPos(3), rectPos(2) + rectPos(4)];  % Coin supérieur droit

% Fonction de rotation autour du centre
rotationMatrix = @(angleRad) [cos(angleRad), -sin(angleRad); sin(angleRad), cos(angleRad)];

angle = input('Entrez l"angle de rotation (en degrés) : ');

    angleRad = deg2rad(angle);

    rotatedCorners = zeros(size(corners));
    for i = 1:size(corners, 1)
        % Déplacer chaque coin par rapport au centre
        translatedCorner = corners(i, :) - center;
        
        % Appliquer la rotation
        rotatedCorner = (rotationMatrix(angleRad) * translatedCorner')';
        
        % Remettre chaque coin à sa position d'origine (en ajoutant le centre)
        rotatedCorners(i, :) = rotatedCorner + center;
    end

    % Effacer le graphique précédent
%     cla;
    plot(Data(Xtsd), Data(Ytsd));
    hold on;

    % Tracer le rectangle tourné
    fill(rotatedCorners(:, 1), rotatedCorners(:, 2), 'r', 'FaceAlpha', 0.3);
    
%     RotateData(rotatedCorners, Xtsd, Ytsd);
    affineTransform(Data(Xtsd), Data(Ytsd), rotatedCorners);

end