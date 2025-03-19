% Figure7StimEffectSleepStructurePlot1
% 05.12.2016 KJ
%
% Collect data to plot the figures from the Figure7.pdf (a-b-c) of Gaetan PhD
% 
% 
%   see Figure7StimEffectSleepStructure Figure7StimEffectSleepStructurePlot2 Figure7StimEffectSleepStructurePlot3
%


clear
load([FolderProjetDelta 'Data/Figure7StimEffectSleepStructure.mat']) 

conditions = figure7_res.manipe;
conditions = unique(conditions(~cellfun('isempty',conditions)));

substage_n1 = 1;
substage_n2 = 2;
substage_n3 = 3;
substage_rem = 4;
substage_wake = 5;
substage_sws = 6;
labels_sessions = {'S1','S2','S3','S4','S5'};
basal_colors = {'k'};
deltatone_colors = {'k','b','k','b','k'};

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure, hold on
show_signif_star = 'none';
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% SWS duration
subplot(3,2,1), hold on %basal
sws_data_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        sws_data_basal = [sws_data_basal ; squeeze(figure7_res.stageDuration(p,substage_sws,:))'];
    end
end
sws_data_basal(sws_data_basal==0)=nan;
sws_data_basal = sws_data_basal / 1E4;

PlotErrorBarN_KJ(sws_data_basal, 'newfig',0,'barcolors',basal_colors,'ShowSigstar',show_signif_star);
ylabel('SWS duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('Basal Sleep')


subplot(3,2,2), hold on %deltaTone
sws_data_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneAll')
        sws_data_tone = [sws_data_tone ; squeeze(figure7_res.stageDuration(p,substage_sws,:))'];
    end
end
sws_data_tone(sws_data_tone==0)=nan;
sws_data_tone = sws_data_tone / 1E4;

PlotErrorBarN_KJ(sws_data_tone, 'newfig',0,'barcolors',deltatone_colors,'ShowSigstar',show_signif_star);
ylabel('SWS duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('DeltaTone Sleep')


%% REM duration
subplot(3,2,3), hold on %basal
rem_data_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        rem_data_basal = [rem_data_basal ; squeeze(figure7_res.stageDuration(p,substage_rem,:))'];
    end
end
%rem_data_basal(rem_data_basal==0)=nan;
rem_data_basal = rem_data_basal / 1E4;

PlotErrorBarN_KJ(rem_data_basal, 'newfig',0,'barcolors',basal_colors,'ShowSigstar',show_signif_star);
ylabel('REM duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,


subplot(3,2,4), hold on %deltaTone
rem_data_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneAll')
        rem_data_tone = [rem_data_tone ; squeeze(figure7_res.stageDuration(p,substage_rem,:))'];
    end
end
%rem_data_tone(rem_data_tone==0)=nan;
rem_data_tone = rem_data_tone / 1E4;

PlotErrorBarN_KJ(rem_data_tone, 'newfig',0,'barcolors',deltatone_colors,'ShowSigstar',show_signif_star);
ylabel('REM duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,


%% Wake duration
subplot(3,2,5), hold on %basal
wake_data_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        wake_data_basal = [wake_data_basal ; squeeze(figure7_res.stageDuration(p,substage_wake,:))'];
    end
end
wake_data_basal(wake_data_basal==0)=nan;
wake_data_basal = wake_data_basal / 1E4;

PlotErrorBarN_KJ(wake_data_basal, 'newfig',0,'barcolors',basal_colors,'ShowSigstar',show_signif_star);
ylabel('Wake duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,


subplot(3,2,6), hold on %deltaTone
wake_data_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneAll')
        wake_data_tone = [wake_data_tone ; squeeze(figure7_res.stageDuration(p,substage_wake,:))'];
    end
end
wake_data_tone(wake_data_tone==0)=nan;
wake_data_tone = wake_data_tone / 1E4;

PlotErrorBarN_KJ(wake_data_tone, 'newfig',0,'barcolors',deltatone_colors,'ShowSigstar',show_signif_star);
ylabel('Wake duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure, hold on
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% N1 duration
subplot(3,2,1), hold on %basal
n1_data_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        n1_data_basal = [n1_data_basal ; squeeze(figure7_res.stageDuration(p,substage_n1,:))'];
    end
end
n1_data_basal(n1_data_basal==0)=nan;
n1_data_basal = n1_data_basal / 1E4;

PlotErrorBarN_KJ(n1_data_basal, 'newfig',0,'barcolors',basal_colors,'ShowSigstar',show_signif_star,'y_lim',[0 1500]);
ylabel('N1 duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('Basal Sleep')


subplot(3,2,2), hold on %deltaTone
n1_data_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneAll')
        n1_data_tone = [n1_data_tone ; squeeze(figure7_res.stageDuration(p,substage_n1,:))'];
    end
end
n1_data_tone(n1_data_tone==0)=nan;
n1_data_tone = n1_data_tone / 1E4;

PlotErrorBarN_KJ(n1_data_tone, 'newfig',0,'barcolors',deltatone_colors,'ShowSigstar',show_signif_star,'y_lim',[0 1500]);
ylabel('N1 duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('DeltaTone Sleep')


%% N2 duration
subplot(3,2,3), hold on %basal
n2_data_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        n2_data_basal = [n2_data_basal ; squeeze(figure7_res.stageDuration(p,substage_n2,:))'];
    end
end
n2_data_basal(n2_data_basal==0)=nan;
n2_data_basal = n2_data_basal / 1E4;

PlotErrorBarN_KJ(n2_data_basal, 'newfig',0,'barcolors',basal_colors,'ShowSigstar',show_signif_star,'y_lim',[0 6000]);
ylabel('N2 duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('Basal Sleep')


subplot(3,2,4), hold on %deltaTone
n2_data_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneAll')
        n2_data_tone = [n2_data_tone ; squeeze(figure7_res.stageDuration(p,substage_n2,:))'];
    end
end
n2_data_tone(n2_data_tone==0)=nan;
n2_data_tone = n2_data_tone / 1E4;

PlotErrorBarN_KJ(n2_data_tone, 'newfig',0,'barcolors',deltatone_colors,'ShowSigstar',show_signif_star,'y_lim',[0 6000]);
ylabel('N2 duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('DeltaTone Sleep')


%% N3 duration
subplot(3,2,5), hold on %basal
n3_data_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        n3_data_basal = [n3_data_basal ; squeeze(figure7_res.stageDuration(p,substage_n3,:))'];
    end
end
n3_data_basal(n3_data_basal==0)=nan;
n3_data_basal = n3_data_basal / 1E4;

PlotErrorBarN_KJ(n3_data_basal, 'newfig',0,'barcolors',basal_colors,'ShowSigstar',show_signif_star,'y_lim',[0 3500]);
ylabel('N3 duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('Basal Sleep')


subplot(3,2,6), hold on %deltaTone
n3_data_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneAll')
        n3_data_tone = [n3_data_tone ; squeeze(figure7_res.stageDuration(p,substage_n3,:))'];
    end
end
n3_data_tone(n3_data_tone==0)=nan;
n3_data_tone = n3_data_tone / 1E4;

PlotErrorBarN_KJ(n3_data_tone, 'newfig',0,'barcolors',deltatone_colors,'ShowSigstar',show_signif_star,'y_lim',[0 3500]);
ylabel('N3 duration (s)'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('DeltaTone Sleep')







