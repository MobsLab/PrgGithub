function Panel_4spectres_par_region_MidStim
%%Avoir fait les AverageSpectrum et les avoir sauver avec la fonction
                %%AverageSpectrum_restrictEpoch
load('ExpeInfo')
pathname='Figures'
pathname2='Figures/Average_Spectrums'
title(['VLPO REM_MidStim ',num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])
%%Panel 4 spectres REM
hR1=openfig('Figures/Average_Spectrums/VLPO_REM_MidStim')
axR1=gca
hR2=openfig('Figures/Average_Spectrums/Bulb_REM_MidStim')
axR2=gca
hR3=openfig('Figures/Average_Spectrums/PFC_REM_MidStim')
axR3=gca
hR4=openfig('Figures/Average_Spectrums/HPC_REM_MidStim')
axR4=gca

hR3=figure
sR1=subplot(2,2,1)
title('VLPO REM_MidStim')
sR2=subplot(2,2,2)
title('Bulb REM_MidStim')
sR3=subplot(2,2,3)
title('PFC REM_MidStim')
sR4=subplot(2,2,4)
title('HPC_REM_MidStim')
fig1=get(axR1,'children')
fig2=get(axR2,'children')
fig3=get(axR3,'children')
fig4=get(axR4,'children')
copyobj(fig1,sR1)
copyobj(fig2,sR2)
copyobj(fig3,sR3)
copyobj(fig4,sR4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hR3,fullfile(pathname,'Panel_REM_MidStim.png'))

%%Panel 4 spectres SWS

hS1=openfig('Figures/Average_Spectrums/VLPO_SWS_MidStim')
axS1=gca
hS2=openfig('Figures/Average_Spectrums/Bulb_SWS_MidStim')
axS2=gca
hS3=openfig('Figures/Average_Spectrums/PFC_SWS_MidStim')
axS3=gca
hS4=openfig('Figures/Average_Spectrums/HPC_SWS_MidStim')
axS4=gca

hS3=figure
sS1=subplot(2,2,1)
title('VLPO SWS_MidStim')
sS2=subplot(2,2,2)
title('Bulb SWS_MidStim')
sS3=subplot(2,2,3)
title('PFC SWS_MidStim')
sS4=subplot(2,2,4)
title('HPC SWS_MidStim')
figS1=get(axS1,'children')
figS2=get(axS2,'children')
figS3=get(axS3,'children')
figS4=get(axS4,'children')
copyobj(figS1,sS1)
copyobj(figS2,sS2)
copyobj(figS3,sS3)
copyobj(figS4,sS4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hS3,fullfile(pathname,'Panel_SWS_MidStim.png'))

%%Panel 4 spectres Wake
hW1=openfig('Figures/Average_Spectrums/VLPO_Wake_MidStim')
axW1=gca
hW2=openfig('Figures/Average_Spectrums/Bulb_Wake_MidStim')
axW2=gca
hW3=openfig('Figures/Average_Spectrums/PFC_Wake_MidStim')
axW3=gca
hW4=openfig('Figures/Average_Spectrums/HPC_Wake_MidStim')
axW4=gca

hW3=figure
sW1=subplot(2,2,1)
title('VLPO Wake_MidStim')
sW2=subplot(2,2,2)
title('Bulb Wake_MidStim')
sW3=subplot(2,2,3)
title('PFC Wake_MidStim')
sW4=subplot(2,2,4)
title('HPC Wake_MidStim')
figW1=get(axW1,'children')
figW2=get(axW2,'children')
figW3=get(axW3,'children')
figW4=get(axW4,'children')
copyobj(figW1,sW1)
copyobj(figW2,sW2)
copyobj(figW3,sW3)
copyobj(figW4,sW4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hW3,fullfile(pathname,'Panel_Wake_MidStim.png'))
end