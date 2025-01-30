function agent = entrainerNouvelAgent(spikes, positions, freqEch)

%%%
%
% Paramètres de contrôle de l'affichage
%
%%%
global AFFICHER_CHRONO;                 AFFICHER_CHRONO = 1;
global AFFICHER_DETAIL_ESTIMATION;      AFFICHER_DETAIL_ESTIMATION = 1;

%%%
%
% Constantes
%
%%%
seuilOccupation = 10; % nombre de passages dans une zone en dessous duquel elle ne sera pas prise en compte
seuilFrequence  = .25; %pourcentage du temps passé dans une zone et pour laquelle la CL ne déchargait pas au-dessous duquel les décharges seront ignorées 
pasArene        = [270 220]; %nombre de zones en x et y pour la discrétisation de l'arène
if (nargin < 3)
    freqEch     = 30; %Fréquence d'échantillonage des données, en Hz
end;
%Autres paramètres cachés : étendu du flou dans la fonction champ de lieu



clc;

agent = Agent();

nCL = size(spikes,2); %nombre de CL
disp([num2str(nCL) ' cellules de lieu.']);

disp(['Durée de l''expérience : ' num2str(size(positions,1)/freqEch,4) 's']); 

bornesArene = [min(positions)' max(positions)'];
disp(['Bornes de la zone d''étude (en x puis en y) : ' mat2str(bornesArene,3)]); 

disp('--------------');
disp('Création de la carte d''occupation.');
cO = carteOccupation(positions, pasArene);

%figCO = figure(1001);
%set(figCO,'Name','Carte d''occupation','NumberTitle','off');
%image(cO');%pause;
%axis off;




disp('Enregistrement des cellules de lieu.');

largeur = 1+floor(sqrt(nCL)); %Nombre de figures sur une ligne
figCL = figure(1002);
clf;set(figCL,'Name','Carte des décharges','NumberTitle','off');
figCL = figure(1004);
clf;set(figCL,'Name', ['Champs de lieu de avec seuilOccupation = ' num2str(seuilOccupation) ' et seuilFrequence =' num2str(seuilFrequence)],'NumberTitle','off');

for i=1:nCL
    disp(['== Cellule ' num2str(i) ' ==']);

    %Carte des spikes:
    cS = carteSpikes(spikes{i}, positions, pasArene, bornesArene, freqEch);

    figure(1002);
    subaxis(largeur, largeur, i, 'Spacing', 0, 'Padding', 0, 'Margin', 0);
    axis off;
    hold on;
    image(65/max(cS(:))*cS'); %Le 65 ne sert que comme facteur d'échelle pour les couleurs

    %champs de lieu
    chL     = champDeLieu(cO, cS, seuilOccupation, seuilFrequence);
    [mu, W] = gaussienne(chL);

    figure(1004);
    subaxis(largeur, largeur, i, 'Spacing', 0, 'Padding', 0, 'Margin', 0);
    axis off;
    hold on;
    image(65/max(chL(:))*chL'); %Le 65 ne sert que comme facteur d'échelle pour les couleurs
    if(~isnan(mu(1)))
        plterrel(mu(2), mu(1), diag([W(4),W(1)]), 1, '-g');%il faut donner y puis x pour passer de la notation matricielle à géométrique
    end
    nSpikes = size(spikes{i},1);
    duree   = freqEch*size(positions,1);
    alpha   = log(nSpikes / duree);
    
    
    % Les valeurs de mu et W ont été calculées avec les coordonnées de
    % la matrice, il est nécessaire de les recalculer en unités SI.

    %facteurs d'échelles (vecteur colonne pour x et y)
    f = (bornesArene(:,2) - bornesArene(:,1)) ./ pasArene';
    muC = bornesArene(:,1) + [mu(2); mu(1)].*f;
    WC  = W .* diag(f.^2);
    
    
    
    disp(['Centre de du champ de lieu', mat2str(muC,3)]);
    disp(['Ecarts types en x et y: [' num2str(sqrt(WC(1)),3) ' ' num2str(sqrt(WC(4)),3) ']']);

    agent.ajouterCL(CelluleDeLieu(muC,WC, num2str(i),alpha));
end
    
end