%%%Pour l'HPC (à changer si le load est différent)
load('SleepScoring_OBGamma.mat')
load('dHPC_sup_Low_Spectrum')
SpectroH=Spectro
load('LFPData/LFP5')
[EEGf]=FilterLFP(LFP,[50 300])
LFPemg=LFP
load('LFPData/DigInfo2.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end
events=Start(TTLEpoch_merged)/1E4;
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),REMEpoch),500,300);
%%AverageSpectre Stim SWS 
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
%%AverageSpectre Stim Wake
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),Wake),500,300);
hold on


EVENTS=(Start(and(TTLEpoch_merged,REMEpoch)))/1E4

[M,T] = PlotRipRaw(LFPemg, events, 40000, 0, 1);

[M,T] = PlotRipRaw(EEGf, EVENTS, 40000, 0, 1);