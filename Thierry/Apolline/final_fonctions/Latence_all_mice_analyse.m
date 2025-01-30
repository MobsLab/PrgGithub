function [TransREMSWS] = Latence_all_mice_analyse(WkStart, SWSStart, REMStart, NoiseStart, Time_Stim)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%%
Nb_Stim = length(Time_Stim);
Result = zeros(Nb_Stim,5);

%% Calculation of the previous and next Wake, SWS and REM transitions

%%Loop to calculate the next wake transition after a stimulation
NextWakeTrans = NaN(Nb_Stim,1);
PreviousWakeTrans = NaN(Nb_Stim,1);

if isempty(WkStart) == 0

    for k=1:Nb_Stim
        CandidateNextWakeTrans = WkStart-Time_Stim(k);
        CandidatePreviousWakeTrans = Time_Stim(k)-WkStart;
    
        if CandidateNextWakeTrans(end) < 0
            NextWakeTrans(k) = NaN;
        else 
            NextWakeTrans(k) = min(CandidateNextWakeTrans(CandidateNextWakeTrans>0));
        end
    
        if CandidatePreviousWakeTrans(1) < 0
            PreviousWakeTrans(k) = NaN;
        else
            PreviousWakeTrans(k) = min(CandidatePreviousWakeTrans(CandidatePreviousWakeTrans>=0));
        end
    
    end
end

%%Loop to calculate the next SWS transition after a stimulation
NextSWSTrans = NaN(Nb_Stim,1);
PreviousSWSTrans = NaN(Nb_Stim,1);

if isempty(SWSStart) == 0

    for k=1:length(Time_Stim)
        CandidateNextSWSTrans = SWSStart-Time_Stim(k);
        CandidatePreviousSWSTrans = Time_Stim(k)-SWSStart;

        if CandidateNextSWSTrans(end) < 0
            NextSWSTrans(k) = NaN;
        else 
            NextSWSTrans(k) = min(CandidateNextSWSTrans(CandidateNextSWSTrans>0));
        end

        if CandidatePreviousSWSTrans(1) < 0
            PreviousSWSTrans(k) = NaN;
        else
            PreviousSWSTrans(k) = min(CandidatePreviousSWSTrans(CandidatePreviousSWSTrans>=0));
        end

    end
end

%%Loop to calculate the next REM transition after a stimulation
NextREMTrans = NaN(Nb_Stim,1);
PreviousREMTrans = NaN(Nb_Stim,1);

if isempty(REMStart) == 0

    for k=1:length(Time_Stim)
        CandidateNextREMTrans = REMStart-Time_Stim(k);
        CandidatePreviousREMTrans = Time_Stim(k)-REMStart;

        if CandidateNextREMTrans(end) < 0
            NextREMTrans(k) = NaN;
        else 
            NextREMTrans(k) = min(CandidateNextREMTrans(CandidateNextREMTrans>0));
        end

        if CandidatePreviousREMTrans(1) < 0
            PreviousREMTrans(k) = NaN;
        else
            PreviousREMTrans(k) = min(CandidatePreviousREMTrans(CandidatePreviousREMTrans>=0));
        end

    end
end

%%Loop to calculate the next Noise transition after a stimulation
NextNoiseTrans = NaN(Nb_Stim,1);
PreviousNoiseTrans = NaN(Nb_Stim,1);

if isempty(NoiseStart) == 0

    for k=1:Nb_Stim
        CandidateNextNoiseTrans = NoiseStart-Time_Stim(k);
        CandidatePreviousNoiseTrans = Time_Stim(k)-NoiseStart;

        if CandidateNextNoiseTrans(end) < 0
            NextNoiseTrans(k) = NaN;
        else 
            NextNoiseTrans(k) = min(CandidateNextNoiseTrans(CandidateNextNoiseTrans>0));
        end

        if CandidatePreviousNoiseTrans(1) < 0
            PreviousNoiseTrans(k) = NaN;
        else
            PreviousNoiseTrans(k) = min(CandidatePreviousNoiseTrans(CandidatePreviousNoiseTrans>=0));
        end

    end
end

%% Determination of the previous and next transition and the delay time

Nb_Trans_REM_SWS = 0;
Nb_Trans_REM_Wake = 0;
Nb_Trans_REM_Noise = 0;
Nb_Trans_SWS_REM = 0;
Nb_Trans_SWS_Wake = 0;
Nb_Trans_SWS_Noise = 0;
Nb_Stim_Wake = 0;
Nb_Stim_Noise = 0;
error = 0;


for k3=1:Nb_Stim
    Result(k3,1) = Time_Stim(k3);
    if min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousWakeTrans(k3)
        Result(k3,2) = 0;
        Result(k3,3) = PreviousWakeTrans(k3);
    elseif min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousSWSTrans(k3)
        Result(k3,2) = 1;
        Result(k3,3) = PreviousSWSTrans(k3);
    elseif min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3),PreviousNoiseTrans(k3)])==PreviousREMTrans(k3)
        Result(k3,2) = 2;
        Result(k3,3) = PreviousREMTrans(k3);
    else 
        Result(k3,2) = 3;
        Result(k3,3) = PreviousNoiseTrans(k3);
    end
    
    
    if min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextWakeTrans(k3)
        Result(k3,4) = 0;
        Result(k3,5) = NextWakeTrans(k3);
    elseif min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextSWSTrans(k3)
        Result(k3,4) = 1;
        Result(k3,5) = NextSWSTrans(k3);
    elseif min([NextWakeTrans(k3),NextSWSTrans(k3),NextREMTrans(k3), NextNoiseTrans(k3)])==NextREMTrans(k3)
        Result(k3,4) = 2;
        Result(k3,5) = NextREMTrans(k3);
    else
        Result(k3,4) = 3;
        Result(k3,5) = NextNoiseTrans(k3);
    end
end

%% ordered

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

