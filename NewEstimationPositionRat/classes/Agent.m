classdef Agent < handle
% AGENT     Mod�lise un agent poss�dant des cellules de lieu et capable de se d�placer.
%           Cette classe peut �tre utilis�e soit pour simuler un d�placement et des
%           d�charges soit pour prendre en charge des donn�es mesur�es de position et de d�charge.
%
%
% Propri�t�s publiques : 
% --------------------
% - position    : position courante (vecteur 2x1)
% - CL          : Liste des Cellules de Lieu
% - decharges   : l'�tat de d�charge des CL (vecteur nCL x 1 o� nCL est le nombre de CL)
%
% M�thodes publiques : 
% --------------------
% - ajouterCL(CelluleDeLieu) ajoute une cellule de lieu � l'agent (voir la documentation de la classe CelluleDeLieu)
%
% M�thodes utiles pour un comportement simul� uniquement :
% - avancer()           : simule un d�placement de l'agent � vitesse constante (pas de longueur unit� dans le plan)
% - g�n�rer d�charges() : simule des potentiels d'action en fonction de la position de l'agent et de ses cellules de lieu 

properties  (SetAccess = public, GetAccess = public)
    position;
    CL;
    decharges; %l'�tat de d�charge des CL et l'historique associ� est stock� dans cet objet

    hist_positions; %historique des positions (matrice . x .)
    hist_decharges; %historique des positions (matrice . x .)
end




methods
    %Constructeur
    function self = Agent()
        self.position = [0;0];%TODO: il faudra �viter de commencer � 0,0...
        self.hist_positions = self.position;
        self.CL = [];
    end

    function ajouterCL(self, cl)
        self.CL = [self.CL cl];
    end



    function avancer(self)
        %g�n�ration d'un nouveau pas (trajectoire liss�e)
        if size(self.hist_positions,2)>1
            deplacement = self.hist_positions(:,end)-self.hist_positions(:,end-1) + random('Normal',0 , 0.4, 2, 1);
            %normalisation (d�placement � vitesse constante)
            deplacement = deplacement/norm(deplacement);

            self.position = self.hist_positions(:,end) + deplacement;
        else
            self.position = random('Normal',0 , 0.5, 2, 1);
        end
        self.hist_positions = [self.hist_positions self.position];
    end



    
    
    function genererDecharges(self)
        self.decharges = self.CL.genererDecharges(self.position);
        self.hist_decharges = [self.hist_decharges self.decharges'];%dimensions � revoir...
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