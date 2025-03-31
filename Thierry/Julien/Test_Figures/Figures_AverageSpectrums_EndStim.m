function Figures_AverageSpectrums_EndStim
clear all
pathname='Figures'
pathname2='Figures/Average_Spectrums'
mkdir Figures
mkdir(fullfile(pathname,'Average_Spectrums'))


load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


events=End(TTLEpoch_merged)/1E4;
EndStim_dansREM=length(Range(Restrict(ts(events*1E4),REMEpoch)))

%%%Pour le VLPO
load('VLPO_Low_Spectrum')
SpectroV=Spectro
%%AveargeSpectre Stim REM (début stim en 0)
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('VLPO REM')
savefig(fullfile(pathname2,'VLPO_REM_EndStim'))
%%AverageSpectre Stim SWS 
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('VLPO SWS_EndStim')
savefig(fullfile(pathname2,'VLPO_SWS_EndStim'))
%%AverageSpectre Stim Wake
[MV,SV,tV]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),Wake),500,300);
title('VLPO Wake_EndStim')
savefig(fullfile(pathname2,'VLPO_Wake_EndStim'))

%%%Pour le bulbe
load('Bulb_deep_Low_Spectrum.mat')
SpectroBl=Spectro;
%%AveargeSpectre Stim REM 
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('Bulb REM_EndStim')
savefig(fullfile(pathname2,'Bulb_REM_EndStim'))
%%AverageSpectre Stim SWS 
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('Bulb SWS_EndStim')
savefig(fullfile(pathname2,'Bulb_SWS_EndStim'))
%%AverageSpectre Stim Wake
[Mbl,Sbl,tbl]=AverageSpectrogram(tsd(SpectroBl{2}*1E4,10*log10(SpectroBl{1})),SpectroBl{3},Restrict(ts(events*1E4),Wake),500,300);
title('Bulb Wake_EndStim')
savefig(fullfile(pathname2,'Bulb_Wake_EndStim'))

%%%Pour le PFc
load('PFCx_deep_Low_Spectrum.mat')
SpectroP=Spectro;
%%AveargeSpectre Stim REM (0)
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('PFC REM_EndStim')
savefig(fullfile(pathname2,'PFC_REM_EndStim'))
%%AverageSpectre Stim SWS 
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('PFC SWS_EndStim')
savefig(fullfile(pathname2,'PFC_SWS_EndStim'))
%%AverageSpectre Stim Wake
[MP,SP,tP]=AverageSpectrogram(tsd(SpectroP{2}*1E4,10*log10(SpectroP{1})),SpectroP{3},Restrict(ts(events*1E4),Wake),500,300);
title('PFC Wake_EndStim')
savefig(fullfile(pathname2,'PFC_Wake_EndStim'))

%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_sup_Low_Spectrum')
SpectroH=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM_EndStim')
savefig(fullfile(pathname2,'HPC_REM_EndStim'))
%%AverageSpectre Stim SWS 
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('HPC SWS_EndStim')
savefig(fullfile(pathname2,'HPC_SWS_EndStim'))
%%AverageSpectre Stim Wake
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),Wake),500,300);
title('HPC Wake_EndStim')
savefig(fullfile(pathname2,'HPC_Wake_EndStim'))

%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM_EndStim')
savefig(fullfile(pathname2,'HPC2_REM_EndStim'))
%%AverageSpectre Stim SWS 
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),SWSEpoch),500,300);
title('HPC SWS_EndStim')
savefig(fullfile(pathname2,'HPC2_SWS_EndStim'))
%%AverageSpectre Stim Wake
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),Wake),500,300);
title('HPC Wake_EndStim')
savefig(fullfile(pathname2,'HPC2_Wake_EndStim'))



Panel_4spectres_par_region_EndStim
end