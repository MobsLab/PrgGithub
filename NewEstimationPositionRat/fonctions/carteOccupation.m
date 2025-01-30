function carte = carteOccupation(positions, taille, bornesArene)
%carteOccupation(positions, taille[, bornesArene])
%Retourne une matrice correspondant à une carte de l'arène donnant les
%nombres de mesures ou l'agent occuper les différentes zones
%Paramères : 
% - position    : matrice nx2 des positions occupées par l'agent
% - taille      : vecteur 1x2 donnant la taille de la matrice à afficher : [hauteur, largeur]
% - bornesArene : (optionnel) [xmin xmax;ymin ymax] 

if (nargin < 3)
    M = max(positions);
    m = min(positions);
else
    M = bornesArene(:,2)'; %coordonnées maximales
    m = bornesArene(:,1)'; %coordonnées minimales
end

carte = zeros(taille);
nombrePositions = size(positions,1);

for i=1:nombrePositions
    coord = floor( (positions(i,:)-m)./(M-m) .* taille)+1;
    coord = min(coord, taille); %pour éviter que les coordonnées ne dépasse la taille de la carte, ce qui se produirait quand les coordonnées x ou y sont maximales
    
    carte(coord(1), coord(2)) = carte(coord(1), coord(2))+1;
end

end

