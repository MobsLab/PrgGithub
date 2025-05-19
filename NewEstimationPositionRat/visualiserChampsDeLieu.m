function visualiserChampsDeLieu(spikes, positions)
% Cette fonction n'est pas utilisée dans la modélisation, elle permet juste
% de visualiser rapidement les données
global AFFICHER_CHRONO;                 AFFICHER_CHRONO = 0;
global AFFICHER_DETAIL_ESTIMATION;      AFFICHER_DETAIL_ESTIMATION = 0;

seuilOccupation = 5;
seuilFrequence  = 0;
pasArene        = [200 200];

nCL = size(spikes,2); %nombre de CL
bornesArene = [min(positions)' max(positions)'];

cO = carteOccupation(positions, pasArene);
figCO = figure(3);
set(figCO,'Name','Carte d''occupation','NumberTitle','off');
axis off;
image(cO'),


figCL = figure(1);
clf;set(figCL,'Name','Carte des décharges','NumberTitle','off');
figCL = figure(2);
clf;set(figCL,'Name', 'Champs de lieu','NumberTitle','off');

for i=1:nCL
    %Carte des spikes:
    cS = carteSpikes(spikes{i}, positions, pasArene, bornesArene);

    figCL = figure(1);
    clf;set(figCL,'Name',['Décharges de la cellule ' num2str(i)]);
    axis off;
    image(cS'); %Le 65 ne sert que comme facteur d'échelle pour les couleurs
    
    %champs de lieu
    chL     = champDeLieu(cO, cS, seuilOccupation, seuilFrequence);
    [mu, W] = gaussienne(chL);

    
    figCL = figure(2);
    clf;set(figCL,'Name', ['Champs de lieu de la cellule ' num2str(i)]);
    axis off;
    hold on;
    image(65/max(chL(:))*chL'); %Le 65 ne sert que comme facteur d'échelle pour les couleurs
    if(~isnan(mu(1)))
        plterrel(mu(2), mu(1), diag([W(4),W(1)]), 1, '-g');%il faut donner y puis x pour passer de la notation matricielle à géométrique
    end
    
    pause;
end
    
end