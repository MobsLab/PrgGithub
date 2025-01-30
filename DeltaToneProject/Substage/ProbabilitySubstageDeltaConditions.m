% ProbabilitySubstageDeltaConditions
% 21.11.2016 KJ
%
% collect data on the percentage of time spent in each substage, along the night
% - each session is divided in nb_intervals intervals
% - percentage of time are computed on each of this intervals
% - number_of_intervals = number_of_sessions * nb_intervals
% - density of delta waves, down states and tones/shams are also computed
% 
% 
%   see ProbabilitySubstageDeltaConditions_bis ProbabilitySubstageDeltaConditions2
%


Dir1 = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);

% Dir1 = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir3 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);

%% params
substages_ind = 1:5; %N1, N2, N3, REM, WAKE
nb_intervals = 101; %each session is divided in nb_intervals-1 intervals


%% Data for Basal
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    proba_res.path{p}=Dir.path{p};
    proba_res.manipe{p}=Dir.manipe{p};
    proba_res.delay{p}=Dir.delay{p};
    proba_res.name{p}=Dir.name{p};
    

    %% load
    %Substages and stages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    %Session
    clear sessions
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    
    clear Down DeltaOffline tEvents 
    %Down states
    try
        load newDownState Down
    catch
        try
            load DownSpk Down
        catch
            Down = intervalSet([],[]);
        end
    end
    tdowns = (Start(Down)+End(Down))/2; 
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline =  DeltaEpoch; 
        clear DeltaEpoch
    end
    tdeltas = (Start(DeltaOffline)+End(DeltaOffline))/2;
    
    %Tones/Shams
    try
        load('DeltaSleepEvent.mat', 'TONEtime1')
        delay = Dir.delay{p}*1E4; %in 1E-4s
        tEvents = ts(TONEtime1 + delay);
        with_tone=1;
    catch
        load('ShamSleepEvent.mat', 'SHAMtime')
        delay = 0;
        tEvents = ts(Range(SHAMtime) + delay);
        with_tone=0;
    end
    nb_events = length(tEvents);
    
    
    %% Substage probability
    proba_substage = [];
    deltas.nb =  [];
    deltas.density = [];
    downs.nb = [];
    downs.density = [];
    events.nb = [];
    events.density = [];
    durations = [];
    
    for s=1:length(sessions)
        session_data = nan(nb_intervals-1, length(substages_ind));
        deltas_nb = zeros(nb_intervals-1, 1);
        deltas_density = zeros(nb_intervals-1, 1);
        downs_nb = zeros(nb_intervals-1, 1);
        downs_density = zeros(nb_intervals-1, 1);
        events_nb = zeros(nb_intervals-1, 1);
        events_density = zeros(nb_intervals-1, 1);
        duration = zeros(nb_intervals-1, 1);
            
        timestamps = linspace(Start(sessions{s}), End(sessions{s}), nb_intervals);
        for t=1:length(timestamps)-1
            intv = intervalSet(timestamps(t),timestamps(t+1));
            total_duration = tot_length(intv);
            for sub=1:length(substages_ind)
                session_data(t,sub) = tot_length(intersect(Substages{substages_ind(sub)}, intv)) / total_duration;
            end
            deltas_nb(t) = length(Restrict(ts(tdeltas),intv));
            deltas_density(t) = length(Restrict(ts(tdeltas),intv)) / total_duration;
            downs_nb(t) = length(Restrict(ts(tdowns),intv));
            downs_density(t) = length(Restrict(ts(tdowns),intv)) / total_duration;
            events_nb(t) = length(Restrict(tEvents,intv));
            events_density(t) = length(Restrict(tEvents,intv)) / total_duration;
            duration(t) = total_duration;
        end
        proba_substage = [proba_substage; session_data];
        deltas.nb = [deltas.nb; deltas_nb];
        deltas.density = [deltas.density; deltas_density];
        downs.nb = [downs.nb; downs_nb];
        downs.density = [downs.density; downs_density];
        events.nb = [events.nb; events_nb];
        events.density = [events.density; events_density];
        durations = [durations duration];
    end

    proba_res.proba_substage{p} = proba_substage;
    proba_res.deltas.nb{p} = deltas.nb;
    proba_res.deltas.density{p} = deltas.density;
    proba_res.downs.nb{p} = downs.nb;
    proba_res.downs.density{p} = downs.density;
    proba_res.events.nb{p} = events.nb;
    proba_res.events.density{p} = events.density;
    proba_res.durations{p} = durations;
    proba_res.with_tone{p} = with_tone;

end


sessions_ind = 1:5;
delays = unique(cell2mat(proba_res.delay));
%saving data
cd([FolderProjetDelta 'Data/']) 
save ProbabilitySubstageDeltaConditions.mat proba_res delays substages_ind sessions_ind nb_intervals


