classdef CelluleDeLieu < handle
    
    properties (SetAccess = private, GetAccess = public)
        nom;
        
        alpha;%importance de la position pour déterminer l'intensité de décharge
        beta;%importance du rythme thêta pour déterminer l'intensité de décharge
        W; %Matrice représentative de l'ellipse du champ de lieu (écarts types sur la diagonale)
        mu; %vecteur position du centre du champ de lieu [x;y]
        phiMax; %phase de décharge au centre du champ de lieu
        
        Wi; %inverse de W, calculé une seule fois pour optimiser le code
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
       
        %TODO à remettre à jour
        % Génère un état de décharge en fonction d'une position)
        % Renvoi l'état de décharge d'une ou plusieurs cellules de lieu
        % (Cette méthode peut êre appliquée à une liste de CL)
        %-------------------
        function decharges = genererDecharges(self, position)
            %pour calculer la probabilité de décharges des CL, on calcule la
            %les positions relatives de l'agent puis la distance à la CL
            n = size(self,2);
            positionsRelatives  = [self.position] - position(:, ones(n, 1)); %Le deuxième terme permet de recopier plusieurs fois position de manière rapide
            distancesAuCarre    = sum(positionsRelatives.^2,1);

            %decharges = exp(-1/2*distancesAuCarre./[self.rayon].^2) .* [self.freqMax];
            
            %bruit
            %bruit  = random('Normal', 0, [self.erreur]) .* [self.freqMax];
            %decharges = decharges+bruit;
            
            %si certaines valeurs sont devenues négatives, il faut les mettre à zéro
            %decharges(decharges < 0) = 0;
        end
        
        
        
        % Cette méthode calcul l'intensité du processus de Poisson associé aux décharges 
        % Elle est optimisée et utilisable pour une liste de CL mais n'est
        % valide que lorsque W est diagonale!
        function lambda = intensite(self, position)
            n = size(self,2);
            x = position(:, ones(n, 1)) - [self.mu];
            wi = [self.Wi];
            wi = wi(wi>0); %Attention, valable uniquement parce que W est supposée diagonale
            
            lambda =  -0.5 * x(:).^2.*wi; %Attention, valable uniquement parce que W est supposée diagonale
            lambda = exp(lambda(2*(1:n))+lambda(2*(1:n)-1));
        end
            
        
        
        % Version non optimisée et utilisable uniquement pour une CL
        function lambda = intensiteO(self, position)
            x = position - self.mu;
            lambda =  exp( self.alpha - 0.5 * x'*self.Wi*x );
        end
    end
    
end