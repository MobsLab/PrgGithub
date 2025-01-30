function carte = carteOccupation(positions, taille, bornesArene)
%carteOccupation(positions, taille[, bornesArene])
%Retourne une matrice correspondant � une carte de l'ar�ne donnant les
%nombres de mesures ou l'agent occuper les diff�rentes zones
%Param�res : 
% - position    : matrice nx2 des positions occup�es par l'agent
% - taille      : vecteur 1x2 donnant la taille de la matrice � afficher : [hauteur, largeur]
% - bornesArene : (optionnel) [xmin xmax;ymin ymax] 

if (nargin < 3)
    M = max(positions);
    m = min(positions);
else
    M = bornesArene(:,2)'; %coordonn�es maximales
    m = bornesArene(:,1)'; %coordonn�es minimales
end

carte = zeros(taille);
nombrePositions = size(positions,1);

for i=1:nombrePositions
    coord = floor( (positions(i,:)-m)./(M-m) .* taille)+1;
    coord = min(coord, taille); %pour �viter que les coordonn�es ne d�passe la taille de la carte, ce qui se produirait quand les coordonn�es x ou y sont maximales
    
    carte(coord(1), coord(2)) = carte(coord(1), coord(2))+1;
end

end

