% To correct dig inputs
clear all
SetCurrentSession
load('makedataBulbeInputs.mat')
MakeData_Digin


%%
load('LFPData/DigInfo2.mat')
load('ChannelsToAnalyse/VLPO.mat')
LowSpectrumSB([cd filesep],channel,'VLPO');
load('SleepScoring_OBGamma.mat')
load('VLPO_Low_Spectrum.mat')

Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
    LittleEpoch = subset(TTLEpoch_merged,k);
    
    Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end

for h = [2,4,10]
    LittleEpoch = subset(TTLEpoch_merged,find(Freq_Stim == h));
     LittleEpoch=LittleEpoch-TotalNoiseEpoch;
    plot(Spectro{3},log(nanmean(Data(Restrict(Sptsd,LittleEpoch))))), hold on
end


