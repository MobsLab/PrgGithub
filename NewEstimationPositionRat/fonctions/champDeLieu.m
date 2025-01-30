function chL = champDeLieu(cO, cS, seuilOccupation, seuilFrequence)
% Renvoie la matrice de champ de lieu ainsi que les param�tres de son mod�le gaussien
%
% Arguments:
% - cO              : carte d'occupation (matrice donnant le nombre de positions mesur�se dans une zone donn�e de l'ar�ne)
% - cS              : cartes des spikes (matrice donnant le nombre de spikes mesur�s dans une zone donn�e de l'ar�ne)
% - seuilOccupation : nombre de passages dans une zone en dessous duquel elle ne sera pas prise en compte
% - seuilFrequence  : pourcentage du temps pass� dans une zone et pour laquelle la CL ne d�chargait pas au-dessous duquel les d�charges seront ignor�es 
%
%   Attention : cO et cS doivent avoir les m�mes dimensions
%
% Renvoie:
% - chL             : matrice de m�me taille que cO et cS
% - mu              : vecteur (colonne) position du centre du champ de lieu
% - W               : matrice de covariance associ�e au champ de lieu

if (nargin < 3)
    seuilOccupation = 0;
    seuilFrequence  = 0;
end

%Application du seuil d'occupation
cO(cO<seuilOccupation) = 0;
cS(cO<seuilOccupation) = 0;

%Le champ de lieu s'obtient avec la fr�quence de d�charge en chaque point
chL = cS ./ cO;
chL(isnan(chL)) = 0;%remplacement des NaN (issus de 0/0 par 0

%Flou gaussien (r�gl� de mani�re arbiraire...) (Inutile pour appliquer un mod�le gaussien par la suite)
h = fspecial('gaussian', 5, 1); % Commentez les trois lignes suivants si elles causent une erreur (pas de tootlbox image processing)
chL = imfilter(chL,h);

%Normalisation (maximum �gal � 1)
chL = chL / max(chL(:));

%Application du seuil de fr�quence
chL(chL<seuilFrequence) = 0;

end

