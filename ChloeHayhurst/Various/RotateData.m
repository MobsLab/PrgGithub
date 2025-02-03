function RotateData(rotatedCorners, Xtsd, Ytsd)
    % Définition des nouveaux axes : les coins du rectangle tourné
    xMin = min(rotatedCorners(:,1));
    xMax = max(rotatedCorners(:,1));
    yMin = min(rotatedCorners(:,2));
    yMax = max(rotatedCorners(:,2));

    % Normalisation des données
    X_normalized = (Data(Xtsd) - xMin) / (xMax - xMin); % X entre [0,1]
    Y_normalized = (Data(Ytsd) - yMin) / (yMax - yMin) * 1.6; % Y entre [0,1.6]

    % Affichage des données normalisées
    figure;
    plot(X_normalized, Y_normalized);  
end