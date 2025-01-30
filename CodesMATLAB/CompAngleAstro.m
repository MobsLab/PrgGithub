

%CompAngleAstro



%    Vecteur X       Vecteur Y	Xastro      Yastro      Xcenter     Ycenter
% R=[[-0.463083956	0.507441046	128.662154	136.230516	102.3585228	157.1011287];
%     [-0.28       	-0.96       330.3590013	288.3545922 310.1340178	255.1550625	]];




for k=1:size(R,1)
    
    p1=angle(R(k,1)+i*R(k,2));
    cen=R(k,5:6)-R(k,3:4);
    p2=angle(cen(1)+i*cen(2));

    Ang(k)=p1-p2;
    
end


% cellule 6 outlier:
AngOK=Ang([[1:5],[7:14]])';

%  Comparaison à une distribution gaussienne de moyenne 0 avec la meme std
%  que AngOK
[h,p]=ztest(AngOK,0,std(AngOK));

%  Calcul des caracteristiques de la distribution:
[Ma,Sa,Ea]=MeanDifNan(abs(AngOK));
[M,S,E]=MeanDifNan(AngOK);
%????
[m,s,e]=MeanDifNan(abs(Ang'));

save Data14cellsIN R Ang AngOK h p Ma Sa Ea M S E m s e




