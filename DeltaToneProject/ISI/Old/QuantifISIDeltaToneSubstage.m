% QuantifISIDeltaToneSubstage
% 23.09.2016 KJ (modified on 23.11.2016)
%
% compute ISI for several conditions and different substage
%   - Basal (n+1, n+2)
%   - DeltaTone, efficient tones (n+1, n+2)
%   - DeltaTone, failed tones (n+1, n+2)
%   - Substages = N1, N2, N3, REM, WAKE
%
%   see QuantifISIDeltaToneSubstage2, QuantifISIDeltaToneSubstage3
%


Dir_basal = PathForExperimentsDeltaWavesTone('Basal');
Dir1=PathForExperimentsDeltaWavesTone('RdmTone');
Dir2=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir_tone = MergePathForExperiment(Dir1,Dir2);
clear Dir1 Dir2


%% params
substages_ind = 1:5; %N1, N2, N3, REM, WAKE
delays = unique(cell2mat(Dir_tone.delay));

%% ISI for Basal
for p=1:length(Dir.path)	
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

    %%ISI
    for sub=substages_ind
        
        basal_res.substage{p,sub} = NamesSubstages{sub};
        delta_substage = Range(Restrict(ts(start_deltas), Substages{sub}));
        down_substage = Range(Restrict(ts(start_down), Substages{sub}));
        
        intv_deltas1 = nan(length(delta_substage));
        intv_deltas2 = nan(length(delta_substage));
        %delta
        for t=1:length(delta_substage)
                next_delta = start_deltas(find(start_deltas>delta_substage(t), 2));
                try
                    intv_deltas1(t) = next_delta(1) - delta_substage(t);
                end
                try
                    intv_deltas2(t) = next_delta(2) - delta_substage(t);
                end
        end
        
        intv_down1 = nan(length(down_substage));
        intv_down2 = nan(length(down_substage));
        %down
        for t=1:length(down_substage)
                next_down = start_down(find(start_down>down_substage(t), 2));
                try
                    intv_down1(t) = next_down(1) - down_substage(t);
                end
                try
                    intv_down2(t) = next_down(2) - down_substage(t);
                end
        end
        
        %res
        basal_res.intv_deltas1{p,sub} = intv_deltas1;
        basal_res.intv_deltas2{p,sub} = intv_deltas2;
        basal_res.intv_down1{p,sub} = intv_down1;
        basal_res.intv_down2{p,sub} = intv_down2;
        
    end
end


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
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);


    %% Tones that induced a down/delta or not, and that were triggered by a true down/delta
    effect_period = 2000; %200ms
    pre_period = 1000; %200ms
    tone_intv_post = intervalSet(Range(ToneEvent), Range(ToneEvent) + effect_period);  % Tone and its window where an effect could be observed
    tone_intv_pre = intervalSet(Range(ToneEvent) - (delay+pre_period), Range(ToneEvent) - (delay-pre_period));  % Tone and its window where an effect could be observed    

    %down
    if ~isempty(start_down)
        induce_down = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_down, [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element
    else
        induce_down = [];
    end
    %delta
    if ~isempty(start_deltas)
        induce_delta = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
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
        gooddown_substage = Range(Restrict(ts(good_tone_down), Substages{sub}));
        baddown_substage = Range(Restrict(ts(bad_tone_down), Substages{sub}));

        intv1_good_tones = nan(length(gooddown_substage),1);
        intv2_good_tones = nan(length(gooddown_substage),1);
        intv3_good_tones = nan(length(gooddown_substage),1);
        for i=1:length(gooddown_substage)
            next_down = start_down(find(start_down>gooddown_substage(i), 3));
            prev_down = start_down(find(start_down<gooddown_substage(i), 1, 'last'));
            try
                intv1_good_tones(i) = next_down(1) - prev_down;
            end
            try
                intv2_good_tones(i) = next_down(2) - prev_down;
            end
            try
                intv3_good_tones(i) = next_down(3) - prev_down;
            end
        end

        intv1_bad_tones = nan(length(baddown_substage),1);
        intv2_bad_tones = nan(length(baddown_substage),1);
        intv3_bad_tones = nan(length(baddown_substage),1);
        for i=1:length(baddown_substage)
            next_down = start_down(find(start_down>baddown_substage(i),3));
            prev_down = start_down(find(start_down<baddown_substage(i), 1, 'last'));
            try
                intv1_bad_tones(i) = next_down(1) - prev_down;
            end
            try
                intv2_bad_tones(i) = next_down(2) - prev_down;
            end
            try
                intv3_bad_tones(i) = next_down(3) - prev_down;
            end
        end

        %Delta
        gooddelta_substage = Range(Restrict(ts(good_tone_delta), Substages{sub}));
        baddelta_substage = Range(Restrict(ts(bad_tone_delta), Substages{sub}));

        intv1_good_tones_delta = nan(length(gooddelta_substage),1);
        intv2_good_tones_delta = nan(length(gooddelta_substage),1);
        intv3_good_tones_delta = nan(length(gooddelta_substage),1);
        for i=1:length(gooddelta_substage)
            next_delta = start_deltas(find(start_deltas>gooddelta_substage(i), 3));
            prev_delta = start_deltas(find(start_deltas<gooddelta_substage(i), 1, 'last'));
            try
                intv1_good_tones_delta(i) = next_delta(1) - prev_delta;
            end
            try
                intv2_good_tones_delta(i) = next_delta(2) - prev_delta;
            end
            try
                intv3_good_tones_delta(i) = next_delta(3) - prev_delta;
            end
        end

        intv1_bad_tones_delta = nan(length(baddelta_substage),1);
        intv2_bad_tones_delta = nan(length(baddelta_substage),1);
        intv3_bad_tones_delta = nan(length(baddelta_substage),1);
        for i=1:length(baddelta_substage)
            next_delta = start_deltas(find(start_deltas>baddelta_substage(i),3));
            prev_delta = start_deltas(find(start_deltas<baddelta_substage(i), 1, 'last'));
            try
                intv1_bad_tones_delta(i) = next_delta(1) - prev_delta;
            end
            try
                intv2_bad_tones_delta(i) = next_delta(2) - prev_delta;
            end
            try
                intv3_bad_tones_delta(i) = next_delta(3) - prev_delta;
            end
        end
        

        deltatone_res.intv1_good_down{p,sub} = intv1_good_tones;
        deltatone_res.intv2_good_down{p,sub} = intv2_good_tones;
        deltatone_res.intv3_good_down{p,sub} = intv3_good_tones;
        deltatone_res.intv1_bad_down{p,sub} = intv1_bad_tones;
        deltatone_res.intv2_bad_down{p,sub} = intv2_bad_tones;
        deltatone_res.intv3_bad_down{p,sub} = intv3_bad_tones;

        deltatone_res.intv1_good_deltas{p,sub} = intv1_good_tones_delta;
        deltatone_res.intv2_good_deltas{p,sub} = intv2_good_tones_delta;
        deltatone_res.intv3_good_deltas{p,sub} = intv3_good_tones_delta;
        deltatone_res.intv1_bad_deltas{p,sub} = intv1_bad_tones_delta;
        deltatone_res.intv2_bad_deltas{p,sub} = intv2_bad_tones_delta;
        deltatone_res.intv3_bad_deltas{p,sub} = intv3_bad_tones_delta;

    end % end substages

end

name_substages = NamesSubstages(substages_ind);
delays = unique([0 cell2mat(Dir_tone.delay)]);
%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifISIDeltaToneSubstage_all.mat -v7.3 basal_res deltatone_res
save QuantifISIDeltaToneSubstage_all.mat -append delays substages_ind 




