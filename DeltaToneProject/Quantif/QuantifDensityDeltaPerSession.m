% QuantifDensityDeltaPerSession
% 16.11.2016 KJ
%
% collect data about the number of delta/down per session S1 S2 S3 S4 S5
% -   
%
%   see 
%


%Dir=PathForExperimentsDeltaISI;
Dir_basal = PathForExperimentsDeltaWavesTone('Basal');
Dir1=PathForExperimentsDeltaWavesTone('RdmTone');
Dir2=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir_tone = MergePathForExperiment(Dir1,Dir2);


%% params
substages_ind = 1:5; %N1, N2, N3, REM, WAKE


%% Data for Basal
for p=1:length(Dir_basal.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_basal.path{',num2str(p),'}'')'])
    disp(pwd)
    basal_res.path{p}=Dir_basal.path{p};
    basal_res.manipe{p}=Dir_basal.manipe{p};
    basal_res.delay{p}=0;
    basal_res.name{p}=Dir_basal.name{p};

    %% load
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
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    %Substages and stages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    %Session
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    
    %% Density
    for s=1:length(sessions)
        for sub=substages_ind
            intv = intersect(Substages{sub}, sessions{s});
            nb_delta = length(Restrict(ts(Start(DeltaOffline)), intv));
            nb_down = length(Restrict(ts(Start(Down)), intv));
            duration = tot_length(intv)/1E4; %in s
            
            basal_res.nb_delta{p,s,sub} = nb_delta;
            basal_res.nb_down{p,s,sub} = nb_down;
            basal_res.duration{p,s,sub} = duration;
        end      
    end
    
end


%% Data for DeltaTone and RdmTone
for p=1:length(Dir_tone.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_tone.path{',num2str(p),'}'')'])
    disp(pwd)
    deltatone_res.path{p}=Dir_tone.path{p};
    deltatone_res.manipe{p}=Dir_tone.manipe{p};
    deltatone_res.delay{p}=Dir_tone.delay{p};
    deltatone_res.name{p}=Dir_tone.name{p};

    %% load
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime1')
    delay = Dir_tone.delay{p}*1E4; %in 1E-4s
    ToneEvent = ts(TONEtime1 + delay);
    nb_tones = length(ToneEvent);
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
    %Substages and stages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    %Session
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    
    
    %% Tones that induces a down or not, delta or not
    effect_period = 2000; %200ms
    tone_intv = intervalSet(Range(ToneEvent), Range(ToneEvent) + effect_period);  % Tone and its window where an effect could be observed
    
    %delta
    if ~isempty(start_deltas)
        induce_delta = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv) End(tone_intv)]);
        tone_success = unique(interval);
        induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
    else
        induce_delta = [];
    end
    %down
    if ~isempty(start_down)
        induce_down = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_down, [Start(tone_intv) End(tone_intv)]);
        tone_success = unique(interval);
        induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element
    else
        induce_down = [];
    end
    
    tones = Range(ToneEvent);
    good_tone_delta = ts(tones(induce_delta==1));
    bad_tone_delta = ts(tones(induce_delta==0));
    good_tone_down = ts(tones(induce_down==1));
    bad_tone_down = ts(tones(induce_down==0));
    
    clear nb_tones
    
    %% Density
    for s=1:length(sessions)
        for sub=substages_ind           
            intv = intersect(Substages{sub}, sessions{s});
            nb_delta = length(Restrict(ts(Start(DeltaOffline)), intv));
            nb_down = length(Restrict(ts(Start(Down)), intv));
            duration = tot_length(intv)/1E4; %in s
            
            nb_tone = length(Restrict(ts(Start(ToneEvent)), intv));
            nb_tone_successdelta = length(Restrict(ts(Start(good_tone_delta)), intv));
            nb_tone_faildelta = length(Restrict(ts(Start(bad_tone_delta)), intv));
            nb_tone_successdown = length(Restrict(ts(Start(good_tone_down)), intv));
            nb_tone_faildown = length(Restrict(ts(Start(bad_tone_down)), intv));
            
            deltatone_res.nb_delta{p,s,sub} = nb_delta;
            deltatone_res.nb_down{p,s,sub} = nb_down;
            deltatone_res.duration{p,s,sub} = duration;
            deltatone_res.nb_tone{p,s,sub} = nb_tone;
            deltatone_res.nb_tone_successdelta{p,s,sub} = nb_tone_successdelta;
            deltatone_res.nb_tone_faildelta{p,s,sub} = nb_tone_faildelta;
            deltatone_res.nb_tone_successdown{p,s,sub} = nb_tone_successdown;
            deltatone_res.nb_tone_faildown{p,s,sub} = nb_tone_faildown;
        end
    end
    
end

sessions_ind = 1:5;
name_substages = NamesSubstages(substages_ind);
delays = unique([0 cell2mat(Dir_tone.delay)]);
%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifDensityDeltaPerSession.mat basal_res deltatone_res delays substages_ind sessions_ind








