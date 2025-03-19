% TonesAtTransitionSWSSubstageDurationPlot2
% 13.12.2016 KJ
%
% Plot correlograms concerning tones and transitions
% 
% 
%   see TonesAtTransitionSWSSubstageDuration TonesAtTransitionSWSSubstageDurationPlot
%


clear
load([FolderProjetDelta 'Data/TonesAtTransitionSWSSubstageDuration.mat']) 

for p=1:length(tonesattransit_res.path) 
    if  strcmpi(tonesattransit_res.manipe{p},'Basal')
        tonesattransit_res.condition{p} = 'Basal';
    elseif strcmpi(tonesattransit_res.manipe{p},'RdmTone')
        tonesattransit_res.condition{p} = 'RdmTone';
    else
        tonesattransit_res.condition{p} = ['Tone-' num2str(tonesattransit_res.delay{p}*1E3)];
    end
end
conditions = unique(tonesattransit_res.condition);
cond_basal = find(strcmpi(conditions,'Basal'));
cond_random = find(strcmpi(conditions,'RdmTone'));


%params
night_average=1;
NamesSubstages = {'N1','N2','N3','REM','Wake'};
conditionColors = {[0.75 0.75 0.75], 'k','b','b','b', 'b'};


%% Concatenate data
%Tone
for cond=1:length(conditions)
    if cond ~= cond_basal
        for sub1=substage_ind
            for sub2=substage_ind
                if sub1~=sub2
                    post.success{cond,sub1,sub2} = [];
                    pre.success{cond,sub1,sub2} = [];
                    post.other{cond,sub1,sub2} = [];
                    pre.other{cond,sub1,sub2} = [];

                    nb_post.success{cond,sub1,sub2} = 0;
                    nb_pre.success{cond,sub1,sub2} = 0;
                    nb_post.other{cond,sub1,sub2} = 0;
                    nb_pre.other{cond,sub1,sub2} = 0;

                    for p=1:length(tonesattransit_res.path)
                        if strcmpi(tonesattransit_res.condition{p},conditions{cond})
                            %intervals
                            intv_post.success = tonesattransit_res.sub2.success.with{sub1,sub2,p};
                            intv_pre.success = tonesattransit_res.sub1.success.with{sub1,sub2,p};
                            intv_post.other = tonesattransit_res.sub2.success.without{sub1,sub2,p};
                            intv_pre.other = tonesattransit_res.sub1.success.without{sub1,sub2,p};


                            %durations
                            if isempty(post.success{cond,sub1,sub2})
                                post.success{cond,sub1,sub2} = End(intv_post.success) - Start(intv_post.success);
                                pre.success{cond,sub1,sub2} = End(intv_pre.success) - Start(intv_pre.success);

                                post.other{cond,sub1,sub2} = End(intv_post.other) - Start(intv_post.other);
                                pre.other{cond,sub1,sub2} = End(intv_pre.other) - Start(intv_pre.other);
                            else
                                post.success{cond,sub1,sub2} = [post.success{cond,sub1,sub2} ; End(intv_post.success) - Start(intv_post.success)];
                                pre.success{cond,sub1,sub2} = [pre.success{cond,sub1,sub2} ; End(intv_pre.success) - Start(intv_pre.success)];

                                post.other{cond,sub1,sub2} = [post.other{cond,sub1,sub2} ; End(intv_post.other) - Start(intv_post.other)];
                                pre.other{cond,sub1,sub2} = [pre.other{cond,sub1,sub2} ; End(intv_pre.other) - Start(intv_pre.other)];
                            end
                            %numbers
                            nb_post.success{cond,sub1,sub2} = nb_post.success{cond,sub1,sub2} + length(Start(intv_post.success));
                            nb_pre.success{cond,sub1,sub2} = nb_pre.success{cond,sub1,sub2} + length(Start(intv_pre.success));

                            nb_post.other{cond,sub1,sub2} = nb_post.other{cond,sub1,sub2} + length(Start(intv_post.other));
                            nb_pre.other{cond,sub1,sub2} = nb_pre.other{cond,sub1,sub2} + length(Start(intv_pre.other));
                        end
                    end %loop path

                end

            end
        end %loop substage
        
    end
end

%Basal
for sub1=substage_ind
    for sub2=substage_ind
        if sub1~=sub2
            post.all{cond_basal,sub1,sub2} = [];
            pre.all{cond_basal,sub1,sub2} = [];
            
            nb_post.all{cond_basal,sub1,sub2} = 0;
            nb_pre.all{cond_basal,sub1,sub2} = 0;

            for p=1:length(tonesattransit_res.path)
                if strcmpi(tonesattransit_res.condition{p},conditions{cond_basal})
                    %intervals
                    intv_post.all = union(tonesattransit_res.sub2.event.with{sub1,sub2,p}, tonesattransit_res.sub2.event.without{sub1,sub2,p});
                    intv_pre.all = union(tonesattransit_res.sub1.event.with{sub1,sub2,p}, tonesattransit_res.sub1.event.without{sub1,sub2,p});


                    %durations
                    if isempty(post.all{cond_basal,sub1,sub2})
                        post.all{cond_basal,sub1,sub2} = End(intv_post.all) - Start(intv_post.all);
                        pre.all{cond_basal,sub1,sub2} = End(intv_pre.all) - Start(intv_pre.all);
                    else
                        post.all{cond_basal,sub1,sub2} = [post.all{cond_basal,sub1,sub2} ; End(intv_post.all) - Start(intv_post.all)];
                        pre.all{cond_basal,sub1,sub2} = [pre.all{cond_basal,sub1,sub2} ; End(intv_pre.all) - Start(intv_pre.all)];
                    end
                    %numbers
                    nb_post.all{cond_basal,sub1,sub2} = nb_post.success{cond_basal,sub1,sub2} + length(Start(intv_post.all));
                    nb_pre.all{cond_basal,sub1,sub2} = nb_pre.success{cond_basal,sub1,sub2} + length(Start(intv_pre.all));

                end
            end %loop path

        end

    end
end %loop substage
        



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
suplabel([NamesSubstages{sub1} ' and ' NamesSubstages{sub2}], 't')



% Figure N2 N3
substage_transitions = [2 3; 3 2];

for cond=1:length(conditions)
    if cond ~= cond_basal & cond ~= cond_random
        labels = conditions(cond_basal);
        labels{end+1} = [conditions{cond} ' - success'];
        labels{end+1} = [conditions{cond} ' - other'];
        barcolors = conditionColors([cond_basal cond]); 
        barcolors{end+1} = 'r';
        
        figure, hold on
        for i=1:length(substage_transitions)
            clear data_post data_pre
            sub1=substage_transitions(i,1);sub2=substage_transitions(i,2);
            
            %Pre
            data_pre{cond_basal} = pre.all{cond_basal,sub1,sub2} / 10;
            data_pre{end+1} = pre.success{cond,sub1,sub2} / 10;
            data_pre{end+1} = pre.other{cond,sub1,sub2} / 10;
            %Post
            data_post{cond_basal} = post.all{cond_basal,sub1,sub2} / 10;
            data_post{end+1} = post.success{cond,sub1,sub2} / 10;
            data_post{end+1} = post.other{cond,sub1,sub2} / 10;
            
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











