
clear all
%REM_First_sec_third
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline/Figures
h1 = openfig('mean_Perc_REM_First_Third.fig','reuse'); 
ax1 = gca; 
h2 = openfig('mean_Perc_REM_Sec_Third','reuse');
ax2 = gca;
h3 = openfig('mean_Perc_REM_Last_Third','reuse');
ax3 = gca;
%REM_overtime Saline vs CNO
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline/Figures
h4 = openfig('mean_Perc_REM_overtime_CNOvsSaline','reuse');
ax4 = gca;

h5 = figure; %create new figure

s1 = subplot(2,3,1); %create and get handle to the subplot axes
ylabel('%REM')
xlabel('Conditions')
title('%REM during the First Third of recording')
xticks([1 2 3 4])
xticklabels({'Homecage1','CNO','Homecage2','Saline'})
ylim([0 18])

s2 = subplot(2,3,2);
ylabel('%REM')
xlabel('Conditions')
title('%REM during the Second Third of recording')
xticks([1 2 3 4])
xticklabels({'Homecage1','CNO','Homecage2','Saline'})
ylim([0 18])

s3 = subplot(2,3,3);
ylabel('%REM')
xlabel('Conditions')
title('%REM during the Last Third of recording')
xticks([1 2 3 4])
xticklabels({'Homecage1','CNO','Homecage2','Saline'})
ylim([0 18])

s4 = subplot(2,3,[4,5,6]);
ylabel('%REM')
xlabel('Time (s)')
title('%REM over time CNO vs Saline')
xticks([1 2 3 4])
legend ('CNO','Saline')
xlim([0 3.5E4])

fig1 = get(ax1,'children'); 
fig2 = get(ax2,'children');
fig3 = get(ax3,'children');
fig4 = get(ax4,'children');

copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3);
copyobj(fig4,s4);
savefig(fullfile('Percentage of REM during recordings.fig'))