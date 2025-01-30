function positionE = estimerBarycentre(CL, decharges)
    % Renvoie une estimation de la position sachant quelles CL d�chargent
    % 
    % Utilisation : estimerPosition(CL, decharges, modele)
    %
    % - CL est une liste d'objets CelluleDeLieu
    % - descharges est un vecteur ligne d�crivant le rythme de d�charge des CL
    %
    % La valeur de retour est un vecteur colonne de taille 2
    %
    
    %seuil d'activit� (rapport freq/freqMax) au dessous duquel on ne
    %consid�rera plus la CL
    seuil = 0.3;
    % on consid�re qu'une CL est active si elle d�charge � un rythme
    % suffisant
    activite = decharges ./ [CL.freqMax];
    activite(activite < seuil) = 0;

        
    %%%  Si aucune CL n'a d�charg�, aucune estimation:
    if sum(activite)==0
        positionE = [NaN NaN]';
        return;
    end
    
    
    %Dans ce mod�le, la position estim�e est un barycentre des centres des
    %domaines des CL
    poids = activite ./ [CL.rayon];

    coordonneesPonderees = [CL.position].*repmat(poids,2,1);
    positionE = sum(coordonneesPonderees, 2) / sum(poids, 2);

end