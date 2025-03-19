% QuantifISIDeltaToneSubstage
% 23.09.2016 KJ
%
% compute ISI for several conditions and different substage
%   - Basal (n+1, n+2)
%   - DeltaTone, efficient tones (n+1, n+2)
%   - DeltaTone, failed tones (n+1, n+2)
%   - Substages = N1, N2, N3, REM, WAKE
%


Dir=PathForExperimentsDeltaISI;
%% params
substages_ind = 1:5; %N1, N2, N3, REM, WAKE

%% ISI for Basal
for p=1:length(Dir.path)
    if strcmpi(Dir.condition{p},'Basal')
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        basal_res.path{p}=Dir.path{p};
        basal_res.condition{p}=Dir.condition{p};
        basal_res.delay{p}=Dir.delay{p};
        basal_res.title{p}=Dir.title{p};
        
        %% load
        load StateEpochSB SWSEpoch Wake
        %Down states
        load newDownState Down
        %Delta
        load DeltaPFCx DeltaOffline
        %Ripples
        load newRipHPC Ripples_tmp
        %Substages
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
        
        %%ISI
        for i=substages_ind
            basal_res.substage{p,i} = NamesSubstages{i};
            
            delta_substage = Range(Restrict(ts(Start(DeltaOffline)), Substages{i}));
            intv_deltas = diff(delta_substage);
            basal_res.intv_deltas1{p,i} = intv_deltas;
            basal_res.intv_deltas2{p,i} = intv_deltas(1:end-1) + intv_deltas(2:end);
            
            down_substage = Range(Restrict(ts(Start(Down)), Substages{i}));
            intv_down = diff(down_substage);
            basal_res.intv_down1{p,i} = intv_down;
            basal_res.intv_down2{p,i} = intv_down(1:end-1) + intv_down(2:end);

        end
        
        
        
    end
end


%% ISI for DeltaTone
for p=1:length(Dir.path)
    if strcmpi(Dir.condition{p},'DeltaTone')
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        deltatone_res.path{p}=Dir.path{p};
        deltatone_res.condition{p}=Dir.condition{p};
        deltatone_res.delay{p}=Dir.delay{p};
        deltatone_res.title{p}=Dir.title{p};
        
        %% load
        load StateEpochSB SWSEpoch Wake
        %tones
        load('DeltaSleepEvent.mat', 'TONEtime2')
        delay = Dir.delay{p}*1E4; %in 1E-4s
        ToneEvent = Restrict(ts(TONEtime2 + delay),SWSEpoch);
        nb_tones = length(ToneEvent);
        %Down states
        load newDownState Down
        start_down = Start(Down);
        %Delta
        load DeltaPFCx DeltaOffline
        start_deltas = Start(DeltaOffline);
        %Ripples
        load newRipHPC Ripples_tmp
        %Substages
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
        
        
        %% Tones that induces a down or not, delta or not
        effect_period = 2000; %200ms
        tone_intv = intervalSet(Range(ToneEvent), Range(ToneEvent) + effect_period);  % Tone and its window where an effect could be observed
        
        %down
        induce_down = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_down, [Start(tone_intv) End(tone_intv)]);
        tone_success = unique(interval);
        induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element
        %delta
        induce_delta = zeros(nb_tones, 1);
        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv) End(tone_intv)]);
        tone_success = unique(interval);
        induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
        
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
            
            intv1_good_tones = zeros(length(gooddown_substage),1);
            intv2_good_tones = zeros(length(gooddown_substage),1);
            for i=1:length(gooddown_substage)
                next_down = start_down(find(start_down>gooddown_substage(i), 2));
                prev_down = start_down(find(start_down<gooddown_substage(i), 1, 'last'));
                try
                    intv1_good_tones(i) = next_down(1) - prev_down;
                catch
                    intv1_good_tones(i) = 0;
                end
                try
                    intv2_good_tones(i) = next_down(2) - prev_down;
                catch
                    intv2_good_tones(i) = 0;
                end
            end
            
            intv1_bad_tones = zeros(length(baddown_substage),1);
            intv2_bad_tones = zeros(length(baddown_substage),1);
            for i=1:length(baddown_substage)
                next_down = start_down(find(start_down>baddown_substage(i),2));
                prev_down = start_down(find(start_down<baddown_substage(i), 1, 'last'));
                try
                    intv1_bad_tones(i) = next_down(1) - prev_down;
                catch
                    intv1_bad_tones(i) = 0;
                end
                try
                    intv2_bad_tones(i) = next_down(2) - prev_down;
                catch
                    intv2_bad_tones(i) = 0;
                end
            end
            
            %Delta
            gooddelta_substage = Range(Restrict(ts(good_tone_delta), Substages{sub}));
            baddelta_substage = Range(Restrict(ts(bad_tone_delta), Substages{sub}));

            intv1_good_tones_delta = zeros(length(gooddelta_substage),1);
            intv2_good_tones_delta = zeros(length(gooddelta_substage),1);
            for i=1:length(gooddelta_substage)
                next_delta = start_deltas(find(start_deltas>gooddelta_substage(i), 2));
                prev_delta = start_deltas(find(start_deltas<gooddelta_substage(i), 1, 'last'));
                try
                    intv1_good_tones_delta(i) = next_delta(1) - prev_delta;
                catch
                    intv1_good_tones_delta(i) = 0;
                end
                try
                    intv2_good_tones_delta(i) = next_delta(2) - prev_delta;
                catch
                    intv2_good_tones_delta(i) = 0;
                end
            end

            intv1_bad_tones_delta = zeros(length(baddelta_substage),1);
            intv2_bad_tones_delta = zeros(length(baddelta_substage),1);
            for i=1:length(baddelta_substage)
                next_delta = start_deltas(find(start_deltas>baddelta_substage(i),2));
                prev_delta = start_deltas(find(start_deltas<baddelta_substage(i), 1, 'last'));
                try
                    intv1_bad_tones_delta(i) = next_delta(1) - prev_delta;
                catch
                    intv1_bad_tones_delta(i) = 0;
                end
                try
                    intv2_bad_tones_delta(i) = next_delta(2) - prev_delta;
                catch
                    intv2_bad_tones_delta(i) = 0;
                end
            end
            
            %ISI
            deltatone_res.intv1_good_down{p,sub} = intv1_good_tones;
            deltatone_res.intv2_good_down{p,sub} = intv2_good_tones;
            deltatone_res.intv1_bad_down{p,sub} = intv1_bad_tones;
            deltatone_res.intv2_bad_down{p,sub} = intv2_bad_tones;

            deltatone_res.intv1_good_deltas{p,sub} = intv1_good_tones_delta;
            deltatone_res.intv2_good_deltas{p,sub} = intv2_good_tones_delta;
            deltatone_res.intv1_bad_deltas{p,sub} = intv1_bad_tones_delta;
            deltatone_res.intv2_bad_deltas{p,sub} = intv2_bad_tones_delta;
            
        end % end substages

    end
end

name_substages = NamesSubstages(substages_ind);
delays = unique(cell2mat(Dir.delay));
%saving data
save QuantifISIDeltaToneSubstage2.mat basal_res deltatone_res delays substages_ind 





