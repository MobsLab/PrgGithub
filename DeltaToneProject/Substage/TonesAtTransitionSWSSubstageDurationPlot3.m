% TonesAtTransitionSWSSubstageDurationPlot3
% 13.12.2016 KJ
%
% Plot correlograms concerning tones and transitions
% 
% 
%   see TonesAtTransitionSWSSubstageDuration  TonesAtTransitionSWSSubstageDuration_bis1
%
%


clear
load([FolderProjetDelta 'Data/TonesAtTransitionSWSSubstageDuration_bis1.mat']) 


%% PLOT

% Figure N2 N3, with all delay
substage_transitions = [2 3; 3 2];

figure, hold on
for i=1:length(substage_transitions)
    clear data_post data_pre
    sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
    
    %Pre
    data_pre{cond_basal} = pre.all{cond_basal,sub1,sub2} / 10;
    for cond=1:length(conditions)
        if cond ~= cond_basal
            data_pre{cond} = pre.success{cond,sub1,sub2} / 10;
        end
    end
    subplot(2,2,2*i-1), hold on
    PlotErrorBarN_KJ(data_pre,'newfig',0,'paired',0,'showPoints',0,'barcolors',conditionColors);
    title(['Pre-Substage duration: ' NamesSubstages{sub1} ' to ' NamesSubstages{sub2}]), ylabel('duration (ms)'), hold on
    set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions), 'XTickLabelRotation', 30), hold on,
    
    % Post
    data_post{cond_basal} = post.all{cond_basal,sub1,sub2} / 10;
    for cond=1:length(conditions)
        if cond ~= cond_basal
            data_post{cond} = post.success{cond,sub1,sub2} / 10;
        end
    end
    subplot(2,2,2*i), hold on
    PlotErrorBarN_KJ(data_post,'newfig',0,'paired',0,'showPoints',0,'barcolors',conditionColors);
    title(['Post-Substage duration: ' NamesSubstages{sub1} ' to ' NamesSubstages{sub2}]), ylabel('duration'), hold on
    set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions), 'XTickLabelRotation', 30), hold on,
end
suplabel([NamesSubstages{sub1} ' and ' NamesSubstages{sub2}], 't');



% Figure N2 N3, one figure by delay
substage_transitions = [2 3; 3 2];

for cond=1:length(conditions)
    if cond ~= cond_basal & cond ~= cond_random
        labels = conditions(cond_basal);
        labels{end+1} = [conditions{cond} ' - tones at transition'];
        labels{end+1} = [conditions{cond} ' - natural transition'];
        barcolors = conditionColors([cond_basal cond]); 
        barcolors{end+1} = 'r';
        
        figure, hold on
        for i=1:length(substage_transitions)
            clear data_post data_pre
            sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
            
            %Pre
            data_pre{cond_basal} = pre.all{cond_basal,sub1,sub2} / 10;
            data_pre{end+1} = pre.success{cond,sub1,sub2} / 10;
            data_pre{end+1} = pre.no_event{cond,sub1,sub2} / 10;
            %Post
            data_post{cond_basal} = post.all{cond_basal,sub1,sub2} / 10;
            data_post{end+1} = post.success{cond,sub1,sub2} / 10;
            data_post{end+1} = post.no_event{cond,sub1,sub2} / 10;
            
            %plot pre
            subplot(2,2,2*i-1), hold on
            PlotErrorBarN_KJ(data_pre,'newfig',0,'paired',0,'showPoints',0,'barcolors',barcolors);
            title(['Pre-Substage duration: ' NamesSubstages{sub1} ' to ' NamesSubstages{sub2}]), ylabel('duration (ms)'), hold on
            set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
            
            %plot post
            subplot(2,2,2*i), hold on
            PlotErrorBarN_KJ(data_post,'newfig',0,'paired',0,'showPoints',0,'barcolors',barcolors);
            title(['Post-Substage duration: ' NamesSubstages{sub1} ' to ' NamesSubstages{sub2}]), ylabel('duration (ms)'), hold on
            set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,

        end
        suplabel([NamesSubstages{sub1} ' and ' NamesSubstages{sub2} ' - ' conditions{cond}], 't');
    end
end











