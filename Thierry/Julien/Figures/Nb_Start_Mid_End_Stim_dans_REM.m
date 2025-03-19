%%%%Fonction pour avoir une matrice avec les 3 valeurs : Nombre de Start
%%%%dans le REM, nombre de Stim à 30s dans le REM et nombre de fin de STIM
%%%%sdans le REM 
function Nb_Start_Mid_End_Stim_dans_REM
clear all
pathname='Figures'
pathname2='Figures/Average_Spectrums'

% Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
load('LFPData/DigInfo6.mat')
load('SleepScoring_OBGamma.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end




%%%REM
events=Start(TTLEpoch_merged)/1E4;
StartStim_dansREM=length(Range(Restrict(ts(events*1E4),REMEpoch)))

events=(End(TTLEpoch_merged)/1E4)+(Start(TTLEpoch_merged)/1E4)/2;
MidStimStim_dansREM=length(Range(Restrict(ts(events*1E4),REMEpoch)))

events=End(TTLEpoch_merged)/1E4;
EndStim_dansREM=length(Range(Restrict(ts(events*1E4),REMEpoch)))

%%SWS
events=Start(TTLEpoch_merged)/1E4;
StartStim_dansSWS=length(Range(Restrict(ts(events*1E4),SWSEpoch)))

events=(End(TTLEpoch_merged)/1E4)+(Start(TTLEpoch_merged)/1E4)/2;
MidStimStim_dansSWS=length(Range(Restrict(ts(events*1E4),SWSEpoch)))

events=End(TTLEpoch_merged)/1E4;
EndStim_dansSWS=length(Range(Restrict(ts(events*1E4),SWSEpoch)))

%%Wake
events=Start(TTLEpoch_merged)/1E4;
StartStim_dansWake=length(Range(Restrict(ts(events*1E4),Wake)))

events=(End(TTLEpoch_merged)/1E4)+(Start(TTLEpoch_merged)/1E4)/2;
MidStimStim_dansWake=length(Range(Restrict(ts(events*1E4),Wake)))

events=End(TTLEpoch_merged)/1E4;
EndStim_dansWake=length(Range(Restrict(ts(events*1E4),Wake)))


%%Save matrice
Start_Mid_End_Stim_dans_REM=[StartStim_dansREM MidStimStim_dansREM EndStim_dansREM]
save('Start_Mid_End_Stim_dans_REM.mat')


