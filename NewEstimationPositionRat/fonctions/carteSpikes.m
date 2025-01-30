function carte = carteSpikes(spikes, positions, taille, bornesArene, freqEch)
% carteSpikes(spikes, positions, taille[, bornesArene, freqEch])
% Renvoie une matrice de taille voulue donnant le nombre des spikes d'une CL dans les diff�rentes zone 
%
% Arguments:
% - spikes      : vecteur colonne donnant les instants des spikes
% - positions   : matrice n x 2 donnant l'�volution de la position (�chantillon�e � une fr�quance donn�e)
% - taille      : vecteur donnant les dimenstions souhait�es pour la carte [x y]
% - bornesArene : (optionnel) [xmin xmax;ymin ymax] 
% - frequEch    : (optionnel) fr�quence d'�chantillonage de la position

if (nargin < 4)
    M = max(positions);
    m = min(positions);
else
    M = bornesArene(:,2)'; %coordonn�es maximales
    m = bornesArene(:,1)'; %coordonn�es minimales
end

if(nargin < 5)
    freqEch = 30;
end





carte = zeros(taille);

for i=1:size(spikes,1)
    numPosition = floor(spikes(i)*freqEch);
    
    if (numPosition < 1) %pour les spikes enregistr�s un peu avant l'enregistrement de la premi�re position
        numPosition = 1;
    end
    if (numPosition > size(positions,1))
        delai = spikes(i) - size(positions,1)/freqEch;
        disp(['  ! - Spike ' num2str(delai,3) 's apr�s l''enregistrement de la derni�re position.']);
        
        numPosition = size(positions,1);
    end
    
    coord = floor( (positions(numPosition,:)-m)./(M-m) .* taille)+1;
    coord = min(coord, taille); %pour �viter que les coordonn�es ne d�passe la taille de la carte, ce qui se produirait quand les coordonn�es x ou y sont maximales
    
    carte(coord(1), coord(2)) = carte(coord(1), coord(2))+1;
    
end

end