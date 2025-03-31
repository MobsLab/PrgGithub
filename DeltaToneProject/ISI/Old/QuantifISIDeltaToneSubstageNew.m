% QuantifISIDeltaToneSubstageNew
% 23.11.2016 KJ
%
% compute ISI for several conditions and different substage
%   - Basal (n+1, n+2)
%   - DeltaTone, efficient tones (n+1, n+2)
%   - DeltaTone, failed tones (n+1, n+2)
%   - Substages = N1, N2, N3, REM, WAKE
%
%   see QuantifISIDeltaToneSubstage2, QuantifISIDeltaToneSubstage3
%


Dir_basal = PathForExperimentsDeltaLongSleepNew('Basal');
Dir1=PathForExperimentsDeltaLongSleepNew('RdmTone');
Dir2=PathForExperimentsDeltaLongSleepNew('DeltaToneAll');
Dir_tone = MergePathForExperiment(Dir1,Dir2);
clear Dir1 Dir2

%% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE, NREM
delays = unique(cell2mat(Dir_tone.delay));
effect_period = 2000; %200ms
pre_period = 1000; %100ms


%% ISI for Basal
for p=1:length(Dir_basal.path)
    
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_basal.path{',num2str(p),'}'')'])
    disp(pwd)
    
    quantif_isi_basal_res.path{p}   = Dir_basal.path{p};
    quantif_isi_basal_res.manipe{p} = Dir_basal.manipe{p};
    quantif_isi_basal_res.name{p}   = Dir_basal.name{p};
    quantif_isi_basal_res.delay{p}  = 0;

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
    
    %% ISI
    for sub=substages_ind
        
        quantif_isi_basal_res.substage{p,sub} = NamesSubstages{sub};
        delta_substage = Range(Restrict(ts(start_deltas), Substages{sub}));
        down_substage = Range(Restrict(ts(start_down), Substages{sub}));
        
        %delta
        for t=1:length(delta_substage)
            for i=1:3
                next_delta = start_deltas(find(start_deltas>delta_substage(t), 3));
                try
                    isi_basal_delta_substage{i}(t) = next_delta(i) - delta_substage(t);
                catch
                    isi_basal_delta_substage{i}(t) = nan;
                end
            end
            
        end
        
        %down
        for t=1:length(down_substage)
            for i=1:3
                next_down = start_down(find(start_down>down_substage(t), 3));
                try
                    isi_basal_down_substage{i}(t) = next_down(i) - down_substage(t);
                catch
                    isi_basal_down_substage{i}(t) = nan;
                end
            end
            
        end
        
        quantif_isi_basal_res.isi_basal_delta_substage{p,sub} = isi_basal_delta_substage;
        quantif_isi_basal_res.isi_basal_down_substage{p,sub} = isi_basal_down_substage;
    end
    
    
    
end


%% ISI for Sham
for p=1:length(Dir_basal.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_basal.path{',num2str(p),'}'')'])
    disp(pwd)
    quantif_isi_sham_res.path{p}    =Dir_basal.path{p};
    quantif_isi_sham_res.manipe{p}  =Dir_basal.manipe{p};
    quantif_isi_sham_res.name{p}    =Dir_basal.name{p};

    %% load
    %shams
    load('ShamSleepEvent.mat', 'SHAMtime')
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
    
    
    for d=1:length(delays)
        delay = delays(d)*1E4; %in 1E-4s
        ShamEvent = ts(Range(SHAMtime) + delay);
        nb_shams = length(ShamEvent);
        
        %% Shams induced a down/delta or not, and that were triggered by a true down/delta
        sham_intv_post = intervalSet(Range(ShamEvent), Range(ShamEvent) + effect_period);  % Sham and its window where an effect could be observed
        sham_intv_pre = intervalSet(Range(ShamEvent) - (delay+pre_period), Range(ShamEvent) - delay);  % Sham and its window where an effect could be observed
        
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
            quantif_isi_sham_res.substage{p,sub,d} = NamesSubstages{sub};

            for trig=1:2
               for indu=1:2
                   %Down
                    sham_down_substage{trig,indu} = Range(Restrict(ts(sham_down{trig,indu}), Substages{sub}));
                    for i=1:3 %isi n+1, n+2 and n+3
                        isi_sham_down_substage{trig,indu,i} = nan(length(sham_down_substage{trig,indu}),1);
                        for t=1:length(sham_down_substage{trig,indu})
                            next_down = start_down(find(start_down>sham_down_substage{trig,indu}(t), 3));
                            prev_down = start_down(find(start_down<sham_down_substage{trig,indu}(t), 1, 'last'));
                            try
                                isi_sham_down_substage{trig,indu,i}(t)= next_down(i) - prev_down;
                            end
                        end
                    end

                    %Delta
                    sham_delta_substage{trig,indu} = Range(Restrict(ts(sham_delta{trig,indu}), Substages{sub}));
                    for i=1:3 %isi n+1, n+2 and n+3
                        isi_sham_delta_substage{trig,indu,i} = nan(length(sham_delta_substage{trig,indu}),1);
                        for t=1:length(sham_delta_substage{trig,indu})
                            next_delta = start_deltas(find(start_deltas>sham_delta_substage{trig,indu}(t), 3));
                            prev_delta = start_deltas(find(start_deltas<sham_delta_substage{trig,indu}(t), 1, 'last'));
                            try
                                isi_sham_delta_substage{trig,indu,i}(t)= next_delta(i) - prev_delta;
                            end
                        end
                    end
               end
            end
        
            %ISI
            quantif_isi_sham_res.isi_sham_down{p,sub,d} = isi_sham_down_substage;
            quantif_isi_sham_res.isi_sham_delta{p,sub,d} = isi_sham_delta_substage;


        end % end substages
    end
end
quantif_isi_sham_res.delay=delays;


%% ISI for DeltaTone
for p=1:length(Dir_tone.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_tone.path{',num2str(p),'}'')'])
    disp(pwd)
    quantif_isi_tone_res.path{p}=Dir_tone.path{p};
    quantif_isi_tone_res.manipe{p}=Dir_tone.manipe{p};
    quantif_isi_tone_res.delay{p}=Dir_tone.delay{p};
    quantif_isi_tone_res.name{p}=Dir_tone.name{p};

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
    tone_intv_pre = intervalSet(Range(ToneEvent) - (delay+pre_period), Range(ToneEvent) - delay);  % Tone and its anterior window     

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
        quantif_isi_tone_res.substage{p,sub} = NamesSubstages{sub};
        
        for trig=1:2
           for indu=1:2
               %Down
                tone_down_substage{trig,indu} = Range(Restrict(ts(tone_down{trig,indu}), Substages{sub}));
                for i=1:3 %isi n+1, n+2 and n+3
                    isi_tone_down_substage{trig,indu,i} = nan(length(tone_down_substage{trig,indu}),1);
                    for t=1:length(tone_down_substage{trig,indu})
                        next_down = start_down(find(start_down>tone_down_substage{trig,indu}(t), 3));
                        prev_down = start_down(find(start_down<tone_down_substage{trig,indu}(t), 1, 'last'));
                        try
                            isi_tone_down_substage{trig,indu,i}(t)= next_down(i) - prev_down;
                        end
                    end
                end
                
                %Delta
                tone_delta_substage{trig,indu} = Range(Restrict(ts(tone_delta{trig,indu}), Substages{sub}));
                for i=1:3 %isi n+1, n+2 and n+3
                    isi_tone_delta_substage{trig,indu,i} = nan(length(tone_delta_substage{trig,indu}),1);
                    for t=1:length(tone_delta_substage{trig,indu})
                        next_delta = start_deltas(find(start_deltas>tone_delta_substage{trig,indu}(t), 3));
                        prev_delta = start_deltas(find(start_deltas<tone_delta_substage{trig,indu}(t), 1, 'last'));
                        try
                            isi_tone_delta_substage{trig,indu,i}(t)= next_delta(i) - prev_delta;
                        end
                    end
                end
           end
        end

        %ISI
        quantif_isi_tone_res.isi_tone_down{p,sub} = isi_tone_down_substage;
        quantif_isi_tone_res.isi_tone_delta{p,sub} = isi_tone_delta_substage;
        
        %quantif_isi_tone_res.isi_tone_down{3,4}{1,1,2}; 
        %quantif_isi_tone_res.isi_tone_down{20,4}{1,1,2};
        %quantif_isi_tone_res.isi_tone_down{20,4}{1,1,1};
        %quantif_isi_tone_res.isi_tone_down{20,4}{1,1,3};
        %
        % In wake and REM, there is no delta, so lots of ISI are the same
        % especially in Rdm : if there are many sounds between two spaced
        % delta waves
 

    end % end substages

end


name_substages = NamesSubstages(substages_ind);
delays = unique([0 cell2mat(Dir_tone.delay)]);
%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifISIDeltaToneSubstage_all2.mat -v7.3 quantif_isi_basal_res quantif_isi_sham_res quantif_isi_tone_res
save QuantifISIDeltaToneSubstage_all2.mat -append delays substages_ind effect_period pre_period



