
load('LFPData/DigInfo4.mat')
load('SleepScoring_OBGamma.mat')
load('ChannelsToAnalyse/dHPC_sup.mat')

load('ChannelsToAnalyse/VLPO.mat')


load('dHPC_sup_Low_Spectrum')
load('H_Low_Spectrum.mat')
load('VLPO_Low_Spectrum.mat')

Sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))
sptsd = tsd(Spectro{2}*1e4,(Spectro{1}))


TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);

for k = 1:length(Start(TTLEpoch_merged))
    LittleEpoch = subset(TTLEpoch_merged,k);
    Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
    Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


events=Start(TTLEpoch_merged)/1E4;

SpectroV=Spectro;
% AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM')

SpectroH=Spectro
%%AveargeSpectre Stim Wake (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(events*1E4),Wake),500,300);
title('HPC Wake')

SpectroVLPO=Spectro
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroVLPO{2}*1E4,10*log10(SpectroVLPO{1})),SpectroVLPO{3},Restrict(ts(events*1E4),Wake),500,300);
title('VLPO Wake')


SpectroVLPO=Sp;
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(events*1E4),REMEpochWiNoise),500,300);
title('VLPO Wake 648')

[MH,SH,tH]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},Restrict(ts(Stim*1E4),REMEpochWiNoise),500,300);


[MH,SH,tH]=AverageSpectrogram(tsd(t*1E4,10*log10(Sp)),f,Restrict(ts(events*1E4),Wake),500,300);



figure, imagesc(t,f,10*log10(Sp')), axis xy %figure spectro quand le VLPO_Low.mat n'existe pas
[MH,SH,tH]=AverageSpectrogram(tsd(t*1E4,10*log10(Sp)),f,Restrict(ts(events*1E4),Wake),500,300);


%%%%%%%%%%%%%%%%%%%
figure, 
subplot(2,1,1), imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy
Spectro
imagesc(Spectro{2},Spectro{3},log(Spectro{1}))
imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
axis xy
hold on
plot((Time_Stim)/1e4,Freq_Stim,'*')
plot((Stim)/1e4,Freq_Stim,'*')

caxis([10 65])
colormap(jet)

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

