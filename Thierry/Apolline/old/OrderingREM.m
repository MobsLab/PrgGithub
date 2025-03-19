function [Ordered_REM] = REM()
%REM Order the Stim done during the REM regarding the period of the REM the
%Stim was done
%   Ordered_REM is a matrix containing in the first column the Start Time
%   of the Stim done between 0s and 10s of the REM, the second column is
%   the Stim done between 10s and 20s, the third column between 20s and 30s
%   and the fourth column over 30s

%% Loading and necessary variables

load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')

WkStart= Start(Wake)./(1e4); %matrix with the start times of all the Wake states
SWSStart = Start(SWSEpoch)./(1e4); %matrix with the start times of all the SWS states
REMStart = Start(REMEpoch)./(1e4); %matrix with the start times of all the REM states

%Calculation of the start time of all the stimulations and their frequency
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
Nb_Stim = length(Start(TTLEpoch_merged));
Freq_Stim = zeros(Nb_Stim,1);
Time_Stim = zeros(Nb_Stim,1); %matrix with all the start times of the stimulations

for k = 1:Nb_Stim
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) =round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)))./(1e4);
end


%% Calculation of the previous Wake, SWS and REM transitions

%%Loop to calculate the previous wake transition after a stimulation
PreviousWakeTrans = zeros(Nb_Stim,1);

for k=1:Nb_Stim
    CandidatePreviousWakeTrans = Time_Stim(k)-WkStart;
    
    if CandidatePreviousWakeTrans(1) < 0
        PreviousWakeTrans(k) = NaN;
    else
        PreviousWakeTrans(k) = min(CandidatePreviousWakeTrans(CandidatePreviousWakeTrans>=0));
    end
    
end

%%Loop to calculate the previous SWS transition after a stimulation
PreviousSWSTrans = zeros(Nb_Stim,1);

for k=1:Nb_Stim
    CandidatePreviousSWSTrans = Time_Stim(k)-SWSStart;
    
    if CandidatePreviousSWSTrans(1) < 0
        PreviousSWSTrans(k) = NaN;
    else
        PreviousSWSTrans(k) = min(CandidatePreviousSWSTrans(CandidatePreviousSWSTrans>=0));
    end
    
end

%%Loop to calculate the previous REM transition after a stimulation
PreviousREMTrans = zeros(Nb_Stim,1);

for k=1:Nb_Stim
    CandidatePreviousREMTrans = Time_Stim(k)-REMStart;
    
    if CandidatePreviousREMTrans(1) < 0
        PreviousREMTrans(k) = NaN;
    else
        PreviousREMTrans(k) = min(CandidatePreviousREMTrans(CandidatePreviousREMTrans>=0));
    end
    
end

%% Determination of the previous transition and so the state at the beginning of the Stim 

Ordered_States = NaN (Nb_Stim,9);

Nb_Stim_Wake = 0;
Nb_Stim_SWS = 0;
Nb_Stim_REM = 0;

for k3=1:Nb_Stim
    if min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3)])==PreviousWakeTrans(k3)
        Nb_Stim_Wake = Nb_Stim_Wake +1;
        Ordered_States(Nb_Stim_Wake,1) = k3;
        Ordered_States(Nb_Stim_Wake,2) = PreviousWakeTrans(k3);
        Ordered_States(Nb_Stim_Wake,3) = Time_Stim(k3);
    elseif min([PreviousWakeTrans(k3),PreviousSWSTrans(k3),PreviousREMTrans(k3)])==PreviousSWSTrans(k3)
        Nb_Stim_SWS = Nb_Stim_SWS +1;
        Ordered_States(Nb_Stim_SWS,4) = k3;
        Ordered_States(Nb_Stim_SWS,5) = PreviousSWSTrans(k3);
        Ordered_States(Nb_Stim_SWS,6) = Time_Stim(k3);
    else
        Nb_Stim_REM = Nb_Stim_REM +1;
        Ordered_States(Nb_Stim_REM,7) = k3;
        Ordered_States(Nb_Stim_REM,8) = PreviousREMTrans(k3);
        Ordered_States(Nb_Stim_REM,9) = Time_Stim(k3);
    end
    
end

% Ordered_States = Ordered_States(1:max([Nb_Stim_Wake, Nb_Stim_SWS, Nb_Stim_REM]),:);

%% Classification of the REM Stim regarding the period of the REM when the Stim begins

Ordered_REM_bis = NaN(Nb_Stim_REM,16);

Nb_Stim_REM_0 = 0;
Nb_Stim_REM_10= 0;
Nb_Stim_REM_20 = 0;
Nb_Stim_REM_30 = 0;

[ Nb, States, Latence, Result] = LatenceTransition();

for k = 1:Nb_Stim_REM
    if Ordered_States(k,8) <= 10
        Nb_Stim_REM_0 = Nb_Stim_REM_0 +1;
        Ordered_REM_bis(Nb_Stim_REM_0,1) = Ordered_States(k,7);
        Ordered_REM_bis(Nb_Stim_REM_0,2) = Ordered_States(k,9);
        Ordered_REM_bis(Nb_Stim_REM_0,3) = Ordered_States(k,8);
        Ordered_REM_bis(Nb_Stim_REM_0,4) = Result(Ordered_States(k,7),4);
    elseif Ordered_States(k,8) <= 20
        Nb_Stim_REM_10 = Nb_Stim_REM_10 +1;
        Ordered_REM_bis(Nb_Stim_REM_10,5) = Ordered_States(k,7);
        Ordered_REM_bis(Nb_Stim_REM_10,6) = Ordered_States(k,9);
        Ordered_REM_bis(Nb_Stim_REM_10,7) = Ordered_States(k,8);
        Ordered_REM_bis(Nb_Stim_REM_10,8) = Result(Ordered_States(k,7),4);
    elseif Ordered_States(k,8) <= 30
        Nb_Stim_REM_20 = Nb_Stim_REM_20 +1;
        Ordered_REM_bis(Nb_Stim_REM_20,9) = Ordered_States(k,7);
        Ordered_REM_bis(Nb_Stim_REM_20,10) = Ordered_States(k,9);
        Ordered_REM_bis(Nb_Stim_REM_20,11) = Ordered_States(k,8);
        Ordered_REM_bis(Nb_Stim_REM_20,12) = Result(Ordered_States(k,7),4);
    else 
        Nb_Stim_REM_30 = Nb_Stim_REM_30 +1;
        Ordered_REM_bis(Nb_Stim_REM_30,13) = Ordered_States(k,7);
        Ordered_REM_bis(Nb_Stim_REM_30,14) = Ordered_States(k,9);
        Ordered_REM_bis(Nb_Stim_REM_30,15) = Ordered_States(k,8);
        Ordered_REM_bis(Nb_Stim_REM_30,16) = Result(Ordered_States(k,7),4);
    end
end

% Ordered_REM = Ordered_REM(1:max([Nb_Stim_REM_0, Nb_Stim_REM_10, Nb_Stim_REM_20, Nb_Stim_REM_30]),:);
Ordered_REM = NaN(max([Nb_Stim_REM_0, Nb_Stim_REM_10, Nb_Stim_REM_20, Nb_Stim_REM_30]),16);
for i = 1:max([Nb_Stim_REM_0, Nb_Stim_REM_10, Nb_Stim_REM_20, Nb_Stim_REM_30])
    for k = 1:16
        Ordered_REM(i,k) = Ordered_REM_bis(i,k);
    end
end









end

