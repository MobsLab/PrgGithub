%%load les fichiers nécessaires (DiGInfo2 est le la digitale du laser)
load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
load('ChannelsToAnalyse/VLPO.mat')

%Fait le spectre pour le VLPO
LowSpectrumSB([cd filesep],channel,'VLPO');
load('VLPO_Low_Spectrum.mat')

%%Définition des variables nécessaires pour les figures
Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


%% time to next transition
WkStart= Start(Wake);
SlpStart = Start(Sleep);
for k=1:length(Time_Stim)
    CandidateTransitions = WkStart-Time_Stim(k);
    CandidateTransitions(CandidateTransitions<0)=[];
    NextWakeTrans(k) = min(CandidateTransitions);
    
end

for k=1:length(Time_Stim)
    CandidateTransitions = SlpStart-Time_Stim(k);
    CandidateTransitions(CandidateTransitions<0)=[];
    NexSleepTrans(k) = min(CandidateTransitions);
    
end