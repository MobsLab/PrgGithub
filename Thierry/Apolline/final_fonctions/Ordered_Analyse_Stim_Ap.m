function [TransREMSWS,TransSWSREM,TransSWSWake,TransSWSSWS,TransSWSNoise,TransREMWake,TransREMNoise,TransREMREM,TransWakeSWS,TransWakeREM,TransWakeNoise,TransWakeWake,TransNoiseSWS,TransNoiseREM, TransNoiseWake,TransNoiseNoise] = Ordered_Analyse_Stim_Ap(Result)
%ORDERED_ANALYSE_STIM_AP orders the Result matrix coming from the
%Analyse_Stim_Ap fonction to classify each kind of transition 
%
%   OUTPUT: 16 matrix corresponding to the 16 possible transitions of
%   states. In each matrix, each line corresponds to 1 stim and each column
%   corresponds to:
%       - column 1 : Starting Time of the stimulation (in s)
%       - column 2 : Time (in s) between the start of the state and the start of the stimulation
%       - column 3 : Time (in s) between the start of the stimulation and the start time of tne next state
%   Each matrix is sorted regarding the previous time (column 2)
%
%   INPUT: Result, the matrix created by the function Analyse_Stim_Ap

%% Initialisation

%   0 = 'Wake'
%   1 = 'SWS'
%   2 = 'REM'
%   3 = 'Noise'

Nb_Stim = length(Result);

TransREMSWS = [];
TransREMWake = [];
TransREMNoise = [];
TransREMREM = [];

TransSWSREM = [];
TransSWSWake = [];
TransSWSNoise = [];
TransSWSSWS = [];

TransWakeSWS = [];
TransWakeREM = [];
TransWakeNoise = [];
TransWakeWake = [];

TransNoiseSWS = [];
TransNoiseREM = [];
TransNoiseWake = [];
TransNoiseNoise = [];


%% Boucle pour trier les stim dans les differentes matrices de Transition

for k3=1:Nb_Stim

    if Result(k3,2) == 0
        
        if Result(k3,4) == 0
            TransWakeWake = sortrows([TransWakeWake ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        elseif Result(k3,4) == 1
            TransWakeSWS = sortrows([TransWakeSWS ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        elseif Result(k3,4) == 2
            TransWakeREM = sortrows([TransWakeREM ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        else
            TransWakeNoise = sortrows([TransWakeNoise ;Result(k3,1),Result(k3,3),Result(k3,5)],2);
        end
        
    elseif Result(k3,2) == 1
        
        if Result(k3,4) == 0
            TransSWSWake = sortrows([TransSWSWake ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        elseif Result(k3,4) == 1
            TransSWSSWS = sortrows([TransSWSSWS ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        elseif Result(k3,4) == 2
            TransSWSREM = sortrows([TransSWSREM ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        else
            TransSWSNoise = sortrows([TransSWSNoise ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        end
        
    elseif Result(k3,2) == 2
        
        if Result(k3,4) == 0
            TransREMWake = sortrows([TransREMWake ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        elseif Result(k3,4) == 1
            TransREMSWS = sortrows([TransREMSWS ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        elseif Result(k3,4) == 2
            TransREMREM = sortrows([TransREMREM ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        else
            TransREMNoise = sortrows([TransREMNoise ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        end
        
    else
        
        if Result(k3,4) == 0
            TransNoiseWake = sortrows([TransNoiseWake ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        elseif Result(k3,4) == 1
            TransNoiseSWS = sortrows([TransNoiseSWS ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        elseif Result(k3,4) == 2
            TransNoiseREM = sortrows([TransNoiseREM ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        else
            TransNoiseNoise = sortrows([TransNoiseNoise ; Result(k3,1),Result(k3,3),Result(k3,5)],2);
        end
        
    end
     
end


end

