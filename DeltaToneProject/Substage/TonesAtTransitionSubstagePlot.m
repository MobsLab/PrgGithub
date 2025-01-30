% TonesAtTransitionSubstagePlot
% 13.12.2016 KJ
%
% Plot correlograms concerning tones and transitions
% 
% 
%   see TonesAtTransitionSubstage
%


clear
load([FolderProjetDelta 'Data/TonesAtTransitionSubstage.mat']) 

conditions = unique(tonetransit_res.manipe);

%params
NamesSubstages = {'N1','N2','N3','REM','Wake'};
conditionColors = {[0.75 0.75 0.75], 'b', 'r'};
conditionLegends = {'Sham', 'Delta Triggered Tone', 'Random Tone'};



%% Concatenate data
for cond=1:length(conditions)
    for sub1=substage_ind
        for sub2=substage_ind
            if sub1~=sub2
                delay_success = [];
                delay_failed = [];
                for p=1:length(tonetransit_res.path)
                    if strcmpi(tonetransit_res.manipe{p},conditions{cond})
                        if isempty(delay_success)
                            delay_success = tonetransit_res.delay_success{p}{sub1,sub2};
                            delay_failed = tonetransit_res.delay_failed{p}{sub1,sub2};
                        else
                            delay_success = [delay_success ; tonetransit_res.delay_success{p}{sub1,sub2}];
                            delay_failed = [delay_failed ; tonetransit_res.delay_failed{p}{sub1,sub2}];
                        end
                    end
                end
                delay.success{cond,sub1,sub2} = delay_success;
                delay.failed{cond,sub1,sub2} = delay_failed;
            end
        end
    end
end


%% histograms
step = 50;
max_edge = 12000;
edges = 0:step:max_edge;
for cond=1:length(conditions)
    for sub1=substage_ind
        for sub2=substage_ind
            if sub1~=sub2
                for idx=1:nb_tone_before_transit
                    %SUCCESS
                    delay_data = delay.success{cond,sub1,sub2}(:,idx);
                    %median
                    stat.median.success{cond,sub1,sub2,idx} = median(delay_data(delay_data/10<max_edge))/10;
                    stat.mode.success{cond,sub1,sub2,idx} = mode(delay_data(delay_data/10<max_edge))/10;
                    stat.mean.success{cond,sub1,sub2,idx} = mean(delay_data(delay_data/10<max_edge))/10;
                    %histo
                    h = histogram(delay_data/10, edges,'Normalization','probability');
                    stat.histo.success.x{cond,sub1,sub2,idx} = h.BinEdges(2:end) - step/2;
                    stat.histo.success.y{cond,sub1,sub2,idx} = h.Values;
                    
                    %FAILED
                    delay_data = delay.failed{cond,sub1,sub2}(:,idx);
                    %median
                    stat.median.failed{cond,sub1,sub2,idx} = median(delay_data(delay_data/10<max_edge))/10;
                    stat.mode.failed{cond,sub1,sub2,idx} = mode(delay_data(delay_data/10<max_edge))/10;
                    stat.mean.failed{cond,sub1,sub2,idx} = mean(delay_data(delay_data/10<max_edge))/10;
                    %histo
                    h = histogram(delay_data/10, edges,'Normalization','probability');
                    stat.histo.failed.x{cond,sub1,sub2,idx} = h.BinEdges(2:end) - step/2;
                    stat.histo.failed.y{cond,sub1,sub2,idx} = h.Values;
                    close;
                end
            end
        end
    end
end



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
        plot(stat.histo.failed.x{cond,sub1,sub2,1}/1E3,Smooth(stat.histo.failed.y{cond,sub1,sub2,1},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([stat.median.failed{cond,sub1,sub2,1} stat.median.failed{cond,sub1,sub2,1}],get(gca,'YLim'), 'color', conditionColors{cond}), hold on
    
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Failed tones '])
    
    %success
    subplot(2,2,i+2), hold on
    for cond=conditions_plot
        plot(stat.histo.success.x{cond,sub1,sub2,1}/1E3,Smooth(stat.histo.success.y{cond,sub1,sub2,1},smoothing),'color',conditionColors{cond}), hold on
    end
    legend(conditionLegends(conditions_plot)), hold on
    line([stat.median.success{cond,sub1,sub2,1} stat.median.success{cond,sub1,sub2,1}],get(gca,'YLim'), 'color', conditionColors{cond}), hold on
    title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2} ' - Success tones'])
end
suplabel([conditions{2} ' and ' conditions{3}],'t');



