% FigureCoachFirstN3
% 30.03.2017 KJ
%
% plot the durations of the first N3 episode
%
%
% see 
%   ClinicEpisodeDurationPlot
%  


clear

%% load
load([FolderPrecomputeDreem 'ClinicEpisodeDuration.mat']) 
conditions = unique(quantity_res.condition);
subjects = unique(cell2mat(quantity_res.subject));

%params
colori = {'k','b',[0.1 0.15 0.1],'r'};
sst = 3;
min_duration = 90; %90s

%% data and plot - nights
figure, hold on

%on nights
% subplot(1,2,1), hold on
clear data
for cond=1:length(conditions)
    path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));
    for p=1:length(path_cond)
        n3_duration = quantity_res.duration{path_cond(p),sst};
        n3_duration = n3_duration(find(n3_duration>min_duration,1));
        data{cond}(p) = n3_duration;
    end
end
labels = conditions;
PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar','sig');
ylabel('Duration (s)'),
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
title('First N3 episode duration')
    

% %on subjects
% subplot(1,2,2), hold on
% data = nan(length(subjects), length(conditions));
% for s=1:length(subjects)
%     for cond=1:length(conditions)
%         selected_paths = find(strcmpi(quantity_res.condition,conditions{cond}) .* (cell2mat(quantity_res.subject)==subjects(s)));
%         subject_data = [];
% 
%         for p=1:length(selected_paths)
%             n3_duration = quantity_res.duration{selected_paths(p),sst};
%             subject_data = [subject_data n3_duration(find(n3_duration>min_duration,1))];
%         end
%         data(s,cond) = mean(subject_data);
%     end
% end
% labels = conditions;
% 
% PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar','sig');
% ylabel('Duration (s)'),
% set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
% title('On subjects (paired)')
% 
% %main title
% suplabel('First N3 episode duration', 't');











