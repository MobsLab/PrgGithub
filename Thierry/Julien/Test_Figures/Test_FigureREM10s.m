%% Load et variables nécessaires

load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
load('VLPO_Low_Spectrum.mat')
WkStart= Start(Wake);
SlpStart = Start(Sleep);
SWSStart=Start(SWSEpoch);
REMStart=Start(REMEpoch);
Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end

REMStart2=Start(REMEpoch)/1E4;
events=Start(TTLEpoch_merged)/1E4;
%Test=Restrict(ts(events*1E4),REMEpoch)
%StREMavecStim=Start(and(TTLEpoch_merged,REMEpoch))
StStimdansREM=Restrict(ts(events*1E4),REMEpoch)
StREMavecStartStim=Restrict(ts(REMStart2*1E4),TTLEpoch_merged)
%M=Range(StStimdansREM)
%L=Range(StREMavecStartStim)

%%Boucle pour avoir les stim ayant lieu dans les 10 premieres secondes REM
for k=1:length(StStimdansREM)
    CandidateREM10s = StStimdansREM(k)-StREMavecStartStim;
     if CandidateREM10s<10.1
         StimREM10s(k)=Time_Stim(k)
     else
         StimREM10s(k)=0
     end
end
%%Matrice des Stim REM dans les 10 premieres secondes
StimREM10s(StimREM10s<0.1)=[]