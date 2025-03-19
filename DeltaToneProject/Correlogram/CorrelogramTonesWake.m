% CorrelogramTonesWake
% 06.02.2017 KJ
%
% Collect data to study the impact of tones on arousals
% 
% 
%   see
%


clear
load([FolderProjetDelta 'Data/TransitionToSWSDeltaTone.mat']) 

conditions = unique(transition_res.manipe);

%params
weighted_average=1;
NamesSubstages = {'N1','N2','N3','REM','Wake','NREM'};



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
            end
        end
    end
end



%% PLOT
substage_transitions = [1 5; 2 5;3 5;6 5;4 5];
smoothing = 0;
%all events
for cond=1:length(conditions)
    figure, hold on
    for i=1:length(substage_transitions)
        sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
        subplot(2,3,i), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_tone{cond,sub1,sub2},smoothing),'k')
        line([0 0],ylim), hold on
        title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2}])
    end
    suplabel(conditions{cond},'t');
end
%success events
for cond=1:length(conditions)
    figure, hold on
    for i=1:length(substage_transitions)
        sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
        subplot(2,3,i), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_success{cond,sub1,sub2},smoothing),'k')
        line([0 0],ylim), hold on
        title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2}])
    end
    suplabel([conditions{cond} ' - success events'],'t');
end
%failed events
for cond=1:length(conditions)
    figure, hold on
    for i=1:length(substage_transitions)
        sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
        subplot(2,3,i), hold on
        plot(Cc_times/1E4,Smooth(Cc_substage_failed{cond,sub1,sub2},smoothing),'k')
        line([0 0],ylim), hold on
        title([NamesSubstages{sub1} ' to ' NamesSubstages{sub2}])
    end
    suplabel([conditions{cond} ' - failed events'],'t');
end


