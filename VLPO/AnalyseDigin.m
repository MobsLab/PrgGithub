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


%%Voir les Stim (s'assurer de la conformité du Digin)
plot(Range(Restrict(DigTSD,TTLEpoch),'s'),Data(Restrict(DigTSD,TTLEpoch)),'r.')
plot(Range(Restrict(DigTSD,TTLEpoch_merged),'s'),Data(Restrict(DigTSD,TTLEpoch_merged)),'r.')
Start(TTLEpoch_merged)


%Nb de stim
Stim=size(Start(TTLEpoch_merged))
%Nb de stim pendant le REM
StimREM=size(Start(and(TTLEpoch_merged,REMEpoch)))
%Nb de stim pendant le SWS
StimSWS=size(Start(and(TTLEpoch_merged,SWSEpoch)))
%Nb de stim pendant Wake
StimWAKE=size(Start(and(TTLEpoch_merged,Wake)))
%Matrice contenant les 4 valeurs précédentes 
MStim=[Stim StimREM StimSWS StimWAKE]


%?
Start(and(TTLEpoch,LittleEpoch))


%% plot le spectre de 0 à 20Hz, les croix représentent les stim
Spectro
imagesc(Spectro{2},Spectro{3},log(Spectro{1}))
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
hold on
plot((Time_Stim)/1e4,Freq_Stim,'*')

%%Plot spectre 2-4-10Hz
for h = [2,4,10]
    LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
     LittleEpoch=LittleEpoch-TotalNoiseEpoch;
    plot(Spectro{3},log(nanmean(Data(Restrict(Sptsd,LittleEpoch))))), hold on
end

%%Plot spectre 20Hz
for h = [20]
    LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
    LittleEpoch=LittleEpoch-TotalNoiseEpoch;
    plot(Spectro{3},log(nanmean(Data(Restrict(Sptsd,LittleEpoch))))), hold on
end

