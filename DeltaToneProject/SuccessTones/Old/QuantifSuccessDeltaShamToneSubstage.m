% QuantifSuccessDeltaShamToneSubstage
% 30.11.2016 KJ
%
% collect data for the quantification of the success of tones/shams to induce delta/down, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are collected
%
%   see QuantifSuccessDeltaToneSubstage QuantifSuccessDeltaShamToneSubstage_bis
%
%


% Dir_sham = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir_sham.path)
%    Dir_sham.condition{p} = 'Basal';
% end
% Dir1 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir2 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir_tone = MergePathForExperiment(Dir1,Dir2);
% 
% for p=1:length(Dir_tone.path)
%     if strcmpi(Dir_tone.manipe{p},'RdmTone')
%         Dir_tone.condition{p} = 'RdmTone';
%     elseif strcmpi(Dir_tone.manipe{p},'DeltaToneAll')
%         Dir_tone.condition{p} = ['Tone ' num2str(Dir_tone.delay{p}*1000) 'ms'];
%     end
% end 

Dir_sham = PathForExperimentsDeltaLongSleepNew('Basal');
for p=1:length(Dir_sham.path)
   Dir_sham.condition{p} = 'Basal';
end
Dir1 = PathForExperimentsDeltaLongSleepNew('RdmTone');
Dir2 = PathForExperimentsDeltaLongSleepNew('DeltaToneAll');
Dir_tone = MergePathForExperiment(Dir1,Dir2);

for p=1:length(Dir_tone.path)
    if strcmpi(Dir_tone.manipe{p},'RdmTone')
        Dir_tone.condition{p} = 'RdmTone';
    elseif strcmpi(Dir_tone.manipe{p},'DeltaToneAll')
        Dir_tone.condition{p} = ['Tone ' num2str(Dir_tone.delay{p}*1000) 'ms'];
    end
end 

animals = union(unique(Dir_sham.name),unique(Dir_tone.name)); %Mice
conditions = union(unique(Dir_sham.condition),unique(Dir_tone.condition)); %Mice

%% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE
delays = unique(cell2mat(Dir2.delay));
effect_period = 2000; %200ms
pre_period = 1000; %100ms


%% SHAM
for p=1:length(Dir_sham.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_sham.path{',num2str(p),'}'')'])
    disp(pwd)
    shamsuccess_res.path{p}=Dir_sham.path{p};
    shamsuccess_res.manipe{p}=Dir_sham.manipe{p};
    shamsuccess_res.delay{p}=0;
    shamsuccess_res.name{p}=Dir_sham.name{p};
    shamsuccess_res.condition{p}=Dir_sham.condition{p};

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
    if ~isempty(op)
        disp('Loading epochs from NREMepochsML.m')
    else
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML_old.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
    end
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    
    %shams
    load('ShamSleepEvent.mat', 'SHAMtime')
    for d=1:length(delays)
        delay = delays(d)*1E4;
        ShamEvent = ts(Range(SHAMtime) + delay);
        nb_shams = length(ShamEvent);
        
        %% Shams induced a down/delta or not, and that were triggered by a true down/delta
        sham_intv_post = intervalSet(Range(ShamEvent), Range(ShamEvent) + effect_period);  % Sham and its window where an effect could be observed
        sham_intv_pre = intervalSet(Range(ShamEvent) - (delay+pre_period), Range(ShamEvent) - (delay-pre_period));  % Sham and its window where an effect could be observed
        
        %down
        if ~isempty(start_down)
            induce_down = zeros(nb_shams, 1);
            [~,interval,~] = InIntervals(start_down, [Start(sham_intv_post) End(sham_intv_post)]);
            sham_success = unique(interval);
            induce_down(sham_success(2:end)) = 1;  %do not consider the first nul element

            down_triggered = zeros(nb_shams, 1);
            [~,interval,~] = InIntervals(start_down, [Start(sham_intv_pre) End(sham_intv_pre)]);
            sham_trig = unique(interval);
            down_triggered(sham_trig(2:end)) = 1;  %do not consider the first nul element
        else
            induce_down = [];
            down_triggered = [];
        end
        %delta
        if ~isempty(start_deltas)
            induce_delta = zeros(nb_shams, 1);
            [~,interval,~] = InIntervals(start_deltas, [Start(sham_intv_post) End(sham_intv_post)]);
            sham_success = unique(interval);
            induce_delta(sham_success(2:end)) = 1;  %do not consider the first nul element

            delta_triggered = zeros(nb_shams, 1);
            [~,interval,~] = InIntervals(start_deltas, [Start(sham_intv_pre) End(sham_intv_pre)]);
            sham_trig = unique(interval);
            delta_triggered(sham_trig(2:end)) = 1;  %do not consider the first nul element
        else
            induce_delta = [];
            delta_triggered = [];
        end
        
        shams = Range(ShamEvent);
        % sham_down{trig,indu} where: 
        % - trig=2 if sham triggered by a down, 1 otherwise  
        % - indu=2 if sham induced by a down, 1 otherwise
        sham_down{1,1} = shams(down_triggered==0 & induce_down==0);
        sham_down{1,2} = shams(down_triggered==0 & induce_down==1);
        sham_down{2,1} = shams(down_triggered==1 & induce_down==0);
        sham_down{2,2} = shams(down_triggered==1 & induce_down==1);
        % sham_delta{trig,indu} where: 
        % - trig=2 if sham triggered by a delta, 1 otherwise  
        % - indu=2 if sham induced by a delta, 1 otherwise
        sham_delta{1,1} = shams(delta_triggered==0 & induce_delta==0);
        sham_delta{1,2} = shams(delta_triggered==0 & induce_delta==1);
        sham_delta{2,1} = shams(delta_triggered==1 & induce_delta==0);
        sham_delta{2,2} = shams(delta_triggered==1 & induce_delta==1);


        %% Substages ISI
        for sub=substages_ind
            shamsuccess_res.substage{p,sub} = NamesSubstages{sub};
            shamsuccess_res.epoch_duration{p,sub} = tot_length(Substages{sub});
            clear sham_down_substage sham_delta_substage
            for trig=1:2
               for indu=1:2
                   %down
                   sham_down_substage{trig,indu} = length(Restrict(ts(sham_down{trig,indu}), Substages{sub}));
                   %delta
                   sham_delta_substage{trig,indu} = length(Restrict(ts(sham_delta{trig,indu}), Substages{sub}));
               end
            end
        
            shamsuccess_res.sham_down_substage{p,sub,d} = sham_down_substage;
            shamsuccess_res.sham_delta_substage{p,sub,d} = sham_delta_substage;
        end

        
        
    end
end


%% Tone
for p=1:length(Dir_tone.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_tone.path{',num2str(p),'}'')'])
    disp(pwd)
    tonesuccess_res.path{p}=Dir_tone.path{p};
    tonesuccess_res.manipe{p}=Dir_tone.manipe{p};
    tonesuccess_res.delay{p}=Dir_tone.delay{p};
    tonesuccess_res.name{p}=Dir_tone.name{p};
    tonesuccess_res.condition{p}=Dir_tone.condition{p};
    
    %% load
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime1')
    delay = Dir_tone.delay{p}*1E4;
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

    
    %% Tones that induced a down/delta or not, and that were triggered by a true down/delta
    tone_intv_post = intervalSet(Range(ToneEvent), Range(ToneEvent) + effect_period);  % Tone and its window where an effect could be observed
    tone_intv_pre = intervalSet(Range(ToneEvent) - (delay+pre_period), Range(ToneEvent) - (delay-pre_period));  % Tone and its window where an effect could be observed    

    %down
    if ~isempty(start_down)
        induce_down = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_down, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element
        
        down_triggered = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_down, [Start(tone_intv_pre) End(tone_intv_pre)]);
        tone_trig = unique(interval);
        down_triggered(tone_trig(2:end)) = 1;  %do not consider the first nul element
    else
        induce_down = [];
        down_triggered = [];
    end
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
    
    tones = Range(ToneEvent);
    % tone_down{trig,indu} where: 
    % - trig=2 if tone triggered by a down, 1 otherwise  
    % - indu=2 if tone induced by a down, 1 otherwise
    tone_down{1,1} = tones(down_triggered==0 & induce_down==0);
    tone_down{1,2} = tones(down_triggered==0 & induce_down==1);
    tone_down{2,1} = tones(down_triggered==1 & induce_down==0);
    tone_down{2,2} = tones(down_triggered==1 & induce_down==1);
    % tone_delta{trig,indu} where: 
    % - trig=2 if tone triggered by a delta, 1 otherwise  
    % - indu=2 if tone induced by a delta, 1 otherwise
    tone_delta{1,1} = tones(delta_triggered==0 & induce_delta==0);
    tone_delta{1,2} = tones(delta_triggered==0 & induce_delta==1);
    tone_delta{2,1} = tones(delta_triggered==1 & induce_delta==0);
    tone_delta{2,2} = tones(delta_triggered==1 & induce_delta==1);
    
    
    %% Substages ISI
    for sub=substages_ind
        tonesuccess_res.substage{p,sub} = NamesSubstages{sub};
        tonesuccess_res.epoch_duration{p,sub} = tot_length(Substages{sub});
        
        for trig=1:2
           for indu=1:2
                %Down
                tone_down_substage{trig,indu} = length(Restrict(ts(tone_down{trig,indu}), Substages{sub}));
                %Delta
                tone_delta_substage{trig,indu} = length(Restrict(ts(tone_delta{trig,indu}), Substages{sub}));
           end
        end

        %ISI
        tonesuccess_res.tone_down_substage{p,sub} = tone_down_substage;
        tonesuccess_res.tone_delta_substage{p,sub} = tone_delta_substage;
        
        
    end % end substages
    
end

name_substages = NamesSubstages(substages_ind);
%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifSuccessDeltaShamToneSubstage_2.mat tonesuccess_res shamsuccess_res delays substages_ind animals conditions effect_period pre_period

