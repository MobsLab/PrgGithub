% TonesAtTransitionSWSSubstageDurationPlot4
% 14.12.2016 KJ
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


% Figure N2 N3, one figure by delay
substage_transitions = [2 3; 3 2];
columntest = [1 3; 1 5; 3 5];
columntest = [columntest;columntest+1];

for cond=1:length(conditions)
    if cond ~= cond_basal && cond ~= cond_random
        labels = cell(0);
        labels{end+1} = conditions{cond_basal};
        labels{end+1} = [conditions{cond} ' - tones at transition'];
        labels{end+1} = [conditions{cond} ' - natural transition']; 
        
        barcolors = conditionColors([cond_basal cond_basal cond cond]); 
        barcolors{end+1} = 'r'; barcolors{end+1} = 'r';
        
        % plot
        figure, hold on
        for i=1:length(substage_transitions)
            clear data_post data_pre
            sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
            
            data_pre = cell(0); data_post = cell(0);
            %Pre
            data_pre{end+1} = -pre.all{cond_basal,sub1,sub2} / 10;
            data_pre{end+1} = -pre.success{cond,sub1,sub2} / 10;
            data_pre{end+1} = -pre.no_event{cond,sub1,sub2} / 10;
            %Post
            data_post{end+1} = post.all{cond_basal,sub1,sub2} / 10;
            data_post{end+1} = post.success{cond,sub1,sub2} / 10;
            data_post{end+1} = post.no_event{cond,sub1,sub2} / 10;
            
            
            %mix
            all_data = cell(0);
            for dp = 1:length(data_pre)
                all_data{end+1} = data_pre{dp};
                all_data{end+1} = data_post{dp};
            end
            
            %plot pre
            subplot(2,1,i), hold on
            PlotErrorBarN_KJ(all_data,'newfig',0,'horizontal',1,'paired',0,'showPoints',0,'barcolors',barcolors, 'columntest', columntest);
            title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2}]), xlabel('duration (ms)'), hold on
            set(gca, 'YTickLabel',labels, 'YTick',[1.5 3.5 5.5]), hold on,

        end
        suplabel([NamesSubstages{sub2} ' <> ' NamesSubstages{sub1} ' - ' conditions{cond}], 't');
    end
end


% Figure N2 N3, one figure by delay
substage_transitions = [2 3; 3 2];
columntest = nchoosek(1:2:8,2);
columntest = [columntest;columntest+1];

for cond=1:length(conditions)
    if cond ~= cond_basal && cond ~= cond_random
        labels = cell(0);
        labels{end+1} = conditions{cond_random};
        labels{end+1} = conditions{cond_basal};
        labels{end+1} = [conditions{cond} ' - tones at transition'];
        labels{end+1} = [conditions{cond} ' - natural transition']; 
        
        barcolors = conditionColors([cond_random cond_random cond_basal cond_basal cond cond]); 
        barcolors{end+1} = 'r'; barcolors{end+1} = 'r';
        
        % plot
        figure, hold on
        for i=1:length(substage_transitions)
            clear data_post data_pre
            sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
            
            data_pre = cell(0); data_post = cell(0);
            %Pre
            data_pre{end+1}  = -pre.success{cond_random,sub1,sub2} / 10;
            data_pre{end+1} = -pre.all{cond_basal,sub1,sub2} / 10;
            data_pre{end+1} = -pre.success{cond,sub1,sub2} / 10;
            data_pre{end+1} = -pre.no_event{cond,sub1,sub2} / 10;
            %Post
            data_post{end+1} = post.success{cond_random,sub1,sub2} / 10;
            data_post{end+1} = post.all{cond_basal,sub1,sub2} / 10;
            data_post{end+1} = post.success{cond,sub1,sub2} / 10;
            data_post{end+1} = post.no_event{cond,sub1,sub2} / 10;
            
            
            %mix
            all_data = cell(0);
            for dp = 1:length(data_pre)
                all_data{end+1} = data_pre{dp};
                all_data{end+1} = data_post{dp};
            end
            
            %plot pre
            subplot(2,1,i), hold on
            PlotErrorBarN_KJ(all_data,'newfig',0,'horizontal',1,'paired',0,'showPoints',0,'barcolors',barcolors, 'columntest', columntest);
            title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2}]), xlabel('duration (ms)'), hold on
            set(gca, 'YTickLabel',labels, 'YTick',[1.5 3.5 5.5 7.5]), hold on,

        end
        suplabel([NamesSubstages{sub2} ' <> ' NamesSubstages{sub1} ' - ' conditions{cond}], 't');
    end
end



























% 
% % Figure N2 N3, with all delay
% substage_transitions = [2 3; 3 2];
% 
% figure, hold on
% for i=1:length(substage_transitions)
%     clear data_post data_pre
%     sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
%     
%     %Pre
%     data_pre{cond_basal} = -pre.all{cond_basal,sub1,sub2} / 10;
%     for cond=1:length(conditions)
%         if cond ~= cond_basal
%             data_pre{cond} = -pre.event{cond,sub1,sub2} / 10;
%         end
%     end
%     subplot(2,2,2*i-1), hold on
%     PlotErrorBarN_KJ(data_pre,'newfig',0,'horizontal',1,'paired',0,'showPoints',0,'barcolors',conditionColors, 'ShowSigstar','none');
%     title(['Pre-Substage duration: ' NamesSubstages{sub1}]), xlabel('duration (ms)'), hold on
%     set(gca, 'YTickLabel',conditions, 'YTick',1:numel(conditions)), hold on,
%     
%     % Post
%     data_post{cond_basal} = -post.all{cond_basal,sub1,sub2} / 10;
%     for cond=1:length(conditions)
%         if cond ~= cond_basal
%             data_post{cond} = -post.event{cond,sub1,sub2} / 10;
%         end
%     end
%     subplot(2,2,2*i), hold on
%     PlotErrorBarN_KJ(data_post,'newfig',0,'horizontal',1,'paired',0,'showPoints',0,'barcolors',conditionColors, 'ShowSigstar','none');
%     title(['Post-Substage duration: ' NamesSubstages{sub2}]), xlabel('duration'), hold on
%     set(gca, 'YTickLabel',''), hold on,
% end
% suplabel([NamesSubstages{sub1} ' <> ' NamesSubstages{sub2}], 't');
% 






