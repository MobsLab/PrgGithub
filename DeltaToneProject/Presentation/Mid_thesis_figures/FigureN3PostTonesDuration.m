% FigureN3PostTonesDuration
% 15.12.2016 KJ
%
% Plot the figure that shows the difference in N3 duration between
% substages induced or not by a tone
% - 
% 
%   see TonesAtTransitionSWSSubstageDurationPlot4
%


%load
clear
eval(['load ' FolderProjetDelta 'Data/TonesAtTransitionSWSSubstageDuration_bis1.mat'])


% Figure N2 N3, one figure by delay
substage_transitions = [2 3];
columntest = [1 2;2 3];
cond = 6;
sub1=substage_transitions(1);sub2=substage_transitions(2);

maintitle = 'N3 duration (after a N2 episode) - Basal vs Tone 490ms';

labels = {'Basal','Tone at transition', 'NO tone at transition'};
barcolors = {[0.2 0.2 0.2],'b',[0.8 0.8 0.8]};

%% DATA
%Post
data_post{cond_basal} = post.all{cond_basal,sub1,sub2} / 10;
data_post{end+1} = post.success{cond,sub1,sub2} / 10;
data_post{end+1} = post.no_event{cond,sub1,sub2} / 10;


%% PLOT
figure, hold on

%plot post
[~,eb] = PlotErrorBarN_KJ(data_post,'newfig',0,'paired',0,'showPoints',0,'barcolors',barcolors,'ColumnTest',columntest);
title(maintitle), ylabel('duration (ms)'), hold on
set(eb,'Linewidth',2); %bold error bar
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'FontName','Times','fontsize',17), hold on,
set(gca, 'YTick',0:1000:4000);

