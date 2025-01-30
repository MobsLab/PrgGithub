% TransitionToSWSDeltaTonePlot2
% 13.12.2016 KJ
%
% Plot correlograms concerning tones and transitions
% 
% 
%   see TransitionToSWSDeltaTone TransitionToSWSDeltaTonePlot
%


clear
load([FolderProjetDelta 'Data/TransitionToSWSDeltaTone.mat']) 

conditions = unique(transition_res.manipe);

%params
weighted_average=1;
NamesSubstages = {'N1','N2','N3','REM','Wake'};
conditionColors = {[0.75 0.75 0.75], 'b', 'r'};
conditionLegends = {'Sham', 'Delta Triggered Tone', 'Random Tone'};


%% Concatenate data
for cond=1:length(conditions)
    for sub1=substage_ind
        for sub2=substage_ind
            if sub1~=sub2
                Cc_all = [];
                Cc_all_success = [];
                Cc_all_failed = [];
                nb_transitions = 0;
                for p=1:length(transition_res.path)
                    if strcmpi(transition_res.manipe{p},conditions{cond})
                        if weighted_average==1
                            coeff = transition_res.nb_transitions{p}{sub1,sub2};
                        else
                            coeff = 1;
                        end
                        
                        if isempty(Cc_all)
                            Cc_all = Data(transition_res.correlograms{p}{sub1,sub2});
                            Cc_all_success = Data(transition_res.correlo_success{p}{sub1,sub2});
                            Cc_all_failed = Data(transition_res.correlo_failed{p}{sub1,sub2});
                        else
                            Cc_all = Cc_all + Data(transition_res.correlograms{p}{sub1,sub2});
                            Cc_all_success = Cc_all_success + Data(transition_res.correlo_success{p}{sub1,sub2});
                            Cc_all_failed = Cc_all_failed + Data(transition_res.correlo_failed{p}{sub1,sub2});
                        end
                            
                        nb_transitions = nb_transitions + coeff;
                        Cc_times = Range(transition_res.correlograms{p}{sub1,sub2});
                        
                    end
                end
               
                Cc_substage_tone{cond,sub1,sub2} = Cc_all / nb_transitions;
                Cc_substage_success{cond,sub1,sub2} = Cc_all_success / nb_transitions;
                Cc_substage_failed{cond,sub1,sub2} = Cc_all_failed / nb_transitions;
                nb_transitions_averagedOn{cond,sub1,sub2} = nb_transitions;
            end
        end
    end
end


% %% Data are between 0 and 1
% for cond=1:length(conditions)
%     for sub1=substage_ind
%         for sub2=substage_ind
%             if sub1~=sub2
%                 Cc_substage_tone{cond,sub1,sub2} = Cc_substage_tone{cond,sub1,sub2} / max(Cc_substage_tone{cond,sub1,sub2});
%                 Cc_substage_success{cond,sub1,sub2} = Cc_substage_success{cond,sub1,sub2} / max(Cc_substage_success{cond,sub1,sub2});
%                 Cc_substage_failed{cond,sub1,sub2} = Cc_substage_failed{cond,sub1,sub2} / max(Cc_substage_failed{cond,sub1,sub2});
%             end
%         end
%     end
% end


%% PLOT

% Figure N2 N3
substage_transitions = [2 3; 3 2];
conditions_plot = [2 3];
smoothing = 1;

figure, hold on
for i=1:length(substage_transitions)
    sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
    %failed
    subplot(2,2,i), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Failed tones (n=' num2str(nb_transitions_averagedOn{cond,sub1,sub2}) ' transitions)'])
    %success
    subplot(2,2,i+2), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_success{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Success tones (n=' num2str(nb_transitions_averagedOn{cond,sub1,sub2}) ' transitions)'])
end
suplabel([conditions{2} ' and ' conditions{3}],'t');



% Figure N2 N3 with Sham
substage_transitions = [2 3; 3 2];
conditions_plot = [1 2 3];
smoothing = 1;

figure, hold on
for i=1:length(substage_transitions)
    sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
    %failed
    subplot(2,2,i), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Failed tones (n=' num2str(nb_transitions_averagedOn{cond,sub1,sub2}) ' transitions)'])
    %success
    subplot(2,2,i+2), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_success{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Success tones (n=' num2str(nb_transitions_averagedOn{cond,sub1,sub2}) ' transitions)'])
end
suplabel([conditionLegends{1} ', ' conditionLegends{2} ' and ' conditionLegends{3}],'t');


% Figure N2 N3
substage_transitions = [1 2; 2 1];
conditions_plot = [2 3];
smoothing = 1;

figure, hold on
for i=1:length(substage_transitions)
    sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
    %failed
    subplot(2,2,i), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Failed tones (n=' num2str(nb_transitions_averagedOn{cond,sub1,sub2}) ' transitions)'])
    %success
    subplot(2,2,i+2), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_success{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Success tones (n=' num2str(nb_transitions_averagedOn{cond,sub1,sub2}) ' transitions)'])
end
suplabel([conditions{2} ' and ' conditions{3}],'t');



% Figure N2 N3 with Sham
substage_transitions = [1 2; 2 1];
conditions_plot = [1 2 3];
smoothing = 1;

figure, hold on
for i=1:length(substage_transitions)
    sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
    %failed
    subplot(2,2,i), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Failed tones (n=' num2str(nb_transitions_averagedOn{cond,sub1,sub2}) ' transitions)'])
    %success
    subplot(2,2,i+2), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_success{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Success tones (n=' num2str(nb_transitions_averagedOn{cond,sub1,sub2}) ' transitions)'])
end
suplabel([conditionLegends{1} ', ' conditionLegends{2} ' and ' conditionLegends{3}],'t');

