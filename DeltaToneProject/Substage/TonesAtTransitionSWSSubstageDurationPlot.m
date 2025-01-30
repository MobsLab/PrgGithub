% TonesAtTransitionSWSSubstageDurationPlot
% 13.12.2016 KJ
%
% Plot correlograms concerning tones and transitions
% 
% 
%   see TonesAtTransitionSWSSubstageDuration TransitionToSWSDeltaTonePlot
%


clear
load([FolderProjetDelta 'Data/TonesAtTransitionSWSSubstageDuration.mat']) 

for p=1:length(tonesattransit_res.path) 
    if  strcmpi(tonesattransit_res.manipe{p},'Basal')
        tonesattransit_res.condition{p} = 'Sham';
    elseif strcmpi(tonesattransit_res.manipe{p},'RdmTone')
        tonesattransit_res.condition{p} = 'RdmTone';
    else
        tonesattransit_res.condition{p} = ['Tone-' num2str(tonesattransit_res.delay{p}*1E3)];
    end
end
conditions = unique(tonesattransit_res.condition);

%params
night_average=1;
NamesSubstages = {'N1','N2','N3','REM','Wake'};
conditionColors = {[0.75 0.75 0.75], 'k','r','r','r', 'r'};


%% Concatenate data
for cond=1:length(conditions)
    for sub1=substage_ind
        for sub2=substage_ind
            if sub1~=sub2
                post.success{cond,sub1,sub2} = [];
                post.failed{cond,sub1,sub2} = [];
                post.noevent{cond,sub1,sub2} = [];
                pre.success{cond,sub1,sub2} = [];
                pre.failed{cond,sub1,sub2} = [];
                pre.noevent{cond,sub1,sub2} = [];
                
                nb_post.success{cond,sub1,sub2} = 0;
                nb_post.failed{cond,sub1,sub2} = 0;
                nb_post.noevent{cond,sub1,sub2} = 0;
                nb_pre.success{cond,sub1,sub2} = 0;
                nb_pre.failed{cond,sub1,sub2} = 0;
                nb_pre.noevent{cond,sub1,sub2} = 0;
                
                for p=1:length(tonesattransit_res.path)
                    if strcmpi(tonesattransit_res.condition{p},conditions{cond})
                        %intervals
                        intv_post_success = tonesattransit_res.sub2.success.with{sub1,sub2,p};
                        intv_post.failed = tonesattransit_res.sub2.failed.with{sub1,sub2,p};
                        intv_post.noevent = tonesattransit_res.sub2.event.without{sub1,sub2,p};
                        
                        intv_pre.success = tonesattransit_res.sub1.success.with{sub1,sub2,p};
                        intv_pre.failed = tonesattransit_res.sub1.failed.with{sub1,sub2,p};
                        intv_pre.noevent = tonesattransit_res.sub1.event.without{sub1,sub2,p};
                        
                        %durations
                        if isempty(post.success{cond,sub1,sub2})
                            post.success{cond,sub1,sub2} = End(intv_post_success) - Start(intv_post_success);
                            post.failed{cond,sub1,sub2} = End(intv_post.failed) - Start(intv_post.failed);
                            post.noevent{cond,sub1,sub2} = End(intv_post.noevent) - Start(intv_post.noevent);
                            pre.success{cond,sub1,sub2} = End(intv_pre.success) - Start(intv_pre.success);
                            pre.failed{cond,sub1,sub2} = End(intv_pre.failed) - Start(intv_pre.failed);
                            pre.noevent{cond,sub1,sub2} = End(intv_pre.noevent) - Start(intv_pre.noevent);                        
                        else
                            post.success{cond,sub1,sub2} = [post.success{cond,sub1,sub2} ; End(intv_post_success) - Start(intv_post_success)];
                            post.failed{cond,sub1,sub2} = [post.failed{cond,sub1,sub2} ; End(intv_post.failed) - Start(intv_post.failed)];
                            post.noevent{cond,sub1,sub2} = [post.noevent{cond,sub1,sub2} ; End(intv_post.noevent) - Start(intv_post.noevent)];
                            pre.success{cond,sub1,sub2} = [pre.success{cond,sub1,sub2} ; End(intv_pre.success) - Start(intv_pre.success)];
                            pre.failed{cond,sub1,sub2} = [pre.failed{cond,sub1,sub2} ; End(intv_pre.failed) - Start(intv_pre.failed)];
                            pre.noevent{cond,sub1,sub2} = [pre.noevent{cond,sub1,sub2} ; End(intv_pre.noevent) - Start(intv_pre.noevent)];                        
                        end
                        %numbers
                        nb_post.success{cond,sub1,sub2} = nb_post.success{cond,sub1,sub2} + length(Start(intv_post_success));
                        nb_post.failed{cond,sub1,sub2} = nb_post.failed{cond,sub1,sub2} + length(Start(intv_post.failed));
                        nb_post.noevent{cond,sub1,sub2} = nb_post.noevent{cond,sub1,sub2} + length(Start(intv_post.noevent));
                        nb_pre.success{cond,sub1,sub2} = nb_pre.success{cond,sub1,sub2} + length(Start(intv_pre.success));
                        nb_pre.failed{cond,sub1,sub2} = nb_pre.failed{cond,sub1,sub2} + length(Start(intv_pre.failed));
                        nb_pre.noevent{cond,sub1,sub2} = nb_pre.noevent{cond,sub1,sub2} + length(Start(intv_pre.noevent));
                    end
                end
                
            end
            
        end
    end
end



%% PLOT

% Figure N2 N3
substage_transitions = [2 3; 3 2];

figure, hold on
for i=1:length(substage_transitions)
    clear data_post data_pre
    sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
    
    %Pre
    for cond=1:length(conditions)
        data_pre{cond} = pre.success{cond,sub1,sub2} / 10;
    end
    subplot(2,2,2*i-1), hold on
    PlotErrorBarN_KJ(data_pre,'newfig',0,'paired',0,'showPoints',0,'barcolors',conditionColors);
    title(['Pre-Substage duration: ' NamesSubstages{sub1} ' to ' NamesSubstages{sub2}]), ylabel('duration (ms)'), hold on
    set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions), 'XTickLabelRotation', 30), hold on,
    
    % Post
    for cond=1:length(conditions)
        data_post{cond} = post.success{cond,sub1,sub2} / 10;
    end
    subplot(2,2,2*i), hold on
    PlotErrorBarN_KJ(data_post,'newfig',0,'paired',0,'showPoints',0,'barcolors',conditionColors);
    title(['Post-Substage duration: ' NamesSubstages{sub1} ' to ' NamesSubstages{sub2}]), ylabel('duration'), hold on
    set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions), 'XTickLabelRotation', 30), hold on,
end
suplabel([NamesSubstages{sub1} ' and ' NamesSubstages{sub2}], 't')



  









