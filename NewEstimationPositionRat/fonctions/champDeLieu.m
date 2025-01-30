function chL = champDeLieu(cO, cS, seuilOccupation, seuilFrequence)
% Renvoie la matrice de champ de lieu ainsi que les paramètres de son modèle gaussien
%
% Arguments:
% - cO              : carte d'occupation (matrice donnant le nombre de positions mesurése dans une zone donnée de l'arène)
% - cS              : cartes des spikes (matrice donnant le nombre de spikes mesurés dans une zone donnée de l'arène)
% - seuilOccupation : nombre de passages dans une zone en dessous duquel elle ne sera pas prise en compte
% - seuilFrequence  : pourcentage du temps passé dans une zone et pour laquelle la CL ne déchargait pas au-dessous duquel les décharges seront ignorées 
%
%   Attention : cO et cS doivent avoir les mêmes dimensions
%
% Renvoie:
% - chL             : matrice de même taille que cO et cS
% - mu              : vecteur (colonne) position du centre du champ de lieu
% - W               : matrice de covariance associée au champ de lieu

if (nargin < 3)
    seuilOccupation = 0;
    seuilFrequence  = 0;
end

%Application du seuil d'occupation
cO(cO<seuilOccupation) = 0;
cS(cO<seuilOccupation) = 0;

%Le champ de lieu s'obtient avec la fréquence de décharge en chaque point
chL = cS ./ cO;
chL(isnan(chL)) = 0;%remplacement des NaN (issus de 0/0 par 0

%Flou gaussien (réglé de manière arbiraire...) (Inutile pour appliquer un modèle gaussien par la suite)
h = fspecial('gaussian', 5, 1); % Commentez les trois lignes suivants si elles causent une erreur (pas de tootlbox image processing)
chL = imfilter(chL,h);

%Normalisation (maximum égal à 1)
chL = chL / max(chL(:));

%Application du seuil de fréquence
chL(chL<seuilFrequence) = 0;

end

