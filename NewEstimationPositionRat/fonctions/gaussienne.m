function [ mu, W ] = gaussienne(mat)
% gaussienne(mat)
%   Renvoi un modèle gaussien basé sur la matrice donné en argument
%
% Pour l'instant, le résultat renvoyé est directement la moyenne et l'écart
% type calculés sur la matrice

somme = sum(mat(:));

%Les matrices suivantes permettent de faire des calculs de barycentre à
%partir de mat
coordX = ones(size(mat,1),1) * (0:(size(mat,2)-1));     % On a : coordX(i,j) = i-1
coordY =(ones(size(mat,2),1) * (0:(size(mat,1)-1)))';   % On a : coordY(i,j) = j-1


%Pour le modèle gaussien :
%Barycentre
xm = sum(sum(mat .* coordX)) / somme;
ym = sum(sum(mat .* coordY)) / somme;
mu = [xm;ym];
%Variances
sigmaX2 = sum(sum(mat .*(coordX-xm).^2 )) / somme;
sigmaY2 = sum(sum(mat .*(coordY-ym).^2 )) / somme;
W = diag([sigmaX2 sigmaY2]);

end

