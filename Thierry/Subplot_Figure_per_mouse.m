cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline/Figures
h1 = openfig('Number.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure
h2 = openfig('%REM_first_sec_third','reuse');
ax2 = gca;
h3 = openfig('Perc.fig','reuse');
ax3 = gca;
h4 = openfig('%REM_overtime.fig','reuse');
ax4 = gca;
h5 = figure; %create new figure
s1 = subplot(2,2,1); %create and get handle to the subplot axes
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M930 Saline)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
s2 = subplot(2,2,2);
ylabel('%REM')
xlabel('Stages')
title('Percentage of REM in different periods (M930 Saline)')
xticks([1 2 3 4 5])
xticklabels({'FirstHalf','SecHalf','FirstThird','SecThird','LastThird'})
s3 = subplot(2,2,3);
ylabel('Percentage')
xlabel('Stages')
title('Sleep/Wake proportions (M930 Saline)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
s4 = subplot(2,2,4);
ylabel('Stages')
xlabel('Time (s)')
title('Hypnogram with MREM (red) (M930 Saline)')
fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
savefig(fullfile('M930_Saline.fig'))
