classdef CelluleDeLieu < handle
    
    properties (SetAccess = private, GetAccess = public)
        nom;
        
        alpha;%importance de la position pour d�terminer l'intensit� de d�charge
        beta;%importance du rythme th�ta pour d�terminer l'intensit� de d�charge
        W; %Matrice repr�sentative de l'ellipse du champ de lieu (�carts types sur la diagonale)
        mu; %vecteur position du centre du champ de lieu [x;y]
        phiMax; %phase de d�charge au centre du champ de lieu
        
        Wi; %inverse de W, calcul� une seule fois pour optimiser le code
    end

    methods
    
        % Constructeurs
        % ------------
        function self = CelluleDeLieu(mu, W, nom, alpha, beta, phiMax)
            
            if (nargin < 2) W       = 20*eye(2); end;
            if (nargin < 3) nom     = '';        end;
            if (nargin < 4) alpha   = 1;         end;
            if (nargin < 5) beta    = 0;         end;
            if (nargin < 6) phiMax  = 0;         end;
            
            self.mu     = mu;
            self.W      = W;
            self.Wi     = inv(W);
            self.nom    = nom;
            self.alpha  = alpha;
            self.beta   = beta;
            self.phiMax = phiMax;
        end
       
        %TODO � remettre � jour
        % G�n�re un �tat de d�charge en fonction d'une position)
        % Renvoi l'�tat de d�charge d'une ou plusieurs cellules de lieu
        % (Cette m�thode peut �re appliqu�e � une liste de CL)
        %-------------------
        function decharges = genererDecharges(self, position)
            %pour calculer la probabilit� de d�charges des CL, on calcule la
            %les positions relatives de l'agent puis la distance � la CL
            n = size(self,2);
            positionsRelatives  = [self.position] - position(:, ones(n, 1)); %Le deuxi�me terme permet de recopier plusieurs fois position de mani�re rapide
            distancesAuCarre    = sum(positionsRelatives.^2,1);

            %decharges = exp(-1/2*distancesAuCarre./[self.rayon].^2) .* [self.freqMax];
            
            %bruit
            %bruit  = random('Normal', 0, [self.erreur]) .* [self.freqMax];
            %decharges = decharges+bruit;
            
            %si certaines valeurs sont devenues n�gatives, il faut les mettre � z�ro
            %decharges(decharges < 0) = 0;
        end
        
        
        
        % Cette m�thode calcul l'intensit� du processus de Poisson associ� aux d�charges 
        % Elle est optimis�e et utilisable pour une liste de CL mais n'est
        % valide que lorsque W est diagonale!
        function lambda = intensite(self, position)
            n = size(self,2);
            x = position(:, ones(n, 1)) - [self.mu];
            wi = [self.Wi];
            wi = wi(wi>0); %Attention, valable uniquement parce que W est suppos�e diagonale
            
            lambda =  -0.5 * x(:).^2.*wi; %Attention, valable uniquement parce que W est suppos�e diagonale
            lambda = exp(lambda(2*(1:n))+lambda(2*(1:n)-1));
        end
            
        
        
        % Version non optimis�e et utilisable uniquement pour une CL
        function lambda = intensiteO(self, position)
            x = position - self.mu;
            lambda =  exp( self.alpha - 0.5 * x'*self.Wi*x );
        end
    end
    
end