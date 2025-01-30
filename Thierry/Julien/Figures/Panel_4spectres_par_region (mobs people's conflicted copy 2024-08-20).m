function Panel_4spectres_par_region
%%Avoir fait les AverageSpectrum et les avoir sauver avec la fonction
                %%AverageSpectrum_restrictEpoch

                           
load('ExpeInfo')
pathname='Figures'
pathname2='Figures/Average_Spectrums'
title([num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])

%%Panel 4 spectres REM
hR1=openfig('Figures/Average_Spectrums/VLPO_REM')
axR1=gca
hR2=openfig('Figures/Average_Spectrums/Bulb_REM')
axR2=gca
hR3=openfig('Figures/Average_Spectrums/PFC_REM')
axR3=gca
hR4=openfig('Figures/Average_Spectrums/HPC_REM')
axR4=gca

hR3=figure
sR1=subplot(2,2,1)
title('VLPO REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
sR2=subplot(2,2,2)
title('Bulb REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
sR3=subplot(2,2,3)
title('PFC REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
sR4=subplot(2,2,4)
title('HPC_REM')
xlabel('time (s)')
ylabel('Frequency (Hz)')
fig1=get(axR1,'children')
fig2=get(axR2,'children')
fig3=get(axR3,'children')
fig4=get(axR4,'children')
copyobj(fig1,sR1)
copyobj(fig2,sR2)
copyobj(fig3,sR3)
copyobj(fig4,sR4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hR3,fullfile(pathname,'Panel_REM.png'))
savefig(fullfile(pathname2,'Panel_REM'))


%%Panel 4 spectres SWS
clear all
load('ExpeInfo')
pathname='Figures'
pathname2='Figures/Average_Spectrums'
title(['VLPO REM ',num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])

hS1=openfig('Figures/Average_Spectrums/VLPO_SWS')
axS1=gca
hS2=openfig('Figures/Average_Spectrums/Bulb_SWS')
axS2=gca
hS3=openfig('Figures/Average_Spectrums/PFC_SWS')
axS3=gca
hS4=openfig('Figures/Average_Spectrums/HPC_SWS')
axS4=gca

hS3=figure
sS1=subplot(2,2,1)
title('VLPO SWS')
sS2=subplot(2,2,2)
title('Bulb SWS')
sS3=subplot(2,2,3)
title('PFC SWS')
sS4=subplot(2,2,4)
title('HPC SWS')
figS1=get(axS1,'children')
figS2=get(axS2,'children')
figS3=get(axS3,'children')
figS4=get(axS4,'children')
copyobj(figS1,sS1)
copyobj(figS2,sS2)
copyobj(figS3,sS3)
copyobj(figS4,sS4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hS3,fullfile(pathname,'Panel_SWS.png'))
savefig(fullfile(pathname2,'Panel_SWS'))


%%Panel 4 spectres Wake
clear all
load('ExpeInfo')
pathname='Figures'
pathname2='Figures/Average_Spectrums'
title(['VLPO REM ',num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])

hW1=openfig('Figures/Average_Spectrums/VLPO_Wake')
axW1=gca
hW2=openfig('Figures/Average_Spectrums/Bulb_Wake')
axW2=gca
hW3=openfig('Figures/Average_Spectrums/PFC_Wake')
axW3=gca
hW4=openfig('Figures/Average_Spectrums/HPC_Wake')
axW4=gca

hW3=figure
sW1=subplot(2,2,1)
title('VLPO Wake')
sW2=subplot(2,2,2)
title('Bulb Wake')
sW3=subplot(2,2,3)
title('PFC Wake')
sW4=subplot(2,2,4)
title('HPC Wake')
figW1=get(axW1,'children')
figW2=get(axW2,'children')
figW3=get(axW3,'children')
figW4=get(axW4,'children')
copyobj(figW1,sW1)
copyobj(figW2,sW2)
copyobj(figW3,sW3)
copyobj(figW4,sW4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hW3,fullfile(pathname,'Panel_Wake.png'))
savefig(fullfile(pathname2,'Panel_Wake'))

end



%suplot pour 2 pannels RM theta wake theta

clear all

hW5=openfig('Figures/Average_Spectrums/HPC_Wake')
axW5=gca
hW6=openfig('Figures/Average_Spectrums/HPC_REM')
axW6=gca

hW7=figure
sW5=subplot(2,1,1)
title('HPC Wake')
sW6=subplot(2,1,2)
title('HPC REM')
figW5=get(axW5,'children')
figW6=get(axW6,'children')
copyobj(figW5,sW5)
copyobj(figW6,sW6)


%%%% subplot en series
cd('/media/nas5/Thierry_DATA/M781_processed/M781_Stimopto_10sREM_Stim30s_07092018')
uiopen('/media/nas5/Thierry_DATA/M781_processed/M781_Stimopto_10sREM_Stim30s_07092018/Figures/Panel_REM.fig',1)

hW1=openfig('Figures/Average_Spectrums/HPC_REM')
axW1=gca
hW2=openfig('Figures/Average_Spectrums/HPC_Wake')
axW2=gca
hW3=openfig('Figures/Average_Spectrums/HPC2_REM')
axW3=gca

hW4=figure
sW1=subplot(3,1,1)
title('781 HPC REM 07092018')
xlabel('time(s)')
ylabel('Frequency(Hz)')

sW3=subplot(3,1,2)
title('781 HPC2 REM 07092018')
xlabel('time(s)')
ylabel('Frequency(Hz)')

sW2=subplot(3,1,3)
title('781 HPC Wake 07092018')
xlabel('time(s)')
ylabel('Frequency(Hz)')

figW1=get(axW1,'children')
figW2=get(axW2,'children')
figW3=get(axW3,'children')
copyobj(figW1,sW1)
copyobj(figW2,sW2)
copyobj(figW3,sW3)