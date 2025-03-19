% QuantifSuccessDeltaToneSubstage
% 14.11.2016 KJ
%
% collect data for the quantification of the success of tone to induce delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are collected
%
%   see QuantifSuccessDeltaToneSubstage2


Dir1 = PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir2  = PathForExperimentsDeltaWavesTone('RdmTone');
Dir = MergePathForExperiment(Dir1,Dir2);

%% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE


%% Collect data
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    deltatone_res.path{p}=Dir.path{p};
    deltatone_res.manipe{p}=Dir.manipe{p};
    deltatone_res.delay{p}=Dir.delay{p};
    deltatone_res.name{p}=Dir.name{p};

    %% load
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime1')
    load('DeltaSleepEvent.mat', 'TONEtime2')
    delay = Dir.delay{p}*1E4; %in 1E-4s
    if exist('TONEtime2','var')
        ToneEvent = ts(TONEtime2 + delay);
    else
        ToneEvent = ts(TONEtime1 + delay);
    end
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
    %Substages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);


    %% Tones that induces a down or not, delta or not
    effect_period = 2000; %200ms
    tone_intv = intervalSet(Range(ToneEvent), Range(ToneEvent) + effect_period);  % Tone and its window where an effect could be observed

    %down
    if ~isempty(start_down)
        induce_down = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_down, [Start(tone_intv) End(tone_intv)]);
        tone_success = unique(interval);
        induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element
    else
        induce_down = [];
    end
    %delta
    if ~isempty(start_deltas)
        induce_delta = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv) End(tone_intv)]);
        tone_success = unique(interval);
        induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
    else
        induce_delta = [];
    end
    
    tones = Range(ToneEvent);
    good_tone_down = tones(induce_down==1);
    bad_tone_down = tones(induce_down==0);
    good_tone_delta = tones(induce_delta==1);
    bad_tone_delta = tones(induce_delta==0);
    
    
    %% Substages ISI
    for sub=substages_ind
        deltatone_res.substage{p,sub} = NamesSubstages{sub};

        %Down
        gooddown_substage = length(Restrict(ts(good_tone_down), Substages{sub}));
        baddown_substage = length(Restrict(ts(bad_tone_down), Substages{sub}));
        
        %Delta
        gooddelta_substage = length(Restrict(ts(good_tone_delta), Substages{sub}));
        baddelta_substage = length(Restrict(ts(bad_tone_delta), Substages{sub}));
        
        %Results
        deltatone_res.gooddown_substage{p,sub} = gooddown_substage;
        deltatone_res.baddown_substage{p,sub} = baddown_substage;
        deltatone_res.gooddelta_substage{p,sub} = gooddelta_substage;
        deltatone_res.baddelta_substage{p,sub} = baddelta_substage;
        deltatone_res.epoch_duration{p,sub} = tot_length(Substages{sub});
        
    end
    
end

name_substages = NamesSubstages(substages_ind);
delays = unique(cell2mat(Dir.delay));
%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifSuccessDeltaToneSubstage.mat deltatone_res delays substages_ind

