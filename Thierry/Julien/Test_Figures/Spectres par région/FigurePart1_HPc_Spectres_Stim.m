function FigurePart1_HPc_Spectres_Stim
%%% Fonction pour faire la figure des spectres par état (REM,SWS, Wake)                 
%%% à utiliser avant la fonction Hpc_Spectres_Baseline pour avoir la figure



load('SleepScoring_OBGamma.mat')
%load le spectre à ploter 
load('dHPC_deep_Low_Spectrum.mat')

%%%%load des spectrums et variables (avoir fait les spectres avant)
%%%%à lancer en 2 temps: se mettre dans le dossier Stim opto
clear all
load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
load('dHPC_deep_Low_Spectrum.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end
sptsd = tsd(Spectro{2}*1e4, Spectro{1})
%%%%A utiliser 
load('dHPC_sup_Low_Spectrum')
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);

load('ExpeInfo')
figure

sptsd = tsd(Spectro{2}*1e4, Spectro{1})
events=Restrict(events,REMEpoch);
pREM = mean(Data(Restrict(sptsd,REMEpoch)))
freq = Spectro{3};
plot(freq,freq.*pREM,'g')
hold on

sptsd = tsd(Spectro{2}*1e4, Spectro{1})
pSWS = mean(Data(Restrict(sptsd,SWSEpoch)))
freq = Spectro{3};
plot(freq,freq.*pSWS,'r')
hold on

sptsd = tsd(Spectro{2}*1e4, Spectro{1})
pWake = mean(Data(Restrict(sptsd,Wake)))
freq = Spectro{3};
plot(freq,freq.*pWake,'b')

hold on
end