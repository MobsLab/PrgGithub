%% Load et variables nécessaires

load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
WkStart= Start(Wake);
SlpStart = Start(Sleep);
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
Nb_Stim = length(Start(TTLEpoch_merged));
Freq_Stim = zeros(1,Nb_Stim);
Time_Stim = zeros(1,Nb_Stim);

for k = 1:Nb_Stim
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end

%%Boucle pour avoir la prochaine transition to Wake
LatenceWake = zeros(1,Nb_Stim);
for k=1:Nb_Stim
    CandidateTransitionsToWake = WkStart-Time_Stim(k);
    CandidateTransitionsToWake(CandidateTransitionsToWake<0)=[];
    LatenceWake(k) = min(CandidateTransitionsToWake);
    
end

%%Boucle pour avoir la prochaine transition to Sleep
LatenceSleep = zeros(1,Nb_Stim);
for k2=1:length(Time_Stim)
    CandidateTransitionsToSleep = SlpStart-Time_Stim(k2);
    CandidateTransitionsToSleep(CandidateTransitionsToSleep<0)=[];
    LatenceSleep(k2) = min(CandidateTransitionsToSleep);
    
end

%% Répartition des temps de latence Wake ou Sleep suivant l'état de départ (wake ou sleep)
for k3=1:Nb_Stim
        if LatenceWake(k3)<LatenceSleep(k3)
            LatenceSleep(k3) = 0;
        else 
            LatenceWake(k3) = 0;
            
        end
end
%%Temps de latence Wake et sleep dans 2 matrices 
LatenceWake(LatenceWake==0)=[];
LatenceSleep(LatenceSleep==0)=[];