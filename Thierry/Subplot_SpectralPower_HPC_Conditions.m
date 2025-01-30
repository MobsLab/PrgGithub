
%% pour 923-926-927-927

clear all
%M923
cd /home/mobs/Dropbox/ProjetPFC-VLPO/CNO_Exchangecage/M923
h1 = openfig('HPC_spectral_REM_923.fig','reuse'); 
ax1 = gca; 
h2 = openfig('HPC_spectral_Wake_923','reuse');
ax2 = gca;
h3 = openfig('HPC_spectral_SWS_923','reuse');
ax3 = gca;

%M926
cd /home/mobs/Dropbox/ProjetPFC-VLPO/CNO_Exchangecage/M926
h4 = openfig('HPC_spectral_REM_926.fig','reuse'); 
ax4 = gca; 
h5 = openfig('HPC_spectral_Wake_926','reuse');
ax5 = gca;
h6 = openfig('HPC_spectral_SWS_926','reuse');
ax6 = gca;

%M927
cd /home/mobs/Dropbox/ProjetPFC-VLPO/CNO_Exchangecage/M927
h7 = openfig('HPC_spectral_REM_927.fig','reuse'); 
ax7 = gca; 
h8 = openfig('HPC_spectral_Wake_927','reuse');
ax8 = gca;
h9 = openfig('HPC_spectral_SWS_927','reuse');
ax9 = gca;

%M928
cd /home/mobs/Dropbox/ProjetPFC-VLPO/CNO_Exchangecage/M928
h10 = openfig('HPC_spectral_REM_928.fig','reuse'); 
ax10 = gca; 
h11 = openfig('HPC_spectral_Wake_928','reuse');
ax11 = gca;
h12 = openfig('HPC_spectral_SWS_928','reuse');
ax12 = gca;

%M953
cd /home/mobs/Dropbox/ProjetPFC-VLPO/CNO_Exchangecage/M953
h13 = openfig('HPC_spectral_REM_953.fig','reuse'); 
ax13 = gca; 
h14 = openfig('HPC_spectral_Wake_953','reuse');
ax14 = gca;
h15 = openfig('HPC_spectral_SWS_953','reuse');
ax15 = gca;

%M954
cd /home/mobs/Dropbox/ProjetPFC-VLPO/CNO_Exchangecage/M954
h16 = openfig('HPC_spectral_REM_954.fig','reuse'); 
ax16 = gca; 
h17 = openfig('HPC_spectral_Wake_954','reuse');
ax17 = gca;
h18 = openfig('HPC_spectral_SWS_954','reuse');
ax18 = gca;

h19 = figure; %create new figure

s1 = subplot(3,6,1); %create and get handle to the subplot axes
legend('HomeCage1','CNO','HomeCage2','Saline')
ylabel('spectral power')
xlabel('Frequency')
title('HPC REM (M923)')
set(gca,'FontSize',14)

s2 = subplot(3,6,2); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC Wake (M923)')
set(gca,'FontSize',14)

s3 = subplot(3,6,3); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC SWS (M923)')
set(gca,'FontSize',14)

s4 = subplot(3,6,4); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC REM (M926)')
set(gca,'FontSize',14)

s5 = subplot(3,6,5); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC Wake (M926)')
set(gca,'FontSize',14)

s6 = subplot(3,6,6); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC SWS (M926)')
set(gca,'FontSize',14)

s7 = subplot(3,6,7); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC REM (M927)')
set(gca,'FontSize',14)

s8 = subplot(3,6,8); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC Wake (M927)')
set(gca,'FontSize',14)

s9 = subplot(3,6,9); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC SWS (M927)')
set(gca,'FontSize',14)

s10 = subplot(3,6,10); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC REM (M928)')
set(gca,'FontSize',14)

s11 = subplot(3,6,11); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC Wake (M928)')
set(gca,'FontSize',14)

s12 = subplot(3,6,12); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC SWS (M928)')
set(gca,'FontSize',14)

s13 = subplot(3,6,13); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC REM (M953)')
set(gca,'FontSize',14)

s14 = subplot(3,6,14); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC Wake (M953)')
set(gca,'FontSize',14)

s15 = subplot(3,6,15); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC SWS (M953)')
set(gca,'FontSize',14)

s16 = subplot(3,6,16); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC REM (M954)')
set(gca,'FontSize',14)

s17 = subplot(3,6,17); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC Wake (M954)')
set(gca,'FontSize',14)

s18 = subplot(3,6,18); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC SWS (M954)')
set(gca,'FontSize',14)

fig1 = get(ax1,'children'); 
fig2 = get(ax2,'children');
fig3 = get(ax3,'children');
fig4 = get(ax4,'children'); 
fig5 = get(ax5,'children');
fig6 = get(ax6,'children');
fig7 = get(ax7,'children'); 
fig8 = get(ax8,'children');
fig9 = get(ax9,'children');
fig10 = get(ax10,'children'); 
fig11 = get(ax11,'children');
fig12 = get(ax12,'children');
fig13 = get(ax13,'children');
fig14 = get(ax14,'children');
fig15 = get(ax15,'children');
fig16 = get(ax16,'children');
fig17 = get(ax17,'children');
fig18 = get(ax18,'children');

copyobj(fig1,s1); 
copyobj(fig2,s2);
copyobj(fig3,s3);
copyobj(fig4,s4); 
copyobj(fig5,s5);
copyobj(fig6,s6);
copyobj(fig7,s7); 
copyobj(fig8,s8);
copyobj(fig9,s9);
copyobj(fig10,s10); 
copyobj(fig11,s11);
copyobj(fig12,s12);
copyobj(fig13,s13); 
copyobj(fig14,s14);
copyobj(fig15,s15);
copyobj(fig16,s16); 
copyobj(fig17,s17);
copyobj(fig18,s18);

savefig(fullfile('HPC_spectral_power_ExchangeCages_CNO'))


%% pour 929-930

clear all
%M929
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline/Figures
h1 = openfig('HPC_spectral_REM_929.fig','reuse'); 
ax1 = gca; 
h2 = openfig('HPC_spectral_Wake_929','reuse');
ax2 = gca;
h3 = openfig('HPC_spectral_SWS_929','reuse');
ax3 = gca;
h4 = openfig('HPC_spectral_All_929','reuse');
ax4 = gca;

%930
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline/Figures
h5 = openfig('HPC_spectral_REM_930.fig','reuse'); 
ax5 = gca; 
h6 = openfig('HPC_spectral_Wake_930','reuse');
ax6 = gca;
h7 = openfig('HPC_spectral_SWS_930','reuse');
ax7 = gca;
h8 = openfig('HPC_spectral_All_930','reuse');
ax8 = gca;

h9 = figure; %create new figure

s1 = subplot(2,4,1); %create and get handle to the subplot axes
legend('HomeCage1','HomecageCNO','HomeCage2','HomecageSal')
ylabel('spectral power')
xlabel('Frequency')
title('HPC REM (M929)')
set(gca,'FontSize',14)
xlim([0 15])

s2 = subplot(2,4,2); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC Wake (M929)')
set(gca,'FontSize',14)
xlim([0 15])

s3 = subplot(2,4,3); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC SWS (M929)')
set(gca,'FontSize',14)
xlim([0 15])

s4 = subplot(2,4,4); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC All (M929)')
set(gca,'FontSize',14)
xlim([0 15])

s5 = subplot(2,4,5); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC REM (M930)')
set(gca,'FontSize',14)
xlim([0 15])

s6 = subplot(2,4,6); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC Wake (M930)')
set(gca,'FontSize',14)
xlim([0 15])

s7 = subplot(2,4,7); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC SWS (M930)')
xlim([0 15])
set(gca,'FontSize',14)
xlim([0 15])

s8 = subplot(2,4,8); %create and get handle to the subplot axes
ylabel('spectral power')
xlabel('Frequency')
title('HPC All (M930)')
set(gca,'FontSize',14)
xlim([0 15])

fig1 = get(ax1,'children'); 
fig2 = get(ax2,'children');
fig3 = get(ax3,'children');
fig4 = get(ax4,'children'); 
fig5 = get(ax5,'children');
fig6 = get(ax6,'children');
fig7 = get(ax7,'children'); 
fig8 = get(ax8,'children');

copyobj(fig1,s1); 
copyobj(fig2,s2);
copyobj(fig3,s3);
copyobj(fig4,s4); 
copyobj(fig5,s5);
copyobj(fig6,s6);
copyobj(fig7,s7); 
copyobj(fig8,s8);

savefig(fullfile('HPC_spectral_power_ExchangeCages_CNO'))