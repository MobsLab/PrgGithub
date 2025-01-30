%%%%load des spectrums et variables (avoir fait les spectres avant)
clear all
%% attention 'DigInfo6.mat' pour EIB32-BCI et 'DigInfo2.mat' pour EIB16 noBCI
load('LFPData/DigInfo6.mat')
load('SleepScoring_OBGamma.mat')

TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


events=Start(TTLEpoch_merged)/1E4;
%%%%%%%%%

%%Pour checker combien de Stim par période
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

%%%Pour le VLPO
load('VLPO_Low_Spectrum')
SpectroV=Spectro
%%AveargeSpectre Stim REM (début stim en 0)
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('VLPO REM')
savefig('VLPO_REM')
%%AverageSpectre Stim SWS 
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('VLPO SWS')
savefig('VLPO_SWS')
%%AverageSpectre Stim Wake
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),Wake),500,300);
title('VLPO Wake')
savefig('VLPO_Wake')

%%%Pour le bulbe
load('Bulb_deep_Low_Spectrum.mat')
SpectroBl=Spectro;
%%AveargeSpectre Stim REM 
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('Bulb REM')
savefig('Bulb_REM')
%%AverageSpectre Stim SWS 
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('Bulb SWS')
savefig('Bulb_SWS')
%%AverageSpectre Stim Wake
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),Wake),500,300);
title('Bulb Wake')
savefig('Bulb_Wake')

%%%Pour le PFc
load('PFCx_deep_Low_Spectrum.mat')
SpectroP=Spectro;
%%AveargeSpectre Stim REM (0)
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('PFC REM')
savefig('PFC_REM')
%%AverageSpectre Stim SWS 
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('PFC SWS')
savefig('PFC_SWS')
%%AverageSpectre Stim Wake
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),Wake),500,300);
title('PFC Wake')
savefig('PFC_Wake')

%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_sup_Low_Spectrum')
SpectroH=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM')
savefig('HPC_REM')
%%AverageSpectre Stim SWS 
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('HPC SWS')
savefig('HPC_SWS')
%%AverageSpectre Stim Wake
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),Wake),500,300);
title('HPC Wake')
savefig('HPC_Wake')

%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM')
savefig('HPC2_REM')
%%AverageSpectre Stim SWS 
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('HPC SWS')
savefig('HPC2_SWS')
%%AverageSpectre Stim Wake
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),Wake),500,300);
title('HPC Wake')
savefig('HPC2_Wake')



