
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline/Figures

clear all
h1 = openfig('mean_Wake_events.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure
h2 = openfig('mean_SWS_events','reuse');
ax2 = gca;
h3 = openfig('mean_REM_events','reuse');
ax3 = gca;
h4 = figure; %create new figure

s1 = subplot(1,3,1); %create and get handle to the subplot axes
ylabel('Number of events')
xlabel('Conditions')
title('Mean Number of Wake events')
xticks([1 2 3 4])
xticklabels({'Homecage1','CNO','Homecage2','Saline'})

s2 = subplot(1,3,2);
ylabel('Number of events')
xlabel('Conditions')
title('Mean Number of SWS events')
xticks([1 2 3 4])
xticklabels({'Homecage1','CNO','Homecage2','Saline'})

s3 = subplot(1,3,3);
ylabel('Number of events')
xlabel('Conditions')
title('Mean Number of REM events')
xticks([1 2 3 4])
xticklabels({'Homecage1','CNO','Homecage2','Saline'})

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
savefig(fullfile('Mean_Number_Events_Conditions.fig'))


