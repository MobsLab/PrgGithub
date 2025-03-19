% CorrelogramDeltaToneTransitionSubPlot
% 13.12.2016 KJ
%
% Plot correlograms concerning tones and transitions
% - the origin is the tone/sham event
% 
%   see CorrelogramDeltaToneTransitionSub TransitionToSWSDeltaTonePlot
%


clear
load([FolderProjetDelta 'Data/CorrelogramDeltaToneTransitionSub.mat']) 

for p=1:length(correlo_res.path) 
    if  strcmpi(correlo_res.manipe{p},'Basal')
        correlo_res.condition{p} = 'Basal';
    elseif strcmpi(correlo_res.manipe{p},'RdmTone')
        correlo_res.condition{p} = 'RdmTone';
    else
        correlo_res.condition{p} = ['DeltaTone-' num2str(correlo_res.delay{p}*1E3)];
    end
end

animals = unique(correlo_res.name); %Mice
conditions = unique(correlo_res.condition); %Conditions

%params
weighted_average=1;
NamesSubstages = {'N1','N2','N3','REM','Wake'};
conditionColors = {[0.75 0.75 0.75], 'b','r','k','m', 'g'};
conditionLegends = {'Sham', 'Delta 140', 'Delta 200', 'Delta 320', 'Delta 490', 'Random'};


%% Concatenate data
for cond=1:length(conditions)
    for sub1=substage_ind
        for sub2=substage_ind
            if sub1~=sub2
                Cc_all = [];
                Cc_all_success = [];
                Cc_all_failed = [];
                nb_events = 0;
                for p=1:length(correlo_res.path)
                    if strcmpi(correlo_res.condition{p},conditions{cond})
                        if weighted_average==1
                            coeff = correlo_res.nb_events{p};
                        else
                            coeff = 1;
                        end
                        
                        if isempty(Cc_all)
                            Cc_all = Data(correlo_res.correlograms{p}{sub1,sub2});
                            Cc_all_success = Data(correlo_res.correlo_success{p}{sub1,sub2});
                            Cc_all_failed = Data(correlo_res.correlo_failed{p}{sub1,sub2});
                        else
                            Cc_all = Cc_all + Data(correlo_res.correlograms{p}{sub1,sub2});
                            Cc_all_success = Cc_all_success + Data(correlo_res.correlo_success{p}{sub1,sub2});
                            Cc_all_failed = Cc_all_failed + Data(correlo_res.correlo_failed{p}{sub1,sub2});
                        end
                            
                        nb_events = nb_events + coeff;
                        Cc_times = Range(correlo_res.correlograms{p}{sub1,sub2});
                        
                    end
                end
               
                Cc_substage_tone{cond,sub1,sub2} = Cc_all / nb_events;
                Cc_substage_success{cond,sub1,sub2} = Cc_all_success / nb_events;
                Cc_substage_failed{cond,sub1,sub2} = Cc_all_failed / nb_events;
                nb_events_averagedOn{cond,sub1,sub2} = nb_events;
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
conditions_plot = 1:6;
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
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Failed tones (n=' num2str(nb_events_averagedOn{cond,sub1,sub2}) ' tones)'])
    %success
    subplot(2,2,i+2), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_success{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Success tones (n=' num2str(nb_events_averagedOn{cond,sub1,sub2}) ' tones)'])
end
suplabel('Correlogram transitions compared to tones','t');


% Figure N2 N3
substage_transitions = [2 3; 3 2];
smoothing = 1;

for cond=2:5
    figure, hold on
    for i=1:length(substage_transitions)
        sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
        %failed
        subplot(2,2,i), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{1,sub1,sub2},smoothing),'color',[0.75 0.75 0.75]), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{cond,sub1,sub2},smoothing),'color','b'), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{6,sub1,sub2},smoothing),'color','r'), hold on
        legend(conditionLegends([1 cond 6])), hold on
        line([0 0],ylim), hold on
        title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Failed tones (n=' num2str(nb_events_averagedOn{cond,sub1,sub2}) ' tones)'])
        %success
        subplot(2,2,i+2), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_success{1,sub1,sub2},smoothing),'color',[0.75 0.75 0.75]), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_success{cond,sub1,sub2},smoothing),'color','b'), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_success{6,sub1,sub2},smoothing),'color','r'), hold on
        legend(conditionLegends([1 cond 6])), hold on
        line([0 0],ylim), hold on
        title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Success tones (n=' num2str(nb_events_averagedOn{cond,sub1,sub2}) ' tones)'])
    end
    suplabel('Correlogram transitions compared to tones','t');
end

% Figure N1 N2
substage_transitions = [1 2; 2 1];
conditions_plot = 1:6;
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
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Failed tones (n=' num2str(nb_events_averagedOn{cond,sub1,sub2}) ' tones)'])
    %success
    subplot(2,2,i+2), hold on
    for cond=conditions_plot
        plot(Cc_times/1E4,Smooth(Cc_substage_success{cond,sub1,sub2},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([0 0],ylim), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Success tones (n=' num2str(nb_events_averagedOn{cond,sub1,sub2}) ' tones)'])
end
suplabel('Correlogram transitions compared to tones','t');


% Figure N1 N2
substage_transitions = [1 2; 2 1];
smoothing = 1;

for cond=2:5
    figure, hold on
    for i=1:length(substage_transitions)
        sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
        %failed
        subplot(2,2,i), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{1,sub1,sub2},smoothing),'color',[0.75 0.75 0.75]), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{cond,sub1,sub2},smoothing),'color','b'), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{6,sub1,sub2},smoothing),'color','r'), hold on
        legend(conditionLegends([1 cond 6])), hold on
        line([0 0],ylim), hold on
        title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Failed tones (n=' num2str(nb_events_averagedOn{cond,sub1,sub2}) ' tones)'])
        %success
        subplot(2,2,i+2), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_success{1,sub1,sub2},smoothing),'color',[0.75 0.75 0.75]), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_success{cond,sub1,sub2},smoothing),'color','b'), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_success{6,sub1,sub2},smoothing),'color','r'), hold on
        legend(conditionLegends([1 cond 6])), hold on
        line([0 0],ylim), hold on
        title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Success tones (n=' num2str(nb_events_averagedOn{cond,sub1,sub2}) ' tones)'])
    end
    suplabel('Correlogram transitions compared to tones','t');
end
