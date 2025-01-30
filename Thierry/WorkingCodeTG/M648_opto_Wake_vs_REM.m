h1 = openfig('VLPO_REM','reuse'); % open figure
colormap(jet)
caxis([20 48])
xlim([-75 +75])
ax1 = gca; % get handle to axes of figure
h2 = openfig('VLPO_Wake.fig','reuse','reuse');
colormap(jet)
caxis([20 48])
xlim([-75 +75])
ax2 = gca;
h3 = openfig('HPC_REM.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-75 +75])
ax3 = gca;
h4 = openfig('HPC_Wake.fig','reuse');
colormap(jet)
caxis([20 48])
xlim([-75 +75])
ax4 = gca;
h5 = figure; %create new figure
s1 = subplot(2,2,1); %create and get handle to the subplot axes
ylabel('Frequency')
xlabel('Time')
title('VLPO REM Stim = 4')
s2 = subplot(2,2,2);
ylabel('Frequency')
xlabel('Time')
title('VLPO Wake Stim = 4')
s3 = subplot(2,2,3);
ylabel('Frequency')
xlabel('Time')
title('HPC REM Stim = 18')
s4 = subplot(2,2,4);
ylabel('Frequency')
xlabel('Time')
title('HPC Wake Stim = 18')
fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
colormap(jet)
caxis([20 48])
xlim([-80 +80])
savefig(fullfile('M648_opto_Wake_vs_REM.fig'))
