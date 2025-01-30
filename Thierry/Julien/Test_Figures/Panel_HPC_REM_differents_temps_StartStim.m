%%%%Avoir la matrice ordered REM
%%%%Se mettre dans le dossier de la nuit voulue
%%%%Output: panel de 4figures: REM avec stim dans les 10s, 10-20s, 20-30s,30s+ 

function Panel_HPC_REM_differents_temps_StartStim
load('LFPData/DigInfo2.mat')
load('SleepScoring_OBGamma.mat')
TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
load('ExpeInfo')
pathname='Figures'
pathname2='Figures/Average_Spectrums'

for k = 1:length(Start(TTLEpoch_merged))
LittleEpoch = subset(TTLEpoch_merged,k);
Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
end


REM10s=Ordered_REM(:,2);
REM10_20s=Ordered_REM(:,5);
REM20_30s=Ordered_REM(:,8);
REM30setplus=Ordered_REM(:,11);



events=REM10s;

%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM10s')
savefig(fullfile(pathname2,'HPC_REM10s'))

events=REM10_20s
%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM10s')
savefig(fullfile(pathname2,'HPC_REM10_20s'))

events=REM20_30s
%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM10s')
savefig(fullfile(pathname2,'HPC_REM20_30s'))

events=REM30setplus
%%%Pour l'HPC (à changer si le load est différent)
load('dHPC_deep_Low_Spectrum')
SpectroH2=Spectro
%%AveargeSpectre Stim REM (0)
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroH2{2}*1E4,10*log10(SpectroH2{1})),SpectroH2{3},Restrict(ts(events*1E4),REMEpoch),500,300);
title('HPC REM10s')
savefig(fullfile(pathname2,'HPC_REM30+'))


%%%%%%%%%%Panel 4 figure en .png
load('ExpeInfo')
pathname='Figures'
pathname2='Figures/Average_Spectrums'
title(['VLPO REM ',num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])
%%Panel 4 spectres REM
hR1=openfig('Figures/Average_Spectrums/HPC_REM10s')
axR1=gca
hR2=openfig('Figures/Average_Spectrums/HPC_REM10_20s')
axR2=gca
hR3=openfig('Figures/Average_Spectrums/HPC_REM20_30s')
axR3=gca
hR4=openfig('Figures/Average_Spectrums/HPC_REM30+')
axR4=gca

hR3=figure
sR1=subplot(2,2,1)
title('HPC_REM10s')
sR2=subplot(2,2,2)
title('HPC_REM10_20s')
sR3=subplot(2,2,3)
title('HPC_REM20s_30s')
sR4=subplot(2,2,4)
title('HPC_REM30s+')
fig1=get(axR1,'children')
fig2=get(axR2,'children')
fig3=get(axR3,'children')
fig4=get(axR4,'children')
copyobj(fig1,sR1)
copyobj(fig2,sR2)
copyobj(fig3,sR3)
copyobj(fig4,sR4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hR3,fullfile(pathname,'Panel_HPC_REM_differents_temps_StartStim.png'))
end
