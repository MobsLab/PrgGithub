% AnalyseSuccessDeltaTone
% 18.02.2017 KJ
%
% collect data for the quantification of the success of tones to induce delta/down, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE, NREM
%
% Here, the data are collected
%
%   see QuantifSuccessDeltaShamToneSubstage FigureSuccessDelayDelta
%
%


%% Dir
Dir1=PathForExperimentsDeltaLongSleepNew('RdmTone');
Dir2=PathForExperimentsDeltaLongSleepNew('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);

% Dir1 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir2 = PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir1,Dir2);

clearvars -except Dir

%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end


%params
substages_ind = 1:6;
pre_period = 2000; %200ms
effect_period = 3000; %300ms


%% Tone
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    tonesuccess_res.path{p}=Dir.path{p};
    tonesuccess_res.manipe{p}=Dir.manipe{p};
    tonesuccess_res.delay{p}=Dir.delay{p};
    tonesuccess_res.name{p}=Dir.name{p};
    tonesuccess_res.condition{p}=Dir.condition{p};
    
    
    %% load
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
    if ~isempty(op)
        disp('Loading epochs from NREMepochsML.m')
    else
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML_old.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
    end
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    NREM = Substages{6};
    %Session
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2_SWS')
    load('DeltaSleepEvent.mat', 'TONEtime1_SWS')
    delay = Dir.delay{p}*1E4;
    if exist('TONEtime2_SWS','var')
        tones_tmp = TONEtime2_SWS + delay;
    else
        tones_tmp = TONEtime1_SWS + delay;
    end
    ToneEvent = Restrict(ts(tones_tmp), NREM);
    tones_tmp = Range(ToneEvent);
    nb_tones = length(tones_tmp);
    tonesuccess_res.all.nb_tone{p} = nb_tones;
    
    %% Tones that induced a down/delta or not, and that were triggered by a true down/delta
    tone_intv_post = intervalSet(tones_tmp, tones_tmp + effect_period);  % Tone and its window where an effect could be observed
    tone_intv_pre = intervalSet(tones_tmp - (delay+pre_period), tones_tmp - delay);  % Tone and its window where an effect could be observed    

    %delta
    if ~isempty(start_deltas)
        induce_delta = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
        
        delta_triggered = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_pre) End(tone_intv_pre)]);
        tone_trig = unique(interval);
        delta_triggered(tone_trig(2:end)) = 1;  %do not consider the first nul element
    else
        induce_delta = [];
        delta_triggered = [];
    end
    
    % tone_delta{trig,indu} where: 
    % - trig=2 if tone triggered by a delta, 1 otherwise  
    % - indu=2 if tone induced by a delta, 1 otherwise
    
    clear tone_delta nb_delta
    for trig=1:2
       for indu=1:2
           tone_delta{trig,indu} = tones_tmp(delta_triggered==(trig-1) & induce_delta==(indu-1));
           nb_delta{trig,indu} = length(tone_delta{trig,indu});
       end
    end
    
    if strcmpi(Dir.condition{p},'RdmTone')
        for indu=1:2
            nb_delta{1,indu} = nb_delta{1,indu} + nb_delta{2,indu};
            nb_delta{2,indu} = 0;
        end
    end
    
    tonesuccess_res.all.delta{p} = nb_delta;
    
    %% SUCCESS RATE in S2 & S4
    for s=1:2
        tonesuccess_res.session.time{p}(s,1) = Start(sessions{s});
        tonesuccess_res.session.time{p}(s,2) = End(sessions{s});
        tonesuccess_res.session.nb_tone{p}(s) = length(Restrict(ToneEvent,sessions{s}));
        
        clear nb_delta
        %delta
        for trig=1:2
            for indu=1:2
                nb_delta{trig,indu} = length(Restrict(ts(tone_delta{trig,indu}),sessions{s}));
            end
        end
        tonesuccess_res.session.delta{p,s} = nb_delta;
        
    end

end


%saving data
cd([FolderProjetDelta 'Data/'])
save AnalyseSuccessDeltaTone.mat tonesuccess_res substages_ind effect_period pre_period


