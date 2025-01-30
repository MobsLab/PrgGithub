
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline/Figures

h1 = openfig('ratio_SWSTotalSleep_conditions.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure
h2 = openfig('ratio_REMTotalSleep_conditions','reuse');
ax2 = gca;
h3 = figure; %create new figure

s1 = subplot(1,2,1); %create and get handle to the subplot axes
ylabel('Ratio SWS/Total Sleep')
xlabel('Conditions')
title('Mean SWS/Total Sleep')
xticks([1 2 3 4])
xticklabels({'Homecage1','CNO','Homecage2','Saline'})

s2 = subplot(1,2,2);
ylabel('Ratio REM/Total Sleep')
xlabel('Conditions')
title('Mean REM/Total Sleep')
xticks([1 2 3 4])
xticklabels({'Homecage1','CNO','Homecage2','Saline'})

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
savefig(fullfile('Mean_Ratio_Conditions.fig'))


%%%% en fonction de l'ordre des CNO / Saline
%Ratio_REMTotalSleep_order_CNO-Saline
cd /home/mobs/Dropbox/ProjetPFC-VLPO/CNO_Exchangecage/Orders

clear all
h1 = openfig('Ratio_REMTotalSleep_order_CNO-Saline.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure
h2 = openfig('Ratio_REMTotalSleep_order_Saline-CNO','reuse');
ax2 = gca;
h3 = figure; %create new figure

s1 = subplot(1,2,1); %create and get handle to the subplot axes
ylabel('Ratio REM/Total Sleep')
xlabel('Conditions')
title('Ratio REM/Total (order: homecage1 -> Exchange Cage CNO -> homecage2 -> Saline)')
xticks([1 2 3 4])
xticklabels({'Homecage1','CNO','Homecage2','Saline'})

s2 = subplot(1,2,2);
ylabel('Ratio REM/Total Sleep')
xlabel('Conditions')
title('Ratio REM/Total (order: homecage1 -> Saline -> homecage2 -> Exchange Cage CNO)')
xticks([1 2 3 4])
xticklabels({'Homecage1','Saline','Homecage2','CNO'})

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
savefig(fullfile('Ratio_REMTotalSleep_order_Saline-CNO.fig'))

