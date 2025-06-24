function fenetre = afficherPosition(CL, decharges, positions, positionsE)
    % Affiche dans le plan:
    %       - la position de l'agent
    %       - sa position estim�e (�ventuellement plusieurs estimateurs)
    %       - la position des CL
    %       - les CL qui d�chargent 
    %
    % Utilisation :
    % afficherPosition(CL, decharges, positions, positionsE)
    %
    % - Pour un sc�nario avec n CL et p positions successives:
    %
    % CL         : liste d'objets CelluleDeLieu
    % decharges  : matrice n x p donnant les frequences des PA
    % positions  : matrice p x 2 
    % positionsE : matrice p x (nbrE*2) (positions estim�es - nbrE est le nombre d'estimateurs utilis�s)
    
    %initialisation de la fen�tre:
    fenetre = figure(1001);
    set(fenetre,'Name','Position et estimation','NumberTitle','off');
    clf;
    hold all;
    axis square;
    
    %la variable d�charges contient tout l'historique: on r�cup�re les
    %derni�res pour l'affichage (sous forme de vecteur ligne):
    %dernieresDecharges = decharges(:,end)';
    
    %fr�quence de d�charge normalis�e (fraction de la freq max)
    %activite = dernieresDecharges ./ [CL.freqMax];
    
    %coordonn�es des centres des domaines des CL
    %positionsCL = [CL.position];
    
    %CL
    %scatter(positionsCL(1,:), positionsCL(2,:) ,16, activite, 'filled');
    load('CL-colormap','mycmap')
    colormap(mycmap)
                
    %scatter3(positionsCL(1,:), positionsCL(2,:), activite, 16, activite, 'filled');
    
    plot(positions(:,1),  positions(:,2),  '+:black');
    
    plot(positionsE(1,:), positionsE(2,:), '+-');
    %plot(positionsE(3,:), positionsE(4,:), '+-');
    %plot(positionsE(5,:), positionsE(6,:), '+-');
    %plot(positionsE(7,:), positionsE(8,:), '+-');
    
    legend('CL', 'Position r�elle', 'Estimation');
    
end