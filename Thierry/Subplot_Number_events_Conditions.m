
%%Mouse 923 
%Homecage1
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M923_Baseline2/Figures
h1 = openfig('Number_Events.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse923_CNO_1_day3/Figures
h2 = openfig('Number','reuse');
ax2 = gca;

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M923_Baseline3/Figures
h3 = openfig('Number_Events','reuse');
ax3 = gca;

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M923_Saline_1_day5/Figures
h4 = openfig('Number_Events','reuse');
ax4 = gca;

h5 = figure; %create new figure
s1 = subplot(2,2,1); %create and get handle to the subplot axes
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M923 Homecage1)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

s2 = subplot(2,2,2);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M923 CNO)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

s3 = subplot(2,2,3);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M923 Homecage2)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

s4 = subplot(2,2,4);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M923 Saline)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
savefig(fullfile('Number_Events_Conditions.fig'))


%%Mouse 926
%Homecage1
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M926_Baseline2/Figures
h1 = openfig('Number_Events.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure

%CNO
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse926_CNO_1_day3/Figures
h2 = openfig('Number_events','reuse');
ax2 = gca;

%Homecage2
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M926_Baseline3/Figures
h3 = openfig('Number_events','reuse');
ax3 = gca;

%Saline
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M926_Saline_1_day5/Figures
h4 = openfig('Number_events','reuse');
ax4 = gca;

h5 = figure; %create new figure
s1 = subplot(2,2,1); %create and get handle to the subplot axes
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M926 Homecage1)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

s2 = subplot(2,2,2);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M926 CNO)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

s3 = subplot(2,2,3);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M926 Homecage2)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

s4 = subplot(2,2,4);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M926 Saline)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
savefig(fullfile('Number_Events_Conditions.fig'))

%%Mouse 927
%Homecage1
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M927_Baseline2/Figures
h1 = openfig('Number.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure

%CNO
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M927_CNO_1_day5/Figures
h2 = openfig('Number','reuse');
ax2 = gca;

%Homecage2
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M927_Baseline3/Figures
h3 = openfig('Number','reuse');
ax3 = gca;

%Saline
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/M927_Saline/Figures
h4 = openfig('Number','reuse');
ax4 = gca;

h5 = figure; %create new figure
s1 = subplot(2,2,1); %create and get handle to the subplot axes
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M927 Homecage1)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

s2 = subplot(2,2,2);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M927 CNO)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

s3 = subplot(2,2,3);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M927 Homecage2)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

s4 = subplot(2,2,4);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M927 Saline)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
savefig(fullfile('Number_Events_Conditions_M927.fig'))

%%Mouse 928
clear all
%Homecage1
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M928_Baseline2/Figures
h1 = openfig('Number.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure

%CNO
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M928_CNO_1_day5/Figures
h2 = openfig('Number','reuse');
ax2 = gca;

%Homecage2
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M928_Baseline3/Figures
h3 = openfig('Number','reuse');
ax3 = gca;

%Saline
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/M928_Saline/Figures
h4 = openfig('Number','reuse');
ax4 = gca;

h5 = figure; %create new figure
s1 = subplot(2,2,1); %create and get handle to the subplot axes
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M928 Homecage1)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 300])

s2 = subplot(2,2,2);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M928 CNO)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 300])

s3 = subplot(2,2,3);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M928 Homecage2)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 300])

s4 = subplot(2,2,4);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M928 Saline)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 300])

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
savefig(fullfile('Number_Events_Conditions_M928.fig'))

%%Mouse 953
clear all
%Homecage1
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M953_Baseline2/Figures
h1 = openfig('Number.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure

%CNO
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M953_CNO/Figures
h2 = openfig('Number','reuse');
ax2 = gca;

%Homecage2
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M953_Baseline3/Figures
h3 = openfig('Number','reuse');
ax3 = gca;

%Saline
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M953_Saline/Figures
h4 = openfig('Number','reuse');
ax4 = gca;

h5 = figure; %create new figure
s1 = subplot(2,2,1); %create and get handle to the subplot axes
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M953 Homecage1)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 600])

s2 = subplot(2,2,2);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M953 CNO)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 600])

s3 = subplot(2,2,3);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M953 Homecage2)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 600])

s4 = subplot(2,2,4);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M953 Saline)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 600])

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
savefig(fullfile('Number_Events_Conditions_M953.fig'))

%%Mouse 954
clear all
%Homecage1
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M954_Baseline2/Figures
h1 = openfig('Number.fig','reuse'); % open figure
ax1 = gca; % get handle to axes of figure

%CNO
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M954_CNO/Figures
h2 = openfig('Number','reuse');
ax2 = gca;

%Homecage2
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M954_Baseline3/Figures
h3 = openfig('Number','reuse');
ax3 = gca;

%Saline
cd /media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M954_Saline/Figures
h4 = openfig('Number','reuse');
ax4 = gca;

h5 = figure; %create new figure
s1 = subplot(2,2,1); %create and get handle to the subplot axes
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M954 Homecage1)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 300])

s2 = subplot(2,2,2);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M954 CNO)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 300])

s3 = subplot(2,2,3);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M954 Homecage2)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 300])

s4 = subplot(2,2,4);
ylabel('Number of events')
xlabel('Stages')
title('Number of sate events (M954 Saline)')
xticks([1 2 3])
xticklabels({'Wake','SWS','REM'})
ylim([0 300])

fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
savefig(fullfile('Number_Events_Conditions_M954.fig'))