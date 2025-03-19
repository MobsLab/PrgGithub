% FrequencyEventsDeltaShamEffect
% 01.12.2016 KJ
%
% collect data about the density of delta, down, tones and
% (not-)induced/(not-)triggered tones
% 
% 
%   see FrequencyEventsDeltaShamEffect_bis FrequencyEventsDeltaShamEffect2 
%



Dir1 = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);
% 
% Dir1 = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir3 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);

Dir_long1 = PathForExperimentsDeltaLongSleep('Basal');
for p=1:length(Dir_long1.path)
    Dir_long1.delay{p}=0;
end
Dir_long2=PathForExperimentsDeltaLongSleep('RdmTone');
Dir_long3=PathForExperimentsDeltaLongSleep('DeltaToneAll');
Dir_long = MergePathForExperiment(Dir2,Dir3);
Dir_long = MergePathForExperiment(Dir_long1,Dir);

Dir = IntersectPathForExperiment(Dir,Dir_long);
clearvars -except Dir



%% params
nb_intervals = 101; %each session is divided in nb_intervals-1 intervals

%% Loop
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    frequency_res.path{p}=Dir.path{p};
    frequency_res.manipe{p}=Dir.manipe{p};
    frequency_res.delay{p}=Dir.delay{p};
    frequency_res.name{p}=Dir.name{p};
    frequency_res.date{p}=Dir.date{p};
    
    
    %% load
    %Session
    clear sessions
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    
    clear Down DeltaOffline ToneEvent 
    %tones
    try
        load('DeltaSleepEvent.mat', 'TONEtime1')
        delay = Dir.delay{p}*1E4;
        tEvents = ts(TONEtime1 + delay);
    catch
        load('ShamSleepEvent.mat', 'SHAMtime')
        tEvents = SHAMtime;
        delay=0;
    end
    nb_events = length(tEvents);
    
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
    start_down = Start(Down);
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    start_deltas = Start(DeltaOffline);
    
    
    %% Tones that induced a down/delta or not, and that were triggered by a true down/delta
    effect_period = 2000; %200ms
    pre_period = 1000; %200ms
    tone_intv_post = intervalSet(Range(tEvents), Range(tEvents) + effect_period);  % Tone and its window where an effect could be observed
    tone_intv_pre = intervalSet(Range(tEvents) - (delay+pre_period), Range(tEvents) - (delay-pre_period));  % Tone and its window where an effect could be observed    

    %down
    if ~isempty(start_down)
        induce_down = zeros(nb_events, 1);
        [~,interval,~] = InIntervals(start_down, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element
        
        down_triggered = zeros(nb_events, 1);
        [~,interval,~] = InIntervals(start_down, [Start(tone_intv_pre) End(tone_intv_pre)]);
        tone_trig = unique(interval);
        down_triggered(tone_trig(2:end)) = 1;  %do not consider the first nul element
    else
        induce_down = [];
        down_triggered = [];
    end
    %delta
    if ~isempty(start_deltas)
        induce_delta = zeros(nb_events, 1);
        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
        
        delta_triggered = zeros(nb_events, 1);
        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_pre) End(tone_intv_pre)]);
        tone_trig = unique(interval);
        delta_triggered(tone_trig(2:end)) = 1;  %do not consider the first nul element
    else
        induce_delta = [];
        delta_triggered = [];
    end
    
    tones = Range(tEvents);
    % tone_down{trig,indu} where: 
    % - trig=2 if tone triggered by a down, 1 otherwise  
    % - indu=2 if tone induced by a down, 1 otherwise
    tone_down{1,1} = ts(sort(tones(down_triggered==0 & induce_down==0)));
    tone_down{1,2} = ts(sort(tones(down_triggered==0 & induce_down==1)));
    tone_down{2,1} = ts(sort(tones(down_triggered==1 & induce_down==0)));
    tone_down{2,2} = ts(sort(tones(down_triggered==1 & induce_down==1)));
    % tone_delta{trig,indu} where: 
    % - trig=2 if tone triggered by a delta, 1 otherwise  
    % - indu=2 if tone induced by a delta, 1 otherwise
    tone_delta{1,1} = ts(sort(tones(delta_triggered==0 & induce_delta==0)));
    tone_delta{1,2} = ts(sort(tones(delta_triggered==0 & induce_delta==1)));
    tone_delta{2,1} = ts(sort(tones(delta_triggered==1 & induce_delta==0)));
    tone_delta{2,2} = ts(sort(tones(delta_triggered==1 & induce_delta==1)));
    
    %% Density per epochs
    deltas.nb =  [];
    deltas.density = [];
    downs.nb = [];
    downs.density = [];
    tones_all.nb = [];
    tones_all.density = [];
    for trig=1:2
        for indu=1:2
            tones_delta.nb{trig,indu} = [];
            tones_delta.density{trig,indu} = [];
            tones_down.nb{trig,indu} = [];
            tones_down.density{trig,indu} = [];
        end
    end
    durations = [];
    
    %loop over session
    for s=1:length(sessions)
        %init
        deltas_nb = zeros(nb_intervals-1, 1);
        deltas_density = zeros(nb_intervals-1, 1);
        downs_nb = zeros(nb_intervals-1, 1);
        downs_density = zeros(nb_intervals-1, 1);
        tones_all_nb = zeros(nb_intervals-1, 1);
        tones_all_density = zeros(nb_intervals-1, 1);
        for trig=1:2
            for indu=1:2
                tones_delta_nb{trig,indu} = zeros(nb_intervals-1, 1);
                tones_delta_density{trig,indu} = zeros(nb_intervals-1, 1);
                tones_down_nb{trig,indu} = zeros(nb_intervals-1, 1);
                tones_down_density{trig,indu} = zeros(nb_intervals-1, 1);
            end
        end
        duration = zeros(nb_intervals-1, 1);
        
        %Restrict to the timestamps division of the session
        timestamps = linspace(Start(sessions{s}), End(sessions{s}), nb_intervals);
        for t=1:length(timestamps)-1
            intv = intervalSet(timestamps(t),timestamps(t+1));
            total_duration = tot_length(intv);

            deltas_nb(t) = length(Restrict(ts(start_deltas),intv));
            deltas_density(t) = length(Restrict(ts(start_deltas),intv)) / total_duration;
            downs_nb(t) = length(Restrict(ts(start_down),intv));
            downs_density(t) = length(Restrict(ts(start_down),intv)) / total_duration;
            tones_all_nb(t) = length(Restrict(tEvents,intv));
            tones_all_density(t) = length(Restrict(tEvents,intv)) / total_duration;
            for trig=1:2
                for indu=1:2
                    tones_delta_nb{trig,indu}(t) = length(Restrict(tone_delta{trig,indu},intv));
                    tones_delta_density{trig,indu}(t) = length(Restrict(tone_delta{trig,indu},intv)) / total_duration;
                    tones_down_nb{trig,indu}(t) = length(Restrict(tone_down{trig,indu},intv));
                    tones_down_density{trig,indu}(t) = length(Restrict(tone_down{trig,indu},intv)) / total_duration;
                end
            end
            duration(t) = total_duration;
        end
        
        %add to previous list
        deltas.nb = [deltas.nb; deltas_nb];
        deltas.density = [deltas.density; deltas_density];
        downs.nb = [downs.nb; downs_nb];
        downs.density = [downs.density; downs_density];
        tones_all.nb = [tones_all.nb; tones_all_nb];
        tones_all.density = [tones_all.density; tones_all_density];
        for trig=1:2
            for indu=1:2
                tones_delta.nb{trig,indu} = [tones_delta.nb{trig,indu} tones_delta_nb{trig,indu}'];
                tones_delta.density{trig,indu} = [tones_delta.density{trig,indu} tones_delta_density{trig,indu}'];
                tones_down.nb{trig,indu} = [tones_down.nb{trig,indu} tones_down_nb{trig,indu}'];
                tones_down.density{trig,indu} = [tones_down.density{trig,indu} tones_down_density{trig,indu}'];
            end
        end
        durations = [durations duration];
    end
    
    frequency_res.tone_down{p} = tone_down;
    frequency_res.tone_delta{p} = tone_delta;
    
    frequency_res.deltas.nb{p} = deltas.nb;
    frequency_res.deltas.density{p} = deltas.density;
    frequency_res.downs.nb{p} = downs.nb;
    frequency_res.downs.density{p} = downs.density;
    frequency_res.tones_all.nb{p} = tones_all.nb;
    frequency_res.tones_all.density{p}  = tones_all.density;
    frequency_res.tones_delta.nb{p} = tones_delta.nb;
    frequency_res.tones_delta.density{p} = tones_delta.density;
    frequency_res.tones_down.nb{p} = tones_down.nb;
    frequency_res.tones_down.density{p} = tones_down.density;
    frequency_res.durations{p} = durations;
  
end

sessions_ind = 1:5;
%saving data
cd([FolderProjetDelta 'Data/']) 
save FrequencyEventsDeltaShamEffect.mat frequency_res sessions_ind nb_intervals








