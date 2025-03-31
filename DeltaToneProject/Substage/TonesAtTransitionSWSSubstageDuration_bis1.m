% TonesAtTransitionSWSSubstageDuration_bis1
% 13.12.2016 KJ
%
% Transform data
% 
% 
%   see TonesAtTransitionSWSSubstageDuration  TonesAtTransitionSWSSubstageDurationPlot2
%
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
NamesSubstages = {'N1','N2','N3','REM','Wake'};
conditionColors = {'k', [0.75 0.75 0.75],'b','b','b', 'b'};


%% Concatenate data
%Tone
for cond=1:length(conditions)
    if cond ~= cond_basal
        for sub1=substage_ind
            for sub2=substage_ind
                if sub1~=sub2
                    post.success{cond,sub1,sub2} = [];
                    pre.success{cond,sub1,sub2} = [];
                    post.no_event{cond,sub1,sub2} = [];
                    pre.no_event{cond,sub1,sub2} = [];

                    nb_post.success{cond,sub1,sub2} = 0;
                    nb_pre.success{cond,sub1,sub2} = 0;
                    nb_post.no_event{cond,sub1,sub2} = 0;
                    nb_pre.no_event{cond,sub1,sub2} = 0;

                    for p=1:length(tonesattransit_res.path)
                        if strcmpi(tonesattransit_res.condition{p},conditions{cond})
                            %intervals
                            intv_post.success = tonesattransit_res.sub2.success.with{sub1,sub2,p};
                            intv_pre.success = tonesattransit_res.sub1.success.with{sub1,sub2,p};
                            intv_post.no_event = tonesattransit_res.sub2.event.without{sub1,sub2,p};
                            intv_pre.no_event = tonesattransit_res.sub1.event.without{sub1,sub2,p};


                            %durations
                            if isempty(post.success{cond,sub1,sub2})
                                post.success{cond,sub1,sub2} = End(intv_post.success) - Start(intv_post.success);
                                pre.success{cond,sub1,sub2} = End(intv_pre.success) - Start(intv_pre.success);

                                post.no_event{cond,sub1,sub2} = End(intv_post.no_event) - Start(intv_post.no_event);
                                pre.no_event{cond,sub1,sub2} = End(intv_pre.no_event) - Start(intv_pre.no_event);
                            else
                                post.success{cond,sub1,sub2} = [post.success{cond,sub1,sub2} ; End(intv_post.success) - Start(intv_post.success)];
                                pre.success{cond,sub1,sub2} = [pre.success{cond,sub1,sub2} ; End(intv_pre.success) - Start(intv_pre.success)];

                                post.no_event{cond,sub1,sub2} = [post.no_event{cond,sub1,sub2} ; End(intv_post.no_event) - Start(intv_post.no_event)];
                                pre.no_event{cond,sub1,sub2} = [pre.no_event{cond,sub1,sub2} ; End(intv_pre.no_event) - Start(intv_pre.no_event)];
                            end
                            %numbers
                            nb_post.success{cond,sub1,sub2} = nb_post.success{cond,sub1,sub2} + length(Start(intv_post.success));
                            nb_pre.success{cond,sub1,sub2} = nb_pre.success{cond,sub1,sub2} + length(Start(intv_pre.success));

                            nb_post.no_event{cond,sub1,sub2} = nb_post.no_event{cond,sub1,sub2} + length(Start(intv_post.no_event));
                            nb_pre.no_event{cond,sub1,sub2} = nb_pre.no_event{cond,sub1,sub2} + length(Start(intv_pre.no_event));
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
                    nb_post.all{cond_basal,sub1,sub2} = nb_post.all{cond_basal,sub1,sub2} + length(Start(intv_post.all));
                    nb_pre.all{cond_basal,sub1,sub2} = nb_pre.all{cond_basal,sub1,sub2} + length(Start(intv_pre.all));

                end
            end %loop path

        end

    end
end %loop substage
        


%saving data
cd([FolderProjetDelta 'Data/']) 
save TonesAtTransitionSWSSubstageDuration_bis1.mat post pre nb_post nb_pre conditions cond_basal cond_random
save TonesAtTransitionSWSSubstageDuration_bis1.mat -append substage_ind NamesSubstages conditionColors







        
