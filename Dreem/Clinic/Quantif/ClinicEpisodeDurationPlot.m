% ClinicEpisodeDurationPlot
% 30.03.2017 KJ
%
% duration of each sleep stage episode - Here we plot
% 
% 
%   see ClinicQuantitySleepPlot ClinicEpisodeDuration
%


clear

%% load
load([FolderPrecomputeDreem 'ClinicEpisodeDuration.mat']) 
conditions = unique(quantity_res.condition);
subjects = unique(cell2mat(quantity_res.subject));

%params
colori = {'k','b',[0.1 0.15 0.1],'r'};


%% data and plot - nights

figure, hold on
for sst=sleepstage_ind
    clear data
    for cond=1:length(conditions)
        path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));
        for p=1:length(path_cond)
            data{cond}(p) = nanmean(quantity_res.duration{path_cond(p),sst});
        end
    end
    labels = conditions;

    subplot(2,3,sst), hold on
    PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar','sig');
    ylabel('Duration (s)'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
    title(NameStages{sst})

end
suplabel('Mean Episode Duration', 't');


%% data and plot - subjects
figure, hold on
for sst=sleepstage_ind
    data = nan(length(subjects), length(conditions));
    for s=1:length(subjects)
        for cond=1:length(conditions)
            selected_paths = find(strcmpi(quantity_res.condition,conditions{cond}) .* (cell2mat(quantity_res.subject)==subjects(s)));
            subject_data = [];

            for p=1:length(selected_paths)
                subject_data = [subject_data nanmean(quantity_res.duration{selected_paths(p),sst})];
            end
            data(s,cond) = mean(subject_data);
        end
    end
    labels = conditions;
    
    subplot(2,3,sst), hold on
    PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar','sig');
    ylabel('Duration (s)'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
    title(NameStages{sst})

end
suplabel('Mean Episode Duration (by subjects)', 't');




