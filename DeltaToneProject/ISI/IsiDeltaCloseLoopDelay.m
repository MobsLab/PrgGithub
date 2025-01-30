% IsiDeltaCloseLoopDelay
% 11.07.2019 KJ
%
% compute ISI for different delays
%   - Basal (n+1, n+2, n+3)
%   - DeltaTone, efficient tones (n+1, n+2, n+3)
%   - DeltaTone, failed tones (n+1, n+2, n+3)
%   - Substages = N1, N2, N3, REM, WAKE, NREM
%
%   see QuantifISIDeltaToneSubstageNew
%

clear

Dir_basal = PathForExperimentsDeltaCloseLoop('Basal');
Dir_tone  = PathForExperimentsDeltaCloseLoop('AllTone');


%% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE, NREM
NamesSubstages = {'N1','N2','N3','REM','Wake','NREM'};
delays = unique(cell2mat(Dir_tone.delay));
effect_period = 2000; %200ms
pre_period = 1000; %100ms


%% ISI for Basal
for p=1:length(Dir_basal.path)
    
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_basal.path{',num2str(p),'}'')'])
    disp(pwd)    
    
    isi_basal_res.path{p}   = Dir_basal.path{p};
    isi_basal_res.manipe{p} = Dir_basal.manipe{p};
    isi_basal_res.date{p}   = Dir_basal.date{p};
    isi_basal_res.name{p}   = Dir_basal.name{p};
    isi_basal_res.delay{p}  = 0;

    %% load
    %Delta waves
    delta_PFCx = GetDeltaWaves;
    start_deltas = Start(delta_PFCx);
    end_deltas = End(delta_PFCx);
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    NREM = or(N1,or(N2,N3));
    Substages = {N1,N2,N3,REM,Wake,NREM};
    

    %% ISI
    for sub=substages_ind
        
        isi_basal_res.substage{p,sub} = NamesSubstages{sub};
        delta_substage  = Range(Restrict(ts(start_deltas), Substages{sub}));
        
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
        %save
        isi_basal_res.isi_basal_delta_substage{p,sub} = isi_basal_delta_substage;
        
    end
    
    
    
end



%% ISI for Sham
for p=1:length(Dir_basal.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_basal.path{',num2str(p),'}'')'])
    disp(pwd)
    isi_sham_res.path{p}    = Dir_basal.path{p};
    isi_sham_res.manipe{p}  = Dir_basal.manipe{p};
    isi_sham_res.date{p}    = Dir_basal.date{p};
    isi_sham_res.name{p}    = Dir_basal.name{p};
    isi_sham_res.delay{p}   = 0;

    %% load
    %shams
    load('ShamSleepEvent.mat', 'SHAMtime')
    %Delta waves
    delta_PFCx = GetDeltaWaves;
    start_deltas = Start(delta_PFCx);
    end_deltas = End(delta_PFCx);
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    NREM = or(N1,or(N2,N3));
    Substages = {N1,N2,N3,REM,Wake,NREM};
    
    for d=1:length(delays)
        delay = delays(d)*1E4; %in 1E-4s
        ShamEvent = ts(Range(SHAMtime) + delay);
        nb_shams = length(ShamEvent);
        
        %% Shams induced a delta or not, and that were triggered by a true delta
        sham_intv_post  = intervalSet(Range(ShamEvent), Range(ShamEvent) + effect_period);  % Sham and its window where an effect could be observed
        sham_intv_pre   = intervalSet(Range(ShamEvent) - (delay+pre_period), Range(ShamEvent) - delay);  % Sham and its window where an effect could be observed
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
        % sham_delta{trig,indu} where: 
        % - trig=2 if sham triggered by a delta, 1 otherwise  
        % - indu=2 if sham induced by a delta, 1 otherwise
        sham_delta{1,1} = shams(delta_triggered==0 & induce_delta==0);
        sham_delta{1,2} = shams(delta_triggered==0 & induce_delta==1);
        sham_delta{2,1} = shams(delta_triggered==1 & induce_delta==0);
        sham_delta{2,2} = shams(delta_triggered==1 & induce_delta==1);
    
    
        %% Substages ISI
        for sub=substages_ind
            isi_sham_res.substage{p,sub,d} = NamesSubstages{sub};

            for trig=1:2
               for indu=1:2
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
            isi_sham_res.isi_sham_delta{p,sub,d} = isi_sham_delta_substage;
        end % end substages
        
    end
end
isi_sham_res.delay=delays;




%% ISI for DeltaTone
for p=1:length(Dir_tone.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir_tone.path{',num2str(p),'}'')'])
    disp(pwd)
    
    
    isi_tone_res.path{p}    = Dir_tone.path{p};
    isi_tone_res.manipe{p}  = Dir_tone.manipe{p};
    isi_tone_res.date{p}    = Dir_tone.date{p};
    isi_tone_res.name{p}    = Dir_tone.name{p};
    isi_tone_res.delay{p}   = 0;
    

    %% load
    %tones
    load('behavResources.mat', 'ToneEvent')
    nb_tones = length(ToneEvent);
    %Delta waves
    delta_PFCx = GetDeltaWaves;
    start_deltas = Start(delta_PFCx);
    end_deltas = End(delta_PFCx);
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    NREM = or(N1,or(N2,N3));
    Substages = {N1,N2,N3,REM,Wake,NREM};


    %% Tones that induced a delta or not, and that were triggered by a true delta
    tone_intv_post = intervalSet(Range(ToneEvent), Range(ToneEvent) + effect_period);  % Tone and its window where an effect could be observed
    tone_intv_pre = intervalSet(Range(ToneEvent) - (delay+pre_period), Range(ToneEvent) - delay);  % Tone and its anterior window     

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
    % tone_delta{trig,indu} where: 
    % - trig=2 if tone triggered by a delta, 1 otherwise  
    % - indu=2 if tone induced by a delta, 1 otherwise
    tone_delta{1,1} = tones(delta_triggered==0 & induce_delta==0);
    tone_delta{1,2} = tones(delta_triggered==0 & induce_delta==1);
    tone_delta{2,1} = tones(delta_triggered==1 & induce_delta==0);
    tone_delta{2,2} = tones(delta_triggered==1 & induce_delta==1);
    
    
    %% Substages ISI
    for sub=substages_ind
        isi_tone_res.substage{p,sub} = NamesSubstages{sub};
        
        for trig=1:2
           for indu=1:2
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
        isi_tone_res.isi_tone_delta{p,sub} = isi_tone_delta_substage;
        %
        % In wake and REM, there is no delta, so lots of ISI are the same
        % especially in Rdm : if there are many sounds between two spaced
        % delta waves
 

    end % end substages

end


name_substages = NamesSubstages(substages_ind);
delays = unique([0 cell2mat(Dir_tone.delay)]);

%saving data
cd(FolderDeltaDataKJ)
save IsiDeltaCloseLoopDelay.mat -v7.3 isi_basal_res isi_sham_res isi_tone_res
save IsiDeltaCloseLoopDelay.mat -append delays substages_ind effect_period pre_period



