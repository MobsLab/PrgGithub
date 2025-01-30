function Panel_4spectres_par_region_EndStim
%%Avoir fait les AverageSpectrum et les avoir sauver avec la fonction
                %%AverageSpectrum_restrictEpoch
load('ExpeInfo')
pathname='Figures'
pathname2='Figures/Average_Spectrums'
title(['VLPO REM_EndStim ',num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])
%%Panel 4 spectres REM
hR1=openfig('Figures/Average_Spectrums/VLPO_REM_EndStim')
axR1=gca
hR2=openfig('Figures/Average_Spectrums/Bulb_REM_EndStim')
axR2=gca
hR3=openfig('Figures/Average_Spectrums/PFC_REM_EndStim')
axR3=gca
hR4=openfig('Figures/Average_Spectrums/HPC_REM_EndStim')
axR4=gca

hR3=figure
sR1=subplot(2,2,1)
title('VLPO REM_EndStim')
sR2=subplot(2,2,2)
title('Bulb REM_EndStim')
sR3=subplot(2,2,3)
title('PFC REM_EndStim')
sR4=subplot(2,2,4)
title('HPC_REM_EndStim')
fig1=get(axR1,'children')
fig2=get(axR2,'children')
fig3=get(axR3,'children')
fig4=get(axR4,'children')
copyobj(fig1,sR1)
copyobj(fig2,sR2)
copyobj(fig3,sR3)
copyobj(fig4,sR4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hR3,fullfile(pathname,'Panel_REM_EndStim.png'))

%%Panel 4 spectres SWS

hS1=openfig('Figures/Average_Spectrums/VLPO_SWS_EndStim')
axS1=gca
hS2=openfig('Figures/Average_Spectrums/Bulb_SWS_EndStim')
axS2=gca
hS3=openfig('Figures/Average_Spectrums/PFC_SWS_EndStim')
axS3=gca
hS4=openfig('Figures/Average_Spectrums/HPC_SWS_EndStim')
axS4=gca

hS3=figure
sS1=subplot(2,2,1)
title('VLPO SWS_EndStim')
sS2=subplot(2,2,2)
title('Bulb SWS_EndStim')
sS3=subplot(2,2,3)
title('PFC SWS_EndStim')
sS4=subplot(2,2,4)
title('HPC SWS_EndStim')
figS1=get(axS1,'children')
figS2=get(axS2,'children')
figS3=get(axS3,'children')
figS4=get(axS4,'children')
copyobj(figS1,sS1)
copyobj(figS2,sS2)
copyobj(figS3,sS3)
copyobj(figS4,sS4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hS3,fullfile(pathname,'Panel_SWS_EndStim.png'))

%%Panel 4 spectres Wake
hW1=openfig('Figures/Average_Spectrums/VLPO_Wake_EndStim')
axW1=gca
hW2=openfig('Figures/Average_Spectrums/Bulb_Wake_EndStim')
axW2=gca
hW3=openfig('Figures/Average_Spectrums/PFC_Wake_EndStim')
axW3=gca
hW4=openfig('Figures/Average_Spectrums/HPC_Wake_EndStim')
axW4=gca

hW3=figure
sW1=subplot(2,2,1)
title('VLPO Wake_EndStim')
sW2=subplot(2,2,2)
title('Bulb Wake_EndStim')
sW3=subplot(2,2,3)
title('PFC Wake_EndStim')
sW4=subplot(2,2,4)
title('HPC Wake_EndStim')
figW1=get(axW1,'children')
figW2=get(axW2,'children')
figW3=get(axW3,'children')
figW4=get(axW4,'children')
copyobj(figW1,sW1)
copyobj(figW2,sW2)
copyobj(figW3,sW3)
copyobj(figW4,sW4)
[z,x]=suplabel([,num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.SessionName)]  ,'t');
saveas(hW3,fullfile(pathname,'Panel_Wake_EndStim.png'))
end