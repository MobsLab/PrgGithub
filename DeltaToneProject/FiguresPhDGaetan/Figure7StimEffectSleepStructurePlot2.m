% Figure7StimEffectSleepStructurePlot2
% 05.12.2016 KJ
%
% Collect data to plot the figures from the Figure7.pdf (d-e) of Gaetan PhD
% 
% 
%   see Figure7StimEffectSleepStructure
%


clear
load([FolderProjetDelta 'Data/Figure7StimEffectSleepStructure.mat']) 

labels_sessions = {'S1','S2','S3','S4','S5'};


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot d
figure, hold on

%delta number
subplot(2,2,1),hold on
delta_nb_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        delta_nb_basal = [delta_nb_basal ; squeeze(figure7_res.delta.nb(p,:))];
    end
end
delta_nb_basal(delta_nb_basal==0)=nan;
delta_nb_basal(delta_nb_basal>5000)=nan;

PlotErrorBarN_KJ(delta_nb_basal, 'newfig',0,'y_lim',[0 5000]);
ylabel('Number of Delta waves'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('Basal Sleep')

subplot(2,2,2),hold on
delta_nb_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneALl')
        delta_nb_tone = [delta_nb_tone ; squeeze(figure7_res.delta.nb(p,:))];
    end
end
delta_nb_tone(delta_nb_tone==0)=nan;
delta_nb_tone(delta_nb_tone>5000)=nan;

PlotErrorBarN_KJ(delta_nb_tone, 'newfig',0,'y_lim',[0 6000]);
ylabel('Number of Delta waves'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('DeltaTone Sleep')


%delta density
subplot(2,2,3),hold on
delta_density_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        delta_density_basal = [delta_density_basal ; squeeze(figure7_res.delta.density(p,:))];
    end
end
delta_density_basal(delta_density_basal==0)=nan;
delta_density_basal(delta_density_basal>2)=nan;

PlotErrorBarN_KJ(delta_density_basal, 'newfig',0,'y_lim',[0 2.5]);
ylabel('Delta waves frequency'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,

subplot(2,2,4),hold on
delta_density_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneALl')
        delta_density_tone = [delta_density_tone ; squeeze(figure7_res.delta.density(p,:))];
    end
end
delta_density_tone(delta_density_tone==0)=nan;
delta_density_tone(delta_density_tone>2)=nan;

PlotErrorBarN_KJ(delta_density_tone, 'newfig',0,'y_lim',[0 3]);
ylabel('Delta waves frequency'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot e
labels_sessions = {'S1','S2','S3','S4','S5'};

figure, hold on

%ripples number
subplot(2,2,1),hold on
ripples_nb_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        ripples_nb_basal = [ripples_nb_basal ; squeeze(figure7_res.ripples.nb(p,:))];
    end
end
ripples_nb_basal(ripples_nb_basal==0)=nan;
ripples_nb_basal(ripples_nb_basal>2000)=nan;

PlotErrorBarN_KJ(ripples_nb_basal, 'newfig',0);
ylabel('Number of SPW-Rs'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('Basal Sleep')

subplot(2,2,2),hold on
ripples_nb_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneALl')
        ripples_nb_tone = [ripples_nb_tone ; squeeze(figure7_res.ripples.nb(p,:))];
    end
end
ripples_nb_tone(ripples_nb_tone==0)=nan;
ripples_nb_tone(ripples_nb_tone>2000)=nan;

PlotErrorBarN_KJ(ripples_nb_tone, 'newfig',0);
ylabel('Number of SPW-Rs'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('DeltaTone Sleep')


%ripples density
subplot(2,2,3),hold on
ripples_density_basal = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'Basal')
        ripples_density_basal = [ripples_density_basal ; squeeze(figure7_res.ripples.density(p,:))];
    end
end
ripples_density_basal(ripples_density_basal==0)=nan;
ripples_density_basal(ripples_density_basal>0.8)=nan;

PlotErrorBarN_KJ(ripples_density_basal, 'newfig',0);
ylabel('SPW-Rs frequency'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,

subplot(2,2,4),hold on
ripples_density_tone = [];
for p=1:length(figure7_res.path)
    if strcmpi(figure7_res.manipe{p}, 'DeltaToneALl')
        ripples_density_tone = [ripples_density_tone ; squeeze(figure7_res.ripples.density(p,:))];
    end
end
ripples_density_tone(ripples_density_tone==0)=nan;
ripples_density_tone(ripples_density_tone>0.8)=nan;

PlotErrorBarN_KJ(ripples_density_tone, 'newfig',0);
ylabel('SPW-Rs frequency'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot d -bis (FOR DOWN STATES)
Down_Dir = PathForExperimentsDeltaSleepSpikes('Basal');
down_paths_basal = unique(Down_Dir.path);
Down_Dir = PathForExperimentsDeltaSleepSpikes('DeltaToneAll');
down_paths_deltatone = unique(Down_Dir.path);

figure, hold on

%down number
subplot(2,2,1),hold on
down_nb_basal = [];
for p=1:length(figure7_res.path)
    if ismember(figure7_res.path{p}, down_paths_basal)
        down_nb_basal = [down_nb_basal ; squeeze(figure7_res.down.nb(p,:))];
    end
end
down_nb_basal(down_nb_basal==0)=nan;
%down_nb_basal(down_nb_basal>5000)=nan;

PlotErrorBarN_KJ(down_nb_basal, 'newfig',0,'y_lim',[0 5000]);
ylabel('Number of Down states'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('Basal Sleep')

subplot(2,2,2),hold on
down_nb_tone = [];
for p=1:length(figure7_res.path)
    if ismember(figure7_res.path{p}, down_paths_deltatone)
        down_nb_tone = [down_nb_tone ; squeeze(figure7_res.down.nb(p,:))];
    end
end
down_nb_tone(down_nb_tone==0)=nan;
%down_nb_tone(down_nb_tone>5000)=nan;

PlotErrorBarN_KJ(down_nb_tone, 'newfig',0,'y_lim',[0 16000]);
ylabel('Number of Down states'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,
title('deltaTone Sleep')


%down density
subplot(2,2,3),hold on
down_density_basal = [];
for p=1:length(figure7_res.path)
    if ismember(figure7_res.path{p}, down_paths_basal)
        down_density_basal = [down_density_basal ; squeeze(figure7_res.down.density(p,:))];
    end
end
down_density_basal(down_density_basal==0)=nan;
%down_density_basal(down_density_basal>2)=nan;

PlotErrorBarN_KJ(down_density_basal, 'newfig',0,'y_lim',[0 3]);
ylabel('Down states frequency'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,

subplot(2,2,4),hold on
down_density_tone = [];
for p=1:length(figure7_res.path)
    if ismember(figure7_res.path{p}, down_paths_deltatone)
        down_density_tone = [down_density_tone ; squeeze(figure7_res.down.density(p,:))];
    end
end
down_density_tone(down_density_tone==0)=nan;
%down_density_tone(down_density_tone>2)=nan;

PlotErrorBarN_KJ(down_density_tone, 'newfig',0,'y_lim',[0 3]);
ylabel('Down states frequency'),
set(gca, 'XTickLabel',labels_sessions, 'XTick',1:numel(labels_sessions)), hold on,


