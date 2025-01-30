classdef Agent < handle
% AGENT     Modélise un agent possédant des cellules de lieu et capable de se déplacer.
%           Cette classe peut être utilisée soit pour simuler un déplacement et des
%           décharges soit pour prendre en charge des données mesurées de position et de décharge.
%
%
% Propriétés publiques : 
% --------------------
% - position    : position courante (vecteur 2x1)
% - CL          : Liste des Cellules de Lieu
% - decharges   : l'état de décharge des CL (vecteur nCL x 1 où nCL est le nombre de CL)
%
% Méthodes publiques : 
% --------------------
% - ajouterCL(CelluleDeLieu) ajoute une cellule de lieu à l'agent (voir la documentation de la classe CelluleDeLieu)
%
% Méthodes utiles pour un comportement simulé uniquement :
% - avancer()           : simule un déplacement de l'agent à vitesse constante (pas de longueur unité dans le plan)
% - générer décharges() : simule des potentiels d'action en fonction de la position de l'agent et de ses cellules de lieu 

properties  (SetAccess = public, GetAccess = public)
    position;
    CL;
    decharges; %l'état de décharge des CL et l'historique associé est stocké dans cet objet

    hist_positions; %historique des positions (matrice . x .)
    hist_decharges; %historique des positions (matrice . x .)
end




methods
    %Constructeur
    function self = Agent()
        self.position = [0;0];%TODO: il faudra éviter de commencer à 0,0...
        self.hist_positions = self.position;
        self.CL = [];
    end

    function ajouterCL(self, cl)
        self.CL = [self.CL cl];
    end



    function avancer(self)
        %génération d'un nouveau pas (trajectoire lissée)
        if size(self.hist_positions,2)>1
            deplacement = self.hist_positions(:,end)-self.hist_positions(:,end-1) + random('Normal',0 , 0.4, 2, 1);
            %normalisation (déplacement à vitesse constante)
            deplacement = deplacement/norm(deplacement);

            self.position = self.hist_positions(:,end) + deplacement;
        else
            self.position = random('Normal',0 , 0.5, 2, 1);
        end
        self.hist_positions = [self.hist_positions self.position];
    end



    
    
    function genererDecharges(self)
        self.decharges = self.CL.genererDecharges(self.position);
        self.hist_decharges = [self.hist_decharges self.decharges'];%dimensions à revoir...
    end

    
    
    
    
    function afficherCL(self, decalageNom)
        mu = [self.CL.mu];
        scatter(mu(1,:), mu(2,:), 25, 'o', 'filled','markerfacecolor',[.5 .5 .5]);
        if(nargin>1 && decalageNom)
            for i=1:size(self.CL,2)
                text(self.CL(i).mu(1) + decalageNom, self.CL(i).mu(2), self.CL(i).nom);
            end
        end
    end
end
    
end