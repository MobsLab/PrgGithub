classdef Estimateur < handle
%ESTIMATEUR     Permet de d�terminer la position d'un agent en fonction de mesures d'activit� de neurones
%
% Propri�t�s publiques : 
% --------------------
%
% M�thodes publiques : 
% --------------------
%


properties
    agent;
    freqEch; %fr�quence d'�chantillonage

    % Param�tres (A estimer)
    covMarcheAlea = 2*diag([1,1]);%Covariance pour la marche al�atoire gaussienne (Wx)

    % Variables de travail (utilis�e pour l'estimation de la position en fonction de l'�tat pr�c�dent)
    dernierInstant = 0; % instant du dernier pas de temps
    derniereVariance = eye(2); %vecteur 2*1
    dernierePosition = [10;40];
end








methods
    % Constructeur
    % ------------
    function self = Estimateur(agent, freqEch)
        self.agent = agent;
        self.freqEch = freqEch;
    end




    % Cestte m�thode revoie une estimation de la position de l'agent en
    % fonction des d�charges de CL et de l'instant des d�charges
    % NB, l'estimation de l'erreur n'est pas renvoy�e
    function [Xpost Wpost] = estimerPosition(self, t, decharges)
        global AFFICHER_DETAIL_ESTIMATION;

        if AFFICHER_DETAIL_ESTIMATION
            disp(['Derni�re position : ' mat2str(self.dernierePosition,4)]);
            disp(['Derni�re variance : ' mat2str(self.derniereVariance,4)]);
        end;

        deltaT = t - self.dernierInstant; %dur�e depuis la derni�re mesure

        Xprior = self.dernierePosition; %Equation 10, estimation a priori de la position
        Wprior = self.covMarcheAlea * deltaT + self.derniereVariance; % Equation 11, variance a priori


        %Calculs interm�diaiares pour les �quations 12 et 13
        A = 0; %premi�re somme de l'�quation 12 et de l'�quation 13 (matrice 2x2)
        B = 0; %deuxi�me somme de l'�quation 12 (vecteur 2x1)
        C = 0; %deuxi�me somme de l'�quation 13 (matrice 2x2)
        lambda = self.agent.CL.intensite(Xprior); %vecteur
        ac  = decharges - lambda; %Equation 14
        
        for i = 1:size(decharges,1)
            mu = self.agent.CL(i).mu;
            wi = self.agent.CL(i).Wi;
            A  = A + ac(i) * wi;
            B  = B + ac(i) * wi * mu;
            C  = C + lambda(i) * ((Xprior-mu)*(Xprior-mu)') * wi.^2; %Attention, simplification car wi est diagonale!
            %if AFFICHER_DETAIL_ESTIMATION, disp([' LogIntensit� associ�e au processus de d�charge de la cellule ' num2str(i) ' : ' num2str(log(cl.intensite(Xprior)),2)]); end;
        end
        invWprior = inv(Wprior);
        
        Xpost = (invWprior + A) \ (invWprior*Xprior + B); %Equation 12
        Wpost = inv(invWprior + A + C); %Equation 13

        if AFFICHER_DETAIL_ESTIMATION
            disp(['Estimation de position a priori : ' mat2str(Xprior,2)]);
            disp(['Variance a priori : ' mat2str(Wprior,2)]);
            disp(['==Estimation de position : ' mat2str(Xpost,2) '==']);
            disp(['Estimation de variance : ' mat2str(Wpost,2)]); 
        end;
        
        n=norm(Xpost-Xprior);
        if n>12
            Xpost = Xprior+12/n*(Xpost-Xprior);
        end
        self.dernierePosition = Xpost;
        self.derniereVariance = Wpost;
        self.dernierInstant = t;
    end



end

    
end

