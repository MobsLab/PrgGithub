function err = estimerPosition(agent, spikes, positions, freqEch)
%err = estimerPosition(agent, spikes, positions, freqEch)
    global AFFICHER_DETAIL_ESTIMATION;      AFFICHER_DETAIL_ESTIMATION = 0;
    
    %%%
    %
    % Constantes
    %
    %%%
    pasAffichage = 10;
    iterations = 0; %Permet de terminer avant le traitement de tous les spikes s'ils sont trop nombreux mettre à 0 pour ne pas limiter
    if(nargin < 4)
        freqEch = 30;
    end

    
    
    clc;
    
    
    nCL = size(spikes,2);
    nPositions = size(positions,1);
    
    %calul du nombre de spikes:
    nSpikes = zeros(1,nCL);
    for i=1:nCL
        nSpikes(i) = size(spikes{i},1);
    end
    if (iterations == 0 || iteration > sum(nSpikes))
        iterations = sum(nSpikes);
    end
    disp(['Au total, ' num2str(sum(nSpikes)) ' spikes pour ' num2str(nCL) ' CL.']);
    disp([' - min : ' num2str(min(nSpikes)) ]);
    disp([' - max : ' num2str(max(nSpikes)) ]);
    disp(['Analyse de ' num2str(iterations) ' spikes :']);
    disp(' ');
    
    
    e = Estimateur(agent, freqEch);
    
    derniersIndices = zeros(1, nCL); %indices des derniers spikes des différentes cellules. Important pour accélérer la recherche du spike suivant

    figure(10);
    clf;
    hold on;
    
    %axis([-5 280 -5 230]);
    axis([-5 180 -5 130]);
%     axis=([-5 max(positions(:,1))+20 -5 max(positions(:,2))+20]);
    
    zoneConfiance    = plot(0);
    dernierePosition = plot(0); 
    
    
    
    %préallocation des 
    positionsR = zeros(iterations, 2);
    positionsE = zeros(iterations, 2);
    init=0;
    save PosPrediced init
        
    tic;
    for i=1:iterations % une itération par spike (il y aura peut être un problème si des spikes sont simultanés)
        
        [id,t,derniersIndices] = spikeSuivant(spikes, derniersIndices);
        numPosition = 1+floor(t*freqEch);
        
        if(id==0 || numPosition > nPositions) %la fin de l'enregistrement a été atteinte
            break;
        end
        
        %il n'y a qu'une décharge
        decharges = zeros(nCL,1);
        decharges(id) = 1;
        
        [pE W] = e.estimerPosition(t, decharges);
        
        positionsE(i,:) = pE';
        positionsR(i,:) = positions(numPosition,:);
        
        init=i;
        posE=positionsE(1:i,:);
        posR=positionsR(1:i,:);        
        save PosPrediced -Append posE posR init
        
        if(~mod(i,pasAffichage)) %Affichage périodiquement
            debutSerie = max(1,i-pasAffichage);
            %position réelle
            plot(positionsR(debutSerie:i,1), positionsR(debutSerie:i,2), '-g');
            delete(dernierePosition);
            dernierePosition = scatter(positionsR(i,1), positionsR(i,2), 35, 'or','filled');
            
            %position estimée
            plot(positionsE(debutSerie:i,1), positionsE(debutSerie:i,2), '-');
            delete(zoneConfiance);
            zoneConfiance = plterrel(pE(1), pE(2), 500*W);
            
            %cellules de lieu
            agent.afficherCL(1);
            mu = agent.CL(id).mu;
            scatter(mu(1),mu(2),25,'ok','filled');%dernière cellule de lieu
            
            if(i==pasAffichage) %on n'affiche la légende qu'une fois
                legend('Position réelle', 'Dernière position réelle', 'Position estimée', 'Zone de confiance', 'CL inactives', 'CL actives');
            end
            disp([num2str(i) ' spikes (t = ' num2str(t) 's).']);
            pause (0.5);%permet de donner la main à l'affichage
        end;
    end
    toc
    err = positionsE-positionsR;
        
end

