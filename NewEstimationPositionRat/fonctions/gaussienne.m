function [ mu, W ] = gaussienne(mat)
% gaussienne(mat)
%   Renvoi un mod�le gaussien bas� sur la matrice donn� en argument
%
% Pour l'instant, le r�sultat renvoy� est directement la moyenne et l'�cart
% type calcul�s sur la matrice

somme = sum(mat(:));

%Les matrices suivantes permettent de faire des calculs de barycentre �
%partir de mat
coordX = ones(size(mat,1),1) * (0:(size(mat,2)-1));     % On a : coordX(i,j) = i-1
coordY =(ones(size(mat,2),1) * (0:(size(mat,1)-1)))';   % On a : coordY(i,j) = j-1


%Pour le mod�le gaussien :
%Barycentre
xm = sum(sum(mat .* coordX)) / somme;
ym = sum(sum(mat .* coordY)) / somme;
mu = [xm;ym];
%Variances
sigmaX2 = sum(sum(mat .*(coordX-xm).^2 )) / somme;
sigmaY2 = sum(sum(mat .*(coordY-ym).^2 )) / somme;
W = diag([sigmaX2 sigmaY2]);

end

