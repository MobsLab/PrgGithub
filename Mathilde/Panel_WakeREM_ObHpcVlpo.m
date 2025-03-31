function Panel_WakeREM_ObHpcVlpo
% AverageSpectrum figures need to be done and saved 

load('ExpeInfo')

hR1=openfig('Figures/Average_SPectrums/Bulb_high_REM');
axR1=gca;
hR2=openfig('Figures/Average_SPectrums/Bulb_high_Wake')
axR2=gca;
hR3=openfig('Figures/Average_SPectrums/Bulb_REM');
axR3=gca;
hR4=openfig('Figures/Average_SPectrums/Bulb_Low_Wake');
axR4=gca;
hR5=openfig('Figures/Average_SPectrums/VLPO_REM');
axR5=gca;
hR6=openfig('Figures/Average_SPectrums/VLPO_Wake');
axR6=gca;
hR7=openfig('Figures/Average_SPectrums/HPC_REM');
axR7=gca;
hR8=openfig('Figures/Average_SPectrums/HPC_Wake');
axR8=gca;

hR8=figure
sR1=subplot(421)
title('OB high REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
colormap(jet)
% caxis([20 48])
xlim([-75 +75])
ylim([+20 +100])
sR2=subplot(422)
title('OB high Wake')
xlabel('time (s)')
ylabel('Frequency (Hz)')
colormap(jet)
% caxis([20 48])
xlim([-75 +75])
ylim([+20 +100])
sR3=subplot(423)
title('OB low REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
colormap(jet)
% caxis([20 48])
xlim([-75 +75])
ylim([0 +20])
sR4=subplot(424)
title('Ob low Wake')
xlabel('time (s)')
ylabel('Frequency (Hz)')
colormap(jet)
% caxis([20 48])
xlim([-75 +75])
ylim([0 +20])
sR5=subplot(425)
title('VLPO REM ')
xlabel('time (s)')
ylabel('Frequency (Hz)')
colormap(jet)
% caxis([20 48])
xlim([-75 +75])
ylim([0 +20])
sR6=subplot(426)
title('VLPO Wake')
xlabel('time (s)')
ylabel('Frequency (Hz)')
colormap(jet)
% caxis([20 48])
xlim([-75 +75])
ylim([0 +20])
sR7=subplot(427)
title('HPC REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
colormap(jet)
% caxis([20 48])
xlim([-75 +75])
ylim([0 +20])
sR8=subplot(428)
title('HCP Wake')
xlabel('time (s)')
ylabel('Frequency (Hz)')
colormap(jet)
% caxis([20 48])
xlim([-75 +75])
ylim([0 +20])
fig1=get(axR1,'children');
fig2=get(axR2,'children');
fig3=get(axR3,'children');
fig4=get(axR4,'children');
fig5=get(axR5,'children');
fig6=get(axR6,'children');
fig7=get(axR7,'children');
fig8=get(axR8,'children');
copyobj(fig1,sR1)
copyobj(fig2,sR2)
copyobj(fig3,sR3)
copyobj(fig4,sR4)
copyobj(fig5,sR5)
copyobj(fig6,sR6)
copyobj(fig7,sR7)
copyobj(fig8,sR8)
colormap(jet)

suptitle([num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])                           

end