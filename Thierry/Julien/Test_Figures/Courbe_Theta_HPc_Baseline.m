function Courbe_Theta_HPc_Baseline
load('ExpeInfo')
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

load('dHPC_sup_Low_Spectrum')
events=Start(TTLEpoch_merged)/1E4;
events=ts(events*1e4);
events=Restrict(events,REMEpoch);
events = Range(events);
clear M S
for i=1:length(Spectro{3})
    for  k =1:length(events)
 
    [M(i,k,:),S(i,k,:),t]=mETAverage(events(k),Range(sptsd),Spectro{1}(:,i),500,300);
    end
end

%%PLot 2eme courbes
Data_Mat=squeeze(mean(M(find(Spectro{3}<9&Spectro{3}>6),:,:)));
hold on
shadedErrorBar(t,Data_Mat,{@mean,@stdError},'-r',1); 
hold on
title(['Theta HPC ',' ','M',num2str(ExpeInfo.nmouse)])
legend('Stim',' ',' ',' ','Baseline')
end