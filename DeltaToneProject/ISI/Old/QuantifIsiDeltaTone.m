% QuantifIsiDeltaTone
% 07.09.2016 KJ (re-edited on 22.09.2016)
%
% compute ISI for several conditions
%   - Basal (n+1, n+2)
%   - DeltaTone, efficient tones (n+1, n+2)
%   - DeltaTone, failed tones (n+1, n+2)
%
% Info
%   Data are collected and saved in basal_res and deltatone_res 
%   (saved in /home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Data/QuantifIsiDeltaTone.mat )    
%

Dir=PathForExperimentsDeltaISI;


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
        start_down = Start(Down);
        %Delta
        load DeltaPFCx DeltaOffline
        start_deltas = Start(DeltaOffline);
        %Ripples
        load newRipHPC Ripples_tmp
        
        %% ISI
        intv_deltas = diff(start_deltas);
        basal_res.intv_deltas1{p} = intv_deltas;
        basal_res.intv_deltas2{p} = intv_deltas(1:end-1)+intv_deltas(2:end);
        
        intv_down = diff(start_down);
        basal_res.intv_down1{p} = intv_down;
        basal_res.intv_down2{p} = intv_down(1:end-1)+intv_down(2:end);
        
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
        
        
        %% Tones that induces a down or not
        effect_period = 2000; %200ms
        tone_intv = intervalSet(Range(ToneEvent), Range(ToneEvent) + effect_period);  % Tone and its window where an effect could be observed
        induce_down = zeros(nb_tones, 1);

        [~,interval,~] = InIntervals(start_down, [Start(tone_intv) End(tone_intv)]);
        tone_success = unique(interval);
        induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element

        tones = Range(ToneEvent);
        good_tones = tones(induce_down==1);
        bad_tones = tones(induce_down==0);

        intv1_good_tones = zeros(length(good_tones),1);
        intv2_good_tones = zeros(length(good_tones),1);
        for i=1:length(good_tones)
            next_down = start_down(find(start_down>good_tones(i), 2));
            prev_down = start_down(find(start_down<good_tones(i), 1, 'last'));
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

        intv1_bad_tones = zeros(length(bad_tones),1);
        intv2_bad_tones = zeros(length(bad_tones),1);
        for i=1:length(bad_tones)
            next_down = start_down(find(start_down>bad_tones(i),2));
            prev_down = start_down(find(start_down<bad_tones(i), 1, 'last'));
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

        
        %% Same thing with delta
        induce_delta = zeros(nb_tones, 1);

        [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv) End(tone_intv)]);
        tone_success = unique(interval);
        induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element

        tones = Range(ToneEvent);
        good_tones = tones(induce_delta==1);
        bad_tones = tones(induce_delta==0);

        intv1_good_tones_delta = zeros(length(good_tones),1);
        intv2_good_tones_delta = zeros(length(good_tones),1);
        for i=1:length(good_tones)
            next_delta = start_deltas(find(start_deltas>good_tones(i), 2));
            prev_delta = start_deltas(find(start_deltas<good_tones(i), 1, 'last'));
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

        intv1_bad_tones_delta = zeros(length(bad_tones),1);
        intv2_bad_tones_delta = zeros(length(bad_tones),1);
        for i=1:length(bad_tones)
            next_delta = start_deltas(find(start_deltas>bad_tones(i),2));
            prev_delta = start_deltas(find(start_deltas<bad_tones(i), 1, 'last'));
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
        
        
        %% ISI
        deltatone_res.intv1_good_down{p} = intv1_good_tones;
        deltatone_res.intv2_good_down{p} = intv2_good_tones;
        deltatone_res.intv1_bad_down{p} = intv1_bad_tones;
        deltatone_res.intv2_bad_down{p} = intv2_bad_tones;
        
        deltatone_res.intv1_good_deltas{p} = intv1_good_tones_delta;
        deltatone_res.intv2_good_deltas{p} = intv2_good_tones_delta;
        deltatone_res.intv1_bad_deltas{p} = intv1_bad_tones_delta;
        deltatone_res.intv2_bad_deltas{p} = intv2_bad_tones_delta;

    end
end

delays = unique(cell2mat(Dir.delay));
cd([FolderProjetDelta 'Data/'])
save QuantifISIDeltaTone.mat basal_res deltatone_res delays















