%% Load et variables nécessaires

load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
load('VLPO_Low_Spectrum.mat')
WkStart= Start(Wake);
SlpStart = Start(Sleep);
Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end

%%Boucle pour avoir la prochaine transition to Wake
for k=1:length(Time_Stim)
    CandidateTransitionsToWake = WkStart-Time_Stim(k);
    CandidateTransitionsToWake(CandidateTransitionsToWake<0)=[];
    NextWakeTrans(k) = min(CandidateTransitionsToWake);
    
end

%%Boucle pour avoir la prochaine transition to Sleep
for k2=1:length(Time_Stim)
    CandidateTransitionsToSleep = SlpStart-Time_Stim(k2);
    CandidateTransitionsToSleep(CandidateTransitionsToSleep<0)=[];
    NextSleepTrans(k2) = min(CandidateTransitionsToSleep);
    
end

%% Répartition des temps de latence Wake ou Sleep suivant l'état de départ (wake ou sleep)
for k3=1:length(NextWakeTrans) 
        if NextWakeTrans(k3)<NextSleepTrans(k3)
             LatenceWake(k3)=NextWakeTrans(k3)
        else 
            LatenceSleep(k3)=NextSleepTrans(k3)
            
        end
end
%%Temps de latence Wake et sleep dans 2 matrices 
LatenceWake(LatenceWake=0)=[]
LatenceSleep(LatenceSleep=0)=[]