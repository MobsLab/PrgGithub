function[a,sansHesit,bloc,strategie,NewColorMap]= PrgMRKLight(a,name,tailleFenetre,rule)
% si dessous la version pour telecharger un fichier de Lionel
%function[a,sansHesit,bloc,strategie,NewColorMap]= PrgMRKLight(name,tailleFenetre,rule)
% SHELL (Konsole)
% sed 's/R/1/;s/L/0/;s/C/0/;s/E/1/' 22_behavior_Right1.txt > 22_behavior_Right1_Num.txt 
% Or : for i in *;do sed 's/R/1/;s/L/0/;s/C/0/;s/E/1/' $i > converted-$i;done

%a=dlmread([name],'\t');
%a=dlmread('22_behavior_Light1_Num.txt','\t') % charge la matrice correspondant aux essais
% strategie right en 2eme colonne
    %task rule light
    a(rule(:,1)==2&a(:,3)==1&a(:,4)==1,6)=1; % mets en 6eme colonne de la matrice les strategies Right ou la lumiere est a droite et le rat fait un essai Correct
    a(rule(:,1)==2&a(:,3)==0&a(:,4)==0,6)=1; % mets en 6eme colonne de la matrice les strategies Right ou la lumiere est a gauche et le rat fait donc un essai Error
    %task rule dark
    a(rule(:,1)==4&a(:,3)==1&a(:,4)==0,6)=1; % mets en 6eme colonne de la matrice les strategies Right ou la lumiere est a droite et le rat fait un essai Error
    a(rule(:,1)==4&a(:,3)==0&a(:,4)==1,6)=1; % mets en 6eme colonne de la matrice les strategies Right ou la lumiere est a gauche et le rat fait donc un essai Correct
    % la colonne 6 affiche alors un 1 qd le rat semble avoir essaye une strat Right
    b(:,2)=a(:,6); % copie la colonne 6 de la matrice a en 2eme colonne d'une matrice b
    a(:,6)=0; % Remets la colonne 6 a Zero pour pouvoir s'en reservir avec les autres strategies
    %task rule right
    b(rule(:,1)==1,2)=a(rule(:,1)==1,4); %strategie Right toutes les fois ou le rat a fait un essai correct
    %task rule left
    b(rule(:,1)==3&a(:,4)==0,2)=1; %strategie Right toutes les fois ou le rat fait une erreur
% strategie left en 3eme colonne
    %task rule light
    a(rule(:,1)==2&a(:,3)==1&a(:,4)==0,6)=1; %mets en 6eme colonne de a les strategies left ou la lumiere est a droite et le rat fait Error
    a(rule(:,1)==2&a(:,3)==0&a(:,4)==1,6)=1; %mets en 6eme colonne de a les strategies left ou la lumiere est a gauche et le rat fait Correct
    %task rule dark
    a(rule(:,1)==4&a(:,3)==1&a(:,4)==1,6)=1; %mets en 6eme colonne de a les strategies left ou la lumiere est a droite et le rat fait Correct
    a(rule(:,1)==4&a(:,3)==0&a(:,4)==0,6)=1; %mets en 6eme colonne de a les strategies left ou la lumiere est a gauche et le rat fait Error
    b(:,3)=a(:,6); % on copie la strategie Left qui est affectee a la 3eme colonne.
    a(:,6)=0; % Remets la colonne 6 a Zero pour pouvoir s'en reservir avec les autres strategies
    %task rule right
    b(rule(:,1)==1&a(:,4)==0,3)=1; %strategie Left toutes les fois ou le rat fait une Error
    %task rule left
    b(rule(:,1)==3,3)=a(rule(:,1)==3,4); %strategie Left toutes les fois ou le rat a fait un essai correct
% strategie light en 4eme colonne
    % task rule light
    b(rule(:,1)==2,4)=a(rule(:,1)==2,4); %strategie Light en 4eme colonne de b toutes les bonnes réponses
    % task rule dark
    b(rule(:,1)==4&a(:,4)==0,4)=1; %strategie Light toutes les fois ou le rat fait une Error
    % task rule right
    a(rule(:,1)==1&a(:,3)==1&a(:,4)==1,6)=1; %mets en 6eme colonne de a les strategies light ou la lumiere est a droite et le rat fait Correct
    a(rule(:,1)==1&a(:,3)==0&a(:,4)==0,6)=1; %mets en 6eme colonne de a les strategies light ou la lumiere est a gauche et le rat fait Error
    % task rule left
    a(rule(:,1)==3&a(:,3)==1&a(:,4)==0,6)=1; %mets en 6eme colonne de a les strategies light ou la lumiere est a droite et le rat fait Error
    a(rule(:,1)==3&a(:,3)==0&a(:,4)==1,6)=1; %mets en 6eme colonne de a les strategies light ou la lumiere est a gauche et le rat fait Correct
    a(:,6)=0;
% strategie dark en 5eme colonne
    % task rule light
    b(rule(:,1)==2&a(:,4)==0,5)=1; %strategie Dark en 5eme colonne de b quand essai Error
    % task rule dark
    b(rule(:,1)==4,5)=a(rule(:,1)==4,4); %strategie Dark en 5eme colonne de b toutes les bonnes réponses
    % task rule right
    a(rule(:,1)==1&a(:,3)==1&a(:,4)==0,6)=1; %mets en 6eme colonne de a les strategies dark ou la lumiere est a droite et le rat fait Error
    a(rule(:,1)==1&a(:,3)==0&a(:,4)==1,6)=1; %mets en 6eme colonne de a les strategies dark ou la lumiere est a gauche et le rat fait Correct
    % task rule left
    a(rule(:,1)==3&a(:,3)==1&a(:,4)==1,6)=1; %mets en 6eme colonne de a les strategies dark ou la lumiere est a droite et le rat fait Correct
    a(rule(:,1)==3&a(:,3)==0&a(:,4)==0,6)=1; %mets en 6eme colonne de a les strategies dark ou la lumiere est a gauche et le rat fait Error
    a(:,6)=0;

%on s'occupe maintenant de l'alternance qui ira en colonne 1 de b
for i=2:size(b,1),
    if b(i,3)==b(i-1,2),
        b(i,1)=1;
    end;
end;
sansHesit=b(:,5:-1:1); % on garde une copie des strategies sans modulation par l'hesitation
sansHesit(:,1)=b(:,2); % et dont les colonnes sont mises dans l'ordre :
sansHesit(:,4)=b(:,5); % right, light, left, dark, altern
% on commence maintenant a calculer les blocs de strategies
bloc(size(sansHesit,1),size(sansHesit,2))=0;
bloc(size(sansHesit,1),:)=b(size(sansHesit,1),:);
for i=(size(sansHesit,1)-1):-1:1,
    bloc(i,:)=sansHesit(i,:)*diag(sansHesit(i,:)+bloc(i+1,:));
end;
% on determine la strategie dominante (parfois il y en a 2 de meme
% importance)
ongoing1=0;
ongoing2=0;
for i=1:size(bloc,1),
    if (ongoing1 == 0),
        ongoing1=argmax(bloc(i,:))*(max(bloc(i,:))>=tailleFenetre);
        if (ongoing1>0),
            vecteur(1,:)=bloc(i,:);
            vecteur(1,ongoing1)=0;
            ongoing2=argmax(vecteur(1,:))*(max(vecteur(1,:))>=max(bloc(i,:)));
        else,
            ongoing2=0;
        end;
        % on enregistre les strategies dominantes
        strategie(i,1)=ongoing1;
        strategie(i,2)=ongoing2;
    else,
        %intermediaire=argmax(bloc(i,:))*(max(bloc(i,:))>=tailleFenetre);
        if ((max(bloc(i,:))>bloc(i,ongoing1))&(max(bloc(i,:))>=tailleFenetre))|(ongoing2>0),
            strategie(i,1)=ongoing1;
            if ongoing2>0,
                strategie(i,2)=ongoing2;
                if bloc(i,ongoing2)<=1,
                    ongoing2=0;
                end;
            else,
                ongoing2=argmax(bloc(i,:));
                strategie(i,2)=ongoing2;
            end;
        else,
            strategie(i,1)=ongoing1;
            strategie(i,2)=0;
        end;
        if bloc(i,ongoing1)<=1,
            ongoing1=ongoing2; % si y'avait pas de 2eme strat, ca met ongoing1 a zero
            ongoing2=0;
        end;
    end;
end;

b(a(:,5)==0,5)=5*b(a(:,5)==0,5);
b(a(:,5)==0,4)=3.9*b(a(:,5)==0,4); % pour ponderer les couleurs par l'hestitation du rat et donc l'interet de l'essai.
b(a(:,5)==0,3)=2.9*b(a(:,5)==0,3);
b(a(:,5)==0,2)=1.9*b(a(:,5)==0,2);
b(a(:,5)==0,1)=0.9*b(a(:,5)==0,1);
b(a(:,5)==1,1)=0.8*b(a(:,5)==1,1);
b(a(:,5)==2,1)=0.6*b(a(:,5)==2,1);
b(a(:,5)==3,1)=0.4*b(a(:,5)==3,1);
b(a(:,5)==4,1)=0.2*b(a(:,5)==4,1);
b(a(:,5)==5,1)=0.1*b(a(:,5)==5,1);
b(a(:,5)==1,2)=1.8*b(a(:,5)==1,2);
b(a(:,5)==2,2)=1.6*b(a(:,5)==2,2);
b(a(:,5)==3,2)=1.4*b(a(:,5)==3,2);
b(a(:,5)==4,2)=1.2*b(a(:,5)==4,2);
b(a(:,5)==5,2)=1.1*b(a(:,5)==5,2);
b(a(:,5)==1,3)=2.8*b(a(:,5)==1,3);
b(a(:,5)==2,3)=2.6*b(a(:,5)==2,3);
b(a(:,5)==3,3)=2.4*b(a(:,5)==3,3);
b(a(:,5)==4,3)=2.2*b(a(:,5)==4,3);
b(a(:,5)==5,3)=2.1*b(a(:,5)==5,3);
b(a(:,5)==1,4)=3.8*b(a(:,5)==1,4);
b(a(:,5)==2,4)=3.6*b(a(:,5)==2,4);
b(a(:,5)==3,4)=3.4*b(a(:,5)==3,4);
b(a(:,5)==4,4)=3.2*b(a(:,5)==4,4);
b(a(:,5)==5,4)=3.1*b(a(:,5)==5,4);
b(a(:,5)==1,5)=4.8*b(a(:,5)==1,5);
b(a(:,5)==2,5)=4.6*b(a(:,5)==2,5);
b(a(:,5)==3,5)=4.4*b(a(:,5)==3,5);
b(a(:,5)==4,5)=4.2*b(a(:,5)==4,5);
b(a(:,5)==5,5)=4.1*b(a(:,5)==5,5);

bfig=b(:,5:-1:1)';%j'inverse l'ordre des colonne pour que la premiere devienne la derniere, la seconde devienne la troiseme, la troisieme devienne la deuxi?me et la derni?re devienne la premi?re afin que chaque ligne soit en face de sa l?gende. Puis je transpose la matrice pour mettre les essais en ligne.
figure,imagesc(bfig);
title(name);
grid;
xlabel('Numero de l''essai'); 
text(10,5,'Strategie Alternance');text(10,4,'Strategie Right');text(10,3,'Strategie Left');text(10,2,'Strategie Light');text(10,1,'Strategie Dark');
j = jet(400);
NewColorMap(1,:) = [1 1 1];
NewColorMap(2:102,:) = j(150:-1:50,:);
NewColorMap(303:403,:)=j(300:400,:);
k = copper(100);
NewColorMap(103:202,:)=k(100:-1:1,:);
l = summer(100);
NewColorMap(203:302,:)=l(100:-1:1,:);
%colorbar;
colormap(NewColorMap);
%hold on;