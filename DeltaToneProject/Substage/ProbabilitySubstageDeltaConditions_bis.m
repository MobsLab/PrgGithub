% ProbabilitySubstageDeltaConditions_bis
% 21.11.2016 KJ
%
% - Use the data collected in ProbabilitySubstageDeltaConditions
% - transform them to be plot in ProbabilitySubstageDeltaConditions2
%
%   see ProbabilitySubstageDeltaConditions ProbabilitySubstageDeltaConditions2
%
%


%% load
clear
eval(['load ' FolderProjetDelta 'Data/ProbabilitySubstageDeltaConditions.mat'])

%% Concatenate
animals = unique(proba_res.name); %Mice

%add delay=-1 for Random conditions
delays = [delays -1];
for p=1:length(proba_res.path)
    if strcmpi(proba_res.manipe{p},'RdmTone')
        proba_res.delay{p} = -1;
    end
end

% data for each mice and delays
for d=1:length(delays)
    for m=1:length(animals)
        sum_proba=[];
        sum_deltas=[];
        sum_downs=[];
        sum_events=[];
        n=0;
        for p=1:length(proba_res.path) 
            if proba_res.delay{p}==delays(d) && strcmpi(proba_res.name{p},animals(m))
                if isempty(sum_proba)
                    sum_proba = proba_res.proba_substage{p};
                    sum_deltas = proba_res.deltas.density{p};
                    sum_downs = proba_res.downs.density{p};
                    sum_events = proba_res.events.density{p};
                else
                    sum_proba = sum_proba + proba_res.proba_substage{p};
                    sum_deltas = sum_deltas + proba_res.deltas.density{p};
                    sum_downs = sum_downs + proba_res.downs.density{p};
                    sum_events = sum_events + proba_res.events.density{p};
                end
                n = n+1;
            end
        end
        substage.mouse.density{d,m} = sum_proba / n;
        deltas.mouse.density{d,m} = sum_deltas / n;
        downs.mouse.density{d,m} = sum_downs / n;
        events.mouse.density{d,m} = sum_events / n;
        nb_night.mouse{d,m} = n;
    end
end

%mean proba for each delays
for d=1:length(delays)
        sum_proba=[];
        sum_deltas=[];
        sum_downs=[];
        sum_events=[];
        n=0;
        for p=1:length(proba_res.path) 
            if proba_res.delay{p}==delays(d)
                if isempty(sum_proba)
                    sum_proba = proba_res.proba_substage{p};
                    sum_deltas = proba_res.deltas.density{p};
                    sum_downs = proba_res.downs.density{p};
                    sum_events = proba_res.events.density{p};
                else
                    sum_proba = sum_proba + proba_res.proba_substage{p};
                    sum_deltas = sum_deltas + proba_res.deltas.density{p};
                    sum_downs = sum_downs + proba_res.downs.density{p};
                    sum_events = sum_events + proba_res.events.density{p};
                end
                n = n+1;
            end
        end
        substage.all.density{d} = sum_proba / n;
        deltas.all.density{d} = sum_deltas / n;
        downs.all.density{d} = sum_downs / n;
        events.all.density{d} = sum_events / n;
        nb_night.all{d} = n;
end


sessions_ind = 1:5;
%saving data
cd([FolderProjetDelta 'Data/']) 
save ProbabilitySubstageDeltaConditions_bis.mat delays nb_intervals substage deltas downs events nb_night


