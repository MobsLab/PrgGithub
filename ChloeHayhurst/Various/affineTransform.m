function [AlignedXtsd,AlignedYtsd] = affineTransform(Xtsd, Ytsd, rotatedCorners)
    % Définir les points cibles (nouveaux repères)
    targetPoints = [0, 0; 1.6, 0; 0, 1; 1.6, 1];
    
    % Points sources (les coins du rectangle tourné)
    sourcePoints = rotatedCorners;
    
    % Calcul de la matrice de transformation affine
    tform = fitgeotrans(sourcePoints, targetPoints, 'affine');

    % Transformation des données
    [X_transformed, Y_transformed] = transformPointsForward(tform, Data(Xtsd), Data(Ytsd));

    % Affichage des données transformées
    figure;
    plot(X_transformed, Y_transformed);
    
    AlignedXtsd = tsd(Range(Xtsd),X_transformed);
    AlignedYtsd = tsd(Range(Ytsd),Y_transformed);
    
end
